/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots

  Cycle 63→64 Phase B Wave T-4b session 51 — roots of evaledFormalPoly.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Structural lemmas about `evaledFormalPoly := (formalSubsetSumPoly n).map (aeval α)`:

  1. **Each subset-sum is a root**: for any S : Finset (Fin n),
     `(evaledFormalPoly).eval (∑ i ∈ S, α i) = 0`.

  2. **Constant term is 0** (0 is a root): `evaledFormalPoly.eval 0 = 0`,
     since S = ∅ gives σ_∅ = 0.

  Combined with s50, these imply that p_ℤ.eval 0 = 0 (in ℂ via embedding),
  so X | p_ℤ in ℤ[X] (by monic-divisibility-lifts).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ

/-! ## evaledFormalPoly.eval at a subset-sum is zero -/

/-- For any subset `S : Finset (Fin n)` and any `α : Fin n → ℂ`, the
    evaluation of `(formalSubsetSumPoly n).map (aeval α)` at the
    subset-sum `∑ i ∈ S, α i` is zero.

    Proof: the formal poly factor `(X - C (∑ i ∈ S, MvPolynomial.X i))`
    becomes `(X - C (∑ i ∈ S, α i))` after aeval α; the product over all
    subsets has this factor; evaluating at `∑ i ∈ S, α i` makes that
    factor zero, hence the whole product is zero. -/
theorem evaledFormalPoly_eval_at_subset_sum_eq_zero
    (n : ℕ) (α : Fin n → ℂ) (S : Finset (Fin n)) (h_S_subset : S ⊆ Finset.univ) :
    (((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)).eval
      (∑ i ∈ S, α i) = 0 := by
  -- Unfold formalSubsetSumPoly
  unfold formalSubsetSumPoly
  -- Use: Polynomial.map of product, then eval
  rw [Polynomial.map_prod]
  -- Goal: (∏ T ∈ univ.powerset, (X - C (∑ i ∈ T, α i))).eval _ = 0
  -- Use: Polynomial.eval of product + S ∈ univ.powerset
  have h_S_mem : S ∈ (Finset.univ : Finset (Fin n)).powerset :=
    Finset.mem_powerset.mpr h_S_subset
  rw [Polynomial.eval_prod]
  -- Each factor's evaluation: (X - C σ_T).eval σ_S = σ_S - σ_T
  -- For T = S: σ_S - σ_S = 0 → product is 0
  apply Finset.prod_eq_zero h_S_mem
  -- Goal: ((X - C (∑ i ∈ S, MvPolynomial.X i)).map (aeval α)).eval (∑ i ∈ S, α i) = 0
  rw [Polynomial.map_sub, Polynomial.map_X, Polynomial.map_C]
  rw [Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_C]
  -- Goal: ∑ i ∈ S, α i - (aeval α) (∑ i ∈ S, MvPolynomial.X i) = 0
  rw [map_sum]
  -- Goal: ∑ i ∈ S, α i - ∑ i ∈ S, (aeval α) (MvPolynomial.X i) = 0
  simp [MvPolynomial.aeval_X]

/-! ## evaledFormalPoly.eval 0 = 0 -/

/-- Constant term of `evaledFormalPoly` is 0, since S = ∅ contributes
    σ_∅ = 0, making `(X - C 0) = X` a factor. -/
theorem evaledFormalPoly_eval_zero_eq_zero
    (n : ℕ) (α : Fin n → ℂ) :
    (((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)).eval 0 = 0 := by
  -- Use S = ∅: σ_∅ = 0, so eval at 0 = eval at σ_∅
  have h_empty_sum : ((∅ : Finset (Fin n)).sum α : ℂ) = 0 := by
    simp [Finset.sum_empty]
  rw [← h_empty_sum]
  exact evaledFormalPoly_eval_at_subset_sum_eq_zero n α ∅ (Finset.empty_subset _)

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 51**.  Two structural facts about
    the evaluated formal subset-sum polynomial:

    1. Each subset-sum is a root.
    2. The constant term is zero (since S = ∅ contributes σ = 0).

    These prepare cycle 64+'s ℤ[X] manipulation for the bridge discharge. -/
theorem session_51_evaledFormalPoly_roots_headline
    (n : ℕ) (α : Fin n → ℂ) :
    (∀ S : Finset (Fin n), S ⊆ Finset.univ →
        (((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)).eval
          (∑ i ∈ S, α i) = 0) ∧
    (((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)).eval 0 = 0 := by
  refine ⟨?_, ?_⟩
  · exact evaledFormalPoly_eval_at_subset_sum_eq_zero n α
  · exact evaledFormalPoly_eval_zero_eq_zero n α

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots
