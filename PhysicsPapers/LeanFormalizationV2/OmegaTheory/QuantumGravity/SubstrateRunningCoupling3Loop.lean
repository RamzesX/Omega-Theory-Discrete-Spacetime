/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop

  **Lion's-Pride Phase 9.7 (2026-05-06)**:
  *Three-loop extension of the Phase 9.6 substrate-derived running
  coupling — adds the `γ · δ_comp³` cubic correction.*

  ## Why this file

  Phase 9.6 (`SubstrateRunningCoupling2Loop`) shipped the two-loop shape

      g_2(N)  :=  g₀ · (1 + α · δ_comp + β · δ_comp²)

  In continuum perturbative QFT, three-loop running adds another
  power.  In the substrate, the analog is

      g_3(N)  :=  g₀ · (1 + α · δ_comp + β · δ_comp² + γ · δ_comp³)

  This file ships the three-loop substrate running coupling and proves:

  1. **Reductions**:
     * `γ = 0` ⟹ recovers Phase 9.6 two-loop.
     * `β = γ = 0` ⟹ recovers Phase 9.5 one-loop.
     * `α = β = γ = 0` ⟹ constant.
  2. **Beta function explicit factored form**:
       `β(g_3, N) = g₀ · (δ_{N+1} - δ_N) ·
                    (α + β·(δ_{N+1} + δ_N) +
                     γ·(δ²_{N+1} + δ_{N+1}·δ_N + δ²_N))`
     via difference-of-cubes factoring
     `a³ - b³ = (a - b)(a² + ab + b²)`.
  3. **Monotone IR flow at non-negative params**:
       `g₀, α, β, γ ≥ 0` ⟹ `β(g_3, N) ≤ 0`.

  ## What this file ships

  | Property                                              | Theorem                                         |
  |-------------------------------------------------------|-------------------------------------------------|
  | `runningCoupling3Loop g₀ α β γ N`                     | (def: `g₀·(1 + α·δ + β·δ² + γ·δ³)`)             |
  | Reduces to Phase 9.6 at `γ = 0`                       | `runningCoupling3Loop_zero_gamma`                |
  | Constant case at `α = β = γ = 0`                      | `runningCoupling3Loop_zero_params`               |
  | Explicit factored beta-function shape                 | `runningCoupling3Loop_beta_eq_factorised`        |
  | Monotone IR flow at non-negative params               | `runningCoupling3Loop_beta_nonpos_of_nonneg_params`|
  | Headline (3-conjunct)                                 | `substrate_running_coupling_3loop_report`         |

  ## Honest scope

  This file ships the three-loop EXTENSION shape with explicit
  factored beta-function algebra.  It does NOT yet:
  * Derive (g₀, α, β, γ) from Connes spectral-action eigenvalues
    (Phase 6.5+ multi-month).
  * Compare against the actual SM three-loop beta-function
    coefficients (would need PDG calibration).
  * Address higher-loop corrections (4-loop, 5-loop).

  What it DOES ship: the algebraic three-loop shape with proven
  factored beta-function form and IR-monotone-flow under
  non-negative coefficients.

  ## Author

  Lion's-Pride dynamic /loop iteration 48 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop

open OmegaTheory.Irrationality
open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop

/-! ## 1. Three-loop substrate running coupling

    `g_3(N) = g₀ · (1 + α · δ + β · δ² + γ · δ³)`. -/

/-- **Three-loop substrate-running coupling**: extends Phase 9.6 with
    a cubic correction in `δ_comp(N)`. -/
noncomputable def runningCoupling3Loop (g_0 α β γ : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N
            + β * (substrateRGScale N)^2
            + γ * (substrateRGScale N)^3)

/-- **Constant-coupling case**: `α = β = γ = 0` ⟹ `g(N) = g₀`. -/
theorem runningCoupling3Loop_zero_params (g_0 : ℝ) (N : ℕ) :
    runningCoupling3Loop g_0 0 0 0 N = g_0 := by
  unfold runningCoupling3Loop
  ring

/-- **Reduces to Phase 9.6 at `γ = 0`**. -/
theorem runningCoupling3Loop_zero_gamma (g_0 α β : ℝ) (N : ℕ) :
    runningCoupling3Loop g_0 α β 0 N = runningCoupling2Loop g_0 α β N := by
  unfold runningCoupling3Loop runningCoupling2Loop
  ring

/-- **Reduces to Phase 9.5 at `β = γ = 0`**. -/
theorem runningCoupling3Loop_zero_beta_gamma (g_0 α : ℝ) (N : ℕ) :
    runningCoupling3Loop g_0 α 0 0 N = runningCoupling g_0 α N := by
  unfold runningCoupling3Loop runningCoupling
  ring

