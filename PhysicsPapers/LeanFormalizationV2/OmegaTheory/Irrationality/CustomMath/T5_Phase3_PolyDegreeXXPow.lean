/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeXXPow

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 159.
  `Polynomial.degree` of X / X^n (WithBot ℕ).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.degree` on basic generators:

  1. **`T5_polynomial_degree_X`** : `X.degree = 1` (Nontrivial R).
  2. **`T5_polynomial_degree_X_pow`** : `(X^n).degree = (n : WithBot ℕ)`.

  Mirror of the `natDegree` versions (s146, s147) but for WithBot-ℕ-
  valued degree.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeXXPow

open Polynomial

/-! ## degree of X -/

/-- **Wave T5 session 159 — `degree X = 1`** (Nontrivial R). -/
theorem T5_polynomial_degree_X
    {R : Type*} [Semiring R] [Nontrivial R] :
    (Polynomial.X : R[X]).degree = 1 :=
  Polynomial.degree_X

/-- **Wave T5 session 159 — `(X^n).degree = (n : WithBot ℕ)`**. -/
theorem T5_polynomial_degree_X_pow
    {R : Type*} [Semiring R] [Nontrivial R] (n : ℕ) :
    ((X : R[X]) ^ n).degree = (n : WithBot ℕ) :=
  Polynomial.degree_X_pow n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 159 — degree of X / X^n**.

    Two foundational identities:
    1. `(X : R[X]).degree = 1`.
    2. `(X^n : R[X]).degree = (n : WithBot ℕ)`.

    Sub-lemma 46/N in T-5 Phase 3.  Lean-core only.

    Mirror of natDegree versions (s146, s147) for WithBot-ℕ-valued
    degree. -/
theorem session_159_polynomial_degree_X_X_pow_headline :
    -- (1) X
    (∀ {R : Type*} [_inst : Semiring R] [_nt : Nontrivial R],
        (Polynomial.X : R[X]).degree = 1)
    -- (2) X^n
    ∧ (∀ {R : Type*} [_inst : Semiring R] [_nt : Nontrivial R] (n : ℕ),
        ((X : R[X]) ^ n).degree = (n : WithBot ℕ)) := by
  refine ⟨?_, ?_⟩
  · intros R _ _; exact T5_polynomial_degree_X
  · intros R _ _ n; exact T5_polynomial_degree_X_pow n

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeXXPow
