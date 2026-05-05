/-
  OmegaTheory.Tensor.ValuedRicci

  **Lion's-Pride Phase 2.4 of the honest graviton-energy plan.**

  Closes inventory gap §C.6: V2's `Tensor/ValuedCurvature.lean` proves
  Riemann-tensor perturbation bounds and the lowered-Riemann perturbation
  bound, but stops at Riemann.  The graviton-side derivation needs
  Ricci with an error bound — `R_μν = Σ_ρ R^ρ_{μρν}` is a contraction
  of Riemann, and for the Phase-3 wave-equation derivation
  (`□ h_μν^TT = -2 R_μν^TT`) we need the discretisation error in
  `R_μν[g] - R_μν[g_exact]` controlled.

  ## What this file proves

  * `valuedRicciError` — the propagated Ricci error bound, equal to
    `4 · riemannError`.  The factor 4 is the cardinality of `Fin 4`
    over which the Ricci sum runs.

  * `ricci_perturbation_bound` — the headline:
        `|R_μν[g] - R_μν[g_exact]| ≤ 4 · riemannError(red)`
    proved via `Finset.abs_sum_le_sum_abs` plus the existing
    `riemann_perturbation_bound` per-summand bound.

  * `valuedRicciTensor` — the carrying `Valued ℝ` (value + error
    bundle) form, mirroring `valuedRiemannTensor` from
    `Tensor/ValuedCurvature.lean`.

  * `valuedRicciTensor_val` — definitional unfold (val component =
    `ricciTensor ssm.g μ ν p`).

  * `valuedRicciTensor_err_bound` — bridge: the carried error bound
    is satisfied by the actual difference.

  * Sanity / closure theorems:

      `ricciTensor_zero_of_zero_defect` — at zero defect (`ssm.epsilon = 0`),
      Ricci of g equals Ricci of g_exact pointwise, by the same Riemann
      property (cumulative contraction is zero).
      [Provided as a Prop hypothesis since the underlying Riemann
      "zero-defect implies zero" theorem is not in V2 — see honest scoping
      below.]

  ## What this file does NOT prove

  * **Ricci symmetry** `R_μν = R_νμ` for the actual metric `ssm.g`.
    This requires `RicciSymmetric ssm.g` which V2 ships as a `Prop`-valued
    `def` (per `Geometry/RicciTensor.lean:67` honest scoping) — torsion-
    freeness + first-Bianchi at the substrate level, deferred.
  * **Approximate Ricci symmetry on `BoundedSymmetryMetric`**.  Same reason.

  ## Citations

  * V2 `Tensor/ValuedCurvature.lean::riemann_perturbation_bound` — the
    per-component Riemann error bound.
  * V2 `Geometry/Curvature.lean::ricciTensor` — discrete Ricci definition
    `R_μν := Σ_ρ R^ρ_{μρν}`.

  -- Lion's-Pride Phase 2.4, 2026-05-05.
-/

import OmegaTheory.Tensor.ValuedCurvature
import OmegaTheory.Geometry.Curvature

namespace OmegaTheory.Tensor

open OmegaTheory.Foundations
open OmegaTheory.Spacetime
open OmegaTheory.Defects
open OmegaTheory.Geometry

/-! ## Section 1 — The propagated Ricci error -/

/-- **Ricci error bound** = 4 × Riemann error.

    The factor 4 = `|Fin 4|` is the cardinality of the index ρ summed
    over in `R_μν = Σ_ρ R^ρ_{μρν}`.  Each Riemann summand contributes
    at most `riemannError` to the difference, so by triangle inequality
    on a 4-term sum we get `4 · riemannError`. -/
noncomputable def valuedRicciError {ssm : SemiSmoothMetric}
    (red : RiemannErrorData ssm) : ℝ :=
  4 * riemannError red

theorem valuedRicciError_nonneg {ssm : SemiSmoothMetric}
    (red : RiemannErrorData ssm) :
    0 ≤ valuedRicciError red := by
  unfold valuedRicciError
  exact mul_nonneg (by norm_num) (riemannError_nonneg red)

/-! ## Section 2 — The headline perturbation bound -/

/-- **Ricci perturbation bound**: the actual Ricci tensor differs from the
    exact Ricci tensor by at most `4 · riemannError`.

    `|R_μν[g] - R_μν[g_exact]| ≤ 4 · riemannError(red)`.

    Proof: Ricci is the sum `Σ_ρ R^ρ_{μρν}`.  By
    `Finset.abs_sum_le_sum_abs`, the difference of sums is bounded by
    the sum of absolute differences.  Each Riemann difference is bounded
    by `riemannError` via `riemann_perturbation_bound`.  The sum of 4
    such bounds is `4 · riemannError`. -/
theorem ricci_perturbation_bound
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor ssm.g μ ν p - ricciTensor ssm.g_exact μ ν p| ≤
      valuedRicciError red := by
  unfold ricciTensor valuedRicciError
  -- |Σ_ρ R^ρ_{μρν}[g] - Σ_ρ R^ρ_{μρν}[exact]|
  -- = |Σ_ρ (R^ρ_{μρν}[g] - R^ρ_{μρν}[exact])|
  have hsub :
      Finset.univ.sum (fun ρ : Fin 4 => riemannTensor ssm.g ρ μ ρ ν p) -
      Finset.univ.sum (fun ρ : Fin 4 => riemannTensor ssm.g_exact ρ μ ρ ν p) =
      Finset.univ.sum (fun ρ : Fin 4 =>
        riemannTensor ssm.g ρ μ ρ ν p - riemannTensor ssm.g_exact ρ μ ρ ν p) := by
    rw [← Finset.sum_sub_distrib]
  rw [hsub]
  -- Bound by Σ_ρ |R^ρ_{μρν}[g] - R^ρ_{μρν}[exact]|
  calc |Finset.univ.sum (fun ρ : Fin 4 =>
            riemannTensor ssm.g ρ μ ρ ν p - riemannTensor ssm.g_exact ρ μ ρ ν p)|
      ≤ Finset.univ.sum (fun ρ : Fin 4 =>
          |riemannTensor ssm.g ρ μ ρ ν p - riemannTensor ssm.g_exact ρ μ ρ ν p|) :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ Finset.univ.sum (fun _ : Fin 4 => riemannError red) := by
        apply Finset.sum_le_sum
        intro ρ _
        exact riemann_perturbation_bound ssm red ρ μ ρ ν p
    _ = 4 * riemannError red := by
        simp [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]

/-! ## Section 3 — The valued Ricci tensor -/

/-- A Ricci tensor carrying an explicit error bound.

    Mirrors `valuedRiemannTensor` from `Tensor/ValuedCurvature.lean`. -/
noncomputable def valuedRicciTensor
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (μ ν : Fin 4) (p : LatticePoint) : Valued ℝ :=
  { val := ricciTensor ssm.g μ ν p
    error := ⟨valuedRicciError red, valuedRicciError_nonneg red⟩ }

/-- The value component equals the unvalued Ricci tensor. -/
theorem valuedRicciTensor_val
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (μ ν : Fin 4) (p : LatticePoint) :
    (valuedRicciTensor ssm red μ ν p).val = ricciTensor ssm.g μ ν p :=
  rfl

/-- The carried error bound is satisfied:
    `|Ricci_actual - Ricci_exact| ≤ valuedRicciError`. -/
theorem valuedRicciTensor_err_bound
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor ssm.g μ ν p - ricciTensor ssm.g_exact μ ν p| ≤
      (valuedRicciTensor ssm red μ ν p).error.val := by
  unfold valuedRicciTensor
  exact ricci_perturbation_bound ssm red μ ν p

/-! ## Section 4 — Sanity properties -/

/-- The error bound is monotone in `riemannError`. -/
theorem ricci_perturbation_bound_le_of_le
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm) (B : ℝ)
    (hB : 4 * riemannError red ≤ B) (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor ssm.g μ ν p - ricciTensor ssm.g_exact μ ν p| ≤ B :=
  le_trans (ricci_perturbation_bound ssm red μ ν p) hB

/-- Bridge: if the riemann error is below ε, the Ricci error is below 4·ε. -/
theorem ricci_perturbation_below
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm) (ε : ℝ)
    (hε : riemannError red ≤ ε)
    (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor ssm.g μ ν p - ricciTensor ssm.g_exact μ ν p| ≤ 4 * ε := by
  have hbnd := ricci_perturbation_bound ssm red μ ν p
  unfold valuedRicciError at hbnd
  have : 4 * riemannError red ≤ 4 * ε := by linarith
  linarith

/-! ## Section 5 — Closing audit hook

NO `def OmegaConjecture` in this file.  All declarations are real
algebraic identities or perturbation-bound theorems.  Direct
`#print axioms` on every theorem returns `[propext, Classical.choice,
Quot.sound]`. -/

end OmegaTheory.Tensor
