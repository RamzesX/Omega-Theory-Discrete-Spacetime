/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer14_AbsHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 14: absolute-value helpers**.

  Foundational sub-lemmas for real |·| arithmetic in the
  Hindry-Silverman D.6.1 chain:

  - AB-1..3: |x| basic properties.
  - AB-4..6: |x · y| = |x| · |y|.
  - AB-7..9: triangle inequality variants.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Order.AbsoluteValue.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer14_AbsHelpers

/-! ## AB-1 — |x| ≥ 0 -/

/-- **AB-1 — `T5_abs_nonneg`**: `|x| ≥ 0`. -/
theorem T5_abs_nonneg (x : ℝ) : 0 ≤ |x| := abs_nonneg x

/-! ## AB-2 — |0| = 0 -/

/-- **AB-2 — `T5_abs_zero`**: `|0| = 0`. -/
theorem T5_abs_zero : |(0 : ℝ)| = 0 := abs_zero

/-! ## AB-3 — |x| = 0 iff x = 0 -/

/-- **AB-3 — `T5_abs_eq_zero`**: `|x| = 0 ↔ x = 0`. -/
theorem T5_abs_eq_zero (x : ℝ) : |x| = 0 ↔ x = 0 := abs_eq_zero

/-! ## AB-4 — |x · y| = |x| · |y| -/

/-- **AB-4 — `T5_abs_mul`**: `|x · y| = |x| · |y|`. -/
theorem T5_abs_mul (x y : ℝ) : |x * y| = |x| * |y| := abs_mul x y

/-! ## AB-5 — |x / y| = |x| / |y| -/

/-- **AB-5 — `T5_abs_div`**: `|x / y| = |x| / |y|`. -/
theorem T5_abs_div (x y : ℝ) : |x / y| = |x| / |y| := abs_div x y

/-! ## AB-6 — |-x| = |x| -/

/-- **AB-6 — `T5_abs_neg`**: `|-x| = |x|`. -/
theorem T5_abs_neg (x : ℝ) : |-x| = |x| := abs_neg x

/-! ## AB-7 — Triangle inequality -/

/-- **AB-7 — `T5_abs_add`**: `|x + y| ≤ |x| + |y|`. -/
theorem T5_abs_add (x y : ℝ) : |x + y| ≤ |x| + |y| := by
  exact abs_add_le x y

/-! ## AB-8 — Reverse triangle inequality (parenthesised form) -/

/-- **AB-8 — `T5_abs_sub_le_abs_sub`**: `|(|x| - |y|)| ≤ |x - y|`. -/
theorem T5_abs_sub_le_abs_sub (x y : ℝ) :
    |(|x| - |y|)| ≤ |x - y| := abs_abs_sub_abs_le_abs_sub x y

/-! ## AB-9 — |x|^n = |x^n| -/

/-- **AB-9 — `T5_abs_pow_eq`**: `|x|^n = |x^n|`. -/
theorem T5_abs_pow_eq (x : ℝ) (n : ℕ) : |x|^n = |x^n| := (abs_pow x n).symm

/-! ## AB-10 — Layer 14 foundational marker -/

/-- **AB-10 — `T5_D61_Layer14_completed_marker`**: 5-conjunct marker for
    Layer 14 completion (absolute-value helpers). -/
theorem T5_D61_Layer14_completed_marker :
    (∀ (x : ℝ), 0 ≤ |x|) ∧
    (∀ (x : ℝ), |x| = 0 ↔ x = 0) ∧
    (∀ (x y : ℝ), |x * y| = |x| * |y|) ∧
    (∀ (x y : ℝ), |x + y| ≤ |x| + |y|) ∧
    (∀ (x : ℝ) (n : ℕ), |x|^n = |x^n|) :=
  ⟨T5_abs_nonneg,
   T5_abs_eq_zero,
   T5_abs_mul,
   T5_abs_add,
   T5_abs_pow_eq⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer14_AbsHelpers
