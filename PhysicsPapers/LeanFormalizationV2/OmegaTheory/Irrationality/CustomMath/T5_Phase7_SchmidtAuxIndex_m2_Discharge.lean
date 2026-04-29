/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge

  T-5 (Roth's theorem) — **m=2 Schmidt aux index UNCONDITIONAL discharge**.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Direct discharge of `T5_SchmidtAuxIndex_m2_Discharge` via
  `P_2 := (X 0 - C α) * (X 1 - C α)`.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

/-! ## multiIteratedPDeriv computation for m=2 -/

/-- multiIteratedPDeriv (fun _ => 1) P_2 = 1, where P_2 = (X 0 - C α) * (X 1 - C α).

    Computation:
    - List.finRange 2 = [0, 1]
    - foldr applies pderiv 1 first, then pderiv 0
    - pderiv 1 P_2 = (X 0 - C α) (via pderiv_mul + pderiv_X + pderiv_C)
    - pderiv 0 (X 0 - C α) = 1 -/
theorem T5_multiIteratedPDeriv_oneJ_m2 (α : ℝ) :
    multiIteratedPDeriv (fun _ : Fin 2 => 1) (T5_schmidtAuxPoly_m2 α) =
      (1 : MvPolynomial (Fin 2) ℝ) := by
  unfold multiIteratedPDeriv T5_schmidtAuxPoly_m2
  have h_finRange : List.finRange 2 = [(0 : Fin 2), (1 : Fin 2)] := by decide
  rw [h_finRange]
  simp only [List.foldr_cons, List.foldr_nil, Function.iterate_one]
  -- Goal: pderiv 0 (pderiv 1 ((X 0 - C α) * (X 1 - C α))) = 1
  -- Step 1: pderiv 1 ((X 0 - C α) * (X 1 - C α)) = X 0 - C α
  have h_inner : (pderiv (1 : Fin 2)) ((X 0 - C α) * (X 1 - C α) :
      MvPolynomial (Fin 2) ℝ) = X 0 - C α := by
    rw [Derivation.leibniz]
    simp [MvPolynomial.pderiv_X, MvPolynomial.pderiv_C, Pi.single_eq_same,
          Pi.single_eq_of_ne (Ne.symm (by decide : (0 : Fin 2) ≠ 1))]
  rw [h_inner]
  -- Step 2: pderiv 0 (X 0 - C α) = 1
  rw [map_sub, MvPolynomial.pderiv_X, MvPolynomial.pderiv_C]
  simp [Pi.single_eq_same]

/-! ## P_2 ≠ 0 -/

theorem T5_schmidtAuxPoly_m2_ne_zero (α : ℝ) :
    T5_schmidtAuxPoly_m2 α ≠ 0 := by
  intro h_eq
  have h1 : multiIteratedPDeriv (fun _ : Fin 2 => 1) (T5_schmidtAuxPoly_m2 α) =
      (1 : MvPolynomial (Fin 2) ℝ) := T5_multiIteratedPDeriv_oneJ_m2 α
  have h2 : multiIteratedPDeriv (fun _ : Fin 2 => 1) (T5_schmidtAuxPoly_m2 α) =
      (0 : MvPolynomial (Fin 2) ℝ) := by
    rw [h_eq]
    unfold multiIteratedPDeriv
    have h_finRange : List.finRange 2 = [(0 : Fin 2), (1 : Fin 2)] := by decide
    rw [h_finRange]
    simp only [List.foldr_cons, List.foldr_nil, Function.iterate_one]
    simp [map_zero]
  rw [h1] at h2
  exact one_ne_zero h2

/-! ## degreeOf bound -/

theorem T5_schmidtAuxPoly_m2_degreeOf (α : ℝ) (i : Fin 2) :
    MvPolynomial.degreeOf i (T5_schmidtAuxPoly_m2 α) ≤ 1 := by
  unfold T5_schmidtAuxPoly_m2
  have h_factor1_X : ∀ k : Fin 2,
      MvPolynomial.degreeOf k (X 0 - C α : MvPolynomial (Fin 2) ℝ) ≤
        if k = 0 then 1 else 0 := by
    intro k
    calc MvPolynomial.degreeOf k (X 0 - C α : MvPolynomial (Fin 2) ℝ)
        ≤ max (MvPolynomial.degreeOf k (X 0 : MvPolynomial (Fin 2) ℝ))
               (MvPolynomial.degreeOf k (C α : MvPolynomial (Fin 2) ℝ)) :=
          MvPolynomial.degreeOf_sub_le k (X 0) (C α)
      _ ≤ if k = 0 then 1 else 0 := by
          rw [MvPolynomial.degreeOf_X k 0, MvPolynomial.degreeOf_C]
          by_cases hk : k = 0
          · subst hk; simp
          · simp [if_neg hk]
  have h_factor2_X : ∀ k : Fin 2,
      MvPolynomial.degreeOf k (X 1 - C α : MvPolynomial (Fin 2) ℝ) ≤
        if k = 1 then 1 else 0 := by
    intro k
    calc MvPolynomial.degreeOf k (X 1 - C α : MvPolynomial (Fin 2) ℝ)
        ≤ max (MvPolynomial.degreeOf k (X 1 : MvPolynomial (Fin 2) ℝ))
               (MvPolynomial.degreeOf k (C α : MvPolynomial (Fin 2) ℝ)) :=
          MvPolynomial.degreeOf_sub_le k (X 1) (C α)
      _ ≤ if k = 1 then 1 else 0 := by
          rw [MvPolynomial.degreeOf_X k 1, MvPolynomial.degreeOf_C]
          by_cases hk : k = 1
          · subst hk; simp
          · simp [if_neg hk]
  calc MvPolynomial.degreeOf i ((X 0 - C α) * (X 1 - C α) : MvPolynomial (Fin 2) ℝ)
      ≤ MvPolynomial.degreeOf i (X 0 - C α : MvPolynomial (Fin 2) ℝ)
        + MvPolynomial.degreeOf i (X 1 - C α : MvPolynomial (Fin 2) ℝ) :=
        MvPolynomial.degreeOf_mul_le i (X 0 - C α) (X 1 - C α)
    _ ≤ (if i = 0 then 1 else 0) + (if i = 1 then 1 else 0) := by
        have := h_factor1_X i
        have := h_factor2_X i
        omega
    _ ≤ 1 := by
        fin_cases i <;> simp

/-! ## Roth-index set non-emptiness -/

theorem T5_schmidtAuxPoly_m2_rothIndexSet_nonempty (α : ℝ) :
    { r : ℝ | ∃ j : Fin 2 → ℕ,
      aeval (fun _ : Fin 2 => α) (multiIteratedPDeriv j (T5_schmidtAuxPoly_m2 α)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / ((1 : ℕ) : ℝ) }.Nonempty := by
  refine ⟨2, fun _ => 1, ?_, ?_⟩
  · rw [T5_multiIteratedPDeriv_oneJ_m2]
    simp
  · simp [Fin.sum_univ_two]

/-! ## Universal vanish for j with sum < 1 - √(2ε) -/

theorem T5_schmidtAuxPoly_m2_aeval_at_alpha_zero (α : ℝ) :
    aeval (fun _ : Fin 2 => α)
      (multiIteratedPDeriv (fun _ : Fin 2 => 0) (T5_schmidtAuxPoly_m2 α)) = 0 := by
  rw [T5_multiIteratedPDeriv_zeroJ]
  unfold T5_schmidtAuxPoly_m2
  simp

/-! ## rothIndex bound -/

theorem T5_schmidtAuxPoly_m2_rothIndex_ge (α : ℝ) (ε : ℝ) (_hε : 0 < ε) :
    rothIndex (T5_schmidtAuxPoly_m2 α) (fun _ : Fin 2 => α) (fun _ : Fin 2 => 1)
      ≥ ((2 : ℕ) : ℝ) / 2 - Real.sqrt (((2 : ℕ) : ℝ) * ε) := by
  rw [ge_iff_le]
  rw [T5_rothIndex_ge_iff_all_lt_vanish _ _ _
      (T5_schmidtAuxPoly_m2_rothIndexSet_nonempty α)]
  intro j hj_lt
  have h_simp : ∑ i : Fin 2, (j i : ℝ) / ((fun _ : Fin 2 => (1 : ℕ)) i : ℝ) =
      (j 0 : ℝ) + (j 1 : ℝ) := by
    simp [Fin.sum_univ_two]
  rw [h_simp] at hj_lt
  -- hj_lt : (j 0 : ℝ) + (j 1 : ℝ) < 2/2 - √(2ε) = 1 - √(2ε) ≤ 1
  set sε := Real.sqrt (((2 : ℕ) : ℝ) * ε) with hsε
  have h_sε_nn : 0 ≤ sε := Real.sqrt_nonneg _
  have h_simp_t : ((2 : ℕ) : ℝ) / 2 - sε ≤ ((2 : ℕ) : ℝ) / 2 := by linarith
  have h_jsum_lt : (j 0 : ℝ) + (j 1 : ℝ) < ((2 : ℕ) : ℝ) / 2 :=
    lt_of_lt_of_le hj_lt h_simp_t
  -- ((2 : ℕ) : ℝ) / 2 = 1
  have h_jsum_lt_one : (j 0 : ℝ) + (j 1 : ℝ) < 1 := by
    have h22 : ((2 : ℕ) : ℝ) / 2 = 1 := by norm_num
    rw [h22] at h_jsum_lt
    exact h_jsum_lt
  -- j 0 + j 1 : ℕ ≥ 0; sum < 1 means j 0 + j 1 = 0
  have h_jsum_lt_one_nat : j 0 + j 1 < 1 := by
    have := h_jsum_lt_one
    have h_cast : ((j 0 + j 1 : ℕ) : ℝ) = (j 0 : ℝ) + (j 1 : ℝ) := by push_cast; rfl
    rw [← h_cast] at this
    exact_mod_cast this
  have h_jsum_zero : j 0 + j 1 = 0 := by omega
  have h_j0_zero : j 0 = 0 := by omega
  have h_j1_zero : j 1 = 0 := by omega
  have h_j_eq_zero : j = fun _ : Fin 2 => 0 := by
    funext i
    fin_cases i
    · exact h_j0_zero
    · exact h_j1_zero
  rw [h_j_eq_zero]
  exact T5_schmidtAuxPoly_m2_aeval_at_alpha_zero α

/-! ## Discharge of m=2 sub-NAMED -/

theorem T5_SchmidtAuxIndex_m2_Discharge_unconditional :
    T5_SchmidtAuxIndex_m2_Discharge := by
  intros α _hα _h_alg ε hε
  refine ⟨T5_schmidtAuxPoly_m2 α, fun _ => 1, ?_, ?_, ?_, ?_⟩
  · exact T5_schmidtAuxPoly_m2_ne_zero α
  · exact T5_schmidtAuxPoly_m2_degreeOf α
  · intro _; exact Nat.one_pos
  · exact T5_schmidtAuxPoly_m2_rothIndex_ge α ε hε

/-! ## Headline -/

theorem session_W2_phase_2_4_m2_discharge_headline :
    T5_SchmidtAuxIndex_m2_Discharge :=
  T5_SchmidtAuxIndex_m2_Discharge_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2_Discharge
