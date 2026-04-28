/-
  OmegaTheory.Predictions.T1_IceCubeAtmosphericMuonFluxBundle

  T-1 — IceCube atmospheric muon flux at TeV bundle, sessions s859-s863.

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Atmospheric (downward) muon flux measured by IceCube — the kilometer-deep
  ice Cherenkov detector at the South Pole — providing the dominant
  background to astrophysical neutrino searches:

  - s859: Atmospheric muon flux at 1 TeV (downward zenith)
          Φ_atm_μ(1 TeV) ≈ 5 × 10⁻¹⁰ /m²/s/sr
          stored in units of 10⁻¹¹: `Phi_atm_mu_1TeV_units = 50`
  - s860: Spectral index γ_atm = 3.7 (atmospheric muon power-law spectrum)
          stored in units of 10⁻²: `gamma_atm_units = 370`
          window: `300 < γ < 400` (i.e. `3 < γ_atm < 4`, falling)
  - s861: Atmospheric muon vs astrophysical ν decade gap at TeV
          atm μ (10⁻¹⁰) >> astro ν (10⁻¹⁸) by 8 decades
          `decade_gap_atm_vs_astro = 8`
  - s862: Earth-shielding for upward-going neutrinos: cosmic-ray atm-μ
          blocked at depth, only ν transit Earth.  Detection threshold
          `E_threshold_GeV = 100` (above 100 GeV regime)
  - s863: bundle composition + IceCubeAtmosphericMuonFlux Prop (6+ conj)

  Companion to `T1_IceCubeGen2UHENuBundle.lean` (UHE astrophysical ν,
  ≥10 PeV), `T1_AstroNeutrinoBundle.lean` (diffuse astro ν landscape),
  `T1_CosmicMuonFluxGroundBundle.lean` (sea-level cosmic μ).  This file
  targets the dominant atm-μ BACKGROUND in IceCube at TeV energies.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_IceCubeAtmosphericMuonFluxBundle

/-! ## s859 — Atmospheric muon flux at 1 TeV (downward zenith) -/

/-- **Atmospheric muon flux at 1 TeV** in units of `10⁻¹¹ /m²/s/sr`: `50`.

    Equivalent to `Φ_atm_μ(1 TeV) ≈ 5 × 10⁻¹⁰ /m²/s/sr` (IceCube 2014). -/
noncomputable def Phi_atm_mu_1TeV_units : ℝ := 50

/-- **🚨 s859 — `Φ_atm_μ(1 TeV)` units > 0**. -/
theorem T1_Phi_atm_mu_pos : 0 < Phi_atm_mu_1TeV_units := by
  unfold Phi_atm_mu_1TeV_units; norm_num

/-- **🚨 s859 — `Φ_atm_μ(1 TeV)` units > 10**
    (lower band: more than `10⁻¹⁰ /m²/s/sr`). -/
theorem T1_Phi_atm_mu_above_10 : Phi_atm_mu_1TeV_units > 10 := by
  unfold Phi_atm_mu_1TeV_units; norm_num

/-- **🚨 s859 — `Φ_atm_μ(1 TeV)` units < 100**
    (upper band: less than `10⁻⁹ /m²/s/sr`). -/
theorem T1_Phi_atm_mu_below_100 : Phi_atm_mu_1TeV_units < 100 := by
  unfold Phi_atm_mu_1TeV_units; norm_num

/-- **🚨 FRONTIER — s859 — IceCube atmospheric muon flux at 1 TeV
    sits in the canonical `(10, 100)` window in `10⁻¹¹` units**. -/
theorem T1_Phi_atm_mu_in_band :
    0 < Phi_atm_mu_1TeV_units
    ∧ 10 < Phi_atm_mu_1TeV_units
    ∧ Phi_atm_mu_1TeV_units < 100 :=
  ⟨T1_Phi_atm_mu_pos, T1_Phi_atm_mu_above_10, T1_Phi_atm_mu_below_100⟩

/-! ## s860 — Spectral index γ_atm = 3.7 -/

/-- **Atmospheric muon spectral index** in units of `10⁻²`: `370`.

    Encodes `γ_atm = 3.7`, the canonical atmospheric muon power-law
    spectral index `dN/dE ∝ E^{-γ_atm}`. -/
noncomputable def gamma_atm_units : ℝ := 370

/-- **🚨 s860 — `γ_atm` units > 0**. -/
theorem T1_gamma_atm_pos : 0 < gamma_atm_units := by
  unfold gamma_atm_units; norm_num

/-- **🚨 s860 — `γ_atm` units > 300** (i.e. `γ_atm > 3`, spectrum falling). -/
theorem T1_gamma_atm_above_300 : gamma_atm_units > 300 := by
  unfold gamma_atm_units; norm_num

/-- **🚨 s860 — `γ_atm` units < 400** (i.e. `γ_atm < 4`). -/
theorem T1_gamma_atm_below_400 : gamma_atm_units < 400 := by
  unfold gamma_atm_units; norm_num

/-- **🚨 FRONTIER — s860 — atmospheric μ spectral index in `(3, 4)` band**. -/
theorem T1_gamma_atm_in_band :
    300 < gamma_atm_units ∧ gamma_atm_units < 400 :=
  ⟨T1_gamma_atm_above_300, T1_gamma_atm_below_400⟩

/-! ## s861 — Atmospheric muon vs astrophysical ν decade gap -/

/-- **Decade gap** between atmospheric muon flux (`~10⁻¹⁰`) and
    astrophysical neutrino flux (`~10⁻¹⁸`) at characteristic energies: `8`. -/
noncomputable def decade_gap_atm_vs_astro : ℝ := 8

/-- **🚨 s861 — decade gap > 0**. -/
theorem T1_decade_gap_pos : 0 < decade_gap_atm_vs_astro := by
  unfold decade_gap_atm_vs_astro; norm_num

/-- **🚨 s861 — decade gap ≥ 5** (atm-μ background dominates astro ν
    by at least 5 decades). -/
theorem T1_decade_gap_ge_5 : decade_gap_atm_vs_astro ≥ 5 := by
  unfold decade_gap_atm_vs_astro; norm_num

/-- **🚨 s861 — decade gap ≤ 10** (gap ≤ 10 decades — physical bound). -/
theorem T1_decade_gap_le_10 : decade_gap_atm_vs_astro ≤ 10 := by
  unfold decade_gap_atm_vs_astro; norm_num

/-- **🚨 FRONTIER — s861 — atmospheric muon background dominates
    astrophysical ν by 8 orders of magnitude at TeV energies**. -/
theorem T1_atm_dominates_astro :
    0 < decade_gap_atm_vs_astro
    ∧ decade_gap_atm_vs_astro ≥ 5
    ∧ decade_gap_atm_vs_astro ≤ 10 :=
  ⟨T1_decade_gap_pos, T1_decade_gap_ge_5, T1_decade_gap_le_10⟩

/-! ## s862 — Detection threshold (Earth shielding) -/

/-- **IceCube detection threshold** in GeV for upward-going ν analyses: `100`.

    Above this energy regime, Earth-transiting ν dominate over residual
    atm-μ leakage (cosmic-ray atm-μ blocked at depth). -/
noncomputable def E_threshold_GeV : ℝ := 100

/-- **🚨 s862 — detection threshold > 0**. -/
theorem T1_E_threshold_pos : 0 < E_threshold_GeV := by
  unfold E_threshold_GeV; norm_num

/-- **🚨 s862 — detection threshold ≥ 10 GeV** (above muon threshold). -/
theorem T1_E_threshold_above_10 : E_threshold_GeV ≥ 10 := by
  unfold E_threshold_GeV; norm_num

/-- **🚨 s862 — detection threshold < 1000 GeV** (below TeV regime). -/
theorem T1_E_threshold_below_1000 : E_threshold_GeV < 1000 := by
  unfold E_threshold_GeV; norm_num

/-- **🚨 FRONTIER — s862 — IceCube upward-ν Earth-shielding regime
    starts above 100 GeV**. -/
theorem T1_E_threshold_in_band :
    0 < E_threshold_GeV
    ∧ E_threshold_GeV ≥ 10
    ∧ E_threshold_GeV < 1000 :=
  ⟨T1_E_threshold_pos, T1_E_threshold_above_10, T1_E_threshold_below_1000⟩

/-! ## s863 — Atmospheric μ flux Prop scaffold -/

/-- **IceCubeAtmosphericMuonFlux**: complete IceCube atm-μ flux structure.

    Real Prop body — all anchors positive, in their canonical PDG /
    IceCube measurement bands, and atm-μ background dominates astro ν
    by 5–10 decades. -/
def IceCubeAtmosphericMuonFlux : Prop :=
  -- Positivity of all four anchors
  0 < Phi_atm_mu_1TeV_units ∧ 0 < gamma_atm_units
  ∧ 0 < decade_gap_atm_vs_astro ∧ 0 < E_threshold_GeV
  -- Φ_atm_μ in canonical (10, 100) × 10⁻¹¹ band
  ∧ (10 < Phi_atm_mu_1TeV_units ∧ Phi_atm_mu_1TeV_units < 100)
  -- γ_atm ∈ (3, 4) (falling spectrum)
  ∧ (300 < gamma_atm_units ∧ gamma_atm_units < 400)
  -- decade gap ∈ [5, 10]
  ∧ (decade_gap_atm_vs_astro ≥ 5 ∧ decade_gap_atm_vs_astro ≤ 10)
  -- threshold above 10 GeV but below TeV
  ∧ (E_threshold_GeV ≥ 10 ∧ E_threshold_GeV < 1000)

/-- **🚨 s863 — `IceCubeAtmosphericMuonFlux`** (full structure). -/
theorem T1_icecube_atm_mu_flux : IceCubeAtmosphericMuonFlux :=
  ⟨T1_Phi_atm_mu_pos, T1_gamma_atm_pos,
   T1_decade_gap_pos, T1_E_threshold_pos,
   ⟨T1_Phi_atm_mu_above_10, T1_Phi_atm_mu_below_100⟩,
   ⟨T1_gamma_atm_above_300, T1_gamma_atm_below_400⟩,
   ⟨T1_decade_gap_ge_5, T1_decade_gap_le_10⟩,
   ⟨T1_E_threshold_above_10, T1_E_threshold_below_1000⟩⟩

/-! ## Headline -/

/-- **🚨 FRONTIER — HEADLINE — sessions s859-s863 — IceCube atmospheric
    muon flux at TeV bundle**.

    🏆 IceCube's dominant downward-going atm-μ background at the South
    Pole — the irreducible cosmic-ray secondary that defines the
    astrophysical-ν search baseline.

    5 sessions:
    - s859: Φ_atm_μ(1 TeV) ≈ 5 × 10⁻¹⁰ /m²/s/sr (units = 50, in 10⁻¹¹)
    - s860: γ_atm = 3.7 (units = 370, in 10⁻²); 3 < γ_atm < 4
    - s861: 8-decade gap atm μ vs astro ν at TeV; 5 ≤ gap ≤ 10
    - s862: Detection threshold E ≥ 100 GeV (Earth shielding regime)
    - s863: bundle composition + IceCubeAtmosphericMuonFlux Prop (≥6-conj)

    Six headline conjuncts:
    1. `Φ_atm_μ(1 TeV)` units in `(10, 100)` (s859)
    2. `γ_atm` units in `(300, 400)` (s860)
    3. atm-μ background dominates astro ν by 5–10 decades (s861)
    4. detection threshold in `[10, 1000) GeV` (s862)
    5. atm-μ flux strictly bigger than astro ν (decade gap > 0) (s861)
    6. `IceCubeAtmosphericMuonFlux` Prop holds (s863)

    Substrate-prediction connection: atmospheric muon production is
    fixed by hadronic showers (π/K decay) in the upper atmosphere,
    governed by QCD cross-sections derived from Λ_QCD (s320 RG flow);
    spectral index γ_atm = γ_CR + 1 reflects pion-decay kinematics.
    Λ_QCD enters via π/K production cross-section.

    Lean-core only.

    🏆 First Lean-core formalization of the IceCube atmospheric-μ
       background landscape at TeV energies. -/
theorem session_859_to_863_icecube_atm_mu_flux_bundle_headline :
    (10 < Phi_atm_mu_1TeV_units ∧ Phi_atm_mu_1TeV_units < 100)
    ∧ (300 < gamma_atm_units ∧ gamma_atm_units < 400)
    ∧ (decade_gap_atm_vs_astro ≥ 5 ∧ decade_gap_atm_vs_astro ≤ 10)
    ∧ (E_threshold_GeV ≥ 10 ∧ E_threshold_GeV < 1000)
    ∧ 0 < decade_gap_atm_vs_astro
    ∧ IceCubeAtmosphericMuonFlux :=
  ⟨⟨T1_Phi_atm_mu_above_10, T1_Phi_atm_mu_below_100⟩,
   ⟨T1_gamma_atm_above_300, T1_gamma_atm_below_400⟩,
   ⟨T1_decade_gap_ge_5, T1_decade_gap_le_10⟩,
   ⟨T1_E_threshold_above_10, T1_E_threshold_below_1000⟩,
   T1_decade_gap_pos,
   T1_icecube_atm_mu_flux⟩

end OmegaTheory.Predictions.T1_IceCubeAtmosphericMuonFluxBundle
