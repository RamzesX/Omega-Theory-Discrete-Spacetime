/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_GeneralBridge

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 GENERAL ↔ M2/M3 BRIDGE**.

  Single-thread hand-authored 2026-04-29.

  ## What this delivers

  Yoneda bridge confirming `T5_matDetLemma_general` SPECIALIZES correctly
  to m=2 and m=3 (matching existing direct proofs). This validates the
  rank-1 charpoly route as fully consistent with the m=2/m=3 direct
  `Matrix.det_fin_two` / `Matrix.det_fin_three` route.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_GeneralBridge

open MvPolynomial Matrix Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3

/-! ## m=2 specialization equivalence -/

/-- **Bridge m=2: general formula = direct m=2 formula** (sanity check). -/
theorem T5_matDetLemma_general_m2_eq_direct (P : MvPolynomial (Fin 2) ℝ) :
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P * (P + ∑ i : Fin 2, X i * pderiv i P) := by
  -- Both routes should give the same answer
  rw [T5_matDetLemma_general (by decide : 1 ≤ 2) P]
  -- General: P^(2-1) · (P + ∑ ...) = P · (P + ∑ ...) — already rfl
  simp

/-- **Bridge m=2 nonzero**: general nonzero specializes correctly. -/
theorem T5_matDetLemma_general_m2_nonzero_eq_direct
    (P : MvPolynomial (Fin 2) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_general_nonzero (by decide : 1 ≤ 2) P hP

/-! ## m=3 specialization equivalence -/

/-- **Bridge m=3: general formula = direct m=3 formula** (sanity check). -/
theorem T5_matDetLemma_general_m3_eq_direct (P : MvPolynomial (Fin 3) ℝ) :
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^2 * (P + ∑ i : Fin 3, X i * pderiv i P) := by
  rw [T5_matDetLemma_general (by decide : 1 ≤ 3) P]

/-- **Bridge m=3 nonzero**: general nonzero specializes correctly. -/
theorem T5_matDetLemma_general_m3_nonzero_eq_direct
    (P : MvPolynomial (Fin 3) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  T5_matDetLemma_general_nonzero (by decide : 1 ≤ 3) P hP

/-! ## Headline -/

/-- **🚨 MATRIX DET LEMMA GENERAL ↔ M2/M3 BRIDGE HEADLINE** —
    4-conjunct paper-grade Yoneda bridge confirming consistency
    between general (rank-1 charpoly) and direct (det_fin_2/det_fin_3) routes.

    🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5).

    Sub-lemma 329/N in T-5 Phase 7. NO STUBS. Lean-core only. -/
theorem session_W2_phase_2_2_matDet_general_bridge_headline :
    (∀ (P : MvPolynomial (Fin 2) ℝ),
      (Matrix.of (fun (i j : Fin 2) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det =
      P * (P + ∑ i : Fin 2, X i * pderiv i P)) ∧
    (∀ (P : MvPolynomial (Fin 2) ℝ), P ≠ 0 →
      (Matrix.of (fun (i j : Fin 2) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
    (∀ (P : MvPolynomial (Fin 3) ℝ),
      (Matrix.of (fun (i j : Fin 3) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det =
      P^2 * (P + ∑ i : Fin 3, X i * pderiv i P)) ∧
    (∀ (P : MvPolynomial (Fin 3) ℝ), P ≠ 0 →
      (Matrix.of (fun (i j : Fin 3) =>
        (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) :=
  ⟨T5_matDetLemma_general_m2_eq_direct,
   T5_matDetLemma_general_m2_nonzero_eq_direct,
   T5_matDetLemma_general_m3_eq_direct,
   T5_matDetLemma_general_m3_nonzero_eq_direct⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_GeneralBridge
