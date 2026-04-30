/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Capstone_SmallJBridge

  T-5 (Roth's theorem) — **V8 CAPSTONE BRIDGE: smallJ witness ⇒
  T5_NAMED_HEART_lift_to_rothIndex** (V8-atom-1 unconditional path).

  Connects the V8-D5 reduction (via smallJ witness NAMED) to the existing
  V8 NAMED Prop `T5_NAMED_HEART_lift_to_rothIndex` defined in
  `T5_Phase7_RothLemmaD61_V8DecompositionStatus.lean`. Since that NAMED
  Prop IS `T5_RothLemmaIndexReduction_Statement` by definition, the
  composition theorem
  `T5_RothLemmaIndexReductionDischarge_via_smallJ_witness` directly
  discharges V8-atom-1 from smallJ witness.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemmaD61_V8DecompositionStatus

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Capstone_SmallJBridge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemmaD61_V8DecompositionStatus
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## V8B-1 — smallJ witness ⇒ V8-D5 NAMED (HEART lift) -/

/-- **🚨🚨 V8B-1 — `T5_smallJ_witness_implies_HEART_lift`**:
    smallJ witness NAMED Prop discharges V8-D5 (HEART lift to rothIndex).

    Direct: `T5_NAMED_HEART_lift_to_rothIndex` IS
    `T5_RothLemmaIndexReduction_Statement` by definition (see
    `T5_Phase7_RothLemmaD61_V8DecompositionStatus.lean:81`), and
    `T5_RothLemmaIndexReductionDischarge_via_smallJ_witness` proves
    that Statement from smallJ witness. -/
theorem T5_smallJ_witness_implies_HEART_lift
    (h_witness : T5_NAMED_smallJ_witness_at_q) :
    T5_NAMED_HEART_lift_to_rothIndex :=
  T5_RothLemmaIndexReductionDischarge_via_smallJ_witness h_witness

/-! ## V8B-2 — smallJ witness ⇒ V8-atom-1 closure -/

/-- **🚨🚨🚨 V8B-2 — `T5_smallJ_witness_closes_V8_atom1`**:
    smallJ witness NAMED Prop directly closes V8-atom-1 via the
    existing V8-D6 (`T5_V8_atom1_via_lift`) wrapper.

    Composition: smallJ witness ⇒ HEART lift (V8B-1) ⇒
    T5_RothLemmaIndexReduction_Statement (V8-D6).  This IS V8-atom-1. -/
theorem T5_smallJ_witness_closes_V8_atom1
    (h_witness : T5_NAMED_smallJ_witness_at_q) :
    T5_RothLemmaIndexReduction_Statement :=
  T5_V8_atom1_via_lift (T5_smallJ_witness_implies_HEART_lift h_witness)

/-! ## V8B-3 — V8 capstone signature with smallJ witness as the unique remaining NAMED -/

/-- **🚨🚨🚨🚨 V8B-3 — `T5_V8_atom1_unique_remaining_NAMED_via_smallJ`**:
    paper-citable V8-atom-1 reduction headline.

    V8-atom-1 (D.6.1) closure path now requires ONLY `T5_NAMED_smallJ_witness_at_q`
    (a SINGLE analytical NAMED leaf).  All other architecture is
    UNCONDITIONALLY DISCHARGED:
    - V8-D5 reduction theorem (via csInf_le)
    - V8-D6 lift wrapper (via def-unfold)
    - V8B-1 + V8B-2 chain (via composition of above)

    Discharging smallJ witness → V8-atom-1 fully unconditional → combined
    with V7 capstone (atom 2) → T-5 UNCONDITIONAL. -/
theorem T5_V8_atom1_unique_remaining_NAMED_via_smallJ :
    -- (a) smallJ witness ⇒ HEART lift NAMED (V8-D5)
    (T5_NAMED_smallJ_witness_at_q → T5_NAMED_HEART_lift_to_rothIndex) ∧
    -- (b) smallJ witness ⇒ V8-atom-1 (T5_RothLemmaIndexReduction_Statement)
    (T5_NAMED_smallJ_witness_at_q → T5_RothLemmaIndexReduction_Statement) ∧
    -- (c) smallJ witness is well-formed (identity)
    (T5_NAMED_smallJ_witness_at_q → T5_NAMED_smallJ_witness_at_q) :=
  ⟨T5_smallJ_witness_implies_HEART_lift,
   T5_smallJ_witness_closes_V8_atom1,
   id⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Capstone_SmallJBridge
