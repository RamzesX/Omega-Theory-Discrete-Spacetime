/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 25 — orbit-sum
  identity at the ℂ-polynomial level for the subset-multiplicity
  polynomial.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Builds the algebraic core for the bridge discharge:

  For any Multiset `s : Multiset ℂ` containing `i*π`, the polynomial
  `subsetSumPoly_C s := ((subsetSums s).filter (·≠0)).map (X - C ·) |>.prod`
  satisfies:
  - aroots over ℂ = subset-sums (filter nonzero) [via Mathlib]
  - `((subsetSumPoly_C s).aroots ℂ).map exp).sum = -m` where m is the
    count of zero subset-sums.

  This is the algebraic identity at the ℂ-poly level — combining s15's
  orbit-product-zero with `Polynomial.roots_multiset_prod_X_sub_C`.

  The remaining cycle 64+ work: lift `subsetSumPoly_C` to ℤ[X] via the
  fundamental theorem of symmetric polynomials, completing the bridge
  for the π² ∉ ℚ case.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
import Mathlib.Algebra.Polynomial.Roots

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

/-! ## Subset-sum polynomial in ℂ[X] -/

/-- The subset-multiplicity polynomial in ℂ[X]:
    `((subsetSums s).filter (·≠0)).map (X - C ·) |>.prod`.

    Roots = nonzero subset-sums (with subset-multiplicity from s.powerset). -/
noncomputable def subsetSumPoly_C (s : Multiset ℂ) : Polynomial ℂ :=
  (((subsetSums s).filter (· ≠ 0)).map
    (fun σ => Polynomial.X - Polynomial.C σ)).prod

/-! ## Aroots = nonzero subsetSums -/

/-- The aroots multiset of `subsetSumPoly_C s` in ℂ equals the multiset
    of nonzero subset-sums of `s` (with subset-multiplicity).

    Proof: aroots = roots after mapping coefficients; for ℂ-coeff polynomials,
    aroots = roots directly.  Apply Mathlib's
    `Polynomial.roots_multiset_prod_X_sub_C`. -/
theorem aroots_subsetSumPoly_C
    (s : Multiset ℂ) :
    (subsetSumPoly_C s).aroots ℂ = (subsetSums s).filter (· ≠ 0) := by
  unfold subsetSumPoly_C
  -- For ℂ-coeff poly, aroots ℂ = roots in ℂ via algebraMap ℂ ℂ = id
  have h_aroots_eq_roots : ∀ (q : Polynomial ℂ), q.aroots ℂ = q.roots := by
    intro q
    rw [Polynomial.aroots_def]
    congr 1
    exact Polynomial.map_id
  rw [h_aroots_eq_roots]
  exact Polynomial.roots_multiset_prod_X_sub_C _

/-! ## Sum-exp identity at ℂ-poly level -/

/-- For Multiset s containing iπ, the sum of exp over `subsetSumPoly_C s`'s
    aroots equals `-(m : ℂ)` where `m = #{T ⊆ s : T.sum = 0}`. -/
theorem sum_exp_aroots_subsetSumPoly_C_eq_neg_m
    (s : Multiset ℂ) (h_iPi_mem : (Complex.I * (Real.pi : ℂ)) ∈ s) :
    (((subsetSumPoly_C s).aroots ℂ).map Complex.exp).sum
      = -(((subsetSums s).filter (· = 0)).card : ℂ) := by
  rw [aroots_subsetSumPoly_C]
  -- Goal: (((subsetSums s).filter (·≠0)).map exp).sum = -((filter (·=0)).card)
  -- Use: ((subsetSums s).map exp).sum = 0 (s15)
  -- AND: ((subsetSums s).map exp).sum =
  --      ((filter (·=0)).map exp).sum + ((filter (·≠0)).map exp).sum
  -- For σ = 0: exp(0) = 1, so (filter (·=0)).map exp = replicate (·.card) 1
  --   sum = (filter (·=0)).card · 1 = (filter (·=0)).card (in ℂ)
  -- So 0 = (filter (·=0)).card + (filter (·≠0)).map exp .sum
  -- Hence (filter (·≠0)).map exp .sum = -((filter (·=0)).card : ℂ)
  have h_zero_sum_eq : ((subsetSums s).map Complex.exp).sum = 0 :=
    sum_exp_subsetSums_eq_zero_of_iPi_mem s h_iPi_mem
  -- Split filter
  have h_split : (subsetSums s).map Complex.exp =
                 ((subsetSums s).filter (· = 0)).map Complex.exp +
                 ((subsetSums s).filter (· ≠ 0)).map Complex.exp := by
    rw [← Multiset.map_add]
    congr 1
    exact (Multiset.filter_add_not (· = 0) (subsetSums s)).symm
  rw [h_split] at h_zero_sum_eq
  rw [Multiset.sum_add] at h_zero_sum_eq
  -- (filter (·=0)).map exp = (filter (·=0)).map (fun _ => 1) since each elt is 0
  have h_zero_part : (((subsetSums s).filter (· = 0)).map Complex.exp).sum
                   = (((subsetSums s).filter (· = 0)).card : ℂ) := by
    have h_each_zero : ∀ σ ∈ ((subsetSums s).filter (· = 0)),
        Complex.exp σ = 1 := by
      intros σ hσ
      rw [Multiset.mem_filter] at hσ
      rw [hσ.2, Complex.exp_zero]
    rw [Multiset.map_congr rfl h_each_zero]
    simp [Multiset.map_const', Multiset.sum_replicate]
  rw [h_zero_part] at h_zero_sum_eq
  -- h_zero_sum_eq : (filter (·=0)).card + (filter (·≠0)).map exp .sum = 0
  exact eq_neg_of_add_eq_zero_right h_zero_sum_eq

/-! ## Headline -/

/-- **Wave T4b session 25 — orbit-sum identity at ℂ-poly level**.

    For any Multiset s with `iπ ∈ s`, the polynomial `subsetSumPoly_C s`
    has aroots = nonzero subset-sums and ((aroots).map exp).sum = -m
    where m = #zero-subset-sums.

    This establishes the algebraic identity that cycle 64+ will need
    to LIFT to ℤ[X] via the fundamental theorem of symmetric polynomials,
    completing the bridge for the π² ∉ ℚ case. -/
theorem session_25_orbit_sum_at_complex_poly_level
    (s : Multiset ℂ) (h_iPi_mem : (Complex.I * (Real.pi : ℂ)) ∈ s) :
    (subsetSumPoly_C s).aroots ℂ = (subsetSums s).filter (· ≠ 0) ∧
    (((subsetSumPoly_C s).aroots ℂ).map Complex.exp).sum
      = -(((subsetSums s).filter (· = 0)).card : ℂ) := by
  refine ⟨aroots_subsetSumPoly_C s, sum_exp_aroots_subsetSumPoly_C_eq_neg_m s h_iPi_mem⟩

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit
