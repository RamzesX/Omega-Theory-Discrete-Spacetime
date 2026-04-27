/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyLeadingCoeffZeroC

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 172.
  `Polynomial.leadingCoeff` of zero / C.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.leadingCoeff` on basic generators:

  1. **`T5_polynomial_leadingCoeff_zero`** : `(0 : R[X]).leadingCoeff = 0`.
  2. **`T5_polynomial_leadingCoeff_C`** : `(C a).leadingCoeff = a`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyLeadingCoeffZeroC

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## leadingCoeff of zero -/

/-- **Wave T5 session 172 — `(0 : R[X]).leadingCoeff = 0`**. -/
theorem T5_polynomial_leadingCoeff_zero :
    Polynomial.leadingCoeff (0 : R[X]) = 0 :=
  Polynomial.leadingCoeff_zero

/-! ## leadingCoeff of C -/

/-- **Wave T5 session 172 — `(C a).leadingCoeff = a`**. -/
theorem T5_polynomial_leadingCoeff_C (a : R) :
    (Polynomial.C a : R[X]).leadingCoeff = a :=
  Polynomial.leadingCoeff_C a

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 172 — leadingCoeff zero / C**.

    Two foundational identities:
    1. `(0).leadingCoeff = 0`.
    2. `(C a).leadingCoeff = a`.

    Sub-lemma 59/N in T-5 Phase 3.  Lean-core only. -/
theorem session_172_polynomial_leadingCoeff_zero_C_headline
    {R : Type*} [Semiring R] :
    -- (1) zero
    (Polynomial.leadingCoeff (0 : R[X]) = 0)
    -- (2) C a
    ∧ (∀ (a : R), (Polynomial.C a : R[X]).leadingCoeff = a) :=
  ⟨T5_polynomial_leadingCoeff_zero, T5_polynomial_leadingCoeff_C⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyLeadingCoeffZeroC
