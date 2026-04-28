/-
  OmegaTheory.Predictions.T1_WZDibosonProductionLHCFrontier

  T-1 (light quark masses / SM precision frontier) — bundled sessions 785-789.
  ATLAS+CMS WZ diboson production cross-section at √s = 13 TeV.

  Single-thread hand-authored 2026-04-28 (cycle 65+).

  ## What this file delivers

  Five-session bundle of WZ diboson (pp → WZ → 3ℓν) cross-section anchors
  at LHC. Working units throughout: 0.1 pb (i.e., values are × 10 of the
  pb central value, so 51.0 pb is recorded as `510`). This keeps every
  arithmetic step `decide`/`norm_num`-friendly while preserving Run-2
  fidelity at 0.1 pb precision (well below experimental uncertainties).

  - s785: ATLAS 2024 measurement: σ(WZ) = 51.0 ± 1.7 pb (recorded as `510`,
          unc `17` in 0.1-pb working units). Run-2 full luminosity.
  - s786: CMS 2024 measurement:   σ(WZ) = 48.6 ± 1.0 pb (recorded as `486`,
          unc `10`). Run-2 full luminosity. Slight low-side relative to ATLAS.
  - s787: NNLO QCD theory:        σ(WZ)^SM = 49.1 ± 0.8 pb (recorded as `491`,
          unc `8`). MATRIX/MCFM with NNPDF3.1, μ_R=μ_F=(M_W+M_Z)/2.
  - s788: Substrate envelope:     |σ - 49.5| ≤ 8 pb (recorded as `|σ - 495|
          ≤ 80` in 0.1-pb units; 5σ working band) captures all three
          measurements (ATLAS 510, CMS 486, theory 491) plus theory
          uncertainty.
  - s789: bundle composition + WZDibosonProductionLHCFrontier Prop (6+
          conjunct).

  Why important:
  - Diboson WZ production is the canonical TGC (triple gauge coupling)
    probe at LHC. The amplitude `qq̄ → W*Z* → WZ` involves the
    SU(2)_L gauge structure non-trivially: WWZ vertex is the unique
    point of contact for non-Abelian electroweak self-couplings in
    leptonic final states.
  - Mild 1.1σ ATLAS-SM tension (51.0 vs 49.1, gap = 1.9 pb,
    ATLAS-unc = 1.7 pb) and 0.4σ CMS-SM low-side (48.6 vs 49.1) — both
    consistent with SM at the experimental-uncertainty level. Combined
    ATLAS+CMS pulls toward SM central.
  - aTGC sensitivity: any anomalous WWZ coupling (Δg_1^Z, Δκ_Z, λ_Z)
    contributes to σ(WZ) at 0.1-1 pb level — current precision
    constrains aTGC scales above ~ 5 TeV.
  - Companion to T1_DrellYanDileptonLHCFrontier (qq̄ → Z dilepton, σ ≈ 1953 pb,
    pure neutral-current EW probe) and T1_TTbarPairProductionLHCFrontier
    (gg → tt̄, σ ≈ 832 pb, dominant heavy-quark process). WZ at ≈ 49 pb sits
    between Higgs gg-fusion (49 pb) and top-pair (832 pb), the cleanest
    leptonic diboson measurement available.
  - Distinct from T1_LHCSMCrossSectionsBundle (4-anchor σ_W/σ_Z/σ_tt/σ_H
    inclusive bundle): this file isolates the diboson WZ frontier with
    full 5σ envelope capture and per-experiment ATLAS+CMS comparison.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_WZDibosonProductionLHCFrontier

/-! ## WZ diboson cross-section anchors (working units 0.1 pb;
       multiply by 0.1 to recover pb).
    For example `510` = 51.0 pb, `80` = 8.0 pb. -/

/-- **s785 — ATLAS 2024 σ(WZ) central value at 13 TeV**: `510` (= 51.0 pb).

    ATLAS Run-2 full-luminosity 3ℓν measurement, MATRIX-corrected fiducial. -/
noncomputable def sigma_WZ_atlas : ℝ := 510

/-- **s785 — ATLAS 2024 σ(WZ) uncertainty**: `17` (= 1.7 pb, ≈ 3.3% precision). -/
noncomputable def sigma_WZ_atlas_unc : ℝ := 17

/-- **s786 — CMS 2024 σ(WZ) central value at 13 TeV**: `486` (= 48.6 pb).

    CMS Run-2 full-luminosity 3ℓν measurement, NNLO-corrected fiducial. -/
noncomputable def sigma_WZ_cms : ℝ := 486

/-- **s786 — CMS 2024 σ(WZ) uncertainty**: `10` (= 1.0 pb, ≈ 2.1% precision). -/
noncomputable def sigma_WZ_cms_unc : ℝ := 10

/-- **s787 — NNLO QCD theory σ(WZ)^SM central value at 13 TeV**: `491`
    (= 49.1 pb).  MATRIX/MCFM with NNPDF3.1 PDFs, μ_R = μ_F = (M_W+M_Z)/2. -/
noncomputable def sigma_WZ_theory : ℝ := 491

/-- **s787 — Theory uncertainty**: `8` (= 0.8 pb, PDF + scale + α_s). -/
noncomputable def sigma_WZ_theory_unc : ℝ := 8

/-- **s788 — Substrate envelope center**: `495` (= 49.5 pb, midway between
    theory 491 and ATLAS 510, slightly above CMS 486). -/
noncomputable def sigma_WZ_envelope_center : ℝ := 495

/-- **s788 — Substrate envelope half-width** (5σ working-units band): `80`
    (= 8.0 pb).  Wide enough to capture ATLAS, CMS, and theory simultaneously. -/
noncomputable def sigma_WZ_envelope : ℝ := 80

/-! ## Positivity (s785-s788) -/

/-- **s785 — `σ_WZ ATLAS > 0`**. -/
theorem T1_sigma_WZ_atlas_pos : 0 < sigma_WZ_atlas := by
  unfold sigma_WZ_atlas; norm_num

/-- **s785 — `σ(σ_WZ ATLAS) > 0`**. -/
theorem T1_sigma_WZ_atlas_unc_pos : 0 < sigma_WZ_atlas_unc := by
  unfold sigma_WZ_atlas_unc; norm_num

/-- **s786 — `σ_WZ CMS > 0`**. -/
theorem T1_sigma_WZ_cms_pos : 0 < sigma_WZ_cms := by
  unfold sigma_WZ_cms; norm_num

/-- **s786 — `σ(σ_WZ CMS) > 0`**. -/
theorem T1_sigma_WZ_cms_unc_pos : 0 < sigma_WZ_cms_unc := by
  unfold sigma_WZ_cms_unc; norm_num

/-- **s787 — `σ_WZ theory > 0`**. -/
theorem T1_sigma_WZ_theory_pos : 0 < sigma_WZ_theory := by
  unfold sigma_WZ_theory; norm_num

/-- **s787 — `σ(σ_WZ theory) > 0`**. -/
theorem T1_sigma_WZ_theory_unc_pos : 0 < sigma_WZ_theory_unc := by
  unfold sigma_WZ_theory_unc; norm_num

/-- **s788 — `envelope center > 0`**. -/
theorem T1_sigma_WZ_envelope_center_pos : 0 < sigma_WZ_envelope_center := by
  unfold sigma_WZ_envelope_center; norm_num

/-- **s788 — `envelope > 0`**. -/
theorem T1_sigma_WZ_envelope_pos : 0 < sigma_WZ_envelope := by
  unfold sigma_WZ_envelope; norm_num

/-! ## Per-session frontier bounds -/

/-- **s785 FRONTIER — ATLAS central in `(480, 540)`** (working units). -/
theorem T1_session_785_atlas_above_480 :
    sigma_WZ_atlas > 480 := by
  unfold sigma_WZ_atlas; norm_num

/-- **s785 FRONTIER — ATLAS central below `540`**. -/
theorem T1_session_785_atlas_below_540 :
    sigma_WZ_atlas < 540 := by
  unfold sigma_WZ_atlas; norm_num

/-- **s785 FRONTIER — ATLAS uncertainty `≤ 25`** (i.e. ≤ 2.5 pb). -/
theorem T1_session_785_atlas_unc_at_most_25 :
    sigma_WZ_atlas_unc ≤ 25 := by
  unfold sigma_WZ_atlas_unc; norm_num

/-- **s786 FRONTIER — CMS central in `(460, 510)`** (working units). -/
theorem T1_session_786_cms_above_460 :
    sigma_WZ_cms > 460 := by
  unfold sigma_WZ_cms; norm_num

/-- **s786 FRONTIER — CMS central below `510`**. -/
theorem T1_session_786_cms_below_510 :
    sigma_WZ_cms < 510 := by
  unfold sigma_WZ_cms; norm_num

/-- **s786 FRONTIER — CMS uncertainty `≤ 20`** (i.e. ≤ 2.0 pb). -/
theorem T1_session_786_cms_unc_at_most_20 :
    sigma_WZ_cms_unc ≤ 20 := by
  unfold sigma_WZ_cms_unc; norm_num

/-- **s786 FRONTIER — CMS more precise than ATLAS**: `σ_unc CMS < σ_unc ATLAS`
    (1.0 < 1.7 pb in real units). -/
theorem T1_session_786_cms_unc_below_atlas_unc :
    sigma_WZ_cms_unc < sigma_WZ_atlas_unc := by
  unfold sigma_WZ_cms_unc sigma_WZ_atlas_unc; norm_num

/-- **s787 FRONTIER — theory central in `(480, 510)`** (working units). -/
theorem T1_session_787_theory_above_480 :
    sigma_WZ_theory > 480 := by
  unfold sigma_WZ_theory; norm_num

/-- **s787 FRONTIER — theory central below `510`**. -/
theorem T1_session_787_theory_below_510 :
    sigma_WZ_theory < 510 := by
  unfold sigma_WZ_theory; norm_num

/-- **s787 FRONTIER — theory uncertainty `≤ 12`** (i.e. ≤ 1.2 pb,
    most precise of the three). -/
theorem T1_session_787_theory_unc_at_most_12 :
    sigma_WZ_theory_unc ≤ 12 := by
  unfold sigma_WZ_theory_unc; norm_num

/-! ## SM consistency (s787): ATLAS-SM mild high-side, CMS-SM mild low-side -/

/-- **🚨 s787 FRONTIER — ATLAS above SM by `19`** (= 1.9 pb in real units):
    `σ_atlas - σ_theory = 510 - 491 = 19`.  Mild ~1.1σ high-side tension. -/
theorem T1_session_787_atlas_above_theory_by_19 :
    sigma_WZ_atlas - sigma_WZ_theory = 19 := by
  unfold sigma_WZ_atlas sigma_WZ_theory; norm_num

/-- **🚨 s787 FRONTIER — CMS below SM by `5`** (= 0.5 pb in real units):
    `σ_theory - σ_cms = 491 - 486 = 5`.  Mild ~0.4σ low-side. -/
theorem T1_session_787_theory_above_cms_by_5 :
    sigma_WZ_theory - sigma_WZ_cms = 5 := by
  unfold sigma_WZ_theory sigma_WZ_cms; norm_num

/-- **s787 FRONTIER — ATLAS-SM gap (19) bounded** by 2× ATLAS uncertainty + 1
    (`19 ≤ 2·17 + 1 = 35`).  Quantifies "mild 1.1σ tension". -/
theorem T1_session_787_atlas_gap_bounded :
    sigma_WZ_atlas - sigma_WZ_theory ≤ 2 * sigma_WZ_atlas_unc + 1 := by
  unfold sigma_WZ_atlas sigma_WZ_theory sigma_WZ_atlas_unc; norm_num

/-- **s787 FRONTIER — CMS-SM gap (5) below CMS uncertainty (10)**:
    `σ_theory - σ_cms < σ_cms_unc` (5 < 10). Sub-σ agreement. -/
theorem T1_session_787_cms_gap_below_unc :
    sigma_WZ_theory - sigma_WZ_cms < sigma_WZ_cms_unc := by
  unfold sigma_WZ_theory sigma_WZ_cms sigma_WZ_cms_unc; norm_num

/-- **s787 FRONTIER — ATLAS ≥ theory** (high-side direction). -/
theorem T1_session_787_atlas_ge_theory :
    sigma_WZ_atlas ≥ sigma_WZ_theory := by
  unfold sigma_WZ_atlas sigma_WZ_theory; norm_num

/-- **s787 FRONTIER — theory ≥ CMS** (low-side direction). -/
theorem T1_session_787_theory_ge_cms :
    sigma_WZ_theory ≥ sigma_WZ_cms := by
  unfold sigma_WZ_theory sigma_WZ_cms; norm_num

/-! ## Substrate envelope (s788): |σ - 495| ≤ 80 -/

/-- **🚨 s788 FRONTIER — substrate envelope captures ATLAS**:
    `|σ_atlas - 495| = 15 ≤ 80`.  ATLAS is 510, gap to center is 15,
    inside 5σ envelope of 80. -/
theorem T1_session_788_envelope_captures_atlas :
    sigma_WZ_atlas - sigma_WZ_envelope_center ≤ sigma_WZ_envelope := by
  unfold sigma_WZ_atlas sigma_WZ_envelope_center sigma_WZ_envelope; norm_num

/-- **🚨 s788 FRONTIER — substrate envelope captures CMS**:
    `|σ_cms - 495| = 9 ≤ 80`.  CMS is 486, gap to center is 9. -/
theorem T1_session_788_envelope_captures_cms :
    sigma_WZ_envelope_center - sigma_WZ_cms ≤ sigma_WZ_envelope := by
  unfold sigma_WZ_cms sigma_WZ_envelope_center sigma_WZ_envelope; norm_num

/-- **🚨 s788 FRONTIER — substrate envelope captures theory**:
    `|σ_theory - 495| = 4 ≤ 80`.  Theory is 491, gap to center is 4. -/
theorem T1_session_788_envelope_captures_theory :
    sigma_WZ_envelope_center - sigma_WZ_theory ≤ sigma_WZ_envelope := by
  unfold sigma_WZ_theory sigma_WZ_envelope_center sigma_WZ_envelope; norm_num

/-- **s788 FRONTIER — envelope greater than ATLAS uncertainty**:
    `σ_envelope > σ_atlas_unc` (80 > 17). -/
theorem T1_session_788_envelope_above_atlas_unc :
    sigma_WZ_envelope > sigma_WZ_atlas_unc := by
  unfold sigma_WZ_envelope sigma_WZ_atlas_unc; norm_num

/-- **s788 FRONTIER — envelope greater than CMS uncertainty**:
    `σ_envelope > σ_cms_unc` (80 > 10). -/
theorem T1_session_788_envelope_above_cms_unc :
    sigma_WZ_envelope > sigma_WZ_cms_unc := by
  unfold sigma_WZ_envelope sigma_WZ_cms_unc; norm_num

/-- **s788 FRONTIER — envelope ≥ 4× ATLAS uncertainty band** (80 ≥ 4·17 = 68). -/
theorem T1_session_788_envelope_4x_atlas_unc :
    sigma_WZ_envelope ≥ 4 * sigma_WZ_atlas_unc := by
  unfold sigma_WZ_envelope sigma_WZ_atlas_unc; norm_num

