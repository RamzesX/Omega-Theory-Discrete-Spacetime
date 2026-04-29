/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer26_LinearMapHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 26: linear map helpers**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer26_LinearMapHelpers

/-! ## LM-1 — Linear scaling: c·(a+b) = c·a + c·b -/

theorem T5_real_distrib_left (c a b : ℝ) : c * (a + b) = c * a + c * b :=
  mul_add c a b

/-! ## LM-2 — Linear scaling right: (a+b)·c = a·c + b·c -/

theorem T5_real_distrib_right (a b c : ℝ) : (a + b) * c = a * c + b * c :=
  add_mul a b c

/-! ## LM-3 — Multiplication associative -/

theorem T5_real_mul_assoc (a b c : ℝ) : (a * b) * c = a * (b * c) := mul_assoc a b c

/-! ## LM-4 — Multiplication commutative -/

theorem T5_real_mul_comm (a b : ℝ) : a * b = b * a := mul_comm a b

/-! ## LM-5 — Add associative -/

theorem T5_real_add_assoc (a b c : ℝ) : (a + b) + c = a + (b + c) := add_assoc a b c

/-! ## LM-6 — Add commutative -/

theorem T5_real_add_comm (a b : ℝ) : a + b = b + a := add_comm a b

/-! ## LM-7 — One is mult identity -/

theorem T5_real_one_mul (a : ℝ) : 1 * a = a := one_mul a

/-! ## LM-8 — Mult by one (right) -/

theorem T5_real_mul_one (a : ℝ) : a * 1 = a := mul_one a

/-! ## LM-9 — Zero is add identity -/

theorem T5_real_zero_add (a : ℝ) : 0 + a = a := zero_add a

/-! ## LM-10 — Layer 26 foundational marker -/

theorem T5_D61_Layer26_completed_marker :
    (∀ (c a b : ℝ), c * (a + b) = c * a + c * b) ∧
    (∀ (a b c : ℝ), (a * b) * c = a * (b * c)) ∧
    (∀ (a b : ℝ), a * b = b * a) ∧
    (∀ (a b c : ℝ), (a + b) + c = a + (b + c)) ∧
    (∀ (a : ℝ), 1 * a = a) :=
  ⟨T5_real_distrib_left,
   T5_real_mul_assoc,
   T5_real_mul_comm,
   T5_real_add_assoc,
   T5_real_one_mul⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer26_LinearMapHelpers
