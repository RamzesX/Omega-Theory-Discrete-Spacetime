/-
  OmegaTheory.Predictions.T1_TauLeptonPrecisionBundle

  T-1 — tau lepton precision bundle, sessions 719-723.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Tau lepton precision tests (PDG 2024):

  - s719: τ_τ lifetime = 290.3 fs (femtoseconds), σ = 5 fs (rel 1.7%)
  - s720: BR(τ → eνν̄) = 17.82% ± 0.04% (leptonic e channel)
  - s721: BR(τ → μνν̄) = 17.39% ± 0.04% (leptonic μ channel)
  - s722: lepton universality — BR_e > BR_μ via phase space; ratio ≈ 0.9764
  - s723: bundle composition + TauLeptonPrecision Prop (8-conjunct)

  Anchors stored as Nat in convenient units:
  - lifetime in 0.1 fs units (`tau_tau_lifetime_units = 2903`)
  - BR in 10⁻⁴ units (`BR_tau_e_units = 1782`, `BR_tau_mu_units = 1739`)

  All Nat decide; bundle is precision sanity at PDG anchors.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Nat.Basic
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_TauLeptonPrecisionBundle

/-! ## τ lifetime anchor (in 0.1 fs units) -/

/-- **τ_τ lifetime PDG 2024**: `290.3 fs = 2903 × 0.1 fs`. -/
def tau_tau_lifetime_units : ℕ := 2903

/-- **σ(τ_τ) PDG 2024**: `5 fs = 50 × 0.1 fs` (relative ~1.7%). -/
def sigma_tau_lifetime_units : ℕ := 50

/-! ## τ leptonic branching ratio anchors (in 10⁻⁴ units) -/

/-- **BR(τ → eνν̄) PDG 2024**: `17.82% = 1782 × 10⁻⁴`. -/
def BR_tau_e_units : ℕ := 1782

/-- **σ(BR_e) PDG 2024**: `0.04% = 4 × 10⁻⁴`. -/
def sigma_tau_e_units : ℕ := 4

/-- **BR(τ → μνν̄) PDG 2024**: `17.39% = 1739 × 10⁻⁴`. -/
def BR_tau_mu_units : ℕ := 1739

/-- **σ(BR_μ) PDG 2024**: `0.04% = 4 × 10⁻⁴`. -/
def sigma_tau_mu_units : ℕ := 4

/-! ## s719 — lifetime sanity -/

/-- **🚨 s719 — `τ_τ lifetime > 0`**. -/
theorem T1_tau_lifetime_pos : 0 < tau_tau_lifetime_units := by decide

/-- **🚨 s719 — `σ_τ > 0`**. -/
theorem T1_sigma_tau_lifetime_pos : 0 < sigma_tau_lifetime_units := by decide

/-- **🚨 s719 — `σ < lifetime`** (precision below central value). -/
theorem T1_sigma_below_lifetime :
    sigma_tau_lifetime_units < tau_tau_lifetime_units := by decide

/-- **🚨 s719 — `100 · σ < 2 · lifetime`** (relative precision < 2%).

    Computed: 100·50 = 5000 < 2·2903 = 5806. ✓ -/
theorem T1_lifetime_relative_precision_below_2pct :
    100 * sigma_tau_lifetime_units < 2 * tau_tau_lifetime_units := by decide

/-- **🚨 s719 — `lifetime < 10⁶ × 0.1 fs`** (lifetime well below ms regime).

    Sanity bound: 2903 < 1_000_000 (i.e., 290.3 fs ≪ 0.1 ms). -/
theorem T1_lifetime_below_microsecond_scale :
    tau_tau_lifetime_units < 1000000 := by decide

/-! ## s720 — BR(τ → eνν̄) sanity -/

/-- **🚨 s720 — `BR_e > 0`**. -/
theorem T1_BR_tau_e_pos : 0 < BR_tau_e_units := by decide

/-- **🚨 s720 — `σ_e < BR_e`**. -/
theorem T1_sigma_e_below_BR_e : sigma_tau_e_units < BR_tau_e_units := by decide

/-- **🚨 s720 — relative precision `σ_e / BR_e < 1/100`** as `100·σ < BR`.

    100·4 = 400 < 1782. ✓ Precision better than 1%. -/
theorem T1_BR_e_relative_precision_below_1pct :
    100 * sigma_tau_e_units < BR_tau_e_units := by decide

/-- **🚨 s720 — `BR_e < 2000`** (i.e., < 20% of total). -/
theorem T1_BR_e_below_20pct : BR_tau_e_units < 2000 := by decide

/-- **🚨 s720 — `BR_e > 1500`** (i.e., > 15%, above pure leptonic floor). -/
theorem T1_BR_e_above_15pct : 1500 < BR_tau_e_units := by decide

/-! ## s721 — BR(τ → μνν̄) sanity -/

/-- **🚨 s721 — `BR_μ > 0`**. -/
theorem T1_BR_tau_mu_pos : 0 < BR_tau_mu_units := by decide

/-- **🚨 s721 — `σ_μ < BR_μ`**. -/
theorem T1_sigma_mu_below_BR_mu :
    sigma_tau_mu_units < BR_tau_mu_units := by decide

/-- **🚨 s721 — relative precision `σ_μ / BR_μ < 1/100`** as `100·σ < BR`.

    100·4 = 400 < 1739. ✓ Precision better than 1%. -/
theorem T1_BR_mu_relative_precision_below_1pct :
    100 * sigma_tau_mu_units < BR_tau_mu_units := by decide

/-- **🚨 s721 — `BR_μ < 2000`** (i.e., < 20% of total). -/
theorem T1_BR_mu_below_20pct : BR_tau_mu_units < 2000 := by decide

/-- **🚨 s721 — `BR_μ > 1500`** (i.e., > 15%). -/
theorem T1_BR_mu_above_15pct : 1500 < BR_tau_mu_units := by decide

/-! ## s722 — Lepton universality (BR_e > BR_μ via phase space) -/

/-- **🚨 s722 — `BR_e > BR_μ`** (phase-space asymmetry from m_e < m_μ). -/
theorem T1_BR_e_above_BR_mu : BR_tau_mu_units < BR_tau_e_units := by decide

/-- **🚨 s722 — `100 · BR_μ > 97 · BR_e`** (universality, ratio > 0.97).

    Computed: 100·1739 = 173_900 > 97·1782 = 172_854. ✓ -/
theorem T1_lepton_universality_ratio_above_97pct :
    97 * BR_tau_e_units < 100 * BR_tau_mu_units := by decide

/-- **🚨 s722 — `100 · BR_μ < 99 · BR_e`** (ratio strictly below 0.99).

    Computed: 100·1739 = 173_900 < 99·1782 = 176_418. ✓
    Captures non-trivial m_μ phase-space suppression. -/
theorem T1_lepton_universality_ratio_below_99pct :
    100 * BR_tau_mu_units < 99 * BR_tau_e_units := by decide

/-- **🚨 s722 — `BR_e - BR_μ ≤ 50`** (absolute diff ≤ 0.5% of total).

    Computed: 1782 - 1739 = 43 ≤ 50. ✓ -/
theorem T1_BR_diff_below_50_units : BR_tau_e_units - BR_tau_mu_units ≤ 50 := by
  decide

/-- **🚨 s722 — `BR_e - BR_μ ≥ 30`** (absolute diff at least 0.3%).

    Captures phase-space size: 43 ≥ 30. ✓ -/
theorem T1_BR_diff_above_30_units : 30 ≤ BR_tau_e_units - BR_tau_mu_units := by
  decide

/-! ## s723 — TauLeptonPrecision Prop scaffold + bundle -/

/-- **TauLeptonPrecision**: τ lifetime + leptonic BRs + universality.

    Real Prop body — 8 conjuncts: lifetime sanity + BR_e/BR_μ within
    PDG window + lepton-universality ratio in [0.97, 0.99]. -/
def TauLeptonPrecision : Prop :=
  -- Lifetime sanity
  0 < tau_tau_lifetime_units ∧
  100 * sigma_tau_lifetime_units < 2 * tau_tau_lifetime_units ∧
  -- BR_e window
  1500 < BR_tau_e_units ∧
  BR_tau_e_units < 2000 ∧
  -- BR_μ window
  1500 < BR_tau_mu_units ∧
  BR_tau_mu_units < 2000 ∧
  -- Lepton universality
  BR_tau_mu_units < BR_tau_e_units ∧
  97 * BR_tau_e_units < 100 * BR_tau_mu_units

/-- **🚨 s723 — `TauLeptonPrecision`**. -/
theorem T1_tau_lepton_precision : TauLeptonPrecision :=
  ⟨T1_tau_lifetime_pos,
   T1_lifetime_relative_precision_below_2pct,
   T1_BR_e_above_15pct, T1_BR_e_below_20pct,
   T1_BR_mu_above_15pct, T1_BR_mu_below_20pct,
   T1_BR_e_above_BR_mu,
   T1_lepton_universality_ratio_above_97pct⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 719-723 — τ lepton precision bundle**.

    🏆 Foreground bundle.

    5 sessions:
    - s719: τ_τ lifetime = 290.3 fs (PDG 2024, σ = 5 fs)
    - s720: BR(τ → eνν̄) = 17.82% (PDG 2024)
    - s721: BR(τ → μνν̄) = 17.39% (PDG 2024)
    - s722: lepton universality (BR_e > BR_μ via phase space, ratio ~0.976)
    - s723: bundle composition + TauLeptonPrecision Prop (8-conjunct)

    Plus headline 14-conjunct bundling all positivity / sanity / window /
    universality witnesses.

    Sum check via sister `T1_TauDecayPropertiesBundle` (s478-482):
    BR_e + BR_μ + BR_hadrons = 1.0000 within PDG precision; this file
    sharpens the leptonic e/μ pair with explicit precision windows.

    Substrate-prediction: τ → l ν ν̄ rates from Y_τ Yukawa (s313)
    + W boson coupling (s310). Lepton universality empirical here;
    SM-derivation via Y_e/Y_μ Yukawa ratio (s330+) — orthogonal to this
    file's precision-anchor scope.

    Sub-lemma 320-324/N in T-1.  Lean-core only.

    🏆 First Lean-core τ lepton precision bundle (lifetime + leptonic
    BRs + universality). -/
theorem session_719_to_723_tau_lepton_precision_bundle_headline :
    0 < tau_tau_lifetime_units
    ∧ 0 < sigma_tau_lifetime_units
    ∧ sigma_tau_lifetime_units < tau_tau_lifetime_units
    ∧ 100 * sigma_tau_lifetime_units < 2 * tau_tau_lifetime_units
    ∧ 0 < BR_tau_e_units
    ∧ 0 < BR_tau_mu_units
    ∧ 100 * sigma_tau_e_units < BR_tau_e_units
    ∧ 100 * sigma_tau_mu_units < BR_tau_mu_units
    ∧ BR_tau_mu_units < BR_tau_e_units
    ∧ 97 * BR_tau_e_units < 100 * BR_tau_mu_units
    ∧ 100 * BR_tau_mu_units < 99 * BR_tau_e_units
    ∧ BR_tau_e_units - BR_tau_mu_units ≤ 50
    ∧ 30 ≤ BR_tau_e_units - BR_tau_mu_units
    ∧ TauLeptonPrecision :=
  ⟨T1_tau_lifetime_pos, T1_sigma_tau_lifetime_pos,
   T1_sigma_below_lifetime,
   T1_lifetime_relative_precision_below_2pct,
   T1_BR_tau_e_pos, T1_BR_tau_mu_pos,
   T1_BR_e_relative_precision_below_1pct,
   T1_BR_mu_relative_precision_below_1pct,
   T1_BR_e_above_BR_mu,
   T1_lepton_universality_ratio_above_97pct,
   T1_lepton_universality_ratio_below_99pct,
   T1_BR_diff_below_50_units,
   T1_BR_diff_above_30_units,
   T1_tau_lepton_precision⟩

end OmegaTheory.Predictions.T1_TauLeptonPrecisionBundle
