/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalSubDerivativeNeg

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 162.
  `Polynomial.eval` of subtraction + `derivative_neg`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's identities (over Ring):

  1. **`T5_polynomial_eval_sub`** : `eval x (p - q) = eval x p - eval x q`.
  2. **`T5_polynomial_derivative_neg`** : `derivative (-f) = -derivative f`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalSubDerivativeNeg

open Polynomial

variable {R : Type*} [Ring R]

/-! ## eval of subtraction -/

/-- **Wave T5 session 162 — `eval x (p - q) = eval x p - eval x q`**. -/
theorem T5_polynomial_eval_sub (p q : R[X]) (x : R) :
    Polynomial.eval x (p - q) = Polynomial.eval x p - Polynomial.eval x q :=
  Polynomial.eval_sub p q x

/-! ## derivative of negation -/

/-- **Wave T5 session 162 — `derivative (-f) = -derivative f`**. -/
theorem T5_polynomial_derivative_neg (f : R[X]) :
    Polynomial.derivative (-f) = -Polynomial.derivative f :=
  Polynomial.derivative_neg f

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 162 — eval_sub + derivative_neg**.

    Two foundational identities (over a Ring):
    1. `eval x (p - q) = eval x p - eval x q`.
    2. `derivative (-f) = -derivative f`.

    Sub-lemma 49/N in T-5 Phase 3.  Lean-core only. -/
theorem session_162_polynomial_eval_sub_derivative_neg_headline
    {R : Type*} [Ring R] :
    -- (1) eval_sub
    (∀ (p q : R[X]) (x : R),
        Polynomial.eval x (p - q) = Polynomial.eval x p - Polynomial.eval x q)
    -- (2) derivative_neg
    ∧ (∀ (f : R[X]), Polynomial.derivative (-f) = -Polynomial.derivative f) :=
  ⟨T5_polynomial_eval_sub, T5_polynomial_derivative_neg⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalSubDerivativeNeg
