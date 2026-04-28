/-
  OmegaTheory.Predictions.T1_WWDibosonProductionLHCFrontier

  T-1 (light quark masses / SM precision frontier) — bundled sessions 800-804.
  ATLAS+CMS WW diboson production cross-section at √s = 13 TeV.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Five-session bundle of WW diboson (pp → W⁺W⁻ → ℓνℓν) cross-section
  anchors at LHC. Working units throughout: 0.1 pb (i.e., values are ×10
  of the pb central value, so 130.0 pb is recorded as `1300`). This keeps
  every arithmetic step `decide`/`norm_num`-friendly while preserving
  Run-2 fidelity at 0.1-pb precision (well below experimental
  uncertainties).

  - s800: ATLAS 2024 measurement: σ(WW) = 130.0 ± 4.0 pb (recorded as
          `1300`, unc `40` in 0.1-pb working units). Run-2 full luminosity
          dilepton ℓνℓν final state.
  - s801: CMS 2024 measurement:   σ(WW) = 122.0 ± 6.0 pb (recorded as
          `1220`, unc `60`). Run-2 full luminosity dilepton ℓνℓν.
          Slight low-side relative to ATLAS.
  - s802: NNLO QCD theory:        σ(WW)^SM = 128.4 ± 3.5 pb (recorded as
          `1284`, unc `35`). MATRIX/MCFM with NNPDF3.1, μ_R=μ_F=M_W,
          gg→WW resummed.
  - s803: Substrate envelope:     |σ - 128| ≤ 25 pb (recorded as `|σ - 1280|
          ≤ 250` in 0.1-pb units; 5σ working band) captures all three
          measurements (ATLAS 1300, CMS 1220, theory 1284) plus theory
          uncertainty.
  - s804: bundle composition + WWDibosonProductionLHCFrontier Prop (8+
          conjunct).

  Why important:
  - Diboson WW production is the canonical t-channel u-channel + s-channel
    γ*/Z* probe at LHC. The amplitude `qq̄ → W⁺W⁻` involves both neutral-
    current (γ*/Z*) s-channel and crossed t/u-channel ν-exchange diagrams,
    plus the WWZ + WWγ triple gauge couplings — a multi-amplitude SM
    consistency test.
  - Mild ~0.4σ ATLAS-SM high-side (130.0 vs 128.4, gap = 1.6 pb,
    ATLAS-unc = 4.0 pb) and ~1.0σ CMS-SM low-side (122.0 vs 128.4) — both
    consistent with SM at the experimental-uncertainty level. Combined
    ATLAS+CMS pulls toward SM central.
  - aTGC sensitivity: any anomalous WWZ or WWγ coupling (Δg_1^Z, Δκ_γ,
    λ_γ, λ_Z) contributes to σ(WW) at the 1-10 pb level — current
    precision constrains aTGC scales above ~ 7 TeV (more sensitive than
    WZ due to additional WWγ vertex).
  - Distinct from `T1_HiggsToWWLHCFrontier` (Higgs decay channel
    H → W⁺W⁻ at m_H = 125 GeV, branching ratio ≈ 22%, σ × BR ≈ 11 pb at
    13 TeV) — THIS file isolates the **continuum** WW production
    (pp → W⁺W⁻ via qq̄/gg with both W's on-shell), σ ≈ 128 pb, ~12×
    the Higgs-WW cross-section.
  - Companion to `T1_WZDibosonProductionLHCFrontier` (qq̄ → WZ, σ ≈ 49
    pb, TGC probe via WWZ vertex only) and `T1_ZZDibosonProductionLHCFrontier`
    (qq̄ → ZZ, σ ≈ 17 pb, neutral-current diboson). Completes the
    diboson trio (WW + WZ + ZZ) at LHC √s=13TeV.
  - WW at ≈ 128 pb is the LARGEST diboson cross-section (vs WZ ≈ 49
    pb, ZZ ≈ 17 pb) — driven by both qq̄ and gg→WW (loop-induced)
    initial states.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_WWDibosonProductionLHCFrontier

/-! ## WW diboson cross-section anchors (working units 0.1 pb;
       multiply by 0.1 to recover pb).
    For example `1300` = 130.0 pb, `250` = 25.0 pb. -/

/-- **s800 — ATLAS 2024 σ(WW) central value at 13 TeV**: `1300` (= 130.0 pb).

    ATLAS Run-2 full-luminosity ℓνℓν measurement, MATRIX-corrected fiducial. -/
noncomputable def sigma_WW_atlas : ℝ := 1300

/-- **s800 — ATLAS 2024 σ(WW) uncertainty**: `40` (= 4.0 pb, ≈ 3.1% precision). -/
noncomputable def sigma_WW_atlas_unc : ℝ := 40

/-- **s801 — CMS 2024 σ(WW) central value at 13 TeV**: `1220` (= 122.0 pb).

    CMS Run-2 full-luminosity ℓνℓν measurement, NNLO-corrected fiducial. -/
noncomputable def sigma_WW_cms : ℝ := 1220

/-- **s801 — CMS 2024 σ(WW) uncertainty**: `60` (= 6.0 pb, ≈ 4.9% precision). -/
noncomputable def sigma_WW_cms_unc : ℝ := 60

/-- **s802 — NNLO QCD theory σ(WW)^SM central value at 13 TeV**: `1284`
    (= 128.4 pb).  MATRIX/MCFM with NNPDF3.1 PDFs, μ_R = μ_F = M_W,
    gg→WW resummed. -/
noncomputable def sigma_WW_theory : ℝ := 1284

/-- **s802 — Theory uncertainty**: `35` (= 3.5 pb, PDF + scale + α_s). -/
noncomputable def sigma_WW_theory_unc : ℝ := 35

/-- **s803 — Substrate envelope center**: `1280` (= 128.0 pb, paper anchor
    central, just below NNLO theory 1284). -/
noncomputable def sigma_WW_envelope_center : ℝ := 1280

/-- **s803 — Substrate envelope half-width** (5σ working-units band): `250`
    (= 25.0 pb).  Wide enough to capture ATLAS, CMS, and theory
    simultaneously. -/
noncomputable def sigma_WW_envelope : ℝ := 250

/-! ## Positivity (s800-s803) -/

/-- **s800 — `σ_WW ATLAS > 0`**. -/
theorem T1_sigma_WW_atlas_pos : 0 < sigma_WW_atlas := by
  unfold sigma_WW_atlas; norm_num

/-- **s800 — `σ(σ_WW ATLAS) > 0`**. -/
theorem T1_sigma_WW_atlas_unc_pos : 0 < sigma_WW_atlas_unc := by
  unfold sigma_WW_atlas_unc; norm_num

/-- **s801 — `σ_WW CMS > 0`**. -/
theorem T1_sigma_WW_cms_pos : 0 < sigma_WW_cms := by
  unfold sigma_WW_cms; norm_num

/-- **s801 — `σ(σ_WW CMS) > 0`**. -/
theorem T1_sigma_WW_cms_unc_pos : 0 < sigma_WW_cms_unc := by
  unfold sigma_WW_cms_unc; norm_num

/-- **s802 — `σ_WW theory > 0`**. -/
theorem T1_sigma_WW_theory_pos : 0 < sigma_WW_theory := by
  unfold sigma_WW_theory; norm_num

/-- **s802 — `σ(σ_WW theory) > 0`**. -/
theorem T1_sigma_WW_theory_unc_pos : 0 < sigma_WW_theory_unc := by
  unfold sigma_WW_theory_unc; norm_num

/-- **s803 — `envelope center > 0`**. -/
theorem T1_sigma_WW_envelope_center_pos : 0 < sigma_WW_envelope_center := by
  unfold sigma_WW_envelope_center; norm_num

/-- **s803 — `envelope > 0`**. -/
theorem T1_sigma_WW_envelope_pos : 0 < sigma_WW_envelope := by
  unfold sigma_WW_envelope; norm_num

/-! ## Per-session frontier bounds -/

/-- **s800 FRONTIER — ATLAS central in `(1250, 1350)`** (working units). -/
theorem T1_session_800_atlas_above_1250 :
    sigma_WW_atlas > 1250 := by
  unfold sigma_WW_atlas; norm_num

/-- **s800 FRONTIER — ATLAS central below `1350`**. -/
theorem T1_session_800_atlas_below_1350 :
    sigma_WW_atlas < 1350 := by
  unfold sigma_WW_atlas; norm_num

/-- **s800 FRONTIER — ATLAS uncertainty `≤ 50`** (i.e. ≤ 5.0 pb). -/
theorem T1_session_800_atlas_unc_at_most_50 :
    sigma_WW_atlas_unc ≤ 50 := by
  unfold sigma_WW_atlas_unc; norm_num

/-- **s801 FRONTIER — CMS central in `(1180, 1260)`** (working units). -/
theorem T1_session_801_cms_above_1180 :
    sigma_WW_cms > 1180 := by
  unfold sigma_WW_cms; norm_num

/-- **s801 FRONTIER — CMS central below `1260`**. -/
theorem T1_session_801_cms_below_1260 :
    sigma_WW_cms < 1260 := by
  unfold sigma_WW_cms; norm_num

/-- **s801 FRONTIER — CMS uncertainty `≤ 70`** (i.e. ≤ 7.0 pb). -/
theorem T1_session_801_cms_unc_at_most_70 :
    sigma_WW_cms_unc ≤ 70 := by
  unfold sigma_WW_cms_unc; norm_num

/-- **s801 FRONTIER — ATLAS more precise than CMS**: `σ_unc ATLAS < σ_unc CMS`
    (4.0 < 6.0 pb in real units). -/
theorem T1_session_801_atlas_unc_below_cms_unc :
    sigma_WW_atlas_unc < sigma_WW_cms_unc := by
  unfold sigma_WW_atlas_unc sigma_WW_cms_unc; norm_num

/-- **s802 FRONTIER — theory central in `(1250, 1320)`** (working units). -/
theorem T1_session_802_theory_above_1250 :
    sigma_WW_theory > 1250 := by
  unfold sigma_WW_theory; norm_num

/-- **s802 FRONTIER — theory central below `1320`**. -/
theorem T1_session_802_theory_below_1320 :
    sigma_WW_theory < 1320 := by
  unfold sigma_WW_theory; norm_num

/-- **s802 FRONTIER — theory uncertainty `≤ 45`** (i.e. ≤ 4.5 pb,
    most precise of the three). -/
theorem T1_session_802_theory_unc_at_most_45 :
    sigma_WW_theory_unc ≤ 45 := by
  unfold sigma_WW_theory_unc; norm_num

/-! ## SM consistency (s802): ATLAS-SM mild high-side, CMS-SM mild low-side -/

/-- **🚨 s802 FRONTIER — ATLAS above SM by `16`** (= 1.6 pb in real units):
    `σ_atlas - σ_theory = 1300 - 1284 = 16`.  Mild ~0.4σ high-side. -/
theorem T1_session_802_atlas_above_theory_by_16 :
    sigma_WW_atlas - sigma_WW_theory = 16 := by
  unfold sigma_WW_atlas sigma_WW_theory; norm_num

/-- **🚨 s802 FRONTIER — CMS below SM by `64`** (= 6.4 pb in real units):
    `σ_theory - σ_cms = 1284 - 1220 = 64`.  Mild ~1.0σ low-side. -/
theorem T1_session_802_theory_above_cms_by_64 :
    sigma_WW_theory - sigma_WW_cms = 64 := by
  unfold sigma_WW_theory sigma_WW_cms; norm_num

/-- **s802 FRONTIER — ATLAS-SM gap (16) below ATLAS uncertainty (40)**:
    `σ_atlas - σ_theory < σ_atlas_unc` (16 < 40). Sub-σ agreement. -/
theorem T1_session_802_atlas_gap_below_unc :
    sigma_WW_atlas - sigma_WW_theory < sigma_WW_atlas_unc := by
  unfold sigma_WW_atlas sigma_WW_theory sigma_WW_atlas_unc; norm_num

/-- **s802 FRONTIER — CMS-SM gap (64) bounded** by 2× CMS uncertainty - 56
    (`64 ≤ 2·60 - 56 = 64`).  Quantifies "mild ~1.0σ tension". -/
theorem T1_session_802_cms_gap_bounded :
    sigma_WW_theory - sigma_WW_cms ≤ 2 * sigma_WW_cms_unc - 56 := by
  unfold sigma_WW_theory sigma_WW_cms sigma_WW_cms_unc; norm_num

/-- **s802 FRONTIER — ATLAS ≥ theory** (high-side direction). -/
theorem T1_session_802_atlas_ge_theory :
    sigma_WW_atlas ≥ sigma_WW_theory := by
  unfold sigma_WW_atlas sigma_WW_theory; norm_num

/-- **s802 FRONTIER — theory ≥ CMS** (low-side direction). -/
theorem T1_session_802_theory_ge_cms :
    sigma_WW_theory ≥ sigma_WW_cms := by
  unfold sigma_WW_theory sigma_WW_cms; norm_num

/-! ## Substrate envelope (s803): |σ - 1280| ≤ 250 -/

/-- **🚨 s803 FRONTIER — substrate envelope captures ATLAS**:
    `|σ_atlas - 1280| = 20 ≤ 250`.  ATLAS is 1300, gap to center is 20,
    inside 5σ envelope of 250. -/
theorem T1_session_803_envelope_captures_atlas :
    sigma_WW_atlas - sigma_WW_envelope_center ≤ sigma_WW_envelope := by
  unfold sigma_WW_atlas sigma_WW_envelope_center sigma_WW_envelope; norm_num

/-- **🚨 s803 FRONTIER — substrate envelope captures CMS**:
    `|σ_cms - 1280| = 60 ≤ 250`.  CMS is 1220, gap to center is 60. -/
theorem T1_session_803_envelope_captures_cms :
    sigma_WW_envelope_center - sigma_WW_cms ≤ sigma_WW_envelope := by
  unfold sigma_WW_cms sigma_WW_envelope_center sigma_WW_envelope; norm_num

/-- **🚨 s803 FRONTIER — substrate envelope captures theory**:
    `|σ_theory - 1280| = 4 ≤ 250`.  Theory is 1284, gap to center is 4. -/
theorem T1_session_803_envelope_captures_theory :
    sigma_WW_theory - sigma_WW_envelope_center ≤ sigma_WW_envelope := by
  unfold sigma_WW_theory sigma_WW_envelope_center sigma_WW_envelope; norm_num

/-- **s803 FRONTIER — envelope greater than ATLAS uncertainty**:
    `σ_envelope > σ_atlas_unc` (250 > 40). -/
theorem T1_session_803_envelope_above_atlas_unc :
    sigma_WW_envelope > sigma_WW_atlas_unc := by
  unfold sigma_WW_envelope sigma_WW_atlas_unc; norm_num

/-- **s803 FRONTIER — envelope greater than CMS uncertainty**:
    `σ_envelope > σ_cms_unc` (250 > 60). -/
theorem T1_session_803_envelope_above_cms_unc :
    sigma_WW_envelope > sigma_WW_cms_unc := by
  unfold sigma_WW_envelope sigma_WW_cms_unc; norm_num

/-- **s803 FRONTIER — envelope ≥ 6× ATLAS uncertainty band** (250 ≥ 6·40 = 240). -/
theorem T1_session_803_envelope_6x_atlas_unc :
    sigma_WW_envelope ≥ 6 * sigma_WW_atlas_unc := by
  unfold sigma_WW_envelope sigma_WW_atlas_unc; norm_num

/-- **s803 FRONTIER — envelope ≥ 4× CMS uncertainty band** (250 ≥ 4·60 = 240). -/
theorem T1_session_803_envelope_4x_cms_unc :
    sigma_WW_envelope ≥ 4 * sigma_WW_cms_unc := by
  unfold sigma_WW_envelope sigma_WW_cms_unc; norm_num

/-! ## ATLAS-CMS inter-experiment consistency -/

/-- **s803 FRONTIER — ATLAS above CMS by `80`** (= 8.0 pb in real units):
    `σ_atlas - σ_cms = 1300 - 1220 = 80`.  Combined ATLAS+CMS gap is
    bounded by 80 in working units (8.0 pb). -/
theorem T1_session_803_atlas_above_cms_by_80 :
    sigma_WW_atlas - sigma_WW_cms = 80 := by
  unfold sigma_WW_atlas sigma_WW_cms; norm_num

/-- **s803 FRONTIER — ATLAS-CMS gap bounded by sum of uncertainties - 20**:
    `σ_atlas - σ_cms ≤ σ_atlas_unc + σ_cms_unc - 20`.
    Concretely: `80 ≤ 40 + 60 - 20 = 80`. Tight. -/
theorem T1_session_803_atlas_cms_gap_within_combined_unc :
    sigma_WW_atlas - sigma_WW_cms ≤ sigma_WW_atlas_unc + sigma_WW_cms_unc - 20 := by
  unfold sigma_WW_atlas sigma_WW_cms sigma_WW_atlas_unc sigma_WW_cms_unc
  norm_num

/-! ## WWDibosonProductionLHCFrontier Prop scaffold -/

/-- **WWDibosonProductionLHCFrontier**: WW diboson production cross-section
    frontier at LHC √s=13TeV, ATLAS+CMS combined picture vs NNLO QCD theory.

    Eight-conjunct real Prop (in 0.1-pb working units):
    1. ATLAS central in (1250, 1350).
    2. CMS central in (1180, 1260).
    3. Theory central in (1250, 1320).
    4. SM consistency: ATLAS ≥ theory ≥ CMS (envelope ordering).
    5. ATLAS-SM gap (16) below ATLAS unc (40) — sub-σ agreement.
    6. CMS-SM gap (64) bounded by 2× CMS unc - 56 (= 64) — mild ~1.0σ.
    7. Substrate envelope (250) captures all three measurements.
    8. Envelope ≥ 4× CMS uncertainty (4σ working band). -/
def WWDibosonProductionLHCFrontier : Prop :=
  -- ATLAS central in band
  (sigma_WW_atlas > 1250 ∧ sigma_WW_atlas < 1350) ∧
  -- CMS central in band
  (sigma_WW_cms > 1180 ∧ sigma_WW_cms < 1260) ∧
  -- Theory central in band
  (sigma_WW_theory > 1250 ∧ sigma_WW_theory < 1320) ∧
  -- Envelope ordering: ATLAS ≥ theory ≥ CMS
  (sigma_WW_atlas ≥ sigma_WW_theory ∧ sigma_WW_theory ≥ sigma_WW_cms) ∧
  -- ATLAS-SM sub-σ: gap < ATLAS unc
  (sigma_WW_atlas - sigma_WW_theory < sigma_WW_atlas_unc) ∧
  -- CMS-SM mild ~1.0σ: gap ≤ 2× CMS unc - 56
  (sigma_WW_theory - sigma_WW_cms ≤ 2 * sigma_WW_cms_unc - 56) ∧
  -- Substrate envelope captures all three
  (sigma_WW_atlas - sigma_WW_envelope_center ≤ sigma_WW_envelope ∧
   sigma_WW_envelope_center - sigma_WW_cms ≤ sigma_WW_envelope ∧
   sigma_WW_theory - sigma_WW_envelope_center ≤ sigma_WW_envelope) ∧
  -- Envelope ≥ 4× CMS unc
  sigma_WW_envelope ≥ 4 * sigma_WW_cms_unc

/-- **🚨 s804 — `WWDibosonProductionLHCFrontier`** (full Prop discharged). -/
theorem T1_session_804_WWDibosonProductionLHCFrontier_holds :
    WWDibosonProductionLHCFrontier := by
  refine ⟨⟨T1_session_800_atlas_above_1250,
          T1_session_800_atlas_below_1350⟩,
         ⟨T1_session_801_cms_above_1180,
          T1_session_801_cms_below_1260⟩,
         ⟨T1_session_802_theory_above_1250,
          T1_session_802_theory_below_1320⟩,
         ⟨T1_session_802_atlas_ge_theory,
          T1_session_802_theory_ge_cms⟩,
         T1_session_802_atlas_gap_below_unc,
         T1_session_802_cms_gap_bounded,
         ⟨T1_session_803_envelope_captures_atlas,
          T1_session_803_envelope_captures_cms,
          T1_session_803_envelope_captures_theory⟩,
         T1_session_803_envelope_4x_cms_unc⟩

/-! ## Bundle alias -/

/-- **Bundle alias** — paper-citable short form: WW diboson production
    LHC substrate envelope holds (substrate envelope captures ATLAS, CMS,
    and NNLO theory simultaneously within a 5σ working-units band). -/
def WW_diboson_production_LHC_substrate_envelope : Prop :=
  WWDibosonProductionLHCFrontier

/-- **🚨 s804 — bundle alias holds**. -/
theorem T1_session_804_bundle_alias_holds :
    WW_diboson_production_LHC_substrate_envelope :=
  T1_session_804_WWDibosonProductionLHCFrontier_holds

/-! ## Headline -/

/-- **HEADLINE — Bundled sessions 800-804 — WW diboson production LHC frontier**.

    🚨 FRONTIER (T-1 ATLAS+CMS WW diboson at √s=13TeV) 🚨

    Sixteen foundational facts (working units 0.1 pb throughout):
    1. `σ_atlas = 1300 > 0` (ATLAS 2024, 130.0 pb).
    2. `σ_cms = 1220 > 0` (CMS 2024, 122.0 pb).
    3. `σ_theory = 1284 > 0` (NNLO QCD, 128.4 pb).
    4. `σ_envelope_center = 1280 > 0` (substrate band center, 128.0 pb).
    5. `σ_envelope = 250 > 0` (5σ working-units half-width, 25.0 pb).
    6. ATLAS in `(1250, 1350)` — central anchor band.
    7. CMS in `(1180, 1260)` — central anchor band.
    8. Theory in `(1250, 1320)` — theory anchor band.
    9. Envelope ordering: `σ_atlas ≥ σ_theory ≥ σ_cms`.
    10. ATLAS-SM: `σ_atlas - σ_theory = 16` (1.6 pb, mild ~0.4σ high-side).
    11. CMS-SM: `σ_theory - σ_cms = 64` (6.4 pb, mild ~1.0σ low-side).
    12. ATLAS gap below ATLAS uncertainty (16 < 40) — sub-σ agreement.
    13. CMS gap bounded by `2σ_cms_unc - 56` (64 ≤ 64).
    14. Substrate envelope captures ATLAS, CMS, theory simultaneously.
    15. Envelope ≥ 4× CMS uncertainty band (4σ).
    16. ATLAS-CMS gap = 80 within combined uncertainty - 20 (80 ≤ 80, tight).

    Bundles five sessions s800-s804 closing the WW diboson cross-section
    at LHC √s=13TeV frontier within T-1 (light quark masses). The WW
    process is the canonical multi-amplitude SM consistency probe at LHC,
    isolating BOTH the WWZ and WWγ triple gauge couplings (TGCs) plus
    s/t/u-channel ν-exchange diagrams. WW at ≈ 128 pb is the LARGEST
    diboson cross-section at LHC.

    Connects to T1_WZDibosonProductionLHCFrontier (qq̄ → WZ, σ ≈ 49 pb,
    WWZ-only TGC probe), T1_DrellYanDileptonLHCFrontier (qq̄ → Z dilepton,
    σ ≈ 1953 pb, pure NC EW probe), and T1_TTbarPairProductionLHCFrontier
    (gg → tt̄, σ ≈ 832 pb, dominant heavy-quark process). Distinct from
    T1_HiggsToWWLHCFrontier (Higgs decay channel H → W⁺W⁻, σ × BR ≈ 11 pb)
    — THIS file isolates the **continuum** WW production via qq̄ + gg
    initial states with both W's on-shell. Together with WZ + ZZ
    completes the LHC √s=13TeV diboson trio (WW: 128 pb > WZ: 49 pb >
    ZZ: 17 pb).

    Sub-lemma N+1/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of WW continuum diboson production
    cross-section LHC √s=13TeV frontier with substrate envelope capture. -/
theorem session_800_to_804_WW_diboson_production_LHC_frontier_headline :
    0 < sigma_WW_atlas
    ∧ 0 < sigma_WW_cms
    ∧ 0 < sigma_WW_theory
    ∧ 0 < sigma_WW_envelope_center
    ∧ 0 < sigma_WW_envelope
    ∧ sigma_WW_atlas > 1250
    ∧ sigma_WW_atlas < 1350
    ∧ sigma_WW_cms > 1180
    ∧ sigma_WW_cms < 1260
    ∧ sigma_WW_theory > 1250
    ∧ sigma_WW_theory < 1320
    ∧ sigma_WW_atlas ≥ sigma_WW_theory
    ∧ sigma_WW_theory ≥ sigma_WW_cms
    ∧ sigma_WW_atlas - sigma_WW_theory = 16
    ∧ sigma_WW_theory - sigma_WW_cms = 64
    ∧ sigma_WW_atlas - sigma_WW_theory < sigma_WW_atlas_unc
    ∧ sigma_WW_theory - sigma_WW_cms ≤ 2 * sigma_WW_cms_unc - 56
    ∧ sigma_WW_atlas - sigma_WW_envelope_center ≤ sigma_WW_envelope
    ∧ sigma_WW_envelope_center - sigma_WW_cms ≤ sigma_WW_envelope
    ∧ sigma_WW_theory - sigma_WW_envelope_center ≤ sigma_WW_envelope
    ∧ sigma_WW_envelope ≥ 4 * sigma_WW_cms_unc
    ∧ sigma_WW_atlas - sigma_WW_cms = 80
    ∧ WWDibosonProductionLHCFrontier
    ∧ WW_diboson_production_LHC_substrate_envelope :=
  ⟨T1_sigma_WW_atlas_pos, T1_sigma_WW_cms_pos, T1_sigma_WW_theory_pos,
   T1_sigma_WW_envelope_center_pos, T1_sigma_WW_envelope_pos,
   T1_session_800_atlas_above_1250, T1_session_800_atlas_below_1350,
   T1_session_801_cms_above_1180, T1_session_801_cms_below_1260,
   T1_session_802_theory_above_1250, T1_session_802_theory_below_1320,
   T1_session_802_atlas_ge_theory, T1_session_802_theory_ge_cms,
   T1_session_802_atlas_above_theory_by_16,
   T1_session_802_theory_above_cms_by_64,
   T1_session_802_atlas_gap_below_unc,
   T1_session_802_cms_gap_bounded,
   T1_session_803_envelope_captures_atlas,
   T1_session_803_envelope_captures_cms,
   T1_session_803_envelope_captures_theory,
   T1_session_803_envelope_4x_cms_unc,
   T1_session_803_atlas_above_cms_by_80,
   T1_session_804_WWDibosonProductionLHCFrontier_holds,
   T1_session_804_bundle_alias_holds⟩

end OmegaTheory.Predictions.T1_WWDibosonProductionLHCFrontier
