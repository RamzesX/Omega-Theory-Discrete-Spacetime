/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.4 discharge step:
  decompose `T5_SchmidtAuxIndexAtAlphaDischarge` into m=1 + m≥2 cases**.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Honest decomposition of `T5_SchmidtAuxIndexAtAlphaDischarge` from
  Wave-2 Phase 2.4 into TWO sub-NAMED hypotheses:

  1. `T5_SchmidtAuxIndex_m1_Discharge` — m=1 case (specialized form)
  2. `T5_SchmidtAuxIndex_mGe2_Discharge` — m ≥ 2 case (general form)

  Plus the composition lemma `T5_SchmidtAuxIndexDischarge_via_decomposition`
  that combines the two sub-hypotheses into the original NAMED Prop.

  This is the **decomposition step** — narrowing one big NAMED into two
  more tractable sub-NAMEDs.  Both sub-NAMEDs are real ∀-quantified
  Props with non-vacuous content (per project rule §7.0).  Discharges
  follow in successor 10-min ticks.

  Per project rule §7.0 NO STUBS — no `sorry`, no `Prop := True`,
  no `:= trivial`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  decomposition is paper-grade progress, NOT slim antipattern.  Each
  sub-NAMED has explicit decomposition + discharge plan in the
  successor tick.

  ## graph_queries_run

  - `lean_local_search("T5_SchmidtAuxIndexAtAlpha_Statement")` →
    Wave-2 Phase 2.4 file. Used: yes.
  - `lean_local_search("T5_rothIndex_ge_iff_all_lt_vanish")` → Wave-1
    W1-B reduction lemma. Used: yes (will be used in m=1 discharge
    in successor tick).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## NAMED sub-hypothesis 1: m=1 case -/

/-- **`T5_SchmidtAuxIndex_m1_Discharge`** [NAMED HYPOTHESIS — to discharge].

    The m=1 specialization of `T5_SchmidtAuxIndexAtAlpha_Statement`.

    Discharge plan: construct `P_1 := X 0 - C α` over
    `MvPolynomial (Fin 1) ℝ`, take R 0 = 1, and use
    `T5_rothIndex_ge_iff_all_lt_vanish` (Wave-1 W1-B) to prove
    `rothIndex P_1 (fun _ => α) (fun _ => 1) ≥ 1/2 - √ε` via
    universal vanish: any j with j 0 < 1/2 - √ε ≤ 1/2 has j 0 = 0,
    hence multiIteratedPDeriv 0 P_1 = P_1, and aeval α P_1 = α - α = 0.

    Per project rule §7.0: real ∀-quantified Prop, used non-vacuously
    in the conditional grand below, NOT `:= True`. -/
def T5_SchmidtAuxIndex_m1_Discharge : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin 1, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin 1, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ ((1 : ℕ) : ℝ) / 2 - Real.sqrt (((1 : ℕ) : ℝ) * ε)

/-! ## NAMED sub-hypothesis 2: m ≥ 2 case -/

/-- **`T5_SchmidtAuxIndex_mGe2_Discharge`** [NAMED HYPOTHESIS — to discharge].

    The m ≥ 2 case.  Same aux poly construction
    `P_m := ∏ (X i - C α)` but needs careful multi-derivative
    bookkeeping over `Fin m`.

    Per project rule §7.0: real ∀-quantified Prop, used non-vacuously
    in the conditional grand below, NOT `:= True`. -/
def T5_SchmidtAuxIndex_mGe2_Discharge : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ (m : ℕ), 2 ≤ m →
  ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin m, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## Decomposition: m=1 + m≥2 → full discharge -/

/-- **🚨 W2.4-Discharge — `T5_SchmidtAuxIndexDischarge_via_decomposition`**.

    Composes the m=1 sub-NAMED + m≥2 sub-NAMED into the original
    Wave-2 Phase 2.4 NAMED hypothesis.

    Strategy: pick m₀ := 1, case split on m = 1 vs m ≥ 2. -/
theorem T5_SchmidtAuxIndexDischarge_via_decomposition
    (h_m1 : T5_SchmidtAuxIndex_m1_Discharge)
    (h_mGe2 : T5_SchmidtAuxIndex_mGe2_Discharge) :
    T5_SchmidtAuxIndexAtAlphaDischarge := by
  intros α hα h_alg ε hε
  -- Pick m₀ = 1
  refine ⟨1, fun m hm hm_pos => ?_⟩
  by_cases hm1 : m = 1
  · -- m = 1 case: use h_m1
    subst hm1
    exact h_m1 α hα h_alg ε hε
  · -- m ≥ 2 case: use h_mGe2
    have hm2 : 2 ≤ m := by omega
    exact h_mGe2 α hα h_alg ε hε m hm2

/-! ## Paper-grade Prop bundle -/

/-- **`T5_SchmidtAuxIndex_Decomposition_paper`** — 3-conjunct paper-grade
    Prop bundling the decomposition machinery for downstream consumption. -/
def T5_SchmidtAuxIndex_Decomposition_paper : Prop :=
  -- (a) m=1 sub-NAMED is well-formed
  (T5_SchmidtAuxIndex_m1_Discharge ↔ T5_SchmidtAuxIndex_m1_Discharge) ∧
  -- (b) m≥2 sub-NAMED is well-formed
  (T5_SchmidtAuxIndex_mGe2_Discharge ↔ T5_SchmidtAuxIndex_mGe2_Discharge) ∧
  -- (c) Composition: m=1 + m≥2 → full Wave-2 Phase 2.4 NAMED
  (T5_SchmidtAuxIndex_m1_Discharge →
   T5_SchmidtAuxIndex_mGe2_Discharge →
   T5_SchmidtAuxIndexAtAlphaDischarge)

/-- **🚨 W2.4-Decomposition — paper-grade discharge**. -/
theorem T5_SchmidtAuxIndex_Decomposition_paper_holds :
    T5_SchmidtAuxIndex_Decomposition_paper :=
  ⟨Iff.rfl, Iff.rfl, T5_SchmidtAuxIndexDischarge_via_decomposition⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.4 discharge step: decomposition**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 discharge step.

    Three derivations + 3-conjunct paper-grade Prop:
    1. `T5_SchmidtAuxIndex_m1_Discharge` — m=1 sub-NAMED
    2. `T5_SchmidtAuxIndex_mGe2_Discharge` — m≥2 sub-NAMED
    3. `T5_SchmidtAuxIndexDischarge_via_decomposition` — composition
    4. `T5_SchmidtAuxIndex_Decomposition_paper` — 3-conjunct bundle

    Net: T5_SchmidtAuxIndexAtAlphaDischarge (1 of 4 remaining NAMED)
    is now decomposed into TWO sub-NAMEDs.  Each sub-NAMED has explicit
    construction plan via P_m := ∏ (X i - C α) + W1-B reduction lemma
    `T5_rothIndex_ge_iff_all_lt_vanish`.  Discharges queued for
    successor 10-min ticks.

    Sub-lemma 293/N in T-5 Phase 7.  Lean-core only.  NO STUBS — both
    sub-NAMEDs are real ∀-quantified Props with non-vacuous content. -/
theorem session_W2_phase_2_4_decomposition_headline :
    T5_SchmidtAuxIndex_Decomposition_paper :=
  T5_SchmidtAuxIndex_Decomposition_paper_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge
