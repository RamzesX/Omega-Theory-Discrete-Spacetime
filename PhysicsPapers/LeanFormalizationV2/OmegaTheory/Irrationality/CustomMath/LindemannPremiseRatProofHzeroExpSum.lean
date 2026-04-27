/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExpSum

  Cycle 63→64 Phase B Wave T-4b session 57 — exp-sum identity for h_ℤ.aroots = -m.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Combines s55 (p_ℤ exp-sum = 0) + s56 (h_ℤ extraction p_ℤ = X^m * h_ℤ) +
  Mathlib `aroots_mul` + `aroots_X_pow`:

    `((h_ℤ.aroots ℂ).map exp).sum = -(m : ℂ)`

  This is the cycle 64 keystone identity — exactly the witness that
  `LindemannExpansionIdentityBridge_HighDegree` requires.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExtraction

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExpSum

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroExpSum
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExtraction

/-! ## h_ℤ exp-sum identity -/

/-- **Wave T4b session 57 — h_ℤ exp-sum = -m**.

    For h_ℤ, m from s56 + p_ℤ exp-sum = 0 (s55):

      `((h_ℤ.aroots ℂ).map Complex.exp).sum = -(m : ℂ)` -/
theorem h_Z_exp_sum_eq_neg_m
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom))
    (h_ℤ : Polynomial ℤ) (m : ℕ) (h_h_ne : h_ℤ ≠ 0) (h_m_pos : 0 < m)
    (h_factor : p_ℤ = Polynomial.X ^ m * h_ℤ) :
    ((h_ℤ.aroots ℂ).map Complex.exp).sum = -(m : ℂ) := by
  -- p_ℤ.aroots ℂ = (X^m * h_ℤ).aroots ℂ = (X^m).aroots + h_ℤ.aroots
  have h_pZ_ne : p_ℤ ≠ 0 := p_Z_ne_zero n α p_ℤ b h_b_ne h_pZ
  have h_aroots_split : p_ℤ.aroots ℂ =
      (Polynomial.X ^ m : Polynomial ℤ).aroots ℂ + h_ℤ.aroots ℂ := by
    rw [h_factor]
    apply Polynomial.aroots_mul
    rw [← h_factor]
    exact h_pZ_ne
  -- (X^m).aroots ℂ = m • {0}
  have h_X_pow_aroots : (Polynomial.X ^ m : Polynomial ℤ).aroots ℂ =
      m • ({0} : Multiset ℂ) := Polynomial.aroots_X_pow m
  -- s55: ((p_ℤ.aroots ℂ).map exp).sum = 0
  have h_pZ_exp_sum : ((p_ℤ.aroots ℂ).map Complex.exp).sum = 0 :=
    p_Z_aroots_exp_sum_eq_zero n α h_iPi_mem p_ℤ b h_b_ne h_pZ
  -- Substitute the split into h_pZ_exp_sum
  rw [h_aroots_split, h_X_pow_aroots, Multiset.map_add, Multiset.sum_add] at h_pZ_exp_sum
  -- Compute (m • {0}).map exp .sum
  have h_zero_sum : ((m • ({0} : Multiset ℂ)).map Complex.exp).sum = (m : ℂ) := by
    rw [Multiset.map_nsmul, Multiset.sum_nsmul]
    simp [Complex.exp_zero]
  rw [h_zero_sum] at h_pZ_exp_sum
  -- h_pZ_exp_sum : (m : ℂ) + ((h_ℤ.aroots ℂ).map exp).sum = 0
  -- Goal: ((h_ℤ.aroots ℂ).map exp).sum = -(m : ℂ)
  linear_combination h_pZ_exp_sum

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 57**.  ((h_ℤ.aroots ℂ).map exp).sum = -m. -/
theorem session_57_h_Z_exp_sum_headline
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom))
    (h_ℤ : Polynomial ℤ) (m : ℕ) (h_h_ne : h_ℤ ≠ 0) (h_m_pos : 0 < m)
    (h_factor : p_ℤ = Polynomial.X ^ m * h_ℤ) :
    ((h_ℤ.aroots ℂ).map Complex.exp).sum = -(m : ℂ) :=
  h_Z_exp_sum_eq_neg_m n α h_iPi_mem p_ℤ b h_b_ne h_pZ h_ℤ m h_h_ne h_m_pos h_factor

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExpSum
