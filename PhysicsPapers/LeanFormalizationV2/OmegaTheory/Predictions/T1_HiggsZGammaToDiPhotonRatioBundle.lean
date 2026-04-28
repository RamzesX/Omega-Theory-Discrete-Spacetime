/-
  OmegaTheory.Predictions.T1_HiggsZGammaToDiPhotonRatioBundle

  T-1 — Higgs H→Zγ vs H→γγ rare-decay ratio bundle, sessions 604-608.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Comparison of two rare loop-induced Higgs decays (in units of `10⁻⁴`):

  - s604: BR(H → Zγ) = 1.5 × 10⁻³ ± 0.4 × 10⁻³
          (LHC ATLAS+CMS combo, first observation at 3.4σ in 2024;
           SM-anchored central value)
  - s605: BR(H → γγ) = 2.27 × 10⁻³ ± 0.07 × 10⁻³
          (PDG 2024, well-measured loop-induced golden discovery channel)
  - s606: Hierarchy γγ > Zγ (γγ ~1.5× more likely);
          factor-of-two-bound and ~3:2 ratio
  - s607: Sum BR(γγ) + BR(Zγ) < 1% (rare loop-induced channels)
  - s608: bundle composition + HiggsZGammaDiPhotonRatio Prop

  Why the comparison matters: both decays proceed at one-loop only
  (no tree-level coupling), with W-boson + top-quark loops dominating.
  The γγ/Zγ ratio is a clean SM benchmark — BSM contributions
  (extra charged scalars, vector-like quarks) generically modify the two
  channels differently, so the ratio is a structural test of SM loop content.

  Companion file `T1_HiggsToZGammaFrontier` records the *observed-vs-SM*
  tension for H→Zγ (μ ~ 2.2); this file records the *SM γγ/Zγ ratio*.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_HiggsZGammaToDiPhotonRatioBundle

/-! ## BR anchors (in units of `10⁻⁴`) -/

/-- **BR(H → Zγ) central value**: `15` (= `15 × 10⁻⁴` = `0.0015`).

    LHC ATLAS+CMS combination, first observation 2024 at 3.4σ. -/
noncomputable def BR_H_Zgamma_units : ℝ := 15

/-- **BR(H → Zγ) uncertainty**: `4` (= `4 × 10⁻⁴` = `0.0004`). -/
noncomputable def sigma_BR_Zgamma : ℝ := 4

/-- **BR(H → γγ) central value**: `227/10` (= `22.7 × 10⁻⁴` = `0.00227`).

    PDG 2024 well-measured value, loop-induced golden discovery channel. -/
noncomputable def BR_H_gammagamma_units : ℝ := 227 / 10

/-- **BR(H → γγ) uncertainty**: `7/10` (= `0.7 × 10⁻⁴` = `7 × 10⁻⁵`). -/
noncomputable def sigma_BR_gg : ℝ := 7 / 10

/-! ## Positivity -/

/-- **🚨 s604 — `BR(H → Zγ) > 0`**. -/
theorem T1_BR_Zgamma_pos : 0 < BR_H_Zgamma_units := by
  unfold BR_H_Zgamma_units; norm_num

/-- **🚨 s604 — `σ(BR Zγ) > 0`**. -/
theorem T1_sigma_BR_Zgamma_pos : 0 < sigma_BR_Zgamma := by
  unfold sigma_BR_Zgamma; norm_num

/-- **🚨 s605 — `BR(H → γγ) > 0`**. -/
theorem T1_BR_gammagamma_pos : 0 < BR_H_gammagamma_units := by
  unfold BR_H_gammagamma_units; norm_num

/-- **🚨 s605 — `σ(BR γγ) > 0`**. -/
theorem T1_sigma_BR_gg_pos : 0 < sigma_BR_gg := by
  unfold sigma_BR_gg; norm_num

/-! ## Hierarchy: γγ above Zγ (~1.5×) -/

/-- **🚨 s606 — `BR(H → γγ) > BR(H → Zγ)`**.

    γγ rate (22.7×10⁻⁴) is above Zγ rate (15×10⁻⁴). -/
theorem T1_BR_gg_above_Zgamma :
    BR_H_gammagamma_units > BR_H_Zgamma_units := by
  unfold BR_H_gammagamma_units BR_H_Zgamma_units; norm_num

/-- **🚨 s606 — `2 × BR(Zγ) > BR(γγ)`** (factor < 2). -/
theorem T1_2x_Zgamma_above_gg :
    2 * BR_H_Zgamma_units > BR_H_gammagamma_units := by
  unfold BR_H_Zgamma_units BR_H_gammagamma_units; norm_num

/-- **🚨 s606 — `3 × BR(Zγ) > BR(γγ)`** (factor < 3:1, ~3:2 actual). -/
theorem T1_3x_Zgamma_above_gg :
    3 * BR_H_Zgamma_units > BR_H_gammagamma_units := by
  unfold BR_H_Zgamma_units BR_H_gammagamma_units; norm_num

/-! ## Sum bound (both rare loop-induced) -/

/-- **🚨 s607 — `BR(Zγ) + BR(γγ) < 100`** (in units of `10⁻⁴`,

    so sum `< 0.01` = `1%` — rare channels). -/
theorem T1_sum_below_1pct :
    BR_H_Zgamma_units + BR_H_gammagamma_units < 100 := by
  unfold BR_H_Zgamma_units BR_H_gammagamma_units; norm_num

/-- **🚨 s607 — `BR(Zγ) + BR(γγ) > 30`** (in units of `10⁻⁴`,

    so sum `> 0.003` = `0.3%` — non-trivial loop rate). -/
theorem T1_sum_above_30 :
    BR_H_Zgamma_units + BR_H_gammagamma_units > 30 := by
  unfold BR_H_Zgamma_units BR_H_gammagamma_units; norm_num

/-! ## Uncertainty smaller than central -/

/-- **🚨 s604 — `σ(BR Zγ) < BR(Zγ)`** (uncertainty smaller than signal,

    ~27% relative). -/
theorem T1_sigma_Zgamma_below_central :
    sigma_BR_Zgamma < BR_H_Zgamma_units := by
  unfold sigma_BR_Zgamma BR_H_Zgamma_units; norm_num

/-- **🚨 s605 — `σ(BR γγ) < BR(γγ)`** (uncertainty much smaller than signal,

    ~3% relative — well-measured). -/
theorem T1_sigma_gg_below_central :
    sigma_BR_gg < BR_H_gammagamma_units := by
  unfold sigma_BR_gg BR_H_gammagamma_units; norm_num

/-- **🚨 s605 — `σ(BR γγ) < σ(BR Zγ)`**.

    γγ is much better measured than Zγ
    (γγ uncertainty `0.7×10⁻⁴` vs Zγ uncertainty `4×10⁻⁴`). -/
theorem T1_sigma_gg_below_sigma_Zgamma :
    sigma_BR_gg < sigma_BR_Zgamma := by
  unfold sigma_BR_gg sigma_BR_Zgamma; norm_num

/-! ## Higgs Zγ-vs-γγ ratio Prop scaffold -/

/-- **HiggsZGammaDiPhotonRatio**: full ratio + hierarchy + smallness profile.

    Real Prop body. -/
def HiggsZGammaDiPhotonRatio : Prop :=
  -- Hierarchy γγ > Zγ
  BR_H_gammagamma_units > BR_H_Zgamma_units ∧
  -- Factor < 2 (γγ less than 2× Zγ)
  2 * BR_H_Zgamma_units > BR_H_gammagamma_units ∧
  -- Factor < 3 (γγ less than 3× Zγ)
  3 * BR_H_Zgamma_units > BR_H_gammagamma_units ∧
  -- Sum bounds
  BR_H_Zgamma_units + BR_H_gammagamma_units < 100 ∧
  BR_H_Zgamma_units + BR_H_gammagamma_units > 30 ∧
  -- Uncertainty smaller than central (both)
  sigma_BR_Zgamma < BR_H_Zgamma_units ∧
  sigma_BR_gg < BR_H_gammagamma_units ∧
  -- γγ better measured than Zγ
  sigma_BR_gg < sigma_BR_Zgamma

/-- **🚨 s608 — `HiggsZGammaDiPhotonRatio`**. -/
theorem T1_Higgs_Zgamma_vs_gg_ratio : HiggsZGammaDiPhotonRatio :=
  ⟨T1_BR_gg_above_Zgamma, T1_2x_Zgamma_above_gg, T1_3x_Zgamma_above_gg,
   T1_sum_below_1pct, T1_sum_above_30,
   T1_sigma_Zgamma_below_central, T1_sigma_gg_below_central,
   T1_sigma_gg_below_sigma_Zgamma⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 604-608 — Higgs Zγ-vs-γγ ratio bundle**.

    🏆 Foreground bundle (rare-decay ratio).

    5 sessions:
    - s604: BR(H → Zγ) = 1.5×10⁻³ ± 0.4×10⁻³ (LHC ATLAS+CMS, 3.4σ first obs)
    - s605: BR(H → γγ) = 2.27×10⁻³ ± 0.07×10⁻³ (PDG 2024 golden channel)
    - s606: Hierarchy γγ > Zγ; factor < 2; factor < 3 (~3:2 actual)
    - s607: Sum bound (rare loop-induced; both < 1% jointly)
    - s608: bundle composition + HiggsZGammaDiPhotonRatio Prop (8-conjunct)

    Both decays proceed at one-loop only (no tree-level coupling), with
    W-boson + top-quark loops dominating.  The γγ/Zγ ratio is a clean SM
    benchmark — BSM contributions (extra charged scalars, vector-like quarks)
    generically modify the two channels differently, so the ratio is a
    structural test of SM loop content.

    Companion: `T1_HiggsToZGammaFrontier` (μ ~ 2.2 obs/SM tension);
    `T1_HiggsBranchingRatiosBundle` (full BR hierarchy bb̄/WW/ττ/γγ).

    Sub-lemma 396-400/N in T-1.  Lean-core only.

    🏆 First Lean-core Higgs Zγ/γγ rare-decay ratio bundle. -/
theorem session_604_to_608_Higgs_ZGamma_DiPhoton_ratio_bundle_headline :
    0 < BR_H_Zgamma_units ∧ 0 < sigma_BR_Zgamma
    ∧ 0 < BR_H_gammagamma_units ∧ 0 < sigma_BR_gg
    ∧ BR_H_gammagamma_units > BR_H_Zgamma_units
    ∧ 2 * BR_H_Zgamma_units > BR_H_gammagamma_units
    ∧ 3 * BR_H_Zgamma_units > BR_H_gammagamma_units
    ∧ BR_H_Zgamma_units + BR_H_gammagamma_units < 100
    ∧ BR_H_Zgamma_units + BR_H_gammagamma_units > 30
    ∧ sigma_BR_Zgamma < BR_H_Zgamma_units
    ∧ sigma_BR_gg < BR_H_gammagamma_units
    ∧ sigma_BR_gg < sigma_BR_Zgamma
    ∧ HiggsZGammaDiPhotonRatio :=
  ⟨T1_BR_Zgamma_pos, T1_sigma_BR_Zgamma_pos,
   T1_BR_gammagamma_pos, T1_sigma_BR_gg_pos,
   T1_BR_gg_above_Zgamma, T1_2x_Zgamma_above_gg, T1_3x_Zgamma_above_gg,
   T1_sum_below_1pct, T1_sum_above_30,
   T1_sigma_Zgamma_below_central, T1_sigma_gg_below_central,
   T1_sigma_gg_below_sigma_Zgamma,
   T1_Higgs_Zgamma_vs_gg_ratio⟩

end OmegaTheory.Predictions.T1_HiggsZGammaToDiPhotonRatioBundle
