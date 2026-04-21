---
name: OmegaTheoryAlgebra
date: 2026-04-18
status: Phase 0 in progress
author: Norbert Marchewka
contributors: Sarin-Alpha (γ Sgr), Sarin-Beta (Nunki, σ Sgr), ...
scope: adapting V3 (Hypatia + Grothendieck + Erdős) from software architecture to Lean 4 theorem proving on OmegaTheory V2
---

# OmegaTheoryAlgebra

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md)

Phase 0 design memos for the V3-for-Lean adaptation. The V3 framework (Marchewka 2026) treats a software system as a typed quiver whose path algebra is non-abelian, whose Magnetic Laplacian is Hermitian, and whose FastRP sub-topologies detect subsystems. This family of files re-derives that framework for Lean 4 on top of OmegaTheory V2 (211 files, ~2612 theorems, 24 axioms, 0 sorry, Mathlib v4.29). Each memo is standalone, one concern per file, cited against V3 papers and OmegaTheory source with line numbers.

> **Count conventions (2026-04-18, per Izar/Docs-Nu reconciliation).** Two parallel counts are cited across these memos:
> - **Source-tree count** — from naive grep over `LeanFormalizationV2/OmegaTheory/`. Per 2026-04-18: **211 files, ~2612 theorems/lemmas, 24 axioms** (8 physical + 1 `Real.pi_transcendental` + 15 HermitePade research axioms). Used as "ground truth" for design discussions.
> - **Neo4j projection count** — from the live `OmegaTheoryV2` namespace in the `math` container. Per 2026-04-18: **176 LeanFile, 800 Theorem, 9 Axiom** (projection is incremental and not yet exhaustive; some early files and Mathlib-projected axioms are not yet ingested; 35 Namespace nodes live on LeanFile-duals). Used as the "graph state" for empirical scripts.
>
> Both counts are valid; they refer to different objects. When a memo cites 211/2612/24 it means the source tree; when it cites 176/800/9 it means the current graph state. Design decisions (entity types, arrow semantics, selection rules) hold for both.
>
> *Axiom-count footnote.* The source-tree figure of 24 reflects raw `^axiom` grep hits. A declaration-grade parse (ignoring the word "axiom" where it appears in doc-comments rather than as a kernel declaration) gives **21 real `axiom` declarations**: 8 physical constants + 1 `Real.pi_transcendental` + 12 HermitePade conjectures. The 3-line gap is doc-comment prose. Memos in this directory use 24 for the grep-level figure and 21 for the kernel-level figure interchangeably; public-facing versions of this README should use 21 and mention the grep inflation explicitly.

## Agents
- **Sarin-Alpha** (γ Sagittarii) — Phase 0 files 01–04, adaptation design
- **Sarin-Beta** (Nunki, σ Sagittarii) — Phase 0 files 05–07, speculative/creative pressure
- (future: Merak team for 08–09, Dubhe for Phase 4 paper)

## Files

| # | File | One-line purpose |
|---|---|---|
| 00 | `README.md` | this index |
| 01 | `01_entity_types.md` | 6 Lean entity types (Axiom, Theorem/Lemma, Definition/Abbrev, Structure/Class, Instance, Namespace) with heights and V3 analogues |
| 02 | `02_relationships.md` | 15 typed relationships (4 structural + 5 dependency + 3 type-theoretic + 3 computational) replacing V3's 22 arrows |
| 03 | `03_selection_rules.md` | forbidden compositions: Axiom pure source, Namespace container-only, Instance unique parent, and 4 more |
| 04 | `04_magnetic_laplacian.md` | 𝔄 ∈ ℂ^{6×6} construction with g=1/4, Hermiticity sketch, per-relation rank-2 decomposition |
| 05 | `05_cycle_hypotheses.md` | (Sarin-Beta) SPECIALIZES⇌GENERALIZES and UNFOLDS⇌FOLDS candidate 𝔰𝔲(2) cycles, ±i eigenvalue predictions |
| 06 | `06_fastrp_scaling.md` | m=64 per relation for ~243K nodes, J-L bound check, seed=42, weights [0,1,1,0.5] |
| 07 | `07_single_lens_rationale.md` | single Lean-Finder lens vs V3's 3-lens overlay |
| 08 | `08_empirical_spectrum.md` | (Merak) commutator eigenvalues on live OmegaTheory+Mathlib data |
| 09 | `09_subsystem_sanity.md` | (Merak) detected subsystems vs expected OmegaTheory themes (Foundations, Irrationality, Gauge, Emergence, Predictions, Conservation) |
| 10 | `10_neo4j_schema_map.md` | how each decision above maps to Cypher nodes/edges in `.neo4j/lean_algebra_*.cypher` |
| `measure_non_commutativity.py` | script for file 08 |
| `verify_cycles.py` | script for file 05/08 |

---

## Amended 2026-04-18 evening — Level B + C extensions

The **core algebra** is 6 entity types + 15 arrows + 7 HARD_BLOCK selection rules. Memo 01 §9, memo 02 §11–§12, memo 03 §"Level B + C selection rules", memo 04 §8–§13 amend this with an explicit meta-layer.

### Current inventory (live Neo4j `math` container, bolt://localhost:7687)

| Layer | Entity types | Arrows | Selection rules | Magnetic Laplacian dim |
|---|---|---|---|---:|
| Core (6-entity, 15-arrow algebra) | 6 | 15 | 7 HARD_BLOCK + 6 derived | 6×6 |
| Level B (behavioral / meta) | +2 (Tactic, Attribute) | +2 (USES_TACTIC, TAGGED_AS) | +2 derived (SR_L14–SR_L15) | — |
| Level C (symmetric-pair witnesses, explicit 𝔰𝔲(2)) | 0 | +3 (MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR) | +3 derived (SR_L16–SR_L18) | — |
| **Live total** | **8 QuiverVertex** | **20 typed arrows** | **7 HARD_BLOCK + 11 derived** | **8×8** |

### Extension level marker

Each QuiverVertex added at Level B carries `extension_level='B'` as a property. Core types have `extension_level=NULL` (verified live for all 6 core vs both Level B).

### Edge counts as of 2026-04-18 evening

| Arrow | Level | Live edges |
|---|---|---:|
| IMPORTS, OPENS_NAMESPACE, EXTENDS, INSTANTIATES, ASSUMES, APPLIES, UNFOLDS, SPECIALIZES, REWRITES_BY, HAS_TYPE, CONSTRAINED_BY, PARAMETRIZES, REDUCES_TO, ELABORATES_AS, SUGGESTED_BY | core | ~1.3M total |
| USES_TACTIC | B | 285,581 |
| TAGGED_AS | B | 12,872 |
| MUTUALLY_IMPLIES | C | 2,082 |
| DUAL_OF | C | 7,786 |
| ADDITIVE_PAIR | C | 3,788 |
| **Total** | | **≈2.0M** |

### INSTANCE_OF children (Level B meta-vertices)

- Tactic → 68 concrete tactic names (simp, ring, linarith, ...)
- Attribute → 37 concrete attribute names (@[simp], @[ext], @[to_additive], ...)

### Reading order for Level B + C

1. Memo 01 §9 — Tactic and Attribute entity types (behavioral meta, R(3,3)=6 preserved on core only)
2. Memo 02 §11–§15 — 5 new arrows with signatures and live counts
3. Memo 03 Amended — SR_L14 through SR_L18 (all derived, none ship as HARD_BLOCK)
4. Memo 04 §8–§13 — 8×8 Magnetic Laplacian, per-category normalization, Alt-A vs Alt-C bifurcation hypothesis
5. Memo 10 Amended — Cypher realization map for Level B + C edges (pending)

The 15-arrow / 6-type core memo content remains authoritative for the core algebra. Amendments extend; they do not rewrite.
