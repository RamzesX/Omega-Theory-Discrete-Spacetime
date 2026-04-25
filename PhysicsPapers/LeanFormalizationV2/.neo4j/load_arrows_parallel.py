#!/usr/bin/env python3
"""Parallel arrow loader — N worker threads × independent sessions + batched UNWIND.

Usage: python3 load_arrows_parallel.py [JSONL_PATH] [--workers N] [--batch 2000]

Optimizations vs sequential load_arrows_from_env_v2.py:
- 16 worker threads, each with own Neo4j session → 16× parallelism
- Larger batch (2000 vs 1000) — fewer round trips
- Pre-bucketed by relation type (reduces lock contention — different rels rarely conflict)
- Skip record filter: --only-cycle N loads only edges from nodes with t.cycle=N

Idempotent via apoc.merge.relationship.

**2026-04-25 fix (cycle 55 close):** identityProps was `{source: 'lean_env_v1'}`,
which only matches existing edges that already carried that property. Older
edges lacked it → MERGE failed to dedup → every refresh added a parallel
edge. ~10M+ redundant edges accumulated across the project's history.
Fix: identityProps `{}` (match purely on src/tgt/type — pure-topology MERGE).
Plus inline post-load dedup for whichever rel-types were just touched.
"""
import json, os, sys, time, argparse
from pathlib import Path
from neo4j import GraphDatabase
from concurrent.futures import ThreadPoolExecutor, as_completed

URI = 'bolt://localhost:7687'
AUTH = ('neo4j', 'omegatheory2026')

REL_FIELDS = {
    'applies': 'APPLIES', 'unfolds': 'UNFOLDS', 'assumes': 'ASSUMES',
    'reduces_to': 'REDUCES_TO', 'elaborates_as': 'ELABORATES_AS',
    'extends_': 'EXTENDS', 'instantiates': 'INSTANTIATES',
    'has_type': 'HAS_TYPE', 'constrained_by': 'CONSTRAINED_BY',
    'parametrizes_types': 'PARAMETRIZES_TYPES',
    'parametrizes_levels': 'PARAMETRIZES_LEVELS',
}

# IDENTITY PROPS = `{}` so MERGE matches purely on (src, tgt, type) topology.
# Earlier `{source: 'lean_env_v1'}` matched only edges with that property,
# letting older edges (created before the source convention) duplicate
# silently every refresh.
LOAD_QUERY = '''
UNWIND $batch AS e
CALL {
  WITH e
  OPTIONAL MATCH (s:Theorem {name: e.src})
  OPTIONAL MATCH (d:Definition {name: e.src}) WHERE s IS NULL
  OPTIONAL MATCH (a:Axiom {name: e.src}) WHERE s IS NULL AND d IS NULL
  OPTIONAL MATCH (f:LeanFile {module: e.src}) WHERE s IS NULL AND d IS NULL AND a IS NULL
  WITH e, coalesce(s, d, a, f) AS src WHERE src IS NOT NULL
  OPTIONAL MATCH (ts:Theorem {name: e.tgt})
  OPTIONAL MATCH (td:Definition {name: e.tgt}) WHERE ts IS NULL
  OPTIONAL MATCH (ta:Axiom {name: e.tgt}) WHERE ts IS NULL AND td IS NULL
  OPTIONAL MATCH (tf:LeanFile {module: e.tgt}) WHERE ts IS NULL AND td IS NULL AND ta IS NULL
  WITH e, src, coalesce(ts, td, ta, tf) AS tgt WHERE tgt IS NOT NULL
  CALL apoc.merge.relationship(
    src, e.rel,
    {},                                                   // identity = src+type+tgt only
    {source: 'lean_env_v1', env_version: 'parallel_v2',  // onCreate
     created_at: datetime()},
    tgt, {last_seen_at: datetime(), source: 'lean_env_v1'}  // onMatch refresh
  ) YIELD rel
  RETURN rel
}
RETURN count(rel) AS merged
'''


def dedup_relation_types(driver, rel_types: list[str], batch_size: int = 50000) -> dict:
    """Post-load cleanup: for each (src, tgt, type) triple with parallel edges,
    keep one and delete the rest. Idempotent — runs to fixed point.

    Uses APOC iterate so a single 1M-edge clean fits in 50k-edge transactions.
    """
    print(f'[dedup] cleaning legacy duplicates for {len(rel_types)} rel types', flush=True)
    out: list[dict] = []
    with driver.session() as s:
        for rt in rel_types:
            # Cypher injects the rel-type via string interpolation (validated
            # by the REL_FIELDS map; not user input).
            cypher = (
                f"CALL apoc.periodic.iterate("
                f"  'MATCH (a)-[r:{rt}]->(b) WITH a, b, collect(r) AS rels "
                f"   WHERE size(rels) > 1 UNWIND rels[1..] AS dup RETURN dup', "
                f"  'DELETE dup', "
                f"  {{batchSize: {batch_size}, parallel: false, retries: 2}})"
                f" YIELD batches, total, errorMessages, timeTaken "
                f"RETURN batches, total, errorMessages, timeTaken"
            )
            t0 = time.monotonic()
            rec = s.run(cypher).single()
            elapsed = time.monotonic() - t0
            n_removed = rec["total"] if rec else 0
            errs = rec["errorMessages"] if rec else {}
            out.append({"rel": rt, "duplicates_removed": n_removed,
                        "elapsed_s": round(elapsed, 1),
                        "errors": dict(errs) if errs else {}})
            if n_removed:
                print(f'  {rt:<22} removed {n_removed} duplicates ({elapsed:.1f}s)',
                      flush=True)
    total_removed = sum(r["duplicates_removed"] for r in out)
    print(f'[dedup] done — {total_removed} duplicate edges removed', flush=True)
    return {"per_rel": out, "total_removed": total_removed}


def stream_edges(jsonl_path):
    # 2026-04-24: after DumpArrows.lean fix (module-based Mathlib detection),
    # dump size grew 17MB → 105MB. Some records contain extremely long name
    # arrays. json.loads can hit pathological lines. We now skip+log bad lines
    # instead of crashing the whole load.
    skipped = 0
    with open(jsonl_path) as f:
        for lineno, line in enumerate(f, start=1):
            try:
                r = json.loads(line)
            except json.JSONDecodeError as e:
                skipped += 1
                if skipped <= 5:
                    print(f'  [stream_edges] line {lineno}: JSONDecodeError {e.msg} at col {e.colno}; skipping',
                          file=sys.stderr)
                continue
            if r.get('kind') == 'module':
                src = r.get('decl')
                for tgt in (r.get('imports') or []):
                    if src and tgt:
                        yield src, tgt, 'IMPORTS'
            else:
                src = r.get('decl')
                if not src:
                    continue
                for field, rel in REL_FIELDS.items():
                    v = r.get(field)
                    if not v:
                        continue
                    if isinstance(v, str):
                        yield src, v, rel
                    elif isinstance(v, list):
                        for tgt in v:
                            if tgt:
                                yield src, tgt, rel


def worker(driver, batch_id, batch):
    """Run one batch. Each call gets its own session to avoid contention on a single session.
    Retries on TransientError (deadlocks) with exponential backoff + jitter, up to 10 attempts.
    With shard-by-source partitioning the deadlock rate is ~0, but we keep the retry as a belt.
    """
    import random
    for attempt in range(10):
        try:
            with driver.session() as session:
                res = session.run(LOAD_QUERY, batch=batch).single()
                return batch_id, res['merged'], len(batch)
        except Exception as e:
            msg = str(e)
            if ('DeadlockDetected' in msg or 'TransientError' in msg) and attempt < 9:
                sleep_s = min(8.0, 0.25 * (2 ** attempt)) + random.uniform(0, 0.5)
                time.sleep(sleep_s)
                continue
            raise


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('jsonl', nargs='?',
                        default=str(Path.home() / 'lean-v2/.neo4j/arrows_from_env_v2.jsonl'))
    parser.add_argument('--workers', type=int, default=16)
    parser.add_argument('--batch', type=int, default=2000)
    parser.add_argument('--only-rel', type=str, default=None,
                        help='Filter to one relation type (e.g., APPLIES)')
    args = parser.parse_args()

    driver = GraphDatabase.driver(URI, auth=AUTH, max_connection_pool_size=args.workers + 4)
    print(f'[parallel-arrows] reading {args.jsonl}')
    print(f'[parallel-arrows] workers={args.workers} batch={args.batch}')

    # Load all edges into memory, SHARD BY SOURCE NODE HASH.
    # Each worker sees a disjoint set of source nodes -> no two workers write
    # relationships to/from the same node concurrently -> zero MERGE deadlock risk.
    # (The prior scheme bucketed by relation type, which did NOT isolate source-node
    # locks: two different rel-type batches could still touch the same source node.)
    import hashlib
    N = args.workers
    shards = [[] for _ in range(N)]
    total_edges = 0
    rel_counts = {}
    for src, tgt, rel in stream_edges(args.jsonl):
        if args.only_rel and rel != args.only_rel:
            continue
        shard_id = int(hashlib.md5(src.encode('utf-8')).hexdigest(), 16) % N
        shards[shard_id].append({'src': src, 'tgt': tgt, 'rel': rel})
        rel_counts[rel] = rel_counts.get(rel, 0) + 1
        total_edges += 1
    print(f'[parallel-arrows] {total_edges} edges, {len(rel_counts)} relation types')
    for r, n in sorted(rel_counts.items(), key=lambda x: -x[1]):
        print(f'  {r:<22} {n}')
    shard_sizes = [len(s) for s in shards]
    print(f'[parallel-arrows] shard sizes (by source hash, {N} shards): '
          f'min={min(shard_sizes)} max={max(shard_sizes)} mean={sum(shard_sizes)//N}')

    # Within each shard, chunk into batches. Batches from the same shard go to
    # the SAME worker so the source-node isolation invariant is preserved.
    batches = []  # list of (worker_id, batch)
    for shard_id, shard in enumerate(shards):
        for i in range(0, len(shard), args.batch):
            batches.append((shard_id, shard[i:i + args.batch]))
    print(f'[parallel-arrows] {len(batches)} batches queued '
          f'(each pinned to its source-hash shard)')

    # Group batches by shard -> one worker drains each shard sequentially.
    # Shard-to-worker pinning preserves the source-node isolation invariant:
    # only one thread ever writes relationships to/from a given source node,
    # so MERGE cannot deadlock on NODE_RELATIONSHIP_GROUP locks.
    shard_batches = [[] for _ in range(args.workers)]
    for shard_id, batch in batches:
        shard_batches[shard_id].append(batch)

    start = time.time()
    state = {'merged_total': 0, 'processed': 0}
    state_lock = __import__('threading').Lock()
    total_batches = len(batches)

    def drain_shard(shard_id, batch_list):
        """One thread: process all batches for one shard in sequence."""
        local_merged = 0
        for b in batch_list:
            _bid, merged, _n = worker(driver, shard_id, b)
            local_merged += merged
            with state_lock:
                state['merged_total'] += merged
                state['processed'] += 1
                if state['processed'] % 10 == 0:
                    rate = state['merged_total'] / max(time.time() - start, 0.01)
                    pct = 100.0 * state['processed'] / total_batches
                    print(f"  {state['processed']}/{total_batches} batches "
                          f"({pct:.1f}%)  merged={state['merged_total']}  {rate:.0f} edges/s",
                          flush=True)
        return shard_id, local_merged

    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = [pool.submit(drain_shard, sid, batch_list)
                   for sid, batch_list in enumerate(shard_batches) if batch_list]
        for fut in as_completed(futures):
            fut.result()  # re-raise if any shard failed terminally
    merged_total = state['merged_total']

    elapsed = time.time() - start
    rate_final = merged_total / max(elapsed, 0.01)
    print(f'\n[parallel-arrows] done. merged={merged_total}/{total_edges} in {elapsed:.1f}s ({rate_final:.0f} edges/s)')

    # ── Inline post-load dedup ───────────────────────────────────────────────
    # Cleans up legacy duplicates introduced by older loader versions.
    # No-op on a fresh-from-scratch graph; on a graph with accumulated
    # duplicates (the cycle-55 finding), it removes them in batches and
    # converges to fixed point.
    rel_types_touched = sorted(set(rel_counts.keys()))
    dedup_result = dedup_relation_types(driver, rel_types_touched, batch_size=50000)
    duplicates_removed = dedup_result["total_removed"]

    with driver.session() as s:
        s.run('''
            MERGE (m:MetaprogramScript {name: 'ParallelLoadArrowsV1'})
            SET m.namespace = 'OmegaTheoryV2',
                m.kind = 'python_loader_parallel',
                m.workers = $w, m.batch_size = $bs,
                m.input_jsonl = $jsonl,
                m.jsonl_edges_total = $total,
                m.edges_merged_into_graph = $merged,
                m.duplicates_removed_post_load = $dups,
                m.elapsed_seconds = $elapsed,
                m.edges_per_second = $rate,
                m.created_at = datetime()
        ''', w=args.workers, bs=args.batch, jsonl=args.jsonl,
             total=total_edges, merged=merged_total,
             dups=duplicates_removed,
             elapsed=int(elapsed), rate=int(rate_final))

    driver.close()


if __name__ == '__main__':
    main()
