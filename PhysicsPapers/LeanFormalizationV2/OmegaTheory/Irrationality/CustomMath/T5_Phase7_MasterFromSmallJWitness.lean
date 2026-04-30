/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_MasterFromSmallJWitness

  T-5 (Roth's theorem) — **`RothLemmaMaster` construction from
  smallJ witness NAMED**.

  Given `T5_NAMED_smallJ_witness_at_q` (V8-atom-1 analytical heart),
  the IR Statement is discharged via V8B-2.  Combined with the
  EXISTING UNCONDITIONAL discharges:
    - `T5_RothWronskianInductiveStep_unconditional` (Phase 2.2)
    - `T5_SchmidtAuxIndexAtAlphaDischarge_unconditional` (Phase 2.4)
  this constructs `RothLemmaMaster` modulo smallJ witness ONLY.

  Composition: smallJ witness → master → V7 capstone (with V7-N1U + Block A+B)
  → RothBoundLarge.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Capstone_SmallJBridge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothWronskianInductiveStep_Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_MasterFromSmallJWitness

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Capstone_SmallJBridge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothWronskianInductiveStep_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure

/-! ## MFSW-1 — Master construction from smallJ witness -/

/-- **🚨🚨🚨 MFSW-1 — `T5_RothLemmaMaster_from_smallJ_witness`**:
    constructs `RothLemmaMaster` from smallJ witness NAMED Prop.

    Composition:
    - Wronskian inductive step: UNCONDITIONAL via existing Phase 2.2.
    - IndexReductionDischarge ≡ T5_RothLemmaIndexReduction_Statement: provided
      via V8B-2 (smallJ witness ⇒ statement) and definitional equality.
    - SchmidtAuxIndexAtAlphaDischarge: UNCONDITIONAL via existing Phase 2.4.

    Result: master is fully unconditional given smallJ witness only. -/
theorem T5_RothLemmaMaster_from_smallJ_witness
    (h_smallJ : T5_NAMED_smallJ_witness_at_q) :
    RothLemmaMaster :=
  T5_RothLemmaMaster_conditional
    T5_RothWronskianInductiveStep_unconditional
    (T5_smallJ_witness_closes_V8_atom1 h_smallJ)
    T5_SchmidtAuxIndexAtAlphaDischarge_unconditional

/-! ## MFSW-2 — Headline: V8 capstone path with smallJ witness as the master-providing NAMED -/

/-- **🚨🚨🚨🚨 MFSW-2 — `T5_V8_master_via_smallJ_witness_HEADLINE`**:
    paper-citable V8 master-construction headline.

    Strategic significance: master is now CONSTRUCTIBLE from smallJ witness.
    Combined with V7 capstone (which takes master + V7-N1-uniform +
    Block A+B + pigeon → RothBoundLarge), the V8 unconditional path
    reduces to discharging:
      1. smallJ witness NAMED (analytical heart of D.6.1)
      2. V7-N1-uniform NAMED (Taylor upper bound, atom 2)
      3. Block A+B NAMED (Schmidt machinery, atom 2)
    Plus pigeon (UNCONDITIONAL via W3-A). 3 NAMED leaves total. -/
theorem T5_V8_master_via_smallJ_witness_HEADLINE :
    -- smallJ witness ⇒ RothLemmaMaster (machine-checked composition)
    T5_NAMED_smallJ_witness_at_q → RothLemmaMaster :=
  T5_RothLemmaMaster_from_smallJ_witness

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_MasterFromSmallJWitness