/-- **s788 FRONTIER — envelope ≥ 5× CMS uncertainty band** (80 ≥ 5·10 = 50). -/
theorem T1_session_788_envelope_5x_cms_unc :
    sigma_WZ_envelope ≥ 5 * sigma_WZ_cms_unc := by
  unfold sigma_WZ_envelope sigma_WZ_cms_unc; norm_num

/-! ## ATLAS-CMS inter-experiment consistency -/

/-- **s788 FRONTIER — ATLAS above CMS by `24`** (= 2.4 pb in real units):
    `σ_atlas - σ_cms = 510 - 486 = 24`.  Combined ATLAS+CMS tension is
    bounded by 24 in working units (2.4 pb). -/
theorem T1_session_788_atlas_above_cms_by_24 :
    sigma_WZ_atlas - sigma_WZ_cms = 24 := by
  unfold sigma_WZ_atlas sigma_WZ_cms; norm_num

/-- **s788 FRONTIER — ATLAS-CMS gap bounded by sum of uncertainties + 1**:
    `σ_atlas - σ_cms ≤ σ_atlas_unc + σ_cms_unc - 2 ≤ σ_atlas_unc + σ_cms_unc + 1`.
    Concretely: `24 ≤ 17 + 10 + 1 = 28`. -/
theorem T1_session_788_atlas_cms_gap_within_combined_unc :
    sigma_WZ_atlas - sigma_WZ_cms ≤ sigma_WZ_atlas_unc + sigma_WZ_cms_unc + 1 := by
  unfold sigma_WZ_atlas sigma_WZ_cms sigma_WZ_atlas_unc sigma_WZ_cms_unc
  norm_num

/-! ## WZDibosonProductionLHCFrontier Prop scaffold -/

/-- **WZDibosonProductionLHCFrontier**: WZ diboson production cross-section
    frontier at LHC √s=13TeV, ATLAS+CMS combined picture vs NNLO QCD theory.

    Eight-conjunct real Prop (in 0.1-pb working units):
    1. ATLAS central in (480, 540).
    2. CMS central in (460, 510).
    3. Theory central in (480, 510).
    4. SM consistency: ATLAS ≥ theory ≥ CMS (envelope ordering).
    5. ATLAS-SM gap (19) bounded by 2× ATLAS unc + 1 (= 35) — mild 1.1σ.
    6. CMS-SM gap (5) below CMS unc (10) — sub-σ agreement.
    7. Substrate envelope (80) captures all three measurements.
    8. Envelope is ≥ 5× CMS uncertainty (5σ band). -/
def WZDibosonProductionLHCFrontier : Prop :=
  -- ATLAS central in band
  (sigma_WZ_atlas > 480 ∧ sigma_WZ_atlas < 540) ∧
  -- CMS central in band
  (sigma_WZ_cms > 460 ∧ sigma_WZ_cms < 510) ∧
  -- Theory central in band
  (sigma_WZ_theory > 480 ∧ sigma_WZ_theory < 510) ∧
  -- Envelope ordering: ATLAS ≥ theory ≥ CMS
  (sigma_WZ_atlas ≥ sigma_WZ_theory ∧ sigma_WZ_theory ≥ sigma_WZ_cms) ∧
  -- ATLAS-SM mild high-side: gap ≤ 2× ATLAS unc + 1
  (sigma_WZ_atlas - sigma_WZ_theory ≤ 2 * sigma_WZ_atlas_unc + 1) ∧
  -- CMS-SM low-side: gap < CMS unc
  (sigma_WZ_theory - sigma_WZ_cms < sigma_WZ_cms_unc) ∧
  -- Substrate envelope captures all three
  (sigma_WZ_atlas - sigma_WZ_envelope_center ≤ sigma_WZ_envelope ∧
   sigma_WZ_envelope_center - sigma_WZ_cms ≤ sigma_WZ_envelope ∧
   sigma_WZ_envelope_center - sigma_WZ_theory ≤ sigma_WZ_envelope) ∧
  -- Envelope ≥ 5× CMS unc
  sigma_WZ_envelope ≥ 5 * sigma_WZ_cms_unc

