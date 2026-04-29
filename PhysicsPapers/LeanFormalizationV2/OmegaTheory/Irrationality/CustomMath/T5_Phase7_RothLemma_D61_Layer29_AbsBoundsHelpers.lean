/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer29_AbsBoundsHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 29: extended absolute value bounds**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer29_AbsBoundsHelpers

/-! ## AB-1 — `|x| < y → -y < x` -/

theorem T5_lt_of_abs_lt (x y : ℝ) (h : |x| < y) : -y < x := by
  have := abs_lt.mp h
  linarith

/-! ## AB-2 — `|x| < y → x < y` -/

theorem T5_lt_of_abs_lt_2 (x y : ℝ) (h : |x| < y) : x < y := by
  have := abs_lt.mp h
  linarith

/-! ## AB-3 — `|0| = 0` -/

theorem T5_abs_zero_eq : |(0 : ℝ)| = 0 := abs_zero

/-! ## AB-4 — `0 ≤ x → |x| = x` -/

theorem T5_abs_of_nonneg (x : ℝ) (h : 0 ≤ x) : |x| = x := abs_of_nonneg h

/-! ## AB-5 — `0 < x → 0 < |x|` -/

theorem T5_abs_pos_of_pos (x : ℝ) (h : 0 < x) : 0 < |x| := by
  rw [abs_of_nonneg (le_of_lt h)]
  exact h

/-! ## AB-6 — `x ≠ 0 → 0 < |x|` -/

theorem T5_abs_pos_of_ne_zero (x : ℝ) (h : x ≠ 0) : 0 < |x| := abs_pos.mpr h

/-! ## AB-7 — `|x| ≥ 0` -/

theorem T5_abs_ge_zero (x : ℝ) : 0 ≤ |x| := abs_nonneg x

/-! ## AB-8 — `0 ≤ |x|^n` -/

theorem T5_abs_pow_nonneg (x : ℝ) (n : ℕ) : 0 ≤ |x|^n :=
  pow_nonneg (abs_nonneg x) n

/-! ## AB-9 — `|x| ≤ y → -y ≤ x ∧ x ≤ y` -/

theorem T5_abs_le_iff (x y : ℝ) (h : |x| ≤ y) : -y ≤ x ∧ x ≤ y :=
  abs_le.mp h

/-! ## AB-10 — Layer 29 foundational marker -/

theorem T5_D61_Layer29_completed_marker :
    (∀ (x : ℝ), 0 ≤ x → |x| = x) ∧
    (∀ (x : ℝ), x ≠ 0 → 0 < |x|) ∧
    (∀ (x : ℝ), 0 ≤ |x|) ∧
    (∀ (x : ℝ) (n : ℕ), 0 ≤ |x|^n) ∧
    (∀ (x y : ℝ), |x| ≤ y → -y ≤ x ∧ x ≤ y) :=
  ⟨T5_abs_of_nonneg,
   T5_abs_pos_of_ne_zero,
   T5_abs_ge_zero,
   T5_abs_pow_nonneg,
   T5_abs_le_iff⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer29_AbsBoundsHelpers
