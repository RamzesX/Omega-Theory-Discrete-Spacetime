/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.5: Roth's lemma
  MASTER CAPSTONE** — composes Phases 2.0-2.4 into the unconditional
  (modulo three NAMED discharges) Roth's-lemma grand statement.

  Single-thread hand-authored 2026-04-29 (Wave-2 phase 2.5 of 6 — FINAL).

  ## What this file delivers

  **Roth's-lemma master Prop** packaging:
  1. The full Hindry-Silverman D.6 statement (multivariate index
     reduction principle).
  2. Conditional discharge given the three NAMED hypotheses from
     Phases 2.2, 2.3, 2.4.
  3. Pathway from Roth-violation hypothesis to a contradiction via
     the index lower bound + index upper bound + integer non-vanishing
     pigeonhole.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  the three NAMED hypotheses (`T5_RothWronskianInductiveStep`,
  `T5_RothLemmaIndexReductionDischarge`,
  `T5_SchmidtAuxIndexAtAlphaDischarge`) are intermediate steps to
  discharge — not terminal endpoints. Discharge happens in successor
  ticks under the loop heartbeat.

  ## graph_queries_run

  - Phase 2.0/2.1/2.2/2.3/2.4 import audit — confirmed GREEN composition
    chain via `T5_Phase7_RothLemma_*.lean` files.
  - `local_search("RothCompleteHypotheses")` → ext #40
    `T5_Phase7_RothTheoremClosure.lean` (Wave-3 entry point). Used: yes.

  Literature: Hindry-Silverman D.6 grand statement.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
  All `Prop`s have real quantifier content; all NAMED hypotheses are
  ∀-quantified, used non-vacuously, NOT `:= True`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

/-! ## Roth's lemma master statement -/

/-- **`RothLemmaMaster`** — the grand Roth's-lemma statement
    (Hindry-Silverman D.6 grand). Bundles:
    - m=1 base case ✓ (Phase 2.0, unconditional)
    - mvPolyWronskian setup ✓ (Phase 2.1, unconditional)
    - Wronskian non-vanish (Phase 2.2, conditional on inductive step)
    - Index reduction inequality (Phase 2.3, conditional on discharge)
    - Aux poly index lower bound (Phase 2.4, conditional on discharge) -/
def RothLemmaMaster : Prop :=
  -- m=1 base (UNCONDITIONAL)
  T5_RothLemma_M1_Base ∧
  -- mvPolyWronskian setup (UNCONDITIONAL)
  T5_RothLemma_InductiveSetup ∧
  -- Wronskian non-vanish (conditional)
  T5_RothLemma_WronskianNonVanish_Statement ∧
  -- Index reduction (conditional)
  T5_RothLemmaIndexReduction_Statement ∧
  -- Aux poly index lower bound (conditional)
  T5_SchmidtAuxIndexAtAlpha_Statement

/-! ## Conditional discharge — composes the three NAMED hypotheses -/

/-- **🚨 W2.5-1 — `T5_RothLemmaMaster_conditional`** — discharges
    `RothLemmaMaster` given the three NAMED hypotheses from Phases
    2.2, 2.3, 2.4. The Wave-2 final composition. -/
theorem T5_RothLemmaMaster_conditional
    (h_step : T5_RothWronskianInductiveStep)
    (h_idxred : T5_RothLemmaIndexReductionDischarge)
    (h_auxidx : T5_SchmidtAuxIndexAtAlphaDischarge) :
    RothLemmaMaster :=
  ⟨T5_RothLemma_M1_Base_holds,
   T5_RothLemma_InductiveSetup_holds,
   T5_RothWronskian_conditional_grand h_step,
   T5_RothLemmaIndexReduction_grand h_idxred,
   T5_SchmidtAuxIndexAtAlpha_grand h_auxidx⟩

/-! ## Wave-2 GRAND headline -/

/-- **`T5_Wave2_RothLemmaMaster_grand`** — Wave-2 grand Prop. -/
def T5_Wave2_RothLemmaMaster_grand : Prop :=
  T5_RothWronskianInductiveStep →
  T5_RothLemmaIndexReductionDischarge →
  T5_SchmidtAuxIndexAtAlphaDischarge →
  RothLemmaMaster

/-- **🚨 W2.5-2 — discharge**. -/
theorem T5_Wave2_RothLemmaMaster_grand_holds :
    T5_Wave2_RothLemmaMaster_grand :=
  fun h1 h2 h3 => T5_RothLemmaMaster_conditional h1 h2 h3

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.5: Roth's lemma MASTER CAPSTONE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.5 (FINAL).

    Wave-2 6/6 phases scaffolded (single-thread paper-grade, ~1.5 hours
    real-time elapsed for the scaffolding skeleton):
    - Phase 2.0 ✓ m=1 base case (commit 0878465)
    - Phase 2.1 ✓ mvPolyWronskian setup (commit 890673b)
    - Phase 2.2 ✓ Wronskian non-vanish STATEMENT + base + IND NAMED (commit 8c13d1c)
    - Phase 2.3 ✓ index reduction inequality STATEMENT + NAMED (commit 224fc35)
    - Phase 2.4 ✓ Schmidt aux index lower bound STATEMENT + NAMED
    - Phase 2.5 ✓ MASTER CAPSTONE composes all five (this file)

    **Three NAMED discharges remain** (multi-day, successor ticks):
    1. `T5_RothWronskianInductiveStep` — Hindry-Silverman D.6.4 induction
    2. `T5_RothLemmaIndexReductionDischarge` — D.6.1 inequality
    3. `T5_SchmidtAuxIndexAtAlphaDischarge` — D.5 aux poly index

    The Wave-2 SCAFFOLD direction is COMPLETE; analytical discharges
    follow.

    Sub-lemma 285/N in T-5 Phase 7 (Wave-2 Phase 2.5 — FINAL).
    Lean-core only. NO STUBS — all NAMED hypotheses are quantified
    Props with real content.

    Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28
    + anti-pattern lock 2026-04-29: NAMED hypotheses are intermediate
    steps to discharge — not terminal. Wave-2 SCAFFOLD complete;
    discharges queued for successor ticks. -/
theorem session_W2_phase_2_5_T5_roth_lemma_master_capstone_headline :
    T5_Wave2_RothLemmaMaster_grand :=
  T5_Wave2_RothLemmaMaster_grand_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
