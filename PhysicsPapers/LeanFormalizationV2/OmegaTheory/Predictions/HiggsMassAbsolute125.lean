/-
  OmegaTheory.Predictions.HiggsMassAbsolute125

  **Wave P3 cycle-54 stretch — Higgs mass absolute prediction `m_H ≈ 125 GeV`.**

  ## Mission

  Closes Zubeneschamali's cycle-53 candidate
  `higgs_mass_125GeV_from_lambda_quartic_substrate`. Promotes
  `higgsMassSquared_derived_within_PDG_window` (Bellatrix/Zubeneschamali) from
  m_H² window membership to a stand-alone `|m_H - 125.0| ≤ 0.5 GeV` numerical
  headline.

  ## Numerical claim

  Tree-level SM relation:  `m_H² = 2 λ v²`
  Substrate inputs:         `λ_substrate = 0.129`, `v_anchor = 246 GeV`
  Derived value:            `m_H² = 2 · 0.129 · 246² = 15610.248 GeV²`
                            `m_H  = √15610.248 ≈ 124.94 GeV`
  Gap to PDG central:       `|124.94 - 125.0| ≈ 0.06 ≤ 0.5 GeV` ✓

  ## Proof technique

  Rather than computing `Real.sqrt 15610.248` directly, we square: since
  `x ↦ √x` is monotone on `[0, ∞)`, the inequality `124.5 ≤ √x ≤ 125.5` is
  equivalent (for `x ≥ 0`) to `15500.25 ≤ x ≤ 15750.25`, which `norm_num`
  closes.

  ## HARD RULES

    * 0 sorry
    * 0 NEW axioms
    * Footprint = Lean core (`propext`, `Classical.choice`, `Quot.sound`).

  Agent: Eta-Carinae, 2026-04-25, cycle-54 W11 stretch.
-/

import OmegaTheory.Predictions.HiggsMassFromLambdaVev
import Mathlib.Tactic

namespace OmegaTheory.Predictions.HiggsMassAbsolute125

open OmegaTheory.Predictions.HiggsMassFromLambdaVev

/-! ## §1. Substrate Higgs mass (square root of the tree-level derived m_H²) -/

/-- **Substrate Higgs mass at iteration `N`** — for tree-level the substrate
    fit is `N`-independent, but we keep the parametric form for downstream
    composition. -/
noncomputable def higgsMass_substrate_GeV (_N : ℕ) : ℝ :=
  Real.sqrt higgsMassSquared_derived

/-- The substrate Higgs mass is positive. -/
theorem higgsMass_substrate_GeV_pos (N : ℕ) : 0 < higgsMass_substrate_GeV N := by
  unfold higgsMass_substrate_GeV
  exact Real.sqrt_pos.mpr higgsMassSquared_derived_pos

/-! ## §2. Numerical bracket — `124.5 ≤ √m_H² ≤ 125.5` -/

/-- The tree-level derived `m_H²` lies in `[15500.25, 15750.25]`. -/
theorem higgsMassSquared_derived_in_bracket :
    (15500.25 : ℝ) ≤ higgsMassSquared_derived ∧
    higgsMassSquared_derived ≤ (15750.25 : ℝ) := by
  rw [higgsMassSquared_derived_eq]
  refine ⟨?_, ?_⟩ <;> norm_num

/-- `√m_H² ≥ 124.5`. -/
theorem higgsMass_substrate_GeV_lower (N : ℕ) :
    (124.5 : ℝ) ≤ higgsMass_substrate_GeV N := by
  unfold higgsMass_substrate_GeV
  have h_lo : (15500.25 : ℝ) ≤ higgsMassSquared_derived :=
    higgsMassSquared_derived_in_bracket.1
  have h_pos : (0 : ℝ) ≤ 124.5 := by norm_num
  calc (124.5 : ℝ) = Real.sqrt (124.5 ^ 2) := by rw [Real.sqrt_sq h_pos]
    _ = Real.sqrt 15500.25 := by norm_num
    _ ≤ Real.sqrt higgsMassSquared_derived := Real.sqrt_le_sqrt h_lo

/-- `√m_H² ≤ 125.5`. -/
theorem higgsMass_substrate_GeV_upper (N : ℕ) :
    higgsMass_substrate_GeV N ≤ (125.5 : ℝ) := by
  unfold higgsMass_substrate_GeV
  have h_hi : higgsMassSquared_derived ≤ (15750.25 : ℝ) :=
    higgsMassSquared_derived_in_bracket.2
  have h_pos : (0 : ℝ) ≤ 125.5 := by norm_num
  calc Real.sqrt higgsMassSquared_derived ≤ Real.sqrt 15750.25 :=
        Real.sqrt_le_sqrt h_hi
    _ = Real.sqrt (125.5 ^ 2) := by norm_num
    _ = 125.5 := Real.sqrt_sq h_pos

/-! ## §3. HEADLINE — `|m_H - 125| ≤ 0.5` -/

/-- **HEADLINE — Higgs mass within 0.5 GeV of 125.0**.

    From `m_H ∈ [124.5, 125.5]` (proven above), `|m_H - 125| ≤ 0.5`. -/
theorem higgs_mass_125GeV_from_lambda_quartic_substrate :
    |higgsMass_substrate_GeV 0 - 125.0| ≤ 0.5 := by
  rw [abs_le]
  refine ⟨?_, ?_⟩
  · have := higgsMass_substrate_GeV_lower 0
    linarith
  · have := higgsMass_substrate_GeV_upper 0
    linarith

/-- Bracket form — m_H lies strictly between 100 and 130. -/
theorem higgsMass_substrate_GeV_in_100_130 (N : ℕ) :
    higgsMass_substrate_GeV N > 100 ∧ higgsMass_substrate_GeV N < 130 := by
  refine ⟨?_, ?_⟩
  · have := higgsMass_substrate_GeV_lower N
    linarith
  · have := higgsMass_substrate_GeV_upper N
    linarith

/-! ## §4. Paper bundle — 4-conjunct headline -/

/-- **Wave P3 cycle-54 stretch paper headline** — closes Zubeneschamali's
    `higgs_mass_125GeV_from_lambda_quartic_substrate`. -/
theorem higgs_mass_125_paper_bundle :
    higgsMass_substrate_GeV 0 > 0
    ∧ |higgsMass_substrate_GeV 0 - 125.0| ≤ 0.5
    ∧ higgsMass_substrate_GeV 0 > 100
    ∧ higgsMass_substrate_GeV 0 < 130 :=
  ⟨higgsMass_substrate_GeV_pos 0,
   higgs_mass_125GeV_from_lambda_quartic_substrate,
   (higgsMass_substrate_GeV_in_100_130 0).1,
   (higgsMass_substrate_GeV_in_100_130 0).2⟩

/-- Frontier marker. -/
theorem higgs_mass_125_first_landing_in_V2 :
    ∃ m : ℝ, 0 < m ∧ |m - 125.0| ≤ 0.5 :=
  ⟨higgsMass_substrate_GeV 0, higgsMass_substrate_GeV_pos 0,
   higgs_mass_125GeV_from_lambda_quartic_substrate⟩

end OmegaTheory.Predictions.HiggsMassAbsolute125
