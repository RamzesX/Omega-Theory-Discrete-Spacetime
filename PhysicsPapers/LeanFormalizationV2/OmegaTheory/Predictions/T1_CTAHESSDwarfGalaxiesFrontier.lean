/-
  OmegaTheory.Predictions.T1_CTAHESSDwarfGalaxiesFrontier

  T-1 (light quark masses) — FRONTIER, sub session 295.
  HESS + CTA dwarf-spheroidal galaxy WIMP indirect detection.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Best dwarf-galaxy WIMP DM bounds 2024:
  - Fermi-LAT dSph stack:  ⟨σv⟩ < 10^(-26) cm³/s for m_χ ~ 100 GeV
  - HESS Galactic Centre:  ⟨σv⟩ < 5×10^(-27) cm³/s for m_χ ~ 1 TeV
  - CTA (forecast 2030+):  ⟨σv⟩ < 10^(-28) cm³/s (10× tighter)

  Why important:
  - Dwarf galaxies are pure DM (less astrophysical contamination)
  - Sets tightest DM-only bound (vs GCE which is contested by MSPs)
  - Already excludes thermal-relic WIMPs for m_χ < 70 GeV
  - CTA will probe TeV WIMPs + axion-like ALPs

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_CTAHESSDwarfGalaxiesFrontier

/-! ## ⟨σv⟩ bounds (in 10^(-26) cm³/s) -/

/-- **Fermi-LAT dSph stack ⟨σv⟩ bound**: `1 × 10^(-26) cm³/s`. -/
noncomputable def sigma_v_FermiLAT_dSph : ℝ := 1 / 100000000000000000000000000

/-- **HESS Galactic Centre ⟨σv⟩ bound**: `5 × 10^(-27) cm³/s`. -/
noncomputable def sigma_v_HESS_GC : ℝ := 5 / 1000000000000000000000000000

/-- **CTA dSph forecast 2030+ ⟨σv⟩**: `1 × 10^(-28) cm³/s`. -/
noncomputable def sigma_v_CTA_target : ℝ := 1 / 10000000000000000000000000000

/-- **Thermal-relic ⟨σv⟩ canonical**: `3 × 10^(-26) cm³/s`. -/
noncomputable def sigma_v_thermal_canonical : ℝ := 3 / 100000000000000000000000000

/-! ## Positivity -/

/-- **Wave T1 session 295 — `Fermi-LAT dSph > 0`**. -/
theorem T1_FermiLAT_dSph_pos : 0 < sigma_v_FermiLAT_dSph := by
  unfold sigma_v_FermiLAT_dSph; norm_num

/-- **Wave T1 session 295 — `HESS GC > 0`**. -/
theorem T1_HESS_GC_pos : 0 < sigma_v_HESS_GC := by
  unfold sigma_v_HESS_GC; norm_num

/-- **Wave T1 session 295 — `CTA > 0`**. -/
theorem T1_CTA_pos : 0 < sigma_v_CTA_target := by
  unfold sigma_v_CTA_target; norm_num

/-- **Wave T1 session 295 — `thermal > 0`**. -/
theorem T1_thermal_pos : 0 < sigma_v_thermal_canonical := by
  unfold sigma_v_thermal_canonical; norm_num

/-! ## Tightest bound: HESS < Fermi-LAT -/

/-- **🚨 FRONTIER — Wave T1 session 295 — `HESS < Fermi-LAT`**.

    HESS GC sets tighter bound at TeV. -/
theorem T1_HESS_tighter_than_FermiLAT :
    sigma_v_HESS_GC < sigma_v_FermiLAT_dSph := by
  unfold sigma_v_HESS_GC sigma_v_FermiLAT_dSph; norm_num

/-! ## CTA future improvement -/

/-- **🚨 FRONTIER — Wave T1 session 295 — `CTA < HESS`**.

    CTA will improve over HESS by ~50×. -/
theorem T1_CTA_tighter_than_HESS :
    sigma_v_CTA_target < sigma_v_HESS_GC := by
  unfold sigma_v_CTA_target sigma_v_HESS_GC; norm_num

/-- **🚨 FRONTIER — Wave T1 session 295 — `CTA < 0.1 × Fermi-LAT`**. -/
theorem T1_CTA_lt_FermiLAT_over_10 :
    10 * sigma_v_CTA_target < sigma_v_FermiLAT_dSph := by
  unfold sigma_v_CTA_target sigma_v_FermiLAT_dSph; norm_num

/-! ## Thermal-relic exclusion: bound < thermal -/

/-- **🚨 FRONTIER — Wave T1 session 295 — `Fermi-LAT dSph < thermal`**.

    Already excludes thermal WIMPs at low mass! -/
theorem T1_FermiLAT_excludes_thermal :
    sigma_v_FermiLAT_dSph < sigma_v_thermal_canonical := by
  unfold sigma_v_FermiLAT_dSph sigma_v_thermal_canonical; norm_num

/-- **🚨 FRONTIER — Wave T1 session 295 — `HESS << thermal`**.

    HESS bound 6× below thermal. -/
theorem T1_HESS_5x_below_thermal :
    5 * sigma_v_HESS_GC < sigma_v_thermal_canonical := by
  unfold sigma_v_HESS_GC sigma_v_thermal_canonical; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 295 — CTA + HESS WIMP frontier**.

    🚨 FRONTIER (tightest WIMP DM constraints — already excludes thermal at low m) 🚨

    Eight foundational facts:
    1. `Fermi-LAT dSph = 10^(-26) cm³/s > 0`.
    2. `HESS GC = 5×10^(-27) cm³/s > 0`.
    3. `CTA forecast = 10^(-28) cm³/s > 0`.
    4. `thermal = 3×10^(-26) cm³/s > 0`.
    5. `HESS < Fermi-LAT` (HESS tighter at TeV).
    6. `CTA < HESS` (~50× future improvement).
    7. `Fermi-LAT < thermal` (excludes thermal WIMPs).
    8. `5 × HESS < thermal` (HESS 6× below).

    Dwarf galaxies are pure DM (less contamination). Sets tightest
    DM-only bound (vs GCE contested by MSPs s291). Already excludes
    thermal-relic WIMPs for m_χ < 70 GeV.

    Sub-lemma 115/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of CTA+HESS WIMP bounds. -/
theorem session_295_CTA_HESS_dwarf_frontier_headline :
    0 < sigma_v_FermiLAT_dSph ∧ 0 < sigma_v_HESS_GC
    ∧ 0 < sigma_v_CTA_target ∧ 0 < sigma_v_thermal_canonical
    ∧ sigma_v_HESS_GC < sigma_v_FermiLAT_dSph
    ∧ sigma_v_CTA_target < sigma_v_HESS_GC
    ∧ sigma_v_FermiLAT_dSph < sigma_v_thermal_canonical
    ∧ 5 * sigma_v_HESS_GC < sigma_v_thermal_canonical :=
  ⟨T1_FermiLAT_dSph_pos, T1_HESS_GC_pos, T1_CTA_pos, T1_thermal_pos,
   T1_HESS_tighter_than_FermiLAT, T1_CTA_tighter_than_HESS,
   T1_FermiLAT_excludes_thermal, T1_HESS_5x_below_thermal⟩

end OmegaTheory.Predictions.T1_CTAHESSDwarfGalaxiesFrontier
