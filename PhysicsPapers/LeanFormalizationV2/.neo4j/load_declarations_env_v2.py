#!/usr/bin/env python3
"""Delta-load declarations into Neo4j (MERGE on name).
Non-destructive: only SETs fields if env_dumped_at IS NULL or older than new dump.

Uses per-record implicit transactions to avoid deadlocks with concurrent
long-running arrows loader. Slow but safe.

DEFAULT_JSONL prefers `declarations_from_env_jobgraph.jsonl` (the fresh
output from `lake exe dump_decls`); falls back to the legacy
`declarations_from_env_v2.jsonl` symlink for backward compatibility.

Bug 2026-04-27: legacy `_v2.jsonl` was a stale symlink to cycle50,
silently bypassing fresh dumps. Default switched to `_jobgraph.jsonl`
to read the real output of dump_decls.

Author: Rasalhague (α Ophiuchi), 2026-04-20; updated 2026-04-27.
"""
import argparse, json, time, sys
from pathlib import Path
from neo4j import GraphDatabase


def _default_jsonl() -> Path:
    """Pick the freshest declarations dump.

    Prefer `_jobgraph.jsonl` (the `lake exe dump_decls --out` output).
    Fall back to `_v2.jsonl` for backward-compat with older flows.
    """
    base = Path.home() / 'lean-v2/.neo4j'
    primary = base / 'declarations_from_env_jobgraph.jsonl'
    legacy = base / 'declarations_from_env_v2.jsonl'
    if primary.exists() and not primary.is_symlink():
        return primary
    return legacy


DEFAULT_JSONL = _default_jsonl()
URI = 'bolt://localhost:7687'
AUTH = ('neo4j', 'omegatheory2026')


def make_query(label):
    """Returns a MERGE/SET query for the given label."""
    extra_for_def = "    n.value               = $value_pretty," if label == 'Definition' else ""
    return f'''
MERGE (n:{label} {{namespace: 'OmegaTheoryV2', name: $name}})
ON CREATE SET n.created_at = datetime()
WITH n WHERE n.env_dumped_at IS NULL OR n.env_dumped_at < datetime($cutoff)
SET n.signature           = $type_pretty,
    n.proof_body          = $value_pretty,
{extra_for_def}
    n.docstring           = $docstring,
    n.file                = $file,
    n.module              = $module,
    n.source_span         = [$line_start, $line_end, $col_start, $col_end],
    n.kind                = $kind,
    n.declaration_type    = $kind,
    n.is_private          = $is_private,
    n.universe_params     = $universe_params,
    n.num_universe_params = $num_universe_params,
    n.source              = 'lean_env_v1',
    n.env_dumped_at       = datetime()
RETURN count(n) AS n
'''


QUERIES = {
    'theorem':   make_query('Theorem'),
    'axiom':     make_query('Axiom'),
    'def':       make_query('Definition'),
    'ctor':      make_query('Definition'),
    'inductive': make_query('Definition'),
    'opaque':    make_query('Definition'),
    'quot':      make_query('Definition'),
    'structure': make_query('Definition'),
    'instance':  make_query('Definition'),
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', '-i', type=Path, default=DEFAULT_JSONL,
                        help='JSONL dump file (default: declarations_from_env_v2.jsonl)')
    args = parser.parse_args()
    jsonl_path = args.input
    if not jsonl_path.exists():
        print(f'[delta-load-decls] ERROR: {jsonl_path} does not exist', file=sys.stderr)
        sys.exit(1)

    driver = GraphDatabase.driver(URI, auth=AUTH)
    records = []
    with open(jsonl_path) as f:
        for line in f:
            records.append(json.loads(line))
    print(f'[delta-load-decls] {len(records)} records from {jsonl_path.name}')

    with driver.session() as s:
        pre = s.run('''
          MATCH (n {namespace: 'OmegaTheoryV2'})
          WHERE n:Theorem OR n:Definition OR n:Axiom
          RETURN labels(n)[0] AS lbl, count(n) AS c
        ''').data()
    pre_map = {r['lbl']: r['c'] for r in pre}
    print(f'[delta-load-decls] PRE: {pre_map}')
    sys.stdout.flush()

    cutoff_iso = time.strftime('%Y-%m-%dT%H:%M:%S')
    print(f'[delta-load-decls] cutoff = {cutoff_iso}')

    start = time.time()
    updated = 0
    errors = 0
    skipped_kind = 0

    def run_record(s, r):
        k = r.get('kind', 'def')
        q = QUERIES.get(k)
        if q is None:
            return None
        params = {
            'name': r['name'],
            'type_pretty': r.get('type_pretty'),
            'value_pretty': r.get('value_pretty'),
            'docstring': r.get('docstring'),
            'file': r.get('file'),
            'module': r.get('module'),
            'line_start': r.get('line_start'),
            'line_end': r.get('line_end'),
            'col_start': r.get('col_start'),
            'col_end': r.get('col_end'),
            'kind': k,
            'is_private': r.get('is_private'),
            'universe_params': r.get('universe_params'),
            'num_universe_params': r.get('num_universe_params'),
            'cutoff': cutoff_iso,
        }
        for attempt in range(5):
            try:
                return s.run(q, **params).single()['n']
            except Exception as e:
                if 'DeadlockDetected' in str(e) and attempt < 4:
                    time.sleep(1 + attempt)
                    continue
                raise

    # Skipping records whose decl already has the latest env_dumped_at
    # (loaded by Schedar 2026-04-19 ~ 23:30). Only records whose name did
    # NOT exist in v1 should be updated.
    BATCH = 200
    BATCH_QUERY = '''
UNWIND $records AS r
WITH r,
     CASE r.kind
       WHEN 'theorem'   THEN 'Theorem'
       WHEN 'axiom'     THEN 'Axiom'
       ELSE                  'Definition'
     END AS labelName
CALL (r, labelName) {
  WITH r, labelName
  WITH r WHERE labelName = 'Theorem'
  MERGE (t:Theorem {namespace: 'OmegaTheoryV2', name: r.name})
  ON CREATE SET t.created_at = datetime()
  // 2026-04-24: content-hash guard. Only bump env_dumped_at (which triggers
  // re-embed downstream) when signature OR proof_body OR docstring actually
  // changed vs what's currently stored. Saves ~20 min GPU time per refresh
  // when most of the dump is byte-identical to prior state.
  WITH t, r,
       (t.signature IS NULL OR t.signature <> r.type_pretty
        OR t.proof_body IS NULL OR t.proof_body <> r.value_pretty
        OR coalesce(t.docstring, '') <> coalesce(r.docstring, '')) AS contentChanged
  SET t.signature           = r.type_pretty,
      t.proof_body          = r.value_pretty,
      t.docstring           = r.docstring,
      t.file                = r.file,
      t.module              = r.module,
      t.source_span         = [r.line_start, r.line_end, r.col_start, r.col_end],
      t.kind                = r.kind,
      t.declaration_type    = r.kind,
      t.is_private          = r.is_private,
      t.universe_params     = r.universe_params,
      t.num_universe_params = r.num_universe_params,
      t.source              = 'lean_env_v1',
      t.env_dumped_at       = CASE WHEN contentChanged OR t.env_dumped_at IS NULL
                                   THEN datetime()
                                   ELSE t.env_dumped_at END
}
CALL (r, labelName) {
  WITH r, labelName
  WITH r WHERE labelName = 'Axiom'
  MERGE (a:Axiom {namespace: 'OmegaTheoryV2', name: r.name})
  ON CREATE SET a.created_at = datetime()
  WITH a, r,
       (a.signature IS NULL OR a.signature <> r.type_pretty
        OR a.proof_body IS NULL OR a.proof_body <> r.value_pretty
        OR coalesce(a.docstring, '') <> coalesce(r.docstring, '')) AS contentChanged
  SET a.signature           = r.type_pretty,
      a.proof_body          = r.value_pretty,
      a.docstring           = r.docstring,
      a.file                = r.file,
      a.module              = r.module,
      a.source_span         = [r.line_start, r.line_end, r.col_start, r.col_end],
      a.kind                = r.kind,
      a.declaration_type    = r.kind,
      a.is_private          = r.is_private,
      a.universe_params     = r.universe_params,
      a.num_universe_params = r.num_universe_params,
      a.source              = 'lean_env_v1',
      a.env_dumped_at       = CASE WHEN contentChanged OR a.env_dumped_at IS NULL
                                   THEN datetime()
                                   ELSE a.env_dumped_at END
}
CALL (r, labelName) {
  WITH r, labelName
  WITH r WHERE labelName = 'Definition'
  MERGE (d:Definition {namespace: 'OmegaTheoryV2', name: r.name})
  ON CREATE SET d.created_at = datetime()
  WITH d, r,
       (d.signature IS NULL OR d.signature <> r.type_pretty
        OR d.proof_body IS NULL OR d.proof_body <> r.value_pretty
        OR coalesce(d.docstring, '') <> coalesce(r.docstring, '')) AS contentChanged
  SET d.signature           = r.type_pretty,
      d.proof_body          = r.value_pretty,
      d.value               = r.value_pretty,
      d.docstring           = r.docstring,
      d.file                = r.file,
      d.module              = r.module,
      d.source_span         = [r.line_start, r.line_end, r.col_start, r.col_end],
      d.kind                = r.kind,
      d.declaration_type    = r.kind,
      d.is_private          = r.is_private,
      d.universe_params     = r.universe_params,
      d.num_universe_params = r.num_universe_params,
      d.source              = 'lean_env_v1',
      d.env_dumped_at       = CASE WHEN contentChanged OR d.env_dumped_at IS NULL
                                   THEN datetime()
                                   ELSE d.env_dumped_at END
}
'''

    valid_recs = [r for r in records if r.get('kind') in QUERIES]
    skipped_kind = len(records) - len(valid_recs)

    with driver.session() as s:
        for i in range(0, len(valid_recs), BATCH):
            batch = valid_recs[i:i+BATCH]
            for attempt in range(8):
                try:
                    s.run(BATCH_QUERY, records=batch)
                    updated += len(batch)
                    break
                except Exception as e:
                    if 'DeadlockDetected' in str(e) and attempt < 7:
                        time.sleep(2 + attempt)
                        continue
                    errors += 1
                    if errors < 5:
                        print(f'  ERR batch {i//BATCH}: {e}')
                    break
            if ((i // BATCH) + 1) % 5 == 0:
                elapsed = time.time() - start
                rate = (i + BATCH) / max(elapsed, 0.01)
                print(f'  {i+BATCH}/{len(valid_recs)} ({rate:.0f} rec/s, updated={updated}, errors={errors})')
                sys.stdout.flush()

    elapsed = time.time() - start
    print(f'[delta-load-decls] done in {elapsed:.1f}s (updated={updated}/{len(records)}, errors={errors}, skipped_kind={skipped_kind})')

    with driver.session() as s:
        post = s.run('''
          MATCH (n {namespace: 'OmegaTheoryV2'})
          WHERE n:Theorem OR n:Definition OR n:Axiom
          RETURN labels(n)[0] AS lbl, count(n) AS c
        ''').data()
    post_map = {r['lbl']: r['c'] for r in post}
    print(f'[delta-load-decls] POST: {post_map}')
    for k in set(pre_map.keys()) | set(post_map.keys()):
        delta = post_map.get(k, 0) - pre_map.get(k, 0)
        if delta != 0:
            print(f'  +{delta} {k}')

    with driver.session() as s:
        s.run('''
            MERGE (m:MetaprogramScript {name: 'DeltaLoadDeclsV2_FunWave'})
            SET m.namespace = 'OmegaTheoryV2',
                m.kind = 'python_loader',
                m.script_path = '~/lean-v2/.neo4j/load_declarations_env_v2.py',
                m.input_jsonl = $input_path,
                m.records_total = $total,
                m.records_updated = $updated,
                m.errors = $errors,
                m.skipped_kind = $skipped,
                m.elapsed_seconds = $elapsed,
                m.provenance_tag = 'source=lean_env_v1, delta=fun_wave_14_hunters',
                m.created_at = datetime()
        ''', total=len(records), updated=updated, errors=errors, skipped=skipped_kind, elapsed=int(elapsed), input_path=str(jsonl_path))
    driver.close()


if __name__ == '__main__':
    main()
