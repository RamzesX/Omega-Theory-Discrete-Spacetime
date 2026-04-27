/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofNonzeroFilterSumRational

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 38 — sum of
  nonzero-filtered subsetSums of f.aroots ℂ is rational.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Composes s35 (subsetSums sum is rational) + s37 (zero-filter sum = 0,
  so subsetSums.sum = nonzero-filter.sum) to conclude:

      `∃ q : ℚ, ((subsetSums (f.aroots ℂ)).filter (· ≠ 0)).sum = (q : ℂ)`

  This is `(subsetSumPoly_C (f.aroots ℂ)).aroots.sum` is rational —
  a step toward "all elementary symmetric polynomials of subsetSumPoly_C's
  aroots are rational" (cycle 64+ goal via fundamental theorem).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsArootsRational
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroFilterSumZero

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofNonzeroFilterSumRational

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsArootsRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofZeroFilterSumZero

/-! ## Nonzero-filter sum is rational -/

/-- **Wave T4b session 38 — nonzero-filter sum is rational**.

    For any nonzero `f : Polynomial ℤ`:
    `∃ q : ℚ, ((subsetSums (f.aroots ℂ)).filter (· ≠ 0)).sum = (q : ℂ)`. -/
theorem nonzero_filter_subsetSums_sum_rational
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ q : ℚ, ((subsetSums (f.aroots ℂ)).filter (· ≠ 0)).sum = (q : ℂ) := by
  obtain ⟨q, hq⟩ := subsetSums_aroots_sum_is_rational f h_ne
  refine ⟨q, ?_⟩
  rw [← subsetSums_sum_eq_nonzero_filter_sum]
  exact hq

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 38**.  Sum of nonzero subset-sums of
    f.aroots is rational.  Combined with s27 (Vieta coefficient extraction)
    and the (subsetSumPoly_C).coeff (natDeg-1) = -((aroots).esymm 1) =
    -((nonzero filter).sum), this gives:

      `(subsetSumPoly_C (f.aroots ℂ)).coeff (natDeg-1) is rational`

    A concrete cycle-64 step. -/
theorem session_38_nonzero_filter_sum_rational_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ q : ℚ, ((subsetSums (f.aroots ℂ)).filter (· ≠ 0)).sum = (q : ℂ) :=
  nonzero_filter_subsetSums_sum_rational f h_ne

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofNonzeroFilterSumRational
