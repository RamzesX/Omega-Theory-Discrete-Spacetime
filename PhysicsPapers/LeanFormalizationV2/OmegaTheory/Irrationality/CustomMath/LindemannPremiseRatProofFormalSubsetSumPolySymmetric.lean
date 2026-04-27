/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolySymmetric

  Cycle 63→64 Phase B Wave T-4b session 42 — symmetry of formalSubsetSumPoly
  under variable renaming.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any permutation `e : Fin n ≃ Fin n`, applying
  `Polynomial.map (MvPolynomial.rename e)` to `formalSubsetSumPoly n`
  gives back `formalSubsetSumPoly n`.

  Hence each coefficient of `formalSubsetSumPoly n` is a SYMMETRIC
  MvPolynomial — fixed by all variable renamings.

  This is the key cycle 64 entry: combined with `MvPolynomial.esymmAlgEquiv`,
  we conclude each coefficient is expressible in elementary symmetrics
  of the Fin n variables, hence rational when specialized at f.aroots ℂ.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyExt

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolySymmetric

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly

/-! ## Symmetry under renaming -/

/-- **Wave T4b session 42 — formalSubsetSumPoly is invariant under renaming**.

    For any permutation `e : Fin n ≃ Fin n`:
    `Polynomial.map (MvPolynomial.rename e) (formalSubsetSumPoly n) = formalSubsetSumPoly n`. -/
theorem formalSubsetSumPoly_rename_invariant
    (n : ℕ) (e : Fin n ≃ Fin n) :
    Polynomial.map (MvPolynomial.rename e).toRingHom (formalSubsetSumPoly n) =
      formalSubsetSumPoly n := by
  unfold formalSubsetSumPoly
  rw [Polynomial.map_prod]
  -- Goal: ∏_S (Polynomial.map rename (X - C σ_S)) = ∏_S (X - C σ_S)
  -- LHS: each factor becomes X - C (rename (∑ Y_i)) = X - C (∑ Y_{e i})
  --      Substitute T = e(S): = ∏_T (X - C (∑ Y_j)) for T = image of S
  -- Use Finset.prod_bij with the bijection S ↦ S.image e
  refine Finset.prod_bij (fun S _ => S.image e) ?_ ?_ ?_ ?_
  · -- Image is in powerset
    intros S hS
    rw [Finset.mem_powerset] at hS ⊢
    exact Finset.image_subset_iff.mpr (fun i _ => Finset.mem_univ _)
  · -- Injectivity
    intros S₁ hS₁ S₂ hS₂ h_image_eq
    exact Finset.image_injective e.injective h_image_eq
  · -- Surjectivity
    intros T hT
    refine ⟨T.image e.symm, ?_, ?_⟩
    · rw [Finset.mem_powerset]
      exact Finset.image_subset_iff.mpr (fun i _ => Finset.mem_univ _)
    · -- Goal: T.image e.symm |>.image e = T
      ext i
      simp [Finset.mem_image]
  · -- Per-element equality
    intros S _
    rw [Polynomial.map_sub, Polynomial.map_X, Polynomial.map_C]
    congr 1
    -- Goal: C (rename e (∑ i ∈ S, X i)) = C (∑ i ∈ S.image e, X i)
    congr 1
    rw [map_sum]
    rw [Finset.sum_image (fun i _ j _ h => e.injective h)]
    apply Finset.sum_congr rfl
    intros i _
    show (MvPolynomial.rename ⇑e) (MvPolynomial.X i) = MvPolynomial.X (e i)
    exact MvPolynomial.rename_X e i

/-! ## Each coefficient is symmetric -/

/-- **Each coefficient of formalSubsetSumPoly is symmetric**. -/
theorem formalSubsetSumPoly_coeff_isSymmetric (n : ℕ) (k : ℕ) :
    ((formalSubsetSumPoly n).coeff k).IsSymmetric := by
  intro e
  have h_map_inv := formalSubsetSumPoly_rename_invariant n e
  -- map preserves coefficient
  have h_coeff : ((Polynomial.map (MvPolynomial.rename e).toRingHom
                   (formalSubsetSumPoly n)).coeff k)
               = (MvPolynomial.rename e) ((formalSubsetSumPoly n).coeff k) := by
    rw [Polynomial.coeff_map]
    rfl
  rw [h_map_inv] at h_coeff
  exact h_coeff.symm

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 42**.  Symmetry of formalSubsetSumPoly:
    invariant under renaming, hence each coefficient is symmetric. -/
theorem session_42_formalSubsetSumPoly_symmetric_headline (n : ℕ) :
    (∀ e : Fin n ≃ Fin n,
        Polynomial.map (MvPolynomial.rename e).toRingHom (formalSubsetSumPoly n) =
          formalSubsetSumPoly n)
    ∧ (∀ k : ℕ, ((formalSubsetSumPoly n).coeff k).IsSymmetric) :=
  ⟨formalSubsetSumPoly_rename_invariant n, formalSubsetSumPoly_coeff_isSymmetric n⟩

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolySymmetric
