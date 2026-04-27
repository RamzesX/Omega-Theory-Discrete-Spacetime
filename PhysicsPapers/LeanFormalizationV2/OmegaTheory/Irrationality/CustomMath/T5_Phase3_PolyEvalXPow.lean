/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 169.
  `Polynomial.eval_X_pow`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `Polynomial.eval_X_pow`:

      `eval x (X^n) = x^n`.

  Univariate analogue of MvPolynomial aeval-on-X^n.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalXPow

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## eval of X^n -/

/-- **Wave T5 session 169 — `eval x (X^n) = x^n`**. -/
theorem T5_polynomial_eval_X_pow {x : R} (n : ℕ) :
    Polynomial.eval x ((X : R[X]) ^ n) = x ^ n :=
  Polynomial.eval_X_pow n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 169 — `eval x (X^n) = x^n`**.

    Foundational evaluation of monomial X^n.

    Sub-lemma 56/N in T-5 Phase 3.  Lean-core only. -/
theorem session_169_polynomial_eval_X_pow_headline
    {R : Type*} [Semiring R] :
    ∀ {x : R} (n : ℕ),
        Polynomial.eval x ((X : R[X]) ^ n) = x ^ n :=
  fun {x} n => T5_polynomial_eval_X_pow (x := x) n

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalXPow
