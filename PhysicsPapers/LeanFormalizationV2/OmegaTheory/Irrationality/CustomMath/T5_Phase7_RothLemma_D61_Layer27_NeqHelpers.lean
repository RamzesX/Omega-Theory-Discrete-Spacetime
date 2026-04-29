/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer27_NeqHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 27: ne/ne' helpers**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer27_NeqHelpers

/-! ## NE-1 — `0 ≠ 1` for ℝ -/

theorem T5_zero_ne_one : (0 : ℝ) ≠ 1 := zero_ne_one

/-! ## NE-2 — `1 ≠ 0` for ℝ -/

theorem T5_one_ne_zero : (1 : ℝ) ≠ 0 := one_ne_zero

/-! ## NE-3 — Symmetric ≠ -/

theorem T5_ne_symm (a b : ℝ) (h : a ≠ b) : b ≠ a := h.symm

/-! ## NE-4 — Strict less implies ne -/

theorem T5_lt_implies_ne (a b : ℝ) (h : a < b) : a ≠ b := ne_of_lt h

/-! ## NE-5 — Strict greater implies ne -/

theorem T5_gt_implies_ne (a b : ℝ) (h : a > b) : a ≠ b := ne_of_gt h

/-! ## NE-6 — Pos implies ≠ 0 -/

theorem T5_pos_ne_zero (a : ℝ) (h : 0 < a) : a ≠ 0 := ne_of_gt h

/-! ## NE-7 — Neg implies ≠ 0 -/

theorem T5_neg_ne_zero (a : ℝ) (h : a < 0) : a ≠ 0 := ne_of_lt h

/-! ## NE-8 — `(a ≠ 0) → (-a ≠ 0)` -/

theorem T5_neg_ne_zero_of_ne (a : ℝ) (h : a ≠ 0) : -a ≠ 0 := neg_ne_zero.mpr h

/-! ## NE-9 — `(a ≠ 0 ∧ b ≠ 0) → (a · b ≠ 0)` -/

theorem T5_mul_ne_zero (a b : ℝ) (ha : a ≠ 0) (hb : b ≠ 0) : a * b ≠ 0 :=
  mul_ne_zero ha hb

/-! ## NE-10 — Layer 27 foundational marker -/

theorem T5_D61_Layer27_completed_marker :
    (((0 : ℝ)) ≠ 1) ∧
    (((1 : ℝ)) ≠ 0) ∧
    (∀ (a b : ℝ), a < b → a ≠ b) ∧
    (∀ (a : ℝ), 0 < a → a ≠ 0) ∧
    (∀ (a b : ℝ), a ≠ 0 → b ≠ 0 → a * b ≠ 0) :=
  ⟨T5_zero_ne_one,
   T5_one_ne_zero,
   T5_lt_implies_ne,
   T5_pos_ne_zero,
   T5_mul_ne_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer27_NeqHelpers
