/-
  OmegaTheory.QuantumGravity.SubstrateRunningCrossSection

  **Lion's-Pride Phase 8.9 (2026-05-06)**:
  *Substrate running cross-section — composes Phase 8.4
  cross-section structure with Phase 9.5 running-coupling pattern,
  giving a substrate-running scattering observable.*

  ## Why this file

  Phase 8.4 (`CrossSectionScaffold`) shipped `|M|²` for a generic
  scattering amplitude.  Phase 9.5 (`SubstrateRunningCoupling`)
  shipped the running-coupling shape `g(N) = g₀(1 + α·δ_comp(N))`.

  This file composes them: the substrate-running scattering
  amplitude

      M_subst(N) := M_IR · (1 + α · δ_comp(N))

  has squared modulus

      |M_subst(N)|² = M_IR² · (1 + α · δ_comp(N))²

  Properties shipped:

  1. Non-negativity (always true for any real M_IR — squared).
  2. Constant case at α = 0: `|M_subst(N)|² = M_IR²`.
  3. Monotone-decreasing in N for `M_IR · α ≥ 0` with `M_IR ≥ 0`.

  Physical content: the substrate cross-section flows monotonically
  to its IR-asymptote `|M_IR|²` as `N → ∞` — a substrate-QG
  prediction for scattering observables.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `runningCrossSection M_IR α N`                        | (def: `(M_IR · (1 + α · δ_comp(N)))²`)        |
  | `runningCrossSection_nonneg`                           | always non-negative                            |
  | `runningCrossSection_zero_alpha`                       | constant at α = 0                              |
  | `runningCrossSection_monotone_decreasing`              | monotone IR flow at non-neg params             |
  | Headline (3-conjunct)                                 | `substrate_running_cross_section_report`        |

  ## Honest scope

  This file ships the structural composition.  It does NOT yet:
  * Calibrate `(M_IR, α)` to any specific scattering channel.
  * Address differential cross-section dσ/dt or dσ/dΩ.
  * Compute the kinematic flux factor `1/(64π²s)`.

  ## Author

  Lion's-Pride dynamic /loop iteration 61 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.CrossSectionScaffold
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCrossSection

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.CrossSectionScaffold

/-! ## 1. Substrate running cross-section

    `|M_subst(N)|² = (M_IR · (1 + α · δ_comp(N)))²`. -/

/-- **Substrate running scattering amplitude**:
    `M_subst(N) := M_IR · (1 + α · δ_comp(N))`. -/
noncomputable def runningAmplitude (M_IR α : ℝ) (N : ℕ) : ℝ :=
  runningCoupling M_IR α N

/-- **Substrate running cross-section**: squared modulus of the
    running amplitude. -/
noncomputable def runningCrossSection (M_IR α : ℝ) (N : ℕ) : ℝ :=
  amplitudeSquared (runningAmplitude M_IR α N)

/-! ## 2. Non-negativity (always true for squared amplitude) -/

/-- **Cross-section is always non-negative**. -/
theorem runningCrossSection_nonneg (M_IR α : ℝ) (N : ℕ) :
    0 ≤ runningCrossSection M_IR α N := by
  unfold runningCrossSection
  exact amplitudeSquared_nonneg _

/-! ## 3. Constant case at α = 0 -/

/-- **Constant case at α = 0**: `|M_subst(N)|² = M_IR²` (no running). -/
theorem runningCrossSection_zero_alpha (M_IR : ℝ) (N : ℕ) :
    runningCrossSection M_IR 0 N = M_IR^2 := by
  unfold runningCrossSection runningAmplitude
  rw [runningCoupling_zero_alpha]
  unfold amplitudeSquared
  rfl

/-! ## 4. Monotone decreasing in N -/

/-- **Monotone decreasing in N**: when `M_IR ≥ 0` and `α ≥ 0`, the
    substrate cross-section is monotone-decreasing in N (substrate
    IR flow). -/
theorem runningCrossSection_monotone_decreasing
    (M_IR α : ℝ) (hM : 0 ≤ M_IR) (hα : 0 ≤ α) (N : ℕ) :
    runningCrossSection M_IR α (N + 1) ≤ runningCrossSection M_IR α N := by
  unfold runningCrossSection runningAmplitude amplitudeSquared
  -- Want: (runningCoupling M_IR α (N+1))² ≤ (runningCoupling M_IR α N)²
  -- runningCoupling M_IR α N is monotone-decreasing (Phase 9.5)
  -- and non-negative (M_IR ≥ 0, α ≥ 0)
  -- Squaring preserves order for non-negatives
  have h_le := runningCoupling_beta_eq_alpha_g0_RG_diff M_IR α N
  have h_run_N : 0 ≤ runningCoupling M_IR α N := by
    unfold runningCoupling
    have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
    have : 0 ≤ 1 + α * substrateRGScale N := by
      have : 0 ≤ α * substrateRGScale N :=
        mul_nonneg hα (le_of_lt h_pos_N)
      linarith
    exact mul_nonneg hM this
  have h_run_N1 : 0 ≤ runningCoupling M_IR α (N + 1) := by
    unfold runningCoupling
    have h_pos_N1 : 0 < substrateRGScale (N + 1) := substrateRGScale_pos (N + 1)
    have : 0 ≤ 1 + α * substrateRGScale (N + 1) := by
      have : 0 ≤ α * substrateRGScale (N + 1) :=
        mul_nonneg hα (le_of_lt h_pos_N1)
      linarith
    exact mul_nonneg hM this
  have h_run_le :
      runningCoupling M_IR α (N + 1) ≤ runningCoupling M_IR α N := by
    -- from substrateBetaFunction_eq + non-positivity
    have h_β := runningCoupling_beta_nonpos_of_nonneg_params M_IR α hM hα N
    -- β = g(N+1) - g(N) ≤ 0  ⟹  g(N+1) ≤ g(N)
    unfold substrateBetaFunction at h_β
    linarith
  -- Now: 0 ≤ a ≤ b implies a² ≤ b²  (using sq_le_sq')
  -- Use pow_le_pow_left
  have : (runningCoupling M_IR α (N + 1))^2 ≤ (runningCoupling M_IR α N)^2 := by
    -- Manual induction-free: a² ≤ b² ⟺ |a| ≤ |b| for non-neg both
    have h1 : runningCoupling M_IR α (N + 1) * runningCoupling M_IR α (N + 1)
                ≤ runningCoupling M_IR α N * runningCoupling M_IR α N := by
      exact mul_le_mul h_run_le h_run_le h_run_N1 h_run_N
    -- ^2 = · ·
    nlinarith [h1, sq_nonneg (runningCoupling M_IR α (N + 1)),
               sq_nonneg (runningCoupling M_IR α N)]
  exact this

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 8.9 headline — substrate running
    cross-section structural report.**

    For any IR-asymptote amplitude `M_IR : ℝ`, substrate sensitivity
    `α : ℝ`, and truncation depth `N : ℕ`:

    1. **Non-negativity**: `0 ≤ runningCrossSection M_IR α N`.

    2. **Constant case**: `α = 0` ⟹
       `runningCrossSection M_IR 0 N = M_IR²`.

    3. **Monotone IR flow**: `M_IR, α ≥ 0` ⟹
       `runningCrossSection M_IR α (N+1) ≤ runningCrossSection M_IR α N`. -/
theorem substrate_running_cross_section_report
    (M_IR α : ℝ) (N : ℕ) :
    0 ≤ runningCrossSection M_IR α N ∧
    runningCrossSection M_IR 0 N = M_IR^2 ∧
    (0 ≤ M_IR → 0 ≤ α →
      runningCrossSection M_IR α (N + 1)
        ≤ runningCrossSection M_IR α N) := by
  refine ⟨?_, ?_, ?_⟩
  · exact runningCrossSection_nonneg M_IR α N
  · exact runningCrossSection_zero_alpha M_IR N
  · intros hM hα
    exact runningCrossSection_monotone_decreasing M_IR α hM hα N

end OmegaTheory.QuantumGravity.SubstrateRunningCrossSection
