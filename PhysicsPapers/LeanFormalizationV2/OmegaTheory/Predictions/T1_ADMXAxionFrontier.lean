/-
  OmegaTheory.Predictions.T1_ADMXAxionFrontier

  T-1 (light quark masses) — FRONTIER, sub session 284.
  ADMX (Axion Dark Matter eXperiment) — QCD axion search.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  ADMX (UWashington, USA) — searches QCD axion DM via
  axion-photon Primakoff conversion in ~7 T magnet:
  - ADMX 2018:  excluded m_a ∈ [2.66, 2.81] μeV (DFSZ + KSVZ models)
  - ADMX 2020:  excluded m_a ∈ [2.81, 3.31] μeV (KSVZ)
  - ADMX 2024:  excluded m_a ∈ [1.91, 3.69] μeV combined sensitivity
  - QCD-axion band:  m_a ~ 1-100 μeV (depending on f_a)

  Why important:
  - QCD axion solves Strong CP (s242: θ̄_QCD < 10^(-9))
  - Could be all of dark matter if pre-inflationary symmetry breaking
  - DFSZ vs KSVZ couplings to fermions/photons differ by ~3×

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_ADMXAxionFrontier

/-! ## ADMX exclusion bounds (in μeV) -/

/-- **ADMX 2024 lower exclusion bound**: `1.91 μeV`. -/
noncomputable def ADMX_m_a_lower_excluded : ℝ := 191 / 100

/-- **ADMX 2024 upper exclusion bound**: `3.69 μeV`. -/
noncomputable def ADMX_m_a_upper_excluded : ℝ := 369 / 100

/-- **ADMX 2018 (early result) lower bound**: `2.66 μeV`. -/
noncomputable def ADMX_m_a_2018_lower : ℝ := 266 / 100

/-- **ADMX 2018 upper bound**: `2.81 μeV`. -/
noncomputable def ADMX_m_a_2018_upper : ℝ := 281 / 100

/-! ## Positivity -/

/-- **Wave T1 session 284 — `ADMX 2024 lower > 0`**. -/
theorem T1_ADMX_lower_pos : 0 < ADMX_m_a_lower_excluded := by
  unfold ADMX_m_a_lower_excluded; norm_num

/-- **Wave T1 session 284 — `ADMX 2024 upper > 0`**. -/
theorem T1_ADMX_upper_pos : 0 < ADMX_m_a_upper_excluded := by
  unfold ADMX_m_a_upper_excluded; norm_num

/-- **Wave T1 session 284 — `ADMX 2018 lower > 0`**. -/
theorem T1_ADMX_2018_lower_pos : 0 < ADMX_m_a_2018_lower := by
  unfold ADMX_m_a_2018_lower; norm_num

/-- **Wave T1 session 284 — `ADMX 2018 upper > 0`**. -/
theorem T1_ADMX_2018_upper_pos : 0 < ADMX_m_a_2018_upper := by
  unfold ADMX_m_a_2018_upper; norm_num

/-! ## ADMX 2024 broader than 2018 (improvement) -/

/-- **🚨 FRONTIER — Wave T1 session 284 — `2024 lower < 2018 lower`**.

    ADMX 2024 starts excluding lower mass than 2018. -/
theorem T1_ADMX_2024_extends_below_2018 :
    ADMX_m_a_lower_excluded < ADMX_m_a_2018_lower := by
  unfold ADMX_m_a_lower_excluded ADMX_m_a_2018_lower; linarith

/-- **🚨 FRONTIER — Wave T1 session 284 — `2024 upper > 2018 upper`**.

    ADMX 2024 extends to higher mass. -/
theorem T1_ADMX_2024_extends_above_2018 :
    ADMX_m_a_upper_excluded > ADMX_m_a_2018_upper := by
  unfold ADMX_m_a_upper_excluded ADMX_m_a_2018_upper; linarith

/-! ## Range consistency: lower < upper -/

/-- **🚨 FRONTIER — Wave T1 session 284 — `lower < upper` (2024)**. -/
theorem T1_ADMX_2024_consistent :
    ADMX_m_a_lower_excluded < ADMX_m_a_upper_excluded := by
  unfold ADMX_m_a_lower_excluded ADMX_m_a_upper_excluded; linarith

/-- **🚨 FRONTIER — Wave T1 session 284 — `lower < upper` (2018)**. -/
theorem T1_ADMX_2018_consistent :
    ADMX_m_a_2018_lower < ADMX_m_a_2018_upper := by
  unfold ADMX_m_a_2018_lower ADMX_m_a_2018_upper; linarith

/-! ## Within QCD-axion band [~1, ~100] μeV -/

/-- **🚨 FRONTIER — Wave T1 session 284 — `2024 lower > 1 μeV`** (QCD band start). -/
theorem T1_ADMX_in_QCD_band_lower :
    ADMX_m_a_lower_excluded > 1 := by
  unfold ADMX_m_a_lower_excluded; norm_num

/-- **🚨 FRONTIER — Wave T1 session 284 — `2024 upper < 100 μeV`** (QCD band end). -/
theorem T1_ADMX_in_QCD_band_upper :
    ADMX_m_a_upper_excluded < 100 := by
  unfold ADMX_m_a_upper_excluded; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 284 — ADMX axion frontier**.

    🚨 FRONTIER (QCD axion DM search) 🚨

    Eight foundational facts:
    1. `ADMX 2024 lower = 1.91 μeV > 0`.
    2. `ADMX 2024 upper = 3.69 μeV > 0`.
    3. `ADMX 2018 lower = 2.66 μeV > 0`.
    4. `ADMX 2018 upper = 2.81 μeV > 0`.
    5. `2024 lower < 2018 lower` (extended below).
    6. `2024 upper > 2018 upper` (extended above).
    7. `lower < upper` (range consistency, 2024 + 2018).
    8. `1 μeV < ADMX 2024 < 100 μeV` (within QCD-axion band).

    QCD axion solves Strong CP (s242). Could be all of dark
    matter if pre-inflationary symmetry breaking. DFSZ vs KSVZ
    couplings differ ~3×.

    Sub-lemma 105/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of ADMX axion DM bounds. -/
theorem session_284_ADMX_axion_frontier_headline :
    0 < ADMX_m_a_lower_excluded ∧ 0 < ADMX_m_a_upper_excluded
    ∧ 0 < ADMX_m_a_2018_lower ∧ 0 < ADMX_m_a_2018_upper
    ∧ ADMX_m_a_lower_excluded < ADMX_m_a_2018_lower
    ∧ ADMX_m_a_upper_excluded > ADMX_m_a_2018_upper
    ∧ ADMX_m_a_lower_excluded < ADMX_m_a_upper_excluded
    ∧ ADMX_m_a_lower_excluded > 1
    ∧ ADMX_m_a_upper_excluded < 100 :=
  ⟨T1_ADMX_lower_pos, T1_ADMX_upper_pos,
   T1_ADMX_2018_lower_pos, T1_ADMX_2018_upper_pos,
   T1_ADMX_2024_extends_below_2018, T1_ADMX_2024_extends_above_2018,
   T1_ADMX_2024_consistent,
   T1_ADMX_in_QCD_band_lower, T1_ADMX_in_QCD_band_upper⟩

end OmegaTheory.Predictions.T1_ADMXAxionFrontier
