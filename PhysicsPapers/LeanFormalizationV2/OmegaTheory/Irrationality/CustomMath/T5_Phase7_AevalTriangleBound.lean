/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AevalTriangleBound

  T-5 (Roth's theorem) — **aeval triangle inequality** for multivariate
  polynomial expansion + sum bound.

  Provides:
    1. Triangle inequality on aeval expanded as monomial sum:
       `|aeval γ P| ≤ ∑ J ∈ P.support, |coeff P J| · ∏ |γ i|^{J i}`
    2. Same for shifted polynomial expansion (Taylor at α):
       `|aeval γ P| ≤ ∑ J ∈ (shiftPoly α P).support,
                       |(shiftPoly α P).coeff J| · ∏ |γ i - α i|^{J i}`

  These triangle bounds are the building blocks for H_c-4 (the √m birth
  step) — they convert the polynomial Taylor sum into a sum of factor
  bounds, which can then be combined with VC-9 and AM-QM.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm
import Mathlib.Algebra.BigOperators.Pi

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AevalTriangleBound

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

/-! ## ATB-1 — Triangle inequality on |aeval γ P| via direct sum -/

/-- **`T5_aeval_abs_le_sum_coeff_abs`**: triangle inequality on the
    monomial-sum expansion of |aeval γ P|.

    For `P : MvPolynomial (Fin m) ℝ` and `γ : Fin m → ℝ`,

        |aeval γ P| ≤ ∑ J ∈ P.support, |P.coeff J| · ∏ i ∈ J.support, |γ i|^{J i} -/
theorem T5_aeval_abs_le_sum_coeff_abs {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ) (γ : Fin m → ℝ) :
    |aeval γ P| ≤
      ∑ J ∈ P.support, |P.coeff J| * ∏ i ∈ J.support, |γ i| ^ (J i) := by
  -- Expand aeval γ P = ∑ J ∈ P.support, P.coeff J * ∏ i ∈ J.support, (γ i)^(J i)
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq]
  -- Apply triangle inequality on the sum
  have h_tri : |∑ J ∈ P.support,
      (algebraMap ℝ ℝ) (P.coeff J) * ∏ i ∈ J.support, γ i ^ (J i)| ≤
      ∑ J ∈ P.support, |(algebraMap ℝ ℝ) (P.coeff J) * ∏ i ∈ J.support, γ i ^ (J i)| :=
    Finset.abs_sum_le_sum_abs _ _
  refine le_trans h_tri ?_
  apply Finset.sum_le_sum
  intros J _
  -- |a · b| ≤ |a| · |b|, then for each factor in product
  rw [abs_mul]
  -- algebraMap ℝ ℝ is identity, so |algebraMap _| = |coeff|
  have h_alg : |(algebraMap ℝ ℝ) (P.coeff J)| = |P.coeff J| := by simp
  rw [h_alg]
  -- |∏ x| = ∏ |x|, then x^n ≤ |x|^n always (with equality for nonneg base)
  have h_prod_abs : |∏ i ∈ J.support, γ i ^ (J i)| =
      ∏ i ∈ J.support, |γ i ^ (J i)| := by
    rw [Finset.abs_prod]
  rw [h_prod_abs]
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  -- ∏ |γ i ^ (J i)| ≤ ∏ |γ i|^(J i) — equality via abs_pow
  apply le_of_eq
  apply Finset.prod_congr rfl
  intros i _
  exact abs_pow (γ i) (J i)

/-! ## ATB-2 — Triangle inequality on Taylor expansion at α -/

/-- **`T5_aeval_abs_taylor_at_alpha_bound`**: triangle bound on the
    Taylor expansion of |aeval γ P| at α (using `shiftPoly`).

        |aeval γ P| ≤ ∑ J ∈ (shiftPoly α P).support,
                        |(shiftPoly α P).coeff J| · ∏ i ∈ J.support, |γ i - α i|^{J i}

    Direct application of `T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional`
    (Taylor sum form) + ATB-1 (triangle on sum). -/
theorem T5_aeval_abs_taylor_at_alpha_bound {m : ℕ}
    (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ) (γ : Fin m → ℝ) :
    |aeval γ P| ≤
      ∑ J ∈ (shiftPoly α P).support,
        |(shiftPoly α P).coeff J| *
        ∏ i ∈ J.support, |γ i - α i| ^ (J i) := by
  -- Use Taylor sum form to write aeval γ P as sum
  have h_taylor := T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional α P γ
  -- Apply triangle on the resulting sum
  rw [h_taylor]
  -- |∑ J, c J · prod| ≤ ∑ J, |c J| · |prod|
  refine le_trans (Finset.abs_sum_le_sum_abs _ _) ?_
  apply Finset.sum_le_sum
  intros J _
  rw [abs_mul]
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  -- |∏ (γ-α)^J| = ∏ |γ-α|^J via abs_prod + abs_pow
  rw [Finset.abs_prod]
  apply le_of_eq
  apply Finset.prod_congr rfl
  intros i _
  exact abs_pow (γ i - α i) (J i)

/-! ## ATB-3 — Headline -/

/-- **🚨🚨 `T5_AEVAL_TRIANGLE_BOUND_HEADLINE`**: paper-citable triangle
    bound bundle.

    Both monomial-sum and Taylor-at-α triangle bounds for aeval, used in
    H_c-4 √m birth composition. -/
theorem T5_AEVAL_TRIANGLE_BOUND_HEADLINE {m : ℕ}
    (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ) (γ : Fin m → ℝ) :
    -- (a) Direct monomial-sum triangle bound
    (|aeval γ P| ≤
      ∑ J ∈ P.support, |P.coeff J| * ∏ i ∈ J.support, |γ i| ^ (J i)) ∧
    -- (b) Taylor-at-α triangle bound
    (|aeval γ P| ≤
      ∑ J ∈ (shiftPoly α P).support,
        |(shiftPoly α P).coeff J| *
        ∏ i ∈ J.support, |γ i - α i| ^ (J i)) :=
  ⟨T5_aeval_abs_le_sum_coeff_abs P γ, T5_aeval_abs_taylor_at_alpha_bound α P γ⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AevalTriangleBound
