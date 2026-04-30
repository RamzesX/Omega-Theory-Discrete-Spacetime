/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7DraftPostN2N3

  T-5 (Roth's theorem) — **V7 capstone simplified target post-V7-N2 + V7-N3
  unconditional discharges**.

  After V7-N3 (commit eae18f5) and V7-N2 (commit 6fb84c7) UNCONDITIONALLY
  DISCHARGED, the V7 capstone target reduces to:

    T5_NAMED_BlockC_Taylor_upper_bound →
    RothLemmaMaster →
    T5_PigeonholeMTuple_Statement →
    RothBoundLarge

  i.e., V7 capstone now requires ONLY the multivariate Taylor upper bound
  (V7-N1) to land, plus master + pigeonhole (which are already
  unconditional via prior fires).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — bridge theorems with real proofs.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7DraftPostN2N3

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

/-! ## V7-T1.5b — Simplified V7 target signature post-V7-N2 + V7-N3 -/

/-- **V7-T1.5b — `T5_atom2_V7_capstone_target_signature_postN2N3`**:
    SIMPLIFIED V7 target signature post-V7-N2 + V7-N3 unconditional
    discharges.

    Requires only V7-N1 (Block C Taylor upper bound) as a NAMED
    hypothesis, since V7-N2 and V7-N3 are now unconditional. -/
def T5_atom2_V7_capstone_target_signature_postN2N3 : Prop :=
  T5_NAMED_BlockC_Taylor_upper_bound →
  RothLemmaMaster →
  T5_PigeonholeMTuple_Statement →
  RothBoundLarge

/-! ## V7-T1.5b-bridge — postN3 implies postN2N3 -/

/-- **V7-T1.5b-bridge — `T5_V7_target_postN3_implies_postN2N3`**:
    bridges the post-N3 target (3 NAMED Props) to the post-N2N3 target
    (2 NAMED Props) using V7-N2 unconditional.

    Direction: if the OLD target signature (with V7-N2 hypothesis) holds,
    then the NEW signature (without V7-N2) follows automatically since
    V7-N2 is now provable. -/
theorem T5_V7_target_postN3_implies_postN2N3
    (h : T5_atom2_V7_capstone_target_signature_postN3) :
    T5_atom2_V7_capstone_target_signature_postN2N3 := by
  intros hN1 master h_pigeon
  exact h hN1 T5_NAMED_BlockD_integer_lower_bound_unconditional master h_pigeon

/-! ## V7-T1.5b-bridge-rev — postN2N3 implies full postN3 (trivial direction) -/

/-- **V7-T1.5b-bridge-rev — `T5_V7_target_postN2N3_implies_postN3`**:
    reverse direction (trivial — ignore the V7-N2 hypothesis input). -/
theorem T5_V7_target_postN2N3_implies_postN3
    (h : T5_atom2_V7_capstone_target_signature_postN2N3) :
    T5_atom2_V7_capstone_target_signature_postN3 := by
  intros hN1 _hN2 master h_pigeon
  exact h hN1 master h_pigeon

/-! ## V7-T2 — Bridge to full target via V7-N3 + V7-N2 -/

/-- **V7-T2 — `T5_V7_target_postN2N3_implies_full`**: from post-N2N3
    signature, derive the full V7 target signature (with all 3
    hypotheses), via V7-N2 + V7-N3 unconditional. -/
theorem T5_V7_target_postN2N3_implies_full
    (h : T5_atom2_V7_capstone_target_signature_postN2N3) :
    T5_atom2_V7_capstone_target_signature := by
  intros hN1 _hN2 _hN3 master h_pigeon
  exact h hN1 master h_pigeon

/-! ## V7-T3 — Equivalence headline -/

/-- **🚨🚨🚨 V7-T3 — `T5_V7_TARGET_SIGNATURES_EQUIVALENCE_HEADLINE`**:
    paper-citable bundle showing the V7 target signature simplification
    chain after V7-N2 + V7-N3 unconditional discharges.

    Starting from the original 3-NAMED-hypothesis form, V7-N3 discharge
    reduced it to 2-NAMED (post-N3), and V7-N2 discharge reduced it
    further to 1-NAMED (post-N2N3 — only V7-N1 remains).

    The remaining V7 capstone work is to discharge V7-N1 (multivariate
    Taylor upper bound at real α) and prove the actual composition. -/
theorem T5_V7_TARGET_SIGNATURES_EQUIVALENCE_HEADLINE :
    -- (a) post-N3 → post-N2N3 (via V7-N2 unconditional)
    (T5_atom2_V7_capstone_target_signature_postN3 →
      T5_atom2_V7_capstone_target_signature_postN2N3) ∧
    -- (b) post-N2N3 → post-N3 (trivial)
    (T5_atom2_V7_capstone_target_signature_postN2N3 →
      T5_atom2_V7_capstone_target_signature_postN3) ∧
    -- (c) post-N2N3 → full target (via V7-N2 + V7-N3)
    (T5_atom2_V7_capstone_target_signature_postN2N3 →
      T5_atom2_V7_capstone_target_signature) :=
  ⟨T5_V7_target_postN3_implies_postN2N3,
   T5_V7_target_postN2N3_implies_postN3,
   T5_V7_target_postN2N3_implies_full⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7DraftPostN2N3
