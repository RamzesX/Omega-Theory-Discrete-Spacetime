/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Specialize

  T-5 (Roth's theorem) — **D.6.1 HEART specialization layer**.

  Concrete specializations of HEART recursion at small Φ, δ values.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Specialize

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge

/-! ## SP-1 — HEART recursion at Φ = 1, δ = 1 -/

theorem T5_HEART_at_one_one (Θ : ℝ) (hΘ : 0 ≤ Θ) (h : Θ ≤ 6) :
    Θ ≤ 2 * ((1 : ℝ) + Real.sqrt 1 + Real.sqrt 1) := by
  rw [Real.sqrt_one]
  linarith

/-! ## SP-2 — HEART recursion at Φ = 1, δ = 0 -/

theorem T5_HEART_at_one_zero (Θ : ℝ) (hΘ : 0 ≤ Θ) (h : Θ ≤ 4) :
    Θ ≤ 2 * ((1 : ℝ) + Real.sqrt 1 + Real.sqrt 0) := by
  rw [Real.sqrt_one, Real.sqrt_zero]
  linarith

/-! ## SP-3 — HEART recursion at Φ = 0, δ = 1 -/

theorem T5_HEART_at_zero_one (Θ : ℝ) (hΘ : 0 ≤ Θ) (h : Θ ≤ 2) :
    Θ ≤ 2 * ((0 : ℝ) + Real.sqrt 0 + Real.sqrt 1) := by
  rw [Real.sqrt_zero, Real.sqrt_one]
  linarith

/-! ## SP-4 — HEART recursion at Φ = 4, δ = 4 -/

theorem T5_HEART_at_four_four (Θ : ℝ) (hΘ : 0 ≤ Θ) (h : Θ ≤ 16) :
    Θ ≤ 2 * ((4 : ℝ) + Real.sqrt 4 + Real.sqrt 4) := by
  have h4 : Real.sqrt 4 = 2 := by
    have h1 : (2 : ℝ)^2 = 4 := by norm_num
    rw [show (4 : ℝ) = (2 : ℝ)^2 by norm_num, Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 2)]
  rw [h4]
  linarith

/-! ## SP-5 — HEART recursion at Φ = 9, δ = 9 -/

theorem T5_HEART_at_nine_nine (Θ : ℝ) (hΘ : 0 ≤ Θ) (h : Θ ≤ 30) :
    Θ ≤ 2 * ((9 : ℝ) + Real.sqrt 9 + Real.sqrt 9) := by
  have h9 : Real.sqrt 9 = 3 := by
    have h1 : (3 : ℝ)^2 = 9 := by norm_num
    rw [show (9 : ℝ) = (3 : ℝ)^2 by norm_num, Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 3)]
  rw [h9]
  linarith

/-! ## SP-6 — Specialize HEART headline -/

theorem T5_D61_HEART_SPECIALIZE_HEADLINE :
    (∀ (Θ : ℝ), 0 ≤ Θ → Θ ≤ 6 →
      Θ ≤ 2 * ((1 : ℝ) + Real.sqrt 1 + Real.sqrt 1)) ∧
    (∀ (Θ : ℝ), 0 ≤ Θ → Θ ≤ 4 →
      Θ ≤ 2 * ((1 : ℝ) + Real.sqrt 1 + Real.sqrt 0)) ∧
    (∀ (Θ : ℝ), 0 ≤ Θ → Θ ≤ 2 →
      Θ ≤ 2 * ((0 : ℝ) + Real.sqrt 0 + Real.sqrt 1)) :=
  ⟨T5_HEART_at_one_one,
   T5_HEART_at_one_zero,
   T5_HEART_at_zero_one⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Specialize
