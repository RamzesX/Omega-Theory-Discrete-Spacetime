/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_FiniteSums

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 4/15 session 82.
  Total-degree bounds for finite sums and products of MvPolynomial.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports for auxiliary polynomial construction:

  1. **`T5_mvpoly_totalDegree_finset_sum`** : sum bound by max over factors.
  2. **`T5_mvpoly_totalDegree_finset_prod`** : product bound by sum of degrees.
  3. **`T5_mvpoly_totalDegree_finsetSum_le`** : if all factors have
     totalDegree ≤ d, then sum has totalDegree ≤ d.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_FiniteSums

open MvPolynomial

variable {σ R ι : Type*} [CommSemiring R]

/-! ## Finite sum -/

/-- **Wave T4b session 82 — totalDegree of finite sum bound**.

    For any Finset s and family f : ι → MvPolynomial σ R:

      `(s.sum f).totalDegree ≤ Finset.sup s (fun i => (f i).totalDegree)`. -/
theorem T5_mvpoly_totalDegree_finset_sum (s : Finset ι) (f : ι → MvPolynomial σ R) :
    (s.sum f).totalDegree ≤ Finset.sup s fun i => (f i).totalDegree :=
  MvPolynomial.totalDegree_finset_sum s f

/-- **Wave T4b session 82 — uniform total-degree bound**.

    If every factor f i has totalDegree ≤ d, then the sum's totalDegree ≤ d. -/
theorem T5_mvpoly_totalDegree_finsetSum_le {s : Finset ι} {f : ι → MvPolynomial σ R} {d : ℕ}
    (hf : ∀ i ∈ s, (f i).totalDegree ≤ d) : (s.sum f).totalDegree ≤ d :=
  MvPolynomial.totalDegree_finsetSum_le hf

/-! ## Finite product -/

/-- **Wave T4b session 82 — totalDegree of finite product bound**.

    For any Finset s and family f : ι → MvPolynomial σ R:

      `(s.prod f).totalDegree ≤ ∑ i ∈ s, (f i).totalDegree`. -/
theorem T5_mvpoly_totalDegree_finset_prod (s : Finset ι) (f : ι → MvPolynomial σ R) :
    (s.prod f).totalDegree ≤ ∑ i ∈ s, (f i).totalDegree :=
  MvPolynomial.totalDegree_finset_prod s f

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 82 — finite sum/product totalDegree bounds**.

    Three foundational bounds for MvPolynomial in T-5 Phase 2:
    1. Finite sum: bounded by max over factors.
    2. Uniform sum: if all ≤ d, then sum ≤ d.
    3. Finite product: bounded by sum of factor degrees.

    Sub-lemma 4/15 in T-5 Phase 2. Lean-core only. -/
theorem session_82_mvpoly_finite_sums_headline
    {σ R ι : Type*} [CommSemiring R] :
    -- (1) Sum max-bound
    (∀ s : Finset ι, ∀ f : ι → MvPolynomial σ R,
        (s.sum f).totalDegree ≤ Finset.sup s fun i => (f i).totalDegree)
    -- (2) Uniform sum
    ∧ (∀ s : Finset ι, ∀ f : ι → MvPolynomial σ R, ∀ d : ℕ,
        (∀ i ∈ s, (f i).totalDegree ≤ d) → (s.sum f).totalDegree ≤ d)
    -- (3) Product sum-bound
    ∧ (∀ s : Finset ι, ∀ f : ι → MvPolynomial σ R,
        (s.prod f).totalDegree ≤ ∑ i ∈ s, (f i).totalDegree) := by
  refine ⟨?_, ?_, ?_⟩
  · intros s f; exact T5_mvpoly_totalDegree_finset_sum s f
  · intros s f d hf; exact T5_mvpoly_totalDegree_finsetSum_le hf
  · intros s f; exact T5_mvpoly_totalDegree_finset_prod s f

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_FiniteSums
