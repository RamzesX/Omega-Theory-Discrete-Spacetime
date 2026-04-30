/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_implies_V6_Bridge

  T-5 (Roth's theorem) — **V8 → V6 BRIDGE** (V8 strictly improves V6).

  Establishes that the V8 5-NAMED-leaves capstone (smallJ + V7N1U + 3 SM)
  implies the V6 2-NAMED-atom capstone (`T5_RothLemmaIndexReductionDischarge`
  + `T5_RothBoundLargeFromMasterAndPigeonhole`).

  V8 progress over V6:
    - V6 atom 1 (T5_RothLemmaIndexReductionDischarge) ≡ T5_RothLemmaIndexReduction_Statement
      ⇐ smallJ witness NAMED (via T5_smallJ_witness_closes_V8_atom1).
    - V6 atom 2 (T5_RothBoundLargeFromMasterAndPigeonhole)
      ⇐ V7N1U + 3 SM (via V7 capstone composition + Block A+B from 3 SM).

  Yoneda-style bridge: V8 capstone strictly improves V6 (smaller NAMED leaves,
  more explicit analytical content).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_from_5_NAMED
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_implies_V6_Bridge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_from_5_NAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Capstone_SmallJBridge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_FromSchmidtMachinery
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_NamedExtraction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6

/-! ## VVB-1 — V8's smallJ witness ⇒ V6's atom 1 -/

/-- **VVB-1 — `T5_smallJ_witness_implies_V6_atom1`**: smallJ witness NAMED
    discharges V6's first NAMED atom `T5_RothLemmaIndexReductionDischarge`.

    Direct: `T5_RothLemmaIndexReductionDischarge ≡ T5_RothLemmaIndexReduction_Statement`
    by definition (`T5_Phase7_RothLemma_IndexReduction.lean:120-121`), and
    `T5_smallJ_witness_closes_V8_atom1` gives that Statement from smallJ. -/
theorem T5_smallJ_witness_implies_V6_atom1
    (h_smallJ : T5_NAMED_smallJ_witness_at_q) :
    T5_RothLemmaIndexReductionDischarge :=
  T5_smallJ_witness_closes_V8_atom1 h_smallJ

/-! ## VVB-2 — V8's V7N1U + 3 SM ⇒ V6's atom 2 -/

/-- **VVB-2 — `T5_V7N1U_3SM_implies_V6_atom2`**: V7N1U + 3 SM NAMED
    discharge V6's second NAMED atom `T5_RothBoundLargeFromMasterAndPigeonhole`.

    Composition:
    - 3 SM NAMED ⇒ T5_NAMED_BlockAB_sequence_extraction (via Block A+B from 3 SM).
    - V7N1U + Block A+B + master + pigeon ⇒ RothBoundLarge (via V7 capstone).
    - Lambda-abstract over master + pigeon to get V6 atom 2 form. -/
theorem T5_V7N1U_3SM_implies_V6_atom2
    (h_V7N1U : T5_NAMED_BlockC_Taylor_upper_bound_uniform)
    (h_SM1 : T5_NAMED_Schmidt_aux_int_poly)
    (h_SM2 : T5_NAMED_Schmidt_balance_per_n)
    (h_SM3 : T5_NAMED_Schmidt_aeval_nonzero_per_n) :
    T5_RothBoundLargeFromMasterAndPigeonhole := by
  intro master h_pigeon
  exact T5_V7_capstone_via_BlockAB_full
    h_V7N1U
    (T5_NAMED_BlockAB_via_3_Schmidt_NAMED h_SM1 h_SM2 h_SM3)
    master
    h_pigeon

/-! ## VVB-3 — V8 5-NAMED capstone ⇒ V6 paper headline -/

/-- **🚨🚨🚨 VVB-3 — `T5_V8_implies_V6_paper_headline`**: V8 5-NAMED-leaves
    capstone implies V6 2-NAMED-atom paper headline.

    Strategic significance: documents that V8 STRICTLY IMPROVES V6 by
    making the 2 V6 atoms PROVABLE from smaller, more explicit NAMED leaves.
    The Yoneda-style direction is V8 → V6 (V8 has fewer abstract NAMEDs). -/
theorem T5_V8_implies_V6_paper_headline
    (h_smallJ : T5_NAMED_smallJ_witness_at_q)
    (h_V7N1U : T5_NAMED_BlockC_Taylor_upper_bound_uniform)
    (h_SM1 : T5_NAMED_Schmidt_aux_int_poly)
    (h_SM2 : T5_NAMED_Schmidt_balance_per_n)
    (h_SM3 : T5_NAMED_Schmidt_aeval_nonzero_per_n) :
    omega_theory_v2_T5_roth_paper_headline_V6 :=
  fun _h_idxred _h_bridge =>
    omega_theory_v2_T5_roth_paper_headline_V6_holds
      (T5_smallJ_witness_implies_V6_atom1 h_smallJ)
      (T5_V7N1U_3SM_implies_V6_atom2 h_V7N1U h_SM1 h_SM2 h_SM3)

/-! ## VVB-4 — Paper-citable V8 vs V6 progress headline -/

/-- **🚨🚨🚨🚨 VVB-4 — `T5_V8_VS_V6_PROGRESS_HEADLINE`**: paper-citable
    headline documenting V8 vs V6 progress.

    V6 (2026-04-29): 2 abstract NAMED atoms (T5_RothLemmaIndexReductionDischarge
      + T5_RothBoundLargeFromMasterAndPigeonhole) with no explicit
      decomposition.
    V8 (2026-04-30): 5 explicit NAMED leaves (smallJ + V7N1U + 3 SM) each
      with documented discharge plan.

    Quantitative progress: V6 leaves were "atomic" universal quantifiers
    over Roth-lemma + RothBoundLarge inputs. V8 leaves are factored
    through smaller analytical pieces (witness existence, Taylor upper
    bound with κ, Schmidt machinery). -/
theorem T5_V8_VS_V6_PROGRESS_HEADLINE :
    -- (a) V8 5-NAMED ⇒ V6 paper headline (machine-checked Yoneda bridge)
    (T5_NAMED_smallJ_witness_at_q →
      T5_NAMED_BlockC_Taylor_upper_bound_uniform →
      T5_NAMED_Schmidt_aux_int_poly →
      T5_NAMED_Schmidt_balance_per_n →
      T5_NAMED_Schmidt_aeval_nonzero_per_n →
      omega_theory_v2_T5_roth_paper_headline_V6) ∧
    -- (b) V8 5-NAMED ⇒ V6 atom 1 separately (direct)
    (T5_NAMED_smallJ_witness_at_q → T5_RothLemmaIndexReductionDischarge) ∧
    -- (c) V8 5-NAMED ⇒ V6 atom 2 separately (direct)
    (T5_NAMED_BlockC_Taylor_upper_bound_uniform →
      T5_NAMED_Schmidt_aux_int_poly →
      T5_NAMED_Schmidt_balance_per_n →
      T5_NAMED_Schmidt_aeval_nonzero_per_n →
      T5_RothBoundLargeFromMasterAndPigeonhole) :=
  ⟨T5_V8_implies_V6_paper_headline,
   T5_smallJ_witness_implies_V6_atom1,
   T5_V7N1U_3SM_implies_V6_atom2⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_implies_V6_Bridge
