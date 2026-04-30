/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_FromSchmidtMachinery

  T-5 (Roth's theorem) — **Block A+B closure via 3 NEW Schmidt NAMED leaves**.

  Composes:
    - D1 failure → unbounded denominators (UNCONDITIONAL via T5_failure_unboundedDens)
    - SM-1 Schmidt int-poly NAMED (gives m, P_int, degreeOf, α-diagonal index ≥ m/2 - √(mε))
    - D4 iterative pigeonhole UNCONDITIONAL (gives q_seq + violator + growth + ℕ-unbounded)
    - SM-2 Schmidt balance NAMED (gives per-n balance condition)
    - SM-3 Schmidt aeval-nonzero NAMED (gives per-n aeval ≠ 0)
    - D5-corrected UNCONDITIONAL (gives per-n index bound + ℝ-unbounded product)

  Result: T5_NAMED_BlockAB_sequence_extraction discharged given the 3 SM
  NAMED leaves only.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_NamedExtraction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_FromSchmidtMachinery

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_NamedExtraction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition

/-! ## BAB-FSM-1 — Block A+B from 3 Schmidt NAMED leaves -/

/-- **🚨🚨🚨 BAB-FSM-1 — `T5_NAMED_BlockAB_via_3_Schmidt_NAMED`**:
    `T5_NAMED_BlockAB_sequence_extraction` discharged from the 3 NEW
    Schmidt machinery NAMED leaves (SM-1 + SM-2 + SM-3) via existing
    UNCONDITIONAL D4 + D5-corrected pieces. -/
theorem T5_NAMED_BlockAB_via_3_Schmidt_NAMED
    (h_SM1 : T5_NAMED_Schmidt_aux_int_poly)
    (h_SM2 : T5_NAMED_Schmidt_balance_per_n)
    (h_SM3 : T5_NAMED_Schmidt_aeval_nonzero_per_n) :
    T5_NAMED_BlockAB_sequence_extraction := by
  intro α h_irr h_alg ε hε master h_pigeon h_fail
  -- SM-1: get m_threshold + per-m existential of P_int with α-diagonal index
  obtain ⟨m_threshold, h_int_poly⟩ := h_SM1 α h_irr h_alg ε hε
  -- Pick m := max m_threshold 1 (ensure m ≥ 1)
  let m : ℕ := max m_threshold 1
  have hm : 1 ≤ m := le_max_right m_threshold 1
  have h_m_thresh : m_threshold ≤ m := le_max_left m_threshold 1
  -- Apply h_int_poly at this m
  obtain ⟨P_int, h_P_ne, h_R_pos, h_alpha_index⟩ := h_int_poly m h_m_thresh
  -- D1: get unbounded violators from failure
  have h_unbd : T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) :=
    T5_failure_unboundedDens α h_irr h_alg ε hε h_fail
  -- D4: get q_seq with violator + growth + ℕ-unbounded
  obtain ⟨q_seq, h_violator, h_growth, h_unbd_nat⟩ :=
    T5_NAMED_iterative_pigeonhole_sequence_unconditional
      α h_irr ε hε m hm h_pigeon h_unbd
  -- SM-2: per-n balance condition
  have h_balance : ∀ n, T5_DegreeHeightBalanceCondition
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
      (q_seq n) ε :=
    h_SM2 α h_irr ε hε hm P_int h_P_ne q_seq h_violator h_growth
  -- SM-3: per-n aeval-nonzero
  have h_aeval_ne : ∀ n, aeval (fun j => ((q_seq n j : ℚ) : ℝ))
      ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0 :=
    h_SM3 α h_irr ε hε hm P_int h_P_ne q_seq h_violator
  -- D5-corrected: per-n index bound + ℝ-unbounded
  obtain ⟨h_index, h_unbd_real⟩ :=
    T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional
      α h_irr h_alg ε hε hm P_int h_P_ne h_R_pos master h_alpha_index
      q_seq h_violator h_growth h_balance h_unbd_nat h_aeval_ne
  -- Build the existential output
  exact ⟨m, hm, P_int, h_P_ne, h_R_pos,
         q_seq, h_violator, h_growth, h_balance, h_index, h_aeval_ne, h_unbd_real⟩

/-! ## BAB-FSM-2 — Paper headline -/

/-- **🚨🚨🚨🚨 BAB-FSM-2 — `T5_BLOCK_AB_FROM_3_SCHMIDT_NAMED_HEADLINE`**:
    paper-citable Block A+B discharge headline.

    Discharging the 3 Schmidt NAMED leaves (SM-1 + SM-2 + SM-3) closes
    Block A+B unconditionally.  Combined with smallJ witness (V8-atom-1)
    and V7-N1-uniform, V8 capstone is FULLY UNCONDITIONAL. -/
theorem T5_BLOCK_AB_FROM_3_SCHMIDT_NAMED_HEADLINE :
    T5_NAMED_Schmidt_aux_int_poly →
    T5_NAMED_Schmidt_balance_per_n →
    T5_NAMED_Schmidt_aeval_nonzero_per_n →
    T5_NAMED_BlockAB_sequence_extraction :=
  T5_NAMED_BlockAB_via_3_Schmidt_NAMED

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_FromSchmidtMachinery
