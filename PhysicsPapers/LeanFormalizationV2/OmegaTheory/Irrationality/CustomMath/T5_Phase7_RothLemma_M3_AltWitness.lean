/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2: m = 3 Wronskian
  non-vanishing ALTERNATE WITNESS** (J 0 = const 0, J i = e_i).

  Single-thread hand-authored 2026-04-29.

  Continues the alt-witness pattern from `T5_Phase7_RothLemma_M2_AltWitness`:
  for J 0 = const 0, J 1 = e_1, J 2 = e_2, the determinant is
  `X 0 * P^3` (uniform sign +1, contrast with (-1)^(m-1) of e_{i-1} witness).

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness

/-! ## m = 3 alt witness (J 0 = const 0, J 1 = e_1, J 2 = e_2) -/

noncomputable def m3_alt_witness_J : Fin 3 → (Fin 3 → ℕ) := fun i =>
  if i = 0 then (fun _ => 0)
  else if i = 1 then (fun k => if k = 1 then 1 else 0)
  else (fun k => if k = 2 then 1 else 0)

theorem T5_m3_alt_witness_apply_zero (Q : MvPolynomial (Fin 3) ℝ) :
    multiIteratedPDeriv (m3_alt_witness_J 0) Q = Q := by
  unfold m3_alt_witness_J
  simp only [if_pos rfl]
  exact T5_multiIteratedPDeriv_zeroJ Q

theorem T5_m3_alt_witness_apply_one (Q : MvPolynomial (Fin 3) ℝ) :
    multiIteratedPDeriv (m3_alt_witness_J 1) Q = (pderiv 1) Q := by
  have h_J0 : m3_alt_witness_J 1 (0 : Fin 3) = 0 := by
    unfold m3_alt_witness_J; simp
  have h_J1 : m3_alt_witness_J 1 (1 : Fin 3) = 1 := by
    unfold m3_alt_witness_J; simp
  have h_J2 : m3_alt_witness_J 1 (2 : Fin 3) = 0 := by
    unfold m3_alt_witness_J; simp
  unfold multiIteratedPDeriv
  have h_eq : List.finRange 3 = [0, 1, 2] := by decide
  rw [h_eq]
  show (pderiv 0)^[m3_alt_witness_J 1 0]
        ((pderiv 1)^[m3_alt_witness_J 1 1]
          ((pderiv 2)^[m3_alt_witness_J 1 2] Q)) = pderiv 1 Q
  rw [h_J0, h_J1, h_J2]
  rfl

theorem T5_m3_alt_witness_apply_two (Q : MvPolynomial (Fin 3) ℝ) :
    multiIteratedPDeriv (m3_alt_witness_J 2) Q = (pderiv 2) Q := by
  have h_J0 : m3_alt_witness_J 2 (0 : Fin 3) = 0 := by
    unfold m3_alt_witness_J; simp
  have h_J1 : m3_alt_witness_J 2 (1 : Fin 3) = 0 := by
    unfold m3_alt_witness_J; simp
  have h_J2 : m3_alt_witness_J 2 (2 : Fin 3) = 1 := by
    unfold m3_alt_witness_J; simp
  unfold multiIteratedPDeriv
  have h_eq : List.finRange 3 = [0, 1, 2] := by decide
  rw [h_eq]
  show (pderiv 0)^[m3_alt_witness_J 2 0]
        ((pderiv 1)^[m3_alt_witness_J 2 1]
          ((pderiv 2)^[m3_alt_witness_J 2 2] Q)) = pderiv 2 Q
  rw [h_J0, h_J1, h_J2]
  rfl

/-! ## Wronskian matrix entries -/

theorem T5_m3_alt_wronskian_entry_0j (P : MvPolynomial (Fin 3) ℝ) (j : Fin 3) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 0 j = (X j : MvPolynomial (Fin 3) ℝ) * P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  exact T5_m3_alt_witness_apply_zero _

theorem T5_m3_alt_wronskian_entry_1_0 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 1 0 =
      (X 0 : MvPolynomial (Fin 3) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m3_alt_witness_apply_one]
  exact T5_pderiv_X_mul_neq P 0 1 (by decide : (1 : Fin 3) ≠ 0)

theorem T5_m3_alt_wronskian_entry_1_1 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 1 1 =
      P + (X 1 : MvPolynomial (Fin 3) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m3_alt_witness_apply_one]
  exact T5_pderiv_X_mul_eq P 1

theorem T5_m3_alt_wronskian_entry_1_2 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 1 2 =
      (X 2 : MvPolynomial (Fin 3) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m3_alt_witness_apply_one]
  exact T5_pderiv_X_mul_neq P 2 1 (by decide : (1 : Fin 3) ≠ 2)

theorem T5_m3_alt_wronskian_entry_2_0 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 2 0 =
      (X 0 : MvPolynomial (Fin 3) ℝ) * (pderiv 2) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m3_alt_witness_apply_two]
  exact T5_pderiv_X_mul_neq P 0 2 (by decide : (2 : Fin 3) ≠ 0)

theorem T5_m3_alt_wronskian_entry_2_1 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 2 1 =
      (X 1 : MvPolynomial (Fin 3) ℝ) * (pderiv 2) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m3_alt_witness_apply_two]
  exact T5_pderiv_X_mul_neq P 1 2 (by decide : (2 : Fin 3) ≠ 1)

theorem T5_m3_alt_wronskian_entry_2_2 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_alt_witness_J 2 2 =
      P + (X 2 : MvPolynomial (Fin 3) ℝ) * (pderiv 2) P := by
  unfold mvPolyWronskianMatrix; simp only [Matrix.of_apply]
  rw [T5_m3_alt_witness_apply_two]
  exact T5_pderiv_X_mul_eq P 2

/-! ## Determinant computation — det = X 0 * P^3 -/

theorem T5_m3_alt_wronskian_det (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskian 3 P m3_alt_witness_J = (X 0 : MvPolynomial (Fin 3) ℝ) * P^3 := by
  unfold mvPolyWronskian
  rw [Matrix.det_fin_three]
  rw [T5_m3_alt_wronskian_entry_0j P 0, T5_m3_alt_wronskian_entry_0j P 1,
      T5_m3_alt_wronskian_entry_0j P 2,
      T5_m3_alt_wronskian_entry_1_0, T5_m3_alt_wronskian_entry_1_1,
      T5_m3_alt_wronskian_entry_1_2,
      T5_m3_alt_wronskian_entry_2_0, T5_m3_alt_wronskian_entry_2_1,
      T5_m3_alt_wronskian_entry_2_2]
  ring

theorem T5_m3_alt_wronskian_ne_zero (P : MvPolynomial (Fin 3) ℝ) (hP : P ≠ 0) :
    mvPolyWronskian 3 P m3_alt_witness_J ≠ 0 := by
  rw [T5_m3_alt_wronskian_det]
  apply mul_ne_zero
  · exact MvPolynomial.X_ne_zero 0
  · exact pow_ne_zero 3 hP

/-! ## Headline -/

/-- **🚨 HEADLINE — m=3 ALTERNATIVE Wronskian non-vanishing CONCRETE WITNESS**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 m=3 ALT closure step.

    Direct construction with witness J 0 = (0,0,0), J 1 = (0,1,0), J 2 = (0,0,1):
    1. `T5_m3_alt_wronskian_det` — explicit det = X 0 * P³  (clean +1 sign)
    2. `T5_m3_alt_wronskian_ne_zero` — non-vanishing via integral domain

    Pattern with alt-witness (J 0 = const 0, J i = e_i): det = X_0 · P^m.
    - m=2: X 0 · P²
    - m=3: X 0 · P³
    - Predicted m≥2: X 0 · P^m (uniform sign +1)

    Sub-lemma 310/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_m3_alt_witness_headline :
    ∀ (P : MvPolynomial (Fin 3) ℝ), P ≠ 0 →
      mvPolyWronskian 3 P m3_alt_witness_J ≠ 0 :=
  fun P hP => T5_m3_alt_wronskian_ne_zero P hP

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness
