/-
  OmegaTheory.HealingFlow.HiggsMassFromCurvature

  **Lion's-Pride Phase 3.4 (2026-05-05)**:
  *Higgs mass from the curvature of the Mexican-hat at the minimum.*

  In standard SSB the physical Higgs particle's mass-squared equals the
  second derivative of the Mexican-hat potential evaluated at the
  vacuum:

      V(φ)    = -μ²·φ² + λ·φ⁴
      V'(φ)   = -2μ²·φ + 4λ·φ³
      V''(φ)  = -2μ²    + 12λ·φ²
      V''(v)  = -2μ²    + 12λ·v²
              = -2μ²    + 12λ·(μ²/(2λ))      since v² = μ²/(2λ)
              = -2μ²    + 6μ²
              =  4μ²
      m_H²    := V''(v) = 4μ².

  At substrate parameters `μ_sq_substrate := 2·δ_comp(N)²`:

      m_H²_substrate := 4 · μ_sq_substrate = 8 · δ_comp(N)²

  ## What this file ships

  We carry the second derivative as a CLOSED-FORM expression
  `higgsPotential_secondDerivative μ_sq lamH φ := -2·μ_sq + 12·lamH·φ²`
  — this is what `(d²/dφ²) V(φ)` would compute symbolically.  We
  do NOT formalise the full calculus apparatus (Mathlib's `deriv`)
  because we don't need it: the closed-form expression is the
  textbook result, and proving `at the Mexican-hat minimum it equals
  4μ²` is a `ring` identity once we substitute `v² = μ²/(2λ)`.

  ## Headlines

  1. `higgsPotential_secondDerivative_at_min`: V''(v_min) = 4·μ_sq.
  2. `higgs_mass_sq_from_curvature`: definition `m_H²` := V''(v_min).
  3. `higgs_mass_sq_from_curvature_eq`: m_H² = 4·μ_sq.
  4. `higgs_mass_sq_substrate_eq`: at substrate-params, m_H² = 8·δ_comp².
  5. `higgs_mass_sq_substrate_pos`: m_H² > 0 at every N.

  ## Honest scope

  This file does NOT:
  * Derive `μ²` and `λ` from substrate axioms (they remain free
    parameters; the substrate choice `μ_sq := 2·δ_comp²` is from
    Phase 3.2's bridge construction).
  * Formalise `(d²/dφ²)` via Mathlib's `deriv` (the closed-form
    result is enough for the Higgs mass content).
  * Match `m_H = 125 GeV` at any specific Λ (that's a calibration of
    `δ_comp(N)` to a specific N value, not a substrate axiom).

  ## Author

  Lion's-Pride dynamic /loop iteration 6 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.HealingFlow.HiggsScalarField
import OmegaTheory.HealingFlow.HiggsSubstrateBridge
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.HealingFlow.HiggsMassFromCurvature

open OmegaTheory.HealingFlow.HiggsScalarField
open OmegaTheory.HealingFlow.HiggsSubstrateBridge
open OmegaTheory.Irrationality

/-! ## 1. Closed-form second derivative of the Mexican-hat

V(φ) = -μ²·φ² + λ·φ⁴ ⟹ V''(φ) = -2μ² + 12λ·φ². -/

/-- Closed-form symbolic second derivative
    `(d²/dφ²) V(φ) = -2μ² + 12λ·φ²` of the Mexican-hat potential.

    Defined directly as the polynomial expression — equivalent to
    applying `Polynomial.derivative` twice to `V`, but without the
    `deriv` apparatus from Mathlib (which is unnecessary for the
    Higgs mass content, since we evaluate at a fixed point). -/
noncomputable def higgsPotential_secondDerivative
    (μ_sq lamH φ : ℝ) : ℝ :=
  -2 * μ_sq + 12 * lamH * φ^2

/-! ## 2. Headline 1: `V''(v_min) = 4·μ_sq`

The key algebraic identity: at the Mexican-hat minimum, the
second derivative collapses to `4·μ²` independent of `λ`. -/

/-- **Headline 1 — `V''(v_min) = 4·μ_sq`**.

    Proof: substitute `v_min² = μ_sq/(2·lamH)` into
    `-2·μ_sq + 12·lamH·v_min² = -2·μ_sq + 12·lamH·μ_sq/(2·lamH)
    = -2·μ_sq + 6·μ_sq = 4·μ_sq` via `ring`. -/
theorem higgsPotential_secondDerivative_at_min
    {μ_sq lamH : ℝ} (hμ : 0 ≤ μ_sq) (hL : 0 < lamH) :
    higgsPotential_secondDerivative μ_sq lamH (higgsVEV_min μ_sq lamH)
      = 4 * μ_sq := by
  unfold higgsPotential_secondDerivative
  rw [higgsVEV_min_sq hμ hL]
  -- Goal: -2·μ_sq + 12·lamH·(μ_sq/(2·lamH)) = 4·μ_sq
  have hL_ne : lamH ≠ 0 := ne_of_gt hL
  field_simp
  ring

/-! ## 3. Headline 2 + 3: Higgs mass squared from curvature -/

/-- The Higgs mass-squared from the curvature at the Mexican-hat minimum:
    `m_H² := V''(v_min)`. -/
noncomputable def higgs_mass_sq_from_curvature (μ_sq lamH : ℝ) : ℝ :=
  higgsPotential_secondDerivative μ_sq lamH (higgsVEV_min μ_sq lamH)

/-- **Headline 2 — `m_H² = 4·μ_sq` (curvature equals four times μ²)**. -/
theorem higgs_mass_sq_from_curvature_eq
    {μ_sq lamH : ℝ} (hμ : 0 ≤ μ_sq) (hL : 0 < lamH) :
    higgs_mass_sq_from_curvature μ_sq lamH = 4 * μ_sq := by
  unfold higgs_mass_sq_from_curvature
  exact higgsPotential_secondDerivative_at_min hμ hL

/-- **Higgs mass-squared positive when `μ_sq > 0`**. -/
theorem higgs_mass_sq_from_curvature_pos
    {μ_sq lamH : ℝ} (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    0 < higgs_mass_sq_from_curvature μ_sq lamH := by
  rw [higgs_mass_sq_from_curvature_eq (le_of_lt hμ) hL]
  linarith

/-! ## 4. Headline 4 + 5: Substrate-anchored Higgs mass

At substrate parameters `μ_sq_substrate := 2·δ_comp(N)²`:
  m_H² = 4·μ_sq_substrate = 4·(2·δ_comp²) = 8·δ_comp(N)². -/

/-- **Substrate-anchored Higgs mass-squared at iteration `N`**:
    `m_H²_substrate(N) := higgs_mass_sq_from_curvature
      (μ_sq_substrate N) lamH_substrate`. -/
noncomputable def higgs_mass_sq_substrate (N : ℕ) : ℝ :=
  higgs_mass_sq_from_curvature (μ_sq_substrate N) lamH_substrate

/-- **Headline 4 — closed-form substrate Higgs mass-squared**:
    `m_H²_substrate(N) = 8 · (computationalUncertainty N)²`. -/
theorem higgs_mass_sq_substrate_eq (N : ℕ) :
    higgs_mass_sq_substrate N = 8 * (computationalUncertainty N)^2 := by
  unfold higgs_mass_sq_substrate
  rw [higgs_mass_sq_from_curvature_eq
        (le_of_lt (μ_sq_substrate_pos N)) lamH_substrate_pos]
  -- Goal: 4 · μ_sq_substrate N = 8 · δ_comp(N)²
  unfold μ_sq_substrate
  ring

/-- **Headline 5 — substrate Higgs mass-squared is strictly positive**. -/
theorem higgs_mass_sq_substrate_pos (N : ℕ) :
    0 < higgs_mass_sq_substrate N := by
  rw [higgs_mass_sq_substrate_eq N]
  have hδ_pos := computationalUncertainty_pos N
  have hδ_sq_pos : 0 < (computationalUncertainty N)^2 := by positivity
  linarith

/-! ## 5. Composite headline: substrate Higgs mass-squared report -/

/-- **Lion's-Pride Phase 3.4 headline — substrate Higgs mass-squared
    report.**

    For every iteration count `N`:

    1. `m_H²_substrate(N) = 8 · (computationalUncertainty N)²`
       (closed-form via Mexican-hat curvature at substrate params).

    2. `0 < m_H²_substrate(N)` (substrate Higgs mass non-trivial).

    3. `m_H²_substrate(N) = 4 · μ_sq_substrate N` (the curvature-vs-μ²
       universal Mexican-hat identity at the minimum).

    The factor 8 connects directly to the substrate Leibniz-truncation
    precision via δ_comp(N) = ℓ_P · 4/(2N+3): more iterations ⟶
    smaller δ_comp ⟶ smaller substrate Higgs mass-squared (consistent
    with high-energy symmetry restoration). -/
theorem higgs_mass_sq_substrate_report (N : ℕ) :
    higgs_mass_sq_substrate N = 8 * (computationalUncertainty N)^2 ∧
    0 < higgs_mass_sq_substrate N ∧
    higgs_mass_sq_substrate N = 4 * μ_sq_substrate N := by
  refine ⟨higgs_mass_sq_substrate_eq N, higgs_mass_sq_substrate_pos N, ?_⟩
  -- 4·μ_sq_substrate N = m_H²_substrate N follows from §3 + §4:
  -- m_H²_substrate := higgs_mass_sq_from_curvature (μ_sq_substrate N) lamH_substrate
  -- which equals 4·μ_sq_substrate N by higgs_mass_sq_from_curvature_eq.
  unfold higgs_mass_sq_substrate
  rw [higgs_mass_sq_from_curvature_eq
        (le_of_lt (μ_sq_substrate_pos N)) lamH_substrate_pos]

/-! ## 6. Decreasing-with-N corollary

The substrate Higgs mass-squared decreases as `N` increases (more
substrate iterations ⟶ smaller δ_comp ⟶ smaller m_H²). -/

/-- **Substrate Higgs mass-squared decreases with `N`** at fixed Λ.
    Direct from `computationalUncertainty_decreasing`: more iterations
    ⟶ smaller δ_comp ⟶ smaller δ_comp² ⟶ smaller m_H². -/
theorem higgs_mass_sq_substrate_decreasing (N : ℕ) :
    higgs_mass_sq_substrate (N + 1) ≤ higgs_mass_sq_substrate N := by
  rw [higgs_mass_sq_substrate_eq, higgs_mass_sq_substrate_eq]
  -- Goal: 8 · δ_comp(N+1)² ≤ 8 · δ_comp(N)²
  have hdec := computationalUncertainty_decreasing N
  have hnn := computationalUncertainty_nonneg (N + 1)
  have hsq : (computationalUncertainty (N + 1))^2
              ≤ (computationalUncertainty N)^2 := by
    apply pow_le_pow_left₀ hnn hdec
  linarith

end OmegaTheory.HealingFlow.HiggsMassFromCurvature
