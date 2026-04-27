/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeAddMul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 140.
  `Polynomial.derivative` linearity + Leibniz rule.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.derivative` algebraic identities:

  1. **`T5_polynomial_derivative_add`** : `derivative (f + g) = derivative f + derivative g`.
  2. **`T5_polynomial_derivative_mul`** : `derivative (f * g) = derivative f * g + f * derivative g` (Leibniz rule).

  Mirror of MvPolynomial pderiv linearity + Leibniz, for the univariate
  setting.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeAddMul

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## Polynomial.derivative algebraic identities -/

/-- **Wave T5 session 140 — derivative is additive**.

    `derivative (f + g) = derivative f + derivative g`. -/
theorem T5_polynomial_derivative_add {f g : R[X]} :
    Polynomial.derivative (f + g) =
      Polynomial.derivative f + Polynomial.derivative g :=
  Polynomial.derivative_add

/-- **Wave T5 session 140 — Leibniz rule for derivative**.

    `derivative (f * g) = derivative f * g + f * derivative g`. -/
theorem T5_polynomial_derivative_mul {f g : R[X]} :
    Polynomial.derivative (f * g) =
      Polynomial.derivative f * g + f * Polynomial.derivative g :=
  Polynomial.derivative_mul

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 140 — derivative additivity + Leibniz**.

    Two fundamental identities:
    1. `derivative (f + g) = derivative f + derivative g`.
    2. `derivative (f * g) = derivative f * g + f * derivative g` (Leibniz).

    Sub-lemma 28/N in T-5 Phase 3.  Lean-core only.

    Mirror of MvPolynomial pderiv linearity + Leibniz for the
    univariate setting. -/
theorem session_140_polynomial_derivative_add_mul_headline
    {R : Type*} [Semiring R] :
    -- (1) Add
    (∀ {f g : R[X]},
        Polynomial.derivative (f + g) =
          Polynomial.derivative f + Polynomial.derivative g)
    -- (2) Mul (Leibniz)
    ∧ (∀ {f g : R[X]},
        Polynomial.derivative (f * g) =
          Polynomial.derivative f * g + f * Polynomial.derivative g) :=
  ⟨T5_polynomial_derivative_add, T5_polynomial_derivative_mul⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeAddMul
