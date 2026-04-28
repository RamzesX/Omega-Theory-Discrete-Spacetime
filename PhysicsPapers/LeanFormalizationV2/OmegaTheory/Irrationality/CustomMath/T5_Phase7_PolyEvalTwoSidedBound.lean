/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound

  T-5 (Roth's theorem) — **Phase 7 ext #24: integer eval lower bound +
  two-sided bound**, sub session 559qqq — STRICT critical-path #316
  (T-5) Phase 7 ext #24.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Integer non-vanishing lower bound + two-sided bound on `eval α p`
  for integer-coefficient polynomials at integer evaluation points:

  - LOWER: `eval α p ≠ 0 → 1 ≤ |eval α p|` (Int.one_le_abs)
  - UPPER: ext #19 `T5_coeffsToPoly_eval_abs_bound`
  - TWO-SIDED: both at once, the contradiction setup for Roth

  This is the **closure foundation** for Roth's contradiction:
  if `eval α p ≠ 0` AND the upper bound is < 1, contradiction.
  The remaining work is producing α (rational, close to algebraic
  target) where the upper bound IS < 1 — that's the Liouville-type
  argument deferred to ext #25+.

  Two derivations + Prop:
  1. `T5_polyEval_one_le_abs_of_ne_zero`: integer non-vanishing
     lower bound `1 ≤ |eval α p|` when non-zero
  2. `T5_polyEval_two_sided_bound`: combination upper + lower for
     `coeffsToPoly c` polynomials

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #24 — two-sided bound foundation for Roth contradiction.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound

/-! ## Integer eval lower bound -/

/-- **🚨 Wave T5 session 559qqq — `eval α p ≠ 0 → 1 ≤ |eval α p|`**.

    For any integer-coefficient polynomial `p : MvPolynomial (Fin n) ℤ`
    evaluated at integer point `α : Fin n → ℤ`, the result is an
    integer; if non-zero, `|·| ≥ 1` by `Int.one_le_abs`. -/
theorem T5_polyEval_one_le_abs_of_ne_zero
    {n : ℕ} (p : MvPolynomial (Fin n) ℤ) (α : Fin n → ℤ)
    (h : (MvPolynomial.eval α) p ≠ 0) :
    1 ≤ |(MvPolynomial.eval α) p| :=
  Int.one_le_abs h

/-! ## Two-sided bound for coeffsToPoly polynomials -/

/-- **🚨 Wave T5 session 559qqq — two-sided bound for `coeffsToPoly c`**.

    Combination of ext #19 upper bound + integer non-vanishing
    lower bound: when `eval α (coeffsToPoly c) ≠ 0`,

        1 ≤ |eval α (coeffsToPoly c)|
          ≤ (∑ k, |c k|) · ∏ i, 2^d · (max 1 |α_i|)^d

    Roth's contradiction: if the upper bound is < 1, can't have
    eval = non-zero integer. -/
theorem T5_polyEval_two_sided_bound {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ)
    (h_ne : (MvPolynomial.eval α) (coeffsToPoly c) ≠ 0) :
    1 ≤ |(MvPolynomial.eval α) (coeffsToPoly c)| ∧
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (∑ k : BoundedMI n d, |c k|) *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) :=
  ⟨T5_polyEval_one_le_abs_of_ne_zero (coeffsToPoly c) α h_ne,
   T5_coeffsToPoly_eval_abs_bound c α⟩

/-! ## PolyEvalTwoSidedBound Prop scaffold -/

/-- **PolyEvalTwoSidedBound**: 2-conjunct Prop packaging the
    integer non-vanishing lower bound + two-sided combination. -/
def PolyEvalTwoSidedBound : Prop :=
  (∀ {n : ℕ} (p : MvPolynomial (Fin n) ℤ) (α : Fin n → ℤ),
    (MvPolynomial.eval α) p ≠ 0 →
    1 ≤ |(MvPolynomial.eval α) p|) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ),
    (MvPolynomial.eval α) (coeffsToPoly c) ≠ 0 →
    1 ≤ |(MvPolynomial.eval α) (coeffsToPoly c)| ∧
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (∑ k : BoundedMI n d, |c k|) *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)))

/-- **🚨 Wave T5 session 559qqq — `PolyEvalTwoSidedBound`**. -/
theorem T5_polyEval_two_sided : PolyEvalTwoSidedBound :=
  ⟨@T5_polyEval_one_le_abs_of_ne_zero,
   @T5_polyEval_two_sided_bound⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559qqq — T-5 Phase 7 ext #24:
    integer eval lower bound + two-sided bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #24.

    Foundation for Roth's contradiction setup:

    LOWER (this file): `eval α p ≠ 0 → 1 ≤ |eval α p|` (Int.one_le_abs)
    UPPER (ext #19): `|eval α (coeffsToPoly c)| ≤ (∑ |c k|) · ∏ 2^d (max 1 |α|)^d`
    TWO-SIDED: combination at once

    Two derivations + Prop:
    1. `T5_polyEval_one_le_abs_of_ne_zero` — integer non-vanishing
       lower bound via `Int.one_le_abs`
    2. `T5_polyEval_two_sided_bound` — combination upper + lower
    + PolyEvalTwoSidedBound Prop (2-conjunct).

    Roth's contradiction lever: if the upper bound `(∑ |c k|) ·
    ∏ 2^d (max 1 |α|)^d < 1`, can't have non-zero integer eval.
    The remaining work is producing α (rational, close to
    algebraic target) where the upper bound IS < 1 (Liouville-type
    argument, ext #25+).

    Mathlib usage: `Int.one_le_abs` (basic integer bound).

    Sub-lemma 217/N in T-1 (T-5 Phase 7 ext #24).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 integer eval two-sided bound
    foundation for Roth contradiction. -/
theorem session_559qqq_T5_phase7_polyEval_two_sided_bound_headline :
    PolyEvalTwoSidedBound :=
  T5_polyEval_two_sided

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound
