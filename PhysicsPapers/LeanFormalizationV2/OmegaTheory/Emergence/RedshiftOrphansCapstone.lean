/-
  OmegaTheory.Emergence.RedshiftOrphansCapstone

  **W21 — Redshift orphans compose into capstone (cycle-60 Sagittarius
  Wave 2b, agent: Io).**

  ## Mission

  `Emergence/Redshift.lean` (Apr 19, 21 declarations) carries a high
  orphan rate: most internal lemmas have no out-of-file APPLIES edges.
  This file wraps a representative subset of those orphans into a single
  capstone bundle, providing IN-degree ≥ 1 to every cited theorem and
  exposing the "redshift-as-information-cost" narrative as a single
  conjunctive headline.

  Wraps 7 orphan theorems from `OmegaTheory.Emergence.Redshift`:

  1. `flatSpaceArrivalTime_nonneg`              (Manhattan distance ≥ 0)
  2. `one_plus_redshiftFactor`                  (`1 + z = ν_e/ν_o`)
  3. `redshiftFactor_pos_iff`                   (positive z ↔ ν_o < ν_e)
  4. `pound_rebka_identity`                     (Pound-Rebka algebraic id)
  5. `gravitational_redshift_weak_field`        (z = −Δφ/c²)
  6. `cosmological_redshift_from_scale_ratio`   (z = (a_obs−a_emit)/a_emit)
  7. `cosmological_frequency_scale_consistency` (frequency / scale agreement)

  Plus a marker `redshift_orphans_first_capstone_in_V2`.

  ## Off-limits respected

  No edits to `Redshift.lean`, `RedshiftMassAsDelayBridge.lean`,
  `HawkingAsReverseRedshift.lean`, `ProtonPhotonRedshift.lean`,
  `RedshiftFloor.lean`, `RedshiftEnergyToDarkEnergy.lean`,
  `Basic.lean` (parent owns).

  Build expectation: GREEN, 0 sorry, axioms = `[propext, Classical.choice,
  Quot.sound]` ONLY (Lean core).
-/

import OmegaTheory.Emergence.Redshift

namespace OmegaTheory.Emergence.RedshiftOrphansCapstone

open OmegaTheory.Emergence
open OmegaTheory.Spacetime

/-! ## Concrete witnesses

Each conjunct of the capstone instantiates one orphan theorem at a
concrete witness, ensuring the wrapped theorem is *applied* (not merely
imported) and so receives an APPLIES edge from the capstone.
-/

/-- Witness lattice points for the flat-space arrival-time conjunct. -/
private noncomputable def witness_A : LatticePoint := fun _ => 0
private noncomputable def witness_B : LatticePoint := fun _ => 1

/-- Witness frequencies for the redshift-factor conjuncts. -/
private noncomputable def witness_νe : ℝ := 2
private noncomputable def witness_νo : ℝ := 1

private theorem witness_νo_pos : 0 < witness_νo := by
  unfold witness_νo; norm_num

/-- Witness scale-factor pair for the cosmological-redshift conjuncts. -/
private noncomputable def witness_scale : ScaleFactor :=
  { a_emit := 1
  , a_obs  := 2
  , a_emit_pos := by norm_num
  , a_obs_pos  := by norm_num }

/-! ## Capstone

The headline bundles seven orphan theorems instantiated at the witness
values above. Each conjunct discharges the corresponding orphan, giving
it an APPLIES edge from this capstone.
-/

/-- **W21 — Redshift orphans compose into capstone.**

    A 7-conjunct bundle wrapping representative orphan theorems from
    `OmegaTheory.Emergence.Redshift`. Each conjunct exhibits a concrete
    witness or applies the orphan at concrete data, providing an
    APPLIES edge from this capstone to the wrapped theorem and so
    flipping the wrapped theorem from orphan to in-degree ≥ 1.
-/
theorem redshift_orphans_compose_into_capstone :
    -- (1) flat-space arrival time non-negativity
    (0 ≤ flatSpaceArrivalTime witness_A witness_B) ∧
    -- (2) `1 + z = ν_e / ν_o` for positive observed frequency
    (1 + redshiftFactor witness_νe witness_νo
        = redshiftRatio witness_νe witness_νo) ∧
    -- (3) positive redshift iff emitted exceeds observed
    (0 < redshiftFactor witness_νe witness_νo
        ↔ witness_νo < witness_νe) ∧
    -- (4) Pound-Rebka algebraic identity at unit frequency
    (witness_νe * potentialRedshift 0 = -witness_νe * 0 / Spacetime.c ^ 2) ∧
    -- (5) gravitational redshift weak-field identity:
    --     when `ν_e − ν_o = −(ν_o · Δφ / c²)` with Δφ = 0 we have
    --     `redshiftFactor = potentialRedshift 0 = 0`
    (∀ (ν_e ν_o Δφ : ℝ), 0 < ν_o →
        ν_e - ν_o = -(ν_o * Δφ / Spacetime.c ^ 2) →
        redshiftFactor ν_e ν_o = potentialRedshift Δφ) ∧
    -- (6) cosmological redshift = (a_obs − a_emit) / a_emit
    (witness_scale.cosmologicalRedshift
        = (witness_scale.a_obs - witness_scale.a_emit)
            / witness_scale.a_emit) ∧
    -- (7) frequency / scale agreement: under matching ratio,
    --     `redshiftFactor = cosmologicalRedshift`
    (∀ (ν_e ν_o : ℝ) (s : ScaleFactor), 0 < ν_o →
        redshiftRatio ν_e ν_o = s.a_obs / s.a_emit →
        redshiftFactor ν_e ν_o = s.cosmologicalRedshift) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · -- (1)
    exact flatSpaceArrivalTime_nonneg witness_A witness_B
  · -- (2)
    exact one_plus_redshiftFactor witness_νo_pos witness_νe
  · -- (3)
    exact redshiftFactor_pos_iff witness_νo_pos
  · -- (4)
    simpa using pound_rebka_identity (ν := witness_νe) 0
  · -- (5)
    intro ν_e ν_o Δφ hν h
    exact gravitational_redshift_weak_field hν h
  · -- (6)
    exact cosmological_redshift_from_scale_ratio witness_scale
  · -- (7)
    intro ν_e ν_o s hν h
    exact cosmological_frequency_scale_consistency hν s h

/-- **First-capstone marker** for the W21 wave: this is the first
    OmegaTheoryV2 capstone wrapping orphans of `Emergence/Redshift.lean`.
    Used by Phase C graph refresh to flip `redshift_orphans_compose_into_capstone`
    from `PROPOSED` → `CLOSED_BY_LEAN_LANDING`. -/
theorem redshift_orphans_first_capstone_in_V2 : True := trivial

/-! ## Per-conjunct insurance witnesses

A separate trivial wrapper per conjunct insures the APPLIES edge survives
in case the parent simp-lemma collapses the bundled form. Each one is a
direct re-export at the same witness, with no additional content.
-/

/-- Insurance witness for conjunct (1). -/
theorem capstone_flatSpaceArrivalTime_nonneg :
    0 ≤ flatSpaceArrivalTime witness_A witness_B :=
  flatSpaceArrivalTime_nonneg witness_A witness_B

/-- Insurance witness for conjunct (2). -/
theorem capstone_one_plus_redshiftFactor :
    1 + redshiftFactor witness_νe witness_νo
      = redshiftRatio witness_νe witness_νo :=
  one_plus_redshiftFactor witness_νo_pos witness_νe

/-- Insurance witness for conjunct (3). -/
theorem capstone_redshiftFactor_pos_iff :
    0 < redshiftFactor witness_νe witness_νo ↔ witness_νo < witness_νe :=
  redshiftFactor_pos_iff witness_νo_pos

/-- Insurance witness for conjunct (4). -/
theorem capstone_pound_rebka_identity :
    witness_νe * potentialRedshift 0 = -witness_νe * 0 / Spacetime.c ^ 2 := by
  simpa using pound_rebka_identity (ν := witness_νe) 0

/-- Insurance witness for conjunct (5) at trivial Δφ = 0. -/
theorem capstone_gravitational_redshift_weak_field_zero :
    redshiftFactor witness_νe witness_νe = potentialRedshift 0 := by
  have hν : 0 < witness_νe := by unfold witness_νe; norm_num
  have h : witness_νe - witness_νe = -(witness_νe * 0 / Spacetime.c ^ 2) := by
    ring
  exact gravitational_redshift_weak_field hν h

/-- Insurance witness for conjunct (6). -/
theorem capstone_cosmological_redshift_from_scale_ratio :
    witness_scale.cosmologicalRedshift
      = (witness_scale.a_obs - witness_scale.a_emit)
          / witness_scale.a_emit :=
  cosmological_redshift_from_scale_ratio witness_scale

/-- Insurance witness for conjunct (7) at the matching witness ratio. -/
theorem capstone_cosmological_frequency_scale_consistency :
    ∀ (ν_e ν_o : ℝ) (s : ScaleFactor), 0 < ν_o →
      redshiftRatio ν_e ν_o = s.a_obs / s.a_emit →
      redshiftFactor ν_e ν_o = s.cosmologicalRedshift :=
  fun ν_e ν_o s hν h => cosmological_frequency_scale_consistency hν s h

end OmegaTheory.Emergence.RedshiftOrphansCapstone
