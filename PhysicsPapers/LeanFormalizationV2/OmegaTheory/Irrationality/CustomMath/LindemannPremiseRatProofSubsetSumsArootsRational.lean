/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsArootsRational

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 35 — sum of
  subsetSums of f.aroots ℂ is rational.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any nonzero `f : Polynomial ℤ`:

      `∃ q : ℚ, (subsetSums (f.aroots ℂ)).sum = (q : ℂ)`

  Combines s34 (`2 · (subsetSums s).sum = 2^s.card · s.sum`) with s30
  (sum of aroots is rational): `(subsetSums s).sum = 2^(card-1) · s.sum`,
  which is `rational · rational = rational`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumExplicit
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsArootsRational

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumExplicit
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational

/-! ## Sum of subsetSums is rational -/

/-- **Wave T4b session 35 — sum of subsetSums of aroots is rational**.

    For any nonzero `f : Polynomial ℤ`:
    `(subsetSums (f.aroots ℂ)).sum` is rational.

    Proof: by s34, `2 · (subsetSums s).sum = 2^s.card · s.sum`.  By s30,
    `s.sum = (q : ℂ)` for some `q : ℚ`.  So
    `(subsetSums s).sum = 2^(s.card - 1) · q` — rational.

    Concretely we work with `2 · sum = 2^card · q`, dividing both sides
    by 2 gives `sum = 2^(card-1) · q` for `card ≥ 1`. -/
theorem subsetSums_aroots_sum_is_rational
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ q : ℚ, (subsetSums (f.aroots ℂ)).sum = (q : ℂ) := by
  obtain ⟨q_s, hq_s⟩ := aroots_sum_is_rational f h_ne
  have h_explicit := two_mul_subsetSums_sum_eq (f.aroots ℂ)
  rw [hq_s] at h_explicit
  -- h_explicit : 2 * (subsetSums (f.aroots ℂ)).sum = 2^card * (q_s : ℂ)
  refine ⟨((2 : ℚ) ^ (f.aroots ℂ).card * q_s) / 2, ?_⟩
  push_cast
  linear_combination h_explicit / 2

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 35**.  Sum of subsetSums of aroots is
    rational. -/
theorem session_35_subsetSums_aroots_sum_rational_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ q : ℚ, (subsetSums (f.aroots ℂ)).sum = (q : ℂ) :=
  subsetSums_aroots_sum_is_rational f h_ne

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsArootsRational
