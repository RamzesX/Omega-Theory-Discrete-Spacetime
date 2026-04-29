/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer28_NormHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 28: numeric / norm helpers**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer28_NormHelpers

/-! ## NN-1 — `2 > 0` -/

theorem T5_two_pos : (0 : ℝ) < 2 := by norm_num

/-! ## NN-2 — `2 ≠ 0` -/

theorem T5_two_ne_zero : (2 : ℝ) ≠ 0 := by norm_num

/-! ## NN-3 — `2 > 1` -/

theorem T5_two_gt_one : (1 : ℝ) < 2 := by norm_num

/-! ## NN-4 — `1/2 > 0` -/

theorem T5_half_pos : (0 : ℝ) < 1/2 := by norm_num

/-! ## NN-5 — `1/2 < 1` -/

theorem T5_half_lt_one : (1 : ℝ)/2 < 1 := by norm_num

/-! ## NN-6 — `1/2 + 1/2 = 1` -/

theorem T5_half_add_half : (1 : ℝ)/2 + 1/2 = 1 := by norm_num

/-! ## NN-7 — `2 · (1/2) = 1` -/

theorem T5_two_mul_half : (2 : ℝ) * (1/2) = 1 := by norm_num

/-! ## NN-8 — `(1/2)^0 = 1` -/

theorem T5_half_pow_zero : ((1 : ℝ)/2)^(0 : ℕ) = 1 := by norm_num

/-! ## NN-9 — `(1/2)^1 = 1/2` -/

theorem T5_half_pow_one : ((1 : ℝ)/2)^(1 : ℕ) = 1/2 := by norm_num

/-! ## NN-10 — Layer 28 foundational marker -/

theorem T5_D61_Layer28_completed_marker :
    ((0 : ℝ) < 2) ∧
    ((2 : ℝ) ≠ 0) ∧
    ((1 : ℝ) < 2) ∧
    ((0 : ℝ) < 1/2) ∧
    ((1 : ℝ)/2 + 1/2 = 1) :=
  ⟨T5_two_pos,
   T5_two_ne_zero,
   T5_two_gt_one,
   T5_half_pos,
   T5_half_add_half⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer28_NormHelpers
