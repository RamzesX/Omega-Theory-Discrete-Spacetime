/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_PaperMasterBridge

  T-5 (Roth's theorem) — **V6 → T_5_GRAND_PAPER_MASTER_V3 PAPER BRIDGE**.

  Single-thread hand-authored 2026-04-29.

  ## What this delivers

  Combines V6 capstone (2-NAMED conditional) with the existing
  UNCONDITIONAL `T_5_GRAND_PAPER_MASTER_V3` (Bundle XVII) for IsAlgebraicOfDegree α n
  with ε > n-2. V6 is conditional but covers ALL ε > 0; V3 is unconditional
  but range-restricted.

  This is the V6 analog of `T5_Phase7_RothFinalCapstoneV5_YonedaBridge`,
  with the Wronskian inductive step now UNCONDITIONALLY discharged.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_PaperMasterBridge

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge

/-! ## V6 ↔ T_5_GRAND_PAPER_MASTER_V3 COEXISTENCE bundle -/

/-- **`T5_V6_V3_paper_master_coexistence_bundle`** — 2-conjunct coexistence:
    1. V6 conditional capstone (2 NAMED → general RothTheorem)
    2. V3 GRAND PAPER MASTER (UNCONDITIONAL for IsAlgebraicOfDegree α n,
       ε > n - 2)

    V6 narrower than V5 (Wronskian step UNCONDITIONALLY discharged), but
    still requires 2 NAMED for general ε > 0. V3 paper master complements
    by providing UNCONDITIONAL bound for ε > n-2.

    Together: complete paper-grade Diophantine bound coverage. -/
def T5_V6_V3_paper_master_coexistence_bundle : Prop :=
  -- (a) V6 capstone holds (conditional on 2 NAMED atoms)
  omega_theory_v2_T5_roth_paper_headline_V6 ∧
  -- (b) V3 GRAND PAPER MASTER UNCONDITIONAL for ε > n-2
  (∀ (α : ℝ), Irrational α → ∀ (n : ℕ), 1 ≤ n → IsAlgebraicOfDegree α n →
   ∀ (ε : ℝ), ((n : ℝ) - 2) < ε → 0 < ε →
   IsAlgebraic ℤ α ∧
   (∃ (C : ℝ) (p : Polynomial ℤ),
     0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
     ∀ (q : ℚ),
       Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
       C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|))

/-- **🚨 V6 ↔ V3 coexistence discharge**. -/
theorem T5_V6_V3_paper_master_coexistence_bundle_holds :
    T5_V6_V3_paper_master_coexistence_bundle :=
  ⟨omega_theory_v2_T5_roth_paper_headline_V6_holds,
   fun α hα n hn h_alg ε hε hε_pos =>
     T_5_GRAND_PAPER_MASTER_V3 α hα n hn h_alg ε hε hε_pos⟩

/-! ## V6 implies V3 paper-master coverage (when V6 NAMED hold) -/

/-- **`T5_V6_implies_V3_paper_master_when_named_holds`** —
    under V6's 2 NAMED atoms, RothTheorem holds for all ε > 0,
    which subsumes V3's ε > n-2 bound. Plus V3 is unconditional. -/
theorem T5_V6_implies_V3_paper_master_when_named_holds
    (h_idxred : T5_RothLemmaIndexReductionDischarge)
    (h_bridge : T5_RothBoundLargeFromMasterAndPigeonhole) :
    RothTheorem ∧
    (∀ (α : ℝ), Irrational α → ∀ (n : ℕ), 1 ≤ n → IsAlgebraicOfDegree α n →
     IsAlgebraic ℤ α) :=
  ⟨omega_theory_v2_T5_roth_paper_headline_V6_holds h_idxred h_bridge,
   fun α _hα n _hn h_alg =>
     T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg⟩

/-! ## Headline -/

/-- **🚨🚨🚨🚨🚨🚨🚨 V6 ↔ V3 COEXISTENCE BRIDGE — Wave-4 W4-A V6 PAPER MASTER**.

    🏆🏆🏆🏆🏆🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5).

    Combined paper headline:
    - V6 capstone (2 NAMED → general RothTheorem; Wronskian step UNCONDITIONAL)
    - V3 GRAND PAPER MASTER (UNCONDITIONAL Liouville-style for ε > n-2)

    Net coverage: T-5 has UNCONDITIONAL paper bound for ε > n-2 (V3),
    PLUS conditional bound for ALL ε > 0 (V6 with 2 remaining NAMED).

    Sub-lemma 332/N in T-5 Phase 7. NO STUBS. Lean-core only. -/
theorem session_W4_A_V6_T5_paper_master_coexistence_bridge_headline :
    T5_V6_V3_paper_master_coexistence_bundle :=
  T5_V6_V3_paper_master_coexistence_bundle_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_PaperMasterBridge
