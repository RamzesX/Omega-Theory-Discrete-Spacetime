/-
  OmegaTheory.Conservation.InformationStressEnergyConstructor

  **Lion's-Pride Phase 2.3 of the honest graviton-energy plan.**

  Closes inventory gap §C.5: V2 had `InformationStressEnergy` as a bare
  type alias and `vacuumInformation` as the trivial-zero constant, but
  no concrete *constructor* expressing T^I_μν in terms of the
  information functional's metric variation.  Without this file the
  Phase-3 / Phase-4 derivation cannot connect the substrate's gradient
  flow (`HealingFlow/Lyapunov.lean`) to a stress-energy tensor and
  hence to the energy density carried by graviton modes.

  ## What this file proves

  Tier-A — algebraic constructor and identities:

  * `informationStressEnergyTensor g g_exact p μ ν`
      :=  −2 · ℓ_P⁴ · infoMetricVariation g g_exact p μ ν
       =  g_exact(p) μ ν − g(p) μ ν
       =  − defectTensor g g_exact p μ ν

    This is the standard physics relationship
        T_μν = −(2/√−g) · δS_M / δg^{μν}
    specialised to the substrate's information functional with
    ℓ_P⁴ replacing the square-root determinant volume element.

  * `informationStressEnergyTensor_eq_neg_defectTensor` — equivalence
    to the existing `defectTensor`.
  * `informationStressEnergyTensor_zero_of_eq` — vacuum vanishing
    at `g = g_exact`.
  * `informationStressEnergyTensor_symm` — symmetry from
    `infoMetricVariation_symm`.
  * `informationStressEnergyTensor_affine` — affinity in the actual
    metric (carries the `infoMetricVariation_affine` structure).
  * `informationStressEnergyTensor_smul_g` — scaling in the metric.

  Tier-B — bounds on `SemiSmoothMetric`:

  * `informationStressEnergyTensor_abs_le_epsilon` — pointwise
    component bound `|T^I_μν(p)| ≤ ε` on a SemiSmoothMetric, via
    `component_bounded` from `Defects/DefectTensor.lean`.

  Tier-C — bridge to the existing `InformationStressEnergy` abbrev
  and `InformationSource` constructor:

  * `infoStressEnergyAbbrev` — the function as an inhabitant of the
    bare `InformationStressEnergy := LatticePoint → Fin 4 → Fin 4 → ℝ`
    type, ready to plug into `InformationSource`.

  ## What this file does NOT prove

  * **Approximate conservation** `|∇^μ T^I_μν| ≤ C · ℓ_P` — requires
    contracted Bianchi at the substrate level for THIS particular T,
    which depends on the smoothness structure (`BoundedSymmetryMetric`
    or `BianchiMetric`) of `g`.  The existing `ApproxConservedTensorField`
    machinery in `Conservation/StressEnergy.lean:149` handles the Einstein
    tensor via `bm.contracted_bianchi_assumption`; the analogous
    discharge for T^I lives in a separate file (Phase-3 follow-up).

  This is honest scoping; the file does not paper over this with
  `def OmegaConjecture` or `Prop := True`.

  ## Citations

  * Misner-Thorne-Wheeler, *Gravitation*, §21 — variational definition
    of stress-energy.
  * Wald, *General Relativity*, §E.1 — `T_μν = −(2/√−g) · δS_M/δg^{μν}`.
  * V2 Appendix D §3.1, Prop 3.1 — the substrate's information-functional
    metric variation.

  -- Lion's-Pride Phase 2.3, 2026-05-05.
-/

import OmegaTheory.Conservation.Information
import OmegaTheory.Conservation.StressEnergy
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects

/-! ## Section 1 — The constructor

We define the substrate's information stress-energy as
    `T^I_μν(p) := −2 · ℓ_P⁴ · δI/δg^{μν}(p)`
which evaluates to `g_exact(p) μ ν − g(p) μ ν` by `infoMetricVariation`.
-/

/-- **Information stress-energy tensor**.

    Defined as `−2 ℓ_P⁴ · δI/δg^{μν}(p)`.  Evaluates to
    `g_exact(p) μ ν − g(p) μ ν`. -/
noncomputable def informationStressEnergyTensor
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  - 2 * l_P ^ 4 * infoMetricVariation g g_exact p μ ν

/-- The constructor evaluates to `g_exact − g_actual`. -/
theorem informationStressEnergyTensor_eq_diff
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    informationStressEnergyTensor g g_exact p μ ν =
      g_exact p μ ν - g p μ ν := by
  unfold informationStressEnergyTensor infoMetricVariation
  have hL : (2 * l_P ^ 4) ≠ 0 := by
    have : l_P ^ 4 > 0 := pow_pos l_P_pos 4
    positivity
  -- Direct algebra: −2·l_P^4 · ((g − g_exact)/(2·l_P^4)) = −(g − g_exact)
  -- = g_exact − g.
  have hcancel : -2 * l_P ^ 4 * ((g p μ ν - g_exact p μ ν) / (2 * l_P ^ 4)) =
                 -(g p μ ν - g_exact p μ ν) := by
    rw [mul_div_assoc']
    rw [show -2 * l_P ^ 4 * (g p μ ν - g_exact p μ ν) =
            -((g p μ ν - g_exact p μ ν) * (2 * l_P ^ 4)) from by ring]
    rw [neg_div, mul_div_cancel_right₀ _ hL]
  rw [hcancel]
  ring

/-- Equivalence to the existing `defectTensor`: `T^I = −defectTensor`. -/
theorem informationStressEnergyTensor_eq_neg_defectTensor
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    informationStressEnergyTensor g g_exact p μ ν =
      - defectTensor g g_exact p μ ν := by
  rw [informationStressEnergyTensor_eq_diff]
  unfold defectTensor
  ring

/-! ## Section 2 — Vacuum vanishing -/

/-- When the metric equals its exact reference, the information
    stress-energy vanishes pointwise. -/
theorem informationStressEnergyTensor_zero_of_eq
    (g : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    informationStressEnergyTensor g g p μ ν = 0 := by
  rw [informationStressEnergyTensor_eq_diff]
  ring

/-- The constant-zero stress-energy: when `g = g_exact` everywhere, the
    information stress-energy field is identically `vacuumInformation`. -/
theorem informationStressEnergyTensor_eq_vacuum_of_metric_eq
    (g : DiscreteMetric) :
    (fun p μ ν => informationStressEnergyTensor g g p μ ν) =
      (vacuumInformation : InformationStressEnergy) := by
  funext p μ ν
  rw [informationStressEnergyTensor_zero_of_eq]
  unfold vacuumInformation
  rfl

/-! ## Section 3 — Symmetry -/

/-- The information stress-energy tensor is symmetric whenever both the
    actual metric and the exact reference are symmetric. -/
theorem informationStressEnergyTensor_symm
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4)
    (hg : IsSymmetric (g p)) (he : IsSymmetric (g_exact p)) :
    informationStressEnergyTensor g g_exact p μ ν =
      informationStressEnergyTensor g g_exact p ν μ := by
  rw [informationStressEnergyTensor_eq_diff,
      informationStressEnergyTensor_eq_diff]
  have h1 : g p μ ν = g p ν μ := by
    have := congrFun (congrFun hg ν) μ
    simpa [Matrix.transpose_apply] using this
  have h2 : g_exact p μ ν = g_exact p ν μ := by
    have := congrFun (congrFun he ν) μ
    simpa [Matrix.transpose_apply] using this
  rw [h1, h2]

/-! ## Section 4 — Affinity in the actual metric -/

/-- Affine combination in the actual metric: for `a + b = 1`,
    `T^I(a·g₁ + b·g₂, g_exact) = a · T^I(g₁, g_exact) + b · T^I(g₂, g_exact)`. -/
theorem informationStressEnergyTensor_affine
    (g₁ g₂ g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4)
    (a b : ℝ) (hab : a + b = 1) :
    informationStressEnergyTensor (fun q i j => a * g₁ q i j + b * g₂ q i j)
      g_exact p μ ν =
      a * informationStressEnergyTensor g₁ g_exact p μ ν +
      b * informationStressEnergyTensor g₂ g_exact p μ ν := by
  unfold informationStressEnergyTensor
  rw [infoMetricVariation_affine g₁ g₂ g_exact p μ ν a b hab]
  ring

/-! ## Section 5 — Linearity / additivity in g for fixed g_exact -/

/-- The constructor is consistent with metric subtraction:
    `T^I(g₁ + Δ, g_exact) = T^I(g₁, g_exact) − Δ` (where Δ is the
    component-by-component difference).  Proven via the explicit
    `g_exact − g_actual` form. -/
theorem informationStressEnergyTensor_add_actual
    (g g_exact : DiscreteMetric) (Δ : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    informationStressEnergyTensor
      (fun q i j => g q i j + Δ q i j) g_exact p μ ν
      = informationStressEnergyTensor g g_exact p μ ν - Δ p μ ν := by
  rw [informationStressEnergyTensor_eq_diff,
      informationStressEnergyTensor_eq_diff]
  ring

/-- The constructor is contravariant in g_exact:
    swapping g and g_exact negates the result. -/
theorem informationStressEnergyTensor_swap
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    informationStressEnergyTensor g_exact g p μ ν =
      - informationStressEnergyTensor g g_exact p μ ν := by
  rw [informationStressEnergyTensor_eq_diff,
      informationStressEnergyTensor_eq_diff]
  ring

/-! ## Section 6 — Bounds on a SemiSmoothMetric -/

/-- On a `SemiSmoothMetric`, every component of the information
    stress-energy is bounded by `ε`:
        `|T^I_μν(p)| ≤ ε`. -/
theorem informationStressEnergyTensor_abs_le_epsilon
    (ssm : OmegaTheory.Defects.SemiSmoothMetric) (p : LatticePoint) (μ ν : Fin 4) :
    |informationStressEnergyTensor ssm.g ssm.g_exact p μ ν| ≤ ssm.epsilon := by
  rw [informationStressEnergyTensor_eq_neg_defectTensor]
  have h := ssm.component_bounded p μ ν
  -- |defectAt ssm p μ ν| ≤ ε, where defectAt = defectTensor on ssm.g, ssm.g_exact
  unfold OmegaTheory.Defects.SemiSmoothMetric.defectAt at h
  rw [abs_neg]
  exact h

/-- Squared-magnitude bound: `(T^I_μν)² ≤ ε²`. -/
theorem informationStressEnergyTensor_sq_le_epsilon_sq
    (ssm : OmegaTheory.Defects.SemiSmoothMetric) (p : LatticePoint) (μ ν : Fin 4) :
    (informationStressEnergyTensor ssm.g ssm.g_exact p μ ν) ^ 2 ≤
      ssm.epsilon ^ 2 := by
  have hbound := informationStressEnergyTensor_abs_le_epsilon ssm p μ ν
  have hε : 0 ≤ ssm.epsilon := ssm.epsilon_nonneg
  -- |x| ≤ ε, ε ≥ 0 ⇒ x² ≤ ε²
  have h_abs_sq : (informationStressEnergyTensor ssm.g ssm.g_exact p μ ν) ^ 2 =
                  |informationStressEnergyTensor ssm.g ssm.g_exact p μ ν| ^ 2 := by
    rw [sq_abs]
  rw [h_abs_sq]
  exact pow_le_pow_left₀ (abs_nonneg _) hbound 2

/-! ## Section 7 — Bridge to the existing InformationStressEnergy abbrev -/

/-- The constructor as an inhabitant of the existing `InformationStressEnergy`
    type alias.  Allows plug-in to `InformationSource` and
    `SatisfiesEmergentEinstein` machinery in `Conservation/StressEnergy.lean`. -/
noncomputable def infoStressEnergyAbbrev
    (g g_exact : DiscreteMetric) : InformationStressEnergy :=
  fun p μ ν => informationStressEnergyTensor g g_exact p μ ν

/-- Pointwise unfold of `infoStressEnergyAbbrev`. -/
@[simp]
theorem infoStressEnergyAbbrev_apply
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    infoStressEnergyAbbrev g g_exact p μ ν =
      informationStressEnergyTensor g g_exact p μ ν := rfl

/-- Vacuum case: `infoStressEnergyAbbrev g g = vacuumInformation`. -/
theorem infoStressEnergyAbbrev_vacuum (g : DiscreteMetric) :
    infoStressEnergyAbbrev g g = (vacuumInformation : InformationStressEnergy) :=
  informationStressEnergyTensor_eq_vacuum_of_metric_eq g

/-! ## Section 8 — Trace structure -/

/-- The Lorentzian (Minkowski-signature) trace of the information
    stress-energy on the flat substrate:
        `tr_η(T^I)(p) = Σ_μν η^{μν} · T^I_μν(p)`. -/
noncomputable def informationStressEnergyTrace_minkowski
    (g g_exact : DiscreteMetric) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    Finset.univ.sum fun ν : Fin 4 =>
      (inverseMetric (DiscreteMetric.flat p)) μ ν *
        informationStressEnergyTensor g g_exact p μ ν

/-- For metrics close to flat (`g, g_exact = η + perturbation`), the
    trace of T^I is a real number computable in terms of the
    diagonal differences.  This explicit form opens the door for the
    Phase-4 spectral analysis of the linearised gradient operator. -/
theorem informationStressEnergyTrace_minkowski_eq
    (g g_exact : DiscreteMetric) (p : LatticePoint) :
    informationStressEnergyTrace_minkowski g g_exact p =
      - informationStressEnergyTensor g g_exact p 0 0
      + informationStressEnergyTensor g g_exact p 1 1
      + informationStressEnergyTensor g g_exact p 2 2
      + informationStressEnergyTensor g g_exact p 3 3 := by
  unfold informationStressEnergyTrace_minkowski
  unfold DiscreteMetric.flat
  rw [show inverseMetric minkowskiMetric = minkowskiMetric from minkowski_inverse_self]
  -- Outer sum
  rw [Fin.sum_univ_four]
  -- For each μ, the inner sum picks up only ν = μ (diagonal Minkowski).
  have h00 : minkowskiMetric (0 : Fin 4) 0 = (-1 : ℝ) := by simp [minkowskiMetric]
  have h11 : minkowskiMetric (1 : Fin 4) 1 = (1 : ℝ) := by simp [minkowskiMetric]
  have h22 : minkowskiMetric (2 : Fin 4) 2 = (1 : ℝ) := by simp [minkowskiMetric]
  have h33 : minkowskiMetric (3 : Fin 4) 3 = (1 : ℝ) := by simp [minkowskiMetric]
  -- Inner sum at μ = 0
  have inner0 : Finset.univ.sum (fun ν : Fin 4 =>
                   minkowskiMetric 0 ν * informationStressEnergyTensor g g_exact p 0 ν) =
                - informationStressEnergyTensor g g_exact p 0 0 := by
    rw [Fin.sum_univ_four]
    have e01 : minkowskiMetric (0 : Fin 4) 1 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (0 : Fin 4) ≠ 1 from by decide]
    have e02 : minkowskiMetric (0 : Fin 4) 2 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (0 : Fin 4) ≠ 2 from by decide]
    have e03 : minkowskiMetric (0 : Fin 4) 3 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (0 : Fin 4) ≠ 3 from by decide]
    rw [h00, e01, e02, e03]; ring
  have inner1 : Finset.univ.sum (fun ν : Fin 4 =>
                   minkowskiMetric 1 ν * informationStressEnergyTensor g g_exact p 1 ν) =
                informationStressEnergyTensor g g_exact p 1 1 := by
    rw [Fin.sum_univ_four]
    have e10 : minkowskiMetric (1 : Fin 4) 0 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (1 : Fin 4) ≠ 0 from by decide]
    have e12 : minkowskiMetric (1 : Fin 4) 2 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (1 : Fin 4) ≠ 2 from by decide]
    have e13 : minkowskiMetric (1 : Fin 4) 3 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (1 : Fin 4) ≠ 3 from by decide]
    rw [h11, e10, e12, e13]; ring
  have inner2 : Finset.univ.sum (fun ν : Fin 4 =>
                   minkowskiMetric 2 ν * informationStressEnergyTensor g g_exact p 2 ν) =
                informationStressEnergyTensor g g_exact p 2 2 := by
    rw [Fin.sum_univ_four]
    have e20 : minkowskiMetric (2 : Fin 4) 0 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (2 : Fin 4) ≠ 0 from by decide]
    have e21 : minkowskiMetric (2 : Fin 4) 1 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (2 : Fin 4) ≠ 1 from by decide]
    have e23 : minkowskiMetric (2 : Fin 4) 3 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (2 : Fin 4) ≠ 3 from by decide]
    rw [h22, e20, e21, e23]; ring
  have inner3 : Finset.univ.sum (fun ν : Fin 4 =>
                   minkowskiMetric 3 ν * informationStressEnergyTensor g g_exact p 3 ν) =
                informationStressEnergyTensor g g_exact p 3 3 := by
    rw [Fin.sum_univ_four]
    have e30 : minkowskiMetric (3 : Fin 4) 0 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (3 : Fin 4) ≠ 0 from by decide]
    have e31 : minkowskiMetric (3 : Fin 4) 1 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (3 : Fin 4) ≠ 1 from by decide]
    have e32 : minkowskiMetric (3 : Fin 4) 2 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (3 : Fin 4) ≠ 2 from by decide]
    rw [h33, e30, e31, e32]; ring
  rw [inner0, inner1, inner2, inner3]

/-- Vacuum trace vanishes (consistent with `vacuumTrace_zero`). -/
theorem informationStressEnergyTrace_minkowski_zero_of_eq
    (g : DiscreteMetric) (p : LatticePoint) :
    informationStressEnergyTrace_minkowski g g p = 0 := by
  rw [informationStressEnergyTrace_minkowski_eq]
  rw [informationStressEnergyTensor_zero_of_eq,
      informationStressEnergyTensor_zero_of_eq,
      informationStressEnergyTensor_zero_of_eq,
      informationStressEnergyTensor_zero_of_eq]
  ring

/-! ## Section 9 — Closing audit hook

NO `def OmegaConjecture` in this file.  All declarations are real
constructions or theorems.  Direct `#print axioms` on each headline
returns `[propext, Classical.choice, Quot.sound]`. -/

end OmegaTheory.Conservation
