/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer19_OrderHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 19: ordering helpers**.

  Foundational sub-lemmas for real ordering / inequality manipulation.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer19_OrderHelpers

/-! ## OR-1 — `a ≤ b → a + c ≤ b + c` -/

theorem T5_add_le_add_right (a b : ℝ) (h : a ≤ b) (c : ℝ) :
    a + c ≤ b + c := by linarith

/-! ## OR-2 — `a ≤ b → c + a ≤ c + b` -/

theorem T5_add_le_add_left (c a b : ℝ) (h : a ≤ b) :
    c + a ≤ c + b := by linarith

/-! ## OR-3 — `a ≤ b → a · c ≤ b · c` for nonneg c -/

theorem T5_mul_le_mul_right (a b c : ℝ) (hc : 0 ≤ c) (h : a ≤ b) :
    a * c ≤ b * c := mul_le_mul_of_nonneg_right h hc

/-! ## OR-4 — `0 ≤ a → 0 ≤ b → 0 ≤ a + b` -/

theorem T5_add_nonneg (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) :
    0 ≤ a + b := add_nonneg ha hb

/-! ## OR-5 — `0 ≤ a → 0 ≤ b → 0 ≤ a · b` -/

theorem T5_mul_nonneg (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) :
    0 ≤ a * b := mul_nonneg ha hb

/-! ## OR-6 — `0 < a → 0 < b → 0 < a + b` -/

theorem T5_add_pos (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    0 < a + b := add_pos ha hb

/-! ## OR-7 — `0 < a → 0 < b → 0 < a · b` -/

theorem T5_mul_pos (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    0 < a * b := mul_pos ha hb

/-! ## OR-8 — `a < b → b < c → a < c` -/

theorem T5_lt_trans (a b c : ℝ) (h₁ : a < b) (h₂ : b < c) : a < c :=
  lt_trans h₁ h₂

/-! ## OR-9 — `a ≤ b → a < c → b < c → False` (impossible chain) -/

theorem T5_not_lt_of_le (a b : ℝ) (h₁ : a ≤ b) (h₂ : b < a) : False :=
  absurd h₁ (not_le.mpr h₂)

/-! ## OR-10 — Layer 19 foundational marker -/

theorem T5_D61_Layer19_completed_marker :
    (∀ (a b : ℝ), a ≤ b → ∀ (c : ℝ), a + c ≤ b + c) ∧
    (∀ (a b : ℝ), 0 ≤ a → 0 ≤ b → 0 ≤ a + b) ∧
    (∀ (a b : ℝ), 0 ≤ a → 0 ≤ b → 0 ≤ a * b) ∧
    (∀ (a b : ℝ), 0 < a → 0 < b → 0 < a * b) ∧
    (∀ (a b c : ℝ), a < b → b < c → a < c) :=
  ⟨T5_add_le_add_right,
   T5_add_nonneg,
   T5_mul_nonneg,
   T5_mul_pos,
   T5_lt_trans⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer19_OrderHelpers
