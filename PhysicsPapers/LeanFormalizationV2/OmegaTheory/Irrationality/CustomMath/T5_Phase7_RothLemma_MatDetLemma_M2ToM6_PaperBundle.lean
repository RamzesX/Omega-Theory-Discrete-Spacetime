/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2ToM6_PaperBundle

  T-5 (Roth's theorem) — **m=2-m=6 PAPER BUNDLE**: 5-conjunct paper-citable
  bundle covering all matrix det lemma specializations for low dimensions.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_Bundle
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M4_M5_M6

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2ToM6_PaperBundle

open MvPolynomial Matrix Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_Bundle
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M4_M5_M6

/-! ## 5-conjunct paper bundle m=2..m=6 -/

/-- **5-conjunct PAPER BUNDLE** — non-vanishing of matrix det at m=2..6. -/
def T5_matDetLemma_m2_to_m6_unconditional_paper_bundle : Prop :=
  -- (a) m=2 nonzero
  (∀ (P : MvPolynomial (Fin 2) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
  -- (b) m=3 nonzero
  (∀ (P : MvPolynomial (Fin 3) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
  -- (c) m=4 nonzero
  (∀ (P : MvPolynomial (Fin 4) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 4) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
  -- (d) m=5 nonzero
  (∀ (P : MvPolynomial (Fin 5) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 5) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
  -- (e) m=6 nonzero
  (∀ (P : MvPolynomial (Fin 6) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 6) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0)

theorem T5_matDetLemma_m2_to_m6_unconditional_paper_bundle_holds :
    T5_matDetLemma_m2_to_m6_unconditional_paper_bundle :=
  ⟨T5_matDetLemma_m2_nonzero,
   T5_matDetLemma_m3_nonzero,
   T5_matDetLemma_m4_nonzero,
   T5_matDetLemma_m5_nonzero,
   T5_matDetLemma_m6_nonzero⟩

/-! ## Headline -/

/-- **🚨 m=2-m=6 PAPER BUNDLE HEADLINE** — five-conjunct paper-citable
    matrix det lemma non-vanishing across all low dimensions m=2..6.

    🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5).

    All proofs Lean-core only via the rank-1 charpoly route
    (`Matrix.charpoly_vecMulVec` from Mathlib).

    Sub-lemma 331/N in T-5 Phase 7. NO STUBS. -/
theorem session_W2_phase_2_2_matDet_m2_to_m6_paper_bundle_headline :
    T5_matDetLemma_m2_to_m6_unconditional_paper_bundle :=
  T5_matDetLemma_m2_to_m6_unconditional_paper_bundle_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2ToM6_PaperBundle
