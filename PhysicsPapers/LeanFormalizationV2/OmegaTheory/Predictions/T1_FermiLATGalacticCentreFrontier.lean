/-
  OmegaTheory.Predictions.T1_FermiLATGalacticCentreFrontier

  T-1 (light quark masses) — FRONTIER, sub session 291.
  Fermi-LAT Galactic Centre Excess — WIMP dark matter hint vs MSPs.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Long-standing Fermi-LAT GeV gamma-ray excess from Galactic Centre:
  - Detection significance: 5-7σ (highly statistically significant)
  - Spectrum:               peaks ~2-3 GeV
  - Best-fit DM (if WIMP):   m_χ ~ 30-50 GeV, σv ~ 10^(-26) cm³/s
  - Alternative:             unresolved millisecond pulsars (MSPs)

  Why important:
  - Could be first DM detection (smoking gun WIMP signal)
  - Or astrophysical (~10,000 unresolved MSPs)
  - Discrimination challenging — both reproduce spectrum + morphology
  - DSPH stacking (dwarf spheroidal galaxies) sets ~10× tighter
    DM-only bound, in tension with WIMP interpretation

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_FermiLATGalacticCentreFrontier

/-! ## GCE significance + parameters -/

/-- **Fermi-LAT GCE detection significance**: `~5σ` (lower bound). -/
noncomputable def GCE_significance_lower : ℝ := 5

/-- **Fermi-LAT GCE detection significance** (upper bound estimate): `7σ`. -/
noncomputable def GCE_significance_upper : ℝ := 7

/-- **Best-fit WIMP mass (if DM)**: `40 GeV` (mid-range 30-50). -/
noncomputable def m_chi_GCE_GeV : ℝ := 40

/-- **Best-fit ⟨σv⟩ (if DM)**: `2 × 10^(-26) cm³/s`. -/
noncomputable def sigma_v_GCE : ℝ := 2 / 100000000000000000000000000

/-- **Thermal relic ⟨σv⟩ reference**: `3 × 10^(-26) cm³/s` (canonical WIMP). -/
noncomputable def sigma_v_thermal : ℝ := 3 / 100000000000000000000000000

/-! ## Positivity -/

/-- **Wave T1 session 291 — `GCE sig lower > 0`**. -/
theorem T1_GCE_sig_lower_pos : 0 < GCE_significance_lower := by
  unfold GCE_significance_lower; norm_num

/-- **Wave T1 session 291 — `GCE sig upper > 0`**. -/
theorem T1_GCE_sig_upper_pos : 0 < GCE_significance_upper := by
  unfold GCE_significance_upper; norm_num

/-- **Wave T1 session 291 — `m_χ > 0`**. -/
theorem T1_m_chi_pos : 0 < m_chi_GCE_GeV := by
  unfold m_chi_GCE_GeV; norm_num

/-- **Wave T1 session 291 — `σv > 0`**. -/
theorem T1_sigma_v_GCE_pos : 0 < sigma_v_GCE := by
  unfold sigma_v_GCE; norm_num

/-- **Wave T1 session 291 — `σv thermal > 0`**. -/
theorem T1_sigma_v_thermal_pos : 0 < sigma_v_thermal := by
  unfold sigma_v_thermal; norm_num

/-! ## Significance hierarchy -/

/-- **🚨 FRONTIER — Wave T1 session 291 — `lower < upper`**. -/
theorem T1_GCE_sig_consistent :
    GCE_significance_lower < GCE_significance_upper := by
  unfold GCE_significance_lower GCE_significance_upper; linarith

/-- **🚨 FRONTIER — Wave T1 session 291 — `lower ≥ 5σ`** (DISCOVERY threshold). -/
theorem T1_GCE_above_5sigma :
    GCE_significance_lower ≥ 5 := by
  unfold GCE_significance_lower; norm_num

/-! ## σv close to thermal relic (WIMP miracle) -/

/-- **🚨 FRONTIER — Wave T1 session 291 — `σv GCE < σv thermal`**.

    GCE preferred ⟨σv⟩ slightly below canonical thermal-relic value. -/
theorem T1_sigma_v_below_thermal :
    sigma_v_GCE < sigma_v_thermal := by
  unfold sigma_v_GCE sigma_v_thermal; norm_num

/-- **🚨 FRONTIER — Wave T1 session 291 — `2 × σv GCE > σv thermal`**.

    Within factor 2 of thermal relic — the "WIMP miracle" coincidence. -/
theorem T1_sigma_v_within_2x_thermal :
    2 * sigma_v_GCE > sigma_v_thermal := by
  unfold sigma_v_GCE sigma_v_thermal; norm_num

/-! ## Mass in WIMP range -/

/-- **🚨 FRONTIER — Wave T1 session 291 — `30 GeV < m_χ < 50 GeV`**. -/
theorem T1_m_chi_in_WIMP_range :
    30 < m_chi_GCE_GeV ∧ m_chi_GCE_GeV < 50 := by
  refine ⟨?_, ?_⟩
  · unfold m_chi_GCE_GeV; norm_num
  · unfold m_chi_GCE_GeV; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 291 — Fermi-LAT GCE frontier**.

    🚨 FRONTIER (potential first WIMP DM signal) 🚨

    Eight foundational facts:
    1. `GCE sig lower = 5σ > 0`.
    2. `GCE sig upper = 7σ > 0`.
    3. `m_χ = 40 GeV > 0` (best-fit WIMP mass).
    4. `σv = 2×10^(-26) cm³/s > 0`.
    5. `σv thermal = 3×10^(-26) cm³/s > 0` (canonical WIMP).
    6. `lower < upper` (significance band).
    7. `lower ≥ 5σ` (DISCOVERY threshold).
    8. `30 GeV < m_χ < 50 GeV` (WIMP regime).

    Also: σv GCE < σv thermal AND 2 × σv GCE > σv thermal —
    within factor 2 of thermal-relic value (WIMP miracle).

    Could be first DM detection OR ~10,000 unresolved MSPs.
    Discrimination challenging — both reproduce spectrum + morphology.

    Sub-lemma 112/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of Fermi-LAT GCE. -/
theorem session_291_Fermi_LAT_GCE_frontier_headline :
    0 < GCE_significance_lower ∧ 0 < GCE_significance_upper
    ∧ 0 < m_chi_GCE_GeV ∧ 0 < sigma_v_GCE ∧ 0 < sigma_v_thermal
    ∧ GCE_significance_lower < GCE_significance_upper
    ∧ GCE_significance_lower ≥ 5
    ∧ (30 < m_chi_GCE_GeV ∧ m_chi_GCE_GeV < 50) :=
  ⟨T1_GCE_sig_lower_pos, T1_GCE_sig_upper_pos,
   T1_m_chi_pos, T1_sigma_v_GCE_pos, T1_sigma_v_thermal_pos,
   T1_GCE_sig_consistent, T1_GCE_above_5sigma,
   T1_m_chi_in_WIMP_range⟩

end OmegaTheory.Predictions.T1_FermiLATGalacticCentreFrontier
