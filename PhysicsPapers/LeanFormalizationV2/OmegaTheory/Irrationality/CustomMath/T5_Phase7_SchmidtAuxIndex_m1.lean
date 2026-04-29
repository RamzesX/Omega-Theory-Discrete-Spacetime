/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1

  T-5 (Roth's theorem) — **m=1 case of Schmidt aux index discharge**.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Direct discharge of `T5_SchmidtAuxIndex_m1_Discharge` via P_1 := X 0 - C α.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaDischarge

/-! ## m=1 aux poly construction -/

/-- The m=1 Schmidt aux poly `P_1 := X 0 - C α`. -/
noncomputable def T5_schmidtAuxPoly_m1 (α : ℝ) : MvPolynomial (Fin 1) ℝ :=
  X 0 - C α

/-! ## Computation of multiIteratedPDeriv at j = (fun _ => 1) -/

/-- **`T5_multiIteratedPDeriv_oneJ_m1`**: multiIteratedPDeriv applied with
    j = (fun _ => 1) on P_1 = X 0 - C α gives 1.

    Proof: unfolds to `(pderiv 0) (X 0 - C α) = 1 - 0 = 1`. -/
theorem T5_multiIteratedPDeriv_oneJ_m1 (α : ℝ) :
    multiIteratedPDeriv (fun _ : Fin 1 => 1) (T5_schmidtAuxPoly_m1 α) =
      (1 : MvPolynomial (Fin 1) ℝ) := by
  unfold multiIteratedPDeriv T5_schmidtAuxPoly_m1
  -- List.finRange 1 = [0]
  -- foldr applies: (pderiv 0)^[1] = pderiv 0
  -- pderiv 0 (X 0 - C α) = 1 - 0 = 1
  have h_finRange : List.finRange 1 = [(0 : Fin 1)] := by decide
  rw [h_finRange]
  simp only [List.foldr_cons, List.foldr_nil, Function.iterate_one]
  rw [map_sub, MvPolynomial.pderiv_X]
  simp [Pi.single_eq_same, MvPolynomial.pderiv_C]

/-! ## P_1 ≠ 0 via the multiIteratedPDeriv computation -/

theorem T5_schmidtAuxPoly_m1_ne_zero (α : ℝ) :
    T5_schmidtAuxPoly_m1 α ≠ 0 := by
  intro h_eq
  -- multiIteratedPDeriv (fun _ => 1) P_1 = 1
  -- but if P_1 = 0, then multiIteratedPDeriv anything 0 = 0
  -- so 1 = 0, contradiction
  have h1 : multiIteratedPDeriv (fun _ : Fin 1 => 1) (T5_schmidtAuxPoly_m1 α) =
      (1 : MvPolynomial (Fin 1) ℝ) := T5_multiIteratedPDeriv_oneJ_m1 α
  have h2 : multiIteratedPDeriv (fun _ : Fin 1 => 1) (T5_schmidtAuxPoly_m1 α) =
      (0 : MvPolynomial (Fin 1) ℝ) := by
    rw [h_eq]
    -- multiIteratedPDeriv on 0 is 0 (linearity)
    unfold multiIteratedPDeriv
    have h_finRange : List.finRange 1 = [(0 : Fin 1)] := by decide
    rw [h_finRange]
    simp only [List.foldr_cons, List.foldr_nil, Function.iterate_one]
    simp [map_zero]
  rw [h1] at h2
  exact one_ne_zero h2

/-! ## degreeOf bound -/

theorem T5_schmidtAuxPoly_m1_degreeOf (α : ℝ) (i : Fin 1) :
    MvPolynomial.degreeOf i (T5_schmidtAuxPoly_m1 α) ≤ 1 := by
  fin_cases i
  unfold T5_schmidtAuxPoly_m1
  calc MvPolynomial.degreeOf 0 (X 0 - C α : MvPolynomial (Fin 1) ℝ)
      ≤ max (MvPolynomial.degreeOf 0 (X 0 : MvPolynomial (Fin 1) ℝ))
             (MvPolynomial.degreeOf 0 (C α : MvPolynomial (Fin 1) ℝ)) :=
        MvPolynomial.degreeOf_sub_le 0 (X 0) (C α)
    _ = max 1 0 := by
        rw [MvPolynomial.degreeOf_X (0 : Fin 1), MvPolynomial.degreeOf_C]
        simp
    _ = 1 := by decide

/-! ## rothIndex bound — preparatory lemmas -/

/-- The Roth-index set for `P_1 = X 0 - C α` at α with d = 1 is
    non-empty (witness: j = (fun _ => 1)). -/
theorem T5_schmidtAuxPoly_m1_rothIndexSet_nonempty (α : ℝ) :
    { r : ℝ | ∃ j : Fin 1 → ℕ,
      aeval (fun _ : Fin 1 => α) (multiIteratedPDeriv j (T5_schmidtAuxPoly_m1 α)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / ((1 : ℕ) : ℝ) }.Nonempty := by
  refine ⟨1, fun _ => 1, ?_, ?_⟩
  · rw [T5_multiIteratedPDeriv_oneJ_m1]
    simp
  · simp

/-- For j = (fun _ => 0), aeval at α of multiIteratedPDeriv j P_1 = 0. -/
theorem T5_schmidtAuxPoly_m1_aeval_at_alpha_zero (α : ℝ) :
    aeval (fun _ : Fin 1 => α)
      (multiIteratedPDeriv (fun _ : Fin 1 => 0) (T5_schmidtAuxPoly_m1 α)) = 0 := by
  rw [T5_multiIteratedPDeriv_zeroJ]
  unfold T5_schmidtAuxPoly_m1
  simp

/-! ## rothIndex bound — main theorem -/

theorem T5_schmidtAuxPoly_m1_rothIndex_ge (α : ℝ) (ε : ℝ) (_hε : 0 < ε) :
    rothIndex (T5_schmidtAuxPoly_m1 α) (fun _ : Fin 1 => α) (fun _ : Fin 1 => 1)
      ≥ ((1 : ℕ) : ℝ) / 2 - Real.sqrt (((1 : ℕ) : ℝ) * ε) := by
  rw [ge_iff_le]
  rw [T5_rothIndex_ge_iff_all_lt_vanish _ _ _
      (T5_schmidtAuxPoly_m1_rothIndexSet_nonempty α)]
  intro j hj_lt
  have h_simp : ∑ i : Fin 1, (j i : ℝ) / ((fun _ : Fin 1 => (1 : ℕ)) i : ℝ) =
      (j 0 : ℝ) := by
    simp
  rw [h_simp] at hj_lt
  set sε := Real.sqrt (((1 : ℕ) : ℝ) * ε) with hsε
  have h_sε_nn : 0 ≤ sε := Real.sqrt_nonneg _
  have h_simp_t : ((1 : ℕ) : ℝ) / 2 - sε ≤ ((1 : ℕ) : ℝ) / 2 := by linarith
  have h_j_lt_half : (j 0 : ℝ) < ((1 : ℕ) : ℝ) / 2 :=
    lt_of_lt_of_le hj_lt h_simp_t
  have h_j_lt_one : (j 0 : ℝ) < 1 := by
    have h12 : ((1 : ℕ) : ℝ) / 2 < 1 := by norm_num
    linarith
  have h_j_zero : j 0 = 0 := by
    have : (j 0 : ℕ) < 1 := by exact_mod_cast h_j_lt_one
    omega
  have h_j_eq_zero : j = fun _ : Fin 1 => 0 := by
    funext i
    fin_cases i
    exact h_j_zero
  rw [h_j_eq_zero]
  exact T5_schmidtAuxPoly_m1_aeval_at_alpha_zero α

/-! ## Discharge of m=1 sub-NAMED -/

/-- **🚨 `T5_SchmidtAuxIndex_m1_Discharge_unconditional`** —
    UNCONDITIONAL discharge of the m=1 sub-NAMED. -/
theorem T5_SchmidtAuxIndex_m1_Discharge_unconditional :
    T5_SchmidtAuxIndex_m1_Discharge := by
  intros α _hα _h_alg ε hε
  refine ⟨T5_schmidtAuxPoly_m1 α, fun _ => 1, ?_, ?_, ?_, ?_⟩
  · exact T5_schmidtAuxPoly_m1_ne_zero α
  · exact T5_schmidtAuxPoly_m1_degreeOf α
  · intro _; exact Nat.one_pos
  · exact T5_schmidtAuxPoly_m1_rothIndex_ge α ε hε

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.4 m=1 sub-NAMED FULL UNCONDITIONAL DISCHARGE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 m=1 closed.

    Closes the m=1 sub-NAMED `T5_SchmidtAuxIndex_m1_Discharge` via:
    1. P_1 := X 0 - C α explicit construction
    2. multiIteratedPDeriv (fun _ => 1) P_1 = 1 (computation)
    3. P_1 ≠ 0 via the above (since 1 ≠ 0)
    4. degreeOf 0 P_1 ≤ 1 via degreeOf_sub_le + degreeOf_X + degreeOf_C
    5. rothIndex bound via Wave-1 W1-B `T5_rothIndex_ge_iff_all_lt_vanish`
       universal-vanish reduction over j 0 = 0 case.

    Sub-lemma 294/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_4_m1_discharge_headline :
    T5_SchmidtAuxIndex_m1_Discharge :=
  T5_SchmidtAuxIndex_m1_Discharge_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m1
