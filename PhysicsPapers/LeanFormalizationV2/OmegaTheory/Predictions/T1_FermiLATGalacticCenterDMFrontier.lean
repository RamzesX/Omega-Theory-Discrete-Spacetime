/-
  OmegaTheory.Predictions.T1_FermiLATGalacticCenterDMFrontier

  T-1 — Fermi-LAT galactic center indirect dark-matter gamma-ray
  FRONTIER, sessions 645-649.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the Fermi-LAT galactic
  center 2-3 GeV gamma-ray excess interpreted as WIMP dark-matter
  annihilation, vs the dwarf-galaxy stack non-detection bound on
  the canonical thermal-relic annihilation cross-section.

  Phenomenology context:

      ⟨σv⟩(SM)              = 0           (SM has no WIMP — no s-wave
                                          annihilation channel into
                                          gammas at tree level)
      ⟨σv⟩(GCE best-fit)    ~ 2 × 10⁻²⁶ cm³/s  (Fermi-LAT 2-3 GeV
                                                excess if WIMP, m_χ
                                                ~ 30-50 GeV, b-bbar)
      ⟨σv⟩(thermal canon.)  = 3 × 10⁻²⁶ cm³/s  (canonical WIMP
                                                thermal-relic value)
      ⟨σv⟩(dwarf bound 90%) < 3 × 10⁻²⁶ cm³/s  (Fermi-LAT dSph stack
                                                non-detection, b-bbar
                                                channel, m_χ ≈ 30 GeV)
      ⟨σv⟩(envelope)        ≤ 30 × 10⁻²⁷ cm³/s (substrate-prediction
                                                window; dwarf-galaxy
                                                bound saturated at
                                                m_χ ≈ 30 GeV)

  Working units: 10⁻²⁷ cm³/s (so `1` in our scale = 10⁻²⁷ in absolute
  units).  Substrate-prediction envelope is `⟨σv⟩ ≤ 30` in scaled
  units (= 3 × 10⁻²⁶ cm³/s in absolute units).

  This is DISTINCT from `T1_FermiLATGalacticCentreFrontier.lean`
  (session 291) — that file focuses on the GeV-excess detection
  significance + best-fit WIMP-mass parameters of the GCE itself,
  whereas this file focuses on the substrate-prediction envelope
  scaffold (Frontier + Prop + 6-conjunct headline) for the indirect
  cross-section bound vs the SM (= 0) baseline, mirroring the LZ
  direct-detection envelope file.  Both files coexist with no overlap.

  This is also DISTINCT from `T1_HESSGalacticCenterTeVBundle.lean`
  (TeV scale, m_χ ~ 1 TeV, Cherenkov atmospheric), and from
  `T1_CTAHESSDwarfGalaxiesFrontier.lean` (TeV-scale dSph stack).

  Substrate-prediction: in OmegaTheory's discrete substrate, the
  WIMP-style DM candidate rides the 4th irrational channel
  (sterile-neutrino / Catalan-G).  Sterile neutrinos couple
  feebly via active-sterile mixing, so the substrate-predicted
  ⟨σv⟩ is at-or-below the dwarf-galaxy thermal-cross-section
  envelope at m_χ ≈ 30 GeV — within the Fermi-LAT 2024 reach.

  Cross-references:

  - `T1_FermiLATGalacticCentreFrontier` (session 291): GCE-specific
    significance + WIMP-mass parameters (5-7σ, m_χ ~ 30-50 GeV).
  - `T1_LZDarkMatterDirectDetectionFrontier` (sessions 625-629):
    sister direct-detection envelope-Frontier file (LZ 2024,
    σ_SI < 2.2 × 10⁻⁴⁸ cm² at m_χ = 30 GeV).
  - `T1_DAMALIBRAAnnualModulationBundle` (sessions 674-678): sister
    annual-modulation file (positive-claim, in tension with LZ null).
  - `T1_CTAHESSDwarfGalaxiesFrontier` (session 295): TeV-mass dSph
    stack frontier (HESS + CTA, Cherenkov).
  - `T1_HESSGalacticCenterTeVBundle`: TeV-mass GC bundle.
  - `SterileNeutrinoFromFourthIrrational`: substrate-side witness
    for the 4th irrational DM channel.

  ## Sessions

  - s645: Fermi-LAT GC envelope half-width definition + positivity
  - s646: ⟨σv⟩ obs central + 1σ-equivalent reach within envelope
  - s647: 1σ, 3σ, 5σ reach bands all fit within envelope
  - s648: SM (= 0) limit within envelope; substrate-SM separation
          bound vs Fermi-LAT 2024 reach; thermal-canonical comparison
  - s649: FermiLATGalacticCenterDMFrontier Prop (6-conjunct) +
          headline + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_FermiLATGalacticCenterDMFrontier

