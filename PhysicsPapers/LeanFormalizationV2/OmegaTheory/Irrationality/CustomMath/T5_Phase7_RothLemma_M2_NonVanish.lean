/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2: m = 2 Wronskian
  non-vanishing CONCRETE WITNESS**.

  Single-thread hand-authored 2026-04-29.

  Key construction: for `P : MvPolynomial (Fin 2) ℝ` non-zero,
  with `J 0 = (0,0)` and `J 1 = (1,0)`, we have
  `mvPolyWronskian 2 P J = -X 1 * P^2`, which is non-zero in
  the integral domain `MvPolynomial (Fin 2) ℝ`.

  This discharges the m=2 instance of `T5_RothLemma_WronskianNonVanish_Statement`
  unconditionally.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

/-! ## Concrete witness construction -/

/-- **m = 2 Wronskian witness J**: J 0 = const 0, J 1 = ![1, 0]. -/
noncomputable def m2_witness_J : Fin 2 → (Fin 2 → ℕ) :=
  fun i => if i = 0 then (fun _ => 0) else (fun k => if k = 0 then 1 else 0)

/-! ## Pderiv of (X j * P) helper -/

/-- For `j ≠ k`: `pderiv k (X j * P) = X j * pderiv k P`. -/
theorem T5_pderiv_X_mul_neq {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (j k : Fin n)
    (h : k ≠ j) :
    (pderiv k) ((X j : MvPolynomial (Fin n) ℝ) * P) =
      (X j : MvPolynomial (Fin n) ℝ) * (pderiv k) P := by
  rw [Derivation.leibniz]
  have h_zero : (pderiv k) (X j : MvPolynomial (Fin n) ℝ) = 0 := by
    rw [MvPolynomial.pderiv_X]
    simp [Pi.single_eq_of_ne (Ne.symm h)]
  rw [h_zero]
  simp [smul_eq_mul]

/-- For `j = k`: `pderiv k (X k * P) = P + X k * pderiv k P`. -/
theorem T5_pderiv_X_mul_eq {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (k : Fin n) :
    (pderiv k) ((X k : MvPolynomial (Fin n) ℝ) * P) =
      P + (X k : MvPolynomial (Fin n) ℝ) * (pderiv k) P := by
  rw [Derivation.leibniz]
  have h_one : (pderiv k) (X k : MvPolynomial (Fin n) ℝ) = 1 := by
    rw [MvPolynomial.pderiv_X]
    exact Pi.single_eq_same k 1
  rw [h_one]
  simp [smul_eq_mul]
  ring

/-! ## multiIteratedPDeriv with witness J — concrete reduction -/

/-- `multiIteratedPDeriv (m2_witness_J 0) Q = Q` (zero multi-index). -/
theorem T5_m2_witness_apply_zero (Q : MvPolynomial (Fin 2) ℝ) :
    multiIteratedPDeriv (m2_witness_J 0) Q = Q := by
  unfold m2_witness_J
  simp only [if_pos rfl]
  exact T5_multiIteratedPDeriv_zeroJ Q

/-- `multiIteratedPDeriv (m2_witness_J 1) Q = pderiv 0 Q`. -/
theorem T5_m2_witness_apply_one (Q : MvPolynomial (Fin 2) ℝ) :
    multiIteratedPDeriv (m2_witness_J 1) Q = (pderiv 0) Q := by
  unfold m2_witness_J multiIteratedPDeriv
  simp only [if_neg (by decide : (1 : Fin 2) ≠ 0)]
  -- (List.finRange 2).foldr (fun k q => (pderiv k)^[J k] q) Q
  -- with J k = if k = 0 then 1 else 0
  -- = (pderiv 0)^[1] ((pderiv 1)^[0] Q) = pderiv 0 Q
  have h_eq : List.finRange 2 = [0, 1] := by decide
  rw [h_eq]
  simp [Function.iterate_one]

/-! ## Wronskian matrix entries explicit -/

/-- Wronskian matrix entries with `m2_witness_J`. -/
theorem T5_m2_wronskian_entry_00 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_witness_J 0 0 = (X 0 : MvPolynomial (Fin 2) ℝ) * P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  exact T5_m2_witness_apply_zero _

theorem T5_m2_wronskian_entry_01 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_witness_J 0 1 = (X 1 : MvPolynomial (Fin 2) ℝ) * P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  exact T5_m2_witness_apply_zero _

theorem T5_m2_wronskian_entry_10 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_witness_J 1 0 =
      P + (X 0 : MvPolynomial (Fin 2) ℝ) * (pderiv 0) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m2_witness_apply_one]
  exact T5_pderiv_X_mul_eq P 0

theorem T5_m2_wronskian_entry_11 (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskianMatrix 2 P m2_witness_J 1 1 =
      (X 1 : MvPolynomial (Fin 2) ℝ) * (pderiv 0) P := by
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [T5_m2_witness_apply_one]
  exact T5_pderiv_X_mul_neq P 1 0 (by decide : (0 : Fin 2) ≠ 1)

/-! ## Wronskian determinant formula -/

/-- **m = 2 Wronskian determinant** = `-(X 1) * P^2`. -/
theorem T5_m2_wronskian_det (P : MvPolynomial (Fin 2) ℝ) :
    mvPolyWronskian 2 P m2_witness_J =
      -(X 1 : MvPolynomial (Fin 2) ℝ) * P^2 := by
  unfold mvPolyWronskian
  rw [Matrix.det_fin_two]
  rw [T5_m2_wronskian_entry_00, T5_m2_wronskian_entry_01,
      T5_m2_wronskian_entry_10, T5_m2_wronskian_entry_11]
  ring

/-! ## Non-vanishing -/

/-- **🚨 m = 2 Wronskian non-vanishing** — direct construction. -/
theorem T5_m2_wronskian_ne_zero (P : MvPolynomial (Fin 2) ℝ) (hP : P ≠ 0) :
    mvPolyWronskian 2 P m2_witness_J ≠ 0 := by
  rw [T5_m2_wronskian_det]
  -- -(X 1) * P^2 ≠ 0
  apply mul_ne_zero
  · -- -(X 1) ≠ 0
    rw [neg_ne_zero]
    exact MvPolynomial.X_ne_zero 1
  · -- P^2 ≠ 0
    exact pow_ne_zero 2 hP

/-! ## m = 2 instance of WronskianNonVanish_Statement -/

/-- **🚨 W2.2-m=2 — m=2 instance of Wronskian non-vanishing**. -/
theorem T5_RothWronskian_m2 (P : MvPolynomial (Fin 2) ℝ) (hP : P ≠ 0)
    (R : Fin 2 → ℕ) (_h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i) :
    ∃ (J : Fin 2 → (Fin 2 → ℕ)),
      (∀ i k, J i k ≤ R k) ∧
      mvPolyWronskian 2 P J ≠ 0 := by
  refine ⟨m2_witness_J, ?_, T5_m2_wronskian_ne_zero P hP⟩
  intro i k
  unfold m2_witness_J
  by_cases h_i : i = 0
  · simp [h_i]
  · simp [h_i]
    by_cases h_k : k = 0
    · simp [h_k]
      exact h_R_pos 0
    · simp [h_k]

/-! ## Headline -/

/-- **🚨 HEADLINE — m=2 Wronskian non-vanishing CONCRETE WITNESS**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 m=2 closure step.

    Direct construction with witness J 0 = (0,0), J 1 = (1,0):
    1. `T5_m2_wronskian_det` — explicit det = -(X 1) * P^2
    2. `T5_m2_wronskian_ne_zero` — non-vanishing via integral domain
    3. `T5_RothWronskian_m2` — m=2 instance of WronskianNonVanish

    This handles m=2 UNCONDITIONALLY without invoking the inductive
    step. Combined with m=1 base, gives partial closure of
    `T5_RothLemma_WronskianNonVanish_Statement` for m ≤ 2.

    The general m case still requires the inductive step
    `T5_RothWronskianInductiveStep` for the m ≥ 3 closure.

    Sub-lemma 304/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_2_m2_concrete_witness_headline :
    ∀ (P : MvPolynomial (Fin 2) ℝ), P ≠ 0 →
      mvPolyWronskian 2 P m2_witness_J ≠ 0 :=
  fun P hP => T5_m2_wronskian_ne_zero P hP

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
