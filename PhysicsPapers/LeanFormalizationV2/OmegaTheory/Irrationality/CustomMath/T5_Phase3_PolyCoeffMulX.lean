/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffMulX

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 174.
  `Polynomial.coeff_mul_X` (right shift identity).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `coeff_mul_X`:

      `(p * X).coeff (n + 1) = p.coeff n`.

  Multiplying on the right by X shifts coefficients up by 1.
  Companion to `coeff_X_mul` (s173, left multiplication).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Coeff

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffMulX

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## p * X shifts coefficients -/

/-- **Wave T5 session 174 — `(p * X).coeff (n+1) = p.coeff n`**.

    Right-multiplying by `X` shifts coefficient indices up by 1. -/
theorem T5_polynomial_coeff_mul_X (p : R[X]) (n : ℕ) :
    (p * (Polynomial.X : R[X])).coeff (n + 1) = p.coeff n :=
  Polynomial.coeff_mul_X p n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 174 — coeff_mul_X (right shift)**.

    `(p * X).coeff (n + 1) = p.coeff n`.

    Sub-lemma 61/N in T-5 Phase 3.  Lean-core only.

    Found via `mcp__omega-orchestrator__omega_hammer_premise` with
    similarity 0.967 on goal `coeff (X*p) = coeff p`. -/
theorem session_174_polynomial_coeff_mul_X_headline
    {R : Type*} [Semiring R] :
    ∀ (p : R[X]) (n : ℕ), (p * (Polynomial.X : R[X])).coeff (n + 1) = p.coeff n :=
  T5_polynomial_coeff_mul_X

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffMulX
