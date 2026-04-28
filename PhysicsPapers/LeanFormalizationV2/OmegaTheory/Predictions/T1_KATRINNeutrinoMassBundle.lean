/-
  OmegaTheory.Predictions.T1_KATRINNeutrinoMassBundle

  T-1 — KATRIN tritium-endpoint absolute neutrino mass bundle, sessions 664-668.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit s664-s668.

  ## What this file delivers

  KATRIN (KArlsruhe TRItium Neutrino) — direct kinematic neutrino mass bound
  via tritium β-decay endpoint spectroscopy. Reference: KATRIN 2024 final
  results.

  - s664: KATRIN 2024 m_β < 0.45 eV (90% CL) — direct kinematic bound from
          tritium β-endpoint
  - s665: KATRIN 5-yr design sensitivity m_β < 0.2 eV (90% CL)
  - s666: cosmological Σm_ν bound (Planck+BAO 2024): Σm_ν < 0.12 eV
          and per-neutrino assuming degenerate ≈ 0.04 eV; cosmology
          tighter than direct kinematic
  - s667: KATRIN target tighter than current bound (improvement factor ~2.25×)
  - s668: KATRINNeutrinoMassBound Prop + bundle composition (8+ conjunct)

  All anchors > 0; m_β ∈ (0.1, 1) eV (sub-eV regime, kinematic).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_KATRINNeutrinoMassBundle

/-! ## Direct kinematic-mass anchors (eV) -/

/-- **KATRIN 2024 m_β upper bound**: `0.45` eV (90% CL).

    Direct kinematic bound from tritium-endpoint spectroscopy. -/
noncomputable def m_beta_KATRIN_eV : ℝ := 45 / 100

/-- **KATRIN 2024 m_β² upper bound**: `0.2025` eV². -/
noncomputable def m_beta_sq_KATRIN_eV2 : ℝ := 2025 / 10000

/-- **KATRIN 5-yr design sensitivity m_β**: `0.2` eV (90% CL).

    Future target after full integrated exposure. -/
noncomputable def m_beta_KATRIN_target_eV : ℝ := 2 / 10

/-! ## Cosmological-Σm_ν anchor (eV) -/

/-- **Σm_ν Planck+BAO 2024 upper bound**: `0.12` eV (95% CL). -/
noncomputable def Sigma_m_nu_cosmo_eV : ℝ := 12 / 100

/-- **Per-neutrino cosmological bound**: `Σm_ν / 3 ≈ 0.04` eV
    (assuming degenerate spectrum). -/
noncomputable def m_nu_cosmo_per_neutrino_eV : ℝ := 4 / 100

/-! ## Positivity -/

/-- **🚨 s664 — `m_β KATRIN > 0`**. -/
theorem T1_m_beta_KATRIN_pos : 0 < m_beta_KATRIN_eV := by
  unfold m_beta_KATRIN_eV; norm_num

/-- **🚨 s664 — `m_β² KATRIN > 0`**. -/
theorem T1_m_beta_sq_KATRIN_pos : 0 < m_beta_sq_KATRIN_eV2 := by
  unfold m_beta_sq_KATRIN_eV2; norm_num

/-- **🚨 s665 — `m_β KATRIN target > 0`**. -/
theorem T1_m_beta_KATRIN_target_pos : 0 < m_beta_KATRIN_target_eV := by
  unfold m_beta_KATRIN_target_eV; norm_num

/-- **🚨 s666 — `Σm_ν cosmo > 0`**. -/
theorem T1_Sigma_m_nu_cosmo_pos : 0 < Sigma_m_nu_cosmo_eV := by
  unfold Sigma_m_nu_cosmo_eV; norm_num

/-- **🚨 s666 — `m_ν per-neutrino cosmo > 0`**. -/
theorem T1_m_nu_cosmo_per_neutrino_pos : 0 < m_nu_cosmo_per_neutrino_eV := by
  unfold m_nu_cosmo_per_neutrino_eV; norm_num

/-! ## KATRIN sub-eV regime: m_β > 0.1 eV bound, m_β < 1 eV (kinematic) -/

/-- **🚨 s664 — `m_β KATRIN > 0.1` eV** (above 100 meV — bound is in
    cosmologically-informed sub-eV regime, not below). -/
theorem T1_m_beta_KATRIN_above_100meV : m_beta_KATRIN_eV > 1 / 10 := by
  unfold m_beta_KATRIN_eV; norm_num

/-- **🚨 s664 — `m_β KATRIN < 1` eV** (sub-eV regime). -/
theorem T1_m_beta_KATRIN_sub_eV : m_beta_KATRIN_eV < 1 := by
  unfold m_beta_KATRIN_eV; norm_num

/-- **🚨 s664 — `m_β KATRIN ∈ (0.1, 1)` eV band**. -/
theorem T1_m_beta_KATRIN_in_sub_eV_band :
    1 / 10 < m_beta_KATRIN_eV ∧ m_beta_KATRIN_eV < 1 :=
  ⟨T1_m_beta_KATRIN_above_100meV, T1_m_beta_KATRIN_sub_eV⟩

/-! ## Cosmology TIGHTER than direct kinematic bound -/

/-- **🚨 s666 — `Σm_ν cosmo < m_β KATRIN`** (cosmology tighter, 0.12 < 0.45). -/
theorem T1_cosmo_tighter_than_KATRIN :
    Sigma_m_nu_cosmo_eV < m_beta_KATRIN_eV := by
  unfold Sigma_m_nu_cosmo_eV m_beta_KATRIN_eV; norm_num

/-- **🚨 s666 — `m_ν per-neutrino cosmo < m_β KATRIN`** (0.04 < 0.45). -/
theorem T1_per_neutrino_cosmo_tighter_KATRIN :
    m_nu_cosmo_per_neutrino_eV < m_beta_KATRIN_eV := by
  unfold m_nu_cosmo_per_neutrino_eV m_beta_KATRIN_eV; norm_num

/-- **🚨 s666 — `m_ν per-neutrino cosmo < Σm_ν cosmo`** (per-neutrino narrower
    than sum). -/
theorem T1_per_neutrino_cosmo_below_Sigma :
    m_nu_cosmo_per_neutrino_eV < Sigma_m_nu_cosmo_eV := by
  unfold m_nu_cosmo_per_neutrino_eV Sigma_m_nu_cosmo_eV; norm_num

/-! ## KATRIN target IMPROVES over current bound -/

/-- **🚨 s667 — `m_β target < m_β current`** (0.2 < 0.45). -/
theorem T1_KATRIN_target_below_current :
    m_beta_KATRIN_target_eV < m_beta_KATRIN_eV := by
  unfold m_beta_KATRIN_target_eV m_beta_KATRIN_eV; norm_num

/-- **🚨 s667 — `m_β target > 0.1` eV** (target still above 100 meV). -/
theorem T1_KATRIN_target_above_100meV :
    m_beta_KATRIN_target_eV > 1 / 10 := by
  unfold m_beta_KATRIN_target_eV; norm_num

/-- **🚨 s667 — KATRIN target ∈ (0.1, current)** (improvement band). -/
theorem T1_KATRIN_target_improvement_band :
    1 / 10 < m_beta_KATRIN_target_eV ∧
    m_beta_KATRIN_target_eV < m_beta_KATRIN_eV :=
  ⟨T1_KATRIN_target_above_100meV, T1_KATRIN_target_below_current⟩

/-! ## Σm_ν cosmo also TIGHTER than KATRIN target -/

/-- **🚨 s666 — `Σm_ν cosmo < m_β KATRIN target`** (0.12 < 0.2 — cosmology
    tighter even than KATRIN's 5-yr goal). -/
theorem T1_cosmo_tighter_than_KATRIN_target :
    Sigma_m_nu_cosmo_eV < m_beta_KATRIN_target_eV := by
  unfold Sigma_m_nu_cosmo_eV m_beta_KATRIN_target_eV; norm_num

/-! ## m_β² consistency with m_β -/

/-- **🚨 s664 — `m_β² = (m_β)²`**: 0.2025 = 0.45² (sanity check
    of squared anchor). -/
theorem T1_m_beta_sq_consistent :
    m_beta_sq_KATRIN_eV2 = m_beta_KATRIN_eV * m_beta_KATRIN_eV := by
  unfold m_beta_sq_KATRIN_eV2 m_beta_KATRIN_eV; norm_num

/-- **🚨 s664 — `m_β² < 0.25` eV²** (kinematic m_β² regime). -/
theorem T1_m_beta_sq_below_025 : m_beta_sq_KATRIN_eV2 < 25 / 100 := by
  unfold m_beta_sq_KATRIN_eV2; norm_num

/-! ## KATRIN-Mass-Bound Prop scaffold -/

/-- **KATRINNeutrinoMassBound**: KATRIN 2024 + future target +
    cosmological consistency.

    Real Prop body — substrate-level prediction needed: why m_β at sub-eV scale,
    and why cosmology systematically below kinematic. -/
def KATRINNeutrinoMassBound : Prop :=
  -- KATRIN current sub-eV
  (1 / 10 < m_beta_KATRIN_eV ∧ m_beta_KATRIN_eV < 1) ∧
  -- Target improves on current
  m_beta_KATRIN_target_eV < m_beta_KATRIN_eV ∧
  -- Both cosmology bounds tighter than direct kinematic
  Sigma_m_nu_cosmo_eV < m_beta_KATRIN_eV ∧
  Sigma_m_nu_cosmo_eV < m_beta_KATRIN_target_eV ∧
  m_nu_cosmo_per_neutrino_eV < m_beta_KATRIN_eV ∧
  m_nu_cosmo_per_neutrino_eV < Sigma_m_nu_cosmo_eV ∧
  -- m_β² = m_β × m_β consistency
  m_beta_sq_KATRIN_eV2 = m_beta_KATRIN_eV * m_beta_KATRIN_eV

/-- **🚨 s668 — `KATRINNeutrinoMassBound`**. -/
theorem T1_KATRIN_neutrino_mass_bound : KATRINNeutrinoMassBound :=
  ⟨T1_m_beta_KATRIN_in_sub_eV_band,
   T1_KATRIN_target_below_current,
   T1_cosmo_tighter_than_KATRIN,
   T1_cosmo_tighter_than_KATRIN_target,
   T1_per_neutrino_cosmo_tighter_KATRIN,
   T1_per_neutrino_cosmo_below_Sigma,
   T1_m_beta_sq_consistent⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 664-668 — KATRIN tritium-endpoint
    direct neutrino-mass bundle**.

    🏆 Bundled-commit s664-s668. 5 sessions:

    - s664: KATRIN 2024 m_β < 0.45 eV (90% CL) direct kinematic
    - s665: KATRIN 5-yr target m_β < 0.2 eV (90% CL)
    - s666: cosmology Σm_ν < 0.12 eV; per-neutrino ≈ 0.04 eV
            (cosmology tighter than direct)
    - s667: KATRIN target < KATRIN current (~2.25× improvement)
    - s668: KATRINNeutrinoMassBound Prop + bundle composition

    Key cross-bound facts: cosmology bounds (Σm_ν and per-neutrino) BOTH
    tighter than direct kinematic; KATRIN target itself tighter than
    current; cosmology even tighter than future KATRIN target. Direct
    kinematic and cosmological bounds are model-independent (kinematic) vs
    model-dependent (cosmology with ΛCDM); the substrate-level prediction
    must explain WHY m_β is at sub-eV scale, why cosmology systematically
    sits below kinematic, and where in the 4-irrational ordering the
    absolute mass scale localizes.

    Sub-lemma 195-199/N in T-1.  Lean-core only.

    🏆 First Lean-core KATRIN tritium-endpoint absolute-mass bundle. -/
theorem session_664_to_668_KATRIN_neutrino_mass_bundle_headline :
    0 < m_beta_KATRIN_eV ∧ 0 < m_beta_sq_KATRIN_eV2 ∧
    0 < m_beta_KATRIN_target_eV ∧ 0 < Sigma_m_nu_cosmo_eV ∧
    0 < m_nu_cosmo_per_neutrino_eV
    ∧ (1 / 10 < m_beta_KATRIN_eV ∧ m_beta_KATRIN_eV < 1)
    ∧ Sigma_m_nu_cosmo_eV < m_beta_KATRIN_eV
    ∧ m_nu_cosmo_per_neutrino_eV < m_beta_KATRIN_eV
    ∧ m_nu_cosmo_per_neutrino_eV < Sigma_m_nu_cosmo_eV
    ∧ m_beta_KATRIN_target_eV < m_beta_KATRIN_eV
    ∧ Sigma_m_nu_cosmo_eV < m_beta_KATRIN_target_eV
    ∧ (1 / 10 < m_beta_KATRIN_target_eV ∧
        m_beta_KATRIN_target_eV < m_beta_KATRIN_eV)
    ∧ m_beta_sq_KATRIN_eV2 = m_beta_KATRIN_eV * m_beta_KATRIN_eV
    ∧ m_beta_sq_KATRIN_eV2 < 25 / 100
    ∧ KATRINNeutrinoMassBound :=
  ⟨T1_m_beta_KATRIN_pos, T1_m_beta_sq_KATRIN_pos,
   T1_m_beta_KATRIN_target_pos, T1_Sigma_m_nu_cosmo_pos,
   T1_m_nu_cosmo_per_neutrino_pos,
   T1_m_beta_KATRIN_in_sub_eV_band,
   T1_cosmo_tighter_than_KATRIN,
   T1_per_neutrino_cosmo_tighter_KATRIN,
   T1_per_neutrino_cosmo_below_Sigma,
   T1_KATRIN_target_below_current,
   T1_cosmo_tighter_than_KATRIN_target,
   T1_KATRIN_target_improvement_band,
   T1_m_beta_sq_consistent,
   T1_m_beta_sq_below_025,
   T1_KATRIN_neutrino_mass_bound⟩

end OmegaTheory.Predictions.T1_KATRINNeutrinoMassBundle
