/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroFilterSumZero

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 37 — sum of
  zero-filtered subsetSums is zero.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Trivial-but-explicit:
    `((subsetSums s).filter (· = 0)).sum = 0`

  for any Multiset `s : Multiset ℂ`.  Useful for splitting subsetSums.sum
  computation:
    `(subsetSums s).sum = ((filter (·=0)).sum) + ((filter (·≠0)).sum)
                       = 0 + ((filter (·≠0)).sum)
                       = ((filter (·≠0)).sum)`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroFilterSumZero

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

/-! ## Sum of zero-filtered subsetSums is 0 -/

/-- **Wave T4b session 37 — zero-filter sum is zero**.  For any Multiset
    `s : Multiset ℂ`, `((subsetSums s).filter (· = 0)).sum = 0`. -/
theorem zero_filter_sum_eq_zero (s : Multiset ℂ) :
    ((subsetSums s).filter (· = 0)).sum = 0 := by
  -- Each element σ in the filter satisfies σ = 0
  -- So the multiset = replicate of 0's = sum of 0's = 0
  rw [show ((subsetSums s).filter (· = 0)) =
        Multiset.replicate ((subsetSums s).filter (· = 0)).card 0 from ?_]
  · simp [Multiset.sum_replicate]
  · -- Each element of the filter is 0
    apply Multiset.eq_replicate.mpr
    refine ⟨rfl, ?_⟩
    intros σ hσ
    rw [Multiset.mem_filter] at hσ
    exact hσ.2

/-! ## Subset-sum split: sum = nonzero sum -/

/-- Split: `(subsetSums s).sum = ((subsetSums s).filter (·≠0)).sum`,
    since the zero-filter contributes 0. -/
theorem subsetSums_sum_eq_nonzero_filter_sum (s : Multiset ℂ) :
    (subsetSums s).sum = ((subsetSums s).filter (· ≠ 0)).sum := by
  have h_split : subsetSums s =
                 (subsetSums s).filter (· = 0) +
                 (subsetSums s).filter (· ≠ 0) := by
    exact (Multiset.filter_add_not (· = 0) (subsetSums s)).symm
  rw [h_split, Multiset.sum_add, zero_filter_sum_eq_zero]
  simp

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 37**.  Sum of subsetSums = sum of
    nonzero subsetSums (since zero subsets contribute 0). -/
theorem session_37_zero_filter_sum_zero_headline (s : Multiset ℂ) :
    ((subsetSums s).filter (· = 0)).sum = 0 ∧
    (subsetSums s).sum = ((subsetSums s).filter (· ≠ 0)).sum :=
  ⟨zero_filter_sum_eq_zero s, subsetSums_sum_eq_nonzero_filter_sum s⟩

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroFilterSumZero
