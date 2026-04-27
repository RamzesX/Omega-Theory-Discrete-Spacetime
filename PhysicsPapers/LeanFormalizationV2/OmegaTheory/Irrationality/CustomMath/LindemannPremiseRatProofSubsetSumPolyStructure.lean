/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyStructure

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 26 — structural
  properties of subsetSumPoly_C (monicity + degree).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Two structural properties of `subsetSumPoly_C`:

  1. **`subsetSumPoly_C_monic`**: the polynomial is monic (leading
     coefficient = 1), since it's a product of monic linear factors.

  2. **`subsetSumPoly_C_natDegree`**: the natural degree equals the
     count of nonzero subset-sums, `((subsetSums s).filter (·≠0)).card`.

  Both follow from Mathlib's `Polynomial.monic_multiset_prod_of_monic` +
  `Polynomial.natDegree_multiset_prod_X_sub_C_of_count`.

  These properties are useful for cycle 64+: monicity + known degree
  enables direct application of `Polynomial.coeff_eq_esymm_roots_of_card`
  (Mathlib Vieta) to extract the symmetric-polynomial expression of
  each coefficient, which is the entry point to the fundamental theorem
  of symmetric polynomials lift.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyStructure

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit

/-! ## Monicity -/

/-- **Wave T4b session 26 — monicity of subsetSumPoly_C**.

    The polynomial `subsetSumPoly_C s` is monic for any Multiset
    `s : Multiset ℂ`.

    Proof: it's a product of `X - C σ` polynomials, each monic, hence
    the product is monic via `Polynomial.monic_multiset_prod_of_monic`. -/
theorem subsetSumPoly_C_monic (s : Multiset ℂ) :
    (subsetSumPoly_C s).Monic := by
  unfold subsetSumPoly_C
  exact Polynomial.monic_multisetProd_X_sub_C _

/-! ## Degree -/

/-- **Wave T4b session 26 — natDegree of subsetSumPoly_C**.

    The natural degree of `subsetSumPoly_C s` equals the cardinality
    of the multiset of nonzero subset-sums.

    Proof: each factor `X - C σ` has natDegree 1; the product over a
    multiset of cardinality `((subsetSums s).filter (·≠0)).card` has
    natDegree equal to that cardinality (since ℂ is a domain). -/
theorem subsetSumPoly_C_natDegree (s : Multiset ℂ) :
    (subsetSumPoly_C s).natDegree = ((subsetSums s).filter (· ≠ 0)).card := by
  unfold subsetSumPoly_C
  -- Use: natDegree of monic Multiset.prod = sum of natDegrees of factors
  rw [Polynomial.natDegree_multiset_prod_of_monic _ (by
    intros p hp
    obtain ⟨σ, _, h_eq⟩ := Multiset.mem_map.mp hp
    rw [← h_eq]
    exact Polynomial.monic_X_sub_C σ)]
  -- (Multiset.map natDegree (map (X - C ·) (filter (·≠0) (subsetSums s)))).sum
  rw [Multiset.map_map]
  -- Goal: (filter (·≠0) (subsetSums s)).map (natDegree ∘ (X - C ·)) .sum = card
  -- Each (X - C σ).natDegree = 1
  have h_each_one : ∀ σ ∈ ((subsetSums s).filter (· ≠ 0)),
      (Polynomial.natDegree ∘ (fun σ => Polynomial.X - Polynomial.C σ)) σ = 1 := by
    intros σ _
    simp [Function.comp, Polynomial.natDegree_X_sub_C]
  rw [Multiset.map_congr rfl h_each_one]
  -- Now: ((filter ...).map (fun _ => 1)).sum = card
  simp [Multiset.map_const', Multiset.sum_replicate]

/-! ## Card of aroots = degree -/

/-- **Wave T4b session 26 — aroots cardinality matches natDegree**.

    The cardinality of `(subsetSumPoly_C s).aroots ℂ` equals
    `(subsetSumPoly_C s).natDegree`, since ℂ is algebraically closed. -/
theorem subsetSumPoly_C_aroots_card
    (s : Multiset ℂ) :
    ((subsetSumPoly_C s).aroots ℂ).card = (subsetSumPoly_C s).natDegree := by
  rw [aroots_subsetSumPoly_C]
  rw [subsetSumPoly_C_natDegree]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 26**.  Three structural properties
    of `subsetSumPoly_C`:

      1. Monic (leading coeff = 1).
      2. natDegree = count of nonzero subset-sums.
      3. aroots cardinality = natDegree (algebraic closure of ℂ).

    These properties enable cycle 64+'s direct application of
    `Polynomial.coeff_eq_esymm_roots_of_card` (Mathlib Vieta) to extract
    each coefficient as a symmetric polynomial in subset-sums, which is
    the entry to the fundamental theorem of symmetric polynomials lift
    to ℤ[X]. -/
theorem session_26_subsetSumPoly_C_structure
    (s : Multiset ℂ) :
    (subsetSumPoly_C s).Monic ∧
    (subsetSumPoly_C s).natDegree = ((subsetSums s).filter (· ≠ 0)).card ∧
    ((subsetSumPoly_C s).aroots ℂ).card = (subsetSumPoly_C s).natDegree := by
  refine ⟨?_, ?_, ?_⟩
  · exact subsetSumPoly_C_monic s
  · exact subsetSumPoly_C_natDegree s
  · exact subsetSumPoly_C_aroots_card s

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyStructure
