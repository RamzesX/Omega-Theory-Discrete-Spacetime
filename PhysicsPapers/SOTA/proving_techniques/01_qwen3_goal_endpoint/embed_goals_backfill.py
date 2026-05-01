#!/usr/bin/env python3
"""SOTA T2 — Long-running backfill: Theorem.embedding_goal (separate from embedding_lean).

The user noted (2026-05-01): goals can NOT share the same embedding field as the
full theorem (which packs signature+proof_body). Goals need their OWN embedding
dimension so the agent can query against pre-proof-state representation.

This script populates a NEW per-Theorem field `embedding_goal` (4096-d, Qwen3 via
[goal] prefix on signature text). It uses the existing GPU-resident
Qwen3-Embedding-8B at :7999, runs in batches of 64, is RESUMABLE (re-running
picks up wherever the previous run left off), and can run for hours without
holding state in Python memory.

USAGE:
    # Foreground (small slice for testing):
    python3 embed_goals_backfill.py --limit 256 --batch 64

    # Long-running (all 192K theorems, both namespaces):
    nohup python3 embed_goals_backfill.py > embed_goals.log 2>&1 &

    # Resumable: just re-run; processed theorems are skipped via NULL filter.

ENV:
    OMEGA_NEO4J_PASSWORD       neo4j password (default: omegatheory2026)
    QWEN3_EMBED_URL            llama-server :7999 endpoint
    OMEGA_GOAL_BATCH           batch size (default: 64)
    OMEGA_GOAL_NAMESPACE       restrict (Mathlib | OmegaTheoryV2 | both = default)

PERFORMANCE (RX 9060 XT 16GB + Qwen3-Embedding-8B Q8_0):
    ~30 embeddings/sec end-to-end (HTTP overhead + GPU forward + Cypher write)
    192,661 theorems → ~107 min single-thread (acceptable for one-time backfill)
    ~85 MB graph delta (192K × 4096 × 0.5 bytes per float at f32 packed)
"""
from __future__ import annotations

import argparse
import os
import sys
import time
from pathlib import Path
from typing import Optional

import requests
from neo4j import GraphDatabase

# Allow running standalone without sys.path mods
GOAL_PREFIX = "[goal] "
QWEN3_URL = os.environ.get(
    "QWEN3_EMBED_URL", "http://localhost:7999/v1/embeddings"
)


# Qwen3-Embedding-8B context window is 4096 tokens; each token is ~4 chars
# of Lean source on average. Truncate aggressively to 1800 chars (≈450 tokens
# headroom for prefix+special) so a long signature can never blow the batch.
SIG_MAX_CHARS = 1800


def embed_goals_batch(
    goals: list[str],
    timeout: float = 180.0,
    url: str = QWEN3_URL,
) -> list[list[float]]:
    """Embed a batch of goals via llama-server :7999 with [goal] prefix.

    On HTTP 400 (typically one oversized goal exceeding ctx), falls back to
    per-goal retry — keeps the batch progressing instead of dropping all 64.
    Truncates inputs to SIG_MAX_CHARS up-front to make 400s rare.
    """
    if not goals:
        return []
    inputs = [GOAL_PREFIX + (g[:SIG_MAX_CHARS] if g else "") for g in goals]
    payload = {"input": inputs, "model": "qwen3-embedding-8b"}
    try:
        r = requests.post(url, json=payload, timeout=timeout)
        r.raise_for_status()
    except requests.HTTPError:
        # 400 → likely one oversized input; fall back to per-row
        if r.status_code == 400 and len(goals) > 1:
            embs: list[list[float]] = []
            for g in goals:
                try:
                    sub = embed_goals_batch([g], timeout=timeout, url=url)
                    embs.append(sub[0] if sub else [0.0] * 4096)
                except Exception as e2:
                    print(f"  [skip] embed failed for goal len={len(g)}: {e2}", flush=True)
                    embs.append([0.0] * 4096)
            return embs
        raise
    data = r.json()
    embs = [d["embedding"] for d in data["data"]]
    if len(embs) != len(goals):
        raise ValueError(
            f"embed batch returned {len(embs)} vecs for {len(goals)} goals"
        )
    return embs


def fetch_pending(session, batch: int, namespace: Optional[str]) -> list[dict]:
    """Pull next batch of (name, signature) where embedding_goal IS NULL.

    Uses ORDER BY name for deterministic checkpoint behavior across restarts.
    Limits result via LIMIT (Neo4j honors after WHERE so no full scan).
    """
    ns_filter = "AND t.namespace = $ns" if namespace else ""
    cypher = f"""
        MATCH (t:Theorem)
        WHERE t.embedding_goal IS NULL
          AND t.signature IS NOT NULL
          {ns_filter}
        RETURN t.name AS name, t.signature AS signature
        ORDER BY t.name
        LIMIT $batch
    """
    params = {"batch": batch}
    if namespace:
        params["ns"] = namespace
    return [dict(r) for r in session.run(cypher, params)]


def write_embeddings(session, rows: list[dict], embeddings: list[list[float]]) -> int:
    """UNWIND-batch SET embedding_goal on each Theorem; returns count written."""
    if not rows:
        return 0
    payload = [
        {"name": r["name"], "vec": v}
        for r, v in zip(rows, embeddings)
    ]
    cypher = """
        UNWIND $rows AS row
        MATCH (t:Theorem {name: row.name})
        SET t.embedding_goal = row.vec
        RETURN count(t) AS n
    """
    res = session.run(cypher, rows=payload).single()
    return res["n"] if res else 0


def count_remaining(session, namespace: Optional[str]) -> int:
    ns_filter = "AND t.namespace = $ns" if namespace else ""
    cypher = f"""
        MATCH (t:Theorem)
        WHERE t.embedding_goal IS NULL
          AND t.signature IS NOT NULL
          {ns_filter}
        RETURN count(t) AS n
    """
    params = {"ns": namespace} if namespace else {}
    res = session.run(cypher, params).single()
    return res["n"] if res else 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--batch", type=int, default=int(os.environ.get("OMEGA_GOAL_BATCH", 64)))
    ap.add_argument("--limit", type=int, default=0,
                    help="max total theorems to process (0 = run until empty)")
    ap.add_argument("--namespace", type=str, default=os.environ.get("OMEGA_GOAL_NAMESPACE"),
                    help="restrict to Mathlib | OmegaTheoryV2 (default: both)")
    ap.add_argument("--dry-run", action="store_true",
                    help="show counts only; do not embed or write")
    args = ap.parse_args()

    pw = os.environ.get("OMEGA_NEO4J_PASSWORD", "omegatheory2026")
    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pw))

    ns = args.namespace if args.namespace and args.namespace.lower() != "both" else None

    with driver.session() as s:
        total_pending = count_remaining(s, ns)
        print(f"[init] pending theorems (embedding_goal IS NULL, ns={ns or 'both'}): {total_pending:,}", flush=True)
        if args.dry_run:
            return

        if total_pending == 0:
            print("[done] nothing to do", flush=True)
            return

        # Health check on embedding server before locking in for hours
        try:
            r = requests.get(QWEN3_URL.replace("/v1/embeddings", "/health"), timeout=5)
            print(f"[init] qwen3 :7999 health = {r.json()}", flush=True)
        except Exception as e:
            print(f"[init] WARNING: qwen3 :7999 health check failed: {e}", flush=True)

        processed = 0
        budget = args.limit if args.limit > 0 else total_pending
        t_start = time.time()
        t_last_log = t_start
        rate_window = 0
        while processed < budget:
            rows = fetch_pending(s, min(args.batch, budget - processed), ns)
            if not rows:
                print(f"[done] no more pending theorems after {processed:,} processed", flush=True)
                break
            try:
                t_emb = time.time()
                embs = embed_goals_batch([r["signature"] for r in rows])
                emb_dt = time.time() - t_emb
            except Exception as e:
                print(f"[err] embed batch failed: {e} — skipping batch of {len(rows)}", flush=True)
                # Backoff to avoid hammer-mode on persistent failure
                time.sleep(5)
                continue
            try:
                t_w = time.time()
                n_written = write_embeddings(s, rows, embs)
                w_dt = time.time() - t_w
            except Exception as e:
                print(f"[err] write batch failed: {e} — retrying after 5s", flush=True)
                time.sleep(5)
                continue
            processed += n_written
            rate_window += n_written

            now = time.time()
            if now - t_last_log >= 5.0 or processed >= budget:
                rate = rate_window / max(0.001, (now - t_last_log))
                pct = 100.0 * processed / budget
                eta_s = (budget - processed) / max(0.001, rate)
                print(
                    f"[progress] {processed:>7,}/{budget:,} ({pct:5.1f}%) "
                    f"rate={rate:5.1f}/s emb={emb_dt:.2f}s write={w_dt:.2f}s "
                    f"ETA={eta_s/60:5.1f}min",
                    flush=True,
                )
                rate_window = 0
                t_last_log = now

        elapsed = time.time() - t_start
        avg_rate = processed / max(0.001, elapsed)
        print(f"[summary] processed={processed:,} elapsed={elapsed/60:.1f}min "
              f"avg_rate={avg_rate:.1f}/s", flush=True)

    driver.close()


if __name__ == "__main__":
    main()
