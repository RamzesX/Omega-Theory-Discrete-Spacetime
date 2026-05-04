# OmegaTheory V2 — Build Status

Single source of truth for repo headline numbers, parsed by `site/src/data/status.mjs`
at Astro build time.

| Metric | Value | Notes |
|---|---:|---|
| **Build jobs** | **4,926 GREEN** | Cycle 65 close, 2026-05-04 |
| **Sorry count** | **0** | NO STUBS rule, locked 2026-04-27 |
| **Physical axioms** | **6** | 4 sealed Hermite-Padé research + 2 citation; **0** in T-x paper-headline cone |
| **Research-conjecture axioms** | **6** | (same — all 6 are research-track) |
| **Total declared axioms** | **6** | Lean `axiom` keywords across the corpus |
| **OmegaTheoryV2 Theorems (own)** | **8,996** | Theorem nodes in Neo4j |
| **OmegaTheoryV2 Definitions** | **4,465** | Definition nodes |
| **Mathlib Theorems (integrated)** | **175,137** | v4.29.0 corpus loaded |
| **Grand total** | **184,133** | OV2 + Mathlib retrievable theorems |
| **OmegaTheoryV2 LeanFile nodes** | **1,100** | approximate, post Cycle 65 |
| **Cycles shipped** | **2 – 65** (64 numbered cycles, includes Tier-1 milestones at cycle 64 and 65) |
| **:GraphFinding.total** | **88** | Graph-research findings |
| **:GraphFinding.paper_worthy** | **44** | High-confidence subset |
| **:TheoremCandidate.total** | **166** | Sage-proposed open candidates |
| **:SubsystemNavigator** | **677** | Leiden communities |

## Tier-1 milestones

- **Cycle 64 (2026-04-27):** First Lean 4 formalization of `Real.pi_transcendental`. Custom Lindemann–Weierstrass port, 24 files, ≈ 8 400 LOC, single-day single-thread closure. Axiom audit: `[propext, Classical.choice, Quot.sound]`.
- **Cycle 65 (2026-05-04):** All five previously-open bridge targets closed (ER=EPR, CPT, graviton energy, Susskind complexity, *d*_crit). Build 4 462 → 4 926 GREEN.

## Honest scope

The **Tier-1 core** — π-transcendence + the 8 hand-authored sectors `Variational/`, `HealingFlow/`, `Geometry/`, `Conservation/`, `Spacetime/`, `Tensor/`, `Torsion/`, `Defects/` (≈ 25 500 LOC) — is peer-review-ready. The **Tier-2 broader Ω-framework** (Standard Model emergence, dark sector, ER=EPR / CPT / etc.) compiles cleanly but its physical interpretation is exploratory; see the README and CompleteOmegaTheory.md §0 for the formal scope statement.
