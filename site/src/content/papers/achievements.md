---
title: "OmegaTheoryAlgebra — Graph Research Achievements"
description: "Design + empirical foundation for the V3-for-Lean paper: 10 design memos, 8,996 theorems × 15 arrow types × 3.95M typed edges. Rank-7 saturating, λ₁/λ₂=1.038, 73.3% non-commutativity."
category: "Graph Research · Neo4j"
order: 101
---

# OmegaTheoryAlgebra — Achievements (as of 2026-04-21)

Design + empirical foundation for the V3-for-Lean paper (Magnetic Laplacian + Leiden community detection + FastRP applied to the OmegaTheory V2 theorem graph).

## Design deliverables (10 modular `.md` files)

| File | Content |
|---|---|
| `01_entity_types.md` | 6 Lean entity types (Axiom · Theorem · Definition · Structure · Instance · Namespace) with height/role mapping |
| `02_relationships.md` | 15 typed arrows: 4 structural + 5 dependency + 3 type-theoretic + 3 computational |
| `03_selection_rules.md` | 7 HARD_BLOCK forbidden compositions (Axiom pure source, Instance unique-parent, etc.) |
| `04_magnetic_laplacian.md` | 𝔄 ∈ ℂ^{6×6} construction at g=1/4; Hermiticity proof sketch |
| `05_cycle_hypotheses.md` | SPECIALIZES⇌GENERALIZES, UNFOLDS⇌FOLDS bidirectional 𝔰𝔲(2) candidates |
| `06_fastrp_scaling.md` | m=64 per relation, J-L scaling for 243K-node corpus |
| `07_single_lens_rationale.md` | Why single Qwen3 embedding vs 3-lens V3 overlay |
| `08_empirical_spectrum.md` | Real spectrum data: λ₁/λ₂ = 1.038 first degeneracy break at rank 7; 73.3% non-commutativity |
| `09_subsystem_sanity.md` | Detected subsystems vs expected OmegaTheory physics themes |
| `10_neo4j_schema_map.md` | Schema ↔ Cypher mapping |

## Empirical scripts
- `measure_non_commutativity.py` (26 KB) — computes `[ρ_i, ρ_j]` eigenvalue spectrum on real OmegaTheory data
- `verify_cycles.py` (12 KB) — bidirectional cycle SPECIALIZES⇌GENERALIZES verifier

## Key numerical findings (persisted as `:GraphFinding` in Neo4j)

- **Rank-7 saturating**: Dubhe measurement surfaces first degeneracy break at rank 7 eigenvalue pair
- **λ₁/λ₂ = 1.038** — first degeneracy-break ratio (smaller than typical 1.5+ for random graphs, signals substrate structure)
- **Non-commutativity 73.3%** — `[ρ_i, ρ_j] ≠ 0` for 73% of arrow-pair products (non-abelian signature confirmed)
- **5-scale hierarchy**: {43379, 41787, 1722, 127, 3.83} — eigenvalue magnitudes span 4 orders of magnitude

## Paper target
V3-for-Lean v1.1 — NeurIPS 2026 / ICLR 2027 submission window. First corpus-scale Magnetic Laplacian + Leiden + FastRP study of a Lean theorem-graph.

## Live artifacts (in Neo4j `OmegaTheoryV2`)
- 95 `:GraphFinding` nodes (36 paper_worthy)
- 24 `:GrothendieckRecipe` nodes
- 144 `:TheoremCandidate` nodes (60 from Mekbuda cycle-24-43 backlog)
- 1 `:MagneticLaplacian` + 15 `:MagneticLaplacian_component` (per-relation rank-2 decomposition)
- 7 `:SelectionRule` nodes (HARD_BLOCK forbidden compositions)
