/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsCardBounds

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 39 — cardinality
  bounds on subsetSums and nonzero filter.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Cardinality lower bounds:
  - `subsetSums s.card = 2^s.card` (already in s15 as `card_subsetSums`).
  - For `s = f.aroots ℂ` with `f.natDegree ≥ 1`: `2 ≤ subsetSums.card`.
  - Nonzero filter cardinality: `subsetSums.card - 1 ≥ filter (·≠0).card`
    (since at least empty subset contributes σ=0).

  These bounds are useful for cycle 64+'s analytical bound on |J_p| < 1
  argument, which depends on the orbit cardinality.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroSubsetSumExists
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsCardBounds

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroSubsetSumExists
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

/-! ## Lower bounds on subsetSums cardinality -/

/-- **Wave T4b session 39 — subsetSums has ≥ 2 elements for natDegree ≥ 1**.

    For nonzero `f : Polynomial ℤ` with `f.natDegree ≥ 1`,
    `2 ≤ (subsetSums (f.aroots ℂ)).card`. -/
theorem two_le_card_subsetSums_of_natDegree_ge_1
    (f : Polynomial ℤ) (h_ne : f ≠ 0) (h_natDeg_ge_1 : 1 ≤ f.natDegree) :
    2 ≤ (subsetSums (f.aroots ℂ)).card := by
  rw [card_subsetSums]
  rw [aroots_card_eq_natDegree_general f h_ne]
  -- Goal: 2 ≤ 2^f.natDegree
  calc 2 = 2 ^ 1 := by norm_num
    _ ≤ 2 ^ f.natDegree := Nat.pow_le_pow_right (by omega) h_natDeg_ge_1

/-! ## Upper bound on nonzero filter cardinality -/

/-- **Wave T4b session 39 — filter (·≠0) cardinality bound**.

    `((subsetSums s).filter (· ≠ 0)).card ≤ subsetSums.card - 1`
    (since at least 1 element — the σ_∅ = 0 — is in the zero-filter). -/
theorem nonzero_filter_card_le
    (s : Multiset ℂ) :
    ((subsetSums s).filter (· ≠ 0)).card ≤ (subsetSums s).card - 1 := by
  have h_split : ((subsetSums s).filter (· = 0)).card +
                 ((subsetSums s).filter (· ≠ 0)).card =
                 (subsetSums s).card := by
    have h := Multiset.filter_add_not (· = 0) (subsetSums s)
    have h_card := congrArg Multiset.card h
    rw [Multiset.card_add] at h_card
    exact h_card
  have h_zero_ge_1 : 1 ≤ ((subsetSums s).filter (· = 0)).card :=
    one_le_zero_filter_card s
  omega

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 39**.  Cardinality bounds for
    subsetSums + nonzero filter.  Useful for cycle 64+'s analytical
    bound argument. -/
theorem session_39_subsetSums_card_bounds_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    (1 ≤ f.natDegree → 2 ≤ (subsetSums (f.aroots ℂ)).card) ∧
    (∀ s : Multiset ℂ,
        ((subsetSums s).filter (· ≠ 0)).card ≤ (subsetSums s).card - 1) :=
  ⟨two_le_card_subsetSums_of_natDegree_ge_1 f h_ne, nonzero_filter_card_le⟩

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsCardBounds
