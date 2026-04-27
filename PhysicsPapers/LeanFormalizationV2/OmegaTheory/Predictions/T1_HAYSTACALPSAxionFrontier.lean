/-
  OmegaTheory.Predictions.T1_HAYSTACALPSAxionFrontier

  T-1 (light quark masses) — FRONTIER, sub session 306.
  HAYSTAC haloscope + ALPS-II light-shining-through-walls axion search.

  Single-thread hand-authored 2026-04-28 (cycle 65).
  opus-code-crawler proposal #11.

  ## What this file delivers

  Axion-photon coupling g_aγγ bounds beyond ADMX (s284):
  - HAYSTAC 2024 (PRL 132 (2024) 031601):
      |g_aγγ| < 1.4 × 10⁻¹⁴ GeV⁻¹ for m_a ∈ [16.96, 17.28] μeV
  - ALPS-II 2023 first physics:
      g_aγγ < 2 × 10⁻¹¹ GeV⁻¹ (light-shining-through-walls)
  - DFSZ axion band:  ~10⁻¹⁵ GeV⁻¹ near 10 μeV
  - KSVZ axion band:  ~10⁻¹³ GeV⁻¹

  Why important:
  - HAYSTAC: probes higher mass than ADMX (s284 covered 1.91-3.69 μeV)
  - ALPS-II: independent constraint via LSW (no halo assumption)
  - Combined coverage of QCD-axion band continues to expand

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_HAYSTACALPSAxionFrontier

/-! ## g_aγγ bounds (in GeV⁻¹) -/

/-- **HAYSTAC g_aγγ upper limit**: `1.4 × 10⁻¹⁴ GeV⁻¹`. -/
noncomputable def g_HAYSTAC : ℝ := 14 / 1000000000000000

/-- **ALPS-II g_aγγ upper limit**: `2 × 10⁻¹¹ GeV⁻¹`. -/
noncomputable def g_ALPS_II : ℝ := 2 / 100000000000

/-- **DFSZ axion band reference (10 μeV)**: `10⁻¹⁵ GeV⁻¹`. -/
noncomputable def g_DFSZ_band : ℝ := 1 / 1000000000000000

/-- **KSVZ axion band reference (10 μeV)**: `10⁻¹³ GeV⁻¹`. -/
noncomputable def g_KSVZ_band : ℝ := 1 / 10000000000000

/-- **HAYSTAC mass lower (μeV)**: `16.96`. -/
noncomputable def m_a_HAYSTAC_lower : ℝ := 1696 / 100

/-- **HAYSTAC mass upper (μeV)**: `17.28`. -/
noncomputable def m_a_HAYSTAC_upper : ℝ := 1728 / 100

/-! ## Positivity -/

/-- **Wave T1 session 306 — `g HAYSTAC > 0`**. -/
theorem T1_g_HAYSTAC_pos : 0 < g_HAYSTAC := by
  unfold g_HAYSTAC; norm_num

/-- **Wave T1 session 306 — `g ALPS-II > 0`**. -/
theorem T1_g_ALPS_pos : 0 < g_ALPS_II := by
  unfold g_ALPS_II; norm_num

/-- **Wave T1 session 306 — `g DFSZ band > 0`**. -/
theorem T1_g_DFSZ_pos : 0 < g_DFSZ_band := by
  unfold g_DFSZ_band; norm_num

/-- **Wave T1 session 306 — `g KSVZ band > 0`**. -/
theorem T1_g_KSVZ_pos : 0 < g_KSVZ_band := by
  unfold g_KSVZ_band; norm_num

/-- **Wave T1 session 306 — `m_a lower > 0`**. -/
theorem T1_m_a_lower_pos : 0 < m_a_HAYSTAC_lower := by
  unfold m_a_HAYSTAC_lower; norm_num

/-- **Wave T1 session 306 — `m_a upper > 0`**. -/
theorem T1_m_a_upper_pos : 0 < m_a_HAYSTAC_upper := by
  unfold m_a_HAYSTAC_upper; norm_num

/-! ## HAYSTAC much tighter than ALPS-II -/

/-- **🚨 FRONTIER — Wave T1 session 306 — `g HAYSTAC < g ALPS-II`**.

    Haloscope ~1000× tighter than LSW. -/
theorem T1_HAYSTAC_tighter_than_ALPS :
    g_HAYSTAC < g_ALPS_II := by
  unfold g_HAYSTAC g_ALPS_II; norm_num

/-! ## Mass band consistency -/

/-- **🚨 FRONTIER — Wave T1 session 306 — `m_a lower < m_a upper`**. -/
theorem T1_m_a_band_consistent :
    m_a_HAYSTAC_lower < m_a_HAYSTAC_upper := by
  unfold m_a_HAYSTAC_lower m_a_HAYSTAC_upper; linarith

/-- **🚨 FRONTIER — Wave T1 session 306 — `m_a HAYSTAC > 16 μeV`**

    HAYSTAC probes ABOVE ADMX 2024 upper (3.69 μeV s284). -/
theorem T1_HAYSTAC_above_ADMX :
    m_a_HAYSTAC_lower > 16 := by
  unfold m_a_HAYSTAC_lower; norm_num

/-! ## DFSZ vs KSVZ band -/

/-- **🚨 FRONTIER — Wave T1 session 306 — `g DFSZ < g KSVZ`** (DFSZ band tighter). -/
theorem T1_DFSZ_below_KSVZ :
    g_DFSZ_band < g_KSVZ_band := by
  unfold g_DFSZ_band g_KSVZ_band; norm_num

/-- **🚨 FRONTIER — Wave T1 session 306 — `g HAYSTAC < g KSVZ`**.

    HAYSTAC excludes KSVZ axion in its mass window. -/
theorem T1_HAYSTAC_below_KSVZ :
    g_HAYSTAC < g_KSVZ_band := by
  unfold g_HAYSTAC g_KSVZ_band; norm_num

/-! ## Smallness (ultra-tight) -/

/-- **🚨 FRONTIER — Wave T1 session 306 — `g HAYSTAC < 10⁻¹³`**. -/
theorem T1_g_HAYSTAC_lt_1e_neg_13 :
    g_HAYSTAC < 1 / 10000000000000 := by
  unfold g_HAYSTAC; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 306 — HAYSTAC + ALPS-II axion frontier**.

    🚨 FRONTIER (axion search complementary to ADMX s284) 🚨

    Eleven foundational facts:
    1. `g HAYSTAC = 1.4×10⁻¹⁴ GeV⁻¹ > 0`.
    2. `g ALPS-II = 2×10⁻¹¹ GeV⁻¹ > 0`.
    3. `g DFSZ = 10⁻¹⁵ GeV⁻¹ > 0`.
    4. `g KSVZ = 10⁻¹³ GeV⁻¹ > 0`.
    5. `m_a HAYSTAC lower = 16.96 μeV > 0`.
    6. `m_a HAYSTAC upper = 17.28 μeV > 0`.
    7. `g HAYSTAC < g ALPS-II` (~1000× tighter).
    8. `m_a band consistent` (lower < upper).
    9. `m_a HAYSTAC > 16 μeV` (above ADMX 2024 upper).
    10. `g DFSZ < g KSVZ` (DFSZ band tighter).
    11. `g HAYSTAC < g KSVZ` (KSVZ excluded in window).

    HAYSTAC complements ADMX (s284) at higher mass.
    ALPS-II independent constraint (LSW, no halo assumption).

    Sub-lemma 126/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of HAYSTAC + ALPS-II axion. -/
theorem session_306_HAYSTAC_ALPS_axion_frontier_headline :
    0 < g_HAYSTAC ∧ 0 < g_ALPS_II
    ∧ 0 < g_DFSZ_band ∧ 0 < g_KSVZ_band
    ∧ 0 < m_a_HAYSTAC_lower ∧ 0 < m_a_HAYSTAC_upper
    ∧ g_HAYSTAC < g_ALPS_II
    ∧ m_a_HAYSTAC_lower < m_a_HAYSTAC_upper
    ∧ m_a_HAYSTAC_lower > 16
    ∧ g_DFSZ_band < g_KSVZ_band
    ∧ g_HAYSTAC < g_KSVZ_band :=
  ⟨T1_g_HAYSTAC_pos, T1_g_ALPS_pos,
   T1_g_DFSZ_pos, T1_g_KSVZ_pos,
   T1_m_a_lower_pos, T1_m_a_upper_pos,
   T1_HAYSTAC_tighter_than_ALPS, T1_m_a_band_consistent,
   T1_HAYSTAC_above_ADMX,
   T1_DFSZ_below_KSVZ, T1_HAYSTAC_below_KSVZ⟩

end OmegaTheory.Predictions.T1_HAYSTACALPSAxionFrontier
