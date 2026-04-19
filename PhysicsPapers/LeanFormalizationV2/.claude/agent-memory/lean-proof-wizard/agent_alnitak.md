---
name: Agent identity — Alnitak
description: Took Alnitak name 2026-04-19 as hunter-T19; new Variational/DiscreteNoetherU1.lean with headline theorem + 4 sectoral corollaries + 2 closure lemmas for U(1) Noether on compact lattice patches; full project GREEN 3654 jobs
type: user
---

# Agent Alnitak — ζ Orionis (leftmost star of Orion's Belt)

Took the name **Alnitak** on 2026-04-19 as hunter-T19 on the Gacrux target
queue.  Mission: formalize `discrete_noether_u1_closed_on_compact_patches`
from `Variational/DiscreteNoether.lean` + `Variational/GraphAction.lean`.

## What I built

New file `OmegaTheory/Variational/DiscreteNoetherU1.lean` (mirrored to
`~/lean-v2` and `chaos-shield/PhysicsPapers/LeanFormalizationV2/`), with 9
theorems delivering the U(1) Noether statement on compact patches:

1.  `conserved_current_closed_on_compact_patch` — generic Noether identity:
    pointwise `IsConserved J` → `Σ_{p ∈ S} div(J)(p) = 0`.
2.  `u1_link_noether_closed_on_compact_patch` — U(1) charge current from
    two harmonic scalars (link current).
3.  `u1_maxwell_noether_closed_on_compact_patch` — U(1) Maxwell source
    current of an antisymmetric 2-form.
4.  `u1_maxwell_noether_from_potential_closed_on_compact_patch` — exact
    form `F = d₁A` special case.
5.  `discrete_noether_u1_closed_on_compact_patches` — **headline**: every
    `ConservedCurrent` summed over any `Finset LatticePoint` is zero.
6.  `discrete_noether_u1_closed_on_compact_patches_link` — sectoral
    corollary through `u1ChargeConservedCurrent`.
7.  `discrete_noether_u1_closed_on_compact_patches_maxwell` — sectoral
    corollary through `maxwellConservedCurrent`.
8.  `discrete_noether_u1_closed_on_compact_patches_exact` — through
    `maxwellFromAny A`.
9.  `discrete_noether_u1_closed_on_compact_patches_gauge` — through
    `Emergence.ErrorGaugeField.GaugeConnection` + `ε_source`.
10.  `discrete_noether_u1_closed_on_compact_patches_add` /
    `_smul` — linear-space closure through `addConservedCurrent` /
    `smulConservedCurrent`.

## Verification

- Single-file build: **PASS** (3327 jobs).
- Full project build: **PASS** (3654 jobs, up from 3651 baseline).
- `#print axioms discrete_noether_u1_closed_on_compact_patches` →
  `[propext, Classical.choice, Quot.sound, G_N, c, hbar]`.  No new axioms;
  only the core Lean prelude + 3 of the 8 project physical constants.
- 0 sorry added; the lone whole-project "sorry" match is a docstring hit
  in `Geometry/RiemannCurvature.lean` (pre-existing, not mine).
- Registered in `OmegaTheory/Basic.lean` at Layer 12, right after the
  general `DiscreteNoether` import.

## Design decisions

- **"Compact patches" modelled as `Finset LatticePoint`** — on `ℤ⁴` the
  lattice is discrete, so finite = bounded = compact; using `Finset`
  keeps the sum-form of the Noether identity direct.
- **The headline speaks about `ConservedCurrent`**, not a single concrete
  sector.  This pushes the meta-structure narrative from
  `NoetherMetaStructure.lean` into the variational namespace, and lets
  downstream files cite one lemma for every U(1) current built from the
  framework (link, Maxwell, gauge-connection, and their sums/rescalings).
- **Every proof is a one-step corollary** of either `linkCurrent_conserved`
  (scalar Noether), `maxwell_current_isConserved` (Maxwell via δ²=0),
  or `J.conserved` (the `ConservedCurrent` bundle), then
  `Finset.sum_eq_zero`.  No new tactical machinery required.

## API-gap note (for future hunters)

The `Variational/GraphAction.lean` infrastructure (weighted graphs,
Erdős-Lagrangian, path action) is NOT currently wired into the U(1)
conserved-current framework.  The variational + Noether integration
used here goes through `Conservation/Information.lean` +
`Conservation/NoetherMetaStructure.lean` + `Geometry/DiscreteMaxwell.lean`
— not through `graphAction` or `SatisfiesBellman`.  A genuine *graph*
Noether theorem (symmetry of the `graphLagrangian` → conservation of
an edge-based current) would be a separate future deliverable.  Hook:
prove that any edge-symmetry of `graphAction` descends to
`IsConserved` for the corresponding current; at that point the headline
here lifts verbatim.
