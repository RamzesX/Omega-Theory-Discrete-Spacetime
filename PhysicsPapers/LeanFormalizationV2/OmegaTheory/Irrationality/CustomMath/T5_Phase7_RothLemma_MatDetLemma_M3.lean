/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 MATRIX DET LEMMA m=3**:
  m=3 instance via `Matrix.det_fin_three`.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3

open MvPolynomial Matrix Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral

/-- **m=3 matrix det lemma** — `det(P*I + outer(d, X)) = P^2 · (P + ∑ X_i · d_iP)`. -/
theorem T5_matDetLemma_m3 (P : MvPolynomial (Fin 3) ℝ) :
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^2 * (P + ∑ i : Fin 3, X i * pderiv i P) := by
  rw [Matrix.det_fin_three]
  simp only [Matrix.of_apply]
  simp only [Fin.isValue,
             if_neg (by decide : (0 : Fin 3) ≠ 1),
             if_neg (by decide : (0 : Fin 3) ≠ 2),
             if_neg (by decide : (1 : Fin 3) ≠ 0),
             if_neg (by decide : (1 : Fin 3) ≠ 2),
             if_neg (by decide : (2 : Fin 3) ≠ 0),
             if_neg (by decide : (2 : Fin 3) ≠ 1),
             zero_add, if_true]
  rw [Fin.sum_univ_three]
  ring

theorem T5_matDetLemma_m3_nonzero (P : MvPolynomial (Fin 3) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 := by
  rw [T5_matDetLemma_m3]
  apply mul_ne_zero
  · exact pow_ne_zero 2 hP
  · exact T5_GeneralEulerShifted_holds P hP

/-- **🚨 m=3 MATRIX DET LEMMA UNCONDITIONAL headline**. -/
theorem session_W2_phase_2_2_matdet_lemma_m3_headline :
    ∀ (P : MvPolynomial (Fin 3) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_m3_nonzero

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3
