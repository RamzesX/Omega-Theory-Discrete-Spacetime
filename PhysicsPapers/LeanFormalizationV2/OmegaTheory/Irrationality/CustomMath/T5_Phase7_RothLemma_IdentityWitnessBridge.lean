/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IdentityWitnessBridge

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 IDENTITY WITNESS BRIDGE**.

  Single-thread hand-authored 2026-04-29.

  ## Strategy

  Prove the connection between abstract `mvPolyWronskian m P (identityWitnessJ m)`
  and the concrete matrix det lemma matrix:
    mvPolyWronskian m P J_id = det(M)
  where M_{ij} = δ_{ij} P + (pderiv i P) · X j.

  Key step: `multiIteratedPDeriv (e_i) Q = pderiv i Q` for the unit
  multi-index e_i (the i-th row of the identity matrix).

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish_Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IdentityWitnessBridge

open MvPolynomial Matrix Finset List
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General

/-! ## Helper: foldr with unit vector reduces to single pderiv -/

/-- **Auxiliary**: `foldr (fun k q => (pderiv k)^[if i = k then 1 else 0] q) Q`
    over a `Nodup` list containing `i` reduces to `pderiv i Q`. -/
private theorem foldr_unitVec_eq {n : ℕ} (i : Fin n) :
    ∀ (l : List (Fin n)) (Q : MvPolynomial (Fin n) ℝ),
      l.Nodup → i ∈ l →
      l.foldr (fun k q => (pderiv k)^[if i = k then 1 else 0] q) Q = pderiv i Q
  | [], _, _, h_mem => by simp at h_mem
  | k :: l, Q, h_nodup, h_mem => by
    rw [List.foldr_cons]
    rcases List.mem_cons.mp h_mem with rfl | h_mem'
    · -- k = i: apply pderiv once, rest is identity
      rw [if_pos rfl]
      simp only [Function.iterate_one]
      -- Now show foldr over rest with i ∉ rest reduces to identity
      have h_not_mem : i ∉ l := (List.nodup_cons.mp h_nodup).1
      have h_id : l.foldr
          (fun k q => (pderiv k)^[if i = k then 1 else 0] q) Q = Q := by
        clear h_nodup h_mem
        induction l with
        | nil => simp
        | cons k' l' ih =>
          rw [List.foldr_cons]
          have h_not_mem' : i ∉ l' := fun h => h_not_mem (List.mem_cons.mpr (Or.inr h))
          have h_neq : i ≠ k' := fun h => h_not_mem (List.mem_cons.mpr (Or.inl h))
          rw [if_neg h_neq]
          simp only [Function.iterate_zero, id_eq]
          exact ih h_not_mem'
      rw [h_id]
    · -- k ≠ i: identity, recurse
      have h_neq : i ≠ k := fun h => (List.nodup_cons.mp h_nodup).1 (h ▸ h_mem')
      rw [if_neg h_neq]
      simp only [Function.iterate_zero, id_eq]
      exact foldr_unitVec_eq i l Q (List.nodup_cons.mp h_nodup).2 h_mem'

/-- **Identity-witness multi-pderiv** —
    `multiIteratedPDeriv (e_i) Q = pderiv i Q` where `e_i k = δ_{ik}`. -/
theorem T5_multiIteratedPDeriv_unitVec {n : ℕ} (i : Fin n) (Q : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv (fun k => if i = k then 1 else 0) Q = pderiv i Q := by
  unfold multiIteratedPDeriv
  exact foldr_unitVec_eq i (List.finRange n) Q (List.nodup_finRange n) (List.mem_finRange i)

/-! ## Identity-witness Wronskian = matrix det lemma matrix det -/

/-- Auxiliary: the Wronskian matrix entry under identity witness.
    `(mvPolyWronskianMatrix m P J_id) i j = pderiv i ((X j) * P)`. -/
theorem T5_mvPolyWronskianMatrix_identityWitness_apply {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ) (i j : Fin m) :
    mvPolyWronskianMatrix m P (identityWitnessJ m) i j =
    pderiv i ((X j : MvPolynomial (Fin m) ℝ) * P) := by
  unfold mvPolyWronskianMatrix identityWitnessJ
  simp only [Matrix.of_apply]
  exact T5_multiIteratedPDeriv_unitVec i ((X j) * P)

/-- Auxiliary: pderiv of `X j * P`. -/
theorem T5_pderiv_X_mul {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (i j : Fin m) :
    pderiv i ((X j : MvPolynomial (Fin m) ℝ) * P) =
    (if i = j then P else 0) + (X j) * pderiv i P := by
  rw [Derivation.leibniz]
  rw [MvPolynomial.pderiv_X]
  by_cases h : i = j
  · subst h
    rw [Pi.single_eq_same, if_pos rfl]
    simp [smul_eq_mul]
    ring
  · rw [Pi.single_eq_of_ne (Ne.symm h), if_neg h]
    simp [smul_eq_mul]

/-- **Identity-witness Wronskian matrix = matrix det lemma matrix** (up to commutativity). -/
theorem T5_mvPolyWronskianMatrix_identityWitness_eq {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ) :
    mvPolyWronskianMatrix m P (identityWitnessJ m) =
    Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j) := by
  ext i j
  rw [T5_mvPolyWronskianMatrix_identityWitness_apply]
  rw [T5_pderiv_X_mul]
  simp only [Matrix.of_apply]
  by_cases h : i = j
  · subst h
    rw [if_pos rfl]
    ring
  · rw [if_neg h]
    ring

/-- **🚨 BRIDGE: identity-witness Wronskian = matrix det lemma matrix det**.
    The full identification: `mvPolyWronskian m P J_id = det(M)`. -/
theorem T5_mvPolyWronskian_identityWitness_eq_matDet {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ) :
    mvPolyWronskian m P (identityWitnessJ m) =
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det := by
  unfold mvPolyWronskian
  rw [T5_mvPolyWronskianMatrix_identityWitness_eq]

/-! ## Headline: full discharge of T5_RothWronskianInductiveStep -/

/-- **🚨 HEADLINE — Identity-witness Wronskian non-vanish UNCONDITIONAL** —
    For any m ≥ 1, P ≠ 0, the identity-witness Wronskian is non-zero. -/
theorem T5_mvPolyWronskian_identityWitness_nonzero {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (hP : P ≠ 0) :
    mvPolyWronskian m P (identityWitnessJ m) ≠ 0 := by
  rw [T5_mvPolyWronskian_identityWitness_eq_matDet]
  exact T5_matDetLemma_general_nonzero hm P hP

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 ROTH WRONSKIAN INDUCTIVE STEP UNCONDITIONAL**.

    🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 INDUCTIVE STEP DISCHARGE.

    For any m ≥ 1, P : MvPolynomial (Fin m) ℝ non-zero, R-bounds with
    `∀ k, 0 < R k`, the identity witness `J_id i k = δ_{ik}` provides:
    - `∀ i k, J_id i k ≤ R k` (since R k ≥ 1)
    - `mvPolyWronskian m P J_id ≠ 0`

    This UNCONDITIONALLY discharges the existence side of the multivariate
    Wronskian non-vanish, including the inductive step. The bridge
    `T5_mvPolyWronskian_identityWitness_eq_matDet` reduces to
    `T5_matDetLemma_general` UNCONDITIONAL closure.

    Sub-lemma 323/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_wronskian_existence_full_discharge :
    ∀ {m : ℕ}, 1 ≤ m → ∀ (P : MvPolynomial (Fin m) ℝ), P ≠ 0 →
    ∀ (R : Fin m → ℕ), (∀ k, 0 < R k) →
    ∃ (J : Fin m → (Fin m → ℕ)),
      (∀ i k, J i k ≤ R k) ∧ mvPolyWronskian m P J ≠ 0 := by
  intro m hm P hP R hR
  refine ⟨identityWitnessJ m, ?_, T5_mvPolyWronskian_identityWitness_nonzero hm P hP⟩
  intro i k
  unfold identityWitnessJ
  by_cases h : i = k
  · rw [if_pos h]
    subst h
    exact hR i
  · rw [if_neg h]
    exact Nat.zero_le _

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IdentityWitnessBridge
