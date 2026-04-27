/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeZeroOne

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 160.
  `Polynomial.degree` of zero / one.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.degree` on zero / one:

  1. **`T5_polynomial_degree_zero`** : `(0 : R[X]).degree = ⊥`.
  2. **`T5_polynomial_degree_one`** : `(1 : R[X]).degree = 0` (Nontrivial).

  Mirror of the corresponding `natDegree` versions (s146).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeZeroOne

open Polynomial

/-! ## degree of zero -/

/-- **Wave T5 session 160 — `(0 : R[X]).degree = ⊥`**. -/
theorem T5_polynomial_degree_zero {R : Type*} [Semiring R] :
    (0 : R[X]).degree = ⊥ :=
  Polynomial.degree_zero

/-! ## degree of one -/

/-- **Wave T5 session 160 — `(1 : R[X]).degree = 0`** (Nontrivial R). -/
theorem T5_polynomial_degree_one {R : Type*} [Semiring R] [Nontrivial R] :
    (1 : R[X]).degree = 0 :=
  Polynomial.degree_one

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 160 — degree of zero / one**.

    Two foundational degree identities (WithBot ℕ-valued):
    1. `(0 : R[X]).degree = ⊥`.
    2. `(1 : R[X]).degree = 0` (with [Nontrivial R]).

    Sub-lemma 47/N in T-5 Phase 3.  Lean-core only. -/
theorem session_160_polynomial_degree_zero_one_headline :
    -- (1) zero
    (∀ {R : Type*} [_inst : Semiring R], (0 : R[X]).degree = ⊥)
    -- (2) one
    ∧ (∀ {R : Type*} [_inst : Semiring R] [_nt : Nontrivial R],
        (1 : R[X]).degree = 0) := by
  refine ⟨?_, ?_⟩
  · intros R _; exact T5_polynomial_degree_zero
  · intros R _ _; exact T5_polynomial_degree_one

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeZeroOne
