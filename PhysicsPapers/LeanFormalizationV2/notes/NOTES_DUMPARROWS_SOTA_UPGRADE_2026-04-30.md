# DumpArrows SOTA Upgrade — Recommendations + Implementation Plan

**Date**: 2026-04-30
**Status**: Audit + Plan. Implementation deferred to strategic 30-min fire.

## Current state (DumpArrows.lean v2 / Larawag 2026-04-25)

**12 of 15 V3 arrows extracted from `Lean.Environment` snapshot:**
- Per-decl (10): `applies`, `assumes`, `unfolds`, `reduces_to`, `extends`,
  `instantiates`, `has_type`, `constrained_by`, `parametrizes_types/levels`,
  `elaborates_as`
- Per-module (1): `imports` (from `env.header.moduleData[i].imports`)

**3 V3 arrows MISSING:**
- `OPENS_NAMESPACE` — flagged TODO at line 37: requires `Frontend.processFile`
- `REWRITES_BY` — tactic-block-level info; not in env snapshot
- `SPECIALIZES` — instance specialization; partial via INSTANTIATES
- `SUGGESTED_BY` — derived from embeddings, not env

## SOTA techniques 2026 — what's available

### A. Tactic-aware extraction (LeanDojo 2025, Lean Copilot 2026, Pantograph 2025)

State of the art for proof-aware arrow extraction:
- LeanDojo's `lean_dojo.utils.parse_proof` walks `Lean.Elab.Term.TacticContext`
  to capture `rw`/`simp`/`apply` use sites
- Lean Copilot 2026 uses `Lean.Elab.Tactic.evalTactic` instrumentation
- Pantograph 2025 extracts via `LSP textDocument/codeLens` on tactic results

**For OmegaTheory V2**: would need `lake exe dump_tactic_arrows` companion
that runs Frontend.processFile per `.lean` file and captures tactic AST.
Estimated 200-300 lines, MED risk.

### B. Attribute extension state (env-readable!)

Mathlib registers many lemmas via attributes (`@[simp]`, `@[aesop]`,
`@[gcongr]`, etc.).  These are stored in `EnvExtension` state, readable
from a pure `Environment` snapshot:

| Attribute | Extension | Usage |
|---|---|---|
| `@[simp]` | `Lean.Meta.simpExtension` | Read: `simpExtension.getState env` |
| `@[aesop]` | `Aesop.Frontend.attributeImpl.scopedExtension` | Read: `.getState env` |
| `@[gcongr]` | `Mathlib.Tactic.GCongr.gcongrExt` | Read: `.getState env` |
| `@[positivity]` | `Mathlib.Tactic.Positivity.positivityExt` | Same |
| `@[norm_num]` | `Mathlib.Tactic.NormNum.normNumExt` | Same |
| `@[fun_prop]` | `Mathlib.Tactic.FunProp.funPropExt` | Same |

Each gives a NEW arrow type `REGISTERED_FOR_<TACTIC>` from lemma → tactic-database.
This is SOTA for proof-retrieval embeddings (LeanDojo benchmark uses this signal).

### C. Equation lemma arrows (env-readable)

`Lean.getEqnsFor?` gives auto-generated equation lemmas for each `defnInfo`.
These provide `EQ_LEMMA_OF` arrows that distinguish "definition unfold via
its eq lemma" from "constant reference in body".

Estimated: 30 lines, LOW risk.

### D. Universe-aware arrow typing (env-readable)

Current `parametrizes_levels` captures level params (e.g., `u`, `v`).
SOTA: capture which arrows DEPEND on which level params, e.g., a theorem
in `Type u` parametrizes its `applies` targets at that universe.

Estimated: 50 lines, LOW risk.

### E. Tactic call graph (env-readable via attribute extensions)

Aggregate of B above: build a "tactic registry graph" where each tactic
node points to all its registered lemmas. This becomes a first-class
edge type that supports tactic-aware retrieval queries.

## Recommended implementation order

**Highest ROI: Phase 1 (Quick wins, 3-5 fires total)**:
1. `REGISTERED_FOR_SIMP` arrow — lookup `simpExtension.getState env` (~50 lines)
2. `REGISTERED_FOR_AESOP` arrow — same pattern (~50 lines)
3. `REGISTERED_FOR_GCONGR/POSITIVITY/NORM_NUM/FUN_PROP` — same pattern, batch (~100 lines)
4. `EQ_LEMMA_OF` arrow — `Lean.getEqnsFor?` (~30 lines)

After Phase 1: 17 arrow types (15 V3 + 2 NEW for tactic registries).
Coverage: 14/15 of V3 (still missing OPENS_NAMESPACE).

**Phase 2 (Tactic-aware, ~3 fires)**:
5. `dump_tactic_arrows` companion — Frontend.processFile pass capturing
   `REWRITES_BY`, `APPLIED_AS`, `SPECIALIZES_AS` use-sites (~250 lines)

After Phase 2: 20+ arrow types. Coverage: 15/15 V3.

**Phase 3 (Embedding-derived, post-build)**:
6. `SUGGESTED_BY` first-class arrow — promote `find_similar` results
   to graph edges with similarity score property (~50 lines, Cypher)

## Estimated graph size impact

Current: ~7.65M typed edges (per project status).
After Phase 1: ~10-12M edges (simp registry adds ~30% volume).
After Phase 2: ~15-18M edges.
After Phase 3: ~17-20M edges.

Each phase improves retrieval quality (tactic-aware retrievers per
LeanDojo benchmark show 15-25% R@10 improvement).

## Implementation files (proposed)

- `OmegaTheory/Meta/DumpTacticRegistries.lean` (NEW, Phase 1) — reads simp/aesop/etc.
- `OmegaTheory/Meta/DumpEqLemmas.lean` (NEW, Phase 1) — reads getEqnsFor?
- `OmegaTheory/Meta/DumpTacticArrows.lean` (NEW, Phase 2) — Frontend.processFile pass
- Update `.neo4j/load_arrows_parallel.py` for new arrow types
- Update LeanAlgebra schema arrows: 15 → 17 (Phase 1) → 20+ (Phase 2)

## References

- LeanDojo 2025 paper: Premise Selection Benchmark
- Lean Copilot 2026 v0.1: tactic-aware retrieval
- Pantograph 2025: proof-state extraction
- Mathlib 4 v4.29.0: attribute extension APIs
- Existing OV2: DumpArrows.lean (Sheratan/Larawag 2026-04-19+25)
