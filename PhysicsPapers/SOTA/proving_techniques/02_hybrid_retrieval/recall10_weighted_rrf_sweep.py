#!/usr/bin/env python3
"""SOTA T3 — Weighted RRF sweep on Recall@10 dev slice.

The unweighted RRF k=60 hybrid (dense + FTS) LOST to dense alone at N=83
(78.3% vs 81.9%) per the baseline. This script sweeps w_dense ∈ {1.0, 1.5,
2.0, 3.0, 5.0} to find an optimal weighted-RRF that recovers the hybrid lift.

Weighted RRF formula:
    scores[name] += w_dense / (k + rank_dense) + w_fts / (k + rank_fts)
    (w_fts pinned to 1.0 — all weights are relative to FTS=1)

USAGE:
    python3 recall10_weighted_rrf_sweep.py [--n 99]

OUTPUT:
    Prints per-w_dense recall@10/recall@5/mean_hits table + JSON to disk.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

# Reuse helpers from the baseline script
sys.path.insert(0, str(Path(__file__).parent))
from recall10_baseline import (
    get_session,
    sample_dev_slice,
    retrieve_dense,
    retrieve_fts,
)


def weighted_rrf_fuse(
    rankings_with_weights: list[tuple[list[str], float]],
    k: int = 60,
) -> list[str]:
    """rankings_with_weights = [(ranking, weight), ...]"""
    scores: dict[str, float] = {}
    for ranking, w in rankings_with_weights:
        for rank, name in enumerate(ranking):
            scores[name] = scores.get(name, 0.0) + w / (k + rank)
    return [n for n, _ in sorted(scores.items(), key=lambda x: x[1], reverse=True)]


def eval_weighted(samples, session, w_dense: float, w_fts: float = 1.0) -> dict:
    n = len(samples)
    hits10 = 0
    hits5 = 0
    hit_counts = []
    t0 = time.time()
    for s in samples:
        d = retrieve_dense(session, s, 10)
        f = retrieve_fts(session, s, 10)
        top10 = weighted_rrf_fuse([(d, w_dense), (f, w_fts)], k=60)[:10]
        top5 = top10[:5]
        gt = set(s["premises"])
        hits = gt.intersection(top10)
        if hits:
            hits10 += 1
        if gt.intersection(top5):
            hits5 += 1
        hit_counts.append(len(hits))
    return {
        "w_dense": w_dense,
        "w_fts": w_fts,
        "n": n,
        "recall_at_10": hits10 / n,
        "recall_at_5": hits5 / n,
        "mean_hits": sum(hit_counts) / max(1, n),
        "elapsed_sec": time.time() - t0,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--n", type=int, default=99)
    ap.add_argument("--save", default=None)
    args = ap.parse_args()

    driver, session = get_session()
    n_per_tier = args.n // 3
    print(f"Sampling {n_per_tier * 3} dev-slice theorems ({n_per_tier} per tier)...")
    samples = sample_dev_slice(session, n_per_tier)
    print(f"Got {len(samples)} samples\n")

    sweep = [
        (1.0, 1.0),
        (1.5, 1.0),
        (2.0, 1.0),
        (3.0, 1.0),
        (5.0, 1.0),
    ]

    # Also evaluate dense-only and fts-only as baselines
    from recall10_baseline import evaluate
    print("=== Baselines ===")
    base_dense = evaluate(samples, session, "dense")
    base_fts = evaluate(samples, session, "fts")
    base_hybrid_unw = evaluate(samples, session, "hybrid")
    print(f"  dense              recall@10={base_dense['recall_at_10']:.3f}  recall@5={base_dense['recall_at_5']:.3f}")
    print(f"  fts                recall@10={base_fts['recall_at_10']:.3f}  recall@5={base_fts['recall_at_5']:.3f}")
    print(f"  hybrid (unweighted) recall@10={base_hybrid_unw['recall_at_10']:.3f}  recall@5={base_hybrid_unw['recall_at_5']:.3f}")
    print()

    print("=== Weighted RRF sweep (w_fts=1.0) ===")
    print(f"  {'w_dense':>8s}  {'recall@10':>10s}  {'recall@5':>9s}  {'mean_hits':>10s}  {'elapsed':>8s}")
    results = {"baselines": {"dense": base_dense, "fts": base_fts, "hybrid_unweighted": base_hybrid_unw}, "sweep": []}
    for w_d, w_f in sweep:
        r = eval_weighted(samples, session, w_d, w_f)
        print(f"  {r['w_dense']:>8.1f}  {r['recall_at_10']:>10.3f}  {r['recall_at_5']:>9.3f}  "
              f"{r['mean_hits']:>10.2f}  {r['elapsed_sec']:>7.1f}s")
        results["sweep"].append(r)

    out = Path(args.save) if args.save else Path(__file__).parent / "recall10_weighted_rrf.json"
    out.write_text(json.dumps(results, indent=2))
    print(f"\nSaved → {out}")
    driver.close()


if __name__ == "__main__":
    main()
