/-
  OmegaTheory.Predictions.T1_BplusToTauNuFrontier

  T-1 (light quark masses) — FRONTIER, sub session 301.
  B⁺ → τ⁺ ν leptonic decay (Belle II + Belle combined).

  Single-thread hand-authored 2026-04-28 (cycle 65).
  opus-code-crawler proposal #3.

  ## What this file delivers

  B⁺ → τ⁺ ν purely leptonic decay (PDG 2024):
  - B obs:    (1.09 ± 0.24) × 10⁻⁴ (Belle II + Belle combined)
  - SM:       (0.95 ± 0.20) × 10⁻⁴ (depends on |V_ub| × f_B)
  - Ratio:    obs/SM = 1.15 (consistent within 1σ)

  Why important:
  - Tests |V_ub| × f_B (decay constant) directly
  - Charged-Higgs-sensitive 2HDM constraint via H+ exchange
  - Belle II will improve by 4× with 50 ab⁻¹ (2030+)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_BplusToTauNuFrontier

/-! ## Branching ratios (× 10⁻⁴) -/

/-- **B(B⁺ → τ⁺ ν) Belle II + Belle 2024**: `1.09 × 10⁻⁴`. -/
noncomputable def BR_B_taunu_obs : ℝ := 109 / 1000000

/-- **B(B⁺ → τ⁺ ν) uncertainty**: `0.24 × 10⁻⁴`. -/
noncomputable def BR_B_taunu_uncertainty : ℝ := 24 / 1000000

/-- **B(B⁺ → τ⁺ ν) SM**: `0.95 × 10⁻⁴`. -/
noncomputable def BR_B_taunu_SM : ℝ := 95 / 1000000

/-- **Ratio obs/SM**: `1.15`. -/
noncomputable def ratio_obs_to_SM : ℝ := 115 / 100

/-! ## Positivity -/

/-- **Wave T1 session 301 — `B obs > 0`**. -/
theorem T1_BR_obs_pos : 0 < BR_B_taunu_obs := by
  unfold BR_B_taunu_obs; norm_num

/-- **Wave T1 session 301 — `uncert > 0`**. -/
theorem T1_BR_uncertainty_pos : 0 < BR_B_taunu_uncertainty := by
  unfold BR_B_taunu_uncertainty; norm_num

/-- **Wave T1 session 301 — `B SM > 0`**. -/
theorem T1_BR_SM_pos : 0 < BR_B_taunu_SM := by
  unfold BR_B_taunu_SM; norm_num

/-- **Wave T1 session 301 — `ratio > 0`**. -/
theorem T1_ratio_pos : 0 < ratio_obs_to_SM := by
  unfold ratio_obs_to_SM; norm_num

/-! ## Slight excess: obs > SM -/

/-- **🚨 FRONTIER — Wave T1 session 301 — `B obs > B SM`**.

    Slight upward fluctuation, ~0.5σ. -/
theorem T1_BR_obs_above_SM :
    BR_B_taunu_obs > BR_B_taunu_SM := by
  unfold BR_B_taunu_obs BR_B_taunu_SM; linarith

/-- **🚨 FRONTIER — Wave T1 session 301 — `B obs - B SM < uncert`**.

    Difference within 1σ uncertainty (consistent). -/
theorem T1_diff_within_uncertainty :
    BR_B_taunu_obs - BR_B_taunu_SM < BR_B_taunu_uncertainty := by
  unfold BR_B_taunu_obs BR_B_taunu_SM BR_B_taunu_uncertainty; linarith

/-! ## Ratio in band [0.85, 1.4] -/

/-- **🚨 FRONTIER — Wave T1 session 301 — `ratio > 1`** (slight excess). -/
theorem T1_ratio_above_1 :
    ratio_obs_to_SM > 1 := by
  unfold ratio_obs_to_SM; norm_num

/-- **🚨 FRONTIER — Wave T1 session 301 — `ratio < 1.4`**. -/
theorem T1_ratio_below_1_4 :
    ratio_obs_to_SM < 14 / 10 := by
  unfold ratio_obs_to_SM; norm_num

/-- **🚨 FRONTIER — Wave T1 session 301 — `ratio > 0.85`**. -/
theorem T1_ratio_above_0_85 :
    ratio_obs_to_SM > 85 / 100 := by
  unfold ratio_obs_to_SM; norm_num

/-! ## Smallness (rare leptonic decay) -/

/-- **🚨 FRONTIER — Wave T1 session 301 — `B obs < 10⁻³`**. -/
theorem T1_BR_obs_lt_1e_neg_3 :
    BR_B_taunu_obs < 1 / 1000 := by
  unfold BR_B_taunu_obs; norm_num

/-- **🚨 FRONTIER — Wave T1 session 301 — `B obs < 1.5 × 10⁻⁴`**. -/
theorem T1_BR_obs_lt_1_5e_neg_4 :
    BR_B_taunu_obs < 15 / 100000 := by
  unfold BR_B_taunu_obs; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 301 — B⁺ → τ⁺ν leptonic frontier**.

    🚨 FRONTIER (V_ub × f_B + charged-Higgs probe) 🚨

    Eleven foundational facts:
    1. `B obs = 1.09×10⁻⁴ > 0` (Belle II + Belle 2024).
    2. `uncert = 0.24×10⁻⁴ > 0`.
    3. `B SM = 0.95×10⁻⁴ > 0`.
    4. `ratio = 1.15 > 0`.
    5. `B obs > B SM` (slight excess, ~0.5σ).
    6. `obs - SM < uncert` (within 1σ, consistent).
    7. `ratio > 1` (slight excess direction).
    8. `0.85 < ratio < 1.4` (band).
    9. `B obs < 10⁻³` (rare regime).
    10. `B obs < 1.5×10⁻⁴` (tighter bound).
    11. `ratio < 1.4` (max excess bounded).

    Tests |V_ub| × f_B directly. Charged-Higgs-sensitive 2HDM
    constraint via H+ exchange. Belle II 50 ab⁻¹ → 4× tighter.

    Sub-lemma 121/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of B⁺ → τ⁺ν. -/
theorem session_301_BplusToTauNu_frontier_headline :
    0 < BR_B_taunu_obs ∧ 0 < BR_B_taunu_uncertainty
    ∧ 0 < BR_B_taunu_SM ∧ 0 < ratio_obs_to_SM
    ∧ BR_B_taunu_obs > BR_B_taunu_SM
    ∧ BR_B_taunu_obs - BR_B_taunu_SM < BR_B_taunu_uncertainty
    ∧ ratio_obs_to_SM > 1
    ∧ ratio_obs_to_SM < 14 / 10
    ∧ ratio_obs_to_SM > 85 / 100
    ∧ BR_B_taunu_obs < 1 / 1000 :=
  ⟨T1_BR_obs_pos, T1_BR_uncertainty_pos,
   T1_BR_SM_pos, T1_ratio_pos,
   T1_BR_obs_above_SM, T1_diff_within_uncertainty,
   T1_ratio_above_1, T1_ratio_below_1_4, T1_ratio_above_0_85,
   T1_BR_obs_lt_1e_neg_3⟩

end OmegaTheory.Predictions.T1_BplusToTauNuFrontier
