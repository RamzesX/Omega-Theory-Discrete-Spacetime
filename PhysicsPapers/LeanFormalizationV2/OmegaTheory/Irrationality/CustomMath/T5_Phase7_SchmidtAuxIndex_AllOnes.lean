/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_AllOnes

  T-5 (Roth's theorem) — **Generalized factor removal lemma**.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_FactorPreserved

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_AllOnes

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_FactorPreserved

/-! ## pderiv k (X k - C α) = 1 — direct -/

theorem T5_pderiv_self_X_sub_C {n : ℕ} (α : ℝ) (k : Fin n) :
    (pderiv k) (X k - C α : MvPolynomial (Fin n) ℝ) = 1 := by
  rw [map_sub]
  have h_X : (pderiv k) (X k : MvPolynomial (Fin n) ℝ) = 1 := by
    rw [MvPolynomial.pderiv_X]
    exact Pi.single_eq_same k 1
  have h_C : (pderiv k) (C α : MvPolynomial (Fin n) ℝ) = 0 := MvPolynomial.pderiv_C
  rw [h_X, h_C, sub_zero]

/-! ## pderiv k of ∏ over Finset S where k ∉ S gives 0 -/

theorem T5_pderiv_prod_zero {n : ℕ} (α : ℝ) (k : Fin n) (S : Finset (Fin n))
    (hk : k ∉ S) :
    (pderiv k) (∏ i ∈ S, (X i - C α : MvPolynomial (Fin n) ℝ)) = 0 := by
  classical
  induction S using Finset.induction_on with
  | empty => simp
  | @insert j S' h_notmem ih =>
    rw [Finset.prod_insert h_notmem]
    have h_jk : k ≠ j := fun h_eq => hk (h_eq ▸ Finset.mem_insert_self j S')
    have h_zero1 : (pderiv k) (X j - C α : MvPolynomial (Fin n) ℝ) = 0 := by
      have h_aux := T5_pderiv_preserves_X_factor α j k h_jk 1
      rw [mul_one, Derivation.map_one_eq_zero, mul_zero] at h_aux
      exact h_aux
    have h_zero2 : (pderiv k) (∏ i ∈ S', (X i - C α : MvPolynomial (Fin n) ℝ)) = 0 := by
      apply ih
      exact fun h => hk (Finset.mem_insert_of_mem h)
    rw [Derivation.leibniz, h_zero1, h_zero2]
    simp

/-! ## pderiv k of prod over S (with k ∈ S) gives prod over S.erase k -/

theorem T5_pderiv_prod_factor_removal {n : ℕ} (α : ℝ) (k : Fin n)
    (S : Finset (Fin n)) (hk : k ∈ S) :
    (pderiv k) (∏ i ∈ S, (X i - C α : MvPolynomial (Fin n) ℝ)) =
      ∏ i ∈ S.erase k, (X i - C α : MvPolynomial (Fin n) ℝ) := by
  classical
  have h_S : S = insert k (S.erase k) := (Finset.insert_erase hk).symm
  conv_lhs => rw [h_S]
  rw [Finset.prod_insert (Finset.notMem_erase k _)]
  rw [Derivation.leibniz]
  rw [T5_pderiv_self_X_sub_C]
  rw [T5_pderiv_prod_zero α k _ (Finset.notMem_erase k _)]
  simp [smul_eq_mul]

/-! ## All-ones discharge: foldr applies factor removal n times -/

/-- Auxiliary: foldr applying pderiv at each list element to a product
    over a Finset, where the list elements are in the Finset and distinct,
    gives the product over the Finset minus the list. -/
theorem T5_foldr_factor_removal {n : ℕ} (α : ℝ) (l : List (Fin n))
    (l_nodup : l.Nodup) (S : Finset (Fin n)) (h_subset : ∀ i ∈ l, i ∈ S) :
    l.foldr (fun i q => (pderiv i) q)
      (∏ i ∈ S, (X i - C α : MvPolynomial (Fin n) ℝ)) =
      ∏ i ∈ S \ l.toFinset, (X i - C α : MvPolynomial (Fin n) ℝ) := by
  classical
  induction l generalizing S with
  | nil => simp
  | cons head tail ih =>
    rw [List.foldr_cons]
    -- foldr tail step P over S = ∏ i ∈ S \ tail.toFinset, ...
    have h_tail_nodup : tail.Nodup := l_nodup.of_cons
    have h_tail_subset : ∀ i ∈ tail, i ∈ S :=
      fun i hi => h_subset i (List.mem_cons_of_mem head hi)
    rw [ih h_tail_nodup S h_tail_subset]
    -- Now: pderiv head (∏ i ∈ S \ tail.toFinset, ...) = ?
    -- head ∈ S, head ∉ tail (by nodup), so head ∈ S \ tail.toFinset
    have h_head_in_S : head ∈ S := h_subset head (by simp)
    have h_head_not_in_tail : head ∉ tail := by
      have := l_nodup
      rw [List.nodup_cons] at this
      exact this.1
    have h_head_not_in_tail_toFinset : head ∉ tail.toFinset := by
      simpa using h_head_not_in_tail
    have h_head_in_diff : head ∈ S \ tail.toFinset := by
      rw [Finset.mem_sdiff]
      exact ⟨h_head_in_S, h_head_not_in_tail_toFinset⟩
    rw [T5_pderiv_prod_factor_removal α head _ h_head_in_diff]
    congr 1
    -- (S \ tail.toFinset).erase head = S \ (head :: tail).toFinset
    rw [List.toFinset_cons]
    ext i
    simp [Finset.mem_erase, Finset.mem_sdiff, Finset.mem_insert]
    tauto

/-! ## All-ones theorem -/

theorem T5_AllOnes_discharge (m : ℕ) (α : ℝ) :
    multiIteratedPDeriv (fun _ : Fin m => 1) (T5_schmidtAuxPoly_general m α) = 1 := by
  unfold multiIteratedPDeriv T5_schmidtAuxPoly_general
  -- (pderiv k)^[1] = pderiv k for our const-1 function
  -- Rewrite the foldr argument to remove the iterate
  have h_eq : (fun (k : Fin m) (q : MvPolynomial (Fin m) ℝ) =>
        (⇑(pderiv k))^[(fun _ : Fin m => 1) k] q)
      = (fun (k : Fin m) (q : MvPolynomial (Fin m) ℝ) => (pderiv k) q) := by
    funext k q
    simp
  rw [h_eq]
  rw [T5_foldr_factor_removal α (List.finRange m) (List.nodup_finRange m) Finset.univ
      (fun i _ => Finset.mem_univ i)]
  have h_full : (List.finRange m).toFinset = (Finset.univ : Finset (Fin m)) := by
    ext i; simp
  rw [h_full]
  simp

/-! ## All-ones non-zero NAMED — fully discharged -/

theorem T5_SchmidtAuxIndex_AllOnesNonZero_unconditional :
    T5_SchmidtAuxIndex_AllOnesNonZero_NAMED := by
  intros m α
  rw [T5_AllOnes_discharge]
  simp

/-! ## Headline -/

/-- **🚨 HEADLINE — m=3 + m≥4 ALL-ONES NON-ZERO FULLY DISCHARGED**.

    🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 m≥3 closure step.

    Combined with `T5_SchmidtAuxIndex_factor_preserved_unconditional`,
    this gives **full m=3 + m≥4 closure** via the general scaffold!

    Key structural lemmas:
    1. T5_pderiv_self_X_sub_C — pderiv k (X k - C α) = 1
    2. T5_pderiv_prod_zero — pderiv k of ∏ where k ∉ S gives 0
    3. T5_pderiv_prod_factor_removal — pderiv k of ∏ where k ∈ S gives
       ∏ over S.erase k (one factor removed)
    4. T5_foldr_factor_removal — iterating factor removal via foldr
       gives ∏ over S \ list.toFinset
    5. T5_AllOnes_discharge — all-ones case: foldr removes all factors,
       result = empty product = 1
    6. T5_SchmidtAuxIndex_AllOnesNonZero_unconditional — discharge the NAMED.

    Sub-lemma 301/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_4_allones_discharge_headline :
    T5_SchmidtAuxIndex_AllOnesNonZero_NAMED :=
  T5_SchmidtAuxIndex_AllOnesNonZero_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_AllOnes
