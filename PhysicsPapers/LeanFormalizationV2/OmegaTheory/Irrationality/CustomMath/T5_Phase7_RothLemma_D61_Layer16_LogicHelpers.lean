/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer16_LogicHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 16: arithmetic logic helpers**.

  Foundational sub-lemmas for ℕ/ℤ arithmetic in the Hindry-Silverman
  D.6.1 chain.

  - LH-1..3: Nat arithmetic helpers.
  - LH-4..6: Int arithmetic helpers.
  - LH-7..9: Real-valued comparison helpers.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Data.Nat.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer16_LogicHelpers

/-! ## LH-1 — Nat positivity from non-zero -/

/-- **LH-1 — `T5_nat_pos_of_ne_zero`**: `n ≠ 0 → 0 < n` for ℕ. -/
theorem T5_nat_pos_of_ne_zero (n : ℕ) (h : n ≠ 0) : 0 < n :=
  Nat.pos_of_ne_zero h

/-! ## LH-2 — Nat ≥ 1 from positivity -/

/-- **LH-2 — `T5_nat_ge_one_of_pos`**: `0 < n → 1 ≤ n` for ℕ. -/
theorem T5_nat_ge_one_of_pos (n : ℕ) (h : 0 < n) : 1 ≤ n := h

/-! ## LH-3 — Nat omega-style -/

/-- **LH-3 — `T5_nat_le_succ`**: `n ≤ n + 1`. -/
theorem T5_nat_le_succ (n : ℕ) : n ≤ n + 1 := Nat.le_succ n

/-! ## LH-4 — Int absolute value nonneg -/

/-- **LH-4 — `T5_int_natAbs_nonneg`**: `(n.natAbs : ℤ) ≥ 0`. -/
theorem T5_int_natAbs_nonneg (n : ℤ) : (0 : ℤ) ≤ (n.natAbs : ℤ) := by
  exact_mod_cast Nat.zero_le _

/-! ## LH-5 — Int 1 ≤ |n| iff n ≠ 0 -/

/-- **LH-5 — `T5_int_one_le_abs`**: `n ≠ 0 → 1 ≤ |n|`. -/
theorem T5_int_one_le_abs (n : ℤ) (h : n ≠ 0) : 1 ≤ |n| := Int.one_le_abs h

/-! ## LH-6 — Int casted to real preserves order -/

/-- **LH-6 — `T5_int_cast_le_real_iff`**: `(n : ℝ) ≤ (m : ℝ) ↔ n ≤ m`. -/
theorem T5_int_cast_le_real_iff (n m : ℤ) :
    (n : ℝ) ≤ (m : ℝ) ↔ n ≤ m := Int.cast_le

/-! ## LH-7 — Real ≤ transitive -/

/-- **LH-7 — `T5_real_le_trans`**: `a ≤ b → b ≤ c → a ≤ c`. -/
theorem T5_real_le_trans (a b c : ℝ) (h₁ : a ≤ b) (h₂ : b ≤ c) : a ≤ c :=
  le_trans h₁ h₂

/-! ## LH-8 — Real < transitive -/

/-- **LH-8 — `T5_real_lt_trans`**: `a < b → b < c → a < c`. -/
theorem T5_real_lt_trans (a b c : ℝ) (h₁ : a < b) (h₂ : b < c) : a < c :=
  lt_trans h₁ h₂

/-! ## LH-9 — Real ≤ from <  -/

/-- **LH-9 — `T5_real_le_of_lt`**: `a < b → a ≤ b`. -/
theorem T5_real_le_of_lt (a b : ℝ) (h : a < b) : a ≤ b := le_of_lt h

/-! ## LH-10 — Layer 16 foundational marker -/

/-- **LH-10 — `T5_D61_Layer16_completed_marker`**: 5-conjunct marker for
    Layer 16 completion (logic helpers). -/
theorem T5_D61_Layer16_completed_marker :
    (∀ (n : ℕ), n ≠ 0 → 0 < n) ∧
    (∀ (n : ℤ), n ≠ 0 → 1 ≤ |n|) ∧
    (∀ (n m : ℤ), (n : ℝ) ≤ (m : ℝ) ↔ n ≤ m) ∧
    (∀ (a b c : ℝ), a ≤ b → b ≤ c → a ≤ c) ∧
    (∀ (a b : ℝ), a < b → a ≤ b) :=
  ⟨T5_nat_pos_of_ne_zero,
   T5_int_one_le_abs,
   T5_int_cast_le_real_iff,
   T5_real_le_trans,
   T5_real_le_of_lt⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer16_LogicHelpers