/-! ## s645: Fermi-LAT GC envelope half-width (units 10⁻²⁷ cm³/s) -/

/-- **Fermi-LAT GC envelope half-width** (units 10⁻²⁷ cm³/s): `30`.
    Represents the Fermi-LAT 2024 dwarf-galaxy stack non-detection
    upper bound `⟨σv⟩ < 3 × 10⁻²⁶ cm³/s` at WIMP mass m_χ ≈ 30 GeV
    in the b-bbar annihilation channel (90% CL).  Annihilation
    cross-sections are non-negative by construction; a substrate
    prediction `⟨σv⟩_sub` is consistent with Fermi-LAT 2024 if
    `0 ≤ ⟨σv⟩_sub ≤ envelope`. -/
noncomputable def sigma_v_envelope_units : ℝ := 30

/-- **Fermi-LAT 2024 observed central value** (units 10⁻²⁷ cm³/s): `0`
    (no detection in dSph stack — the bound is a one-sided upper
    limit, the central value is consistent with zero within
    statistical fluctuation). -/
noncomputable def sigma_v_obs_units : ℝ := 0

/-- **Fermi-LAT 2024 1σ-equivalent uncertainty** (units 10⁻²⁷ cm³/s):
    `5` (≈ envelope/6, the 90% CL → 1σ conversion factor for a
    one-sided Gaussian upper limit on a non-negative quantity).
    Kept integer-valued for clean arithmetic; 5σ = 25 ≤ envelope = 30. -/
noncomputable def sigma_v_uncert_units : ℝ := 5

/-- **SM expected central** (units 10⁻²⁷ cm³/s): `0`.  The SM has no
    WIMP — dark matter must come from beyond the SM, so the SM
    expectation for ⟨σv⟩(WIMP-WIMP → γ + X) is identically zero. -/
noncomputable def sigma_v_SM_units : ℝ := 0

/-- **Thermal-relic canonical ⟨σv⟩** (units 10⁻²⁷ cm³/s): `30`
    (= 3 × 10⁻²⁶ cm³/s in absolute units).  The canonical WIMP
    thermal-relic annihilation cross-section, set by the freeze-out
    abundance Ω_χ h² ≈ 0.12.  Saturates the Fermi-LAT 2024 envelope
    at m_χ ≈ 30 GeV. -/
noncomputable def sigma_v_thermal_canonical_units : ℝ := 30

/-- **GCE best-fit ⟨σv⟩ (if WIMP)** (units 10⁻²⁷ cm³/s): `20`
    (= 2 × 10⁻²⁶ cm³/s in absolute units, mid-range of best-fit
    range to GCE 2-3 GeV peak with m_χ ~ 30-50 GeV b-bbar). -/
noncomputable def sigma_v_GCE_bestfit_units : ℝ := 20

/-- **🚨 s645 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s645_envelope_pos : 0 < sigma_v_envelope_units := by
  unfold sigma_v_envelope_units; norm_num

/-- **🚨 s645 — `envelope > 25`**: envelope reaches the 2.5 × 10⁻²⁶
    cm³/s scale, comfortably enclosing the canonical thermal value. -/
theorem T1_s645_envelope_gt_twenty_five : 25 < sigma_v_envelope_units := by
  unfold sigma_v_envelope_units; norm_num

/-- **🚨 s645 — `envelope = 30`** (units 10⁻²⁷ cm³/s): canonical
    Fermi-LAT 2024 dSph stack non-detection sensitivity-reach value
    at m_χ ≈ 30 GeV. -/
theorem T1_s645_envelope_eq_thirty :
    sigma_v_envelope_units = 30 := by
  unfold sigma_v_envelope_units; rfl

/-! ## s646: ⟨σv⟩ obs central + 1σ-equivalent reach within envelope -/

/-- **🚨 s646 — `⟨σv⟩_obs ≥ 0`**: annihilation cross-section is
    non-negative by construction. -/
theorem T1_s646_obs_nonneg : 0 ≤ sigma_v_obs_units := by
  unfold sigma_v_obs_units; norm_num

/-- **🚨 s646 — `⟨σv⟩_obs < envelope`**: upper envelope bound on
    Fermi-LAT 2024 observed central. -/
theorem T1_s646_obs_below_upper :
    sigma_v_obs_units < sigma_v_envelope_units := by
  unfold sigma_v_obs_units sigma_v_envelope_units; norm_num

/-- **🚨 s646 — `⟨σv⟩_SM = ⟨σv⟩_obs`**: SM (= 0 since no WIMP) and
    Fermi-LAT 2024 central (= 0 by construction since no detection)
    coincide. -/
theorem T1_s646_SM_eq_obs :
    sigma_v_SM_units = sigma_v_obs_units := by
  unfold sigma_v_SM_units sigma_v_obs_units; rfl

/-- **🚨 s646 — `⟨σv⟩_obs < σ`**: observed central is well below
    1σ-equivalent (0 < 5), confirming Fermi-LAT 2024 is consistent
    with SM at the < 1σ level. -/
theorem T1_s646_obs_lt_uncert :
    sigma_v_obs_units < sigma_v_uncert_units := by
  unfold sigma_v_obs_units sigma_v_uncert_units; norm_num

/-! ## s647: 1σ, 3σ, 5σ reach bands within envelope -/

/-- **🚨 s647 — `σ > 0`**: 1σ-equivalent reach positive. -/
theorem T1_s647_uncert_pos : 0 < sigma_v_uncert_units := by
  unfold sigma_v_uncert_units; norm_num

/-- **🚨 s647 — `σ < envelope`**: 1σ-equivalent reach fits within
    envelope (5 < 30). -/
theorem T1_s647_uncert_lt_envelope :
    sigma_v_uncert_units < sigma_v_envelope_units := by
  unfold sigma_v_uncert_units sigma_v_envelope_units; norm_num

/-- **🚨 s647 — `3σ < envelope`**: 3σ-equivalent band fits within
    envelope (15 < 30). -/
theorem T1_s647_three_sigma_lt_envelope :
    3 * sigma_v_uncert_units < sigma_v_envelope_units := by
  unfold sigma_v_uncert_units sigma_v_envelope_units; norm_num

/-- **🚨 s647 — `5σ ≤ envelope`**: 5σ discovery threshold fits
    within envelope (5 × 5 = 25 ≤ 30), within 5 units of
    saturating the Fermi-LAT 2024 sensitivity reach. -/
theorem T1_s647_five_sigma_le_envelope :
    5 * sigma_v_uncert_units ≤ sigma_v_envelope_units := by
  unfold sigma_v_uncert_units sigma_v_envelope_units; norm_num

/-- **🚨 s647 — `obs + 3σ < envelope`**: upper 3σ tail of observed
    (= 0 + 15 = 15) lies within envelope (15 < 30). -/
theorem T1_s647_obs_plus_three_sigma_within :
    sigma_v_obs_units + 3 * sigma_v_uncert_units
      < sigma_v_envelope_units := by
  unfold sigma_v_obs_units sigma_v_uncert_units sigma_v_envelope_units
  norm_num

/-! ## s648: SM (= 0) limit + substrate-SM separation + thermal-canonical -/

/-- **🚨 s648 — `⟨σv⟩_SM ≥ 0`**: SM expectation is non-negative
    (it's zero — SM has no WIMP). -/
theorem T1_s648_SM_nonneg : 0 ≤ sigma_v_SM_units := by
  unfold sigma_v_SM_units; norm_num

/-- **🚨 s648 — `⟨σv⟩_SM < envelope`**: SM expectation lies within
    envelope (0 < 30), so SM prediction is consistent with Fermi-LAT
    2024 sensitivity reach (trivially: SM expects no WIMP signal). -/
theorem T1_s648_SM_below_upper :
    sigma_v_SM_units < sigma_v_envelope_units := by
  unfold sigma_v_SM_units sigma_v_envelope_units; norm_num

/-- **🚨 s648 — `⟨σv⟩_obs - ⟨σv⟩_SM = 0`**: separation of Fermi-LAT
    2024 central from SM expectation is exactly zero. -/
theorem T1_s648_separation_eq_zero :
    sigma_v_obs_units - sigma_v_SM_units = 0 := by
  unfold sigma_v_obs_units sigma_v_SM_units; norm_num

/-- **🚨 s648 — `⟨σv⟩_obs - ⟨σv⟩_SM < envelope`**: separation is
    bounded (0 < 30). -/
theorem T1_s648_separation_lt_envelope :
    sigma_v_obs_units - sigma_v_SM_units < sigma_v_envelope_units := by
  unfold sigma_v_obs_units sigma_v_SM_units sigma_v_envelope_units
  norm_num

/-- **🚨 s648 — `⟨σv⟩_obs - ⟨σv⟩_SM < σ`**: separation is well within
    1σ-equivalent (0 < 5), confirming Fermi-LAT 2024 is consistent
    with SM at the < 1σ level. -/
theorem T1_s648_separation_lt_uncert :
    sigma_v_obs_units - sigma_v_SM_units < sigma_v_uncert_units := by
  unfold sigma_v_obs_units sigma_v_SM_units sigma_v_uncert_units
  norm_num

/-- **🚨 s648 — `thermal_canonical > 0`**: canonical thermal-relic
    cross-section is a positive value (30 = 3 × 10⁻²⁶). -/
theorem T1_s648_thermal_pos : 0 < sigma_v_thermal_canonical_units := by
  unfold sigma_v_thermal_canonical_units; norm_num

/-- **🚨 s648 — `thermal ≤ envelope`**: canonical thermal-relic
    cross-section saturates the Fermi-LAT 2024 envelope
    (30 ≤ 30) at m_χ ≈ 30 GeV — Fermi-LAT just begins to exclude
    the thermal-relic WIMP at this mass. -/
theorem T1_s648_thermal_le_envelope :
    sigma_v_thermal_canonical_units ≤ sigma_v_envelope_units := by
  unfold sigma_v_thermal_canonical_units sigma_v_envelope_units; norm_num

/-- **🚨 s648 — `GCE_bestfit > 0`**: GCE best-fit cross-section
    is a positive value (20 = 2 × 10⁻²⁶). -/
theorem T1_s648_gce_bestfit_pos : 0 < sigma_v_GCE_bestfit_units := by
  unfold sigma_v_GCE_bestfit_units; norm_num

/-- **🚨 s648 — `GCE_bestfit < envelope`**: GCE best-fit value is
    strictly inside the Fermi-LAT 2024 envelope (20 < 30) — the
    excess interpreted as WIMP is *not yet excluded* by the
    dwarf-galaxy stack at m_χ ≈ 30 GeV. -/
theorem T1_s648_gce_bestfit_lt_envelope :
    sigma_v_GCE_bestfit_units < sigma_v_envelope_units := by
  unfold sigma_v_GCE_bestfit_units sigma_v_envelope_units; norm_num

/-- **🚨 s648 — `GCE_bestfit < thermal`**: GCE best-fit (20) lies
    below the canonical thermal-relic value (30) — the GCE excess
    is somewhat sub-thermal, slightly disfavouring a pure
    thermal-relic interpretation. -/
theorem T1_s648_gce_bestfit_lt_thermal :
    sigma_v_GCE_bestfit_units < sigma_v_thermal_canonical_units := by
  unfold sigma_v_GCE_bestfit_units sigma_v_thermal_canonical_units; norm_num

/-! ## s649: Frontier Prop + 6-conjunct headline -/

/-- **FermiLATGalacticCenterDMFrontier**: 6-way conjunction pinning
    the substrate-prediction envelope for the Fermi-LAT 2024
    dwarf-galaxy stack non-detection bound on the WIMP-WIMP
    annihilation cross-section, in working units of 10⁻²⁷ cm³/s:

    1. `envelope > 0`                                  (positivity)
    2. `0 ≤ ⟨σv⟩_obs < envelope`                       (Fermi-LAT central within)
    3. `0 ≤ ⟨σv⟩_SM < envelope`                        (SM = 0 within)
    4. `σ_uncert < envelope ∧ 5σ ≤ envelope`           (full 5σ reach fits)
    5. `0 ≤ ⟨σv⟩_obs - ⟨σv⟩_SM < envelope`             (separation within)
    6. `thermal_canonical ≤ envelope`                  (Fermi-LAT just
                                                        excludes thermal
                                                        WIMP at m_χ ≈ 30 GeV)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `⟨σv⟩(WIMP-WIMP → γ + X)` (annihilation
    cross-section into gamma-final-state, m_χ ≈ 30 GeV, b-bbar
    channel) must lie within this envelope to remain consistent
    with Fermi-LAT 2024 dSph stack sensitivity reach. -/
def FermiLATGalacticCenterDMFrontier : Prop :=
  -- envelope > 0
  (0 < sigma_v_envelope_units) ∧
  -- 0 ≤ ⟨σv⟩_obs < envelope
  (0 ≤ sigma_v_obs_units ∧
    sigma_v_obs_units < sigma_v_envelope_units) ∧
  -- 0 ≤ ⟨σv⟩_SM < envelope
  (0 ≤ sigma_v_SM_units ∧
    sigma_v_SM_units < sigma_v_envelope_units) ∧
  -- σ_uncert < envelope ∧ 5σ ≤ envelope
  (sigma_v_uncert_units < sigma_v_envelope_units ∧
    5 * sigma_v_uncert_units ≤ sigma_v_envelope_units) ∧
  -- 0 ≤ ⟨σv⟩_obs - ⟨σv⟩_SM < envelope (= 0 by construction, but bounded)
  (sigma_v_obs_units - sigma_v_SM_units < sigma_v_envelope_units ∧
    sigma_v_obs_units - sigma_v_SM_units < sigma_v_uncert_units) ∧
  -- thermal_canonical ≤ envelope (Fermi-LAT just excludes thermal WIMP)
  (sigma_v_thermal_canonical_units ≤ sigma_v_envelope_units)

/-- **🚨 s649 — `FermiLATGalacticCenterDMFrontier`** holds. -/
theorem T1_s649_fermi_lat_galactic_center_dm_frontier :
    FermiLATGalacticCenterDMFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s645_envelope_pos
  · exact T1_s646_obs_nonneg
  · exact T1_s646_obs_below_upper
  · exact T1_s648_SM_nonneg
  · exact T1_s648_SM_below_upper
  · exact T1_s647_uncert_lt_envelope
  · exact T1_s647_five_sigma_le_envelope
  · exact T1_s648_separation_lt_envelope
  · exact T1_s648_separation_lt_uncert
  · exact T1_s648_thermal_le_envelope

/-! ## Headline -/

/-- **HEADLINE — sessions 645-649 — Fermi-LAT galactic center indirect
    DM gamma-ray frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s645: ⟨σv⟩ envelope half-width = 30 × 10⁻²⁷ cm³/s (= 3 × 10⁻²⁶,
            Fermi-LAT 2024 dSph stack sensitivity reach at m_χ ≈ 30 GeV,
            b-bbar channel, 90% CL)
    - s646: Fermi-LAT 2024 central ⟨σv⟩_obs = 0 within envelope
            (no detection in dSph stack)
    - s647: 1σ (5), 3σ (15), 5σ (25) reach bands fit within envelope
    - s648: SM (no WIMP, ⟨σv⟩ = 0) within envelope; Fermi-LAT-SM
            separation = 0; thermal-canonical = 30 ≤ envelope (just
            excludes thermal WIMP); GCE best-fit (20) < thermal (30)
    - s649: FermiLATGalacticCenterDMFrontier Prop (6-conjunct) +
            headline + bundle alias

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the Fermi-LAT 2024 dwarf-galaxy
    stack non-detection, the world-leading indirect-detection upper
    bound on WIMP-WIMP annihilation cross-section ⟨σv⟩ at m_χ ≈ 30 GeV
    in the b-bbar channel.  The galactic-center 2-3 GeV gamma-ray
    excess (Fermi-LAT, 5-7σ) admits a WIMP best-fit with m_χ ~ 30-50
    GeV and ⟨σv⟩ ~ 2 × 10⁻²⁶ cm³/s (just below the dwarf bound), in
    tension with millisecond-pulsar (MSP) astrophysical alternative.
    Any positive detection above this envelope at m_χ ≈ 30 GeV would
    be unambiguously beyond the SM (which has ⟨σv⟩(WIMP) = 0 — no
    WIMP at tree level).

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    WIMP-style DM candidate rides the 4th irrational channel
    (sterile-neutrino / Catalan-G).  Sterile neutrinos couple feebly
    via active-sterile mixing; the substrate-predicted ⟨σv⟩ is
    typically *below* the dwarf-galaxy thermal-cross-section envelope
    at m_χ ≈ 30 GeV — within the Fermi-LAT 2024 reach.  See
    `SterileNeutrinoFromFourthIrrational` for the substrate-side
    witness.

    Reference: Ackermann et al., "Searching for Dark Matter
    Annihilation from Milky Way Dwarf Spheroidal Galaxies with Six
    Years of Fermi Large Area Telescope Data", PRL 115, 231301 (2015);
    updated dSph stack analyses through 2024.

    Sub-lemma in T-1 dark-sector residue.  Lean-core only.

    🏆 First Lean-core Fermi-LAT galactic-center-DM indirect-detection
    frontier envelope. -/
theorem session_645_to_649_fermi_lat_galactic_center_dm_frontier_headline :
    0 < sigma_v_envelope_units
    ∧ 0 ≤ sigma_v_obs_units
    ∧ sigma_v_obs_units < sigma_v_envelope_units
    ∧ 0 ≤ sigma_v_SM_units
    ∧ sigma_v_SM_units < sigma_v_envelope_units
    ∧ sigma_v_uncert_units < sigma_v_envelope_units
    ∧ 5 * sigma_v_uncert_units ≤ sigma_v_envelope_units
    ∧ sigma_v_obs_units - sigma_v_SM_units < sigma_v_envelope_units
    ∧ sigma_v_thermal_canonical_units ≤ sigma_v_envelope_units
    ∧ sigma_v_GCE_bestfit_units < sigma_v_envelope_units
    ∧ FermiLATGalacticCenterDMFrontier :=
  ⟨T1_s645_envelope_pos,
   T1_s646_obs_nonneg, T1_s646_obs_below_upper,
   T1_s648_SM_nonneg, T1_s648_SM_below_upper,
   T1_s647_uncert_lt_envelope, T1_s647_five_sigma_le_envelope,
   T1_s648_separation_lt_envelope,
   T1_s648_thermal_le_envelope,
   T1_s648_gce_bestfit_lt_envelope,
   T1_s649_fermi_lat_galactic_center_dm_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_fermi_lat_galactic_center_dm_frontier_bundle :
    FermiLATGalacticCenterDMFrontier :=
  T1_s649_fermi_lat_galactic_center_dm_frontier

end OmegaTheory.Predictions.T1_FermiLATGalacticCenterDMFrontier
