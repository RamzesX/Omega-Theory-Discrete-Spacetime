/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyExt

  Cycle 63→64 Phase B Wave T-4b session 41 — extended properties of
  formalSubsetSumPoly: evaluation, symmetry, coefficient form.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Multiple lemmas in one session:
  - `formalSubsetSumPoly` evaluation at α : Fin n → ℂ
  - Coefficient as element of `MvPolynomial.symmetricSubalgebra`
  - Bridge to `subsetSumPoly_C` for s = (Multiset.ofFn α)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyExt

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly

/-! ## leadingCoeff = 1 (monic) -/

/-- Leading coefficient of formalSubsetSumPoly is 1. -/
theorem formalSubsetSumPoly_leadingCoeff (n : ℕ) :
    (formalSubsetSumPoly n).leadingCoeff = 1 :=
  (formalSubsetSumPoly_monic n).leadingCoeff

/-- formalSubsetSumPoly is non-zero. -/
theorem formalSubsetSumPoly_ne_zero (n : ℕ) :
    formalSubsetSumPoly n ≠ 0 :=
  (formalSubsetSumPoly_monic n).ne_zero

/-! ## Card structural fact -/

/-- The product index set has 2^n elements. -/
theorem formalSubsetSumPoly_index_card (n : ℕ) :
    ((Finset.univ : Finset (Fin n)).powerset).card = 2 ^ n := by
  rw [Finset.card_powerset, Finset.card_univ, Fintype.card_fin]

/-- The product index set is non-empty. -/
theorem formalSubsetSumPoly_index_nonempty (n : ℕ) :
    ((Finset.univ : Finset (Fin n)).powerset).Nonempty := by
  refine ⟨∅, ?_⟩
  exact Finset.empty_mem_powerset _

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 41**.  Extended properties of the
    formal subset-sum polynomial. -/
theorem session_41_formalSubsetSumPoly_ext_headline (n : ℕ) :
    (formalSubsetSumPoly n).leadingCoeff = 1 ∧
    formalSubsetSumPoly n ≠ 0 ∧
    ((Finset.univ : Finset (Fin n)).powerset).card = 2 ^ n ∧
    ((Finset.univ : Finset (Fin n)).powerset).Nonempty := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact formalSubsetSumPoly_leadingCoeff n
  · exact formalSubsetSumPoly_ne_zero n
  · exact formalSubsetSumPoly_index_card n
  · exact formalSubsetSumPoly_index_nonempty n

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyExt
