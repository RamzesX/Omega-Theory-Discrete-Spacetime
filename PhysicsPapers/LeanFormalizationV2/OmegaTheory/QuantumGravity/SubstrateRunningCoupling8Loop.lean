/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling8Loop

  **Lion's-Pride Phase 9.51 (2026-05-06)**:
  *Eight-loop extension of the substrate-derived running coupling —
  adds the `ι · δ_comp⁸` octic correction with explicit factored
  beta-function via difference-of-eighth-powers identity
  `a⁸ - b⁸ = (a - b)(a⁷ + a⁶b + a⁵b² + a⁴b³ + a³b⁴ + a²b⁵ + ab⁶ + b⁷)`.*

  ## Why this file

  Phase 9.49 (`SubstrateRunningCoupling7Loop`) shipped the seven-loop
  shape:

      g_7(N) := g₀ · (1 + α·δ + β·δ² + γ·δ³ + ε·δ⁴ + ζ·δ⁵ + η·δ⁶ + θ·δ⁷)

  The substrate analog of eight-loop running adds yet another power:

      g_8(N) := g₀ · (1 + α·δ + β·δ² + ... + θ·δ⁷ + ι·δ⁸)

  This file ships the eight-loop substrate running coupling and proves:

  1. **Reductions**:
     * `ι = 0` ⟹ recovers Phase 9.49 seven-loop.
     * `θ = ι = 0` ⟹ recovers Phase 9.47 six-loop.
     * `α = β = ... = ι = 0` ⟹ constant.
  2. **Beta function explicit factored form** via difference-of-
     eighth-powers `a⁸-b⁸ = (a-b)(a⁷+a⁶b+a⁵b²+a⁴b³+a³b⁴+a²b⁵+ab⁶+b⁷)`.
  3. **Monotone IR flow at non-negative params**:
       `g₀, α, β, γ, ε, ζ, η, θ, ι ≥ 0` ⟹ `β(g_8, N) ≤ 0`.

  ## Honest scope

  This file ships the eight-loop EXTENSION shape with explicit factored
  beta-function algebra. It does NOT yet:
  * Derive (g₀, α, β, γ, ε, ζ, η, θ, ι) from Connes spectral-action
    eigenvalues.
  * Compare against actual SM 8-loop beta-function coefficients (most
    SM coefficients are not even computed at 8-loop in continuum QFT).

  What it DOES ship: the algebraic eight-loop shape with proven factored
  beta-function form and IR-monotone-flow under non-negative coefficients.

  ## Author

  Lion's-Pride dynamic /loop iteration 142 (2026-05-06).
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
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling8Loop

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling3Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling4Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling5Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling6Loop
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling7Loop

/-! ## 1. Eight-loop substrate running coupling -/

/-- **Eight-loop substrate-running coupling**: extends Phase 9.49 with
    an octic correction in `δ_comp(N)`. -/
noncomputable def runningCoupling8Loop (g_0 α β γ ε ζ η θ ι : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N
            + β * (substrateRGScale N)^2
            + γ * (substrateRGScale N)^3
            + ε * (substrateRGScale N)^4
            + ζ * (substrateRGScale N)^5
            + η * (substrateRGScale N)^6
            + θ * (substrateRGScale N)^7
            + ι * (substrateRGScale N)^8)

/-- **Constant-coupling case**. -/
theorem runningCoupling8Loop_zero_params (g_0 : ℝ) (N : ℕ) :
    runningCoupling8Loop g_0 0 0 0 0 0 0 0 0 N = g_0 := by
  unfold runningCoupling8Loop
  ring

/-- **Reduces to Phase 9.49 at `ι = 0`**. -/
theorem runningCoupling8Loop_zero_iota (g_0 α β γ ε ζ η θ : ℝ) (N : ℕ) :
    runningCoupling8Loop g_0 α β γ ε ζ η θ 0 N = runningCoupling7Loop g_0 α β γ ε ζ η θ N := by
  unfold runningCoupling8Loop runningCoupling7Loop
  ring

/-- **Reduces to Phase 9.47 at `θ = ι = 0`**. -/
theorem runningCoupling8Loop_zero_theta_iota (g_0 α β γ ε ζ η : ℝ) (N : ℕ) :
    runningCoupling8Loop g_0 α β γ ε ζ η 0 0 N = runningCoupling6Loop g_0 α β γ ε ζ η N := by
  unfold runningCoupling8Loop runningCoupling6Loop
  ring

/-- **Reduces to Phase 9.43 at `η = θ = ι = 0`**. -/
theorem runningCoupling8Loop_zero_eta_theta_iota (g_0 α β γ ε ζ : ℝ) (N : ℕ) :
    runningCoupling8Loop g_0 α β γ ε ζ 0 0 0 N = runningCoupling5Loop g_0 α β γ ε ζ N := by
  unfold runningCoupling8Loop runningCoupling5Loop
  ring

/-! ## 2. Substrate beta function on the eight-loop running coupling -/

/-- **Eight-loop beta function in factored form** via
    difference-of-eighth-powers
    `a⁸ - b⁸ = (a-b)(a⁷ + a⁶b + a⁵b² + a⁴b³ + a³b⁴ + a²b⁵ + ab⁶ + b⁷)`. -/
theorem runningCoupling8Loop_beta_eq_factorised
    (g_0 α β γ ε ζ η θ ι : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling8Loop g_0 α β γ ε ζ η θ ι) N
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
                    + (substrateRGScale N)^7)) := by
  unfold substrateBetaFunction runningCoupling8Loop
  ring

/-- **Eight-loop beta function is non-positive at non-negative parameters**. -/
theorem runningCoupling8Loop_beta_nonpos_of_nonneg_params
    (g_0 α β γ ε ζ η θ ι : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (hε : 0 ≤ ε) (hζ : 0 ≤ ζ) (hη : 0 ≤ η) (hθ : 0 ≤ θ) (hι : 0 ≤ ι)
    (N : ℕ) :
    substrateBetaFunction (runningCoupling8Loop g_0 α β γ ε ζ η θ ι) N ≤ 0 := by
  rw [runningCoupling8Loop_beta_eq_factorised]
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
                    + (substrateRGScale N)^7) := by
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
    linarith
  nlinarith [hg, h_diff_nonpos, h_bracket_nonneg,
             mul_nonneg hg h_bracket_nonneg]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.51 headline — eight-loop substrate-running-
    coupling structural report.**

    For non-negative `g₀, α, β, γ, ε, ζ, η, θ, ι ≥ 0` and depth `N : ℕ`:

    1. **Reduces to Phase 9.49 (7-loop) at `ι = 0`**.
    2. **Beta function in factored form** via difference-of-eighth-powers.
    3. **Monotone IR flow at non-negative params**: `β(g_8, N) ≤ 0`. -/
theorem substrate_running_coupling_8loop_report
    (g_0 α β γ ε ζ η θ ι : ℝ)
    (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (hγ : 0 ≤ γ)
    (hε : 0 ≤ ε) (hζ : 0 ≤ ζ) (hη : 0 ≤ η) (hθ : 0 ≤ θ) (hι : 0 ≤ ι)
    (N : ℕ) :
    runningCoupling8Loop g_0 α β γ ε ζ η θ 0 N = runningCoupling7Loop g_0 α β γ ε ζ η θ N ∧
    substrateBetaFunction (runningCoupling8Loop g_0 α β γ ε ζ η θ ι) N ≤ 0 := by
  refine ⟨?_, ?_⟩
  · exact runningCoupling8Loop_zero_iota g_0 α β γ ε ζ η θ N
  · exact runningCoupling8Loop_beta_nonpos_of_nonneg_params g_0 α β γ ε ζ η θ ι
      hg hα hβ hγ hε hζ hη hθ hι N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling8Loop
