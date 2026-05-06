/-
  OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling

  **Lion's-Pride Phase 9.36 (2026-05-06)**:
  *Substrate-running fermion mass UV-ceiling: under non-negative
  IR-Yukawa, non-negative substrate sensitivity α, and non-negative
  Higgs VEV v, the running fermion mass `m_g^subst(N) := y_g^IR ·
  (1 + α_g · δ_N) · v` is bounded above by `y_g^IR · (1 + α_g · δ_0) · v`.*

  ## Why this file

  Phase 9.35 (`SubstrateFermionMassIRFloor`) shipped the IR-floor:

      y_g · v ≤ m_g^subst(N).

  This file ships the dual UV-CEILING:

      m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v.

  Combined: the running fermion mass is sandwiched between
  `y_g · v` (deep IR) and `y_g · (1 + α_g · δ_0) · v` (UV near
  N=0).  This is the FINITE substrate-running window for the
  fermion mass.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `substrateRGScale_le_zero`                             | substrateRGScale N ≤ substrateRGScale 0               |
  | `threeGenFermionMass_le_yIR_v_uv`                     | non-neg ⟹ m_g(N) ≤ y_g·(1+α_g·δ_0)·v                  |
  | Headline (2-conjunct)                                 | `substrate_fermion_mass_uv_ceiling_report`           |

  ## Author

  Lion's-Pride dynamic /loop iteration 98 (2026-05-06).
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

namespace OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateYukawaRunning
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning

/-! ## 1. substrateRGScale ≤ initial value (helper) -/

/-- **Substrate RG scale is bounded above by its initial value**:
    `substrateRGScale N ≤ substrateRGScale 0`.

    Proof by induction: base case N=0 is reflexivity; inductive step
    uses `substrateRGScale (N+1) ≤ substrateRGScale N` from
    `substrateRGScale_decreasing`. -/
theorem substrateRGScale_le_zero (N : ℕ) :
    substrateRGScale N ≤ substrateRGScale 0 := by
  induction N with
  | zero => exact le_refl _
  | succ k ih =>
    have h_step : substrateRGScale (k + 1) ≤ substrateRGScale k :=
      substrateRGScale_decreasing k
    linarith

/-! ## 2. Fermion mass UV ceiling -/

/-- **Substrate-running fermion mass UV-ceiling**: under
    non-negative parameters, `m_g(N) ≤ y_g · (1 + α_g · δ_0) · v`. -/
theorem threeGenFermionMass_le_yIR_v_uv
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    threeGenFermionMass yIRs αs v N g ≤
      yIRs g * (1 + αs g * substrateRGScale 0) * v := by
  unfold threeGenFermionMass threeGenYukawa yukawaRunning runningCoupling
  -- Goal: yIRs g * (1 + αs g * δ_N) * v ≤ yIRs g * (1 + αs g * δ_0) * v
  have h_δ_le : substrateRGScale N ≤ substrateRGScale 0 :=
    substrateRGScale_le_zero N
  have h_yv : 0 ≤ yIRs g * v := mul_nonneg hy hv
  -- α_g · δ_N ≤ α_g · δ_0
  have h_α_δ_le : αs g * substrateRGScale N ≤ αs g * substrateRGScale 0 :=
    mul_le_mul_of_nonneg_left h_δ_le hα
  -- 1 + α_g · δ_N ≤ 1 + α_g · δ_0
  have h_one_plus_le : 1 + αs g * substrateRGScale N ≤ 1 + αs g * substrateRGScale 0 := by
    linarith
  -- Multiply both sides by yIRs g · v ≥ 0 (using factorisation)
  -- yIRs g * (1 + αs g · δ_N) * v = (yIRs g * v) * (1 + αs g · δ_N)
  -- ≤ (yIRs g * v) * (1 + αs g · δ_0)
  -- = yIRs g * (1 + αs g · δ_0) * v
  nlinarith [h_yv, h_one_plus_le,
             mul_le_mul_of_nonneg_left h_one_plus_le h_yv]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.36 headline — substrate-running fermion
    mass UV-ceiling structural report.**

    For non-negative IR-Yukawa values, non-negative substrate
    sensitivity, non-negative Higgs VEV, depth `N : ℕ`, and
    generation `g : Fin 3`:

    1. **Substrate RG scale bounded by initial value**:
       `substrateRGScale N ≤ substrateRGScale 0`.

    2. **UV-ceiling upper bound**:
       `m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v`. -/
theorem substrate_fermion_mass_uv_ceiling_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v) :
    substrateRGScale N ≤ substrateRGScale 0 ∧
    threeGenFermionMass yIRs αs v N g ≤
      yIRs g * (1 + αs g * substrateRGScale 0) * v := by
  refine ⟨?_, ?_⟩
  · exact substrateRGScale_le_zero N
  · exact threeGenFermionMass_le_yIR_v_uv yIRs αs v N g hy hα hv

end OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling
