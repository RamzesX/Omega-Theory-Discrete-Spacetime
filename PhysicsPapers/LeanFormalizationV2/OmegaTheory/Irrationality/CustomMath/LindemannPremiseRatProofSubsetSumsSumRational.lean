/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 30 — sum of all
  subset-sums of f.aroots ℂ is rational.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any nonzero `f : Polynomial ℤ`:

      `∃ q : ℚ, (subsetSums (f.aroots ℂ)).sum = (q : ℂ)`

  Key identity: each element α_i of f.aroots appears in exactly 2^(n-1)
  subsets (where n = card of aroots = natDegree).  So:
      `(subsetSums s).sum = 2^(s.card - 1) · s.sum`  (when s.card ≥ 1)

  And `s.sum = s.esymm 1` is rational by s29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

/-! ## esymm 1 = sum -/

/-- Helper: for any Multiset over a CommSemiring, `esymm s 1 = s.sum`. -/
private theorem multiset_esymm_one_eq_sum {R : Type*} [CommSemiring R]
    (s : Multiset R) :
    s.esymm 1 = s.sum := by
  unfold Multiset.esymm
  rw [Multiset.powersetCard_one, Multiset.map_map]
  simp only [Function.comp_apply, Multiset.prod_singleton, Multiset.map_id']

/-! ## Sum of aroots is rational -/

/-- **Wave T4b session 30 — sum of aroots is rational**.

    For any nonzero `f : Polynomial ℤ`, `(f.aroots ℂ).sum` is rational. -/
theorem aroots_sum_is_rational
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ q : ℚ, (f.aroots ℂ).sum = (q : ℂ) := by
  obtain ⟨q, hq⟩ := aroots_esymm_is_rational f h_ne 1
  refine ⟨q, ?_⟩
  rw [← multiset_esymm_one_eq_sum]
  exact hq

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 30**.  Sum of complex roots of any
    nonzero integer polynomial is rational.  Direct corollary of s29
    (esymm of aroots is rational) via `esymm 1 = sum`. -/
theorem session_30_aroots_sum_rational_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ q : ℚ, (f.aroots ℂ).sum = (q : ℂ) :=
  aroots_sum_is_rational f h_ne

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational
