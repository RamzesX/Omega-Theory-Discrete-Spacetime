/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalNegXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 167.
  `Polynomial.aeval` of negation + X^n.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.aeval` identities:

  1. **`T5_polynomial_aeval_neg`** : `aeval x (-p) = -aeval x p` (over Ring).
  2. **`T5_polynomial_aeval_X_pow`** : `aeval x (X^n) = x^n`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalNegXPow

open Polynomial

/-! ## aeval of negation -/

/-- **Wave T5 session 167 — `aeval x (-p) = -aeval x p`** (over Ring). -/
theorem T5_polynomial_aeval_neg
    {R A : Type*} [CommRing R] [Ring A] [Algebra R A]
    {p : R[X]} (x : A) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) (-p) =
      -(Polynomial.aeval x : R[X] →ₐ[R] A) p :=
  Polynomial.aeval_neg x

/-! ## aeval of X^n -/

/-- **Wave T5 session 167 — `aeval x (X^n) = x^n`**. -/
theorem T5_polynomial_aeval_X_pow
    {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A]
    (x : A) {n : ℕ} :
    (Polynomial.aeval x : R[X] →ₐ[R] A) (Polynomial.X ^ n) = x ^ n :=
  Polynomial.aeval_X_pow x

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 167 — aeval_neg + aeval_X_pow**.

    Two foundational identities:
    1. `aeval x (-p) = -aeval x p` (over Ring).
    2. `aeval x (X^n) = x^n`.

    Sub-lemma 54/N in T-5 Phase 3.  Lean-core only. -/
theorem session_167_polynomial_aeval_neg_X_pow_headline :
    -- (1) aeval_neg
    (∀ {R A : Type*} [_inst : CommRing R] [_inst' : Ring A] [_inst'' : Algebra R A]
        {p : R[X]} (x : A),
        (Polynomial.aeval x : R[X] →ₐ[R] A) (-p) =
          -(Polynomial.aeval x : R[X] →ₐ[R] A) p)
    -- (2) aeval_X_pow
    ∧ (∀ {R A : Type*} [_inst : CommSemiring R] [_inst' : Semiring A] [_inst'' : Algebra R A]
        (x : A) {n : ℕ},
        (Polynomial.aeval x : R[X] →ₐ[R] A) (Polynomial.X ^ n) = x ^ n) := by
  refine ⟨?_, ?_⟩
  · intros R A _ _ _ p x; exact T5_polynomial_aeval_neg x
  · intros R A _ _ _ x n; exact T5_polynomial_aeval_X_pow x

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalNegXPow
