/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeBasics

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 138.
  `Polynomial.derivative` foundational identities.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.derivative` on basic generators:

  1. **`T5_polynomial_derivative_X`** : `derivative X = 1`.
  2. **`T5_polynomial_derivative_C`** : `derivative (C a) = 0`.
  3. **`T5_polynomial_derivative_pow`** : `derivative (p^n) = n * p^(n-1) * derivative p`.

  Mirror of T5_Phase3_PDerivCommute (s110) for univariate Polynomial.

  Used in T-5 polynomial-index calculus where univariate derivatives
  appear when working with the minimal polynomial of an algebraic α.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeBasics

open Polynomial

variable {R : Type*}

/-! ## Polynomial.derivative on generators -/

/-- **Wave T5 session 138 — derivative of X is 1**. -/
theorem T5_polynomial_derivative_X [Semiring R] :
    Polynomial.derivative (X : R[X]) = 1 :=
  Polynomial.derivative_X

/-- **Wave T5 session 138 — derivative of constant is zero**. -/
theorem T5_polynomial_derivative_C [Semiring R] (a : R) :
    Polynomial.derivative (C a : R[X]) = 0 :=
  Polynomial.derivative_C

/-- **Wave T5 session 138 — power rule for `derivative`**.

    `derivative (p^n) = n * p^(n-1) * derivative p`. -/
theorem T5_polynomial_derivative_pow [CommSemiring R] (p : R[X]) (n : ℕ) :
    Polynomial.derivative (p ^ n) = C (n : R) * p ^ (n - 1) * Polynomial.derivative p :=
  Polynomial.derivative_pow p n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 138 — Polynomial.derivative basics**.

    Three foundational identities:
    1. `derivative X = 1`.
    2. `derivative (C a) = 0`.
    3. `derivative (p^n) = C n * p^(n-1) * derivative p`.

    Sub-lemma 27/N in T-5 Phase 3.  Lean-core only.

    Mirror of T5_Phase3_PDerivCommute (s110-style) for univariate
    Polynomial.  Used in T-5 polynomial-index calculus for the
    univariate setting (minimal polynomials of algebraic α). -/
theorem session_138_polynomial_derivative_basics_headline
    {R : Type*} [CommSemiring R] :
    -- (1) X
    (Polynomial.derivative (X : R[X]) = 1)
    -- (2) C a
    ∧ (∀ (a : R), Polynomial.derivative (C a : R[X]) = 0)
    -- (3) Power rule
    ∧ (∀ (p : R[X]) (n : ℕ),
        Polynomial.derivative (p ^ n) =
          C (n : R) * p ^ (n - 1) * Polynomial.derivative p) :=
  ⟨T5_polynomial_derivative_X, T5_polynomial_derivative_C,
   T5_polynomial_derivative_pow⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeBasics
