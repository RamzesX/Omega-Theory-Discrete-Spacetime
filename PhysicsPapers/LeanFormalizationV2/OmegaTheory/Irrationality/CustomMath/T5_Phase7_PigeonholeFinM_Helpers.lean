/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeFinM_Helpers

  T-5 (Roth's theorem) — **pigeonhole helpers on Fin m** for HEART work.

  Provides foundational pigeonhole / averaging lemmas:
    1. **Max-at-least-average**: ∃ i, m · aᵢ ≥ ∑ aⱼ
    2. **Min-at-most-average**: ∃ i, m · aᵢ ≤ ∑ aⱼ
    3. **Sandwich + nonneg variant**

  These foundational pigeonhole forms feed into H_c-2 (pigeonhole applied
  to Taylor offsets).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.BigOperators.Pi
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Max
import Mathlib.Data.Fintype.Lattice

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeFinM_Helpers

open Finset

/-! ## PFM-1 — Max element bounds the average -/

/-- **`T5_pigeonhole_max_at_least_average`**: ∃ i with `∑ aⱼ ≤ m · aᵢ`. -/
theorem T5_pigeonhole_max_at_least_average {m : ℕ} (hm : 0 < m) (a : Fin m → ℝ) :
    ∃ i : Fin m, ∑ j, a j ≤ (m : ℝ) * a i := by
  have h_nonempty : (Finset.univ : Finset (Fin m)).Nonempty :=
    Finset.univ_nonempty_iff.mpr ⟨⟨0, hm⟩⟩
  obtain ⟨i, _hi_mem, h_max⟩ :=
    Finset.exists_max_image (Finset.univ : Finset (Fin m)) a h_nonempty
  refine ⟨i, ?_⟩
  have h_const_sum : (∑ _j : Fin m, (a i : ℝ)) = (m : ℝ) * a i := by
    simp [Finset.sum_const, Finset.card_univ, Fintype.card_fin, mul_comm]
  rw [← h_const_sum]
  exact Finset.sum_le_sum (fun j _ => h_max j (Finset.mem_univ j))

/-! ## PFM-2 — Min element bounds the average from below -/

/-- **`T5_pigeonhole_min_at_most_average`**: ∃ i with `m · aᵢ ≤ ∑ aⱼ`. -/
theorem T5_pigeonhole_min_at_most_average {m : ℕ} (hm : 0 < m) (a : Fin m → ℝ) :
    ∃ i : Fin m, (m : ℝ) * a i ≤ ∑ j, a j := by
  have h_nonempty : (Finset.univ : Finset (Fin m)).Nonempty :=
    Finset.univ_nonempty_iff.mpr ⟨⟨0, hm⟩⟩
  obtain ⟨i, _hi_mem, h_min⟩ :=
    Finset.exists_min_image (Finset.univ : Finset (Fin m)) a h_nonempty
  refine ⟨i, ?_⟩
  have h_const_sum : (m : ℝ) * a i = ∑ _j : Fin m, (a i : ℝ) := by
    simp [Finset.sum_const, Finset.card_univ, Fintype.card_fin, mul_comm]
  rw [h_const_sum]
  exact Finset.sum_le_sum (fun j _ => h_min j (Finset.mem_univ j))

/-! ## PFM-3 — Average sandwich -/

/-- **`T5_pigeonhole_average_sandwich`**: combines PFM-1 and PFM-2.

    There exist i_min, i_max such that `m · aᵢ_min ≤ ∑ aⱼ ≤ m · aᵢ_max`. -/
theorem T5_pigeonhole_average_sandwich {m : ℕ} (hm : 0 < m) (a : Fin m → ℝ) :
    ∃ (i_min i_max : Fin m),
      (m : ℝ) * a i_min ≤ ∑ j, a j ∧ ∑ j, a j ≤ (m : ℝ) * a i_max := by
  obtain ⟨i_max, h_max⟩ := T5_pigeonhole_max_at_least_average hm a
  obtain ⟨i_min, h_min⟩ := T5_pigeonhole_min_at_most_average hm a
  exact ⟨i_min, i_max, h_min, h_max⟩

/-! ## PFM-4 — Average bound for nonneg sequences (avg ≤ max coord) -/

/-- **`T5_pigeonhole_max_avg_nonneg`**: division form
    `(∑ a) / m ≤ max coord`. -/
theorem T5_pigeonhole_max_avg_nonneg {m : ℕ} (hm : 0 < m) (a : Fin m → ℝ) :
    ∃ i : Fin m, (∑ j, a j) / (m : ℝ) ≤ a i := by
  obtain ⟨i, h_le⟩ := T5_pigeonhole_max_at_least_average hm a
  refine ⟨i, ?_⟩
  have h_m_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  -- div_le_iff₀ : (a / b ≤ c) ↔ (a ≤ c * b) for b > 0
  rw [div_le_iff₀ h_m_pos, mul_comm]
  exact h_le

/-! ## PFM-5 — Headline -/

/-- **🚨🚨 `T5_PIGEONHOLE_FIN_M_HEADLINE`**: paper-citable pigeonhole
    bundle for Fin m foundational averaging lemmas. -/
theorem T5_PIGEONHOLE_FIN_M_HEADLINE {m : ℕ} (hm : 0 < m) (a : Fin m → ℝ) :
    -- (a) Max bounds total
    (∃ i : Fin m, ∑ j, a j ≤ (m : ℝ) * a i) ∧
    -- (b) Min bounded by total
    (∃ i : Fin m, (m : ℝ) * a i ≤ ∑ j, a j) ∧
    -- (c) Sandwich
    (∃ (i_min i_max : Fin m),
      (m : ℝ) * a i_min ≤ ∑ j, a j ∧ ∑ j, a j ≤ (m : ℝ) * a i_max) :=
  ⟨T5_pigeonhole_max_at_least_average hm a,
   T5_pigeonhole_min_at_most_average hm a,
   T5_pigeonhole_average_sandwich hm a⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeFinM_Helpers
