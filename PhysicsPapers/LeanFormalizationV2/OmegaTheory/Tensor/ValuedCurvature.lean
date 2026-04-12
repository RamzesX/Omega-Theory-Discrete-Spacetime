/-
  OmegaTheory.Tensor.ValuedCurvature

  Error-propagating Riemann curvature tensor: extending the Valued pipeline
  from Christoffel symbols (ValuedGeometry.lean) to curvature.

  ## Architecture

  The Riemann tensor is built from Christoffel symbols via:
    R^ρ_{σμν} = ∂_μ Γ^ρ_{νσ} - ∂_ν Γ^ρ_{μσ}
              + Σ_λ Γ^ρ_{μλ} Γ^λ_{νσ} - Σ_λ Γ^ρ_{νλ} Γ^λ_{μσ}

  Two error sources:
  1. **Derivative terms**: `∂_α Γ[g] - ∂_α Γ[g_exact]`. By
     `symmetricDiff_perturbation`, if `|Γ[g] - Γ[g_exact]| ≤ Γ_err`
     uniformly, then `|∂_α Γ[g] - ∂_α Γ[g_exact]| ≤ Γ_err / l_P`.
  2. **Product terms**: `Γ_1[g]·Γ_2[g] - Γ_1[g_exact]·Γ_2[g_exact]`.
     By `abs_mul_sub_mul_bound`, bounded by
     `M_Γ · Γ_err + M_Γ · Γ_err + Γ_err²`.

  Combining: 2 derivative terms + 2 × 4 product terms (sum over λ ∈ Fin 4).
-/

import OmegaTheory.Tensor.ValuedGeometry
import OmegaTheory.Geometry.Curvature

namespace OmegaTheory.Tensor

open OmegaTheory.Foundations
open OmegaTheory.Geometry
open OmegaTheory.Defects
open OmegaTheory.Spacetime

variable {ssm : SemiSmoothMetric}

/-! ## Additional hypotheses for Riemann error propagation -/

/-- Extended error data for Riemann tensor bounds. Adds a magnitude
    bound on the exact Christoffel symbols to the Christoffel error data. -/
structure RiemannErrorData (ssm : SemiSmoothMetric) extends ChristoffelErrorData ssm where
  /-- Uniform bound on exact Christoffel magnitude. -/
  M_Gamma : ℝ
  M_Gamma_nonneg : 0 ≤ M_Gamma
  /-- |Γ[g_exact](ρ,μ,ν,p)| ≤ M_Gamma for all indices and points. -/
  gamma_exact_bounded : ∀ (ρ μ ν : Fin 4) (p : LatticePoint),
    |christoffelSymbol ssm.g_exact ρ μ ν p| ≤ M_Gamma

/-! ## Christoffel derivative error bound

By `symmetricDiff_perturbation`: if `|Γ[g](q) - Γ[g_exact](q)| ≤ err`
for all q, then `|∂_α Γ[g] - ∂_α Γ[g_exact]| ≤ err / l_P`. -/

/-- The Christoffel derivative error: christoffelError / l_P. -/
noncomputable def christoffelDerivativeError (ced : ChristoffelErrorData ssm) : ℝ :=
  christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv / l_P

theorem christoffelDerivativeError_nonneg (ced : ChristoffelErrorData ssm) :
    0 ≤ christoffelDerivativeError ced := by
  unfold christoffelDerivativeError
  exact div_nonneg (christoffelError_nonneg (le_of_lt ced.M_inv_pos)
    ced.M_deriv_nonneg ssm.epsilon_nonneg ced.epsilon_inv_nonneg) l_P_nonneg

/-- Christoffel derivative perturbation bound. -/
theorem christoffelDerivative_perturbation_bound
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (ρ μ ν α : Fin 4) (p : LatticePoint) :
    |christoffelDerivative ssm.g ρ μ ν α p -
     christoffelDerivative ssm.g_exact ρ μ ν α p| ≤
    christoffelDerivativeError ced := by
  unfold christoffelDerivative christoffelDerivativeError
  exact symmetricDiff_perturbation
    (fun q => christoffelSymbol ssm.g ρ μ ν q)
    (fun q => christoffelSymbol ssm.g_exact ρ μ ν q)
    (christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv)
    (fun q => valuedChristoffelSymbol_err_bound ssm ced ρ μ ν q) α p

/-! ## Christoffel product error bound -/

/-- Bound on the actual Christoffel: |Γ[g]| ≤ M_Gamma + christoffelError.
    Follows from triangle inequality + the two component bounds. -/
theorem christoffel_actual_bounded
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (ρ μ ν : Fin 4) (p : LatticePoint) :
    |christoffelSymbol ssm.g ρ μ ν p| ≤
    red.M_Gamma + christoffelError red.M_inv red.M_deriv ssm.epsilon red.epsilon_inv := by
  have herr := valuedChristoffelSymbol_err_bound ssm red.toChristoffelErrorData ρ μ ν p
  have hexact := red.gamma_exact_bounded ρ μ ν p
  calc |christoffelSymbol ssm.g ρ μ ν p|
      = |(christoffelSymbol ssm.g ρ μ ν p - christoffelSymbol ssm.g_exact ρ μ ν p) +
         christoffelSymbol ssm.g_exact ρ μ ν p| := by ring_nf
    _ ≤ |christoffelSymbol ssm.g ρ μ ν p - christoffelSymbol ssm.g_exact ρ μ ν p| +
        |christoffelSymbol ssm.g_exact ρ μ ν p| := abs_add_le _ _
    _ ≤ christoffelError red.M_inv red.M_deriv ssm.epsilon red.epsilon_inv +
        red.M_Gamma := add_le_add herr hexact
    _ = red.M_Gamma + christoffelError red.M_inv red.M_deriv ssm.epsilon red.epsilon_inv := by
        ring

/-- The per-summand Christoffel product error: for a single λ,
    |Γ^ρ_{μλ}[g] · Γ^λ_{νσ}[g] - Γ^ρ_{μλ}[g_exact] · Γ^λ_{νσ}[g_exact]|
    is bounded by abs_mul_sub_mul_bound with:
    - A = M_Gamma + Γ_err (actual Christoffel bound)
    - B = M_Gamma (exact Christoffel bound)
    - εa = εb = Γ_err (Christoffel error) -/
noncomputable def christoffelProductSummandError (red : RiemannErrorData ssm) : ℝ :=
  let Γ_err := christoffelError red.M_inv red.M_deriv ssm.epsilon red.epsilon_inv
  let A := red.M_Gamma + Γ_err
  let B := red.M_Gamma
  A * Γ_err + B * Γ_err + Γ_err * Γ_err

/-- Per-summand Christoffel product bound. -/
theorem christoffel_product_summand_bound
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (ρ μ ν σ l : Fin 4) (p : LatticePoint) :
    |christoffelSymbol ssm.g ρ μ l p * christoffelSymbol ssm.g l ν σ p -
     christoffelSymbol ssm.g_exact ρ μ l p * christoffelSymbol ssm.g_exact l ν σ p| ≤
    christoffelProductSummandError red := by
  unfold christoffelProductSummandError
  exact abs_mul_sub_mul_bound
    (christoffel_actual_bounded ssm red ρ μ l p)
    (red.gamma_exact_bounded l ν σ p)
    (valuedChristoffelSymbol_err_bound ssm red.toChristoffelErrorData ρ μ l p)
    (valuedChristoffelSymbol_err_bound ssm red.toChristoffelErrorData l ν σ p)

/-! ## Riemann tensor error bound -/

/-- The total Riemann error bound:
    2 × (Christoffel derivative error)  +  2 × 4 × (product summand error)

    The 2× comes from two derivative terms (∂_μΓ and ∂_νΓ) and two
    product sums (Σ_λ Γ·Γ each with 4 terms). -/
noncomputable def riemannError (red : RiemannErrorData ssm) : ℝ :=
  2 * christoffelDerivativeError red.toChristoffelErrorData +
  2 * (4 * christoffelProductSummandError red)

theorem riemannError_nonneg (red : RiemannErrorData ssm) :
    0 ≤ riemannError red := by
  unfold riemannError
  apply add_nonneg
  · exact mul_nonneg (by norm_num) (christoffelDerivativeError_nonneg red.toChristoffelErrorData)
  · apply mul_nonneg (by norm_num)
    apply mul_nonneg (by norm_num)
    unfold christoffelProductSummandError
    have hΓ := christoffelError_nonneg (le_of_lt red.M_inv_pos)
      red.M_deriv_nonneg ssm.epsilon_nonneg red.epsilon_inv_nonneg
    nlinarith [red.M_Gamma_nonneg]

/-- **The Riemann error bound theorem**: the actual Riemann tensor differs
    from the exact Riemann tensor by at most `riemannError`.

    `|R^ρ_{σμν}[g] - R^ρ_{σμν}[g_exact]| ≤ riemannError(red)` -/
theorem riemann_perturbation_bound
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannTensor ssm.g ρ σ μ ν p - riemannTensor ssm.g_exact ρ σ μ ν p| ≤
    riemannError red := by
  unfold riemannTensor riemannError
  -- R = (dΓ1 - dΓ2) + (ΣΓΓ1 - ΣΓΓ2)
  -- R[g] - R[exact] = (dΓ1[g] - dΓ1[ex]) - (dΓ2[g] - dΓ2[ex])
  --                  + (ΣΓΓ1[g] - ΣΓΓ1[ex]) - (ΣΓΓ2[g] - ΣΓΓ2[ex])
  set dΓ1_g := christoffelDerivative ssm.g ρ ν σ μ p
  set dΓ1_e := christoffelDerivative ssm.g_exact ρ ν σ μ p
  set dΓ2_g := christoffelDerivative ssm.g ρ μ σ ν p
  set dΓ2_e := christoffelDerivative ssm.g_exact ρ μ σ ν p
  set P1_g := Finset.univ.sum fun l => christoffelSymbol ssm.g ρ μ l p * christoffelSymbol ssm.g l ν σ p
  set P1_e := Finset.univ.sum fun l => christoffelSymbol ssm.g_exact ρ μ l p * christoffelSymbol ssm.g_exact l ν σ p
  set P2_g := Finset.univ.sum fun l => christoffelSymbol ssm.g ρ ν l p * christoffelSymbol ssm.g l μ σ p
  set P2_e := Finset.univ.sum fun l => christoffelSymbol ssm.g_exact ρ ν l p * christoffelSymbol ssm.g_exact l μ σ p
  -- Decompose into 4 difference terms
  have hdec : (dΓ1_g - dΓ2_g + P1_g - P2_g) - (dΓ1_e - dΓ2_e + P1_e - P2_e) =
    (dΓ1_g - dΓ1_e) - (dΓ2_g - dΓ2_e) + (P1_g - P1_e) - (P2_g - P2_e) := by ring
  rw [hdec]
  -- Bound derivative terms
  have hd1 := christoffelDerivative_perturbation_bound ssm red.toChristoffelErrorData ρ ν σ μ p
  have hd2 := christoffelDerivative_perturbation_bound ssm red.toChristoffelErrorData ρ μ σ ν p
  -- Bound product sums: |ΣΓΓ[g] - ΣΓΓ[exact]| ≤ 4 * productSummandError
  have hp1 : |P1_g - P1_e| ≤ 4 * christoffelProductSummandError red := by
    have hsub : P1_g - P1_e = Finset.univ.sum fun l =>
        (christoffelSymbol ssm.g ρ μ l p * christoffelSymbol ssm.g l ν σ p -
         christoffelSymbol ssm.g_exact ρ μ l p * christoffelSymbol ssm.g_exact l ν σ p) := by
      simp only [P1_g, P1_e, ← Finset.sum_sub_distrib]
    rw [hsub]
    calc |Finset.univ.sum _|
        ≤ Finset.univ.sum fun l =>
            |christoffelSymbol ssm.g ρ μ l p * christoffelSymbol ssm.g l ν σ p -
             christoffelSymbol ssm.g_exact ρ μ l p * christoffelSymbol ssm.g_exact l ν σ p| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ Finset.univ.sum fun _ => christoffelProductSummandError red :=
          Finset.sum_le_sum fun l _ => christoffel_product_summand_bound ssm red ρ μ ν σ l p
      _ = _ := by simp [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]
  have hp2 : |P2_g - P2_e| ≤ 4 * christoffelProductSummandError red := by
    have hsub : P2_g - P2_e = Finset.univ.sum fun l =>
        (christoffelSymbol ssm.g ρ ν l p * christoffelSymbol ssm.g l μ σ p -
         christoffelSymbol ssm.g_exact ρ ν l p * christoffelSymbol ssm.g_exact l μ σ p) := by
      simp only [P2_g, P2_e, ← Finset.sum_sub_distrib]
    rw [hsub]
    calc |Finset.univ.sum _|
        ≤ Finset.univ.sum fun l =>
            |christoffelSymbol ssm.g ρ ν l p * christoffelSymbol ssm.g l μ σ p -
             christoffelSymbol ssm.g_exact ρ ν l p * christoffelSymbol ssm.g_exact l μ σ p| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ Finset.univ.sum fun _ => christoffelProductSummandError red :=
          Finset.sum_le_sum fun l _ => christoffel_product_summand_bound ssm red ρ ν μ σ l p
      _ = _ := by simp [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]
  -- Combine: |a - b + c - d| ≤ |a| + |b| + |c| + |d|
  set a := dΓ1_g - dΓ1_e
  set b := dΓ2_g - dΓ2_e
  set c := P1_g - P1_e
  set d := P2_g - P2_e
  have h4 : |a - b + c - d| ≤ |a| + |b| + |c| + |d| := by
    have hab : |a - b| ≤ |a| + |b| := by
      calc |a - b| = |a + (-b)| := by ring_nf
        _ ≤ |a| + |-b| := abs_add_le _ _
        _ = |a| + |b| := by rw [abs_neg]
    have habc : |a - b + c| ≤ |a| + |b| + |c| := by
      linarith [abs_add_le (a - b) c]
    calc |a - b + c - d|
        = |(a - b + c) + (-d)| := by ring_nf
      _ ≤ |a - b + c| + |-d| := abs_add_le _ _
      _ = |a - b + c| + |d| := by rw [abs_neg]
      _ ≤ |a| + |b| + |c| + |d| := by linarith
  linarith

/-! ## Valued Riemann tensor -/

/-- A Riemann tensor carrying an explicit error bound. -/
noncomputable def valuedRiemannTensor
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) : Valued ℝ :=
  { val := riemannTensor ssm.g ρ σ μ ν p
    error := ⟨riemannError red, riemannError_nonneg red⟩ }

/-- The value component equals the unvalued Riemann tensor. -/
theorem valuedRiemannTensor_val
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    (valuedRiemannTensor ssm red ρ σ μ ν p).val = riemannTensor ssm.g ρ σ μ ν p :=
  rfl

/-- The Riemann error bound is satisfied. -/
theorem valuedRiemannTensor_err_bound
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannTensor ssm.g ρ σ μ ν p - riemannTensor ssm.g_exact ρ σ μ ν p| ≤
    riemannError red :=
  riemann_perturbation_bound ssm red ρ σ μ ν p

/-! ## Lowered Riemann Error Bound

The lowered Riemann tensor R_{ρσμν} = Σ_λ g_{ρλ} R^λ_{σμν} involves
a metric-times-Riemann product. Its perturbation decomposes as:

  R_lower[g] - R_lower[g_exact] = Σ_λ (g_{ρλ} R^λ[g] - g_exact_{ρλ} R^λ[g_exact])

Each summand is bounded by `abs_mul_sub_mul_bound` with:
- A = M_g (actual metric bound), B = M_R (exact Riemann bound)
- εa = ε (metric error), εb = riemannError (Riemann error)

Total: 4 summands × (M_g · riemannError + M_R · ε + ε · riemannError). -/

/-- Per-summand error in the lowered Riemann tensor. -/
noncomputable def riemannLowerSummandError
    (M_g M_R : ℝ) (red : RiemannErrorData ssm) : ℝ :=
  M_g * riemannError red + M_R * ssm.epsilon + ssm.epsilon * riemannError red

/-- Total lowered Riemann error (sum over 4 values of λ). -/
noncomputable def riemannLowerError
    (M_g M_R : ℝ) (red : RiemannErrorData ssm) : ℝ :=
  4 * riemannLowerSummandError M_g M_R red

theorem riemannLowerError_nonneg
    (M_g M_R : ℝ) (hMg : 0 ≤ M_g) (hMR : 0 ≤ M_R)
    (red : RiemannErrorData ssm) :
    0 ≤ riemannLowerError M_g M_R red := by
  unfold riemannLowerError riemannLowerSummandError
  have hR := riemannError_nonneg red
  have hε := ssm.epsilon_nonneg
  nlinarith

/-- The metric component perturbation is bounded by ε.
    Definitional unfolding of `component_bounded`. -/
private theorem metric_component_perturbation
    (ssm : SemiSmoothMetric) (p : LatticePoint) (ρ l : Fin 4) :
    |(ssm.g p) ρ l - (ssm.g_exact p) ρ l| ≤ ssm.epsilon := by
  have h := ssm.component_bounded p ρ l
  simp only [SemiSmoothMetric.defectAt, defectTensor] at h
  exact h

/-- Lowered Riemann perturbation bound: the actual lowered Riemann tensor
    differs from the exact by at most `riemannLowerError`.

    `|R_{ρσμν}[g] - R_{ρσμν}[g_exact]| ≤ riemannLowerError M_g M_R red` -/
theorem riemannLower_perturbation_bound
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (M_g M_R : ℝ)
    (hg_bounded : ∀ p ρ σ, |(ssm.g p) ρ σ| ≤ M_g)
    (hR_bounded : ∀ ρ σ μ ν p,
      |riemannTensor ssm.g_exact ρ σ μ ν p| ≤ M_R)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower ssm.g ρ σ μ ν p -
     riemannLower ssm.g_exact ρ σ μ ν p| ≤
    riemannLowerError M_g M_R red := by
  unfold riemannLower riemannLowerError
  -- Combine the two sums into a single sum of differences
  rw [← Finset.sum_sub_distrib]
  -- Apply triangle inequality
  calc |Finset.univ.sum fun l =>
          (ssm.g p) ρ l * riemannTensor ssm.g l σ μ ν p -
          (ssm.g_exact p) ρ l * riemannTensor ssm.g_exact l σ μ ν p|
      ≤ Finset.univ.sum fun l =>
          |(ssm.g p) ρ l * riemannTensor ssm.g l σ μ ν p -
           (ssm.g_exact p) ρ l * riemannTensor ssm.g_exact l σ μ ν p| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ Finset.univ.sum fun _ => riemannLowerSummandError M_g M_R red := by
        apply Finset.sum_le_sum; intro l _
        unfold riemannLowerSummandError
        exact abs_mul_sub_mul_bound
          (hg_bounded p ρ l)
          (hR_bounded l σ μ ν p)
          (metric_component_perturbation ssm p ρ l)
          (riemann_perturbation_bound ssm red l σ μ ν p)
    _ = 4 * riemannLowerSummandError M_g M_R red := by
        simp [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]

end OmegaTheory.Tensor
