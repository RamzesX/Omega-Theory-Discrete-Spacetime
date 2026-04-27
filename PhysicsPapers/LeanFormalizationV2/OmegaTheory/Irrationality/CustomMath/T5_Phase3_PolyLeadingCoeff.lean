/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyLeadingCoeff

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 171.
  `Polynomial.leadingCoeff` basics.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.leadingCoeff` identities:

  1. **`T5_polynomial_coeff_natDegree`** : `p.coeff p.natDegree = p.leadingCoeff`.
  2. **`T5_polynomial_leadingCoeff_X`** : `(X : R[X]).leadingCoeff = 1`.

  Used in T-5 polynomial-index calculus where the leading coefficient
  of the auxiliary polynomial controls bound estimates.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyLeadingCoeff

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## leadingCoeff via natDegree -/

/-- **Wave T5 session 171 — `coeff (natDegree p) = leadingCoeff`**. -/
theorem T5_polynomial_coeff_natDegree {p : R[X]} :
    p.coeff p.natDegree = p.leadingCoeff :=
  Polynomial.coeff_natDegree

/-! ## leadingCoeff of X -/

/-- **Wave T5 session 171 — `(X : R[X]).leadingCoeff = 1`**. -/
theorem T5_polynomial_leadingCoeff_X :
    (Polynomial.X : R[X]).leadingCoeff = 1 :=
  Polynomial.leadingCoeff_X

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 171 — leadingCoeff basics**.

    Two foundational identities:
    1. `p.coeff p.natDegree = p.leadingCoeff` (definitional bridge).
    2. `(X : R[X]).leadingCoeff = 1`.

    Sub-lemma 58/N in T-5 Phase 3.  Lean-core only.

    Used in T-5 polynomial-index calculus where the leading coefficient
    of the auxiliary polynomial controls bound estimates. -/
theorem session_171_polynomial_leadingCoeff_headline
    {R : Type*} [Semiring R] :
    -- (1) coeff_natDegree
    (∀ {p : R[X]}, p.coeff p.natDegree = p.leadingCoeff)
    -- (2) leadingCoeff_X
    ∧ ((Polynomial.X : R[X]).leadingCoeff = 1) :=
  ⟨fun {p} => T5_polynomial_coeff_natDegree, T5_polynomial_leadingCoeff_X⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyLeadingCoeff
