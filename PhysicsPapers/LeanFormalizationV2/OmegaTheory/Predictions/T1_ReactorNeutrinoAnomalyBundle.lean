/-
  OmegaTheory.Predictions.T1_ReactorNeutrinoAnomalyBundle

  T-1 — Reactor Antineutrino Anomaly (RAA) bundle, sessions 669-673.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Short-baseline reactor antineutrino flux deficit (PROSPECT 2024 +
  Daya Bay near, combined short-baseline):

  - s669: Observed/predicted ratio R_obs/exp ≈ 0.945 ± 0.024
          (`R_obs_pred_units := 945`, `sigma_R_units := 24` — units of 10⁻³)
  - s670: Standard prediction (no oscillation): R_pred = 1.000
          (`R_pred_units := 1000` — units of 10⁻³)
  - s671: Deficit Δ = R_pred - R_obs = 0.055 (5.5% effect)
          (`Delta_R_units := 55`); R_obs < R_pred and Δ > 2σ (55 > 48)
  - s672: Sterile-neutrino interpretation Δm²_sterile ≈ 1.7 eV²
          (`delta_m_sq_sterile_eV2 := 17/10`,
           `sin2_2theta_eV_target := 1/10`)
  - s673: bundle composition + ReactorNeutrinoAnomaly Prop (5+ conjunct)

  ## Honest framing

  This is an UNRESOLVED ~2σ anomaly. The bundle records the consistency
  of measurements (deficit > 2σ, eV-scale Δm²) without claiming the
  sterile-neutrino interpretation is confirmed.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_ReactorNeutrinoAnomalyBundle

/-! ## RAA anchors (units of 10⁻³ for the ratio block) -/

/-- **Observed/predicted ratio (PROSPECT 2024 + Daya Bay near)**: `0.945`.
    In units of 10⁻³: `945`. -/
noncomputable def R_obs_pred_units : ℝ := 945

/-- **Combined short-baseline statistical uncertainty**: `0.024`.
    In units of 10⁻³: `24`. -/
noncomputable def sigma_R_units : ℝ := 24

/-- **Standard (no-oscillation) prediction**: `1.000`.
    In units of 10⁻³: `1000`. -/
noncomputable def R_pred_units : ℝ := 1000

/-- **Deficit `R_pred − R_obs`**: `0.055`.
    In units of 10⁻³: `55`. -/
noncomputable def Delta_R_units : ℝ := 55

/-! ## Sterile-neutrino interpretation anchors -/

/-- **Δm²_sterile (eV²)** — sterile-active mass-squared splitting: `1.7`.
    Stored as a rational: `17/10`. -/
noncomputable def delta_m_sq_sterile_eV2 : ℝ := 17 / 10

/-- **sin²(2θ_eV)** — sterile-active mixing-angle squared (target): `0.1`.
    Stored as a rational: `1/10`. -/
noncomputable def sin2_2theta_eV_target : ℝ := 1 / 10

/-- **Atmospheric-scale Δm² (eV²)** — for hierarchy comparison: `2.5×10⁻³`. -/
noncomputable def delta_m_sq_atm_eV2 : ℝ := 25 / 10000

/-! ## Positivity -/

/-- **🚨 s669 — `R_obs/exp > 0`**. -/
theorem T1_R_obs_pred_pos : 0 < R_obs_pred_units := by
  unfold R_obs_pred_units; norm_num

/-- **🚨 s669 — `σ_R > 0`**. -/
theorem T1_sigma_R_pos : 0 < sigma_R_units := by
  unfold sigma_R_units; norm_num

/-- **🚨 s670 — `R_pred > 0`**. -/
theorem T1_R_pred_pos : 0 < R_pred_units := by
  unfold R_pred_units; norm_num

/-- **🚨 s671 — `Δ_R > 0`**. -/
theorem T1_Delta_R_pos : 0 < Delta_R_units := by
  unfold Delta_R_units; norm_num

/-- **🚨 s672 — `Δm²_sterile > 0`**. -/
theorem T1_delta_m_sq_sterile_pos : 0 < delta_m_sq_sterile_eV2 := by
  unfold delta_m_sq_sterile_eV2; norm_num

/-- **🚨 s672 — `sin²(2θ_eV) > 0`**. -/
theorem T1_sin2_2theta_eV_pos : 0 < sin2_2theta_eV_target := by
  unfold sin2_2theta_eV_target; norm_num

/-- **🚨 s672 — `Δm²_atm > 0`**. -/
theorem T1_delta_m_sq_atm_pos : 0 < delta_m_sq_atm_eV2 := by
  unfold delta_m_sq_atm_eV2; norm_num

/-! ## Deficit: R_obs < R_pred -/

/-- **🚨 s671 — `R_obs < R_pred`** (the anomaly is a deficit). -/
theorem T1_R_obs_lt_R_pred : R_obs_pred_units < R_pred_units := by
  unfold R_obs_pred_units R_pred_units; norm_num

/-- **🚨 s671 — `Δ_R = R_pred − R_obs`** (definition consistency). -/
theorem T1_Delta_R_eq_diff : Delta_R_units = R_pred_units - R_obs_pred_units := by
  unfold Delta_R_units R_pred_units R_obs_pred_units; norm_num

/-! ## Statistical significance: Δ > 2σ -/

/-- **🚨 s671 — `Δ_R > 2 σ_R`** (deficit > 2σ — statistically meaningful). -/
theorem T1_Delta_above_2sigma : Delta_R_units > 2 * sigma_R_units := by
  unfold Delta_R_units sigma_R_units; norm_num

/-- **🚨 s671 — `Δ_R < 3 σ_R`** (deficit < 3σ — anomaly NOT confirmed). -/
theorem T1_Delta_below_3sigma : Delta_R_units < 3 * sigma_R_units := by
  unfold Delta_R_units sigma_R_units; norm_num

/-- **🚨 s671 — anomaly band `2σ < Δ < 3σ`** — unresolved ~2σ effect. -/
theorem T1_Delta_in_2_3_sigma_band :
    2 * sigma_R_units < Delta_R_units ∧ Delta_R_units < 3 * sigma_R_units :=
  ⟨T1_Delta_above_2sigma, T1_Delta_below_3sigma⟩

/-! ## R_obs/exp band: 0.92 < R_obs < 0.97 (within data) -/

/-- **🚨 s669 — `R_obs > 0.92`** (in units of 10⁻³ : `R_obs > 920`). -/
theorem T1_R_obs_above_092 : R_obs_pred_units > 920 := by
  unfold R_obs_pred_units; norm_num

/-- **🚨 s669 — `R_obs < 0.97`** (in units of 10⁻³ : `R_obs < 970`). -/
theorem T1_R_obs_below_097 : R_obs_pred_units < 970 := by
  unfold R_obs_pred_units; norm_num

/-- **🚨 s669 — `R_obs ∈ [0.92, 0.97]`** (PROSPECT/Daya Bay band). -/
theorem T1_R_obs_in_band :
    920 < R_obs_pred_units ∧ R_obs_pred_units < 970 :=
  ⟨T1_R_obs_above_092, T1_R_obs_below_097⟩

/-! ## Sterile-neutrino mass scale: eV² >> atmospheric Δm² -/

/-- **🚨 s672 — `Δm²_sterile > 1 eV²`** (eV-scale, not atmospheric). -/
theorem T1_delta_m_sq_sterile_above_1 : delta_m_sq_sterile_eV2 > 1 := by
  unfold delta_m_sq_sterile_eV2; norm_num

/-- **🚨 s672 — `Δm²_sterile < 2 eV²`** (eV-scale upper band). -/
theorem T1_delta_m_sq_sterile_below_2 : delta_m_sq_sterile_eV2 < 2 := by
  unfold delta_m_sq_sterile_eV2; norm_num

/-- **🚨 s672 — `Δm²_sterile >> Δm²_atm`** (eV² >> 10⁻³ eV²). -/
theorem T1_sterile_above_atm :
    delta_m_sq_sterile_eV2 > delta_m_sq_atm_eV2 := by
  unfold delta_m_sq_sterile_eV2 delta_m_sq_atm_eV2; norm_num

/-- **🚨 s672 — `Δm²_sterile / Δm²_atm > 100`** (separation by ~100×). -/
theorem T1_sterile_atm_ratio_above_100 :
    delta_m_sq_sterile_eV2 > 100 * delta_m_sq_atm_eV2 := by
  unfold delta_m_sq_sterile_eV2 delta_m_sq_atm_eV2; norm_num

/-! ## Mixing-angle target: sin²(2θ_eV) ∈ (0, 1) -/

/-- **🚨 s672 — `sin²(2θ_eV) < 1`** (physical mixing). -/
theorem T1_sin2_2theta_eV_below_1 : sin2_2theta_eV_target < 1 := by
  unfold sin2_2theta_eV_target; norm_num

/-- **🚨 s672 — `sin²(2θ_eV) < sin²(2θ_PMNS)`** (sterile mixing < solar — small).
    Compare to PMNS sin²(2θ_12) = 0.851 from Solar/PMNS bundle. Here we use a
    safe upper proxy `1/2`. -/
theorem T1_sterile_mixing_small : sin2_2theta_eV_target < 1 / 2 := by
  unfold sin2_2theta_eV_target; norm_num

/-! ## RAA Prop scaffold -/

/-- **ReactorNeutrinoAnomaly**: 5+ conjunct compositional Prop.

    Records the consistency of the RAA measurement (deficit > 2σ, eV-scale
    Δm², small mixing angle) without claiming the sterile interpretation is
    confirmed. -/
