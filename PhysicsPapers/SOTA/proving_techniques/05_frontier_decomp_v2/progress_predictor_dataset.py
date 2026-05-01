#!/usr/bin/env python3
"""SOTA T6.9 — Progress-prediction dataset extraction.

Extracts (goal_embedding, tactics_remaining) pairs from the OV2 corpus for
training a tiny MLP that predicts how many tactics are left in a proof.

Source paper: LeanProgress (arXiv 2502.17925).

USAGE:
    python3 progress_predictor_dataset.py [--limit N] [--out PATH] [--namespace NS]

OUTPUT:
    NPZ file with two arrays:
      - X: float32 [N, 4096]  — Theorem.embedding_lean (or _goal once backfill done)
      - y: int32   [N]        — tactics_remaining (count of tactics in proof_body)

DESIGN:
- Uses Theorem.tactic_evidence (T1.2 Day-1 Cypher migration over proof_body)
  which is an array of tactic head names (e.g. ["have","rfl","linarith"]).
- Target = len(tactic_evidence) — the total number of tactics from start to QED.
- For "progress" semantics: at any point during a proof, this is the FULL tactic
  count; per-step "remaining" labels would need T1.3 goal-state checkpoints
  (DumpProofSteps.lean — deferred Day 8-10).

For now, this dataset trains a model to predict TOTAL_TACTIC_COUNT given the
THEOREM_EMBEDDING — a useful proxy for difficulty stratification beyond the
existing `tier` heuristic (Tier-99/80/Heart based on proof_body length only).

Stratification: limit per-tier sampling to balance the training set
(Tier-99 has 17 vs Tier-80 has 1.7K vs Tier-Heart has 2.2K candidates).
"""
from __future__ import annotations

import argparse
import os
import sys
import time
from pathlib import Path

import numpy as np
from neo4j import GraphDatabase


def get_driver():
    pw = os.environ.get("OMEGA_NEO4J_PASSWORD", "omegatheory2026")
    return GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pw))


def fetch_dataset(session, namespace: str, limit: int) -> tuple[np.ndarray, np.ndarray, list[str]]:
    """Returns (X[N,4096], y[N], names[N])."""
    cypher = """
    MATCH (t:Theorem {namespace: $ns})
    WHERE t.embedding_lean IS NOT NULL
      AND t.tactic_evidence IS NOT NULL
      AND size(t.tactic_evidence) > 0
    RETURN t.name AS name,
           t.embedding_lean AS emb,
           size(t.tactic_evidence) AS tactics_count,
           t.tier AS tier
    ORDER BY rand()
    LIMIT $lim
    """
    rows = list(session.run(cypher, ns=namespace, lim=limit))
    if not rows:
        raise ValueError(f"empty dataset for namespace={namespace}")
    n = len(rows)
    X = np.zeros((n, 4096), dtype=np.float32)
    y = np.zeros(n, dtype=np.int32)
    names = []
    for i, r in enumerate(rows):
        emb = r["emb"]
        if len(emb) != 4096:
            continue
        X[i] = emb
        y[i] = r["tactics_count"]
        names.append(r["name"])
    return X, y, names


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--namespace", default="OmegaTheoryV2")
    ap.add_argument("--limit", type=int, default=10000)
    ap.add_argument("--out", default="progress_predictor_dataset.npz")
    args = ap.parse_args()

    drv = get_driver()
    t0 = time.time()
    with drv.session() as s:
        X, y, names = fetch_dataset(s, args.namespace, args.limit)
    elapsed = time.time() - t0

    out_path = Path(__file__).parent / args.out if not args.out.startswith("/") else Path(args.out)
    np.savez_compressed(out_path, X=X, y=y, names=np.array(names, dtype=object))
    print(f"Wrote {out_path}: N={len(y)} in {elapsed:.1f}s")
    print(f"  X.shape={X.shape}, y.shape={y.shape}")
    print(f"  tactics_count: min={y.min()} max={y.max()} mean={y.mean():.1f} median={np.median(y):.1f}")
    print(f"  histogram bins ≤5/6-15/16-50/>50: "
          f"{int((y<=5).sum())}/{int(((y>5)&(y<=15)).sum())}/"
          f"{int(((y>15)&(y<=50)).sum())}/{int((y>50).sum())}")
    drv.close()


if __name__ == "__main__":
    main()
