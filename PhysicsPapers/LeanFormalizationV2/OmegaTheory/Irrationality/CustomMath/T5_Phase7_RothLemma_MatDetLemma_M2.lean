/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 MATRIX DET LEMMA m=2**:
  unconditional discharge of the m=2 instance of the matrix det lemma
  for the polynomial-coefficient identity-witness Wronskian matrix.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  For any P : MvPolynomial (Fin 2) ℝ, the determinant of
  `M_{ij} = δ_{ij} P + (pderiv i P) · X_j` equals `P · (P + ∑ X_i · pderiv_i P)`.

  This is the matrix det lemma at m=2, proved DIRECTLY via
  `Matrix.det_fin_two` (no fraction-field lift needed for small m).

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2

open MvPolynomial Matrix Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral

/-! ## m=2 matrix det lemma — DIRECT computation -/

/-- **m=2 matrix det lemma** — `det(P*I + outer(d, X)) = P · (P + ∑ X_i · d_iP)`. -/
theorem T5_matDetLemma_m2 (P : MvPolynomial (Fin 2) ℝ) :
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P * (P + ∑ i : Fin 2, X i * pderiv i P) := by
  rw [Matrix.det_fin_two]
  simp only [Matrix.of_apply]
  -- Compute entries
  simp only [Fin.isValue, if_neg (by decide : (0 : Fin 2) ≠ 1),
             if_neg (by decide : (1 : Fin 2) ≠ 0), zero_add, if_true]
  rw [Fin.sum_univ_two]
  ring

/-- **m=2 Wronskian non-vanish via matrix det lemma + Euler kernel** —
    UNCONDITIONAL. -/
theorem T5_matDetLemma_m2_nonzero (P : MvPolynomial (Fin 2) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 := by
  rw [T5_matDetLemma_m2]
  apply mul_ne_zero hP
  exact T5_GeneralEulerShifted_holds P hP

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 m=2 MATRIX DET LEMMA UNCONDITIONAL**.

    🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 m=2 unconditional.

    Two derivations:
    1. `T5_matDetLemma_m2` — explicit formula via `Matrix.det_fin_two`
    2. `T5_matDetLemma_m2_nonzero` — combine with Euler kernel for non-vanishing

    This is the m=2 unconditional instance of `T5_MatrixDetLemma_for_VarP_NAMED`
    (commit 779cded). Strategy generalizes: for each fixed m, use
    `Matrix.det_fin_<m>` + ring to compute formula. For arbitrary m,
    requires the fraction-field lift (multi-day).

    Sub-lemma 318/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_matdet_lemma_m2_headline :
    ∀ (P : MvPolynomial (Fin 2) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_m2_nonzero

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2
