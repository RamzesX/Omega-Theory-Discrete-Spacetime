/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeGenerators

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 146.
  `Polynomial.natDegree` of generators.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.natDegree` on basic generators:

  1. **`T5_polynomial_natDegree_C`** : `(C a).natDegree = 0`.
  2. **`T5_polynomial_natDegree_X`** : `X.natDegree = 1` (Nontrivial R).
  3. **`T5_polynomial_natDegree_one`** : `(1).natDegree = 0`.

  Univariate analogue of T5_Phase3_TotalDegreeGenerators (s129).

  Used in T-5 polynomial-index calculus where degree bounds on
  univariate auxiliary polynomials appear in the Liouville/Roth
  approximation arguments.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeGenerators

open Polynomial

/-! ## natDegree of generators -/

/-- **Wave T5 session 146 — `natDegree (C a) = 0`**. -/
theorem T5_polynomial_natDegree_C {R : Type*} [Semiring R] (a : R) :
    (Polynomial.C a : R[X]).natDegree = 0 :=
  Polynomial.natDegree_C a

/-- **Wave T5 session 146 — `natDegree X = 1`** (Nontrivial R). -/
theorem T5_polynomial_natDegree_X {R : Type*} [Semiring R] [Nontrivial R] :
    (Polynomial.X : R[X]).natDegree = 1 :=
  Polynomial.natDegree_X

/-- **Wave T5 session 146 — `natDegree 1 = 0`**. -/
theorem T5_polynomial_natDegree_one {R : Type*} [Semiring R] :
    (1 : R[X]).natDegree = 0 :=
  Polynomial.natDegree_one

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 146 — Polynomial.natDegree of generators**.

    Three foundational identities:
    1. `natDegree (C a) = 0`.
    2. `natDegree X = 1` (Nontrivial R).
    3. `natDegree 1 = 0`.

    Sub-lemma 34/N in T-5 Phase 3.  Lean-core only.

    Univariate analogue of T5_Phase3_TotalDegreeGenerators (s129). -/
theorem session_146_polynomial_natDegree_generators_headline :
    -- (1) C
    (∀ {R : Type*} [_inst : Semiring R] (a : R),
        (Polynomial.C a : R[X]).natDegree = 0)
    -- (2) X
    ∧ (∀ {R : Type*} [_inst : Semiring R] [_nt : Nontrivial R],
        (Polynomial.X : R[X]).natDegree = 1)
    -- (3) 1
    ∧ (∀ {R : Type*} [_inst : Semiring R],
        (1 : R[X]).natDegree = 0) := by
  refine ⟨?_, ?_, ?_⟩
  · intros R _ a; exact T5_polynomial_natDegree_C a
  · intros R _ _; exact T5_polynomial_natDegree_X
  · intros R _; exact T5_polynomial_natDegree_one

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeGenerators
