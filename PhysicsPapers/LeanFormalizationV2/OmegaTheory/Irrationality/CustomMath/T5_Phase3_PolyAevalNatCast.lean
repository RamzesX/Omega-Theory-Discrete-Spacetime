/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalNatCast

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 168.
  `Polynomial.aeval_natCast`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `Polynomial.aeval_natCast`:

      `aeval x (n : R[X]) = (n : A)` for `n : ℕ`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalNatCast

open Polynomial

variable {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A]

/-! ## aeval of natural cast -/

/-- **Wave T5 session 168 — `aeval x (n : R[X]) = (n : A)`** for `n : ℕ`. -/
theorem T5_polynomial_aeval_natCast (x : A) (n : ℕ) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) (n : R[X]) = (n : A) :=
  Polynomial.aeval_natCast x n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 168 — `aeval (n : R[X]) = (n : A)`**.

    Naturals cast through aeval to naturals (in any algebra A over R).

    Sub-lemma 55/N in T-5 Phase 3.  Lean-core only. -/
theorem session_168_polynomial_aeval_natCast_headline
    {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A] :
    ∀ (x : A) (n : ℕ),
        (Polynomial.aeval x : R[X] →ₐ[R] A) (n : R[X]) = (n : A) :=
  T5_polynomial_aeval_natCast

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalNatCast
