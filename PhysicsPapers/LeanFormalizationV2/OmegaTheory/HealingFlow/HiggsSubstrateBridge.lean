/-
  OmegaTheory.HealingFlow.HiggsSubstrateBridge

  **Lion's-Pride Phase 3.2 (2026-05-05)**:
  *Substrate Higgs VEV is the Mexican-hat minimum.*

  The substrate identification `higgs_vev N := computationalUncertainty N`
  (HiggsFromError, cycle 4) and the abstract Mexican-hat machinery
  (Phase 3.1, HiggsScalarField) are connected here:

  for each iteration count `N`, there exist Mexican-hat parameters
  `μ_sq, lamH > 0` such that the SSB minimum `higgsVEV_min μ_sq lamH`
  EQUALS the substrate Higgs VEV `higgs_vev N`.

  Concrete choice:
      `μ_sq := 2 · (computationalUncertainty N)²`,  `lamH := 1`.
  Then `μ_sq / (2 · lamH) = (computationalUncertainty N)²`, and so
  `higgsVEV_min := √(μ_sq / (2 · lamH)) = computationalUncertainty N`
  (using `computationalUncertainty N > 0` to drop the absolute value).

  Hence the Mexican-hat SSB report (Phase 3.1) holds for the substrate's
  concrete VEV at every iteration `N`.

  ## Why this is non-trivial

  Phase 3.1 ships the abstract Mexican-hat algebra parametrically.
  Phase 3.2 IDENTIFIES the abstract VEV with the substrate's concrete
  one (`higgs_vev N = δ_comp(N)`), making the SSB story applicable to
  V2 substrate physics.

  This is the first concrete bridge linking the substrate's Leibniz
  truncation precision `δ_comp(N) = ℓ_P · 4/(2N+3)` to a CLASSICAL
  FIELD-THEORY Mexican-hat potential.  No PDG anchor, no calibration,
  no `def OmegaConjecture`.

  ## Honest scope

  This file does NOT yet:
  * Derive `μ_sq` and `lamH` from substrate axioms.  The choice
    `μ_sq = 2 · δ_comp(N)²`, `lamH = 1` is a CHOICE — different
    choices recover different `μ_sq/lamH` ratios.  Phase 6 (Connes
    NCG spectral action) will derive `lamH` from the heat-kernel `a₄`
    coefficient and `μ_sq` from the spectral-action stationarity.
  * Bridge the full SU(2)×U(1)→U(1)_EM electroweak SSB pattern (just
    the Z₂ toy model here).
  * Connect to the W-boson mass `m_W² = g² · v² / 4` formula (already
    present in `HiggsFromError` as `wBosonMass_sq_from_higgs`; Phase 4
    + 5 connects more sectors).

  ## Author

  Lion's-Pride dynamic /loop iteration 4 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.
  Companion to Phase 3.1 `HealingFlow/HiggsScalarField.lean`.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.HealingFlow.HiggsScalarField
import OmegaTheory.Emergence.HiggsFromError
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.HealingFlow.HiggsSubstrateBridge

open OmegaTheory.HealingFlow.HiggsScalarField
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Irrationality

/-! ## 1. Substrate Mexican-hat parameters at iteration `N`

We choose `lamH := 1` and `μ_sq := 2 · (computationalUncertainty N)²`
so that `μ_sq / (2 · lamH) = (computationalUncertainty N)²` and the
Mexican-hat minimum lies exactly at `±computationalUncertainty N`. -/

/-- Substrate `μ²` parameter at iteration `N`:
    `μ_sq_substrate N := 2 · (computationalUncertainty N)²`. -/
noncomputable def μ_sq_substrate (N : ℕ) : ℝ :=
  2 * (computationalUncertainty N)^2

/-- Substrate `λ_H` parameter: chosen `1` so that the minimum lies at
    exactly `±δ_comp(N)`. -/
def lamH_substrate : ℝ := 1

/-! ## 2. Positivity of substrate Mexican-hat parameters -/

/-- `μ_sq_substrate N > 0` for every `N`. -/
theorem μ_sq_substrate_pos (N : ℕ) : 0 < μ_sq_substrate N := by
  unfold μ_sq_substrate
  have hδ_pos := computationalUncertainty_pos N
  have hδ_sq_pos : 0 < (computationalUncertainty N)^2 := by positivity
  linarith

/-- `lamH_substrate > 0` (it equals 1). -/
theorem lamH_substrate_pos : 0 < lamH_substrate := by
  unfold lamH_substrate
  norm_num

/-! ## 3. Substrate Mexican-hat ratio identity

The key calculation: `μ_sq_substrate N / (2 · lamH_substrate)
= (computationalUncertainty N)²`. -/

/-- The Mexican-hat ratio at substrate parameters reduces to
    `(computationalUncertainty N)²`. -/
theorem μ_sq_over_2_lam_substrate (N : ℕ) :
    μ_sq_substrate N / (2 * lamH_substrate)
      = (computationalUncertainty N)^2 := by
  unfold μ_sq_substrate lamH_substrate
  field_simp

/-! ## 4. Substrate Higgs VEV equals the Mexican-hat minimum

The headline of this file: the substrate `higgs_vev N` IS the
Mexican-hat minimum at the substrate parameters.

Proof: `higgsVEV_min μ_sq_substrate lamH_substrate
      = √(μ_sq_substrate / (2 · lamH_substrate))    (by definition)
      = √((computationalUncertainty N)²)            (by §3 identity)
      = |computationalUncertainty N|                 (by Real.sqrt_sq_eq_abs)
      = computationalUncertainty N                  (since δ_comp > 0).
   And `higgs_vev N := computationalUncertainty N` by definition. -/

/-- The Mexican-hat minimum at substrate parameters equals
    `computationalUncertainty N`. -/
theorem higgsVEV_min_substrate_eq_computationalUncertainty (N : ℕ) :
    higgsVEV_min (μ_sq_substrate N) lamH_substrate
      = computationalUncertainty N := by
  unfold higgsVEV_min
  rw [μ_sq_over_2_lam_substrate N]
  -- Goal: √((computationalUncertainty N)²) = computationalUncertainty N
  rw [Real.sqrt_sq_eq_abs]
  -- Goal: |computationalUncertainty N| = computationalUncertainty N
  exact abs_of_pos (computationalUncertainty_pos N)

/-- **Headline 1 — substrate Higgs VEV is the Mexican-hat minimum**:
    `higgs_vev N = higgsVEV_min (μ_sq_substrate N) lamH_substrate`
    for every iteration count `N`.

    This is the first concrete identification of the V2 substrate's
    Higgs VEV with a CLASSICAL FIELD-THEORY Mexican-hat minimum. -/
theorem higgs_vev_eq_mexican_hat_minimum (N : ℕ) :
    higgs_vev N = higgsVEV_min (μ_sq_substrate N) lamH_substrate := by
  unfold higgs_vev
  rw [higgsVEV_min_substrate_eq_computationalUncertainty N]

/-! ## 5. Substrate-anchored SSB report

The Mexican-hat SSB report (Phase 3.1, headline 6) holds at the
substrate parameters.  Each conjunct is the substrate-anchored form
of the corresponding Phase 3.1 result. -/

/-- The Mexican-hat potential at substrate parameters, evaluated at
    the substrate VEV, is `-(computationalUncertainty N)⁴`. -/
theorem higgsPotential_substrate_at_vev (N : ℕ) :
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      = -(computationalUncertainty N)^4 := by
  rw [higgs_vev_eq_mexican_hat_minimum N]
  rw [higgsPotential_at_vev_min_eq (le_of_lt (μ_sq_substrate_pos N))
      lamH_substrate_pos]
  -- Goal: -(μ_sq_substrate N)² / (4 · lamH_substrate) = -(δ_comp N)⁴
  unfold μ_sq_substrate lamH_substrate
  ring

/-- **The substrate Higgs minimum is strictly negative** (the EW
    vacuum is below the symmetric `φ = 0` point by `δ_comp(N)⁴`). -/
theorem higgsPotential_substrate_at_vev_neg (N : ℕ) :
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N) < 0 := by
  rw [higgsPotential_substrate_at_vev N]
  have hδ_pos := computationalUncertainty_pos N
  have hδ_pow_pos : 0 < (computationalUncertainty N)^4 := by positivity
  linarith

/-- **Headline 2 — at substrate parameters, V is minimised at the
    substrate VEV**.  Direct corollary of Phase 3.1
    `higgsPotential_min_at_vev_min` instantiated at substrate parameters
    + the bridge `higgs_vev_eq_mexican_hat_minimum`. -/
theorem higgsPotential_substrate_min_at_higgs_vev (N : ℕ) (φ : ℝ) :
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      ≤ higgsPotential (μ_sq_substrate N) lamH_substrate φ := by
  rw [higgs_vev_eq_mexican_hat_minimum N]
  exact higgsPotential_min_at_vev_min (μ_sq_substrate_pos N)
                                       lamH_substrate_pos φ

/-- **Headline 3 — at substrate parameters, the symmetric point
    `φ = 0` is NOT the minimum**.  V(0) = 0 > V(higgs_vev N)
    = -δ_comp(N)⁴. -/
theorem higgsPotential_substrate_at_zero_gt_at_vev (N : ℕ) :
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      < higgsPotential (μ_sq_substrate N) lamH_substrate 0 := by
  rw [higgs_vev_eq_mexican_hat_minimum N]
  exact higgsPotential_at_zero_gt_min (μ_sq_substrate_pos N)
                                       lamH_substrate_pos

/-- **Headline 4 — Z₂ symmetry breaking at substrate parameters**:
    `+higgs_vev N` and `-higgs_vev N` are BOTH minima with equal V,
    they are DISTINCT, and `higgs_vev N ≠ 0`. -/
theorem higgsPotential_substrate_SSB (N : ℕ) :
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      = higgsPotential (μ_sq_substrate N) lamH_substrate (-(higgs_vev N))
    ∧ higgs_vev N ≠ -(higgs_vev N)
    ∧ higgs_vev N ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · -- V(v) = V(-v) by the Z₂ symmetry of V.
    exact (higgsPotential_neg (μ_sq_substrate N) lamH_substrate
            (higgs_vev N)).symm
  · -- v ≠ -v because v > 0.
    have hv_pos : 0 < higgs_vev N := higgs_vev_pos N
    intro h
    linarith
  · -- v ≠ 0 because v > 0.
    exact higgs_vev_ne_zero N

/-! ## 6. Composite headline: substrate Mexican-hat SSB report

A single 5-conjunct headline tying together Phase 3.1 + Phase 3.2:
the substrate Higgs VEV `higgs_vev N` IS the Mexican-hat SSB minimum
at concrete parameters `(μ_sq_substrate N, lamH_substrate)`, with all
the SSB structure (V_min closed form, V minimised at vev, V(0) higher,
Z₂ pair distinct minima) carrying through. -/

/-- **Lion's-Pride Phase 3.2 headline — substrate Mexican-hat SSB report.**

    For every iteration count `N`:

    1. `higgs_vev N = higgsVEV_min (μ_sq_substrate N) lamH_substrate`
       (substrate VEV IS the Mexican-hat SSB minimum at substrate
       parameters).

    2. `V_substrate(higgs_vev N) = -(computationalUncertainty N)⁴`
       (closed-form V_min).

    3. `∀ φ, V_substrate(higgs_vev N) ≤ V_substrate(φ)`
       (substrate VEV minimises V).

    4. `V_substrate(higgs_vev N) < V_substrate(0)`
       (symmetric point is NOT the minimum).

    5. `V_substrate(higgs_vev N) = V_substrate(-(higgs_vev N))`
       AND `higgs_vev N ≠ -(higgs_vev N)` (Z₂-symmetric pair). -/
theorem higgs_substrate_mexican_hat_SSB_report (N : ℕ) :
    higgs_vev N = higgsVEV_min (μ_sq_substrate N) lamH_substrate ∧
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      = -(computationalUncertainty N)^4 ∧
    (∀ φ : ℝ,
      higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
        ≤ higgsPotential (μ_sq_substrate N) lamH_substrate φ) ∧
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      < higgsPotential (μ_sq_substrate N) lamH_substrate 0 ∧
    higgsPotential (μ_sq_substrate N) lamH_substrate (higgs_vev N)
      = higgsPotential (μ_sq_substrate N) lamH_substrate (-(higgs_vev N))
    ∧ higgs_vev N ≠ -(higgs_vev N) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact higgs_vev_eq_mexican_hat_minimum N
  · exact higgsPotential_substrate_at_vev N
  · intro φ; exact higgsPotential_substrate_min_at_higgs_vev N φ
  · exact higgsPotential_substrate_at_zero_gt_at_vev N
  · exact (higgsPotential_neg (μ_sq_substrate N) lamH_substrate
            (higgs_vev N)).symm
  · -- v ≠ -v.
    have hv_pos : 0 < higgs_vev N := higgs_vev_pos N
    intro h
    linarith

/-! ## 7. Existence: ∃ Mexican-hat parameters realising substrate VEV

A weaker but more abstract corollary: for every `N`, the substrate
Higgs VEV is the Mexican-hat minimum for SOME positive Mexican-hat
parameters.  This is a useful entry point for downstream consumers
who don't need the specific `(2·δ_comp², 1)` choice. -/

/-- **Existence form** — substrate Higgs VEV is realised as the
    Mexican-hat minimum for some `(μ_sq, lamH) > 0`. -/
theorem exists_mexican_hat_params_at_substrate_higgs_vev (N : ℕ) :
    ∃ μ_sq lamH : ℝ,
      0 < μ_sq ∧ 0 < lamH ∧
      higgs_vev N = higgsVEV_min μ_sq lamH := by
  refine ⟨μ_sq_substrate N, lamH_substrate,
          μ_sq_substrate_pos N, lamH_substrate_pos,
          higgs_vev_eq_mexican_hat_minimum N⟩

end OmegaTheory.HealingFlow.HiggsSubstrateBridge
