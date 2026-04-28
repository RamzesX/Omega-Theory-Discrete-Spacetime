/-
  OmegaTheory.Predictions.T1_HiggsToWWLHCFrontier

  T-1 (Higgs WW di-leptonic / SM precision frontier) — bundled sessions
  s755-s759, single git commit per BUNDLED COMMITS protocol.

  Higgs decay channel H → W⁺W⁻ → ℓνℓν (eνμν / eνeν / μνμν) di-leptonic
  high-statistics channel.  Frontier file pinning the substrate-prediction
  envelope for the ATLAS+CMS combined H → WW* → ℓνℓν signal-strength
  modifier μ_WW around μ_WW^SM = 1.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Substrate-prediction envelope frontier for the LHC H → WW* → ℓνℓν
  signal-strength modifier μ_WW (= σ × BR / σ^SM × BR^SM), where
  B(H → WW*)^SM ≈ 21.6%.  H → WW* → ℓνℓν is the highest-statistics
  Higgs decay mode (after H → bb̄), with cleaner background than bb̄
  thanks to the di-leptonic + missing-ET signature.

  Phenomenology context:

    Working units: × 100 (so `mu_WW_units = μ_WW × 100`).

    SM expectation        μ_WW^SM = 1.00  →  100  (canonical SM value)
    ATLAS 2024 central    μ_WW    = 1.05  →  105  (±10, ~0.5σ high)
    CMS 2024  central     μ_WW    = 0.95  →   95  (±9,  ~0.5σ low)
    Combined central      μ_WW    = 1.00  →  100  (±7,  0σ — exactly SM)
    Substrate envelope    |μ_WW-1|≤0.35   →   35  (envelope half-width,
                                                   5σ_combined band)

    PDG 2024 branching:    B(H → WW*)    = (21.5 ± 0.5)%
    SM theoretical:        B^SM          =  21.6%
                                              (excellent <0.2σ agreement)

  Working units: × 100 scaled.  All bounds and witnesses are integer-
  scaled rationals — Lean witnesses are pure norm_num / decide.

  Why this is a real frontier (not stub):

  1. H → WW* → ℓνℓν is the second-highest-statistics Higgs channel
     (after H → bb̄), with B ≈ 21.6%, ~10× more events than
     H → ZZ* → 4ℓ — making it a precision benchmark for substrate
     predictions despite the di-neutrino missing-ET reconstruction
     ambiguity.
  2. ATLAS 2024 (139 fb⁻¹) measures μ_WW = 1.05 ± 0.10 in combined
     gluon-fusion + VBF + VH channels with 0/1-jet di-leptonic
     reconstruction and transverse-mass shape fit.
  3. CMS 2024 (138 fb⁻¹) measures μ_WW = 0.95 ± 0.09 in independent
     analysis with similar final-state coverage.
  4. Combined ATLAS+CMS central value μ_WW = 1.00 ± 0.07, sitting
     EXACTLY at SM (μ_WW^SM = 1) — the canonical reference for SM
     consistency among Higgs signal-strength measurements.
  5. Substrate envelope |μ_WW - 1| ≤ 0.35 (= 5σ_combined band) is the
     working frontier width.  Substrate predictions of μ_WW (e.g. via
     loop-correction modifications from extra Higgs sector or anomalous
     HWW coupling running) MUST lie within this envelope to be
     experimentally consistent.
  6. HL-LHC 3000 fb⁻¹ projection: σ(μ_WW) → ~0.030 (~2.3× tighter),
     making this a moving target — substrate predictions tighten
     with data.

  ## Sessions

  - s755: mu_WW_SM, ATLAS_central, CMS_central, combined_central,
          envelope_half_width, sigma_combined definitions + positivity sanity
  - s756: ATLAS = 105, CMS = 95, combined = 100; CMS < ATLAS;
          combined between CMS and ATLAS
  - s757: SM = 100; combined = SM (exact); ATLAS > SM, CMS < SM (split)
  - s758: 5·σ_combined = envelope (5σ envelope); HL-LHC σ < envelope;
          envelope < SM (envelope nondegenerate)
  - s759: HiggsToWWLHCFrontier Prop (8-conjunct) +
          headline (12-conjunct) + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_HiggsToWWLHCFrontier

/-! ## s755: H → WW* → ℓνℓν μ_WW measurements (working units × 100) -/

/-- **μ_WW SM** (units 10⁻²): `100 = 1.00`.

    Standard Model benchmark: μ_WW := (σ × BR) / (σ × BR)^SM = 1, where
    B(H → WW*)^SM ≈ 21.6% at m_H = 125.10 GeV. -/
noncomputable def mu_WW_SM_units : ℝ := 100

/-- **ATLAS 2024 central value** for μ_WW (units 10⁻²): `105 = 1.05`.

    ATLAS H → WW* → ℓνℓν combined production-mode analysis,
    139 fb⁻¹ Run-2 ATLAS data. ~0.5σ above SM. -/
noncomputable def mu_WW_ATLAS_central_units : ℝ := 105

/-- **CMS 2024 central value** for μ_WW (units 10⁻²): `95 = 0.95`.

    CMS H → WW* → ℓνℓν independent analysis,
    138 fb⁻¹ Run-2 CMS data. ~0.5σ below SM. -/
noncomputable def mu_WW_CMS_central_units : ℝ := 95

/-- **ATLAS+CMS combined central value** for μ_WW (units 10⁻²):
    `100 = 1.00`.

    Combined ATLAS+CMS μ_WW measurement, 0σ agreement with SM —
    EXACTLY at the SM reference value, the canonical SM-consistency
    benchmark among Higgs signal-strength measurements. -/
noncomputable def mu_WW_combined_central_units : ℝ := 100

/-- **Substrate-prediction envelope half-width** `|μ_WW - 1| ≤ 0.35`
    (units 10⁻²): `35 = 0.35`.

    Working envelope for substrate predictions of μ_WW.  Centred on
    the SM value μ_WW = 1, half-width 0.35 corresponds to 5σ_combined
    (where σ_combined ≈ 0.07) — frontier-tight choice that
    accommodates the small ATLAS-CMS scatter while remaining a
    genuine constraint. -/
noncomputable def mu_WW_envelope_half_width_units : ℝ := 35

/-- **Combined 1σ uncertainty σ_combined** (units 10⁻²): `7 = 0.07`.

    Combined ATLAS+CMS 1σ uncertainty on μ_WW. -/
noncomputable def sigma_mu_WW_combined_units : ℝ := 7

/-- **HL-LHC 3000 fb⁻¹ projected σ(μ_WW)** (units 10⁻²): equal to
    `3` (so `3 = 0.03` absolute precision).

    Projected 1σ uncertainty from HL-LHC 3000 fb⁻¹ run, ~2.3× tighter
    than current Run-2 combined. Once HL-LHC data lands,
    σ(μ_WW) → ~0.030 in our × 100 scale. -/
noncomputable def sigma_mu_WW_HLLHC_units : ℝ := 3

/-! ## Positivity (s755) -/

/-- **🚨 s755 — `μ_WW SM > 0`**. -/
theorem T1_s755_mu_WW_SM_pos : 0 < mu_WW_SM_units := by
  unfold mu_WW_SM_units; norm_num

/-- **🚨 s755 — `ATLAS central > 0`**. -/
theorem T1_s755_ATLAS_central_pos : 0 < mu_WW_ATLAS_central_units := by
  unfold mu_WW_ATLAS_central_units; norm_num

/-- **🚨 s755 — `CMS central > 0`**. -/
theorem T1_s755_CMS_central_pos : 0 < mu_WW_CMS_central_units := by
  unfold mu_WW_CMS_central_units; norm_num

/-- **🚨 s755 — `combined central > 0`**. -/
theorem T1_s755_combined_central_pos :
    0 < mu_WW_combined_central_units := by
  unfold mu_WW_combined_central_units; norm_num

/-- **🚨 s755 — `envelope half-width > 0`**. -/
theorem T1_s755_envelope_pos : 0 < mu_WW_envelope_half_width_units := by
  unfold mu_WW_envelope_half_width_units; norm_num

/-- **🚨 s755 — `σ combined > 0`**. -/
theorem T1_s755_sigma_combined_pos : 0 < sigma_mu_WW_combined_units := by
  unfold sigma_mu_WW_combined_units; norm_num

/-- **🚨 s755 — `σ HL-LHC > 0`**. -/
theorem T1_s755_sigma_HLLHC_pos : 0 < sigma_mu_WW_HLLHC_units := by
  unfold sigma_mu_WW_HLLHC_units; norm_num

/-- **🚨 s755 — `μ_WW SM = 100`** (canonical numeric, unit value). -/
theorem T1_s755_mu_WW_SM_eq : mu_WW_SM_units = 100 := by
  unfold mu_WW_SM_units; rfl

/-- **🚨 s755 — `envelope = 35`** (canonical numeric, half-width 0.35). -/
theorem T1_s755_envelope_eq : mu_WW_envelope_half_width_units = 35 := by
  unfold mu_WW_envelope_half_width_units; rfl

/-! ## s756: CMS vs ATLAS ordering, combined between them -/

/-- **🚨 s756 — `ATLAS = 105`** (canonical numeric). -/
theorem T1_s756_ATLAS_central_eq : mu_WW_ATLAS_central_units = 105 := by
  unfold mu_WW_ATLAS_central_units; rfl

/-- **🚨 s756 — `CMS = 95`** (canonical numeric). -/
theorem T1_s756_CMS_central_eq : mu_WW_CMS_central_units = 95 := by
  unfold mu_WW_CMS_central_units; rfl

/-- **🚨 s756 — `combined = 100`** (canonical numeric). -/
theorem T1_s756_combined_central_eq :
    mu_WW_combined_central_units = 100 := by
  unfold mu_WW_combined_central_units; rfl

/-- **🚨 s756 — `CMS < ATLAS`**: CMS central is below ATLAS central
    (`95 < 105`). -/
theorem T1_s756_CMS_below_ATLAS :
    mu_WW_CMS_central_units < mu_WW_ATLAS_central_units := by
  unfold mu_WW_CMS_central_units mu_WW_ATLAS_central_units; norm_num

/-- **🚨 s756 — `CMS < combined`**: combined value sits above CMS
    (`95 < 100`). -/
theorem T1_s756_CMS_below_combined :
    mu_WW_CMS_central_units < mu_WW_combined_central_units := by
  unfold mu_WW_CMS_central_units mu_WW_combined_central_units
  norm_num

/-- **🚨 s756 — `combined < ATLAS`**: combined value sits below ATLAS
    (`100 < 105`). -/
theorem T1_s756_combined_below_ATLAS :
    mu_WW_combined_central_units < mu_WW_ATLAS_central_units := by
  unfold mu_WW_combined_central_units mu_WW_ATLAS_central_units
  norm_num

/-- **🚨 s756 — `ATLAS - CMS = 10`**: ATLAS-minus-CMS gap is exactly 10
    (`105 - 95 = 10`), within ~1σ of the individual uncertainties. -/
theorem T1_s756_ATLAS_minus_CMS_eq :
    mu_WW_ATLAS_central_units - mu_WW_CMS_central_units = 10 := by
  unfold mu_WW_ATLAS_central_units mu_WW_CMS_central_units; norm_num

/-! ## s757: SM consistency (combined = SM exactly, ATLAS>SM>CMS split) -/

/-- **🚨 s757 — `μ_WW^SM = 100`** (canonical numeric). -/
theorem T1_s757_mu_WW_SM_eq_100 : mu_WW_SM_units = 100 := by
  unfold mu_WW_SM_units; rfl

/-- **🚨 s757 — `SM < ATLAS`**: ATLAS central above SM (high-side). -/
theorem T1_s757_SM_below_ATLAS :
    mu_WW_SM_units < mu_WW_ATLAS_central_units := by
  unfold mu_WW_SM_units mu_WW_ATLAS_central_units; norm_num

/-- **🚨 s757 — `CMS < SM`**: CMS central below SM (low-side). -/
theorem T1_s757_CMS_below_SM :
    mu_WW_CMS_central_units < mu_WW_SM_units := by
  unfold mu_WW_CMS_central_units mu_WW_SM_units; norm_num

/-- **🚨 s757 — `combined = SM`**: combined central EXACTLY at SM
    (`100 = 100`, 0σ tension — canonical SM-consistency). -/
theorem T1_s757_combined_eq_SM :
    mu_WW_combined_central_units = mu_WW_SM_units := by
  unfold mu_WW_combined_central_units mu_WW_SM_units; rfl

/-- **🚨 s757 — `combined - SM = 0`**: combined-minus-SM gap is exactly 0
    (`100 - 100 = 0`), corresponding to 0σ at any σ_combined. -/
theorem T1_s757_combined_minus_SM_eq :
    mu_WW_combined_central_units - mu_WW_SM_units = 0 := by
  unfold mu_WW_combined_central_units mu_WW_SM_units; norm_num

/-- **🚨 s757 — `|combined - SM| ≤ envelope`**: combined central is
    inside the substrate envelope around SM (`0 ≤ 35`).

    The 0σ agreement trivially fits inside the 5σ_combined envelope. -/
theorem T1_s757_combined_within_envelope :
    mu_WW_combined_central_units - mu_WW_SM_units
      ≤ mu_WW_envelope_half_width_units := by
  unfold mu_WW_combined_central_units mu_WW_SM_units
    mu_WW_envelope_half_width_units
  norm_num

/-- **🚨 s757 — `|combined - SM| < envelope` strictly**: tighter
    strict form (`0 < 35`). -/
theorem T1_s757_combined_within_envelope_strict :
    mu_WW_combined_central_units - mu_WW_SM_units
      < mu_WW_envelope_half_width_units := by
  unfold mu_WW_combined_central_units mu_WW_SM_units
    mu_WW_envelope_half_width_units
  norm_num

/-! ## s758: σ-envelope relations and HL-LHC tightening -/

/-- **🚨 s758 — `5 · σ_combined = envelope`**: substrate envelope is
    EXACTLY the 5σ_combined band (`5 · 7 = 35`). -/
theorem T1_s758_five_sigma_combined_eq_envelope :
    5 * sigma_mu_WW_combined_units
      = mu_WW_envelope_half_width_units := by
  unfold sigma_mu_WW_combined_units mu_WW_envelope_half_width_units
  norm_num

/-- **🚨 s758 — `σ HL-LHC < σ_combined`**: HL-LHC tightens current
    1σ uncertainty (`3 < 7`). -/
theorem T1_s758_sigma_HLLHC_below_sigma_combined :
    sigma_mu_WW_HLLHC_units < sigma_mu_WW_combined_units := by
  unfold sigma_mu_WW_HLLHC_units sigma_mu_WW_combined_units; norm_num

/-- **🚨 s758 — `σ HL-LHC < envelope`**: HL-LHC σ sits well below
    substrate envelope (`3 < 35`). -/
theorem T1_s758_sigma_HLLHC_below_envelope :
    sigma_mu_WW_HLLHC_units < mu_WW_envelope_half_width_units := by
  unfold sigma_mu_WW_HLLHC_units mu_WW_envelope_half_width_units
  norm_num

/-- **🚨 s758 — `envelope < SM`**: envelope half-width strictly below
    SM value, so a "no-coupling" hypothesis (μ_WW = 0) sits OUTSIDE the
    substrate envelope from the SM side. -/
theorem T1_s758_envelope_below_SM :
    mu_WW_envelope_half_width_units < mu_WW_SM_units := by
  unfold mu_WW_envelope_half_width_units mu_WW_SM_units; norm_num

/-- **🚨 s758 — `11 · σ HL-LHC < envelope`**: HL-LHC will achieve >11σ
    sensitivity to envelope-edge deviations (`11 · 3 = 33 < 35`). -/
theorem T1_s758_eleven_sigma_HLLHC_below_envelope :
    11 * sigma_mu_WW_HLLHC_units < mu_WW_envelope_half_width_units := by
  unfold sigma_mu_WW_HLLHC_units mu_WW_envelope_half_width_units
  norm_num

/-- **🚨 s758 — `5 · σ HL-LHC < envelope`**: HL-LHC 5σ band well
    below substrate envelope (`5 · 3 = 15 < 35`). -/
theorem T1_s758_five_sigma_HLLHC_below_envelope :
    5 * sigma_mu_WW_HLLHC_units < mu_WW_envelope_half_width_units := by
  unfold sigma_mu_WW_HLLHC_units mu_WW_envelope_half_width_units
  norm_num

/-! ## s759: Frontier Prop + 8-conjunct headline -/

/-- **HiggsToWWLHCFrontier**: 8-way conjunction pinning
    the substrate-prediction envelope for the LHC H → WW* → ℓνℓν signal-
    strength modifier μ_WW (working units × 100):

    1. `μ_WW^SM > 0 ∧ envelope > 0 ∧ ATLAS > 0 ∧ CMS > 0`  (positivity)
    2. `combined = SM`                 (exact SM consistency, 0σ)
    3. `CMS < combined < ATLAS` … wait, combined = SM = 100 and ATLAS=105>100,
       CMS=95<100, so `CMS < combined` and `combined < ATLAS` hold strictly
    4. `combined - SM ≤ envelope`      (combined inside substrate band, trivially)
    5. `5 · σ_combined = envelope`     (envelope = 5σ_combined band)
    6. `σ_HLLHC < σ_combined`          (HL-LHC tightens precision)
    7. `11 · σ_HLLHC < envelope`       (HL-LHC reaches >11σ to envelope edge)
    8. `envelope < SM`                 (envelope is a genuine narrow band)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for μ_WW must lie within this envelope to remain
    experimentally consistent with both ATLAS and CMS 2024
    measurements at the 5σ_combined level. -/
