/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffXC

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 148.
  `Polynomial.coeff` of X / C.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.coeff` on basic generators:

  1. **`T5_polynomial_coeff_X`** : `X.coeff n = if 1 = n then 1 else 0`.
  2. **`T5_polynomial_coeff_C`** : `(C a).coeff n = if n = 0 then a else 0`.

  Used in T-5 polynomial-index calculus where the support / coefficient
  structure of polynomials drives Roth's lemma.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffXC

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## coeff of X -/

/-- **Wave T5 session 148 — `coeff X n = if 1 = n then 1 else 0`**. -/
theorem T5_polynomial_coeff_X (n : ℕ) :
    (Polynomial.X : R[X]).coeff n = if 1 = n then 1 else 0 :=
  Polynomial.coeff_X

/-! ## coeff of C -/

/-- **Wave T5 session 148 — `coeff (C a) n = if n = 0 then a else 0`**. -/
theorem T5_polynomial_coeff_C {a : R} (n : ℕ) :
    (Polynomial.C a : R[X]).coeff n = if n = 0 then a else 0 :=
  Polynomial.coeff_C

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 148 — Polynomial.coeff of X / C**.

    Two foundational coefficient identities:
    1. `(X : R[X]).coeff n = if 1 = n then 1 else 0`.
    2. `(C a).coeff n = if n = 0 then a else 0`.

    Sub-lemma 36/N in T-5 Phase 3.  Lean-core only.

    Used in T-5 polynomial-index calculus where the support /
    coefficient structure of polynomials drives Roth's lemma. -/
theorem session_148_polynomial_coeff_X_C_headline {R : Type*} [Semiring R] :
    -- (1) X
    (∀ (n : ℕ), (Polynomial.X : R[X]).coeff n = if 1 = n then 1 else 0)
    -- (2) C a
    ∧ (∀ {a : R} (n : ℕ),
        (Polynomial.C a : R[X]).coeff n = if n = 0 then a else 0) :=
  ⟨T5_polynomial_coeff_X, fun {a} n => T5_polynomial_coeff_C (a := a) n⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffXC
