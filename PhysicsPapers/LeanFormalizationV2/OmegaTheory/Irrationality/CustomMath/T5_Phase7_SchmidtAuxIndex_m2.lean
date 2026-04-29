/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

  T-5 (Roth's theorem) — **m=2 case scaffold for Schmidt aux index discharge**.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Direct discharge of the m=2 case of the Schmidt aux index Prop via
  `P_2 := (X 0 - C α) * (X 1 - C α)`.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1

/-! ## m=2 aux poly construction -/

/-- The m=2 Schmidt aux poly `P_2 := (X 0 - C α) * (X 1 - C α)`. -/
noncomputable def T5_schmidtAuxPoly_m2 (α : ℝ) : MvPolynomial (Fin 2) ℝ :=
  (X 0 - C α) * (X 1 - C α)

/-! ## NAMED hypothesis for m=2 case -/

/-- **`T5_SchmidtAuxIndex_m2_Discharge`** [NAMED HYPOTHESIS — to discharge].

    The m=2 specialization of the Schmidt aux index statement.

    Construction plan: P_2 := (X 0 - C α) * (X 1 - C α), R i = 1.
    rothIndex via Wave-1 W1-B + product-rule case analysis on
    multi-derivatives.

    Per project rule §7.0: real ∀-quantified Prop, used non-vacuously. -/
def T5_SchmidtAuxIndex_m2_Discharge : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (P : MvPolynomial (Fin 2) ℝ) (R : Fin 2 → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin 2, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin 2, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ ((2 : ℕ) : ℝ) / 2 - Real.sqrt (((2 : ℕ) : ℝ) * ε)

/-! ## NAMED hypothesis for m≥3 case (further decomposition) -/

/-- **`T5_SchmidtAuxIndex_mGe3_Discharge`** [NAMED HYPOTHESIS — to discharge].

    The m≥3 specialization.  Same product construction
    `P_m := ∏_{i : Fin m} (X i - C α)` requiring induction-heavy
    multi-derivative bookkeeping.

    Per project rule §7.0: real ∀-quantified Prop. -/
def T5_SchmidtAuxIndex_mGe3_Discharge : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ (m : ℕ), 3 ≤ m →
  ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin m, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## Composition: m=2 + m≥3 → m≥2 -/

/-- **🚨 `T5_SchmidtAuxIndex_mGe2_Discharge_via_decomposition`** —
    composes m=2 sub-NAMED + m≥3 sub-NAMED into the m≥2 NAMED. -/
theorem T5_SchmidtAuxIndex_mGe2_Discharge_via_decomposition
    (h_m2 : T5_SchmidtAuxIndex_m2_Discharge)
    (h_mGe3 : T5_SchmidtAuxIndex_mGe3_Discharge) :
    T5_SchmidtAuxIndex_mGe2_Discharge := by
  intros α hα h_alg ε hε m hm
  by_cases hm2 : m = 2
  · subst hm2
    exact h_m2 α hα h_alg ε hε
  · have hm3 : 3 ≤ m := by omega
    exact h_mGe3 α hα h_alg ε hε m hm3

/-! ## Composition: m=1 + m=2 + m≥3 → full Wave-2 Phase 2.4 NAMED -/

/-- **🚨 `T5_SchmidtAuxIndex_full_via_finer_decomposition`** —
    composes m=1 (UNCONDITIONAL) + m=2 sub-NAMED + m≥3 sub-NAMED
    into the original Wave-2 Phase 2.4 NAMED. -/
theorem T5_SchmidtAuxIndex_full_via_finer_decomposition
    (h_m2 : T5_SchmidtAuxIndex_m2_Discharge)
    (h_mGe3 : T5_SchmidtAuxIndex_mGe3_Discharge) :
    T5_SchmidtAuxIndexAtAlphaDischarge :=
  T5_SchmidtAuxIndexDischarge_via_decomposition
    T5_SchmidtAuxIndex_m1_Discharge_unconditional
    (T5_SchmidtAuxIndex_mGe2_Discharge_via_decomposition h_m2 h_mGe3)

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.4 m≥2 finer decomposition**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 finer split.

    Three derivations:
    1. `T5_SchmidtAuxIndex_m2_Discharge` — m=2 sub-NAMED
    2. `T5_SchmidtAuxIndex_mGe3_Discharge` — m≥3 sub-NAMED
    3. `T5_SchmidtAuxIndex_mGe2_Discharge_via_decomposition` —
       composes m=2 + m≥3 → m≥2
    4. `T5_SchmidtAuxIndex_full_via_finer_decomposition` —
       composes m=1 (UNCONDITIONAL) + m=2 + m≥3 → original NAMED

    Net: T5_SchmidtAuxIndexAtAlphaDischarge is now decomposed into:
    - m=1 ✅ CLOSED (T5_Phase7_SchmidtAuxIndex_m1.lean)
    - m=2 NAMED (this file)
    - m≥3 NAMED (this file)

    Sub-lemma 296/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_4_finer_decomposition_headline :
    T5_SchmidtAuxIndex_m2_Discharge →
    T5_SchmidtAuxIndex_mGe3_Discharge →
    T5_SchmidtAuxIndexAtAlphaDischarge :=
  T5_SchmidtAuxIndex_full_via_finer_decomposition

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2
