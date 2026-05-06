/-
  OmegaTheory.QuantumGravity.SubstrateFermionMassExcess

  **Lion's-Pride Phase 9.39 (2026-05-06)**:
  *Substrate-running fermion mass EXCESS-above-floor: the deviation
  of the running mass from the IR-floor is `y_g · α_g · δ_N · v`,
  monotone-non-increasing in N (substrate-RG flow toward IR).*

  ## Why this file

  Phase 9.35 (`SubstrateFermionMassIRFloor`) shipped:

      y_g · v ≤ m_g^subst(N).

  Phase 9.36 (`SubstrateFermionMassUVCeiling`) shipped:

      m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v.

  This file ships the EXACT EXCESS-above-floor formula:

      m_g^subst(N) - y_g · v = y_g · α_g · δ_N · v.

  And the monotone decay of the excess as N increases (since
  δ_N is monotone non-increasing toward 0):

      m_g^subst(N+1) - y_g · v ≤ m_g^subst(N) - y_g · v.

  Physical content: the running mass approaches its IR-floor
  asymptotically; the excess above the floor decays monotonically
  with substrate truncation depth N.  The decay rate is controlled
  by the substrate residual δ_N.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `threeGenFermionMass_excess_eq`                       | m_g(N) - y_g·v = y_g·α_g·δ_N·v                       |
  | `threeGenFermionMass_excess_nonneg`                   | non-neg ⟹ 0 ≤ excess                                  |
  | `threeGenFermionMass_excess_monotone_decreasing`      | non-neg ⟹ excess(N+1) ≤ excess(N)                     |
  | Headline (3-conjunct)                                 | `substrate_fermion_mass_excess_report`               |

  ## Author

  Lion's-Pride dynamic /loop iteration 101 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateYukawaRunning
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateFermionMassExcess

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateYukawaRunning
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor

/-! ## 1. Excess-above-floor exact formula -/

/-- **Excess-above-floor exact formula**:
    `m_g^subst(N) - y_g·v = y_g · α_g · δ_N · v`. -/
theorem threeGenFermionMass_excess_eq
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3) :
    threeGenFermionMass yIRs αs v N g - yIRs g * v
      = yIRs g * αs g * substrateRGScale N * v := by
  unfold threeGenFermionMass threeGenYukawa yukawaRunning runningCoupling
  ring

/-! ## 2. Excess non-negativity -/

/-- **Excess non-negativity**: under non-negative parameters,
    `0 ≤ m_g^subst(N) - y_g · v`. -/
theorem threeGenFermionMass_excess_nonneg
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    0 ≤ threeGenFermionMass yIRs αs v N g - yIRs g * v := by
  rw [threeGenFermionMass_excess_eq]
  -- Goal: 0 ≤ y_g · α_g · δ_N · v
  have h_δ : 0 ≤ substrateRGScale N := le_of_lt (substrateRGScale_pos N)
  have h_yα : 0 ≤ yIRs g * αs g := mul_nonneg hy hα
  have h_yαδ : 0 ≤ yIRs g * αs g * substrateRGScale N := mul_nonneg h_yα h_δ
  exact mul_nonneg h_yαδ hv

/-! ## 3. Excess monotone-decreasing in N -/

/-- **Excess monotone-decreasing in N**: under non-negative
    parameters, `excess(N+1) ≤ excess(N)`. -/
theorem threeGenFermionMass_excess_monotone_decreasing
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    threeGenFermionMass yIRs αs v (N + 1) g - yIRs g * v ≤
    threeGenFermionMass yIRs αs v N g - yIRs g * v := by
  rw [threeGenFermionMass_excess_eq, threeGenFermionMass_excess_eq]
  -- Goal: y_g · α_g · δ_{N+1} · v ≤ y_g · α_g · δ_N · v
  have h_δ_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
    substrateRGScale_decreasing N
  have h_yα : 0 ≤ yIRs g * αs g := mul_nonneg hy hα
  -- Factor: (y_g · α_g) · δ_{N+1} · v ≤ (y_g · α_g) · δ_N · v
  -- Multiply δ-inequality by (y_g · α_g) ≥ 0 first:
  have h_yαδ : yIRs g * αs g * substrateRGScale (N + 1) ≤
               yIRs g * αs g * substrateRGScale N :=
    mul_le_mul_of_nonneg_left h_δ_le h_yα
  -- Then multiply by v ≥ 0:
  exact mul_le_mul_of_nonneg_right h_yαδ hv

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 9.39 headline — substrate-running fermion
    mass excess-above-floor structural report.**

    For non-negative IR-Yukawa values, non-negative substrate
    sensitivity, non-negative Higgs VEV, depth `N : ℕ`, and
    generation `g : Fin 3`:

    1. **Excess exact formula**:
       `m_g^subst(N) - y_g · v = y_g · α_g · δ_N · v`.

    2. **Excess non-negativity**:
       `0 ≤ m_g^subst(N) - y_g · v`.

    3. **Excess monotone-decreasing in N**:
       `m_g^subst(N+1) - y_g·v ≤ m_g^subst(N) - y_g·v`. -/
theorem substrate_fermion_mass_excess_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    threeGenFermionMass yIRs αs v N g - yIRs g * v
      = yIRs g * αs g * substrateRGScale N * v ∧
    0 ≤ threeGenFermionMass yIRs αs v N g - yIRs g * v ∧
    threeGenFermionMass yIRs αs v (N + 1) g - yIRs g * v ≤
      threeGenFermionMass yIRs αs v N g - yIRs g * v := by
  refine ⟨?_, ?_, ?_⟩
  · exact threeGenFermionMass_excess_eq yIRs αs v N g
  · exact threeGenFermionMass_excess_nonneg yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_excess_monotone_decreasing yIRs αs v N g hy hα hv

end OmegaTheory.QuantumGravity.SubstrateFermionMassExcess
