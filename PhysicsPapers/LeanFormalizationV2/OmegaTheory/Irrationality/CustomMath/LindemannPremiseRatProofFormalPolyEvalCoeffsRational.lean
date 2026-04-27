/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalPolyEvalCoeffsRational

  Cycle 63→64 Phase B Wave T-4b session 48 — coefficients of the
  evaluated formalSubsetSumPoly are rational.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Direct corollary of s46 + s47.  For any nonzero `f : ℤ[X]` and any
  `α : Fin n → ℂ` enumerating `f.aroots ℂ`:

    `∀ k : ℕ, ∃ q : ℚ,
       ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).coeff k = (q : ℂ)`

  This is the polynomial-level statement: every coefficient of the
  ℂ-valued polynomial obtained by evaluating the formal one at α
  is rational.

  This is the cycle 64 keystone for π² ∉ ℚ closure: it shows that the
  polynomial encoding the subset-sums of `f.aroots ℂ` already has all
  rational coefficients, hence descends to ℚ[X] (and after clearing
  denominators, to ℤ[X]).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalCoeffEvalRational
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultisetEnumeration

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalPolyEvalCoeffsRational

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalCoeffEvalRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultisetEnumeration

/-! ## Coefficient of map polynomial = aeval of original coefficient -/

/-- Generic Mathlib fact: the k-th coefficient of `Polynomial.map φ p`
    equals `φ` applied to the k-th coefficient of `p`. -/
theorem coeff_map_via_aeval
    (n : ℕ) (α : Fin n → ℂ) (k : ℕ) :
    ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).coeff k =
      (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) := by
  rw [Polynomial.coeff_map]
  rfl

/-! ## Evaluated formal poly has rational coefficients -/

/-- **Wave T4b session 48 — evaluated formal poly has rational coefficients**.

    For any `α : Fin n → ℂ` such that every `(univ.val.map α).esymm k` is
    rational, the polynomial `(formalSubsetSumPoly n).map (aeval α)`
    has rational coefficients (each coefficient is in ℚ-image of ℂ). -/
theorem evaledFormalPoly_coeff_rational_of_esymm_rational
    (n : ℕ) (α : Fin n → ℂ)
    (h_rat : ∀ k : ℕ, ∃ q : ℚ,
       ((Finset.univ : Finset (Fin n)).val.map α).esymm k = (q : ℂ))
    (k : ℕ) :
    ∃ q : ℚ,
      ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).coeff k =
        (q : ℂ) := by
  rw [coeff_map_via_aeval]
  exact formalCoeff_eval_rational_of_esymm_rational n α h_rat k

/-! ## Specialization to f.aroots ℂ -/

/-- **Wave T4b session 48 — specialization to α enumerating f.aroots ℂ**.

    For any nonzero `f : ℤ[X]` and any `α : Fin n → ℂ` enumerating
    `f.aroots ℂ` (i.e., `Finset.univ.val.map α = f.aroots ℂ`), every
    coefficient of `(formalSubsetSumPoly n).map (aeval α)` is rational. -/
theorem evaledFormalPoly_coeff_rational_at_aroots
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (k : ℕ) :
    ∃ q : ℚ,
      ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).coeff k =
        (q : ℂ) := by
  rw [coeff_map_via_aeval]
  exact formalCoeff_eval_rational_at_aroots f h_ne n α h_α k

/-! ## Existential form: enumeration α exists with all rational coefficients -/

/-- **Wave T4b session 48 — existence of enumeration with rational eval coeffs**.

    For any nonzero `f : Polynomial ℤ` and `n := Multiset.card (f.aroots ℂ)`,
    there exists `α : Fin n → ℂ` enumerating `f.aroots ℂ`, AND for every
    `k : ℕ`, the k-th coefficient of `(formalSubsetSumPoly n).map (aeval α)`
    is rational. -/
theorem exists_enumeration_with_rational_eval_coeffs
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ (α : Fin (Multiset.card (f.aroots ℂ)) → ℂ),
      ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) =
        f.aroots ℂ ∧
      ∀ k : ℕ, ∃ q : ℚ,
        ((formalSubsetSumPoly (Multiset.card (f.aroots ℂ))).map
          (MvPolynomial.aeval α).toRingHom).coeff k = (q : ℂ) := by
  obtain ⟨α, h_α⟩ := exists_enumeration_of_card (f.aroots ℂ)
                       (Multiset.card (f.aroots ℂ)) rfl
  refine ⟨α, h_α, ?_⟩
  intro k
  exact evaledFormalPoly_coeff_rational_at_aroots f h_ne _ α h_α k

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 48**.  For any nonzero `f : ℤ[X]`,
    there exists an enumeration `α : Fin (card (f.aroots ℂ)) → ℂ` of
    `f.aroots ℂ` such that every coefficient of the evaluated formal
    subset-sum polynomial is rational.

    This is the cycle 64 keystone for π² ∉ ℚ closure.  Combined with
    `Polynomial.descend_to_Q` (any ℂ-poly with rational coefficients
    descends to ℚ[X]) + `IsLocalization.integerNormalization` (any
    ℚ-poly clears denominators to ℤ[X]), we get the integer polynomial
    `h : ℤ[X]` whose roots include all nonzero subset-sums of `f.aroots ℂ`
    — exactly what's needed for the Lindemann analytical bound. -/
theorem session_48_evaledFormalPoly_coeff_rational_at_aroots_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ (α : Fin (Multiset.card (f.aroots ℂ)) → ℂ),
      ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) =
        f.aroots ℂ ∧
      ∀ k : ℕ, ∃ q : ℚ,
        ((formalSubsetSumPoly (Multiset.card (f.aroots ℂ))).map
          (MvPolynomial.aeval α).toRingHom).coeff k = (q : ℂ) :=
  exists_enumeration_with_rational_eval_coeffs f h_ne

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalPolyEvalCoeffsRational
