/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly

  Cycle 63→64 Phase B Wave T-4b session 40 — formal subset-sum polynomial
  in MvPolynomial.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Defines the formal subset-sum polynomial:

      `formalSubsetSumPoly n : Polynomial (MvPolynomial (Fin n) ℤ)`

  defined as the product over all subsets S ⊆ Fin n of `(X - C (∑_{i ∈ S} Y_i))`
  where Y_i is the i-th MvPolynomial variable.

  Coefficients of this polynomial are MvPolynomials in (Fin n) ℤ — integer-
  coefficient polynomials in n formal variables.

  Evaluating at Y_i ↦ α_i (for α : Fin n → ℂ) gives a polynomial in ℂ[X]
  whose roots are the subset-sums of {α_i}.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
import Mathlib.RingTheory.MvPolynomial.Symmetric.Defs

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly

open Polynomial Complex

/-! ## Formal subset-sum polynomial -/

/-- The formal subset-sum polynomial: product over all subsets S ⊆ Fin n
    of `(X - C (∑_{i ∈ S} MvPolynomial.X i))`.

    Result type: `Polynomial (MvPolynomial (Fin n) ℤ)`. -/
noncomputable def formalSubsetSumPoly (n : ℕ) :
    Polynomial (MvPolynomial (Fin n) ℤ) :=
  ∏ S ∈ (Finset.univ : Finset (Fin n)).powerset,
    (Polynomial.X - Polynomial.C (∑ i ∈ S, MvPolynomial.X i))

/-! ## Basic properties -/

/-- The formal subset-sum polynomial is monic. -/
theorem formalSubsetSumPoly_monic (n : ℕ) :
    (formalSubsetSumPoly n).Monic := by
  unfold formalSubsetSumPoly
  apply Polynomial.monic_prod_of_monic
  intros S _
  exact Polynomial.monic_X_sub_C _

/-- The formal subset-sum polynomial has natDegree = 2^n. -/
theorem formalSubsetSumPoly_natDegree (n : ℕ) :
    (formalSubsetSumPoly n).natDegree = 2 ^ n := by
  unfold formalSubsetSumPoly
  rw [Polynomial.natDegree_prod_of_monic _ _ (fun S _ => Polynomial.monic_X_sub_C _)]
  -- Sum of natDegree of (X - C ·) = card of powerset = 2^n
  simp only [Polynomial.natDegree_X_sub_C, Finset.sum_const, smul_eq_mul, mul_one]
  rw [Finset.card_powerset, Finset.card_univ, Fintype.card_fin]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 40**.  Formal subset-sum polynomial
    is monic with natDegree = 2^n.

    This is the foundational MvPolynomial structure that cycle 64+
    will analyze: by `MvPolynomial.esymmAlgEquiv`, each coefficient
    (as a MvPolynomial in Fin n vars) is symmetric, hence expressible
    in elementary symmetrics; specializing at f.aroots ℂ gives rational
    values via Vieta. -/
theorem session_40_formalSubsetSumPoly_headline (n : ℕ) :
    (formalSubsetSumPoly n).Monic ∧
    (formalSubsetSumPoly n).natDegree = 2 ^ n :=
  ⟨formalSubsetSumPoly_monic n, formalSubsetSumPoly_natDegree n⟩

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
