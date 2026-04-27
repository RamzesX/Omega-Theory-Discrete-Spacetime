/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroExpSum

  Cycle 63→64 Phase B Wave T-4b session 55 — exp-sum identity for p_ℤ.aroots,
  + p_ℤ ≠ 0.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Properties of p_ℤ from s50 derived from s54:

  1. **p_ℤ ≠ 0**: since p_ℤ.map ι = b • evaledFormalPoly, b ≠ 0, and
     evaledFormalPoly is monic non-zero.

  2. **((p_ℤ.aroots ℂ).map exp).sum = 0**: since
     p_ℤ.aroots ℂ = evaledFormalPoly.aroots ℂ (same Multiset, scalar `b`
     doesn't change roots).  Combined with s54.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyArootsExp
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroXdvd

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroExpSum

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyArootsExp

/-! ## evaledFormalPoly is monic non-zero -/

/-- evaledFormalPoly is monic, hence non-zero. -/
theorem evaledFormalPoly_monic (n : ℕ) (α : Fin n → ℂ) :
    ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).Monic := by
  rw [evaledFormalPoly_eq_multisetProd]
  -- Goal: Monic ((univ.powerset.val.map (fun S => X - C σ_S)).prod)
  -- Convert to Monic ((s.map (X - C ·)).prod) form
  rw [show ((Finset.univ : Finset (Fin n)).powerset.val.map
              (fun S : Finset (Fin n) => Polynomial.X - Polynomial.C (∑ i ∈ S, α i))) =
          ((Finset.univ : Finset (Fin n)).powerset.val.map
              (fun S : Finset (Fin n) => ∑ i ∈ S, α i)).map
            (fun a : ℂ => Polynomial.X - Polynomial.C a) from ?_]
  · exact Polynomial.monic_multisetProd_X_sub_C _
  · rw [Multiset.map_map]
    rfl

/-- evaledFormalPoly is non-zero. -/
theorem evaledFormalPoly_ne_zero (n : ℕ) (α : Fin n → ℂ) :
    ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom) ≠ 0 :=
  (evaledFormalPoly_monic n α).ne_zero

/-! ## p_ℤ ≠ 0 -/

/-- p_ℤ from s50 is non-zero. -/
theorem p_Z_ne_zero
    (n : ℕ) (α : Fin n → ℂ)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    p_ℤ ≠ 0 := by
  intro h_zero
  -- p_ℤ = 0 → p_ℤ.map ι = 0
  rw [h_zero, Polynomial.map_zero] at h_pZ
  -- h_pZ : 0 = (b : ℂ) • evaledFormalPoly
  have h_b_C_ne : (b : ℂ) ≠ 0 := by exact_mod_cast h_b_ne
  have : (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom) ≠ 0 := by
    rw [smul_ne_zero_iff]
    refine ⟨h_b_C_ne, ?_⟩
    exact evaledFormalPoly_ne_zero n α
  exact this h_pZ.symm

/-! ## p_ℤ.aroots ℂ exp-sum = 0 -/

/-- For nonzero `f : ℤ[X]` with `iπ ∈ univ.val.map α`, the exp-sum
    of p_ℤ.aroots ℂ is 0. -/
theorem p_Z_aroots_exp_sum_eq_zero
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    ((p_ℤ.aroots ℂ).map Complex.exp).sum = 0 := by
  -- p_ℤ.aroots ℂ = (p_ℤ.map ι).roots
  have h_aroots_def : p_ℤ.aroots ℂ = (p_ℤ.map (algebraMap ℤ ℂ)).roots := by
    rw [Polynomial.aroots_def]
  rw [h_aroots_def, h_pZ]
  -- Goal: (((b : ℂ) • evaledFormalPoly).roots.map exp).sum = 0
  -- (c • p).roots = p.roots when c ≠ 0
  have h_b_C_ne : (b : ℂ) ≠ 0 := by exact_mod_cast h_b_ne
  rw [Polynomial.smul_eq_C_mul]
  rw [Polynomial.roots_C_mul _ h_b_C_ne]
  -- Goal: ((evaledFormalPoly.roots).map exp).sum = 0
  -- For ℂ-coeff poly, aroots ℂ = roots
  have h_aroots_eq_roots : ∀ (q : Polynomial ℂ), q.aroots ℂ = q.roots := by
    intro q
    rw [Polynomial.aroots_def]
    congr 1
    exact Polynomial.map_id
  rw [← h_aroots_eq_roots]
  exact aroots_evaledFormalPoly_exp_sum_eq_zero n α h_iPi_mem

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 55**.

    1. p_ℤ ≠ 0.
    2. ((p_ℤ.aroots ℂ).map exp).sum = 0.

    Both follow from s50 + s54.  Cycle 64+ uses these to extract
    h_ℤ := p_ℤ /ₘ X^m where m = rootMultiplicity 0 p_ℤ. -/
theorem session_55_p_Z_exp_sum_headline
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    p_ℤ ≠ 0 ∧ ((p_ℤ.aroots ℂ).map Complex.exp).sum = 0 := by
  refine ⟨?_, ?_⟩
  · exact p_Z_ne_zero n α p_ℤ b h_b_ne h_pZ
  · exact p_Z_aroots_exp_sum_eq_zero n α h_iPi_mem p_ℤ b h_b_ne h_pZ

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroExpSum
