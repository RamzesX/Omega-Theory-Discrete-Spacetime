/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalZeroOne

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 166.
  `Polynomial.aeval` of zero / one (univariate).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.aeval` on zero / one:

  1. **`T5_polynomial_aeval_zero`** : `aeval x 0 = 0`.
  2. **`T5_polynomial_aeval_one`** : `aeval x 1 = 1`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalZeroOne

open Polynomial

variable {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A]

/-! ## aeval of zero / one -/

/-- **Wave T5 session 166 — `aeval x 0 = 0`**. -/
theorem T5_polynomial_aeval_zero (x : A) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) 0 = 0 :=
  Polynomial.aeval_zero x

/-- **Wave T5 session 166 — `aeval x 1 = 1`**. -/
theorem T5_polynomial_aeval_one (x : A) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) 1 = 1 :=
  Polynomial.aeval_one x

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 166 — aeval of zero / one**.

    Two foundational identities:
    1. `aeval x 0 = 0`.
    2. `aeval x 1 = 1`.

    Sub-lemma 53/N in T-5 Phase 3.  Lean-core only. -/
theorem session_166_polynomial_aeval_zero_one_headline
    {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A] :
    -- (1) zero
    (∀ (x : A), (Polynomial.aeval x : R[X] →ₐ[R] A) 0 = 0)
    -- (2) one
    ∧ (∀ (x : A), (Polynomial.aeval x : R[X] →ₐ[R] A) 1 = 1) :=
  ⟨T5_polynomial_aeval_zero, T5_polynomial_aeval_one⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalZeroOne
