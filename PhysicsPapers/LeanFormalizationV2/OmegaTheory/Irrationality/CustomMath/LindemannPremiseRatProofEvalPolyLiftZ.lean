/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ

  Cycle 63→64 Phase B Wave T-4b session 50 — descent of evaluated formal poly
  to ℤ[X] via IsLocalization.integerNormalization.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Combines s49 (lift to ℚ[X]) with Mathlib's
  `IsLocalization.integerNormalization` (specialised at ℤ → ℚ via
  IsFractionRing) to get:

    `∃ p_ℤ : ℤ[X], ∃ b : ℤ, b ≠ 0 ∧
       p_ℤ.map (Int.castRingHom ℂ) = (b : ℂ) • evaledFormalPoly`

  This is the cycle 64 keystone: the evaluated formal subset-sum
  polynomial admits a non-zero integer scaling that descends to ℤ[X].
  The integer scaling is exactly what allows the Lindemann
  exp_polynomial_approx machinery to apply in cycle 64+.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftQ
import Mathlib.RingTheory.Localization.Integral
import Mathlib.RingTheory.Localization.FractionRing

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalPolyEvalCoeffsRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftQ

/-! ## Composition of map: ℤ → ℚ → ℂ -/

/-- Composition of `Polynomial.map`: applying ℤ → ℚ then ℚ → ℂ equals
    applying ℤ → ℂ directly. -/
theorem map_int_via_rat_eq_map_complex (p : Polynomial ℤ) :
    (p.map (algebraMap ℤ ℚ)).map (algebraMap ℚ ℂ) =
      p.map (algebraMap ℤ ℂ) := by
  rw [Polynomial.map_map]
  congr 1

/-! ## Lift to ℤ[X] via integerNormalization -/

/-- **Wave T4b session 50 — generic lift of ℚ-poly to ℤ-poly via integerNormalization**.

    For any `p_ℚ : ℚ[X]`, there exists a non-zero `b : ℤ` and `p_ℤ : ℤ[X]`
    such that `p_ℤ.map (algebraMap ℤ ℚ) = b • p_ℚ`. -/
theorem int_lift_via_integerNormalization (p_ℚ : Polynomial ℚ) :
    ∃ (p_ℤ : Polynomial ℤ) (b : ℤ), b ≠ 0 ∧
      p_ℤ.map (algebraMap ℤ ℚ) = (b : ℚ) • p_ℚ := by
  obtain ⟨b, hb_mem, hb_eq⟩ :=
    IsLocalization.integerNormalization_spec (nonZeroDivisors ℤ) p_ℚ
  refine ⟨IsLocalization.integerNormalization (nonZeroDivisors ℤ) p_ℚ, b, ?_, ?_⟩
  · exact nonZeroDivisors.ne_zero hb_mem
  · -- hb_eq : (integerNormalization _ p_ℚ).map (algebraMap ℤ ℚ) = b • p_ℚ
    -- Goal: ... = (b : ℚ) • p_ℚ
    rw [hb_eq]
    -- Goal: b • p_ℚ = (b : ℚ) • p_ℚ — both are integer scaling
    exact (Int.cast_smul_eq_zsmul ℚ b p_ℚ).symm

/-! ## Specialization to evaluated formal poly -/

/-- **Wave T4b session 50 — evaluated formal poly descends to ℤ[X] up to scalar**.

    For any nonzero `f : ℤ[X]` and any `α : Fin n → ℂ` enumerating
    `f.aroots ℂ`, there exists `p_ℤ : ℤ[X]` and `b : ℤ`, b ≠ 0, such that:

      `p_ℤ.map (algebraMap ℤ ℂ) = (b : ℂ) • ((formalSubsetSumPoly n).map (aeval α))`

    Strategy: chain s49 (ℚ-lift) with integerNormalization. -/
theorem evaledFormalPoly_descends_to_Z_at_aroots
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ) :
    ∃ (p_ℤ : Polynomial ℤ) (b : ℤ), b ≠ 0 ∧
      p_ℤ.map (algebraMap ℤ ℂ) =
        (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom) := by
  -- Step 1: ℚ-lift via s49
  obtain ⟨p_ℚ, h_p_ℚ⟩ := evaledFormalPoly_lifts_to_Q_at_aroots f h_ne n α h_α
  -- h_p_ℚ : p_ℚ.map (algebraMap ℚ ℂ) = (formalSubsetSumPoly n).map (aeval α)
  -- Step 2: ℤ-lift via integerNormalization
  obtain ⟨p_ℤ, b, hb_ne, hb_eq⟩ := int_lift_via_integerNormalization p_ℚ
  -- hb_eq : p_ℤ.map (algebraMap ℤ ℚ) = (b : ℚ) • p_ℚ
  refine ⟨p_ℤ, b, hb_ne, ?_⟩
  -- Goal: p_ℤ.map (algebraMap ℤ ℂ) = (b : ℂ) • evaledFormalPoly
  -- Compute: p_ℤ.map (algebraMap ℤ ℂ)
  --        = (p_ℤ.map (algebraMap ℤ ℚ)).map (algebraMap ℚ ℂ)  (composition)
  --        = ((b : ℚ) • p_ℚ).map (algebraMap ℚ ℂ)  (by hb_eq)
  --        = (b : ℂ) • (p_ℚ.map (algebraMap ℚ ℂ))  (smul-map)
  --        = (b : ℂ) • evaledFormalPoly  (by h_p_ℚ)
  rw [← map_int_via_rat_eq_map_complex p_ℤ]
  rw [hb_eq]
  rw [Polynomial.map_smul]
  rw [h_p_ℚ]
  -- Goal: ((b : ℚ) : ℂ) • _ = (b : ℂ) • _
  congr 1

/-! ## Existential form -/

/-- **Wave T4b session 50 — existence of α + ℤ-lift with non-zero scalar**.

    For any nonzero `f : Polynomial ℤ`, there exists `α : Fin n → ℂ` (with
    n = card (f.aroots ℂ)), `p_ℤ : Polynomial ℤ`, and `b : ℤ`, b ≠ 0, such that:

    1. α enumerates `f.aroots ℂ`
    2. `p_ℤ.map (algebraMap ℤ ℂ) = (b : ℂ) • evaledFormalPoly` -/
theorem exists_enumeration_with_Z_lift
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ (α : Fin (Multiset.card (f.aroots ℂ)) → ℂ) (p_ℤ : Polynomial ℤ) (b : ℤ),
      b ≠ 0 ∧
      ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) =
        f.aroots ℂ ∧
      p_ℤ.map (algebraMap ℤ ℂ) =
        (b : ℂ) • ((formalSubsetSumPoly (Multiset.card (f.aroots ℂ))).map
          (MvPolynomial.aeval α).toRingHom) := by
  obtain ⟨α, h_α, _⟩ := exists_enumeration_with_rational_eval_coeffs f h_ne
  obtain ⟨p_ℤ, b, hb_ne, h_eq⟩ := evaledFormalPoly_descends_to_Z_at_aroots f h_ne _ α h_α
  exact ⟨α, p_ℤ, b, hb_ne, h_α, h_eq⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 50**.  For any nonzero `f : ℤ[X]`,
    there exists an enumeration `α : Fin (card (f.aroots ℂ)) → ℂ` of
    `f.aroots ℂ`, an integer polynomial `p_ℤ : ℤ[X]`, and a non-zero
    integer `b : ℤ` such that `p_ℤ.map (algebraMap ℤ ℂ) = b • evaledFormalPoly`.

    This is the cycle 64 keystone for π² ∉ ℚ closure.  The integer
    polynomial p_ℤ has the exact same roots (in ℂ) as evaledFormalPoly,
    namely all subset-sums of `f.aroots ℂ`.  Combined with the
    Lindemann analytical bound (s8 + s14), this yields the contradiction
    needed to discharge the bridge unconditionally. -/
theorem session_50_evaledFormalPoly_descends_to_Z_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ (α : Fin (Multiset.card (f.aroots ℂ)) → ℂ) (p_ℤ : Polynomial ℤ) (b : ℤ),
      b ≠ 0 ∧
      ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) =
        f.aroots ℂ ∧
      p_ℤ.map (algebraMap ℤ ℂ) =
        (b : ℂ) • ((formalSubsetSumPoly (Multiset.card (f.aroots ℂ))).map
          (MvPolynomial.aeval α).toRingHom) :=
  exists_enumeration_with_Z_lift f h_ne

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ
