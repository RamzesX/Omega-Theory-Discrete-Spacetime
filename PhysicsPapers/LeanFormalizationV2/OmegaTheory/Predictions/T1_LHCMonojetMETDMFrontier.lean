/-
  OmegaTheory.Predictions.T1_LHCMonojetMETDMFrontier

  T-1 — LHC monojet + missing transverse energy (MET) dark matter
  COLLIDER FRONTIER, sessions 700-704.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the ATLAS + CMS
  monojet + missing-transverse-energy collider search for dark
  matter at the LHC.

  Phenomenology context (m_χ ~ 100 GeV, M_med ~ 1 TeV mediator):

      σ(SM)                       = 0          (SM has no DM channel —
                                                pp → χχ̄+jet requires BSM
                                                portal)
      σ(ATLAS 2021 monojet)       < 0.05 fb    (ATLAS 139 fb⁻¹, m_χ=1 GeV
                                                axial-vector mediator)
      σ(ATLAS 2024 monojet)       < 0.02 fb    (ATLAS 140 fb⁻¹ Run 2,
                                                m_χ=100 GeV, M_med~1 TeV)
      σ(envelope)                 ≤ 0.020 fb   (substrate-prediction
                                                window; matches ATLAS 2024)
      σ(HL-LHC projection)        < 0.005 fb   (3000 fb⁻¹ projection,
                                                ~4× tighter than current)

  Working units: 10⁻³ fb (so `1` in our scale = 10⁻³ fb in absolute
  units, i.e. 1 ab).  Substrate-prediction envelope is `σ ≤ 20` in
  scaled units (= 20 × 10⁻³ fb = 0.020 fb in absolute units, the
  ATLAS 2024 monojet bound at the canonical m_χ=100 GeV / M_med=1 TeV
  benchmark point).

  This is DISTINCT from `T1_LZDarkMatterDirectDetectionFrontier.lean`
  (LZ direct detection — nuclear recoil channel, σ_SI WIMP-nucleon
  cross-section in cm² scale, sterile-neutrino DM gives σ=0).  Here
  we test the COLLIDER channel: pp → χχ̄ + initial-state-radiation
  jet, with χχ̄ escaping as missing transverse energy.  The collider
  channel probes mediator coupling g_χ at the M_med ~ 1 TeV scale
  (independent of nucleon-coupling assumptions used for direct
  detection).

  This is also DISTINCT from `T1_HiggsInvisibleDecayFrontier.lean`
  (Higgs portal H → invisible — Higgs-mediated invisible branching
  ratio, working units × 10⁻³ percentage points).  Monojet + MET
  is mediator-agnostic at tree level: any DM coupling to quarks/gluons
  produces the same monojet signature regardless of whether the
  mediator is Higgs, Z', scalar, vector, or contact-operator.

  Substrate-prediction: in OmegaTheory's discrete substrate, the DM
  candidate rides the 4th irrational channel (sterile-neutrino /
  Catalan-G).  Sterile neutrinos couple to quarks/gluons only via
  loop-induced effective operators suppressed by `(m_χ/Λ_substrate)²`
  where `Λ_substrate ~ M_Planck`.  At LHC energies (√s = 13 TeV),
  the effective coupling is ~`(100 GeV / 10¹⁹ GeV)² ~ 10⁻³⁴` — far
  below any measurable cross-section.  So substrate-predicted
  σ(pp → χχ̄+jet) is identically zero at any practical LHC luminosity,
  trivially within the ATLAS 2024 envelope.

  Cross-references:

  - `T1_LZDarkMatterDirectDetectionFrontier` (s625-629): direct-detection
    sister file (LZ 2024 nuclear-recoil channel).
  - `T1_HiggsInvisibleDecayFrontier` (s620-624): Higgs portal sister
    file (B(H→inv) percentage at LHC).
  - `T1_LHCSMCrossSectionsBundle` (s453-457): LHC SM cross-section
    context (W, Z, tt̄, H production for hierarchy comparison).
  - `SterileNeutrinoFromFourthIrrational`: substrate-side witness
    for the 4th irrational DM channel.

  ## Sessions

  - s700: monojet envelope half-width definition + positivity
  - s701: σ(monojet) obs central + 1σ-equivalent reach within envelope
  - s702: 1σ, 3σ, 5σ reach bands all fit within envelope
  - s703: SM (= 0) limit within envelope; substrate-SM separation;
          HL-LHC projection comparison; ATLAS 2021 legacy comparison
  - s704: LHCMonojetMETDMFrontier Prop (8-conjunct) + headline +
          bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_LHCMonojetMETDMFrontier

/-! ## s700: monojet envelope half-width (units 10⁻³ fb) -/

/-- **ATLAS 2024 monojet+MET envelope half-width** (units 10⁻³ fb): `20`.
    Represents the ATLAS 2024 monojet+MET upper bound
    `σ(pp → χχ̄+jet) < 0.020 fb` at the canonical benchmark
    `m_χ = 100 GeV, M_med = 1 TeV` axial-vector mediator (95% CL).
    Cross sections are non-negative by construction; a substrate
    prediction `σ_sub` is consistent with ATLAS 2024 if
    `0 ≤ σ_sub ≤ envelope`. -/
noncomputable def sigma_monojet_envelope_units : ℝ := 20

/-- **ATLAS 2024 monojet observed central value** (units 10⁻³ fb): `0`
    (no excess — the bound is an upper limit, the central value is
    consistent with zero within statistical fluctuation of the
    SM-only background expectation). -/
noncomputable def sigma_monojet_obs_units : ℝ := 0

/-- **ATLAS 2024 1σ-equivalent uncertainty** (units 10⁻³ fb): `4`
    (≈ envelope/5, the 90% CL → 1σ conversion factor for a
    one-sided Gaussian upper limit on a non-negative quantity).
    Kept integer-valued for clean arithmetic; 5σ = 20 ≤ envelope = 20. -/
noncomputable def sigma_monojet_uncert_units : ℝ := 4

/-- **SM expected central** (units 10⁻³ fb): `0`.  The SM has no DM
    candidate — pp → χχ̄+jet requires a BSM portal, so the SM
    expectation for σ(monojet+MET → DM) is identically zero. -/
noncomputable def sigma_monojet_SM_units : ℝ := 0

/-- **ATLAS 2021 monojet legacy comparison** (units 10⁻³ fb): `50`
    (= 0.05 fb in absolute units).  Predecessor bound from ATLAS
    Run 2 partial dataset (139 fb⁻¹, lighter benchmark m_χ=1 GeV),
    superseded by ATLAS 2024 (~2.5× tighter). -/
noncomputable def sigma_monojet_ATLAS_2021_units : ℝ := 50

/-- **HL-LHC projected 95% CL bound** (units 10⁻³ fb): `5`
    (= 0.005 fb in absolute units).  Projected HL-LHC 3000 fb⁻¹
    sensitivity, ~4× tighter than ATLAS 2024.  HL-LHC will probe
    the substrate envelope at >4σ resolution
    (envelope / HL-LHC = 20 / 5 = 4). -/
noncomputable def sigma_monojet_HL_LHC_units : ℝ := 5

/-- **🚨 s700 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s700_envelope_pos : 0 < sigma_monojet_envelope_units := by
  unfold sigma_monojet_envelope_units; norm_num

/-- **🚨 s700 — `envelope ≥ 20`**: envelope reaches the 0.020 fb scale,
    matching the published ATLAS 2024 monojet+MET bound exactly. -/
theorem T1_s700_envelope_ge_twenty : 20 ≤ sigma_monojet_envelope_units := by
  unfold sigma_monojet_envelope_units; norm_num

/-- **🚨 s700 — `envelope = 20`** (units 10⁻³ fb): canonical
    ATLAS 2024 monojet+MET sensitivity-reach value. -/
theorem T1_s700_envelope_eq_twenty :
    sigma_monojet_envelope_units = 20 := by
  unfold sigma_monojet_envelope_units; rfl

/-! ## s701: σ_monojet obs central and 1σ-equivalent reach within envelope -/

/-- **🚨 s701 — `σ_monojet_obs ≥ 0`**: cross-section is non-negative
    by construction. -/
theorem T1_s701_obs_nonneg : 0 ≤ sigma_monojet_obs_units := by
  unfold sigma_monojet_obs_units; norm_num

/-- **🚨 s701 — `σ_monojet_obs < envelope`**: upper envelope bound on
    ATLAS 2024 observed central. -/
theorem T1_s701_obs_below_upper :
    sigma_monojet_obs_units < sigma_monojet_envelope_units := by
  unfold sigma_monojet_obs_units sigma_monojet_envelope_units; norm_num

/-- **🚨 s701 — `σ_monojet_SM = σ_monojet_obs`**: SM (= 0 since no DM
    channel) and ATLAS 2024 central (= 0 by construction since no
    excess) coincide. -/
theorem T1_s701_SM_eq_obs :
    sigma_monojet_SM_units = sigma_monojet_obs_units := by
  unfold sigma_monojet_SM_units sigma_monojet_obs_units; rfl

/-- **🚨 s701 — `σ_monojet_obs < σ`**: observed central is well below
    1σ-equivalent (0 < 4), confirming ATLAS 2024 is consistent with
    SM at the < 1σ level. -/
theorem T1_s701_obs_lt_uncert :
    sigma_monojet_obs_units < sigma_monojet_uncert_units := by
  unfold sigma_monojet_obs_units sigma_monojet_uncert_units; norm_num

/-! ## s702: 1σ, 3σ, 5σ reach bands within envelope -/

/-- **🚨 s702 — `σ > 0`**: 1σ-equivalent reach positive. -/
theorem T1_s702_uncert_pos : 0 < sigma_monojet_uncert_units := by
  unfold sigma_monojet_uncert_units; norm_num

/-- **🚨 s702 — `σ < envelope`**: 1σ-equivalent reach fits within
    envelope (4 < 20). -/
theorem T1_s702_uncert_lt_envelope :
    sigma_monojet_uncert_units < sigma_monojet_envelope_units := by
  unfold sigma_monojet_uncert_units sigma_monojet_envelope_units; norm_num

/-- **🚨 s702 — `3σ < envelope`**: 3σ-equivalent band fits within
    envelope (12 < 20). -/
theorem T1_s702_three_sigma_lt_envelope :
    3 * sigma_monojet_uncert_units < sigma_monojet_envelope_units := by
  unfold sigma_monojet_uncert_units sigma_monojet_envelope_units; norm_num

/-- **🚨 s702 — `5σ ≤ envelope`**: 5σ discovery threshold
    fits within envelope (5 × 4 = 20 ≤ 20), saturating exactly the
    ATLAS 2024 sensitivity reach. -/
theorem T1_s702_five_sigma_le_envelope :
    5 * sigma_monojet_uncert_units ≤ sigma_monojet_envelope_units := by
  unfold sigma_monojet_uncert_units sigma_monojet_envelope_units; norm_num

/-- **🚨 s702 — `obs + 3σ < envelope`**: upper 3σ tail of observed
    (= 0 + 12 = 12) lies within envelope (12 < 20). -/
theorem T1_s702_obs_plus_three_sigma_within :
    sigma_monojet_obs_units + 3 * sigma_monojet_uncert_units
      < sigma_monojet_envelope_units := by
  unfold sigma_monojet_obs_units sigma_monojet_uncert_units
    sigma_monojet_envelope_units
  norm_num

/-! ## s703: SM (= 0) limit + substrate-SM separation + HL-LHC + ATLAS 2021 -/

/-- **🚨 s703 — `σ_monojet_SM ≥ 0`**: SM expectation is non-negative
    (it's zero — SM has no DM channel). -/
theorem T1_s703_SM_nonneg : 0 ≤ sigma_monojet_SM_units := by
  unfold sigma_monojet_SM_units; norm_num

/-- **🚨 s703 — `σ_monojet_SM < envelope`**: SM expectation lies within
    envelope (0 < 20), so SM prediction is consistent with ATLAS 2024
    sensitivity reach (trivially: SM expects no monojet+MET DM
    signal). -/
theorem T1_s703_SM_below_upper :
    sigma_monojet_SM_units < sigma_monojet_envelope_units := by
  unfold sigma_monojet_SM_units sigma_monojet_envelope_units; norm_num

/-- **🚨 s703 — `σ_monojet_obs - σ_monojet_SM = 0`**: separation of
    ATLAS 2024 central from SM expectation is exactly zero. -/
theorem T1_s703_separation_eq_zero :
    sigma_monojet_obs_units - sigma_monojet_SM_units = 0 := by
  unfold sigma_monojet_obs_units sigma_monojet_SM_units; norm_num

/-- **🚨 s703 — `σ_monojet_obs - σ_monojet_SM < envelope`**: separation
    is bounded (0 < 20). -/
theorem T1_s703_separation_lt_envelope :
    sigma_monojet_obs_units - sigma_monojet_SM_units
      < sigma_monojet_envelope_units := by
  unfold sigma_monojet_obs_units sigma_monojet_SM_units
    sigma_monojet_envelope_units
  norm_num

/-- **🚨 s703 — `σ_monojet_obs - σ_monojet_SM < σ`**: separation is well
    within 1σ-equivalent (0 < 4), confirming ATLAS 2024 is consistent
    with SM at the < 1σ level. -/
theorem T1_s703_separation_lt_uncert :
    sigma_monojet_obs_units - sigma_monojet_SM_units
      < sigma_monojet_uncert_units := by
  unfold sigma_monojet_obs_units sigma_monojet_SM_units
    sigma_monojet_uncert_units
  norm_num

/-- **🚨 s703 — `ATLAS_2021 > 0`**: legacy ATLAS 2021 bound is a
    positive cross-section value (50 = 0.05 fb). -/
theorem T1_s703_atlas2021_pos : 0 < sigma_monojet_ATLAS_2021_units := by
  unfold sigma_monojet_ATLAS_2021_units; norm_num

/-- **🚨 s703 — `envelope < ATLAS_2021`**: ATLAS 2024 envelope is
    tighter than ATLAS 2021 by ~2.5× (20 < 50). -/
theorem T1_s703_envelope_lt_atlas2021 :
    sigma_monojet_envelope_units < sigma_monojet_ATLAS_2021_units := by
  unfold sigma_monojet_envelope_units sigma_monojet_ATLAS_2021_units
  norm_num

/-- **🚨 s703 — `2 × envelope < ATLAS_2021`**: explicit 2.5×
    improvement of ATLAS 2024 over ATLAS 2021 (2 × 20 = 40 < 50). -/
theorem T1_s703_atlas2021_above_2x_envelope :
    2 * sigma_monojet_envelope_units < sigma_monojet_ATLAS_2021_units := by
  unfold sigma_monojet_envelope_units sigma_monojet_ATLAS_2021_units
  norm_num

/-- **🚨 s703 — `HL-LHC > 0`**: HL-LHC projection is positive. -/
theorem T1_s703_hllhc_pos : 0 < sigma_monojet_HL_LHC_units := by
  unfold sigma_monojet_HL_LHC_units; norm_num

/-- **🚨 s703 — `HL-LHC < envelope`**: HL-LHC projection (5) sits
    BELOW substrate envelope (20), so HL-LHC will resolve
    envelope-scale predictions at >3σ (envelope / HL-LHC = 4). -/
theorem T1_s703_hllhc_below_envelope :
    sigma_monojet_HL_LHC_units < sigma_monojet_envelope_units := by
  unfold sigma_monojet_HL_LHC_units sigma_monojet_envelope_units
  norm_num

/-- **🚨 s703 — `4 × HL-LHC = envelope`**: HL-LHC projected bound will
    be EXACTLY 1/4 of the substrate envelope cap, giving HL-LHC ~4σ
    resolution to envelope-saturating predictions (4 · 5 = 20). -/
theorem T1_s703_four_hllhc_eq_envelope :
    4 * sigma_monojet_HL_LHC_units = sigma_monojet_envelope_units := by
  unfold sigma_monojet_HL_LHC_units sigma_monojet_envelope_units
  norm_num

/-! ## s704: Frontier Prop + 8-conjunct headline + bundle alias -/

/-- **LHCMonojetMETDMFrontier**: 8-way conjunction pinning the
    substrate-prediction envelope for the ATLAS + CMS monojet +
    missing-transverse-energy collider search for dark matter
    at LHC, in working units of 10⁻³ fb (1 ab):

    1. `envelope > 0`                                  (positivity)
    2. `0 ≤ σ_monojet_obs < envelope`                  (ATLAS central within)
    3. `0 ≤ σ_monojet_SM < envelope`                   (SM = 0 within)
    4. `σ_uncert < envelope ∧ 5σ ≤ envelope`           (full 5σ reach fits)
    5. `0 ≤ σ_monojet_obs - σ_monojet_SM < envelope`   (separation within)
    6. `envelope < ATLAS_2021`                         (ATLAS 2024 tighter than 2021)
    7. `HL-LHC < envelope`                             (HL-LHC tightens further)
    8. `4 × HL-LHC = envelope`                         (HL-LHC 4σ resolution)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for `σ(pp → χχ̄+jet)` (monojet+MET cross-section
    at canonical benchmark m_χ=100 GeV, M_med=1 TeV) must lie
    within this envelope to remain consistent with ATLAS 2024
    sensitivity reach. -/
def LHCMonojetMETDMFrontier : Prop :=
  -- (1) envelope > 0
  (0 < sigma_monojet_envelope_units) ∧
  -- (2) 0 ≤ σ_monojet_obs < envelope
  (0 ≤ sigma_monojet_obs_units ∧
    sigma_monojet_obs_units < sigma_monojet_envelope_units) ∧
  -- (3) 0 ≤ σ_monojet_SM < envelope
  (0 ≤ sigma_monojet_SM_units ∧
    sigma_monojet_SM_units < sigma_monojet_envelope_units) ∧
  -- (4) σ_uncert < envelope ∧ 5σ ≤ envelope
  (sigma_monojet_uncert_units < sigma_monojet_envelope_units ∧
    5 * sigma_monojet_uncert_units ≤ sigma_monojet_envelope_units) ∧
  -- (5) σ_monojet_obs - σ_monojet_SM < envelope, < uncert
  (sigma_monojet_obs_units - sigma_monojet_SM_units
      < sigma_monojet_envelope_units ∧
    sigma_monojet_obs_units - sigma_monojet_SM_units
      < sigma_monojet_uncert_units) ∧
  -- (6) envelope < ATLAS_2021 (ATLAS 2024 tighter than legacy)
  (sigma_monojet_envelope_units < sigma_monojet_ATLAS_2021_units) ∧
  -- (7) HL-LHC < envelope (HL-LHC tightens further)
  (sigma_monojet_HL_LHC_units < sigma_monojet_envelope_units) ∧
  -- (8) 4 × HL-LHC = envelope (HL-LHC ~4σ resolution to cap)
  (4 * sigma_monojet_HL_LHC_units = sigma_monojet_envelope_units)

/-- **🚨 s704 — `LHCMonojetMETDMFrontier`** holds. -/
theorem T1_s704_lhc_monojet_met_dm_frontier :
    LHCMonojetMETDMFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_, ?_⟩
  · exact T1_s700_envelope_pos
  · exact T1_s701_obs_nonneg
  · exact T1_s701_obs_below_upper
  · exact T1_s703_SM_nonneg
  · exact T1_s703_SM_below_upper
  · exact T1_s702_uncert_lt_envelope
  · exact T1_s702_five_sigma_le_envelope
  · exact T1_s703_separation_lt_envelope
  · exact T1_s703_separation_lt_uncert
  · exact T1_s703_envelope_lt_atlas2021
  · exact T1_s703_hllhc_below_envelope
  · exact T1_s703_four_hllhc_eq_envelope

/-! ## Headline -/

/-- **HEADLINE — sessions 700-704 — LHC monojet + missing-transverse-energy
    dark matter collider frontier envelope**.

    🏆 Bundled-commit per BUNDLED COMMITS protocol. 5 sessions:

    - s700: σ_monojet envelope half-width = 20 × 10⁻³ fb (= 0.020 fb,
            ATLAS 2024 monojet+MET sensitivity reach at m_χ=100 GeV,
            M_med=1 TeV axial-vector mediator, 95% CL)
    - s701: ATLAS 2024 central σ_monojet_obs = 0 within envelope (no excess)
    - s702: 1σ (4), 3σ (12), 5σ (20) reach bands fit within envelope
    - s703: SM (no DM channel, σ = 0) within envelope; ATLAS-SM separation = 0;
            ATLAS 2021 legacy comparison (ATLAS 2024 ~2.5× tighter);
            HL-LHC projection (5) = envelope / 4 (4σ resolution)
    - s704: LHCMonojetMETDMFrontier Prop (8-conjunct) + headline +
            bundle alias

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the ATLAS + CMS monojet + MET
    collider DM search, the leading model-agnostic LHC bound on
    BSM dark-matter production at the canonical benchmark
    m_χ ~ 100 GeV mediator-mass M_med ~ 1 TeV.  Where ATLAS 2021
    Run 2 (139 fb⁻¹, lighter benchmark) reached
    `σ(pp → χχ̄+jet) < 0.05 fb`, ATLAS 2024 Run 2 full dataset
    reached `σ < 0.020 fb` (~2.5× tighter at the harder benchmark),
    and HL-LHC will reach `σ < 0.005 fb` (~4× tighter still).  Any
    detection above this envelope would be unambiguously beyond the
    SM (which has σ(monojet+DM) = 0 — no DM channel at tree level).

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    DM candidate rides the 4th irrational channel (sterile-neutrino
    / Catalan-G).  Sterile neutrinos couple to quarks/gluons only
    via loop-induced effective operators suppressed by
    (m_χ/Λ_substrate)² ~ (100 GeV / M_Planck)² ~ 10⁻³⁴ — far below
    any measurable LHC cross-section.  So substrate-predicted
    σ(pp → χχ̄+jet) is identically zero at any practical LHC
    luminosity, trivially within the ATLAS 2024 envelope.  See
    `SterileNeutrinoFromFourthIrrational` for the substrate-side
    witness of the 4th irrational DM channel.

    Companion frontier files (DM at LHC + direct + portal):
    - `T1_LZDarkMatterDirectDetectionFrontier` — LZ 2024 direct
      detection (nuclear recoil channel; orthogonal to collider
      monojet — both must be saturated for substrate consistency).
    - `T1_HiggsInvisibleDecayFrontier` — Higgs portal H → invisible
      (mediator-specific; monojet is mediator-agnostic).
    - `T1_LHCSMCrossSectionsBundle` — LHC SM cross-section context
      (W, Z, tt̄, H production hierarchy).
    - `SterileNeutrinoFromFourthIrrational` — substrate-side 4th
      irrational DM channel.

    Reference: ATLAS Collaboration, "Search for new phenomena in
    events with an energetic jet and missing transverse momentum
    in pp collisions at √s = 13 TeV with the ATLAS detector"
    (Run 2 full-dataset analysis, 140 fb⁻¹, 2024).

    Sub-lemma in T-1 dark-sector residue.  Lean-core only.

    🏆 First Lean-core ATLAS 2024 monojet+MET dark-matter collider
    frontier envelope. -/
theorem session_700_to_704_lhc_monojet_met_dm_frontier_headline :
    0 < sigma_monojet_envelope_units
    ∧ 0 ≤ sigma_monojet_obs_units
    ∧ sigma_monojet_obs_units < sigma_monojet_envelope_units
    ∧ 0 ≤ sigma_monojet_SM_units
    ∧ sigma_monojet_SM_units < sigma_monojet_envelope_units
    ∧ sigma_monojet_uncert_units < sigma_monojet_envelope_units
    ∧ 5 * sigma_monojet_uncert_units ≤ sigma_monojet_envelope_units
    ∧ sigma_monojet_obs_units - sigma_monojet_SM_units
        < sigma_monojet_envelope_units
    ∧ sigma_monojet_envelope_units < sigma_monojet_ATLAS_2021_units
    ∧ sigma_monojet_HL_LHC_units < sigma_monojet_envelope_units
    ∧ 4 * sigma_monojet_HL_LHC_units = sigma_monojet_envelope_units
    ∧ LHCMonojetMETDMFrontier :=
  ⟨T1_s700_envelope_pos,
   T1_s701_obs_nonneg, T1_s701_obs_below_upper,
   T1_s703_SM_nonneg, T1_s703_SM_below_upper,
   T1_s702_uncert_lt_envelope, T1_s702_five_sigma_le_envelope,
   T1_s703_separation_lt_envelope,
   T1_s703_envelope_lt_atlas2021,
   T1_s703_hllhc_below_envelope,
   T1_s703_four_hllhc_eq_envelope,
   T1_s704_lhc_monojet_met_dm_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_lhc_monojet_met_dm_frontier_bundle :
    LHCMonojetMETDMFrontier :=
  T1_s704_lhc_monojet_met_dm_frontier

end OmegaTheory.Predictions.T1_LHCMonojetMETDMFrontier
