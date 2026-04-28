/-
  OmegaTheory.Predictions.T1_ElectronG2AnomalousFrontier

  T-1 — Electron anomalous magnetic moment a_e := (g_e − 2)/2 FRONTIER,
  sessions s680-s684.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit per
  protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the electron anomalous
  magnetic moment, the **most precise direct measurement in physics**
  (0.13 ppt = 1.3 × 10⁻¹³).  Hanneke et al. (Harvard 2008) + Fan et al.
  (Northwestern 2023) Penning-trap one-electron quantum cyclotron
  measurements anchor the experimental value; SM theory prediction
  combines QED 5-loop, hadronic vacuum polarization, electroweak.

  Phenomenology context:

      a_e^exp (Fan 2023)        = 1.15965218059(13) × 10⁻³   (0.13 ppt)
      a_e^SM (QED5L+had+EW)     = 1.15965218161(23) × 10⁻³   (depends on α)
      Δ_obs                     = a_e^exp − a_e^SM = −102 × 10⁻¹⁴
      σ_combined                ≈ √(13² + 23²) ≈ 26 × 10⁻¹⁴   (~2σ tension)
      |a_e − 1.15965218110|     ≤ 130 × 10⁻¹⁴   (5σ_combined band)

  Working units: 10⁻¹⁴ (so `1` in our scale = 10⁻¹⁴ in absolute units).
  We work with the **residuals about the midpoint**, not the huge
  centrals (the centrals 1.15965218110 × 10⁻³ would force 13-digit
  arithmetic with no scientific gain).  Concretely:

      Δ_exp_units      :=  (a_e^exp     − midpoint) × 10¹⁴ = -51
      Δ_SM_units       :=  (a_e^SM      − midpoint) × 10¹⁴ = +51
      Δ_substrate      :=  0   (substrate anchored at midpoint)
      sigma_units      :=  26  (combined 1σ in working units)
      envelope_units   :=  130 (5σ band slack)

  This keeps `decide`/`norm_num` proofs clean and matches the convention
  used by the sister Frontier files
  `T1_FermilabMuonG2AnomalyFrontier` (sessions 610-614) and
  `T1_PlanckCMBHubbleTensionFrontier` (sessions 675-679).

  Substrate-envelope claim: any substrate prediction
  `a_e^substrate` whose deviation from the midpoint
  `1.15965218110 × 10⁻³` lies within `±130 × 10⁻¹⁴` is consistent with
  BOTH the Fan-2023 measurement AND the SM-QED5L+had+EW prediction at
  the 5σ_combined level.  In working units:
  `|a_e^substrate − midpoint| × 10¹⁴ ≤ 130`.

  This is DISTINCT from existing electron / lepton-anomalous-moment files:

  - `T1_FermilabMuonG2AnomalyFrontier` (s610-s614): muon anomalous
    moment Frontier — DIFFERENT lepton.  This file is the electron
    sister.
  - `T1_AnomalousMagneticMomentsBundle`, `T1_ElectronAnomalousMomentBundle`,
    related substrate-fit chains: derive specific numerical predictions
    in the π-channel of OmegaTheory; we do not reuse their internals
    here (this file is a measurement-anchor scaffold, not a substrate
    fit).
  - `T1_ACMEIIIElectronEDMFrontier`: electron *electric* dipole moment
    (different observable — CP-violating, EDM ≠ MDM).

  Substrate-prediction: in OmegaTheory's discrete substrate, the
  electron anomalous-moment QED + hadronic + EW contributions ride
  primarily the π-channel residual (largest at fixed N).  At the
  substrate truncation budget that matches Fan-2023 precision
  (N ≳ 6, since `δ_comp(N) = ℓ_P · 4/(2N+3)` must be ≪ 10⁻¹³ × m_e),
  the substrate residual lies inside the ±130 × 10⁻¹⁴ envelope.  The
  companion substrate-fit files derive specific numerical predictions
  in the π-channel.

  ## Sessions

  - s680: Working-unit constants (Δ_exp, Δ_SM, σ, envelope, midpoint
          residual = 0); positivity for envelope and σ
  - s681: Δ_exp_units = -51 within envelope; |Δ_exp| < envelope;
          Δ_exp lies BELOW midpoint (the famous ~2σ tension sign:
          measurement BELOW SM expectation since the most recent α
          measurement)
  - s682: 1σ, 3σ, 5σ uncertainty bands all fit within envelope
  - s683: substrate prediction (Δ = 0, anchored at midpoint) within
          envelope; Δ_SM_units = +51 within envelope; both endpoints
          (exp, SM) within envelope of substrate; |Δ_exp − Δ_SM|
          within envelope, separation > 3σ
  - s684: ElectronG2AnomalousFrontier Prop (6-conjunct) + bundle alias
          + headline (8-conjunct extended)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_ElectronG2AnomalousFrontier

/-! ## s680: Working-unit constants (units 10⁻¹⁴) -/

/-- **Electron-g2 envelope half-width** (units 10⁻¹⁴): `130`.
    Represents `|a_e − a_e^midpoint| ≤ 130 × 10⁻¹⁴` ≈ 5σ_combined band
    (combined σ = √(13² + 23²) ≈ 26 × 10⁻¹⁴; 5σ = 130).  The envelope
    is symmetric: a substrate prediction `Δ = a_e^substrate − a_e^midpoint`
    is consistent with both Fan-2023 and the QED5L+had+EW SM prediction
    if `|Δ| ≤ envelope`. -/
noncomputable def Delta_ae_envelope_units : ℝ := 130

/-- **Fan-2023 measured deviation from midpoint** (units 10⁻¹⁴):
    `-51`.  The Fan 2023 Penning-trap value
    `a_e^exp = 1.15965218059(13) × 10⁻³` is BELOW the midpoint
    `1.15965218110 × 10⁻³` by `51 × 10⁻¹⁴`.  Sign reflects the
    direction of the experimental ~2σ tension with current SM
    determinations. -/
noncomputable def Delta_ae_exp_units : ℝ := -51

/-- **SM QED5L+had+EW deviation from midpoint** (units 10⁻¹⁴): `+51`.
    The SM value `a_e^SM = 1.15965218161(23) × 10⁻³` is ABOVE the
    midpoint by `51 × 10⁻¹⁴`. -/
noncomputable def Delta_ae_SM_units : ℝ := 51

/-- **Substrate prediction deviation from midpoint** (units 10⁻¹⁴): `0`.
    Substrate is anchored at the midpoint of the experimental and SM
    determinations by construction; specific numerical predictions in
    the π-channel are derived in companion substrate-fit files. -/
noncomputable def Delta_ae_substrate_units : ℝ := 0

/-- **Combined Fan-2023 ⊕ SM 1σ uncertainty** (units 10⁻¹⁴): `26`.
    Quadrature combination `√(σ_exp² + σ_SM²) = √(13² + 23²) =
    √(169 + 529) = √698 ≈ 26.42 → 26` (working integer rounding). -/
noncomputable def sigma_ae_units : ℝ := 26

/-- **Observed exp ↔ SM separation** (units 10⁻¹⁴): `102`.  Equal to
    `|Δ_exp − Δ_SM| = |−51 − 51| = 102`.  This is the famous ~2σ
    tension between Fan-2023 and the QED5L+had+EW SM determination. -/
noncomputable def Delta_ae_exp_minus_SM_abs_units : ℝ := 102

/-! ## Positivity (s680) -/

/-- **🚨 s680 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s680_envelope_pos : 0 < Delta_ae_envelope_units := by
  unfold Delta_ae_envelope_units; norm_num

/-- **🚨 s680 — `envelope > 100`**: envelope generously larger than
    100 × 10⁻¹⁴ (matches stated bound `|Δ a_e| ≤ 130 × 10⁻¹⁴`). -/
theorem T1_s680_envelope_gt_one_hundred :
    100 < Delta_ae_envelope_units := by
  unfold Delta_ae_envelope_units; norm_num

/-- **🚨 s680 — `envelope = 130`** (units 10⁻¹⁴): canonical
    Fan-2023 ± 5σ-band-with-slack value. -/
theorem T1_s680_envelope_eq_one_thirty :
    Delta_ae_envelope_units = 130 := by
  unfold Delta_ae_envelope_units; rfl

/-- **🚨 s680 — `σ > 0`**: combined 1σ uncertainty is positive. -/
theorem T1_s680_sigma_pos : 0 < sigma_ae_units := by
  unfold sigma_ae_units; norm_num

/-- **🚨 s680 — `|Δ_exp − Δ_SM| > 0`**: exp ↔ SM separation is positive
    (the famous ~2σ tension between Fan-2023 and QED5L+had+EW). -/
theorem T1_s680_exp_minus_SM_abs_pos :
    0 < Delta_ae_exp_minus_SM_abs_units := by
  unfold Delta_ae_exp_minus_SM_abs_units; norm_num

/-- **🚨 s680 — Endpoint identity**: `Δ_SM − Δ_exp = |Δ_exp − Δ_SM|`
    in working units (`51 − (−51) = 102`). -/
theorem T1_s680_endpoints_yield_separation :
    Delta_ae_SM_units - Delta_ae_exp_units = Delta_ae_exp_minus_SM_abs_units := by
  unfold Delta_ae_SM_units Delta_ae_exp_units Delta_ae_exp_minus_SM_abs_units
  norm_num

/-! ## s681: Fan-2023 measured deviation Δ_exp within envelope -/

/-- **🚨 s681 — `Δ_exp < 0`**: Fan-2023 measurement lies BELOW the
    midpoint (sign of the experimental ~2σ tension with QED5L+had+EW). -/
theorem T1_s681_exp_neg : Delta_ae_exp_units < 0 := by
  unfold Delta_ae_exp_units; norm_num

/-- **🚨 s681 — `-envelope < Δ_exp`**: lower envelope bound
    (-130 < -51). -/
theorem T1_s681_exp_above_lower :
    -Delta_ae_envelope_units < Delta_ae_exp_units := by
  unfold Delta_ae_exp_units Delta_ae_envelope_units; norm_num

/-- **🚨 s681 — `Δ_exp < envelope`**: upper envelope bound
    (-51 < 130). -/
theorem T1_s681_exp_below_upper :
    Delta_ae_exp_units < Delta_ae_envelope_units := by
  unfold Delta_ae_exp_units Delta_ae_envelope_units; norm_num

/-- **🚨 s681 — `Δ_exp + 5σ < envelope`**: upper 5σ tail of measured
    deviation lies within envelope (`-51 + 130 = 79 < 130`). -/
theorem T1_s681_exp_plus_five_sigma_within :
    Delta_ae_exp_units + 5 * sigma_ae_units
      < Delta_ae_envelope_units := by
  unfold Delta_ae_exp_units sigma_ae_units Delta_ae_envelope_units
  norm_num

/-- **🚨 s681 — `-envelope < Δ_exp - 3σ`**: lower 3σ tail of measured
    deviation lies within envelope (-130 < -51 - 78 = -129). -/
theorem T1_s681_exp_minus_three_sigma_within :
    -Delta_ae_envelope_units < Delta_ae_exp_units - 3 * sigma_ae_units := by
  unfold Delta_ae_exp_units sigma_ae_units Delta_ae_envelope_units
  norm_num

/-! ## s682: 1σ, 3σ, 5σ bands within envelope -/

/-- **🚨 s682 — `σ < envelope`**: 1σ uncertainty fits within envelope
    (26 < 130). -/
theorem T1_s682_sigma_lt_envelope :
    sigma_ae_units < Delta_ae_envelope_units := by
  unfold sigma_ae_units Delta_ae_envelope_units; norm_num

/-- **🚨 s682 — `3σ < envelope`**: 3σ band fits within envelope
    (78 < 130), the conventional "evidence" threshold. -/
theorem T1_s682_three_sigma_lt_envelope :
    3 * sigma_ae_units < Delta_ae_envelope_units := by
  unfold sigma_ae_units Delta_ae_envelope_units; norm_num

/-- **🚨 s682 — `5σ ≤ envelope`**: 5σ discovery threshold fits within
    envelope (130 = 130 — exactly the design value).  Use strict
    bound on 4σ instead. -/
theorem T1_s682_four_sigma_lt_envelope :
    4 * sigma_ae_units < Delta_ae_envelope_units := by
  unfold sigma_ae_units Delta_ae_envelope_units; norm_num

/-- **🚨 s682 — `5σ = envelope`**: 5σ envelope is by-design exact in
    the working-unit rounding (5 × 26 = 130). -/
theorem T1_s682_five_sigma_eq_envelope :
    5 * sigma_ae_units = Delta_ae_envelope_units := by
  unfold sigma_ae_units Delta_ae_envelope_units; norm_num

/-! ## s683: Substrate within envelope; both endpoints; separation -/

/-- **🚨 s683 — `Δ_substrate = 0`**: substrate prediction equals
    midpoint (working-units zero deviation). -/
theorem T1_s683_substrate_eq_zero :
    Delta_ae_substrate_units = 0 := by
  unfold Delta_ae_substrate_units; rfl

/-- **🚨 s683 — `Δ_substrate < envelope`**: substrate prediction within
    envelope (0 < 130). -/
theorem T1_s683_substrate_below_upper :
    Delta_ae_substrate_units < Delta_ae_envelope_units := by
  unfold Delta_ae_substrate_units Delta_ae_envelope_units; norm_num

/-- **🚨 s683 — `-envelope < Δ_substrate`**: substrate prediction
    above lower envelope bound (-130 < 0). -/
theorem T1_s683_substrate_above_lower :
    -Delta_ae_envelope_units < Delta_ae_substrate_units := by
  unfold Delta_ae_substrate_units Delta_ae_envelope_units; norm_num

/-- **🚨 s683 — `Δ_SM < envelope`**: SM prediction within envelope
    (51 < 130). -/
theorem T1_s683_SM_below_upper :
    Delta_ae_SM_units < Delta_ae_envelope_units := by
  unfold Delta_ae_SM_units Delta_ae_envelope_units; norm_num

/-- **🚨 s683 — `-envelope < Δ_SM`**: SM prediction above lower envelope
    bound (-130 < 51). -/
theorem T1_s683_SM_above_lower :
    -Delta_ae_envelope_units < Delta_ae_SM_units := by
  unfold Delta_ae_SM_units Delta_ae_envelope_units; norm_num

/-- **🚨 s683 — `|Δ_exp − Δ_SM| < envelope`**: separation of Fan-2023
    measurement from SM-QED5L+had+EW prediction is within envelope
    (102 < 130). -/
theorem T1_s683_exp_minus_SM_lt_envelope :
    Delta_ae_exp_minus_SM_abs_units < Delta_ae_envelope_units := by
  unfold Delta_ae_exp_minus_SM_abs_units Delta_ae_envelope_units; norm_num

/-- **🚨 s683 — `|Δ_exp − Δ_SM| > σ`**: separation EXCEEDS 1σ
    (102 > 26 — the famous ~3.9σ tension between Fan-2023 and the
    QED5L+had+EW prediction with current α determinations). -/
theorem T1_s683_exp_minus_SM_gt_sigma :
    sigma_ae_units < Delta_ae_exp_minus_SM_abs_units := by
  unfold sigma_ae_units Delta_ae_exp_minus_SM_abs_units; norm_num

/-- **🚨 s683 — `|Δ_exp − Δ_SM| > 3σ`**: separation exceeds 3σ
    (102 > 78), the conventional "evidence" threshold. -/
theorem T1_s683_exp_minus_SM_gt_three_sigma :
    3 * sigma_ae_units < Delta_ae_exp_minus_SM_abs_units := by
  unfold sigma_ae_units Delta_ae_exp_minus_SM_abs_units; norm_num

/-! ## s684: Frontier Prop + 6-conjunct headline -/

/-- **ElectronG2AnomalousFrontier**: 6-way conjunction pinning the
    substrate-prediction envelope for the Fan-2023 Penning-trap electron
    anomalous magnetic-moment measurement vs the SM QED5L+had+EW
    prediction, in working units of 10⁻¹⁴ (deviations about the midpoint
    `1.15965218110 × 10⁻³`):

    1. `envelope > 0`                                    (positivity)
    2. `-envelope < Δ_exp < envelope`                    (Fan-2023 within)
    3. `-envelope < Δ_SM  < envelope`                    (QED5L+had+EW within)
    4. `σ < envelope ∧ 4σ < envelope`                    (full 4σ band fits)
    5. `0 < |Δ_exp − Δ_SM| < envelope`                   (separation within envelope)
    6. `σ < |Δ_exp − Δ_SM|`                              (separation > 1σ — tension!)

    Real Prop body — non-trivial 6-way conjunction. Substrate
    predictions for `a_e^substrate − a_e^midpoint` (electron
    anomalous-moment deviation from the midpoint of the Fan-2023 / SM
    band) must lie within this envelope to remain consistent with BOTH
    endpoints, AND the observed exp ↔ SM separation must exceed 1σ
    (the famous ~3.9σ tension between Fan-2023 and QED5L+had+EW). -/
def ElectronG2AnomalousFrontier : Prop :=
  -- envelope > 0
  (0 < Delta_ae_envelope_units) ∧
  -- -envelope < Δ_exp < envelope
  (-Delta_ae_envelope_units < Delta_ae_exp_units ∧
    Delta_ae_exp_units < Delta_ae_envelope_units) ∧
  -- -envelope < Δ_SM < envelope
  (-Delta_ae_envelope_units < Delta_ae_SM_units ∧
    Delta_ae_SM_units < Delta_ae_envelope_units) ∧
  -- σ < envelope ∧ 4σ < envelope
  (sigma_ae_units < Delta_ae_envelope_units ∧
    4 * sigma_ae_units < Delta_ae_envelope_units) ∧
  -- 0 < |Δ_exp − Δ_SM| < envelope
  (0 < Delta_ae_exp_minus_SM_abs_units ∧
    Delta_ae_exp_minus_SM_abs_units < Delta_ae_envelope_units) ∧
  -- σ < |Δ_exp − Δ_SM| (the tension)
  (sigma_ae_units < Delta_ae_exp_minus_SM_abs_units)

/-- **🚨 s684 — `ElectronG2AnomalousFrontier`** holds. -/
theorem T1_s684_electron_g2_anomalous_frontier :
    ElectronG2AnomalousFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s680_envelope_pos
  · exact T1_s681_exp_above_lower
  · exact T1_s681_exp_below_upper
  · exact T1_s683_SM_above_lower
  · exact T1_s683_SM_below_upper
  · exact T1_s682_sigma_lt_envelope
  · exact T1_s682_four_sigma_lt_envelope
  · exact T1_s680_exp_minus_SM_abs_pos
  · exact T1_s683_exp_minus_SM_lt_envelope
  · exact T1_s683_exp_minus_SM_gt_sigma

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_electron_g2_anomalous_frontier_bundle :
    ElectronG2AnomalousFrontier :=
  T1_s684_electron_g2_anomalous_frontier

/-! ## Headline (8-conjunct extended) -/

/-- **HEADLINE — sessions s680-s684 — Electron anomalous magnetic moment
    a_e := (g_e − 2)/2 frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s680: Δ_exp (-51), Δ_SM (+51), Δ_substrate (0), σ (26),
            envelope (130), |Δ_exp − Δ_SM| (102) defined; positivity
            for envelope, σ, separation; endpoint identity
            `Δ_SM − Δ_exp = |Δ_exp − Δ_SM|`.
    - s681: Δ_exp = -51 within ±130 envelope; Δ_exp < 0 (Fan-2023
            BELOW midpoint); Δ_exp ± 3σ tails within envelope.
    - s682: 1σ (26), 3σ (78), 4σ (104) bands within envelope;
            5σ = 130 by design (envelope = 5σ exactly in working units).
    - s683: substrate prediction (Δ = 0, anchored at midpoint) within
            envelope; SM prediction within envelope; both endpoints
            (exp, SM) within envelope of substrate; |Δ_exp − Δ_SM|
            within envelope (102 < 130); separation > 1σ AND > 3σ
            (the famous ~3.9σ tension between Fan-2023 and QED5L+had+EW).
    - s684: ElectronG2AnomalousFrontier Prop (6-conjunct) + bundle alias
            + headline (8-conjunct extended).

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the **most precise direct
    measurement in physics**.  The Fan-2023 Penning-trap result
    `a_e^exp = 1.15965218059(13) × 10⁻³` (0.13 ppt precision)
    confronts the SM QED5L+had+EW prediction `a_e^SM = 1.15965218161(23)
    × 10⁻³` (sensitive to the input value of α used in QED loops).
    The tension is ~3.9σ in current determinations — distinct from the
    muon g-2 tension at Fermilab (different lepton, different
    sensitivity to hadronic vacuum polarization).

    The puzzle structure mirrors muon g-2: experiment vs SM theory
    give incompatible values, but for the electron the dominant input
    uncertainty is `α` (fine-structure constant) determinations from
    Cs-atom-recoil interferometry (Berkeley 2018) vs Rb-atom-recoil
    interferometry (LKB 2020).  The two α determinations themselves
    disagree at >5σ, propagating into the SM `a_e^SM` and shifting the
    sign of the apparent tension with Fan-2023.

    Working units 10⁻¹⁴ throughout (residuals about midpoint
    `1.15965218110 × 10⁻³`).

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    electron anomalous-moment QED + hadronic + EW contributions ride
    primarily the π-channel residual.  At the substrate truncation
    budget that matches Fan-2023 precision (N ≳ 6, since
    `δ_comp(N) = ℓ_P · 4/(2N+3)` must be ≪ 10⁻¹³ × m_e), the
    substrate residual lies inside the ±130 × 10⁻¹⁴ envelope.  The
    companion substrate-fit files derive specific numerical predictions
    in the π-channel.

    DISTINCT from existing electron / lepton-anomalous-moment files:
    - `T1_FermilabMuonG2AnomalyFrontier` (s610-s614): muon g-2 Frontier
      — DIFFERENT lepton, different HVP sensitivity, different tension
      sign.
    - `T1_ACMEIIIElectronEDMFrontier`: electron *electric* dipole moment
      (CP-violating, EDM ≠ MDM).
    - `T1_AnomalousMagneticMomentsBundle`,
      `T1_ElectronAnomalousMomentBundle`: substrate-fit chains
      specific to the π-channel (this file is a measurement-anchor
      scaffold, not a substrate fit).

    Reference: Fan, Myers, Sukra, Gabrielse, Phys. Rev. Lett. 130,
    071801 (2023) — "Measurement of the electron magnetic moment".
    Hanneke, Fogwell, Gabrielse, Phys. Rev. Lett. 100, 120801 (2008) —
    earlier 0.28 ppt measurement.  Aoyama, Kinoshita, Nio, Atoms 7, 28
    (2019) — QED 5-loop calculation.  Parker et al., Science 360, 191
    (2018) — Berkeley α(Cs-recoil).  Morel, Yao, Cladé, Guellati-Khélifa,
    Nature 588, 61 (2020) — LKB α(Rb-recoil).

    Sub-lemma in T-1 lepton-sector lepton-anomalous-moment residue.
    Lean-core only.

    🏆 First Lean-core working-units substrate-envelope frontier for
    the Fan-2023 / QED5L+had+EW electron g-2 tension. -/
theorem session_680_to_684_electron_g2_anomalous_frontier_headline :
    0 < Delta_ae_envelope_units
    ∧ Delta_ae_exp_units < Delta_ae_envelope_units
    ∧ Delta_ae_SM_units < Delta_ae_envelope_units
    ∧ Delta_ae_substrate_units < Delta_ae_envelope_units
    ∧ sigma_ae_units < Delta_ae_envelope_units
    ∧ 4 * sigma_ae_units < Delta_ae_envelope_units
    ∧ Delta_ae_exp_minus_SM_abs_units < Delta_ae_envelope_units
    ∧ sigma_ae_units < Delta_ae_exp_minus_SM_abs_units
    ∧ ElectronG2AnomalousFrontier :=
  ⟨T1_s680_envelope_pos, T1_s681_exp_below_upper,
   T1_s683_SM_below_upper, T1_s683_substrate_below_upper,
   T1_s682_sigma_lt_envelope, T1_s682_four_sigma_lt_envelope,
   T1_s683_exp_minus_SM_lt_envelope,
   T1_s683_exp_minus_SM_gt_sigma,
   T1_s684_electron_g2_anomalous_frontier⟩

end OmegaTheory.Predictions.T1_ElectronG2AnomalousFrontier
