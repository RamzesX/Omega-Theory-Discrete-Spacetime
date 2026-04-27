/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalBasics

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 145.
  `Polynomial.aeval` foundational identities (univariate).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's univariate `Polynomial.aeval`:

  1. **`T5_polynomial_aeval_X`** : `aeval x X = x`.
  2. **`T5_polynomial_aeval_C`** : `aeval x (C r) = algebraMap R A r`.

  Univariate analogue of T5_Phase3_AevalBasics (s120, MvPolynomial).

  Used in T-5 polynomial-index calculus, where univariate aeval
  appears for evaluation of minimal polynomials of algebraic α.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalBasics

open Polynomial

variable {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A]

/-! ## Polynomial.aeval on basic generators -/

/-- **Wave T5 session 145 — `aeval x X = x`**. -/
theorem T5_polynomial_aeval_X (x : A) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) Polynomial.X = x :=
  Polynomial.aeval_X x

/-- **Wave T5 session 145 — `aeval x (C r) = algebraMap R A r`**. -/
theorem T5_polynomial_aeval_C (x : A) (r : R) :
    (Polynomial.aeval x : R[X] →ₐ[R] A) (Polynomial.C r) = (algebraMap R A) r :=
  Polynomial.aeval_C x r

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 145 — Polynomial.aeval basics**.

    Two foundational identities (univariate version):
    1. `aeval x X = x`.
    2. `aeval x (C r) = algebraMap R A r`.

    Sub-lemma 33/N in T-5 Phase 3.  Lean-core only.

    Univariate analogue of T5_Phase3_AevalBasics (s120, MvPolynomial). -/
theorem session_145_polynomial_aeval_basics_headline
    {R A : Type*} [CommSemiring R] [Semiring A] [Algebra R A] :
    -- (1) aeval X
    (∀ (x : A),
        (Polynomial.aeval x : R[X] →ₐ[R] A) Polynomial.X = x)
    -- (2) aeval C
    ∧ (∀ (x : A) (r : R),
        (Polynomial.aeval x : R[X] →ₐ[R] A) (Polynomial.C r) =
          (algebraMap R A) r) :=
  ⟨T5_polynomial_aeval_X, T5_polynomial_aeval_C⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyAevalBasics
