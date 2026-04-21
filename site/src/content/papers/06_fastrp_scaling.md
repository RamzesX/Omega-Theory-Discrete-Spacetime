---
title: "06 — FastRP scaling (Johnson–Lindenstrauss)"
description: "m=64 per relation for ~243K nodes. J-L bound, seed=42, weights [0.0, 1.0, 1.0, 0.5]."
category: "Graph Research · Neo4j"
order: 115
---

<!-- orig-frontmatter: name: 06_fastrp_scaling -->
<!-- orig-frontmatter: date: 2026-04-18 -->
<!-- orig-frontmatter: author: Sarin-Beta (Nunki, σ Sagittarii) -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra Phase 0 -->
<!-- orig-frontmatter: status: design decision memo -->
# 06. FastRP Embedding Dimension at Lean Scale

**TL;DR.** V3 picked m = 8 for n ≈ 400 software nodes, knowingly violating the strict Johnson–Lindenstrauss (J-L) bound. On OmegaTheory + Mathlib (~243K nodes) we recommend m = 64 per relation. That still violates strict J-L, but it is within the same "V3-accepted" distortion regime, stays inside a 1 GB embedding budget per full pass, and gives roughly 7.7× the trainable-weight budget to cover 600× more nodes. Seed, iteration weights, orientation and property ratio are fixed to inherit V3 reproducibility. The one Lean-specific change: a 4-iteration propagation profile [0.0, 1.0, 1.0, 0.5] so that 3-hop import chains (common in Mathlib) contribute signal.

## 1. The strict J-L bound at Lean scale

For n distinct points in ℝ^d, Johnson–Lindenstrauss says a random projection into ℝ^m preserves pairwise distances up to multiplicative factor (1 ± ε) with high probability when

    m ≥ 24 · log(n) / ε²

For our scale n = 243,000 (≈3,500 OmegaTheory + ~240,000 Mathlib), log n ≈ 12.40, so at ε = 0.5:

    m_strict ≥ 24 · 12.40 / 0.25 ≈ 1,190

V3 uses m = 8 for n ≈ 400, where strict J-L at ε = 0.5 requires m ≈ 510. V3 is already a ~64× violation of the strict bound. The V3 response is that FastRP empirically recovers useful per-relation geometry even at m = 8 for ~400 nodes — the sub-topologies are interpretable and the anti-correlation (cos = −0.311) between ORCHESTRATES and TRIGGERS is stable across seeds. So the strict bound is treated as a one-sided guideline, not a hard floor.

## 2. Recommendation: m = 64 per relation

We pick m = 64. The implied effective ε when m = 64 at n = 243K is about 2.16 (solving 24 log n / m = ε²), i.e., in the same distortion regime V3 accepts, adjusted upward by the ratio of logs. This is the pragmatic pick — large enough to carry real per-relation structure, small enough to fit in memory and compute budget.

The composite embedding is R^{64 × 15} = R^{960}, and each per-relation vector lives in R^64. The 15 comes from the Lean ontology in `02_relationships.md`: 4 structural + 5 dependency + 3 type-theoretic + 3 computational.

**Fallback.** If empirical distortion on a pilot run is catastrophic (e.g., all per-relation sub-topologies cluster into a single blob in ρ₀-space, cosine between any two > 0.95), we drop to m = 32 and accept the stronger distortion, explicitly mirroring V3's choice for small n. If m = 32 also fails, the architectural problem is not dimension — it is that the Lean graph is insufficiently non-abelian (see file 05 Alt-B for the diagnostic).

## 3. Invariants inherited from V3

| Knob | V3 value | Lean value | Rationale |
|---|---|---|---|
| randomSeed | 42 | 42 | Reproducibility across all 16 runs (1 base ρ₀ + 15 per-relation); same seed means the random matrix is identical, so corrections Δ_k = ρ_k − ρ₀ are pure structural signal, not noise. |
| propertyRatio | 0.5 | 0.5 | Half the projection weight to the Lean-Finder text embedding, half to graph adjacency. Same split as V3. |
| orientation | UNDIRECTED | UNDIRECTED | FastRP propagates symmetrically; directionality lives in 𝔄 (file 04), not 𝔚. Same separation V3 enforces. |
| iterationWeights | [0.0, 1.0, 1.0] | [0.0, 1.0, 1.0, 0.5] | **One change.** Lean proofs routinely chain through 3 hops of imports or 3 hops of specialization. A tapered 4th iteration (weight 0.5) captures Mathlib depth without doubling cost. Verified on OmegaTheory DAG: the 95th percentile transitive import depth is 4 hops. |

The zero in the first iteration weight is critical: it prevents the embedding from collapsing into the identity (i.e., just echoing the text embedding). V3 keeps this; so do we.

## 4. Parameter budget

The trainable-weights count, in the V3 LoRA decomposition ρ_k = ρ_0 + α_k · u_k v_k^T, scales as

    |𝔚| = m · d_text + K · (1 + m · d_text + m)

with m = 64, d_text = 768 (Lean-Finder output dim), K = 15:

    |𝔚| = 64 × 768 + 15 × (1 + 64 × 768 + 64)
         = 49,152 + 15 × 49,217
         = 787,407

Compared to V3's 102,553 trainable weights for 152 nodes, this is a 7.7× budget increase to cover a 600× larger graph — a healthy amortization. Crucially, the budget is still independent of node count: the per-node embeddings are products of 𝔚, not parameters of it.

## 5. Storage

Each node stores one ρ₀ embedding plus 15 per-relation embeddings = 16 × 64 = 1,024 float32 values = 4 KB/node. At 243K nodes:

    243,000 × 4 KB ≈ 0.97 GB

That sits comfortably in Neo4j GDS 2.x on the RX 9060 XT 16 GB (the card arriving Apr 20 per the project plan), and well under the WSL2 RAM ceiling. Writing these back as Neo4j node properties via `gds.graph.nodeProperties.write` is the V3 pattern and requires no special handling at this scale.

## 6. Timing estimate

Order-of-magnitude expectations for one FastRP pass on the Lean graph:

| Hardware | Base ρ₀ pass | Per-relation pass | Full 16-pass wall clock |
|---|---|---|---|
| Neo4j GDS on RX 9060 XT 16 GB | ~5 min | ~2 min | ~35 min |
| Neo4j GDS on CPU (Ryzen 9 9950X, 32 threads) | ~12 min | ~5 min | ~1.5 hr |

These are estimates derived from V3's reported ~30 s per pass on a 152-node graph, scaled by edge count (linear in edges for FastRP), then cushioned for random projection overhead. Per-relation passes are faster because the per-relation subgraph has ~1/15 the edges of the full graph, on average.

**Compute budget.** A full re-train costs under an hour on the new GPU once the cable arrives. Until then, CPU is tolerable: ~1.5 hours is within a single evening's session. No need to pre-compute intermediate artifacts.

## 7. What we predict / what could kill this

**We predict:** at m = 64 with the V3-inherited invariants, the measured distortion (mean pairwise distance ratio between ρ_k(R^768) and full-embedding cosine similarity) stays below 1.25× on a 1,000-node pilot drawn from OmegaTheory Emergence + Predictions subsystems. Per-relation cosine anti-correlations show up for at least one pair (expected: SPECIALIZES vs INSTANTIATES, or UNFOLDS vs REWRITES). Both signatures match V3's pattern.

**What kills this.** (a) Distortion above 2× on the pilot, meaning the random projection has genuinely lost structure at this scale — we drop to m = 96 or switch to Gaussian J-L with explicit normalization. (b) No anti-correlations at all across all 15 × 14 / 2 = 105 relation pairs — means Lean sub-topologies collapse onto a single blob and we never had a non-abelian algebra to begin with. (c) The 4th iteration weight [..., 0.5] degrades rather than improves the per-relation discrimination — revert to [0.0, 1.0, 1.0] and accept the shallower propagation.

All three are cheap to check on a pilot before committing to the full 243K run.
