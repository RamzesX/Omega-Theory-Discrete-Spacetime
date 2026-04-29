/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer0

  T-5 (Roth's theorem) — **D.6.1 Layer 0: real-analytic glue lemmas**.

  Foundational real-analysis lemmas for Hindry-Silverman D.6.1
  (Roth's-lemma index-reduction inequality):

  - L0-1: `smallEpsBound` — for `0 < ε < 1/(4m²)`, `√(mε) < 1/2`.
  - L0-2: `smallEpsBound_le` — for `0 < ε ≤ 1/(4m²)`, `√(mε) ≤ 1/2`.
  - L0-3: `growth_implies_pos` — growth + 1 ≤ d_0 ⇒ each `1 ≤ d_i`.
  - L0-4: `log_d_nonneg` — `1 ≤ d ⇒ 0 ≤ log d`.

  These are PURE-ANALYSIS facts independent of the polynomial /
  multivariate machinery.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS — no `sorry`, no `Prop := True`, etc.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer0

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## L0-1 — Small ε bound (≤ form) -/

/-- **L0-1 — `smallEpsBound_le`**: for `0 < ε` and `ε ≤ 1/(4m²)` with `m ≥ 1`,
    `√(mε) ≤ 1/2`.

    The standard Hindry-Silverman D.6.1 hypothesis bound: keeping ε small
    enough relative to m ensures `√(mε)` is bounded by 1/2. -/
theorem T5_smallEpsBound_le
    (m : ℕ) (hm : 1 ≤ m) (ε : ℝ) (hε_pos : 0 < ε)
    (hε_le : ε ≤ 1 / (4 * (m : ℝ)^2)) :
    Real.sqrt ((m : ℝ) * ε) ≤ 1 / 2 := by
  have hm_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  have hm2_pos : (0 : ℝ) < (m : ℝ)^2 := by positivity
  -- m·ε ≤ m · 1/(4m²) ≤ 1/4 (combine in one step)
  have h_m_eps_le_quarter : (m : ℝ) * ε ≤ 1/4 := by
    have h1 : (m : ℝ) * ε ≤ (m : ℝ) * (1 / (4 * (m : ℝ)^2)) :=
      mul_le_mul_of_nonneg_left hε_le (le_of_lt hm_pos)
    -- m · (1 / (4 m²)) = 1 / (4 m).
    -- 1 / (4m) ≤ 1/4 since 4m ≥ 4.
    have h_simplify : (m : ℝ) * (1 / (4 * (m : ℝ)^2)) = 1 / (4 * (m : ℝ)) := by
      field_simp
    rw [h_simplify] at h1
    -- Now h1 : m·ε ≤ 1/(4m)
    have h_one_over_4m_le_quarter : 1 / (4 * (m : ℝ)) ≤ (1/4 : ℝ) := by
      have h_one_le_m : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
      have h_4_le_4m : (4 : ℝ) ≤ 4 * (m : ℝ) := by linarith
      have h_4m_pos : (0 : ℝ) < 4 * (m : ℝ) := by positivity
      rw [div_le_div_iff₀ h_4m_pos (by norm_num : (0 : ℝ) < 4)]
      linarith
    linarith
  -- √(m·ε) ≤ √(1/4) = 1/2
  have h_sqrt_le : Real.sqrt ((m : ℝ) * ε) ≤ Real.sqrt (1/4) :=
    Real.sqrt_le_sqrt h_m_eps_le_quarter
  rw [show (1/4 : ℝ) = (1/2)^2 by norm_num] at h_sqrt_le
  rw [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 1/2)] at h_sqrt_le
  exact h_sqrt_le

/-! ## L0-1' — Small ε bound (strict form) -/

/-- **L0-1' — `smallEpsBound_lt`**: for `0 < ε < 1/(4m²)` with `m ≥ 1`,
    `√(mε) < 1/2` (strict).

    Strict-hypothesis version producing a strict conclusion. -/
theorem T5_smallEpsBound_lt
    (m : ℕ) (hm : 1 ≤ m) (ε : ℝ) (hε_pos : 0 < ε)
    (hε_lt : ε < 1 / (4 * (m : ℝ)^2)) :
    Real.sqrt ((m : ℝ) * ε) < 1 / 2 := by
  have hm_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  -- m·ε < m · 1/(4m²) = 1/(4m) ≤ 1/4
  have h_m_eps_lt_quarter : (m : ℝ) * ε < 1/4 := by
    have h1 : (m : ℝ) * ε < (m : ℝ) * (1 / (4 * (m : ℝ)^2)) :=
      mul_lt_mul_of_pos_left hε_lt hm_pos
    have h_simplify : (m : ℝ) * (1 / (4 * (m : ℝ)^2)) = 1 / (4 * (m : ℝ)) := by
      field_simp
    rw [h_simplify] at h1
    have h_one_over_4m_le_quarter : 1 / (4 * (m : ℝ)) ≤ (1/4 : ℝ) := by
      have h_one_le_m : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
      have h_4_le_4m : (4 : ℝ) ≤ 4 * (m : ℝ) := by linarith
      have h_4m_pos : (0 : ℝ) < 4 * (m : ℝ) := by positivity
      rw [div_le_div_iff₀ h_4m_pos (by norm_num : (0 : ℝ) < 4)]
      linarith
    linarith
  have h_m_eps_nn : (0 : ℝ) ≤ (m : ℝ) * ε := by positivity
  have h_sqrt_lt : Real.sqrt ((m : ℝ) * ε) < Real.sqrt (1/4) :=
    Real.sqrt_lt_sqrt h_m_eps_nn h_m_eps_lt_quarter
  rw [show (1/4 : ℝ) = (1/2)^2 by norm_num] at h_sqrt_lt
  rw [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 1/2)] at h_sqrt_lt
  exact h_sqrt_lt

/-! ## L0-2 — Real.log on natural numbers ≥ 1 -/

/-- **L0-2 — `log_natCast_nonneg`**: for `n : ℕ` with `1 ≤ n`,
    `0 ≤ Real.log (n : ℝ)`. -/
theorem T5_log_natCast_nonneg (n : ℕ) (hn : 1 ≤ n) :
    0 ≤ Real.log (n : ℝ) := by
  apply Real.log_nonneg
  exact_mod_cast hn

/-- **L0-3 — `log_natCast_pos`**: for `n : ℕ` with `2 ≤ n`,
    `0 < Real.log (n : ℝ)`. -/
theorem T5_log_natCast_pos (n : ℕ) (hn : 2 ≤ n) :
    0 < Real.log (n : ℝ) := by
  apply Real.log_pos
  have : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  linarith

/-! ## L0-4 — Sqrt monotonicity helper for analytical chain -/

/-- **L0-4 — `sqrt_mul_pos`**: `0 < √(m·ε)` for `0 < m·ε` (real form). -/
theorem T5_sqrt_mul_pos (m : ℝ) (ε : ℝ) (hmε : 0 < m * ε) :
    0 < Real.sqrt (m * ε) :=
  Real.sqrt_pos.mpr hmε

/-- **L0-5 — `sqrt_natMul_pos`**: `0 < √((m : ℝ)·ε)` for `m ≥ 1`, `ε > 0`. -/
theorem T5_sqrt_natMul_pos (m : ℕ) (hm : 1 ≤ m) (ε : ℝ) (hε : 0 < ε) :
    0 < Real.sqrt ((m : ℝ) * ε) := by
  have hm_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  exact T5_sqrt_mul_pos _ _ (mul_pos hm_pos hε)

/-! ## L0-6 — Two-arg threshold helpers -/

/-- **L0-6 — `t_minus_sqrt_mε_pos`**: if `t ≥ 1/2 + √(mε) + δ` for some
    `δ > 0`, then `t - √(mε) > 1/2`.

    Used in Layer 5 recursion: the rothIndex `t` is bounded below by
    `t - √(mε)`, and we want that bound to remain positive. -/
theorem T5_t_minus_sqrt_mε_pos
    (t δ : ℝ) (m : ℕ) (hm : 1 ≤ m) (ε : ℝ) (hε_pos : 0 < ε)
    (hδ_pos : 0 < δ)
    (ht_ge : t ≥ 1/2 + Real.sqrt ((m : ℝ) * ε) + δ) :
    t - Real.sqrt ((m : ℝ) * ε) > 1/2 := by
  linarith

/-! ## L0-7 — Sqrt monotonicity in the m·ε argument -/

/-- **L0-7 — `sqrt_mε_le_of_eps_le`**: monotonicity of √(m·ε) in ε.
    For fixed m ≥ 0, ε ≤ ε' implies √(m·ε) ≤ √(m·ε'). -/
theorem T5_sqrt_mε_le_of_eps_le
    (m : ℝ) (hm_nn : 0 ≤ m) (ε ε' : ℝ) (hεε' : ε ≤ ε') :
    Real.sqrt (m * ε) ≤ Real.sqrt (m * ε') := by
  apply Real.sqrt_le_sqrt
  exact mul_le_mul_of_nonneg_left hεε' hm_nn

/-! ## L0-8 — m ≥ 2 specialization of smallEpsBound -/

/-- **L0-8 — `smallEpsBound_m_ge_2`**: for m ≥ 2 and 0 < ε ≤ 1/(4m²),
    `√(mε) < 1/2` (strict, even with ≤ in hypothesis).

    For m ≥ 2: ε ≤ 1/(4m²) ⇒ m·ε ≤ 1/(4m) < 1/8 < 1/4. So √ < 1/2. -/
theorem T5_smallEpsBound_m_ge_2
    (m : ℕ) (hm : 2 ≤ m) (ε : ℝ) (hε_pos : 0 < ε)
    (hε_le : ε ≤ 1 / (4 * (m : ℝ)^2)) :
    Real.sqrt ((m : ℝ) * ε) < 1 / 2 := by
  have hm_pos : (0 : ℝ) < (m : ℝ) := by
    have : 1 ≤ m := by omega
    exact_mod_cast this
  have hm_ge_two : (2 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hm2_pos : (0 : ℝ) < (m : ℝ)^2 := by positivity
  -- m·ε ≤ m · 1/(4m²) = 1/(4m) ≤ 1/8 (m ≥ 2)
  have h_simplify : (m : ℝ) * (1 / (4 * (m : ℝ)^2)) = 1 / (4 * (m : ℝ)) := by
    field_simp
  have h_le_1_4m : (m : ℝ) * ε ≤ 1 / (4 * (m : ℝ)) := by
    have h := mul_le_mul_of_nonneg_left hε_le (le_of_lt hm_pos)
    rw [h_simplify] at h
    exact h
  -- 1/(4m) ≤ 1/8 (since m ≥ 2)
  have h_8_le_4m : (8 : ℝ) ≤ 4 * (m : ℝ) := by linarith
  have h_4m_pos : (0 : ℝ) < 4 * (m : ℝ) := by positivity
  have h_one_over_4m_le_eighth : 1 / (4 * (m : ℝ)) ≤ (1/8 : ℝ) := by
    rw [div_le_div_iff₀ h_4m_pos (by norm_num : (0 : ℝ) < 8)]
    linarith
  have h_m_eps_le_eighth : (m : ℝ) * ε ≤ 1/8 :=
    le_trans h_le_1_4m h_one_over_4m_le_eighth
  -- 1/8 < 1/4
  have h_eighth_lt_quarter : (1/8 : ℝ) < 1/4 := by norm_num
  have h_m_eps_lt_quarter : (m : ℝ) * ε < 1/4 :=
    lt_of_le_of_lt h_m_eps_le_eighth h_eighth_lt_quarter
  -- √(m·ε) < √(1/4) = 1/2
  have h_m_eps_nn : (0 : ℝ) ≤ (m : ℝ) * ε := by positivity
  have h_sqrt_lt : Real.sqrt ((m : ℝ) * ε) < Real.sqrt (1/4) :=
    Real.sqrt_lt_sqrt h_m_eps_nn h_m_eps_lt_quarter
  rw [show (1/4 : ℝ) = (1/2)^2 by norm_num] at h_sqrt_lt
  rw [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 1/2)] at h_sqrt_lt
  exact h_sqrt_lt

/-! ## L0-9 — Sqrt arithmetic helpers -/

/-- **L0-9a — `sqrt_lt_one_of_lt_one`**: `0 ≤ x < 1 ⇒ √x < 1`. -/
theorem T5_sqrt_lt_one_of_lt_one (x : ℝ) (hx_nn : 0 ≤ x) (hx_lt : x < 1) :
    Real.sqrt x < 1 := by
  have h_sqrt_lt : Real.sqrt x < Real.sqrt 1 :=
    Real.sqrt_lt_sqrt hx_nn hx_lt
  rwa [Real.sqrt_one] at h_sqrt_lt

/-- **L0-9b — `sqrt_le_one_of_le_one`**: `0 ≤ x ≤ 1 ⇒ √x ≤ 1`. -/
theorem T5_sqrt_le_one_of_le_one (x : ℝ) (hx_nn : 0 ≤ x) (hx_le : x ≤ 1) :
    Real.sqrt x ≤ 1 := by
  have h_sqrt_le : Real.sqrt x ≤ Real.sqrt 1 := Real.sqrt_le_sqrt hx_le
  rwa [Real.sqrt_one] at h_sqrt_le

/-! ## L0-10 — Integer/Real bridge for the index calculus -/

/-- **L0-10 — `nat_cast_pos_of_one_le`**: `1 ≤ n ⇒ 0 < (n : ℝ)`. -/
theorem T5_nat_cast_pos_of_one_le (n : ℕ) (hn : 1 ≤ n) :
    (0 : ℝ) < (n : ℝ) := by
  have : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  linarith

/-- **L0-11 — `inv_nat_le_one`**: `1 ≤ n ⇒ 1/(n : ℝ) ≤ 1`. -/
theorem T5_inv_nat_le_one (n : ℕ) (hn : 1 ≤ n) :
    1 / (n : ℝ) ≤ 1 := by
  have hn_pos : (0 : ℝ) < (n : ℝ) := T5_nat_cast_pos_of_one_le n hn
  have hn_ge_one : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  rw [div_le_iff₀ hn_pos]
  linarith

/-! ## L0-12 — Balance-condition basic implications -/

/-- **L0-12a — `balance_implies_C_pos`**: balance condition ⇒ the balancing
    constant C is positive. Trivially follows from the existential
    structure. -/
theorem T5_balance_implies_C_pos
    {m : ℕ} (R : Fin m → ℕ) (q : Fin m → ℚ) (ε : ℝ)
    (h_bal : T5_DegreeHeightBalanceCondition R q ε) :
    ∃ C > 0, ∀ i : Fin m,
      |((R i : ℝ) * Real.log ((q i : ℚ).den : ℝ)) - C| ≤ C * ε :=
  h_bal

/-- **L0-12b — `balance_implies_per_i_bound`**: from the balance condition,
    each `R_i · log d_i` lies in `[C(1-ε), C(1+ε)]` (the explicit interval). -/
theorem T5_balance_implies_per_i_bound
    {m : ℕ} (R : Fin m → ℕ) (q : Fin m → ℚ) (ε : ℝ)
    (h_bal : T5_DegreeHeightBalanceCondition R q ε)
    (i : Fin m) :
    ∃ (C : ℝ), 0 < C ∧
      C * (1 - ε) ≤ (R i : ℝ) * Real.log ((q i : ℚ).den : ℝ) ∧
      (R i : ℝ) * Real.log ((q i : ℚ).den : ℝ) ≤ C * (1 + ε) := by
  obtain ⟨C, hC_pos, h_per_i⟩ := h_bal
  refine ⟨C, hC_pos, ?_, ?_⟩
  · -- lower bound: |x - C| ≤ Cε ⇒ -Cε ≤ x - C ⇒ x ≥ C - Cε = C(1-ε)
    have h_abs := h_per_i i
    rw [abs_sub_le_iff] at h_abs
    -- h_abs : (R_i log d_i) - C ≤ C·ε ∧ C - (R_i log d_i) ≤ C·ε
    have h_low := h_abs.2
    linarith
  · -- upper bound: similar
    have h_abs := h_per_i i
    rw [abs_sub_le_iff] at h_abs
    have h_up := h_abs.1
    linarith

/-! ## L0-13 — Growth-condition basic implications -/

/-- **L0-13a — `growth_implies_log_chain`**: growth condition ⇒ for any
    `i.val + 1 < m`, `log d_{i+1} ≥ (2/ε) · log d_i`.

    Direct re-export of `T5_DenominatorGrowthCondition` definition. -/
theorem T5_growth_implies_log_chain
    {m : ℕ} (q : Fin m → ℚ) (ε : ℝ)
    (h_growth : T5_DenominatorGrowthCondition q ε)
    (i : Fin m) (h_succ : i.val + 1 < m) :
    Real.log ((q ⟨i.val + 1, h_succ⟩ : ℚ).den : ℝ) ≥
      (2 / ε) * Real.log ((q i : ℚ).den : ℝ) :=
  h_growth i h_succ

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer0
