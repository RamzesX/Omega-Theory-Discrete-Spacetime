/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP1_Discharge

  T-5 (Roth's theorem) — **DLP-1 unconditional discharge** (with corrected constraint).

  Proves the corrected DLP-1 NAMED Prop: ∃ ε > ε₀ with √(mε) - ε/m ≥ √(mε₀)
  — but with the TIGHTENED constraint `ε₀ ≤ m³/16` (NOT m³/4 as in the
  original DLP-1).

  **Discovery**: original DLP-1 with `ε₀ ≤ m³/4` is FALSE near boundary.
  At ε₀ = m³/4: √(mε₀) = m²/2.  Function f(ε) := √(mε) - ε/m has MAX
  value m²/4 (at ε = m³/4).  So m²/4 ≥ m²/2 is impossible.  CORRECTED:
  with ε₀ ≤ m³/16: √(mε₀) ≤ m²/4 = f(m³/4). ✓

  **Strategy**: pick witness ε := m³/4 (the maximum point of f).  Then:
    - ε > ε₀ since ε₀ ≤ m³/16 < m³/4 (for m ≥ 1)
    - f(ε) = m²/4 ≥ √(mε₀) since ε₀ ≤ m³/16 implies mε₀ ≤ m⁴/16
      so √(mε₀) ≤ m²/4

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — UNCONDITIONAL discharge of corrected NAMED.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_DeltaLimit_Packaging

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP1_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_DeltaLimit_Packaging

/-! ## DLP1D-1 — Corrected DLP-1 NAMED with tighter constraint ε₀ ≤ m³/16 -/

/-- **DLP1D-1 — `T5_NAMED_sqrt_mε_increasing_witness_tighter`**:
    corrected version of DLP-1 with `ε₀ ≤ m³/16`.

    Tightens original DLP-1 `ε₀ ≤ m³/4` (which was infeasible at boundary)
    to `ε₀ ≤ m³/16` (within feasibility region — f's max value m²/4 is
    achieved at ε = m³/4 and equals √(mε₀) when ε₀ = m³/16).

    Discharge: take witness ε := m³/4.  Then f(ε) = m²/4 ≥ √(mε₀). -/
def T5_NAMED_sqrt_mε_increasing_witness_tighter : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (ε₀ : ℝ), 0 < ε₀ → ε₀ ≤ ((m : ℝ)^3) / 16 →
  ∃ (ε : ℝ), ε₀ < ε ∧
    Real.sqrt ((m : ℝ) * ε) - ε / (m : ℝ) ≥ Real.sqrt ((m : ℝ) * ε₀)

/-! ## DLP1D-2 — Unconditional discharge -/

/-- **DLP1D-2 — `T5_sqrt_mε_increasing_witness_tighter_unconditional`**:
    UNCONDITIONALLY proves the corrected DLP-1' NAMED Prop. -/
theorem T5_sqrt_mε_increasing_witness_tighter_unconditional :
    T5_NAMED_sqrt_mε_increasing_witness_tighter := by
  intros m hm ε₀ hε₀_pos hε₀_le
  -- Pick ε := m³/4
  refine ⟨((m : ℝ)^3) / 4, ?_, ?_⟩
  · -- Show m³/4 > ε₀
    -- ε₀ ≤ m³/16 < m³/4 (since 1/16 < 1/4)
    have hm_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
    have hm_cube_pos : (0 : ℝ) < (m : ℝ)^3 := by positivity
    have h : (m : ℝ)^3 / 16 < (m : ℝ)^3 / 4 := by
      apply div_lt_div_of_pos_left hm_cube_pos
      · norm_num
      · norm_num
    linarith
  · -- Show √(m · m³/4) - (m³/4)/m ≥ √(mε₀)
    -- LHS: √(m⁴/4) - m²/4 = m²/2 - m²/4 = m²/4
    -- RHS: √(mε₀) ≤ √(m · m³/16) = √(m⁴/16) = m²/4
    -- So LHS = m²/4 ≥ m²/4 ≥ √(mε₀). ✓
    have hm_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
    have hm_nn : (0 : ℝ) ≤ (m : ℝ) := le_of_lt hm_pos
    -- Compute √(m · m³/4) = m²/2
    have h_sqrt_first : Real.sqrt ((m : ℝ) * ((m : ℝ)^3 / 4)) = (m : ℝ)^2 / 2 := by
      have h_arg : (m : ℝ) * ((m : ℝ)^3 / 4) = ((m : ℝ)^2 / 2)^2 := by ring
      rw [h_arg, Real.sqrt_sq (by positivity)]
    -- (m³/4)/m = m²/4 (assuming m > 0)
    have h_div : (m : ℝ)^3 / 4 / (m : ℝ) = (m : ℝ)^2 / 4 := by
      field_simp
    -- LHS = m²/2 - m²/4 = m²/4
    rw [h_sqrt_first, h_div]
    -- Goal: m²/2 - m²/4 ≥ √(mε₀)
    -- which is m²/4 ≥ √(mε₀)
    -- we have ε₀ ≤ m³/16, so mε₀ ≤ m⁴/16 = (m²/4)², so √(mε₀) ≤ m²/4
    have h_mε₀_nn : 0 ≤ (m : ℝ) * ε₀ := mul_nonneg hm_nn (le_of_lt hε₀_pos)
    have h_mε₀_bound : (m : ℝ) * ε₀ ≤ ((m : ℝ)^2 / 4)^2 := by
      have h_target : ((m : ℝ)^2 / 4)^2 = (m : ℝ)^4 / 16 := by ring
      rw [h_target]
      have h_step : (m : ℝ) * ε₀ ≤ (m : ℝ) * ((m : ℝ)^3 / 16) :=
        mul_le_mul_of_nonneg_left hε₀_le hm_nn
      have h_eq : (m : ℝ) * ((m : ℝ)^3 / 16) = (m : ℝ)^4 / 16 := by ring
      rw [h_eq] at h_step
      exact h_step
    have h_sqrt_bound : Real.sqrt ((m : ℝ) * ε₀) ≤ (m : ℝ)^2 / 4 := by
      have h_pos : (0 : ℝ) ≤ (m : ℝ)^2 / 4 := by positivity
      rw [show ((m : ℝ)^2 / 4) = Real.sqrt (((m : ℝ)^2 / 4)^2) from
        (Real.sqrt_sq h_pos).symm]
      exact Real.sqrt_le_sqrt h_mε₀_bound
    linarith

/-! ## DLP1D-3 — Headline -/

/-- **🚨🚨🚨 DLP1D-3 — `T5_DLP1_DISCHARGE_HEADLINE`**: paper-citable
    headline documenting DLP-1' UNCONDITIONALLY DISCHARGED with corrected
    constraint.

    Strategic significance: 2 of 2 δ → 0 limit sub-NAMEDs CLOSED
    UNCONDITIONALLY (DLP-1' tighter form + DLP-2). The δ → 0 limit leaf
    of V8 closure tree is fully closed (modulo the constraint ε₀ ≤ m³/16). -/
theorem T5_DLP1_DISCHARGE_HEADLINE :
    T5_NAMED_sqrt_mε_increasing_witness_tighter :=
  T5_sqrt_mε_increasing_witness_tighter_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP1_Discharge
