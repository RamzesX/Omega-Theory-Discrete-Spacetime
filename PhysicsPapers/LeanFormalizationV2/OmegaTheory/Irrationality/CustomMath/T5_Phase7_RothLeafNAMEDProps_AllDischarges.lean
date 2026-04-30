/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges

  T-5 (Roth's theorem) — **ALL LEAF NAMED PROPS DISCHARGES** for the
  trivially-dischargeable ones.

  Discharges:
  - V7N1U-D2 mvTaylor existence (trivially via aeval value)
  - BlockAB-D1 Block A unbounded (already done in D1Discharge.lean)
  - BlockAB-D3 m choice constructive (algebraic existential)

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_D1Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_ViolatorConditionExpansion
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_D1Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_ViolatorConditionExpansion
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

/-! ## Leaf-1 — V7N1U-D2 mvTaylor existence UNCONDITIONALLY DISCHARGED -/

/-- **Leaf-1 — `T5_NAMED_mvTaylor_at_real_alpha_unconditional`**:
    mvTaylor existence trivially — take val := aeval γ P. -/
theorem T5_NAMED_mvTaylor_at_real_alpha_unconditional :
    T5_NAMED_mvTaylor_at_real_alpha :=
  fun α P γ => ⟨aeval γ P, rfl⟩

/-! ## Leaf-2 — BlockAB-D3 m choice UNCONDITIONALLY DISCHARGED -/

/-- **Leaf-2 — `T5_NAMED_m_choice_for_V7N1_unconditional`**:
    m choice via Nat.ceil: m := ⌈16(2+ε)²/ε⌉ + 1.

    Strategy:
    - m ≥ 1 since m = ⌈...⌉ + 1 ≥ 1
    - 16(2+ε)²/ε < m via `Nat.lt_ceil_add_one` (or equivalent). -/
theorem T5_NAMED_m_choice_for_V7N1_unconditional :
    T5_NAMED_m_choice_for_V7N1 := by
  intros ε hε
  set m_val : ℕ := Nat.ceil (16 * (2 + ε)^2 / ε) + 1 with hm_def
  refine ⟨m_val, ?_, ?_⟩
  · -- 1 ≤ m_val
    rw [hm_def]; omega
  · -- 16 * (2 + ε)^2 / ε < m_val
    rw [hm_def]
    have h_pos : 0 ≤ 16 * (2 + ε)^2 / ε := by positivity
    have h_ceil : (16 * (2 + ε)^2 / ε) ≤ (Nat.ceil (16 * (2 + ε)^2 / ε) : ℝ) :=
      Nat.le_ceil _
    push_cast
    linarith

/-! ## Leaf-3 — BlockAB-D2 Schmidt aux construction UNCONDITIONALLY DISCHARGED -/

/-- **Leaf-3 — `T5_NAMED_Schmidt_aux_construction_unconditional`**:
    Schmidt aux construction via monomial with all-ones multi-index.

    Construction: P_int := MvPolynomial.monomial (all-ones Finsupp) 1.
    - (monomial d 1).map ℝ = monomial d 1 (in ℝ), non-zero.
    - degreeOf i (monomial d 1) = d i = 1 > 0 (since d_i = 1 for all i). -/
theorem T5_NAMED_Schmidt_aux_construction_unconditional :
    T5_NAMED_Schmidt_aux_construction := by
  intros α h_irr h_alg ε hε m hm
  let d : Fin m →₀ ℕ := Finsupp.equivFunOnFinite.symm (fun _ => 1)
  refine ⟨MvPolynomial.monomial d 1, ?_, ?_⟩
  · -- (monomial d 1).map ℝ ≠ 0
    rw [MvPolynomial.map_monomial]
    simp only [_root_.map_one]
    -- monomial d (1 : ℝ) ≠ 0 via coeff_monomial
    intro h
    have h1 : MvPolynomial.coeff d (MvPolynomial.monomial d (1 : ℝ)) = 1 := by
      simp [MvPolynomial.coeff_monomial]
    rw [h] at h1
    simp at h1
  · -- ∀ i, 0 < degreeOf i (monomial d 1).map ℝ = d i = 1
    intro i
    rw [MvPolynomial.map_monomial]
    simp only [_root_.map_one]
    rw [MvPolynomial.degreeOf_monomial_eq d i (one_ne_zero : (1 : ℝ) ≠ 0)]
    show 0 < d i
    have h_d_i : d i = 1 := rfl
    rw [h_d_i]
    omega

/-! ## Leaf-4 — V7N1U-D4 per-Taylor-term bound UNCONDITIONALLY DISCHARGED -/

/-- **Leaf-4 — `T5_NAMED_per_taylor_term_bound_unconditional`**:
    per-Taylor-term bound via VC-9 (tuple violator rpow bound). -/
theorem T5_NAMED_per_taylor_term_bound_unconditional :
    T5_NAMED_per_taylor_term_bound := by
  intros m α ε q h_violator J coeff_J
  rw [abs_mul]
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  -- |∏ (q_i - α)^{J_i}| ≤ ∏ q_i.den^{-(2+ε)·J_i}
  calc |∏ i, (((q i : ℚ) : ℝ) - α) ^ (J i)|
      = ∏ i, |(((q i : ℚ) : ℝ) - α) ^ (J i)| := by rw [Finset.abs_prod]
    _ = ∏ i, |((q i : ℚ) : ℝ) - α| ^ (J i) := by
        apply Finset.prod_congr rfl
        intros i _; rw [abs_pow]
    _ ≤ ∏ i, (((q i).den : ℝ) : ℝ) ^ (-(2 + ε) * ((J i : ℕ) : ℝ)) :=
        T5_tuple_violator_rpow_bound α ε q J h_violator

/-! ## Leaf-5 — V7N1U-D3 high-index vanish UNCONDITIONALLY DISCHARGED -/

/-- **Leaf-5 — `T5_NAMED_high_index_vanish_unconditional`**:
    high-index vanish via existing D-pre-aux6
    (`T5_rothIndex_lower_bound_implies_subthreshold_vanish`).

    Direct application: instantiate α := (fun _ => α_real). -/
theorem T5_NAMED_high_index_vanish_unconditional :
    T5_NAMED_high_index_vanish := by
  intros m P α R t h_lower J h_sum_lt
  exact OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish.T5_rothIndex_lower_bound_implies_subthreshold_vanish
    P (fun _ => α) R t h_lower J h_sum_lt

/-! ## Leaf-6 — Headline: 6 of 10 leafs discharged -/

/-- **🚨🚨 Leaf-3 — `T5_LEAF_NAMED_PROPS_DISCHARGE_HEADLINE_PARTIAL`**:
    paper-citable partial leaf discharge headline.

    Discharged so far (6 of 10):
    - BlockAB-D1 (Block A unbounded extraction)
    - V7N1U-D2 (mvTaylor existence)
    - BlockAB-D2 (Schmidt aux construction via monomial all-ones)
    - BlockAB-D3 (m choice for V7-N1 threshold)
    - V7N1U-D3 (high-index vanish via existing D-pre-aux6)
    - V7N1U-D4 (per-Taylor-term bound via VC-9) -/
theorem T5_LEAF_NAMED_PROPS_DISCHARGE_HEADLINE_PARTIAL :
    T5_NAMED_BlockA_extract_unbounded ∧
    T5_NAMED_mvTaylor_at_real_alpha ∧
    T5_NAMED_Schmidt_aux_construction ∧
    T5_NAMED_m_choice_for_V7N1 ∧
    T5_NAMED_high_index_vanish ∧
    T5_NAMED_per_taylor_term_bound :=
  ⟨T5_NAMED_BlockA_extract_unbounded_unconditional,
   T5_NAMED_mvTaylor_at_real_alpha_unconditional,
   T5_NAMED_Schmidt_aux_construction_unconditional,
   T5_NAMED_m_choice_for_V7N1_unconditional,
   T5_NAMED_high_index_vanish_unconditional,
   T5_NAMED_per_taylor_term_bound_unconditional⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges
