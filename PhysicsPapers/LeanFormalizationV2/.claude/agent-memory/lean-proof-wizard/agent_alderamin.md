---
name: Agent identity — Alderamin
description: Took Alderamin name 2026-04-19; Gacrux target #18 — new Spacetime/LightConeInclusion.lean: IsNullStep + lightCone set + headline lightCone ⊆ futureCone; full project GREEN 3653 jobs
type: project
---

# Agent Alderamin — Gacrux Target #18 (Light Cone Inclusion)

**Name origin**: α Cephei (Alderamin) — bright A-type star in Cepheus, one of
the future pole stars in Earth's precession cycle. Appropriate for a theorem
about causal future pointing along the time axis.

**Mission**: Formalize `OmegaTheory.Spacetime.causal_lattice_light_cone_inclusion` —
every lattice event's light cone ⊆ its causal future.

## What was added — new file

`OmegaTheory/Spacetime/LightConeInclusion.lean`

### Key definitions
- `IsNullStep p q` — `q 0 = p 0 + 1 ∧ ∃ i ≠ 0, |q i − p i| = 1 ∧ (∀ j ≠ 0, j ≠ i, q j = p j)`.
  A one-tick forward step that moves one unit along exactly one spatial axis.
  This is the discrete analogue of a continuum null-geodesic step
  (`|Δx⃗| = c · Δt` on a coordinate axis).
- `lightCone p : Set LatticePoint := { q | Relation.TransGen IsNullStep p q }`.
  Transitive closure of `IsNullStep` — every event reachable by a chain of null steps.

### Key theorems (all 0 sorry, 0 new axioms — standard `propext/Classical.choice/Quot.sound` only)
1. `null_step_is_causal_successor : IsNullStep p q → isCausalSuccessor p q` — the bridge lemma.
2. `timeCoord_null_step : IsNullStep p q → timeCoord p < timeCoord q`.
3. `mem_lightCone_of_null_step : IsNullStep p q → q ∈ lightCone p`.
4. Private helper `transGen_mono_of_impl` — monotonicity of TransGen under implication (could be a Mathlib lemma; kept private).
5. **`lightCone_subset_futureCone : lightCone p ⊆ futureCone p`** — main inclusion.
6. **`causal_lattice_light_cone_inclusion : lightCone p ⊆ futureCone p`** — headline alias.
7. `timeCoord_mono_on_lightCone : q ∈ lightCone p → timeCoord p < timeCoord q`.
8. `not_mem_own_lightCone : p ∉ lightCone p` (chronology protection restricted to null geodesics).
9. `lightCone_asymm : q ∈ lightCone p → p ∉ lightCone q`.
10. `lightCone_not_spacelike : q ∈ lightCone p → ¬ spacelikeSeparated p q`.

## API gaps noted for future work
- The `MassAsDelay` scope-flag note (line 328+) describes a *lattice-level*
  null-geodesic statement that would need `Snapshot.propagate` to take a
  direction parameter. Alderamin's `IsNullStep` lives at the raw
  `LatticePoint` layer and is independent of that refactor, but the two
  concepts could be bridged once `Snapshot.propagate` is generalized.
- `lightCone p` captures the future-directed half only. A past-light-cone
  analogue (reverse-direction null steps) is straightforward to add if
  needed — pattern would mirror `pastCone` vs `futureCone`.
- `transGen_mono_of_impl` is a generic Mathlib-shaped lemma. If Mathlib ever
  ships it natively, it can be swapped in and the private helper removed.

## Build state
- Single-module build: GREEN (1 s).
- Full project build: GREEN at **3653 jobs** (baseline was 3651 — +2 for new
  module + Basic re-elab).
- 0 `sorry`, 0 new axioms.
- `#print axioms causal_lattice_light_cone_inclusion` → only
  `[propext, Classical.choice, Quot.sound]`.
- Mirrored to chaos-shield `/mnt/c/.../LeanFormalizationV2/...`.

## Notes for next agent
The causal-lattice layer (`CausalLattice.lean`) already had excellent
infrastructure — `isCausalSuccessor`, `causalPrecedence` as `TransGen`,
`futureCone`, chronology protection — so the null-step refinement slots in
cleanly. The key insight: null steps are a *subset* of causal-successor
steps (they saturate exactly one spatial axis to 1 and leave the others at
0, which still satisfies the `|Δx_i| ≤ 1` bound of `isCausalSuccessor`).
This let the inclusion reduce to `TransGen` monotonicity over an implication.
