/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeChar

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 170.
  `Polynomial.degree` characterizations.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.degree` characterizations:

  1. **`T5_polynomial_degree_eq_bot`** : `p.degree = ⊥ ↔ p = 0`.
  2. **`T5_polynomial_natDegree_eq_zero_iff_degree_le_zero`** :
     `p.natDegree = 0 ↔ p.degree ≤ 0`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeChar

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## degree = ⊥ iff zero -/

/-- **Wave T5 session 170 — `p.degree = ⊥ ↔ p = 0`**. -/
theorem T5_polynomial_degree_eq_bot {p : R[X]} :
    p.degree = ⊥ ↔ p = 0 :=
  Polynomial.degree_eq_bot

/-! ## natDegree = 0 iff degree ≤ 0 -/

/-- **Wave T5 session 170 — `p.natDegree = 0 ↔ p.degree ≤ 0`**. -/
theorem T5_polynomial_natDegree_eq_zero_iff_degree_le_zero
    {p : R[X]} : p.natDegree = 0 ↔ p.degree ≤ 0 :=
  Polynomial.natDegree_eq_zero_iff_degree_le_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 170 — degree characterizations**.

    Two foundational characterizations:
    1. `p.degree = ⊥ ↔ p = 0`.
    2. `p.natDegree = 0 ↔ p.degree ≤ 0`.

    Sub-lemma 57/N in T-5 Phase 3.  Lean-core only. -/
theorem session_170_polynomial_degree_char_headline
    {R : Type*} [Semiring R] :
    -- (1) bot
    (∀ {p : R[X]}, p.degree = ⊥ ↔ p = 0)
    -- (2) natDegree = 0
    ∧ (∀ {p : R[X]}, p.natDegree = 0 ↔ p.degree ≤ 0) :=
  ⟨fun {p} => T5_polynomial_degree_eq_bot,
   fun {p} => T5_polynomial_natDegree_eq_zero_iff_degree_le_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeChar
