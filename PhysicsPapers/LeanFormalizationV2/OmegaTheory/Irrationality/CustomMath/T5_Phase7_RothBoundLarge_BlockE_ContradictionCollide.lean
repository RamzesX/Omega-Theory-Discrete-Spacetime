/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockE_ContradictionCollide

  T-5 (Roth's theorem) — **D.7 Block E: contradiction collide foundations**.

  Foundational sub-lemmas for combining the analytical upper bound
  (Block C) with the integer non-vanishing lower bound (Block D) to
  produce a contradiction with ε sufficiently small.

  - E-1..3: bound-collision arithmetic.
  - E-4..6: ε-regime constraints.
  - E-7..9: contradiction-from-combined-bounds skeleton.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Sqrt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockE_ContradictionCollide

open Real

/-! ## E-1 — Bound-collision arithmetic: a/b ≤ c → a ≤ b·c -/

/-- **E-1 — `T5_div_le_implies_le_mul`**: for `b > 0`, `a/b ≤ c → a ≤ b·c`. -/
theorem T5_div_le_implies_le_mul
    (a b c : ℝ) (hb : 0 < b) (h : a / b ≤ c) :
    a ≤ b * c := by
  rw [div_le_iff₀ hb] at h
  linarith

/-! ## E-2 — Bound-collision: a ≤ b → c·a ≤ c·b for c ≥ 0 -/

/-- **E-2 — `T5_mul_le_mul_of_nonneg`**: `c ≥ 0 → a ≤ b → c·a ≤ c·b`. -/
theorem T5_mul_le_mul_of_nonneg
    (a b c : ℝ) (hc : 0 ≤ c) (h : a ≤ b) :
    c * a ≤ c * b :=
  mul_le_mul_of_nonneg_left h hc

/-! ## E-3 — `1/x^a ≤ 1/x^b` for x ≥ 1, b ≤ a -/

/-- **E-3 — `T5_one_div_pow_anti`**: `x ≥ 1, b ≤ a → 1/x^a ≤ 1/x^b`. -/
theorem T5_one_div_pow_anti
    (x : ℝ) (hx : 1 ≤ x) (a b : ℕ) (hab : b ≤ a) :
    1 / x^a ≤ 1 / x^b := by
  have hx_pos : 0 < x := lt_of_lt_of_le zero_lt_one hx
  have hx_pow_a_pos : 0 < x^a := pow_pos hx_pos a
  have hx_pow_b_pos : 0 < x^b := pow_pos hx_pos b
  rw [div_le_div_iff₀ hx_pow_a_pos hx_pow_b_pos]
  rw [one_mul, one_mul]
  exact pow_le_pow_right₀ hx hab

/-! ## E-4 — `x^(2+ε) ≥ x^2` for x ≥ 1, ε ≥ 0 -/

/-- **E-4 — `T5_pow_2_eps_ge_pow_2`**: `x ≥ 1, 0 ≤ ε → x^(2+ε) ≥ x^2`. -/
theorem T5_pow_2_eps_ge_pow_2
    (x : ℝ) (hx : 1 ≤ x) (ε : ℝ) (hε : 0 ≤ ε) :
    x^(2 : ℝ) ≤ x^(2 + ε) := by
  apply Real.rpow_le_rpow_of_exponent_le hx
  linarith

/-! ## E-5 — `0 < 1/x^a` for x > 0 -/

/-- **E-5 — `T5_one_div_pow_pos`**: `x > 0 → 0 < 1/x^a`. -/
theorem T5_one_div_pow_pos
    (x : ℝ) (hx : 0 < x) (a : ℕ) :
    0 < 1 / x^a := by
  have hx_pow_pos : 0 < x^a := pow_pos hx a
  exact one_div_pos.mpr hx_pow_pos

/-! ## E-6 — Bound monotonicity: 1/x^a ≤ 1/x^b for x ≥ 1, b ≤ a (real-exp) -/

/-- **E-6 — `T5_one_div_rpow_anti`**: `x > 1, b ≤ a → 1/x^a ≤ 1/x^b`
    for real exponents. -/
theorem T5_one_div_rpow_anti
    (x : ℝ) (hx : 1 < x) (a b : ℝ) (hab : b ≤ a) :
    1 / x^a ≤ 1 / x^b := by
  have hx_pos : 0 < x := lt_trans zero_lt_one hx
  have hx_le : 1 ≤ x := le_of_lt hx
  have hxa_pos : 0 < x^a := Real.rpow_pos_of_pos hx_pos a
  have hxb_pos : 0 < x^b := Real.rpow_pos_of_pos hx_pos b
  rw [div_le_div_iff₀ hxa_pos hxb_pos]
  rw [one_mul, one_mul]
  exact Real.rpow_le_rpow_of_exponent_le hx_le hab

/-! ## E-7 — Combined contradiction skeleton -/

/-- **E-7 — `T5_combined_contradiction_skeleton`**: if `a ≤ b` and
    `b < a`, contradiction. -/
theorem T5_combined_contradiction_skeleton
    (a b : ℝ) (h₁ : a ≤ b) (h₂ : b < a) : False :=
  absurd h₁ (not_le.mpr h₂)

/-! ## E-8 — Contradiction via multiplied bound -/

/-- **E-8 — `T5_mul_contradict`**: if `a · c < b · c` with `c > 0`,
    then `a < b`. -/
theorem T5_mul_contradict
    (a b c : ℝ) (hc : 0 < c) (h : a * c < b * c) : a < b := by
  exact lt_of_mul_lt_mul_right h (le_of_lt hc)

/-! ## E-9 — Real exponent inequality bridge -/

/-- **E-9 — `T5_rpow_bridge_eps_threshold`**: for `x > 1` and `ε > δ ≥ 0`,
    `x^δ < x^ε`. -/
theorem T5_rpow_bridge_eps_threshold
    (x : ℝ) (hx : 1 < x) (δ ε : ℝ) (hδ : 0 ≤ δ) (hδε : δ < ε) :
    x^δ < x^ε :=
  Real.rpow_lt_rpow_of_exponent_lt hx hδε

/-! ## E-10 — Block E foundational marker -/

/-- **E-10 — `T5_BlockE_foundational_marker`**: 4-conjunct marker for
    Block E foundational sub-lemmas. -/
theorem T5_BlockE_foundational_marker :
    (∀ (a b c : ℝ), 0 < b → a / b ≤ c → a ≤ b * c) ∧
    (∀ (x : ℝ), 1 ≤ x → ∀ (a b : ℕ), b ≤ a → 1 / x^a ≤ 1 / x^b) ∧
    (∀ (x : ℝ), 0 < x → ∀ (a : ℕ), 0 < 1 / x^a) ∧
    (∀ (x : ℝ), 1 < x → ∀ (δ ε : ℝ), 0 ≤ δ → δ < ε → x^δ < x^ε) :=
  ⟨T5_div_le_implies_le_mul,
   T5_one_div_pow_anti,
   T5_one_div_pow_pos,
   T5_rpow_bridge_eps_threshold⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockE_ContradictionCollide
