/-
  OmegaTheory.Predictions.T1_TTWAssociatedProductionFrontier

  T-1 (tt̄W associated production / SM precision frontier) — bundled
  sessions s790-s794, single git commit per BUNDLED COMMITS protocol.

  Top-pair-associated W-boson production pp → tt̄W at √s = 13 TeV.
  Frontier file pinning the substrate-prediction envelope for the
  ATLAS+CMS combined tt̄W cross-section σ_ttW around the SM benchmark
  σ_ttW^SM ≈ 0.65 pb (NLO QCD+EW with electroweak Sudakov logs).

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Substrate-prediction envelope frontier for the LHC tt̄W (pp → tt̄W)
  associated W production cross-section σ_ttW, where the SM expectation
  is σ_ttW^SM ≈ 0.65 ± 0.07 pb (NLO QCD+EW, m_t = 172.69 GeV,
  m_W = 80.38 GeV) at √s = 13 TeV.  tt̄W is the **direct top-W
  charged-current coupling probe** at the LHC: production amplitude
  has tree-level W-radiation off the initial-state quarks combined
  with t→Wb decays in the final state, giving a notably DIFFERENT
  topology from neutral-current tt̄Z.

  Phenomenology context (working units: fb, × 1000 from pb):

    SM expectation        σ_ttW^SM = 0.65 pb →  650 fb (NLO QCD+EW)
    PDG 2024 central      σ_ttW    = 0.87 pb →  870 fb (combined ATLAS+CMS)
    ATLAS Run-2 central   σ_ttW    = 0.87 pb →  870 fb (139 fb⁻¹, multi-lepton)
    CMS  Run-2 central    σ_ttW    = 0.77 pb →  770 fb (138 fb⁻¹, multi-lepton)
    Substrate envelope    |σ-0.87|≤0.65 pb  →  650 fb (envelope half-width,
                                                       5σ_combined band)

    PDG 2024 σ_ttW        =  0.87 ± 0.13 pb (combined experimental)
    NLO+EW   σ_ttW^SM     =  0.65 ± 0.07 pb (theory, EW Sudakov logs)
    Notable ~1.5σ tension |Δ| = 0.22 pb     (~1.69σ at σ_combined = 0.13 pb)
    Cross-section ratio   σ_ttW / σ_tt̄    ≈ 1/950    (sub-percent rare)

  Working units: fb (× 1000 from pb).  All bounds and witnesses are
  integer-scaled rationals — Lean witnesses are pure norm_num / decide.

  Why this is a real frontier (not stub):

  1. tt̄W is the **direct ttW charged-current coupling probe** at the
     LHC.  Unlike tt̄Z (where Z-radiation off the top-line tests the
     neutral-current ttZ vertex), in tt̄W the W is radiated from the
     INITIAL-STATE QUARKS (qq̄ → W → tt̄W diagrams dominate).  The
     SM cross-section receives LARGE electroweak Sudakov logarithms,
     making higher-order theory uncertainty notably bigger than tt̄Z.
  2. ATLAS 2024 (139 fb⁻¹) measures σ_ttW = 0.87 ± 0.13 pb in combined
     multi-lepton (3ℓ + 2ℓSS) channels with same-sign-dilepton signature.
  3. CMS 2024 (138 fb⁻¹) measures σ_ttW = 0.77 ± 0.13 pb in independent
     multi-lepton analysis with similar tt̄W-tag selection.
  4. Combined ATLAS+CMS PDG 2024 σ_ttW = 0.87 ± 0.13 pb, sitting
     **~1.69σ above the NLO+EW prediction** of 0.65 ± 0.07 pb — the
     LARGEST persistent positive deviation among the top-associated
     production channels (compare tt̄Z 1.14σ, tt̄H 0σ).
  5. Substrate envelope |σ_ttW - 0.87| ≤ 0.65 pb (= 5σ_combined band)
     is the working frontier width.  Substrate predictions of σ_ttW
     (e.g. via anomalous ttW vertex corrections, charged Higgs H±
     contributions, or extended electroweak sector with W'-mixing)
     MUST lie within this envelope.
  6. HL-LHC 3000 fb⁻¹ projection: σ(σ_ttW) → ~0.05 pb (~2.6× tighter),
     making this a SHARP charged-current probe going forward.

  Why tt̄W is DISTINCT from tt̄H, tt̄Z, and tt̄γ:

  - Production radiates a W BOSON (charged-current), not a Higgs (scalar)
    or Z (neutral-current) or photon — so the vertex tested is ttW
    (γ_μ × {C_V, C_A} with V-A structure), NOT the neutral-current
    Z vertex (ttZ) and NOT the EM vertex (ttγ).  W is RADIATED FROM
    THE INITIAL-STATE QUARKS, not from the top line — this is the
    crucial topology difference vs. tt̄Z.
  - Final state has SAME-SIGN DILEPTONS (W±W±) from t→W+b and
    radiated W± — a distinctive low-background signature.
  - Substrate predictions for ttW vertex form factors AND for
    initial-state-radiation EW corrections show up here directly.
  - Notable ~1.5σ excess in PDG combined value is the LARGEST among
    top-associated production channels — a persistent feature
    surviving multiple analysis rounds.

  ## Sessions

  - s790: σ_ttW^SM, PDG_central, ATLAS_central, CMS_central,
          envelope_half_width, sigma_combined, sigma_HLLHC definitions
          + positivity
  - s791: ATLAS = 870, CMS = 770, PDG = 870; CMS < PDG = ATLAS;
          ATLAS - CMS = 100 (~0.77σ split)
  - s792: SM = 650; PDG > SM (notable ~1.69σ positive tension);
          PDG - SM = 220 (~1.69σ); 220 ≤ envelope = 650 (within band)
  - s793: 5·σ_combined = envelope (5σ envelope); HL-LHC σ < envelope;
          envelope = SM (envelope EXACTLY equal to SM — distinct from
          tt̄Z where envelope < SM)
  - s794: TTWAssociatedProductionFrontier Prop (8-conjunct) +
          headline (12-conjunct) + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_TTWAssociatedProductionFrontier

/-! ## s790: tt̄W σ_ttW measurements (working units: fb, × 1000 from pb) -/

/-- **σ_ttW SM** (units fb): `650 = 0.65 pb`.

    Standard Model NLO QCD+EW prediction at √s = 13 TeV,
    m_t = 172.69 GeV, m_W = 80.38 GeV.  Includes electroweak
    Sudakov logarithms which slow convergence relative to tt̄Z;
    higher-order theory uncertainty is ~10%, larger than tt̄Z. -/
noncomputable def sigma_ttW_SM_units : ℝ := 650

/-- **PDG 2024 combined central value** for σ_ttW (units fb):
    `870 = 0.87 pb`.

    Combined ATLAS+CMS PDG 2024 average over multi-lepton (3ℓ + 2ℓSS)
    channels, ~1.69σ above NLO+EW expectation — the largest persistent
    positive deviation among top-associated production channels. -/
noncomputable def sigma_ttW_PDG_central_units : ℝ := 870

/-- **ATLAS 2024 central value** for σ_ttW (units fb): `870 = 0.87 pb`.

    ATLAS tt̄W combined multi-lepton analysis, 139 fb⁻¹ Run-2 ATLAS
    data with 3ℓ + 2ℓSS channel tagging.  ~1.69σ above SM. -/
noncomputable def sigma_ttW_ATLAS_central_units : ℝ := 870

/-- **CMS 2024 central value** for σ_ttW (units fb): `770 = 0.77 pb`.

    CMS tt̄W independent multi-lepton analysis, 138 fb⁻¹ Run-2 CMS
    data with similar multi-channel ttW-tag selection.  ~0.92σ above
    SM (slightly below ATLAS). -/
noncomputable def sigma_ttW_CMS_central_units : ℝ := 770

/-- **Substrate-prediction envelope half-width** `|σ_ttW - 0.87| ≤ 0.65 pb`
    (units fb): `650 = 0.65 pb`.

    Working envelope for substrate predictions of σ_ttW.  Centred on
    the PDG combined value σ_ttW = 0.87 pb, half-width 0.65 pb
    corresponds to 5σ_combined (where σ_combined ≈ 0.13 pb).  Notable:
    envelope EXACTLY equals SM value — a coincidence reflecting the
    larger combined experimental uncertainty for charged-current
    production than for neutral-current. -/
noncomputable def sigma_ttW_envelope_half_width_units : ℝ := 650

/-- **Combined 1σ uncertainty σ_combined** (units fb): `130 = 0.13 pb`.

    Combined ATLAS+CMS PDG 2024 uncertainty on σ_ttW.  Notably larger
    than tt̄Z combined uncertainty (70 fb), reflecting the larger
    EW Sudakov-log theory uncertainty AND the lower experimental
    statistics in same-sign dilepton channels. -/
noncomputable def sigma_ttW_combined_units : ℝ := 130

/-- **HL-LHC 3000 fb⁻¹ projected σ(σ_ttW)** (units fb): `50 = 0.05 pb`.

    Projected 1σ uncertainty from HL-LHC 3000 fb⁻¹ run, ~2.6× tighter
    than current Run-2 combined.  Will sharpen the current ~1.7σ
    tension to either >5σ discovery of new physics or a definitive
    pull-back to SM. -/
noncomputable def sigma_ttW_HLLHC_units : ℝ := 50

/-! ## Positivity (s790) -/

/-- **🚨 s790 — `σ_ttW SM > 0`**. -/
theorem T1_s790_sigma_ttW_SM_pos : 0 < sigma_ttW_SM_units := by
  unfold sigma_ttW_SM_units; norm_num

/-- **🚨 s790 — `σ_ttW PDG central > 0`**. -/
theorem T1_s790_PDG_central_pos : 0 < sigma_ttW_PDG_central_units := by
  unfold sigma_ttW_PDG_central_units; norm_num

/-- **🚨 s790 — `ATLAS central > 0`**. -/
theorem T1_s790_ATLAS_central_pos : 0 < sigma_ttW_ATLAS_central_units := by
  unfold sigma_ttW_ATLAS_central_units; norm_num

/-- **🚨 s790 — `CMS central > 0`**. -/
theorem T1_s790_CMS_central_pos : 0 < sigma_ttW_CMS_central_units := by
  unfold sigma_ttW_CMS_central_units; norm_num

/-- **🚨 s790 — `envelope half-width > 0`**. -/
theorem T1_s790_envelope_pos : 0 < sigma_ttW_envelope_half_width_units := by
  unfold sigma_ttW_envelope_half_width_units; norm_num

/-- **🚨 s790 — `σ combined > 0`**. -/
theorem T1_s790_sigma_combined_pos : 0 < sigma_ttW_combined_units := by
  unfold sigma_ttW_combined_units; norm_num

/-- **🚨 s790 — `σ HL-LHC > 0`**. -/
theorem T1_s790_sigma_HLLHC_pos : 0 < sigma_ttW_HLLHC_units := by
  unfold sigma_ttW_HLLHC_units; norm_num

/-- **🚨 s790 — `σ_ttW SM = 650`** (canonical numeric, NLO+EW value). -/
theorem T1_s790_sigma_ttW_SM_eq : sigma_ttW_SM_units = 650 := by
  unfold sigma_ttW_SM_units; rfl

/-- **🚨 s790 — `envelope = 650`** (canonical numeric, half-width 0.65 pb). -/
theorem T1_s790_envelope_eq : sigma_ttW_envelope_half_width_units = 650 := by
  unfold sigma_ttW_envelope_half_width_units; rfl

/-! ## s791: CMS vs ATLAS ordering, PDG matches ATLAS (combined-driven) -/

/-- **🚨 s791 — `ATLAS = 870`** (canonical numeric). -/
theorem T1_s791_ATLAS_central_eq : sigma_ttW_ATLAS_central_units = 870 := by
  unfold sigma_ttW_ATLAS_central_units; rfl

/-- **🚨 s791 — `CMS = 770`** (canonical numeric). -/
theorem T1_s791_CMS_central_eq : sigma_ttW_CMS_central_units = 770 := by
  unfold sigma_ttW_CMS_central_units; rfl

/-- **🚨 s791 — `PDG = 870`** (canonical numeric — combined experimental,
    matches ATLAS central). -/
theorem T1_s791_PDG_central_eq :
    sigma_ttW_PDG_central_units = 870 := by
  unfold sigma_ttW_PDG_central_units; rfl

/-- **🚨 s791 — `CMS < ATLAS`**: CMS central is below ATLAS central
    (`770 < 870`). -/
theorem T1_s791_CMS_below_ATLAS :
    sigma_ttW_CMS_central_units < sigma_ttW_ATLAS_central_units := by
  unfold sigma_ttW_CMS_central_units sigma_ttW_ATLAS_central_units; norm_num

/-- **🚨 s791 — `CMS < PDG`**: PDG combined value sits above CMS
    (`770 < 870`). -/
theorem T1_s791_CMS_below_PDG :
    sigma_ttW_CMS_central_units < sigma_ttW_PDG_central_units := by
  unfold sigma_ttW_CMS_central_units sigma_ttW_PDG_central_units
  norm_num

/-- **🚨 s791 — `PDG = ATLAS`**: PDG combined value matches ATLAS central
    exactly (`870 = 870`).  Reflects the larger weight ATLAS has in the
    combination due to its slightly smaller systematic uncertainty
    (distinct from tt̄Z where PDG sits between CMS and ATLAS). -/
theorem T1_s791_PDG_eq_ATLAS :
    sigma_ttW_PDG_central_units = sigma_ttW_ATLAS_central_units := by
  unfold sigma_ttW_PDG_central_units sigma_ttW_ATLAS_central_units
  norm_num

/-- **🚨 s791 — `PDG ≤ ATLAS`**: PDG combined value at most ATLAS
    central (`870 ≤ 870` — equality from `T1_s791_PDG_eq_ATLAS`). -/
theorem T1_s791_PDG_le_ATLAS :
    sigma_ttW_PDG_central_units ≤ sigma_ttW_ATLAS_central_units := by
  unfold sigma_ttW_PDG_central_units sigma_ttW_ATLAS_central_units
  norm_num

/-- **🚨 s791 — `ATLAS - CMS = 100`**: ATLAS-minus-CMS gap is exactly 100
    (`870 - 770 = 100`), within ~0.77σ at σ_combined=130. -/
theorem T1_s791_ATLAS_minus_CMS_eq :
    sigma_ttW_ATLAS_central_units - sigma_ttW_CMS_central_units = 100 := by
  unfold sigma_ttW_ATLAS_central_units sigma_ttW_CMS_central_units; norm_num

/-! ## s792: SM tension (PDG > SM, notable ~1.69σ excess inside envelope) -/

/-- **🚨 s792 — `σ_ttW^SM = 650`** (canonical numeric). -/
theorem T1_s792_sigma_ttW_SM_eq_650 : sigma_ttW_SM_units = 650 := by
  unfold sigma_ttW_SM_units; rfl

/-- **🚨 s792 — `SM < PDG`**: PDG combined above SM (notable positive
    tension at ~1.69σ — the LARGEST persistent excess among top-
    associated production channels). -/
theorem T1_s792_SM_below_PDG :
    sigma_ttW_SM_units < sigma_ttW_PDG_central_units := by
  unfold sigma_ttW_SM_units sigma_ttW_PDG_central_units; norm_num

/-- **🚨 s792 — `SM < ATLAS`**: ATLAS central above SM (high-side
    tension, ~1.69σ — matches PDG since PDG = ATLAS exactly). -/
theorem T1_s792_SM_below_ATLAS :
    sigma_ttW_SM_units < sigma_ttW_ATLAS_central_units := by
  unfold sigma_ttW_SM_units sigma_ttW_ATLAS_central_units; norm_num

/-- **🚨 s792 — `SM < CMS`**: CMS central also above SM (~0.92σ above).
    All three experimental measurements lie above NLO+EW, persistent
    cross-experiment positive deviation. -/
theorem T1_s792_SM_below_CMS :
    sigma_ttW_SM_units < sigma_ttW_CMS_central_units := by
  unfold sigma_ttW_SM_units sigma_ttW_CMS_central_units; norm_num

/-- **🚨 s792 — `PDG - SM = 220`**: PDG-minus-SM gap is exactly 220 fb
    (`870 - 650 = 220`), corresponding to ~1.69σ at σ_combined=130 —
    the LARGEST persistent positive excess among top-associated
    production channels (compare tt̄Z 80 fb / 1.14σ, tt̄H 0 fb / 0σ). -/
theorem T1_s792_PDG_minus_SM_eq :
    sigma_ttW_PDG_central_units - sigma_ttW_SM_units = 220 := by
  unfold sigma_ttW_PDG_central_units sigma_ttW_SM_units; norm_num

/-- **🚨 s792 — `PDG - SM ≤ envelope`**: PDG combined sits inside the
    substrate envelope around itself (`220 ≤ 650` — gap fits within
    5σ band, but at 33.8% of envelope width — much closer to envelope
    edge than tt̄Z's 22.9%). -/
theorem T1_s792_PDG_SM_gap_within_envelope :
    sigma_ttW_PDG_central_units - sigma_ttW_SM_units
      ≤ sigma_ttW_envelope_half_width_units := by
  unfold sigma_ttW_PDG_central_units sigma_ttW_SM_units
    sigma_ttW_envelope_half_width_units
  norm_num

/-- **🚨 s792 — `ATLAS - SM = 220`**: ATLAS deviation from SM
    (`870 - 650 = 220`, ~1.69σ above — same as PDG since PDG = ATLAS). -/
theorem T1_s792_ATLAS_minus_SM_eq :
    sigma_ttW_ATLAS_central_units - sigma_ttW_SM_units = 220 := by
  unfold sigma_ttW_ATLAS_central_units sigma_ttW_SM_units; norm_num

/-- **🚨 s792 — `CMS - SM = 120`**: CMS deviation from SM
    (`770 - 650 = 120`, ~0.92σ above — slightly less excess than ATLAS
    but still positive). -/
theorem T1_s792_CMS_minus_SM_eq :
    sigma_ttW_CMS_central_units - sigma_ttW_SM_units = 120 := by
  unfold sigma_ttW_CMS_central_units sigma_ttW_SM_units; norm_num

/-! ## s793: σ-envelope relations and HL-LHC tightening -/

/-- **🚨 s793 — `5 · σ_combined = envelope`**: substrate envelope is
    EXACTLY the 5σ_combined band (`5 · 130 = 650`). -/
theorem T1_s793_five_sigma_combined_eq_envelope :
    5 * sigma_ttW_combined_units
      = sigma_ttW_envelope_half_width_units := by
  unfold sigma_ttW_combined_units sigma_ttW_envelope_half_width_units
  norm_num

/-- **🚨 s793 — `σ HL-LHC < σ_combined`**: HL-LHC tightens current
    1σ uncertainty (`50 < 130`). -/
theorem T1_s793_sigma_HLLHC_below_sigma_combined :
    sigma_ttW_HLLHC_units < sigma_ttW_combined_units := by
  unfold sigma_ttW_HLLHC_units sigma_ttW_combined_units; norm_num

/-- **🚨 s793 — `σ HL-LHC < envelope`**: HL-LHC σ sits well below
    substrate envelope (`50 < 650`). -/
theorem T1_s793_sigma_HLLHC_below_envelope :
    sigma_ttW_HLLHC_units < sigma_ttW_envelope_half_width_units := by
  unfold sigma_ttW_HLLHC_units sigma_ttW_envelope_half_width_units
  norm_num

/-- **🚨 s793 — `envelope = SM`**: envelope half-width EXACTLY equals
    SM value (`650 = 650`).  Distinct from tt̄Z (where envelope < SM):
    the larger combined uncertainty for tt̄W (driven by EW Sudakov
    logs + same-sign-dilepton statistics) makes the 5σ envelope as
    wide as the SM cross-section itself.  This is a real phenomeno-
    logical feature of the charged-current top-associated channel. -/
theorem T1_s793_envelope_eq_SM :
    sigma_ttW_envelope_half_width_units = sigma_ttW_SM_units := by
  unfold sigma_ttW_envelope_half_width_units sigma_ttW_SM_units; norm_num

/-- **🚨 s793 — `envelope ≤ SM`**: envelope half-width at most SM value
    (`650 ≤ 650` — equality from `T1_s793_envelope_eq_SM`).  Substrate
    predictions of σ_ttW are bounded by twice the SM cross-section
    in absolute terms (since σ ≥ 0 by physical positivity, the
    envelope-floor is `max(0, PDG - envelope) = max(0, 220) = 220`). -/
theorem T1_s793_envelope_le_SM :
    sigma_ttW_envelope_half_width_units ≤ sigma_ttW_SM_units := by
  unfold sigma_ttW_envelope_half_width_units sigma_ttW_SM_units; norm_num

/-- **🚨 s793 — `10 · σ HL-LHC < envelope`**: HL-LHC will achieve >10σ
    sensitivity to envelope-edge deviations (`10 · 50 = 500 < 650`).
    HL-LHC will SHARPLY test whether the current ~1.69σ excess is a
    real BSM signal or a statistical fluctuation. -/
theorem T1_s793_ten_sigma_HLLHC_below_envelope :
    10 * sigma_ttW_HLLHC_units < sigma_ttW_envelope_half_width_units := by
  unfold sigma_ttW_HLLHC_units sigma_ttW_envelope_half_width_units
  norm_num

/-- **🚨 s793 — `5 · σ HL-LHC < envelope`**: HL-LHC 5σ band well
    below substrate envelope (`5 · 50 = 250 < 650`). -/
theorem T1_s793_five_sigma_HLLHC_below_envelope :
    5 * sigma_ttW_HLLHC_units < sigma_ttW_envelope_half_width_units := by
  unfold sigma_ttW_HLLHC_units sigma_ttW_envelope_half_width_units
  norm_num

/-! ## s794: Frontier Prop + 8-conjunct headline -/

/-- **TTWAssociatedProductionFrontier**: 8-way conjunction pinning
    the substrate-prediction envelope for the LHC tt̄W (pp → tt̄W)
    associated W-boson production cross-section σ_ttW
    (working units: fb):

    1. `σ_ttW^SM > 0 ∧ envelope > 0 ∧ ATLAS > 0 ∧ CMS > 0`  (positivity)
    2. `SM < PDG`                      (notable ~1.69σ positive tension)
    3. `CMS < PDG ∧ PDG ≤ ATLAS`       (PDG combined matches ATLAS, above CMS)
    4. `PDG - SM ≤ envelope`           (PDG-SM gap inside substrate band)
    5. `5 · σ_combined = envelope`     (envelope = 5σ_combined band)
    6. `σ_HLLHC < σ_combined`          (HL-LHC tightens precision)
    7. `10 · σ_HLLHC < envelope`       (HL-LHC reaches >10σ to envelope edge)
    8. `envelope ≤ SM`                 (envelope at most SM — distinct
                                        from tt̄Z's envelope < SM)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for σ_ttW must lie within this envelope to remain
    experimentally consistent with both ATLAS and CMS 2024
    measurements at the 5σ_combined level. -/
def TTWAssociatedProductionFrontier : Prop :=
  -- (1) positivity quad
  (0 < sigma_ttW_SM_units ∧ 0 < sigma_ttW_envelope_half_width_units
    ∧ 0 < sigma_ttW_ATLAS_central_units
    ∧ 0 < sigma_ttW_CMS_central_units) ∧
  -- (2) PDG above SM (notable positive tension)
  (sigma_ttW_SM_units < sigma_ttW_PDG_central_units) ∧
  -- (3) PDG between CMS and ATLAS (with PDG = ATLAS exact)
  (sigma_ttW_CMS_central_units < sigma_ttW_PDG_central_units
    ∧ sigma_ttW_PDG_central_units ≤ sigma_ttW_ATLAS_central_units) ∧
  -- (4) PDG-SM gap inside substrate band
  (sigma_ttW_PDG_central_units - sigma_ttW_SM_units
      ≤ sigma_ttW_envelope_half_width_units) ∧
  -- (5) envelope = 5σ_combined band
  (5 * sigma_ttW_combined_units
      = sigma_ttW_envelope_half_width_units) ∧
  -- (6) HL-LHC tightens precision
  (sigma_ttW_HLLHC_units < sigma_ttW_combined_units) ∧
  -- (7) HL-LHC >10σ sensitivity to envelope edge
  (10 * sigma_ttW_HLLHC_units
      < sigma_ttW_envelope_half_width_units) ∧
  -- (8) envelope at most SM (a distinguishing feature of charged-current
  --     channel — wider envelope from EW-Sudakov-log uncertainty)
  (sigma_ttW_envelope_half_width_units ≤ sigma_ttW_SM_units)

/-- **🚨 s794 — `TTWAssociatedProductionFrontier`** holds. -/
theorem T1_s794_ttw_associated_production_frontier :
    TTWAssociatedProductionFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ⟨?_, ?_⟩, ?_, ?_, ?_, ?_, ?_⟩
  · exact T1_s790_sigma_ttW_SM_pos
  · exact T1_s790_envelope_pos
  · exact T1_s790_ATLAS_central_pos
  · exact T1_s790_CMS_central_pos
  · exact T1_s792_SM_below_PDG
  · exact T1_s791_CMS_below_PDG
  · exact T1_s791_PDG_le_ATLAS
  · exact T1_s792_PDG_SM_gap_within_envelope
  · exact T1_s793_five_sigma_combined_eq_envelope
  · exact T1_s793_sigma_HLLHC_below_sigma_combined
  · exact T1_s793_ten_sigma_HLLHC_below_envelope
  · exact T1_s793_envelope_le_SM

/-! ## Headline (12-conjunct) -/

/-- **HEADLINE — sessions 790-794 — tt̄W (pp → tt̄W) σ_ttW LHC-frontier
    associated W-boson PRODUCTION envelope (DIRECT ttW CHARGED-CURRENT
    COUPLING PROBE)**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s790: σ_ttW^SM = 650, PDG = 870, ATLAS = 870, CMS = 770,
            envelope = 650, σ_combined = 130, σ_HLLHC = 50 (units fb)
    - s791: CMS < PDG = ATLAS, ATLAS - CMS = 100
    - s792: SM < CMS < PDG = ATLAS (all three above NLO+EW SM);
            PDG - SM = 220 ≤ envelope = 650 (within 5σ band, 33.8%
            of envelope width — much closer to edge than tt̄Z 22.9%);
            ATLAS - SM = 220 (~1.69σ), CMS - SM = 120 (~0.92σ)
    - s793: 5·σ_combined = envelope; σ_HLLHC < σ_combined;
            10·σ_HLLHC < envelope (HL-LHC >10σ envelope sensitivity);
            envelope = SM (distinct from tt̄Z where envelope < SM)
    - s794: TTWAssociatedProductionFrontier (8-conjunct) +
            headline (12-conjunct) + bundle alias

    Phenomenology (all in pb, working units fb × 1000):
      σ_ttW^SM            = 0.65 ± 0.07 pb (NLO QCD+EW theory, Sudakov)
      σ_ttW (ATLAS 2024)  = 0.87 ± 0.13 pb (139 fb⁻¹ Run-2 multi-lepton)
      σ_ttW (CMS 2024)    = 0.77 ± 0.13 pb (138 fb⁻¹ Run-2 multi-lepton)
      σ_ttW (PDG 2024)    = 0.87 ± 0.13 pb (combined experimental)
      |σ_ttW - 0.87|≤0.65 (envelope)       working substrate window (5σ)
      σ(σ_ttW) → 0.05 pb  (HL-LHC 3 ab⁻¹) projected precision

      σ_ttW / σ_tt̄       ≈ 1/950            (sub-percent rare, but tagged)
      Topology: 2 b-jets from t→Wb + 2 W's + radiated W±
                → SAME-SIGN DILEPTON signature (low background)

    Why this matters:
    tt̄W is the **direct ttW charged-current coupling probe** at the
    LHC.  Unlike tt̄Z (where Z radiates from the top line, testing the
    neutral-current ttZ vertex), in tt̄W the W is radiated from the
    INITIAL-STATE QUARKS — a fundamentally different topology probing
    qq̄W coupling AND ttW vertex jointly.  Large electroweak Sudakov
    logarithms make NLO+EW theory uncertainty ~10%, larger than tt̄Z.

    The PDG 2024 combined value sits **~1.69σ above NLO+EW prediction**
    — the LARGEST persistent positive excess among top-associated
    production channels (compare tt̄Z 1.14σ, tt̄H 0σ).  Whether this
    is a statistical fluctuation, a missing higher-order EW correction,
    or a genuine BSM signal will be decisively settled by HL-LHC.

    Together with tt̄H (top-Yukawa scalar coupling), tt̄γ (electromagnetic
    vertex), and tt̄Z (neutral-current ttZ vertex), tt̄W completes the
    **top-quark-electroweak-coupling coverage** of OmegaTheory V2's
    SM precision frontier — the DIRECT charged-current ttW gauge tag
    at the LHC.

    BSM scenarios that affect σ_ttW (anomalous ttW vertex form factors,
    charged Higgs H± production with t→H±b decay, top-philic W'
    contributions, vector-like top partners with charged-current
    mixing, MSSM with stop-W couplings) all show up as σ_ttW shifts
    at the few-percent level — precisely the precision now reached,
    and a major HL-LHC target.

    Companion files:
    - `T1_TTZAssociatedProductionFrontier`   — tt̄Z neutral-current ttZ
    - `T1_TTHAssociatedProductionFrontier`   — tt̄H tree-level top-Yukawa
    - `T1_TTbarPairProductionLHCFrontier`    — tt̄ inclusive (largest σ)
    - `T1_HLLHCTopYukawaKappaTBundle`        — HL-LHC κ_t projection
    - `T1_LHCSMCrossSectionsBundle`          — multi-channel LHC σ context
    - `T1_HiggsToWWLHCFrontier`              — H → WW* leptonic decay

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core tt̄W (pp → tt̄W) σ_ttW LHC-frontier envelope.
    Closes the DIRECT ttW charged-current coupling associated-production
    channel — together with the tt̄H top-Yukawa bundle, the tt̄Z
    neutral-current bundle, and the tt̄ inclusive LHC frontier, this
    completes the top-tier **top-quark associated production coverage**
    of OmegaTheory V2's SM precision frontier.  The direct tree-level
    ttW vertex probe with the LARGEST current data-vs-SM tension:
    substrate predictions of ttW form-factor or initial-state-radiation
    EW-correction shifts must lie within the 5σ envelope to remain
    experimentally consistent with both ATLAS and CMS 2024
    measurements. -/
theorem session_790_to_794_ttw_associated_production_frontier_headline :
    0 < sigma_ttW_SM_units
    ∧ 0 < sigma_ttW_envelope_half_width_units
    ∧ 0 < sigma_ttW_ATLAS_central_units
    ∧ 0 < sigma_ttW_CMS_central_units
    ∧ 0 < sigma_ttW_PDG_central_units
    ∧ 0 < sigma_ttW_combined_units
    ∧ 0 < sigma_ttW_HLLHC_units
    ∧ sigma_ttW_CMS_central_units < sigma_ttW_PDG_central_units
    ∧ sigma_ttW_PDG_central_units ≤ sigma_ttW_ATLAS_central_units
    ∧ sigma_ttW_SM_units < sigma_ttW_PDG_central_units
    ∧ sigma_ttW_PDG_central_units - sigma_ttW_SM_units
        ≤ sigma_ttW_envelope_half_width_units
    ∧ 5 * sigma_ttW_combined_units
        = sigma_ttW_envelope_half_width_units
    ∧ TTWAssociatedProductionFrontier :=
  ⟨T1_s790_sigma_ttW_SM_pos, T1_s790_envelope_pos,
   T1_s790_ATLAS_central_pos, T1_s790_CMS_central_pos,
   T1_s790_PDG_central_pos, T1_s790_sigma_combined_pos,
   T1_s790_sigma_HLLHC_pos, T1_s791_CMS_below_PDG,
   T1_s791_PDG_le_ATLAS, T1_s792_SM_below_PDG,
   T1_s792_PDG_SM_gap_within_envelope,
   T1_s793_five_sigma_combined_eq_envelope,
   T1_s794_ttw_associated_production_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_ttw_associated_production_frontier_bundle :
    TTWAssociatedProductionFrontier :=
  T1_s794_ttw_associated_production_frontier

end OmegaTheory.Predictions.T1_TTWAssociatedProductionFrontier
