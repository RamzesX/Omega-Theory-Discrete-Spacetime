/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer18_DivHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 18: division/inverse helpers**.

  Foundational sub-lemmas for division/inverse in real arithmetic.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer18_DivHelpers

/-! ## DV-1 — Inverse positive -/

/-- **DV-1 — `T5_inv_pos`**: `0 < x → 0 < x⁻¹`. -/
theorem T5_inv_pos (x : ℝ) (h : 0 < x) : 0 < x⁻¹ := inv_pos.mpr h

/-! ## DV-2 — Inverse nonneg -/

/-- **DV-2 — `T5_inv_nonneg`**: `0 ≤ x → 0 ≤ x⁻¹`. -/
theorem T5_inv_nonneg (x : ℝ) (h : 0 ≤ x) : 0 ≤ x⁻¹ := inv_nonneg.mpr h

/-! ## DV-3 — Inverse of one -/

/-- **DV-3 — `T5_inv_one`**: `1⁻¹ = 1`. -/
theorem T5_inv_one : (1 : ℝ)⁻¹ = 1 := inv_one

/-! ## DV-4 — Inverse of zero -/

/-- **DV-4 — `T5_inv_zero`**: `0⁻¹ = 0`. -/
theorem T5_inv_zero : (0 : ℝ)⁻¹ = 0 := inv_zero

/-! ## DV-5 — Division by self -/

/-- **DV-5 — `T5_div_self`**: `x ≠ 0 → x / x = 1`. -/
theorem T5_div_self (x : ℝ) (h : x ≠ 0) : x / x = 1 := div_self h

/-! ## DV-6 — Division zero -/

/-- **DV-6 — `T5_zero_div`**: `0 / x = 0`. -/
theorem T5_zero_div (x : ℝ) : (0 : ℝ) / x = 0 := zero_div x

/-! ## DV-7 — Division by one -/

/-- **DV-7 — `T5_div_one`**: `x / 1 = x`. -/
theorem T5_div_one (x : ℝ) : x / (1 : ℝ) = x := div_one x

/-! ## DV-8 — Division pos from numerator pos and denominator pos -/

/-- **DV-8 — `T5_div_pos`**: `0 < a, 0 < b → 0 < a / b`. -/
theorem T5_div_pos (a b : ℝ) (ha : 0 < a) (hb : 0 < b) : 0 < a / b :=
  div_pos ha hb

/-! ## DV-9 — Division nonneg -/

/-- **DV-9 — `T5_div_nonneg`**: `0 ≤ a, 0 ≤ b → 0 ≤ a / b`. -/
theorem T5_div_nonneg (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ a / b :=
  div_nonneg ha hb

/-! ## DV-10 — Layer 18 foundational marker -/

/-- **DV-10 — `T5_D61_Layer18_completed_marker`**: 5-conjunct marker for
    Layer 18 completion (division helpers). -/
theorem T5_D61_Layer18_completed_marker :
    (∀ (x : ℝ), 0 < x → 0 < x⁻¹) ∧
    ((1 : ℝ)⁻¹ = 1) ∧
    ((0 : ℝ)⁻¹ = 0) ∧
    (∀ (x : ℝ), x ≠ 0 → x / x = 1) ∧
    (∀ (a b : ℝ), 0 < a → 0 < b → 0 < a / b) :=
  ⟨T5_inv_pos,
   T5_inv_one,
   T5_inv_zero,
   T5_div_self,
   T5_div_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer18_DivHelpers
