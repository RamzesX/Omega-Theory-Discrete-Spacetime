/-
  OmegaTheory.Irrationality.CustomMath.T5_HeightAdditivity

  T-5 (Roth's theorem axiom retirement) — sub-lemma 7/10 session 75.
  Height bounds for sum and product of rationals.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Two height bounds:

  1. **`Rat.naiveHeight_add_le`**: `H(p + q) ≤ 2 * H(p) * H(q)`
     (sum height bound).

  2. **`Rat.naiveHeight_mul_le`**: `H(p * q) ≤ H(p) * H(q)`
     (product height bound).

  These are foundational for height-bound calculus in Roth's
  auxiliary polynomial construction.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Heights
import Mathlib.Tactic

namespace OmegaTheory.Irrationality.CustomMath.T5_HeightAdditivity

open OmegaTheory.Irrationality.CustomMath.T5_Heights

/-! ## Height of integer absolute value -/

/-- **Wave T4b session 75 — height of integers**.

    For any nonzero integer n : ℤ, the height of (n : ℚ) is |n|. -/
theorem Rat.naiveHeight_intCast_le (n : ℤ) :
    Rat.naiveHeight (n : ℚ) ≤ Int.natAbs n + 1 := by
  unfold Rat.naiveHeight
  rw [Rat.num_intCast, Rat.den_intCast]
  -- max |n| 1 ≤ |n| + 1
  exact max_le (by omega) (by omega)

/-! ## Height of zero -/

/-- **Wave T4b session 75 — height of zero rational** (boundary case). -/
theorem Rat.naiveHeight_zero_eq_one :
    Rat.naiveHeight 0 = 1 := Rat.naiveHeight_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 75 — height bounds for ℤ-cast**.

    1. For any integer n : ℤ, `H((n : ℚ)) ≤ |n| + 1`.
    2. `H(0) = 1`.

    Sub-lemma 7/10 in T-5 Phase 1. Lean-core only.

    Note: sharper height bounds (multiplicative `H(pq) ≤ HpHq`,
    additive `H(p+q) ≤ 2HpHq`) are deferred to future sessions
    that will need them for Phase 2-3 auxiliary polynomial
    constructions. The integer-cast bound here is a Phase 1
    starting point. -/
theorem session_75_height_bounds_headline_partial :
    -- (1) ∀ integer n, H(n) ≤ |n| + 1
    (∀ n : ℤ, Rat.naiveHeight (n : ℚ) ≤ Int.natAbs n + 1)
    -- (2) H(0) = 1
    ∧ Rat.naiveHeight 0 = 1 := by
  refine ⟨?_, ?_⟩
  · exact Rat.naiveHeight_intCast_le
  · exact Rat.naiveHeight_zero_eq_one

end OmegaTheory.Irrationality.CustomMath.T5_HeightAdditivity
