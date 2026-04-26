# NOTES — Cycle 61 Capricornus W3.5 — Iris (FermionQuantumNumbers isolation break)

**Date**: 2026-04-26
**Wizard**: Iris (asteroid 7 Iris, ~199 km, main-belt — Greek goddess of the rainbow)
**Wave**: cycle-61 Capricornus Phase B Wave 3 W3.5
**Brief**: Heart-Nebula NS N3 (rerank 0.88, HIGH) — `NS_FermionQuantumNumbers_isolation_break_via_SM_content_capstone`

## Outcome

**LANDED.** New file
`OmegaTheory/Emergence/FermionQuantumNumbersIsolationBreak.lean` (308 lines,
13 thm + 0 def). Single-module build **3,398 GREEN, 2.0s** on ~/lean-v2.
Full project build **4,048 GREEN — matches c61 baseline; zero downstream
regressions**. md5 `36d4e8f2dcdc4f96f706717e13fe666f` matches across
~/lean-v2 ↔ /mnt/c.

## Strategy

W1.7 Rosette already shipped the SM-content capstone
`FermionGeneration_composite_base_site_paper_bundle` in
`Predictions/FermionGenerationCompositeBaseSiteWitness.lean`. The 81 %
isolation of the `FermionQuantumNumbers` cluster (30/37 orphans) was the
*missing OUT-edge bundle* — the file's 33 hand-written declarations had
no APPLIES path into Rosette's capstone or the wave-F sterile-neutrino
bridges.

This file ships **one paper-citeable bundle + 8 sub-bundles** that cite,
by exact name, every primitive in `FermionQuantumNumbers.lean`:

| Bundle | Cites |
|--------|-------|
| `_hypercharge_sanity_bundle` | 6 `QN_*_Y_matches` |
| `_gell_mann_nishijima_bundle` | 8 `gell_mann_nishijima_*` |
| `_LR_consistency_bundle` | 4 `*_Q_consistent` |
| `_rep_cardinality_bundle` | `SU2Rep.card_eq` + `SU3Rep.card_eq` |
| `_rep_dim_bundle` | 4 `dim_*` simp lemmas |
| `_total_isospin_bundle` | `SU2Rep.totalIsospin` def |
| `_full_QN_bundle` | 6 `QN_*` defs (rfl on FullQuantumNumbers triples) |
| `_per_species_Q_bundle` | 8 `Q_*` defs (rfl on (T₃ + Y) form) |
| `_anomaly_consistency` | `generation_charge_sum_zero` |
| `_RH_singlet_charges` | `electric_charges_standard` |
| `_wave_F_bundle` | 4 wave-F bridges (Edasich 2026-04-24) |
| `_SM_content_capstone_bridge` | Rosette c61 W1.7 paper bundle |

Headline `NS_FermionQuantumNumbers_isolation_break_via_SM_content_capstone`
glues 5 of the above into a single 5-conjunct paper-citeable statement.
Frontier marker `_first_landing_in_V2`.

## Hit count

≥30 distinct hand-written declarations cited by exact name (all 6 `QN_*`,
all 8 `gell_mann_nishijima_*`, all 6 `QN_*_Y_matches`, all 4
`*_Q_consistent`, all 8 `Q_*`, `electric_charges_standard`,
`generation_charge_sum_zero`, all 4 wave-F bridges, plus the 4
`SU{2,3}Rep.dim_*` simp children + 2 `card_eq` lemmas) — **comfortably
clears the 30/37 orphan target** (≈ 81 % isolation → near-0 %).

Pattern mirrors Sirius c59 W16 `OperatorsCapstoneResidual` (151/151
declarations) and Pleione c60 W20 `OperatorsCapstoneResidualWave3` (~20+
new derivations) — same bundle-of-bundles structure, same
all-rfl/decide/norm_num discharge, same axiom footprint.

## Axioms

`#print axioms` on **9 main bundles + headline + frontier marker** =
`[propext, Classical.choice, Quot.sound]` ONLY (Lean core).

**Zero physics axioms.** No `Real.pi_transcendental` dependency. No
HermitePadé research axiom dependency. Closed-term rationals + `decide`
+ `rfl` on FullQuantumNumbers structure constructors only.

## Guardrails respected

NO edits to:
- `Emergence/FermionQuantumNumbers.lean` (target — READ-ONLY, IMPORT only)
- `Emergence/FermionContent.lean` (Mirach READ-ONLY)
- `Emergence/FermionHypercharge.lean` (Algieba READ-ONLY)
- `Predictions/FermionGenerationCompositeBaseSiteWitness.lean` (Rosette
  c61 W1.7 READ-ONLY — extends, doesn't edit)
- `Predictions/SterileNeutrinoFromFourthIrrational.lean` (Zosma READ-ONLY)
- W3.1 sister `FermionContentIsolationBreak.lean` (Triton in-flight,
  distinct namespace)
- All W1+W2 wave files (15 c61 wizards landed)
- All cycle 52-60 wizard files
- `Basic.lean` (parent owns batch — flagged below for parent)

## Basic.lean import line (parent owns batch)

```lean
import OmegaTheory.Emergence.FermionQuantumNumbersIsolationBreak
```

Suggested placement: with the other c61 cluster-isolation-break imports
(W3.1 Triton's FermionContent break, future W3.* siblings).

## Neo4j

`:TheoremCandidate NS_FermionQuantumNumbers_isolation_break_via_SM_content_capstone`
to be flipped PROPOSED → CLOSED_BY_LEAN_LANDING (parent / refresh handles).

`:ReservedName Iris` claimed via local agent_memory (omega-orchestrator
claim_name MCP not invoked — auto mode + tool not present in current
session).
