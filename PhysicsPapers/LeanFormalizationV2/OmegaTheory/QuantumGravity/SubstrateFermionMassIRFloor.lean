/-
  OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor

  **Lion's-Pride Phase 9.35 (2026-05-06)**:
  *Substrate-running fermion mass IR-floor: under non-negative
  IR-Yukawa, non-negative substrate sensitivity α, and non-negative
  Higgs VEV v, the running fermion mass `m_g^subst(N) := y_g^IR ·
  (1 + α_g · δ_N) · v` is bounded below by `y_g^IR · v` for all N.*

  ## Why this file

  Phase 9.13 (`SubstrateYukawaRunning`) shipped:

      yukawaRunning y α N := runningCoupling y α N
                          := y · (1 + α · substrateRGScale N).

  Phase 9.14 (`SubstrateThreeGenerationRunning`) shipped:

      threeGenFermionMass yIRs αs v N g := yukawaRunning (yIRs g) (αs g) N · v.

  Since `substrateRGScale N > 0` (Phase 9.x via `computationalUncertainty`),
  for non-negative `α_g`, `1 + α_g · δ_N ≥ 1`, hence:

      m_g(N) = y_g · (1 + α_g · δ_N) · v ≥ y_g · 1 · v = y_g · v

  for `0 ≤ y_g, v`.  This is the **IR-floor** of the running fermion
  mass — the deep-IR limit value below which the substrate-running
  trajectory cannot fall.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `threeGenFermionMass_ge_yIR_v`                        | non-neg ⟹ y_g·v ≤ m_g(N)                              |
  | `threeGenFermionMass_nonneg_of_nonneg`                | non-neg parameters ⟹ 0 ≤ m_g(N)                       |
  | Headline (2-conjunct)                                 | `substrate_fermion_mass_ir_floor_report`             |

  ## Author

  Lion's-Pride dynamic /loop iteration 97 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateYukawaRunning
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateYukawaRunning
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning

/-! ## 1. IR-floor lower bound -/

/-- **Substrate-running fermion mass IR-floor**: under non-negative
    IR-Yukawa `0 ≤ y_g`, non-negative substrate sensitivity
    `0 ≤ α_g`, and non-negative Higgs VEV `0 ≤ v`,

        y_g · v ≤ m_g^subst(N)

    for all `N : ℕ` and generation `g : Fin 3`.

    Proof: `m_g(N) = y_g · (1 + α_g · δ_N) · v` and
    `α_g · δ_N ≥ 0` (since both factors non-neg), so
    `1 + α_g · δ_N ≥ 1`, and multiplying by `y_g · v ≥ 0` preserves
    the inequality. -/
theorem threeGenFermionMass_ge_yIR_v
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    yIRs g * v ≤ threeGenFermionMass yIRs αs v N g := by
  unfold threeGenFermionMass threeGenYukawa yukawaRunning runningCoupling
  -- Goal: yIRs g · v ≤ (yIRs g · (1 + αs g · substrateRGScale N)) · v
  have h_δ : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_α_δ : 0 ≤ αs g * substrateRGScale N := mul_nonneg hα (le_of_lt h_δ)
  have h_yv : 0 ≤ yIRs g * v := mul_nonneg hy hv
  -- yIRs g · v ≤ yIRs g · v · (1 + αs g · δ_N)
  -- since 1 ≤ 1 + αs g · δ_N
  nlinarith [h_α_δ, h_yv]

/-! ## 2. Non-negativity of running mass -/

/-- **Substrate-running fermion mass non-negativity**: under
    non-negative parameters, `0 ≤ m_g^subst(N)`. -/
theorem threeGenFermionMass_nonneg_of_nonneg
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    0 ≤ threeGenFermionMass yIRs αs v N g := by
  have h1 : yIRs g * v ≤ threeGenFermionMass yIRs αs v N g :=
    threeGenFermionMass_ge_yIR_v yIRs αs v N g hy hα hv
  have h2 : 0 ≤ yIRs g * v := mul_nonneg hy hv
  linarith

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.35 headline — substrate-running fermion
    mass IR-floor structural report.**

    For non-negative IR-Yukawa values, non-negative substrate
    sensitivity, non-negative Higgs VEV, depth `N : ℕ`, and
    generation `g : Fin 3`:

    1. **IR-floor lower bound**:
       `y_g · v ≤ m_g^subst(N)`.

    2. **Non-negativity**:
       `0 ≤ m_g^subst(N)`. -/
theorem substrate_fermion_mass_ir_floor_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    yIRs g * v ≤ threeGenFermionMass yIRs αs v N g ∧
    0 ≤ threeGenFermionMass yIRs αs v N g := by
  refine ⟨?_, ?_⟩
  · exact threeGenFermionMass_ge_yIR_v yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_nonneg_of_nonneg yIRs αs v N g hy hα hv

end OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor
