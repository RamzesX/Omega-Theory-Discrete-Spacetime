/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer31_RPowExtended

  T-5 (Roth's theorem) — **D.6.1 Layer 31: extended rpow helpers**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer31_RPowExtended

/-! ## RPE-1 — Real.rpow_natCast: x^(n : ℝ) = x^n -/

theorem T5_rpow_natCast (x : ℝ) (n : ℕ) : x^(n : ℝ) = x^n :=
  Real.rpow_natCast x n

/-! ## RPE-2 — `x^a · x^b = x^(a+b)` for x > 0 (alternate direction) -/

theorem T5_rpow_add_pos_alt (x : ℝ) (h : 0 < x) (a b : ℝ) :
    x^a * x^b = x^(a + b) := (Real.rpow_add h a b).symm

/-! ## RPE-3 — `(x · y)^a = x^a · y^a` for x, y nonneg -/

theorem T5_mul_rpow (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) (a : ℝ) :
    (x * y)^a = x^a * y^a := Real.mul_rpow hx hy

/-! ## RPE-4 — `x^a ≤ y^a` for nonneg base + nonneg exponent + x ≤ y -/

theorem T5_rpow_le_rpow (x y : ℝ) (hx : 0 ≤ x) (hxy : x ≤ y) (a : ℝ) (ha : 0 ≤ a) :
    x^a ≤ y^a := Real.rpow_le_rpow hx hxy ha

/-! ## RPE-5 — `1 ≤ x → 1 ≤ x^a` for a ≥ 0 -/

theorem T5_one_le_rpow (x : ℝ) (hx : 1 ≤ x) (a : ℝ) (ha : 0 ≤ a) : 1 ≤ x^a :=
  Real.one_le_rpow hx ha

/-! ## RPE-6 — `x^a < y^a` for strictly less and positive exponent -/

theorem T5_rpow_lt_rpow (x y : ℝ) (hx : 0 ≤ x) (hxy : x < y) (a : ℝ) (ha : 0 < a) :
    x^a < y^a := Real.rpow_lt_rpow hx hxy ha

/-! ## RPE-7 — `0^0 = 1` (Mathlib convention) -/

theorem T5_zero_rpow_zero : (0 : ℝ)^(0 : ℝ) = 1 := by
  simp

/-! ## RPE-8 — Rpow of inverse -/

theorem T5_rpow_neg (x : ℝ) (hx : 0 ≤ x) (a : ℝ) :
    x^(-a) = (x^a)⁻¹ := Real.rpow_neg hx a

/-! ## RPE-9 — Rpow of half preserves sign -/

theorem T5_rpow_half_pos (x : ℝ) (hx : 0 < x) : 0 < x^((1 : ℝ)/2) :=
  Real.rpow_pos_of_pos hx _

/-! ## RPE-10 — Layer 31 foundational marker -/

theorem T5_D61_Layer31_completed_marker :
    (∀ (x : ℝ) (n : ℕ), x^(n : ℝ) = x^n) ∧
    (∀ (x y : ℝ), 0 ≤ x → 0 ≤ y → ∀ (a : ℝ), (x * y)^a = x^a * y^a) ∧
    (∀ (x y : ℝ), 0 ≤ x → x ≤ y → ∀ (a : ℝ), 0 ≤ a → x^a ≤ y^a) ∧
    (∀ (x : ℝ), 1 ≤ x → ∀ (a : ℝ), 0 ≤ a → 1 ≤ x^a) ∧
    (∀ (x : ℝ), 0 < x → 0 < x^((1 : ℝ)/2)) :=
  ⟨T5_rpow_natCast,
   T5_mul_rpow,
   T5_rpow_le_rpow,
   T5_one_le_rpow,
   T5_rpow_half_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer31_RPowExtended
