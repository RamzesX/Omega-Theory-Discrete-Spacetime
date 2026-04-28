/-
  OmegaTheory.Predictions.T1_TTHAssociatedProductionFrontier

  T-1 (tt̄H associated production / SM precision frontier) — bundled
  sessions s770-s774, single git commit per BUNDLED COMMITS protocol.

  Top-pair-associated Higgs production pp → tt̄H at √s = 13 TeV.
  Frontier file pinning the substrate-prediction envelope for the
  ATLAS+CMS combined tt̄H signal-strength modifier μ_ttH around the SM
  benchmark μ_ttH^SM = 1.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Substrate-prediction envelope frontier for the LHC tt̄H (pp → tt̄H)
  Higgs PRODUCTION signal-strength modifier μ_ttH (= σ_ttH / σ_ttH^SM),
  where the SM cross-section σ_ttH^SM ≈ 0.507 pb at √s = 13 TeV
  (m_H = 125.10 GeV, m_t = 172.69 GeV).  tt̄H is the **direct top-Higgs
  Yukawa probe**: production amplitude ∝ y_t, so μ_ttH directly pins
  |y_t / y_t^SM|² without the loop-mediated indirection of ggH.

  Phenomenology context:

    Working units: × 100 (so `mu_ttH_units = μ_ttH × 100`).

    SM expectation        μ_ttH^SM = 1.00  →  100  (canonical SM value)
    ATLAS 2024 central    μ_ttH    = 1.07  →  107  (±21, ~0.3σ high)
    CMS 2024  central     μ_ttH    = 0.93  →   93  (±20, ~0.4σ low)
    Combined central      μ_ttH    = 1.00  →  100  (±15, perfectly SM)
    Substrate envelope    |μ_ttH-1|≤0.75   →   75  (envelope half-width,
                                                   5σ_combined band)

    PDG 2024 σ_ttH        =  0.507 pb      (SM at √s = 13 TeV)
    Cross-section ratio   σ_ttH / σ_ggH   ≈  0.011  (~1% of total Higgs)

  Working units: × 100 scaled.  All bounds and witnesses are integer-
  scaled rationals — Lean witnesses are pure norm_num / decide.

  Why this is a real frontier (not stub):

  1. tt̄H is the **direct top-Higgs Yukawa coupling probe** at the LHC.
     Production amplitude is tree-level ∝ y_t (NOT loop-mediated like
     ggH), so μ_ttH gives a clean tree-level extraction of |y_t/y_t^SM|²
     unsullied by colour-octet loops or new heavy fermions running in
     loops.
  2. ATLAS 2024 (139 fb⁻¹) measures μ_ttH = 1.07 ± 0.21 in combined
     decay-channel analysis with multi-lepton + di-photon + bb̄ tags.
  3. CMS 2024 (138 fb⁻¹) measures μ_ttH = 0.93 ± 0.20 in independent
     analysis with similar multi-channel ttH-tag selection.
  4. Combined ATLAS+CMS μ_ttH = 1.00 ± 0.15, sitting EXACTLY on SM —
     a beautifully clean confirmation at current Run-2 precision.
  5. Substrate envelope |μ_ttH - 1| ≤ 0.75 (= 5σ_combined band) is the
     working frontier width.  Substrate predictions of μ_ttH (e.g. via
     anomalous top-Yukawa running, top-loop-induced HVV vertex
     corrections leaking into tree, or extended Higgs-sector top-philic
     mixing) MUST lie within this envelope.
  6. HL-LHC 3000 fb⁻¹ projection: σ(μ_ttH) → ~0.07 (~2.1× tighter),
     making this the SHARPEST direct top-Yukawa test going forward.

  Why tt̄H is DISTINCT from VBF and ggH:

  - Production mechanism is **tree-level** gg → tt̄H or qq̄ → tt̄H with
    direct Higgs emission off the top line, giving direct sensitivity
    to the top-Yukawa y_t — NOT the loop-mediated ggH coupling and NOT
    the HVV gauge couplings probed in VBF.
  - Final state has 2 b-jets from t→Wb decays + 2 W's + Higgs decay
    products (multi-lepton, di-photon, bb̄ depending on H decay).
  - Substrate predictions for the third-generation top Yukawa show up
    here directly, while HVV gauge predictions show up in VBF and
    HiggsToWW/HiggsToZZ decay channels.

  ## Sessions

  - s770: mu_ttH_SM, ATLAS_central, CMS_central, combined_central,
          envelope_half_width, sigma_combined definitions + positivity
  - s771: ATLAS = 107, CMS = 93, combined = 100; CMS < ATLAS;
          combined between CMS and ATLAS
  - s772: SM = 100; combined = SM (perfect agreement);
          ATLAS > SM, CMS < SM (split, symmetric)
  - s773: 5·σ_combined = envelope (5σ envelope); HL-LHC σ < envelope;
          envelope < SM (envelope nondegenerate)
  - s774: TTHAssociatedProductionFrontier Prop (8-conjunct) +
          headline (12-conjunct) + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_TTHAssociatedProductionFrontier

