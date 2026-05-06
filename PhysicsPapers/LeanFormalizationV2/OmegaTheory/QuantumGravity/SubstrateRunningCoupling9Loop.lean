/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling9Loop

  **Lion's-Pride Phase 9.53 (2026-05-06)**:
  *Nine-loop extension of the substrate-derived running coupling —
  adds the `κ · δ_comp⁹` nonic correction with explicit factored
  beta-function via difference-of-ninth-powers identity
  `a⁹ - b⁹ = (a - b)(a⁸ + a⁷b + a⁶b² + a⁵b³ + a⁴b⁴ + a³b⁵ + a²b⁶ + ab⁷ + b⁸)`.*

  ## Why this file

  Phase 9.51 (`SubstrateRunningCoupling8Loop`) shipped the eight-loop
  shape. The substrate analog of nine-loop running adds yet another
  power:

      g_9(N) := g₀ · (1 + α·δ + β·δ² + ... + ι·δ⁸ + κ·δ⁹)

  This file ships the nine-loop substrate running coupling and proves:

  1. **Reductions**:
     * `κ = 0` ⟹ recovers Phase 9.51 eight-loop.
     * `ι = κ = 0` ⟹ recovers Phase 9.49 seven-loop.
     * `α = β = ... = κ = 0` ⟹ constant.
  2. **Beta function explicit factored form** via difference-of-
     ninth-powers `a⁹-b⁹ = (a-b)(a⁸+a⁷b+a⁶b²+a⁵b³+a⁴b⁴+a³b⁵+a²b⁶+ab⁷+b⁸)`.
  3. **Monotone IR flow at non-negative params**:
       `g₀, α, β, γ, ε, ζ, η, θ, ι, κ ≥ 0` ⟹ `β(g_9, N) ≤ 0`.

  ## Honest scope

  This file ships the nine-loop EXTENSION shape with explicit factored
  beta-function algebra. It does NOT yet:
  * Derive parameters from Connes spectral-action eigenvalues.
  * Compare against actual SM 9-loop beta-function coefficients
    (these are not even computed in continuum QFT at 9-loop).

  What it DOES ship: the algebraic nine-loop shape with proven factored
  beta-function form and IR-monotone-flow under non-negative coefficients.

  ## Author

  Lion's-Pride dynamic /loop iteration 146 (2026-05-06).
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
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling6Loop
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling7Loop
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling8Loop
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling9Loop

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling5Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling6Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling7Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling8Loop

/-! ## 1. Nine-loop substrate running coupling -/

/-- **Nine-loop substrate-running coupling**: extends Phase 9.51 with
    a nonic correction in `δ_comp(N)`. -/
noncomputable def runningCoupling9Loop (g_0 α β γ ε ζ η θ ι κ : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N
            + β * (substrateRGScale N)^2
            + γ * (substrateRGScale N)^3
            + ε * (substrateRGScale N)^4
            + ζ * (substrateRGScale N)^5
            + η * (substrateRGScale N)^6
            + θ * (substrateRGScale N)^7
            + ι * (substrateRGScale N)^8
            + κ * (substrateRGScale N)^9)

/-- **Constant-coupling case**. -/
theorem runningCoupling9Loop_zero_params (g_0 : ℝ) (N : ℕ) :
    runningCoupling9Loop g_0 0 0 0 0 0 0 0 0 0 N = g_0 := by
  unfold runningCoupling9Loop
  ring

/-- **Reduces to Phase 9.51 at `κ = 0`**. -/
theorem runningCoupling9Loop_zero_kappa (g_0 α β γ ε ζ η θ ι : ℝ) (N : ℕ) :
    runningCoupling9Loop g_0 α β γ ε ζ η θ ι 0 N = runningCoupling8Loop g_0 α β γ ε ζ η θ ι N := by
  unfold runningCoupling9Loop runningCoupling8Loop
  ring

/-- **Reduces to Phase 9.49 at `ι = κ = 0`**. -/
theorem runningCoupling9Loop_zero_iota_kappa (g_0 α β γ ε ζ η θ : ℝ) (N : ℕ) :
    runningCoupling9Loop g_0 α β γ ε ζ η θ 0 0 N = runningCoupling7Loop g_0 α β γ ε ζ η θ N := by
  unfold runningCoupling9Loop runningCoupling7Loop
  ring

/-- **Reduces to Phase 9.47 at `θ = ι = κ = 0`**. -/
theorem runningCoupling9Loop_zero_theta_iota_kappa (g_0 α β γ ε ζ η : ℝ) (N : ℕ) :
    runningCoupling9Loop g_0 α β γ ε ζ η 0 0 0 N = runningCoupling6Loop g_0 α β γ ε ζ η N := by
  unfold runningCoupling9Loop runningCoupling6Loop
  ring

/-! ## 2. Substrate beta function on the nine-loop running coupling -/

/-- **Nine-loop beta function in factored form** via
    difference-of-ninth-powers
    `a⁹ - b⁹ = (a-b)(a⁸ + a⁷b + a⁶b² + a⁵b³ + a⁴b⁴ + a³b⁵ + a²b⁶ + ab⁷ + b⁸)`. -/
theorem runningCoupling9Loop_beta_eq_factorised
    (g_0 α β γ ε ζ η θ ι κ : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling9Loop g_0 α β γ ε ζ η θ ι κ) N
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
                    + (substrateRGScale N)^5)
             + θ * ((substrateRGScale (N + 1))^6
                    + (substrateRGScale (N + 1))^5 * substrateRGScale N
                    + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^3
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^4
                    + substrateRGScale (N + 1) * (substrateRGScale N)^5
                    + (substrateRGScale N)^6)
             + ι * ((substrateRGScale (N + 1))^7
                    + (substrateRGScale (N + 1))^6 * substrateRGScale N
                    + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^3
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^4
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^5
                    + substrateRGScale (N + 1) * (substrateRGScale N)^6
                    + (substrateRGScale N)^7)
             + κ * ((substrateRGScale (N + 1))^8
                    + (substrateRGScale (N + 1))^7 * substrateRGScale N
                    + (substrateRGScale (N + 1))^6 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^3
                    + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^4
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^5
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^6
                    + substrateRGScale (N + 1) * (substrateRGScale N)^7
                    + (substrateRGScale N)^8)) := by
  unfold substrateBetaFunction runningCoupling9Loop
  ring

/-- **Nine-loop beta function is non-positive at non-negative parameters**. -/
theorem runningCoupling9Loop_beta_nonpos_of_nonneg_params
    (g_0 α β γ ε ζ η θ ι κ : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (hε : 0 ≤ ε) (hζ : 0 ≤ ζ) (hη : 0 ≤ η) (hθ : 0 ≤ θ) (hι : 0 ≤ ι) (hκ : 0 ≤ κ)
    (N : ℕ) :
    substrateBetaFunction (runningCoupling9Loop g_0 α β γ ε ζ η θ ι κ) N ≤ 0 := by
  rw [runningCoupling9Loop_beta_eq_factorised]
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
  have h_sum_sext_nonneg :
      0 ≤ (substrateRGScale (N + 1))^6
            + (substrateRGScale (N + 1))^5 * substrateRGScale N
            + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^2
            + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^3
            + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^4
            + substrateRGScale (N + 1) * (substrateRGScale N)^5
            + (substrateRGScale N)^6 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^6 := by positivity
    have h2 : 0 ≤ (substrateRGScale (N + 1))^5 * substrateRGScale N := by positivity
    have h3 : 0 ≤ (substrateRGScale (N + 1))^4 * (substrateRGScale N)^2 := by positivity
    have h4 : 0 ≤ (substrateRGScale (N + 1))^3 * (substrateRGScale N)^3 := by positivity
    have h5 : 0 ≤ (substrateRGScale (N + 1))^2 * (substrateRGScale N)^4 := by positivity
    have h6 : 0 ≤ substrateRGScale (N + 1) * (substrateRGScale N)^5 := by positivity
    have h7 : 0 ≤ (substrateRGScale N)^6 := by positivity
    linarith
  have h_sum_sept_nonneg :
      0 ≤ (substrateRGScale (N + 1))^7
            + (substrateRGScale (N + 1))^6 * substrateRGScale N
            + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^2
            + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^3
            + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^4
            + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^5
            + substrateRGScale (N + 1) * (substrateRGScale N)^6
            + (substrateRGScale N)^7 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^7 := by positivity
    have h2 : 0 ≤ (substrateRGScale (N + 1))^6 * substrateRGScale N := by positivity
    have h3 : 0 ≤ (substrateRGScale (N + 1))^5 * (substrateRGScale N)^2 := by positivity
    have h4 : 0 ≤ (substrateRGScale (N + 1))^4 * (substrateRGScale N)^3 := by positivity
    have h5 : 0 ≤ (substrateRGScale (N + 1))^3 * (substrateRGScale N)^4 := by positivity
    have h6 : 0 ≤ (substrateRGScale (N + 1))^2 * (substrateRGScale N)^5 := by positivity
    have h7 : 0 ≤ substrateRGScale (N + 1) * (substrateRGScale N)^6 := by positivity
    have h8 : 0 ≤ (substrateRGScale N)^7 := by positivity
    linarith
  have h_sum_oct_nonneg :
      0 ≤ (substrateRGScale (N + 1))^8
            + (substrateRGScale (N + 1))^7 * substrateRGScale N
            + (substrateRGScale (N + 1))^6 * (substrateRGScale N)^2
            + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^3
            + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^4
            + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^5
            + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^6
            + substrateRGScale (N + 1) * (substrateRGScale N)^7
            + (substrateRGScale N)^8 := by
    have h1 : 0 ≤ (substrateRGScale (N + 1))^8 := by positivity
    have h2 : 0 ≤ (substrateRGScale (N + 1))^7 * substrateRGScale N := by positivity
    have h3 : 0 ≤ (substrateRGScale (N + 1))^6 * (substrateRGScale N)^2 := by positivity
    have h4 : 0 ≤ (substrateRGScale (N + 1))^5 * (substrateRGScale N)^3 := by positivity
    have h5 : 0 ≤ (substrateRGScale (N + 1))^4 * (substrateRGScale N)^4 := by positivity
    have h6 : 0 ≤ (substrateRGScale (N + 1))^3 * (substrateRGScale N)^5 := by positivity
    have h7 : 0 ≤ (substrateRGScale (N + 1))^2 * (substrateRGScale N)^6 := by positivity
    have h8 : 0 ≤ substrateRGScale (N + 1) * (substrateRGScale N)^7 := by positivity
    have h9 : 0 ≤ (substrateRGScale N)^8 := by positivity
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
                    + (substrateRGScale N)^5)
            + θ * ((substrateRGScale (N + 1))^6
                    + (substrateRGScale (N + 1))^5 * substrateRGScale N
                    + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^3
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^4
                    + substrateRGScale (N + 1) * (substrateRGScale N)^5
                    + (substrateRGScale N)^6)
            + ι * ((substrateRGScale (N + 1))^7
                    + (substrateRGScale (N + 1))^6 * substrateRGScale N
                    + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^3
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^4
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^5
                    + substrateRGScale (N + 1) * (substrateRGScale N)^6
                    + (substrateRGScale N)^7)
            + κ * ((substrateRGScale (N + 1))^8
                    + (substrateRGScale (N + 1))^7 * substrateRGScale N
                    + (substrateRGScale (N + 1))^6 * (substrateRGScale N)^2
                    + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^3
                    + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^4
                    + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^5
                    + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^6
                    + substrateRGScale (N + 1) * (substrateRGScale N)^7
                    + (substrateRGScale N)^8) := by
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
    have hθ_term : 0 ≤ θ * ((substrateRGScale (N + 1))^6
                              + (substrateRGScale (N + 1))^5 * substrateRGScale N
                              + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^2
                              + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^3
                              + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^4
                              + substrateRGScale (N + 1) * (substrateRGScale N)^5
                              + (substrateRGScale N)^6) :=
      mul_nonneg hθ h_sum_sext_nonneg
    have hι_term : 0 ≤ ι * ((substrateRGScale (N + 1))^7
                              + (substrateRGScale (N + 1))^6 * substrateRGScale N
                              + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^2
                              + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^3
                              + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^4
                              + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^5
                              + substrateRGScale (N + 1) * (substrateRGScale N)^6
                              + (substrateRGScale N)^7) :=
      mul_nonneg hι h_sum_sept_nonneg
    have hκ_term : 0 ≤ κ * ((substrateRGScale (N + 1))^8
                              + (substrateRGScale (N + 1))^7 * substrateRGScale N
                              + (substrateRGScale (N + 1))^6 * (substrateRGScale N)^2
                              + (substrateRGScale (N + 1))^5 * (substrateRGScale N)^3
                              + (substrateRGScale (N + 1))^4 * (substrateRGScale N)^4
                              + (substrateRGScale (N + 1))^3 * (substrateRGScale N)^5
                              + (substrateRGScale (N + 1))^2 * (substrateRGScale N)^6
                              + substrateRGScale (N + 1) * (substrateRGScale N)^7
                              + (substrateRGScale N)^8) :=
      mul_nonneg hκ h_sum_oct_nonneg
    linarith
  nlinarith [hg, h_diff_nonpos, h_bracket_nonneg,
             mul_nonneg hg h_bracket_nonneg]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.53 headline — nine-loop substrate-running-
    coupling structural report.**

    For non-negative `g₀, α, β, γ, ε, ζ, η, θ, ι, κ ≥ 0` and depth `N : ℕ`:

    1. **Reduces to Phase 9.51 (8-loop) at `κ = 0`**.
    2. **Beta function in factored form** via difference-of-ninth-powers.
    3. **Monotone IR flow at non-negative params**: `β(g_9, N) ≤ 0`. -/
theorem substrate_running_coupling_9loop_report
    (g_0 α β γ ε ζ η θ ι κ : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (hε : 0 ≤ ε) (hζ : 0 ≤ ζ) (hη : 0 ≤ η) (hθ : 0 ≤ θ) (hι : 0 ≤ ι) (hκ : 0 ≤ κ)
    (N : ℕ) :
    runningCoupling9Loop g_0 α β γ ε ζ η θ ι 0 N = runningCoupling8Loop g_0 α β γ ε ζ η θ ι N ∧
    substrateBetaFunction (runningCoupling9Loop g_0 α β γ ε ζ η θ ι κ) N ≤ 0 := by
  refine ⟨?_, ?_⟩
  · exact runningCoupling9Loop_zero_kappa g_0 α β γ ε ζ η θ ι N
  · exact runningCoupling9Loop_beta_nonpos_of_nonneg_params g_0 α β γ ε ζ η θ ι κ
      hg hα hβ hγ hε hζ hη hθ hι hκ N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling9Loop
