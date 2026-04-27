/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 144.
  `Polynomial.derivative_X_pow` and `eval_pow`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's polynomial power identities:

  1. **`T5_polynomial_derivative_X_pow`** : `derivative (X^n) = C n * X^(n-1)`.
  2. **`T5_polynomial_eval_pow`** : `eval x (p^n) = (eval x p)^n`.

  Mirror of the MvPolynomial T5_pderiv_X_pow_self (s115) for univariate
  setting, plus the corresponding eval-power identity.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeXPow

open Polynomial

/-! ## derivative of X^n -/

/-- **Wave T5 session 144 — derivative of `X^n`**.

    `derivative (X^n) = C n * X^(n-1)`. -/
theorem T5_polynomial_derivative_X_pow {R : Type*} [Semiring R] (n : ℕ) :
    Polynomial.derivative ((X : R[X]) ^ n) = C (n : R) * X ^ (n - 1) :=
  Polynomial.derivative_X_pow n

/-! ## eval of p^n -/

/-- **Wave T5 session 144 — eval of `p^n` is `(eval p)^n`**.

    `eval x (p^n) = (eval x p)^n`. -/
theorem T5_polynomial_eval_pow {R : Type*} [CommSemiring R]
    {p : R[X]} {x : R} (n : ℕ) :
    Polynomial.eval x (p ^ n) = (Polynomial.eval x p) ^ n :=
  Polynomial.eval_pow n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 144 — derivative_X_pow + eval_pow**.

    Two power-rule identities:
    1. `derivative (X^n) = C n * X^(n-1)`.
    2. `eval x (p^n) = (eval x p)^n`.

    Sub-lemma 32/N in T-5 Phase 3.  Lean-core only.

    Mirror of MvPolynomial pderiv_X_pow_self (s115) for univariate
    setting, plus the eval-power identity. -/
theorem session_144_polynomial_derivative_X_pow_headline :
    -- (1) derivative X^n
    (∀ {R : Type*} [_inst : Semiring R] (n : ℕ),
        Polynomial.derivative ((X : R[X]) ^ n) = C (n : R) * X ^ (n - 1))
    -- (2) eval p^n
    ∧ (∀ {R : Type*} [_inst : CommSemiring R] {p : R[X]} {x : R} (n : ℕ),
        Polynomial.eval x (p ^ n) = (Polynomial.eval x p) ^ n) := by
  refine ⟨?_, ?_⟩
  · intros R _ n; exact T5_polynomial_derivative_X_pow n
  · intros R _ p x n; exact T5_polynomial_eval_pow n

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeXPow
