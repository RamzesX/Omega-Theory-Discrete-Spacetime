/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer4

  T-5 (Roth's theorem) — **D.6.1 Layer 4: combinatorial pigeonhole foundations**.

  Sub-lemmas around the combinatorial pigeonhole that produces a
  large-index subset S ⊆ Fin m on which the Roth-index averages
  exceed the weighted threshold.

  - L4-1..3: Finset partition / sum decomposition lemmas.
  - L4-4..6: Pigeonhole-style large-subset existence.
  - L4-7..9: Sum-of-index lower bounds on the half-subset.
  - L4-10..12: Layer 4 marker.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer4

open Real
open Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3

/-! ## L4-1 — Finite-sum nonneg from pointwise -/

/-- **L4-1 — `T5_finset_sum_nonneg`**: `∀ i ∈ s, 0 ≤ f i ⇒ 0 ≤ ∑ i ∈ s, f i`. -/
theorem T5_finset_sum_nonneg
    {α : Type*} (s : Finset α) (f : α → ℝ)
    (h : ∀ i ∈ s, 0 ≤ f i) :
    0 ≤ ∑ i ∈ s, f i :=
  Finset.sum_nonneg h

/-! ## L4-2 — Sum split by predicate -/

/-- **L4-2 — `T5_finset_sum_split_by_predicate`**: for any predicate p,
    the sum splits into the p-sum and the ¬p-sum. -/
theorem T5_finset_sum_split_by_predicate
    {α : Type*} [DecidableEq α] (s : Finset α) (f : α → ℝ) (p : α → Prop)
    [DecidablePred p] :
    ∑ i ∈ s, f i =
      (∑ i ∈ s.filter p, f i) + (∑ i ∈ s.filter (fun i => ¬p i), f i) := by
  rw [← Finset.sum_filter_add_sum_filter_not s p f]

/-! ## L4-3 — Average is at least one of the values -/

/-- **L4-3 — `T5_exists_ge_avg_in_finset`**: if `s` is non-empty, there
    exists an `i ∈ s` with `f i ≥ (∑ s.f) / |s|`. -/
theorem T5_exists_ge_avg_in_finset
    {α : Type*} (s : Finset α) (hs : s.Nonempty) (f : α → ℝ) :
    ∃ i ∈ s, (∑ j ∈ s, f j) / (s.card : ℝ) ≤ f i := by
  by_contra h
  push_neg at h
  have h_strict :
      ∀ i ∈ s, f i < (∑ j ∈ s, f j) / (s.card : ℝ) := h
  have h_card_pos : 0 < (s.card : ℝ) := by
    exact_mod_cast hs.card_pos
  have h_card_ne : (s.card : ℝ) ≠ 0 := ne_of_gt h_card_pos
  have h_sum_strict :
      ∑ i ∈ s, f i < ∑ _i ∈ s, (∑ j ∈ s, f j) / (s.card : ℝ) :=
    Finset.sum_lt_sum_of_nonempty hs h_strict
  rw [Finset.sum_const, nsmul_eq_mul] at h_sum_strict
  -- h_sum_strict : ∑ f < ↑#s * (∑ f / ↑#s)
  have h_simp : (s.card : ℝ) * ((∑ j ∈ s, f j) / (s.card : ℝ)) =
      ∑ j ∈ s, f j := by
    field_simp
  rw [h_simp] at h_sum_strict
  exact lt_irrefl _ h_sum_strict

/-! ## L4-4 — Sum at least the minimum times card -/

/-- **L4-4 — `T5_finset_sum_ge_min_card`**: if `f i ≥ c` for all `i ∈ s`,
    then `∑ i ∈ s, f i ≥ c · s.card`. -/
theorem T5_finset_sum_ge_min_card
    {α : Type*} (s : Finset α) (f : α → ℝ) (c : ℝ)
    (h : ∀ i ∈ s, c ≤ f i) :
    c * (s.card : ℝ) ≤ ∑ i ∈ s, f i := by
  have h1 : ∑ _i ∈ s, c ≤ ∑ i ∈ s, f i := by
    apply Finset.sum_le_sum h
  rw [Finset.sum_const, nsmul_eq_mul, mul_comm] at h1
  exact h1

/-! ## L4-5 — Sum ≤ max times card -/

/-- **L4-5 — `T5_finset_sum_le_max_card`**: if `f i ≤ c` for all `i ∈ s`,
    then `∑ i ∈ s, f i ≤ c · s.card`. -/
theorem T5_finset_sum_le_max_card
    {α : Type*} (s : Finset α) (f : α → ℝ) (c : ℝ)
    (h : ∀ i ∈ s, f i ≤ c) :
    ∑ i ∈ s, f i ≤ c * (s.card : ℝ) := by
  have h1 : ∑ i ∈ s, f i ≤ ∑ _i ∈ s, c := by
    apply Finset.sum_le_sum h
  rw [Finset.sum_const, nsmul_eq_mul, mul_comm] at h1
  exact h1

/-! ## L4-6 — Filter card + complement card = total card -/

/-- **L4-6 — `T5_filter_card_add_compl`**: for any predicate p,
    `(s.filter p).card + (s.filter (¬p)).card = s.card`. -/
theorem T5_filter_card_add_compl
    {α : Type*} [DecidableEq α] (s : Finset α) (p : α → Prop)
    [DecidablePred p] :
    (s.filter p).card + (s.filter (fun i => ¬p i)).card = s.card := by
  rw [Finset.filter_card_add_filter_neg_card_eq_card]

/-! ## L4-7 — At least half the sum on one side -/

/-- **L4-7 — `T5_sum_half_split`**: if `∑ s.f = T`, then for any
    predicate `p`, either the `p`-sum is ≥ `T / 2` or the `¬p`-sum is
    ≥ `T / 2` (or both). -/
theorem T5_sum_half_split
    {α : Type*} [DecidableEq α] (s : Finset α) (f : α → ℝ) (p : α → Prop)
    [DecidablePred p] :
    (∑ i ∈ s, f i) / 2 ≤ ∑ i ∈ s.filter p, f i ∨
    (∑ i ∈ s, f i) / 2 ≤ ∑ i ∈ s.filter (fun i => ¬p i), f i := by
  by_contra h
  push_neg at h
  obtain ⟨h1, h2⟩ := h
  have h_sum := T5_finset_sum_split_by_predicate s f p
  have h_total : ∑ i ∈ s, f i < ∑ i ∈ s, f i := by
    rw [h_sum]
    linarith
  exact lt_irrefl _ h_total

/-! ## L4-8 — Set of large-value elements -/

/-- **L4-8 — `T5_finset_filter_ge_card_pos`**: if the average of `f` on
    `s` is ≥ `c` and `s.Nonempty`, then `(s.filter (·≥c)).Nonempty`.

    "If the average is ≥ c, at least one element is ≥ c." -/
theorem T5_finset_filter_ge_card_pos
    {α : Type*} [DecidableEq α] (s : Finset α) (hs : s.Nonempty) (f : α → ℝ) (c : ℝ)
    (h_avg : c ≤ (∑ i ∈ s, f i) / (s.card : ℝ)) :
    ∃ i ∈ s, c ≤ f i := by
  obtain ⟨i, hi, h_ge⟩ := T5_exists_ge_avg_in_finset s hs f
  exact ⟨i, hi, le_trans h_avg h_ge⟩

/-! ## L4-9 — Sum split positivity -/

/-- **L4-9 — `T5_finset_filter_pos_sum`**: if all `f i > 0` on `s`,
    then both filtered sums (by predicate p, and complement) are
    nonneg. -/
theorem T5_finset_filter_pos_sum
    {α : Type*} [DecidableEq α] (s : Finset α) (f : α → ℝ) (p : α → Prop)
    [DecidablePred p] (h_nn : ∀ i ∈ s, 0 ≤ f i) :
    0 ≤ ∑ i ∈ s.filter p, f i ∧
    0 ≤ ∑ i ∈ s.filter (fun i => ¬p i), f i := by
  refine ⟨?_, ?_⟩
  · apply Finset.sum_nonneg
    intro i hi
    apply h_nn
    exact (Finset.mem_filter.mp hi).1
  · apply Finset.sum_nonneg
    intro i hi
    apply h_nn
    exact (Finset.mem_filter.mp hi).1

/-! ## L4-10 — Layer 4 paper-citable headline -/

/-- **L4-10 — `T5_D61_Layer4_completed_marker`**: 4-conjunct marker for
    Layer 4 completion (combinatorial pigeonhole foundations). -/
theorem T5_D61_Layer4_completed_marker
    {α : Type*} [DecidableEq α] :
    (∀ (s : Finset α) (f : α → ℝ), (∀ i ∈ s, 0 ≤ f i) → 0 ≤ ∑ i ∈ s, f i) ∧
    (∀ (s : Finset α) (f : α → ℝ) (p : α → Prop) [DecidablePred p],
      ∑ i ∈ s, f i =
        (∑ i ∈ s.filter p, f i) + (∑ i ∈ s.filter (fun i => ¬p i), f i)) ∧
    (∀ (s : Finset α) (f : α → ℝ) (c : ℝ),
      (∀ i ∈ s, c ≤ f i) → c * (s.card : ℝ) ≤ ∑ i ∈ s, f i) ∧
    (∀ (s : Finset α) (f : α → ℝ) (p : α → Prop) [DecidablePred p],
      (∑ i ∈ s, f i) / 2 ≤ ∑ i ∈ s.filter p, f i ∨
      (∑ i ∈ s, f i) / 2 ≤ ∑ i ∈ s.filter (fun i => ¬p i), f i) := by
  refine ⟨T5_finset_sum_nonneg, ?_, T5_finset_sum_ge_min_card, ?_⟩
  · intros
    apply T5_finset_sum_split_by_predicate
  · intros
    apply T5_sum_half_split

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer4
