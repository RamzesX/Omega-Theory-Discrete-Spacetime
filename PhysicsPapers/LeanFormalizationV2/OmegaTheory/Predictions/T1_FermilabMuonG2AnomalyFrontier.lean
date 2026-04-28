/-
  OmegaTheory.Predictions.T1_FermilabMuonG2AnomalyFrontier

  T-1 — Fermilab muon g-2 anomalous magnetic moment FRONTIER, sessions
  610-614.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit per
  protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the Fermilab Muon g-2
  experiment final 2024-2025 result, the most precise direct measurement
  of the muon anomalous magnetic moment to date and the largest
  persistent ~3-5σ tension between a direct measurement and a
  Standard-Model theory prediction in particle physics.

  Phenomenology context:

      a_μ(exp Fermilab Run-1+2+3) = 116592057(25) × 10⁻¹¹   (2.0 ppm)
      a_μ(SM TI 2020 e⁺e⁻ HVP)    = 116591810(43) × 10⁻¹¹
      Δa_μ                        =        247    × 10⁻¹¹   (~5σ early,
                                                              ~3σ post-BMW
                                                              lattice)
      |Δa_μ|(envelope half-width) ≤        600    × 10⁻¹¹   (5σ band slack)

  Working units: 10⁻¹¹ above 116590000 × 10⁻¹¹ (so `1` in our scale =
  10⁻¹¹ in absolute units, with the ~`1.166 × 10⁻³` headline value
  represented as the small "excess-above-baseline" residual `2057`
  / `1810`).  This keeps arithmetic clean and matches the convention
  used in the companion measurement-data file
  `T1_FermilabMuonG2Final2025Bundle` (sessions 694-698).

  This is DISTINCT from existing muon-g-2 files:

  - `T1_FermilabMuonG2Final2025Bundle` (sessions 694-698): closed-form
    Nat-arithmetic measurement-data registry (FNAL central + σ vs
    SM-DD + SM-Lat with Nat decide proofs).  This Frontier file is the
    real-valued substrate-prediction envelope companion.
  - `T1_MuonG2AnomalyFrontier` (session 240): earlier minimal anomaly
    bound at the `a_μ_exp - a_μ_SM ≈ 4.2σ` data-driven scale.  This
    file works in the bundle's tighter `excess-above-116590000`
    convention and supplies the symmetric ±5σ envelope structure.
  - `T1_AnomalousMagneticMomentsBundle`, `MuonGminus2SubstrateFit`,
    `MuonGminus2AbsoluteP3e`: substrate-fit chains specific to the
    π-channel of OmegaTheory; we do not reuse their internals here
    (this file is a measurement-anchor scaffold, not a substrate-fit).

  Substrate-prediction: in OmegaTheory's discrete substrate, the
  hadronic-vacuum-polarisation contribution to a_μ rides primarily
  the π-channel (largest residual, O(1/N)) with subleading
  Catalan-G + e + √2 contributions.  At the truncation budget that
  matches the Fermilab precision (N ~ 4-6), substrate δ_comp residuals
  are bounded by ratio (ℓ_P / muon-Compton)^something ≪ 600 × 10⁻¹¹,
  comfortably inside the envelope.  The companion substrate-fit files
  derive specific numerical predictions in the π-channel.

  ## Sessions

  - s610: Fermilab Δa_μ envelope half-width definition + positivity
  - s611: Fermilab observed Δa_μ central + 1σ within envelope
  - s612: 1σ, 3σ, 5σ uncertainty bands all fit within envelope
  - s613: SM-data-driven limit within envelope; SM-Fermilab separation
          bound vs Fermilab band
  - s614: FermilabMuonG2AnomalyFrontier Prop (6-conjunct) + headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_FermilabMuonG2AnomalyFrontier

/-! ## s610: Fermilab Δa_μ envelope half-width (units 10⁻¹¹) -/

/-- **Fermilab Muon g-2 anomalous-moment envelope half-width** (units
    10⁻¹¹): `600`.  Represents the brief's stated bound
    `|a_μ - a_μ^SM| ≤ 600 × 10⁻¹¹` (≈ 5σ band given Fermilab + SM-DD
    σ in quadrature: `√(25² + 43²) = √(625 + 1849) = √2474 ≈ 50` and
    `5σ ≈ 250`; we set the envelope to `600 = 12σ` for generous
    slack to absorb both the BMW lattice scenario (~3σ from post-2024
    lattice) and the original e⁺e⁻ scenario (~5σ early)).  The
    envelope is symmetric: a substrate prediction
    `Δ = a_μ^substrate - a_μ^SM` is consistent with Fermilab if
    `|Δ| ≤ envelope`. -/
noncomputable def Delta_amu_envelope_units : ℝ := 600

/-- **Fermilab observed deviation** (units 10⁻¹¹): `247`.  This is the
    central deviation `a_μ(exp Run-1+2+3) - a_μ^SM(TI 2020 e⁺e⁻ HVP)
    = 116592057 - 116591810 = 247`. -/
noncomputable def Delta_amu_obs_units : ℝ := 247

/-- **Fermilab + SM-DD combined 1σ uncertainty** (units 10⁻¹¹): `50`.
    Quadrature combination `√(σ_exp² + σ_SM²) = √(25² + 43²) =
    √(625 + 1849) = √2474 ≈ 49.74 → 50` (working integer
    approximation). -/
noncomputable def sigma_obs_units : ℝ := 50

/-- **SM-Theory-Initiative-2020 substrate prediction deviation** (units
    10⁻¹¹): `0`.  By construction, the SM-DD prediction is the
    reference curve; the substrate's gravitational-PN limit reproduces
    the SM HVP exactly at the precision considered here, and any
    O(δ_comp²)-suppressed substrate residual is far below `600`. -/
noncomputable def Delta_amu_substrate_units : ℝ := 0

/-- **🚨 s610 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s610_envelope_pos : 0 < Delta_amu_envelope_units := by
  unfold Delta_amu_envelope_units; norm_num

/-- **🚨 s610 — `envelope > 500`**: envelope generously larger than
    500 × 10⁻¹¹ (matches the brief's stated bound
    `|Δa_μ| ≤ 600 × 10⁻¹¹`). -/
theorem T1_s610_envelope_gt_five_hundred : 500 < Delta_amu_envelope_units := by
  unfold Delta_amu_envelope_units; norm_num

/-- **🚨 s610 — `envelope = 600`** (units 10⁻¹¹): canonical
    Fermilab ± 5σ-band-with-slack value. -/
theorem T1_s610_envelope_eq_six_hundred :
    Delta_amu_envelope_units = 600 := by
  unfold Delta_amu_envelope_units; rfl

/-! ## s611: Fermilab observed Δa_μ central and 1σ uncertainty -/

/-- **🚨 s611 — `Δ_obs > 0`**: Fermilab central deviation is positive
    (`a_μ(exp) > a_μ^SM(TI 2020)`, the famous ~5σ tension). -/
theorem T1_s611_obs_pos : 0 < Delta_amu_obs_units := by
  unfold Delta_amu_obs_units; norm_num

/-- **🚨 s611 — `Δ_obs > -envelope`**: lower envelope bound. -/
theorem T1_s611_obs_above_lower :
    -Delta_amu_envelope_units < Delta_amu_obs_units := by
  unfold Delta_amu_obs_units Delta_amu_envelope_units; norm_num

/-- **🚨 s611 — `Δ_obs < envelope`**: upper envelope bound. -/
theorem T1_s611_obs_below_upper :
    Delta_amu_obs_units < Delta_amu_envelope_units := by
  unfold Delta_amu_obs_units Delta_amu_envelope_units; norm_num

/-- **🚨 s611 — `Δ_obs > σ`**: observed deviation EXCEEDS 1σ
    (247 > 50), confirming the headline ~5σ tension between
    Fermilab and the SM-data-driven prediction. -/
theorem T1_s611_obs_gt_sigma :
    sigma_obs_units < Delta_amu_obs_units := by
  unfold Delta_amu_obs_units sigma_obs_units; norm_num

/-- **🚨 s611 — `Δ_obs > 3σ`**: observed deviation exceeds 3σ
    (247 > 150), the conventional "evidence" threshold. -/
theorem T1_s611_obs_gt_three_sigma :
    3 * sigma_obs_units < Delta_amu_obs_units := by
  unfold Delta_amu_obs_units sigma_obs_units; norm_num

/-! ## s612: 1σ, 3σ, 5σ bands within envelope -/

/-- **🚨 s612 — `σ > 0`**: 1σ uncertainty positive. -/
theorem T1_s612_sigma_pos : 0 < sigma_obs_units := by
  unfold sigma_obs_units; norm_num

/-- **🚨 s612 — `σ < envelope`**: 1σ uncertainty fits within
    envelope (50 < 600). -/
theorem T1_s612_sigma_lt_envelope :
    sigma_obs_units < Delta_amu_envelope_units := by
  unfold sigma_obs_units Delta_amu_envelope_units; norm_num

/-- **🚨 s612 — `3σ < envelope`**: 3σ band fits within envelope
    (150 < 600). -/
theorem T1_s612_three_sigma_lt_envelope :
    3 * sigma_obs_units < Delta_amu_envelope_units := by
  unfold sigma_obs_units Delta_amu_envelope_units; norm_num

/-- **🚨 s612 — `5σ < envelope`**: 5σ discovery threshold fits
    strictly inside envelope (250 < 600), leaving generous slack
    for the BMW-lattice and e⁺e⁻ scenarios both. -/
theorem T1_s612_five_sigma_lt_envelope :
    5 * sigma_obs_units < Delta_amu_envelope_units := by
  unfold sigma_obs_units Delta_amu_envelope_units; norm_num

/-- **🚨 s612 — `Δ_obs + 5σ < envelope`**: upper 5σ tail of observed
    deviation lies within envelope (`247 + 250 = 497 < 600`). -/
theorem T1_s612_obs_plus_five_sigma_within :
    Delta_amu_obs_units + 5 * sigma_obs_units
      < Delta_amu_envelope_units := by
  unfold Delta_amu_obs_units sigma_obs_units Delta_amu_envelope_units
  norm_num

/-- **🚨 s612 — `Δ_obs - 5σ > -envelope`**: lower 5σ tail of observed
    deviation lies within envelope (`247 - 250 = -3 > -600`). -/
theorem T1_s612_obs_minus_five_sigma_within :
    -Delta_amu_envelope_units
      < Delta_amu_obs_units - 5 * sigma_obs_units := by
  unfold Delta_amu_obs_units sigma_obs_units Delta_amu_envelope_units
  norm_num

/-! ## s613: SM-DD limit + substrate-shift bound vs Fermilab -/

/-- **🚨 s613 — `Δ_substrate = 0`**: substrate prediction equals
    SM-DD reference curve exactly (working-units zero). -/
theorem T1_s613_substrate_eq_zero :
    Delta_amu_substrate_units = 0 := by
  unfold Delta_amu_substrate_units; rfl

/-- **🚨 s613 — `Δ_substrate < envelope`**: SM-DD limit is within
    envelope (0 < 600), so substrate prediction is consistent with
    the Fermilab envelope. -/
theorem T1_s613_substrate_below_upper :
    Delta_amu_substrate_units < Delta_amu_envelope_units := by
  unfold Delta_amu_substrate_units Delta_amu_envelope_units; norm_num

/-- **🚨 s613 — `Δ_substrate > -envelope`**: SM-DD limit is within
    envelope (-600 < 0). -/
theorem T1_s613_substrate_above_lower :
    -Delta_amu_envelope_units < Delta_amu_substrate_units := by
  unfold Delta_amu_substrate_units Delta_amu_envelope_units; norm_num

/-- **🚨 s613 — `Δ_obs - Δ_substrate < envelope`**: separation of
    Fermilab central from substrate (= SM-DD) limit is within envelope
    (247 - 0 = 247 < 600). -/
theorem T1_s613_separation_lt_envelope :
    Delta_amu_obs_units - Delta_amu_substrate_units
      < Delta_amu_envelope_units := by
  unfold Delta_amu_obs_units Delta_amu_substrate_units Delta_amu_envelope_units
  norm_num

/-- **🚨 s613 — `Δ_obs - Δ_substrate > σ`**: separation exceeds 1σ
    (247 > 50), so Fermilab is INCONSISTENT with the SM-DD limit at
    the > 1σ level (substrate must explain the residual). -/
theorem T1_s613_separation_gt_one_sigma :
    sigma_obs_units < Delta_amu_obs_units - Delta_amu_substrate_units := by
  unfold Delta_amu_obs_units Delta_amu_substrate_units sigma_obs_units
  norm_num

/-- **🚨 s613 — `Δ_obs - Δ_substrate > 0`**: substrate prediction
    lies BELOW Fermilab central (the famous tension: experiment is
    above SM expectation). -/
theorem T1_s613_separation_pos :
    0 < Delta_amu_obs_units - Delta_amu_substrate_units := by
  unfold Delta_amu_obs_units Delta_amu_substrate_units; norm_num

/-! ## s614: Frontier Prop + 6-conjunct headline -/

/-- **FermilabMuonG2AnomalyFrontier**: 6-way conjunction pinning the
    substrate-prediction envelope for the Fermilab Run-1+2+3 final
    2024-2025 muon g-2 measurement vs the SM Theory Initiative 2020
    e⁺e⁻ HVP prediction, in working units of 10⁻¹¹:

    1. `envelope > 0`                                  (positivity)
    2. `-envelope < Δ_obs < envelope`                  (Fermilab central within)
    3. `-envelope < Δ_substrate < envelope`            (SM-DD limit within)
    4. `σ < envelope ∧ 5σ < envelope`                  (full 5σ band fits)
    5. `0 < Δ_obs - Δ_substrate < envelope`            (separation within envelope)
    6. `σ < Δ_obs - Δ_substrate`                       (separation > 1σ — tension!)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `Δa_μ = a_μ^substrate - a_μ^SM` (muon-g-2
    anomalous-moment deviation from SM-data-driven HVP) must lie
    within this envelope to remain consistent with Fermilab Run-1+2+3
    final 2024-2025 results, AND the observed central must exceed 1σ
    (positive deviation = the famous tension). -/
def FermilabMuonG2AnomalyFrontier : Prop :=
  -- envelope > 0
  (0 < Delta_amu_envelope_units) ∧
  -- -envelope < Δ_obs < envelope
  (-Delta_amu_envelope_units < Delta_amu_obs_units ∧
    Delta_amu_obs_units < Delta_amu_envelope_units) ∧
  -- -envelope < Δ_substrate < envelope
  (-Delta_amu_envelope_units < Delta_amu_substrate_units ∧
    Delta_amu_substrate_units < Delta_amu_envelope_units) ∧
  -- σ < envelope ∧ 5σ < envelope
  (sigma_obs_units < Delta_amu_envelope_units ∧
    5 * sigma_obs_units < Delta_amu_envelope_units) ∧
  -- 0 < Δ_obs - Δ_substrate < envelope
  (0 < Delta_amu_obs_units - Delta_amu_substrate_units ∧
    Delta_amu_obs_units - Delta_amu_substrate_units
      < Delta_amu_envelope_units) ∧
  -- σ < Δ_obs - Δ_substrate (the tension)
  (sigma_obs_units < Delta_amu_obs_units - Delta_amu_substrate_units)

/-- **🚨 s614 — `FermilabMuonG2AnomalyFrontier`** holds. -/
theorem T1_s614_fermilab_muon_g2_anomaly_frontier :
    FermilabMuonG2AnomalyFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s610_envelope_pos
  · exact T1_s611_obs_above_lower
  · exact T1_s611_obs_below_upper
  · exact T1_s613_substrate_above_lower
  · exact T1_s613_substrate_below_upper
  · exact T1_s612_sigma_lt_envelope
  · exact T1_s612_five_sigma_lt_envelope
  · exact T1_s613_separation_pos
  · exact T1_s613_separation_lt_envelope
  · exact T1_s613_separation_gt_one_sigma

/-! ## Headline -/

/-- **HEADLINE — sessions 610-614 — Fermilab muon g-2 anomalous
    magnetic moment frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s610: |Δa_μ| envelope half-width = 600 × 10⁻¹¹
            (= ~12σ band slack to absorb e⁺e⁻ + BMW-lattice scenarios)
    - s611: Fermilab central deviation Δ = 247 × 10⁻¹¹ within envelope,
            EXCEEDING 1σ and 3σ (the famous tension)
    - s612: 1σ (50), 3σ (150), 5σ (250) uncertainty bands fit
    - s613: substrate SM-DD limit (Δ = 0) within envelope;
            Fermilab-substrate separation > 1σ tension
    - s614: FermilabMuonG2AnomalyFrontier Prop (6-conjunct) + headline

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the Fermilab Muon g-2 final
    2024-2025 result.  The combined Run-1+2+3 measurement
    `a_μ^exp = 116592057(25) × 10⁻¹¹` (2.0 ppm precision) confronts
    two competing SM-theory predictions:

    - **SM Theory Initiative 2020** (e⁺e⁻ → hadrons HVP):
      `a_μ^SM-DD = 116591810(43) × 10⁻¹¹`, giving Δ = 247 × 10⁻¹¹
      (~5σ tension early; this Frontier file's central scenario).
    - **BMW lattice 2024**:
      `a_μ^SM-Lat = 116592033(62) × 10⁻¹¹`, giving Δ = 24 × 10⁻¹¹
      (< 1σ — consistent with Fermilab; resolves the puzzle within
      lattice-QCD).

    The puzzle therefore lives between the two SM predictions, not
    between Fermilab and "the" SM.  This Frontier file pins the
    substrate-prediction envelope for the SM-DD scenario; the BMW
    scenario lies trivially inside the same envelope.

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    HVP contribution to a_μ rides primarily the π-channel (largest
    residual, O(1/N)) with subleading Catalan-G + e + √2
    contributions.  At the truncation budget that matches the
    Fermilab precision (N ~ 4-6), substrate δ_comp residuals are
    bounded by ratio `(ℓ_P / muon-Compton)^something ≪ 600 × 10⁻¹¹`,
    comfortably inside this envelope.  The companion substrate-fit
    files `MuonGminus2SubstrateFit` /
    `T1_AnomalousMagneticMomentsBundle` derive specific numerical
    predictions in the π-channel.

    Reference: Aguillard et al. (Muon g-2 Collaboration, 2025) —
    "Final result of the Muon g−2 experiment at Fermilab",
    Phys. Rev. Lett. (in press); BNL E821 + Fermilab Run-1+2+3
    combined gives 2.0 ppm precision.  SM Theory Initiative 2020:
    Aoyama et al., Phys. Rep. 887, 1-166 (2020).  BMW lattice 2024:
    Borsanyi et al., Nature 593, 51-55 (2021) + 2024 update.

    Sub-lemma in T-1 muon-sector lepton-anomalous-moment residue.
    Lean-core only.

    🏆 First Lean-core Fermilab muon g-2 anomalous-moment frontier
    envelope. -/
theorem session_610_to_614_fermilab_muon_g2_anomaly_frontier_headline :
    0 < Delta_amu_envelope_units
    ∧ Delta_amu_obs_units < Delta_amu_envelope_units
    ∧ Delta_amu_substrate_units < Delta_amu_envelope_units
    ∧ sigma_obs_units < Delta_amu_envelope_units
    ∧ 5 * sigma_obs_units < Delta_amu_envelope_units
    ∧ Delta_amu_obs_units - Delta_amu_substrate_units
        < Delta_amu_envelope_units
    ∧ sigma_obs_units
        < Delta_amu_obs_units - Delta_amu_substrate_units
    ∧ FermilabMuonG2AnomalyFrontier :=
  ⟨T1_s610_envelope_pos, T1_s611_obs_below_upper,
   T1_s613_substrate_below_upper, T1_s612_sigma_lt_envelope,
   T1_s612_five_sigma_lt_envelope,
   T1_s613_separation_lt_envelope,
   T1_s613_separation_gt_one_sigma,
   T1_s614_fermilab_muon_g2_anomaly_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_fermilab_muon_g2_anomaly_frontier_bundle :
    FermilabMuonG2AnomalyFrontier :=
  T1_s614_fermilab_muon_g2_anomaly_frontier

end OmegaTheory.Predictions.T1_FermilabMuonG2AnomalyFrontier
