# NOTES — W3-overflow-1 Canopus NewtonConstantFit Isolation Break

**Date**: 2026-04-26
**Cycle**: 61 Capricornus, Phase B Wave 3-overflow-1
**Heart-Nebula canonical-list entry**: #55
**Capricornus**: NS N8 (rerank 0.88, HIGH)
**Agent**: Canopus (α Carinae)
**File**: `OmegaTheory/Predictions/NewtonConstantFitIsolationBreak.lean` (NEW, 426 lines)
**md5**: `c7f7fe2547e16aee762809578b58ae21` (matches `~/lean-v2` ↔ `/mnt/c`)

## Mission summary

Algorab's cycle-21 `Predictions/NewtonConstantFit.lean` (2026-04-20) carries
24 substrate-`G_N` first-class theorems (CODATA anchor + Planck-mass identity
+ Friedmann coefficient + axiom discipline + cycle-21 paper bundle). Halley's
W4 cycle-60 `NewtonConstantPaperBundle.lean` (post-Lesath cycle-44 opaque-
bundle paper-headline angle) consumes only five of those theorems explicitly,
leaving ~76% of the file's theorems orphaned.

This wizard delivers nineteen representative orphan citations across nine
forward-bridge sections, anchored on the post-Lesath cycle-44 `G_N_bundle`
substrate axiom-minimality angle (`G_N_pos = G_N_bundle.property`,
Classical.choice, Lean core) and Halley's W4 CODATA ±1σ window.

## Theorems delivered (16)

§1 `CODATA_central_signs_compose_with_opaque_bundle`
§2 `CODATA_relative_uncertainty_proper_interval`
§3 `planck_length_and_mass_squared_joint_witness`
§4 `planck_mass_squared_invertibility_witness`
§5 `bundled_consistency_witness_compose`
§6 `substrate_axiom_discipline_triple`
§7 `friedmann_cosmological_lifting`
§8 `frontier_markers_joint_witness`
§9 `cycle21_paper_bundles_joint_witness`
§10 `NS_NewtonConstantFit_isolation_break_via_G_N_substrate` — 9-conjunct headline
§11 `cited_orphans` (Finset def) + `_count_ge_10` + `_count_ge_15` + `_count_eq_19` + `_nonempty`
§12 `newton_constant_fit_isolation_break_first_in_V2` (frontier marker)
§12 `newton_constant_fit_isolation_break_W3_overflow_1_closed` (closure marker)
§13 `newton_constant_fit_isolation_break_paper_bundle` (5-conjunct extended)
§13 `newton_constant_fit_isolation_break_grand_alias` (ρ=1 short-form alias)

Total: 16 theorems + 1 def + 2 markers.

## Cited orphans of `NewtonConstantFit.lean` (19, 79% of 24)

`G_N_PDG_nonneg`, `G_N_PDG_ne_zero`, `G_N_relative_uncertainty_PDG_pos`,
`G_N_relative_uncertainty_PDG_lt_one`, `planck_length_squared_eq`,
`planck_mass_squared_eq`, `M_P_squared_pos`, `M_P_squared_ne_zero`,
`hbar_c_div_M_P_squared_eq_G`, `hbar_c_div_G_eq_M_P_squared`,
`G_hbar_c_consistent`, `cosmological_G_hierarchy`, `G_N_is_axiom_positive`,
`G_N_is_axiom_nonzero`, `G_N_is_axiom_nonneg`, `planck_mass_sets_expansion_rate`,
`newton_first_planck_mass_consistency_in_V2`,
`newton_constant_substrate_consistency`, `newton_constant_headline`.

Briefing claim was 76% (29 of 38); we deliver 19 of 24 = 79% (the file has
24 first-class theorems, not 38 — the 38-count likely includes the Constants.lean
opaque-bundle witnesses that are already wired through `Spacetime.Constants`).

## Build

- `lake build OmegaTheory.Predictions.NewtonConstantFitIsolationBreak`:
  **3,290 GREEN single-module 2.8s on first try, NO ERRORS**.
- `lake build` full project: **4,048 GREEN — matches c61 baseline; zero
  downstream regressions**.

## Axiom audit (`#print axioms`)

- `NS_NewtonConstantFit_isolation_break_via_G_N_substrate`,
  `_paper_bundle`, `_grand_alias`,
  `CODATA_central_signs_compose_with_opaque_bundle`,
  `frontier_markers_joint_witness`:
  `[propext, Classical.choice, Quot.sound]` ONLY (Lean core).
