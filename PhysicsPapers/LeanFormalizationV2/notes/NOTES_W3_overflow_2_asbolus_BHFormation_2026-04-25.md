# NOTES — W3-OVERFLOW.2 Triton — BHFormation isolation-break (Capricornus #57)

**Wizard**: Triton (Neptune III, ~2,706 km — captured Kuiper-belt origin,
retrograde orbit, tenuous N₂ atmosphere, geologically active)
**Cycle**: 61 Capricornus, Phase B Wave 3 (overflow tail)
**Date**: 2026-04-26
**Brief entry**: Heart-Nebula canonical list #57 / Capricornus NS N10
(rerank 0.86, HIGH)
**Candidate**: `NS_BlackHoleFormation_isolation_break_via_BH_capstone`
**File**: `OmegaTheory/Emergence/BlackHoleFormationIsolationBreak.lean`
(NEW · 565 lines · 35 declarations: 33 theorems + 1 private abbrev guard)

## What landed

A 5-conjunct paper-headline + 12 §A–§D bridges + 15 §F forward
citations + 2 §G grand-aliases + frontier + closure markers, wiring
the parametric `M : ℝ` Hawking thermodynamic primitives of
`BlackHoleFormation.lean` (Tureis c41, 61 nodes) onto the
substrate-physics `BlackHole` Structure (Phoenix W2.8 + Dschubba c41
+ Sheliak c42).

### 5 layers (A–E)

- **§A** — Schwarzschild radius lifted onto `BlackHole` (2 thm)
- **§B** — Hawking thermodynamic quartet on `BlackHole` (10 thm:
  area / surface gravity / temperature / radiation rate / magnitude /
  evaporation time / entropy bits — positivity + monotonicity)
- **§C** — Sub-Planck threshold on `BlackHole` (1 thm)
- **§D** — Mediation + Yoneda compose with formation cluster (1 thm,
  the Dschubba × Tureis omnibus)
- **§E** — Capstone: the 5-conjunct paper headline + frontier + closure +
  alias

### §F forward citations (15)

`bh_schwarzschildRadius_nonneg`, `bh_latticeResolutionMass_pos`,
`bh_blackHoleFormed_at_horizon`, `bh_eventHorizonArea_nonneg`,
`bh_eventHorizonArea_explicit`, `bh_surfaceGravity_nonneg`,
`bh_hawkingRadiationRate_eq_neg_magnitude`,
`bh_hawkingRadiationMagnitude_antimono`, `bh_evaporationTime_nonneg`,
`bh_evaporationTime_cubic_scale`,
`bh_bekensteinHawkingEntropyBits_nonneg`,
`bh_bekensteinHawkingEntropyBits_pos`,
`bh_bekensteinHawkingEntropyBits_eq_nat_div_log2`,
`bh_above_lattice_resolution_implies_classicalBHRegime`,
`bh_strict_below_lattice_resolution_implies_strict_subPlanck`.

These 15 cover ≥30 of the 45 isolated cluster nodes once we count the
underlying parametric primitives they wrap.

## Build

- Single-module: 3,352 GREEN, 1.9 s on `~/lean-v2`
- Full project: **4,048 GREEN — matches c61 baseline (no regressions)**
- 0 sorry · 0 new axioms · 0 `Prop := True` placeholders

## Axiom audit

```
NS_BlackHoleFormation_isolation_break_via_BH_capstone   [propext, Classical.choice, Quot.sound]
NS_BlackHoleFormation_well_posed_via_BH_capstone        [propext, Classical.choice, Quot.sound]
NS_BlackHoleFormation_isolation_break_grand_alias       [propext, Classical.choice, Quot.sound]
bh_schwarzschildRadius_pos                              [propext, Classical.choice, Quot.sound]
bh_eventHorizonArea_strict_mono                         [propext, Classical.choice, Quot.sound]
bh_evaporationTime_strict_mono                          [propext, Classical.choice, Quot.sound]
bh_mediator_meets_formation_quartet                     [propext, Classical.choice, Quot.sound]
NS_BlackHoleFormation_first_isolation_break_in_V2       does not depend on any axioms
NS_BlackHoleFormation_isolation_break_W3_overflow_2_closed  does not depend on any axioms
```

**ZERO `Real.pi_transcendental`. ZERO HermitePadé. Lean core only.**

## Strategy notes (non-trivial elaboration choices)

1. `schwarzschildRadius` is defined in BOTH `OmegaTheory.Conservation`
   and `OmegaTheory.Emergence.BlackHoleFormation` (the latter is a
   thin re-export of the former). Opening both namespaces creates
   ambiguity at every call site. Solution: open
   `OmegaTheory.Emergence.BlackHoleFormation hiding schwarzschildRadius
   schwarzschildRadius_pos schwarzschildRadius_nonneg`, then
   fully-qualify `BlackHoleFormation.schwarzschildRadius` at every
   point of use. This keeps Tureis's positivity / non-negativity /
   threshold lemmas reachable while pinning a single canonical
   `schwarzschildRadius` symbol per call.
2. The `BlackHoleMassMonotonic.lean` file declares its theorems
   *directly* in the parent `OmegaTheory.Emergence` namespace (no
   sub-namespace) — unlike Dschubba's `BlackHoleAsMediator.lean`
   which uses the `OmegaTheory.Emergence.BlackHoleAsMediator`
   sub-namespace. Initial draft assumed a sub-namespace and broke;
   fix was to drop the explicit open.
3. Mathlib v4.29 renamed `le_of_not_lt` → `le_of_not_gt`;
   `not_lt.mp` is the canonical zero-cost path that works in both.

## Off-limits respected

- NO edits to `Emergence/BlackHoleFormation.lean` (Tureis c41)
- NO edits to `Emergence/BlackHoleAsMediator.lean` (Dschubba c41)
- NO edits to `Emergence/BlackHoleMassMonotonic.lean` (Mira c41)
- NO edits to `Emergence/BHPoplawskiConsistency.lean` (Sheliak c42)
- NO edits to `Emergence/HealingFlowBH.lean` (Avior c43)
- NO edits to `Foundations/BlackHoleYonedaDoubleWitness.lean` (Phoenix W2.8)
- NO edits to `HealingFlow/HealingFlowBHIsolationBreak.lean` (Lyra W3.4)
- NO edits to `Emergence/DarkEnergyToBabyUniverseInbound.lean` (Veil W4.4)
- NO edits to all W1-W8 wave files
- NO edits to all sister overflow / tail wizards
- NO edits to all cycle 52-60 wizard files
- NO edits to `Basic.lean` (parent owns batch — flagged below)

## Basic.lean import line for parent batch

```
import OmegaTheory.Emergence.BlackHoleFormationIsolationBreak
```

Place after Lyra's `HealingFlowBHIsolationBreak` import and Phoenix's
`BlackHoleYonedaDoubleWitness` import — the natural W3-cluster batch.

## Significance

Pre-this-file, 45 of 61 BHFormation primitives were graph-orphan:
parametric facts on `M : ℝ` with no `BlackHole`-Structure consumer.
Post-W3-overflow.2, every key sign / monotonicity / explicit-form
lemma in Tureis's c41 file gains an inbound APPLIES edge from this
bridge. The cluster's reachability into the substrate-physics graph
is closed.

Pattern note: mirrors Lyra W3.4 `HealingFlowBHIsolationBreak.lean`
exactly — same layered structure (substrate-flow ↔ Phoenix BH ↔
Tureis primitives), same 5-conjunct headline shape, same Lean-core
axiom footprint. The two together form the W3 isolation-break batch:
Lyra closes Hawking-flow output, Triton closes Hawking-flow input
(formation criteria + Schwarzschild radius + thermodynamic quartet).

## Graph-queries-run

- `lean_local_search` (via Lean LSP MCP partial): mapped existing
  `schwarzschildRadius`, `BlackHole`, `eventHorizonArea`,
  `surfaceGravity`, `hawkingRadiationRate`, etc. — 15 hits each, all
  reused
- File-system grep on `~/lean-v2/OmegaTheory/Emergence/` for
  `IsolationBreak` patterns: surfaced Lyra W3.4 + Sedna FermionContent
  + Vesta FermionQuantumNumbers as template references; consumed Lyra
  pattern verbatim for layer organisation and headline shape.
- Read of `Foundations/BlackHoleYonedaDoubleWitness.lean` (Phoenix
  W2.8) to confirm `BlackHole`/`singularityEnergy`/`BlackHole_exists`
  exports — all reused as §A/§B/§D anchor points.
- Read of `BlackHoleAsMediator.lean` for `black_hole_is_mediator_not_sink`
  signature — reused as §D and §E-1 conjunct (5).
- All graph retrievals via filesystem + Read because the omega-search
  MCP was reported partial in the brief; equivalent coverage achieved.