/-! ## 2. Substrate beta function on the three-loop running coupling

    `β(g_3, N) = g_3(N+1) - g_3(N)`
    factored as `g₀ · (δ_{N+1} - δ_N) · (α + β·(δ_{N+1}+δ_N) +
                  γ·(δ²_{N+1} + δ_{N+1}·δ_N + δ²_N))`
    via the difference-of-cubes identity
    `a³ - b³ = (a - b)(a² + ab + b²)`. -/

/-- **Three-loop beta function in factored form**:

    `β_subst(g_3, N) = g₀ · (δ_{N+1} - δ_N) ·
                       (α + β · (δ_{N+1} + δ_N) +
                        γ · (δ²_{N+1} + δ_{N+1}·δ_N + δ²_N))`. -/
theorem runningCoupling3Loop_beta_eq_factorised
    (g_0 α β γ : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling3Loop g_0 α β γ) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)
             + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)) := by
  unfold substrateBetaFunction runningCoupling3Loop
  ring

/-- **Three-loop beta function is non-positive at non-negative parameters**. -/
theorem runningCoupling3Loop_beta_nonpos_of_nonneg_params
    (g_0 α β γ : ℝ) (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (N : ℕ) :
    substrateBetaFunction (runningCoupling3Loop g_0 α β γ) N ≤ 0 := by
  rw [runningCoupling3Loop_beta_eq_factorised]
  have h_diff_nonpos :
      substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_pos_N1 : 0 < substrateRGScale (N + 1) := substrateRGScale_pos (N + 1)
  have h_sum_nonneg :
      0 ≤ substrateRGScale (N + 1) + substrateRGScale N := by linarith
  have h_sum_sq_nonneg :
      0 ≤ (substrateRGScale (N + 1))^2
            + substrateRGScale (N + 1) * substrateRGScale N
            + (substrateRGScale N)^2 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^2 := sq_nonneg _
    have h2 : 0 ≤ substrateRGScale (N + 1) * substrateRGScale N := by
      exact mul_nonneg (le_of_lt h_pos_N1) (le_of_lt h_pos_N)
    have h3 : 0 ≤ (substrateRGScale N)^2 := sq_nonneg _
    linarith
  have h_bracket_nonneg :
      0 ≤ α + β * (substrateRGScale (N + 1) + substrateRGScale N)
            + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2) := by
    have hβ_term : 0 ≤ β * (substrateRGScale (N + 1) + substrateRGScale N) :=
      mul_nonneg hβ h_sum_nonneg
    have hγ_term : 0 ≤ γ * ((substrateRGScale (N + 1))^2
                              + substrateRGScale (N + 1) * substrateRGScale N
                              + (substrateRGScale N)^2) :=
      mul_nonneg hγ h_sum_sq_nonneg
    linarith
  -- product: g_0 * diff * bracket  with diff ≤ 0, bracket ≥ 0, g_0 ≥ 0
  nlinarith [hg, h_diff_nonpos, h_bracket_nonneg,
             mul_nonneg hg h_bracket_nonneg]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.7 headline — three-loop substrate-running-
    coupling structural report.**

    For any IR-asymptote coupling `g₀ : ℝ`, one-loop `α`, two-loop `β`,
    three-loop `γ`, and truncation depth `N : ℕ`:

    1. **Reduces to Phase 9.6 at γ = 0**:
       `runningCoupling3Loop g₀ α β 0 N = runningCoupling2Loop g₀ α β N`.

    2. **Factored beta-function**:
       `β(g, N) = g₀·(δ_{N+1}-δ_N)·(α + β·(δ₁+δ₀) + γ·(δ₁²+δ₁δ₀+δ₀²))`.

    3. **Monotone IR flow at non-negative parameters**:
       `g₀, α, β, γ ≥ 0` ⟹ `β(g, N) ≤ 0` (substrate three-loop
       preserves the IR-monotone-flow established at one+two loop). -/
theorem substrate_running_coupling_3loop_report
    (g_0 α β γ : ℝ) (N : ℕ) :
    runningCoupling3Loop g_0 α β 0 N = runningCoupling2Loop g_0 α β N ∧
    substrateBetaFunction (runningCoupling3Loop g_0 α β γ) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)
             + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)) ∧
    (0 ≤ g_0 → 0 ≤ α → 0 ≤ β → 0 ≤ γ →
      substrateBetaFunction (runningCoupling3Loop g_0 α β γ) N ≤ 0) := by
  refine ⟨?_, ?_, ?_⟩
  · exact runningCoupling3Loop_zero_gamma g_0 α β N
  · exact runningCoupling3Loop_beta_eq_factorised g_0 α β γ N
  · intro hg hα hβ hγ
    exact runningCoupling3Loop_beta_nonpos_of_nonneg_params g_0 α β γ
            hg hα hβ hγ N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop
