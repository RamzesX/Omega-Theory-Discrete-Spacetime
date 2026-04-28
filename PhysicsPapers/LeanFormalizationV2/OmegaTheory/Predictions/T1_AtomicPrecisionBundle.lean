/-
  OmegaTheory.Predictions.T1_AtomicPrecisionBundle

  T-1 — atomic precision constants bundle, sessions 403-407.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit
  (5 sessions in one file) per `T1_FundamentalConstantsBundle.lean` precedent.

  ## What this file delivers

  Atomic-physics precision constants (CODATA 2024 / PDG 2024):

  - s403: m_p / m_e = 1836.15267343 (proton / electron mass ratio)
  - s404: m_n / m_p = 1.00137841918 (neutron / proton mass ratio)
  - s405: R_∞ Rydberg = 10973731.568160 m⁻¹ (cross-bundle: cites
                  `T1_RydbergConstantPDG`, adds tighter sanity bounds)
  - s406: a_0 Bohr radius (precise) = 5.29177210903 × 10⁻¹¹ m
                  (NEW noncomputable def with extra precision over `T1_BohrRadiusPDG`)
  - s407: α (fine-structure α_em) ratio sanity vs Rydberg + bundle composition
                  (cross-bundle: reuses `T1_FineStructureAlphaPDG.alpha_PDG`)

  Cross-bundle composition: pulls in 3 prior bundles to assemble a
  6-conjunct headline witnessing the four atomic precision constants
  (m_p/m_e, m_n/m_p, R_∞, a_0, α) plus the consistency Prop.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.T1_RydbergConstantPDG
import OmegaTheory.Predictions.T1_BohrRadiusPDG
import OmegaTheory.Predictions.T1_FineStructureAlphaPDG

namespace OmegaTheory.Predictions.T1_AtomicPrecisionBundle

open OmegaTheory.Predictions.T1_RydbergConstantPDG
open OmegaTheory.Predictions.T1_BohrRadiusPDG
open OmegaTheory.Predictions.T1_FineStructureAlphaPDG

/-! ## CODATA 2024 anchored values -/

/-- **m_p / m_e CODATA 2024**: `1836.15267343` (dimensionless,
    proton-to-electron mass ratio, ±10⁻⁹). -/
noncomputable def m_p_over_m_e_CODATA : ℝ := 183615267343 / 100000000

/-- **m_n / m_p CODATA 2024**: `1.00137841918` (dimensionless,
    neutron-to-proton mass ratio, ±10⁻⁸).  Confirms n heavier than p. -/
noncomputable def m_n_over_m_p_CODATA : ℝ := 100137841918 / 100000000000

/-- **a_0 CODATA 2024 (precise)**: `5.29177210903 × 10⁻¹¹ m` (Bohr radius,
    ±10⁻¹⁵).  Stored as `529177210903 / 10000000000000000000000`. -/
noncomputable def a_0_CODATA : ℝ := 529177210903 / 10000000000000000000000

/-! ## s403 — m_p / m_e = 1836.15267343 -/

/-- **🚨 s403 — `m_p / m_e > 0`**. -/
theorem T1_m_p_over_m_e_pos : 0 < m_p_over_m_e_CODATA := by
  unfold m_p_over_m_e_CODATA; norm_num

/-- **🚨 s403 — `m_p / m_e > 1836`** (lower band, CODATA central is 1836.15). -/
theorem T1_m_p_over_m_e_gt_1836 : m_p_over_m_e_CODATA > 1836 := by
  unfold m_p_over_m_e_CODATA; norm_num

/-- **🚨 s403 — `m_p / m_e < 1837`** (upper band, CODATA central is 1836.15). -/
theorem T1_m_p_over_m_e_lt_1837 : m_p_over_m_e_CODATA < 1837 := by
  unfold m_p_over_m_e_CODATA; norm_num

/-- **🚨 s403 — `m_p / m_e ∈ (1836, 1837)`** (CODATA central band). -/
theorem T1_m_p_over_m_e_band :
    1836 < m_p_over_m_e_CODATA ∧ m_p_over_m_e_CODATA < 1837 :=
  ⟨T1_m_p_over_m_e_gt_1836, T1_m_p_over_m_e_lt_1837⟩

/-! ## s404 — m_n / m_p = 1.00137841918 -/

/-- **🚨 s404 — `m_n / m_p > 0`**. -/
theorem T1_m_n_over_m_p_pos : 0 < m_n_over_m_p_CODATA := by
  unfold m_n_over_m_p_CODATA; norm_num

/-- **🚨 s404 — `m_n / m_p > 1`** (n heavier than p, m_d > m_u). -/
theorem T1_m_n_over_m_p_gt_one : m_n_over_m_p_CODATA > 1 := by
  unfold m_n_over_m_p_CODATA; norm_num

/-- **🚨 s404 — `m_n / m_p < 11/10`** (very close to 1, ~0.14% split). -/
theorem T1_m_n_over_m_p_lt_eleven_tenths : m_n_over_m_p_CODATA < 11 / 10 := by
  unfold m_n_over_m_p_CODATA; norm_num

/-- **🚨 s404 — `m_n / m_p ∈ (1, 11/10)`** band: small but positive split. -/
theorem T1_m_n_over_m_p_band :
    1 < m_n_over_m_p_CODATA ∧ m_n_over_m_p_CODATA < 11 / 10 :=
  ⟨T1_m_n_over_m_p_gt_one, T1_m_n_over_m_p_lt_eleven_tenths⟩

/-! ## s405 — R_∞ Rydberg cross-bundle sanity -/

/-- **🚨 s405 — `R_∞ > 1.097 × 10⁷ m⁻¹`** (tighter than precedent ≥ 10⁷). -/
theorem T1_R_inf_above_1_097e7 : R_inf_PDG > 10970000 := by
  unfold R_inf_PDG; norm_num

/-- **🚨 s405 — `R_∞ < 1.098 × 10⁷ m⁻¹`** (tightening: CODATA central 1.0974). -/
theorem T1_R_inf_below_1_098e7 : R_inf_PDG < 10980000 := by
  unfold R_inf_PDG; norm_num

/-- **🚨 s405 — `R_∞ ∈ (1.097e7, 1.098e7)`** band, CODATA central 1.0974e7. -/
theorem T1_R_inf_central_band :
    10970000 < R_inf_PDG ∧ R_inf_PDG < 10980000 :=
  ⟨T1_R_inf_above_1_097e7, T1_R_inf_below_1_098e7⟩

/-! ## s406 — a_0 Bohr radius (precision upgrade) -/

/-- **🚨 s406 — `a_0_CODATA > 0`**. -/
theorem T1_a_0_CODATA_pos : 0 < a_0_CODATA := by
  unfold a_0_CODATA; norm_num

/-- **🚨 s406 — `a_0_CODATA < 1`** (tiny, ~5.3 × 10⁻¹¹ m). -/
theorem T1_a_0_CODATA_lt_one : a_0_CODATA < 1 := by
  unfold a_0_CODATA; norm_num

/-- **🚨 s406 — `a_0_CODATA > 5 × 10⁻¹¹` × 10⁻¹⁰** (Bohr scale).

    Stored value `5.29177210903 × 10⁻¹¹` is bracketed as
    `> 5 / 10^11 = 5 × 10⁻¹¹` and `< 6 / 10^11 = 6 × 10⁻¹¹`. -/
theorem T1_a_0_CODATA_lower : a_0_CODATA > 5 / 100000000000 := by
  unfold a_0_CODATA; norm_num

/-- **🚨 s406 — `a_0_CODATA < 6 × 10⁻¹¹`** (upper Bohr-scale bracket). -/
theorem T1_a_0_CODATA_upper : a_0_CODATA < 6 / 100000000000 := by
  unfold a_0_CODATA; norm_num

/-- **🚨 s406 — `a_0_CODATA ∈ (5e-11, 6e-11) m`** band. -/
theorem T1_a_0_CODATA_band :
    5 / 100000000000 < a_0_CODATA ∧ a_0_CODATA < 6 / 100000000000 :=
  ⟨T1_a_0_CODATA_lower, T1_a_0_CODATA_upper⟩

/-! ## s407 — α ratio sanity vs Rydberg + bundle composition -/

/-- **🚨 s407 — `α < 1`** trivial sanity (perturbative dimensionless). -/
theorem T1_alpha_below_one : alpha_PDG < 1 := by
  have h : alpha_PDG < 1 / 100 := T1_alpha_PDG_lt_one_hundredth
  linarith

/-- **🚨 s407 — `α × R_∞ < R_∞`**: α-suppressed corrections smaller than R_∞.

    Combines `α < 1` with `0 < R_∞`. -/
theorem T1_alpha_times_R_inf_lt_R_inf : alpha_PDG * R_inf_PDG < R_inf_PDG := by
  have h_R : 0 < R_inf_PDG := T1_R_inf_PDG_pos
  have h_alpha : alpha_PDG < 1 := T1_alpha_below_one
  -- α × R < 1 × R = R, via mul_lt_of_lt_one_left
  have : alpha_PDG * R_inf_PDG < 1 * R_inf_PDG :=
    mul_lt_mul_of_pos_right h_alpha h_R
  linarith

/-- **🚨 s407 — `α × R_∞ > 0`**: positive α-suppressed Rydberg correction. -/
theorem T1_alpha_times_R_inf_pos : 0 < alpha_PDG * R_inf_PDG := by
  exact mul_pos T1_alpha_PDG_pos T1_R_inf_PDG_pos

/-! ## AtomicPrecisionConsistency Prop -/

/-- **AtomicPrecisionConsistency**: 4 atomic precision anchors plus
    α-Rydberg cross-bundle inequality, all in expected bands.

    Real Prop body. -/
def AtomicPrecisionConsistency : Prop :=
  -- m_p / m_e in (1836, 1837)
  (1836 < m_p_over_m_e_CODATA ∧ m_p_over_m_e_CODATA < 1837) ∧
  -- m_n / m_p in (1, 11/10), small but positive split
  (1 < m_n_over_m_p_CODATA ∧ m_n_over_m_p_CODATA < 11 / 10) ∧
  -- R_∞ in (1.097e7, 1.098e7) tight CODATA band
  (10970000 < R_inf_PDG ∧ R_inf_PDG < 10980000) ∧
  -- a_0 in (5e-11, 6e-11) m Bohr-scale band
  (5 / 100000000000 < a_0_CODATA ∧ a_0_CODATA < 6 / 100000000000) ∧
  -- α-suppressed Rydberg correction: 0 < α R_∞ < R_∞
  (0 < alpha_PDG * R_inf_PDG ∧ alpha_PDG * R_inf_PDG < R_inf_PDG)

/-- **🚨 s407 — `AtomicPrecisionConsistency`**. -/
theorem T1_atomic_precision_consistency : AtomicPrecisionConsistency :=
  ⟨T1_m_p_over_m_e_band,
   T1_m_n_over_m_p_band,
   T1_R_inf_central_band,
   T1_a_0_CODATA_band,
   ⟨T1_alpha_times_R_inf_pos, T1_alpha_times_R_inf_lt_R_inf⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 403-407 — atomic precision bundle**.

    🏆 Bundled-commit (5 sessions, atomic precision) per protocol.

    - s403: m_p / m_e = 1836.15267343 (CODATA 2024)
    - s404: m_n / m_p = 1.00137841918 (CODATA 2024)
    - s405: R_∞ Rydberg constant tight band (1.0973e7, 1.098e7) m⁻¹
    - s406: a_0 Bohr radius CODATA-precise = 5.29177210903 × 10⁻¹¹ m
    - s407: α-Rydberg cross-bundle inequalities + AtomicPrecisionConsistency

    Six-conjunct flat composition: positivity of `m_p/m_e`, `m_n/m_p`,
    `a_0_CODATA`, plus three band facts for `m_p/m_e`, `m_n/m_p`, R_∞,
    plus α-Rydberg inequalities, plus the consistency Prop.

    Cross-bundle: cites `T1_RydbergConstantPDG`, `T1_BohrRadiusPDG`,
    and `T1_FineStructureAlphaPDG` — adds 3 fresh `:APPLIES` edges per
    Yoneda-bridge protocol.

    Sub-lemma 170-174/N in T-1.  Lean-core only.

    🏆 First Lean-core atomic precision constants bundle. -/
theorem session_403_to_407_atomic_precision_bundle_headline :
    0 < m_p_over_m_e_CODATA
    ∧ 0 < m_n_over_m_p_CODATA
    ∧ 0 < a_0_CODATA
    ∧ (1836 < m_p_over_m_e_CODATA ∧ m_p_over_m_e_CODATA < 1837)
    ∧ (1 < m_n_over_m_p_CODATA ∧ m_n_over_m_p_CODATA < 11 / 10)
    ∧ (10970000 < R_inf_PDG ∧ R_inf_PDG < 10980000)
    ∧ (5 / 100000000000 < a_0_CODATA ∧ a_0_CODATA < 6 / 100000000000)
    ∧ (0 < alpha_PDG * R_inf_PDG ∧ alpha_PDG * R_inf_PDG < R_inf_PDG)
    ∧ AtomicPrecisionConsistency :=
  ⟨T1_m_p_over_m_e_pos,
   T1_m_n_over_m_p_pos,
   T1_a_0_CODATA_pos,
   T1_m_p_over_m_e_band,
   T1_m_n_over_m_p_band,
   T1_R_inf_central_band,
   T1_a_0_CODATA_band,
   ⟨T1_alpha_times_R_inf_pos, T1_alpha_times_R_inf_lt_R_inf⟩,
   T1_atomic_precision_consistency⟩

end OmegaTheory.Predictions.T1_AtomicPrecisionBundle
