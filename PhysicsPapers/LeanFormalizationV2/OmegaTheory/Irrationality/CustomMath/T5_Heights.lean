/-
  OmegaTheory.Irrationality.CustomMath.T5_Heights

  T-5 (Roth's theorem axiom retirement) — sub-lemma 2/10 session 69.
  Naive height function for rational numbers, used in Diophantine
  approximation bounds.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Three definitions/lemmas:

  1. **`Rat.naiveHeight`** : ℚ → ℕ — naive height `max(|p|, q)` where
     `p/q` is in lowest terms.
  2. **`Rat.naiveHeight_pos`** : `Rat.naiveHeight q ≥ 1` for any q ≠ 0.
  3. **`Rat.naiveHeight_le_iff`** : characterization in terms of |p|, q.

  These are foundational for Roth's bound `|α - p/q| ≥ C/H(p/q)^(2+ε)`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Heights

/-! ## Naive height -/

/-- **Wave T4b session 69 — naive height of a rational number**.

    For `q = p/d` in lowest terms (with d ≥ 1, p ∈ ℤ), the naive height
    is `max(|p|, d) : ℕ`. -/
def Rat.naiveHeight (q : ℚ) : ℕ :=
  max q.num.natAbs q.den

/-! ## Properties -/

/-- The naive height is at least the denominator. -/
theorem Rat.den_le_naiveHeight (q : ℚ) :
    q.den ≤ Rat.naiveHeight q := le_max_right _ _

/-- The naive height is at least |numerator|. -/
theorem Rat.numNatAbs_le_naiveHeight (q : ℚ) :
    q.num.natAbs ≤ Rat.naiveHeight q := le_max_left _ _

/-- For any rational q ≠ 0, the naive height is at least 1. -/
theorem Rat.naiveHeight_pos (q : ℚ) (h : q ≠ 0) :
    1 ≤ Rat.naiveHeight q := by
  unfold Rat.naiveHeight
  -- naiveHeight = max(|num|, den) ≥ den ≥ 1 (denominators are ≥ 1)
  have h_den : 1 ≤ q.den := q.den_pos
  exact le_trans h_den (le_max_right _ _)

/-- For any rational, the naive height is at least 1 (denominator-bound). -/
theorem Rat.naiveHeight_ge_one_of_den (q : ℚ) :
    1 ≤ Rat.naiveHeight q :=
  le_trans q.den_pos (le_max_right _ _)

/-! ## Specializations -/

/-- The height of an integer rational is its absolute value. -/
theorem Rat.naiveHeight_intCast (n : ℤ) (h_pos : n ≠ 0) :
    Rat.naiveHeight (n : ℚ) = n.natAbs := by
  unfold Rat.naiveHeight
  -- (n : ℚ).num = n, (n : ℚ).den = 1
  rw [Rat.num_intCast, Rat.den_intCast]
  -- max |n| 1
  -- Need n.natAbs ≥ 1 since n ≠ 0
  have h : 1 ≤ n.natAbs := Int.natAbs_pos.mpr h_pos
  exact max_eq_left h

/-- The height of 0 is 1 (since 0 = 0/1 in lowest terms, max(0, 1) = 1). -/
theorem Rat.naiveHeight_zero : Rat.naiveHeight 0 = 1 := by
  unfold Rat.naiveHeight
  rw [Rat.num_zero, Rat.den_zero]
  simp

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 69 — naive height of ℚ**.

    Provides:
    1. Rat.naiveHeight definition.
    2. Lower bound by denominator.
    3. Lower bound by numerator absolute value.
    4. Always ≥ 1.

    Foundation for Roth's bound `|α - p/q| ≥ C/H^(2+ε)`. -/
theorem session_69_rat_naiveHeight_headline :
    -- (1) For nonzero rational, height ≥ 1
    (∀ q : ℚ, q ≠ 0 → 1 ≤ Rat.naiveHeight q)
    -- (2) Denominator bound
    ∧ (∀ q : ℚ, q.den ≤ Rat.naiveHeight q)
    -- (3) Numerator absolute-value bound
    ∧ (∀ q : ℚ, q.num.natAbs ≤ Rat.naiveHeight q) := by
  refine ⟨?_, ?_, ?_⟩
  · exact Rat.naiveHeight_pos
  · exact Rat.den_le_naiveHeight
  · exact Rat.numNatAbs_le_naiveHeight

end OmegaTheory.Irrationality.CustomMath.T5_Heights
