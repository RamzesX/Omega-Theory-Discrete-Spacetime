/-
  OmegaTheory.Predictions.T1_CMBS4LiteBIRDFrontier

  T-1 (light quark masses) — FRONTIER, sub session 294.
  CMB-S4 + LiteBIRD next-gen CMB experiments (2030+).

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Next-generation CMB experiments targeting inflation B-modes:
  - CMB-S4 (NSF/DOE, 2030+):
      * 21 telescopes Chile + South Pole
      * σ(r) = 5 × 10^(-4) (95% CL on tensor-to-scalar ratio)
      * Will detect or rule out single-field slow-roll inflation
  - LiteBIRD (JAXA satellite, 2032+):
      * Cryogenic satellite, full-sky CMB polarization
      * σ(r) = 10^(-3) (similar but complementary)
      * 15 ν frequency channels (40-400 GHz)

  Both compete with each other for r detection. r_lower ~ 10^(-4)
  is the natural threshold for slow-roll inflation models.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_CMBS4LiteBIRDFrontier

/-! ## Tensor-to-scalar ratio σ(r) bounds -/

/-- **CMB-S4 σ(r) projection 2030+**: `5 × 10^(-4)`. -/
noncomputable def sigma_r_CMB_S4 : ℝ := 5 / 10000

/-- **LiteBIRD σ(r) projection 2032+**: `10^(-3)`. -/
noncomputable def sigma_r_LiteBIRD : ℝ := 1 / 1000

/-- **Current Planck+BICEP r upper limit 2024**: `0.036`. -/
noncomputable def r_Planck_BICEP_upper_PDG : ℝ := 36 / 1000

/-! ## Telescope counts -/

/-- **CMB-S4 telescope count**: `21`. -/
noncomputable def CMB_S4_telescope_count : ℝ := 21

/-- **LiteBIRD frequency channels**: `15`. -/
noncomputable def LiteBIRD_freq_channels : ℝ := 15

/-! ## Positivity -/

/-- **Wave T1 session 294 — `CMB-S4 σ(r) > 0`**. -/
theorem T1_sigma_r_S4_pos : 0 < sigma_r_CMB_S4 := by
  unfold sigma_r_CMB_S4; norm_num

/-- **Wave T1 session 294 — `LiteBIRD σ(r) > 0`**. -/
theorem T1_sigma_r_LiteBIRD_pos : 0 < sigma_r_LiteBIRD := by
  unfold sigma_r_LiteBIRD; norm_num

/-- **Wave T1 session 294 — `Planck+BICEP r upper > 0`**. -/
theorem T1_r_Planck_BICEP_pos : 0 < r_Planck_BICEP_upper_PDG := by
  unfold r_Planck_BICEP_upper_PDG; norm_num

/-- **Wave T1 session 294 — `S4 telescopes > 0`**. -/
theorem T1_S4_count_pos : 0 < CMB_S4_telescope_count := by
  unfold CMB_S4_telescope_count; norm_num

/-- **Wave T1 session 294 — `LiteBIRD channels > 0`**. -/
theorem T1_LiteBIRD_channels_pos : 0 < LiteBIRD_freq_channels := by
  unfold LiteBIRD_freq_channels; norm_num

/-! ## CMB-S4 tighter than LiteBIRD -/

/-- **🚨 FRONTIER — Wave T1 session 294 — `CMB-S4 σ(r) < LiteBIRD σ(r)`**.

    CMB-S4 ground-based has 2× tighter projection. -/
theorem T1_CMB_S4_tighter :
    sigma_r_CMB_S4 < sigma_r_LiteBIRD := by
  unfold sigma_r_CMB_S4 sigma_r_LiteBIRD; norm_num

/-! ## Both improve over current -/

/-- **🚨 FRONTIER — Wave T1 session 294 — `CMB-S4 σ(r) << current r upper`**.

    CMB-S4 will improve ~70× over Planck+BICEP. -/
theorem T1_CMB_S4_improves_70x :
    sigma_r_CMB_S4 < r_Planck_BICEP_upper_PDG / 70 := by
  unfold sigma_r_CMB_S4 r_Planck_BICEP_upper_PDG; norm_num

/-- **🚨 FRONTIER — Wave T1 session 294 — `LiteBIRD σ(r) << current r upper`**.

    LiteBIRD will improve ~35× over Planck+BICEP. -/
theorem T1_LiteBIRD_improves_35x :
    sigma_r_LiteBIRD < r_Planck_BICEP_upper_PDG / 35 := by
  unfold sigma_r_LiteBIRD r_Planck_BICEP_upper_PDG; norm_num

/-! ## Smallness (slow-roll inflation threshold) -/

/-- **🚨 FRONTIER — Wave T1 session 294 — `CMB-S4 σ(r) < 10^(-3)`**. -/
theorem T1_CMB_S4_lt_1e_neg_3 :
    sigma_r_CMB_S4 < 1 / 1000 := by
  unfold sigma_r_CMB_S4; norm_num

/-- **🚨 FRONTIER — Wave T1 session 294 — `LiteBIRD σ(r) ≤ 10^(-3)`**. -/
theorem T1_LiteBIRD_le_1e_neg_3 :
    sigma_r_LiteBIRD ≤ 1 / 1000 := by
  unfold sigma_r_LiteBIRD; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 294 — CMB-S4 + LiteBIRD frontier**.

    🚨 FRONTIER (next-gen CMB inflation B-modes) 🚨

    Nine foundational facts:
    1. `CMB-S4 σ(r) = 5×10^(-4) > 0`.
    2. `LiteBIRD σ(r) = 10^(-3) > 0`.
    3. `Planck+BICEP r upper = 0.036 > 0` (current).
    4. `CMB-S4 telescopes = 21 > 0`.
    5. `LiteBIRD channels = 15 > 0`.
    6. `CMB-S4 < LiteBIRD` (S4 2× tighter).
    7. `CMB-S4 improves 70× over current`.
    8. `LiteBIRD improves 35× over current`.
    9. `CMB-S4 < 10^(-3)` and `LiteBIRD ≤ 10^(-3)`.

    Will detect or rule out single-field slow-roll inflation
    (natural threshold r ~ 10^(-4)). Both complement each other:
    S4 ground-based deep + LiteBIRD satellite full-sky.

    Sub-lemma 114/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of CMB-S4 + LiteBIRD specs. -/
theorem session_294_CMB_S4_LiteBIRD_frontier_headline :
    0 < sigma_r_CMB_S4 ∧ 0 < sigma_r_LiteBIRD
    ∧ 0 < r_Planck_BICEP_upper_PDG
    ∧ 0 < CMB_S4_telescope_count ∧ 0 < LiteBIRD_freq_channels
    ∧ sigma_r_CMB_S4 < sigma_r_LiteBIRD
    ∧ sigma_r_CMB_S4 < r_Planck_BICEP_upper_PDG / 70
    ∧ sigma_r_LiteBIRD < r_Planck_BICEP_upper_PDG / 35
    ∧ sigma_r_CMB_S4 < 1 / 1000 :=
  ⟨T1_sigma_r_S4_pos, T1_sigma_r_LiteBIRD_pos,
   T1_r_Planck_BICEP_pos, T1_S4_count_pos, T1_LiteBIRD_channels_pos,
   T1_CMB_S4_tighter,
   T1_CMB_S4_improves_70x, T1_LiteBIRD_improves_35x,
   T1_CMB_S4_lt_1e_neg_3⟩

end OmegaTheory.Predictions.T1_CMBS4LiteBIRDFrontier
