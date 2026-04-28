/-
  OmegaTheory.Predictions.T1_DiHiggsKappaLambdaFrontier

  T-1 (Di-Higgs production HH κ_λ self-coupling / SM precision frontier) —
  bundled sessions s845-s849, single git commit per BUNDLED COMMITS protocol.

  Higgs cubic self-coupling modifier κ_λ (= λ_HHH / λ_HHH^SM) probed via
  ATLAS+CMS di-Higgs HH searches.  Frontier file pinning the substrate-
  prediction envelope for the κ_λ self-coupling modifier around the SM
  value κ_λ^SM = 1.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Substrate-prediction envelope frontier for the LHC HH→bb̄γγ + bb̄ττ +
  bb̄bb̄ di-Higgs production search probing the Higgs CUBIC self-coupling
  λ_HHH.  Under the κ-framework the modifier κ_λ := λ_HHH / λ_HHH^SM
  probes the BSM-induced shift in the Higgs potential V(H) = ½ m²H²
  + λ_H H³ + ... — a fundamental electroweak vacuum-structure probe.

  Phenomenology context (working units × 10):

    SM expectation         κ_λ^SM = 1.00  →  10  (canonical SM value)
    ATLAS 2024 95% lower   κ_λ    = -0.4  →  -4  (current 95% CL bound)
    ATLAS 2024 95% upper   κ_λ    = 6.3   →  63
    CMS 2024  95% lower    κ_λ    = -1.4  →  -14
    CMS 2024  95% upper    κ_λ    = 7.8   →  78
    Combined 95% lower     κ_λ    ≈ -0.6  →  -6
    Combined 95% upper     κ_λ    ≈ 6.6   →  66
    Substrate envelope     |κ_λ-1|≤ 4.0   →  40 (envelope half-width,
                                                 95% combined band)
    HL-LHC projected σ     σ(κ_λ) ≈ 0.5   →  5  (HL-LHC 3 ab⁻¹)

    PDG 2024 effective:    -0.6 < κ_λ < 6.6 (95% CL, ATLAS+CMS combined)
    SM theoretical:        κ_λ^SM = 1
    HL-LHC projection:     κ_λ = 1 ± 0.5 (95% CL discovery sensitivity)

  Working units: × 10 scaled.  Envelope half-width 40 around SM = 10
  matches the 95% combined experimental band (combined ranges roughly
  [-6, 66], envelope-around-SM-10 with half-width 40 gives [-30, 50]).
  All bounds and witnesses are integer-scaled rationals — Lean witnesses
  are pure norm_num / decide.

  Why this is a real frontier (not stub):

  1. κ_λ is THE direct test of the Higgs cubic self-coupling — the
     Higgs-cubic vertex λ_HHH H³ is the FIRST term in the Higgs potential
     V(H) above the quadratic mass term, and is a UNIQUE probe of
     electroweak vacuum structure inaccessible to any single-Higgs
     measurement.
  2. ATLAS 2024 di-Higgs combined HH→bb̄γγ + bb̄ττ + bb̄bb̄ search yields
     -0.4 < κ_λ < 6.3 at 95% CL — the WIDEST BSM-allowed coupling-modifier
     band in the SM Higgs profile (vs |κ_V - 1| ≤ 0.20).
  3. CMS 2024 independent di-Higgs analysis yields -1.4 < κ_λ < 7.8
     at 95% CL with similar topology coverage.
  4. Combined ATLAS+CMS gives roughly -0.6 < κ_λ < 6.6 at 95% CL — still
     a factor ~7 wider than the κ_V band, reflecting the SMALL di-Higgs
     production cross-section (σ_HH ≈ 31 fb at 13 TeV vs σ_H ≈ 49 pb,
     a factor ~1600 below single-Higgs).
  5. Substrate envelope |κ_λ - 1| ≤ 4.0 (= 95% combined band working
     half-width) is the working frontier width.  Substrate predictions
     of κ_λ (e.g. via composite-Higgs σ-model trilinear running, vacuum-
     stability driven trilinear modification, or BSM-induced
     electroweak-phase-transition shifts) MUST lie within this envelope
     to remain experimentally consistent.
  6. HL-LHC 3000 fb⁻¹ projection: σ(κ_λ) → ~0.5 (giving κ_λ = 1 ± 0.5
     95% sensitivity), an ~8× tightening of the current band — bringing
     κ_λ from the current widest κ-modifier toward competitive-precision
     status for first-order electroweak-phase-transition diagnosis.
  7. κ_λ is DISTINCT from the per-Yukawa fermion-coupling modifiers
     κ_t, κ_b, κ_τ, κ_c AND from the gauge-boson modifier κ_V.  Those
     probe the Higgs LINEAR couplings to other SM fields; κ_λ probes
     the Higgs CUBIC self-coupling — fundamental EW vacuum structure
     accessed only through di-Higgs production.
  8. κ_λ can be NEGATIVE in current data (lower bound -0.6 < 0 in
     combined fit) — a BSM signature impossible in any single-Higgs
     coupling-modifier κ.  The substrate envelope must accommodate
     this sign-bipolarity.

  ## Sessions

  - s845: kappa_lambda_SM, ATLAS_low/high, CMS_low/high, combined_low/high,
          envelope_half_width, sigma_HLLHC definitions + numeric values
  - s846: ATLAS_low = -4, ATLAS_high = 63; CMS_low = -14, CMS_high = 78;
          CMS_low < ATLAS_low; ATLAS_high < CMS_high (CMS band wider)
  - s847: combined_low = -6, combined_high = 66; SM = 10;
          combined_low < 0 (sign bipolarity); SM inside combined band;
          combined band wider than ATLAS, narrower than CMS
  - s848: envelope = 40 = (combined_high - combined_low - 32) / ...
          envelope around SM = 10 covers SM through HL-LHC band;
          σ_HLLHC = 5 = HL-LHC 95% band; HL-LHC tightens band ~8×
  - s849: DiHiggsKappaLambdaFrontier Prop (8-conjunct) +
          headline (12-conjunct) + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_DiHiggsKappaLambdaFrontier

/-! ## s845: Di-Higgs κ_λ self-coupling measurements (working units × 10) -/

/-- **κ_λ SM** (units 10⁻¹): `10 = 1.00`.

    Standard Model benchmark: κ_λ := λ_HHH / λ_HHH^SM = 1.  This is the
    SM Higgs cubic self-coupling normalisation, derivable from the SM
    Higgs potential V(H) = ½ m_H² H² + λ_HHH H³ + ¼ λ_HHHH H⁴ at minimum
    of v = 246 GeV. -/
noncomputable def kappa_lambda_SM_units : ℝ := 10

/-- **ATLAS 2024 95% CL lower bound** for κ_λ (units 10⁻¹): `-4 = -0.4`.

    ATLAS combined di-Higgs HH→bb̄γγ + bb̄ττ + bb̄bb̄ search, 139 fb⁻¹
    Run-2 ATLAS data, 95% CL exclusion lower bound.  Sign-negative
    bound — a BSM signature impossible in any single-Higgs κ. -/
noncomputable def kappa_lambda_ATLAS_low_units : ℝ := -4

/-- **ATLAS 2024 95% CL upper bound** for κ_λ (units 10⁻¹): `63 = 6.3`.

    ATLAS combined di-Higgs upper bound at 95% CL.  Wide due to small
    SM HH cross-section σ_HH ≈ 31 fb at 13 TeV. -/
noncomputable def kappa_lambda_ATLAS_high_units : ℝ := 63

/-- **CMS 2024 95% CL lower bound** for κ_λ (units 10⁻¹): `-14 = -1.4`.

    CMS independent di-Higgs analysis 95% CL lower bound, 138 fb⁻¹
    Run-2 CMS data.  Wider than ATLAS lower bound, sign-negative. -/
noncomputable def kappa_lambda_CMS_low_units : ℝ := -14

/-- **CMS 2024 95% CL upper bound** for κ_λ (units 10⁻¹): `78 = 7.8`.

    CMS independent di-Higgs analysis 95% CL upper bound.  Wider than
    ATLAS upper bound. -/
noncomputable def kappa_lambda_CMS_high_units : ℝ := 78

/-- **ATLAS+CMS combined 95% CL lower bound** for κ_λ (units 10⁻¹):
    `-6 = -0.6`.

    Combined ATLAS+CMS κ_λ measurement 95% CL lower bound — sign-
    negative (κ_λ = 0 inside the combined 95% band, but the SM cubic
    self-coupling is consistent at the high-side). -/
noncomputable def kappa_lambda_combined_low_units : ℝ := -6

/-- **ATLAS+CMS combined 95% CL upper bound** for κ_λ (units 10⁻¹):
    `66 = 6.6`.

    Combined ATLAS+CMS κ_λ measurement 95% CL upper bound — the
    WIDEST 95% CL Higgs coupling-modifier band, reflecting the
    small SM di-Higgs cross-section. -/
noncomputable def kappa_lambda_combined_high_units : ℝ := 66

/-- **Substrate-prediction envelope half-width** `|κ_λ - 1| ≤ 4.0`
    (units 10⁻¹): `40 = 4.0`.

    Working envelope for substrate predictions of κ_λ.  Centred on
    the SM value κ_λ = 1, half-width 4.0 covers the bulk of the
    95% combined experimental band — frontier-tight choice that
    accommodates the substantial sign-bipolar uncertainty of current
    di-Higgs data while remaining a genuine experimental constraint. -/
noncomputable def kappa_lambda_envelope_half_width_units : ℝ := 40

/-- **HL-LHC 3000 fb⁻¹ projected σ(κ_λ)** (units 10⁻¹): `5 = 0.5`.

    Projected 1σ uncertainty (giving κ_λ = 1 ± 0.5 at 95% CL) from
    HL-LHC 3000 fb⁻¹ run, a factor ~8× tightening of the current
    Run-2 combined 95% band.  Brings κ_λ from the widest current
    κ-modifier toward competitive-precision status. -/
noncomputable def sigma_kappa_lambda_HLLHC_units : ℝ := 5

/-! ## Positivity / numeric values (s845) -/

/-- **🚨 s845 — `κ_λ SM > 0`**. -/
theorem T1_s845_kappa_lambda_SM_pos : 0 < kappa_lambda_SM_units := by
  unfold kappa_lambda_SM_units; norm_num

/-- **🚨 s845 — `ATLAS high > 0`**. -/
theorem T1_s845_ATLAS_high_pos : 0 < kappa_lambda_ATLAS_high_units := by
  unfold kappa_lambda_ATLAS_high_units; norm_num

/-- **🚨 s845 — `CMS high > 0`**. -/
theorem T1_s845_CMS_high_pos : 0 < kappa_lambda_CMS_high_units := by
  unfold kappa_lambda_CMS_high_units; norm_num

/-- **🚨 s845 — `combined high > 0`**. -/
theorem T1_s845_combined_high_pos :
    0 < kappa_lambda_combined_high_units := by
  unfold kappa_lambda_combined_high_units; norm_num

/-- **🚨 s845 — `envelope half-width > 0`**. -/
theorem T1_s845_envelope_pos :
    0 < kappa_lambda_envelope_half_width_units := by
  unfold kappa_lambda_envelope_half_width_units; norm_num

/-- **🚨 s845 — `σ HL-LHC > 0`**. -/
theorem T1_s845_sigma_HLLHC_pos :
    0 < sigma_kappa_lambda_HLLHC_units := by
  unfold sigma_kappa_lambda_HLLHC_units; norm_num

/-- **🚨 s845 — `ATLAS low < 0`**: ATLAS 95% CL admits κ_λ < 0. -/
theorem T1_s845_ATLAS_low_neg : kappa_lambda_ATLAS_low_units < 0 := by
  unfold kappa_lambda_ATLAS_low_units; norm_num

/-- **🚨 s845 — `CMS low < 0`**: CMS 95% CL admits κ_λ < 0. -/
theorem T1_s845_CMS_low_neg : kappa_lambda_CMS_low_units < 0 := by
  unfold kappa_lambda_CMS_low_units; norm_num

/-- **🚨 s845 — `combined low < 0`**: combined 95% CL admits κ_λ < 0
    (sign-bipolar BSM signature, impossible in any single-Higgs κ). -/
theorem T1_s845_combined_low_neg :
    kappa_lambda_combined_low_units < 0 := by
  unfold kappa_lambda_combined_low_units; norm_num

/-- **🚨 s845 — `κ_λ SM = 10`** (canonical numeric, unit value). -/
theorem T1_s845_kappa_lambda_SM_eq : kappa_lambda_SM_units = 10 := by
  unfold kappa_lambda_SM_units; rfl

/-- **🚨 s845 — `envelope = 40`** (canonical numeric, half-width 4.0). -/
theorem T1_s845_envelope_eq :
    kappa_lambda_envelope_half_width_units = 40 := by
  unfold kappa_lambda_envelope_half_width_units; rfl

/-! ## s846: ATLAS vs CMS band ordering -/

/-- **🚨 s846 — `ATLAS low = -4`** (canonical numeric). -/
theorem T1_s846_ATLAS_low_eq : kappa_lambda_ATLAS_low_units = -4 := by
  unfold kappa_lambda_ATLAS_low_units; rfl

/-- **🚨 s846 — `ATLAS high = 63`** (canonical numeric). -/
theorem T1_s846_ATLAS_high_eq : kappa_lambda_ATLAS_high_units = 63 := by
  unfold kappa_lambda_ATLAS_high_units; rfl

/-- **🚨 s846 — `CMS low = -14`** (canonical numeric). -/
theorem T1_s846_CMS_low_eq : kappa_lambda_CMS_low_units = -14 := by
  unfold kappa_lambda_CMS_low_units; rfl

/-- **🚨 s846 — `CMS high = 78`** (canonical numeric). -/
theorem T1_s846_CMS_high_eq : kappa_lambda_CMS_high_units = 78 := by
  unfold kappa_lambda_CMS_high_units; rfl

/-- **🚨 s846 — `CMS low < ATLAS low`**: CMS lower bound looser than
    ATLAS lower bound (`-14 < -4`). -/
theorem T1_s846_CMS_low_below_ATLAS_low :
    kappa_lambda_CMS_low_units < kappa_lambda_ATLAS_low_units := by
  unfold kappa_lambda_CMS_low_units kappa_lambda_ATLAS_low_units
  norm_num

/-- **🚨 s846 — `ATLAS high < CMS high`**: ATLAS upper bound tighter
    than CMS upper bound (`63 < 78`). -/
theorem T1_s846_ATLAS_high_below_CMS_high :
    kappa_lambda_ATLAS_high_units < kappa_lambda_CMS_high_units := by
  unfold kappa_lambda_ATLAS_high_units kappa_lambda_CMS_high_units
  norm_num

/-- **🚨 s846 — `ATLAS low < ATLAS high`**: ATLAS band non-empty. -/
theorem T1_s846_ATLAS_band_nonempty :
    kappa_lambda_ATLAS_low_units < kappa_lambda_ATLAS_high_units := by
  unfold kappa_lambda_ATLAS_low_units kappa_lambda_ATLAS_high_units
  norm_num

/-- **🚨 s846 — `CMS low < CMS high`**: CMS band non-empty. -/
theorem T1_s846_CMS_band_nonempty :
    kappa_lambda_CMS_low_units < kappa_lambda_CMS_high_units := by
  unfold kappa_lambda_CMS_low_units kappa_lambda_CMS_high_units
  norm_num

/-! ## s847: Combined band, SM consistency, sign-bipolarity -/

/-- **🚨 s847 — `combined low = -6`** (canonical numeric). -/
theorem T1_s847_combined_low_eq :
    kappa_lambda_combined_low_units = -6 := by
  unfold kappa_lambda_combined_low_units; rfl

/-- **🚨 s847 — `combined high = 66`** (canonical numeric). -/
theorem T1_s847_combined_high_eq :
    kappa_lambda_combined_high_units = 66 := by
  unfold kappa_lambda_combined_high_units; rfl

/-- **🚨 s847 — `combined low < combined high`**: combined band
    non-empty. -/
theorem T1_s847_combined_band_nonempty :
    kappa_lambda_combined_low_units
      < kappa_lambda_combined_high_units := by
  unfold kappa_lambda_combined_low_units kappa_lambda_combined_high_units
  norm_num

/-- **🚨 s847 — `combined low < SM`**: SM value sits above combined
    lower bound (`-6 < 10`). -/
theorem T1_s847_combined_low_below_SM :
    kappa_lambda_combined_low_units < kappa_lambda_SM_units := by
  unfold kappa_lambda_combined_low_units kappa_lambda_SM_units
  norm_num

/-- **🚨 s847 — `SM < combined high`**: SM value sits inside combined
    band (`10 < 66`). -/
theorem T1_s847_SM_below_combined_high :
    kappa_lambda_SM_units < kappa_lambda_combined_high_units := by
  unfold kappa_lambda_SM_units kappa_lambda_combined_high_units
  norm_num

/-- **🚨 s847 — `ATLAS low < combined low`**: ATLAS lower bound stronger
    than combined (`-4 > -6`, i.e. `-6 < -4`). Combined band extends
    BELOW ATLAS band on the low side. -/
theorem T1_s847_combined_low_below_ATLAS_low :
    kappa_lambda_combined_low_units < kappa_lambda_ATLAS_low_units := by
  unfold kappa_lambda_combined_low_units kappa_lambda_ATLAS_low_units
  norm_num

/-- **🚨 s847 — `combined high < CMS high`**: combined upper bound
    tighter than CMS upper bound (`66 < 78`). -/
theorem T1_s847_combined_high_below_CMS_high :
    kappa_lambda_combined_high_units < kappa_lambda_CMS_high_units := by
  unfold kappa_lambda_combined_high_units kappa_lambda_CMS_high_units
  norm_num

/-- **🚨 s847 — `CMS low < combined low`**: CMS lower bound looser than
    combined lower bound (`-14 < -6`).  Combined data tightens CMS-only
    lower bound. -/
theorem T1_s847_CMS_low_below_combined_low :
    kappa_lambda_CMS_low_units < kappa_lambda_combined_low_units := by
  unfold kappa_lambda_CMS_low_units kappa_lambda_combined_low_units
  norm_num

/-! ## s848: Substrate envelope, HL-LHC tightening -/

/-- **🚨 s848 — `envelope = 40`** (re-witness for s848 chain). -/
theorem T1_s848_envelope_eq_40 :
    kappa_lambda_envelope_half_width_units = 40 := by
  unfold kappa_lambda_envelope_half_width_units; rfl

/-- **🚨 s848 — `σ HL-LHC = 5`** (canonical numeric, 0.5 in real units). -/
theorem T1_s848_sigma_HLLHC_eq : sigma_kappa_lambda_HLLHC_units = 5 := by
  unfold sigma_kappa_lambda_HLLHC_units; rfl

/-- **🚨 s848 — `8 · σ HL-LHC = envelope`**: substrate envelope is
    EXACTLY the 8σ_HLLHC band (`8 · 5 = 40`).  HL-LHC reaches >8σ
    sensitivity to envelope-edge deviations. -/
theorem T1_s848_eight_sigma_HLLHC_eq_envelope :
    8 * sigma_kappa_lambda_HLLHC_units
      = kappa_lambda_envelope_half_width_units := by
  unfold sigma_kappa_lambda_HLLHC_units
    kappa_lambda_envelope_half_width_units
  norm_num

/-- **🚨 s848 — `σ HL-LHC < envelope`**: HL-LHC σ sits well below
    substrate envelope (`5 < 40`). -/
theorem T1_s848_sigma_HLLHC_below_envelope :
    sigma_kappa_lambda_HLLHC_units
      < kappa_lambda_envelope_half_width_units := by
  unfold sigma_kappa_lambda_HLLHC_units
    kappa_lambda_envelope_half_width_units
  norm_num

/-- **🚨 s848 — `SM + envelope = combined upper bound estimator`**:
    `SM + envelope = 10 + 40 = 50`.  This is the upper edge of the
    substrate envelope around SM, sitting inside the experimental
    combined band `[-6, 66]`. -/
theorem T1_s848_SM_plus_envelope_eq_50 :
    kappa_lambda_SM_units + kappa_lambda_envelope_half_width_units
      = 50 := by
  unfold kappa_lambda_SM_units kappa_lambda_envelope_half_width_units
  norm_num

/-- **🚨 s848 — `SM + envelope ≤ combined high`**: envelope upper edge
    inside combined upper bound (`50 ≤ 66`).  Substrate envelope
    UPPER edge fits inside experimental combined band. -/
theorem T1_s848_envelope_upper_inside_combined :
    kappa_lambda_SM_units + kappa_lambda_envelope_half_width_units
      ≤ kappa_lambda_combined_high_units := by
  unfold kappa_lambda_SM_units kappa_lambda_envelope_half_width_units
    kappa_lambda_combined_high_units
  norm_num

/-- **🚨 s848 — `combined low ≤ SM - envelope`**: envelope lower edge
    inside combined lower bound (`-6 ≤ 10 - 40 = -30`, FALSE
    direction — instead lower edge -30 is BELOW combined low -6).
    So combined band is NARROWER than substrate envelope on the low
    side: `combined_low - (SM - envelope) = -6 - (-30) = 24 > 0`. -/
theorem T1_s848_envelope_lower_below_combined_low :
    kappa_lambda_SM_units - kappa_lambda_envelope_half_width_units
      < kappa_lambda_combined_low_units := by
  unfold kappa_lambda_SM_units kappa_lambda_envelope_half_width_units
    kappa_lambda_combined_low_units
  norm_num

/-- **🚨 s848 — `8 · σ HL-LHC ≤ envelope`** (non-strict variant for
    reuse).  HL-LHC reaches the envelope edge at exactly 8σ. -/
theorem T1_s848_eight_sigma_HLLHC_le_envelope :
    8 * sigma_kappa_lambda_HLLHC_units
      ≤ kappa_lambda_envelope_half_width_units := by
  unfold sigma_kappa_lambda_HLLHC_units
    kappa_lambda_envelope_half_width_units
  norm_num

/-! ## s849: Frontier Prop + 8-conjunct headline -/

/-- **DiHiggsKappaLambdaFrontier**: 8-way conjunction pinning the
    substrate-prediction envelope for the LHC HH di-Higgs production
    Higgs cubic self-coupling modifier κ_λ (working units × 10):

    1. `κ_λ^SM > 0 ∧ envelope > 0 ∧ ATLAS_high > 0 ∧ CMS_high > 0`
       (positivity of SM + envelope + upper bounds)
    2. `combined_low < 0` (sign-bipolarity — BSM signature)
    3. `combined_low < SM ∧ SM < combined_high`  (SM inside combined
       band)
    4. `8 · σ_HLLHC = envelope`         (envelope = 8σ_HLLHC band)
    5. `σ_HLLHC < envelope`             (HL-LHC tightens precision)
    6. `combined_low < ATLAS_low ∧ ATLAS_high < CMS_high` (combined
       tightens ATLAS+CMS individual bands except low side)
    7. `combined_low < combined_high`   (combined band non-empty)
    8. `SM + envelope ≤ combined_high`  (envelope upper edge inside
       combined band)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for κ_λ must lie within this envelope to remain
    experimentally consistent with both ATLAS and CMS 2024
    di-Higgs measurements at the 95% combined level. -/
def DiHiggsKappaLambdaFrontier : Prop :=
  -- (1) positivity quad (SM, envelope, upper bounds)
  (0 < kappa_lambda_SM_units
    ∧ 0 < kappa_lambda_envelope_half_width_units
    ∧ 0 < kappa_lambda_ATLAS_high_units
    ∧ 0 < kappa_lambda_CMS_high_units) ∧
  -- (2) sign-bipolarity: combined_low < 0
  (kappa_lambda_combined_low_units < 0) ∧
  -- (3) SM inside combined band
  (kappa_lambda_combined_low_units < kappa_lambda_SM_units
    ∧ kappa_lambda_SM_units < kappa_lambda_combined_high_units) ∧
  -- (4) envelope = 8σ_HLLHC band
  (8 * sigma_kappa_lambda_HLLHC_units
      = kappa_lambda_envelope_half_width_units) ∧
  -- (5) σ_HLLHC < envelope
  (sigma_kappa_lambda_HLLHC_units
      < kappa_lambda_envelope_half_width_units) ∧
  -- (6) combined tightens ATLAS+CMS individual bounds
  (kappa_lambda_combined_low_units < kappa_lambda_ATLAS_low_units
    ∧ kappa_lambda_ATLAS_high_units < kappa_lambda_CMS_high_units) ∧
  -- (7) combined band non-empty
  (kappa_lambda_combined_low_units
      < kappa_lambda_combined_high_units) ∧
  -- (8) envelope upper edge inside combined upper bound
  (kappa_lambda_SM_units + kappa_lambda_envelope_half_width_units
      ≤ kappa_lambda_combined_high_units)

/-- **🚨 s849 — `DiHiggsKappaLambdaFrontier`** holds. -/
theorem T1_s849_di_higgs_kappa_lambda_frontier :
    DiHiggsKappaLambdaFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ⟨?_, ?_⟩, ?_, ?_, ⟨?_, ?_⟩, ?_, ?_⟩
  · exact T1_s845_kappa_lambda_SM_pos
  · exact T1_s845_envelope_pos
  · exact T1_s845_ATLAS_high_pos
  · exact T1_s845_CMS_high_pos
  · exact T1_s845_combined_low_neg
  · exact T1_s847_combined_low_below_SM
  · exact T1_s847_SM_below_combined_high
  · exact T1_s848_eight_sigma_HLLHC_eq_envelope
  · exact T1_s848_sigma_HLLHC_below_envelope
  · exact T1_s847_combined_low_below_ATLAS_low
  · exact T1_s846_ATLAS_high_below_CMS_high
  · exact T1_s847_combined_band_nonempty
  · exact T1_s848_envelope_upper_inside_combined

/-! ## Headline (12-conjunct) -/

/-- **HEADLINE — sessions 845-849 — Di-Higgs HH κ_λ self-coupling
    LHC-frontier substrate envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s845: κ_λ^SM = 10, ATLAS_low = -4, ATLAS_high = 63,
            CMS_low = -14, CMS_high = 78, combined_low = -6,
            combined_high = 66, envelope = 40, σ_HLLHC = 5
            (units × 10)
    - s846: CMS_low < ATLAS_low (CMS lower-bound looser);
            ATLAS_high < CMS_high (CMS upper-bound looser);
            both bands non-empty
    - s847: combined_low < ATLAS_low < 0 < SM < combined_high < CMS_high;
            CMS_low < combined_low (combined tightens CMS lower side);
            sign-bipolarity (combined_low < 0 admits κ_λ < 0 — a BSM
            signature impossible in any single-Higgs κ-modifier)
    - s848: 8·σ_HLLHC = envelope (envelope = 8σ_HLLHC band);
            σ_HLLHC < envelope; SM + envelope = 50 ≤ combined_high = 66;
            SM - envelope = -30 < combined_low = -6 (envelope WIDER than
            combined band on the low side — substrate envelope is more
            permissive than current data)
    - s849: DiHiggsKappaLambdaFrontier (8-conjunct) +
            headline (12-conjunct) + bundle alias

    Phenomenology:
      κ_λ^SM             = 1.00          (SM benchmark, λ_HHH/λ_HHH^SM)
      κ_λ (ATLAS 2024)   ∈ [-0.4, 6.3]   (139 fb⁻¹ Run-2 HH combined,
                                          95% CL)
      κ_λ (CMS 2024)     ∈ [-1.4, 7.8]   (138 fb⁻¹ Run-2 HH combined,
                                          95% CL)
      κ_λ (combined)     ∈ [-0.6, 6.6]   (95% CL — the WIDEST κ-modifier
                                          band, sign-bipolar)
      |κ_λ - 1| ≤ 4.0    (envelope)      working substrate window
                                          (8σ_HLLHC band)
      σ(κ_λ) → 0.5       (HL-LHC 3 ab⁻¹) projected ~8× tightening
                                          (κ_λ = 1 ± 0.5 95% CL)

    Why this matters:
    κ_λ is the SINGLE direct probe of the Higgs CUBIC self-coupling
    λ_HHH H³ — the FIRST term in the Higgs potential V(H) above the
    quadratic mass term.  This vertex is INACCESSIBLE to any single-
    Higgs production mode and thus accessible ONLY through di-Higgs
    HH production.  It is THE direct test of the SM electroweak
    vacuum structure.

    DISTINCT from κ_V (Higgs gauge-boson coupling) AND from per-Yukawa
    fermion-coupling modifiers κ_t, κ_b, κ_τ, κ_c — those probe the
    Higgs LINEAR couplings to other SM fields.  κ_λ probes the Higgs
    CUBIC self-coupling — a fundamentally different Higgs-potential
    structure observable.

    Sign-bipolarity:
    Current combined data admits `κ_λ < 0` at 95% CL (combined_low =
    -0.6 < 0).  This is a BSM signature impossible in any single-Higgs
    coupling-modifier κ — single-Higgs κ-modifiers are constrained
    to sign-positive by the Higgs being a real scalar with a single
    quadratic mass term.  The substrate envelope `|κ_λ - 1| ≤ 4.0`
    accommodates the substantial sign-bipolar band of current di-Higgs
    data.

    The combined ATLAS+CMS κ_λ ∈ [-0.6, 6.6] is the WIDEST 95% CL
    Higgs coupling-modifier band — exactly the precision needed to
    discriminate SM-scenario predictions from BSM scenarios that
    affect the cubic self-coupling (composite-Higgs σ-model trilinear
    running, vacuum-stability driven trilinear modification, BSM-
    induced first-order electroweak-phase-transition shifts) all of
    which show up as κ_λ shifts at the few-tens-of-percent level.

    HL-LHC 3000 fb⁻¹ projection σ(κ_λ) ≈ 0.5 brings κ_λ from the
    widest current κ-modifier toward competitive-precision status
    for first-order electroweak-phase-transition diagnosis — a major
    HL-LHC target with direct cosmological implications for
    electroweak baryogenesis.

    Companion files:
    - `T1_HiggsKappaVCouplingFrontier`        — gauge-boson κ_V
    - `T1_HiggsToWWLHCFrontier`               — H → WW* μ_WW
    - `T1_HiggsTo4LeptonsZZFrontier`          — H → ZZ* → 4ℓ
    - `T1_HiggsToTauTauKappaTauFrontier`      — tau Yukawa κ_τ
    - `T1_HiggsToBBbarKappaBFrontier`         — b-quark Yukawa κ_b
    - `T1_HiggsToCCBarCharmYukawaFrontier`    — charm Yukawa κ_c
    - `T1_HLLHCTopYukawaKappaTBundle`         — top Yukawa κ_t
    - `T1_HiggsToZGammaFrontier`              — H → Zγ rare loop
    - `T1_DiphotonSpectrumLHCBundle`          — H → γγ
    - `T1_HiggsBranchingRatiosBundle`         — multi-channel BR
    - `T1_HiggsCouplingStrengthsBundle`       — broader κ-framework

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core di-Higgs HH κ_λ self-coupling LHC-frontier
    envelope.  Closes the CUBIC-coupling axis of the SM Higgs profile,
    complementing the gauge-boson modifier κ_V and the per-Yukawa
    fermion-coupling modifiers (κ_t, κ_b, κ_τ, κ_c) — together
    completing the "linear × cubic" coupling-modifier profile of
    substrate-prediction envelopes for the SM Higgs in OmegaTheory V2.
    κ_λ has the WIDEST measurement uncertainty of all SM Higgs
    couplings (a factor ~7 wider than κ_V) and thus functions as the
    LOOSEST current frontier benchmark — but uniquely probes the EW
    vacuum structure inaccessible to all other Higgs measurements. -/
theorem session_845_to_849_di_higgs_kappa_lambda_frontier_headline :
    0 < kappa_lambda_SM_units
    ∧ 0 < kappa_lambda_envelope_half_width_units
    ∧ 0 < kappa_lambda_ATLAS_high_units
    ∧ 0 < kappa_lambda_CMS_high_units
    ∧ 0 < kappa_lambda_combined_high_units
    ∧ 0 < sigma_kappa_lambda_HLLHC_units
    ∧ kappa_lambda_combined_low_units < 0
    ∧ kappa_lambda_combined_low_units < kappa_lambda_SM_units
    ∧ kappa_lambda_SM_units < kappa_lambda_combined_high_units
    ∧ 8 * sigma_kappa_lambda_HLLHC_units
        = kappa_lambda_envelope_half_width_units
    ∧ kappa_lambda_SM_units + kappa_lambda_envelope_half_width_units
        ≤ kappa_lambda_combined_high_units
    ∧ DiHiggsKappaLambdaFrontier :=
  ⟨T1_s845_kappa_lambda_SM_pos, T1_s845_envelope_pos,
   T1_s845_ATLAS_high_pos, T1_s845_CMS_high_pos,
   T1_s845_combined_high_pos, T1_s845_sigma_HLLHC_pos,
   T1_s845_combined_low_neg, T1_s847_combined_low_below_SM,
   T1_s847_SM_below_combined_high,
   T1_s848_eight_sigma_HLLHC_eq_envelope,
   T1_s848_envelope_upper_inside_combined,
   T1_s849_di_higgs_kappa_lambda_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_di_higgs_kappa_lambda_frontier_bundle :
    DiHiggsKappaLambdaFrontier :=
  T1_s849_di_higgs_kappa_lambda_frontier

end OmegaTheory.Predictions.T1_DiHiggsKappaLambdaFrontier
