/-
  OmegaTheory.Foundations.SubstrateUVSpectralAction

  **Lion's-Pride Phase 6.5i (2026-05-06)**:
  *Specialise the Yukawa heat-kernel expansion to the substrate UV
  cutoff `Λ_substrate² := 4/ℓ_P²` from `IRUVDecomposition` — yielding
  a CONCRETE finite-dim Connes spectral-action expansion at the
  substrate's natural scale.*

  ## Why this file

  The substrate has an INTRINSIC UV cutoff:

      Λ_substrate²  :=  4 / ℓ_P²

  proved in `Predictions/IRUVDecomposition.lean::latticeDispersion_UV_ceiling`:
  the lattice-dispersion frequency ceiling is `4·ℓ_P^{-2}` for any
  spatial mode `k ∈ ℝ`.  No mode can carry more squared-frequency
  than `4/ℓ_P²` — this IS the substrate's natural UV scale.

  Setting the heat-kernel parameter `t := 1/Λ² = ℓ_P²/4` in the
  truncated heat trace gives the Connes spectral-action evaluation
  at the substrate's UV scale.  Combined with Phase 6.5h's Yukawa-
  power-moment formula, the result is:

      truncatedHeatTrace(yukawaSpectralTriple, 1, ℓ_P²/4)
        =  n  −  (ℓ_P²/4) · (Σᵢ y_i²)

      truncatedHeatTrace(yukawaSpectralTriple, 2, ℓ_P²/4)
        =  n  −  (ℓ_P²/4) · (Σᵢ y_i²)
              +  (ℓ_P²/4)² / 2 · (Σᵢ y_i⁴)

  These are the LEADING and SUB-LEADING Connes spectral-action
  contributions at substrate-natural cutoff.  The leading correction
  scales as `ℓ_P² · Σ y_i²`, encoding the connection between Yukawa
  couplings and the Planck length — which is exactly the structure
  of the Connes-Chamseddine Higgs mass-squared formula in dimension d.

  ## What this file ships

  | Property                                          | Theorem                                    |
  |---------------------------------------------------|--------------------------------------------|
  | `t_substrate := ℓ_P²/4` (heat-kernel parameter)   | (definition)                              |
  | `t_substrate > 0`                                 | `t_substrate_pos`                         |
  | `t_substrate · 4 / ℓ_P² = 1` (cutoff identity)    | `t_substrate_inv_eq_uv_cutoff`            |
  | Order-1 expansion at substrate cutoff              | `truncHeatTrace_yukawa_at_substrate_one`   |
  | Order-2 expansion at substrate cutoff              | `truncHeatTrace_yukawa_at_substrate_two`   |
  | Headline 4-conjunct                                | `substrate_uv_spectral_action_report`      |

  ## Honest scope

  This file ships ONLY the SUBSTRATE-CUTOFF EVALUATION of the
  truncated heat trace.  It does NOT close:

  * The CONTINUUM connection (multi-month Vassilevich port).
  * The CONCRETE Higgs μ² value (requires cutoff function f and its
    asymptotic moments f_k).
  * The full Connes-Chamseddine Higgs-mass formula
    `μ² = c · Λ² · (Σ y_i²)` for explicit c.

  What it DOES ship: the rigorous algebraic specialisation of the
  truncated heat trace to the substrate's natural UV cutoff —
  connecting Yukawa eigenvalues directly to Planck-length-scaled
  contributions in the spectral action.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure composition via Phase 6.5h `truncHeatTrace_yukawa_*` +
  Spacetime.Constants `l_P_pos`.  No abstraction towers.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.YukawaHeatKernelExpansion
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.SubstrateUVSpectralAction

open OmegaTheory.Foundations.YukawaDirac
open OmegaTheory.Foundations.YukawaHeatKernelExpansion
open OmegaTheory.Foundations.SpectralActionTruncated
open OmegaTheory.Spacetime

/-! ## 1. Substrate heat-kernel parameter `t_substrate := ℓ_P²/4`

    Inverse of the substrate UV cutoff `Λ_substrate² = 4/ℓ_P²`. -/

/-- **Substrate heat-kernel parameter** at substrate UV cutoff
    `Λ_substrate² := 4/ℓ_P²`:

      `t_substrate := ℓ_P² / 4`

    so `t_substrate · Λ_substrate² = 1` (heat-kernel parameter at
    substrate UV scale). -/
noncomputable def t_substrate : ℝ := l_P ^ 2 / 4

/-- **`t_substrate > 0`**.  Direct from `l_P > 0`. -/
theorem t_substrate_pos : 0 < t_substrate := by
  unfold t_substrate
  have hL_sq : 0 < l_P ^ 2 := by
    have hL := l_P_pos
    positivity
  linarith

/-- **`t_substrate · (4/ℓ_P²) = 1`**: inverse-of-UV-cutoff identity. -/
theorem t_substrate_inv_eq_uv_cutoff :
    t_substrate * (4 / l_P ^ 2) = 1 := by
  unfold t_substrate
  have hL := l_P_pos
  have hL_sq : (0 : ℝ) < l_P ^ 2 := by positivity
  have hL_sq_ne : (l_P ^ 2 : ℝ) ≠ 0 := ne_of_gt hL_sq
  field_simp

/-! ## 2. Truncated heat trace at substrate cutoff (order 1) -/

/-- **Order-1 expansion at substrate cutoff**:

    `truncatedHeatTrace(yukawaSpectralTriple, 1, t_substrate)
      = n − (ℓ_P²/4) · (Σᵢ y_i²)` -/
theorem truncHeatTrace_yukawa_at_substrate_one
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) 1 (t_substrate : ℂ)
      = (n : ℂ) - (t_substrate : ℂ) * ∑ i : Fin n, ((y i : ℂ)) ^ 2 := by
  rw [truncHeatTrace_yukawa_one h y (t_substrate : ℂ)]

/-! ## 3. Truncated heat trace at substrate cutoff (order 2) -/

/-- **Order-2 expansion at substrate cutoff**:

    `truncatedHeatTrace(yukawaSpectralTriple, 2, t_substrate)
      = n − (ℓ_P²/4) · (Σᵢ y_i²)
            + (ℓ_P²/4)² / 2 · (Σᵢ y_i⁴)` -/
theorem truncHeatTrace_yukawa_at_substrate_two
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) 2 (t_substrate : ℂ)
      = (n : ℂ) - (t_substrate : ℂ) * (∑ i : Fin n, ((y i : ℂ)) ^ 2)
                + (t_substrate : ℂ) ^ 2 / 2
                    * (∑ i : Fin n, ((y i : ℂ)) ^ 4) := by
  rw [truncHeatTrace_yukawa_two h y (t_substrate : ℂ)]

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6.5i headline — substrate UV cutoff
    spectral-action expansion report.**

    For Yukawa eigenvalues `y : Fin n → ℝ` (with `0 < n`), the heat-
    kernel expansion at substrate UV cutoff `Λ_substrate² := 4/ℓ_P²`
    (heat-kernel parameter `t_substrate = ℓ_P²/4`):

    1. **Substrate parameter positivity**: `0 < t_substrate`.

    2. **Inverse-cutoff identity**: `t_substrate · (4/ℓ_P²) = 1`.

    3. **Order-1 expansion** (leading mass-scale at substrate UV):
       `truncHeatTrace_yukawa(N=1, t_substrate)
          = n − (ℓ_P²/4)·(Σ y_i²)`
       The leading correction is `(ℓ_P²/4)·(Σ y_i²)` — connecting
       Yukawa-square sum directly to Planck-length scale.

    4. **Order-2 expansion** (leading + Higgs-quartic correction):
       `truncHeatTrace_yukawa(N=2, t_substrate)
          = n − (ℓ_P²/4)·(Σ y_i²) + (ℓ_P²/4)²/2·(Σ y_i⁴)`
       The Higgs quartic correction scales as `ℓ_P⁴ · (Σ y_i⁴)`. -/
theorem substrate_uv_spectral_action_report
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    0 < t_substrate ∧
    t_substrate * (4 / l_P ^ 2) = 1 ∧
    truncatedHeatTrace (yukawaSpectralTriple h y) 1 (t_substrate : ℂ)
      = (n : ℂ) - (t_substrate : ℂ) * ∑ i : Fin n, ((y i : ℂ)) ^ 2 ∧
    truncatedHeatTrace (yukawaSpectralTriple h y) 2 (t_substrate : ℂ)
      = (n : ℂ) - (t_substrate : ℂ) * (∑ i : Fin n, ((y i : ℂ)) ^ 2)
                + (t_substrate : ℂ) ^ 2 / 2
                    * (∑ i : Fin n, ((y i : ℂ)) ^ 4) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact t_substrate_pos
  · exact t_substrate_inv_eq_uv_cutoff
  · exact truncHeatTrace_yukawa_at_substrate_one h y
  · exact truncHeatTrace_yukawa_at_substrate_two h y

end OmegaTheory.Foundations.SubstrateUVSpectralAction
