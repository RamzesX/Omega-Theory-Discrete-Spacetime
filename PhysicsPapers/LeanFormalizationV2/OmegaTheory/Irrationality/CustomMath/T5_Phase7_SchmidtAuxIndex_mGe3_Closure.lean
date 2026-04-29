/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure

  T-5 (Roth's theorem) — **m=3 + m≥4 FULL UNCONDITIONAL CLOSURE**.

  Combines:
  - T5_SchmidtAuxIndex_factor_preserved_unconditional (factor preservation)
  - T5_SchmidtAuxIndex_AllOnesNonZero_unconditional (all-ones non-zero)

  Into the m=3 + m≥4 sub-NAMED discharges.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_AllOnes
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_FactorPreserved
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_AllOnes
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

/-! ## m≥3 sub-NAMED FULL UNCONDITIONAL DISCHARGE -/

/-- **🏆 m≥3 FULLY DISCHARGED** via factor preservation + all-ones witness. -/
theorem T5_SchmidtAuxIndex_mGe3_Discharge_unconditional :
    T5_SchmidtAuxIndex_mGe3_Discharge :=
  T5_SchmidtAuxIndex_mGe3_via_general
    T5_SchmidtAuxIndex_factor_preserved_unconditional
    T5_SchmidtAuxIndex_AllOnesNonZero_unconditional

/-! ## m=3 sub-NAMED also closed (subcase of m≥3) -/

theorem T5_SchmidtAuxIndex_m3_Discharge_unconditional :
    T5_SchmidtAuxIndex_m3_Discharge := by
  intros α hα h_alg ε hε
  exact T5_SchmidtAuxIndex_mGe3_Discharge_unconditional α hα h_alg ε hε 3 (le_refl 3)

/-! ## m≥4 sub-NAMED also closed (subcase of m≥3) -/

theorem T5_SchmidtAuxIndex_mGe4_Discharge_unconditional :
    T5_SchmidtAuxIndex_mGe4_Discharge := by
  intros α hα h_alg ε hε m hm
  exact T5_SchmidtAuxIndex_mGe3_Discharge_unconditional α hα h_alg ε hε m (by omega)

/-! ## Full Schmidt aux index NAMED discharge -/

theorem T5_SchmidtAuxIndexAtAlphaDischarge_unconditional :
    T5_SchmidtAuxIndexAtAlphaDischarge :=
  T5_SchmidtAuxIndex_full_via_finer_decomposition
    T5_SchmidtAuxIndex_m2_Discharge_unconditional
    T5_SchmidtAuxIndex_mGe3_Discharge_unconditional

/-! ## Headline -/

/-- **🚨🚨🚨 GRAND HEADLINE — m=3 + m≥4 + FULL Schmidt aux UNCONDITIONALLY CLOSED**.

    🏆🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 FULL CLOSURE.

    Three NAMED hypotheses fully discharged:
    1. T5_SchmidtAuxIndex_m3_Discharge — m=3 ✅
    2. T5_SchmidtAuxIndex_mGe4_Discharge — m≥4 ✅
    3. T5_SchmidtAuxIndexAtAlphaDischarge — original Wave-2 Phase 2.4 ✅

    Composition path:
    - factor preservation (general for all m) +
    - all-ones non-zero (general for all m) +
    - rothIndex bound (compositional)
    → m≥3 closure for ALL m ≥ 3
    + m=1 ✅ + m=2 ✅
    → full Schmidt aux index NAMED CLOSED

    NEW Schmidt status: ALL m cases UNCONDITIONALLY CLOSED.
    Combined with W3-A pigeonhole UNCONDITIONALLY CLOSED earlier,
    only TWO Wave-2 NAMED + W3-D bridge remain for full T-5 RothTheorem.

    Sub-lemma 302/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_4_FULL_CLOSURE_headline :
    T5_SchmidtAuxIndexAtAlphaDischarge :=
  T5_SchmidtAuxIndexAtAlphaDischarge_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_mGe3_Closure
