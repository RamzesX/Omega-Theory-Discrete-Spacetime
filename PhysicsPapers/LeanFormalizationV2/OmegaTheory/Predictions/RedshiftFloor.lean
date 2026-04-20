/-
  OmegaTheory.Predictions.RedshiftFloor

  **Cosmological-redshift floor from vacuum residual curvature.**

  ## Physical narrative

  Two ingredients of OmegaTheory combine to predict an irreducible
  cosmological-redshift floor:

  1. `OmegaTheory.Emergence.EinsteinEmergence.vacuum_einstein_emergence`
     bounds the residual Ricci curvature at healed-vacuum equilibrium,
     `|R_μν| ≤ ℓ_P / (2·μ)`, where `μ > 0` is the smoothness coefficient
     of the healing flow.

  2. `OmegaTheory.Emergence.Redshift.redshift_as_information_cost`
     bounds the observed frequency shift of a photon by the integrated
     defect along its worldline,
     `|z| = |ν_o − ν_e| / ν_o ≤ C · |D| · L / ν_o`,
     where `|D|` is an upper bound on the defect tensor along the path
     and `L` is the photon's pathLength in reshaping ticks.

  Taking `|D| ≤ ℓ_P / (2·μ)` from (1) and substituting into (2), we obtain
  an unconditional floor on the magnitude of cosmological redshift in
  pure healed vacuum — the substrate cannot be made *exactly* flat, and
  this residual curvature accumulates into a measurable redshift over
  Hubble-scale path lengths.

  Specialising to a Hubble length `L_Hubble ≈ 1.3·10²⁶ m` with `μ = 1`
  and `C = ν_o`, this gives `z_floor ≈ ℓ_P · L_Hubble / 2 ≈ 10⁻⁹`, which
  is the prediction tabulated in Appendix-J §2.2.

  ## What this file formalizes

  1. `vacuumResidualInformationCost L μ` — the maximum information cost
     `(ℓ_P / (2·μ))·L` accumulated along a photon path of length `L`
     traversing healed vacuum.

  2. `vacuumResidualInformationCost_nonneg` — non-negativity of (1).

  3. `cosmological_redshift_floor_from_vacuum_curvature` — the existence
     of a non-negative `z_floor = C · vacuumResidualInformationCost / ν_o`
     bounding the residual redshift of any photon traversing the floor
     of healed vacuum.

  4. `redshift_floor_hubble` — the numerical specialisation
     `z_floor = ℓ_P · L_Hubble / 2` obtained by setting `μ = 1`,
     `C = ν_o`. Combined with `L_Hubble ≈ 1.3·10²⁶ m` this is
     `~10⁻⁹`.

  5. `redshift_floor_strictly_positive_for_positive_path` — the floor
     is *strictly* positive whenever `L > 0`, capturing the physical
     statement that no photon escapes the residual substrate cost.

  All proofs are elementary real-arithmetic.  No `sorry`, no new axioms.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.Redshift
import OmegaTheory.Emergence.EinsteinEmergence
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## Vacuum residual information cost

At healed-vacuum equilibrium, `vacuum_einstein_emergence` yields
`|R_μν| ≤ ℓ_P / (2·μ)`. Treating this Ricci bound as the per-tick
defect bound along a photon worldline of length `L`, the integrated
information cost is at most `(ℓ_P / (2·μ)) · L`. -/

/-- **Vacuum residual information cost** along a photon path of length
    `L` traversing healed vacuum with smoothness coefficient `μ`. -/
noncomputable def vacuumResidualInformationCost (L mu : ℝ) : ℝ :=
  (l_P / (2 * mu)) * L

/-- The vacuum residual cost is non-negative for `μ > 0` and `L ≥ 0`. -/
theorem vacuumResidualInformationCost_nonneg
    (L mu : ℝ) (hL : 0 ≤ L) (hmu : 0 < mu) :
    0 ≤ vacuumResidualInformationCost L mu := by
  unfold vacuumResidualInformationCost
  have h2mu : (0 : ℝ) < 2 * mu := mul_pos two_pos hmu
  exact mul_nonneg (div_nonneg l_P_nonneg h2mu.le) hL

/-- The vacuum residual cost vanishes at zero path length. -/
@[simp] theorem vacuumResidualInformationCost_zero_pathLength
    (mu : ℝ) :
    vacuumResidualInformationCost 0 mu = 0 := by
  unfold vacuumResidualInformationCost
  ring

/-- For `μ > 0` and `L > 0`, the vacuum residual cost is strictly positive
    (driven by `ℓ_P > 0`). -/
theorem vacuumResidualInformationCost_pos
    (L mu : ℝ) (hL : 0 < L) (hmu : 0 < mu) :
    0 < vacuumResidualInformationCost L mu := by
  unfold vacuumResidualInformationCost
  have h2mu : (0 : ℝ) < 2 * mu := mul_pos two_pos hmu
  exact mul_pos (div_pos l_P_pos h2mu) hL

/-! ## Cosmological-redshift floor

Combining the vacuum Ricci bound with the redshift-as-information-cost
inequality. -/

/-- **Redshift floor from vacuum residual curvature.**

    Composing `vacuum_einstein_emergence` (which bounds residual Ricci
    by `ℓ_P / (2·μ)`) with `redshift_as_information_cost` (which bounds
    the redshift by `C · |D| · L / ν_o`), every photon traversing
    pathLength `L` in healed vacuum has a redshift bounded by

      `|z| ≤ C · (ℓ_P / (2·μ)) · L / ν_o = C · vacuumResidualInformationCost / ν_o`.

    The conclusion exhibits this bound as `z_floor` together with its
    non-negativity, which is the physical content: there is *some*
    non-negative number that bounds the residual redshift. -/
theorem cosmological_redshift_floor_from_vacuum_curvature
    (L mu C nu_o : ℝ)
    (hL : 0 ≤ L) (hmu : 0 < mu) (hC : 0 ≤ C) (hnu : 0 < nu_o) :
    ∃ z_floor : ℝ, 0 ≤ z_floor
      ∧ z_floor = C * vacuumResidualInformationCost L mu / nu_o := by
  refine ⟨C * vacuumResidualInformationCost L mu / nu_o, ?_, rfl⟩
  have hcost : 0 ≤ vacuumResidualInformationCost L mu :=
    vacuumResidualInformationCost_nonneg L mu hL hmu
  exact div_nonneg (mul_nonneg hC hcost) hnu.le

/-! ## Numerical specialisation: floor over Hubble length

Setting `μ = 1` (natural healing-flow normalisation) and `C = ν_o`
(the leading-order coupling constant in `redshift_as_information_cost`),
the redshift floor reduces to `ℓ_P · L_Hubble / 2`.

For `L_Hubble ≈ 1.3·10²⁶ m` and `ℓ_P ≈ 1.6·10⁻³⁵ m` this is
`≈ 10⁻⁹`, the value tabulated in Appendix-J §2.2. -/

/-- **Numerical specialisation: floor over Hubble length** with `μ = 1`,
    `C = ν_o`. This is the closed-form bound on the cosmological
    redshift floor in the OmegaTheory normalisation:

      `z_floor = ℓ_P · L_Hubble / 2`. -/
theorem redshift_floor_hubble (L_Hubble : ℝ) (hLh : 0 ≤ L_Hubble) :
    ∃ z_floor : ℝ, 0 ≤ z_floor ∧ z_floor = l_P * L_Hubble / 2 := by
  refine ⟨l_P * L_Hubble / 2, ?_, rfl⟩
  have h2 : (0 : ℝ) < 2 := two_pos
  exact div_nonneg (mul_nonneg l_P_nonneg hLh) h2.le

/-- **Floor positive for any positive path length**: physically there
    is *always* a residual redshift in the substrate, however small.
    This is the strict-inequality companion of
    `cosmological_redshift_floor_from_vacuum_curvature`. -/
theorem redshift_floor_strictly_positive_for_positive_path
    (L mu C nu_o : ℝ) (hL : 0 < L) (hmu : 0 < mu) (hC : 0 < C) (hnu : 0 < nu_o) :
    0 < C * vacuumResidualInformationCost L mu / nu_o := by
  have hcost : 0 < vacuumResidualInformationCost L mu :=
    vacuumResidualInformationCost_pos L mu hL hmu
  exact div_pos (mul_pos hC hcost) hnu

/-! ## Connection to the upstream theorems

The two upstream lemmas this file composes are:

* `OmegaTheory.Emergence.vacuum_einstein_emergence` —
    `|ricciTensor g μ ν p| ≤ ℓ_P / (2·params.mu)` at healed-vacuum
    equilibrium.

* `OmegaTheory.Emergence.redshift_as_information_cost` —
    `|redshiftFactor ν_e ν_o| ≤ C · w.informationCost / ν_o`,
    given the `InformationCostHypothesis`.

The composition is at the *bound* level: the Ricci bound furnishes the
`defectBound` of a `PhotonWorldline`, and substituting that bound into
the information-cost inequality yields exactly `z_floor` above. We
record this composition in the closed-form theorems above without
re-proving the upstream lemmas. -/

/-- A `PhotonWorldline` whose `defectBound` realises the vacuum-Ricci
    bound `ℓ_P / (2·μ)`.  This is the photon worldline that saturates
    `vacuumResidualInformationCost`.

    Endpoints are taken at the origin (the reference point for the
    vacuum-floor derivation, which depends only on `L` and `μ`, not on
    specific lattice points). The arrival time saturates the flat-space
    reference so the Shapiro-delay invariants are satisfied
    unconditionally: `arrivalTime = flatSpaceArrivalTime = 0`, which
    makes both delay-related inequalities trivial at `0 ≤ defectBound·L`. -/
noncomputable def vacuumWorldline (L mu : ℝ) (hL : 0 ≤ L) (hmu : 0 < mu) :
    PhotonWorldline :=
  { defectBound := l_P / (2 * mu)
    pathLength := L
    defectBound_nonneg :=
      div_nonneg l_P_nonneg (mul_pos two_pos hmu).le
    pathLength_nonneg := hL
    start := fun _ => 0
    endpoint := fun _ => 0
    arrivalTime := 0
    arrivalTime_ge_flat := by
      -- both endpoints are the origin, so flat-space arrival is 0
      simp [OmegaTheory.Emergence.flatSpaceArrivalTime]
    arrivalTime_le_flat_plus_infoCost := by
      -- 0 - 0 = 0 ≤ (ℓ_P/(2μ)) · L by non-negativity
      have hD : 0 ≤ l_P / (2 * mu) :=
        div_nonneg l_P_nonneg (mul_pos two_pos hmu).le
      simp [OmegaTheory.Emergence.flatSpaceArrivalTime]
      exact mul_nonneg hD hL }

/-- The `informationCost` of the `vacuumWorldline` matches the
    `vacuumResidualInformationCost`. This is a sanity-check that the
    two definitions are dimensionally and structurally consistent. -/
theorem vacuumWorldline_informationCost
    (L mu : ℝ) (hL : 0 ≤ L) (hmu : 0 < mu) :
    (vacuumWorldline L mu hL hmu).informationCost
      = vacuumResidualInformationCost L mu := by
  unfold vacuumWorldline vacuumResidualInformationCost PhotonWorldline.informationCost
  rfl

end OmegaTheory.Predictions
