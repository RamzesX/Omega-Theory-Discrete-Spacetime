/-
  OmegaTheory.QuantumGravity.SubstrateKinematicThreshold

  **Lion's-Pride Phase 9.19 (2026-05-06)**:
  *Substrate kinematic threshold running — combines Phase 8.5
  Mandelstam structure with Phase 9.13 mass running: the 2-particle
  reaction threshold `s_thresh = (m_1 + m_2)²` itself runs with
  truncation depth N.*

  ## Why this file

  In SM collider physics, reactions like `e^+ e^- → μ^+ μ^-` require
  centre-of-mass energy `√s ≥ m_1 + m_2` (energy conservation +
  on-shell final state).  The threshold is `s_thresh = (m_1 + m_2)²`.

  When the masses run with the substrate truncation depth via
  Phase 9.13 (`SubstrateYukawaRunning`), the threshold also runs:

      s_thresh(N) := (m_1(N) + m_2(N))²

  with `m_g(N) = m_g,IR · (1 + α_g · δ_comp(N))`.

  Properties shipped:

  1. **Non-negativity** (always true — squared).
  2. **Constant case at α = 0**: `s_thresh(N) = (m_{1,IR} + m_{2,IR})²`.
  3. **Monotone-decreasing in N** under uniform α with non-negative
     parameters: as N → ∞, threshold DECREASES (since masses
     decrease toward IR-asymptotes).

  Physical content: substrate predicts that two-particle reaction
  thresholds SHIFT DOWN as truncation depth increases.  Reactions
  that are barely accessible at low N may become more energy-
  efficient at high N.  This is a substrate-QG signature for
  threshold collider experiments.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `kinematicThresholdRunning m1 m2 α N`                 | (def: `(m_1(N) + m_2(N))²`)                   |
  | Non-negativity                                        | `kinematicThresholdRunning_nonneg`             |
  | Constant case at α = 0                                | `kinematicThresholdRunning_zero_alpha`         |
  | Monotone decreasing under uniform α                   | `kinematicThresholdRunning_monotone_decreasing` |
  | Headline (3-conjunct)                                 | `substrate_kinematic_threshold_report`         |

  ## Honest scope

  This file ships the structural shape under UNIFORM α (Phase 9.15
  case).  It does NOT yet:
  * Address non-uniform α (would need cross-difference analysis).
  * Calibrate (m_1,IR, m_2,IR, α) for specific reactions.
  * Connect to Lorentz-invariant phase-space integration.

  ## Author

  Lion's-Pride dynamic /loop iteration 63 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateKinematicThreshold

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling

/-! ## 1. Substrate kinematic threshold running

    `s_thresh(N) = (m_1(N) + m_2(N))²` with substrate-running masses. -/

/-- **Substrate kinematic threshold running** for 2-particle final
    state with masses `m_1, m_2`:
    `s_thresh(N) := (runningCoupling m_1 α N + runningCoupling m_2 α N)²`.

    Uses uniform α (same substrate sensitivity for both masses;
    Phase 9.15 case). -/
noncomputable def kinematicThresholdRunning
    (m1_IR m2_IR α : ℝ) (N : ℕ) : ℝ :=
  (runningCoupling m1_IR α N + runningCoupling m2_IR α N)^2

/-! ## 2. Non-negativity (always true for squared) -/

/-- **Non-negativity**: substrate kinematic threshold is always
    non-negative. -/
theorem kinematicThresholdRunning_nonneg
    (m1_IR m2_IR α : ℝ) (N : ℕ) :
    0 ≤ kinematicThresholdRunning m1_IR m2_IR α N := by
  unfold kinematicThresholdRunning
  exact sq_nonneg _

/-! ## 3. Constant case at α = 0 -/

/-- **Constant case at α = 0**: `s_thresh(N) = (m_1,IR + m_2,IR)²`. -/
theorem kinematicThresholdRunning_zero_alpha
    (m1_IR m2_IR : ℝ) (N : ℕ) :
    kinematicThresholdRunning m1_IR m2_IR 0 N = (m1_IR + m2_IR)^2 := by
  unfold kinematicThresholdRunning
  rw [runningCoupling_zero_alpha, runningCoupling_zero_alpha]

/-! ## 4. Monotone decreasing in N under uniform α + non-neg masses -/

/-- **Monotone decreasing in N**: under uniform α and non-negative
    masses, the substrate kinematic threshold is monotone-decreasing.

    For `m_1, m_2, α ≥ 0`:
    `kinematicThresholdRunning m1 m2 α (N+1) ≤ kinematicThresholdRunning m1 m2 α N`. -/
theorem kinematicThresholdRunning_monotone_decreasing
    (m1_IR m2_IR α : ℝ) (N : ℕ)
    (hm1 : 0 ≤ m1_IR) (hm2 : 0 ≤ m2_IR) (hα : 0 ≤ α) :
    kinematicThresholdRunning m1_IR m2_IR α (N + 1)
      ≤ kinematicThresholdRunning m1_IR m2_IR α N := by
  unfold kinematicThresholdRunning
  -- Want: (m_1(N+1) + m_2(N+1))² ≤ (m_1(N) + m_2(N))²
  -- Both inner sums non-negative, sum at N+1 ≤ sum at N (each component ≤)
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_pos_N1 : 0 < substrateRGScale (N + 1) := substrateRGScale_pos (N + 1)
  have h_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
    substrateRGScale_decreasing N
  -- Each running mass non-negative
  have h_run_m1_N : 0 ≤ runningCoupling m1_IR α N := by
    unfold runningCoupling
    have h_inner : 0 ≤ 1 + α * substrateRGScale N := by
      have : 0 ≤ α * substrateRGScale N :=
        mul_nonneg hα (le_of_lt h_pos_N)
      linarith
    exact mul_nonneg hm1 h_inner
  have h_run_m2_N : 0 ≤ runningCoupling m2_IR α N := by
    unfold runningCoupling
    have h_inner : 0 ≤ 1 + α * substrateRGScale N := by
      have : 0 ≤ α * substrateRGScale N :=
        mul_nonneg hα (le_of_lt h_pos_N)
      linarith
    exact mul_nonneg hm2 h_inner
  have h_run_m1_N1 : 0 ≤ runningCoupling m1_IR α (N + 1) := by
    unfold runningCoupling
    have h_inner : 0 ≤ 1 + α * substrateRGScale (N + 1) := by
      have : 0 ≤ α * substrateRGScale (N + 1) :=
        mul_nonneg hα (le_of_lt h_pos_N1)
      linarith
    exact mul_nonneg hm1 h_inner
  -- Each running mass monotone-decreasing
  have h_m1_le : runningCoupling m1_IR α (N + 1) ≤ runningCoupling m1_IR α N := by
    unfold runningCoupling
    have hα_le : α * substrateRGScale (N + 1) ≤ α * substrateRGScale N :=
      mul_le_mul_of_nonneg_left h_le hα
    have h_inner_le :
        1 + α * substrateRGScale (N + 1) ≤ 1 + α * substrateRGScale N := by
      linarith
    exact mul_le_mul_of_nonneg_left h_inner_le hm1
  have h_m2_le : runningCoupling m2_IR α (N + 1) ≤ runningCoupling m2_IR α N := by
    unfold runningCoupling
    have hα_le : α * substrateRGScale (N + 1) ≤ α * substrateRGScale N :=
      mul_le_mul_of_nonneg_left h_le hα
    have h_inner_le :
        1 + α * substrateRGScale (N + 1) ≤ 1 + α * substrateRGScale N := by
      linarith
    exact mul_le_mul_of_nonneg_left h_inner_le hm2
  -- Sum at N+1 ≤ sum at N
  have h_sum_le :
      runningCoupling m1_IR α (N + 1) + runningCoupling m2_IR α (N + 1)
        ≤ runningCoupling m1_IR α N + runningCoupling m2_IR α N := by
    linarith
  -- Sum at N+1 ≥ 0 (since both components are non-negative)
  have h_run_m2_N1 : 0 ≤ runningCoupling m2_IR α (N + 1) := by
    unfold runningCoupling
    have h_inner : 0 ≤ 1 + α * substrateRGScale (N + 1) := by
      have : 0 ≤ α * substrateRGScale (N + 1) :=
        mul_nonneg hα (le_of_lt h_pos_N1)
      linarith
    exact mul_nonneg hm2 h_inner
  have h_sum_N1_nonneg :
      0 ≤ runningCoupling m1_IR α (N + 1) + runningCoupling m2_IR α (N + 1) := by
    linarith
  -- (sum_N1)² ≤ (sum_N)² for non-neg sums + sum_N1 ≤ sum_N
  -- Use mul_le_mul on the squaring
  have h_sum_N_nonneg :
      0 ≤ runningCoupling m1_IR α N + runningCoupling m2_IR α N := by
    linarith
  -- Direct: a ≥ 0, b ≥ 0, a ≤ b → a² ≤ b²
  have : (runningCoupling m1_IR α (N + 1) + runningCoupling m2_IR α (N + 1))
            * (runningCoupling m1_IR α (N + 1) + runningCoupling m2_IR α (N + 1))
        ≤ (runningCoupling m1_IR α N + runningCoupling m2_IR α N)
            * (runningCoupling m1_IR α N + runningCoupling m2_IR α N) := by
    exact mul_le_mul h_sum_le h_sum_le h_sum_N1_nonneg h_sum_N_nonneg
  nlinarith [this, sq_nonneg (runningCoupling m1_IR α (N + 1) + runningCoupling m2_IR α (N + 1)),
             sq_nonneg (runningCoupling m1_IR α N + runningCoupling m2_IR α N)]

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 9.19 headline — substrate kinematic
    threshold structural report.**

    For IR-asymptote masses `m_1,IR, m_2,IR : ℝ`, uniform substrate
    sensitivity `α : ℝ`, and truncation depth `N : ℕ`:

    1. **Non-negativity**: `0 ≤ kinematicThresholdRunning m_1 m_2 α N`.

    2. **Constant case**: `α = 0` ⟹ `s_thresh(N) = (m_1 + m_2)²`.

    3. **Monotone decreasing**: `m_1, m_2, α ≥ 0` ⟹
       `s_thresh(N+1) ≤ s_thresh(N)` (substrate IR flow). -/
theorem substrate_kinematic_threshold_report
    (m1_IR m2_IR α : ℝ) (N : ℕ) :
    0 ≤ kinematicThresholdRunning m1_IR m2_IR α N ∧
    kinematicThresholdRunning m1_IR m2_IR 0 N = (m1_IR + m2_IR)^2 ∧
    (0 ≤ m1_IR → 0 ≤ m2_IR → 0 ≤ α →
      kinematicThresholdRunning m1_IR m2_IR α (N + 1)
        ≤ kinematicThresholdRunning m1_IR m2_IR α N) := by
  refine ⟨?_, ?_, ?_⟩
  · exact kinematicThresholdRunning_nonneg m1_IR m2_IR α N
  · exact kinematicThresholdRunning_zero_alpha m1_IR m2_IR N
  · intros hm1 hm2 hα
    exact kinematicThresholdRunning_monotone_decreasing m1_IR m2_IR α N hm1 hm2 hα

end OmegaTheory.QuantumGravity.SubstrateKinematicThreshold
