/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop

  **Lion's-Pride Phase 9.42 (2026-05-06)**:
  *Four-loop extension of the substrate-derived running coupling —
  adds the `ε · δ_comp⁴` quartic correction with explicit factored
  beta-function via difference-of-fourth-powers identity
  `a⁴ - b⁴ = (a - b)(a³ + a²·b + a·b² + b³)`.*

  ## Why this file

  Phase 9.7 (`SubstrateRunningCoupling3Loop`) shipped the three-loop
  shape:

      g_3(N)  :=  g₀ · (1 + α · δ_comp + β · δ_comp² + γ · δ_comp³)

  In continuum perturbative QFT, four-loop running adds another
  power.  In the substrate, the analog is

      g_4(N)  :=  g₀ · (1 + α · δ_comp + β · δ_comp² +
                        γ · δ_comp³ + ε · δ_comp⁴)

  This file ships the four-loop substrate running coupling and proves:

  1. **Reductions**:
     * `ε = 0` ⟹ recovers Phase 9.7 three-loop.
     * `α = β = γ = ε = 0` ⟹ constant.
  2. **Beta function explicit factored form**:
       `β(g_4, N) = g₀ · (δ_{N+1} - δ_N) ·
                    (α + β·(δ_{N+1}+δ_N) +
                     γ·(δ²_{N+1} + δ_{N+1}·δ_N + δ²_N) +
                     ε·(δ³_{N+1} + δ²_{N+1}·δ_N + δ_{N+1}·δ²_N + δ³_N))`
     via difference-of-fourth-powers
     `a⁴ - b⁴ = (a - b)(a³ + a²·b + a·b² + b³)`.
  3. **Monotone IR flow at non-negative params**:
       `g₀, α, β, γ, ε ≥ 0` ⟹ `β(g_4, N) ≤ 0`.

  ## Honest scope

  This file ships the four-loop EXTENSION shape with explicit factored
  beta-function algebra. It does NOT yet:
  * Derive (g₀, α, β, γ, ε) from Connes spectral-action eigenvalues
    (Phase 6.5+ multi-month).
  * Compare against actual SM 4-loop beta-function coefficients (would
    need PDG calibration).

  What it DOES ship: the algebraic four-loop shape with proven
  factored beta-function form and IR-monotone-flow under non-negative
  coefficients.

  ## Author

  Lion's-Pride dynamic /loop iteration 115 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop

/-! ## 1. Four-loop substrate running coupling

    `g_4(N) = g₀ · (1 + α · δ + β · δ² + γ · δ³ + ε · δ⁴)`. -/

/-- **Four-loop substrate-running coupling**: extends Phase 9.7
    with a quartic correction in `δ_comp(N)`. -/
noncomputable def runningCoupling4Loop (g_0 α β γ ε : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N
            + β * (substrateRGScale N)^2
            + γ * (substrateRGScale N)^3
            + ε * (substrateRGScale N)^4)

/-- **Constant-coupling case**: `α = β = γ = ε = 0` ⟹ `g(N) = g₀`. -/
theorem runningCoupling4Loop_zero_params (g_0 : ℝ) (N : ℕ) :
    runningCoupling4Loop g_0 0 0 0 0 N = g_0 := by
  unfold runningCoupling4Loop
  ring

/-- **Reduces to Phase 9.7 at `ε = 0`**. -/
theorem runningCoupling4Loop_zero_epsilon (g_0 α β γ : ℝ) (N : ℕ) :
    runningCoupling4Loop g_0 α β γ 0 N = runningCoupling3Loop g_0 α β γ N := by
  unfold runningCoupling4Loop runningCoupling3Loop
  ring

/-- **Reduces to Phase 9.6 at `γ = ε = 0`**. -/
theorem runningCoupling4Loop_zero_gamma_epsilon (g_0 α β : ℝ) (N : ℕ) :
    runningCoupling4Loop g_0 α β 0 0 N = runningCoupling2Loop g_0 α β N := by
  unfold runningCoupling4Loop runningCoupling2Loop
  ring

/-- **Reduces to Phase 9.5 at `β = γ = ε = 0`**. -/
theorem runningCoupling4Loop_zero_beta_gamma_epsilon (g_0 α : ℝ) (N : ℕ) :
    runningCoupling4Loop g_0 α 0 0 0 N = runningCoupling g_0 α N := by
  unfold runningCoupling4Loop runningCoupling
  ring

/-! ## 2. Substrate beta function on the four-loop running coupling -/

/-- **Four-loop beta function in factored form**:

    `β_subst(g_4, N) = g₀ · (δ_{N+1} - δ_N) ·
                       (α + β · (δ_{N+1} + δ_N)
                          + γ · (δ²_{N+1} + δ_{N+1}·δ_N + δ²_N)
                          + ε · (δ³_{N+1} + δ²_{N+1}·δ_N
                                 + δ_{N+1}·δ²_N + δ³_N))`

    via difference-of-fourth-powers
    `a⁴ - b⁴ = (a - b)(a³ + a²·b + a·b² + b³)`. -/
theorem runningCoupling4Loop_beta_eq_factorised
    (g_0 α β γ ε : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling4Loop g_0 α β γ ε) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)
             + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)
             + ε * ((substrateRGScale (N + 1))^3
                    + (substrateRGScale (N + 1))^2 * substrateRGScale N
                    + substrateRGScale (N + 1) * (substrateRGScale N)^2
                    + (substrateRGScale N)^3)) := by
  unfold substrateBetaFunction runningCoupling4Loop
  ring

/-- **Four-loop beta function is non-positive at non-negative parameters**. -/
theorem runningCoupling4Loop_beta_nonpos_of_nonneg_params
    (g_0 α β γ ε : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ) (hε : 0 ≤ ε)
    (N : ℕ) :
    substrateBetaFunction (runningCoupling4Loop g_0 α β γ ε) N ≤ 0 := by
  rw [runningCoupling4Loop_beta_eq_factorised]
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
    have h2 : 0 ≤ substrateRGScale (N + 1) * substrateRGScale N :=
      mul_nonneg (le_of_lt h_pos_N1) (le_of_lt h_pos_N)
    have h3 : 0 ≤ (substrateRGScale N)^2 := sq_nonneg _
    linarith
  have h_sum_cube_nonneg :
      0 ≤ (substrateRGScale (N + 1))^3
            + (substrateRGScale (N + 1))^2 * substrateRGScale N
            + substrateRGScale (N + 1) * (substrateRGScale N)^2
            + (substrateRGScale N)^3 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^3 := by positivity
    have h2 : 0 ≤ (substrateRGScale (N + 1))^2 * substrateRGScale N :=
      mul_nonneg (sq_nonneg _) (le_of_lt h_pos_N)
    have h3 : 0 ≤ substrateRGScale (N + 1) * (substrateRGScale N)^2 :=
      mul_nonneg (le_of_lt h_pos_N1) (sq_nonneg _)
    have h4 : 0 ≤ (substrateRGScale N)^3 := by positivity
    linarith
  have h_bracket_nonneg :
      0 ≤ α + β * (substrateRGScale (N + 1) + substrateRGScale N)
            + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)
            + ε * ((substrateRGScale (N + 1))^3
                    + (substrateRGScale (N + 1))^2 * substrateRGScale N
                    + substrateRGScale (N + 1) * (substrateRGScale N)^2
                    + (substrateRGScale N)^3) := by
    have hβ_term : 0 ≤ β * (substrateRGScale (N + 1) + substrateRGScale N) :=
      mul_nonneg hβ h_sum_nonneg
    have hγ_term : 0 ≤ γ * ((substrateRGScale (N + 1))^2
                              + substrateRGScale (N + 1) * substrateRGScale N
                              + (substrateRGScale N)^2) :=
      mul_nonneg hγ h_sum_sq_nonneg
    have hε_term : 0 ≤ ε * ((substrateRGScale (N + 1))^3
                              + (substrateRGScale (N + 1))^2 * substrateRGScale N
                              + substrateRGScale (N + 1) * (substrateRGScale N)^2
                              + (substrateRGScale N)^3) :=
      mul_nonneg hε h_sum_cube_nonneg
    linarith
  nlinarith [hg, h_diff_nonpos, h_bracket_nonneg,
             mul_nonneg hg h_bracket_nonneg]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.42 headline — four-loop substrate-running-
    coupling structural report.**

    For non-negative `g₀, α, β, γ, ε ≥ 0` and depth `N : ℕ`:

    1. **Reduces to Phase 9.7 (3-loop) at `ε = 0`**:
       `runningCoupling4Loop g₀ α β γ 0 N = runningCoupling3Loop g₀ α β γ N`.

    2. **Beta function in factored form**:
       `β(g_4, N) = g₀ · (δ_{N+1} - δ_N) · bracket(α, β, γ, ε)`.

    3. **Monotone IR flow at non-negative params**:
       `β(g_4, N) ≤ 0`. -/
theorem substrate_running_coupling_4loop_report
    (g_0 α β γ ε : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ) (hε : 0 ≤ ε)
    (N : ℕ) :
    runningCoupling4Loop g_0 α β γ 0 N = runningCoupling3Loop g_0 α β γ N ∧
    substrateBetaFunction (runningCoupling4Loop g_0 α β γ ε) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)
             + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)
             + ε * ((substrateRGScale (N + 1))^3
                    + (substrateRGScale (N + 1))^2 * substrateRGScale N
                    + substrateRGScale (N + 1) * (substrateRGScale N)^2
                    + (substrateRGScale N)^3)) ∧
    substrateBetaFunction (runningCoupling4Loop g_0 α β γ ε) N ≤ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · exact runningCoupling4Loop_zero_epsilon g_0 α β γ N
  · exact runningCoupling4Loop_beta_eq_factorised g_0 α β γ ε N
  · exact runningCoupling4Loop_beta_nonpos_of_nonneg_params g_0 α β γ ε hg hα hβ hγ hε N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop
