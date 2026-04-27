/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroSubsetSumExists

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 36 — at least one
  subset-sum is zero (the empty subset).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any Multiset `s : Multiset ℂ`:
  - `0 ∈ subsetSums s` (empty subset has sum 0).
  - `1 ≤ ((subsetSums s).filter (· = 0)).card`.

  These are foundational for the L-W expansion identity (s15's
  `sum_exp_subsetSums_eq_zero_of_iPi_mem`): the zero-subset-sum count
  m is at least 1, ensuring the bridge's `0 < m` hypothesis.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroSubsetSumExists

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

/-! ## Empty subset gives σ = 0 -/

/-- **Wave T4b session 36 — empty subset has σ = 0**.  For any Multiset
    `s : Multiset ℂ`, `0 ∈ subsetSums s`. -/
theorem zero_mem_subsetSums (s : Multiset ℂ) :
    (0 : ℂ) ∈ subsetSums s := by
  unfold subsetSums
  rw [Multiset.mem_map]
  refine ⟨0, ?_, ?_⟩
  · -- 0 ∈ s.powerset (the empty multiset ≤ s, hence in powerset)
    rw [Multiset.mem_powerset]
    exact Multiset.zero_le s
  · -- (0 : Multiset ℂ).sum = 0
    simp

/-! ## Filter cardinality lower bound -/

/-- **Wave T4b session 36 — at least one zero subset-sum**.  For any
    Multiset `s : Multiset ℂ`,
    `1 ≤ ((subsetSums s).filter (· = 0)).card`. -/
theorem one_le_zero_filter_card (s : Multiset ℂ) :
    1 ≤ ((subsetSums s).filter (· = 0)).card := by
  rw [Nat.one_le_iff_ne_zero]
  intro h_card_zero
  rw [Multiset.card_eq_zero] at h_card_zero
  -- h_card_zero : ((subsetSums s).filter (·=0)) = 0  (empty Multiset)
  -- But 0 ∈ subsetSums s and 0 = 0, so 0 should be in the filter
  have h_zero_mem : (0 : ℂ) ∈ subsetSums s := zero_mem_subsetSums s
  have h_zero_mem_filter : (0 : ℂ) ∈ (subsetSums s).filter (· = 0) := by
    rw [Multiset.mem_filter]
    exact ⟨h_zero_mem, rfl⟩
  rw [h_card_zero] at h_zero_mem_filter
  simp at h_zero_mem_filter

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 36**.  Foundational fact: any subsetSums
    multiset contains 0 (from the empty subset), so the zero-filter has
    cardinality ≥ 1.  This gives the `0 < m` hypothesis for the L-W
    expansion bridge. -/
theorem session_36_zero_subsetSum_exists_headline (s : Multiset ℂ) :
    (0 : ℂ) ∈ subsetSums s ∧ 1 ≤ ((subsetSums s).filter (· = 0)).card :=
  ⟨zero_mem_subsetSums s, one_le_zero_filter_card s⟩

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroSubsetSumExists
