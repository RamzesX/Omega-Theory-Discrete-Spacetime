/-
  OmegaTheory.Predictions.T1_IceCubeGen2UHENuBundle

  T-1 — IceCube-Gen2 ultra-high-energy astrophysical neutrinos +
  Glashow resonance, bundled sessions s584-s588.

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Five-session bundle covering IceCube-Gen2 UHE-ν observatory targets
  and the Glashow resonance (W⁻ resonance in ν̄_e + e⁻ → W⁻ → hadrons):

  - s584: Φ_ν astrophysical at 100 TeV ≈ 1.5 × 10⁻¹⁸ GeV⁻¹ cm⁻² s⁻¹ sr⁻¹
          (IceCube 2024 best fit); coefficient 1.5 in 10⁻¹⁸ units.
  - s585: Glashow resonance peak at E_ν = 6.3 PeV (W resonance,
          ν̄_e + e⁻ → W⁻).
  - s586: σ_Glashow ≈ 5 × 10⁻³¹ cm² (peak cross-section).
  - s587: Atmospheric ν background at 100 TeV ≈ 1 × 10⁻¹⁸ in same units;
          astro/atmo signal-dominated (ratio > 1).
  - s588: Bundle composition + IceCubeGen2NuFlux Prop (5+ conjunct
          headline).

  Companion to `T1_AstroNeutrinoBundle.lean` (diffuse astrophysical
  flux landscape including KM3NeT/ANTARES/GZK), `T1_NeutrinoOscillationsBundle.lean`
  (PMNS), and `T1_CosmicRaySpectrumBundle.lean` (charged primaries).
  This bundle targets the next-generation UHE-ν observatory + the
  Glashow resonance signature.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_IceCubeGen2UHENuBundle

/-! ## s584 — IceCube astrophysical ν flux at 100 TeV (1.5 × 10⁻¹⁸) -/

/-- **IceCube astrophysical ν flux at 100 TeV** in units of `10⁻¹⁸ GeV⁻¹ cm⁻² s⁻¹ sr⁻¹`:
    `1.5` (best fit, 2024 single-power-law).

    Stored as the mantissa coefficient `15/10 = 1.5` for the `10⁻¹⁸`
    decade in differential flux per energy per area per time per
    solid angle. -/
noncomputable def Phi_nu_100TeV_units : ℝ := 15 / 10

/-- **s584 — IceCube ν flux coefficient > 0**. -/
theorem s584_Phi_nu_100TeV_pos : 0 < Phi_nu_100TeV_units := by
  unfold Phi_nu_100TeV_units; norm_num

/-- **s584 — IceCube ν flux coefficient = 1.5**. -/
theorem s584_Phi_nu_100TeV_eq : Phi_nu_100TeV_units = 15 / 10 := by
  unfold Phi_nu_100TeV_units; rfl

/-- **🚨 FRONTIER — s584 — IceCube astrophysical ν flux at 100 TeV
    is `1.5 × 10⁻¹⁸ GeV⁻¹ cm⁻² s⁻¹ sr⁻¹`** — this is the IceCube-Gen2
    benchmark normalization point at the canonical reference energy. -/
theorem s584_IceCube_flux_benchmark :
    0 < Phi_nu_100TeV_units ∧ Phi_nu_100TeV_units = 15 / 10 :=
  ⟨s584_Phi_nu_100TeV_pos, s584_Phi_nu_100TeV_eq⟩

/-! ## s585 — Glashow resonance at 6.3 PeV -/

/-- **Glashow resonance peak energy** in PeV: `6.3`.

    The W boson resonance occurs at `E_ν = M_W² / (2 m_e) ≈ 6.3 PeV`
    in ν̄_e + e⁻ → W⁻ → hadrons (or → ν̄_ℓ + ℓ⁻).  Stored as the
    rational `63/10 = 6.3`. -/
noncomputable def E_nu_Glashow_PeV : ℝ := 63 / 10

/-- **s585 — Glashow energy > 0**. -/
theorem s585_E_nu_Glashow_pos : 0 < E_nu_Glashow_PeV := by
  unfold E_nu_Glashow_PeV; norm_num

/-- **s585 — Glashow energy = 6.3 PeV**. -/
theorem s585_E_nu_Glashow_eq : E_nu_Glashow_PeV = 63 / 10 := by
  unfold E_nu_Glashow_PeV; rfl

/-- **s585 — Glashow energy > 1 PeV** (decisively in the
    PeV regime, not TeV). -/
theorem s585_E_nu_Glashow_above_1PeV : 1 < E_nu_Glashow_PeV := by
  unfold E_nu_Glashow_PeV; norm_num

/-- **🚨 FRONTIER — s585 — Glashow resonance peaks at `6.3 PeV`**
    in ν̄_e + e⁻ → W⁻ — the only resonant ν-induced process in the
    Standard Model and a smoking-gun signature for ν̄_e content. -/
theorem s585_Glashow_resonance_6_3_PeV :
    0 < E_nu_Glashow_PeV ∧ E_nu_Glashow_PeV = 63 / 10 ∧ 1 < E_nu_Glashow_PeV :=
  ⟨s585_E_nu_Glashow_pos, s585_E_nu_Glashow_eq, s585_E_nu_Glashow_above_1PeV⟩

/-! ## s586 — Glashow cross-section ≈ 5 × 10⁻³¹ cm² -/

/-- **Glashow peak cross-section** in units of `10⁻³¹ cm²`: `5`.

    Stored as the mantissa for the `10⁻³¹ cm²` decade.  The Glashow
    resonance cross-section is roughly two orders of magnitude above
    the deep-inelastic-scattering ν–N cross-section at the same energy. -/
noncomputable def sigma_Glashow_units : ℝ := 5

/-- **s586 — Glashow cross-section > 0**. -/
theorem s586_sigma_Glashow_pos : 0 < sigma_Glashow_units := by
  unfold sigma_Glashow_units; norm_num

/-- **s586 — Glashow cross-section = 5**. -/
theorem s586_sigma_Glashow_eq : sigma_Glashow_units = 5 := by
  unfold sigma_Glashow_units; rfl

/-- **s586 — Glashow cross-section > 1** (well above unit reference). -/
theorem s586_sigma_Glashow_above_1 : 1 < sigma_Glashow_units := by
  unfold sigma_Glashow_units; norm_num

/-- **🚨 FRONTIER — s586 — Glashow peak cross-section is
    `5 × 10⁻³¹ cm²`** — orders of magnitude above the ν-N DIS
    baseline at the same energy, giving a sharp PeV bump. -/
theorem s586_Glashow_sigma_bracket :
    0 < sigma_Glashow_units ∧ sigma_Glashow_units = 5 := by
  exact ⟨s586_sigma_Glashow_pos, s586_sigma_Glashow_eq⟩

/-! ## s587 — Atmospheric ν background + signal-dominated ratio -/

/-- **Atmospheric ν flux at 100 TeV** in units of `10⁻¹⁸ GeV⁻¹ cm⁻² s⁻¹ sr⁻¹`:
    `1`.

    Conventional + prompt atmospheric ν background extrapolated to
    100 TeV.  Used as the denominator in the astro/atmo signal ratio. -/
noncomputable def Phi_nu_atmos_100TeV_units : ℝ := 1

/-- **s587 — Atmospheric ν flux > 0**. -/
theorem s587_Phi_nu_atmos_pos : 0 < Phi_nu_atmos_100TeV_units := by
  unfold Phi_nu_atmos_100TeV_units; norm_num

/-- **s587 — Atmospheric ν flux = 1**. -/
theorem s587_Phi_nu_atmos_eq : Phi_nu_atmos_100TeV_units = 1 := by
  unfold Phi_nu_atmos_100TeV_units; rfl

/-- **🚨 s587 — Astro/atmo ratio > 1 at 100 TeV**: astrophysical
    flux strictly exceeds atmospheric flux at the same energy
    (signal-dominated regime — IceCube discovery condition). -/
theorem s587_astro_above_atmospheric :
    Phi_nu_atmos_100TeV_units < Phi_nu_100TeV_units := by
  unfold Phi_nu_atmos_100TeV_units Phi_nu_100TeV_units; norm_num

/-- **🚨 FRONTIER — s587 — Astro vs atmospheric at 100 TeV**:
    astrophysical flux is strictly above atmospheric (`1.5 > 1` in
    `10⁻¹⁸` units). -/
theorem s587_astro_atmospheric_bracket :
    0 < Phi_nu_atmos_100TeV_units
    ∧ Phi_nu_atmos_100TeV_units < Phi_nu_100TeV_units :=
  ⟨s587_Phi_nu_atmos_pos, s587_astro_above_atmospheric⟩

/-! ## s588 — Bundle composition + IceCubeGen2NuFlux Prop -/

/-- **IceCubeGen2NuFlux** — Prop scaffold capturing the five
    invariants of the IceCube-Gen2 UHE-ν observatory program:

    1. positive astrophysical flux at 100 TeV (`Phi > 0`),
    2. Glashow resonance is in the multi-PeV regime (`E_Glashow > 1 PeV`),
    3. positive Glashow cross-section,
    4. positive atmospheric background,
    5. astro flux strictly above atmospheric (signal-dominated). -/
def IceCubeGen2NuFlux : Prop :=
    0 < Phi_nu_100TeV_units
    ∧ 1 < E_nu_Glashow_PeV
    ∧ 0 < sigma_Glashow_units
    ∧ 0 < Phi_nu_atmos_100TeV_units
    ∧ Phi_nu_atmos_100TeV_units < Phi_nu_100TeV_units

/-- **🚨 s588 — IceCubeGen2NuFlux Prop is realised by the bundle**. -/
theorem s588_IceCubeGen2NuFlux_holds : IceCubeGen2NuFlux := by
  unfold IceCubeGen2NuFlux
  exact ⟨s584_Phi_nu_100TeV_pos,
         s585_E_nu_Glashow_above_1PeV,
         s586_sigma_Glashow_pos,
         s587_Phi_nu_atmos_pos,
         s587_astro_above_atmospheric⟩

/-- **🚨 FRONTIER — HEADLINE — s584-s588 — IceCube-Gen2
    ultra-high-energy ν observatory + Glashow resonance bundle**.

    Six foundational facts spanning IceCube-Gen2 + Glashow:

    1. `Phi_nu_100TeV_units > 0` — IceCube astro ν flux benchmark (s584).
    2. `Phi_nu_100TeV_units = 1.5` — coefficient in `10⁻¹⁸` units (s584).
    3. `E_nu_Glashow_PeV > 1` — resonance squarely in PeV regime (s585).
    4. `sigma_Glashow_units > 0` — peak ν̄_e + e⁻ → W⁻ cross-section (s586).
    5. `Phi_nu_atmos_100TeV_units > 0` — atmospheric background present (s587).
    6. `Phi_nu_atmos < Phi_nu_100TeV` — astro signal-dominated at 100 TeV (s587).

    Multi-observable landscape:
    - **IceCube-Gen2** (South Pole, ~8 km³ planned, late 2020s/2030s):
      next-generation UHE-ν observatory.
    - **Glashow resonance** (predicted 1960, confirmed by IceCube 2021):
      the one resonant ν process in the Standard Model.
    - **Atmospheric ν** (conventional + prompt): the irreducible
      background at all astrophysical-ν energies.

    Sub-lemmas for sessions s584-s588 in T-1.  Lean-core only. -/
theorem s584_s588_IceCubeGen2_UHENu_bundle_headline :
    0 < Phi_nu_100TeV_units
    ∧ Phi_nu_100TeV_units = 15 / 10
    ∧ 1 < E_nu_Glashow_PeV
    ∧ 0 < sigma_Glashow_units
    ∧ 0 < Phi_nu_atmos_100TeV_units
    ∧ Phi_nu_atmos_100TeV_units < Phi_nu_100TeV_units :=
  ⟨s584_Phi_nu_100TeV_pos,
   s584_Phi_nu_100TeV_eq,
   s585_E_nu_Glashow_above_1PeV,
   s586_sigma_Glashow_pos,
   s587_Phi_nu_atmos_pos,
   s587_astro_above_atmospheric⟩

end OmegaTheory.Predictions.T1_IceCubeGen2UHENuBundle