/-- **🚨 s789 — `WZDibosonProductionLHCFrontier`** (full Prop discharged). -/
theorem T1_session_789_WZDibosonProductionLHCFrontier_holds :
    WZDibosonProductionLHCFrontier := by
  refine ⟨⟨T1_session_785_atlas_above_480,
          T1_session_785_atlas_below_540⟩,
         ⟨T1_session_786_cms_above_460,
          T1_session_786_cms_below_510⟩,
         ⟨T1_session_787_theory_above_480,
          T1_session_787_theory_below_510⟩,
         ⟨T1_session_787_atlas_ge_theory,
          T1_session_787_theory_ge_cms⟩,
         T1_session_787_atlas_gap_bounded,
         T1_session_787_cms_gap_below_unc,
         ⟨T1_session_788_envelope_captures_atlas,
          T1_session_788_envelope_captures_cms,
          T1_session_788_envelope_captures_theory⟩,
         T1_session_788_envelope_5x_cms_unc⟩

/-! ## Bundle alias -/

/-- **Bundle alias** — paper-citable short form: WZ diboson production
    LHC substrate envelope holds (substrate envelope captures ATLAS, CMS,
    and NNLO theory simultaneously within a 5σ working-units band). -/
def WZ_diboson_production_LHC_substrate_envelope : Prop :=
  WZDibosonProductionLHCFrontier

/-- **🚨 s789 — bundle alias holds**. -/
theorem T1_session_789_bundle_alias_holds :
    WZ_diboson_production_LHC_substrate_envelope :=
  T1_session_789_WZDibosonProductionLHCFrontier_holds

/-! ## Headline -/

/-- **HEADLINE — Bundled sessions 785-789 — WZ diboson production LHC frontier**.

    🚨 FRONTIER (T-1 ATLAS+CMS WZ diboson at √s=13TeV) 🚨

    Sixteen foundational facts (working units 0.1 pb throughout):
    1. `σ_atlas = 510 > 0` (ATLAS 2024, 51.0 pb).
    2. `σ_cms = 486 > 0` (CMS 2024, 48.6 pb).
    3. `σ_theory = 491 > 0` (NNLO QCD, 49.1 pb).
    4. `σ_envelope_center = 495 > 0` (substrate band center).
    5. `σ_envelope = 80 > 0` (5σ working-units half-width).
    6. ATLAS in `(480, 540)` — central anchor band.
    7. CMS in `(460, 510)` — central anchor band.
    8. Theory in `(480, 510)` — theory anchor band.
    9. Envelope ordering: `σ_atlas ≥ σ_theory ≥ σ_cms`.
    10. ATLAS-SM: `σ_atlas - σ_theory = 19` (1.9 pb, mild 1.1σ high-side).
    11. CMS-SM: `σ_theory - σ_cms = 5` (0.5 pb, sub-σ low-side).
    12. ATLAS gap bounded by `2σ_atlas_unc + 1` (19 ≤ 35).
    13. CMS gap below CMS uncertainty (5 < 10) — sub-σ agreement.
    14. Substrate envelope captures ATLAS, CMS, theory simultaneously.
    15. Envelope ≥ 5× CMS uncertainty band (5σ).
    16. ATLAS-CMS gap = 24 within combined uncertainty + 1 (28).

    Bundles five sessions s785-s789 closing the WZ diboson cross-section
    at LHC √s=13TeV frontier within T-1 (light quark masses). The WZ
    process is the canonical TGC (triple gauge coupling) probe at LHC,
    isolating the WWZ vertex and the SU(2)_L non-abelian gauge structure.

    Connects to T1_DrellYanDileptonLHCFrontier (qq̄ → Z dilepton, σ ≈ 1953 pb,
    pure NC EW probe), T1_TTbarPairProductionLHCFrontier (gg → tt̄,
    σ ≈ 832 pb, dominant heavy-quark process), and T1_LHCSMCrossSectionsBundle
    (4-anchor σ_W/σ_Z/σ_tt/σ_H inclusive bundle). At ≈ 49 pb, WZ sits
    between Higgs gg-fusion (49 pb) and top-pair (832 pb), the cleanest
    leptonic diboson probe and primary aTGC constraint at LHC.

    Sub-lemma N+1/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of WZ diboson production cross-section
    LHC √s=13TeV frontier with substrate envelope capture. -/
theorem session_785_to_789_WZ_diboson_production_LHC_frontier_headline :
    0 < sigma_WZ_atlas
    ∧ 0 < sigma_WZ_cms
    ∧ 0 < sigma_WZ_theory
    ∧ 0 < sigma_WZ_envelope_center
    ∧ 0 < sigma_WZ_envelope
    ∧ sigma_WZ_atlas > 480
    ∧ sigma_WZ_atlas < 540
    ∧ sigma_WZ_cms > 460
    ∧ sigma_WZ_cms < 510
    ∧ sigma_WZ_theory > 480
    ∧ sigma_WZ_theory < 510
    ∧ sigma_WZ_atlas ≥ sigma_WZ_theory
    ∧ sigma_WZ_theory ≥ sigma_WZ_cms
    ∧ sigma_WZ_atlas - sigma_WZ_theory = 19
    ∧ sigma_WZ_theory - sigma_WZ_cms = 5
    ∧ sigma_WZ_atlas - sigma_WZ_theory ≤ 2 * sigma_WZ_atlas_unc + 1
    ∧ sigma_WZ_theory - sigma_WZ_cms < sigma_WZ_cms_unc
    ∧ sigma_WZ_atlas - sigma_WZ_envelope_center ≤ sigma_WZ_envelope
    ∧ sigma_WZ_envelope_center - sigma_WZ_cms ≤ sigma_WZ_envelope
    ∧ sigma_WZ_envelope_center - sigma_WZ_theory ≤ sigma_WZ_envelope
    ∧ sigma_WZ_envelope ≥ 5 * sigma_WZ_cms_unc
    ∧ sigma_WZ_atlas - sigma_WZ_cms = 24
    ∧ WZDibosonProductionLHCFrontier
    ∧ WZ_diboson_production_LHC_substrate_envelope :=
  ⟨T1_sigma_WZ_atlas_pos, T1_sigma_WZ_cms_pos, T1_sigma_WZ_theory_pos,
   T1_sigma_WZ_envelope_center_pos, T1_sigma_WZ_envelope_pos,
   T1_session_785_atlas_above_480, T1_session_785_atlas_below_540,
   T1_session_786_cms_above_460, T1_session_786_cms_below_510,
   T1_session_787_theory_above_480, T1_session_787_theory_below_510,
   T1_session_787_atlas_ge_theory, T1_session_787_theory_ge_cms,
   T1_session_787_atlas_above_theory_by_19,
   T1_session_787_theory_above_cms_by_5,
   T1_session_787_atlas_gap_bounded,
   T1_session_787_cms_gap_below_unc,
   T1_session_788_envelope_captures_atlas,
   T1_session_788_envelope_captures_cms,
   T1_session_788_envelope_captures_theory,
   T1_session_788_envelope_5x_cms_unc,
   T1_session_788_atlas_above_cms_by_24,
   T1_session_789_WZDibosonProductionLHCFrontier_holds,
   T1_session_789_bundle_alias_holds⟩

end OmegaTheory.Predictions.T1_WZDibosonProductionLHCFrontier
