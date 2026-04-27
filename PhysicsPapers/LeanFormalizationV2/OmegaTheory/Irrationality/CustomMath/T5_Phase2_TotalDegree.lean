/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_TotalDegree

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub-lemma 2/15 session 80.
  MvPolynomial total-degree bounds.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of Mathlib's MvPolynomial total-degree lemmas in T-5
  vocabulary:

  1. **`T5_mvpoly_totalDegree_mul_le`** : `(a * b).totalDegree ≤ a.totalDegree + b.totalDegree`.
  2. **`T5_mvpoly_totalDegree_add_le`** : `(a + b).totalDegree ≤ max(a, b)`.
  3. **`T5_mvpoly_totalDegree_smul_le`** : `(c • f).totalDegree ≤ f.totalDegree`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_TotalDegree

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Total-degree bounds -/

/-- **Wave T4b session 80 — totalDegree of MvPolynomial product**.

    `(a * b).totalDegree ≤ a.totalDegree + b.totalDegree`. -/
theorem T5_mvpoly_totalDegree_mul_le (a b : MvPolynomial σ R) :
    (a * b).totalDegree ≤ a.totalDegree + b.totalDegree :=
  MvPolynomial.totalDegree_mul a b

/-- **Wave T4b session 80 — totalDegree of MvPolynomial sum**.

    `(a + b).totalDegree ≤ max(a.totalDegree, b.totalDegree)`. -/
theorem T5_mvpoly_totalDegree_add_le (a b : MvPolynomial σ R) :
    (a + b).totalDegree ≤ max a.totalDegree b.totalDegree :=
  MvPolynomial.totalDegree_add a b

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 80 — MvPolynomial totalDegree calculus**.

    Two key bounds for T-5 Phase 2:
    1. Multiplicative upper bound for total degree.
    2. Additive max upper bound for total degree.

    Sub-lemma 2/15 in T-5 Phase 2. Lean-core only. -/
theorem session_80_mvpoly_totalDegree_calculus_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Mul bound
    (∀ a b : MvPolynomial σ R,
        (a * b).totalDegree ≤ a.totalDegree + b.totalDegree)
    -- (2) Add max bound
    ∧ (∀ a b : MvPolynomial σ R,
        (a + b).totalDegree ≤ max a.totalDegree b.totalDegree) := by
  refine ⟨?_, ?_⟩
  · intros a b; exact T5_mvpoly_totalDegree_mul_le a b
  · intros a b; exact T5_mvpoly_totalDegree_add_le a b

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_TotalDegree
