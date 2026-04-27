/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateScaledXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 124.
  Iterated pderiv of `C r * X i^n`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Two foundational identities:

  1. **`T5_pderiv_iterate_C_mul`** : iteration commutes with `C r *`.
     `(pderiv i)^[k] (C r * p) = C r * (pderiv i)^[k] p`.
  2. **`T5_pderiv_iterate_C_mul_X_pow`** : iterated pderiv of scaled `X^n`.
     `(pderiv i)^[k] (C r * X i^n) = C r * (n.descFactorial k : R) * X i^(n-k)`.

  Used in Roth's polynomial-index calculus where each monomial of an
  auxiliary polynomial is `c_α * X^α` for some integer coefficient.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateScaledXPow

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

variable {σ R : Type*} [CommSemiring R]

/-! ## Iteration commutes with C-multiplication -/

/-- **Wave T5 session 124 — `(pderiv i)^[k]` commutes with `C r * _`**.

    `(pderiv i)^[k] (C r * p) = C r * (pderiv i)^[k] p`. -/
theorem T5_pderiv_iterate_C_mul (i : σ) (r : R) (k : ℕ) (p : MvPolynomial σ R) :
    ((pderiv i)^[k] (C r * p)) = C r * ((pderiv i)^[k] p) := by
  induction k generalizing p with
  | zero => simp
  | succ m ih =>
    rw [Function.iterate_succ_apply, pderiv_C_mul, ih,
        ← Function.iterate_succ_apply]

/-! ## Iterated pderiv of scaled X^n -/

/-- **Wave T5 session 124 — `(pderiv i)^[k] (C r * X i^n)`**.

    `(pderiv i)^[k] (C r * X i^n) = C r * (n.descFactorial k : R) * X i^(n-k)`.

    Iterated power rule with leading coefficient. -/
theorem T5_pderiv_iterate_C_mul_X_pow (i : σ) (r : R) (n k : ℕ) :
    ((pderiv i)^[k] (C r * (X i : MvPolynomial σ R)^n)) =
      C r * (n.descFactorial k : MvPolynomial σ R) * (X i)^(n - k) := by
  rw [T5_pderiv_iterate_C_mul, T5_pderiv_iterate_X_pow_self, mul_assoc]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 124 — iterated pderiv of scaled X^n**.

    Two facts:
    1. Iteration commutes with `C r *` (linearity over ground ring).
    2. Iterated pderiv of `C r * X i^n` equals
       `C r * (n.descFactorial k) * X i^(n-k)`.

    Sub-lemma 13/N in T-5 Phase 3.  Lean-core only.

    Used in Roth's polynomial-index calculus for handling monomials
    with leading coefficients. -/
theorem session_124_pderiv_iterate_C_mul_X_pow_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Iteration commutes with C r * _
    (∀ (i : σ) (r : R) (k : ℕ) (p : MvPolynomial σ R),
        ((pderiv i)^[k] (C r * p)) = C r * ((pderiv i)^[k] p))
    -- (2) Closed form for C r * X i^n
    ∧ (∀ (i : σ) (r : R) (n k : ℕ),
        ((pderiv i)^[k] (C r * (X i : MvPolynomial σ R)^n)) =
          C r * (n.descFactorial k : MvPolynomial σ R) * (X i)^(n - k)) :=
  ⟨T5_pderiv_iterate_C_mul, T5_pderiv_iterate_C_mul_X_pow⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateScaledXPow
