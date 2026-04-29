/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV2

  T-5 (Roth's theorem) — **Phase 7 Wave-4 W4-A V2: OV2 paper-headline
  capstone V2 — pigeonhole discharged**.

  Single-thread hand-authored 2026-04-29 (Wave-4 W4-A V2).

  ## Difference from V1 (`T5_Phase7_RothFinalCapstone.lean`)

  V1 had the **5-NAMED-atom** conditional `RothTheorem` discharge.
  V2 incorporates `T5_PigeonholeMTupleDischarge_unconditional` (closed
  in `T5_Phase7_PigeonholeMTupleDischarge.lean` 2026-04-29) and so
  reduces to a **4-NAMED-atom** conditional discharge.

  Four NAMED hypotheses remain:
  1. `T5_RothWronskianInductiveStep` — Wave-2 Phase 2.2 (D.6.4 induction)
  2. `T5_RothLemmaIndexReductionDischarge` — Wave-2 Phase 2.3 (D.6.1)
  3. `T5_SchmidtAuxIndexAtAlphaDischarge` — Wave-2 Phase 2.4 (D.5)
  4. `T5_RothBoundLargeFromMasterAndPigeonhole` — Wave-3 W3-D bridge

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## graph_queries_run

  - `lean_local_search("T5_PigeonholeMTupleDischarge_unconditional")`
    → newly discharged in T5_Phase7_PigeonholeMTupleDischarge.lean.
    Used: yes (the W4-A V2 simplification).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTupleDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallClosure

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV2

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTupleDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## OV2 paper-headline V2 (4-NAMED conditional) -/

/-- **`omega_theory_v2_T5_roth_paper_headline_V2`** — OV2 paper-grade Prop:

    Given the FOUR NAMED hypotheses (3 Wave-2 + 1 W3-D bridge),
    `RothTheorem` holds for OmegaTheory V2.

    The pigeonhole NAMED (W3-A) has been UNCONDITIONALLY discharged
    via `T5_PigeonholeMTupleDischarge_unconditional` and is no longer
    a condition. -/
def omega_theory_v2_T5_roth_paper_headline_V2 : Prop :=
  T5_RothWronskianInductiveStep →
  T5_RothLemmaIndexReductionDischarge →
  T5_SchmidtAuxIndexAtAlphaDischarge →
  T5_RothBoundLargeFromMasterAndPigeonhole →
  RothTheorem

/-- **🚨 W4-A-V2-1 — discharge V2** — apply the unconditional W3-A
    pigeonhole into the 5-NAMED grand. -/
theorem omega_theory_v2_T5_roth_paper_headline_V2_holds :
    omega_theory_v2_T5_roth_paper_headline_V2 := by
  intros h_step h_idxred h_auxidx h_bridge
  exact omega_theory_v2_T5_roth_paper_headline_holds
    h_step h_idxred h_auxidx
    T5_PigeonholeMTupleDischarge_unconditional h_bridge

/-! ## Full chain audit V2 -/

/-- **`omega_theory_v2_T5_roth_full_chain_audit_V2`** — 4-conjunct
    paper-grade Prop documenting the full Wave-1 → Wave-4 V2 chain. -/
def omega_theory_v2_T5_roth_full_chain_audit_V2 : Prop :=
  -- (a) 4-NAMED-atom conditional headline
  omega_theory_v2_T5_roth_paper_headline_V2 ∧
  -- (b) Pigeonhole UNCONDITIONALLY discharged (W3-A closed)
  T5_PigeonholeMTupleDischarge ∧
  -- (c) RothBoundSmall unconditional (W1-E)
  RothBoundSmall ∧
  -- (d) Yoneda bridge to existing ext #40 holds
  T5_roth_conditional_yoneda_bridge

/-- **🚨 W4-A-V2-2 — discharge of full chain V2**. -/
theorem omega_theory_v2_T5_roth_full_chain_audit_V2_holds :
    omega_theory_v2_T5_roth_full_chain_audit_V2 :=
  ⟨omega_theory_v2_T5_roth_paper_headline_V2_holds,
   T5_PigeonholeMTupleDischarge_unconditional,
   T5_RothBoundSmall_unconditional_closure_alias,
   T5_roth_conditional_yoneda_bridge_holds⟩

/-! ## Headline -/

/-- **🚨 OV2 PAPER-HEADLINE V2 — Wave-4 W4-A V2: T-5 Roth final capstone V2**.

    🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-4 W4-A V2.

    Three derivations + 4-conjunct chain audit:
    1. `omega_theory_v2_T5_roth_paper_headline_V2` — 4-NAMED-atom Prop
    2. `omega_theory_v2_T5_roth_full_chain_audit_V2` — 4-conjunct chain

    **Net achievement V2**: T-5 Roth's theorem reduced from FIVE NAMED
    hypotheses (V1) to FOUR NAMED hypotheses (V2) by UNCONDITIONALLY
    discharging the W3-A pigeonhole.

    **Wave-2 + Wave-3 W3-D + W3-A SCAFFOLD COMPLETE + W3-A DISCHARGED**.
    Three Wave-2 NAMED + one W3-D bridge NAMED follow.

    Sub-lemma 292/N in T-5 Phase 7 (Wave-4 W4-A V2).  Lean-core only.
    NO STUBS — all `Prop`s have real quantifier content.

    Per §7.0 NO STUBS rule + §8a single-thread paper-grade discipline. -/
theorem session_W4_A_V2_T5_roth_final_capstone_V2_headline :
    omega_theory_v2_T5_roth_full_chain_audit_V2 :=
  omega_theory_v2_T5_roth_full_chain_audit_V2_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV2
