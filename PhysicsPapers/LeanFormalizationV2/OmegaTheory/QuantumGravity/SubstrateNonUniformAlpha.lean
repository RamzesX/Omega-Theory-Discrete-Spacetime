/-
  OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha

  **Lion's-Pride Phase 9.16 (2026-05-06)**:
  *Substrate non-uniform α mass-ratio shift — complement to
  Phase 9.15: when substrate sensitivities `α_g` differ across
  generations, mass ratios CHANGE with truncation depth N
  according to a clean cross-difference identity.*

  ## Why this file

  Phase 9.15 (`SubstrateMassRatioInvariance`) showed that under
  uniform α (same `α` for all three generations), the fermion-mass
  ratios are SCALE-INVARIANT in N.

  This file ships the COMPLEMENT: under NON-UNIFORM α
  (`α_g₁ ≠ α_g₂`), mass ratios SHIFT.  The shift is captured by
  the cross-difference identity:

      m_g₁(N+1) · m_g₂(N) - m_g₁(N) · m_g₂(N+1)
        = y_g₁,IR · y_g₂,IR · v² · (α_g₁ - α_g₂) · (δ_{N+1} - δ_N)

  Sign analysis:
  * If `α_g₁ > α_g₂`, since `δ_{N+1} - δ_N ≤ 0`, the cross-difference
    is `≤ 0`, meaning `m_g₁/m_g₂` DECREASES from N to N+1.
  * If `α_g₁ < α_g₂`, the cross-difference is `≥ 0`, meaning
    `m_g₁/m_g₂` INCREASES from N to N+1.
  * If `α_g₁ = α_g₂`, the cross-difference is exactly 0 — Phase 9.15.

  Pi-Hunch connection: the substrate hypothesis that
  `gen 1 ↔ √2, gen 2 ↔ e, gen 3 ↔ π` predicts non-uniform α per
  generation (different irrationals → different convergence rates →
  different `α_g`).  Under this hypothesis, mass ratios SHIFT with
  truncation depth, and the direction of shift is set by the relative
  ordering of `α_g`.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `mass_cross_difference_identity`                      | the clean algebraic cross-difference          |
  | `mass_cross_difference_zero_iff_equal_alpha`          | uniform α ⟹ zero cross-difference (Phase 9.15) |
  | `mass_cross_difference_sign_under_alpha_diff`         | sign analysis under non-uniform α              |
  | Headline (3-conjunct)                                 | `substrate_non_uniform_alpha_report`           |

  ## Honest scope

  This file ships the cross-difference IDENTITY.  It does NOT yet:
  * Quantify the "amount of shift" — would need explicit Δ_N
    computation.
  * Identify (α_g₁, α_g₂, α_g₃) with substrate-derived irrational
    convergence rates (multi-month future).
  * Compare to observed CKM/PMNS or fermion-mass running rates
    (calibration deferred).

  ## Author

  Lion's-Pride dynamic /loop iteration 59 (2026-05-06).
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

namespace OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateYukawaRunning
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning

/-! ## 1. Mass cross-difference identity

    `m_g₁(N+1)·m_g₂(N) - m_g₁(N)·m_g₂(N+1) =
        y_g₁,IR · y_g₂,IR · v² · (α_g₁ - α_g₂) · (δ_{N+1} - δ_N)`. -/

/-- **Cross-difference identity**: the cross-difference between
    fermion masses at consecutive truncation depths factors cleanly
    in terms of `(α_g₁ - α_g₂) · (δ_{N+1} - δ_N)`. -/
theorem mass_cross_difference_identity
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g1 g2 : Fin 3) :
    threeGenFermionMass yIRs αs v (N + 1) g1
        * threeGenFermionMass yIRs αs v N g2
      - threeGenFermionMass yIRs αs v N g1
        * threeGenFermionMass yIRs αs v (N + 1) g2
      = yIRs g1 * yIRs g2 * v^2
        * (αs g1 - αs g2)
        * (substrateRGScale (N + 1) - substrateRGScale N) := by
  unfold threeGenFermionMass threeGenYukawa yukawaRunning runningCoupling
  ring

/-! ## 2. Uniform-α corollary: cross-difference is zero -/

/-- **Uniform-α corollary**: when `α_g₁ = α_g₂`, the cross-difference
    is exactly zero (recovers Phase 9.15 mass-ratio invariance). -/
theorem mass_cross_difference_zero_iff_equal_alpha
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g1 g2 : Fin 3)
    (h_eq : αs g1 = αs g2) :
    threeGenFermionMass yIRs αs v (N + 1) g1
        * threeGenFermionMass yIRs αs v N g2
      = threeGenFermionMass yIRs αs v N g1
        * threeGenFermionMass yIRs αs v (N + 1) g2 := by
  have h := mass_cross_difference_identity yIRs αs v N g1 g2
  rw [h_eq] at h
  -- h: ... = ... * (αs g2 - αs g2) * ... = 0 * ... = 0
  -- so LHS - RHS = 0 ⟹ LHS = RHS
  have h_zero : αs g2 - αs g2 = 0 := by ring
  rw [h_zero] at h
  -- h: ... - ... = ... * 0 * ... = 0
  linarith [h]

/-! ## 3. Sign of cross-difference under α-difference

    Direction of mass-ratio shift is set by sign of (α_g₁ - α_g₂). -/

/-- **Sign analysis under α-difference**: when `α_g₁ > α_g₂`,
    `y_g₁,IR ≥ 0`, `y_g₂,IR ≥ 0`, `v² ≥ 0` (always true), the
    cross-difference is `≤ 0` (since `δ_{N+1} - δ_N ≤ 0`). -/
theorem mass_cross_difference_sign_under_alpha_diff
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g1 g2 : Fin 3)
    (h_y1 : 0 ≤ yIRs g1) (h_y2 : 0 ≤ yIRs g2)
    (h_α : αs g2 ≤ αs g1) :
    threeGenFermionMass yIRs αs v (N + 1) g1
        * threeGenFermionMass yIRs αs v N g2
      ≤ threeGenFermionMass yIRs αs v N g1
        * threeGenFermionMass yIRs αs v (N + 1) g2 := by
  have h := mass_cross_difference_identity yIRs αs v N g1 g2
  -- Want LHS ≤ RHS, i.e., LHS - RHS ≤ 0
  -- h says LHS - RHS = y1·y2·v²·(α1 - α2)·(δ_{N+1} - δ_N)
  --   ≥ 0 component: y1·y2·v² (= ≥ 0)
  --   ≥ 0 component: (α1 - α2) (since α1 ≥ α2)
  --   ≤ 0 component: (δ_{N+1} - δ_N)  (Phase 9.3 monotone decreasing)
  -- product: (≥0) · (≥0) · (≤0) = ≤ 0
  have h_y_prod : 0 ≤ yIRs g1 * yIRs g2 := mul_nonneg h_y1 h_y2
  have h_v_sq : 0 ≤ v^2 := sq_nonneg v
  have h_y_v_sq : 0 ≤ yIRs g1 * yIRs g2 * v^2 := mul_nonneg h_y_prod h_v_sq
  have h_α_diff : 0 ≤ αs g1 - αs g2 := by linarith
  have h_δ_diff_le : substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  -- LHS - RHS = h_y_v_sq · h_α_diff · h_δ_diff_le ≤ 0
  -- product of (≥0)·(≥0)·(≤0) = (≤0)
  nlinarith [h, h_y_v_sq, h_α_diff, h_δ_diff_le,
             mul_nonneg h_y_v_sq h_α_diff]

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 9.16 headline — substrate non-uniform α
    mass-ratio shift structural report.**

    For any IR-Yukawa values `yIRs : Fin 3 → ℝ`, substrate
    sensitivities `αs : Fin 3 → ℝ`, Higgs VEV `v : ℝ`, truncation
    depth `N : ℕ`, and generation indices `g₁ g₂ : Fin 3`:

    1. **Cross-difference identity**:
       `m_g₁(N+1)·m_g₂(N) - m_g₁(N)·m_g₂(N+1)
            = y_g₁,IR·y_g₂,IR·v²·(α_g₁ - α_g₂)·(δ_{N+1} - δ_N)`.

    2. **Uniform-α corollary (Phase 9.15)**:
       `α_g₁ = α_g₂` ⟹ cross-difference is zero.

    3. **Sign under α-difference**:
       `y_g₁, y_g₂ ≥ 0 ∧ α_g₂ ≤ α_g₁` ⟹ cross-difference ≤ 0
       (the ratio `m_g₁/m_g₂` decreases from N to N+1). -/
theorem substrate_non_uniform_alpha_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g1 g2 : Fin 3) :
    threeGenFermionMass yIRs αs v (N + 1) g1
        * threeGenFermionMass yIRs αs v N g2
      - threeGenFermionMass yIRs αs v N g1
        * threeGenFermionMass yIRs αs v (N + 1) g2
      = yIRs g1 * yIRs g2 * v^2
        * (αs g1 - αs g2)
        * (substrateRGScale (N + 1) - substrateRGScale N) ∧
    (αs g1 = αs g2 →
      threeGenFermionMass yIRs αs v (N + 1) g1
          * threeGenFermionMass yIRs αs v N g2
        = threeGenFermionMass yIRs αs v N g1
          * threeGenFermionMass yIRs αs v (N + 1) g2) ∧
    (0 ≤ yIRs g1 → 0 ≤ yIRs g2 → αs g2 ≤ αs g1 →
      threeGenFermionMass yIRs αs v (N + 1) g1
          * threeGenFermionMass yIRs αs v N g2
        ≤ threeGenFermionMass yIRs αs v N g1
          * threeGenFermionMass yIRs αs v (N + 1) g2) := by
  refine ⟨?_, ?_, ?_⟩
  · exact mass_cross_difference_identity yIRs αs v N g1 g2
  · intro h_eq
    exact mass_cross_difference_zero_iff_equal_alpha yIRs αs v N g1 g2 h_eq
  · intros h_y1 h_y2 h_α
    exact mass_cross_difference_sign_under_alpha_diff
      yIRs αs v N g1 g2 h_y1 h_y2 h_α

end OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
