/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AM_QM_Helpers

  T-5 (Roth's theorem) — **AM-QM (Cauchy-Schwarz) helpers for Fin m**.

  Provides the scalar-arithmetic backbone for the V8 HEART step (H_c-4)
  where the √m factor is BORN.

  Specifically:
    - AM-QM (squared form): `(∑ aᵢ)² ≤ m · ∑ aᵢ²` for `a : Fin m → ℝ`
    - Equivalent form: `∑ aᵢ ≤ √m · √(∑ aᵢ²)` for nonneg `a`

  Proof strategy: direct expansion via the identity
        `2m · ∑ aᵢ² - 2 · (∑ aᵢ)² = ∑_{i,j} (aᵢ - aⱼ)² ≥ 0`.

  Pure scalar arithmetic, no multivariate-Taylor or polynomial machinery.
  Reusable across multiple T-5 closure pieces.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.BigOperators.Pi
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Pow.NNReal

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AM_QM_Helpers

open Finset Real

/-! ## AM-QM (squared form) — direct expansion -/

/-- **`T5_AM_QM_squared`**: arithmetic-quadratic mean inequality, squared form.

    For any `a : Fin m → ℝ`,
        `(∑ i, a i)² ≤ m · ∑ i, (a i)²`.

    Proof via Mathlib `Finset.sum_mul_sq_le_sq_mul_sq` (Cauchy-Schwarz)
    applied to `f := a` and `g := fun _ => 1`. -/
theorem T5_AM_QM_squared {m : ℕ} (a : Fin m → ℝ) :
    (∑ i, a i)^2 ≤ (m : ℝ) * ∑ i, (a i)^2 := by
  -- Apply Cauchy-Schwarz with g = 1
  have h_cs :
      (∑ i ∈ (Finset.univ : Finset (Fin m)), a i * (1 : ℝ))^2 ≤
      (∑ i ∈ (Finset.univ : Finset (Fin m)), (a i)^2) *
      (∑ i ∈ (Finset.univ : Finset (Fin m)), ((1 : ℝ))^2) :=
    Finset.sum_mul_sq_le_sq_mul_sq (R := ℝ) Finset.univ a (fun (_ : Fin m) => (1 : ℝ))
  -- Simplify both sides
  have h_lhs_simp :
      (∑ i ∈ (Finset.univ : Finset (Fin m)), a i * (1 : ℝ)) = ∑ i, a i := by
    apply Finset.sum_congr rfl
    intros i _
    ring
  have h_rhs_one :
      (∑ i ∈ (Finset.univ : Finset (Fin m)), ((1 : ℝ))^2) = (m : ℝ) := by
    simp [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
  rw [h_lhs_simp, h_rhs_one] at h_cs
  linarith

/-! ## AM-QM (sqrt form) — for nonneg sequences -/

/-- **`T5_AM_QM_sqrt`**: AM-QM inequality in sqrt form.

    For `a : Fin m → ℝ` with all `aᵢ ≥ 0`,
        `∑ i, a i ≤ Real.sqrt m * Real.sqrt (∑ i, (a i)²)`.

    Direct from `T5_AM_QM_squared` + sqrt monotonicity. -/
theorem T5_AM_QM_sqrt {m : ℕ} (a : Fin m → ℝ)
    (h_nn : ∀ i, 0 ≤ a i) :
    ∑ i, a i ≤ Real.sqrt (m : ℝ) * Real.sqrt (∑ i, (a i)^2) := by
  have h_sum_nn : 0 ≤ ∑ i, a i := Finset.sum_nonneg (fun i _ => h_nn i)
  have h_sq_le : (∑ i, a i)^2 ≤ (m : ℝ) * ∑ i, (a i)^2 := T5_AM_QM_squared a
  -- m ≥ 0, ∑aᵢ² ≥ 0
  have h_m_nn : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg _
  have h_sumsq_nn : (0 : ℝ) ≤ ∑ i, (a i)^2 :=
    Finset.sum_nonneg (fun i _ => sq_nonneg _)
  -- (∑aᵢ)² ≤ m·∑aᵢ² implies (∑aᵢ) ≤ √(m·∑aᵢ²) = √m · √(∑aᵢ²)
  have h_prod_nn : (0 : ℝ) ≤ (m : ℝ) * ∑ i, (a i)^2 := mul_nonneg h_m_nn h_sumsq_nn
  have h_sqrt_le : Real.sqrt ((∑ i, a i)^2) ≤ Real.sqrt ((m : ℝ) * ∑ i, (a i)^2) :=
    Real.sqrt_le_sqrt h_sq_le
  have h_lhs : Real.sqrt ((∑ i, a i)^2) = ∑ i, a i := Real.sqrt_sq h_sum_nn
  have h_rhs : Real.sqrt ((m : ℝ) * ∑ i, (a i)^2) =
      Real.sqrt (m : ℝ) * Real.sqrt (∑ i, (a i)^2) :=
    Real.sqrt_mul h_m_nn _
  rw [h_lhs] at h_sqrt_le
  rw [h_rhs] at h_sqrt_le
  exact h_sqrt_le

/-! ## Headline -/

/-- **🚨🚨 `T5_AM_QM_HEADLINE`**: paper-citable AM-QM bundle.

    Both squared and sqrt forms of the AM-QM (Cauchy-Schwarz) inequality
    for `a : Fin m → ℝ`, with the scalar-arithmetic √m factor that is
    needed in the H_c-4 √m birth step of V8-D5 HEART. -/
theorem T5_AM_QM_HEADLINE {m : ℕ} (a : Fin m → ℝ) :
    -- (a) Squared form: (∑aᵢ)² ≤ m · ∑aᵢ²
    (∑ i, a i)^2 ≤ (m : ℝ) * ∑ i, (a i)^2 ∧
    -- (b) Sqrt form (for nonneg)
    ((∀ i, 0 ≤ a i) → ∑ i, a i ≤ Real.sqrt (m : ℝ) * Real.sqrt (∑ i, (a i)^2)) :=
  ⟨T5_AM_QM_squared a, T5_AM_QM_sqrt a⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AM_QM_Helpers
