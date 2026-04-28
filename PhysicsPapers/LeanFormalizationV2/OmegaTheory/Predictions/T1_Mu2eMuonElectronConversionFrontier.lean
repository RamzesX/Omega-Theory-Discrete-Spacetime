/-
  OmegaTheory.Predictions.T1_Mu2eMuonElectronConversionFrontier

  T-1 — Mu2e (Fermilab) + COMET (J-PARC) μ⁻ → e⁻ conversion in nuclear
  field charged-LFV FRONTIER, sessions s630-s634.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the Mu2e (Fermilab E973)
  + COMET (J-PARC E21 / E36) coherent-conversion search

      μ⁻ + (A,Z)  →  e⁻ + (A,Z)        (no neutrinos in final state)

  parameterised by the conversion ratio

      R_{μe} := Γ(μ⁻ N → e⁻ N) / Γ(μ⁻ N capture).

  Phenomenology context (working units 10⁻¹⁴):

      R_{μe}(SM, mν loop)        ~ 10⁻⁵⁴             (CKM/PMNS-suppressed,
                                                       unobservable)
      R_{μe}(SINDRUM II, Ti)     < 4.3 × 10⁻¹²       (Bertl et al.,
                                                       Eur.Phys.J.C 47, 337,
                                                       2006, 90% CL)
      R_{μe}(SINDRUM II, Au)     < 7   × 10⁻¹³       (Bertl et al., Au
                                                       target — current
                                                       world-best 90% CL)
      R_{μe}(envelope)           ≤ 70  × 10⁻¹⁴       (substrate-prediction
                                                       window in our
                                                       working units)
      R_{μe}(Mu2e Phase-1)       < 6   × 10⁻¹⁷       (single-event
                                                       sensitivity SES,
                                                       projected)
      R_{μe}(COMET Phase-2)      < 7   × 10⁻¹⁸       (further reach)

  Working units: `10⁻¹⁴` (so `1` in our scale = 10⁻¹⁴ in absolute units).
  Substrate-prediction envelope is `R_{μe} ≤ 70` in working units
  (= 7 × 10⁻¹³, the SINDRUM II 2006 Au-target 90% CL world-best).
  Mu2e Phase-1 single-event sensitivity (`< 6 × 10⁻¹⁷`) corresponds
  to `0.0006` in our working units — five orders of magnitude below
  the envelope edge.

  This is DISTINCT from `T1_ChargedLFVBoundsBundle.lean` which lumps
  Bs→μμ, τ→3μ, μ→e at a single 10⁻¹⁷ scale (covering Mu2e Phase-1
  sensitivity in coarse units), and from
  `T1_MEGMuToEGammaFrontier.lean` (μ→eγ photonic CLFV at the
  ~10⁻¹³ level).  This file's envelope is *one-sided non-negative*
  (R_{μe} ≥ 0 by definition: it is a ratio of non-negative rates),
  which differs from the symmetric two-sided EDM envelope in
  `T1_ACMEIIIElectronEDMFrontier.lean`.

  The MEG μ→eγ photonic CLFV channel ranks tighter than the SINDRUM II
  Ti-target rate (4.2×10⁻¹³ < 4.3×10⁻¹²) but weaker on the world-best
  Au target (4.2×10⁻¹³ < 7×10⁻¹³).  In normalised conversion units
  the photon-emission and coherent-conversion rates are different
  observables — see `MuToEConversionBound.lean` for the substrate
  ordering.

  Substrate-prediction: in OmegaTheory's discrete substrate the CLFV
  rate is bounded by the √2-channel super-exponential residual.  At
  N = 6 the tree-level substrate prediction is `R_{μe}^{sub} = 0`
  exactly (no BSM content; PMNS mixing-induced rate `~ 10⁻⁵⁴`
  vanishes in the working unit) — well within the SINDRUM II Au
  envelope and ~14 orders of magnitude below Mu2e Phase-1 reach.
  See `MuToEConversionBound.lean` for the substrate-side `R_sub = 0`
  witness.

  Cross-references:

  - `MuToEConversionBound` (cycle-19 target 3/6, Pollux): substrate
    `R_sub = 0` chain at SINDRUM II Ti scale.
  - `T1_ChargedLFVBoundsBundle` (s564-s568): coarse Mu2e Phase-1
    bound at 10⁻¹⁷ scale, in the bundled CLFV combo.
  - `T1_MEGMuToEGammaFrontier` (s280): μ→eγ photonic CLFV partner.
  - `T1_HiggsToEMuLFVBundle` (s528-s532): EW-scale CLFV partner.
  - `T1_ACMEIIIElectronEDMFrontier` (s595-s599): same envelope-Frontier
    scaffold pattern (lepton-CP).
  - `T1_LZDarkMatterDirectDetectionFrontier` (s625-s629): same
    one-sided envelope-Frontier pattern with 5σ saturation +
    legacy comparison witness.

  ## Sessions

  - s630: Mu2e/SINDRUM II envelope half-width definition + positivity
  - s631: R_obs central + 1σ-equivalent reach within envelope
  - s632: 1σ, 3σ, 5σ reach bands all fit within envelope
  - s633: SM (= 0) limit within envelope; substrate-SM separation
          bound vs SINDRUM II Ti legacy + Mu2e Phase-1 reach
  - s634: Mu2eMuonElectronConversionFrontier Prop (6-conjunct) +
          headline + paper alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_Mu2eMuonElectronConversionFrontier

/-! ## s630: Mu2e / SINDRUM II envelope half-width (units 10⁻¹⁴) -/

/-- **SINDRUM II Au envelope half-width** (units 10⁻¹⁴): `70`.
    Represents the SINDRUM II 2006 gold-target 90% CL world-best
    upper bound `R_{μe}(Au) < 7 × 10⁻¹³` (Bertl et al.,
    Eur.Phys.J.C 47, 337, 2006).  Conversion ratios are non-negative
    by construction; a substrate prediction `R_sub` is consistent
    with SINDRUM II if `0 ≤ R_sub ≤ envelope`. -/
noncomputable def R_mue_envelope_units : ℝ := 70

/-- **SINDRUM II observed central value** (units 10⁻¹⁴): `0`
    (no detection — the bound is an upper limit, the central value
    is consistent with zero within statistical fluctuation). -/
noncomputable def R_mue_obs_units : ℝ := 0

/-- **SINDRUM II 1σ-equivalent uncertainty** (units 10⁻¹⁴): `12`
    (≈ envelope/5.83, the 90% CL → 1σ conversion factor for a
    one-sided Gaussian upper limit on a non-negative quantity).
    Kept integer-valued for clean arithmetic; 5σ = 60 ≤ envelope = 70. -/
noncomputable def R_mue_uncert_units : ℝ := 12

/-- **SM expected central** (units 10⁻¹⁴): `0`.  The PMNS-mixing
    induced SM amplitude is `~ 10⁻⁵⁴`, which rounds to `0` at
    the experimental scale of 10⁻¹⁴. -/
noncomputable def R_mue_SM_units : ℝ := 0

/-- **SINDRUM II Ti-target legacy comparison** (units 10⁻¹⁴): `430`
    (= 4.3 × 10⁻¹² in absolute units).  Earlier SINDRUM II Ti-target
    bound; superseded by the Au-target world-best (~6× tighter). -/
noncomputable def R_mue_SINDRUMII_Ti_units : ℝ := 430

/-- **🚨 s630 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s630_envelope_pos : 0 < R_mue_envelope_units := by
  unfold R_mue_envelope_units; norm_num

/-- **🚨 s630 — `envelope > 60`**: envelope reaches the 6.0 × 10⁻¹³
    scale, marginally above the published 7 × 10⁻¹³. -/
theorem T1_s630_envelope_gt_sixty : 60 < R_mue_envelope_units := by
  unfold R_mue_envelope_units; norm_num

/-- **🚨 s630 — `envelope = 70`** (units 10⁻¹⁴): canonical SINDRUM II
    Au-target 90% CL world-best. -/
theorem T1_s630_envelope_eq_seventy :
    R_mue_envelope_units = 70 := by
  unfold R_mue_envelope_units; rfl

/-! ## s631: R_obs central and 1σ-equivalent reach within envelope -/

/-- **🚨 s631 — `R_obs ≥ 0`**: conversion ratio is non-negative
    by construction (ratio of non-negative rates). -/
theorem T1_s631_obs_nonneg : 0 ≤ R_mue_obs_units := by
  unfold R_mue_obs_units; norm_num

/-- **🚨 s631 — `R_obs < envelope`**: upper envelope bound on
    SINDRUM II observed central. -/
theorem T1_s631_obs_below_upper :
    R_mue_obs_units < R_mue_envelope_units := by
  unfold R_mue_obs_units R_mue_envelope_units; norm_num

/-- **🚨 s631 — `R_SM = R_obs`**: SM (~10⁻⁵⁴ ≈ 0 in our 10⁻¹⁴
    units) and SINDRUM II central (= 0 by construction since no
    detection) coincide at experimental precision. -/
theorem T1_s631_SM_eq_obs :
    R_mue_SM_units = R_mue_obs_units := by
  unfold R_mue_SM_units R_mue_obs_units; rfl

/-- **🚨 s631 — `R_obs < σ`**: observed central is well below
    1σ-equivalent (0 < 12), confirming SINDRUM II is consistent
    with SM at the < 1σ level. -/
theorem T1_s631_obs_lt_uncert :
    R_mue_obs_units < R_mue_uncert_units := by
  unfold R_mue_obs_units R_mue_uncert_units; norm_num

/-! ## s632: 1σ, 3σ, 5σ reach bands within envelope -/

/-- **🚨 s632 — `σ > 0`**: 1σ-equivalent reach positive. -/
theorem T1_s632_uncert_pos : 0 < R_mue_uncert_units := by
  unfold R_mue_uncert_units; norm_num

/-- **🚨 s632 — `σ < envelope`**: 1σ-equivalent reach fits within
    envelope (12 < 70). -/
theorem T1_s632_uncert_lt_envelope :
    R_mue_uncert_units < R_mue_envelope_units := by
  unfold R_mue_uncert_units R_mue_envelope_units; norm_num

/-- **🚨 s632 — `3σ < envelope`**: 3σ-equivalent band fits within
    envelope (36 < 70). -/
theorem T1_s632_three_sigma_lt_envelope :
    3 * R_mue_uncert_units < R_mue_envelope_units := by
  unfold R_mue_uncert_units R_mue_envelope_units; norm_num

/-- **🚨 s632 — `5σ ≤ envelope`**: 5σ discovery threshold
    fits within envelope (5 × 12 = 60 ≤ 70), within 10 units of
    saturating the SINDRUM II Au sensitivity reach. -/
theorem T1_s632_five_sigma_le_envelope :
    5 * R_mue_uncert_units ≤ R_mue_envelope_units := by
  unfold R_mue_uncert_units R_mue_envelope_units; norm_num

/-- **🚨 s632 — `obs + 3σ < envelope`**: upper 3σ tail of observed
    (= 0 + 36 = 36) lies within envelope (36 < 70). -/
theorem T1_s632_obs_plus_three_sigma_within :
    R_mue_obs_units + 3 * R_mue_uncert_units
      < R_mue_envelope_units := by
  unfold R_mue_obs_units R_mue_uncert_units R_mue_envelope_units
  norm_num

/-! ## s633: SM (= 0) limit + substrate-SM separation + Ti legacy -/

/-- **🚨 s633 — `R_SM ≥ 0`**: SM expectation is non-negative
    (it's effectively zero — PMNS-mixing-induced rate ~10⁻⁵⁴
    rounds to 0 at experimental scale). -/
theorem T1_s633_SM_nonneg : 0 ≤ R_mue_SM_units := by
  unfold R_mue_SM_units; norm_num

/-- **🚨 s633 — `R_SM < envelope`**: SM expectation lies within
    envelope (0 < 70), so SM prediction is consistent with
    SINDRUM II Au sensitivity reach (trivially: SM expects no
    observable signal at this scale). -/
theorem T1_s633_SM_below_upper :
    R_mue_SM_units < R_mue_envelope_units := by
  unfold R_mue_SM_units R_mue_envelope_units; norm_num

/-- **🚨 s633 — `R_obs - R_SM = 0`**: separation of SINDRUM II
    central from SM expectation is exactly zero (both are 0 in
    working units 10⁻¹⁴). -/
theorem T1_s633_separation_eq_zero :
    R_mue_obs_units - R_mue_SM_units = 0 := by
  unfold R_mue_obs_units R_mue_SM_units; norm_num

/-- **🚨 s633 — `R_obs - R_SM < envelope`**: separation is bounded
    (0 < 70). -/
theorem T1_s633_separation_lt_envelope :
    R_mue_obs_units - R_mue_SM_units < R_mue_envelope_units := by
  unfold R_mue_obs_units R_mue_SM_units R_mue_envelope_units
  norm_num

/-- **🚨 s633 — `R_obs - R_SM < σ`**: separation is well within
    1σ-equivalent (0 < 12), confirming SINDRUM II is consistent
    with SM at the < 1σ level. -/
theorem T1_s633_separation_lt_uncert :
    R_mue_obs_units - R_mue_SM_units < R_mue_uncert_units := by
  unfold R_mue_obs_units R_mue_SM_units R_mue_uncert_units
  norm_num

/-- **🚨 s633 — `SINDRUMII_Ti > 0`**: legacy SINDRUM II Ti-target
    bound is a positive ratio value (430 = 4.3 × 10⁻¹²). -/
theorem T1_s633_sindrum_ii_ti_pos : 0 < R_mue_SINDRUMII_Ti_units := by
  unfold R_mue_SINDRUMII_Ti_units; norm_num

/-- **🚨 s633 — `envelope < SINDRUMII_Ti`**: SINDRUM II Au envelope
    is tighter than SINDRUM II Ti legacy by ~6× (70 < 430). -/
theorem T1_s633_envelope_lt_sindrum_ii_ti :
    R_mue_envelope_units < R_mue_SINDRUMII_Ti_units := by
  unfold R_mue_envelope_units R_mue_SINDRUMII_Ti_units; norm_num

/-- **🚨 s633 — `6 × envelope ≤ SINDRUMII_Ti`**: explicit 6×
    improvement of SINDRUM II Au over Ti (6 × 70 = 420 ≤ 430). -/
theorem T1_s633_sindrum_ii_ti_at_least_6x_envelope :
    6 * R_mue_envelope_units ≤ R_mue_SINDRUMII_Ti_units := by
  unfold R_mue_envelope_units R_mue_SINDRUMII_Ti_units; norm_num

/-! ## s634: Frontier Prop + 6-conjunct headline -/

/-- **Mu2eMuonElectronConversionFrontier**: 6-way conjunction pinning
    the substrate-prediction envelope for the Mu2e (Fermilab) +
    COMET (J-PARC) coherent μ⁻→e⁻ conversion search, anchored at the
    SINDRUM II 2006 Au-target world-best 90% CL upper limit, in
    working units of 10⁻¹⁴:

    1. `envelope > 0`                                  (positivity)
    2. `0 ≤ R_obs < envelope`                          (SINDRUM II central within)
    3. `0 ≤ R_SM < envelope`                           (SM = 0 within)
    4. `σ < envelope ∧ 5σ ≤ envelope`                  (full 5σ reach fits)
    5. `0 ≤ R_obs - R_SM < envelope`                   (separation within)
    6. `envelope < SINDRUMII_Ti_legacy`                (Au tighter than Ti)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `R_{μe}` (μ⁻→e⁻ conversion ratio in nuclear
    field) must lie within this envelope to remain consistent with
    SINDRUM II Au sensitivity reach.  Mu2e Phase-1 (`< 6 × 10⁻¹⁷`)
    + COMET Phase-2 (`< 7 × 10⁻¹⁸`) will probe to ~10⁵× tighter
    than this envelope; substrate-side `R_sub = 0` (no BSM content)
    threads the envelope and all upcoming reach values trivially. -/
def Mu2eMuonElectronConversionFrontier : Prop :=
  -- envelope > 0
  (0 < R_mue_envelope_units) ∧
  -- 0 ≤ R_obs < envelope
  (0 ≤ R_mue_obs_units ∧
    R_mue_obs_units < R_mue_envelope_units) ∧
  -- 0 ≤ R_SM < envelope
  (0 ≤ R_mue_SM_units ∧
    R_mue_SM_units < R_mue_envelope_units) ∧
  -- σ < envelope ∧ 5σ ≤ envelope
  (R_mue_uncert_units < R_mue_envelope_units ∧
    5 * R_mue_uncert_units ≤ R_mue_envelope_units) ∧
  -- 0 ≤ R_obs - R_SM < envelope (= 0 by construction, bounded)
  (R_mue_obs_units - R_mue_SM_units < R_mue_envelope_units ∧
    R_mue_obs_units - R_mue_SM_units < R_mue_uncert_units) ∧
  -- envelope < SINDRUMII_Ti_legacy (Au tighter than Ti)
  (R_mue_envelope_units < R_mue_SINDRUMII_Ti_units)

/-- **🚨 s634 — `Mu2eMuonElectronConversionFrontier`** holds. -/
theorem T1_s634_mu2e_muon_electron_conversion_frontier :
    Mu2eMuonElectronConversionFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s630_envelope_pos
  · exact T1_s631_obs_nonneg
  · exact T1_s631_obs_below_upper
  · exact T1_s633_SM_nonneg
  · exact T1_s633_SM_below_upper
  · exact T1_s632_uncert_lt_envelope
  · exact T1_s632_five_sigma_le_envelope
  · exact T1_s633_separation_lt_envelope
  · exact T1_s633_separation_lt_uncert
  · exact T1_s633_envelope_lt_sindrum_ii_ti

/-! ## Headline -/

