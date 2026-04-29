/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer30_RPowHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 30: rpow (real power) helpers**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer30_RPowHelpers

/-! ## RP-1 — `x^0 = 1` for real exponent -/

theorem T5_rpow_zero (x : ℝ) : x^(0 : ℝ) = 1 := Real.rpow_zero x

/-! ## RP-2 — `x^1 = x` for real exponent -/

theorem T5_rpow_one (x : ℝ) : x^(1 : ℝ) = x := Real.rpow_one x

/-! ## RP-3 — `0^x = 0` for x ≠ 0 -/

theorem T5_zero_rpow (x : ℝ) (h : x ≠ 0) : (0 : ℝ)^x = 0 := Real.zero_rpow h

/-! ## RP-4 — `1^x = 1` -/

theorem T5_one_rpow (x : ℝ) : (1 : ℝ)^x = 1 := Real.one_rpow x

/-! ## RP-5 — Rpow positivity for x > 0 -/

theorem T5_rpow_pos_of_pos (x : ℝ) (h : 0 < x) (e : ℝ) : 0 < x^e :=
  Real.rpow_pos_of_pos h e

/-! ## RP-6 — Rpow add: `x^(a+b) = x^a · x^b` for x > 0 -/

theorem T5_rpow_add_pos (x : ℝ) (h : 0 < x) (a b : ℝ) :
    x^(a + b) = x^a * x^b :=
  Real.rpow_add h a b

/-! ## RP-7 — Rpow mul: `x^(a · b) = (x^a)^b` for x ≥ 0 -/

theorem T5_rpow_mul_nonneg (x : ℝ) (h : 0 ≤ x) (a b : ℝ) :
    x^(a * b) = (x^a)^b :=
  Real.rpow_mul h a b

/-! ## RP-8 — Rpow nonneg from x ≥ 0 -/

theorem T5_rpow_nonneg (x : ℝ) (h : 0 ≤ x) (e : ℝ) : 0 ≤ x^e :=
  Real.rpow_nonneg h e

/-! ## RP-9 — Rpow monotone in exponent -/

theorem T5_rpow_le_rpow_of_exponent_le (x : ℝ) (h : 1 ≤ x) (a b : ℝ) (hab : a ≤ b) :
    x^a ≤ x^b := Real.rpow_le_rpow_of_exponent_le h hab

/-! ## RP-10 — Layer 30 foundational marker -/

theorem T5_D61_Layer30_completed_marker :
    (∀ (x : ℝ), x^(0 : ℝ) = 1) ∧
    (∀ (x : ℝ), x^(1 : ℝ) = x) ∧
    (∀ (x : ℝ), (1 : ℝ)^x = 1) ∧
    (∀ (x : ℝ), 0 ≤ x → ∀ (e : ℝ), 0 ≤ x^e) ∧
    (∀ (x : ℝ), 0 < x → ∀ (e : ℝ), 0 < x^e) :=
  ⟨T5_rpow_zero,
   T5_rpow_one,
   T5_one_rpow,
   T5_rpow_nonneg,
   T5_rpow_pos_of_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer30_RPowHelpers
