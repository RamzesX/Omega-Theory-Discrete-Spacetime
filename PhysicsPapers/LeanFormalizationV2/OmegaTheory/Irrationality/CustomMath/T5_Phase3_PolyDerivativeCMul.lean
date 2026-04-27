/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeCMul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 150.
  `Polynomial.derivative` C-mul + zero.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.derivative` linearity:

  1. **`T5_polynomial_derivative_C_mul`** : `derivative (C a * p) = C a * derivative p`.
  2. **`T5_polynomial_derivative_zero`** : `derivative 0 = 0`.

  Univariate analogue of MvPolynomial pderiv_C_mul + pderiv_zero.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeCMul

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## derivative is linear over C-multiplication -/

/-- **Wave T5 session 150 — `derivative (C a * p) = C a * derivative p`**. -/
theorem T5_polynomial_derivative_C_mul (a : R) (p : R[X]) :
    Polynomial.derivative (Polynomial.C a * p) =
      Polynomial.C a * Polynomial.derivative p :=
  Polynomial.derivative_C_mul a p

/-- **Wave T5 session 150 — `derivative 0 = 0`**. -/
theorem T5_polynomial_derivative_zero :
    Polynomial.derivative (0 : R[X]) = 0 :=
  Polynomial.derivative_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 150 — derivative C-mul + zero**.

    Two foundational identities:
    1. `derivative (C a * p) = C a * derivative p` (C-linearity).
    2. `derivative 0 = 0`.

    Sub-lemma 38/N in T-5 Phase 3.  Lean-core only.

    Univariate analogue of MvPolynomial pderiv_C_mul + pderiv_zero. -/
theorem session_150_polynomial_derivative_C_mul_headline
    {R : Type*} [Semiring R] :
    -- (1) C-mul linearity
    (∀ (a : R) (p : R[X]),
        Polynomial.derivative (Polynomial.C a * p) =
          Polynomial.C a * Polynomial.derivative p)
    -- (2) zero
    ∧ (Polynomial.derivative (0 : R[X]) = 0) :=
  ⟨T5_polynomial_derivative_C_mul, T5_polynomial_derivative_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeCMul
