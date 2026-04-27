/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeGenerators

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 129.
  totalDegree of generators (X, 1, monomial).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's totalDegree on basic generators:

  1. **`T5_totalDegree_X`** : `(X s).totalDegree = 1` (with [Nontrivial R]).
  2. **`T5_totalDegree_one`** : `(1 : MvPolynomial σ R).totalDegree = 0`.
  3. **`T5_degreeOf_le_totalDegree`** : `f.degreeOf i ≤ f.totalDegree`.
  4. **`T5_mem_support_iff`** : `m ∈ p.support ↔ p.coeff m ≠ 0`.

  Found via `mcp__omega-orchestrator__omega_hammer_premise`.

  Used in T-5 polynomial-index calculus where individual variable
  degree bounds give degree-of-each-variable bounds for Roth setup.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Algebra.MvPolynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeGenerators

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## totalDegree of generators -/

/-- **Wave T5 session 129 — `totalDegree (X s) = 1`** (Nontrivial R). -/
theorem T5_totalDegree_X [Nontrivial R] (s : σ) :
    (X s : MvPolynomial σ R).totalDegree = 1 :=
  MvPolynomial.totalDegree_X s

/-- **Wave T5 session 129 — `totalDegree (1) = 0`**. -/
theorem T5_totalDegree_one :
    (1 : MvPolynomial σ R).totalDegree = 0 :=
  MvPolynomial.totalDegree_one

/-- **Wave T5 session 129 — `degreeOf i f ≤ totalDegree f`**.

    Each individual variable's degree is bounded by the total degree. -/
theorem T5_degreeOf_le_totalDegree (f : MvPolynomial σ R) (i : σ) :
    f.degreeOf i ≤ f.totalDegree :=
  MvPolynomial.degreeOf_le_totalDegree f i

/-- **Wave T5 session 129 — `m ∈ support iff coeff m ≠ 0`**. -/
theorem T5_mem_support_iff {p : MvPolynomial σ R} {m : σ →₀ ℕ} :
    m ∈ p.support ↔ MvPolynomial.coeff m p ≠ 0 :=
  MvPolynomial.mem_support_iff

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 129 — totalDegree of generators**.

    Four foundational identities:
    1. `totalDegree (X s) = 1` (Nontrivial R).
    2. `totalDegree (1) = 0`.
    3. `degreeOf i f ≤ totalDegree f`.
    4. `m ∈ p.support ↔ coeff m p ≠ 0`.

    Sub-lemma 18/N in T-5 Phase 3.  Lean-core only.

    Found via `mcp__omega-orchestrator__omega_hammer_premise`.

    Used in Roth's polynomial-index calculus where individual variable
    degree bounds give input parameters for the gap principle. -/
theorem session_129_total_degree_generators_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) X
    (∀ [inst : Nontrivial R] (s : σ),
        (X s : MvPolynomial σ R).totalDegree = 1)
    -- (2) 1
    ∧ ((1 : MvPolynomial σ R).totalDegree = 0)
    -- (3) degreeOf bound
    ∧ (∀ (f : MvPolynomial σ R) (i : σ), f.degreeOf i ≤ f.totalDegree)
    -- (4) support iff
    ∧ (∀ {p : MvPolynomial σ R} {m : σ →₀ ℕ},
        m ∈ p.support ↔ MvPolynomial.coeff m p ≠ 0) := by
  refine ⟨?_, T5_totalDegree_one, T5_degreeOf_le_totalDegree, ?_⟩
  · intros _ s; exact T5_totalDegree_X s
  · intros p m; exact T5_mem_support_iff

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeGenerators
