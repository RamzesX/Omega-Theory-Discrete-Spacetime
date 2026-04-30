/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP2_Discharge

  T-5 (Roth's theorem) — **DLP-2 unconditional discharge**.

  Proves DLP-2 (`T5_NAMED_growth_balance_monotone_in_eps`) UNCONDITIONALLY:
  growth and balance conditions are monotone (weakening) in ε.

  Strategy:
    - **Growth**: log d_{i+1} ≥ (2/ε) · log d_i.  For ε₀ ≤ ε: 2/ε ≤ 2/ε₀,
      so RHS at ε is ≤ RHS at ε₀.  Thus growth(ε₀) ⇒ growth(ε).
    - **Balance**: |R_i · log d_i - C| ≤ C · ε.  For ε₀ ≤ ε: C · ε₀ ≤ C · ε,
      so balance(ε₀) (stronger ≤ ε₀) ⇒ balance(ε) (weaker ≤ ε).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — actual analytical content.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_DeltaLimit_Packaging

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP2_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_DeltaLimit_Packaging
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## DLP2D-1 — Growth monotonicity in ε -/

/-- **DLP2D-1 — `T5_growth_monotone_in_eps`**: for ε₀ ≤ ε, growth at ε₀
    implies growth at ε.

    Direct: log d_{i+1} ≥ (2/ε₀) · log d_i ≥ (2/ε) · log d_i (when log d_i ≥ 0
    which holds since d_i ≥ 1 in ℚ). -/
theorem T5_growth_monotone_in_eps
    {m : ℕ} (q : Fin m → ℚ) (ε₀ ε : ℝ)
    (hε₀_pos : 0 < ε₀) (hε₀_le : ε₀ ≤ ε) :
    T5_DenominatorGrowthCondition q ε₀ →
    T5_DenominatorGrowthCondition q ε := by
  intro h_growth_ε₀
  intros i h_succ
  -- We have: log d_{i+1} ≥ (2/ε₀) · log d_i (at ε₀)
  -- Want: log d_{i+1} ≥ (2/ε) · log d_i (at ε)
  -- Need: (2/ε) · log d_i ≤ (2/ε₀) · log d_i
  -- This holds when log d_i ≥ 0 AND 2/ε ≤ 2/ε₀ (i.e., ε ≥ ε₀)
  have h_ε_pos : 0 < ε := lt_of_lt_of_le hε₀_pos hε₀_le
  have h_log_nn : 0 ≤ Real.log ((q i : ℚ).den : ℝ) := by
    apply Real.log_nonneg
    have h1 : (1 : ℚ) ≤ ((q i : ℚ).den : ℚ) := by
      exact_mod_cast (q i).pos
    exact_mod_cast h1
  have h_2_div : 2 / ε ≤ 2 / ε₀ :=
    div_le_div_of_nonneg_left (by norm_num) hε₀_pos hε₀_le
  have h_target : (2 / ε) * Real.log ((q i : ℚ).den : ℝ) ≤
      (2 / ε₀) * Real.log ((q i : ℚ).den : ℝ) :=
    mul_le_mul_of_nonneg_right h_2_div h_log_nn
  exact le_trans h_target (h_growth_ε₀ i h_succ)

/-! ## DLP2D-2 — Balance monotonicity in ε -/

/-- **DLP2D-2 — `T5_balance_monotone_in_eps`**: for ε₀ ≤ ε, balance at ε₀
    implies balance at ε.

    Direct: same C works.  C · ε₀ ≤ C · ε since C > 0 and ε₀ ≤ ε. -/
theorem T5_balance_monotone_in_eps
    {m : ℕ} (R : Fin m → ℕ) (q : Fin m → ℚ) (ε₀ ε : ℝ)
    (hε₀_pos : 0 < ε₀) (hε₀_le : ε₀ ≤ ε) :
    T5_DegreeHeightBalanceCondition R q ε₀ →
    T5_DegreeHeightBalanceCondition R q ε := by
  intro h_balance_ε₀
  obtain ⟨C, hC_pos, h_per_i⟩ := h_balance_ε₀
  refine ⟨C, hC_pos, ?_⟩
  intro i
  have h_C_ε : C * ε₀ ≤ C * ε := mul_le_mul_of_nonneg_left hε₀_le (le_of_lt hC_pos)
  exact le_trans (h_per_i i) h_C_ε

/-! ## DLP2D-3 — Combined: T5_NAMED_growth_balance_monotone_in_eps unconditional -/

/-- **DLP2D-3 — `T5_growth_balance_monotone_in_eps_unconditional`**:
    UNCONDITIONALLY proves DLP-2 NAMED Prop. -/
theorem T5_growth_balance_monotone_in_eps_unconditional :
    T5_NAMED_growth_balance_monotone_in_eps := by
  intros m R q ε₀ ε hε₀_pos hε₀_le
  refine ⟨?_, ?_⟩
  · exact T5_growth_monotone_in_eps q ε₀ ε hε₀_pos hε₀_le
  · exact T5_balance_monotone_in_eps R q ε₀ ε hε₀_pos hε₀_le

/-! ## DLP2D-4 — Headline -/

/-- **🚨🚨 DLP2D-4 — `T5_DLP2_DISCHARGE_HEADLINE`**: paper-citable headline
    documenting DLP-2 UNCONDITIONALLY DISCHARGED.

    Strategic significance: 1 of 2 δ → 0 limit sub-NAMEDs CLOSED.
    Remaining: DLP-1 (real-analytic √(mε) - ε/m increasing). -/
theorem T5_DLP2_DISCHARGE_HEADLINE :
    T5_NAMED_growth_balance_monotone_in_eps :=
  T5_growth_balance_monotone_in_eps_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP2_Discharge