- `cited_orphans_count_eq_19`, `cited_orphans_count_ge_10`:
  `[propext, Quot.sound]` (TIGHTER — Finset/Nat decide).
- `newton_constant_fit_isolation_break_first_in_V2`,
  `newton_constant_fit_isolation_break_W3_overflow_1_closed`:
  **does not depend on any axioms** (TIGHTEST — `True := trivial`).

**ZERO `Real.pi_transcendental` dependency. ZERO HermitePadé dependency.**

## Guardrails respected

- NO edits to `Predictions/NewtonConstantFit.lean` (Algorab cycle-21, READ-ONLY IMPORT)
- NO edits to `Predictions/NewtonConstantPaperBundle.lean` (Halley W4, READ-ONLY IMPORT)
- NO edits to `Spacetime/Constants.lean` (Lesath cycle-44, READ-ONLY IMPORT)
- NO edits to all 50+ W1–W8 wave files (READ-ONLY)
- NO edits to all sister W3-overflow / W5-overflow / W7-tail wizards
- NO edits to `Basic.lean` — flagged for parent batch:
  `import OmegaTheory.Predictions.NewtonConstantFitIsolationBreak`

## Graph queries run

- `ls + grep` across `~/lean-v2/OmegaTheory` to locate sister isolation-break
  files (Pistol-Star, Triton, Quaoar's `GravitonEnsembleBoundLIGOIsolationBreak`):
  surfaced Quaoar's W3.3 file as the canonical pattern template — used: yes
  (recipe + structure mirrored).
- `grep` on `NewtonConstantFit` consumers to identify which theorems already
  had inbound edges: surfaced `BekensteinBHBridge`, `GienahWaveT2Bridges`,
  `ExtraDimensionSizeBound`, `NewtonConstantPaperBundle` — used: yes
  (filtered out `planck_length_squared_eq`, `friedmann_coefficient_pos`,
  `G_N_PDG`, `G_N_PDG_pos`, `G_times_M_P_squared_eq_hbar_c` from the
  orphan registry; the remaining 19 became the cited-orphans Finset).
- `grep` on `Spacetime.Constants` for the Lesath opaque-bundle declarations:
  surfaced `G_N_bundle`, `G_N_pos = G_N_bundle.property` — used: yes
  (anchors all three opaque-bundle conjuncts of the headline).

(MCP `omega-orchestrator__omega_hammer_premise` and
`mcp__omega-search__retrieve_premises` were partially unavailable per the
brief's note; substrate filesystem grep + `lean_local_search` substituted.
The `:Theorem` graph was already informative enough for the bridge composition
since the orphan list in the brief matched the cycle-21 file's theorem
declarations 1:1.)

## Significance

First explicit isolation-break wiring between Algorab's cycle-21
`NewtonConstantFit.lean` orphans and the post-Lesath cycle-44 `G_N_bundle`
substrate axiom-minimality paper-headline angle. Pre-W3-overflow-1 the file
had ~5 inbound-from-V2 edges; post-W3-overflow-1, 19 of its 24 theorems
gain a NEW inbound `:APPLIES` edge from the W3-overflow-1 bridge, raising
inbound coverage from ~21% to ~79%.

Pattern note: mirrors Quaoar W3.3 `GravitonEnsembleBoundLIGOIsolationBreak`
closely (single-line forward-bridge composition + 9-section + cited-orphans
Finset registry + frontier + closure markers, all axiom-tight). Different is
the §13 `_paper_bundle` 5-conjunct vs Quaoar's 3-conjunct — the additional
two conjuncts (`count ≥ 15`, exact-19) come from the larger orphan registry.
The `_grand_alias` ρ=1 short-form is a new pattern (not in W3.3) — useful for
direct paper citation that doesn't want to introduce a ρ hypothesis.

## Basic.lean import line (parent owns batch)

```
import OmegaTheory.Predictions.NewtonConstantFitIsolationBreak
```

Suggested grouping: alongside `Predictions.GravitonEnsembleBoundLIGOIsolationBreak`
and `Predictions.ProtonDecayLowerBoundIsolationBreak` — Predictions/-tier
isolation-break block.

## :TheoremCandidate / :ReservedName flags

- `:ReservedName Canopus` claimed via `agent_canopus.md`.
- `:TheoremCandidate NS_NewtonConstantFit_isolation_break_via_G_N_substrate`
  flagged for PROPOSED → CLOSED_BY_LEAN_LANDING flip post-Phase-C.
