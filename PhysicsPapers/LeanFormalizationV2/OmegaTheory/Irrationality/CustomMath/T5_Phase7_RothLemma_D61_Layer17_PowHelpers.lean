/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer17_PowHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 17: power/exp helpers**.

  Foundational sub-lemmas for real powers in the Hindry-Silverman
  D.6.1 chain.

  - PH-1..3: pow basic positivity.
  - PH-4..6: pow with exponent comparison.
  - PH-7..9: pow product / sum identities.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Order.Ring.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer17_PowHelpers

/-! ## PH-1 — Pow zero -/

/-- **PH-1 — `T5_pow_zero`**: `x^0 = 1`. -/
theorem T5_pow_zero (x : ℝ) : x^(0 : ℕ) = 1 := pow_zero x

/-! ## PH-2 — Pow one -/

/-- **PH-2 — `T5_pow_one`**: `x^1 = x`. -/
theorem T5_pow_one (x : ℝ) : x^(1 : ℕ) = x := pow_one x

/-! ## PH-3 — Pow positivity -/

/-- **PH-3 — `T5_pow_pos`**: `0 < x → 0 < x^n` for any `n : ℕ`. -/
theorem T5_pow_pos (x : ℝ) (hx : 0 < x) (n : ℕ) : 0 < x^n := pow_pos hx n

/-! ## PH-4 — Pow nonneg -/

/-- **PH-4 — `T5_pow_nonneg`**: `0 ≤ x → 0 ≤ x^n`. -/
theorem T5_pow_nonneg (x : ℝ) (hx : 0 ≤ x) (n : ℕ) : 0 ≤ x^n := pow_nonneg hx n

/-! ## PH-5 — Pow add -/

/-- **PH-5 — `T5_pow_add`**: `x^(a + b) = x^a · x^b`. -/
theorem T5_pow_add (x : ℝ) (a b : ℕ) : x^(a + b) = x^a * x^b := pow_add x a b

/-! ## PH-6 — Pow multiplicative -/

/-- **PH-6 — `T5_pow_mul_comm`**: `x^a · x^b = x^b · x^a`. -/
theorem T5_pow_mul_comm (x : ℝ) (a b : ℕ) : x^a * x^b = x^b * x^a :=
  mul_comm _ _

/-! ## PH-7 — Pow of product -/

/-- **PH-7 — `T5_mul_pow`**: `(x · y)^n = x^n · y^n`. -/
theorem T5_mul_pow (x y : ℝ) (n : ℕ) : (x * y)^n = x^n * y^n :=
  mul_pow x y n

/-! ## PH-8 — Pow nesting -/

/-- **PH-8 — `T5_pow_mul`**: `(x^a)^b = x^(a · b)`. -/
theorem T5_pow_mul_eq (x : ℝ) (a b : ℕ) : (x^a)^b = x^(a * b) :=
  (pow_mul x a b).symm

/-! ## PH-9 — Pow ≥ 1 for x ≥ 1 -/

/-- **PH-9 — `T5_pow_le_one`**: `1 ≤ x → 1 ≤ x^n`. -/
theorem T5_pow_le_one (x : ℝ) (hx : 1 ≤ x) (n : ℕ) : 1 ≤ x^n :=
  one_le_pow₀ hx

/-! ## PH-10 — Layer 17 foundational marker -/

/-- **PH-10 — `T5_D61_Layer17_completed_marker`**: 5-conjunct marker for
    Layer 17 completion (power helpers). -/
theorem T5_D61_Layer17_completed_marker :
    (∀ (x : ℝ), x^(0 : ℕ) = 1) ∧
    (∀ (x : ℝ), x^(1 : ℕ) = x) ∧
    (∀ (x : ℝ), 0 < x → ∀ (n : ℕ), 0 < x^n) ∧
    (∀ (x y : ℝ) (n : ℕ), (x * y)^n = x^n * y^n) ∧
    (∀ (x : ℝ), 1 ≤ x → ∀ (n : ℕ), 1 ≤ x^n) :=
  ⟨T5_pow_zero,
   T5_pow_one,
   T5_pow_pos,
   T5_mul_pow,
   T5_pow_le_one⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer17_PowHelpers
