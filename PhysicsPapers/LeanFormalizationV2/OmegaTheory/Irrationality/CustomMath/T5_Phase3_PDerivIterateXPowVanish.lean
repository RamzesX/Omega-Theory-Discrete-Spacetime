/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPowVanish

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 119.
  High-order pderiv vanishing on low-degree X^n.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  When `k > n`, `(pderiv i)^[k] (X i^n) = 0`.  Cited via the falling
  factorial identity (s118) + Mathlib's `Nat.descFactorial_eq_zero_iff_lt`.

  Crucial for Roth's polynomial-index calculus: the index measures the
  minimal `k` such that some derivative-iterate vanishes — for a
  monomial `X i^n`, that minimum is `k = n + 1`.

  Main result:
  **`T5_pderiv_iterate_X_pow_eq_zero_of_gt`**: if `n < k`, then
  `(pderiv i)^[k] (X i^n) = 0`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPowVanish

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

variable {σ R : Type*} [CommSemiring R]

/-! ## High-order pderiv vanishing -/

/-- **Wave T5 session 119 — `(pderiv i)^[k] (X i^n) = 0` when k > n**.

    For `n < k`, the descending factorial `n.descFactorial k = 0`, so
    by s118's closed form, the iterated pderiv vanishes. -/
theorem T5_pderiv_iterate_X_pow_eq_zero_of_gt
    (i : σ) (n k : ℕ) (h : n < k) :
    ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n)) = 0 := by
  rw [T5_pderiv_iterate_X_pow_self]
  have hdesc : n.descFactorial k = 0 := Nat.descFactorial_eq_zero_iff_lt.mpr h
  rw [hdesc]
  simp

/-- **Wave T5 session 119 — `(pderiv i)^[n+1] (X i^n) = 0`** (boundary case).

    The smallest `k` for which `(pderiv i)^[k] (X i^n)` vanishes is
    `k = n + 1`. -/
theorem T5_pderiv_iterate_X_pow_eq_zero_succ
    (i : σ) (n : ℕ) :
    ((pderiv i)^[n + 1] ((X i : MvPolynomial σ R) ^ n)) = 0 :=
  T5_pderiv_iterate_X_pow_eq_zero_of_gt i n (n + 1) (Nat.lt_succ_self n)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 119 — pderiv-iterate vanishes on low-deg X^n**.

    Two formulations:
    1. `(pderiv i)^[k] (X i^n) = 0` for `n < k`.
    2. `(pderiv i)^[n+1] (X i^n) = 0` (boundary).

    Sub-lemma 9/N in T-5 Phase 3.  Lean-core only.

    Crucial for Roth's polynomial-index calculus: the index measures
    minimal `k` for vanishing.  For monomial `X i^n`, minimum is `n+1`. -/
theorem session_119_pderiv_iterate_vanishing_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) k > n vanishing
    (∀ (i : σ) (n k : ℕ), n < k →
        ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n)) = 0)
    -- (2) Boundary k = n+1
    ∧ (∀ (i : σ) (n : ℕ),
        ((pderiv i)^[n + 1] ((X i : MvPolynomial σ R) ^ n)) = 0) := by
  refine ⟨?_, ?_⟩
  · exact T5_pderiv_iterate_X_pow_eq_zero_of_gt
  · exact T5_pderiv_iterate_X_pow_eq_zero_succ

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPowVanish
