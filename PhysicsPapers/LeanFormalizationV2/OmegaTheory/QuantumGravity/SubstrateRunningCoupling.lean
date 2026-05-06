/-
  OmegaTheory.QuantumGravity.SubstrateRunningCoupling

  **Lion's-Pride Phase 9.5 (2026-05-06)**:
  *Concrete substrate-derived running coupling — connects Phase 9.3
  substrate RG scale to a parametric coupling shape and computes the
  Phase 9.4 substrate beta function on it.*

  ## Why this file

  The substrate's natural RG scale is `δ_comp(N) = ℓ_P · 4/(2N+3)`
  (Phase 9.3 `substrateRGScale`), monotone-decreasing in `N`, with
  IR fixed point `δ_comp → 0` as `N → ∞`.

  The simplest non-trivial coupling that runs with the substrate RG
  scale is

      g(N)  :=  g₀ · (1 + α · δ_comp(N))

  where `g₀` is the IR-asymptote coupling and `α` is the substrate
  sensitivity.  At infinite truncation depth `N → ∞`, `g(N) → g₀`
  (asymptotic freedom toward the substrate IR fixed point).

  The substrate beta function (Phase 9.4) on this shape is

      β(g, N)  :=  g(N+1) - g(N)
                =  g₀ · α · (δ_comp(N+1) - δ_comp(N))

  Since `δ_comp` is monotone-decreasing, `β ≤ 0` for `g₀, α ≥ 0` —
  the coupling flows toward `g₀` as `N → ∞`.

  This file ships the concrete connection between Phase 9.3 + 9.4
  abstractions and a parametric running coupling.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `runningCoupling g₀ α N := g₀ * (1 + α * δ_comp N)`    | (definition)                                  |
  | `runningCoupling_zero_alpha`                           | α = 0 ⟹ g(N) = g₀ (constant-coupling case)    |
  | `runningCoupling_beta_eq_alpha_g0_RG_diff`             | β(g, N) = g₀·α·(δ_comp(N+1) - δ_comp(N))      |
  | `runningCoupling_beta_nonpos_of_nonneg_params`         | g₀, α ≥ 0 ⟹ β(g, N) ≤ 0 (IR asymptote)         |
  | Headline (3-conjunct)                                 | `substrate_running_coupling_report`            |

  ## Honest scope

  This file ships ONE concrete substrate-running-coupling shape
  `g(N) = g₀(1 + α·δ_comp(N))`.  It does NOT:
  * Identify the parameters `(g₀, α)` for SPECIFIC SM couplings
    (g_s, α_em, λ_H — calibration to PDG values is Phase 9.5+
    multi-month work; the substrate-axiom derivation of (g₀, α)
    from first principles is the heart of the Connes spectral
    action, deferred to Phase 6.5+).
  * Address higher-loop corrections (Phase 9.6+).
  * Compare against the Standard Model two-loop beta functions
    (would need full QFT framework).

  What it DOES ship: the structural CONNECTION between Phase 9.3
  RG scale and Phase 9.4 beta function via a tractable parametric
  family.  The IR asymptote `g(N) → g₀` is implicit in the substrate
  RG flow's monotone decreasing of `δ_comp`.

  ## Author

  Lion's-Pride dynamic /loop iteration 43 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCoupling

open OmegaTheory.Irrationality
open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction

/-! ## 1. Concrete running coupling

    `g(N) = g₀ · (1 + α · δ_comp(N))`. -/

/-- **Substrate-running coupling**: parametric family of couplings
    that run with the substrate RG scale `δ_comp(N)`.

    `α = 0` recovers the constant case (`g(N) = g₀`).
    `α > 0`: g flows DOWN to `g₀` as N → ∞ (asymptotic-freedom-like).
    `α < 0`: g flows UP to `g₀` as N → ∞ (asymptotic-IR-flow).
    -/
noncomputable def runningCoupling (g_0 α : ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + α * substrateRGScale N)

/-- **Constant-coupling case**: `α = 0` ⟹ `runningCoupling g₀ 0 N = g₀`. -/
theorem runningCoupling_zero_alpha (g_0 : ℝ) (N : ℕ) :
    runningCoupling g_0 0 N = g_0 := by
  unfold runningCoupling
  ring

/-! ## 2. Substrate beta function on the running coupling

    `β(g, N) = g(N+1) - g(N) = g₀ · α · (δ_comp(N+1) - δ_comp(N))`. -/

/-- **Substrate beta function on the running coupling**:

    `β(g, N) = g₀ · α · (δ_comp(N+1) - δ_comp(N))`.

    The factor `δ_comp(N+1) - δ_comp(N)` is the discrete derivative
    of the substrate RG scale; by Phase 9.3 monotone-decreasing it
    is `≤ 0`. -/
theorem runningCoupling_beta_eq_alpha_g0_RG_diff
    (g_0 α : ℝ) (N : ℕ) :
    substrateBetaFunction (runningCoupling g_0 α) N
      = g_0 * α * (substrateRGScale (N + 1) - substrateRGScale N) := by
  unfold substrateBetaFunction runningCoupling
  ring

/-- **Substrate beta function is non-positive when `g₀, α ≥ 0`**:

    Combines Phase 9.3 monotone-decreasing of substrateRGScale with
    the explicit beta-function form above. -/
theorem runningCoupling_beta_nonpos_of_nonneg_params
    (g_0 α : ℝ) (hg : 0 ≤ g_0) (hα : 0 ≤ α) (N : ℕ) :
    substrateBetaFunction (runningCoupling g_0 α) N ≤ 0 := by
  rw [runningCoupling_beta_eq_alpha_g0_RG_diff]
  -- Want: g_0 * α * (RG(N+1) - RG(N)) ≤ 0
  -- have:  RG(N+1) - RG(N) ≤ 0 (Phase 9.3 monotone-decreasing)
  -- and    g_0 * α ≥ 0 (product of two non-negatives)
  have h_diff : substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_prod : 0 ≤ g_0 * α := mul_nonneg hg hα
  nlinarith [h_diff, h_prod]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.5 headline — concrete substrate-running-
    coupling structural report.**

    For any IR-asymptote coupling `g₀ : ℝ`, substrate sensitivity
    `α : ℝ`, and truncation depth `N : ℕ`:

    1. **Constant case**: α = 0 ⟹ `runningCoupling g₀ 0 N = g₀`.

    2. **Beta-function explicit form**:
       `β(g, N) = g₀ · α · (δ_comp(N+1) - δ_comp(N))`.

    3. **IR asymptote (non-negative parameters)**: `g₀ ≥ 0 ∧ α ≥ 0`
       ⟹ `β(g, N) ≤ 0` (coupling flows monotonically toward `g₀`). -/
theorem substrate_running_coupling_report
    (g_0 α : ℝ) (N : ℕ) :
    runningCoupling g_0 0 N = g_0 ∧
    substrateBetaFunction (runningCoupling g_0 α) N
      = g_0 * α * (substrateRGScale (N + 1) - substrateRGScale N) ∧
    (0 ≤ g_0 → 0 ≤ α →
      substrateBetaFunction (runningCoupling g_0 α) N ≤ 0) := by
  refine ⟨?_, ?_, ?_⟩
  · exact runningCoupling_zero_alpha g_0 N
  · exact runningCoupling_beta_eq_alpha_g0_RG_diff g_0 α N
  · intro hg hα
    exact runningCoupling_beta_nonpos_of_nonneg_params g_0 α hg hα N

end OmegaTheory.QuantumGravity.SubstrateRunningCoupling
