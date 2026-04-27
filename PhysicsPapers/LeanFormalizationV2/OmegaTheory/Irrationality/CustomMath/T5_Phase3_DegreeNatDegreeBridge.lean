/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_DegreeNatDegreeBridge

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 157.
  Bridge `Polynomial.degree` ↔ `natDegree`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `Polynomial.degree_eq_natDegree`:

      For `p ≠ 0`, `p.degree = (p.natDegree : WithBot ℕ)`.

  Bridge between the `degree : WithBot ℕ` (where 0 polynomial has
  `⊥`) and `natDegree : ℕ` (where 0 polynomial has `0`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_DegreeNatDegreeBridge

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## degree / natDegree bridge -/

/-- **Wave T5 session 157 — `degree p = ↑p.natDegree` when `p ≠ 0`**. -/
theorem T5_polynomial_degree_eq_natDegree
    {p : R[X]} (hp : p ≠ 0) :
    p.degree = (p.natDegree : WithBot ℕ) :=
  Polynomial.degree_eq_natDegree hp

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 157 — degree ↔ natDegree bridge**.

    For non-zero `p`, the WithBot-valued `degree` and the ℕ-valued
    `natDegree` agree (via the canonical coercion).

    Sub-lemma 44/N in T-5 Phase 3.  Lean-core only.

    Used in T-5 to bridge between Mathlib's two `degree` notions. -/
theorem session_157_polynomial_degree_natDegree_headline
    {R : Type*} [Semiring R] :
    ∀ {p : R[X]}, p ≠ 0 → p.degree = (p.natDegree : WithBot ℕ) :=
  fun {p} hp => T5_polynomial_degree_eq_natDegree hp

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_DegreeNatDegreeBridge
