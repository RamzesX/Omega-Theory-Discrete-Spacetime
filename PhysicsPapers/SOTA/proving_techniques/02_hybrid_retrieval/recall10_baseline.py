#!/usr/bin/env python3
"""SOTA T3 — Recall@10 baseline benchmark for omega_hammer retrieval.

Measures the percentage of OV2 theorems for which AT LEAST ONE of the top-10
dense kNN hits is a ground-truth premise (APPLIES target). Establishes the
baseline BEFORE the FTS hybrid layer + reranker fusion are wired in.

USAGE:
    python3 recall10_baseline.py [--n 100] [--mode dense|fts|hybrid] [--save out.json]

OUTPUT:
    JSON dict with per-mode recall@10, recall@5, mean #hits, sample log.
    Saved to recall10_baseline.json (or path passed via --save).

DESIGN:
- Sample N OV2 theorems with both embedding_lean AND >=2 APPLIES targets.
- Stratify across tier ∈ {99, 80, Heart} (33/33/34 default).
- For each, retrieve top-10 candidates via:
    mode=dense  → CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', 10, embedding)
    mode=fts    → CALL db.index.fulltext.queryNodes('theorem_fts', signature_text)
    mode=hybrid → RRF-fuse dense + FTS rankings (k=60)
- Check |top10 ∩ APPLIES_targets| > 0 (recall@10) and == top5 (recall@5).
- Excludes the seed theorem itself from candidate pool.

Authority: SOTA/PLAN.md T3 verification — "benchmark recall@10 on 100-goal dev slice
≥ 75% (vs current ~62%)". This baseline IS the "current ~62%" measurement.
"""

import argparse
import json
import os
import random
import sys
import time
from pathlib import Path

from neo4j import GraphDatabase

random.seed(42)


def get_session():
    pw = os.environ.get("OMEGA_NEO4J_PASSWORD", "omegatheory2026")
    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pw))
    return driver, driver.session()


def sample_dev_slice(session, n_per_tier: int) -> list[dict]:
    """Pick stratified theorems with embedding + APPLIES, return ground truth."""
    tiers = ["99", "80", "Heart"]
    samples: list[dict] = []
    for tier in tiers:
        rows = list(session.run(
            """
            MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})-[:APPLIES]->(p:Theorem)
            WHERE t.embedding_lean IS NOT NULL
              AND t.signature IS NOT NULL
              AND t.tier = $tier
              AND p.namespace = 'OmegaTheoryV2'
            WITH t, collect(DISTINCT p.name) AS premises
            WHERE size(premises) >= 2 AND size(premises) <= 30
            RETURN t.name AS name, t.signature AS signature,
                   t.embedding_lean AS embedding, premises
            ORDER BY rand()
            LIMIT $n
            """,
            tier=tier, n=n_per_tier,
        ))
        for r in rows:
            samples.append({
                "name": r["name"],
                "signature": r["signature"],
                "embedding": r["embedding"],
                "premises": r["premises"],
                "tier": tier,
            })
    random.shuffle(samples)
    return samples


def retrieve_dense(session, sample: dict, k: int) -> list[str]:
    rows = list(session.run(
        """
        CALL db.index.vector.queryNodes(
            'lean_retriever_embedding_theorem', $kk, $vec
        ) YIELD node, score
        WHERE node.namespace = 'OmegaTheoryV2'
          AND node.name <> $seed
        RETURN node.name AS name, score ORDER BY score DESC LIMIT $k
        """,
        kk=k * 4, vec=sample["embedding"], seed=sample["name"], k=k,
    ))
    return [r["name"] for r in rows]


def retrieve_fts(session, sample: dict, k: int) -> list[str]:
    # FTS query: take the theorem's signature as the query text. Lucene
    # requires escaping special characters; use a coarse strip + quote.
    q = sample["signature"][:512]
    # Replace Lucene-special chars with spaces; keeps tokens intact.
    for ch in '+-&|!(){}[]^"~*?:\\/':
        q = q.replace(ch, " ")
    q = q.strip()
    if not q:
        return []
    try:
        rows = list(session.run(
            """
            CALL db.index.fulltext.queryNodes('theorem_fts', $q) YIELD node, score
            WHERE node.namespace = 'OmegaTheoryV2'
              AND node.name <> $seed
            RETURN node.name AS name, score ORDER BY score DESC LIMIT $k
            """,
            q=q, seed=sample["name"], k=k,
        ))
        return [r["name"] for r in rows]
    except Exception as e:
        print(f"  FTS error on {sample['name']}: {e}", file=sys.stderr)
        return []


def rrf_fuse(rankings: list[list[str]], k: int = 60) -> list[str]:
    scores: dict[str, float] = {}
    for ranking in rankings:
        for rank, name in enumerate(ranking):
            scores[name] = scores.get(name, 0.0) + 1.0 / (k + rank)
    return [n for n, _ in sorted(scores.items(), key=lambda x: x[1], reverse=True)]


def evaluate(samples: list[dict], session, mode: str) -> dict:
    n = len(samples)
    hits_at_10 = 0
    hits_at_5 = 0
    hit_counts = []
    log = []
    t0 = time.time()
    for i, s in enumerate(samples):
        if mode == "dense":
            top10 = retrieve_dense(session, s, 10)
        elif mode == "fts":
            top10 = retrieve_fts(session, s, 10)
        elif mode == "hybrid":
            d = retrieve_dense(session, s, 10)
            f = retrieve_fts(session, s, 10)
            top10 = rrf_fuse([d, f], k=60)[:10]
        else:
            raise ValueError(f"unknown mode: {mode}")
        top5 = top10[:5]
        gt = set(s["premises"])
        hits = gt.intersection(top10)
        if hits:
            hits_at_10 += 1
        if gt.intersection(top5):
            hits_at_5 += 1
        hit_counts.append(len(hits))
        log.append({
            "name": s["name"],
            "tier": s["tier"],
            "premises_count": len(s["premises"]),
            "hit_count": len(hits),
            "sample_hit": next(iter(hits), None),
        })
        if (i + 1) % 25 == 0:
            elapsed = time.time() - t0
            print(f"  [{mode}] {i+1}/{n}  elapsed={elapsed:.1f}s  recall@10 so far={hits_at_10/(i+1):.3f}")
    return {
        "mode": mode,
        "n": n,
        "recall_at_10": hits_at_10 / n,
        "recall_at_5": hits_at_5 / n,
        "mean_hits": sum(hit_counts) / max(1, n),
        "elapsed_sec": time.time() - t0,
        "log_sample": log[:10],
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--n", type=int, default=99,
                    help="total samples (will be split per tier)")
    ap.add_argument("--mode", choices=["dense", "fts", "hybrid", "all"],
                    default="all")
    ap.add_argument("--save", type=str, default=None)
    args = ap.parse_args()

    driver, session = get_session()
    n_per_tier = args.n // 3
    print(f"Sampling {n_per_tier * 3} dev-slice theorems ({n_per_tier} per tier)...")
    samples = sample_dev_slice(session, n_per_tier)
    print(f"Got {len(samples)} samples (target {args.n}).")
    print()

    results = {}
    modes = ["dense", "fts", "hybrid"] if args.mode == "all" else [args.mode]
    for mode in modes:
        print(f"=== Mode: {mode} ===")
        results[mode] = evaluate(samples, session, mode)
        r = results[mode]
        print(f"  recall@10 = {r['recall_at_10']:.3f}  "
              f"recall@5 = {r['recall_at_5']:.3f}  "
              f"mean_hits = {r['mean_hits']:.2f}  "
              f"elapsed = {r['elapsed_sec']:.1f}s")
        print()

    out_path = Path(args.save) if args.save else \
        Path(__file__).parent / "recall10_baseline.json"
    out_path.write_text(json.dumps(results, indent=2))
    print(f"Saved → {out_path}")
    driver.close()


if __name__ == "__main__":
    main()
