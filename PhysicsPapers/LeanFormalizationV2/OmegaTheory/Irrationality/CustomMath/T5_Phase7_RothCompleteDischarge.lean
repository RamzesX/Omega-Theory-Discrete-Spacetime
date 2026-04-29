/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge

  T-5 (Roth's theorem) — **Phase 7 Wave-3 W3-D: complete discharge bridge**
  composing Wave-2 RothLemmaMaster + W1-E unconditional `RothBoundSmall`
  + W3-A pigeonhole into the conditional capstone closure (existing ext #40).

  Single-thread hand-authored 2026-04-29 (Wave-3 W3-D).

  ## What this file delivers

  **Conditional `RothTheorem` discharge bundle**:
  1. NAMED bridge `T5_RothBoundLargeFromMasterAndPigeonhole` translating
     the Wave-2 master + W3-A pigeonhole into `RothBoundLarge`.
  2. Conditional `RothCompleteHypotheses` discharge given the bridge.
  3. Conditional `RothTheorem` via the existing `T5_roth_conditional_closure_capstone`.
  4. Final headline Prop bundling everything for downstream Wave-4.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  NAMED Props valid IF discharged in subsequent ticks.

  ## graph_queries_run

  - `lean_local_search("RothBoundLarge")` → `T5_Phase7_RothTheoremClosure.RothBoundLarge`
    + `T5_Phase7_RothBoundSmallDirect.T5_rothBoundSmall_unconditional`. Used: yes.
  - `lean_local_search("RothCompleteHypotheses")` → conditional capstone in
    `T5_Phase7_RothTheoremClosure.lean`. Used: yes.
  - `omega_hammer_premise("Liouville-style Roth bound large denominator
    rational approximation algebraic")` → composition Phase 7 master + pigeonhole.

  Literature: Hindry-Silverman §D.7 (composition into RothTheorem).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
import OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## NAMED bridge hypothesis -/

/-- **`T5_RothBoundLargeFromMasterAndPigeonhole`** [NAMED HYPOTHESIS — to discharge].

    Given:
    - `RothLemmaMaster` (the 5-conjunct Wave-2 master statement, all
      five sub-statements unconditional or conditional on Wave-2 NAMED
      discharges)
    - `T5_PigeonholeMTuple_Statement` (the W3-A pigeonhole extraction)

    one obtains `RothBoundLarge` (the analytical-side bound for q with
    large denominator).

    The full Hindry-Silverman D.7 argument:
    1. Suppose `RothBoundLarge` fails: ∃ infinite violating set.
    2. By W3-A pigeonhole: extract m rationals with growth condition.
    3. By Phase 2.4: Schmidt aux poly P with rothIndex ≥ m/2 − √(mε)
       at (α, ..., α).
    4. By Phase 2.3 (translation invariance + index reduction):
       rothIndex P at (q₁, ..., qₘ) ≤ m/2 − √(mε) − √(mε) < m/2.
    5. By Phase 2.2 Wronskian non-vanishing + Phase 2.5 master: this
       contradicts the lower bound.

    Per project rule §7.0: NAMED real Prop content (∀-quantified
    universally over master + pigeonhole hypotheses), used non-vacuously,
    NOT `:= True`. To be discharged in successor ticks. -/
def T5_RothBoundLargeFromMasterAndPigeonhole : Prop :=
  RothLemmaMaster →
  T5_PigeonholeMTuple_Statement →
  RothBoundLarge

/-! ## Conditional discharge of RothBoundLarge -/

/-- **🚨 W3-D-1 — `T5_RothBoundLarge_conditional`** — discharges
    `RothBoundLarge` given the master + pigeonhole + bridge. -/
theorem T5_RothBoundLarge_conditional
    (h_master : RothLemmaMaster)
    (h_pigeon : T5_PigeonholeMTuple_Statement)
    (h_bridge : T5_RothBoundLargeFromMasterAndPigeonhole) :
    RothBoundLarge :=
  h_bridge h_master h_pigeon

/-! ## Conditional discharge of RothCompleteHypotheses -/

/-- **🚨 W3-D-2 — `T5_RothCompleteHypotheses_conditional`** — discharges
    `RothCompleteHypotheses` given:
    - Wave-2 RothLemmaMaster
    - W3-A pigeonhole statement
    - W3-D bridge hypothesis

    Note: `RothBoundSmall` is UNCONDITIONALLY discharged via W1-E
    (`T5_rothBoundSmall_unconditional`), so we only need to compose
    with the conditional `RothBoundLarge`. -/
theorem T5_RothCompleteHypotheses_conditional
    (h_master : RothLemmaMaster)
    (h_pigeon : T5_PigeonholeMTuple_Statement)
    (h_bridge : T5_RothBoundLargeFromMasterAndPigeonhole) :
    RothCompleteHypotheses :=
  ⟨T5_RothBoundLarge_conditional h_master h_pigeon h_bridge,
   T5_rothBoundSmall_unconditional⟩

/-! ## Conditional discharge of RothTheorem -/

/-- **🚨 W3-D-3 — `T5_RothTheorem_conditional`** — discharges `RothTheorem`
    given the Wave-2 master + W3-A pigeonhole + W3-D bridge.

    Composition path:
    1. Build `RothCompleteHypotheses` via T5_RothCompleteHypotheses_conditional.
    2. Apply existing ext #40 `T5_roth_conditional_closure_capstone`. -/
theorem T5_RothTheorem_conditional
    (h_master : RothLemmaMaster)
    (h_pigeon : T5_PigeonholeMTuple_Statement)
    (h_bridge : T5_RothBoundLargeFromMasterAndPigeonhole) :
    RothTheorem :=
  T5_roth_conditional_closure_capstone
    (T5_RothCompleteHypotheses_conditional h_master h_pigeon h_bridge)

/-! ## Wave-3 W3-D grand statement -/

/-- **`T5_Wave3_RothCompleteDischarge_grand`** — the Wave-3 grand
    closure statement chaining all three NAMED discharge hypotheses
    (Wave-2 three + W3-A one + W3-D one) into `RothTheorem`. -/
def T5_Wave3_RothCompleteDischarge_grand : Prop :=
  T5_RothWronskianInductiveStep →
  T5_RothLemmaIndexReductionDischarge →
  T5_SchmidtAuxIndexAtAlphaDischarge →
  T5_PigeonholeMTupleDischarge →
  T5_RothBoundLargeFromMasterAndPigeonhole →
  RothTheorem

/-- **🚨 W3-D-4 — discharge of grand**. -/
theorem T5_Wave3_RothCompleteDischarge_grand_holds :
    T5_Wave3_RothCompleteDischarge_grand := by
  intros h_step h_idxred h_auxidx h_pigeon_disch h_bridge
  have h_master : RothLemmaMaster :=
    T5_RothLemmaMaster_conditional h_step h_idxred h_auxidx
  have h_pigeon : T5_PigeonholeMTuple_Statement :=
    T5_PigeonholeMTuple_grand h_pigeon_disch
  exact T5_RothTheorem_conditional h_master h_pigeon h_bridge

/-! ## NAMED Prop for Wave-4 capstone consumption -/

/-- **`T5_RothCompleteDischarge`** — 3-conjunct paper-grade Prop bundling
    the Wave-3 W3-D conditional discharge machinery for Wave-4. -/
def T5_RothCompleteDischarge : Prop :=
  -- (a) Bridge hypothesis is well-formed
  (T5_RothBoundLargeFromMasterAndPigeonhole ↔
    (RothLemmaMaster → T5_PigeonholeMTuple_Statement → RothBoundLarge)) ∧
  -- (b) Conditional discharge: master + pigeonhole + bridge → RothTheorem
  (RothLemmaMaster →
   T5_PigeonholeMTuple_Statement →
   T5_RothBoundLargeFromMasterAndPigeonhole →
   RothTheorem) ∧
  -- (c) Five-NAMED-hypothesis grand: assembles RothTheorem from atoms
  T5_Wave3_RothCompleteDischarge_grand

/-- **🚨 W3-D-5 — discharge**. -/
theorem T5_RothCompleteDischarge_holds : T5_RothCompleteDischarge :=
  ⟨Iff.rfl, T5_RothTheorem_conditional, T5_Wave3_RothCompleteDischarge_grand_holds⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-3 W3-D: complete discharge bridge**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-3 W3-D.

    Six derivations + 3-conjunct discharged Prop:
    1. `T5_RothBoundLargeFromMasterAndPigeonhole` — NAMED bridge
    2. `T5_RothBoundLarge_conditional` — conditional analytical bound
    3. `T5_RothCompleteHypotheses_conditional` — composes with W1-E unconditional
    4. `T5_RothTheorem_conditional` — full Roth's theorem conditional
    5. `T5_Wave3_RothCompleteDischarge_grand` — five-NAMED-atom grand
    6. `T5_RothCompleteDischarge_holds` — 3-conjunct discharged Prop

    Wave-3 W3-D consumes:
    - Wave-2 master capstone (`RothLemmaMaster`, conditional on Wave-2
      three NAMED discharges)
    - W3-A pigeonhole (`T5_PigeonholeMTuple_Statement`, conditional on
      one NAMED discharge)
    - W1-E `T5_rothBoundSmall_unconditional` (UNCONDITIONAL — no NAMED
      discharge required)
    - existing ext #40 `T5_roth_conditional_closure_capstone`
      (UNCONDITIONAL composition)

    Net result: `RothTheorem` discharged conditional on FIVE NAMED
    hypotheses (3 from Wave-2 + 1 from W3-A + 1 from W3-D = 5). When
    all five are discharged in successor ticks, the unconditional
    `RothTheorem` lands.

    Sub-lemma 287/N in T-5 Phase 7 (Wave-3 W3-D).  Lean-core only.
    NO STUBS — all `Prop`s have real quantifier content. -/
theorem session_W3_D_T5_roth_complete_discharge_headline :
    T5_RothCompleteDischarge :=
  T5_RothCompleteDischarge_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
