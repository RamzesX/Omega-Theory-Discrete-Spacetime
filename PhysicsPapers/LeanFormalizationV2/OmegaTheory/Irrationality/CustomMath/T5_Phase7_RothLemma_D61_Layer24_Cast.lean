/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer24_Cast

  T-5 (Roth's theorem) — **D.6.1 Layer 24: cast helpers**.

  Foundational sub-lemmas for type coercion in the Hindry-Silverman
  D.6.1 chain.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Data.Nat.Cast.Order.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer24_Cast

/-! ## CT-1 — Nat cast nonneg -/

theorem T5_nat_cast_nonneg (n : ℕ) : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n

/-! ## CT-2 — Nat cast positive iff n > 0 -/

theorem T5_nat_cast_pos (n : ℕ) : (0 : ℝ) < (n : ℝ) ↔ 0 < n :=
  Nat.cast_pos

/-! ## CT-3 — Nat cast 0 -/

theorem T5_nat_cast_zero : ((0 : ℕ) : ℝ) = 0 := Nat.cast_zero

/-! ## CT-4 — Nat cast 1 -/

theorem T5_nat_cast_one : ((1 : ℕ) : ℝ) = 1 := Nat.cast_one

/-! ## CT-5 — Nat cast add -/

theorem T5_nat_cast_add (n m : ℕ) : ((n + m : ℕ) : ℝ) = (n : ℝ) + (m : ℝ) := by
  push_cast
  rfl

/-! ## CT-6 — Nat cast mul -/

theorem T5_nat_cast_mul (n m : ℕ) : ((n * m : ℕ) : ℝ) = (n : ℝ) * (m : ℝ) := by
  push_cast
  rfl

/-! ## CT-7 — Int cast 0 -/

theorem T5_int_cast_zero : ((0 : ℤ) : ℝ) = 0 := Int.cast_zero

/-! ## CT-8 — Int cast 1 -/

theorem T5_int_cast_one : ((1 : ℤ) : ℝ) = 1 := Int.cast_one

/-! ## CT-9 — Int cast neg -/

theorem T5_int_cast_neg (n : ℤ) : ((-n : ℤ) : ℝ) = -(n : ℝ) := Int.cast_neg n

/-! ## CT-10 — Layer 24 foundational marker -/

theorem T5_D61_Layer24_completed_marker :
    (∀ (n : ℕ), (0 : ℝ) ≤ (n : ℝ)) ∧
    (((0 : ℕ) : ℝ) = 0) ∧
    (((1 : ℕ) : ℝ) = 1) ∧
    (∀ (n m : ℕ), ((n + m : ℕ) : ℝ) = (n : ℝ) + (m : ℝ)) ∧
    (((0 : ℤ) : ℝ) = 0) :=
  ⟨T5_nat_cast_nonneg,
   T5_nat_cast_zero,
   T5_nat_cast_one,
   T5_nat_cast_add,
   T5_int_cast_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer24_Cast
