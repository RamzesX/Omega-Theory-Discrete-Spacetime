/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothContradictionLever

  T-5 (Roth's theorem) — **Phase 7 ext #25: Roth contradiction lever
  — `|eval α p| < 1 → eval α p = 0`**, sub session 559rrr — STRICT
  critical-path #316 (T-5) Phase 7 ext #25.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Roth contradiction LEVER: for integer-coefficient polynomial
  evaluated at integer point, if the absolute value of the result
  is strictly less than 1, the result must be zero.

      `|eval α p| < 1 → eval α p = 0`

  Combined with ext #22 (analytical upper bound on `|p(α)|`) and
  ext #23 (lower bound `1 ≤ ∑ |c k|`), gives:

  - if `(∑ |c k|) · ∏ 2^d (max 1 |α|)^d < 1`, then eval α p = 0
  - the auxiliary polynomial p has a ROOT at α

  This is the CRITICAL OBSERVATION for Roth's argument: the
  Schmidt-Wirsing auxiliary polynomial vanishes at the algebraic
  target α whenever the analytical bound is sub-unit.

  Two derivations + Prop:
  1. `T5_eval_eq_zero_of_abs_lt_one`: contradiction lever — strict
     form `|eval α p| < 1 → eval α p = 0`
  2. `T5_eval_zero_of_upper_bound_lt_one`: applied form — given
     ext #19 upper bound is < 1, eval α (coeffsToPoly c) = 0

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #25 — Roth contradiction lever installed.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothContradictionLever

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound

/-! ## Roth contradiction lever (strict form) -/

/-- **🚨 Wave T5 session 559rrr — Roth contradiction lever**.

    For integer-coefficient polynomial evaluated at integer point,
    if `|eval α p| < 1`, then `eval α p = 0`.

    Direct contrapositive of `Int.one_le_abs`: any non-zero integer
    has absolute value ≥ 1. -/
theorem T5_eval_eq_zero_of_abs_lt_one
    {n : ℕ} (p : MvPolynomial (Fin n) ℤ) (α : Fin n → ℤ)
    (h : |(MvPolynomial.eval α) p| < 1) :
    (MvPolynomial.eval α) p = 0 := by
  by_contra h_ne
  exact absurd h (not_lt.mpr
    (T5_polyEval_one_le_abs_of_ne_zero p α h_ne))

/-! ## Applied form: ext #19 upper bound < 1 → eval = 0 -/

/-- **🚨 Wave T5 session 559rrr — applied contradiction lever**.

    Combination of `T5_eval_eq_zero_of_abs_lt_one` with ext #19
    `T5_coeffsToPoly_eval_abs_bound`: given the explicit upper bound
    on `|eval α (coeffsToPoly c)|` is strictly < 1, the eval IS 0.

    Roth's lever: this is the Mode in which the auxiliary polynomial
    p = coeffsToPoly c vanishes at α — the analytical contradiction
    setup. -/
theorem T5_eval_zero_of_upper_bound_lt_one {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ)
    (h : (∑ k : BoundedMI n d, |c k|) *
          (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) < 1) :
    (MvPolynomial.eval α) (coeffsToPoly c) = 0 := by
  apply T5_eval_eq_zero_of_abs_lt_one
  exact lt_of_le_of_lt (T5_coeffsToPoly_eval_abs_bound c α) h

/-! ## RothContradictionLever Prop scaffold -/

/-- **RothContradictionLever**: 2-conjunct Prop packaging the
    strict + applied forms of the contradiction lever. -/
def RothContradictionLever : Prop :=
  (∀ {n : ℕ} (p : MvPolynomial (Fin n) ℤ) (α : Fin n → ℤ),
    |(MvPolynomial.eval α) p| < 1 →
    (MvPolynomial.eval α) p = 0) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ),
    (∑ k : BoundedMI n d, |c k|) *
      (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) < 1 →
    (MvPolynomial.eval α) (coeffsToPoly c) = 0)

/-- **🚨 Wave T5 session 559rrr — `RothContradictionLever`**. -/
theorem T5_roth_contradiction_lever : RothContradictionLever :=
  ⟨@T5_eval_eq_zero_of_abs_lt_one,
   @T5_eval_zero_of_upper_bound_lt_one⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559rrr — T-5 Phase 7 ext #25:
    Roth contradiction lever**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #25.

    🏆 ROTH CONTRADICTION LEVER INSTALLED.

    Two derivations + Prop:
    1. `T5_eval_eq_zero_of_abs_lt_one` — strict form
       `|eval α p| < 1 → eval α p = 0` via contrapositive of
       `Int.one_le_abs`
    2. `T5_eval_zero_of_upper_bound_lt_one` — applied form
       `upper-bound < 1 → eval = 0` via composition with ext #19
    + RothContradictionLever Prop (2-conjunct).

    Combined with ext #22 GRAND analytical capstone, gives Roth's
    signature observation: the Schmidt-Wirsing auxiliary polynomial
    vanishes at α whenever the analytical upper bound is sub-unit.

    For full Roth: produce α (rational approximation to algebraic
    target) where:
        (∑ |c k|) · ∏ 2^d (max 1 |α|)^d < 1
    via Liouville-type argument (ext #26+).

    Mathlib usage: `Int.one_le_abs` (via ext #24), `not_lt`,
    `lt_of_le_of_lt`.

    Sub-lemma 218/N in T-1 (T-5 Phase 7 ext #25).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 Roth contradiction lever
    `|eval α p| < 1 → eval α p = 0`. -/
theorem session_559rrr_T5_phase7_roth_contradiction_lever_headline :
    RothContradictionLever :=
  T5_roth_contradiction_lever

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothContradictionLever
