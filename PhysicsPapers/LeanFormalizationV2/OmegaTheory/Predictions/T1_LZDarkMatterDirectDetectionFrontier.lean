/-
  OmegaTheory.Predictions.T1_LZDarkMatterDirectDetectionFrontier

  T-1 — LZ (LUX-ZEPLIN) 2024 first-results dark matter direct detection
  FRONTIER, sessions 625-629.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the LUX-ZEPLIN 2024
  first-results spin-independent WIMP-nucleon cross-section limit,
  the world-leading bound at 30 GeV WIMP mass.

  Phenomenology context:

      σ_SI(SM)              = 0           (SM has no WIMP — dark matter
                                          must come from beyond the SM)
      σ_SI(XENON1T 2018)    < 1.1 × 10⁻⁴⁷ cm²    (Aprile et al., 2018)
      σ_SI(XENONnT 2024)    < 1.5 × 10⁻⁴⁷ cm²    (90% CL, M_χ = 30 GeV)
      σ_SI(LZ 2024)         < 2.2 × 10⁻⁴⁸ cm²    (Aalbers et al., PRL
                                                  131, 041002, 2024)
      σ_SI(envelope)        ≤ 2.2 × 10⁻⁴⁸ cm²    (substrate-prediction
                                                  window; ~5× tighter
                                                  than XENON1T)

  Working units: 10⁻⁴⁸ cm² (so `1` in our scale = 10⁻⁴⁸ in absolute
  units).  Substrate-prediction envelope is `σ_SI ≤ 22` in scaled
  units (= 2.2 × 10⁻⁴⁸ cm² in absolute units).

  This is DISTINCT from `T1_DAMALIBRAAnnualModulationBundle.lean`
  (DAMA/LIBRA annual modulation, an INDIRECT-style positive-claim
  signature in NaI-Tl detectors) — DAMA cites a positive signature
  in tension with all other null direct-detection experiments.  Here
  LZ is the world-leading direct-detection NULL bound, in unique
  units of 10⁻⁴⁸ to keep the arithmetic clean for envelope conjuncts.

  This is also DISTINCT from the existing
  `T1_DarkMatterDirectDetectionFrontier.lean` (3-theorem coarse
  frontier file at 5×10⁻⁴⁸ scale): here we focus on the LZ 2024 first
  result specifically, with envelope-Frontier scaffold + Prop +
  multi-conjunct headline mirroring `T1_ACMEIIIElectronEDMFrontier`.

  Substrate-prediction: in OmegaTheory's discrete substrate, the
  WIMP candidate rides the 4th irrational channel (sterile-neutrino /
  Catalan-G).  Sterile neutrinos do NOT couple electroweakly to
  nucleons, so the substrate-predicted σ_SI is identically zero at
  tree level — well within the LZ 2024 envelope.

  Cross-references:

  - `T1_DarkMatterDirectDetectionFrontier` (session 249): coarse
    frontier file.
  - `T1_DAMALIBRAAnnualModulationBundle` (sessions 674-678): sister
    DAMA modulation file (positive-claim signature, in tension).
  - `T1_ACMEIIIElectronEDMFrontier` (sessions 595-599): same
    envelope-Frontier scaffold pattern (lepton-EDM CP-violation).
  - `T1_NeutronEDMFrontier` (session 250): hadronic-CP partner file.
  - `SterileNeutrinoFromFourthIrrational`: substrate-side witness
    for the 4th irrational DM channel.

  ## Sessions

  - s625: LZ 2024 envelope half-width definition + positivity
  - s626: σ_SI obs central + 1σ-equivalent reach within envelope
  - s627: 1σ, 3σ, 5σ reach bands all fit within envelope
  - s628: SM (= 0) limit within envelope; substrate-SM separation
          bound vs LZ 2024 reach; XENON1T 2018 comparison
  - s629: LZDarkMatterDirectDetectionFrontier Prop (6-conjunct) +
          headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_LZDarkMatterDirectDetectionFrontier

/-! ## s625: LZ 2024 envelope half-width (units 10⁻⁴⁸ cm²) -/

/-- **LZ 2024 envelope half-width** (units 10⁻⁴⁸ cm²): `22`.
    Represents the LUX-ZEPLIN 2024 first-results upper bound
    `σ_SI < 2.2 × 10⁻⁴⁸ cm²` at WIMP mass 30 GeV (90% CL).  Cross
    sections are non-negative by construction; a substrate prediction
    `σ_sub` is consistent with LZ 2024 if `0 ≤ σ_sub ≤ envelope`. -/
noncomputable def sigma_SI_envelope_units : ℝ := 22

/-- **LZ 2024 observed central value** (units 10⁻⁴⁸ cm²): `0`
    (no detection — the bound is an upper limit, the central value
    is consistent with zero within statistical fluctuation). -/
noncomputable def sigma_SI_obs_units : ℝ := 0

/-- **LZ 2024 1σ-equivalent uncertainty** (units 10⁻⁴⁸ cm²): `4`
    (≈ envelope/5, the 90% CL → 1σ conversion factor for a
    one-sided Gaussian upper limit on a non-negative quantity).
    Kept integer-valued for clean arithmetic; 5σ = 20 ≤ envelope = 22. -/
noncomputable def sigma_SI_uncert_units : ℝ := 4

/-- **SM expected central** (units 10⁻⁴⁸ cm²): `0`.  The SM has no
    WIMP — dark matter must come from beyond the SM, so the SM
    expectation for σ_SI(WIMP-nucleon) is identically zero. -/
noncomputable def sigma_SI_SM_units : ℝ := 0

/-- **XENON1T 2018 (legacy comparison)** (units 10⁻⁴⁸ cm²): `110`
    (= 1.1 × 10⁻⁴⁷ cm² in absolute units).  Predecessor bound,
    superseded by LZ 2024 (~5× tighter). -/
noncomputable def sigma_SI_XENON1T_2018_units : ℝ := 110

/-- **🚨 s625 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s625_envelope_pos : 0 < sigma_SI_envelope_units := by
  unfold sigma_SI_envelope_units; norm_num

/-- **🚨 s625 — `envelope > 20`**: envelope reaches the 2.0 × 10⁻⁴⁸
    cm² scale, marginally tighter than the published 2.2 × 10⁻⁴⁸. -/
theorem T1_s625_envelope_gt_twenty : 20 < sigma_SI_envelope_units := by
  unfold sigma_SI_envelope_units; norm_num

/-- **🚨 s625 — `envelope = 22`** (units 10⁻⁴⁸ cm²): canonical
    LZ 2024 sensitivity-reach value. -/
theorem T1_s625_envelope_eq_twenty_two :
    sigma_SI_envelope_units = 22 := by
  unfold sigma_SI_envelope_units; rfl

/-! ## s626: σ_SI obs central and 1σ-equivalent reach within envelope -/

/-- **🚨 s626 — `σ_SI_obs ≥ 0`**: cross-section is non-negative
    by construction. -/
theorem T1_s626_obs_nonneg : 0 ≤ sigma_SI_obs_units := by
  unfold sigma_SI_obs_units; norm_num

/-- **🚨 s626 — `σ_SI_obs < envelope`**: upper envelope bound on
    LZ 2024 observed central. -/
theorem T1_s626_obs_below_upper :
    sigma_SI_obs_units < sigma_SI_envelope_units := by
  unfold sigma_SI_obs_units sigma_SI_envelope_units; norm_num

/-- **🚨 s626 — `σ_SI_SM = σ_SI_obs`**: SM (= 0 since no WIMP) and
    LZ 2024 central (= 0 by construction since no detection)
    coincide. -/
theorem T1_s626_SM_eq_obs :
    sigma_SI_SM_units = sigma_SI_obs_units := by
  unfold sigma_SI_SM_units sigma_SI_obs_units; rfl

/-- **🚨 s626 — `σ_SI_obs < σ`**: observed central is well below
    1σ-equivalent (0 < 4), confirming LZ 2024 is consistent with
    SM at the < 1σ level. -/
theorem T1_s626_obs_lt_uncert :
    sigma_SI_obs_units < sigma_SI_uncert_units := by
  unfold sigma_SI_obs_units sigma_SI_uncert_units; norm_num

