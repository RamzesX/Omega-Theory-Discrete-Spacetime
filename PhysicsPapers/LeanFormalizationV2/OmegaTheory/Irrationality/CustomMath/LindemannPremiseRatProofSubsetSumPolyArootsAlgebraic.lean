/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyArootsAlgebraic

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 31 — every root
  of subsetSumPoly_C (f.aroots ℂ) is algebraic over ℚ for any nonzero f.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any nonzero `f : Polynomial ℤ` and any
  `σ ∈ (subsetSumPoly_C (f.aroots ℂ)).aroots ℂ`:

      `IsIntegral ℚ σ`

  Composes s25's `aroots_subsetSumPoly_C` (subsetSumPoly_C aroots = filtered
  subsetSums) with s16's `isIntegral_of_mem_subsetSums` (each subset-sum is
  integral over ℚ).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerSubsetSums

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyArootsAlgebraic

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerSubsetSums

/-! ## Aroots are algebraic -/

/-- **Wave T4b session 31 — subsetSumPoly_C aroots are integral over ℚ**.

    For any nonzero `f : Polynomial ℤ` and any
    `σ ∈ (subsetSumPoly_C (f.aroots ℂ)).aroots ℂ`, `σ` is integral over ℚ.

    Proof: by s25, the aroots multiset = `(subsetSums (f.aroots ℂ)).filter (·≠0)`;
    each member is in `subsetSums (f.aroots ℂ)`; by s16's
    `isIntegral_of_mem_subsetSums`, every subset-sum is integral over ℚ. -/
theorem subsetSumPoly_C_aroots_isIntegral
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    {σ : ℂ} (hσ : σ ∈ (subsetSumPoly_C (f.aroots ℂ)).aroots ℂ) :
    IsIntegral ℚ σ := by
  rw [aroots_subsetSumPoly_C] at hσ
  rw [Multiset.mem_filter] at hσ
  exact isIntegral_of_mem_subsetSums f h_ne hσ.1

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 31**.  All roots of `subsetSumPoly_C s`
    for `s = f.aroots ℂ` are integral over ℚ.

    This is the algebraic structure piece toward cycle 64+: combined with
    Galois/symmetric-polynomial theory, the rationality of subsetSumPoly_C's
    coefficients follows. -/
theorem session_31_subsetSumPoly_C_aroots_isIntegral_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∀ σ ∈ (subsetSumPoly_C (f.aroots ℂ)).aroots ℂ, IsIntegral ℚ σ :=
  fun _ hσ => subsetSumPoly_C_aroots_isIntegral f h_ne hσ

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyArootsAlgebraic
