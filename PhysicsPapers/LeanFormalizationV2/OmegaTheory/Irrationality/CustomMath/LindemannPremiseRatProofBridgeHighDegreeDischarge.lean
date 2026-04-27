/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeHighDegreeDischarge

  Cycle 63→64 Phase B Wave T-4b session 58 — discharge of the
  high-degree L-W expansion bridge (CYCLE 64 KEYSTONE).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  `LindemannExpansionIdentityBridge_HighDegree` is unconditionally
  provable via the chain:

  1. pQ ≠ 0, deg ≥ 2, aeval π_ℝ pQ = 0  →  ∃ p_ℚ : ℚ[X] non-zero with iπ root
     (algebraic chain s2/s3).
  2. integerNormalization p_ℚ : ℤ[X], non-zero, with iπ as root.
  3. Enumerate f.aroots ℂ (s47).
  4. Apply s50 → p_ℤ, b ≠ 0 with p_ℤ.map ι = b • evaledFormalPoly.
  5. Apply s56 → h_ℤ, m with h_ℤ ≠ 0, h_ℤ.eval 0 ≠ 0, m ≥ 1.
  6. Apply s57 → ((h_ℤ.aroots ℂ).map exp).sum = -m.
  7. Return witness.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExpSum
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAlgebraicChain
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeHighDegreeDischarge

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExtraction
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExpSum
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAlgebraicChain
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultisetEnumeration
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction

/-! ## Step 1: from pQ to f : ℤ[X] with iπ as root -/

/-- From pQ : ℚ[X] non-zero with aeval π_ℝ pQ = 0, construct
    f : ℤ[X] non-zero with aeval (iπ_ℂ) f = 0. -/
theorem exists_int_poly_with_iPi_root
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧
      Polynomial.aeval (Complex.I * (Real.pi : ℂ)) f = 0 := by
  -- Step 1.1: i*π is algebraic over ℚ → ∃ p_ℚ ≠ 0 with aeval (iπ) p_ℚ = 0
  have h_alg : IsAlgebraic ℚ (Complex.I * (Real.pi : ℂ)) :=
    isAlgebraic_iPi_of_aeval_pi_real_zero pQ h_ne h_zero
  obtain ⟨p_ℚ, h_pQ_ne, h_pQ_zero⟩ := h_alg
  -- Step 1.2: Apply integerNormalization → f : ℤ[X], f ≠ 0
  let f : Polynomial ℤ := IsLocalization.integerNormalization (nonZeroDivisors ℤ) p_ℚ
  have h_f_ne : f ≠ 0 := by
    intro hf_eq_zero
    have h_iff : f = 0 ↔ p_ℚ = 0 :=
      IsLocalization.integerNormalization_eq_zero_iff (M := nonZeroDivisors ℤ) le_rfl _
    exact h_pQ_ne (h_iff.mp hf_eq_zero)
  -- Step 1.3: aeval (iπ) f = 0 via integerNormalization_aeval_eq_zero
  have h_f_zero : Polynomial.aeval (Complex.I * (Real.pi : ℂ)) f = 0 := by
    apply IsLocalization.integerNormalization_aeval_eq_zero (M := nonZeroDivisors ℤ)
    exact h_pQ_zero
  exact ⟨f, h_f_ne, h_f_zero⟩

/-! ## Step 2: iπ ∈ f.aroots ℂ -/

/-- For f : ℤ[X] non-zero with aeval (iπ_ℂ) f = 0, we have iπ_ℂ ∈ f.aroots ℂ. -/
theorem iPi_in_aroots
    (f : Polynomial ℤ) (h_f_ne : f ≠ 0)
    (h_f_zero : Polynomial.aeval (Complex.I * (Real.pi : ℂ)) f = 0) :
    Complex.I * (Real.pi : ℂ) ∈ f.aroots ℂ := by
  rw [Polynomial.mem_aroots]
  exact ⟨h_f_ne, h_f_zero⟩

/-! ## Bridge discharge -/

/-- **Wave T4b session 58 — high-degree bridge discharge**.

    `LindemannExpansionIdentityBridge_HighDegree` holds unconditionally:
    given pQ ≠ 0, deg ≥ 2, aeval π_ℝ pQ = 0, produce h : ℤ[X] with
    h ≠ 0, h.eval 0 ≠ 0, m > 0, ((h.aroots ℂ).map exp).sum = -m. -/
theorem bridge_high_degree_discharge :
    LindemannExpansionIdentityBridge_HighDegree := by
  intros pQ h_ne _h_natDeg_ge_2 h_zero
  -- Step 1: build f : ℤ[X] with iπ as root
  obtain ⟨f, h_f_ne, h_f_zero⟩ := exists_int_poly_with_iPi_root pQ h_ne h_zero
  -- Step 2: iπ ∈ f.aroots ℂ
  have h_iPi_in_aroots : Complex.I * (Real.pi : ℂ) ∈ f.aroots ℂ :=
    iPi_in_aroots f h_f_ne h_f_zero
  -- Step 3: Enumerate f.aroots ℂ
  obtain ⟨α, h_α⟩ :=
    exists_enumeration_of_card (f.aroots ℂ) (Multiset.card (f.aroots ℂ)) rfl
  -- iπ ∈ univ.val.map α
  have h_iPi_mem :
      Complex.I * (Real.pi : ℂ) ∈
        ((Finset.univ : Finset (Fin (Multiset.card (f.aroots ℂ)))).val.map α) := by
    rw [h_α]
    exact h_iPi_in_aroots
  -- Step 4: Apply s50 → p_ℤ, b
  obtain ⟨p_ℤ, b, h_b_ne, h_pZ_eq⟩ :=
    evaledFormalPoly_descends_to_Z_at_aroots f h_f_ne (Multiset.card (f.aroots ℂ)) α h_α
  -- Step 5: Apply s56 → h_ℤ, m
  obtain ⟨h_ℤ, m, h_h_ne, h_h_eval_ne, h_m_pos, h_factor⟩ :=
    h_Z_extraction (Multiset.card (f.aroots ℂ)) α h_iPi_mem f h_f_ne h_α
      p_ℤ b h_b_ne h_pZ_eq
  -- Step 6: Apply s57 → exp-sum = -m
  have h_exp_sum : ((h_ℤ.aroots ℂ).map Complex.exp).sum = -(m : ℂ) :=
    h_Z_exp_sum_eq_neg_m (Multiset.card (f.aroots ℂ)) α h_iPi_mem p_ℤ b h_b_ne h_pZ_eq
      h_ℤ m h_h_ne h_m_pos h_factor
  -- Step 7: Witness
  exact ⟨h_ℤ, m, h_h_ne, h_h_eval_ne, h_m_pos, h_exp_sum⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 58 — CYCLE 64 KEYSTONE**.

    `LindemannExpansionIdentityBridge_HighDegree` discharged
    unconditionally via the formal subset-sum polynomial machinery
    (s40-s50) + Mathlib `IsLocalization.integerNormalization` +
    `pow_mul_divByMonic_rootMultiplicity_eq` + Euler's identity. -/
theorem session_58_bridge_high_degree_discharge_headline :
    LindemannExpansionIdentityBridge_HighDegree :=
  bridge_high_degree_discharge

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeHighDegreeDischarge
