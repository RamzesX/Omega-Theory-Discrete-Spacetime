/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV4

  T-5 (Roth's theorem) — **Phase 7 Wave-4 W4-A V4: OV2 paper-headline V4
  — m=2 Schmidt aux discharged**.

  Single-thread hand-authored 2026-04-29.

  ## Difference from V3

  V3 had Schmidt aux narrowed to m≥2 sub-NAMED.
  V4 incorporates `T5_SchmidtAuxIndex_m2_Discharge_unconditional`
  (closed in `T5_Phase7_SchmidtAuxIndex_m2_Discharge.lean` 2026-04-29)
  and so further narrows to JUST the m≥3 case.

  Net Wave-2/3 atoms required for full RothTheorem discharge:
  1. `T5_RothWronskianInductiveStep` — Wave-2 Phase 2.2 (D.6.4)
  2. `T5_RothLemmaIndexReductionDischarge` — Wave-2 Phase 2.3 (D.6.1)
  3. `T5_SchmidtAuxIndex_mGe3_Discharge` — Wave-2 Phase 2.4 m≥3
  4. `T5_RothBoundLargeFromMasterAndPigeonhole` — Wave-3 W3-D bridge

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV3
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV4

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV3
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## OV2 paper-headline V4 (3 Wave-2 atoms + 1 W3-D bridge) -/

/-- **`omega_theory_v2_T5_roth_paper_headline_V4`** — OV2 paper-grade Prop:

    Given the FOUR remaining NAMED atoms (Wronskian induction +
    index reduction + m≥3 Schmidt aux + W3-D bridge), `RothTheorem`
    holds for OmegaTheory V2.

    Pigeonhole (W3-A), m=1 Schmidt, m=2 Schmidt are all UNCONDITIONALLY
    discharged. -/
def omega_theory_v2_T5_roth_paper_headline_V4 : Prop :=
  T5_RothWronskianInductiveStep →
  T5_RothLemmaIndexReductionDischarge →
  T5_SchmidtAuxIndex_mGe3_Discharge →
  T5_RothBoundLargeFromMasterAndPigeonhole →
  RothTheorem

/-- **🚨 W4-A-V4-1 — discharge V4** — apply m=2 unconditional + V3
    paper headline. -/
theorem omega_theory_v2_T5_roth_paper_headline_V4_holds :
    omega_theory_v2_T5_roth_paper_headline_V4 := by
  intros h_step h_idxred h_mGe3 h_bridge
  -- Compose m=2 + m≥3 → m≥2 sub-NAMED
  have h_mGe2 : T5_SchmidtAuxIndex_mGe2_Discharge :=
    T5_SchmidtAuxIndex_mGe2_Discharge_via_decomposition
      T5_SchmidtAuxIndex_m2_Discharge_unconditional h_mGe3
  exact omega_theory_v2_T5_roth_paper_headline_V3_holds
    h_step h_idxred h_mGe2 h_bridge

/-! ## Headline -/

/-- **🚨 OV2 PAPER-HEADLINE V4 — Wave-4 W4-A V4: T-5 Roth final capstone V4**.

    🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-4 W4-A V4.

    Two derivations:
    1. `omega_theory_v2_T5_roth_paper_headline_V4` — 4-NAMED-atom Prop
       with Schmidt aux narrowed to JUST m≥3 sub-NAMED
    2. `omega_theory_v2_T5_roth_paper_headline_V4_holds` — discharge

    **Net achievement V4**: T-5 Roth's theorem closure now requires:
    - 2 Wave-2 NAMED atoms (Wronskian induction + index reduction)
    - 1 Wave-2 Phase 2.4 m≥3 sub-NAMED (m=1 + m=2 already discharged)
    - 1 Wave-3 W3-D bridge

    UNCONDITIONALLY discharged:
    - Wave-1 W1-A through W1-E (5 files)
    - Wave-2 Phase 2.0 (m=1 base) and Phase 2.1 (mvPolyWronskian setup)
    - Wave-2 Phase 2.4 m=1 + m=2 sub-NAMEDs
    - Wave-3 W3-A pigeonhole
    - Wave-3 W3-C RothBoundSmall closure

    Sub-lemma 297/N in T-5 Phase 7 (Wave-4 W4-A V4).  Lean-core only.
    NO STUBS. -/
theorem session_W4_A_V4_T5_roth_final_capstone_V4_headline :
    omega_theory_v2_T5_roth_paper_headline_V4 :=
  omega_theory_v2_T5_roth_paper_headline_V4_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV4
