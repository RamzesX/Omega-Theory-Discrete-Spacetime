/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 115.
  Partial derivative of `X i ^ n`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Foundational identities for `pderiv` on monomials in a single
  variable:

  1. **`T5_pderiv_X_pow_self`** : `pderiv i (X i ^ n) = n * X i ^ (n-1)`.
     This is the analogue of `d/dx (x^n) = n x^(n-1)`.
  2. **`T5_pderiv_X_pow_of_ne`** : `pderiv i (X j ^ n) = 0` for `i ≠ j`.
     Cross-variable derivatives vanish.

  Both follow by combining Mathlib's `pderiv_pow` (Leibniz iteration)
  with `pderiv_X_self` / `pderiv_X_of_ne`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## pderiv of `X i ^ n` -/

/-- **Wave T5 session 115 — pderiv of X^n in same variable**.

    `pderiv i (X i ^ n) = n * X i^(n-1)`.

    The polynomial-derivative power rule. -/
theorem T5_pderiv_X_pow_self (i : σ) (n : ℕ) :
    pderiv i ((X i : MvPolynomial σ R) ^ n) = (n : MvPolynomial σ R) * (X i)^(n - 1) := by
  rw [pderiv_pow, pderiv_X_self, mul_one]

/-- **Wave T5 session 115 — pderiv of X^n in different variable**.

    `pderiv i (X j ^ n) = 0` for `j ≠ i`. -/
theorem T5_pderiv_X_pow_of_ne {i j : σ} (h : j ≠ i) (n : ℕ) :
    pderiv i ((X j : MvPolynomial σ R) ^ n) = 0 := by
  rw [pderiv_pow, pderiv_X_of_ne h, mul_zero]

/-- **Wave T5 session 115 — pderiv of (C r * X i ^ n)**.

    Combines `pderiv_C_mul` with the power rule. -/
theorem T5_pderiv_C_mul_X_pow (i : σ) (r : R) (n : ℕ) :
    pderiv i (C r * (X i : MvPolynomial σ R)^n) =
      C r * ((n : MvPolynomial σ R) * (X i)^(n-1)) := by
  rw [pderiv_C_mul, T5_pderiv_X_pow_self]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 115 — pderiv on monomials in 1 var**.

    Three foundational facts:
    1. `pderiv i (X i^n) = n * X i^(n-1)` (power rule).
    2. `pderiv i (X j^n) = 0` for `i ≠ j` (cross-variable).
    3. `pderiv i (C r * X i^n) = C r * n * X i^(n-1)` (scaled).

    Sub-lemma 6/N in T-5 Phase 3.  Lean-core only.

    Used in Roth's polynomial-index calculus where the index counts
    pderiv-iterations until vanishing. The power rule is the workhorse
    for monomial-by-monomial reasoning. -/
theorem session_115_pderiv_X_pow_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Power rule
    (∀ (i : σ) (n : ℕ),
        pderiv i ((X i : MvPolynomial σ R) ^ n) = (n : MvPolynomial σ R) * (X i)^(n - 1))
    -- (2) Cross-variable
    ∧ (∀ {i j : σ} (h : j ≠ i) (n : ℕ),
        pderiv i ((X j : MvPolynomial σ R) ^ n) = 0)
    -- (3) Scaled
    ∧ (∀ (i : σ) (r : R) (n : ℕ),
        pderiv i (C r * (X i : MvPolynomial σ R)^n) =
          C r * ((n : MvPolynomial σ R) * (X i)^(n-1))) := by
  refine ⟨T5_pderiv_X_pow_self, ?_, T5_pderiv_C_mul_X_pow⟩
  intros i j h n; exact T5_pderiv_X_pow_of_ne h n

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow
