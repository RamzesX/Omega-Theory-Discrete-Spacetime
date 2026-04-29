/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_Bundle

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 MATRIX DET LEMMA m≤3 BUNDLE**.

  Consolidates the m=2 and m=3 unconditional discharges of the matrix
  det lemma into a partial closure for m ≤ 3. Combined with Euler
  kernel (commit 7d950e3), gives the multivariate Wronskian non-vanish
  for the identity-witness construction at m=2 and m=3.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_Bundle

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_M3

/-! ## Bundle: m=2 + m=3 matrix det lemma — UNCONDITIONAL -/

/-- **`T5_MatDetLemma_m_le_3_unconditional`** — 4-conjunct paper bundle:
    matrix det lemma + Wronskian non-vanish for m ∈ {2, 3} unconditionally. -/
def T5_MatDetLemma_m_le_3_unconditional : Prop :=
  -- (a) m=2 formula
  (∀ (P : MvPolynomial (Fin 2) ℝ),
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P * (P + ∑ i : Fin 2, X i * pderiv i P)) ∧
  -- (b) m=2 non-vanishing
  (∀ (P : MvPolynomial (Fin 2) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 2) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0) ∧
  -- (c) m=3 formula
  (∀ (P : MvPolynomial (Fin 3) ℝ),
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^2 * (P + ∑ i : Fin 3, X i * pderiv i P)) ∧
  -- (d) m=3 non-vanishing
  (∀ (P : MvPolynomial (Fin 3) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin 3) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0)

theorem T5_MatDetLemma_m_le_3_unconditional_holds :
    T5_MatDetLemma_m_le_3_unconditional :=
  ⟨T5_matDetLemma_m2,
   T5_matDetLemma_m2_nonzero,
   T5_matDetLemma_m3,
   T5_matDetLemma_m3_nonzero⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — m≤3 MATRIX DET LEMMA UNCONDITIONAL BUNDLE**.

    🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 m≤3 unconditional.

    4-conjunct paper-grade bundle:
    1. m=2 formula: det = P · (P + ∑ X_i · d_iP)
    2. m=2 non-vanish for P ≠ 0
    3. m=3 formula: det = P² · (P + ∑ X_i · d_iP)
    4. m=3 non-vanish for P ≠ 0

    Combined with Euler kernel (UNCONDITIONAL) gives the multivariate
    Wronskian non-vanish for m ≤ 3 via the identity-witness construction.

    Sub-lemma 319/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_matdet_lemma_m_le_3_bundle_headline :
    T5_MatDetLemma_m_le_3_unconditional :=
  T5_MatDetLemma_m_le_3_unconditional_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_Bundle
