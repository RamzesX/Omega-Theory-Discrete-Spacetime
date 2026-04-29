/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M4_M5_M6

  T-5 (Roth's theorem) — **Phase 7 m=4/m=5/m=6 SPECIALIZATIONS**.

  Single-thread hand-authored 2026-04-29.

  ## What this delivers

  Concrete m=4, m=5, m=6 specializations of the matrix det lemma —
  unblocked by `T5_matDetLemma_general` (rank-1 charpoly route)
  bypassing the kernel-timeout issues from direct `det_succ_row_zero`
  cofactor expansion that previously blocked m=4.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M4_M5_M6

open MvPolynomial Matrix Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General

/-! ## m=4 specialization -/

/-- **m=4 matrix det lemma** via general rank-1 charpoly route. -/
theorem T5_matDetLemma_m4 (P : MvPolynomial (Fin 4) ℝ) :
    (Matrix.of (fun (i j : Fin 4) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^3 * (P + ∑ i : Fin 4, X i * pderiv i P) := by
  rw [T5_matDetLemma_general (by decide : 1 ≤ 4) P]

theorem T5_matDetLemma_m4_nonzero (P : MvPolynomial (Fin 4) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 4) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_general_nonzero (by decide : 1 ≤ 4) P hP

/-! ## m=5 specialization -/

/-- **m=5 matrix det lemma** via general rank-1 charpoly route. -/
theorem T5_matDetLemma_m5 (P : MvPolynomial (Fin 5) ℝ) :
    (Matrix.of (fun (i j : Fin 5) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^4 * (P + ∑ i : Fin 5, X i * pderiv i P) := by
  rw [T5_matDetLemma_general (by decide : 1 ≤ 5) P]

theorem T5_matDetLemma_m5_nonzero (P : MvPolynomial (Fin 5) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 5) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_general_nonzero (by decide : 1 ≤ 5) P hP

/-! ## m=6 specialization -/

/-- **m=6 matrix det lemma** via general rank-1 charpoly route. -/
theorem T5_matDetLemma_m6 (P : MvPolynomial (Fin 6) ℝ) :
    (Matrix.of (fun (i j : Fin 6) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^5 * (P + ∑ i : Fin 6, X i * pderiv i P) := by
  rw [T5_matDetLemma_general (by decide : 1 ≤ 6) P]

theorem T5_matDetLemma_m6_nonzero (P : MvPolynomial (Fin 6) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 6) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_general_nonzero (by decide : 1 ≤ 6) P hP

/-! ## Headline -/

/-- **🚨 m=4/m=5/m=6 MATRIX DET LEMMA UNCONDITIONAL via rank-1 charpoly**.

    Concrete witnesses showing the general rank-1 charpoly route
    UNBLOCKS dimensions previously blocked by kernel-timeout issues
    from `det_succ_row_zero` cofactor expansion.

    Sub-lemma 330/N in T-5 Phase 7. NO STUBS. -/
theorem session_W2_phase_2_2_matDet_m4m5m6_headline :
    (∀ (P : MvPolynomial (Fin 4) ℝ), P ≠ 0 →
      (Matrix.of (fun (i j : Fin 4) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
    (∀ (P : MvPolynomial (Fin 5) ℝ), P ≠ 0 →
      (Matrix.of (fun (i j : Fin 5) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
    (∀ (P : MvPolynomial (Fin 6) ℝ), P ≠ 0 →
      (Matrix.of (fun (i j : Fin 6) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) :=
  ⟨T5_matDetLemma_m4_nonzero,
   T5_matDetLemma_m5_nonzero,
   T5_matDetLemma_m6_nonzero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M4_M5_M6
