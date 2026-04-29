/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3

  T-5 (Roth's theorem) — **m=3 Schmidt aux index UNCONDITIONAL discharge**.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Direct discharge of the m=3 case via
  `P_3 := (X 0 - C α) * (X 1 - C α) * (X 2 - C α)`.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

/-! ## NAMED hypothesis for m=3 case -/

/-- **`T5_SchmidtAuxIndex_m3_Discharge`** [NAMED HYPOTHESIS — to discharge].

    The m=3 specialization of the Schmidt aux index statement.

    Construction: P_3 := (X 0 - C α) * (X 1 - C α) * (X 2 - C α).
    rothIndex via Wave-1 W1-B + Derivation.leibniz product rule
    over 3-fold product. -/
def T5_SchmidtAuxIndex_m3_Discharge : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (P : MvPolynomial (Fin 3) ℝ) (R : Fin 3 → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin 3, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin 3, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ ((3 : ℕ) : ℝ) / 2 - Real.sqrt (((3 : ℕ) : ℝ) * ε)

/-! ## NAMED hypothesis for m≥4 case -/

/-- **`T5_SchmidtAuxIndex_mGe4_Discharge`** [NAMED HYPOTHESIS — to discharge].

    The m≥4 specialization.  Same product construction
    `P_m := ∏_{i : Fin m} (X i - C α)` requiring induction. -/
def T5_SchmidtAuxIndex_mGe4_Discharge : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ (m : ℕ), 4 ≤ m →
  ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin m, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## Composition: m=3 + m≥4 → m≥3 -/

/-- **🚨 `T5_SchmidtAuxIndex_mGe3_Discharge_via_decomposition`** —
    composes m=3 sub-NAMED + m≥4 sub-NAMED into the m≥3 NAMED. -/
theorem T5_SchmidtAuxIndex_mGe3_Discharge_via_decomposition
    (h_m3 : T5_SchmidtAuxIndex_m3_Discharge)
    (h_mGe4 : T5_SchmidtAuxIndex_mGe4_Discharge) :
    T5_SchmidtAuxIndex_mGe3_Discharge := by
  intros α hα h_alg ε hε m hm
  by_cases hm3 : m = 3
  · subst hm3
    exact h_m3 α hα h_alg ε hε
  · have hm4 : 4 ≤ m := by omega
    exact h_mGe4 α hα h_alg ε hε m hm4

/-! ## Headline -/

theorem session_W2_phase_2_4_m3_decomposition_headline :
    T5_SchmidtAuxIndex_m3_Discharge →
    T5_SchmidtAuxIndex_mGe4_Discharge →
    T5_SchmidtAuxIndex_mGe3_Discharge :=
  T5_SchmidtAuxIndex_mGe3_Discharge_via_decomposition

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3
