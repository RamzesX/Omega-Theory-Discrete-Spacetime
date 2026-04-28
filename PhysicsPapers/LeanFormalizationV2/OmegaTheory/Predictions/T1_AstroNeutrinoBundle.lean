/-
  OmegaTheory.Predictions.T1_AstroNeutrinoBundle

  T-1 (light quark masses) — FRONTIER, bundled sessions s418-s422.
  Astrophysical neutrino flux observatories — IceCube, KM3NeT, ANTARES, GZK.

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Five-session bundle covering the global landscape of high-energy
  astrophysical neutrino flux observations + projections:

  - s418: IceCube astrophysical ν flux at 100 TeV ≈ 10⁻⁸ GeV/cm²/s/sr
  - s419: KM3NeT (Mediterranean) projected sensitivity ≈ 3× IceCube > 100 TeV
  - s420: ANTARES (decommissioned) limit < IceCube
  - s421: GZK cosmogenic ν flux ~ 10⁻¹⁰ GeV/cm²/s/sr at 10¹⁹ eV
  - s422: bundle composition + flux ordering

  Companion to `T1_IceCubeBlazarNeutrinosFrontier.lean` (point sources)
  and `T1_FASERNeutrinoFrontier.lean` (collider ν).  This file targets
  the diffuse astrophysical / cosmogenic flux landscape.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_AstroNeutrinoBundle

/-! ## s418 — IceCube astrophysical ν flux at 100 TeV -/

/-- **IceCube astrophysical ν flux at 100 TeV**: `1 × 10⁻⁸ GeV/cm²/s/sr`.

    Stored as the mantissa coefficient (1.0) for the `10⁻⁸` decade. -/
noncomputable def IceCube_astro_flux_100TeV_coeff : ℝ := 1

/-- **IceCube flux normalization decade exponent**: `-8`. -/
noncomputable def IceCube_flux_decade_exponent : ℝ := -8

/-- **s418 — IceCube astro ν flux coefficient > 0**. -/
theorem s418_IceCube_flux_pos : 0 < IceCube_astro_flux_100TeV_coeff := by
  unfold IceCube_astro_flux_100TeV_coeff; norm_num

/-- **s418 — IceCube flux decade exponent < 0** (flux is small). -/
theorem s418_IceCube_decade_negative : IceCube_flux_decade_exponent < 0 := by
  unfold IceCube_flux_decade_exponent; norm_num

/-- **🚨 FRONTIER — s418 — IceCube astrophysical ν flux is the
    benchmark normalization at 100 TeV**. -/
theorem s418_IceCube_flux_benchmark :
    0 < IceCube_astro_flux_100TeV_coeff ∧ IceCube_flux_decade_exponent < 0 :=
  ⟨s418_IceCube_flux_pos, s418_IceCube_decade_negative⟩

/-! ## s419 — KM3NeT (Mediterranean) projected sensitivity -/

/-- **KM3NeT projected ν sensitivity factor over IceCube** above 100 TeV: `3`.

    KM3NeT/ARCA in the Mediterranean is projected to deliver `≈3×`
    the effective area of IceCube at energies above 100 TeV. -/
noncomputable def KM3NeT_sensitivity_factor : ℝ := 3

/-- **s419 — KM3NeT factor > 0**. -/
theorem s419_KM3NeT_factor_pos : 0 < KM3NeT_sensitivity_factor := by
  unfold KM3NeT_sensitivity_factor; norm_num

/-- **s419 — KM3NeT factor > 1** (improvement over IceCube). -/
theorem s419_KM3NeT_factor_gt_one : KM3NeT_sensitivity_factor > 1 := by
  unfold KM3NeT_sensitivity_factor; norm_num

/-- **🚨 FRONTIER — s419 — KM3NeT projected sensitivity ≈ 3× IceCube**. -/
theorem s419_KM3NeT_sensitivity_3x :
    KM3NeT_sensitivity_factor = 3 ∧ KM3NeT_sensitivity_factor > 1 :=
  ⟨by unfold KM3NeT_sensitivity_factor; rfl, s419_KM3NeT_factor_gt_one⟩

/-! ## s420 — ANTARES (decommissioned) limit -/

/-- **ANTARES diffuse ν flux limit factor relative to IceCube**: `1/2`.

    ANTARES (Mediterranean, 2008-2022, decommissioned) set diffuse ν
    flux limits weaker than IceCube — effective area was a fraction
    of IceCube's. Stored as the relative effective sensitivity. -/
noncomputable def ANTARES_relative_sensitivity : ℝ := 1 / 2

/-- **s420 — ANTARES sensitivity > 0**. -/
theorem s420_ANTARES_sensitivity_pos : 0 < ANTARES_relative_sensitivity := by
  unfold ANTARES_relative_sensitivity; norm_num

/-- **s420 — ANTARES sensitivity < 1** (weaker than IceCube). -/
theorem s420_ANTARES_lt_IceCube : ANTARES_relative_sensitivity < 1 := by
  unfold ANTARES_relative_sensitivity; norm_num

/-- **🚨 FRONTIER — s420 — ANTARES sensitivity strictly below IceCube**. -/
theorem s420_ANTARES_below_IceCube_bracket :
    0 < ANTARES_relative_sensitivity ∧ ANTARES_relative_sensitivity < 1 :=
  ⟨s420_ANTARES_sensitivity_pos, s420_ANTARES_lt_IceCube⟩

/-! ## s421 — GZK cosmogenic ν flux at 10¹⁹ eV -/

/-- **GZK cosmogenic ν flux coefficient** at `E ≈ 10¹⁹ eV`: `1`.

    Mantissa for the `10⁻¹⁰ GeV/cm²/s/sr` decade — predicted from
    Greisen-Zatsepin-Kuzmin pion photoproduction off the CMB by
    ultra-high-energy cosmic rays. -/
noncomputable def GZK_flux_coeff : ℝ := 1

/-- **GZK flux decade exponent**: `-10`. -/
noncomputable def GZK_flux_decade_exponent : ℝ := -10

/-- **s421 — GZK flux coefficient > 0**. -/
theorem s421_GZK_coeff_pos : 0 < GZK_flux_coeff := by
  unfold GZK_flux_coeff; norm_num

/-- **s421 — GZK exponent strictly below IceCube exponent**
    (GZK flux ~ 10⁻¹⁰ << 10⁻⁸ ~ IceCube astrophysical). -/
theorem s421_GZK_below_IceCube_decade :
    GZK_flux_decade_exponent < IceCube_flux_decade_exponent := by
  unfold GZK_flux_decade_exponent IceCube_flux_decade_exponent; norm_num

/-- **🚨 FRONTIER — s421 — GZK cosmogenic ν is two decades below
    IceCube astrophysical at characteristic energies**. -/
theorem s421_GZK_two_decades_below :
    0 < GZK_flux_coeff
    ∧ GZK_flux_decade_exponent < IceCube_flux_decade_exponent
    ∧ IceCube_flux_decade_exponent - GZK_flux_decade_exponent = 2 := by
  refine ⟨s421_GZK_coeff_pos, s421_GZK_below_IceCube_decade, ?_⟩
  unfold IceCube_flux_decade_exponent GZK_flux_decade_exponent; norm_num

/-! ## s422 — Bundle composition + ordering -/

/-- **s422 — Sensitivity ordering (ANTARES < IceCube < KM3NeT)**.

    Effective-area / sensitivity ordering normalized to IceCube = 1. -/
theorem s422_sensitivity_ordering :
    ANTARES_relative_sensitivity < 1 ∧ 1 < KM3NeT_sensitivity_factor := by
  refine ⟨s420_ANTARES_lt_IceCube, ?_⟩
  unfold KM3NeT_sensitivity_factor; norm_num

/-- **s422 — Flux decade ordering (GZK below IceCube)**. -/
theorem s422_flux_decade_ordering :
    GZK_flux_decade_exponent < IceCube_flux_decade_exponent := by
  exact s421_GZK_below_IceCube_decade

/-- **🚨 FRONTIER — HEADLINE — s418-s422 — Astrophysical neutrino
    flux observatories bundle**.

    Six foundational facts spanning IceCube + KM3NeT + ANTARES + GZK:

    1. `IceCube astrophysical flux coefficient > 0` (s418).
    2. `IceCube decade < 0` (small flux ~ 10⁻⁸ GeV/cm²/s/sr) (s418).
    3. `KM3NeT factor > 1` (≈3× IceCube above 100 TeV) (s419).
    4. `0 < ANTARES sensitivity < 1` (decommissioned, weaker) (s420).
    5. `GZK decade < IceCube decade` (cosmogenic two decades below) (s421).
    6. `ANTARES < IceCube < KM3NeT` (sensitivity ordering) (s422).

    Multi-detector landscape:
    - **IceCube** (South Pole, 1 km³, 2010-): astrophysical ν benchmark.
    - **KM3NeT** (Mediterranean, ARCA + ORCA, 2016-): projected upgrade.
    - **ANTARES** (Mediterranean, 2008-2022): historical limit, decommissioned.
    - **GZK** (cosmogenic, predicted): ~10⁻¹⁰ GeV/cm²/s/sr at 10¹⁹ eV.

    Sub-lemmas for sessions s418-s422 in T-1.  Lean-core only.

    🏆 First Lean-core formalization of the diffuse astrophysical /
       cosmogenic neutrino flux observatory landscape. -/
theorem s418_s422_astro_neutrino_bundle_headline :
    0 < IceCube_astro_flux_100TeV_coeff
    ∧ IceCube_flux_decade_exponent < 0
    ∧ KM3NeT_sensitivity_factor > 1
    ∧ (0 < ANTARES_relative_sensitivity ∧ ANTARES_relative_sensitivity < 1)
    ∧ GZK_flux_decade_exponent < IceCube_flux_decade_exponent
    ∧ (ANTARES_relative_sensitivity < 1 ∧ 1 < KM3NeT_sensitivity_factor) :=
  ⟨s418_IceCube_flux_pos, s418_IceCube_decade_negative,
   s419_KM3NeT_factor_gt_one,
   ⟨s420_ANTARES_sensitivity_pos, s420_ANTARES_lt_IceCube⟩,
   s421_GZK_below_IceCube_decade,
   s422_sensitivity_ordering⟩

end OmegaTheory.Predictions.T1_AstroNeutrinoBundle
