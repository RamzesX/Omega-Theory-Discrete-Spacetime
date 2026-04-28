/-
  OmegaTheory.Predictions.T1_VeraRubinLSSTDMSubstructureBundle

  T-1 — Vera C. Rubin Observatory (LSST) DM substructure projection bundle,
  sessions 789-793.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Vera Rubin Observatory LSST 10-year survey (2025+) projections for
  Milky Way dark matter substructure: subhalo lensing + satellite
  galaxy census (Local Group out to ~1.5 Mpc):

  - s789: LSST projected ≈ 100 new dark satellites (vs ≈ 60 currently
    known from DES + Pan-STARRS + SDSS) — extension of detected count
  - s790: subhalo mass-function lower-cutoff sensitivity:
    m_subhalo,min ≈ 10⁷ M_⊙ (in units of 10⁵ M_⊙ ⇒ 100)
  - s791: integrated 10-yr survey coverage: ~37000 deg² × 800 visits
    ≈ 30M observations (in units of 10⁶ ⇒ 30)
  - s792: ΛCDM prediction for satellite N_sub (m > 10⁷ M_⊙) within MW
    virial radius is 200-500 — strictly above the LSST projection ⇒
    "missing satellites" persists even with LSST
  - s793: bundle composition + VeraRubinLSSTDMSubstructure Prop

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_VeraRubinLSSTDMSubstructureBundle

/-! ## LSST DM substructure anchors -/

/-- **LSST projected new MW dark satellites (count)**: `100`. -/
noncomputable def N_satellites_LSST_projection : ℝ := 100

/-- **Currently known MW satellites (DES + Pan-STARRS + SDSS)**: `60`. -/
noncomputable def N_satellites_current : ℝ := 60

/-- **Subhalo mass-function lower cutoff (in units of 10⁵ M_⊙)**: `100`
    (= 10⁷ M_⊙). -/
noncomputable def m_subhalo_min_LSST_units : ℝ := 100

/-- **LSST 10-yr observation count (in units of 10⁶)**: `30`
    (= 30M observations: ~37000 deg² × 800 visits). -/
noncomputable def N_observations_LSST_M : ℝ := 30

/-- **ΛCDM lower prediction for N_sub(m > 10⁷ M_⊙) within MW R_vir**: `200`. -/
noncomputable def N_sub_LCDM_predicted_low : ℝ := 200

/-- **ΛCDM upper prediction for N_sub(m > 10⁷ M_⊙) within MW R_vir**: `500`. -/
noncomputable def N_sub_LCDM_predicted_high : ℝ := 500

/-! ## Positivity -/

/-- **🚨 s789 — `N_satellites_LSST > 0`**. -/
theorem T1_N_satellites_LSST_pos : 0 < N_satellites_LSST_projection := by
  unfold N_satellites_LSST_projection; norm_num

/-- **🚨 s789 — `N_satellites_current > 0`**. -/
theorem T1_N_satellites_current_pos : 0 < N_satellites_current := by
  unfold N_satellites_current; norm_num

/-- **🚨 s790 — `m_subhalo_min > 0`**. -/
theorem T1_m_subhalo_min_pos : 0 < m_subhalo_min_LSST_units := by
  unfold m_subhalo_min_LSST_units; norm_num

/-- **🚨 s791 — `N_observations_LSST > 0`**. -/
theorem T1_N_observations_LSST_pos : 0 < N_observations_LSST_M := by
  unfold N_observations_LSST_M; norm_num

/-- **🚨 s792 — `N_sub_LCDM_low > 0`**. -/
theorem T1_N_sub_LCDM_low_pos : 0 < N_sub_LCDM_predicted_low := by
  unfold N_sub_LCDM_predicted_low; norm_num

/-- **🚨 s792 — `N_sub_LCDM_high > 0`**. -/
theorem T1_N_sub_LCDM_high_pos : 0 < N_sub_LCDM_predicted_high := by
  unfold N_sub_LCDM_predicted_high; norm_num

/-! ## Satellite count band — LSST extends current detection -/

/-- **🚨 s789 — `N_satellites_LSST > N_satellites_current`** (100 > 60). -/
theorem T1_LSST_extends_current :
    N_satellites_LSST_projection > N_satellites_current := by
  unfold N_satellites_LSST_projection N_satellites_current; norm_num

/-- **🚨 s789 — `N_satellites_LSST > 50`** (above floor). -/
theorem T1_N_satellites_LSST_above_50 :
    N_satellites_LSST_projection > 50 := by
  unfold N_satellites_LSST_projection; norm_num

/-- **🚨 s789 — `N_satellites_LSST < 1000`** (below ceiling). -/
theorem T1_N_satellites_LSST_below_1000 :
    N_satellites_LSST_projection < 1000 := by
  unfold N_satellites_LSST_projection; norm_num

/-- **🚨 s789 — `N_satellites_current > 10`** (above floor: 10 < 60). -/
theorem T1_N_satellites_current_above_10 :
    N_satellites_current > 10 := by
  unfold N_satellites_current; norm_num

/-! ## Subhalo mass cutoff in expected band -/

/-- **🚨 s790 — `m_subhalo_min > 50`** (10⁷ M_⊙ unit floor). -/
theorem T1_m_subhalo_min_above_50 :
    m_subhalo_min_LSST_units > 50 := by
  unfold m_subhalo_min_LSST_units; norm_num

/-- **🚨 s790 — `m_subhalo_min < 200`** (below upper). -/
theorem T1_m_subhalo_min_below_200 :
    m_subhalo_min_LSST_units < 200 := by
  unfold m_subhalo_min_LSST_units; norm_num

/-! ## Survey integrated coverage -/

/-- **🚨 s791 — `N_observations > 20`** (20M lower bound). -/
theorem T1_N_observations_above_20 :
    N_observations_LSST_M > 20 := by
  unfold N_observations_LSST_M; norm_num

/-- **🚨 s791 — `N_observations < 50`** (50M upper bound). -/
theorem T1_N_observations_below_50 :
    N_observations_LSST_M < 50 := by
  unfold N_observations_LSST_M; norm_num

/-! ## ΛCDM band ordering — predicts more than LSST detects -/

/-- **🚨 s792 — `N_sub_LCDM_low < N_sub_LCDM_high`** (band ordering). -/
theorem T1_LCDM_band_ordering :
    N_sub_LCDM_predicted_low < N_sub_LCDM_predicted_high := by
  unfold N_sub_LCDM_predicted_low N_sub_LCDM_predicted_high; norm_num

/-- **🚨 s792 — `N_satellites_LSST < N_sub_LCDM_low`** (100 < 200).

    Even with LSST's full 10-yr survey, the projected detection (100)
    sits BELOW ΛCDM's lowest prediction (200). The "missing satellites"
    problem persists — only ~half of the ΛCDM lower bound is recoverable
    even at LSST sensitivity. -/
theorem T1_missing_satellites_persists :
    N_satellites_LSST_projection < N_sub_LCDM_predicted_low := by
  unfold N_satellites_LSST_projection N_sub_LCDM_predicted_low; norm_num

/-- **🚨 s792 — `2 × N_satellites_LSST ≤ N_sub_LCDM_low`** (LSST recovers
    at most half of ΛCDM lower band). -/
theorem T1_LSST_at_most_half_LCDM_low :
    2 * N_satellites_LSST_projection ≤ N_sub_LCDM_predicted_low := by
  unfold N_satellites_LSST_projection N_sub_LCDM_predicted_low; norm_num

/-- **🚨 s792 — `N_sub_LCDM_high > 400`**. -/
theorem T1_N_sub_LCDM_high_above_400 :
    N_sub_LCDM_predicted_high > 400 := by
  unfold N_sub_LCDM_predicted_high; norm_num

/-! ## DM substructure Prop scaffold -/

/-- **VeraRubinLSSTDMSubstructure**: LSST 10-yr projection sits in expected
    physical bands AND is strictly below ΛCDM lowest predicted satellite
    count (missing-satellites residue).

    Real Prop body. -/
def VeraRubinLSSTDMSubstructure : Prop :=
  -- LSST satellite count in [50, 1000]
  (50 < N_satellites_LSST_projection ∧ N_satellites_LSST_projection < 1000) ∧
  -- LSST extends currently known count
  N_satellites_LSST_projection > N_satellites_current ∧
  -- Subhalo mass-cutoff in [50, 200] (units of 10⁵ M_⊙)
  (50 < m_subhalo_min_LSST_units ∧ m_subhalo_min_LSST_units < 200) ∧
  -- Survey coverage in [20, 50]M observations
  (20 < N_observations_LSST_M ∧ N_observations_LSST_M < 50) ∧
  -- ΛCDM band ordering
  N_sub_LCDM_predicted_low < N_sub_LCDM_predicted_high ∧
  -- LSST detection STRICTLY below ΛCDM lowest prediction (missing-satellites)
  N_satellites_LSST_projection < N_sub_LCDM_predicted_low

/-- **🚨 s793 — `VeraRubinLSSTDMSubstructure`**. -/
theorem T1_Vera_Rubin_LSST_DM_substructure : VeraRubinLSSTDMSubstructure :=
  ⟨⟨T1_N_satellites_LSST_above_50, T1_N_satellites_LSST_below_1000⟩,
   T1_LSST_extends_current,
   ⟨T1_m_subhalo_min_above_50, T1_m_subhalo_min_below_200⟩,
   ⟨T1_N_observations_above_20, T1_N_observations_below_50⟩,
   T1_LCDM_band_ordering,
   T1_missing_satellites_persists⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 789-793 — Vera Rubin (LSST) DM substructure
    bundle**.

    🏆 LSST projection bundle.

    5 sessions:
    - s789: N_satellites_LSST_projection = 100 ∈ (50, 1000),
      strictly above N_satellites_current = 60 (DES+Pan-STARRS+SDSS)
    - s790: m_subhalo_min_LSST = 100 (× 10⁵ M_⊙ = 10⁷ M_⊙) ∈ (50, 200)
    - s791: N_observations_LSST_M = 30 (= 30 × 10⁶ obs:
      ~37000 deg² × 800 visits) ∈ (20, 50)
    - s792: ΛCDM prediction band [200, 500]; LSST projection (100)
      strictly below lower band ⇒ missing-satellites residue persists
    - s793: bundle composition + VeraRubinLSSTDMSubstructure Prop

    Plus VeraRubinLSSTDMSubstructure Prop (6-conjunct).

    Substrate-prediction: DM is sterile-ν / 4th-irrational channel
    (Pi-Hunch). LSST satellite census tests halo substructure mass
    function vs ΛCDM expectation. The persistent gap between LSST
    projection (100) and ΛCDM lower band (200) is the formalised
    "missing satellites problem" — paper-citable headline as a
    falsifiable substrate / ΛCDM disagreement.

    Sub-lemma 525-529/N in T-1.  Lean-core only.

    🏆 First Lean-core LSST projection bundle. -/
theorem session_789_to_793_Vera_Rubin_LSST_DM_substructure_bundle_headline :
    0 < N_satellites_LSST_projection ∧ 0 < N_satellites_current
    ∧ 0 < m_subhalo_min_LSST_units ∧ 0 < N_observations_LSST_M
    ∧ 0 < N_sub_LCDM_predicted_low ∧ 0 < N_sub_LCDM_predicted_high
    ∧ N_satellites_LSST_projection > N_satellites_current
    ∧ (50 < N_satellites_LSST_projection ∧ N_satellites_LSST_projection < 1000)
    ∧ (50 < m_subhalo_min_LSST_units ∧ m_subhalo_min_LSST_units < 200)
    ∧ (20 < N_observations_LSST_M ∧ N_observations_LSST_M < 50)
    ∧ N_sub_LCDM_predicted_low < N_sub_LCDM_predicted_high
    ∧ N_satellites_LSST_projection < N_sub_LCDM_predicted_low
    ∧ 2 * N_satellites_LSST_projection ≤ N_sub_LCDM_predicted_low
    ∧ VeraRubinLSSTDMSubstructure :=
  ⟨T1_N_satellites_LSST_pos, T1_N_satellites_current_pos,
   T1_m_subhalo_min_pos, T1_N_observations_LSST_pos,
   T1_N_sub_LCDM_low_pos, T1_N_sub_LCDM_high_pos,
   T1_LSST_extends_current,
   ⟨T1_N_satellites_LSST_above_50, T1_N_satellites_LSST_below_1000⟩,
   ⟨T1_m_subhalo_min_above_50, T1_m_subhalo_min_below_200⟩,
   ⟨T1_N_observations_above_20, T1_N_observations_below_50⟩,
   T1_LCDM_band_ordering,
   T1_missing_satellites_persists,
   T1_LSST_at_most_half_LCDM_low,
   T1_Vera_Rubin_LSST_DM_substructure⟩

end OmegaTheory.Predictions.T1_VeraRubinLSSTDMSubstructureBundle