def ReactorNeutrinoAnomaly : Prop :=
  -- Anchors positive
  0 < R_obs_pred_units ∧
  0 < R_pred_units ∧
  0 < sigma_R_units ∧
  -- Deficit
  R_obs_pred_units < R_pred_units ∧
  Delta_R_units = R_pred_units - R_obs_pred_units ∧
  -- Statistical band: 2σ < Δ < 3σ (unresolved ~2σ effect)
  (2 * sigma_R_units < Delta_R_units ∧ Delta_R_units < 3 * sigma_R_units) ∧
  -- Observed band
  (920 < R_obs_pred_units ∧ R_obs_pred_units < 970) ∧
  -- Sterile interpretation: eV-scale, much above atmospheric
  delta_m_sq_sterile_eV2 > delta_m_sq_atm_eV2 ∧
  delta_m_sq_sterile_eV2 > 100 * delta_m_sq_atm_eV2 ∧
  -- Mixing-angle target small but positive
  (0 < sin2_2theta_eV_target ∧ sin2_2theta_eV_target < 1 / 2)

/-- **🚨 s673 — `ReactorNeutrinoAnomaly`**. -/
theorem T1_reactor_neutrino_anomaly : ReactorNeutrinoAnomaly :=
  ⟨T1_R_obs_pred_pos, T1_R_pred_pos, T1_sigma_R_pos,
   T1_R_obs_lt_R_pred, T1_Delta_R_eq_diff,
   T1_Delta_in_2_3_sigma_band,
   T1_R_obs_in_band,
   T1_sterile_above_atm, T1_sterile_atm_ratio_above_100,
   ⟨T1_sin2_2theta_eV_pos, T1_sterile_mixing_small⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 669-673 — Reactor Antineutrino Anomaly bundle**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s669: R_obs/exp = 0.945 ± 0.024 (PROSPECT 2024 + Daya Bay near)
    - s670: R_pred = 1.000 (no-oscillation standard)
    - s671: Δ = 0.055, deficit > 2σ (55 > 48), < 3σ (unresolved)
    - s672: Sterile interpretation Δm² ≈ 1.7 eV², mixing ≤ 0.1
    - s673: bundle composition + ReactorNeutrinoAnomaly Prop

    Plus ReactorNeutrinoAnomaly Prop (10-conjunct).

    HONEST FRAMING: this is an UNRESOLVED ~2σ effect. The bundle records
    measurement consistency (deficit > 2σ, eV-scale Δm², small mixing)
    WITHOUT claiming the sterile-neutrino interpretation is confirmed.

    Sub-lemma slot in T-1.  Lean-core only. -/
theorem session_669_to_673_RAA_bundle_headline :
    0 < R_obs_pred_units ∧ 0 < R_pred_units ∧ 0 < sigma_R_units
    ∧ 0 < Delta_R_units
    ∧ 0 < delta_m_sq_sterile_eV2 ∧ 0 < sin2_2theta_eV_target
    ∧ 0 < delta_m_sq_atm_eV2
    ∧ R_obs_pred_units < R_pred_units
    ∧ Delta_R_units = R_pred_units - R_obs_pred_units
    ∧ Delta_R_units > 2 * sigma_R_units
    ∧ Delta_R_units < 3 * sigma_R_units
    ∧ (920 < R_obs_pred_units ∧ R_obs_pred_units < 970)
    ∧ delta_m_sq_sterile_eV2 > 1
    ∧ delta_m_sq_sterile_eV2 < 2
    ∧ delta_m_sq_sterile_eV2 > delta_m_sq_atm_eV2
    ∧ delta_m_sq_sterile_eV2 > 100 * delta_m_sq_atm_eV2
    ∧ sin2_2theta_eV_target < 1
    ∧ sin2_2theta_eV_target < 1 / 2
    ∧ ReactorNeutrinoAnomaly :=
  ⟨T1_R_obs_pred_pos, T1_R_pred_pos, T1_sigma_R_pos,
   T1_Delta_R_pos,
   T1_delta_m_sq_sterile_pos, T1_sin2_2theta_eV_pos,
   T1_delta_m_sq_atm_pos,
   T1_R_obs_lt_R_pred,
   T1_Delta_R_eq_diff,
   T1_Delta_above_2sigma,
   T1_Delta_below_3sigma,
   T1_R_obs_in_band,
   T1_delta_m_sq_sterile_above_1,
   T1_delta_m_sq_sterile_below_2,
   T1_sterile_above_atm,
   T1_sterile_atm_ratio_above_100,
   T1_sin2_2theta_eV_below_1,
   T1_sterile_mixing_small,
   T1_reactor_neutrino_anomaly⟩

end OmegaTheory.Predictions.T1_ReactorNeutrinoAnomalyBundle
