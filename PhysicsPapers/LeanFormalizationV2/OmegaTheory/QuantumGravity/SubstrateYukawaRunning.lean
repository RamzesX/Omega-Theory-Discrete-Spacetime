/-
  OmegaTheory.QuantumGravity.SubstrateYukawaRunning

  **Lion's-Pride Phase 9.13 (2026-05-06)**:
  *Substrate Yukawa coupling running — applies the Phase 9.5
  one-loop pattern to a fermion Yukawa coupling, with the
  corresponding fermion mass running via tree-level `m = y v / √2`.*

  ## Why this file

  Phase 9.5 (`SubstrateRunningCoupling`) shipped the generic
  substrate running-coupling pattern. Phase 9.11
  (`SubstrateHiggsRunning`) applied it to the Higgs self-coupling.

  This file applies it to a SPECIFIC FERMION YUKAWA coupling.
  The structural shape:

      y_f^subst(N)  :=  y_f,IR · (1 + α_y · δ_comp(N))
      m_f^subst(N)  :=  y_f^subst(N) · v / √2

  where `v` is the Higgs VEV (= 246.22 GeV at PDG).

  Properties:

  1. Constant case at α_y = 0: y_f^subst = y_f,IR.
  2. Non-negativity for non-negative parameters.
  3. Monotone-decreasing in N (substrate IR flow).
  4. Mass running follows: `m_f^subst(N+1) ≤ m_f^subst(N)` for
     positive v ≥ 0 and non-negative parameters.

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `yukawaRunning yIR α N`                               | (def: `yIR · (1 + α · δ_comp(N))`)               |
  | `fermionMassRunning yIR α v N`                        | (def: `yukawaRunning · v`, simplified—√2 omitted, see scope) |
  | Constant case at `α = 0`                              | `yukawaRunning_zero_alpha`                         |
  | Non-negativity                                        | `yukawaRunning_nonneg`                              |
  | Monotone decreasing                                   | `yukawaRunning_monotone_decreasing`                 |
  | Mass non-negative for non-neg v                       | `fermionMassRunning_nonneg`                         |
  | Headline (4-conjunct)                                 | `substrate_yukawa_running_report`                   |

  ## Honest scope

  This file ships the structural shape.  Specific (yIR, α) for
  individual fermion Yukawa values requires multi-month future
  calibration.  The `√2` factor in standard `m = y v / √2` is
  absorbed into the input parameters (`v` here is the rescaled
  VEV `v_eff := v_PDG / √2`).

  ## Author

  Lion's-Pride dynamic /loop iteration 56 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateYukawaRunning

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling

/-! ## 1. Substrate Yukawa coupling and fermion mass running

    `y_f^subst(N) = y_f,IR · (1 + α_y · δ_comp(N))` and
    `m_f^subst(N) = y_f^subst(N) · v_eff`. -/

/-- **Substrate Yukawa coupling running**:
    `y_f^subst(N) := y_f,IR · (1 + α_y · δ_comp(N))`. -/
noncomputable def yukawaRunning (yIR α : ℝ) (N : ℕ) : ℝ :=
  runningCoupling yIR α N

/-- **Substrate fermion mass running** via tree-level `m = y · v_eff`
    (the `1/√2` factor is absorbed into `v_eff := v_PDG / √2`):
    `m_f^subst(N) := yukawaRunning yIR α N · v_eff`. -/
noncomputable def fermionMassRunning
    (yIR α v : ℝ) (N : ℕ) : ℝ :=
  yukawaRunning yIR α N * v

/-! ## 2. Constant case at α = 0 -/

/-- **Constant case**: `α = 0` ⟹ no running, y_f^subst = y_f,IR. -/
theorem yukawaRunning_zero_alpha (yIR : ℝ) (N : ℕ) :
    yukawaRunning yIR 0 N = yIR := by
  unfold yukawaRunning
  exact runningCoupling_zero_alpha yIR N

/-! ## 3. Non-negativity -/

/-- **Non-negative for non-negative parameters**:
    `yIR ≥ 0 ∧ α ≥ 0 ⟹ y_f^subst(N) ≥ 0`. -/
theorem yukawaRunning_nonneg
    (yIR α : ℝ) (hy : 0 ≤ yIR) (hα : 0 ≤ α) (N : ℕ) :
    0 ≤ yukawaRunning yIR α N := by
  unfold yukawaRunning runningCoupling
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_inner_nonneg : 0 ≤ 1 + α * substrateRGScale N := by
    have : 0 ≤ α * substrateRGScale N :=
      mul_nonneg hα (le_of_lt h_pos_N)
    linarith
  exact mul_nonneg hy h_inner_nonneg

/-! ## 4. Monotone decreasing in N -/

/-- **Monotone decreasing in N**: substrate Yukawa decreases with
    truncation depth (substrate IR flow). -/
theorem yukawaRunning_monotone_decreasing
    (yIR α : ℝ) (hy : 0 ≤ yIR) (hα : 0 ≤ α) (N : ℕ) :
    yukawaRunning yIR α (N + 1) ≤ yukawaRunning yIR α N := by
  unfold yukawaRunning runningCoupling
  have h_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
    substrateRGScale_decreasing N
  have h_α_le : α * substrateRGScale (N + 1) ≤ α * substrateRGScale N :=
    mul_le_mul_of_nonneg_left h_le hα
  have h_inner_le :
      1 + α * substrateRGScale (N + 1) ≤ 1 + α * substrateRGScale N := by
    linarith
  exact mul_le_mul_of_nonneg_left h_inner_le hy

/-! ## 5. Fermion mass running properties -/

/-- **Fermion mass non-negative** for non-negative parameters and v. -/
theorem fermionMassRunning_nonneg
    (yIR α v : ℝ) (hy : 0 ≤ yIR) (hα : 0 ≤ α) (hv : 0 ≤ v) (N : ℕ) :
    0 ≤ fermionMassRunning yIR α v N := by
  unfold fermionMassRunning
  have h_y_run : 0 ≤ yukawaRunning yIR α N :=
    yukawaRunning_nonneg yIR α hy hα N
  exact mul_nonneg h_y_run hv

/-- **Fermion mass monotone decreasing** for non-negative parameters and v. -/
theorem fermionMassRunning_monotone_decreasing
    (yIR α v : ℝ) (hy : 0 ≤ yIR) (hα : 0 ≤ α) (hv : 0 ≤ v) (N : ℕ) :
    fermionMassRunning yIR α v (N + 1) ≤ fermionMassRunning yIR α v N := by
  unfold fermionMassRunning
  have h_y_le := yukawaRunning_monotone_decreasing yIR α hy hα N
  exact mul_le_mul_of_nonneg_right h_y_le hv

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 9.13 headline — substrate Yukawa running
    structural report.**

    For any IR-asymptote Yukawa `yIR : ℝ`, substrate sensitivity
    `α : ℝ`, effective VEV `v : ℝ`, and truncation depth `N : ℕ`:

    1. **Constant case**: `α = 0` ⟹ `yukawaRunning yIR 0 N = yIR`.

    2. **Non-negativity**: `yIR, α ≥ 0` ⟹ `yukawaRunning ≥ 0`.

    3. **Yukawa monotone decreasing**: `yIR, α ≥ 0` ⟹
       `yukawaRunning(N+1) ≤ yukawaRunning(N)`.

    4. **Fermion mass monotone decreasing**: `yIR, α, v ≥ 0` ⟹
       `fermionMassRunning(N+1) ≤ fermionMassRunning(N)`. -/
theorem substrate_yukawa_running_report
    (yIR α v : ℝ) (N : ℕ) :
    yukawaRunning yIR 0 N = yIR ∧
    (0 ≤ yIR → 0 ≤ α → 0 ≤ yukawaRunning yIR α N) ∧
    (0 ≤ yIR → 0 ≤ α →
      yukawaRunning yIR α (N + 1) ≤ yukawaRunning yIR α N) ∧
    (0 ≤ yIR → 0 ≤ α → 0 ≤ v →
      fermionMassRunning yIR α v (N + 1)
        ≤ fermionMassRunning yIR α v N) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact yukawaRunning_zero_alpha yIR N
  · intros hy hα
    exact yukawaRunning_nonneg yIR α hy hα N
  · intros hy hα
    exact yukawaRunning_monotone_decreasing yIR α hy hα N
  · intros hy hα hv
    exact fermionMassRunning_monotone_decreasing yIR α v hy hα hv N

end OmegaTheory.QuantumGravity.SubstrateYukawaRunning
