/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_MasterBundle

  T-5 (Roth's theorem) — **V6 MASTER BUNDLE**: comprehensive paper-citable
  bundle of UNCONDITIONAL discharges + V3-V6 capstone progression.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Six-conjunct paper-grade bundle exposing the V6 status:
  1. V3 capstone (4 NAMED) — historic
  2. V4 capstone (4 NAMED with sub-narrowing) — historic
  3. V5 capstone (3 NAMED — Schmidt aux UNCONDITIONAL) — V5 closure
  4. **V6 capstone (2 NAMED — Wronskian step UNCONDITIONAL)** — current
  5. Matrix det lemma UNCONDITIONAL (rank-1 charpoly)
  6. mvPolyWronskian identity-witness ↔ matrix det BRIDGE

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_PaperBundle
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IdentityWitnessBridge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothWronskianInductiveStep_Discharge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_MasterBundle

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV3
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV4
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV5
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_PaperBundle
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IdentityWitnessBridge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothWronskianInductiveStep_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish_Discharge

/-! ## V6 master 6-conjunct paper bundle -/

/-- **🚨 V6 MASTER PAPER BUNDLE (6-conjunct)** —
    All four capstone Props (V3 → V4 → V5 → V6) + matrix det UNCONDITIONAL +
    mvPolyWronskian identity-witness BRIDGE. -/
def T5_V6_master_paper_bundle : Prop :=
  -- (a) V3 capstone (historic, 4 NAMED)
  omega_theory_v2_T5_roth_paper_headline_V3 ∧
  -- (b) V4 capstone (historic, 4 NAMED with sub-narrowing)
  omega_theory_v2_T5_roth_paper_headline_V4 ∧
  -- (c) V5 capstone (Schmidt aux ENTIRELY UNCONDITIONAL, 3 NAMED)
  omega_theory_v2_T5_roth_paper_headline_V5 ∧
  -- (d) V6 capstone (Wronskian step ENTIRELY UNCONDITIONAL, 2 NAMED)
  omega_theory_v2_T5_roth_paper_headline_V6 ∧
  -- (e) Matrix det lemma UNCONDITIONAL formula
  (∀ {m : ℕ}, 1 ≤ m → ∀ (P : MvPolynomial (Fin m) ℝ),
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^(m-1) * (P + ∑ i : Fin m, X i * pderiv i P)) ∧
  -- (f) mvPolyWronskian identity-witness ↔ matrix det BRIDGE
  (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ),
    mvPolyWronskian m P (identityWitnessJ m) =
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det)

theorem T5_V6_master_paper_bundle_holds :
    T5_V6_master_paper_bundle :=
  ⟨omega_theory_v2_T5_roth_paper_headline_V3_holds,
   omega_theory_v2_T5_roth_paper_headline_V4_holds,
   omega_theory_v2_T5_roth_paper_headline_V5_holds,
   omega_theory_v2_T5_roth_paper_headline_V6_holds,
   fun hm P => T5_matDetLemma_general hm P,
   fun {_} P => T5_mvPolyWronskian_identityWitness_eq_matDet P⟩

/-! ## Headline -/

/-- **🚨🚨🚨🚨🚨🚨 OV2 V6 MASTER PAPER HEADLINE — 6-conjunct paper-grade bundle**.

    🏆🏆🏆🏆🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-4 W4-A V6 MASTER.

    Single Prop bundling SIX paper-citable conjuncts:
    1. V3 capstone progression
    2. V4 capstone progression
    3. V5 capstone (Schmidt aux UNCONDITIONAL)
    4. V6 capstone (Wronskian step UNCONDITIONAL — 2 NAMED remain)
    5. Matrix det lemma UNCONDITIONAL via rank-1 charpoly
    6. mvPolyWronskian ↔ matrix det BRIDGE

    All conjuncts Lean-core only [propext, Classical.choice, Quot.sound].

    **Strategic significance**: this is the SINGLE-CITATION paper anchor
    for the V6 closure showing the multi-day NAMED-atom reduction
    (4 → 3 → 2) across V3-V6 capstone sequence.

    Sub-lemma 328/N in T-5 Phase 7. NO STUBS. -/
theorem session_W4_A_V6_T5_master_paper_bundle_headline :
    T5_V6_master_paper_bundle :=
  T5_V6_master_paper_bundle_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV6_MasterBundle
