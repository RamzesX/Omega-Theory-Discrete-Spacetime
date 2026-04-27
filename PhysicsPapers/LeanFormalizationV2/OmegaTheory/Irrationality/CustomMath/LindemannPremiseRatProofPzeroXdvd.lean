/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroXdvd

  Cycle 63→64 Phase B Wave T-4b session 52 — p_ℤ has 0 as root, hence X | p_ℤ.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Combines s50 + s51:
  - s50: p_ℤ.map (algebraMap ℤ ℂ) = b • evaledFormalPoly with b ≠ 0
  - s51: evaledFormalPoly.eval 0 = 0

  → p_ℤ.eval 0 = 0 (via injectivity of algebraMap ℤ ℂ on integers)
  → X | p_ℤ in ℤ[X] (by Polynomial.X_dvd_iff)

  Strictly speaking, evaledFormalPoly factors as X^m · subsetSumPoly_C
  where m = #{S ⊆ Fin n : σ_S = 0} ≥ 1.  The single X-divisibility
  step here is the FIRST iteration of that factorization.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroXdvd

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots

/-! ## p_ℤ.eval 0 = 0 -/

/-- For any nonzero `f : ℤ[X]`, the integer polynomial `p_ℤ` from s50
    has 0 as a root: `p_ℤ.eval 0 = 0`. -/
theorem p_Z_eval_zero_eq_zero
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    p_ℤ.eval 0 = 0 := by
  -- Step 1: (p_ℤ.eval 0 : ℂ) = (p_ℤ.map (algebraMap ℤ ℂ)).eval 0
  have h_eval_cast : ((p_ℤ.eval 0 : ℤ) : ℂ) = (p_ℤ.map (algebraMap ℤ ℂ)).eval 0 := by
    rw [Polynomial.eval_map, Polynomial.eval₂_at_zero]
    -- Goal: (p_ℤ.eval 0 : ℂ) = algebraMap ℤ ℂ (p_ℤ.coeff 0)
    rw [← Polynomial.coeff_zero_eq_eval_zero]
    simp [algebraMap_int_eq, eq_intCast]
  -- Step 2: rewrite via h_pZ
  rw [h_pZ] at h_eval_cast
  -- Goal: (b : ℂ) • evaledFormalPoly evaluates to 0 at 0
  rw [Polynomial.eval_smul] at h_eval_cast
  rw [evaledFormalPoly_eval_zero_eq_zero n α] at h_eval_cast
  -- h_eval_cast : (p_ℤ.eval 0 : ℂ) = (b : ℂ) • 0 = 0
  rw [smul_zero] at h_eval_cast
  -- h_eval_cast : (p_ℤ.eval 0 : ℂ) = 0
  exact_mod_cast h_eval_cast

/-! ## X divides p_ℤ in ℤ[X] -/

/-- `X | p_ℤ` in ℤ[X], following from `p_ℤ.eval 0 = 0`. -/
theorem X_dvd_p_Z
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    Polynomial.X ∣ p_ℤ := by
  rw [Polynomial.X_dvd_iff]
  -- Goal: p_ℤ.coeff 0 = 0
  -- Use: p_ℤ.coeff 0 = p_ℤ.eval 0 (for any polynomial)
  have h_coeff_eq_eval : p_ℤ.coeff 0 = p_ℤ.eval 0 := by
    rw [← Polynomial.coeff_zero_eq_eval_zero]
  rw [h_coeff_eq_eval]
  exact p_Z_eval_zero_eq_zero f h_ne n α h_α p_ℤ b h_b_ne h_pZ

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 52**.  The integer polynomial p_ℤ
    from s50 has `X` as a factor (in ℤ[X]) because evaledFormalPoly
    has 0 as a root (from S = ∅ contributing σ = 0).

    This is the first step toward fully factoring `p_ℤ = X^m · h_ℤ`
    in ℤ[X] (cycle 64+ goal). -/
theorem session_52_p_Z_eval_zero_and_X_dvd_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    p_ℤ.eval 0 = 0 ∧ Polynomial.X ∣ p_ℤ := by
  refine ⟨?_, ?_⟩
  · exact p_Z_eval_zero_eq_zero f h_ne n α h_α p_ℤ b h_b_ne h_pZ
  · exact X_dvd_p_Z f h_ne n α h_α p_ℤ b h_b_ne h_pZ

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroXdvd
