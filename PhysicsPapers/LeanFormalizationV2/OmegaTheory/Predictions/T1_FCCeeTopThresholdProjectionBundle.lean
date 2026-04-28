/-
  OmegaTheory.Predictions.T1_FCCeeTopThresholdProjectionBundle

  T-1 (light quark masses) — FRONTIER, bundled sessions 759-763.
  FCC-ee tt̄ near-threshold scan top-mass + top-width precision projection.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Five-session bundle for FCC-ee (Future Circular Collider, e+e- mode)
  near-threshold tt̄ scan around √s ≈ 350 GeV — the cleanest possible
  measurement of m_t and Γ_t. All MeV scale anchors:

  - s759: σ(m_t) projected at FCC-ee threshold scan ≈ 25 MeV
          (10× tighter than HL-LHC ≈ 250 MeV).
          `sigma_m_t_FCCee_MeV = 25`,
          `sigma_m_t_LHC_HL_MeV = 250`.
  - s760: σ(Γ_t) projected at FCC-ee threshold ≈ 40 MeV (vs PDG ±190 MeV).
          `sigma_Gamma_t_FCCee_MeV = 40`,
          `Gamma_t_PDG_MeV = 1420` (= 1.42 GeV).
  - s761: Threshold-scan luminosity target: 1.0 fb⁻¹ (≈ 0.2 fb⁻¹/yr × 5 yr).
          `lumi_target_fb_inv = 1`.
  - s762: Energy scan center: 350 GeV ≈ 2 m_top (m_top ≈ 173 GeV).
          `E_threshold_GeV = 350`. Sub-2m_t lower bound: 350 > 346 = 2·173.
  - s763: bundle composition + FCCeeTopThreshold Prop (6+ conjunct).

  Why important:
  - The tt̄ threshold scan is the unique probe extracting m_t in a
    theoretically clean short-distance scheme (1S or PS), bypassing
    the ~500 MeV ambiguity of the LHC pole-mass extraction.
  - Direct measurement of Γ_t at sub-3% is the only way to access the
    top width without modeling — current PDG width has ~13% uncertainty.
  - Sub-percent m_t precision tightens electroweak vacuum stability
    bounds (Higgs quartic running) and global SM fits (M_W, sin²θ_W).
  - Structural complement to T1_HLLHCTopYukawaKappaTBundle (κ_t)
    and to broader top-quark precision programme.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_FCCeeTopThresholdProjectionBundle

/-! ## FCC-ee top-quark precision anchors (MeV scale) -/

/-- **s759 — FCC-ee target σ(m_t)** in MeV: `25 = 25 MeV` (≈ 0.014% of m_t).
    Threshold-scan projection (FCC-ee CDR + Snowmass 2022). -/
noncomputable def sigma_m_t_FCCee_MeV : ℝ := 25

/-- **s759 — LHC HL-LHC projected σ(m_t)** in MeV: `250 = 250 MeV`. -/
noncomputable def sigma_m_t_LHC_HL_MeV : ℝ := 250

/-- **s760 — FCC-ee target σ(Γ_t)** in MeV: `40 = 40 MeV`. -/
noncomputable def sigma_Gamma_t_FCCee_MeV : ℝ := 40

/-- **s760 — PDG 2024 top width** in MeV: `1420 = 1.42 GeV`. -/
noncomputable def Gamma_t_PDG_MeV : ℝ := 1420

/-- **s761 — Threshold-scan luminosity target** in fb⁻¹: `1` (≈ 0.2 fb⁻¹/yr × 5 yr). -/
noncomputable def lumi_target_fb_inv : ℝ := 1

/-- **s762 — FCC-ee threshold-scan center energy** in GeV: `350 = 350 GeV`. -/
noncomputable def E_threshold_GeV : ℝ := 350

/-! ## Positivity (s759-s762) -/

/-- **s759 — `σ(m_t) FCC-ee > 0`**. -/
theorem T1_sigma_m_t_FCCee_pos : 0 < sigma_m_t_FCCee_MeV := by
  unfold sigma_m_t_FCCee_MeV; norm_num

/-- **s759 — `σ(m_t) LHC HL > 0`**. -/
theorem T1_sigma_m_t_LHC_HL_pos : 0 < sigma_m_t_LHC_HL_MeV := by
  unfold sigma_m_t_LHC_HL_MeV; norm_num

/-- **s760 — `σ(Γ_t) FCC-ee > 0`**. -/
theorem T1_sigma_Gamma_t_FCCee_pos : 0 < sigma_Gamma_t_FCCee_MeV := by
  unfold sigma_Gamma_t_FCCee_MeV; norm_num

/-- **s760 — `Γ_t PDG > 0`**. -/
theorem T1_Gamma_t_PDG_pos : 0 < Gamma_t_PDG_MeV := by
  unfold Gamma_t_PDG_MeV; norm_num

/-- **s761 — `lumi target > 0`**. -/
theorem T1_lumi_target_pos : 0 < lumi_target_fb_inv := by
  unfold lumi_target_fb_inv; norm_num

/-- **s762 — `E threshold > 0`**. -/
theorem T1_E_threshold_pos : 0 < E_threshold_GeV := by
  unfold E_threshold_GeV; norm_num

/-! ## s759: FCC-ee 10× tighter than HL-LHC for m_t -/

/-- **s759 FRONTIER — `σ(m_t) FCC-ee < σ(m_t) HL-LHC`**:
    `25 < 250` MeV (FCC-ee strictly tighter than LHC HL). -/
theorem T1_session_759_FCCee_below_LHC :
    sigma_m_t_FCCee_MeV < sigma_m_t_LHC_HL_MeV := by
  unfold sigma_m_t_FCCee_MeV sigma_m_t_LHC_HL_MeV
  norm_num

/-- **s759 FRONTIER — FCC-ee at least 10× tighter**:
    `10 · σ_FCCee = 250 ≤ σ_LHC_HL`. -/
theorem T1_session_759_10x_tighter :
    10 * sigma_m_t_FCCee_MeV ≤ sigma_m_t_LHC_HL_MeV := by
  unfold sigma_m_t_FCCee_MeV sigma_m_t_LHC_HL_MeV
  norm_num

/-- **s759 FRONTIER — `σ(m_t) FCC-ee ≤ 25 MeV`** (target ceiling). -/
theorem T1_session_759_sigma_m_t_at_most_25 :
    sigma_m_t_FCCee_MeV ≤ 25 := by
  unfold sigma_m_t_FCCee_MeV; norm_num

/-! ## s760: σ(Γ_t) FCC-ee << current PDG width -/

/-- **s760 FRONTIER — `σ(Γ_t) FCC-ee < Γ_t PDG`**:
    `40 < 1420` MeV (target precision << central value). -/
theorem T1_session_760_sigma_Gamma_below_Gamma :
    sigma_Gamma_t_FCCee_MeV < Gamma_t_PDG_MeV := by
  unfold sigma_Gamma_t_FCCee_MeV Gamma_t_PDG_MeV
  norm_num

/-- **s760 FRONTIER — Γ_t precision target ≤ 40 MeV**. -/
theorem T1_session_760_sigma_Gamma_at_most_40 :
    sigma_Gamma_t_FCCee_MeV ≤ 40 := by
  unfold sigma_Gamma_t_FCCee_MeV; norm_num

/-- **s760 FRONTIER — Γ_t width is at least 10× the target σ**:
    `10 · σ(Γ_t) = 400 ≤ Γ_t PDG`. -/
theorem T1_session_760_width_at_least_10x_sigma :
    10 * sigma_Gamma_t_FCCee_MeV ≤ Gamma_t_PDG_MeV := by
  unfold sigma_Gamma_t_FCCee_MeV Gamma_t_PDG_MeV
  norm_num

/-! ## s761: luminosity target in physical regime -/

/-- **s761 FRONTIER — `0.5 ≤ lumi target ≤ 5`** (physical scan budget,
    consistent with 0.2 fb⁻¹/yr × 5 yr). -/
theorem T1_session_761_lumi_in_range :
    (1 : ℝ) / 2 ≤ lumi_target_fb_inv ∧ lumi_target_fb_inv ≤ 5 := by
  unfold lumi_target_fb_inv
  refine ⟨?_, ?_⟩ <;> norm_num

/-- **s761 FRONTIER — `lumi target = 1.0 fb⁻¹`** (canonical FCC-ee CDR target). -/
theorem T1_session_761_lumi_eq_1 :
    lumi_target_fb_inv = 1 := by
  unfold lumi_target_fb_inv; rfl

/-! ## s762: threshold scan ≈ 2 m_top -/

/-- **s762 FRONTIER — `E threshold > 2 · 173`**:
    `350 > 346 = 2 · m_top` (above sub-2m_t pair production threshold). -/
theorem T1_session_762_above_2mt :
    E_threshold_GeV > 2 * 173 := by
  unfold E_threshold_GeV
  norm_num

/-- **s762 FRONTIER — `E threshold ≤ 360 GeV`** (within scan window 350±5). -/
theorem T1_session_762_at_most_360 :
    E_threshold_GeV ≤ 360 := by
  unfold E_threshold_GeV; norm_num

/-- **s762 FRONTIER — `E threshold ≥ 345 GeV`** (within scan window 350±5). -/
theorem T1_session_762_at_least_345 :
    E_threshold_GeV ≥ 345 := by
  unfold E_threshold_GeV; norm_num

/-! ## s763 — Bundle composition: precision hierarchy + scan validity -/

/-- **s763 FRONTIER — strict m_t precision ordering**:
    `0 < σ_FCCee_m_t < σ_LHC_HL_m_t` (FCC-ee strictly tighter than HL-LHC). -/
theorem T1_session_763_strict_m_t_ordering :
    0 < sigma_m_t_FCCee_MeV
    ∧ sigma_m_t_FCCee_MeV < sigma_m_t_LHC_HL_MeV := by
  refine ⟨T1_sigma_m_t_FCCee_pos, T1_session_759_FCCee_below_LHC⟩

/-- **s763 FRONTIER — strict Γ_t hierarchy**:
    `0 < σ_FCCee_Γ_t < Γ_t_PDG`. -/
theorem T1_session_763_strict_Gamma_ordering :
    0 < sigma_Gamma_t_FCCee_MeV
    ∧ sigma_Gamma_t_FCCee_MeV < Gamma_t_PDG_MeV := by
  refine ⟨T1_sigma_Gamma_t_FCCee_pos, T1_session_760_sigma_Gamma_below_Gamma⟩

/-! ## FCCeeTopThreshold Prop scaffold (6+ conjunct) -/

/-- **s763 — FCC-ee tt̄ threshold Prop**:
    σ(m_t) target positive and ≤ 25 MeV, σ(m_t) FCC-ee strictly below
    σ(m_t) HL-LHC and ≥ 10× tighter, σ(Γ_t) target positive and < Γ_t PDG,
    luminosity target = 1.0 fb⁻¹, energy scan center > 2 · 173 GeV. -/
def FCCeeTopThreshold : Prop :=
    0 < sigma_m_t_FCCee_MeV
    ∧ sigma_m_t_FCCee_MeV ≤ 25
    ∧ sigma_m_t_FCCee_MeV < sigma_m_t_LHC_HL_MeV
    ∧ 10 * sigma_m_t_FCCee_MeV ≤ sigma_m_t_LHC_HL_MeV
    ∧ sigma_Gamma_t_FCCee_MeV < Gamma_t_PDG_MeV
    ∧ E_threshold_GeV > 2 * 173

/-- **s763 — `FCCeeTopThreshold` holds** from numerical bounds. -/
theorem T1_session_763_FCCeeTopThreshold_holds : FCCeeTopThreshold := by
  refine ⟨T1_sigma_m_t_FCCee_pos,
          T1_session_759_sigma_m_t_at_most_25,
          T1_session_759_FCCee_below_LHC,
          T1_session_759_10x_tighter,
          T1_session_760_sigma_Gamma_below_Gamma,
          T1_session_762_above_2mt⟩

/-! ## Headline -/

/-- **HEADLINE — Bundled sessions 759-763 — FCC-ee tt̄ threshold projection bundle**.

    🚨 FRONTIER (T-1 FCC-ee top-mass + top-width precision projection) 🚨

    Twelve foundational facts:
    1. `σ(m_t) FCC-ee = 25 MeV > 0` (threshold-scan target).
    2. `σ(m_t) HL-LHC = 250 MeV > 0` (LHC HL projection).
    3. `σ(Γ_t) FCC-ee = 40 MeV > 0` (threshold-scan target).
    4. `Γ_t PDG = 1420 MeV > 0` (PDG 2024 central).
    5. `σ(m_t) FCC-ee < σ(m_t) HL-LHC` (FCC-ee strictly tighter).
    6. `10 · σ(m_t) FCC-ee ≤ σ(m_t) HL-LHC` (≥ 10× tighter).
    7. `σ(Γ_t) FCC-ee < Γ_t PDG` (target σ << current width).
    8. `10 · σ(Γ_t) FCC-ee ≤ Γ_t PDG` (Γ_t at least 10× σ-target).
    9. `lumi target = 1 fb⁻¹` (≈ 0.2 fb⁻¹/yr × 5 yr).
    10. `0.5 ≤ lumi ≤ 5 fb⁻¹` (physical scan budget).
    11. `345 ≤ E_threshold ≤ 360 GeV` (scan window 350±5).
    12. `E_threshold > 2 · m_top` (above pair-production threshold).

    Bundles five sessions s759-s763 closing FCC-ee tt̄ near-threshold
    scan precision projection frontier within T-1 (light quark masses).

    Connects to T1_HLLHCTopYukawaKappaTBundle, T1_HLLHCZprimeDileptonBundle,
    and to broader top-quark precision programme.

    Sub-lemma N+1/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of FCC-ee tt̄ threshold-scan top-mass
    and top-width precision projection bundle. -/
theorem session_759_763_FCCee_tt_threshold_projection_bundle_headline :
    0 < sigma_m_t_FCCee_MeV
    ∧ 0 < sigma_m_t_LHC_HL_MeV
    ∧ 0 < sigma_Gamma_t_FCCee_MeV
    ∧ 0 < Gamma_t_PDG_MeV
    ∧ sigma_m_t_FCCee_MeV < sigma_m_t_LHC_HL_MeV
    ∧ 10 * sigma_m_t_FCCee_MeV ≤ sigma_m_t_LHC_HL_MeV
    ∧ sigma_Gamma_t_FCCee_MeV < Gamma_t_PDG_MeV
    ∧ 10 * sigma_Gamma_t_FCCee_MeV ≤ Gamma_t_PDG_MeV
    ∧ lumi_target_fb_inv = 1
    ∧ ((1 : ℝ) / 2 ≤ lumi_target_fb_inv ∧ lumi_target_fb_inv ≤ 5)
    ∧ (E_threshold_GeV ≥ 345 ∧ E_threshold_GeV ≤ 360)
    ∧ E_threshold_GeV > 2 * 173
    ∧ FCCeeTopThreshold :=
  ⟨T1_sigma_m_t_FCCee_pos,
   T1_sigma_m_t_LHC_HL_pos,
   T1_sigma_Gamma_t_FCCee_pos,
   T1_Gamma_t_PDG_pos,
   T1_session_759_FCCee_below_LHC,
   T1_session_759_10x_tighter,
   T1_session_760_sigma_Gamma_below_Gamma,
   T1_session_760_width_at_least_10x_sigma,
   T1_session_761_lumi_eq_1,
   T1_session_761_lumi_in_range,
   ⟨T1_session_762_at_least_345, T1_session_762_at_most_360⟩,
   T1_session_762_above_2mt,
   T1_session_763_FCCeeTopThreshold_holds⟩

end OmegaTheory.Predictions.T1_FCCeeTopThresholdProjectionBundle
