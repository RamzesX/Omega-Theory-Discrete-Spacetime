/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 118.
  Iterated `pderiv` on `X i^n` — falling factorial closed form.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Closed form for `(pderiv i)^[k] (X i^n)` when `k ≤ n`:

      `(pderiv i)^[k] (X i^n) = (n.descFactorial k : MvPolynomial σ R) * X i^(n-k)`

  Where `n.descFactorial k = n * (n-1) * ... * (n-k+1) = n! / (n-k)!`
  is the descending factorial.

  This is the analogue of `(d/dx)^k (x^n) = n!/(n-k)! * x^(n-k)`.

  Proof: induction on k using s115's power rule.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow

variable {σ R : Type*} [CommSemiring R]

/-! ## Falling-factorial pderiv-iterate -/

/-- **Wave T5 session 118 — Iterated pderiv on `X i^n`** (closed form).

    `(pderiv i)^[k] (X i^n) = (n.descFactorial k : R) * X i^(n-k)`.

    The polynomial analogue of the falling-factorial closed form. -/
theorem T5_pderiv_iterate_X_pow_self (i : σ) (n k : ℕ) :
    ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n)) =
      (n.descFactorial k : MvPolynomial σ R) * (X i)^(n - k) := by
  induction k with
  | zero =>
    simp [Nat.descFactorial_zero]
  | succ m ih =>
    rw [Function.iterate_succ_apply', ih]
    -- Goal: pderiv i ((n.descFactorial m : MvPolynomial σ R) * X i^(n-m)) =
    --       ((n.descFactorial (m+1)) : MvPolynomial σ R) * X i^(n - (m+1))
    rw [Derivation.leibniz, T5_pderiv_X_pow_self,
        (pderiv i).map_natCast (n.descFactorial m), smul_zero, add_zero, smul_eq_mul]
    -- Goal: (n.descFactorial m : MvPolynomial σ R) * ((n - m : MvPolynomial σ R) * X i^(n-m-1))
    --     = (n.descFactorial (m+1) : MvPolynomial σ R) * X i^(n - (m+1))
    rw [← mul_assoc]
    have hdesc : (n.descFactorial m : MvPolynomial σ R) * (n - m : MvPolynomial σ R) =
                 ((n.descFactorial (m+1) : ℕ) : MvPolynomial σ R) := by
      rw [Nat.descFactorial_succ, Nat.cast_mul, mul_comm]
    have hpow : ((X i : MvPolynomial σ R)) ^ (n - m - 1) = (X i)^(n - (m+1)) := by
      congr 1
    rw [hdesc, hpow]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 118 — falling-factorial pderiv-iterate**.

    `(pderiv i)^[k] (X i^n) = (n.descFactorial k : R) * X i^(n-k)`.

    Sub-lemma 8/N in T-5 Phase 3.  Lean-core only.

    Polynomial analogue of `(d/dx)^k (x^n) = n!/(n-k)! * x^(n-k)`.
    Used in Roth's polynomial-index calculus to compute high-order
    derivatives of monomials at integer/rational points. -/
theorem session_118_pderiv_iterate_X_pow_headline
    {σ R : Type*} [CommSemiring R] :
    ∀ (i : σ) (n k : ℕ),
        ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n)) =
          (n.descFactorial k : MvPolynomial σ R) * (X i)^(n - k) :=
  T5_pderiv_iterate_X_pow_self

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow
