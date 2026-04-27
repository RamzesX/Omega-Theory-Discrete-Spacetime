/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSymmetric

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 28 — symmetry of
  subsetSums under multiset-equality (built-in for Multiset, made explicit).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Establishes the symmetry property at the Multiset level:

  1. **`subsetSums_eq_of_eq`**: if `s = t` (as Multisets), then
     `subsetSums s = subsetSums t`.  This is built-in but stated explicitly
     for use in cycle 64+ Galois-symmetry proofs.

  2. **`filter_subsetSums_esymm_eq_of_eq`**: similarly for the filtered
     version + esymm.

  3. **`subsetSumPoly_C_eq_of_eq`**: `subsetSumPoly_C s = subsetSumPoly_C t`
     when `s = t`.

  These are technically trivial (since Multiset equality is structural)
  but make the symmetry property explicit for downstream use.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSymmetric

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyStructure
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs

/-! ## Multiset-equality symmetry properties -/

/-- `subsetSums` respects Multiset equality. -/
theorem subsetSums_eq_of_eq {s t : Multiset ℂ} (h : s = t) :
    subsetSums s = subsetSums t := by
  rw [h]

/-- The filtered subset-sum esymm respects Multiset equality. -/
theorem filter_subsetSums_esymm_eq_of_eq
    {s t : Multiset ℂ} (h : s = t) (k : ℕ) :
    ((subsetSums s).filter (· ≠ 0)).esymm k =
      ((subsetSums t).filter (· ≠ 0)).esymm k := by
  rw [h]

/-- `subsetSumPoly_C` respects Multiset equality. -/
theorem subsetSumPoly_C_eq_of_eq {s t : Multiset ℂ} (h : s = t) :
    subsetSumPoly_C s = subsetSumPoly_C t := by
  rw [h]

/-! ## Card preservation -/

/-- The cardinality of zero-subset-sums equals the cardinality difference. -/
theorem card_zero_filter_eq_card_diff (s : Multiset ℂ) :
    ((subsetSums s).filter (· = 0)).card =
      (subsetSums s).card - ((subsetSums s).filter (· ≠ 0)).card := by
  have h_split : (subsetSums s).card =
      ((subsetSums s).filter (· = 0)).card +
      ((subsetSums s).filter (· ≠ 0)).card := by
    have := Multiset.filter_add_not (· = 0) (subsetSums s)
    have h_card := congrArg Multiset.card this.symm
    rw [Multiset.card_add] at h_card
    exact h_card
  omega

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 28**.  Symmetry properties at the
    Multiset level + cardinality bookkeeping for the subset-sum
    polynomial.

    These trivial-but-explicit properties enable cycle 64+'s use of
    Multiset equality + permutation-invariance reasoning when working
    with `s = f.aroots ℂ`. -/
theorem session_28_subsetSums_symmetric_headline :
    (∀ {s t : Multiset ℂ}, s = t → subsetSums s = subsetSums t)
    ∧ (∀ {s t : Multiset ℂ}, s = t → ∀ (k : ℕ),
        ((subsetSums s).filter (· ≠ 0)).esymm k =
        ((subsetSums t).filter (· ≠ 0)).esymm k)
    ∧ (∀ {s t : Multiset ℂ}, s = t → subsetSumPoly_C s = subsetSumPoly_C t)
    ∧ (∀ s : Multiset ℂ,
        ((subsetSums s).filter (· = 0)).card =
        (subsetSums s).card - ((subsetSums s).filter (· ≠ 0)).card) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intros s t h; exact subsetSums_eq_of_eq h
  · intros s t h k; exact filter_subsetSums_esymm_eq_of_eq h k
  · intros s t h; exact subsetSumPoly_C_eq_of_eq h
  · exact card_zero_filter_eq_card_diff

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSymmetric
