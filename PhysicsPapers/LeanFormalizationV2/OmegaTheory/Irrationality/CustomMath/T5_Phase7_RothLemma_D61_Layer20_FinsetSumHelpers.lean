/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer20_FinsetSumHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 20: Finset sum helpers (extended)**.

  Foundational sub-lemmas for Finset sum manipulations beyond Layer 4.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer20_FinsetSumHelpers

open Finset

/-! ## FS-1 — Empty finset sum is zero -/

theorem T5_finset_sum_empty {α : Type*} (f : α → ℝ) :
    ∑ i ∈ (∅ : Finset α), f i = 0 := Finset.sum_empty

/-! ## FS-2 — Singleton finset sum -/

theorem T5_finset_sum_singleton {α : Type*} [DecidableEq α] (a : α) (f : α → ℝ) :
    ∑ i ∈ ({a} : Finset α), f i = f a := Finset.sum_singleton _ _

/-! ## FS-3 — Sum over union (disjoint) -/

theorem T5_finset_sum_union {α : Type*} [DecidableEq α]
    (s t : Finset α) (h_disj : Disjoint s t) (f : α → ℝ) :
    ∑ i ∈ s ∪ t, f i = (∑ i ∈ s, f i) + (∑ i ∈ t, f i) :=
  Finset.sum_union h_disj

/-! ## FS-4 — Sum const -/

theorem T5_finset_sum_const {α : Type*} (s : Finset α) (c : ℝ) :
    ∑ _i ∈ s, c = (s.card : ℝ) * c := by
  rw [Finset.sum_const]
  simp [nsmul_eq_mul]

/-! ## FS-5 — Sum of zero is zero -/

theorem T5_finset_sum_zero {α : Type*} (s : Finset α) :
    ∑ _i ∈ s, (0 : ℝ) = 0 := Finset.sum_const_zero

/-! ## FS-6 — Sum of one is card -/

theorem T5_finset_sum_one {α : Type*} (s : Finset α) :
    ∑ _i ∈ s, (1 : ℝ) = (s.card : ℝ) := by
  rw [Finset.sum_const]
  simp [nsmul_eq_mul]

/-! ## FS-7 — Sum nonneg from term nonneg -/

theorem T5_finset_sum_nonneg {α : Type*} (s : Finset α) (f : α → ℝ)
    (h : ∀ i ∈ s, 0 ≤ f i) : 0 ≤ ∑ i ∈ s, f i :=
  Finset.sum_nonneg h

/-! ## FS-8 — Sum is monotone under pointwise ≤ -/

theorem T5_finset_sum_le_sum {α : Type*} (s : Finset α) (f g : α → ℝ)
    (h : ∀ i ∈ s, f i ≤ g i) :
    ∑ i ∈ s, f i ≤ ∑ i ∈ s, g i :=
  Finset.sum_le_sum h

/-! ## FS-9 — Sum nonneg → ∑ ≥ 0 via Finset.sum_nonneg (alias) -/

theorem T5_finset_sum_pos_of_pos {α : Type*} (s : Finset α) (f : α → ℝ)
    (h : ∀ i ∈ s, 0 ≤ f i) : 0 ≤ ∑ i ∈ s, f i :=
  Finset.sum_nonneg h

/-! ## FS-10 — Layer 20 foundational marker -/

theorem T5_D61_Layer20_completed_marker :
    (∀ {α : Type*} (f : α → ℝ), ∑ i ∈ (∅ : Finset α), f i = 0) ∧
    (∀ {α : Type*} (s : Finset α), ∑ _i ∈ s, (0 : ℝ) = 0) ∧
    (∀ {α : Type*} (s : Finset α) (f : α → ℝ),
      (∀ i ∈ s, 0 ≤ f i) → 0 ≤ ∑ i ∈ s, f i) ∧
    (∀ {α : Type*} (s : Finset α) (f g : α → ℝ),
      (∀ i ∈ s, f i ≤ g i) → ∑ i ∈ s, f i ≤ ∑ i ∈ s, g i) ∧
    (∀ {α : Type*} (s : Finset α) (f : α → ℝ),
      (∀ i ∈ s, 0 ≤ f i) → 0 ≤ ∑ i ∈ s, f i) :=
  ⟨@T5_finset_sum_empty,
   @T5_finset_sum_zero,
   @T5_finset_sum_nonneg,
   @T5_finset_sum_le_sum,
   @T5_finset_sum_pos_of_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer20_FinsetSumHelpers