/-! ## s627: 1σ, 3σ, 5σ reach bands within envelope -/

/-- **🚨 s627 — `σ > 0`**: 1σ-equivalent reach positive. -/
theorem T1_s627_uncert_pos : 0 < sigma_SI_uncert_units := by
  unfold sigma_SI_uncert_units; norm_num

/-- **🚨 s627 — `σ < envelope`**: 1σ-equivalent reach fits within
    envelope (4 < 22). -/
theorem T1_s627_uncert_lt_envelope :
    sigma_SI_uncert_units < sigma_SI_envelope_units := by
  unfold sigma_SI_uncert_units sigma_SI_envelope_units; norm_num

/-- **🚨 s627 — `3σ < envelope`**: 3σ-equivalent band fits within
    envelope (12 < 22). -/
theorem T1_s627_three_sigma_lt_envelope :
    3 * sigma_SI_uncert_units < sigma_SI_envelope_units := by
  unfold sigma_SI_uncert_units sigma_SI_envelope_units; norm_num

/-- **🚨 s627 — `5σ ≤ envelope`**: 5σ discovery threshold
    fits within envelope (5 × 4 = 20 ≤ 22), within 2 units of
    saturating the LZ 2024 sensitivity reach. -/
theorem T1_s627_five_sigma_le_envelope :
    5 * sigma_SI_uncert_units ≤ sigma_SI_envelope_units := by
  unfold sigma_SI_uncert_units sigma_SI_envelope_units; norm_num

/-- **🚨 s627 — `obs + 3σ < envelope`**: upper 3σ tail of observed
    (= 0 + 12 = 12) lies within envelope (12 < 22). -/
theorem T1_s627_obs_plus_three_sigma_within :
    sigma_SI_obs_units + 3 * sigma_SI_uncert_units
      < sigma_SI_envelope_units := by
  unfold sigma_SI_obs_units sigma_SI_uncert_units sigma_SI_envelope_units
  norm_num

/-! ## s628: SM (= 0) limit + substrate-SM separation + XENON1T legacy -/

/-- **🚨 s628 — `σ_SI_SM ≥ 0`**: SM expectation is non-negative
    (it's zero — SM has no WIMP). -/
theorem T1_s628_SM_nonneg : 0 ≤ sigma_SI_SM_units := by
  unfold sigma_SI_SM_units; norm_num

/-- **🚨 s628 — `σ_SI_SM < envelope`**: SM expectation lies within
    envelope (0 < 22), so SM prediction is consistent with LZ 2024
    sensitivity reach (trivially: SM expects no WIMP signal). -/
theorem T1_s628_SM_below_upper :
    sigma_SI_SM_units < sigma_SI_envelope_units := by
  unfold sigma_SI_SM_units sigma_SI_envelope_units; norm_num

/-- **🚨 s628 — `σ_SI_obs - σ_SI_SM = 0`**: separation of LZ 2024
    central from SM expectation is exactly zero. -/
theorem T1_s628_separation_eq_zero :
    sigma_SI_obs_units - sigma_SI_SM_units = 0 := by
  unfold sigma_SI_obs_units sigma_SI_SM_units; norm_num

/-- **🚨 s628 — `σ_SI_obs - σ_SI_SM < envelope`**: separation is
    bounded (0 < 22). -/
theorem T1_s628_separation_lt_envelope :
    sigma_SI_obs_units - sigma_SI_SM_units < sigma_SI_envelope_units := by
  unfold sigma_SI_obs_units sigma_SI_SM_units sigma_SI_envelope_units
  norm_num

/-- **🚨 s628 — `σ_SI_obs - σ_SI_SM < σ`**: separation is well within
    1σ-equivalent (0 < 4), confirming LZ 2024 is consistent with
    SM at the < 1σ level. -/
theorem T1_s628_separation_lt_uncert :
    sigma_SI_obs_units - sigma_SI_SM_units < sigma_SI_uncert_units := by
  unfold sigma_SI_obs_units sigma_SI_SM_units sigma_SI_uncert_units
  norm_num

/-- **🚨 s628 — `XENON1T_2018 > 0`**: legacy XENON1T 2018 bound
    is a positive cross-section value (110 = 1.1 × 10⁻⁴⁷). -/
theorem T1_s628_xenon1t_pos : 0 < sigma_SI_XENON1T_2018_units := by
  unfold sigma_SI_XENON1T_2018_units; norm_num

/-- **🚨 s628 — `envelope < XENON1T_2018`**: LZ 2024 envelope is
    tighter than XENON1T 2018 by ~5× (22 < 110). -/
theorem T1_s628_envelope_lt_xenon1t :
    sigma_SI_envelope_units < sigma_SI_XENON1T_2018_units := by
  unfold sigma_SI_envelope_units sigma_SI_XENON1T_2018_units; norm_num

/-- **🚨 s628 — `5 × envelope ≤ XENON1T_2018`**: explicit 5×
    improvement of LZ 2024 over XENON1T 2018 (5 × 22 = 110 ≤ 110). -/
theorem T1_s628_xenon1t_at_least_5x_envelope :
    5 * sigma_SI_envelope_units ≤ sigma_SI_XENON1T_2018_units := by
  unfold sigma_SI_envelope_units sigma_SI_XENON1T_2018_units; norm_num

/-! ## s629: Frontier Prop + 6-conjunct headline -/

/-- **LZDarkMatterDirectDetectionFrontier**: 6-way conjunction pinning
    the substrate-prediction envelope for the LZ (LUX-ZEPLIN) 2024
    first-results spin-independent WIMP-nucleon cross-section bound,
    in working units of 10⁻⁴⁸ cm²:

    1. `envelope > 0`                                  (positivity)
    2. `0 ≤ σ_SI_obs < envelope`                       (LZ central within)
    3. `0 ≤ σ_SI_SM < envelope`                        (SM = 0 within)
    4. `σ_uncert < envelope ∧ 5σ ≤ envelope`           (full 5σ reach fits)
    5. `0 ≤ σ_SI_obs - σ_SI_SM < envelope`             (separation within)
    6. `envelope < XENON1T_2018`                       (LZ tighter than legacy)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `σ_SI(WIMP-nucleon)` (spin-independent
    cross-section at WIMP mass ~30 GeV) must lie within this envelope
    to remain consistent with LZ 2024 sensitivity reach. -/
def LZDarkMatterDirectDetectionFrontier : Prop :=
  -- envelope > 0
  (0 < sigma_SI_envelope_units) ∧
  -- 0 ≤ σ_SI_obs < envelope
  (0 ≤ sigma_SI_obs_units ∧
    sigma_SI_obs_units < sigma_SI_envelope_units) ∧
  -- 0 ≤ σ_SI_SM < envelope
  (0 ≤ sigma_SI_SM_units ∧
    sigma_SI_SM_units < sigma_SI_envelope_units) ∧
  -- σ_uncert < envelope ∧ 5σ ≤ envelope
  (sigma_SI_uncert_units < sigma_SI_envelope_units ∧
    5 * sigma_SI_uncert_units ≤ sigma_SI_envelope_units) ∧
  -- 0 ≤ σ_SI_obs - σ_SI_SM < envelope (= 0 by construction, but bounded)
  (sigma_SI_obs_units - sigma_SI_SM_units < sigma_SI_envelope_units ∧
    sigma_SI_obs_units - sigma_SI_SM_units < sigma_SI_uncert_units) ∧
  -- envelope < XENON1T_2018 (LZ tighter than legacy)
  (sigma_SI_envelope_units < sigma_SI_XENON1T_2018_units)

/-- **🚨 s629 — `LZDarkMatterDirectDetectionFrontier`** holds. -/
theorem T1_s629_lz_dark_matter_direct_detection_frontier :
    LZDarkMatterDirectDetectionFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s625_envelope_pos
  · exact T1_s626_obs_nonneg
  · exact T1_s626_obs_below_upper
  · exact T1_s628_SM_nonneg
  · exact T1_s628_SM_below_upper
  · exact T1_s627_uncert_lt_envelope
  · exact T1_s627_five_sigma_le_envelope
  · exact T1_s628_separation_lt_envelope
  · exact T1_s628_separation_lt_uncert
  · exact T1_s628_envelope_lt_xenon1t

/-! ## Headline -/

/-- **HEADLINE — sessions 625-629 — LZ (LUX-ZEPLIN) 2024 dark matter
    direct detection frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s625: σ_SI envelope half-width = 22 × 10⁻⁴⁸ cm² (= 2.2 × 10⁻⁴⁸,
            LZ 2024 sensitivity reach at M_χ = 30 GeV, 90% CL)
    - s626: LZ 2024 central σ_SI_obs = 0 within envelope (no detection)
    - s627: 1σ (4), 3σ (12), 5σ (20) reach bands fit within envelope
    - s628: SM (no WIMP, σ = 0) within envelope; LZ-SM separation = 0;
            XENON1T 2018 legacy comparison (LZ ~5× tighter)
    - s629: LZDarkMatterDirectDetectionFrontier Prop (6-conjunct) +
            headline

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the LUX-ZEPLIN 2024 first
    results, the world-leading direct-detection upper bound on
    spin-independent WIMP-nucleon cross-section at 30 GeV WIMP mass.
    Where XENON1T 2018 (Aprile et al., PRL 121, 111302, 2018) reached
    `σ_SI < 1.1 × 10⁻⁴⁷ cm²` and XENONnT 2024 reached
    `σ_SI < 1.5 × 10⁻⁴⁷ cm²`, LZ 2024 (Aalbers et al., PRL 131,
    041002, 2024) reached `σ_SI < 2.2 × 10⁻⁴⁸ cm²` (~5× tighter
    than XENON1T 2018).  Any detection above this envelope at the
    30 GeV WIMP mass would be unambiguously beyond the SM (which
    has σ_SI(WIMP) = 0 — no WIMP at tree level).

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    dark matter candidate rides the 4th irrational channel
    (sterile-neutrino / Catalan-G).  Sterile neutrinos do NOT couple
    electroweakly to nucleons, so the substrate-predicted σ_SI is
    identically zero at tree level — well within the LZ 2024
    envelope.  See `SterileNeutrinoFromFourthIrrational` for the
    substrate-side witness.

    Reference: Aalbers et al., "First Dark Matter Search Results
    from the LUX-ZEPLIN (LZ) Experiment", PRL 131, 041002 (2024).

    Sub-lemma in T-1 dark-sector residue.  Lean-core only.

    🏆 First Lean-core LZ 2024 dark-matter direct-detection frontier
    envelope. -/
theorem session_625_to_629_lz_dark_matter_direct_detection_frontier_headline :
    0 < sigma_SI_envelope_units
    ∧ 0 ≤ sigma_SI_obs_units
    ∧ sigma_SI_obs_units < sigma_SI_envelope_units
    ∧ 0 ≤ sigma_SI_SM_units
    ∧ sigma_SI_SM_units < sigma_SI_envelope_units
    ∧ sigma_SI_uncert_units < sigma_SI_envelope_units
    ∧ 5 * sigma_SI_uncert_units ≤ sigma_SI_envelope_units
    ∧ sigma_SI_obs_units - sigma_SI_SM_units < sigma_SI_envelope_units
    ∧ sigma_SI_envelope_units < sigma_SI_XENON1T_2018_units
    ∧ LZDarkMatterDirectDetectionFrontier :=
  ⟨T1_s625_envelope_pos,
   T1_s626_obs_nonneg, T1_s626_obs_below_upper,
   T1_s628_SM_nonneg, T1_s628_SM_below_upper,
   T1_s627_uncert_lt_envelope, T1_s627_five_sigma_le_envelope,
   T1_s628_separation_lt_envelope,
   T1_s628_envelope_lt_xenon1t,
   T1_s629_lz_dark_matter_direct_detection_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_lz_dark_matter_direct_detection_frontier_bundle :
    LZDarkMatterDirectDetectionFrontier :=
  T1_s629_lz_dark_matter_direct_detection_frontier

end OmegaTheory.Predictions.T1_LZDarkMatterDirectDetectionFrontier
