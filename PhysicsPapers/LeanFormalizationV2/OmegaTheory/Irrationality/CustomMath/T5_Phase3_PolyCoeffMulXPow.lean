/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffMulXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 154.
  `Polynomial.coeff` of mul / X^k.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.coeff` on multiplication / power:

  1. **`T5_polynomial_coeff_mul`** : Cauchy product
     `(p * q).coeff n = ∑ x ∈ Finset.antidiagonal n, p.coeff x.1 * q.coeff x.2`.
  2. **`T5_polynomial_coeff_X_pow`** : Kronecker delta
     `(X^k).coeff n = if n = k then 1 else 0`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Coeff

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffMulXPow

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## Cauchy product -/

/-- **Wave T5 session 154 — coeff of product is Cauchy convolution**.

    `(p * q).coeff n = ∑ x ∈ Finset.antidiagonal n, p.coeff x.1 * q.coeff x.2`. -/
theorem T5_polynomial_coeff_mul (p q : R[X]) (n : ℕ) :
    (p * q).coeff n = ∑ x ∈ Finset.antidiagonal n, p.coeff x.1 * q.coeff x.2 :=
  Polynomial.coeff_mul p q n

/-! ## coeff of X^k is Kronecker delta -/

/-- **Wave T5 session 154 — `(X^k).coeff n = if n = k then 1 else 0`**. -/
theorem T5_polynomial_coeff_X_pow (k n : ℕ) :
    ((Polynomial.X : R[X]) ^ k).coeff n = if n = k then 1 else 0 :=
  Polynomial.coeff_X_pow k n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 154 — coeff_mul + coeff_X_pow**.

    Two foundational coefficient identities:
    1. Cauchy product: `(p*q).coeff n = ∑ ... p.coeff i * q.coeff j`.
    2. Kronecker delta: `(X^k).coeff n = if n = k then 1 else 0`.

    Sub-lemma 41/N in T-5 Phase 3.  Lean-core only.

    Used in T-5 polynomial-index calculus when expanding products /
    powers via support analysis. -/
theorem session_154_polynomial_coeff_mul_X_pow_headline
    {R : Type*} [Semiring R] :
    -- (1) Cauchy product
    (∀ (p q : R[X]) (n : ℕ),
        (p * q).coeff n =
          ∑ x ∈ Finset.antidiagonal n, p.coeff x.1 * q.coeff x.2)
    -- (2) X^k Kronecker delta
    ∧ (∀ (k n : ℕ),
        ((Polynomial.X : R[X]) ^ k).coeff n = if n = k then 1 else 0) :=
  ⟨T5_polynomial_coeff_mul, T5_polynomial_coeff_X_pow⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffMulXPow
