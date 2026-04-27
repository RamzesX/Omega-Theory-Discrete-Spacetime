/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalAddMul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 155.
  `Polynomial.aeval` add/mul (algebra-hom).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.aeval` algebra-hom identities:

  1. **`T5_polynomial_aeval_add`** : `aeval x (p + q) = aeval x p + aeval x q`.
  2. **`T5_polynomial_aeval_mul`** : `aeval x (p * q) = aeval x p * aeval x q`.

  Confirms `aeval x : R[X] → A` is an algebra homomorphism.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalAddMul

open Polynomial

variable {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A]

/-! ## aeval is additive + multiplicative -/

/-- **Wave T5 session 155 — `aeval` is additive**.

    `aeval x (p + q) = aeval x p + aeval x q`. -/
theorem T5_polynomial_aeval_add {p q : R[X]} (x : A) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) (p + q) =
      (Polynomial.aeval x) p + (Polynomial.aeval x) q :=
  Polynomial.aeval_add x

/-- **Wave T5 session 155 — `aeval` is multiplicative**.

    `aeval x (p * q) = aeval x p * aeval x q`. -/
theorem T5_polynomial_aeval_mul {p q : R[X]} (x : A) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) (p * q) =
      (Polynomial.aeval x) p * (Polynomial.aeval x) q :=
  Polynomial.aeval_mul x

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 155 — aeval add/mul (algebra hom)**.

    Two algebra-hom identities for univariate `aeval x`:
    1. `aeval x (p + q) = aeval x p + aeval x q` (additive).
    2. `aeval x (p * q) = aeval x p * aeval x q` (multiplicative).

    Confirms `aeval x : R[X] → A` is an algebra homomorphism.

    Sub-lemma 42/N in T-5 Phase 3.  Lean-core only. -/
theorem session_155_polynomial_aeval_add_mul_headline
    {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A] :
    -- (1) additive
    (∀ {p q : R[X]} (x : A),
        (Polynomial.aeval x : R[X] →ₐ[R] A) (p + q) =
          (Polynomial.aeval x) p + (Polynomial.aeval x) q)
    -- (2) multiplicative
    ∧ (∀ {p q : R[X]} (x : A),
        (Polynomial.aeval x : R[X] →ₐ[R] A) (p * q) =
          (Polynomial.aeval x) p * (Polynomial.aeval x) q) :=
  ⟨fun {_ _} x => T5_polynomial_aeval_add x,
   fun {_ _} x => T5_polynomial_aeval_mul x⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalAddMul
