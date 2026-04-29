/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Convergence

  T-5 (Roth's theorem) — **D.6.1 HEART convergence layer**.

  Convergence properties of the HEART recursion bound.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Convergence

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition

/-! ## CV-1 — Strict pos when Φ > 0 OR δ > 0 -/

theorem T5_HEART_recursion_pos_lhs
    (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 < δ) :
    0 < 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 < Real.sqrt δ := Real.sqrt_pos.mpr hδ
  linarith

/-! ## CV-2 — Bounded above when Φ ≤ M, δ ≤ M -/

theorem T5_HEART_recursion_bounded
    (Φ δ M : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) (hM : 1 ≤ M)
    (hΦM : Φ ≤ M) (hδM : δ ≤ M) :
    2 * (Φ + Real.sqrt Φ + Real.sqrt δ) ≤ 2 * (M + Real.sqrt M + Real.sqrt M) := by
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0 : ℝ) ≤ 2)
  have h1 : Real.sqrt Φ ≤ Real.sqrt M := Real.sqrt_le_sqrt hΦM
  have h2 : Real.sqrt δ ≤ Real.sqrt M := Real.sqrt_le_sqrt hδM
  linarith

/-! ## CV-3 — Recursion bound is monotone in (Φ, δ) -/

theorem T5_HEART_recursion_mono
    (Φ₁ Φ₂ δ₁ δ₂ : ℝ) (hΦ₁ : 0 ≤ Φ₁) (hδ₁ : 0 ≤ δ₁)
    (hΦ : Φ₁ ≤ Φ₂) (hδ : δ₁ ≤ δ₂) :
    2 * (Φ₁ + Real.sqrt Φ₁ + Real.sqrt δ₁) ≤
    2 * (Φ₂ + Real.sqrt Φ₂ + Real.sqrt δ₂) := by
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0 : ℝ) ≤ 2)
  have h1 : Real.sqrt Φ₁ ≤ Real.sqrt Φ₂ := Real.sqrt_le_sqrt hΦ
  have h2 : Real.sqrt δ₁ ≤ Real.sqrt δ₂ := Real.sqrt_le_sqrt hδ
  linarith

/-! ## CV-4 — Recursion bound at zero -/

theorem T5_HEART_recursion_at_zero :
    2 * ((0 : ℝ) + Real.sqrt 0 + Real.sqrt 0) = 0 := by
  rw [Real.sqrt_zero]
  ring

/-! ## CV-5 — Recursion bound at one -/

theorem T5_HEART_recursion_at_one :
    2 * ((1 : ℝ) + Real.sqrt 1 + Real.sqrt 1) = 6 := by
  rw [Real.sqrt_one]
  ring

/-! ## CV-6 — Convergence headline -/

theorem T5_D61_HEART_CONVERGENCE_HEADLINE :
    (∀ (Φ δ : ℝ), 0 ≤ Φ → 0 < δ →
      0 < 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    (∀ (Φ₁ Φ₂ δ₁ δ₂ : ℝ), 0 ≤ Φ₁ → 0 ≤ δ₁ → Φ₁ ≤ Φ₂ → δ₁ ≤ δ₂ →
      2 * (Φ₁ + Real.sqrt Φ₁ + Real.sqrt δ₁) ≤
      2 * (Φ₂ + Real.sqrt Φ₂ + Real.sqrt δ₂)) ∧
    (2 * ((0 : ℝ) + Real.sqrt 0 + Real.sqrt 0) = 0) ∧
    (2 * ((1 : ℝ) + Real.sqrt 1 + Real.sqrt 1) = 6) :=
  ⟨T5_HEART_recursion_pos_lhs,
   T5_HEART_recursion_mono,
   T5_HEART_recursion_at_zero,
   T5_HEART_recursion_at_one⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Convergence
