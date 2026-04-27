/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftQ

  Cycle 63→64 Phase B Wave T-4b session 49 — lift evaluated formal poly to ℚ[X].

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Combines s48 (rational coefficients) with Mathlib's
  `Polynomial.lifts_iff_coeff_lifts` to derive:

    `∃ p_ℚ : Polynomial ℚ, p_ℚ.map (algebraMap ℚ ℂ) =
       (formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom`

  This is the descent of the evaluated formal subset-sum polynomial
  to ℚ[X], a major cycle 64 keystone toward π² ∉ ℚ closure.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalPolyEvalCoeffsRational
import Mathlib.Algebra.Polynomial.Lifts

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftQ

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalPolyEvalCoeffsRational

/-! ## Rat cast = algebraMap ℚ ℂ -/

/-- `algebraMap ℚ ℂ q = (q : ℂ)` for any `q : ℚ`. -/
theorem algebraMap_Q_C_eq_cast (q : ℚ) :
    algebraMap ℚ ℂ q = (q : ℂ) := by
  simp [Rat.cast_def, algebraMap, Algebra.algebraMap, IsScalarTower.algebraMap_eq]

/-! ## Lift to ℚ[X] -/

/-- **Wave T4b session 49 — generic lift of poly with rational coefficients to ℚ[X]**.

    Given a polynomial `p : ℂ[X]` such that every coefficient is rational,
    there exists `p_ℚ : ℚ[X]` such that `p_ℚ.map (algebraMap ℚ ℂ) = p`. -/
theorem lift_to_Q_of_coeffs_rational
    (p : Polynomial ℂ)
    (h_rat : ∀ k : ℕ, ∃ q : ℚ, p.coeff k = (q : ℂ)) :
    ∃ p_ℚ : Polynomial ℚ, p_ℚ.map (algebraMap ℚ ℂ) = p := by
  -- Use Mathlib's Polynomial.lifts_iff_coeff_lifts
  have h_lifts : p ∈ Polynomial.lifts (algebraMap ℚ ℂ) := by
    rw [Polynomial.lifts_iff_coeff_lifts]
    intro k
    obtain ⟨q, hq⟩ := h_rat k
    refine ⟨q, ?_⟩
    rw [algebraMap_Q_C_eq_cast]
    exact hq.symm
  exact (Polynomial.mem_lifts _).mp h_lifts

/-! ## Specialization to evaluated formalSubsetSumPoly -/

/-- **Wave T4b session 49 — evaluated formal poly lifts to ℚ[X]**.

    For any nonzero `f : ℤ[X]` and any `α : Fin n → ℂ` enumerating
    `f.aroots ℂ`, there exists `p_ℚ : ℚ[X]` such that
    `p_ℚ.map (algebraMap ℚ ℂ) = (formalSubsetSumPoly n).map (aeval α)`. -/
theorem evaledFormalPoly_lifts_to_Q_at_aroots
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ) :
    ∃ p_ℚ : Polynomial ℚ,
      p_ℚ.map (algebraMap ℚ ℂ) =
        (formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom := by
  apply lift_to_Q_of_coeffs_rational
  intro k
  exact evaledFormalPoly_coeff_rational_at_aroots f h_ne n α h_α k

/-! ## Existential form -/

/-- **Wave T4b session 49 — existence of α + ℚ-lift**.

    For any nonzero `f : Polynomial ℤ`, there exists `α : Fin n → ℂ`
    (with n = card (f.aroots ℂ)) AND `p_ℚ : Polynomial ℚ` such that:
    1. α enumerates `f.aroots ℂ`
    2. `p_ℚ.map (algebraMap ℚ ℂ) = (formalSubsetSumPoly n).map (aeval α)` -/
theorem exists_enumeration_with_Q_lift
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ (α : Fin (Multiset.card (f.aroots ℂ)) → ℂ) (p_ℚ : Polynomial ℚ),
      ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) =
        f.aroots ℂ ∧
      p_ℚ.map (algebraMap ℚ ℂ) =
        (formalSubsetSumPoly (Multiset.card (f.aroots ℂ))).map
          (MvPolynomial.aeval α).toRingHom := by
  obtain ⟨α, h_α, _⟩ := exists_enumeration_with_rational_eval_coeffs f h_ne
  obtain ⟨p_ℚ, h_p_ℚ⟩ := evaledFormalPoly_lifts_to_Q_at_aroots f h_ne _ α h_α
  exact ⟨α, p_ℚ, h_α, h_p_ℚ⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 49**.  For any nonzero `f : ℤ[X]`,
    there exists an enumeration `α : Fin (card (f.aroots ℂ)) → ℂ` of
    `f.aroots ℂ` AND a polynomial `p_ℚ : ℚ[X]` such that `p_ℚ` maps to
    the evaluated formal subset-sum polynomial.

    This is the cycle 64 keystone for π² ∉ ℚ closure. -/
theorem session_49_evaledFormalPoly_lifts_to_Q_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ (α : Fin (Multiset.card (f.aroots ℂ)) → ℂ) (p_ℚ : Polynomial ℚ),
      ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) =
        f.aroots ℂ ∧
      p_ℚ.map (algebraMap ℚ ℂ) =
        (formalSubsetSumPoly (Multiset.card (f.aroots ℂ))).map
          (MvPolynomial.aeval α).toRingHom :=
  exists_enumeration_with_Q_lift f h_ne

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftQ
