/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalCasts

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 158.
  `Polynomial.eval` of integer / natural casts.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.eval` on Nat-cast / Int-cast:

  1. **`T5_polynomial_eval_natCast`** : `eval x (n : R[X]) = n`.
  2. **`T5_polynomial_eval_intCast`** : `eval x (n : R[X]) = n`.

  Casts of integers/naturals into `R[X]` (via `Nat.cast` / `Int.cast`)
  are evaluation-invariant — they pass through `eval`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalCasts

open Polynomial

/-! ## eval of natural casts -/

/-- **Wave T5 session 158 — eval of `Nat.cast` is `Nat.cast`**.

    `eval x (n : R[X]) = (n : R)`. -/
theorem T5_polynomial_eval_natCast
    {R : Type*} [Semiring R] {x : R} {n : ℕ} :
    Polynomial.eval x (n : R[X]) = (n : R) :=
  Polynomial.eval_natCast

/-- **Wave T5 session 158 — eval of `Int.cast` is `Int.cast`**.

    `eval x (n : R[X]) = (n : R)`. -/
theorem T5_polynomial_eval_intCast
    {R : Type*} [Ring R] {x : R} {n : ℤ} :
    Polynomial.eval x (n : R[X]) = (n : R) :=
  Polynomial.eval_intCast

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 158 — eval of integer / natural casts**.

    Two foundational identities:
    1. `eval x (n : R[X]) = (n : R)` for `n : ℕ`.
    2. `eval x (n : R[X]) = (n : R)` for `n : ℤ`.

    Sub-lemma 45/N in T-5 Phase 3.  Lean-core only. -/
theorem session_158_polynomial_eval_casts_headline :
    -- (1) ℕ
    (∀ {R : Type*} [_inst : Semiring R] {x : R} {n : ℕ},
        Polynomial.eval x (n : R[X]) = (n : R))
    -- (2) ℤ
    ∧ (∀ {R : Type*} [_inst : Ring R] {x : R} {n : ℤ},
        Polynomial.eval x (n : R[X]) = (n : R)) := by
  refine ⟨?_, ?_⟩
  · intros R _ x n; exact T5_polynomial_eval_natCast
  · intros R _ x n; exact T5_polynomial_eval_intCast

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalCasts
