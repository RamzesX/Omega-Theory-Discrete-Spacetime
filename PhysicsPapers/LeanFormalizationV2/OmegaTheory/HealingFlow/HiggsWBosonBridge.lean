/-
  OmegaTheory.HealingFlow.HiggsWBosonBridge

  **Lion's-Pride Phase 3.3 (2026-05-05)**:
  *W-boson mass formula via the substrate Mexican-hat minimum.*

  Connects three pieces of V2 machinery:
  * `Emergence/HiggsFromError.lean`: `m_W² = g_W² · v² / 4` with
    `v := higgs_vev N := computationalUncertainty N`.
  * `HealingFlow/HiggsScalarField.lean` (Phase 3.1):
    Mexican-hat algebra + SSB minimum at `higgsVEV_min μ_sq lamH`.
  * `HealingFlow/HiggsSubstrateBridge.lean` (Phase 3.2):
    `higgs_vev N = higgsVEV_min (μ_sq_substrate N) lamH_substrate`.

  This file ties them together: the W-boson mass formula `m_W² =
  g_W² · v² / 4` evaluated at the Mexican-hat minimum gives a
  closed-form `m_W²` in terms of substrate parameters.

  **The chain**: SSB Mexican-hat minimum produces the VEV `v`,
  the substrate identification fixes `v = δ_comp(N)`, and the
  Higgs mechanism turns this into `m_W² = g_W²·δ_comp(N)²/4`.
  No PDG anchor, no calibration tautology.

  ## What this file proves

  Headline: `wBosonMass_sq_at_mexican_hat_minimum` —
  `m_W² = g_W²(N, Λ) · (higgsVEV_min μ_sq_substrate lamH_substrate)² / 4`.

  Plus the closed-form decomposition in terms of substrate primitives:
  `m_W² = δ_comp(N)³ · (Λ/E_P)² / 4`
  (already present as `wBosonMass_sq_unfold` in HiggsFromError; we
  add the bridge to the Mexican-hat minimum via Phase 3.2).

  ## Honest scope

  This file does NOT:
  * Identify `g_W = e/sin θ_W` (that's the SU(2)×U(1) → U(1)_EM
    structure, scheduled for Phase 4-5).
  * Claim `m_W = 80.379 GeV` matching PDG (that's a calibration of
    the energy-scale parameter `Λ`; the substrate sets the dimensionless
    relation `m_W² · 4 / (g_W² · v²) = 1` exactly).
  * Derive `g_W²` from substrate axioms (it's parametrically defined
    in Regor's `weakCouplingConstant_from_substrate`).

  ## Author

  Lion's-Pride dynamic /loop iteration 5 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.
  Companion to Phase 3.1 + 3.2.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.HealingFlow.HiggsScalarField
import OmegaTheory.HealingFlow.HiggsSubstrateBridge
import OmegaTheory.Emergence.HiggsFromError
import OmegaTheory.Emergence.ErrorGaugeSU2
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.HealingFlow.HiggsWBosonBridge

open OmegaTheory.HealingFlow.HiggsScalarField
open OmegaTheory.HealingFlow.HiggsSubstrateBridge
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Emergence.ErrorGaugeSU2
open OmegaTheory.Irrationality

/-! ## 1. W-boson mass-squared at the Mexican-hat minimum

`wBosonMass_sq_from_higgs N Λ hΛ = g_W²(N, Λ) · higgs_vev² N / 4`.
By Phase 3.2 `higgs_vev_eq_mexican_hat_minimum`, `higgs_vev N`
equals `higgsVEV_min (μ_sq_substrate N) lamH_substrate`.  Hence:

    m_W² = g_W²(N, Λ) · (higgsVEV_min substrate-params)² / 4.

This is the direct substitution. -/

/-- **Headline 1 — W-boson mass-squared at the Mexican-hat minimum**:
    `m_W² = g_W²(N, Λ) · (higgsVEV_min substrate-params)² / 4`. -/
theorem wBosonMass_sq_at_mexican_hat_minimum (N : ℕ) (Λ : ℝ) (hΛ : 0 < Λ) :
    wBosonMass_sq_from_higgs N Λ hΛ
      = (weakCouplingConstant_from_substrate N Λ hΛ).gW_sq
        * (higgsVEV_min (μ_sq_substrate N) lamH_substrate)^2 / 4 := by
  unfold wBosonMass_sq_from_higgs
  rw [higgs_vev_eq_mexican_hat_minimum N]

/-! ## 2. The Mexican-hat-minimum-squared coincides with `δ_comp²` -/

/-- The squared Mexican-hat minimum at substrate parameters equals
    `(computationalUncertainty N)²`.  Direct from
    `higgsVEV_min_substrate_eq_computationalUncertainty` and squaring. -/
theorem higgsVEV_min_substrate_sq (N : ℕ) :
    (higgsVEV_min (μ_sq_substrate N) lamH_substrate)^2
      = (computationalUncertainty N)^2 := by
  rw [higgsVEV_min_substrate_eq_computationalUncertainty N]

/-! ## 3. Headline 2: closed-form `m_W² = g_W²·δ_comp²/4` via the bridge

Combining §1 and §2: the W-mass formula evaluated at the substrate
Mexican-hat minimum equals the existing `wBosonMass_sq_unfold`
expression. -/

/-- **Headline 2 — closed-form `m_W²` via Mexican-hat ⟶ δ_comp**:
    `m_W² = g_W²(N, Λ) · δ_comp(N)² / 4`. -/
theorem wBosonMass_sq_via_mexican_hat (N : ℕ) (Λ : ℝ) (hΛ : 0 < Λ) :
    wBosonMass_sq_from_higgs N Λ hΛ
      = (weakCouplingConstant_from_substrate N Λ hΛ).gW_sq
        * (computationalUncertainty N)^2 / 4 := by
  rw [wBosonMass_sq_at_mexican_hat_minimum N Λ hΛ,
      higgsVEV_min_substrate_sq N]

/-! ## 4. Headline 3: Mexican-hat → W mass positivity via the bridge

`m_W² > 0` at the Mexican-hat minimum, with the positivity of each
factor traced through. -/

/-- **Headline 3 — W-boson mass-squared is strictly positive at the
    Mexican-hat minimum**.  Routes through the substrate-bridge
    `higgs_vev_eq_mexican_hat_minimum` and the existing
    `wBosonMass_sq_pos`. -/
theorem wBosonMass_sq_at_mexican_hat_minimum_pos
    (N : ℕ) (Λ : ℝ) (hΛ : 0 < Λ) :
    0 < (weakCouplingConstant_from_substrate N Λ hΛ).gW_sq
      * (higgsVEV_min (μ_sq_substrate N) lamH_substrate)^2 / 4 := by
  rw [← wBosonMass_sq_at_mexican_hat_minimum N Λ hΛ]
  exact wBosonMass_sq_pos N Λ hΛ

/-! ## 5. Composite headline: substrate Mexican-hat → W-boson mass report

Three-conjunct combining all of the above. -/

/-- **Lion's-Pride Phase 3.3 headline — substrate Mexican-hat → W-boson
    mass report.**

    For every iteration count `N` and every positive energy scale `Λ`:

    1. `m_W² = g_W²(N, Λ) · (higgsVEV_min substrate-params)² / 4`
       (direct identification of W-mass via Mexican-hat minimum).

    2. `m_W² = g_W²(N, Λ) · (computationalUncertainty N)² / 4`
       (closed-form in substrate primitives).

    3. `0 < m_W²` (the substrate mass is non-trivial). -/
theorem higgs_substrate_mexican_hat_to_wBoson_report
    (N : ℕ) (Λ : ℝ) (hΛ : 0 < Λ) :
    wBosonMass_sq_from_higgs N Λ hΛ
      = (weakCouplingConstant_from_substrate N Λ hΛ).gW_sq
        * (higgsVEV_min (μ_sq_substrate N) lamH_substrate)^2 / 4 ∧
    wBosonMass_sq_from_higgs N Λ hΛ
      = (weakCouplingConstant_from_substrate N Λ hΛ).gW_sq
        * (computationalUncertainty N)^2 / 4 ∧
    0 < wBosonMass_sq_from_higgs N Λ hΛ := by
  refine ⟨?_, ?_, ?_⟩
  · exact wBosonMass_sq_at_mexican_hat_minimum N Λ hΛ
  · exact wBosonMass_sq_via_mexican_hat N Λ hΛ
  · exact wBosonMass_sq_pos N Λ hΛ

/-! ## 6. Decreasing-with-N corollary

The W-mass at the Mexican-hat minimum decreases as `N` increases
(equivalent to `wBosonMass_sq_decreasing` from HiggsFromError, but
expressed through the Mexican-hat bridge). -/

/-- **Mexican-hat W-mass shrinks as substrate iterates**:
    `m_W²(N+1) ≤ m_W²(N)` at fixed Λ.  Direct corollary of
    `wBosonMass_sq_decreasing` from `HiggsFromError`. -/
theorem wBosonMass_sq_at_mexican_hat_decreasing
    (N : ℕ) (Λ : ℝ) (hΛ : 0 < Λ) :
    wBosonMass_sq_from_higgs (N + 1) Λ hΛ
      ≤ wBosonMass_sq_from_higgs N Λ hΛ :=
  wBosonMass_sq_decreasing N Λ hΛ

end OmegaTheory.HealingFlow.HiggsWBosonBridge
