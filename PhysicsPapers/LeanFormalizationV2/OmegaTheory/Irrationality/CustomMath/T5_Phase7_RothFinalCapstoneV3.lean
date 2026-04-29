/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV3

  T-5 (Roth's theorem) — **Phase 7 Wave-4 W4-A V3: OV2 paper-headline V3
  — m=1 Schmidt aux discharged**.

  Single-thread hand-authored 2026-04-29.

  ## Difference from V2

  V2 had the **4-NAMED-atom** conditional `RothTheorem` discharge.
  V3 incorporates `T5_SchmidtAuxIndex_m1_Discharge_unconditional`
  (closed in `T5_Phase7_SchmidtAuxIndex_m1.lean` 2026-04-29) and so
  reduces the Schmidt aux NAMED to JUST the m≥2 case
  `T5_SchmidtAuxIndex_mGe2_Discharge`.

  Net Wave-2/3 atoms required for full RothTheorem discharge:
  1. `T5_RothWronskianInductiveStep` — Wave-2 Phase 2.2 (D.6.4)
  2. `T5_RothLemmaIndexReductionDischarge` — Wave-2 Phase 2.3 (D.6.1)
  3. `T5_SchmidtAuxIndex_mGe2_Discharge` — Wave-2 Phase 2.4 m≥2
  4. `T5_RothBoundLargeFromMasterAndPigeonhole` — Wave-3 W3-D bridge

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV2
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV3

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## OV2 paper-headline V3 (m≥2 Schmidt sub-NAMED only) -/

/-- **`omega_theory_v2_T5_roth_paper_headline_V3`** — OV2 paper-grade Prop:

    Given the FOUR remaining NAMED hypotheses (3 Wave-2 atoms with
    Schmidt aux replaced by the m≥2 sub-atom + 1 Wave-3 W3-D bridge),
    `RothTheorem` holds for OmegaTheory V2.

    Pigeonhole (W3-A) AND m=1 Schmidt aux are UNCONDITIONALLY
    discharged and no longer conditions. -/
def omega_theory_v2_T5_roth_paper_headline_V3 : Prop :=
  T5_RothWronskianInductiveStep →
  T5_RothLemmaIndexReductionDischarge →
  T5_SchmidtAuxIndex_mGe2_Discharge →
  T5_RothBoundLargeFromMasterAndPigeonhole →
  RothTheorem

/-- **🚨 W4-A-V3-1 — discharge V3** — apply the unconditional m=1
    Schmidt + W3-A pigeonhole into the V2 grand. -/
theorem omega_theory_v2_T5_roth_paper_headline_V3_holds :
    omega_theory_v2_T5_roth_paper_headline_V3 := by
  intros h_step h_idxred h_mGe2 h_bridge
  -- Compose m=1 + m≥2 → full Schmidt aux index discharge
  have h_schmidt : T5_SchmidtAuxIndexAtAlphaDischarge :=
    T5_SchmidtAuxIndexDischarge_via_decomposition
      T5_SchmidtAuxIndex_m1_Discharge_unconditional h_mGe2
  -- Use V2 paper headline with the assembled Schmidt
  exact omega_theory_v2_T5_roth_paper_headline_V2_holds
    h_step h_idxred h_schmidt h_bridge

/-! ## Headline -/

/-- **🚨 OV2 PAPER-HEADLINE V3 — Wave-4 W4-A V3: T-5 Roth final capstone V3**.

    🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-4 W4-A V3.

    Two derivations:
    1. `omega_theory_v2_T5_roth_paper_headline_V3` — 4-NAMED-atom Prop
       with Schmidt aux narrowed to just m≥2 sub-NAMED
    2. `omega_theory_v2_T5_roth_paper_headline_V3_holds` — discharge

    **Net achievement V3**: T-5 Roth's theorem closure now requires
    only:
    - 2 Wave-2 NAMED atoms (Wronskian induction + index reduction)
    - 1 Wave-2 Phase 2.4 m≥2 sub-NAMED (m=1 already discharged)
    - 1 Wave-3 W3-D bridge

    Plus UNCONDITIONALLY discharged:
    - Wave-1 W1-A through W1-E (5 files)
    - Wave-2 Phase 2.0 (m=1 base) and Phase 2.1 (mvPolyWronskian setup)
    - Wave-3 W3-A pigeonhole
    - Wave-3 W3-C RothBoundSmall closure
    - Wave-2 Phase 2.4 m=1 (this commit)

    Sub-lemma 295/N in T-5 Phase 7 (Wave-4 W4-A V3).  Lean-core only.
    NO STUBS — all `Prop`s have real quantifier content. -/
theorem session_W4_A_V3_T5_roth_final_capstone_V3_headline :
    omega_theory_v2_T5_roth_paper_headline_V3 :=
  omega_theory_v2_T5_roth_paper_headline_V3_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV3