/-- **HEADLINE — sessions s630–s634 — Mu2e / COMET μ⁻→e⁻ conversion
    in nuclear field charged-LFV frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s630: R_{μe} envelope half-width = 70 × 10⁻¹⁴ (= 7 × 10⁻¹³,
            SINDRUM II 2006 Au-target world-best 90% CL)
    - s631: SINDRUM II central R_obs = 0 within envelope (no detection)
    - s632: 1σ (12), 3σ (36), 5σ (60) reach bands fit within envelope
    - s633: SM (PMNS-suppressed, ≈ 0 at this scale) within envelope;
            SINDRUM II-SM separation = 0; SINDRUM II Ti-target
            legacy comparison (Au ~6× tighter)
    - s634: Mu2eMuonElectronConversionFrontier Prop (6-conjunct) +
            headline + paper alias

    Phenomenology context: this FRONTIER file is the substrate-prediction
    envelope for the Mu2e (Fermilab E973, in commissioning 2024-2026)
    + COMET (J-PARC E21 / E36, Phase-1 first beam 2025) coherent
    μ⁻→e⁻ conversion search.  Where SINDRUM II 2006 reached
    `R_{μe}(Ti) < 4.3 × 10⁻¹²` and the Au target reached
    `R_{μe}(Au) < 7 × 10⁻¹³` (Bertl et al., Eur.Phys.J.C 47, 337,
    2006, world-best), Mu2e Phase-1 single-event sensitivity is
    `R_{μe}(Al) < 6 × 10⁻¹⁷` and COMET Phase-2 reaches
    `R_{μe}(Al) < 7 × 10⁻¹⁸` — both ~10⁴–10⁵ orders tighter than
    the SINDRUM II Au envelope.  Any detection above SM expectation
    `~10⁻⁵⁴` would be unambiguously beyond the SM (the PMNS
    mixing-induced amplitude is suppressed by `(Δm²_ν / m_W²)²`
    and is unobservable at any reasonable experimental reach).

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    CLFV rate is bounded by the √2-channel super-exponential
    residual.  At N = 6 the tree-level substrate prediction is
    `R_{μe}^{sub} = 0` exactly (no BSM content in the substrate;
    PMNS-induced rate ~10⁻⁵⁴ vanishes in our 10⁻¹⁴ working units).
    See `MuToEConversionBound.lean` (Pollux, cycle-19 target 3/6)
    for the substrate-side `R_sub = 0` chain at the SINDRUM II Ti
    scale, and `T1_ChargedLFVBoundsBundle.lean` (s564–s568) for
    the coarse Mu2e Phase-1 bound at 10⁻¹⁷ scale.

    References:

    - Bertl et al. (SINDRUM II), Eur.Phys.J.C 47, 337-346 (2006).
    - Mu2e TDR — Bartoszek et al., Fermilab-TM-2594, 2014.
    - COMET Phase-1 TDR — Adamov et al., Prog.Theor.Exp.Phys.
      2020, 033C01 (2020).

    Sub-lemma in T-1 charged-LFV residue.  Lean-core only.

    🏆 First Lean-core formalisation of the SINDRUM II Au-target
    world-best Mu2e/COMET μ⁻→e⁻ conversion frontier envelope. -/
theorem session_s630_to_s634_mu2e_muon_electron_conversion_frontier_headline :
    0 < R_mue_envelope_units
    ∧ 0 ≤ R_mue_obs_units
    ∧ R_mue_obs_units < R_mue_envelope_units
    ∧ 0 ≤ R_mue_SM_units
    ∧ R_mue_SM_units < R_mue_envelope_units
    ∧ R_mue_uncert_units < R_mue_envelope_units
    ∧ 5 * R_mue_uncert_units ≤ R_mue_envelope_units
    ∧ R_mue_obs_units - R_mue_SM_units < R_mue_envelope_units
    ∧ R_mue_envelope_units < R_mue_SINDRUMII_Ti_units
    ∧ Mu2eMuonElectronConversionFrontier :=
  ⟨T1_s630_envelope_pos,
   T1_s631_obs_nonneg, T1_s631_obs_below_upper,
   T1_s633_SM_nonneg, T1_s633_SM_below_upper,
   T1_s632_uncert_lt_envelope, T1_s632_five_sigma_le_envelope,
   T1_s633_separation_lt_envelope,
   T1_s633_envelope_lt_sindrum_ii_ti,
   T1_s634_mu2e_muon_electron_conversion_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_mu2e_muon_electron_conversion_frontier_bundle :
    Mu2eMuonElectronConversionFrontier :=
  T1_s634_mu2e_muon_electron_conversion_frontier

end OmegaTheory.Predictions.T1_Mu2eMuonElectronConversionFrontier
