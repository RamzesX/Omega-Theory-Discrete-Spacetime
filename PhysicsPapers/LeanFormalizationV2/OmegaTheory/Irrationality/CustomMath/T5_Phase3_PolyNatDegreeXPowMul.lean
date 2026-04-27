/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeXPowMul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 147.
  `Polynomial.natDegree` of X^n and product.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.natDegree` on X^n + mul:

  1. **`T5_polynomial_natDegree_X_pow`** : `(X^n).natDegree = n` (Nontrivial).
  2. **`T5_polynomial_natDegree_mul_le`** : `(p * q).natDegree ≤ p.natDegree + q.natDegree`.

  Univariate analogue of the totalDegree mul bound (s128).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeXPowMul

open Polynomial

/-! ## natDegree of X^n -/

/-- **Wave T5 session 147 — `natDegree (X^n) = n`** (Nontrivial R). -/
theorem T5_polynomial_natDegree_X_pow
    {R : Type*} [Semiring R] [Nontrivial R] (n : ℕ) :
    ((X : R[X]) ^ n).natDegree = n :=
  Polynomial.natDegree_X_pow n

/-! ## natDegree of product is bounded -/

/-- **Wave T5 session 147 — `natDegree (p*q) ≤ p.natDegree + q.natDegree`**. -/
theorem T5_polynomial_natDegree_mul_le
    {R : Type*} [Semiring R] {p q : R[X]} :
    (p * q).natDegree ≤ p.natDegree + q.natDegree :=
  Polynomial.natDegree_mul_le

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 147 — natDegree of X^n + mul**.

    Two foundational identities:
    1. `natDegree (X^n) = n`  (with [Nontrivial R]).
    2. `natDegree (p*q) ≤ p.natDegree + q.natDegree`.

    Sub-lemma 35/N in T-5 Phase 3.  Lean-core only.

    Univariate analogue of the totalDegree mul bound (s128). -/
theorem session_147_polynomial_natDegree_X_pow_mul_headline :
    -- (1) X^n
    (∀ {R : Type*} [_inst : Semiring R] [_nt : Nontrivial R] (n : ℕ),
        ((X : R[X]) ^ n).natDegree = n)
    -- (2) mul bound
    ∧ (∀ {R : Type*} [_inst : Semiring R] {p q : R[X]},
        (p * q).natDegree ≤ p.natDegree + q.natDegree) := by
  refine ⟨?_, ?_⟩
  · intros R _ _ n; exact T5_polynomial_natDegree_X_pow n
  · intros R _ p q; exact T5_polynomial_natDegree_mul_le

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeXPowMul
