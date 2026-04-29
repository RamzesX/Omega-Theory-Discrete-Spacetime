/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV5

  T-5 (Roth's theorem) — **Phase 7 Wave-4 W4-A V5: OV2 paper-headline V5
  — Schmidt aux index ENTIRELY discharged (m=1 + m=2 + m≥3 + full)**.

  Single-thread hand-authored 2026-04-29.

  ## Difference from V4

  V4 had Schmidt aux narrowed to m≥3 sub-NAMED.
  V5 incorporates `T5_SchmidtAuxIndex_mGe3_Discharge_unconditional`
  (closed in `T5_Phase7_SchmidtAuxIndex_mGe3_Closure.lean` 2026-04-29
  via factor preservation + all-ones witness — STRUCTURAL HEART CLOSURE).

  Net Wave-2/3 atoms required for full RothTheorem discharge — REDUCED
  from FOUR (V4) to THREE (V5):
  1. `T5_RothWronskianInductiveStep` — Wave-2 Phase 2.2 (D.6.4)
  2. `T5_RothLemmaIndexReductionDischarge` — Wave-2 Phase 2.3 (D.6.1)
  3. `T5_RothBoundLargeFromMasterAndPigeonhole` — Wave-3 W3-D bridge

  **Phase 2.4 (Schmidt aux index NAMED) IS NOW UNCONDITIONALLY CLOSED
  for ALL m ≥ 1.** Composition path:
  - factor preservation (general for all m, via `T5_pderiv_preserves_X_factor`)
  - all-ones non-zero (general for all m, via `T5_AllOnes_discharge`)
  - rothIndex bound (compositional via `T5_SchmidtAuxIndex_mGe3_via_general`)
  → m≥3 closure for ALL m ≥ 3
  + m=1 ✅ + m=2 ✅
  → full Schmidt aux index NAMED CLOSED

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV4
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV5

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV4
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## OV2 paper-headline V5 (THREE NAMED atoms only — Schmidt aux ENTIRELY UNCONDITIONAL) -/

/-- **`omega_theory_v2_T5_roth_paper_headline_V5`** — OV2 paper-grade Prop:

    Given the THREE remaining NAMED hypotheses (Wronskian induction +
    index reduction + W3-D bridge), `RothTheorem` holds for OmegaTheory V2.

    Pigeonhole (W3-A) + Schmidt aux index ALL m (m=1, m=2, m≥3, full)
    are UNCONDITIONALLY discharged and no longer conditions. -/
def omega_theory_v2_T5_roth_paper_headline_V5 : Prop :=
  T5_RothWronskianInductiveStep →
  T5_RothLemmaIndexReductionDischarge →
  T5_RothBoundLargeFromMasterAndPigeonhole →
  RothTheorem

/-- **🚨 W4-A-V5-1 — discharge V5** — apply the m≥3 unconditional
    discharge into the V4 grand to entirely eliminate the Schmidt aux
    sub-NAMED. -/
theorem omega_theory_v2_T5_roth_paper_headline_V5_holds :
    omega_theory_v2_T5_roth_paper_headline_V5 := by
  intros h_step h_idxred h_bridge
  -- m≥3 sub-NAMED is now UNCONDITIONALLY closed
  exact omega_theory_v2_T5_roth_paper_headline_V4_holds
    h_step h_idxred T5_SchmidtAuxIndex_mGe3_Discharge_unconditional h_bridge

/-! ## Headline -/

/-- **🚨🚨🚨 OV2 PAPER-HEADLINE V5 — Wave-4 W4-A V5: T-5 Roth final capstone V5**.

    🏆🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-4 W4-A V5.

    Two derivations:
    1. `omega_theory_v2_T5_roth_paper_headline_V5` — 3-NAMED-atom Prop
       with Schmidt aux ENTIRELY UNCONDITIONAL
    2. `omega_theory_v2_T5_roth_paper_headline_V5_holds` — discharge

    **Net achievement V5**: T-5 Roth's theorem closure now requires
    only THREE remaining NAMED atoms (down from FOUR in V4):
    - 2 Wave-2 NAMED atoms (Wronskian induction + index reduction)
    - 1 Wave-3 W3-D bridge

    Plus UNCONDITIONALLY discharged:
    - Wave-1 W1-A through W1-E (5 files)
    - Wave-2 Phase 2.0 (m=1 base) and Phase 2.1 (mvPolyWronskian setup)
    - Wave-2 Phase 2.4 ALL m (m=1 + m=2 + m≥3 + full Schmidt aux index)
      🆕 closed via factor preservation + all-ones structural witness
    - Wave-3 W3-A pigeonhole
    - Wave-3 W3-C RothBoundSmall closure

    Sub-lemma 303/N in T-5 Phase 7 (Wave-4 W4-A V5).  Lean-core only.
    NO STUBS — all `Prop`s have real quantifier content. -/
theorem session_W4_A_V5_T5_roth_final_capstone_V5_headline :
    omega_theory_v2_T5_roth_paper_headline_V5 :=
  omega_theory_v2_T5_roth_paper_headline_V5_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV5
