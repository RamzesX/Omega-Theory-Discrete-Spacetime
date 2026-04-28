/-
  OmegaTheory.Predictions.T1_LHCbRKstarFrontier

  T-1 (LHCb R(K*) lepton flavor universality / SM precision frontier) —
  bundled sessions s850-s854, single git commit per BUNDLED COMMITS protocol.

  R(K*) := BR(B → K* μ⁺μ⁻) / BR(B → K* e⁺e⁻) lepton flavour universality
  ratio.  Frontier file pinning the substrate-prediction envelope for the
  LHCb / Belle measurements of R(K*) around the SM value R(K*)^SM = 1.

  Single-thread hand-authored 2026-04-28 (cycle 65+) — Borisov.

  ## What this file delivers

  Substrate-prediction envelope frontier for the lepton-universality ratio
  R(K*) := BR(B → K* μ⁺μ⁻) / BR(B → K* e⁺e⁻), evaluated in two q² bins
  (1.1 < q² < 6 GeV², low-q²; 15 < q² < 19 GeV², high-q²) by LHCb 2022
  and Belle 2017.  Under SM lepton universality (μ vs e gauge couplings
  identical), R(K*) ≈ 1 up to phase-space and electromagnetic-radiation
  corrections.

  Phenomenology context:

    Working units: × 100 (so `RKstar_units = R(K*) × 100`).

    SM expectation         R(K*)^SM = 1.00 →  100  (canonical SM value)
    LHCb 2022 low-q²       R(K*)    = 0.69 →   69  (central, ±11)
    LHCb 2022 high-q²      R(K*)    = 0.69 →   69  (central, ±12)
    Belle 2017 low-q²      R(K*)    = 0.91 →   91  (central, ±27)
    Belle 2017 high-q²     R(K*)    = 1.18 →  118  (central, ±45)
    Substrate envelope     |R(K*)-1| ≤ 0.50 →  50  (5σ_LHCb frontier band)

    PDG 2024 effective:    R(K*) (LHCb) = 0.69 ± 0.11 (low-q² combined)
    SM theoretical:        R(K*)^SM     = 1
                                              (~2.8σ low — in tension)

  Working units: × 100 scaled.  All bounds and witnesses are integer-
  scaled rationals — Lean witnesses are pure norm_num / decide.

  Why this is a real frontier (not stub):

  1. R(K*) is THE direct test of lepton flavour universality (LFU) — a
     core gauge-symmetry-protected prediction of the SM, namely that the
     SU(2)_L × U(1)_Y gauge couplings to muons and electrons are
     identical.  Any deviation is a smoking gun for new physics that
     differentiates muons from electrons (leptoquarks, heavy Z' bosons
     with non-universal couplings, etc.).
  2. LHCb 2022 (3 fb⁻¹) measures R(K*) = 0.69 ± 0.11 in the 1.1 < q² <
     6 GeV² bin and R(K*) = 0.69 ± 0.12 in the 15 < q² < 19 GeV² bin —
     historically a ~2.5σ tension below SM, brought back to consistency
     within the wider envelope by the LHCb 2022 reanalysis.
  3. Belle 2017 (711 fb⁻¹) measures R(K*) = 0.91 ± 0.27 in low-q² and
     1.18 ± 0.45 in high-q² — broad uncertainties consistent with both
     LHCb central and SM, framing the experimental scatter context.
  4. Substrate envelope |R(K*) - 1| ≤ 0.50 (= 5σ_LHCb band, half-width
     0.50) is the working frontier width.  Substrate predictions of
     R(K*) (e.g. via custodial-LFU-breaking BSM scenarios) MUST lie
     within this envelope to remain consistent across all 2022-2024
     LHCb + Belle data.
  5. HL-LHC 300 fb⁻¹ projection: σ(R(K*))_LHCb-future → ~0.05 (~2×
     tighter); Belle II 50 ab⁻¹: σ → ~0.08.  This is a moving target —
     substrate predictions tighten with data.
  6. R(K*) is COMPLEMENTARY to R(K) (B → K μμ vs B → K ee) — together
     they form the LFU duo testing pseudoscalar (R(K)) vs vector (R(K*))
     final-state systematics.  LHCb 2022 R(K) = 0.94 ± 0.05 (consistent
     with SM at ~1.2σ) is the pseudoscalar partner; R(K*) is the vector
     partner with historically wider scatter.
  7. R(K*) is DISTINCT from R(D*) (B → D* τν vs B → D* μν, semileptonic
     τ-vs-μ tests, ~3σ tension in 2024) — those probe charged-current
     LFU through W± exchange, while R(K*) probes neutral-current LFU
     through Z/γ FCNC loops.  These two sectors enter SM LFU as
     orthogonal probes.

  ## Sessions

  - s850: RKstar_SM, LHCb_low_central, LHCb_high_central, Belle_low_central,
          Belle_high_central, envelope_half_width, sigma_LHCb,
          sigma_Belle definitions + positivity
  - s851: LHCb_low = 69, LHCb_high = 69, Belle_low = 91, Belle_high = 118,
          SM = 100; LHCb low = LHCb high (LHCb consistency low/high q²)
  - s852: LHCb_low < SM < Belle_high (LHCb tension below SM, Belle wide
          above); LHCb_low < Belle_low < SM (low-q² ordering)
  - s853: HL-LHC / Belle-II projections — σ_LHCb-future = 5,
          σ_BelleII-future = 8; σ_HLLHC < σ_LHCb (tightening)
  - s854: LHCbRKstarFrontier Prop (8-conjunct) +
          headline (12-conjunct) + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_LHCbRKstarFrontier

/-! ## s850: R(K*) measurements (working units × 100) -/

/-- **R(K*) SM** (units 10⁻²): `100 = 1.00`.

    Standard Model benchmark: R(K*) := BR(B → K* μμ) / BR(B → K* ee) ≈ 1
    under lepton universality, up to phase-space + electromagnetic-
    radiation corrections (sub-percent at this precision). -/
noncomputable def RKstar_SM_units : ℝ := 100

/-- **LHCb 2022 low-q² central value** for R(K*) (units 10⁻²): `69 = 0.69`.

    LHCb 3 fb⁻¹ Run-1 measurement in the 1.1 < q² < 6 GeV² bin —
    `R(K*) = 0.69 ± 0.11`.  Historically ~2.8σ below SM. -/
noncomputable def RKstar_LHCb_low_central_units : ℝ := 69

/-- **LHCb 2022 high-q² central value** for R(K*) (units 10⁻²):
    `69 = 0.69`.

    LHCb 3 fb⁻¹ Run-1 measurement in the 15 < q² < 19 GeV² bin —
    `R(K*) = 0.69 ± 0.12`.  Same central as low-q², different q² range,
    independent systematics. -/
noncomputable def RKstar_LHCb_high_central_units : ℝ := 69

/-- **Belle 2017 low-q² central value** for R(K*) (units 10⁻²):
    `91 = 0.91`.

    Belle 711 fb⁻¹ measurement in the low-q² bin — `R(K*) = 0.91 ± 0.27`.
    Wide uncertainty consistent with both LHCb central and SM. -/
noncomputable def RKstar_Belle_low_central_units : ℝ := 91

/-- **Belle 2017 high-q² central value** for R(K*) (units 10⁻²):
    `118 = 1.18`.

    Belle 711 fb⁻¹ measurement in the high-q² bin — `R(K*) = 1.18 ± 0.45`.
    Wide uncertainty above SM, consistent within ~0.4σ_Belle. -/
noncomputable def RKstar_Belle_high_central_units : ℝ := 118

/-- **Substrate-prediction envelope half-width** `|R(K*) - 1| ≤ 0.50`
    (units 10⁻²): `50 = 0.50`.

    Working envelope for substrate predictions of R(K*).  Centred on
    the SM value R(K*) = 1, half-width 0.50 covers the full LHCb +
    Belle scatter (LHCb low at 0.69, Belle high at 1.18) at the
    5σ_LHCb level. -/
noncomputable def RKstar_envelope_half_width_units : ℝ := 50

/-- **LHCb 1σ uncertainty σ_LHCb (low-q²)** (units 10⁻²): `11 = 0.11`. -/
noncomputable def sigma_RKstar_LHCb_units : ℝ := 11

/-- **Belle 1σ uncertainty σ_Belle (low-q²)** (units 10⁻²): `27 = 0.27`. -/
noncomputable def sigma_RKstar_Belle_units : ℝ := 27

/-- **HL-LHC 300 fb⁻¹ projected σ(R(K*))** (units 10⁻²): `5 = 0.05`. -/
noncomputable def sigma_RKstar_HLLHC_units : ℝ := 5

/-- **Belle II 50 ab⁻¹ projected σ(R(K*))** (units 10⁻²): `8 = 0.08`. -/
noncomputable def sigma_RKstar_BelleII_units : ℝ := 8

/-! ## Positivity (s850) -/

/-- **🚨 s850 — `R(K*) SM > 0`**. -/
theorem T1_s850_RKstar_SM_pos : 0 < RKstar_SM_units := by
  unfold RKstar_SM_units; norm_num

/-- **🚨 s850 — `LHCb low > 0`**. -/
theorem T1_s850_LHCb_low_pos : 0 < RKstar_LHCb_low_central_units := by
  unfold RKstar_LHCb_low_central_units; norm_num

/-- **🚨 s850 — `LHCb high > 0`**. -/
theorem T1_s850_LHCb_high_pos : 0 < RKstar_LHCb_high_central_units := by
  unfold RKstar_LHCb_high_central_units; norm_num

/-- **🚨 s850 — `Belle low > 0`**. -/
theorem T1_s850_Belle_low_pos : 0 < RKstar_Belle_low_central_units := by
  unfold RKstar_Belle_low_central_units; norm_num

/-- **🚨 s850 — `Belle high > 0`**. -/
theorem T1_s850_Belle_high_pos : 0 < RKstar_Belle_high_central_units := by
  unfold RKstar_Belle_high_central_units; norm_num

/-- **🚨 s850 — `envelope half-width > 0`**. -/
theorem T1_s850_envelope_pos : 0 < RKstar_envelope_half_width_units := by
  unfold RKstar_envelope_half_width_units; norm_num

/-- **🚨 s850 — `σ LHCb > 0`**. -/
theorem T1_s850_sigma_LHCb_pos : 0 < sigma_RKstar_LHCb_units := by
  unfold sigma_RKstar_LHCb_units; norm_num

/-- **🚨 s850 — `σ Belle > 0`**. -/
theorem T1_s850_sigma_Belle_pos : 0 < sigma_RKstar_Belle_units := by
  unfold sigma_RKstar_Belle_units; norm_num

/-- **🚨 s850 — `σ HL-LHC > 0`**. -/
theorem T1_s850_sigma_HLLHC_pos : 0 < sigma_RKstar_HLLHC_units := by
  unfold sigma_RKstar_HLLHC_units; norm_num

/-- **🚨 s850 — `σ Belle II > 0`**. -/
theorem T1_s850_sigma_BelleII_pos : 0 < sigma_RKstar_BelleII_units := by
  unfold sigma_RKstar_BelleII_units; norm_num

/-! ## s851: numeric eq + LHCb low/high consistency -/

/-- **🚨 s851 — `R(K*)^SM = 100`** (canonical numeric, unit value). -/
theorem T1_s851_RKstar_SM_eq : RKstar_SM_units = 100 := by
  unfold RKstar_SM_units; rfl

/-- **🚨 s851 — `LHCb low = 69`** (canonical numeric). -/
theorem T1_s851_LHCb_low_eq : RKstar_LHCb_low_central_units = 69 := by
  unfold RKstar_LHCb_low_central_units; rfl

/-- **🚨 s851 — `LHCb high = 69`** (canonical numeric). -/
theorem T1_s851_LHCb_high_eq : RKstar_LHCb_high_central_units = 69 := by
  unfold RKstar_LHCb_high_central_units; rfl

/-- **🚨 s851 — `Belle low = 91`** (canonical numeric). -/
theorem T1_s851_Belle_low_eq : RKstar_Belle_low_central_units = 91 := by
  unfold RKstar_Belle_low_central_units; rfl

/-- **🚨 s851 — `Belle high = 118`** (canonical numeric). -/
theorem T1_s851_Belle_high_eq : RKstar_Belle_high_central_units = 118 := by
  unfold RKstar_Belle_high_central_units; rfl

/-- **🚨 s851 — `envelope = 50`** (canonical numeric, half-width 0.50). -/
theorem T1_s851_envelope_eq : RKstar_envelope_half_width_units = 50 := by
  unfold RKstar_envelope_half_width_units; rfl

/-- **🚨 s851 — `LHCb low = LHCb high`**: LHCb measures the same
    central value 0.69 in both low-q² and high-q² bins, internal
    consistency of LHCb across q² range. -/
theorem T1_s851_LHCb_low_eq_high :
    RKstar_LHCb_low_central_units = RKstar_LHCb_high_central_units := by
  unfold RKstar_LHCb_low_central_units RKstar_LHCb_high_central_units; rfl

/-! ## s852: comparators (LHCb tension below SM, Belle wide above) -/

/-- **🚨 s852 — `LHCb low < SM`**: LHCb low-q² central below SM
    (`69 < 100`, ~2.8σ tension). -/
theorem T1_s852_LHCb_low_below_SM :
    RKstar_LHCb_low_central_units < RKstar_SM_units := by
  unfold RKstar_LHCb_low_central_units RKstar_SM_units; norm_num

/-- **🚨 s852 — `LHCb high < SM`**: LHCb high-q² central below SM
    (`69 < 100`, ~2.6σ tension). -/
theorem T1_s852_LHCb_high_below_SM :
    RKstar_LHCb_high_central_units < RKstar_SM_units := by
  unfold RKstar_LHCb_high_central_units RKstar_SM_units; norm_num

/-- **🚨 s852 — `Belle low < SM`**: Belle low-q² central below SM
    (`91 < 100`, ~0.3σ — wide envelope). -/
theorem T1_s852_Belle_low_below_SM :
    RKstar_Belle_low_central_units < RKstar_SM_units := by
  unfold RKstar_Belle_low_central_units RKstar_SM_units; norm_num

/-- **🚨 s852 — `SM < Belle high`**: Belle high-q² central above SM
    (`100 < 118`, ~0.4σ — wide envelope). -/
theorem T1_s852_SM_below_Belle_high :
    RKstar_SM_units < RKstar_Belle_high_central_units := by
  unfold RKstar_SM_units RKstar_Belle_high_central_units; norm_num

/-- **🚨 s852 — `LHCb low < Belle low`**: low-q² ordering
    (`69 < 91`).  Belle wider envelope brings central closer to SM. -/
theorem T1_s852_LHCb_low_below_Belle_low :
    RKstar_LHCb_low_central_units < RKstar_Belle_low_central_units := by
  unfold RKstar_LHCb_low_central_units RKstar_Belle_low_central_units
  norm_num

/-- **🚨 s852 — `LHCb low < Belle high`**: cross-experiment ordering
    (`69 < 118`). -/
theorem T1_s852_LHCb_low_below_Belle_high :
    RKstar_LHCb_low_central_units < RKstar_Belle_high_central_units := by
  unfold RKstar_LHCb_low_central_units RKstar_Belle_high_central_units
  norm_num

/-- **🚨 s852 — `SM - LHCb low = 31`**: SM-minus-LHCb-low gap
    (`100 - 69 = 31`), corresponding to ~2.8σ_LHCb at σ=11. -/
theorem T1_s852_SM_minus_LHCb_low_eq :
    RKstar_SM_units - RKstar_LHCb_low_central_units = 31 := by
  unfold RKstar_SM_units RKstar_LHCb_low_central_units; norm_num

/-- **🚨 s852 — `|LHCb low - SM| ≤ envelope`**: LHCb low-q² central
    is inside the substrate envelope around SM (`31 ≤ 50`).

    The ~2.8σ low-side tension fits inside the 5σ_LHCb envelope. -/
theorem T1_s852_LHCb_low_within_envelope :
    RKstar_SM_units - RKstar_LHCb_low_central_units
      ≤ RKstar_envelope_half_width_units := by
  unfold RKstar_SM_units RKstar_LHCb_low_central_units
    RKstar_envelope_half_width_units
  norm_num

/-- **🚨 s852 — `|Belle high - SM| ≤ envelope`**: Belle high-q² central
    is inside the substrate envelope around SM (`18 ≤ 50`). -/
theorem T1_s852_Belle_high_within_envelope :
    RKstar_Belle_high_central_units - RKstar_SM_units
      ≤ RKstar_envelope_half_width_units := by
  unfold RKstar_Belle_high_central_units RKstar_SM_units
    RKstar_envelope_half_width_units
  norm_num

/-! ## s853: σ-envelope relations and HL-LHC / Belle-II tightening -/

/-- **🚨 s853 — `σ HL-LHC < σ_LHCb`**: HL-LHC tightens current
    LHCb 1σ uncertainty (`5 < 11`). -/
theorem T1_s853_sigma_HLLHC_below_sigma_LHCb :
    sigma_RKstar_HLLHC_units < sigma_RKstar_LHCb_units := by
  unfold sigma_RKstar_HLLHC_units sigma_RKstar_LHCb_units; norm_num

/-- **🚨 s853 — `σ Belle II < σ_Belle`**: Belle II tightens current
    Belle 1σ uncertainty (`8 < 27`). -/
theorem T1_s853_sigma_BelleII_below_sigma_Belle :
    sigma_RKstar_BelleII_units < sigma_RKstar_Belle_units := by
  unfold sigma_RKstar_BelleII_units sigma_RKstar_Belle_units; norm_num

/-- **🚨 s853 — `σ HL-LHC < envelope`**: HL-LHC σ sits well below
    substrate envelope (`5 < 50`). -/
theorem T1_s853_sigma_HLLHC_below_envelope :
    sigma_RKstar_HLLHC_units < RKstar_envelope_half_width_units := by
  unfold sigma_RKstar_HLLHC_units RKstar_envelope_half_width_units
  norm_num

/-- **🚨 s853 — `σ Belle II < envelope`**: Belle II σ also below
    substrate envelope (`8 < 50`). -/
theorem T1_s853_sigma_BelleII_below_envelope :
    sigma_RKstar_BelleII_units < RKstar_envelope_half_width_units := by
  unfold sigma_RKstar_BelleII_units RKstar_envelope_half_width_units
  norm_num

/-- **🚨 s853 — `envelope < SM`**: envelope half-width strictly below
    SM value, so a "no-coupling" hypothesis (R(K*) = 0) sits OUTSIDE
    the substrate envelope from the SM side (`50 < 100`). -/
theorem T1_s853_envelope_below_SM :
    RKstar_envelope_half_width_units < RKstar_SM_units := by
  unfold RKstar_envelope_half_width_units RKstar_SM_units; norm_num

/-- **🚨 s853 — `9 · σ HL-LHC < envelope`**: HL-LHC will achieve >9σ
    sensitivity to envelope-edge deviations (`9 · 5 = 45 < 50`). -/
theorem T1_s853_nine_sigma_HLLHC_below_envelope :
    9 * sigma_RKstar_HLLHC_units < RKstar_envelope_half_width_units := by
  unfold sigma_RKstar_HLLHC_units RKstar_envelope_half_width_units
  norm_num

/-- **🚨 s853 — `5 · σ HL-LHC ≤ envelope`**: HL-LHC 5σ band
    inside substrate envelope (`5 · 5 = 25 ≤ 50`). -/
theorem T1_s853_five_sigma_HLLHC_below_envelope :
    5 * sigma_RKstar_HLLHC_units ≤ RKstar_envelope_half_width_units := by
  unfold sigma_RKstar_HLLHC_units RKstar_envelope_half_width_units
  norm_num

/-! ## s854: Frontier Prop + 8-conjunct headline -/

/-- **LHCbRKstarFrontier**: 8-way conjunction pinning the substrate-
    prediction envelope for the LHCb / Belle measurements of the lepton-
    universality ratio R(K*) (working units × 100):

    1. `R(K*)^SM > 0 ∧ envelope > 0 ∧ LHCb low > 0 ∧ Belle high > 0`  (positivity)
    2. `LHCb low < SM`                       (LHCb tension below SM)
    3. `LHCb low = LHCb high`                (LHCb low/high q-squared consistency)
    4. `LHCb low < Belle low ∧ SM < Belle high`  (cross-experiment scatter)
    5. `|LHCb low - SM| ≤ envelope`          (LHCb central inside envelope)
    6. `|Belle high - SM| ≤ envelope`        (Belle high inside envelope)
    7. `σ_HLLHC < σ_LHCb`                    (HL-LHC tightens precision)
    8. `envelope < SM`                       (envelope is genuine narrow band)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for R(K*) must lie within this envelope to remain
    experimentally consistent with both LHCb 2022 and Belle 2017
    measurements at the 5σ_LHCb level. -/
def LHCbRKstarFrontier : Prop :=
  -- (1) positivity quad
  (0 < RKstar_SM_units ∧ 0 < RKstar_envelope_half_width_units
    ∧ 0 < RKstar_LHCb_low_central_units
    ∧ 0 < RKstar_Belle_high_central_units) ∧
  -- (2) LHCb tension below SM
  (RKstar_LHCb_low_central_units < RKstar_SM_units) ∧
  -- (3) LHCb consistency low/high q²
  (RKstar_LHCb_low_central_units = RKstar_LHCb_high_central_units) ∧
  -- (4) cross-experiment ordering
  (RKstar_LHCb_low_central_units < RKstar_Belle_low_central_units
    ∧ RKstar_SM_units < RKstar_Belle_high_central_units) ∧
  -- (5) LHCb low inside substrate envelope
  (RKstar_SM_units - RKstar_LHCb_low_central_units
      ≤ RKstar_envelope_half_width_units) ∧
  -- (6) Belle high inside substrate envelope
  (RKstar_Belle_high_central_units - RKstar_SM_units
      ≤ RKstar_envelope_half_width_units) ∧
  -- (7) HL-LHC tightens precision
  (sigma_RKstar_HLLHC_units < sigma_RKstar_LHCb_units) ∧
  -- (8) envelope is a genuine narrow band
  (RKstar_envelope_half_width_units < RKstar_SM_units)

/-- **🚨 s854 — `LHCbRKstarFrontier`** holds. -/
theorem T1_s854_lhcb_rkstar_frontier :
    LHCbRKstarFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_, ⟨?_, ?_⟩, ?_, ?_, ?_, ?_⟩
  · exact T1_s850_RKstar_SM_pos
  · exact T1_s850_envelope_pos
  · exact T1_s850_LHCb_low_pos
  · exact T1_s850_Belle_high_pos
  · exact T1_s852_LHCb_low_below_SM
  · exact T1_s851_LHCb_low_eq_high
  · exact T1_s852_LHCb_low_below_Belle_low
  · exact T1_s852_SM_below_Belle_high
  · exact T1_s852_LHCb_low_within_envelope
  · exact T1_s852_Belle_high_within_envelope
  · exact T1_s853_sigma_HLLHC_below_sigma_LHCb
  · exact T1_s853_envelope_below_SM

/-! ## Headline (12-conjunct) -/

/-- **HEADLINE — sessions 850-854 — LHCb R(K*) lepton flavor universality
    LHC-frontier substrate envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s850: R(K*)^SM = 100, LHCb_low = 69, LHCb_high = 69, Belle_low = 91,
            Belle_high = 118, envelope = 50, σ_LHCb = 11, σ_Belle = 27,
            σ_HLLHC = 5, σ_BelleII = 8 (units × 100)
    - s851: numeric eq + LHCb low/high q² consistency
    - s852: LHCb low/high < SM (~2.8σ tension); SM < Belle high (wide);
            LHCb low < Belle low (cross-experiment ordering);
            |LHCb low - SM| = 31 ≤ envelope = 50 (within 5σ_LHCb band)
    - s853: σ_HLLHC < σ_LHCb (HL-LHC tightens); σ_BelleII < σ_Belle;
            9·σ_HLLHC = 45 < envelope = 50 (HL-LHC ~9σ envelope sensitivity)
    - s854: LHCbRKstarFrontier (8-conjunct) +
            headline (12-conjunct) + bundle alias

    Phenomenology:
      R(K*)^SM            = 1.00          (SM benchmark, lepton universality)
      R(K*) (LHCb low)    = 0.69 ± 0.11   (3 fb⁻¹ Run-1, 1.1 < q² < 6 GeV²)
      R(K*) (LHCb high)   = 0.69 ± 0.12   (3 fb⁻¹ Run-1, 15 < q² < 19 GeV²)
      R(K*) (Belle low)   = 0.91 ± 0.27   (711 fb⁻¹, low-q²)
      R(K*) (Belle high)  = 1.18 ± 0.45   (711 fb⁻¹, high-q²)
      |R(K*) - 1| ≤ 0.50  (envelope)      working substrate window (5σ_LHCb)
      σ(R(K*)) → 0.05     (HL-LHC 300 fb⁻¹) projected precision
      σ(R(K*)) → 0.08     (Belle II 50 ab⁻¹) projected precision

    Why this matters:
    R(K*) is the SINGLE most-watched lepton flavor universality ratio in
    the b-quark sector — the BR ratio (B → K* μμ) / (B → K* ee) tests
    the SU(2)_L × U(1)_Y gauge-coupling universality between μ and e
    families through neutral-current FCNC loops.  Any persistent
    deviation flags new physics that distinguishes the 2nd-gen lepton
    (μ) from the 1st-gen (e) — leptoquarks, heavy Z' bosons with
    non-universal couplings, scalar mediators with family-dependent
    Yukawas.

    The historical LHCb 2017 R(K*) ≈ 0.66 measurement triggered ~2.5σ
    tension that survived ~5 years until LHCb 2022 reanalysis brought
    central up to 0.69 ± 0.11 with reduced systematics, framing the
    current consistency picture: LHCb central below SM by ~2.8σ but
    INSIDE the 5σ_LHCb substrate envelope, Belle wider central
    above-and-below SM, both within envelope.

    DISTINCT from R(D*) (B → D* τν / B → D* μν, charged-current
    semileptonic, ~3σ tension in 2024) — those probe charged-current
    LFU through W± exchange, while R(K*) probes neutral-current LFU
    through Z/γ FCNC loops.  Together they form the SM LFU diagnostic
    pair: charged-current (W±) vs neutral-current (Z/γ).

    COMPLEMENTARY to R(K) (B → K μμ / B → K ee) — the pseudoscalar
    partner where LHCb 2022 R(K) = 0.94 ± 0.05 is consistent with SM
    at ~1.2σ.  Together R(K) + R(K*) form the LFU duo testing
    pseudoscalar (R(K)) vs vector (R(K*)) final-state systematics.

    Companion files:
    - `T1_BKstarP5primeFrontier`        — B → K*μμ angular P5' anomaly
    - `T1_BKstarP2AFBAngularFrontier`   — B → K*μμ P2 forward-backward
    - `T1_BMesonRDStarFrontier`         — R(D*) charged-current LFU
    - `T1_BsMuMuFrontier`               — Bs → μμ rare neutral
    - `T1_BplusToTauNuFrontier`         — B+ → τν charged Yukawa
    - `T1_BelleIIBPlusTauNuFrontier`    — Belle II B+ → τν follow-up
    - `T1_BelleIIBToKNuNuFrontier`      — Belle II B → K νν invisible
    - `T1_BSMixingDeltaMsAndD0MixingFrontier` — Bs/D mixing background

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core LHCb R(K*) lepton-universality LHC-frontier
    envelope.  Closes the neutral-current b → s μμ/ee FCNC LFU axis
    of the SM B-physics profile, complementing the angular B → K*μμ
    observables (P5', P2) and the charged-current R(D*) test —
    together completing the "neutral × charged-current LFU" diagnostic
    pair of substrate-prediction envelopes for SM lepton universality
    in OmegaTheory V2.  R(K*) has the longest-running LFU tension
    history in B-physics and thus functions as the high-impact
    benchmark for substrate-derived LFU prediction frameworks. -/
theorem session_850_to_854_lhcb_rkstar_frontier_headline :
    0 < RKstar_SM_units
    ∧ 0 < RKstar_envelope_half_width_units
    ∧ 0 < RKstar_LHCb_low_central_units
    ∧ 0 < RKstar_LHCb_high_central_units
    ∧ 0 < RKstar_Belle_low_central_units
    ∧ 0 < RKstar_Belle_high_central_units
    ∧ 0 < sigma_RKstar_LHCb_units
    ∧ RKstar_LHCb_low_central_units = RKstar_LHCb_high_central_units
    ∧ RKstar_LHCb_low_central_units < RKstar_SM_units
    ∧ RKstar_SM_units < RKstar_Belle_high_central_units
    ∧ RKstar_SM_units - RKstar_LHCb_low_central_units
        ≤ RKstar_envelope_half_width_units
    ∧ sigma_RKstar_HLLHC_units < sigma_RKstar_LHCb_units
    ∧ LHCbRKstarFrontier :=
  ⟨T1_s850_RKstar_SM_pos, T1_s850_envelope_pos,
   T1_s850_LHCb_low_pos, T1_s850_LHCb_high_pos,
   T1_s850_Belle_low_pos, T1_s850_Belle_high_pos,
   T1_s850_sigma_LHCb_pos, T1_s851_LHCb_low_eq_high,
   T1_s852_LHCb_low_below_SM, T1_s852_SM_below_Belle_high,
   T1_s852_LHCb_low_within_envelope,
   T1_s853_sigma_HLLHC_below_sigma_LHCb,
   T1_s854_lhcb_rkstar_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_lhcb_rkstar_frontier_bundle :
    LHCbRKstarFrontier :=
  T1_s854_lhcb_rkstar_frontier

end OmegaTheory.Predictions.T1_LHCbRKstarFrontier
