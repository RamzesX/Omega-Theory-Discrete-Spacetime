/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop

  **Lion's-Pride Phase 9.6 (2026-05-06)**:
  *Two-loop extension of the Phase 9.5 substrate-derived running
  coupling — adds the `β · δ_comp²` quadratic correction.*

  ## Why this file

  Phase 9.5 (`SubstrateRunningCoupling`) shipped the one-loop shape

      g_1(N)  :=  g₀ · (1 + α · δ_comp(N))

  In continuum perturbative QFT, two-loop running adds a
  `g₀ · β · log²(μ/μ_ref)` correction.  In the substrate, the analog
  is

      g_2(N)  :=  g₀ · (1 + α · δ_comp(N) + β · δ_comp(N)²)

  This file ships the two-loop substrate running coupling and proves:

  1. **Reduction**: `β = 0` ⟹ recovers Phase 9.5 one-loop shape.
  2. **Beta function explicit form**:
        `β_subst(g_2, N) = g₀·(δ_{N+1} - δ_N)·(α + β·(δ_{N+1} + δ_N))`.
  3. **Monotone IR flow at non-negative params**:
        `g₀ ≥ 0 ∧ α ≥ 0 ∧ β ≥ 0 ⟹ β_subst(g_2, N) ≤ 0`
     (the substrate quadratic correction does NOT spoil the
      monotone-IR-flow established in Phase 9.5).

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `runningCoupling2Loop g₀ α β N`                       | (def: `g₀·(1 + α·δ + β·δ²)`)                     |
  | Reduces to Phase 9.5 at `β = 0`                       | `runningCoupling2Loop_zero_beta`                  |
  | Constant case at `α = β = 0`                          | `runningCoupling2Loop_zero_params`                |
  | Explicit beta-function shape                          | `runningCoupling2Loop_beta_eq_factorised`         |
  | Monotone IR flow at non-negative params               | `runningCoupling2Loop_beta_nonpos_of_nonneg_params`|
  | Headline (3-conjunct)                                 | `substrate_running_coupling_2loop_report`          |

  ## Honest scope

  This file ships the two-loop EXTENSION shape with explicit
  beta-function algebra.  It does NOT yet:
  * Derive the (g₀, α, β) parameters from Connes spectral-action
    eigenvalues (Phase 6.5+ multi-month).
  * Compare against the actual SM two-loop beta-function coefficients
    `b_0 = 11N_c/3 - 2N_f/3` etc. — would need PDG calibration of
    g₀, α, β.
  * Address higher-loop corrections (3-loop, 4-loop — would need
    Phase 9.7+ files).

  What it DOES ship: the algebraic two-loop shape with proven
  factored beta-function form and IR-monotone-flow under
  non-negative coefficients — a structural prediction extending
  Phase 9.5 to second order.

  ## Author

  Lion's-Pride dynamic /loop iteration 46 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop

open OmegaTheory.Irrationality
open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling

/-! ## 1. Two-loop substrate running coupling

    `g_2(N) = g₀ · (1 + α · δ_comp(N) + β · δ_comp(N)²)`. -/

/-- **Two-loop substrate-running coupling**: extends Phase 9.5 with a
    quadratic correction in `δ_comp(N)`.

    `α = β = 0`: constant case (`g(N) = g₀`).
    `β = 0, α ≠ 0`: recovers Phase 9.5 one-loop.
    `β > 0`: substrate two-loop strengthens the IR pull (faster flow).
    `β < 0`: substrate two-loop weakens / can reverse the IR pull. -/
noncomputable def runningCoupling2Loop (g_0 α β : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N + β * (substrateRGScale N)^2)

/-- **Constant-coupling case**: `α = 0 ∧ β = 0` ⟹ `g(N) = g₀`. -/
theorem runningCoupling2Loop_zero_params (g_0 : ℝ) (N : ℕ) :
    runningCoupling2Loop g_0 0 0 N = g_0 := by
  unfold runningCoupling2Loop
  ring

/-- **Reduces to Phase 9.5 at `β = 0`**: with `β = 0`, the two-loop
    coupling matches the one-loop coupling. -/
theorem runningCoupling2Loop_zero_beta (g_0 α : ℝ) (N : ℕ) :
    runningCoupling2Loop g_0 α 0 N = runningCoupling g_0 α N := by
  unfold runningCoupling2Loop runningCoupling
  ring

/-! ## 2. Substrate beta function on the two-loop running coupling

    `β(g_2, N) = g_2(N+1) - g_2(N)
              = g₀ · (δ_{N+1} - δ_N) · (α + β · (δ_{N+1} + δ_N))` -/

/-- **Two-loop beta function in factored form**:

    `β_subst(g_2, N) = g₀ · (δ_{N+1} - δ_N) · (α + β · (δ_{N+1} + δ_N))`.

    Proof: `g_2(N+1) - g_2(N) = g₀ · α · (δ_{N+1} - δ_N)
                              + g₀ · β · (δ²_{N+1} - δ²_N)`.
    Difference of squares: `δ²_{N+1} - δ²_N = (δ_{N+1} - δ_N)(δ_{N+1} + δ_N)`.
    Factor `(δ_{N+1} - δ_N)` out. -/
theorem runningCoupling2Loop_beta_eq_factorised
    (g_0 α β : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling2Loop g_0 α β) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)) := by
  unfold substrateBetaFunction runningCoupling2Loop
  ring

/-- **Two-loop beta function is non-positive at non-negative parameters**:
    `g₀ ≥ 0 ∧ α ≥ 0 ∧ β ≥ 0` ⟹ `β_subst(g_2, N) ≤ 0`.

    Reasoning:
    * `(δ_{N+1} - δ_N) ≤ 0` from Phase 9.3 monotone-decreasing.
    * `(δ_{N+1} + δ_N) > 0` (sum of two positive δ_comp).
    * `α + β · (...) ≥ 0` (sum of two non-negatives times positive).
    * `g₀ ≥ 0` by hypothesis.
    Product of: `(≤ 0)`, `(≥ 0)`, `(≥ 0)` → `(≤ 0)`. -/
theorem runningCoupling2Loop_beta_nonpos_of_nonneg_params
    (g_0 α β : ℝ) (hg : 0 ≤ g_0) (hα : 0 ≤ α) (hβ : 0 ≤ β) (N : ℕ) :
    substrateBetaFunction (runningCoupling2Loop g_0 α β) N ≤ 0 := by
  rw [runningCoupling2Loop_beta_eq_factorised]
  -- Want: g_0 * (δ_{N+1} - δ_N) * (α + β · (δ_{N+1} + δ_N)) ≤ 0
  have h_diff_nonpos :
      substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_sum_nonneg :
      0 ≤ substrateRGScale (N + 1) + substrateRGScale N := by
    have hn := substrateRGScale_pos N
    have hN1 := substrateRGScale_pos (N + 1)
    linarith
  have h_bracket_nonneg :
      0 ≤ α + β * (substrateRGScale (N + 1) + substrateRGScale N) := by
    have := mul_nonneg hβ h_sum_nonneg
    linarith
  -- product structure: g_0 * (≤0) * (≥0) = (≤0)
  -- equivalently, g_0 * bracket * diff ≤ 0
  -- using nlinarith-like reasoning
  nlinarith [hg, h_diff_nonpos, h_bracket_nonneg, mul_nonneg hg h_bracket_nonneg]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.6 headline — two-loop substrate-running-
    coupling structural report.**

    For any IR-asymptote coupling `g₀ : ℝ`, one-loop `α : ℝ`,
    two-loop `β : ℝ`, and truncation depth `N : ℕ`:

    1. **Reduces to Phase 9.5 at β = 0**:
       `runningCoupling2Loop g₀ α 0 N = runningCoupling g₀ α N`.

    2. **Factored beta-function**:
       `β(g, N) = g₀·(δ_{N+1} - δ_N)·(α + β·(δ_{N+1} + δ_N))`.

    3. **Monotone IR flow at non-negative parameters**:
       `g₀, α, β ≥ 0` ⟹ `β(g, N) ≤ 0` (substrate two-loop preserves
       the IR-monotone-flow established at one-loop). -/
theorem substrate_running_coupling_2loop_report
    (g_0 α β : ℝ) (N : ℕ) :
    runningCoupling2Loop g_0 α 0 N = runningCoupling g_0 α N ∧
    substrateBetaFunction (runningCoupling2Loop g_0 α β) N
      = g_0 * (substrateRGScale (N + 1) - substrateRGScale N)
        * (α + β * (substrateRGScale (N + 1) + substrateRGScale N)) ∧
    (0 ≤ g_0 → 0 ≤ α → 0 ≤ β →
      substrateBetaFunction (runningCoupling2Loop g_0 α β) N ≤ 0) := by
  refine ⟨?_, ?_, ?_⟩
  · exact runningCoupling2Loop_zero_beta g_0 α N
  · exact runningCoupling2Loop_beta_eq_factorised g_0 α β N
  · intro hg hα hβ
    exact runningCoupling2Loop_beta_nonpos_of_nonneg_params g_0 α β hg hα hβ N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling2Loop
