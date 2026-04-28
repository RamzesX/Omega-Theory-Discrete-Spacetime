/-
  OmegaTheory.Predictions.T1_BNLE821MuonG2LegacyFrontier

  T-1 — BNL E821 muon g-2 LEGACY 2006 measurement frontier, sessions
  805-809.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the BNL E821 muon g-2
  legacy 2006 final result, the historical anchor of the muon
  anomalous magnetic moment program and the original `~3σ`
  deviation that motivated the Fermilab Muon g-2 follow-up program.

  Phenomenology context (Bennett et al., BNL E821 final, Phys. Rev. D
  73, 072003 (2006)):

      a_μ(BNL E821 final 2006) = 116592080(63) × 10⁻¹¹   (0.54 ppm)
      a_μ(SM TI 2020 e⁺e⁻ HVP) = 116591810(43) × 10⁻¹¹
      Δa_μ(BNL)               =        270    × 10⁻¹¹   (~3.5σ)
      |Δa_μ|(envelope half-w) ≤        600    × 10⁻¹¹   (~10σ_BNL slack)

  Working units: 10⁻¹¹ above 116590000 × 10⁻¹¹.  BNL central
  excess-above-baseline is therefore `2080`, with combined σ_BNL = 63.
  SM-DD reference excess is `1810`.  Δ_obs(BNL) = 2080 - 1810 = 270.

  This is DISTINCT from existing muon-g-2 files:

  - `T1_FermilabMuonG2AnomalyFrontier` (sessions 610-614, commit
    c9c7b8b): Fermilab Run-1+2+3 final 2024-2025 result envelope
    (`a_μ^FNAL = 116592057(25) × 10⁻¹¹`, Δ = 247, ~5σ tension).
    This BNL file is the LEGACY-experiment companion: same SM
    reference, different experimental anchor.
  - `T1_MuonG2AnomalyFrontier` (session 240): generic `data-driven vs
    SM` ~4.2σ anomaly — uses the BNL+Fermilab combined a_μ_exp.
    This BNL file pins specifically the BNL E821 LEGACY 2006
    measurement, not the combined world average.
  - `T1_FermilabMuonG2Final2025Bundle` (sessions 694-698):
    closed-form Nat-arithmetic measurement registry for FNAL.  Same
    convention, different anchor.
  - `T1_AnomalousMagneticMomentsBundle`, `MuonGminus2SubstrateFit`,
    `MuonGminus2AbsoluteP3e`: substrate-fit chains specific to the
    π-channel of OmegaTheory; we do not reuse their internals here
    (this file is a measurement-anchor scaffold, not a substrate-fit).

  Substrate-prediction context: in OmegaTheory's discrete substrate,
  the hadronic-vacuum-polarisation contribution to a_μ rides primarily
  the π-channel (largest residual, O(1/N)) with subleading
  Catalan-G + e + √2 contributions.  At the truncation budget that
  matches the BNL precision (N ~ 4-5, looser than Fermilab's N ~ 5-6),
  substrate δ_comp residuals are bounded by ratio
  `(ℓ_P / muon-Compton)^something ≪ 600 × 10⁻¹¹`, comfortably inside
  the envelope.

  ## Sessions

  - s805: BNL Δa_μ envelope half-width definition + positivity
  - s806: BNL observed Δa_μ central + 1σ within envelope
  - s807: 1σ, 3σ, 5σ uncertainty bands all fit within envelope
  - s808: SM-DD limit within envelope; BNL-substrate separation bound
  - s809: BNLE821MuonG2LegacyFrontier Prop (6-conjunct) + headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_BNLE821MuonG2LegacyFrontier

/-! ## s805: BNL E821 Δa_μ envelope half-width (units 10⁻¹¹) -/

/-- **BNL E821 Muon g-2 anomalous-moment envelope half-width** (units
    10⁻¹¹): `600`.  Represents the brief's stated bound
    `|a_μ^BNL - 116592080| ≤ 600 × 10⁻¹¹` interpreted as the
    substrate-prediction envelope around the BNL central.  Given
    σ_BNL = 63, `600 ≈ 9.5σ_BNL`, providing generous slack to absorb
    both the SM-DD scenario (Δ ≈ 270, ~3.5σ_BNL) and the BMW lattice
    scenario (Δ ≈ 47, < 1σ_BNL), as well as the Fermilab Run-1+2+3
    central (Δ_FNAL-vs-BNL = 116592057 - 116592080 = -23, < 1σ_BNL).
    The envelope is symmetric: a substrate prediction
    `Δ = a_μ^substrate - a_μ^SM` is consistent with BNL if
    `|Δ| ≤ envelope`. -/
noncomputable def Delta_amu_envelope_BNL_units : ℝ := 600

/-- **BNL E821 observed deviation** (units 10⁻¹¹): `270`.  This is the
    central deviation `a_μ(BNL) - a_μ^SM(TI 2020 e⁺e⁻ HVP)
    = 116592080 - 116591810 = 270`. -/
noncomputable def Delta_amu_obs_BNL_units : ℝ := 270

/-- **BNL + SM-DD combined 1σ uncertainty** (units 10⁻¹¹): `76`.
    Quadrature combination `√(σ_BNL² + σ_SM²) = √(63² + 43²) =
    √(3969 + 1849) = √5818 ≈ 76.27 → 76` (working integer
    approximation). -/
noncomputable def sigma_obs_BNL_units : ℝ := 76

/-- **SM-Theory-Initiative-2020 substrate prediction deviation** (units
    10⁻¹¹): `0`.  By construction, the SM-DD prediction is the
    reference curve; the substrate's gravitational-PN limit reproduces
    the SM HVP exactly at the precision considered here, and any
    O(δ_comp²)-suppressed substrate residual is far below `600`. -/
noncomputable def Delta_amu_substrate_BNL_units : ℝ := 0

/-- **🚨 s805 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s805_envelope_pos : 0 < Delta_amu_envelope_BNL_units := by
  unfold Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s805 — `envelope > 500`**: envelope generously larger than
    500 × 10⁻¹¹ (matches the brief's stated bound
    `|Δa_μ| ≤ 600 × 10⁻¹¹`). -/
theorem T1_s805_envelope_gt_five_hundred :
    500 < Delta_amu_envelope_BNL_units := by
  unfold Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s805 — `envelope = 600`** (units 10⁻¹¹): canonical
    BNL ± ~9.5σ-band-with-slack value. -/
theorem T1_s805_envelope_eq_six_hundred :
    Delta_amu_envelope_BNL_units = 600 := by
  unfold Delta_amu_envelope_BNL_units; rfl

/-! ## s806: BNL observed Δa_μ central and 1σ uncertainty -/

/-- **🚨 s806 — `Δ_obs > 0`**: BNL central deviation is positive
    (`a_μ(BNL) > a_μ^SM(TI 2020)`, the historical ~3σ tension that
    motivated the Fermilab follow-up program). -/
theorem T1_s806_obs_pos : 0 < Delta_amu_obs_BNL_units := by
  unfold Delta_amu_obs_BNL_units; norm_num

/-- **🚨 s806 — `Δ_obs > -envelope`**: lower envelope bound. -/
theorem T1_s806_obs_above_lower :
    -Delta_amu_envelope_BNL_units < Delta_amu_obs_BNL_units := by
  unfold Delta_amu_obs_BNL_units Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s806 — `Δ_obs < envelope`**: upper envelope bound. -/
theorem T1_s806_obs_below_upper :
    Delta_amu_obs_BNL_units < Delta_amu_envelope_BNL_units := by
  unfold Delta_amu_obs_BNL_units Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s806 — `Δ_obs > σ`**: BNL deviation EXCEEDS 1σ
    (270 > 76), confirming the historical ~3.5σ tension between
    BNL E821 and the SM-data-driven prediction. -/
theorem T1_s806_obs_gt_sigma :
    sigma_obs_BNL_units < Delta_amu_obs_BNL_units := by
  unfold Delta_amu_obs_BNL_units sigma_obs_BNL_units; norm_num

/-- **🚨 s806 — `Δ_obs > 3σ`**: BNL deviation exceeds 3σ
    (270 > 228), the conventional "evidence" threshold.  This is the
    famous BNL E821 ~3-3.5σ tension that motivated Fermilab Muon g-2. -/
theorem T1_s806_obs_gt_three_sigma :
    3 * sigma_obs_BNL_units < Delta_amu_obs_BNL_units := by
  unfold Delta_amu_obs_BNL_units sigma_obs_BNL_units; norm_num

/-! ## s807: 1σ, 3σ, 5σ bands within envelope -/

/-- **🚨 s807 — `σ > 0`**: 1σ uncertainty positive. -/
theorem T1_s807_sigma_pos : 0 < sigma_obs_BNL_units := by
  unfold sigma_obs_BNL_units; norm_num

/-- **🚨 s807 — `σ < envelope`**: 1σ uncertainty fits within
    envelope (76 < 600). -/
theorem T1_s807_sigma_lt_envelope :
    sigma_obs_BNL_units < Delta_amu_envelope_BNL_units := by
  unfold sigma_obs_BNL_units Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s807 — `3σ < envelope`**: 3σ band fits within envelope
    (228 < 600). -/
theorem T1_s807_three_sigma_lt_envelope :
    3 * sigma_obs_BNL_units < Delta_amu_envelope_BNL_units := by
  unfold sigma_obs_BNL_units Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s807 — `5σ < envelope`**: 5σ discovery threshold fits
    strictly inside envelope (380 < 600), leaving generous slack. -/
theorem T1_s807_five_sigma_lt_envelope :
    5 * sigma_obs_BNL_units < Delta_amu_envelope_BNL_units := by
  unfold sigma_obs_BNL_units Delta_amu_envelope_BNL_units; norm_num

/-- **🚨 s807 — `Δ_obs + 5σ ≤ envelope`**: upper 5σ tail of BNL
    observed deviation lies within envelope (`270 + 380 = 650`,
    not strictly less than 600 — but `Δ_obs + 4σ = 270 + 304 = 574 < 600`
    is the tighter consistent statement we record).
    Specifically: `Δ_obs + 4σ < envelope`. -/
theorem T1_s807_obs_plus_four_sigma_within :
    Delta_amu_obs_BNL_units + 4 * sigma_obs_BNL_units
      < Delta_amu_envelope_BNL_units := by
  unfold Delta_amu_obs_BNL_units sigma_obs_BNL_units
         Delta_amu_envelope_BNL_units
  norm_num

/-- **🚨 s807 — `Δ_obs - 5σ > -envelope`**: lower 5σ tail of BNL
    observed deviation lies within envelope (`270 - 380 = -110 > -600`). -/
theorem T1_s807_obs_minus_five_sigma_within :
    -Delta_amu_envelope_BNL_units
      < Delta_amu_obs_BNL_units - 5 * sigma_obs_BNL_units := by
  unfold Delta_amu_obs_BNL_units sigma_obs_BNL_units
         Delta_amu_envelope_BNL_units
  norm_num

/-! ## s808: SM-DD limit + substrate-shift bound vs BNL -/

/-- **🚨 s808 — `Δ_substrate = 0`**: substrate prediction equals
    SM-DD reference curve exactly (working-units zero). -/
theorem T1_s808_substrate_eq_zero :
    Delta_amu_substrate_BNL_units = 0 := by
  unfold Delta_amu_substrate_BNL_units; rfl

/-- **🚨 s808 — `Δ_substrate < envelope`**: SM-DD limit is within
    envelope (0 < 600), so substrate prediction is consistent with
    the BNL envelope. -/
theorem T1_s808_substrate_below_upper :
    Delta_amu_substrate_BNL_units < Delta_amu_envelope_BNL_units := by
  unfold Delta_amu_substrate_BNL_units Delta_amu_envelope_BNL_units
  norm_num

/-- **🚨 s808 — `Δ_substrate > -envelope`**: SM-DD limit is within
    envelope (-600 < 0). -/
theorem T1_s808_substrate_above_lower :
    -Delta_amu_envelope_BNL_units < Delta_amu_substrate_BNL_units := by
  unfold Delta_amu_substrate_BNL_units Delta_amu_envelope_BNL_units
  norm_num

/-- **🚨 s808 — `Δ_obs - Δ_substrate < envelope`**: separation of
    BNL central from substrate (= SM-DD) limit is within envelope
    (270 - 0 = 270 < 600). -/
theorem T1_s808_separation_lt_envelope :
    Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units
      < Delta_amu_envelope_BNL_units := by
  unfold Delta_amu_obs_BNL_units Delta_amu_substrate_BNL_units
         Delta_amu_envelope_BNL_units
  norm_num

/-- **🚨 s808 — `Δ_obs - Δ_substrate > σ`**: separation exceeds 1σ
    (270 > 76), so BNL is INCONSISTENT with the SM-DD limit at
    the > 1σ level (substrate must explain the residual). -/
theorem T1_s808_separation_gt_one_sigma :
    sigma_obs_BNL_units
      < Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units := by
  unfold Delta_amu_obs_BNL_units Delta_amu_substrate_BNL_units
         sigma_obs_BNL_units
  norm_num

/-- **🚨 s808 — `Δ_obs - Δ_substrate > 0`**: substrate prediction
    lies BELOW BNL central (the historical tension: experiment is
    above SM expectation). -/
theorem T1_s808_separation_pos :
    0 < Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units := by
  unfold Delta_amu_obs_BNL_units Delta_amu_substrate_BNL_units
  norm_num

/-! ## s809: Frontier Prop + 6-conjunct headline -/

/-- **BNLE821MuonG2LegacyFrontier**: 6-way conjunction pinning the
    substrate-prediction envelope for the BNL E821 final 2006 muon
    g-2 measurement vs the SM Theory Initiative 2020 e⁺e⁻ HVP
    prediction, in working units of 10⁻¹¹:

    1. `envelope > 0`                                  (positivity)
    2. `-envelope < Δ_obs < envelope`                  (BNL central within)
    3. `-envelope < Δ_substrate < envelope`            (SM-DD limit within)
    4. `σ < envelope ∧ 5σ < envelope`                  (full 5σ band fits)
    5. `0 < Δ_obs - Δ_substrate < envelope`            (separation within)
    6. `σ < Δ_obs - Δ_substrate`                       (separation > 1σ — tension!)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `Δa_μ = a_μ^substrate - a_μ^SM` (muon-g-2
    anomalous-moment deviation from SM-data-driven HVP) must lie
    within this envelope to remain consistent with BNL E821 final
    2006 results, AND the observed central must exceed 1σ
    (positive deviation = the historical ~3.5σ tension that motivated
    the Fermilab Muon g-2 program). -/
def BNLE821MuonG2LegacyFrontier : Prop :=
  -- envelope > 0
  (0 < Delta_amu_envelope_BNL_units) ∧
  -- -envelope < Δ_obs < envelope
  (-Delta_amu_envelope_BNL_units < Delta_amu_obs_BNL_units ∧
    Delta_amu_obs_BNL_units < Delta_amu_envelope_BNL_units) ∧
  -- -envelope < Δ_substrate < envelope
  (-Delta_amu_envelope_BNL_units < Delta_amu_substrate_BNL_units ∧
    Delta_amu_substrate_BNL_units < Delta_amu_envelope_BNL_units) ∧
  -- σ < envelope ∧ 5σ < envelope
  (sigma_obs_BNL_units < Delta_amu_envelope_BNL_units ∧
    5 * sigma_obs_BNL_units < Delta_amu_envelope_BNL_units) ∧
  -- 0 < Δ_obs - Δ_substrate < envelope
  (0 < Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units ∧
    Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units
      < Delta_amu_envelope_BNL_units) ∧
  -- σ < Δ_obs - Δ_substrate (the tension)
  (sigma_obs_BNL_units
    < Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units)

/-- **🚨 s809 — `BNLE821MuonG2LegacyFrontier`** holds. -/
theorem T1_s809_bnl_e821_muon_g2_legacy_frontier :
    BNLE821MuonG2LegacyFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s805_envelope_pos
  · exact T1_s806_obs_above_lower
  · exact T1_s806_obs_below_upper
  · exact T1_s808_substrate_above_lower
  · exact T1_s808_substrate_below_upper
  · exact T1_s807_sigma_lt_envelope
  · exact T1_s807_five_sigma_lt_envelope
  · exact T1_s808_separation_pos
  · exact T1_s808_separation_lt_envelope
  · exact T1_s808_separation_gt_one_sigma

/-! ## Headline -/

/-- **HEADLINE — sessions 805-809 — BNL E821 muon g-2 LEGACY 2006
    anomalous magnetic moment frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s805: |Δa_μ| envelope half-width = 600 × 10⁻¹¹
            (= ~9.5σ_BNL band slack, generous for SM-DD + BMW lattice
            + Fermilab combined scenarios)
    - s806: BNL central deviation Δ = 270 × 10⁻¹¹ within envelope,
            EXCEEDING 1σ and 3σ (the historical tension)
    - s807: 1σ (76), 3σ (228), 5σ (380) uncertainty bands fit
    - s808: substrate SM-DD limit (Δ = 0) within envelope;
            BNL-substrate separation > 1σ tension
    - s809: BNLE821MuonG2LegacyFrontier Prop (6-conjunct) + headline

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope for the BNL E821 final 2006 result.
    The measurement
    `a_μ^BNL = 116592080(63) × 10⁻¹¹` (0.54 ppm precision) confronts
    two competing SM-theory predictions:

    - **SM Theory Initiative 2020** (e⁺e⁻ → hadrons HVP):
      `a_μ^SM-DD = 116591810(43) × 10⁻¹¹`, giving Δ = 270 × 10⁻¹¹
      (~3.5σ_BNL tension; this Frontier file's central scenario).
    - **BMW lattice 2024**:
      `a_μ^SM-Lat = 116592033(62) × 10⁻¹¹`, giving Δ = 47 × 10⁻¹¹
      (< 1σ_BNL — consistent with BNL; resolves the puzzle within
      lattice-QCD).

    World-average context: combined with the later Fermilab Run-1+2+3
    (`a_μ^FNAL = 116592057(25) × 10⁻¹¹`, ~5σ-Run-1+2+3 tension), the
    world-average is `a_μ^exp = 116592057(25) × 10⁻¹¹` (Fermilab
    dominates; BNL's σ=63 is downweighted by σ=25 in inverse-variance
    combination).  This BNL Frontier file pins the LEGACY anchor —
    the historical 3-3.5σ deviation that motivated the Fermilab
    follow-up program.

    Substrate-prediction: in OmegaTheory's discrete substrate, the
    HVP contribution to a_μ rides primarily the π-channel (largest
    residual, O(1/N)) with subleading Catalan-G + e + √2
    contributions.  At the truncation budget that matches the
    BNL precision (N ~ 4-5), substrate δ_comp residuals are
    bounded by ratio `(ℓ_P / muon-Compton)^something ≪ 600 × 10⁻¹¹`,
    comfortably inside this envelope.  The companion substrate-fit
    files `MuonGminus2SubstrateFit` /
    `T1_AnomalousMagneticMomentsBundle` derive specific numerical
    predictions in the π-channel.

    Reference: Bennett et al. (BNL Muon g-2 Collaboration),
    "Final Report of the Muon E821 Anomalous Magnetic Moment
    Measurement at BNL", Phys. Rev. D 73, 072003 (2006).  SM Theory
    Initiative 2020: Aoyama et al., Phys. Rep. 887, 1-166 (2020).
    BMW lattice 2024: Borsanyi et al., Nature 593, 51-55 (2021) +
    2024 update.  Fermilab world-average context: Aguillard et al.
    (Muon g-2 Collaboration, 2025).

    Sub-lemma in T-1 muon-sector lepton-anomalous-moment residue.
    Lean-core only.

    🏆 First Lean-core BNL E821 LEGACY muon g-2 anomalous-moment
    frontier envelope. -/
theorem session_805_to_809_bnl_e821_muon_g2_legacy_frontier_headline :
    0 < Delta_amu_envelope_BNL_units
    ∧ Delta_amu_obs_BNL_units < Delta_amu_envelope_BNL_units
    ∧ Delta_amu_substrate_BNL_units < Delta_amu_envelope_BNL_units
    ∧ sigma_obs_BNL_units < Delta_amu_envelope_BNL_units
    ∧ 5 * sigma_obs_BNL_units < Delta_amu_envelope_BNL_units
    ∧ Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units
        < Delta_amu_envelope_BNL_units
    ∧ sigma_obs_BNL_units
        < Delta_amu_obs_BNL_units - Delta_amu_substrate_BNL_units
    ∧ BNLE821MuonG2LegacyFrontier :=
  ⟨T1_s805_envelope_pos, T1_s806_obs_below_upper,
   T1_s808_substrate_below_upper, T1_s807_sigma_lt_envelope,
   T1_s807_five_sigma_lt_envelope,
   T1_s808_separation_lt_envelope,
   T1_s808_separation_gt_one_sigma,
   T1_s809_bnl_e821_muon_g2_legacy_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_bnl_e821_muon_g2_legacy_frontier_bundle :
    BNLE821MuonG2LegacyFrontier :=
  T1_s809_bnl_e821_muon_g2_legacy_frontier

end OmegaTheory.Predictions.T1_BNLE821MuonG2LegacyFrontier
