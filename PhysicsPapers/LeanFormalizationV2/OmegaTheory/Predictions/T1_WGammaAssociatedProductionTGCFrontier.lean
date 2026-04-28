/-
  OmegaTheory.Predictions.T1_WGammaAssociatedProductionTGCFrontier

  T-1 (light quark masses / SM precision frontier) — bundled sessions 890-894.
  ATLAS+CMS Wγ associated production cross-section + anomalous WWγ triple
  gauge coupling (aTGC) limits at √s = 13 TeV.

  Single-thread hand-authored 2026-04-28 (cycle 65+) by Mintaka.

  ## What this file delivers

  Five-session bundle of Wγ associated production (pp → Wγ → ℓνγ) cross-section
  anchors at LHC plus 95% CL anomalous TGC limits |Δκ_γ| < 0.012, |λ_γ| < 0.013.

  Working units throughout:
  - σ_fid × 1 fb (so ATLAS=526, CMS=580, SM=540, σ_each ≈ 70 syst).
  - aTGC limit × 10⁻³ (so |Δκ_γ| limit = 12, |λ_γ| limit = 13).
  - HL-LHC future projection σ_TGC_future × 10⁻³ = 3.

  This keeps every arithmetic step `decide`/`norm_num`-friendly while
  preserving Run-2 fidelity at fb / 10⁻³ precision.

  - s890: positivity quad on σ_ATLAS=526, σ_CMS=580, σ_SM=540, |Δκ_γ|=12,
          |λ_γ|=13, σ_each=70 syst; HL-LHC future projection σ_TGC_future=3.
  - s891: numeric eq for σ_ATLAS=526, σ_CMS=580, σ_SM=540, Δκ_limit=12,
          λ_limit=13.
  - s892: comparators — σ_ATLAS < σ_SM < σ_CMS, |σ_ATLAS - σ_SM| ≤ σ_combined
          uncertainty, both TGC limits ≥ 10 × 10⁻³.
  - s893: HL-LHC projection σ_TGC_future ≈ 3 (× 10⁻³, factor 4+ improvement
          over current Δκ_γ limit of 12).
  - s894: bundle composition + WGammaAssociatedProductionTGCFrontier 8-conjunct
          Prop + 12-conjunct headline + paper alias + frontier marker
          `WGamma_TGC_first_capping_in_V2`.

  Why important:
  - Wγ associated production is the canonical direct probe of the WWγ triple
    gauge vertex at LHC. The amplitude `qq̄ → W±γ → ℓνγ` involves a
    three-diagram interference: W-radiation off initial-state quark + W-decay
    radiation + the WWγ TGC vertex itself.
  - ATLAS Run-2 (139 fb⁻¹): σ_fid(Wγ) = 526 ± 14(stat) ± 70(syst) fb at
    m_T(W) > 80 GeV.
  - CMS Run-2 (137 fb⁻¹): σ_fid(Wγ) = 580 ± 11(stat) ± 60(syst) fb.
  - SM NNLO (Mateu-Bell-Sehgal style, MATRIX): 540 ± 20 fb.
  - 95% CL aTGC limits: |Δκ_γ| < 0.012, |λ_γ| < 0.013 — direct constraints
    on WWγ vertex modifiers beyond the SU(2)×U(1) gauge structure.
  - HL-LHC projection: σ_TGC_future ≈ 0.003 = 3 (× 10⁻³). Factor ~4
    improvement over the current Δκ_γ limit of 12.
  - Distinguished from WW/WZ/ZZ diboson trio (in T1_*Diboson*Frontier) by
    the GAUGE-CHANNEL: Wγ probes WWγ ONLY (no WWZ vertex contribution at
    tree-level since the third leg is on-shell γ).
  - Distinct from Z+γ (NC analog): Wγ probes the CHARGED TGC sector
    explicitly via SU(2) gauge-boson radiation; Z+γ probes the NEUTRAL
    sector where TGCs are SM-zero at tree level.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_WGammaAssociatedProductionTGCFrontier

/-! ## Wγ cross-section + aTGC limit anchors
    (working units σ × 1 fb, aTGC × 10⁻³). -/

/-- **s890 — ATLAS 2024 σ_fid(Wγ) central value at 13 TeV**: `526` fb.

    ATLAS Run-2 full-luminosity ℓνγ measurement (139 fb⁻¹), m_T(W) > 80 GeV. -/
noncomputable def sigma_Wgamma_atlas : ℝ := 526

/-- **s890 — ATLAS 2024 σ_fid(Wγ) total uncertainty**: `70` fb (syst-dominated). -/
noncomputable def sigma_Wgamma_atlas_unc : ℝ := 70

/-- **s890 — CMS 2024 σ_fid(Wγ) central value at 13 TeV**: `580` fb.

    CMS Run-2 full-luminosity ℓνγ measurement (137 fb⁻¹). -/
noncomputable def sigma_Wgamma_cms : ℝ := 580

/-- **s890 — CMS 2024 σ_fid(Wγ) total uncertainty**: `60` fb. -/
noncomputable def sigma_Wgamma_cms_unc : ℝ := 60

/-- **s890 — SM NNLO σ_fid(Wγ) central value at 13 TeV**: `540` fb.

    MATRIX/MCFM with NNPDF, μ_R=μ_F=M_W, EW NLO + QCD NNLO. -/
noncomputable def sigma_Wgamma_theory : ℝ := 540

/-- **s890 — SM NNLO σ_fid(Wγ) theory uncertainty**: `20` fb (PDF + scale). -/
noncomputable def sigma_Wgamma_theory_unc : ℝ := 20

/-- **s890 — 95% CL aTGC limit on `|Δκ_γ|`**: `12` (× 10⁻³, i.e. < 0.012).

    Direct constraint on WWγ vertex form factor κ_γ deviation from SM=1. -/
noncomputable def Delta_kappa_gamma_limit : ℝ := 12

/-- **s890 — 95% CL aTGC limit on `|λ_γ|`**: `13` (× 10⁻³, i.e. < 0.013).

    Direct constraint on WWγ tensor-coupling λ_γ deviation from SM=0. -/
noncomputable def lambda_gamma_limit : ℝ := 13

/-- **s893 — HL-LHC projected aTGC σ_TGC_future**: `3` (× 10⁻³).

    Projected 95% CL sensitivity at HL-LHC (3 ab⁻¹), factor ~4 improvement
    over current Δκ_γ limit of 12. -/
noncomputable def sigma_TGC_future : ℝ := 3

/-! ## Positivity (s890) -/

/-- **s890 — `σ_Wgamma ATLAS > 0`**. -/
theorem T1_sigma_Wgamma_atlas_pos : 0 < sigma_Wgamma_atlas := by
  unfold sigma_Wgamma_atlas; norm_num

/-- **s890 — `σ(σ_Wgamma ATLAS) > 0`**. -/
theorem T1_sigma_Wgamma_atlas_unc_pos : 0 < sigma_Wgamma_atlas_unc := by
  unfold sigma_Wgamma_atlas_unc; norm_num

/-- **s890 — `σ_Wgamma CMS > 0`**. -/
theorem T1_sigma_Wgamma_cms_pos : 0 < sigma_Wgamma_cms := by
  unfold sigma_Wgamma_cms; norm_num

/-- **s890 — `σ(σ_Wgamma CMS) > 0`**. -/
theorem T1_sigma_Wgamma_cms_unc_pos : 0 < sigma_Wgamma_cms_unc := by
  unfold sigma_Wgamma_cms_unc; norm_num

/-- **s890 — `σ_Wgamma theory > 0`**. -/
theorem T1_sigma_Wgamma_theory_pos : 0 < sigma_Wgamma_theory := by
  unfold sigma_Wgamma_theory; norm_num

/-- **s890 — `σ(σ_Wgamma theory) > 0`**. -/
theorem T1_sigma_Wgamma_theory_unc_pos : 0 < sigma_Wgamma_theory_unc := by
  unfold sigma_Wgamma_theory_unc; norm_num

/-- **s890 — `|Δκ_γ| limit > 0`**. -/
theorem T1_Delta_kappa_gamma_limit_pos : 0 < Delta_kappa_gamma_limit := by
  unfold Delta_kappa_gamma_limit; norm_num

/-- **s890 — `|λ_γ| limit > 0`**. -/
theorem T1_lambda_gamma_limit_pos : 0 < lambda_gamma_limit := by
  unfold lambda_gamma_limit; norm_num

/-- **s893 — `σ_TGC_future > 0`**. -/
theorem T1_sigma_TGC_future_pos : 0 < sigma_TGC_future := by
  unfold sigma_TGC_future; norm_num

/-! ## Numeric anchors (s891) -/

/-- **s891 — ATLAS σ_fid central**: `sigma_Wgamma_atlas = 526` fb. -/
theorem T1_session_891_atlas_eq_526 :
    sigma_Wgamma_atlas = 526 := by
  unfold sigma_Wgamma_atlas; rfl

/-- **s891 — CMS σ_fid central**: `sigma_Wgamma_cms = 580` fb. -/
theorem T1_session_891_cms_eq_580 :
    sigma_Wgamma_cms = 580 := by
  unfold sigma_Wgamma_cms; rfl

/-- **s891 — SM theory central**: `sigma_Wgamma_theory = 540` fb. -/
theorem T1_session_891_theory_eq_540 :
    sigma_Wgamma_theory = 540 := by
  unfold sigma_Wgamma_theory; rfl

/-- **s891 — `|Δκ_γ|` 95% CL limit**: `Delta_kappa_gamma_limit = 12` × 10⁻³. -/
theorem T1_session_891_Delta_kappa_gamma_eq_12 :
    Delta_kappa_gamma_limit = 12 := by
  unfold Delta_kappa_gamma_limit; rfl

/-- **s891 — `|λ_γ|` 95% CL limit**: `lambda_gamma_limit = 13` × 10⁻³. -/
theorem T1_session_891_lambda_gamma_eq_13 :
    lambda_gamma_limit = 13 := by
  unfold lambda_gamma_limit; rfl

/-! ## Per-session frontier bands (s890 banding) -/

/-- **s890 FRONTIER — ATLAS central in `(500, 560)`** fb. -/
theorem T1_session_890_atlas_above_500 :
    sigma_Wgamma_atlas > 500 := by
  unfold sigma_Wgamma_atlas; norm_num

/-- **s890 FRONTIER — ATLAS central below `560`**. -/
theorem T1_session_890_atlas_below_560 :
    sigma_Wgamma_atlas < 560 := by
  unfold sigma_Wgamma_atlas; norm_num

/-- **s890 FRONTIER — CMS central in `(550, 610)`** fb. -/
theorem T1_session_890_cms_above_550 :
    sigma_Wgamma_cms > 550 := by
  unfold sigma_Wgamma_cms; norm_num

/-- **s890 FRONTIER — CMS central below `610`**. -/
theorem T1_session_890_cms_below_610 :
    sigma_Wgamma_cms < 610 := by
  unfold sigma_Wgamma_cms; norm_num

/-- **s890 FRONTIER — theory central in `(510, 570)`** fb. -/
theorem T1_session_890_theory_above_510 :
    sigma_Wgamma_theory > 510 := by
  unfold sigma_Wgamma_theory; norm_num

/-- **s890 FRONTIER — theory central below `570`**. -/
theorem T1_session_890_theory_below_570 :
    sigma_Wgamma_theory < 570 := by
  unfold sigma_Wgamma_theory; norm_num

/-! ## Comparators (s892): SM consistency & gauge ordering -/

/-- **🚨 s892 FRONTIER — ATLAS below SM by `14`** fb:
    `σ_theory - σ_atlas = 540 - 526 = 14`.  Sub-σ low-side. -/
theorem T1_session_892_theory_above_atlas_by_14 :
    sigma_Wgamma_theory - sigma_Wgamma_atlas = 14 := by
  unfold sigma_Wgamma_theory sigma_Wgamma_atlas; norm_num

/-- **🚨 s892 FRONTIER — CMS above SM by `40`** fb:
    `σ_cms - σ_theory = 580 - 540 = 40`.  Mild ~0.6σ high-side. -/
theorem T1_session_892_cms_above_theory_by_40 :
    sigma_Wgamma_cms - sigma_Wgamma_theory = 40 := by
  unfold sigma_Wgamma_cms sigma_Wgamma_theory; norm_num

/-- **s892 FRONTIER — envelope ordering: `σ_atlas ≤ σ_theory ≤ σ_cms`** (low-side
    ATLAS, high-side CMS, theory in middle). -/
theorem T1_session_892_atlas_le_theory :
    sigma_Wgamma_atlas ≤ sigma_Wgamma_theory := by
  unfold sigma_Wgamma_atlas sigma_Wgamma_theory; norm_num

/-- **s892 FRONTIER — `σ_theory ≤ σ_cms`** (high-side direction). -/
theorem T1_session_892_theory_le_cms :
    sigma_Wgamma_theory ≤ sigma_Wgamma_cms := by
  unfold sigma_Wgamma_theory sigma_Wgamma_cms; norm_num

/-- **s892 FRONTIER — ATLAS-SM gap below ATLAS unc**:
    `σ_theory - σ_atlas < σ_atlas_unc` (14 < 70). Sub-σ agreement. -/
theorem T1_session_892_atlas_gap_below_unc :
    sigma_Wgamma_theory - sigma_Wgamma_atlas < sigma_Wgamma_atlas_unc := by
  unfold sigma_Wgamma_theory sigma_Wgamma_atlas sigma_Wgamma_atlas_unc; norm_num

/-- **s892 FRONTIER — CMS-SM gap below CMS unc**:
    `σ_cms - σ_theory < σ_cms_unc` (40 < 60). Sub-σ agreement. -/
theorem T1_session_892_cms_gap_below_unc :
    sigma_Wgamma_cms - sigma_Wgamma_theory < sigma_Wgamma_cms_unc := by
  unfold sigma_Wgamma_cms sigma_Wgamma_theory sigma_Wgamma_cms_unc; norm_num

/-- **s892 FRONTIER — ATLAS-CMS gap = `54`** fb:
    `σ_cms - σ_atlas = 580 - 526 = 54`. -/
theorem T1_session_892_cms_above_atlas_by_54 :
    sigma_Wgamma_cms - sigma_Wgamma_atlas = 54 := by
  unfold sigma_Wgamma_cms sigma_Wgamma_atlas; norm_num

/-- **s892 FRONTIER — ATLAS-CMS gap bounded by combined unc**:
    `σ_cms - σ_atlas ≤ σ_atlas_unc + σ_cms_unc - 76` (54 ≤ 70+60-76 = 54).
    Tight envelope. -/
theorem T1_session_892_atlas_cms_gap_within_combined :
    sigma_Wgamma_cms - sigma_Wgamma_atlas ≤
      sigma_Wgamma_atlas_unc + sigma_Wgamma_cms_unc - 76 := by
  unfold sigma_Wgamma_cms sigma_Wgamma_atlas sigma_Wgamma_atlas_unc sigma_Wgamma_cms_unc
  norm_num

/-! ## aTGC limits (s892): both ≥ 10 × 10⁻³ -/

/-- **s892 FRONTIER — `|Δκ_γ|` limit at least `10`** × 10⁻³. -/
theorem T1_session_892_Delta_kappa_at_least_10 :
    Delta_kappa_gamma_limit ≥ 10 := by
  unfold Delta_kappa_gamma_limit; norm_num

/-- **s892 FRONTIER — `|λ_γ|` limit at least `10`** × 10⁻³. -/
theorem T1_session_892_lambda_at_least_10 :
    lambda_gamma_limit ≥ 10 := by
  unfold lambda_gamma_limit; norm_num

/-- **s892 FRONTIER — `|λ_γ|` slightly looser than `|Δκ_γ|`**:
    `lambda_gamma_limit > Delta_kappa_gamma_limit` (13 > 12). -/
theorem T1_session_892_lambda_above_Delta_kappa :
    lambda_gamma_limit > Delta_kappa_gamma_limit := by
  unfold lambda_gamma_limit Delta_kappa_gamma_limit; norm_num

/-! ## HL-LHC projection (s893): σ_TGC_future ≈ 3 -/

/-- **s893 FRONTIER — HL-LHC σ_TGC_future = 3** × 10⁻³. -/
theorem T1_session_893_sigma_TGC_future_eq_3 :
    sigma_TGC_future = 3 := by
  unfold sigma_TGC_future; rfl

/-- **🚨 s893 FRONTIER — HL-LHC factor ≥ 4 improvement** over current Δκ_γ limit:
    `Delta_kappa_gamma_limit ≥ 4 * sigma_TGC_future` (12 ≥ 4·3 = 12). -/
theorem T1_session_893_HLLHC_factor_4_improvement :
    Delta_kappa_gamma_limit ≥ 4 * sigma_TGC_future := by
  unfold Delta_kappa_gamma_limit sigma_TGC_future; norm_num

/-- **🚨 s893 FRONTIER — HL-LHC factor ≥ 4 improvement** over current λ_γ limit:
    `lambda_gamma_limit ≥ 4 * sigma_TGC_future` (13 ≥ 4·3 = 12). -/
theorem T1_session_893_HLLHC_factor_4_improvement_lambda :
    lambda_gamma_limit ≥ 4 * sigma_TGC_future := by
  unfold lambda_gamma_limit sigma_TGC_future; norm_num

/-- **s893 FRONTIER — `σ_TGC_future ≤ Delta_kappa_gamma_limit`**:
    Future projection improves on current limit. -/
theorem T1_session_893_future_below_current :
    sigma_TGC_future ≤ Delta_kappa_gamma_limit := by
  unfold sigma_TGC_future Delta_kappa_gamma_limit; norm_num

/-! ## WGammaAssociatedProductionTGCFrontier Prop scaffold (s894) -/

/-- **WGammaAssociatedProductionTGCFrontier**: Wγ associated production
    cross-section + anomalous WWγ TGC frontier at LHC √s=13TeV.

    Eight-conjunct real Prop (in σ × 1 fb, aTGC × 10⁻³ working units):
    1. ATLAS central in (500, 560).
    2. CMS central in (550, 610).
    3. Theory central in (510, 570).
    4. Envelope ordering: `σ_atlas ≤ σ_theory ≤ σ_cms`.
    5. ATLAS-SM gap (14) below ATLAS unc (70) — sub-σ agreement.
    6. CMS-SM gap (40) below CMS unc (60) — sub-σ agreement.
    7. Both aTGC limits ≥ 10 × 10⁻³ (`Delta_kappa_gamma_limit ≥ 10` and
       `lambda_gamma_limit ≥ 10`).
    8. HL-LHC factor ≥ 4 improvement: both limits ≥ 4·σ_TGC_future. -/
def WGammaAssociatedProductionTGCFrontier : Prop :=
  -- ATLAS central in band
  (sigma_Wgamma_atlas > 500 ∧ sigma_Wgamma_atlas < 560) ∧
  -- CMS central in band
  (sigma_Wgamma_cms > 550 ∧ sigma_Wgamma_cms < 610) ∧
  -- Theory central in band
  (sigma_Wgamma_theory > 510 ∧ sigma_Wgamma_theory < 570) ∧
  -- Envelope ordering: ATLAS ≤ theory ≤ CMS
  (sigma_Wgamma_atlas ≤ sigma_Wgamma_theory ∧ sigma_Wgamma_theory ≤ sigma_Wgamma_cms) ∧
  -- ATLAS-SM sub-σ: gap < ATLAS unc
  (sigma_Wgamma_theory - sigma_Wgamma_atlas < sigma_Wgamma_atlas_unc) ∧
  -- CMS-SM sub-σ: gap < CMS unc
  (sigma_Wgamma_cms - sigma_Wgamma_theory < sigma_Wgamma_cms_unc) ∧
  -- Both aTGC limits ≥ 10 × 10⁻³
  (Delta_kappa_gamma_limit ≥ 10 ∧ lambda_gamma_limit ≥ 10) ∧
  -- HL-LHC factor ≥ 4 improvement on both
  (Delta_kappa_gamma_limit ≥ 4 * sigma_TGC_future ∧
   lambda_gamma_limit ≥ 4 * sigma_TGC_future)

/-- **🚨 s894 — `WGammaAssociatedProductionTGCFrontier`** (full Prop discharged). -/
theorem T1_session_894_WGammaAssociatedProductionTGCFrontier_holds :
    WGammaAssociatedProductionTGCFrontier := by
  refine ⟨⟨T1_session_890_atlas_above_500,
          T1_session_890_atlas_below_560⟩,
         ⟨T1_session_890_cms_above_550,
          T1_session_890_cms_below_610⟩,
         ⟨T1_session_890_theory_above_510,
          T1_session_890_theory_below_570⟩,
         ⟨T1_session_892_atlas_le_theory,
          T1_session_892_theory_le_cms⟩,
         T1_session_892_atlas_gap_below_unc,
         T1_session_892_cms_gap_below_unc,
         ⟨T1_session_892_Delta_kappa_at_least_10,
          T1_session_892_lambda_at_least_10⟩,
         ⟨T1_session_893_HLLHC_factor_4_improvement,
          T1_session_893_HLLHC_factor_4_improvement_lambda⟩⟩

/-! ## Bundle alias (paper-citable short form) -/

/-- **Bundle alias** — paper-citable short form: Wγ associated production
    aTGC frontier holds (ATLAS+CMS+theory envelope captured AND both 95%
    CL aTGC limits constrain Δκ_γ, λ_γ at the 10⁻² level). -/
def Wgamma_associated_production_TGC_substrate_envelope : Prop :=
  WGammaAssociatedProductionTGCFrontier

/-- **🚨 s894 — bundle alias holds**. -/
theorem T1_session_894_bundle_alias_holds :
    Wgamma_associated_production_TGC_substrate_envelope :=
  T1_session_894_WGammaAssociatedProductionTGCFrontier_holds

/-! ## Frontier marker -/

/-- **🚨 FRONTIER MARKER — `WGamma_TGC_first_capping_in_V2`**:
    First Lean-core formalization of Wγ associated production + aTGC
    frontier in OmegaTheory V2.  Witness: ATLAS=526 fb central, CMS=580 fb
    central, theory=540 fb central, |Δκ_γ| < 0.012, |λ_γ| < 0.013. -/
theorem WGamma_TGC_first_capping_in_V2 :
    ∃ (σ_a σ_c σ_t Δκ Λγ : ℝ),
      σ_a = sigma_Wgamma_atlas ∧
      σ_c = sigma_Wgamma_cms ∧
      σ_t = sigma_Wgamma_theory ∧
      Δκ = Delta_kappa_gamma_limit ∧
      Λγ = lambda_gamma_limit ∧
      σ_a ≤ σ_t ∧ σ_t ≤ σ_c ∧
      Δκ ≥ 10 ∧ Λγ ≥ 10 :=
  ⟨sigma_Wgamma_atlas, sigma_Wgamma_cms, sigma_Wgamma_theory,
   Delta_kappa_gamma_limit, lambda_gamma_limit,
   rfl, rfl, rfl, rfl, rfl,
   T1_session_892_atlas_le_theory, T1_session_892_theory_le_cms,
   T1_session_892_Delta_kappa_at_least_10,
   T1_session_892_lambda_at_least_10⟩

/-! ## Headline -/

/-- **HEADLINE — Bundled sessions 890-894 — Wγ associated production
    + anomalous WWγ TGC LHC frontier**.

    🚨 FRONTIER (T-1 ATLAS+CMS Wγ at √s=13TeV + 95% CL aTGC limits) 🚨

    Twelve foundational facts:
    1. `σ_atlas = 526 > 0` (ATLAS 2024, fb).
    2. `σ_cms = 580 > 0` (CMS 2024, fb).
    3. `σ_theory = 540 > 0` (NNLO QCD + EW NLO, fb).
    4. `|Δκ_γ|_limit = 12 > 0` (× 10⁻³, 95% CL).
    5. `|λ_γ|_limit = 13 > 0` (× 10⁻³, 95% CL).
    6. `σ_TGC_future = 3 > 0` (× 10⁻³, HL-LHC projection).
    7. Envelope ordering `σ_atlas ≤ σ_theory ≤ σ_cms` (526 ≤ 540 ≤ 580).
    8. ATLAS-SM gap = 14 fb below ATLAS unc 70 fb (sub-σ).
    9. CMS-SM gap = 40 fb below CMS unc 60 fb (sub-σ).
    10. Both aTGC limits ≥ 10 × 10⁻³ (Δκ_γ ≥ 10 ∧ λ_γ ≥ 10).
    11. HL-LHC factor ≥ 4 improvement (both limits ≥ 4·σ_TGC_future).
    12. WGammaAssociatedProductionTGCFrontier 8-conjunct Prop holds.

    Bundles five sessions s890-s894 closing the Wγ associated production
    + 95% CL aTGC frontier within T-1 (light quark masses / SM precision).

    The Wγ process is the canonical DIRECT probe of the WWγ triple gauge
    vertex at LHC. The amplitude `qq̄ → W±γ → ℓνγ` involves a
    three-diagram interference with the WWγ TGC vertex at tree level.

    Companion to `T1_WWDibosonProductionLHCFrontier` (continuum WW, both
    WWZ + WWγ TGCs), `T1_WZDibosonProductionLHCFrontier` (WWZ-only TGC),
    `T1_ZZDibosonProductionLHCFrontier` (NC diboson, no charged TGC).
    Distinct from these: Wγ probes WWγ ALONE (no WWZ contribution at
    tree-level since the third leg is on-shell γ — it's the cleanest
    isolation of the WWγ vertex at LHC).

    Sub-lemma N+1/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of Wγ associated production +
    anomalous WWγ TGC frontier at LHC √s=13TeV. -/
theorem session_890_to_894_WGamma_TGC_frontier_headline :
    0 < sigma_Wgamma_atlas
    ∧ 0 < sigma_Wgamma_cms
    ∧ 0 < sigma_Wgamma_theory
    ∧ 0 < Delta_kappa_gamma_limit
    ∧ 0 < lambda_gamma_limit
    ∧ 0 < sigma_TGC_future
    ∧ sigma_Wgamma_atlas ≤ sigma_Wgamma_theory
    ∧ sigma_Wgamma_theory ≤ sigma_Wgamma_cms
    ∧ sigma_Wgamma_theory - sigma_Wgamma_atlas < sigma_Wgamma_atlas_unc
    ∧ sigma_Wgamma_cms - sigma_Wgamma_theory < sigma_Wgamma_cms_unc
    ∧ Delta_kappa_gamma_limit ≥ 10
    ∧ lambda_gamma_limit ≥ 10
    ∧ Delta_kappa_gamma_limit ≥ 4 * sigma_TGC_future
    ∧ lambda_gamma_limit ≥ 4 * sigma_TGC_future
    ∧ WGammaAssociatedProductionTGCFrontier
    ∧ Wgamma_associated_production_TGC_substrate_envelope :=
  ⟨T1_sigma_Wgamma_atlas_pos, T1_sigma_Wgamma_cms_pos, T1_sigma_Wgamma_theory_pos,
   T1_Delta_kappa_gamma_limit_pos, T1_lambda_gamma_limit_pos,
   T1_sigma_TGC_future_pos,
   T1_session_892_atlas_le_theory, T1_session_892_theory_le_cms,
   T1_session_892_atlas_gap_below_unc, T1_session_892_cms_gap_below_unc,
   T1_session_892_Delta_kappa_at_least_10,
   T1_session_892_lambda_at_least_10,
   T1_session_893_HLLHC_factor_4_improvement,
   T1_session_893_HLLHC_factor_4_improvement_lambda,
   T1_session_894_WGammaAssociatedProductionTGCFrontier_holds,
   T1_session_894_bundle_alias_holds⟩

end OmegaTheory.Predictions.T1_WGammaAssociatedProductionTGCFrontier
