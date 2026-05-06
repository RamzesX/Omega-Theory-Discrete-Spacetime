/-
  OmegaTheory.Predictions.SubstrateFermionMassFiniteWindowCapstone

  **Lion's-Pride Phase 9.37 (2026-05-06)**:
  *Substrate-running fermion mass FINITE WINDOW META-CAPSTONE
  composing one substantive identity from EACH of Phase 9.35
  (IR-floor) and Phase 9.36 (UV-ceiling) into a single 3-conjunct
  theorem stating the COMPLETE substrate-RG-running window for
  the fermion mass.*

  ## Why this file

  Phase 9.35 (`SubstrateFermionMassIRFloor`) shipped:

      y_g · v ≤ m_g^subst(N).

  Phase 9.36 (`SubstrateFermionMassUVCeiling`) shipped:

      m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v.

  This file COMBINES them into the FINITE WINDOW theorem:

      y_g · v ≤ m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v.

  Plus the explicit width of this window:

      m_g^subst(N) - y_g · v ∈ [0, y_g · α_g · δ_0 · v].

  Physical content: for non-negative substrate parameters, the
  running fermion mass remains within a FINITE bounded window
  throughout the substrate-RG flow — neither runs to ∞ in UV
  nor crosses 0 in IR.  The window width is `y_g · α_g · δ_0 · v`,
  controlled by the substrate sensitivity α_g and the initial
  truncation residual δ_0.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `threeGenFermionMass_finite_window`                   | y_g·v ≤ m_g(N) ≤ y_g·(1+α_g·δ_0)·v                    |
  | `threeGenFermionMass_window_width_bound`              | m_g(N) - y_g·v ≤ y_g·α_g·δ_0·v                       |
  | Headline (3-conjunct)                                 | `substrate_fermion_mass_finite_window_report`        |

  ## Author

  Lion's-Pride dynamic /loop iteration 99 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor
import OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.SubstrateFermionMassFiniteWindowCapstone

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor
open OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling

/-! ## 1. Combined finite window -/

/-- **Substrate-running fermion mass FINITE WINDOW**:
    `y_g · v ≤ m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v` for
    non-negative parameters. -/
theorem threeGenFermionMass_finite_window
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    yIRs g * v ≤ threeGenFermionMass yIRs αs v N g ∧
    threeGenFermionMass yIRs αs v N g ≤
      yIRs g * (1 + αs g * substrateRGScale 0) * v := by
  refine ⟨?_, ?_⟩
  · exact threeGenFermionMass_ge_yIR_v yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_le_yIR_v_uv yIRs αs v N g hy hα hv

/-! ## 2. Window width upper bound -/

/-- **Window width upper bound**: the running mass deviation from
    the IR-floor is bounded by `y_g · α_g · δ_0 · v`:

        m_g^subst(N) - y_g · v ≤ y_g · α_g · δ_0 · v. -/
theorem threeGenFermionMass_window_width_bound
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    threeGenFermionMass yIRs αs v N g - yIRs g * v ≤
      yIRs g * αs g * substrateRGScale 0 * v := by
  -- m_g(N) ≤ y_g · (1 + α_g · δ_0) · v, so
  -- m_g(N) - y_g · v ≤ y_g · (1 + α_g · δ_0) · v - y_g · v
  --                 = y_g · α_g · δ_0 · v
  have h_ub : threeGenFermionMass yIRs αs v N g ≤
              yIRs g * (1 + αs g * substrateRGScale 0) * v :=
    threeGenFermionMass_le_yIR_v_uv yIRs αs v N g hy hα hv
  -- Algebra: y_g·(1+α_g·δ_0)·v - y_g·v = y_g·α_g·δ_0·v
  have h_eq : yIRs g * (1 + αs g * substrateRGScale 0) * v - yIRs g * v
              = yIRs g * αs g * substrateRGScale 0 * v := by
    ring
  linarith

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.37 headline — substrate-running fermion
    mass FINITE WINDOW structural report.**

    For non-negative IR-Yukawa values, non-negative substrate
    sensitivity, non-negative Higgs VEV, depth `N : ℕ`, and
    generation `g : Fin 3`:

    1. **IR-floor**: `y_g · v ≤ m_g^subst(N)`.

    2. **UV-ceiling**:
       `m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v`.

    3. **Window width bound**:
       `m_g^subst(N) - y_g · v ≤ y_g · α_g · δ_0 · v`. -/
theorem substrate_fermion_mass_finite_window_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    yIRs g * v ≤ threeGenFermionMass yIRs αs v N g ∧
    threeGenFermionMass yIRs αs v N g ≤
      yIRs g * (1 + αs g * substrateRGScale 0) * v ∧
    threeGenFermionMass yIRs αs v N g - yIRs g * v ≤
      yIRs g * αs g * substrateRGScale 0 * v := by
  refine ⟨?_, ?_, ?_⟩
  · exact threeGenFermionMass_ge_yIR_v yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_le_yIR_v_uv yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_window_width_bound yIRs αs v N g hy hα hv

/-! ## 4. Frozen-Nat substrate fermion-mass window snapshot -/

/-- **Substrate fermion-mass window phase count snapshot**:
    9.13 + 9.14 + 9.35 + 9.36 + 9.37 = 5 phases. -/
def substrateFermionMassWindow_phase_count : ℕ := 5

/-- **Frozen-Nat substrate fermion-mass FINITE WINDOW snapshot —
    verifiable via `decide`**. -/
theorem substrate_fermion_mass_window_snapshot :
    substrateFermionMassWindow_phase_count = 5 ∧
    substrateFermionMassWindow_phase_count ≤ 6 := by
  refine ⟨rfl, ?_⟩
  decide

end OmegaTheory.Predictions.SubstrateFermionMassFiniteWindowCapstone
