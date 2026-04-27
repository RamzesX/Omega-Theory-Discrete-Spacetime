/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 27 — Vieta
  coefficient extraction for subsetSumPoly_C.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Applies Mathlib's `Polynomial.coeff_eq_esymm_roots_of_card` to
  `subsetSumPoly_C` (using s26's monicity + degree + roots.card = natDegree)
  to extract each coefficient as a value of an elementary symmetric
  polynomial of the filtered subset-sums multiset:

      `(subsetSumPoly_C s).coeff k =
         (-1)^(natDeg - k) ·
           ((subsetSums s).filter (·≠0)).esymm (natDeg - k)`

  This is the cycle 64 entry: each esymm value is symmetric in the
  filtered subset-sums, hence in `s` (since the filter is permutation-
  invariant), hence rational when `s = f.aroots ℂ` for `f : ℤ[X]`
  (via fundamental theorem of symmetric polynomials applied to f.aroots).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyStructure

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyStructure

/-! ## Vieta coefficient extraction -/

/-- **Wave T4b session 27 — Vieta coefficient formula for subsetSumPoly_C**.

    For any Multiset `s : Multiset ℂ` and `k ≤ natDegree`:

      `(subsetSumPoly_C s).coeff k =
         (-1)^(natDeg - k) ·
           ((subsetSums s).filter (·≠0)).esymm (natDeg - k)`

    Proof: apply Mathlib's `Polynomial.coeff_eq_esymm_roots_of_card`
    using s26's monicity + roots.card = natDegree. -/
theorem subsetSumPoly_C_coeff_eq_esymm
    (s : Multiset ℂ) (k : ℕ) (hk : k ≤ (subsetSumPoly_C s).natDegree) :
    (subsetSumPoly_C s).coeff k =
      (-1) ^ ((subsetSumPoly_C s).natDegree - k) *
        ((subsetSums s).filter (· ≠ 0)).esymm
          ((subsetSumPoly_C s).natDegree - k) := by
  have h_card : (subsetSumPoly_C s).roots.card = (subsetSumPoly_C s).natDegree := by
    have := subsetSumPoly_C_aroots_card s
    -- aroots ℂ for ℂ[X] = roots
    have h_aroots_eq_roots : (subsetSumPoly_C s).aroots ℂ = (subsetSumPoly_C s).roots := by
      rw [Polynomial.aroots_def]
      congr 1
      exact Polynomial.map_id
    rw [h_aroots_eq_roots] at this
    exact this
  have h_vieta := Polynomial.coeff_eq_esymm_roots_of_card h_card hk
  rw [h_vieta]
  -- leadingCoeff = 1 (monic)
  rw [(subsetSumPoly_C_monic s).leadingCoeff, one_mul]
  -- roots = (subsetSums s).filter (·≠0)
  -- Need to convert .roots to the aroots form
  congr 1
  have h_aroots_eq_roots : (subsetSumPoly_C s).aroots ℂ = (subsetSumPoly_C s).roots := by
    rw [Polynomial.aroots_def]
    congr 1
    exact Polynomial.map_id
  rw [← h_aroots_eq_roots]
  rw [aroots_subsetSumPoly_C]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 27**.  For any Multiset `s : Multiset ℂ`,
    the coefficients of `subsetSumPoly_C s` are determined by the
    elementary symmetric polynomials of the filtered subset-sums multiset.

    Specifically: `coeff k = (-1)^(natDeg-k) · esymm of filtered`.

    This is the entry point for cycle 64+: each esymm value is symmetric
    in s's elements, so when `s = f.aroots ℂ` for `f : ℤ[X]`, the
    coefficient is symmetric polynomial in f.aroots, hence rational by
    fundamental theorem of symmetric polynomials + Vieta. -/
theorem session_27_subsetSumPoly_C_coeff_formula
    (s : Multiset ℂ) (k : ℕ) (hk : k ≤ (subsetSumPoly_C s).natDegree) :
    (subsetSumPoly_C s).coeff k =
      (-1) ^ ((subsetSumPoly_C s).natDegree - k) *
        ((subsetSums s).filter (· ≠ 0)).esymm
          ((subsetSumPoly_C s).natDegree - k) :=
  subsetSumPoly_C_coeff_eq_esymm s k hk

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs
