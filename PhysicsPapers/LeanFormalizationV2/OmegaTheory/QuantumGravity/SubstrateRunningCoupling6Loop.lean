/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling6Loop

  **Lion's-Pride Phase 9.47 (2026-05-06)**:
  *Six-loop extension of the substrate-derived running coupling —
  adds the `η · δ_comp⁶` sextic correction with explicit factored
  beta-function via difference-of-sixth-powers identity
  `a⁶ - b⁶ = (a - b)(a⁵ + a⁴·b + a³·b² + a²·b³ + a·b⁴ + b⁵)`.*

  ## Why this file

  Phase 9.43 (`SubstrateRunningCoupling5Loop`) shipped the five-loop
  shape:

      g_5(N) := g₀ · (1 + α·δ + β·δ² + γ·δ³ + ε·δ⁴ + ζ·δ⁵)

  In continuum perturbative QFT, six-loop running adds another power.
  In the substrate, the analog is

      g_6(N) := g₀ · (1 + α·δ + β·δ² + γ·δ³ + ε·δ⁴ + ζ·δ⁵ + η·δ⁶)

  This file ships the six-loop substrate running coupling and proves:

  1. **Reductions**:
     * `η = 0` ⟹ recovers Phase 9.43 five-loop.
     * `α = β = γ = ε = ζ = η = 0` ⟹ constant.
  2. **Beta function explicit factored form** via difference-of-
     sixth-powers `a⁶-b⁶ = (a-b)(a⁵ + a⁴b + a³b² + a²b³ + ab⁴ + b⁵)`.
  3. **Monotone IR flow at non-negative params**:
       `g₀, α, β, γ, ε, ζ, η ≥ 0` ⟹ `β(g_6, N) ≤ 0`.

  ## Honest scope

  This file ships the six-loop EXTENSION shape with explicit factored
  beta-function algebra. It does NOT yet:
  * Derive (g₀, α, β, γ, ε, ζ, η) from Connes spectral-action eigenvalues
    (Phase 6.5+ multi-month).
  * Compare against actual SM 6-loop beta-function coefficients
    (would need PDG calibration).

  What it DOES ship: the algebraic six-loop shape with proven
  factored beta-function form and IR-monotone-flow under non-negative
  coefficients.

  ## Author

  Lion's-Pride dynamic /loop iteration 121 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling5Loop
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling6Loop

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling5Loop

/-! ## 1. Six-loop substrate running coupling -/

/-- **Six-loop substrate-running coupling**: extends Phase 9.43 with
    a sextic correction in `δ_comp(N)`. -/
noncomputable def runningCoupling6Loop (g_0 α β γ ε ζ η : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N
            + β * (substrateRGScale N)^2
            + γ * (substrateRGScale N)^3
            + ε * (substrateRGScale N)^4
            + ζ * (substrateRGScale N)^5
            + η * (substrateRGScale N)^6)

/-- **Constant-coupling case**. -/
theorem runningCoupling6Loop_zero_params (g_0 : ℝ) (N : ℕ) :
    runningCoupling6Loop g_0 0 0 0 0 0 0 N = g_0 := by
  unfold runningCoupling6Loop
  ring

/-- **Reduces to Phase 9.43 at `η = 0`**. -/
theorem runningCoupling6Loop_zero_eta (g_0 α β γ ε ζ : ℝ) (N : ℕ) :
    runningCoupling6Loop g_0 α β γ ε ζ 0 N = runningCoupling5Loop g_0 α β γ ε ζ N := by
  unfold runningCoupling6Loop runningCoupling5Loop
  ring

/-- **Reduces to Phase 9.42 at `ζ = η = 0`**. -/
theorem runningCoupling6Loop_zero_zeta_eta (g_0 α β γ ε : ℝ) (N : ℕ) :
    runningCoupling6Loop g_0 α β γ ε 0 0 N = runningCoupling4Loop g_0 α β γ ε N := by
  unfold runningCoupling6Loop runningCoupling4Loop
  ring

/-- **Reduces to Phase 9.7 at `ε = ζ = η = 0`**. -/
theorem runningCoupling6Loop_zero_epsilon_zeta_eta (g_0 α β γ : ℝ) (N : ℕ) :
    runningCoupling6Loop g_0 α β γ 0 0 0 N = runningCoupling3Loop g_0 α β γ N := by
  unfold runningCoupling6Loop runningCoupling3Loop
  ring

/-! ## 2. Substrate beta function on the six-loop running coupling -/

/-- **Six-loop beta function in factored form** via
    difference-of-sixth-powers
    `a⁶ - b⁶ = (a-b)(a⁵ + a⁴b + a³b² + a²b³ + ab⁴ + b⁵)`. -/
theorem runningCoupling6Loop_beta_eq_factorised
    (g_0 α β γ ε ζ η : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling6Loop g_0 α β γ ε ζ η) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)
             + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)
             + ε * ((substrateRGScale (N + 1))^3
                    + (substrateRGScale (N + 1))^2 * substrateRGScale N
                    + substrateRGScale (N + 1) * (substrateRGScale N)^2
                    + (substrateRGScale N)^3)
             + ζ * ((substrateRGScale (N + 1))^4
                    + (substrateRGScale (N + 1))^3 * substrateRGScale N
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^2
                    + substrateRGScale (N + 1) * (substrateRGScale N)^3
                    + (substrateRGScale N)^4)
             + η * ((substrateRGScale (N + 1))^5
                    + (substrateRGScale (N + 1))^4 * substrateRGScale N
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^3
                    + substrateRGScale (N + 1) * (substrateRGScale N)^4
                    + (substrateRGScale N)^5)) := by
  unfold substrateBetaFunction runningCoupling6Loop
  ring

/-- **Six-loop beta function is non-positive at non-negative parameters**. -/
theorem runningCoupling6Loop_beta_nonpos_of_nonneg_params
    (g_0 α β γ ε ζ η : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (hε : 0 ≤ ε) (hζ : 0 ≤ ζ) (hη : 0 ≤ η)
    (N : ℕ) :
    substrateBetaFunction (runningCoupling6Loop g_0 α β γ ε ζ η) N ≤ 0 := by
  rw [runningCoupling6Loop_beta_eq_factorised]
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
  have h_sum_quart_nonneg :
      0 ≤ (substrateRGScale (N + 1))^4
            + (substrateRGScale (N + 1))^3 * substrateRGScale N
            + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^2
            + substrateRGScale (N + 1) * (substrateRGScale N)^3
            + (substrateRGScale N)^4 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^4 := by positivity
    have h2 : 0 ≤ (substrateRGScale (N + 1))^3 * substrateRGScale N := by positivity
    have h3 : 0 ≤ (substrateRGScale (N + 1))^2 * (substrateRGScale N)^2 := by positivity
    have h4 : 0 ≤ substrateRGScale (N + 1) * (substrateRGScale N)^3 := by positivity
    have h5 : 0 ≤ (substrateRGScale N)^4 := by positivity
    linarith
  have h_sum_quint_nonneg :
      0 ≤ (substrateRGScale (N + 1))^5
            + (substrateRGScale (N + 1))^4 * substrateRGScale N
            + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^2
            + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^3
            + substrateRGScale (N + 1) * (substrateRGScale N)^4
            + (substrateRGScale N)^5 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^5 := by positivity
    have h2 : 0 ≤ (substrateRGScale (N + 1))^4 * substrateRGScale N := by positivity
    have h3 : 0 ≤ (substrateRGScale (N + 1))^3 * (substrateRGScale N)^2 := by positivity
    have h4 : 0 ≤ (substrateRGScale (N + 1))^2 * (substrateRGScale N)^3 := by positivity
    have h5 : 0 ≤ substrateRGScale (N + 1) * (substrateRGScale N)^4 := by positivity
    have h6 : 0 ≤ (substrateRGScale N)^5 := by positivity
    linarith
  have h_bracket_nonneg :
      0 ≤ α + β * (substrateRGScale (N + 1) + substrateRGScale N)
            + γ * ((substrateRGScale (N + 1))^2
                    + substrateRGScale (N + 1) * substrateRGScale N
                    + (substrateRGScale N)^2)
            + ε * ((substrateRGScale (N + 1))^3
                    + (substrateRGScale (N + 1))^2 * substrateRGScale N
                    + substrateRGScale (N + 1) * (substrateRGScale N)^2
                    + (substrateRGScale N)^3)
            + ζ * ((substrateRGScale (N + 1))^4
                    + (substrateRGScale (N + 1))^3 * substrateRGScale N
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^2
                    + substrateRGScale (N + 1) * (substrateRGScale N)^3
                    + (substrateRGScale N)^4)
            + η * ((substrateRGScale (N + 1))^5
                    + (substrateRGScale (N + 1))^4 * substrateRGScale N
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^3
                    + substrateRGScale (N + 1) * (substrateRGScale N)^4
                    + (substrateRGScale N)^5) := by
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
    have hζ_term : 0 ≤ ζ * ((substrateRGScale (N + 1))^4
                              + (substrateRGScale (N + 1))^3 * substrateRGScale N
                              + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^2
                              + substrateRGScale (N + 1) * (substrateRGScale N)^3
                              + (substrateRGScale N)^4) :=
      mul_nonneg hζ h_sum_quart_nonneg
    have hη_term : 0 ≤ η * ((substrateRGScale (N + 1))^5
                              + (substrateRGScale (N + 1))^4 * substrateRGScale N
                              + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^2
                              + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^3
                              + substrateRGScale (N + 1) * (substrateRGScale N)^4
                              + (substrateRGScale N)^5) :=
      mul_nonneg hη h_sum_quint_nonneg
    linarith
  nlinarith [hg, h_diff_nonpos, h_bracket_nonneg,
             mul_nonneg hg h_bracket_nonneg]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.47 headline — six-loop substrate-running-
    coupling structural report.**

    For non-negative `g₀, α, β, γ, ε, ζ, η ≥ 0` and depth `N : ℕ`:

    1. **Reduces to Phase 9.43 (5-loop) at `η = 0`**.
    2. **Beta function in factored form** via difference-of-sixth-powers.
    3. **Monotone IR flow at non-negative params**: `β(g_6, N) ≤ 0`. -/
theorem substrate_running_coupling_6loop_report
    (g_0 α β γ ε ζ η : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (hε : 0 ≤ ε) (hζ : 0 ≤ ζ) (hη : 0 ≤ η)
    (N : ℕ) :
    runningCoupling6Loop g_0 α β γ ε ζ 0 N = runningCoupling5Loop g_0 α β γ ε ζ N ∧
    substrateBetaFunction (runningCoupling6Loop g_0 α β γ ε ζ η) N ≤ 0 := by
  refine ⟨?_, ?_⟩
  · exact runningCoupling6Loop_zero_eta g_0 α β γ ε ζ N
  · exact runningCoupling6Loop_beta_nonpos_of_nonneg_params g_0 α β γ ε ζ η
      hg hα hβ hγ hε hζ hη N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling6Loop
