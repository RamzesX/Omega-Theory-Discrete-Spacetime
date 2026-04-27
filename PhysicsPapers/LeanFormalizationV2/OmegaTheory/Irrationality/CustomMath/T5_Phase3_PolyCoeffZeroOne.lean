/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffZeroOne

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 152.
  `Polynomial.coeff` of zero / one.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.coeff` on zero and one:

  1. **`T5_polynomial_coeff_zero`** : `(0).coeff n = 0`.
  2. **`T5_polynomial_coeff_one`** : `(1).coeff n = if n = 0 then 1 else 0`.

  Used in T-5 polynomial-index calculus where the constant polynomial
  evaluates to its only nonzero coefficient.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffZeroOne

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## coeff of zero / one -/

/-- **Wave T5 session 152 — `(0 : R[X]).coeff n = 0`**. -/
theorem T5_polynomial_coeff_zero (n : ℕ) :
    (0 : R[X]).coeff n = 0 :=
  Polynomial.coeff_zero n

/-- **Wave T5 session 152 — `(1 : R[X]).coeff n = if n = 0 then 1 else 0`**. -/
theorem T5_polynomial_coeff_one {n : ℕ} :
    (1 : R[X]).coeff n = if n = 0 then 1 else 0 :=
  Polynomial.coeff_one

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 152 — Polynomial.coeff zero / one**.

    Two foundational coefficient identities:
    1. `(0 : R[X]).coeff n = 0`.
    2. `(1 : R[X]).coeff n = if n = 0 then 1 else 0`.

    Sub-lemma 39/N in T-5 Phase 3.  Lean-core only. -/
theorem session_152_polynomial_coeff_zero_one_headline {R : Type*} [Semiring R] :
    -- (1) zero
    (∀ (n : ℕ), (0 : R[X]).coeff n = 0)
    -- (2) one
    ∧ (∀ {n : ℕ}, (1 : R[X]).coeff n = if n = 0 then 1 else 0) :=
  ⟨T5_polynomial_coeff_zero, fun {n} => T5_polynomial_coeff_one (n := n)⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffZeroOne
