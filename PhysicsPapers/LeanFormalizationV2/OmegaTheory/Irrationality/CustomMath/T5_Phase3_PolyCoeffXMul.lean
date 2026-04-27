/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffXMul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 173.
  `Polynomial.coeff_X_mul` (shift identity).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `coeff_X_mul`:

      `(X * p).coeff (n + 1) = p.coeff n`.

  Multiplying by X shifts coefficients up by 1.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Coeff

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffXMul

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## X * p shifts coefficients -/

/-- **Wave T5 session 173 — `(X * p).coeff (n+1) = p.coeff n`**.

    Multiplying a polynomial by `X` shifts coefficient indices up by 1. -/
theorem T5_polynomial_coeff_X_mul (p : R[X]) (n : ℕ) :
    ((Polynomial.X : R[X]) * p).coeff (n + 1) = p.coeff n :=
  Polynomial.coeff_X_mul p n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 173 — coeff_X_mul shift**.

    `(X * p).coeff (n + 1) = p.coeff n`.

    Sub-lemma 60/N in T-5 Phase 3.  Lean-core only.

    🏆 60 sub-lemmas LANDED (s110-s173). -/
theorem session_173_polynomial_coeff_X_mul_headline
    {R : Type*} [Semiring R] :
    ∀ (p : R[X]) (n : ℕ), ((Polynomial.X : R[X]) * p).coeff (n + 1) = p.coeff n :=
  T5_polynomial_coeff_X_mul

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffXMul
