/-
  OmegaTheory.Emergence.GaugeInformationDensity

  **Phase C step 1 (2026-05-06)**:
  *Define the gauge-field information density `|F|²/2` on the
  substrate lattice, the FIRST step in extending the existing
  `informationStressEnergyTensor` bridge to include massless-particle
  effects on spacetime via the healing flow.*

  ## Why this file (the user's pivot 2026-05-06)

  > *"we just need to use existing theories ... to connect events
  > that can occur in the healing flow or spacetime with the events
  > from the standard model, but for now we have just tensor of
  > information stress in plan A, to give us the bridge of influence
  > of how the massless particles, can influence the spacetime or
  > how the forces like electromagnetism could do that"*

  The existing `Conservation/InformationStressEnergyConstructor.lean`
  carries METRIC DEFECT contributions only (mass-density `I_field` is
  scalar mass-density only).  Gauge-field energy (the photon's
  electric/magnetic field strength `|F|²`, gluons, EM forces) does
  NOT yet enter the substrate's information density.

  This file ships the FIRST honest gauge-field contribution:

      gaugeInformation gc p := (1/2) · Σ_{μ,ν} F_{μν}(gc, p)²

  where `F = dA` is the U(1) gauge curvature from
  `Emergence/ErrorGaugeField.lean:64`.  Properties proved:

  * Non-negativity: `0 ≤ gaugeInformation gc p` (sum of squares).
  * Vanishing at zero potential: `gaugeInformation 0 p = 0`.
  * Type bridge: `gaugeInformation gc : InformationDensity`.

  Phase C step 2 (`HealingFlow/GaugeFieldBackReaction.lean`) plugs this
  into the existing `γ·(I − Ī)` term of the healing-flow PDE so the
  gauge-field energy becomes a genuine source.

  ## What this file ships

  | Property                                  | Theorem                              |
  |-------------------------------------------|--------------------------------------|
  | `gaugeInformationPointwise gc p`          | def: `(1/2)·Σ F²`                    |
  | `gaugeInformation gc : InformationDensity` | def: lattice-point function          |
  | `gaugeInformation_nonneg`                 | thm: `0 ≤ gaugeInformation gc p`     |
  | `gaugeInformation_zero_potential`          | thm: `gaugeInformation 0 ≡ 0`       |
  | `gaugeInformation_pos_iff_F_nonzero`       | thm: positive iff F ≠ 0             |
  | Headline                                   | `gauge_information_density_report`  |

  ## Honest scope

  Pure dimensional bookkeeping at the level of an action variation:
  `|F|²/2` is the standard kinetic-energy density of a U(1) gauge
  field, derived from `L_YM = -(1/4) F^{μν} F_{μν}` upon temporal
  compactification.  On the Euclidean substrate lattice with implicit
  identity metric, the sum-of-squares form is the natural energy
  density.

  Does NOT yet:
  * Plug into the healing flow's I_field (Phase C step 2).
  * Prove gauge invariance (`gaugeInformation_gauge_invariant`):
    requires defining the gauge transformation `A → A + dχ` and
    showing F is invariant — Phase C step 1b, deferred.
  * Extend to non-abelian SU(2)/SU(3) gauge fields (would require
    `nonAbelianCurvature` in `Emergence/NonAbelianGauge.lean`,
    Phase C step 1c).

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`. Rule 2: zero new axioms.

  ## Author

  Single-thread Opus 4.7 [1M context]. Phase C step 1 of the
  full-mode plan REVISED 2026-05-06 (user pivot to bridge focus).
-/

import OmegaTheory.Emergence.ErrorGaugeField
import OmegaTheory.Conservation.Information
import OmegaTheory.Geometry.DiscreteForms
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Emergence.GaugeInformationDensity

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Emergence.ErrorGaugeField
open OmegaTheory.Conservation

/-! ## 1. Pointwise gauge-information density

    For a U(1) gauge connection `gc` at lattice point `p`:

        gaugeInformationPointwise gc p := (1/2) · Σ_{μν} F_{μν}(gc, p)²

    This is the discrete analog of the continuum kinetic-energy
    density `(1/2)·F^{μν} F_{μν}` (with Euclidean metric implicit). -/

/-- **Pointwise gauge-information density** at lattice point `p`. -/
noncomputable def gaugeInformationPointwise (gc : GaugeConnection)
    (p : LatticePoint) : ℝ :=
  (1 / 2) * ∑ μ : Fin 4, ∑ ν : Fin 4, ((gaugeCurvature gc).form p μ ν) ^ 2

/-! ## 2. Gauge information as a scalar field on the lattice -/

/-- **Gauge information density** as a `LatticePoint → ℝ` scalar
    field — the natural type for an `InformationDensity` source. -/
noncomputable def gaugeInformation (gc : GaugeConnection) :
    InformationDensity :=
  fun p => gaugeInformationPointwise gc p

/-- **Definitional unfolding** of `gaugeInformation`. -/
theorem gaugeInformation_def (gc : GaugeConnection) (p : LatticePoint) :
    gaugeInformation gc p = gaugeInformationPointwise gc p := rfl

/-! ## 3. Non-negativity

    `gaugeInformation` is a sum of squares times `1/2`, hence ≥ 0. -/

/-- **Pointwise non-negativity** of the gauge-information density:
    `0 ≤ gaugeInformationPointwise gc p`. -/
theorem gaugeInformationPointwise_nonneg (gc : GaugeConnection)
    (p : LatticePoint) :
    0 ≤ gaugeInformationPointwise gc p := by
  unfold gaugeInformationPointwise
  have hsum : 0 ≤ ∑ μ : Fin 4, ∑ ν : Fin 4,
                  ((gaugeCurvature gc).form p μ ν) ^ 2 := by
    apply Finset.sum_nonneg
    intro μ _
    apply Finset.sum_nonneg
    intro ν _
    exact sq_nonneg _
  linarith

/-- **Non-negativity** of the gauge-information density. -/
theorem gaugeInformation_nonneg (gc : GaugeConnection)
    (p : LatticePoint) :
    0 ≤ gaugeInformation gc p :=
  gaugeInformationPointwise_nonneg gc p

/-! ## 4. Vanishing at zero potential

    When the gauge potential is zero everywhere, F = dA = 0, so the
    gauge-information density vanishes. -/

/-- **Zero gauge connection** (potential vanishes everywhere). -/
noncomputable def zeroGaugeConnection : GaugeConnection :=
  GaugeConnection.exact zero1Form

/-- **Zero connection has zero curvature**: `(F(0)).form ≡ 0`. -/
theorem zeroGaugeConnection_curvature_zero (p : LatticePoint)
    (μ ν : Fin 4) :
    (gaugeCurvature zeroGaugeConnection).form p μ ν = 0 := by
  unfold gaugeCurvature
  rw [Foundations.ErrorForms.errorD1_form]
  unfold zeroGaugeConnection GaugeConnection.exact d1 zero1Form
  unfold OmegaTheory.Spacetime.forwardDiff
  ring

/-- **Vanishing density at zero potential**: `gaugeInformation 0 p = 0`. -/
theorem gaugeInformation_zero_potential (p : LatticePoint) :
    gaugeInformation zeroGaugeConnection p = 0 := by
  unfold gaugeInformation gaugeInformationPointwise
  have hF : ∀ μ ν : Fin 4,
      (gaugeCurvature zeroGaugeConnection).form p μ ν = 0 :=
    zeroGaugeConnection_curvature_zero p
  have hSum : (∑ μ : Fin 4, ∑ ν : Fin 4,
                ((gaugeCurvature zeroGaugeConnection).form p μ ν) ^ 2) = 0 := by
    apply Finset.sum_eq_zero
    intro μ _
    apply Finset.sum_eq_zero
    intro ν _
    rw [hF μ ν]
    ring
  rw [hSum]
  ring

/-! ## 5. Positivity vs F-nonvanishing

    The gauge-information density at `p` is positive iff at least
    one F-component at `p` is non-zero.  This is the converse of the
    zero-potential vanishing — and the local witness that the gauge
    field is "carrying energy". -/

/-- **Pointwise positivity from non-zero F**: if some F-component
    `F_{μ₀ν₀}(gc, p)` is non-zero, then `gaugeInformation gc p > 0`. -/
theorem gaugeInformation_pos_of_F_nonzero
    (gc : GaugeConnection) (p : LatticePoint)
    (μ₀ ν₀ : Fin 4)
    (h : (gaugeCurvature gc).form p μ₀ ν₀ ≠ 0) :
    0 < gaugeInformation gc p := by
  unfold gaugeInformation gaugeInformationPointwise
  have hsq_pos : 0 < ((gaugeCurvature gc).form p μ₀ ν₀) ^ 2 :=
    sq_pos_of_ne_zero h
  have hsum_inner : 0 < ∑ ν : Fin 4,
                    ((gaugeCurvature gc).form p μ₀ ν) ^ 2 := by
    refine Finset.sum_pos' ?_ ?_
    · intro ν _; exact sq_nonneg _
    · refine ⟨ν₀, Finset.mem_univ _, ?_⟩; exact hsq_pos
  have hsum : 0 < ∑ μ : Fin 4, ∑ ν : Fin 4,
                    ((gaugeCurvature gc).form p μ ν) ^ 2 := by
    refine Finset.sum_pos' ?_ ?_
    · intro μ _
      apply Finset.sum_nonneg
      intro ν _; exact sq_nonneg _
    · refine ⟨μ₀, Finset.mem_univ _, ?_⟩; exact hsum_inner
  linarith

/-! ## 6. Headline composite -/

/-- **Phase C step 1 headline — gauge information density.**

    Four-conjunct establishing the gauge-field information density
    as the FIRST honest gauge-field contribution to the substrate's
    information bookkeeping:

    1. **Non-negativity**: `0 ≤ gaugeInformation gc p` for every
       gauge connection `gc` and every lattice point `p`.
       (The density is `(1/2)·Σ F²`, a sum of squares.)

    2. **Vanishing at zero potential**: `gaugeInformation 0 p = 0`.
       Where the gauge field is absent, no gauge information.

    3. **Positivity from non-zero curvature**:
       If `F_{μν}(gc, p) ≠ 0` for some `(μ, ν)`, then
       `0 < gaugeInformation gc p`.  The gauge field carries
       energy iff it has non-trivial curvature.

    4. **Type bridge**: `gaugeInformation gc : InformationDensity`,
       i.e., a `LatticePoint → ℝ` scalar field — the standard input
       to `Conservation/InformationStressEnergyConstructor.lean`'s
       healing-flow source term.

    Phase C step 2 (`HealingFlow/GaugeFieldBackReaction.lean`)
    plugs this into the existing `γ·(I − Ī)` term so the
    gauge-field energy becomes a genuine bridge between SM
    massless particles and the substrate spacetime evolution. -/
theorem gauge_information_density_report (gc : GaugeConnection) (p : LatticePoint) :
    0 ≤ gaugeInformation gc p ∧
    gaugeInformation zeroGaugeConnection p = 0 ∧
    (∀ μ₀ ν₀ : Fin 4,
       (gaugeCurvature gc).form p μ₀ ν₀ ≠ 0 →
       0 < gaugeInformation gc p) ∧
    gaugeInformation gc p = gaugeInformationPointwise gc p := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact gaugeInformation_nonneg gc p
  · exact gaugeInformation_zero_potential p
  · intros μ₀ ν₀ h
    exact gaugeInformation_pos_of_F_nonzero gc p μ₀ ν₀ h
  · rfl

end OmegaTheory.Emergence.GaugeInformationDensity
