/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumExplicit

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 34 — explicit
  formula for sum of subsetSums.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any Multiset `s : Multiset ℂ`:

      `2 * (subsetSums s).sum = 2^s.card * s.sum`

  Proof: each element `a ∈ s` appears in exactly `2^(s.card - 1)` subsets.
  Multiset induction on s.

  Equivalent form (for s.card ≥ 1):

      `(subsetSums s).sum = 2^(s.card - 1) * s.sum`

  This is a concrete instance of the symmetric-polynomial-in-subsetSums
  pattern, expressing it explicitly in terms of elementary symmetrics
  of s (here just `s.sum = s.esymm 1`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumExplicit

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

/-! ## Explicit sum formula -/

/-- **Wave T4b session 34 — sum of subsetSums explicit formula**.

    For any Multiset `s : Multiset ℂ`:
    `2 * (subsetSums s).sum = 2^s.card * s.sum`.

    Proof: Multiset induction on s.  Each step shows the formula holds
    by Multiset.powerset_cons + linearity. -/
theorem two_mul_subsetSums_sum_eq
    (s : Multiset ℂ) :
    2 * (subsetSums s).sum = 2^s.card * s.sum := by
  induction s using Multiset.induction with
  | empty =>
      unfold subsetSums
      simp
  | cons a s ih =>
      unfold subsetSums
      rw [Multiset.powerset_cons]
      rw [Multiset.map_add, Multiset.sum_add]
      -- subsetSums (a ::ₘ s).sum = (s.powerset.map sum).sum
      --                          + (s.powerset.map (cons a)).map sum |>.sum
      rw [Multiset.map_map]
      -- Second part: s.powerset.map (sum ∘ (cons a)) |>.sum
      --            = s.powerset.map (fun T => a + T.sum) |>.sum
      have h_inner : (Multiset.map (Multiset.sum ∘ Multiset.cons a) s.powerset).sum
                   = a * (s.powerset.card : ℂ) + (s.powerset.map Multiset.sum).sum := by
        rw [show (Multiset.sum ∘ Multiset.cons a)
              = (fun T => a + Multiset.sum T) from by
            funext T
            simp [Function.comp, Multiset.sum_cons]]
        -- (s.powerset.map (fun T => a + T.sum)).sum
        --   = (s.powerset.map (fun T => a)).sum + (s.powerset.map (fun T => T.sum)).sum
        induction s.powerset using Multiset.induction with
        | empty => simp
        | cons T ps ih_p =>
            simp only [Multiset.map_cons, Multiset.sum_cons, ih_p, Multiset.card_cons]
            push_cast
            ring
      rw [h_inner]
      -- LHS: 2 * ((s.powerset.map sum).sum + (a · powerset.card + (s.powerset.map sum).sum))
      --    = 2 * subsetSums(s).sum * 2 + 2 · a · powerset.card
      --    Wait let me recompute
      -- Goal: 2 * ((s.powerset.map sum).sum + (a · powerset.card + ...))
      --     = 2^(s.card + 1) * (a + s.sum)
      -- Original (subsetSums (a ::ₘ s)).sum = subsetSums(s).sum + a · |powerset(s)| + subsetSums(s).sum
      --                                     = 2 · subsetSums(s).sum + a · 2^s.card
      -- So 2 * (subsetSums (a ::ₘ s)).sum = 4 · subsetSums(s).sum + 2 · a · 2^s.card
      -- By IH: 2 · subsetSums(s).sum = 2^s.card · s.sum
      --       So 4 · subsetSums(s).sum = 2 · 2^s.card · s.sum = 2^(s.card + 1) · s.sum
      -- 2 · a · 2^s.card = 2^(s.card + 1) · a
      -- Total = 2^(s.card + 1) · (s.sum + a) = 2^(s.card + 1) · (a + s.sum)
      -- = 2^((a ::ₘ s).card) · (a ::ₘ s).sum  ✓
      rw [Multiset.card_powerset, Multiset.card_cons, Multiset.sum_cons]
      -- Now the equation should follow algebraically
      have ih' := ih
      unfold subsetSums at ih'
      push_cast
      linear_combination 2 * ih'

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 34**.  Explicit formula for the sum
    of subsetSums: `2 · (subsetSums s).sum = 2^s.card · s.sum`. -/
theorem session_34_subsetSums_sum_explicit_headline
    (s : Multiset ℂ) :
    2 * (subsetSums s).sum = 2^s.card * s.sum :=
  two_mul_subsetSums_sum_eq s

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumExplicit
