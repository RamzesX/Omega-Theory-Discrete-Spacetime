/-
  OmegaTheory.QuantumGravity.SubstratePiHunchGeneralCrossDifference

  **Lion's-Pride Phase 9.27 (2026-05-06)**:
  *Substrate Pi-Hunch GENERAL cross-difference — parameterised by
  ANY pair `g₁, g₂` with `αs g₁ < αs g₂`. Generalises Phase 9.23
  (adjacent (0,1) and (1,2)) and Phase 9.25 (transitive (0,2))
  into one universal sign theorem.*

  ## Why this file

  Phase 9.16 (`SubstrateNonUniformAlpha`) shipped the
  cross-difference identity:

      m_g₁(N+1)·m_g₂(N) - m_g₁(N)·m_g₂(N+1)
        = y_g₁,IR · y_g₂,IR · v² · (αs g₁ - αs g₂) · (δ_{N+1} - δ_N)

  Phase 9.23 + 9.25 combined to ship sign theorems at the THREE
  specific pairs (0,1), (1,2), (0,2) under Pi-Hunch ordering.

  This file ships the GENERAL theorem: for ANY pair `g₁, g₂` with
  `αs g₁ < αs g₂` (regardless of whether they're adjacent or
  transitive), the cross-difference is `≥ 0`.

  This is a UNIVERSAL substrate-QG sign prediction: in any
  non-uniform-α regime where one generation has smaller substrate
  sensitivity, the lighter generation's mass declines RELATIVELY
  SLOWER than the heavier generation's mass with substrate
  truncation depth N.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `pi_hunch_general_cross_difference_nonneg`            | universal sign theorem (any g₁, g₂ with αs g₁ < αs g₂) |
  | Headline (1-conjunct)                                 | `substrate_pi_hunch_general_cross_difference_report`  |

  ## Honest scope

  This file ships the general statement parameterised by an
  arbitrary pair `g₁, g₂ : Fin 3`.  The three specific pairs
  (0,1), (1,2), (0,2) under Pi-Hunch follow as corollaries.

  ## Author

  Lion's-Pride dynamic /loop iteration 78 (2026-05-06).
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

namespace OmegaTheory.QuantumGravity.SubstratePiHunchGeneralCrossDifference

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
open OmegaTheory.QuantumGravity.SubstratePiHunchOrdering

/-! ## 1. General Pi-Hunch cross-difference theorem -/

/-- **GENERAL Pi-Hunch cross-difference**: for ANY pair `g₁, g₂ : Fin 3`
    with `αs g₁ < αs g₂` and non-negative IR-Yukawa values
    `0 ≤ yIRs g₁` and `0 ≤ yIRs g₂`, the cross-difference is `≥ 0`:

        m_g₁(N+1) · m_g₂(N) - m_g₁(N) · m_g₂(N+1)  ≥  0.

    Generalises Phase 9.23's `_at_g0_g1`, `_at_g1_g2` and Phase 9.25's
    `_at_g0_g2` to arbitrary index pairs.  The proof is structurally
    identical: cross-difference identity ⟹ sign of
    `(αs g₁ - αs g₂) · (δ_{N+1} - δ_N)` ⟹ ≥ 0 since both factors
    are non-positive. -/
theorem pi_hunch_general_cross_difference_nonneg
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (g₁ g₂ : Fin 3)
    (h_α_lt : αs g₁ < αs g₂)
    (hy1 : 0 ≤ yIRs g₁) (hy2 : 0 ≤ yIRs g₂) :
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) g₁
          * threeGenFermionMass yIRs αs v N g₂
        - threeGenFermionMass yIRs αs v N g₁
          * threeGenFermionMass yIRs αs v (N + 1) g₂ := by
  rw [mass_cross_difference_identity]
  -- Goal: 0 ≤ yIRs g₁ · yIRs g₂ · v² · (αs g₁ - αs g₂) · (δ_{N+1} - δ_N)
  have h_α_neg : αs g₁ - αs g₂ < 0 := by linarith
  have h_δ_diff_le : substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_y_prod : 0 ≤ yIRs g₁ * yIRs g₂ := mul_nonneg hy1 hy2
  have h_v_sq : 0 ≤ v^2 := sq_nonneg v
  have h_y_v_sq : 0 ≤ yIRs g₁ * yIRs g₂ * v^2 := mul_nonneg h_y_prod h_v_sq
  -- Product: (≥0) · (<0) · (≤0) ≥ 0
  nlinarith [h_y_v_sq, h_α_neg, h_δ_diff_le,
             mul_nonpos_of_nonneg_of_nonpos h_y_v_sq (le_of_lt h_α_neg)]

/-! ## 2. Pi-Hunch corollary: under strict ordering, all 3 pairs ≥ 0 -/

/-- **Pi-Hunch all-pairs corollary**: under `IsStrictlyOrderedAlpha`,
    the general theorem yields `≥ 0` at ALL THREE pairs (0,1), (1,2),
    (0,2) directly. -/
theorem pi_hunch_strict_ordering_all_pairs
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy1 : 0 ≤ yIRs 1) (hy2 : 0 ≤ yIRs 2) :
    -- (g₁=0, g₂=1) — adjacent
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 1
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 1 ∧
    -- (g₁=1, g₂=2) — adjacent
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 1
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 1
          * threeGenFermionMass yIRs αs v (N + 1) 2 ∧
    -- (g₁=0, g₂=2) — transitive
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 2 := by
  obtain ⟨h01, h12⟩ := h_ord
  refine ⟨?_, ?_, ?_⟩
  · exact pi_hunch_general_cross_difference_nonneg yIRs αs v N 0 1 h01 hy0 hy1
  · exact pi_hunch_general_cross_difference_nonneg yIRs αs v N 1 2 h12 hy1 hy2
  · -- transitive: αs 0 < αs 2 from h01 + h12 transitivity
    have h02 : αs 0 < αs 2 := lt_trans h01 h12
    exact pi_hunch_general_cross_difference_nonneg yIRs αs v N 0 2 h02 hy0 hy2

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.27 headline — substrate Pi-Hunch general
    cross-difference structural report.**

    For Pi-Hunch ordered substrate sensitivities, non-negative
    IR-Yukawa values, Higgs VEV `v : ℝ`, truncation depth `N : ℕ`,
    and ANY pair `g₁, g₂ : Fin 3` with `αs g₁ < αs g₂`:

    1. **General cross-difference** ≥ 0 at any (g₁, g₂) with αs g₁ < αs g₂.

    2. **All three Pi-Hunch pairs** ≥ 0 simultaneously (corollary of (1)). -/
theorem substrate_pi_hunch_general_cross_difference_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (g₁ g₂ : Fin 3)
    (h_α_lt : αs g₁ < αs g₂)
    (hy1 : 0 ≤ yIRs g₁) (hy2 : 0 ≤ yIRs g₂)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy1' : 0 ≤ yIRs 1) (hy2' : 0 ≤ yIRs 2) :
    -- (1) General theorem
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) g₁
          * threeGenFermionMass yIRs αs v N g₂
        - threeGenFermionMass yIRs αs v N g₁
          * threeGenFermionMass yIRs αs v (N + 1) g₂ ∧
    -- (2) All three Pi-Hunch pairs simultaneously
    (0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
            * threeGenFermionMass yIRs αs v N 1
          - threeGenFermionMass yIRs αs v N 0
            * threeGenFermionMass yIRs αs v (N + 1) 1 ∧
     0 ≤ threeGenFermionMass yIRs αs v (N + 1) 1
            * threeGenFermionMass yIRs αs v N 2
          - threeGenFermionMass yIRs αs v N 1
            * threeGenFermionMass yIRs αs v (N + 1) 2 ∧
     0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
            * threeGenFermionMass yIRs αs v N 2
          - threeGenFermionMass yIRs αs v N 0
            * threeGenFermionMass yIRs αs v (N + 1) 2) := by
  refine ⟨?_, ?_⟩
  · exact pi_hunch_general_cross_difference_nonneg yIRs αs v N g₁ g₂ h_α_lt hy1 hy2
  · exact pi_hunch_strict_ordering_all_pairs yIRs αs v N h_ord hy0 hy1' hy2'

end OmegaTheory.QuantumGravity.SubstratePiHunchGeneralCrossDifference
