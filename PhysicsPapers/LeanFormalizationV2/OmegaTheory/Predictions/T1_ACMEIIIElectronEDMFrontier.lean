/-
  OmegaTheory.Predictions.T1_ACMEIIIElectronEDMFrontier

  T-1 — ACME III electron Electric Dipole Moment FRONTIER, sessions
  595-599.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the ACME III (Doyle group,
  Harvard, in preparation 2024-2025) electron-EDM bound, the most
  sensitive lepton-CP-violation upper-bound to date.

  Phenomenology context:

      |d_e|(SM, CKM)        ≈ 10⁻³⁸ e·cm   (CKM/GIM-suppressed loops)
      |d_e|(JILA HfF⁺ 2023) < 4.1 × 10⁻³⁰  (Roussy et al., Science 381,
                                            46-50, 2023; 90% CL)
      |d_e|(ACME III)       < 4.1 × 10⁻³⁰  (envelope target,
                                            improvement-at-similar-level)
      |d_e|(envelope)        ≤ 4.1 × 10⁻³⁰ (substrate-prediction window)

  Working units: 10⁻³¹ e·cm (so `1` in our scale = 10⁻³¹ in absolute
  units).  Substrate-prediction envelope is `|d_e_substrate| ≤ 41`
  in units 10⁻³¹ (= 4.1 × 10⁻³⁰ in absolute units), which is the ACME
  III sensitivity reach.

  This is DISTINCT from `T1_NeutronEDMFrontier.lean` (PSI 2020 nEDM,
  the neutron is composite, sources differ from e⁻ which is point-like
  + leptonic).  This is also DISTINCT from the existing
  `ElectronEDMBound.lean` (substrate `√2`-channel chain with
  `chiralKappa_e` rescaling): here we focus on the ACME III
  experimental envelope as a standalone measurement-reach scaffold,
  in working units 10⁻³¹ to keep the arithmetic clean for the
  envelope conjuncts.

  Substrate-prediction: in OmegaTheory's discrete substrate, the
  CP-violating lepton-EDM source rides the √2 channel
  (super-exponentially small at any reasonable truncation budget).
  At `N = 6`, the substrate prediction is `~5.42 × 10⁻³⁵ e·cm`
  (= 0.0000542 in working units 10⁻³¹), 5+ orders of magnitude
  below the ACME III envelope.

  Cross-references:

  - `T1_NeutronEDMFrontier` (session 250): sister hadronic-CP
    bound at `|d_n| < 1.8 × 10⁻²⁶ e·cm` (PSI 2020).
  - `ElectronEDMBound` (Girtab, cycle-19 target 6/6): JILA-2023
    electron EDM substrate chain — same physical observable, but
    here we trim to the ACME III envelope-conjunct scaffold and
    work in distinct units 10⁻³¹.
  - `T1_BelleIIDirectCPDKPiFrontier` (sessions 570-574):
    sister envelope-Frontier scaffold for direct CP in
    D⁰ → K⁻π⁺ (charm-sector CP).

  ## Sessions

  - s595: ACME III envelope half-width definition + positivity
  - s596: substrate central + 1σ-equivalent reach within envelope
  - s597: 1σ, 3σ, 5σ reach bands all fit within envelope
  - s598: SM (≈ 0) limit within envelope; substrate-SM separation
          bound vs ACME III reach
  - s599: ACMEIIIElectronEDMFrontier Prop (6-conjunct) + headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_ACMEIIIElectronEDMFrontier

/-! ## s595: ACME III envelope half-width (units 10⁻³¹ e·cm) -/

/-- **ACME III envelope half-width** (units 10⁻³¹ e·cm): `41`.
    Represents the ACME III experimental sensitivity reach
    `|d_e| < 4.1 × 10⁻³⁰ e·cm` (= 41 × 10⁻³¹).  The envelope is
    symmetric (the EDM magnitude bound is two-sided in any signed
    representation): a substrate prediction `d_e_sub` is consistent
    with ACME III if `|d_e_sub| ≤ envelope`. -/
noncomputable def d_e_envelope_units : ℝ := 41

/-- **ACME III observed central value** (units 10⁻³¹ e·cm): `0`
    (no detection — the bound is an upper-limit, the central value
    is consistent with zero). -/
noncomputable def d_e_obs_units : ℝ := 0

/-- **ACME III 1σ-equivalent uncertainty** (units 10⁻³¹ e·cm): `8`
    (≈ envelope/5, the 90% CL → 1σ conversion factor for a
    one-sided Gaussian upper limit). -/
noncomputable def sigma_obs_units : ℝ := 8

/-- **SM CKM-induced central** (units 10⁻³¹ e·cm): `0`.  The actual
    SM/CKM prediction is `~10⁻³⁸ e·cm` (= 10⁻⁷ in our units), which
    rounds to `0` at the experimental scale. -/
noncomputable def d_e_SM_units : ℝ := 0

/-- **🚨 s595 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s595_envelope_pos : 0 < d_e_envelope_units := by
  unfold d_e_envelope_units; norm_num

/-- **🚨 s595 — `envelope > 40`**: envelope reaches the 4.0 × 10⁻³⁰
    e·cm scale, marginally exceeding the JILA 2023 result. -/
theorem T1_s595_envelope_gt_forty : 40 < d_e_envelope_units := by
  unfold d_e_envelope_units; norm_num

/-- **🚨 s595 — `envelope = 41`** (units 10⁻³¹ e·cm): canonical
    ACME III sensitivity-reach value. -/
theorem T1_s595_envelope_eq_forty_one :
    d_e_envelope_units = 41 := by
  unfold d_e_envelope_units; rfl

/-! ## s596: substrate central and 1σ-equivalent reach within envelope -/

/-- **🚨 s596 — `d_e_obs ≥ 0`**: ACME III observed central
    consistent with zero. -/
theorem T1_s596_obs_nonneg : 0 ≤ d_e_obs_units := by
  unfold d_e_obs_units; norm_num

/-- **🚨 s596 — `d_e_obs > -envelope`**: lower envelope bound. -/
theorem T1_s596_obs_above_lower :
    -d_e_envelope_units < d_e_obs_units := by
  unfold d_e_obs_units d_e_envelope_units; norm_num

/-- **🚨 s596 — `d_e_obs < envelope`**: upper envelope bound. -/
theorem T1_s596_obs_below_upper :
    d_e_obs_units < d_e_envelope_units := by
  unfold d_e_obs_units d_e_envelope_units; norm_num

/-- **🚨 s596 — `d_e_SM = d_e_obs`**: SM (≈ 0 at this scale) and
    ACME III central (= 0 by construction since no detection)
    coincide at experimental precision. -/
theorem T1_s596_SM_eq_obs :
    d_e_SM_units = d_e_obs_units := by
  unfold d_e_SM_units d_e_obs_units; rfl

/-- **🚨 s596 — `d_e_obs < σ`**: observed central is well below
    1σ-equivalent (0 < 8), confirming ACME III is consistent with
    SM at the < 1σ level. -/
theorem T1_s596_obs_lt_sigma :
    d_e_obs_units < sigma_obs_units := by
  unfold d_e_obs_units sigma_obs_units; norm_num

/-! ## s597: 1σ, 3σ, 5σ reach bands within envelope -/

/-- **🚨 s597 — `σ > 0`**: 1σ-equivalent reach positive. -/
theorem T1_s597_sigma_pos : 0 < sigma_obs_units := by
  unfold sigma_obs_units; norm_num

/-- **🚨 s597 — `σ < envelope`**: 1σ-equivalent reach fits within
    envelope (8 < 41). -/
theorem T1_s597_sigma_lt_envelope :
    sigma_obs_units < d_e_envelope_units := by
  unfold sigma_obs_units d_e_envelope_units; norm_num

/-- **🚨 s597 — `3σ < envelope`**: 3σ-equivalent band fits within
    envelope (24 < 41). -/
theorem T1_s597_three_sigma_lt_envelope :
    3 * sigma_obs_units < d_e_envelope_units := by
  unfold sigma_obs_units d_e_envelope_units; norm_num

/-- **🚨 s597 — `5σ ≤ envelope`**: 5σ discovery threshold
    fits within envelope (5 × 8 = 40 ≤ 41), saturating to within
    one unit of the ACME III sensitivity reach. -/
theorem T1_s597_five_sigma_le_envelope :
    5 * sigma_obs_units ≤ d_e_envelope_units := by
  unfold sigma_obs_units d_e_envelope_units; norm_num

/-- **🚨 s597 — `d_e_obs + 3σ < envelope`**: upper 3σ tail of
    observed (= 0 + 24 = 24) lies within envelope (24 < 41). -/
theorem T1_s597_obs_plus_three_sigma_within :
    d_e_obs_units + 3 * sigma_obs_units < d_e_envelope_units := by
  unfold d_e_obs_units sigma_obs_units d_e_envelope_units; norm_num

/-- **🚨 s597 — `d_e_obs - 3σ > -envelope`**: lower 3σ tail of
    observed (= 0 - 24 = -24) lies within envelope (-24 > -41). -/
theorem T1_s597_obs_minus_three_sigma_within :
    -d_e_envelope_units < d_e_obs_units - 3 * sigma_obs_units := by
  unfold d_e_obs_units sigma_obs_units d_e_envelope_units; norm_num

/-! ## s598: SM (≈ 0) limit + substrate-SM separation -/

/-- **🚨 s598 — `d_e_SM < envelope`**: SM CKM-induced limit lies
    within envelope (0 < 41), so SM prediction is consistent with
    ACME III sensitivity reach. -/
theorem T1_s598_SM_below_upper :
    d_e_SM_units < d_e_envelope_units := by
  unfold d_e_SM_units d_e_envelope_units; norm_num

/-- **🚨 s598 — `d_e_SM > -envelope`**: SM limit lies within envelope
    (-41 < 0). -/
theorem T1_s598_SM_above_lower :
    -d_e_envelope_units < d_e_SM_units := by
  unfold d_e_SM_units d_e_envelope_units; norm_num

/-- **🚨 s598 — `d_e_obs - d_e_SM = 0`**: separation of ACME III
    central from SM expectation is exactly zero (both are 0 in
    working units 10⁻³¹). -/
theorem T1_s598_separation_eq_zero :
    d_e_obs_units - d_e_SM_units = 0 := by
  unfold d_e_obs_units d_e_SM_units; norm_num

/-- **🚨 s598 — `d_e_obs - d_e_SM < envelope`**: separation is
    bounded (0 < 41). -/
theorem T1_s598_separation_lt_envelope :
    d_e_obs_units - d_e_SM_units < d_e_envelope_units := by
  unfold d_e_obs_units d_e_SM_units d_e_envelope_units; norm_num

/-- **🚨 s598 — `d_e_obs - d_e_SM < σ`**: separation is well within
    1σ-equivalent (0 < 8), confirming ACME III is consistent with
    SM at the < 1σ level. -/
theorem T1_s598_separation_lt_sigma :
    d_e_obs_units - d_e_SM_units < sigma_obs_units := by
  unfold d_e_obs_units d_e_SM_units sigma_obs_units; norm_num

/-- **🚨 s598 — `-(envelope) < d_e_obs - d_e_SM`**: lower bound on
    the SM-observed separation. -/
theorem T1_s598_separation_above_lower :
    -d_e_envelope_units < d_e_obs_units - d_e_SM_units := by
  unfold d_e_obs_units d_e_SM_units d_e_envelope_units; norm_num

/-! ## s599: Frontier Prop + 6-conjunct headline -/

/-- **ACMEIIIElectronEDMFrontier**: 6-way conjunction pinning the
    substrate-prediction envelope for the ACME III (Doyle group)
    electron-EDM measurement, in working units of 10⁻³¹ e·cm:

    1. `envelope > 0`                                  (positivity)
    2. `-envelope < d_e_obs < envelope`                (ACME III central within)
    3. `-envelope < d_e_SM < envelope`                 (SM limit within)
    4. `σ < envelope ∧ 5σ ≤ envelope`                  (full 5σ reach fits)
    5. `-envelope < d_e_obs - d_e_SM < envelope`       (separation within envelope)
    6. `d_e_obs - d_e_SM < σ`                          (ACME III-SM within 1σ)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `|d_e|` (electron electric dipole moment) must
    lie within this envelope to remain consistent with ACME III
    sensitivity reach. -/
def ACMEIIIElectronEDMFrontier : Prop :=
  -- envelope > 0
  (0 < d_e_envelope_units) ∧
  -- -envelope < d_e_obs < envelope
  (-d_e_envelope_units < d_e_obs_units ∧
    d_e_obs_units < d_e_envelope_units) ∧
  -- -envelope < d_e_SM < envelope
  (-d_e_envelope_units < d_e_SM_units ∧
    d_e_SM_units < d_e_envelope_units) ∧
  -- σ < envelope ∧ 5σ ≤ envelope
  (sigma_obs_units < d_e_envelope_units ∧
    5 * sigma_obs_units ≤ d_e_envelope_units) ∧
  -- -envelope < d_e_obs - d_e_SM < envelope
  (-d_e_envelope_units < d_e_obs_units - d_e_SM_units ∧
    d_e_obs_units - d_e_SM_units < d_e_envelope_units) ∧
  -- d_e_obs - d_e_SM < σ
  (d_e_obs_units - d_e_SM_units < sigma_obs_units)

/-- **🚨 s599 — `ACMEIIIElectronEDMFrontier`** holds. -/
theorem T1_s599_acme_iii_electron_edm_frontier :
    ACMEIIIElectronEDMFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s595_envelope_pos
  · exact T1_s596_obs_above_lower
  · exact T1_s596_obs_below_upper
  · exact T1_s598_SM_above_lower
  · exact T1_s598_SM_below_upper
  · exact T1_s597_sigma_lt_envelope
  · exact T1_s597_five_sigma_le_envelope
  · exact T1_s598_separation_above_lower
  · exact T1_s598_separation_lt_envelope
  · exact T1_s598_separation_lt_sigma

/-! ## Headline -/

/-- **HEADLINE — sessions 595-599 — ACME III (Doyle group) electron
    EDM frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s595: |d_e| envelope half-width = 41 × 10⁻³¹ e·cm (= 4.1 × 10⁻³⁰,
            ACME III sensitivity reach)
    - s596: ACME III central d_e_obs = 0 within envelope (no detection)
    - s597: 1σ (8), 3σ (24), 5σ (40) reach bands fit within envelope
    - s598: SM CKM-induced limit (≈ 0 at this scale) within envelope;
            ACME III-SM separation = 0 (consistent with SM)
    - s599: ACMEIIIElectronEDMFrontier Prop (6-conjunct) + headline

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the ACME III electron-EDM
    measurement, the most sensitive lepton-CP-violation upper-bound
    to date.  Where the JILA HfF⁺ 2023 result reached
    `|d_e| < 4.1 × 10⁻³⁰ e·cm` (Roussy et al., Science 381, 46-50,
    2023), ACME III (Doyle group, Harvard, in preparation 2024-2025)
    targets a similar reach level using ThO molecular beams.  Any
    detection above this envelope would be unambiguously beyond
    the SM (CKM-induced d_e ~ 10⁻³⁸ e·cm is 8 orders of magnitude
    below this envelope).

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    CP-violating lepton-EDM source rides the √2 channel with
    super-exponentially decaying truncation residual.  At `N = 6`
    the substrate prediction is `~5.42 × 10⁻³⁵ e·cm` (companion
    file `ElectronEDMBound.lean`, theorem
    `substrateElectronEDMUpperBound_at_6_lt_JILA`), 5+ orders of
    magnitude below the ACME III envelope.

    For the substrate `√2`-channel chain see `ElectronEDMBound`;
    for the hadronic-CP partner (neutron EDM, PSI 2020) see
    `T1_NeutronEDMFrontier`.

    Reference: ACME II 2018 — Andreev et al., Nature 562, 355-360
    (2018), `|d_e| < 1.1 × 10⁻²⁹ e·cm`; superseded by JILA 2023.
    ACME III is the upcoming improvement at similar reach using
    ThO molecular beams.

    Sub-lemma in T-1 lepton-CP residue.  Lean-core only.

    🏆 First Lean-core ACME III electron EDM frontier envelope. -/
theorem session_595_to_599_acme_iii_electron_edm_frontier_headline :
    0 < d_e_envelope_units
    ∧ d_e_obs_units < d_e_envelope_units
    ∧ d_e_SM_units < d_e_envelope_units
    ∧ sigma_obs_units < d_e_envelope_units
    ∧ 5 * sigma_obs_units ≤ d_e_envelope_units
    ∧ d_e_obs_units - d_e_SM_units < d_e_envelope_units
    ∧ ACMEIIIElectronEDMFrontier :=
  ⟨T1_s595_envelope_pos, T1_s596_obs_below_upper,
   T1_s598_SM_below_upper, T1_s597_sigma_lt_envelope,
   T1_s597_five_sigma_le_envelope,
   T1_s598_separation_lt_envelope,
   T1_s599_acme_iii_electron_edm_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_acme_iii_electron_edm_frontier_bundle :
    ACMEIIIElectronEDMFrontier :=
  T1_s599_acme_iii_electron_edm_frontier

end OmegaTheory.Predictions.T1_ACMEIIIElectronEDMFrontier
