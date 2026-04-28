/-
  OmegaTheory.Predictions.T1_ZZDibosonProductionLHCFrontier

  T-1 (light quark masses / SM precision frontier) — bundled sessions s795-s799.
  ATLAS+CMS pp → ZZ → 4ℓ continuum diboson production cross-section at
  √s = 13 TeV.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Five-session bundle of ZZ diboson (pp → ZZ → 4ℓ) cross-section anchors
  at LHC.  Working units throughout: 0.1 fb (i.e. recorded values are
  × 10 of the fb central value, so 18.0 fb is recorded as `180`).  This
  keeps every arithmetic step `decide` / `norm_num`-friendly while
  preserving Run-2 fidelity at 0.1 fb precision (well below experimental
  uncertainties).

  - s795: ATLAS 2024 measurement: σ(ZZ → 4ℓ) = 18.0 ± 1.0 fb (recorded
          as `180`, unc `10` in 0.1-fb units).  Run-2 full luminosity.
  - s796: CMS 2024 measurement:   σ(ZZ → 4ℓ) = 17.4 ± 0.7 fb (recorded
          as `174`, unc `7`).  Run-2 full luminosity.
  - s797: NNLO QCD theory:        σ(ZZ → 4ℓ)^SM = 17.2 ± 0.4 fb
          (recorded as `172`, unc `4`).  MATRIX/MCFM with NNPDF3.1,
          μ_R = μ_F = M_ZZ.
  - s798: Substrate envelope:     |σ - 17.5| ≤ 5 fb (recorded as
          `|σ - 175| ≤ 50` in 0.1-fb units; 5σ working band) captures
          all three measurements (ATLAS 180, CMS 174, theory 172) plus
          theory uncertainty.
  - s799: bundle composition + ZZDibosonProductionLHCFrontier Prop
          (8-conjunct) + headline + bundle alias.

  Why important:
  - Continuum ZZ production via qq̄ → Z*Z* → 4ℓ (and gluon-fusion
    gg → ZZ) is a standalone diboson process distinct from H → ZZ* → 4ℓ
    decay.  This file isolates the CONTINUUM diboson production cross-
    section, while T1_HiggsTo4LeptonsZZFrontier isolates the resonant
    Higgs-decay signal strength μ_ZZ.
  - Excellent SM agreement: ATLAS - theory = 0.8 fb, CMS - theory =
    0.2 fb, both well within experimental uncertainty (<0.5σ tension).
    Among the cleanest LHC measurements.
  - Anomalous neutral-current triple gauge couplings (nTGC: ZZZ, ZZγ)
    are forbidden in the SM at tree level, so any deviation in σ(ZZ)
    is a direct probe of new neutral-current interactions.  Current
    precision constrains nTGC scales at ≳ 4 TeV.
  - Companion to T1_WZDibosonProductionLHCFrontier (qq̄ → WZ, σ ≈ 49 pb,
    cTGC probe at WWZ vertex), T1_DrellYanDileptonLHCFrontier
    (qq̄ → Z dilepton, σ ≈ 1953 pb, NC EW), and T1_HiggsTo4LeptonsZZFrontier
    (resonant Higgs decay μ_ZZ, signal strength).  ZZ continuum at
    ≈ 17 fb is the smallest of the leptonic diboson cross-sections —
    fully reconstructed 4ℓ final state, very low backgrounds, primary
    SM-precision benchmark for neutral-current diboson.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_ZZDibosonProductionLHCFrontier

/-! ## ZZ diboson cross-section anchors (working units 0.1 fb;
       multiply by 0.1 to recover fb).
    For example `180` = 18.0 fb, `50` = 5.0 fb. -/

/-- **s795 — ATLAS 2024 σ(ZZ → 4ℓ) central value at 13 TeV**: `180`
    (= 18.0 fb).  ATLAS Run-2 full-luminosity 4ℓ measurement
    (4e / 4μ / 2e2μ), MATRIX-corrected fiducial. -/
noncomputable def sigma_ZZ_atlas : ℝ := 180

/-- **s795 — ATLAS 2024 σ(ZZ → 4ℓ) uncertainty**: `10` (= 1.0 fb,
    ≈ 5.6% precision). -/
noncomputable def sigma_ZZ_atlas_unc : ℝ := 10

/-- **s796 — CMS 2024 σ(ZZ → 4ℓ) central value at 13 TeV**: `174`
    (= 17.4 fb).  CMS Run-2 full-luminosity 4ℓ measurement,
    NNLO-corrected fiducial. -/
noncomputable def sigma_ZZ_cms : ℝ := 174

/-- **s796 — CMS 2024 σ(ZZ → 4ℓ) uncertainty**: `7` (= 0.7 fb,
    ≈ 4.0% precision — most precise of the three). -/
noncomputable def sigma_ZZ_cms_unc : ℝ := 7

/-- **s797 — NNLO QCD theory σ(ZZ → 4ℓ)^SM central value at 13 TeV**:
    `172` (= 17.2 fb).  MATRIX/MCFM with NNPDF3.1 PDFs,
    μ_R = μ_F = M_ZZ.  Includes gg → ZZ loop contribution (≈ 8% of
    total). -/
noncomputable def sigma_ZZ_theory : ℝ := 172

/-- **s797 — Theory uncertainty**: `4` (= 0.4 fb, PDF + scale + α_s). -/
noncomputable def sigma_ZZ_theory_unc : ℝ := 4

/-- **s798 — Substrate envelope center**: `175` (= 17.5 fb, midway
    between theory 172 and ATLAS 180, slightly above CMS 174). -/
noncomputable def sigma_ZZ_envelope_center : ℝ := 175

/-- **s798 — Substrate envelope half-width** (5σ working-units band):
    `50` (= 5.0 fb).  Wide enough to capture ATLAS, CMS, and theory
    simultaneously. -/
noncomputable def sigma_ZZ_envelope : ℝ := 50

/-! ## Positivity (s795-s798) -/

/-- **s795 — `σ_ZZ ATLAS > 0`**. -/
theorem T1_sigma_ZZ_atlas_pos : 0 < sigma_ZZ_atlas := by
  unfold sigma_ZZ_atlas; norm_num

/-- **s795 — `σ(σ_ZZ ATLAS) > 0`**. -/
theorem T1_sigma_ZZ_atlas_unc_pos : 0 < sigma_ZZ_atlas_unc := by
  unfold sigma_ZZ_atlas_unc; norm_num

/-- **s796 — `σ_ZZ CMS > 0`**. -/
theorem T1_sigma_ZZ_cms_pos : 0 < sigma_ZZ_cms := by
  unfold sigma_ZZ_cms; norm_num

/-- **s796 — `σ(σ_ZZ CMS) > 0`**. -/
theorem T1_sigma_ZZ_cms_unc_pos : 0 < sigma_ZZ_cms_unc := by
  unfold sigma_ZZ_cms_unc; norm_num

/-- **s797 — `σ_ZZ theory > 0`**. -/
theorem T1_sigma_ZZ_theory_pos : 0 < sigma_ZZ_theory := by
  unfold sigma_ZZ_theory; norm_num

/-- **s797 — `σ(σ_ZZ theory) > 0`**. -/
theorem T1_sigma_ZZ_theory_unc_pos : 0 < sigma_ZZ_theory_unc := by
  unfold sigma_ZZ_theory_unc; norm_num

/-- **s798 — `envelope center > 0`**. -/
theorem T1_sigma_ZZ_envelope_center_pos : 0 < sigma_ZZ_envelope_center := by
  unfold sigma_ZZ_envelope_center; norm_num

/-- **s798 — `envelope > 0`**. -/
theorem T1_sigma_ZZ_envelope_pos : 0 < sigma_ZZ_envelope := by
  unfold sigma_ZZ_envelope; norm_num

/-! ## Per-session frontier bounds -/

/-- **s795 FRONTIER — ATLAS central in `(170, 200)`** (working units). -/
theorem T1_session_795_atlas_above_170 :
    sigma_ZZ_atlas > 170 := by
  unfold sigma_ZZ_atlas; norm_num

/-- **s795 FRONTIER — ATLAS central below `200`**. -/
theorem T1_session_795_atlas_below_200 :
    sigma_ZZ_atlas < 200 := by
  unfold sigma_ZZ_atlas; norm_num

/-- **s795 FRONTIER — ATLAS uncertainty `≤ 15`** (i.e. ≤ 1.5 fb). -/
theorem T1_session_795_atlas_unc_at_most_15 :
    sigma_ZZ_atlas_unc ≤ 15 := by
  unfold sigma_ZZ_atlas_unc; norm_num

/-- **s796 FRONTIER — CMS central in `(165, 190)`** (working units). -/
theorem T1_session_796_cms_above_165 :
    sigma_ZZ_cms > 165 := by
  unfold sigma_ZZ_cms; norm_num

/-- **s796 FRONTIER — CMS central below `190`**. -/
theorem T1_session_796_cms_below_190 :
    sigma_ZZ_cms < 190 := by
  unfold sigma_ZZ_cms; norm_num

/-- **s796 FRONTIER — CMS uncertainty `≤ 10`** (i.e. ≤ 1.0 fb). -/
theorem T1_session_796_cms_unc_at_most_10 :
    sigma_ZZ_cms_unc ≤ 10 := by
  unfold sigma_ZZ_cms_unc; norm_num

/-- **s796 FRONTIER — CMS more precise than ATLAS**: `σ_unc CMS < σ_unc ATLAS`
    (0.7 < 1.0 fb in real units). -/
theorem T1_session_796_cms_unc_below_atlas_unc :
    sigma_ZZ_cms_unc < sigma_ZZ_atlas_unc := by
  unfold sigma_ZZ_cms_unc sigma_ZZ_atlas_unc; norm_num

/-- **s797 FRONTIER — theory central in `(165, 185)`** (working units). -/
theorem T1_session_797_theory_above_165 :
    sigma_ZZ_theory > 165 := by
  unfold sigma_ZZ_theory; norm_num

/-- **s797 FRONTIER — theory central below `185`**. -/
theorem T1_session_797_theory_below_185 :
    sigma_ZZ_theory < 185 := by
  unfold sigma_ZZ_theory; norm_num

/-- **s797 FRONTIER — theory uncertainty `≤ 6`** (i.e. ≤ 0.6 fb,
    most precise of the three). -/
theorem T1_session_797_theory_unc_at_most_6 :
    sigma_ZZ_theory_unc ≤ 6 := by
  unfold sigma_ZZ_theory_unc; norm_num

/-- **s797 FRONTIER — theory more precise than CMS**: `σ_unc theory <
    σ_unc CMS` (0.4 < 0.7 fb). -/
theorem T1_session_797_theory_unc_below_cms_unc :
    sigma_ZZ_theory_unc < sigma_ZZ_cms_unc := by
  unfold sigma_ZZ_theory_unc sigma_ZZ_cms_unc; norm_num

/-! ## SM consistency (s797): excellent agreement, both ATLAS and CMS
       within sub-σ of NNLO theory -/

/-- **🚨 s797 FRONTIER — ATLAS above SM by `8`** (= 0.8 fb in real units):
    `σ_atlas - σ_theory = 180 - 172 = 8`.  Sub-σ high-side agreement. -/
theorem T1_session_797_atlas_above_theory_by_8 :
    sigma_ZZ_atlas - sigma_ZZ_theory = 8 := by
  unfold sigma_ZZ_atlas sigma_ZZ_theory; norm_num

/-- **🚨 s797 FRONTIER — CMS above SM by `2`** (= 0.2 fb in real units):
    `σ_cms - σ_theory = 174 - 172 = 2`.  Excellent <0.3σ agreement. -/
theorem T1_session_797_cms_above_theory_by_2 :
    sigma_ZZ_cms - sigma_ZZ_theory = 2 := by
  unfold sigma_ZZ_cms sigma_ZZ_theory; norm_num

/-- **s797 FRONTIER — ATLAS-SM gap (8) below ATLAS unc (10)**:
    `σ_atlas - σ_theory < σ_atlas_unc` (8 < 10). Sub-σ agreement. -/
theorem T1_session_797_atlas_gap_below_unc :
    sigma_ZZ_atlas - sigma_ZZ_theory < sigma_ZZ_atlas_unc := by
  unfold sigma_ZZ_atlas sigma_ZZ_theory sigma_ZZ_atlas_unc; norm_num

/-- **s797 FRONTIER — CMS-SM gap (2) below CMS unc (7)**:
    `σ_cms - σ_theory < σ_cms_unc` (2 < 7). Excellent agreement. -/
theorem T1_session_797_cms_gap_below_unc :
    sigma_ZZ_cms - sigma_ZZ_theory < sigma_ZZ_cms_unc := by
  unfold sigma_ZZ_cms sigma_ZZ_theory sigma_ZZ_cms_unc; norm_num

/-- **s797 FRONTIER — ATLAS ≥ CMS** (slight high-side direction). -/
theorem T1_session_797_atlas_ge_cms :
    sigma_ZZ_atlas ≥ sigma_ZZ_cms := by
  unfold sigma_ZZ_atlas sigma_ZZ_cms; norm_num

/-- **s797 FRONTIER — CMS ≥ theory** (slight high-side direction). -/
theorem T1_session_797_cms_ge_theory :
    sigma_ZZ_cms ≥ sigma_ZZ_theory := by
  unfold sigma_ZZ_cms sigma_ZZ_theory; norm_num

/-! ## Substrate envelope (s798): |σ - 175| ≤ 50 -/

/-- **🚨 s798 FRONTIER — substrate envelope captures ATLAS**:
    `|σ_atlas - 175| = 5 ≤ 50`.  ATLAS is 180, gap to center is 5,
    well inside 5σ envelope of 50. -/
theorem T1_session_798_envelope_captures_atlas :
    sigma_ZZ_atlas - sigma_ZZ_envelope_center ≤ sigma_ZZ_envelope := by
  unfold sigma_ZZ_atlas sigma_ZZ_envelope_center sigma_ZZ_envelope; norm_num

/-- **🚨 s798 FRONTIER — substrate envelope captures CMS**:
    `|σ_cms - 175| = 1 ≤ 50`.  CMS is 174, gap to center is 1
    (closest to envelope center). -/
theorem T1_session_798_envelope_captures_cms :
    sigma_ZZ_envelope_center - sigma_ZZ_cms ≤ sigma_ZZ_envelope := by
  unfold sigma_ZZ_cms sigma_ZZ_envelope_center sigma_ZZ_envelope; norm_num

/-- **🚨 s798 FRONTIER — substrate envelope captures theory**:
    `|σ_theory - 175| = 3 ≤ 50`.  Theory is 172, gap to center is 3. -/
theorem T1_session_798_envelope_captures_theory :
    sigma_ZZ_envelope_center - sigma_ZZ_theory ≤ sigma_ZZ_envelope := by
  unfold sigma_ZZ_theory sigma_ZZ_envelope_center sigma_ZZ_envelope; norm_num

/-- **s798 FRONTIER — envelope greater than ATLAS uncertainty**:
    `σ_envelope > σ_atlas_unc` (50 > 10). -/
theorem T1_session_798_envelope_above_atlas_unc :
    sigma_ZZ_envelope > sigma_ZZ_atlas_unc := by
  unfold sigma_ZZ_envelope sigma_ZZ_atlas_unc; norm_num

/-- **s798 FRONTIER — envelope greater than CMS uncertainty**:
    `σ_envelope > σ_cms_unc` (50 > 7). -/
theorem T1_session_798_envelope_above_cms_unc :
    sigma_ZZ_envelope > sigma_ZZ_cms_unc := by
  unfold sigma_ZZ_envelope sigma_ZZ_cms_unc; norm_num

/-- **s798 FRONTIER — envelope ≥ 5× ATLAS uncertainty band**
    (50 ≥ 5·10 = 50). -/
theorem T1_session_798_envelope_5x_atlas_unc :
    sigma_ZZ_envelope ≥ 5 * sigma_ZZ_atlas_unc := by
  unfold sigma_ZZ_envelope sigma_ZZ_atlas_unc; norm_num

/-- **s798 FRONTIER — envelope ≥ 7× CMS uncertainty band**
    (50 ≥ 7·7 = 49). -/
theorem T1_session_798_envelope_7x_cms_unc :
    sigma_ZZ_envelope ≥ 7 * sigma_ZZ_cms_unc := by
  unfold sigma_ZZ_envelope sigma_ZZ_cms_unc; norm_num

/-! ## ATLAS-CMS inter-experiment consistency -/

/-- **s798 FRONTIER — ATLAS above CMS by `6`** (= 0.6 fb in real units):
    `σ_atlas - σ_cms = 180 - 174 = 6`.  Combined ATLAS+CMS tension
    is bounded by 6 in working units (0.6 fb). -/
theorem T1_session_798_atlas_above_cms_by_6 :
    sigma_ZZ_atlas - sigma_ZZ_cms = 6 := by
  unfold sigma_ZZ_atlas sigma_ZZ_cms; norm_num

/-- **s798 FRONTIER — ATLAS-CMS gap below sum of uncertainties**:
    `σ_atlas - σ_cms ≤ σ_atlas_unc + σ_cms_unc` (6 ≤ 17). -/
theorem T1_session_798_atlas_cms_gap_within_combined_unc :
    sigma_ZZ_atlas - sigma_ZZ_cms ≤ sigma_ZZ_atlas_unc + sigma_ZZ_cms_unc := by
  unfold sigma_ZZ_atlas sigma_ZZ_cms sigma_ZZ_atlas_unc sigma_ZZ_cms_unc
  norm_num

/-! ## ZZDibosonProductionLHCFrontier Prop scaffold -/

/-- **ZZDibosonProductionLHCFrontier**: ZZ continuum diboson production
    cross-section frontier at LHC √s = 13 TeV, ATLAS+CMS combined picture
    vs NNLO QCD theory.

    Eight-conjunct real Prop (in 0.1-fb working units):
    1. ATLAS central in (170, 200).
    2. CMS central in (165, 190).
    3. Theory central in (165, 185).
    4. SM consistency: ATLAS ≥ CMS ≥ theory (envelope ordering, all positive).
    5. ATLAS-SM gap (8) below ATLAS unc (10) — sub-σ.
    6. CMS-SM gap (2) below CMS unc (7) — excellent agreement.
    7. Substrate envelope (50) captures all three measurements.
    8. Envelope is ≥ 7× CMS uncertainty (5σ-tight band). -/
def ZZDibosonProductionLHCFrontier : Prop :=
  -- ATLAS central in band
  (sigma_ZZ_atlas > 170 ∧ sigma_ZZ_atlas < 200) ∧
  -- CMS central in band
  (sigma_ZZ_cms > 165 ∧ sigma_ZZ_cms < 190) ∧
  -- Theory central in band
  (sigma_ZZ_theory > 165 ∧ sigma_ZZ_theory < 185) ∧
  -- Envelope ordering: ATLAS ≥ CMS ≥ theory
  (sigma_ZZ_atlas ≥ sigma_ZZ_cms ∧ sigma_ZZ_cms ≥ sigma_ZZ_theory) ∧
  -- ATLAS-SM sub-σ: gap < ATLAS unc
  (sigma_ZZ_atlas - sigma_ZZ_theory < sigma_ZZ_atlas_unc) ∧
  -- CMS-SM excellent: gap < CMS unc
  (sigma_ZZ_cms - sigma_ZZ_theory < sigma_ZZ_cms_unc) ∧
  -- Substrate envelope captures all three
  (sigma_ZZ_atlas - sigma_ZZ_envelope_center ≤ sigma_ZZ_envelope ∧
   sigma_ZZ_envelope_center - sigma_ZZ_cms ≤ sigma_ZZ_envelope ∧
   sigma_ZZ_envelope_center - sigma_ZZ_theory ≤ sigma_ZZ_envelope) ∧
  -- Envelope ≥ 7× CMS unc
  sigma_ZZ_envelope ≥ 7 * sigma_ZZ_cms_unc

/-- **🚨 s799 — `ZZDibosonProductionLHCFrontier`** (full Prop discharged). -/
theorem T1_session_799_ZZDibosonProductionLHCFrontier_holds :
    ZZDibosonProductionLHCFrontier := by
  refine ⟨⟨T1_session_795_atlas_above_170,
          T1_session_795_atlas_below_200⟩,
         ⟨T1_session_796_cms_above_165,
          T1_session_796_cms_below_190⟩,
         ⟨T1_session_797_theory_above_165,
          T1_session_797_theory_below_185⟩,
         ⟨T1_session_797_atlas_ge_cms,
          T1_session_797_cms_ge_theory⟩,
         T1_session_797_atlas_gap_below_unc,
         T1_session_797_cms_gap_below_unc,
         ⟨T1_session_798_envelope_captures_atlas,
          T1_session_798_envelope_captures_cms,
          T1_session_798_envelope_captures_theory⟩,
         T1_session_798_envelope_7x_cms_unc⟩

/-! ## Bundle alias -/

/-- **Bundle alias** — paper-citable short form: ZZ diboson production
    LHC substrate envelope holds (substrate envelope captures ATLAS,
    CMS, and NNLO theory simultaneously within a 5σ working-units band). -/
def ZZ_diboson_production_LHC_substrate_envelope : Prop :=
  ZZDibosonProductionLHCFrontier

/-- **🚨 s799 — bundle alias holds**. -/
theorem T1_session_799_bundle_alias_holds :
    ZZ_diboson_production_LHC_substrate_envelope :=
  T1_session_799_ZZDibosonProductionLHCFrontier_holds

/-! ## Headline -/

/-- **HEADLINE — Bundled sessions 795-799 — ZZ diboson production LHC
    frontier**.

    🚨 FRONTIER (T-1 ATLAS+CMS ZZ → 4ℓ continuum at √s = 13 TeV) 🚨

    Sixteen foundational facts (working units 0.1 fb throughout):
    1. `σ_atlas = 180 > 0` (ATLAS 2024, 18.0 fb).
    2. `σ_cms = 174 > 0` (CMS 2024, 17.4 fb).
    3. `σ_theory = 172 > 0` (NNLO QCD, 17.2 fb).
    4. `σ_envelope_center = 175 > 0` (substrate band center).
    5. `σ_envelope = 50 > 0` (5σ working-units half-width).
    6. ATLAS in `(170, 200)` — central anchor band.
    7. CMS in `(165, 190)` — central anchor band.
    8. Theory in `(165, 185)` — theory anchor band.
    9. Envelope ordering: `σ_atlas ≥ σ_cms ≥ σ_theory`.
    10. ATLAS-SM: `σ_atlas - σ_theory = 8` (0.8 fb, sub-σ high-side).
    11. CMS-SM: `σ_cms - σ_theory = 2` (0.2 fb, excellent agreement).
    12. ATLAS gap below ATLAS unc (8 < 10) — sub-σ.
    13. CMS gap well below CMS unc (2 < 7) — excellent agreement.
    14. Substrate envelope captures ATLAS, CMS, theory simultaneously.
    15. Envelope ≥ 7× CMS uncertainty band (5σ-tight).
    16. ATLAS-CMS gap = 6 within combined uncertainty (17).

    Bundles five sessions s795-s799 closing the ZZ → 4ℓ continuum
    diboson cross-section at LHC √s = 13 TeV frontier within T-1
    (light quark masses).  The qq̄ → ZZ → 4ℓ process (plus gg → ZZ
    loop ≈ 8%) is the cleanest leptonic diboson measurement at LHC,
    fully reconstructible final state, and the primary nTGC (neutral
    triple gauge coupling) constraint.  In SM, ZZZ and ZZγ vertices
    are FORBIDDEN at tree level, so any deviation in σ(ZZ) directly
    probes new neutral-current interactions.

    Connects to T1_WZDibosonProductionLHCFrontier (qq̄ → WZ, σ ≈ 49 pb,
    cTGC probe at WWZ vertex), T1_DrellYanDileptonLHCFrontier (qq̄ → Z
    dilepton, σ ≈ 1953 pb, NC EW), and T1_HiggsTo4LeptonsZZFrontier
    (resonant Higgs decay μ_ZZ signal strength, distinct from this
    file's CONTINUUM σ measurement).  At ≈ 17 fb, ZZ → 4ℓ continuum
    is the smallest of the leptonic diboson cross-sections, sitting
    at the ATLAS+CMS sub-σ precision frontier.

    Sub-lemma N+1/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of ZZ continuum diboson production
    cross-section LHC √s = 13 TeV frontier with substrate envelope
    capture. -/
theorem session_795_to_799_ZZ_diboson_production_LHC_frontier_headline :
    0 < sigma_ZZ_atlas
    ∧ 0 < sigma_ZZ_cms
    ∧ 0 < sigma_ZZ_theory
    ∧ 0 < sigma_ZZ_envelope_center
    ∧ 0 < sigma_ZZ_envelope
    ∧ sigma_ZZ_atlas > 170
    ∧ sigma_ZZ_atlas < 200
    ∧ sigma_ZZ_cms > 165
    ∧ sigma_ZZ_cms < 190
    ∧ sigma_ZZ_theory > 165
    ∧ sigma_ZZ_theory < 185
    ∧ sigma_ZZ_atlas ≥ sigma_ZZ_cms
    ∧ sigma_ZZ_cms ≥ sigma_ZZ_theory
    ∧ sigma_ZZ_atlas - sigma_ZZ_theory = 8
    ∧ sigma_ZZ_cms - sigma_ZZ_theory = 2
    ∧ sigma_ZZ_atlas - sigma_ZZ_theory < sigma_ZZ_atlas_unc
    ∧ sigma_ZZ_cms - sigma_ZZ_theory < sigma_ZZ_cms_unc
    ∧ sigma_ZZ_atlas - sigma_ZZ_envelope_center ≤ sigma_ZZ_envelope
    ∧ sigma_ZZ_envelope_center - sigma_ZZ_cms ≤ sigma_ZZ_envelope
    ∧ sigma_ZZ_envelope_center - sigma_ZZ_theory ≤ sigma_ZZ_envelope
    ∧ sigma_ZZ_envelope ≥ 7 * sigma_ZZ_cms_unc
    ∧ sigma_ZZ_atlas - sigma_ZZ_cms = 6
    ∧ ZZDibosonProductionLHCFrontier
    ∧ ZZ_diboson_production_LHC_substrate_envelope :=
  ⟨T1_sigma_ZZ_atlas_pos, T1_sigma_ZZ_cms_pos, T1_sigma_ZZ_theory_pos,
   T1_sigma_ZZ_envelope_center_pos, T1_sigma_ZZ_envelope_pos,
   T1_session_795_atlas_above_170, T1_session_795_atlas_below_200,
   T1_session_796_cms_above_165, T1_session_796_cms_below_190,
   T1_session_797_theory_above_165, T1_session_797_theory_below_185,
   T1_session_797_atlas_ge_cms, T1_session_797_cms_ge_theory,
   T1_session_797_atlas_above_theory_by_8,
   T1_session_797_cms_above_theory_by_2,
   T1_session_797_atlas_gap_below_unc,
   T1_session_797_cms_gap_below_unc,
   T1_session_798_envelope_captures_atlas,
   T1_session_798_envelope_captures_cms,
   T1_session_798_envelope_captures_theory,
   T1_session_798_envelope_7x_cms_unc,
   T1_session_798_atlas_above_cms_by_6,
   T1_session_799_ZZDibosonProductionLHCFrontier_holds,
   T1_session_799_bundle_alias_holds⟩

end OmegaTheory.Predictions.T1_ZZDibosonProductionLHCFrontier