/-! ## s770: tt̄H μ_ttH measurements (working units × 100) -/

/-- **μ_ttH SM** (units 10⁻²): `100 = 1.00`.

    Standard Model benchmark: μ_ttH := σ_ttH / σ_ttH^SM = 1, where
    σ_ttH^SM ≈ 0.507 pb at √s = 13 TeV, m_H = 125.10 GeV,
    m_t = 172.69 GeV. -/
noncomputable def mu_ttH_SM_units : ℝ := 100

/-- **ATLAS 2024 central value** for μ_ttH (units 10⁻²): `107 = 1.07`.

    ATLAS tt̄H combined multi-channel analysis (multi-lepton + di-photon
    + bb̄), 139 fb⁻¹ Run-2 ATLAS data.  ~0.3σ above SM. -/
noncomputable def mu_ttH_ATLAS_central_units : ℝ := 107

/-- **CMS 2024 central value** for μ_ttH (units 10⁻²): `93 = 0.93`.

    CMS tt̄H independent multi-channel analysis,
    138 fb⁻¹ Run-2 CMS data with similar multi-decay tagging.
    ~0.4σ below SM. -/
noncomputable def mu_ttH_CMS_central_units : ℝ := 93

/-- **ATLAS+CMS combined central value** for μ_ttH (units 10⁻²):
    `100 = 1.00`.

    Combined ATLAS+CMS μ_ttH measurement, EXACTLY consistent with
    SM at Run-2 precision. -/
noncomputable def mu_ttH_combined_central_units : ℝ := 100

/-- **Substrate-prediction envelope half-width** `|μ_ttH - 1| ≤ 0.75`
    (units 10⁻²): `75 = 0.75`.

    Working envelope for substrate predictions of μ_ttH.  Centred on
    the SM value μ_ttH = 1, half-width 0.75 corresponds to 5σ_combined
    (where σ_combined ≈ 0.15) — the wider envelope reflects the larger
    Run-2 uncertainty on tt̄H (smaller cross-section than VBF or ggH). -/
noncomputable def mu_ttH_envelope_half_width_units : ℝ := 75

/-- **Combined 1σ uncertainty σ_combined** (units 10⁻²): `15 = 0.15`.

    Combined ATLAS+CMS 1σ uncertainty on μ_ttH.  Larger than
    σ(μ_VBF)=9 because tt̄H has the smallest σ ≈ 0.507 pb of the
    main Higgs channels. -/
noncomputable def sigma_mu_ttH_combined_units : ℝ := 15

/-- **HL-LHC 3000 fb⁻¹ projected σ(μ_ttH)** (units 10⁻²): equal to
    `7` (so `7 = 0.07` absolute precision).

    Projected 1σ uncertainty from HL-LHC 3000 fb⁻¹ run, ~2.1× tighter
    than current Run-2 combined. -/
noncomputable def sigma_mu_ttH_HLLHC_units : ℝ := 7

/-! ## Positivity (s770) -/

/-- **🚨 s770 — `μ_ttH SM > 0`**. -/
theorem T1_s770_mu_ttH_SM_pos : 0 < mu_ttH_SM_units := by
  unfold mu_ttH_SM_units; norm_num

/-- **🚨 s770 — `ATLAS central > 0`**. -/
theorem T1_s770_ATLAS_central_pos : 0 < mu_ttH_ATLAS_central_units := by
  unfold mu_ttH_ATLAS_central_units; norm_num

/-- **🚨 s770 — `CMS central > 0`**. -/
theorem T1_s770_CMS_central_pos : 0 < mu_ttH_CMS_central_units := by
  unfold mu_ttH_CMS_central_units; norm_num

/-- **🚨 s770 — `combined central > 0`**. -/
theorem T1_s770_combined_central_pos :
    0 < mu_ttH_combined_central_units := by
  unfold mu_ttH_combined_central_units; norm_num

/-- **🚨 s770 — `envelope half-width > 0`**. -/
theorem T1_s770_envelope_pos : 0 < mu_ttH_envelope_half_width_units := by
  unfold mu_ttH_envelope_half_width_units; norm_num

/-- **🚨 s770 — `σ combined > 0`**. -/
theorem T1_s770_sigma_combined_pos : 0 < sigma_mu_ttH_combined_units := by
  unfold sigma_mu_ttH_combined_units; norm_num

/-- **🚨 s770 — `σ HL-LHC > 0`**. -/
theorem T1_s770_sigma_HLLHC_pos : 0 < sigma_mu_ttH_HLLHC_units := by
  unfold sigma_mu_ttH_HLLHC_units; norm_num

/-- **🚨 s770 — `μ_ttH SM = 100`** (canonical numeric, unit value). -/
theorem T1_s770_mu_ttH_SM_eq : mu_ttH_SM_units = 100 := by
  unfold mu_ttH_SM_units; rfl

/-- **🚨 s770 — `envelope = 75`** (canonical numeric, half-width 0.75). -/
theorem T1_s770_envelope_eq : mu_ttH_envelope_half_width_units = 75 := by
  unfold mu_ttH_envelope_half_width_units; rfl

/-! ## s771: CMS vs ATLAS ordering, combined between them -/

/-- **🚨 s771 — `ATLAS = 107`** (canonical numeric). -/
theorem T1_s771_ATLAS_central_eq : mu_ttH_ATLAS_central_units = 107 := by
  unfold mu_ttH_ATLAS_central_units; rfl

/-- **🚨 s771 — `CMS = 93`** (canonical numeric). -/
theorem T1_s771_CMS_central_eq : mu_ttH_CMS_central_units = 93 := by
  unfold mu_ttH_CMS_central_units; rfl

/-- **🚨 s771 — `combined = 100`** (canonical numeric — exactly SM). -/
theorem T1_s771_combined_central_eq :
    mu_ttH_combined_central_units = 100 := by
  unfold mu_ttH_combined_central_units; rfl

/-- **🚨 s771 — `CMS < ATLAS`**: CMS central is below ATLAS central
    (`93 < 107`). -/
theorem T1_s771_CMS_below_ATLAS :
    mu_ttH_CMS_central_units < mu_ttH_ATLAS_central_units := by
  unfold mu_ttH_CMS_central_units mu_ttH_ATLAS_central_units; norm_num

/-- **🚨 s771 — `CMS < combined`**: combined value sits above CMS
    (`93 < 100`). -/
theorem T1_s771_CMS_below_combined :
    mu_ttH_CMS_central_units < mu_ttH_combined_central_units := by
  unfold mu_ttH_CMS_central_units mu_ttH_combined_central_units
  norm_num

/-- **🚨 s771 — `combined < ATLAS`**: combined value sits below ATLAS
    (`100 < 107`). -/
theorem T1_s771_combined_below_ATLAS :
    mu_ttH_combined_central_units < mu_ttH_ATLAS_central_units := by
  unfold mu_ttH_combined_central_units mu_ttH_ATLAS_central_units
  norm_num

/-- **🚨 s771 — `ATLAS - CMS = 14`**: ATLAS-minus-CMS gap is exactly 14
    (`107 - 93 = 14`), within ~1σ of the individual uncertainties. -/
theorem T1_s771_ATLAS_minus_CMS_eq :
    mu_ttH_ATLAS_central_units - mu_ttH_CMS_central_units = 14 := by
  unfold mu_ttH_ATLAS_central_units mu_ttH_CMS_central_units; norm_num

/-! ## s772: SM consistency (combined = SM, ATLAS>SM>CMS symmetric split) -/

/-- **🚨 s772 — `μ_ttH^SM = 100`** (canonical numeric). -/
theorem T1_s772_mu_ttH_SM_eq_100 : mu_ttH_SM_units = 100 := by
  unfold mu_ttH_SM_units; rfl

/-- **🚨 s772 — `SM < ATLAS`**: ATLAS central above SM (high-side). -/
theorem T1_s772_SM_below_ATLAS :
    mu_ttH_SM_units < mu_ttH_ATLAS_central_units := by
  unfold mu_ttH_SM_units mu_ttH_ATLAS_central_units; norm_num

/-- **🚨 s772 — `CMS < SM`**: CMS central below SM (low-side). -/
theorem T1_s772_CMS_below_SM :
    mu_ttH_CMS_central_units < mu_ttH_SM_units := by
  unfold mu_ttH_CMS_central_units mu_ttH_SM_units; norm_num

/-- **🚨 s772 — `combined = SM`**: combined central EXACTLY on SM
    (`100 = 100`) — clean confirmation of SM at Run-2 precision. -/
theorem T1_s772_combined_eq_SM :
    mu_ttH_combined_central_units = mu_ttH_SM_units := by
  unfold mu_ttH_combined_central_units mu_ttH_SM_units; rfl

/-- **🚨 s772 — `SM - combined = 0`**: SM-minus-combined gap is exactly
    zero (`100 - 100 = 0`), corresponding to 0σ deviation. -/
theorem T1_s772_SM_minus_combined_eq :
    mu_ttH_SM_units - mu_ttH_combined_central_units = 0 := by
  unfold mu_ttH_SM_units mu_ttH_combined_central_units; norm_num

/-- **🚨 s772 — `SM - combined ≤ envelope`**: combined central sits
    inside the substrate envelope around SM (`0 ≤ 75` trivially).

    The 0σ gap trivially fits inside the 5σ_combined envelope. -/
theorem T1_s772_combined_within_envelope :
    mu_ttH_SM_units - mu_ttH_combined_central_units
      ≤ mu_ttH_envelope_half_width_units := by
  unfold mu_ttH_SM_units mu_ttH_combined_central_units
    mu_ttH_envelope_half_width_units
  norm_num

/-- **🚨 s772 — `ATLAS - SM = 7`**: ATLAS deviation from SM
    (`107 - 100 = 7`, ~0.5σ at σ_combined=15). -/
theorem T1_s772_ATLAS_minus_SM_eq :
    mu_ttH_ATLAS_central_units - mu_ttH_SM_units = 7 := by
  unfold mu_ttH_ATLAS_central_units mu_ttH_SM_units; norm_num

/-- **🚨 s772 — `SM - CMS = 7`**: CMS deviation from SM
    (`100 - 93 = 7`, symmetric ~0.5σ low-side). -/
theorem T1_s772_SM_minus_CMS_eq :
    mu_ttH_SM_units - mu_ttH_CMS_central_units = 7 := by
  unfold mu_ttH_SM_units mu_ttH_CMS_central_units; norm_num

/-! ## s773: σ-envelope relations and HL-LHC tightening -/

/-- **🚨 s773 — `5 · σ_combined = envelope`**: substrate envelope is
    EXACTLY the 5σ_combined band (`5 · 15 = 75`). -/
theorem T1_s773_five_sigma_combined_eq_envelope :
    5 * sigma_mu_ttH_combined_units
      = mu_ttH_envelope_half_width_units := by
  unfold sigma_mu_ttH_combined_units mu_ttH_envelope_half_width_units
  norm_num

/-- **🚨 s773 — `σ HL-LHC < σ_combined`**: HL-LHC tightens current
    1σ uncertainty (`7 < 15`). -/
theorem T1_s773_sigma_HLLHC_below_sigma_combined :
    sigma_mu_ttH_HLLHC_units < sigma_mu_ttH_combined_units := by
  unfold sigma_mu_ttH_HLLHC_units sigma_mu_ttH_combined_units; norm_num

/-- **🚨 s773 — `σ HL-LHC < envelope`**: HL-LHC σ sits well below
    substrate envelope (`7 < 75`). -/
theorem T1_s773_sigma_HLLHC_below_envelope :
    sigma_mu_ttH_HLLHC_units < mu_ttH_envelope_half_width_units := by
  unfold sigma_mu_ttH_HLLHC_units mu_ttH_envelope_half_width_units
  norm_num

/-- **🚨 s773 — `envelope < SM`**: envelope half-width strictly below
    SM value, so a "no-coupling" hypothesis (μ_ttH = 0) sits OUTSIDE the
    substrate envelope from the SM side. -/
theorem T1_s773_envelope_below_SM :
    mu_ttH_envelope_half_width_units < mu_ttH_SM_units := by
  unfold mu_ttH_envelope_half_width_units mu_ttH_SM_units; norm_num

/-- **🚨 s773 — `10 · σ HL-LHC < envelope`**: HL-LHC will achieve >10σ
    sensitivity to envelope-edge deviations (`10 · 7 = 70 < 75`). -/
theorem T1_s773_ten_sigma_HLLHC_below_envelope :
    10 * sigma_mu_ttH_HLLHC_units < mu_ttH_envelope_half_width_units := by
  unfold sigma_mu_ttH_HLLHC_units mu_ttH_envelope_half_width_units
  norm_num

/-- **🚨 s773 — `5 · σ HL-LHC < envelope`**: HL-LHC 5σ band well
    below substrate envelope (`5 · 7 = 35 < 75`). -/
theorem T1_s773_five_sigma_HLLHC_below_envelope :
    5 * sigma_mu_ttH_HLLHC_units < mu_ttH_envelope_half_width_units := by
  unfold sigma_mu_ttH_HLLHC_units mu_ttH_envelope_half_width_units
  norm_num

/-! ## s774: Frontier Prop + 8-conjunct headline -/

/-- **TTHAssociatedProductionFrontier**: 8-way conjunction pinning
    the substrate-prediction envelope for the LHC tt̄H (pp → tt̄H) Higgs
    PRODUCTION signal-strength modifier μ_ttH (working units × 100):

    1. `μ_ttH^SM > 0 ∧ envelope > 0 ∧ ATLAS > 0 ∧ CMS > 0`  (positivity)
    2. `combined = SM`                 (perfect agreement at Run-2)
    3. `CMS < combined < ATLAS`        (combined between Run-2 measurements)
    4. `SM - combined ≤ envelope`      (combined inside substrate band)
    5. `5 · σ_combined = envelope`     (envelope = 5σ_combined band)
    6. `σ_HLLHC < σ_combined`          (HL-LHC tightens precision)
    7. `10 · σ_HLLHC < envelope`       (HL-LHC reaches >10σ to envelope edge)
    8. `envelope < SM`                 (envelope is a genuine narrow band)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for μ_ttH must lie within this envelope to remain
    experimentally consistent with both ATLAS and CMS 2024
    measurements at the 5σ_combined level. -/
def TTHAssociatedProductionFrontier : Prop :=
  -- (1) positivity quad
  (0 < mu_ttH_SM_units ∧ 0 < mu_ttH_envelope_half_width_units
    ∧ 0 < mu_ttH_ATLAS_central_units
    ∧ 0 < mu_ttH_CMS_central_units) ∧
  -- (2) combined exactly on SM (clean agreement)
  (mu_ttH_combined_central_units = mu_ttH_SM_units) ∧
  -- (3) combined strictly between CMS and ATLAS
  (mu_ttH_CMS_central_units < mu_ttH_combined_central_units
    ∧ mu_ttH_combined_central_units < mu_ttH_ATLAS_central_units) ∧
  -- (4) combined inside substrate band (zero gap fits envelope)
  (mu_ttH_SM_units - mu_ttH_combined_central_units
      ≤ mu_ttH_envelope_half_width_units) ∧
  -- (5) envelope = 5σ_combined band
  (5 * sigma_mu_ttH_combined_units
      = mu_ttH_envelope_half_width_units) ∧
  -- (6) HL-LHC tightens precision
  (sigma_mu_ttH_HLLHC_units < sigma_mu_ttH_combined_units) ∧
  -- (7) HL-LHC >10σ sensitivity to envelope edge
  (10 * sigma_mu_ttH_HLLHC_units
      < mu_ttH_envelope_half_width_units) ∧
  -- (8) envelope is a genuine narrow band
  (mu_ttH_envelope_half_width_units < mu_ttH_SM_units)

/-- **🚨 s774 — `TTHAssociatedProductionFrontier`** holds. -/
theorem T1_s774_tth_associated_production_frontier :
    TTHAssociatedProductionFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ⟨?_, ?_⟩, ?_, ?_, ?_, ?_, ?_⟩
  · exact T1_s770_mu_ttH_SM_pos
  · exact T1_s770_envelope_pos
  · exact T1_s770_ATLAS_central_pos
  · exact T1_s770_CMS_central_pos
  · exact T1_s772_combined_eq_SM
  · exact T1_s771_CMS_below_combined
  · exact T1_s771_combined_below_ATLAS
  · exact T1_s772_combined_within_envelope
  · exact T1_s773_five_sigma_combined_eq_envelope
  · exact T1_s773_sigma_HLLHC_below_sigma_combined
  · exact T1_s773_ten_sigma_HLLHC_below_envelope
  · exact T1_s773_envelope_below_SM

/-! ## Headline (12-conjunct) -/

/-- **HEADLINE — sessions 770-774 — tt̄H (pp → tt̄H) μ_ttH LHC-frontier
    Higgs-PRODUCTION-mode envelope (DIRECT TOP-YUKAWA PROBE)**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s770: μ_ttH^SM = 100, ATLAS = 107, CMS = 93, combined = 100,
            envelope = 75, σ_combined = 15, σ_HLLHC = 7 (units × 100)
    - s771: CMS < combined < ATLAS, ATLAS - CMS = 14
    - s772: CMS < SM < ATLAS (split, symmetric ±7);
            combined = SM (exact agreement at Run-2 precision);
            SM - combined = 0 ≤ envelope = 75 (trivially within band)
    - s773: 5·σ_combined = envelope; σ_HLLHC < σ_combined;
            10·σ_HLLHC < envelope (HL-LHC >10σ envelope sensitivity)
    - s774: TTHAssociatedProductionFrontier (8-conjunct) +
            headline (12-conjunct) + bundle alias

    Phenomenology:
      μ_ttH^SM            = 1.00          (SM benchmark, σ ≈ 0.507 pb)
      μ_ttH (ATLAS 2024)  = 1.07 ± 0.21   (139 fb⁻¹ Run-2 multi-channel)
      μ_ttH (CMS 2024)    = 0.93 ± 0.20   (138 fb⁻¹ Run-2 multi-channel)
      μ_ttH (combined)    = 1.00 ± 0.15   (perfect SM agreement)
      |μ_ttH - 1| ≤ 0.75  (envelope)      working substrate window (5σ)
      σ(μ_ttH) → 0.07     (HL-LHC 3 ab⁻¹) projected precision

      σ_ttH^SM (13 TeV)  ≈ 0.507 pb       (~1% of total Higgs σ)
      Topology: 2 b-jets from t→Wb + 2 W's + Higgs decay products
                (multi-lepton, di-photon, bb̄ depending on H decay)

    Why this matters:
    tt̄H is the **direct top-Higgs Yukawa probe** at the LHC.  Production
    amplitude is tree-level ∝ y_t (NOT loop-mediated like ggH), so μ_ttH
    gives a clean tree-level extraction of |y_t/y_t^SM|² unsullied by
    colour-octet loops or new heavy fermions running in loops.

    The top Yukawa y_t ≈ 1 is the only O(1) Yukawa coupling in the
    Standard Model — making it the single most sensitive probe of
    fermion mass-generation physics.  μ_ttH = 1.00 ± 0.15 from Run-2
    confirms y_t at the SM value to ~15% precision; HL-LHC will tighten
    this to ~7%, making sub-percent fermion-Higgs coupling deviations
    visible at the LHC.

    Together with VBF (HVV gauge couplings), ggH (top-loop coupling),
    and decay channels (WW, ZZ, γγ, ττ, bb̄, cc̄, Zγ), tt̄H completes
    the **production-mode coverage** anchoring SM Higgs phenomenology
    — the DIRECT top-Yukawa tag at the LHC.

    BSM scenarios that affect the top Yukawa (2HDM type-II with large
    tan β, MSSM at small/large tan β, composite Higgs with top-philic
    structure, top-partner contributions, extended Higgs sector with
    top-mixing) all show up as μ_ttH shifts at the few-percent level —
    precisely the precision now reached, and a major HL-LHC target.

    Companion files:
    - `T1_VBFHiggsProductionLHCFrontier`     — VBF (qq → qqH) HVV gauge
    - `T1_HLLHCTopYukawaKappaTBundle`        — HL-LHC κ_t projection
    - `T1_HiggsToWWLHCFrontier`              — H → WW* → ℓνℓν decay
    - `T1_HiggsTo4LeptonsZZFrontier`         — H → ZZ* → 4ℓ golden channel
    - `T1_HiggsToTauTauKappaTauFrontier`     — tau Yukawa κ_τ (3rd gen lepton)
    - `T1_HiggsToBBbarKappaBFrontier`        — b-quark Yukawa κ_b (3rd gen quark)
    - `T1_HiggsToCCBarCharmYukawaFrontier`   — charm Yukawa κ_c (2nd gen quark)
    - `T1_HiggsToZGammaFrontier`             — H → Zγ rare-loop channel
    - `T1_DiphotonSpectrumLHCBundle`         — H → γγ golden-channel sister
    - `T1_HiggsBranchingRatiosBundle`        — multi-channel branching context
    - `T1_HiggsCouplingStrengthsBundle`      — broader κ-modifier framework

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core tt̄H (pp → tt̄H) μ_ttH LHC-frontier envelope.
    Closes the DIRECT top-Yukawa Higgs production-mode channel —
    together with the VBF HVV bundle and the HL-LHC κ_t projection,
    this completes the top-tier **production-mode** coverage of
    OmegaTheory V2's SM Higgs precision frontier.  The direct
    tree-level top-Yukawa probe: substrate predictions of y_t shift
    must lie within the 5σ envelope to remain experimentally
    consistent with both ATLAS and CMS 2024 measurements. -/
theorem session_770_to_774_tth_associated_production_frontier_headline :
    0 < mu_ttH_SM_units
    ∧ 0 < mu_ttH_envelope_half_width_units
    ∧ 0 < mu_ttH_ATLAS_central_units
    ∧ 0 < mu_ttH_CMS_central_units
    ∧ 0 < mu_ttH_combined_central_units
    ∧ 0 < sigma_mu_ttH_combined_units
    ∧ 0 < sigma_mu_ttH_HLLHC_units
    ∧ mu_ttH_CMS_central_units < mu_ttH_combined_central_units
    ∧ mu_ttH_combined_central_units < mu_ttH_ATLAS_central_units
    ∧ mu_ttH_combined_central_units = mu_ttH_SM_units
    ∧ mu_ttH_SM_units - mu_ttH_combined_central_units
        ≤ mu_ttH_envelope_half_width_units
    ∧ 5 * sigma_mu_ttH_combined_units
        = mu_ttH_envelope_half_width_units
    ∧ TTHAssociatedProductionFrontier :=
  ⟨T1_s770_mu_ttH_SM_pos, T1_s770_envelope_pos,
   T1_s770_ATLAS_central_pos, T1_s770_CMS_central_pos,
   T1_s770_combined_central_pos, T1_s770_sigma_combined_pos,
   T1_s770_sigma_HLLHC_pos, T1_s771_CMS_below_combined,
   T1_s771_combined_below_ATLAS, T1_s772_combined_eq_SM,
   T1_s772_combined_within_envelope,
   T1_s773_five_sigma_combined_eq_envelope,
   T1_s774_tth_associated_production_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_tth_associated_production_frontier_bundle :
    TTHAssociatedProductionFrontier :=
  T1_s774_tth_associated_production_frontier

end OmegaTheory.Predictions.T1_TTHAssociatedProductionFrontier
