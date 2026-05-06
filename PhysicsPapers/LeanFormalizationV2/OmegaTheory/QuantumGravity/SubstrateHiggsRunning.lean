/-
  OmegaTheory.QuantumGravity.SubstrateHiggsRunning

  **Lion's-Pride Phase 9.11 (2026-05-06)**:
  *Substrate Higgs self-coupling running — applies the Phase 9.5
  one-loop running-coupling pattern to the SM Higgs self-coupling
  `lamH`, with the corresponding Higgs squared-mass running.*

  ## Why this file

  Phase 9.5 (`SubstrateRunningCoupling`) shipped the generic
  one-loop substrate running coupling shape `g(N) = g₀(1 + α·δ_comp(N))`.

  This file specialises that pattern to the SM Higgs self-coupling
  `lamH` and applies the standard tree-level relation `m_H² = 2 lamH v²`
  to compute the corresponding Higgs squared-mass running.

  Definitions:

      lamH^subst(N)  :=  lamH,IR · (1 + α_λ · δ_comp(N))
      m_H²^subst(N)  :=  2 · lamH^subst(N) · v²

  where:
  * `lamH,IR : ℝ` — IR-asymptote Higgs self-coupling (≈ 0.129 at
    PDG with v = 246.22 GeV, m_H = 125.10 GeV, but calibration is
    multi-month deferred work).
  * `α_λ : ℝ` — substrate sensitivity parameter for the Higgs
    sector.
  * `v : ℝ` — Higgs VEV (= 246.22 GeV at PDG, treated as input
    parameter here).

  Properties shipped:

  1. Non-negativity for non-negative parameters (`lamH,IR, α_λ ≥ 0`).
  2. Monotone-decreasing in N (substrate IR flow).
  3. The squared-mass `m_H²^subst(N)` inherits these properties
     when `v ≠ 0` (multiplied by `v² ≥ 0`).
  4. At `α_λ = 0`: lamH^subst(N) = lamH,IR (constant, no running).

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `higgsSelfCouplingRunning lamIR α N`                    | (def: `lamIR · (1 + α · δ_comp(N))`)               |
  | `higgsSquaredMassRunning lamIR α v N`                   | (def: `2 · lamH^subst(N) · v²`)                   |
  | Constant case at `α = 0`                              | `higgsSelfCouplingRunning_zero_alpha`              |
  | Non-negativity                                         | `higgsSelfCouplingRunning_nonneg`                  |
  | Monotone decreasing in N                              | `higgsSelfCouplingRunning_monotone_decreasing`      |
  | Squared-mass non-negative                              | `higgsSquaredMassRunning_nonneg`                    |
  | Headline (4-conjunct)                                 | `substrate_higgs_running_report`                    |

  ## Honest scope

  This file ships the STRUCTURAL substrate-running shape for the
  Higgs self-coupling and squared mass.  It does NOT yet:
  * Calibrate `(lamH,IR, α_λ)` to PDG values.
  * Address radiative corrections from top-quark Yukawa loops
    (which dominate the SM running).
  * Connect to Higgs VEV running (would need substrate-running
    on `v` too).
  * Compute the SM Higgs vacuum-stability prediction.

  What it DOES ship: a substrate-physics application of the
  running-coupling tower to a specific observable (Higgs sector),
  with monotone-IR-flow guarantee.

  ## Author

  Lion's-Pride dynamic /loop iteration 54 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateHiggsRunning

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling

/-! ## 1. Substrate Higgs self-coupling and squared-mass

    `lamH^subst(N) = lamH,IR · (1 + α_λ · δ_comp(N))` and
    `m_H²^subst(N) = 2 · lamH^subst(N) · v²`. -/

/-- **Substrate Higgs self-coupling running**:
    `lamH^subst(N) := lamH,IR · (1 + α_λ · δ_comp(N))`.
    Specialisation of `SubstrateRunningCoupling.runningCoupling`. -/
noncomputable def higgsSelfCouplingRunning (lamIR α : ℝ) (N : ℕ) : ℝ :=
  runningCoupling lamIR α N

/-- **Substrate Higgs squared-mass running** via tree-level
    `m_H² = 2 lamH v²`:
    `m_H²^subst(N) := 2 · lamH^subst(N) · v²`. -/
noncomputable def higgsSquaredMassRunning
    (lamIR α v : ℝ) (N : ℕ) : ℝ :=
  2 * higgsSelfCouplingRunning lamIR α N * v^2

/-! ## 2. Constant case at α = 0 -/

/-- **Constant case**: `α = 0` ⟹ no running, lamH^subst(N) = lamH,IR. -/
theorem higgsSelfCouplingRunning_zero_alpha (lamIR : ℝ) (N : ℕ) :
    higgsSelfCouplingRunning lamIR 0 N = lamIR := by
  unfold higgsSelfCouplingRunning
  exact runningCoupling_zero_alpha lamIR N

/-! ## 3. Non-negativity -/

/-- **Non-negative for non-negative parameters**:
    `lamIR ≥ 0 ∧ α ≥ 0 ⟹ lamH^subst(N) ≥ 0`. -/
theorem higgsSelfCouplingRunning_nonneg
    (lamIR α : ℝ) (hL : 0 ≤ lamIR) (hα : 0 ≤ α) (N : ℕ) :
    0 ≤ higgsSelfCouplingRunning lamIR α N := by
  unfold higgsSelfCouplingRunning runningCoupling
  -- Want: 0 ≤ lamIR · (1 + α · substrateRGScale N)
  -- inner factor ≥ 1 (since α ≥ 0 and δ ≥ 0); lamIR ≥ 0; product ≥ 0
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_inner_ge_1 : 1 ≤ 1 + α * substrateRGScale N := by
    have : 0 ≤ α * substrateRGScale N :=
      mul_nonneg hα (le_of_lt h_pos_N)
    linarith
  have h_inner_nonneg : 0 ≤ 1 + α * substrateRGScale N := by linarith
  exact mul_nonneg hL h_inner_nonneg

/-! ## 4. Monotone decreasing in N -/

/-- **Monotone decreasing in N**: substrate Higgs self-coupling
    decreases with truncation depth (substrate IR flow).

    For `lamIR ≥ 0, α ≥ 0`:
    `higgsSelfCouplingRunning lamIR α (N+1) ≤ higgsSelfCouplingRunning lamIR α N`. -/
theorem higgsSelfCouplingRunning_monotone_decreasing
    (lamIR α : ℝ) (hL : 0 ≤ lamIR) (hα : 0 ≤ α) (N : ℕ) :
    higgsSelfCouplingRunning lamIR α (N + 1)
      ≤ higgsSelfCouplingRunning lamIR α N := by
  unfold higgsSelfCouplingRunning runningCoupling
  -- Want: lamIR · (1 + α · δ_{N+1}) ≤ lamIR · (1 + α · δ_N)
  -- δ_{N+1} ≤ δ_N ⟹ α · δ_{N+1} ≤ α · δ_N ⟹ 1+... ≤ 1+...
  -- Multiply by lamIR ≥ 0
  have h_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
    substrateRGScale_decreasing N
  have h_α_le : α * substrateRGScale (N + 1) ≤ α * substrateRGScale N :=
    mul_le_mul_of_nonneg_left h_le hα
  have h_inner_le :
      1 + α * substrateRGScale (N + 1) ≤ 1 + α * substrateRGScale N := by
    linarith
  exact mul_le_mul_of_nonneg_left h_inner_le hL

/-! ## 5. Squared-mass non-negativity -/

/-- **Higgs squared-mass non-negative**: when `lamIR, α ≥ 0`,
    `m_H²^subst(N) ≥ 0` for any real `v`. -/
theorem higgsSquaredMassRunning_nonneg
    (lamIR α v : ℝ) (hL : 0 ≤ lamIR) (hα : 0 ≤ α) (N : ℕ) :
    0 ≤ higgsSquaredMassRunning lamIR α v N := by
  unfold higgsSquaredMassRunning
  have h_L_run : 0 ≤ higgsSelfCouplingRunning lamIR α N :=
    higgsSelfCouplingRunning_nonneg lamIR α hL hα N
  have h_v_sq : 0 ≤ v^2 := sq_nonneg v
  have h_2_L_run : 0 ≤ 2 * higgsSelfCouplingRunning lamIR α N := by linarith
  exact mul_nonneg h_2_L_run h_v_sq

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 9.11 headline — substrate Higgs running
    structural report.**

    For any IR-asymptote Higgs self-coupling `lamIR : ℝ`, substrate
    sensitivity `α : ℝ`, Higgs VEV `v : ℝ`, and truncation depth
    `N : ℕ`:

    1. **Constant case**: `α = 0` ⟹ `lamH^subst(N) = lamIR`.

    2. **Non-negativity**: `lamIR, α ≥ 0` ⟹ `lamH^subst(N) ≥ 0`.

    3. **Monotone decreasing**: `lamIR, α ≥ 0` ⟹
       `lamH^subst(N+1) ≤ lamH^subst(N)`.

    4. **Squared-mass non-negative**: `lamIR, α ≥ 0` ⟹
       `m_H²^subst(N) ≥ 0` for any v. -/
theorem substrate_higgs_running_report
    (lamIR α v : ℝ) (N : ℕ) :
    higgsSelfCouplingRunning lamIR 0 N = lamIR ∧
    (0 ≤ lamIR → 0 ≤ α → 0 ≤ higgsSelfCouplingRunning lamIR α N) ∧
    (0 ≤ lamIR → 0 ≤ α →
      higgsSelfCouplingRunning lamIR α (N + 1)
        ≤ higgsSelfCouplingRunning lamIR α N) ∧
    (0 ≤ lamIR → 0 ≤ α → 0 ≤ higgsSquaredMassRunning lamIR α v N) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact higgsSelfCouplingRunning_zero_alpha lamIR N
  · intros hL hα
    exact higgsSelfCouplingRunning_nonneg lamIR α hL hα N
  · intros hL hα
    exact higgsSelfCouplingRunning_monotone_decreasing lamIR α hL hα N
  · intros hL hα
    exact higgsSquaredMassRunning_nonneg lamIR α v hL hα N

end OmegaTheory.QuantumGravity.SubstrateHiggsRunning
