/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2: m = 2 Wronskian
  non-vanishing ALTERNATE WITNESS** (J 0 = const 0, J 1 = e_1).

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Alternative m=2 witness with cleaner formula `det = X_0 * P^2`
  (uniform sign across m, in contrast to the (-1)^(m-1) sign of
  the e_{i-1} witness).

  This witness generalizes uniformly to all m: J 0 = const 0, J i = e_i
  (standard basis at position i) for i ≥ 1. The determinant is
  `X_0 * P^m`, non-zero whenever P ≠ 0.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish

/-! ## Alternative witness (J 0 = const 0, J 1 = e_1) -/

/-- **m = 2 ALTERNATIVE Wronskian witness J**: J 0 = const 0, J 1 = ![0,1]. -/
noncomputable def m2_alt_witness_J : Fin 2 → (Fin 2 → ℕ) :=
  fun i => if i = 0 then (fun _ => 0) else (fun k => if k = 1 then 1 else 0)

theorem T5_m2_alt_witness_apply_zero (Q : MvPolynomial (Fin 2) ℝ) :
    multiIteratedPDeriv (m2_alt_witness_J 0) Q = Q := by
  unfold m2_alt_witness_J
  simp only [if_pos rfl]
  exact T5_multiIteratedPDeriv_zeroJ Q

theorem T5_m2_alt_witness_apply_one (Q : MvPolynomial (Fin 2) ℝ) :
    multiIteratedPDeriv (m2_alt_witness_J 1) Q = (pderiv 1) Q := by
  have h_J0 : m2_alt_witness_J 1 (0 : Fin 2) = 0 := by
    unfold m2_alt_witness_J; simp
  have h_J1 : m2_alt_witness_J 1 (1 : Fin 2) = 1 := by
    unfold m2_alt_witness_J; simp
  unfold multiIteratedPDeriv
  have h_eq : List.finRange 2 = [0, 1] := by decide
  rw [h_eq]
  show (pderiv 0)^[m2_alt_witness_J 1 0]
        ((pderiv 1)^[m2_alt_witness_J 1 1] Q) = pderiv 1 Q
  rw [h_J0, h_J1]
  rfl

/-! ## Wronskian matrix entries -/

theorem T5_m2_alt_wronskian_entry_00 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_alt_witness_J 0 0 = (X 0 : MvPolynomial (Fin 2) ℝ) * P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  exact T5_m2_alt_witness_apply_zero _

theorem T5_m2_alt_wronskian_entry_01 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_alt_witness_J 0 1 = (X 1 : MvPolynomial (Fin 2) ℝ) * P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  exact T5_m2_alt_witness_apply_zero _

theorem T5_m2_alt_wronskian_entry_10 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_alt_witness_J 1 0 =
      (X 0 : MvPolynomial (Fin 2) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m2_alt_witness_apply_one]
  exact T5_pderiv_X_mul_neq P 0 1 (by decide : (1 : Fin 2) ≠ 0)

theorem T5_m2_alt_wronskian_entry_11 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_alt_witness_J 1 1 =
      P + (X 1 : MvPolynomial (Fin 2) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m2_alt_witness_apply_one]
  exact T5_pderiv_X_mul_eq P 1

/-! ## Determinant via Matrix.det_fin_two — CLEANER FORMULA -/

/-- **m = 2 Wronskian determinant (alternate witness)** = `X 0 * P^2`. -/
theorem T5_m2_alt_wronskian_det (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskian 2 P m2_alt_witness_J = (X 0 : MvPolynomial (Fin 2) ℝ) * P^2 := by
  unfold mvPolyWronskian
  rw [Matrix.det_fin_two]
  rw [T5_m2_alt_wronskian_entry_00, T5_m2_alt_wronskian_entry_01,
      T5_m2_alt_wronskian_entry_10, T5_m2_alt_wronskian_entry_11]
  ring

/-- **🚨 m = 2 Wronskian non-vanishing (alternate)** — direct construction. -/
theorem T5_m2_alt_wronskian_ne_zero (P : MvPolynomial (Fin 2) ℝ) (hP : P ≠ 0) :
    mvPolyWronskian 2 P m2_alt_witness_J ≠ 0 := by
  rw [T5_m2_alt_wronskian_det]
  apply mul_ne_zero
  · exact MvPolynomial.X_ne_zero 0
  · exact pow_ne_zero 2 hP

/-! ## Headline -/

/-- **🚨 HEADLINE — m=2 ALTERNATIVE Wronskian non-vanishing CONCRETE WITNESS**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 m=2 ALT closure step.

    Direct construction with witness J 0 = (0,0), J 1 = (0,1):
    1. `T5_m2_alt_wronskian_det` — explicit det = X 0 * P²  (clean +1 sign)
    2. `T5_m2_alt_wronskian_ne_zero` — non-vanishing via integral domain

    The alternative (J 0 = const 0, J i = e_i) witness pattern gives
    a UNIFORM clean formula `det = X_0 * P^m` for ALL m (no sign variation).

    Sub-lemma 309/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_m2_alt_witness_headline :
    ∀ (P : MvPolynomial (Fin 2) ℝ), P ≠ 0 →
      mvPolyWronskian 2 P m2_alt_witness_J ≠ 0 :=
  fun P hP => T5_m2_alt_wronskian_ne_zero P hP

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness
