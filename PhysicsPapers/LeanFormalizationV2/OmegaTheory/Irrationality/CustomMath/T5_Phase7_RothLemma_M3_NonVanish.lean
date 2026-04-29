/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2: m = 3 Wronskian
  non-vanishing CONCRETE WITNESS**.

  Single-thread hand-authored 2026-04-29.

  Key construction: for `P : MvPolynomial (Fin 3) ℝ` non-zero,
  with `J 0 = (0,0,0)`, `J 1 = (1,0,0)`, `J 2 = (0,1,0)`, we have
  `mvPolyWronskian 3 P J = X 2 * P^3`, which is non-zero in
  the integral domain `MvPolynomial (Fin 3) ℝ`.

  This discharges the m=3 instance of `T5_RothLemma_WronskianNonVanish_Statement`
  unconditionally.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish

/-! ## Concrete witness construction -/

/-- **m = 3 Wronskian witness J**: J 0 = const 0, J 1 = ![1,0,0], J 2 = ![0,1,0]. -/
noncomputable def m3_witness_J : Fin 3 → (Fin 3 → ℕ) := fun i =>
  if i = 0 then (fun _ => 0)
  else if i = 1 then (fun k => if k = 0 then 1 else 0)
  else (fun k => if k = 1 then 1 else 0)

/-! ## multiIteratedPDeriv reductions -/

/-- `multiIteratedPDeriv (m3_witness_J 0) Q = Q`. -/
theorem T5_m3_witness_apply_zero (Q : MvPolynomial (Fin 3) ℝ) :
    multiIteratedPDeriv (m3_witness_J 0) Q = Q := by
  unfold m3_witness_J
  simp only [if_pos rfl]
  exact T5_multiIteratedPDeriv_zeroJ Q

/-- `multiIteratedPDeriv (m3_witness_J 1) Q = pderiv 0 Q`. -/
theorem T5_m3_witness_apply_one (Q : MvPolynomial (Fin 3) ℝ) :
    multiIteratedPDeriv (m3_witness_J 1) Q = (pderiv 0) Q := by
  -- Step 1: rewrite m3_witness_J 1 to a clean functional form
  have h_J0 : m3_witness_J 1 (0 : Fin 3) = 1 := by
    unfold m3_witness_J; simp
  have h_J1 : m3_witness_J 1 (1 : Fin 3) = 0 := by
    unfold m3_witness_J; simp
  have h_J2 : m3_witness_J 1 (2 : Fin 3) = 0 := by
    unfold m3_witness_J; simp
  -- Step 2: unfold multiIteratedPDeriv
  unfold multiIteratedPDeriv
  -- Step 3: rewrite List.finRange 3
  have h_eq : List.finRange 3 = [0, 1, 2] := by decide
  rw [h_eq]
  -- Step 4: simplify foldr step by step
  show (pderiv 0)^[m3_witness_J 1 0]
        ((pderiv 1)^[m3_witness_J 1 1]
          ((pderiv 2)^[m3_witness_J 1 2] Q)) = pderiv 0 Q
  rw [h_J0, h_J1, h_J2]
  -- (pderiv 0)^[1] ((pderiv 1)^[0] ((pderiv 2)^[0] Q)) = pderiv 0 Q
  rfl

/-- `multiIteratedPDeriv (m3_witness_J 2) Q = pderiv 1 Q`. -/
theorem T5_m3_witness_apply_two (Q : MvPolynomial (Fin 3) ℝ) :
    multiIteratedPDeriv (m3_witness_J 2) Q = (pderiv 1) Q := by
  have h_J0 : m3_witness_J 2 (0 : Fin 3) = 0 := by
    unfold m3_witness_J; simp
  have h_J1 : m3_witness_J 2 (1 : Fin 3) = 1 := by
    unfold m3_witness_J; simp
  have h_J2 : m3_witness_J 2 (2 : Fin 3) = 0 := by
    unfold m3_witness_J; simp
  unfold multiIteratedPDeriv
  have h_eq : List.finRange 3 = [0, 1, 2] := by decide
  rw [h_eq]
  show (pderiv 0)^[m3_witness_J 2 0]
        ((pderiv 1)^[m3_witness_J 2 1]
          ((pderiv 2)^[m3_witness_J 2 2] Q)) = pderiv 1 Q
  rw [h_J0, h_J1, h_J2]
  rfl

/-! ## Wronskian matrix entries -/

/-- Row 0 of m3 Wronskian matrix. -/
theorem T5_m3_wronskian_entry_0j (P : MvPolynomial (Fin 3) ℝ) (j : Fin 3) :
    mvPolyWronskianMatrix 3 P m3_witness_J 0 j = (X j : MvPolynomial (Fin 3) ℝ) * P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  exact T5_m3_witness_apply_zero _

/-- Row 1 entries via pderiv 0. -/
theorem T5_m3_wronskian_entry_1_eq (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_witness_J 1 0 =
      P + (X 0 : MvPolynomial (Fin 3) ℝ) * (pderiv 0) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m3_witness_apply_one]
  exact T5_pderiv_X_mul_eq P 0

theorem T5_m3_wronskian_entry_1_neq_1 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_witness_J 1 1 =
      (X 1 : MvPolynomial (Fin 3) ℝ) * (pderiv 0) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m3_witness_apply_one]
  exact T5_pderiv_X_mul_neq P 1 0 (by decide : (0 : Fin 3) ≠ 1)

theorem T5_m3_wronskian_entry_1_neq_2 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_witness_J 1 2 =
      (X 2 : MvPolynomial (Fin 3) ℝ) * (pderiv 0) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m3_witness_apply_one]
  exact T5_pderiv_X_mul_neq P 2 0 (by decide : (0 : Fin 3) ≠ 2)

/-- Row 2 entries via pderiv 1. -/
theorem T5_m3_wronskian_entry_2_neq_0 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_witness_J 2 0 =
      (X 0 : MvPolynomial (Fin 3) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m3_witness_apply_two]
  exact T5_pderiv_X_mul_neq P 0 1 (by decide : (1 : Fin 3) ≠ 0)

theorem T5_m3_wronskian_entry_2_eq (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_witness_J 2 1 =
      P + (X 1 : MvPolynomial (Fin 3) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m3_witness_apply_two]
  exact T5_pderiv_X_mul_eq P 1

theorem T5_m3_wronskian_entry_2_neq_2 (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskianMatrix 3 P m3_witness_J 2 2 =
      (X 2 : MvPolynomial (Fin 3) ℝ) * (pderiv 1) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m3_witness_apply_two]
  exact T5_pderiv_X_mul_neq P 2 1 (by decide : (1 : Fin 3) ≠ 2)

/-! ## Determinant computation via Matrix.det_fin_three -/

/-- **m = 3 Wronskian determinant** = `X 2 * P^3`. -/
theorem T5_m3_wronskian_det (P : MvPolynomial (Fin 3) ℝ) :
    mvPolyWronskian 3 P m3_witness_J = (X 2 : MvPolynomial (Fin 3) ℝ) * P^3 := by
  unfold mvPolyWronskian
  rw [Matrix.det_fin_three]
  rw [T5_m3_wronskian_entry_0j P 0, T5_m3_wronskian_entry_0j P 1, T5_m3_wronskian_entry_0j P 2,
      T5_m3_wronskian_entry_1_eq, T5_m3_wronskian_entry_1_neq_1, T5_m3_wronskian_entry_1_neq_2,
      T5_m3_wronskian_entry_2_neq_0, T5_m3_wronskian_entry_2_eq, T5_m3_wronskian_entry_2_neq_2]
  ring

/-! ## Non-vanishing -/

/-- **🚨 m = 3 Wronskian non-vanishing** — direct construction. -/
theorem T5_m3_wronskian_ne_zero (P : MvPolynomial (Fin 3) ℝ) (hP : P ≠ 0) :
    mvPolyWronskian 3 P m3_witness_J ≠ 0 := by
  rw [T5_m3_wronskian_det]
  apply mul_ne_zero
  · exact MvPolynomial.X_ne_zero 2
  · exact pow_ne_zero 3 hP

/-! ## m = 3 instance of WronskianNonVanish_Statement -/

/-- **🚨 W2.2-m=3 — m=3 instance of Wronskian non-vanishing**. -/
theorem T5_RothWronskian_m3 (P : MvPolynomial (Fin 3) ℝ) (hP : P ≠ 0)
    (R : Fin 3 → ℕ) (_h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i) :
    ∃ (J : Fin 3 → (Fin 3 → ℕ)),
      (∀ i k, J i k ≤ R k) ∧
      mvPolyWronskian 3 P J ≠ 0 := by
  refine ⟨m3_witness_J, ?_, T5_m3_wronskian_ne_zero P hP⟩
  intro i k
  unfold m3_witness_J
  by_cases h_i0 : i = 0
  · simp [h_i0]
  · by_cases h_i1 : i = 1
    · simp [h_i0, h_i1]
      by_cases h_k : k = 0
      · simp [h_k]; exact h_R_pos 0
      · simp [h_k]
    · simp [h_i0, h_i1]
      by_cases h_k : k = 1
      · simp [h_k]; exact h_R_pos 1
      · simp [h_k]

/-! ## Headline -/

/-- **🚨 HEADLINE — m=3 Wronskian non-vanishing CONCRETE WITNESS**.

    🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 m=3 closure step.

    Direct construction with witness J 0 = (0,0,0), J 1 = (1,0,0), J 2 = (0,1,0):
    1. `T5_m3_wronskian_det` — explicit det = X_2 * P^3
    2. `T5_m3_wronskian_ne_zero` — non-vanishing via integral domain
    3. `T5_RothWronskian_m3` — m=3 instance of WronskianNonVanish

    Pattern emerging: `det = (-1)^(m-1) * X_{m-1} * P^m` for the witness
    `J 0 = const 0, J i = e_{i-1} for i ≥ 1`.
    - m=1: X_0 * P (sign +1)
    - m=2: -X_1 * P^2 (sign -1)
    - m=3: X_2 * P^3 (sign +1)
    - m=4: -X_3 * P^4 (predicted)
    Pattern follows the cofactor expansion along the last column.

    Sub-lemma 305/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_2_m3_concrete_witness_headline :
    ∀ (P : MvPolynomial (Fin 3) ℝ), P ≠ 0 →
      mvPolyWronskian 3 P m3_witness_J ≠ 0 :=
  fun P hP => T5_m3_wronskian_ne_zero P hP

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish
