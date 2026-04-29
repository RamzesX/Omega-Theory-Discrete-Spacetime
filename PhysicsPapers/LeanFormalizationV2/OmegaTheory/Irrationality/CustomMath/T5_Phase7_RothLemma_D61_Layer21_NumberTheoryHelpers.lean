/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer21_NumberTheoryHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 21: number theory helpers**.

  Foundational sub-lemmas for elementary number theory in the
  Hindry-Silverman D.6.1 chain.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Nat.Choose.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer21_NumberTheoryHelpers

/-! ## NT-1 — Factorial pos -/

theorem T5_factorial_pos (n : ℕ) : 0 < n.factorial := Nat.factorial_pos n

/-! ## NT-2 — Factorial zero -/

theorem T5_factorial_zero : (0 : ℕ).factorial = 1 := Nat.factorial_zero

/-! ## NT-3 — Factorial one -/

theorem T5_factorial_one : (1 : ℕ).factorial = 1 := Nat.factorial_one

/-! ## NT-4 — Factorial succ -/

theorem T5_factorial_succ (n : ℕ) :
    (n + 1).factorial = (n + 1) * n.factorial := Nat.factorial_succ n

/-! ## NT-5 — Choose at zero -/

theorem T5_choose_zero (n : ℕ) : n.choose 0 = 1 := Nat.choose_zero_right n

/-! ## NT-6 — Choose self -/

theorem T5_choose_self (n : ℕ) : n.choose n = 1 := Nat.choose_self n

/-! ## NT-7 — Choose symmetric -/

theorem T5_choose_symm (n k : ℕ) (h : k ≤ n) :
    n.choose k = n.choose (n - k) := (Nat.choose_symm h).symm

/-! ## NT-8 — Choose 0 = 1 trivially -/

theorem T5_choose_zero_zero : (0 : ℕ).choose 0 = 1 := Nat.choose_self 0

/-! ## NT-9 — Choose ≥ 1 when k ≤ n -/

theorem T5_choose_pos (n k : ℕ) (h : k ≤ n) : 0 < n.choose k :=
  Nat.choose_pos h

/-! ## NT-10 — Layer 21 foundational marker -/

theorem T5_D61_Layer21_completed_marker :
    (∀ (n : ℕ), 0 < n.factorial) ∧
    ((0 : ℕ).factorial = 1) ∧
    (∀ (n : ℕ), n.choose 0 = 1) ∧
    (∀ (n : ℕ), n.choose n = 1) ∧
    (∀ (n k : ℕ), k ≤ n → 0 < n.choose k) :=
  ⟨T5_factorial_pos,
   T5_factorial_zero,
   T5_choose_zero,
   T5_choose_self,
   T5_choose_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer21_NumberTheoryHelpers