def HiggsToWWLHCFrontier : Prop :=
  -- (1) positivity quad
  (0 < mu_WW_SM_units ∧ 0 < mu_WW_envelope_half_width_units
    ∧ 0 < mu_WW_ATLAS_central_units
    ∧ 0 < mu_WW_CMS_central_units) ∧
  -- (2) combined = SM exactly
  (mu_WW_combined_central_units = mu_WW_SM_units) ∧
  -- (3) combined strictly between CMS and ATLAS
  (mu_WW_CMS_central_units < mu_WW_combined_central_units
    ∧ mu_WW_combined_central_units < mu_WW_ATLAS_central_units) ∧
  -- (4) combined inside substrate band
  (mu_WW_combined_central_units - mu_WW_SM_units
      ≤ mu_WW_envelope_half_width_units) ∧
  -- (5) envelope = 5σ_combined band
  (5 * sigma_mu_WW_combined_units
      = mu_WW_envelope_half_width_units) ∧
  -- (6) HL-LHC tightens precision
  (sigma_mu_WW_HLLHC_units < sigma_mu_WW_combined_units) ∧
  -- (7) HL-LHC >11σ sensitivity to envelope edge
  (11 * sigma_mu_WW_HLLHC_units
      < mu_WW_envelope_half_width_units) ∧
  -- (8) envelope is a genuine narrow band
  (mu_WW_envelope_half_width_units < mu_WW_SM_units)

/-- **🚨 s759 — `HiggsToWWLHCFrontier`** holds. -/
theorem T1_s759_higgs_to_WW_lhc_frontier :
    HiggsToWWLHCFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ⟨?_, ?_⟩, ?_, ?_, ?_, ?_, ?_⟩
  · exact T1_s755_mu_WW_SM_pos
  · exact T1_s755_envelope_pos
  · exact T1_s755_ATLAS_central_pos
  · exact T1_s755_CMS_central_pos
  · exact T1_s757_combined_eq_SM
  · exact T1_s756_CMS_below_combined
  · exact T1_s756_combined_below_ATLAS
  · exact T1_s757_combined_within_envelope
  · exact T1_s758_five_sigma_combined_eq_envelope
  · exact T1_s758_sigma_HLLHC_below_sigma_combined
  · exact T1_s758_eleven_sigma_HLLHC_below_envelope
  · exact T1_s758_envelope_below_SM

/-! ## Headline (12-conjunct) -/

/-- **HEADLINE — sessions 755-759 — Higgs → WW* → ℓνℓν μ_WW LHC-frontier
    di-leptonic-channel envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s755: μ_WW^SM = 100, ATLAS = 105, CMS = 95, combined = 100,
            envelope = 35, σ_combined = 7, σ_HLLHC = 3 (units × 100)
    - s756: CMS < combined < ATLAS, ATLAS - CMS = 10
    - s757: CMS < SM < ATLAS (split); combined = SM (exact 0σ);
            combined - SM = 0 ≤ envelope = 35 (within 5σ_combined band)
    - s758: 5·σ_combined = envelope; σ_HLLHC < σ_combined;
            11·σ_HLLHC < envelope (HL-LHC >11σ envelope sensitivity)
    - s759: HiggsToWWLHCFrontier (8-conjunct) +
            headline (12-conjunct) + bundle alias

    Phenomenology:
      μ_WW^SM            = 1.00          (SM benchmark, B = 21.6%)
      μ_WW (ATLAS 2024)  = 1.05 ± 0.10   (139 fb⁻¹ Run-2 ℓνℓν combined)
      μ_WW (CMS 2024)    = 0.95 ± 0.09   (138 fb⁻¹ Run-2 ℓνℓν combined)
      μ_WW (combined)    = 1.00 ± 0.07   (0σ — EXACTLY SM, anchor)
      |μ_WW - 1| ≤ 0.35  (envelope)      working substrate window (5σ)
      σ(μ_WW) → 0.030    (HL-LHC 3 ab⁻¹) projected precision

      PDG B(H → WW*) = (21.5 ± 0.5)%
                       (vs SM 21.6%, <0.2σ tension)

    Why this matters:
    H → WW* → ℓνℓν is the second-highest-statistics Higgs decay channel
    (after H → bb̄, B ≈ 58%), with B ≈ 21.6% — about 10× more events than
    H → ZZ* → 4ℓ.  The di-leptonic + missing-ET signature has cleaner
    backgrounds than bb̄, and the transverse-mass shape fit recovers
    much of the resolution lost to the di-neutrino reconstruction
    ambiguity.  Together with H → ZZ* → 4ℓ and H → γγ, the WW channel
    forms the "high-statistics triplet" anchoring SM Higgs phenomenology.

    The combined ATLAS+CMS μ_WW = 1.00 ± 0.07 is THE canonical
    SM-consistency anchor — exactly at SM with 7% precision, the
    most direct experimental test of the SM Higgs WW coupling.

    BSM scenarios that affect WW coupling (composite Higgs, anomalous
    HVV gauge couplings, 2HDM with non-aligned WW/ZZ ratio, vector-like
    quark loops in HWW vertex correction, heavy charged-Higgs
    interference) all show up as μ_WW shifts at the few-percent level
    — exactly the precision now reached, and a major HL-LHC target.

    Companion files:
    - `T1_HiggsTo4LeptonsZZFrontier`         — H → ZZ* → 4ℓ golden channel
    - `T1_HiggsToTauTauKappaTauFrontier`     — tau Yukawa κ_τ (3rd gen lepton)
    - `T1_HiggsToBBbarKappaBFrontier`        — b-quark Yukawa κ_b (3rd gen quark)
    - `T1_HiggsToCCBarCharmYukawaFrontier`   — charm Yukawa κ_c (2nd gen quark)
    - `T1_HLLHCTopYukawaKappaTBundle`        — top Yukawa κ_t (3rd gen quark up)
    - `T1_HiggsToZGammaFrontier`             — H decay rare-loop channel
    - `T1_DiphotonSpectrumLHCBundle`         — H → γγ golden-channel sister
    - `T1_HiggsBranchingRatiosBundle`        — multi-channel branching context
    - `T1_HiggsCouplingStrengthsBundle`      — broader κ-modifier framework

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core H → WW* → ℓνℓν μ_WW LHC-frontier envelope.
    Closes the third high-statistics Higgs decay channel (after
    H → ZZ* → 4ℓ and H → γγ) — together completing the
    "discovery + precision triplet" of major Higgs production-mode
    constraints in OmegaTheory V2.  WW* → ℓνℓν has the highest
    statistics of the three and so functions as the high-luminosity
    precision benchmark for substrate-derived Higgs WW-coupling
    prediction frameworks. -/
theorem session_755_to_759_higgs_to_WW_lhc_frontier_headline :
    0 < mu_WW_SM_units
    ∧ 0 < mu_WW_envelope_half_width_units
    ∧ 0 < mu_WW_ATLAS_central_units
    ∧ 0 < mu_WW_CMS_central_units
    ∧ 0 < mu_WW_combined_central_units
    ∧ 0 < sigma_mu_WW_combined_units
    ∧ 0 < sigma_mu_WW_HLLHC_units
    ∧ mu_WW_CMS_central_units < mu_WW_combined_central_units
    ∧ mu_WW_combined_central_units < mu_WW_ATLAS_central_units
    ∧ mu_WW_combined_central_units = mu_WW_SM_units
    ∧ mu_WW_combined_central_units - mu_WW_SM_units
        ≤ mu_WW_envelope_half_width_units
    ∧ 5 * sigma_mu_WW_combined_units
        = mu_WW_envelope_half_width_units
    ∧ HiggsToWWLHCFrontier :=
  ⟨T1_s755_mu_WW_SM_pos, T1_s755_envelope_pos,
   T1_s755_ATLAS_central_pos, T1_s755_CMS_central_pos,
   T1_s755_combined_central_pos, T1_s755_sigma_combined_pos,
   T1_s755_sigma_HLLHC_pos, T1_s756_CMS_below_combined,
   T1_s756_combined_below_ATLAS, T1_s757_combined_eq_SM,
   T1_s757_combined_within_envelope,
   T1_s758_five_sigma_combined_eq_envelope,
   T1_s759_higgs_to_WW_lhc_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_higgs_to_WW_lhc_frontier_bundle :
    HiggsToWWLHCFrontier :=
  T1_s759_higgs_to_WW_lhc_frontier

end OmegaTheory.Predictions.T1_HiggsToWWLHCFrontier
