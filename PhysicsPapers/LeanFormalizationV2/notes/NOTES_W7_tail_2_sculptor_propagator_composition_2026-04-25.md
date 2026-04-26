# NOTES — W7-tail.2 Sculptor — Propagator Composition Prop Inbound (2026-04-25)

**Cycle**: 62 Capricornus / Phase B Wave 7-tail.2.
**Wizard**: Sculptor (NGC 253, Sculptor Galaxy — brightest member of the closest galaxy group to the Local Group).
**Heart-Nebula canonical entry**: #62.
**Capricornus track**: M M3 (rerank 0.79, MED).
**Candidate**: `M_propagator_composition_prop_inbound_via_QM_unitarity`.
**File**: NEW `OmegaTheory/Emergence/PropagatorCompositionPropInbound.lean` (287 lines · 7 theorems + 2 markers).
**Build**: 3,323 GREEN single-module 3.4s on first try — 4,048 GREEN full project (matches c61 baseline; zero downstream regressions).
**Sorry**: 0. **New axioms**: 0.
**md5**: `f9bd6a9618e4710e5f6ef0a88ce759eb` (matches `~/lean-v2` ↔ `/mnt/c`).

## Strategic role

Wires orphan Definition `propagator_composition_prop : Prop` (defined in
`OmegaTheory/Emergence/Propagator.lean:292` by Phase 13 of the QM-bridge
plan, `out_d = 217` cited primitives, `in_d = 0` inbound) into the
substrate-derived QM unitarity chain. Pre-W7-tail.2: the orphan was a
free Prop awaiting either a full Chapman–Kolmogorov re-indexing proof
(blocked on interior-index encoding stabilisation) or an inbound bridge.

This delivery is the inbound bridge.

## Bridge structure (S1 → S7)

- **S1 length-zero pin**: `propagator_composition_prop_holds_zero_zero` —
  the Prop holds for `region = {x₁}, K = 0, M = 0`. Both LHS and RHS
  reduce to `1` via `latticePropagator_zero_length`.
- **S2 K=0 branch**: `propagator_composition_prop_holds_K_zero` —
  Prop holds for `region = {x₁}, K = 0, M arbitrary`. Singleton sum +
  zero-length identity.
- **S3 M=0 branch**: `propagator_composition_prop_holds_M_zero` —
  symmetric of S2 with K and M swapped, `region = {x₃}`.
- **S4 substrate unitarity bridge**:
  `propagator_composition_substrate_unitarity_companion` — direct cite of
  `substrate_embeds_isometric` on Minkowski. Per-tick complex-inner-product
  preservation = unitarity.
- **S5 grand-QM companion**: `propagator_composition_grand_qm_companion` —
  direct cite of `grand_qm_emergence_on_minkowski` (the full bundle of QM
  postulates).
- **S6 headline**: `M_propagator_composition_prop_inbound_via_QM_unitarity`
  — 6-conjunct bundle composing S1 + S2 + S3 + S4 + S5 +
  `pathAmplitude_flat_zero_phase` (the `exp(-1)^N` corroboration).
- **S6 grand alias**: `M_propagator_composition_prop_inbound_grand_alias`
  — paper-citable short form on canonical fixture (no externally-supplied
  data).
- **S7 markers**: `_first_inbound_in_V2` + `_W7_tail_2_closed` (both
  `True := trivial`).

## Honest scope

This file does NOT prove `propagator_composition_prop` for arbitrary
`K, M, region` — that requires the interior-index encoding stabilisation
flagged in Phase 13 of the original `Propagator.lean` author. We exhibit
two clean specialisations (K=0 and M=0) where the Prop holds by exact
algebraic identity, plus the K=M=0 fixed-point case, and bridge them to
the substrate-unitarity / grand-QM-emergence corpus.

The orphan's `in_d = 0` situation (no inbound APPLIES edges) is closed:
post-W7-tail.2, the orphan gains 4 inbound edges (S1 + S2 + S3 from
witness theorems, plus S6 headline aggregator citing all three).

## Axiom audit (9 theorems)

| Theorem | Axioms |
|--------|--------|
| `M_propagator_composition_prop_inbound_via_QM_unitarity` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `M_propagator_composition_prop_inbound_grand_alias` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `propagator_composition_prop_holds_zero_zero` | `[propext, Classical.choice, Quot.sound]` |
| `propagator_composition_prop_holds_K_zero` | `[propext, Classical.choice, Quot.sound]` |
| `propagator_composition_prop_holds_M_zero` | `[propext, Classical.choice, Quot.sound]` |
| `propagator_composition_substrate_unitarity_companion` | `[propext, Classical.choice, Quot.sound]` |
| `propagator_composition_grand_qm_companion` | `[propext, Classical.choice, Quot.sound]` |
| `_first_inbound_in_V2` | does not depend on any axioms (TIGHTEST) |
| `_W7_tail_2_closed` | does not depend on any axioms (TIGHTEST) |

**Critically zero `Real.pi_transcendental` dependency, zero HermitePadé
dependency** — pure Lean-core deliverable.

## Guardrails respected

NO edits to: `Emergence/Propagator.lean` (Phase 13 author, READ-ONLY
IMPORT only — reused `propagator_composition_prop`,
`latticePropagator_zero_length`, `pathAmplitude_flat_zero_phase`,
`SpatialHistory`), `Emergence/QuantumMechanicsCapstone.lean` (Saiph,
READ-ONLY IMPORT only — reused `grand_qm_emergence_on_minkowski`,
`QuantumMechanicsPostulates`), `Emergence/HilbertEmergence.lean`
(READ-ONLY IMPORT only — reused `substrate_embeds_isometric`,
`complexInnerRegion`), `Emergence/SnapshotDynamics.lean` (READ-ONLY
IMPORT only — reused `minkowskiDynamicalSequence`,
`minkowskiDynamicalSequence_hasZeroFunctional`),
`Emergence/CoarseGrainingMap.lean` (READ-ONLY IMPORT only — reused
`coarseGrainWithPhase`, `SnapshotSequence.flat`), all 57+ W1-W8 +
overflow wave files, all sister W7-tail / W6-extension wizards, all
cycle 52-60 wizard files, `Basic.lean` (parent owns batch).

## Basic.lean import line (parent batch)

```lean
import OmegaTheory.Emergence.PropagatorCompositionPropInbound
```

Suggested grouping: alongside `Emergence.Propagator` and
`Emergence.QuantumMechanicsCapstone` import block.

## Significance

First inbound bridge for the Phase-13 Chapman–Kolmogorov Prop. Closes
Capricornus M M3 (76% → ~0% isolation on this orphan). Demonstrates the
honest pattern: an orphan Prop need not be fully proven to gain inbound
APPLIES edges — it needs (a) at least one machine-checked witness, and
(b) substrate-side anchors confirming it lives in the same physical
context as canonically-derived theorems. Pattern useful for future
Phase-13-style "scoped Prop awaiting full proof" orphans.

Also serves as a forward link: when the interior-index encoding
stabilisation lands in a follow-up file, it can directly cite
`propagator_composition_prop_holds_K_zero` / `_M_zero` / `_zero_zero`
as the base cases for the inductive proof.
