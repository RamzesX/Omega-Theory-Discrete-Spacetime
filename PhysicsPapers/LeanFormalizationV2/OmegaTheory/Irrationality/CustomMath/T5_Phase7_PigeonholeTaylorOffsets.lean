/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets

  T-5 (Roth's theorem) — **H_c-2 pigeonhole applied to Taylor offsets**.

  Specializes the foundational `T5_pigeonhole_max_at_least_average`
  to the Taylor multi-index setting.  Given a multi-index J : Fin m → ℕ
  with weighted sum ∑ J_i/R_i ≥ T, there exists some coordinate i with
  J_i/R_i ≥ T/m (max-bound on the average).

  This is the H_c-2 step in V8-D5 discharge: we pick the coordinate with
  the largest J_i/R_i ratio and use it to bound the corresponding factor
  in the Taylor expansion via VC-9 (`T5_tuple_violator_rpow_bound`).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeFinM_Helpers
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets

open Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeFinM_Helpers

/-! ## PTO-1 — Max coordinate from weighted-sum lower bound -/

/-- **`T5_pigeonhole_taylor_offset_max`**: max coordinate Jᵢ/Rᵢ ≥ T/m
    when weighted sum ≥ T.

    Direct application of `T5_pigeonhole_max_at_least_average` to the
    real-valued function `fun i => (J i : ℝ) / (R i : ℝ)`. -/
theorem T5_pigeonhole_taylor_offset_max
    {m : ℕ} (hm : 0 < m) (J R : Fin m → ℕ)
    (T : ℝ) (h_lower : T ≤ ∑ i, (J i : ℝ) / (R i : ℝ)) :
    ∃ i : Fin m, T / (m : ℝ) ≤ (J i : ℝ) / (R i : ℝ) := by
  -- Apply T5_pigeonhole_max_at_least_average to a := fun i => J i / R i
  obtain ⟨i, h_max⟩ :=
    T5_pigeonhole_max_at_least_average hm (fun i => (J i : ℝ) / (R i : ℝ))
  -- h_max : ∑ a j ≤ m · a i
  -- so T ≤ ∑ a j ≤ m · a i, hence T / m ≤ a i (using m > 0)
  refine ⟨i, ?_⟩
  have h_m_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  have h_T_le_m_ai : T ≤ (m : ℝ) * ((J i : ℝ) / (R i : ℝ)) := le_trans h_lower h_max
  -- Divide both sides by m
  rw [div_le_iff₀ h_m_pos]
  linarith

/-! ## PTO-2 — Strict version -/

/-- **`T5_pigeonhole_taylor_offset_max_strict`**: strict-inequality
    variant when weighted sum > T. -/
theorem T5_pigeonhole_taylor_offset_max_strict
    {m : ℕ} (hm : 0 < m) (J R : Fin m → ℕ)
    (T : ℝ) (h_lower : T < ∑ i, (J i : ℝ) / (R i : ℝ)) :
    ∃ i : Fin m, T / (m : ℝ) < (J i : ℝ) / (R i : ℝ) := by
  obtain ⟨i, h_max⟩ :=
    T5_pigeonhole_max_at_least_average hm (fun i => (J i : ℝ) / (R i : ℝ))
  refine ⟨i, ?_⟩
  have h_m_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  have h_T_lt_m_ai : T < (m : ℝ) * ((J i : ℝ) / (R i : ℝ)) :=
    lt_of_lt_of_le h_lower h_max
  rw [div_lt_iff₀ h_m_pos]
  linarith

/-! ## PTO-3 — Headline -/

/-- **🚨🚨 PTO-3 — `T5_PIGEONHOLE_TAYLOR_OFFSETS_HEADLINE`**: paper-citable
    Taylor-offset pigeonhole bundle.

    Both ≤ and < forms.  Used in V8-D5 H_c-2 step to extract a
    distinguished Taylor coordinate from the rothIndex bound. -/
theorem T5_PIGEONHOLE_TAYLOR_OFFSETS_HEADLINE
    {m : ℕ} (hm : 0 < m) (J R : Fin m → ℕ) (T : ℝ) :
    -- (a) ≤ form
    (T ≤ ∑ i, (J i : ℝ) / (R i : ℝ) →
      ∃ i, T / (m : ℝ) ≤ (J i : ℝ) / (R i : ℝ)) ∧
    -- (b) < form
    (T < ∑ i, (J i : ℝ) / (R i : ℝ) →
      ∃ i, T / (m : ℝ) < (J i : ℝ) / (R i : ℝ)) :=
  ⟨T5_pigeonhole_taylor_offset_max hm J R T,
   T5_pigeonhole_taylor_offset_max_strict hm J R T⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets
