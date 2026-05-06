/-
  OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference

  **Lion's-Pride Phase 9.23 (2026-05-06)**:
  *Substrate Pi-Hunch cross-difference sign — combines Phase 9.22
  Pi-Hunch ordering with Phase 9.16 cross-difference identity to
  give a falsifiable substrate-running prediction: under Pi-Hunch
  ordering, the lighter generation's mass declines SLOWER than the
  heavier generation's mass with truncation depth N.*

  ## Why this file

  Phase 9.22 (`SubstratePiHunchOrdering`) shipped the structural
  predicate `IsStrictlyOrderedAlpha αs := αs 0 < αs 1 < αs 2`.

  Phase 9.16 (`SubstrateNonUniformAlpha`) shipped the cross-difference
  identity:

      m_g₁(N+1)·m_g₂(N) - m_g₁(N)·m_g₂(N+1)
        = yIRs g₁ · yIRs g₂ · v² · (αs g₁ - αs g₂) · (δ_{N+1} - δ_N)

  This file COMBINES them: under Pi-Hunch ordering with `g₁ < g₂`
  (in ordinal, i.e., g₁ is the lighter generation), the cross-
  difference is `≥ 0` for non-negative IR-Yukawa values.  This
  means:

      m_g₁(N+1)·m_g₂(N) ≥ m_g₁(N)·m_g₂(N+1)

  Equivalently, the ratio `m_g₁(N+1)/m_g₁(N) ≥ m_g₂(N+1)/m_g₂(N)`,
  i.e., the LIGHTER generation's mass declines SLOWER (relatively)
  than the HEAVIER generation's mass with substrate truncation N.

  Physical content: under Pi-Hunch (gen 1 ↔ √2 fast convergence,
  gen 3 ↔ π slow convergence), lighter fermions are RELATIVELY
  less affected by substrate truncation than heavier ones.  This
  is a falsifiable substrate-QG prediction:

  * If observed precision measurements show that fermion mass
    ratios (m_e/m_τ, m_u/m_t etc.) show DECREASING relative
    sensitivity to scale at higher precision, this is consistent
    with Pi-Hunch.
  * If they show INCREASING relative sensitivity, Pi-Hunch is
    contradicted (substrate must be uniform-α or anti-Pi-Hunch).

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `pi_hunch_cross_difference_nonneg_at_g0_g1`           | (g₁=0, g₂=1) cross-difference ≥ 0              |
  | `pi_hunch_cross_difference_nonneg_at_g1_g2`           | (g₁=1, g₂=2) cross-difference ≥ 0              |
  | Headline (2-conjunct)                                 | `substrate_pi_hunch_cross_difference_report`    |

  ## Honest scope

  This file ships TWO specific cross-difference sign theorems
  (g₁=0/g₂=1 and g₁=1/g₂=2).  The general (g₁, g₂) case follows
  by transitivity but I don't ship it here for brevity.

  ## Author

  Lion's-Pride dynamic /loop iteration 69 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
import OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
open OmegaTheory.QuantumGravity.SubstratePiHunchOrdering

/-! ## 1. Pi-Hunch cross-difference at (g₁=0, g₂=1) -/

/-- **Pi-Hunch cross-difference at (g₁=0, g₂=1)**: under Pi-Hunch
    ordering and non-negative IR-Yukawa values, the cross-difference
    `m_0(N+1)·m_1(N) - m_0(N)·m_1(N+1) ≥ 0`. -/
theorem pi_hunch_cross_difference_nonneg_at_g0_g1
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy1 : 0 ≤ yIRs 1) :
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 1
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 1 := by
  -- Use cross-difference identity
  rw [mass_cross_difference_identity]
  -- Goal: 0 ≤ yIRs 0 · yIRs 1 · v² · (αs 0 - αs 1) · (δ_{N+1} - δ_N)
  obtain ⟨h01, _⟩ := h_ord
  -- αs 0 < αs 1 ⟹ αs 0 - αs 1 < 0
  have h_α_neg : αs 0 - αs 1 < 0 := by linarith
  have h_δ_diff_le : substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_y_prod : 0 ≤ yIRs 0 * yIRs 1 := mul_nonneg hy0 hy1
  have h_v_sq : 0 ≤ v^2 := sq_nonneg v
  have h_y_v_sq : 0 ≤ yIRs 0 * yIRs 1 * v^2 := mul_nonneg h_y_prod h_v_sq
  -- Product: (≥0) · (<0) · (≤0) ≥ 0
  -- (yIRs 0 * yIRs 1 * v²) * (αs 0 - αs 1) ≤ 0  (non-neg × neg)
  -- (yIRs 0 * yIRs 1 * v²) * (αs 0 - αs 1) * (δ_{N+1} - δ_N) ≥ 0  (≤0 × ≤0)
  nlinarith [h_y_v_sq, h_α_neg, h_δ_diff_le,
             mul_nonpos_of_nonneg_of_nonpos h_y_v_sq (le_of_lt h_α_neg)]

/-! ## 2. Pi-Hunch cross-difference at (g₁=1, g₂=2) -/

/-- **Pi-Hunch cross-difference at (g₁=1, g₂=2)**: same shape as
    the (0, 1) case, by Pi-Hunch ordering's αs 1 < αs 2. -/
theorem pi_hunch_cross_difference_nonneg_at_g1_g2
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy1 : 0 ≤ yIRs 1) (hy2 : 0 ≤ yIRs 2) :
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 1
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 1
          * threeGenFermionMass yIRs αs v (N + 1) 2 := by
  rw [mass_cross_difference_identity]
  obtain ⟨_, h12⟩ := h_ord
  have h_α_neg : αs 1 - αs 2 < 0 := by linarith
  have h_δ_diff_le : substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_y_prod : 0 ≤ yIRs 1 * yIRs 2 := mul_nonneg hy1 hy2
  have h_v_sq : 0 ≤ v^2 := sq_nonneg v
  have h_y_v_sq : 0 ≤ yIRs 1 * yIRs 2 * v^2 := mul_nonneg h_y_prod h_v_sq
  nlinarith [h_y_v_sq, h_α_neg, h_δ_diff_le,
             mul_nonpos_of_nonneg_of_nonpos h_y_v_sq (le_of_lt h_α_neg)]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.23 headline — substrate Pi-Hunch cross-
    difference structural report.**

    For Pi-Hunch ordered substrate sensitivities, non-negative
    IR-Yukawa values, Higgs VEV `v : ℝ`, and truncation depth `N : ℕ`:

    1. **Cross-difference at (g₁=0, g₂=1)**: ≥ 0.

    2. **Cross-difference at (g₁=1, g₂=2)**: ≥ 0. -/
theorem substrate_pi_hunch_cross_difference_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy1 : 0 ≤ yIRs 1) (hy2 : 0 ≤ yIRs 2) :
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 1
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 1 ∧
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 1
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 1
          * threeGenFermionMass yIRs αs v (N + 1) 2 := by
  refine ⟨?_, ?_⟩
  · exact pi_hunch_cross_difference_nonneg_at_g0_g1 yIRs αs v N h_ord hy0 hy1
  · exact pi_hunch_cross_difference_nonneg_at_g1_g2 yIRs αs v N h_ord hy1 hy2

end OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference
