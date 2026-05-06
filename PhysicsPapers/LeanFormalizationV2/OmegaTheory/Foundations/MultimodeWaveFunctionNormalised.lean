/-
  OmegaTheory.Foundations.MultimodeWaveFunctionNormalised

  **Lion's-Pride Phase 7.10 (2026-05-06)**:
  *Multi-mode wave function normalisation predicate
  `IsNormalised ψ := ⟨ψ, ψ⟩ = 1` — basis states are normalised.*

  ## Why this file

  Phase 7.9 (`MultimodeWaveFunction`) shipped the wave-function /
  inner-product layer.  This file ships the **normalisation
  predicate** that captures the QM probability requirement:

      Σ_state |ψ(state)|² = ⟨ψ, ψ⟩ = 1.

  In QM, this constraint expresses that a wave function describes
  a probability amplitude — the total probability of finding the
  system in some basis state must be 1.

  Properties shipped:

  1. **Predicate**: `IsNormalised ψ := ⟨ψ, ψ⟩ = 1`.
  2. **Basis states are normalised**:
     `IsNormalised (basisStateAsWaveFunction state)`.
  3. **Norm-squared non-negativity**: for any wave function,
     `0 ≤ ⟨ψ, ψ⟩` (sum of squares).
  4. **Zero wave function not normalised**: `⟨0, 0⟩ = 0 ≠ 1`.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `IsNormalised ψ : Prop`                                | (def: `⟨ψ, ψ⟩ = 1`)                            |
  | `basisStateAsWaveFunction_isNormalised`                | basis state ⟹ normalised                       |
  | `innerProduct_self_nonneg`                             | `0 ≤ ⟨ψ, ψ⟩` (sum of squares)                  |
  | `zero_wave_function_innerProduct_self_zero`            | ⟨0, 0⟩ = 0                                     |
  | Headline (3-conjunct)                                 | `multimode_wave_function_normalised_report`     |

  ## Honest scope

  This file ships the REAL-valued normalisation structure.  It does
  NOT yet:
  * Define the L²-norm `‖ψ‖ := √⟨ψ, ψ⟩` separately.
  * Prove Cauchy-Schwarz `|⟨ψ, φ⟩| ≤ ‖ψ‖·‖φ‖` (Phase 7.11+).
  * Build the unit sphere as a separate type / quotient.

  ## Author

  Lion's-Pride dynamic /loop iteration 67 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionNormalised

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction

/-! ## 1. Normalisation predicate

    `IsNormalised ψ := ⟨ψ, ψ⟩ = 1`. -/

/-- **Normalisation predicate** for a multi-mode wave function:
    `IsNormalised ψ ⟺ ⟨ψ, ψ⟩ = 1`. -/
def IsNormalised {k N : ℕ} (ψ : WaveFunction k N) : Prop :=
  innerProduct ψ ψ = 1

/-! ## 2. Basis states are normalised -/

/-- **Basis-state wave functions are normalised**:
    `IsNormalised (basisStateAsWaveFunction state)` for any state. -/
theorem basisStateAsWaveFunction_isNormalised
    {k N : ℕ} (state : MultimodeFockState k N) :
    IsNormalised (basisStateAsWaveFunction state) := by
  unfold IsNormalised
  exact innerProduct_basis_state_self state

/-! ## 3. Inner-product self non-negativity -/

/-- **Inner product with itself is non-negative**:
    `0 ≤ ⟨ψ, ψ⟩ = Σ_s ψ(s)²`. -/
theorem innerProduct_self_nonneg
    {k N : ℕ} (ψ : WaveFunction k N) :
    0 ≤ innerProduct ψ ψ := by
  unfold innerProduct
  apply Finset.sum_nonneg
  intros s _
  -- ψ(s) * ψ(s) = ψ(s)² ≥ 0
  exact mul_self_nonneg (ψ s)

/-! ## 4. Zero wave function -/

/-- **Zero wave function**: `⟨0, 0⟩ = 0`. -/
theorem zero_wave_function_innerProduct_self_zero (k N : ℕ) :
    innerProduct (0 : WaveFunction k N) 0 = 0 := by
  unfold innerProduct
  apply Finset.sum_eq_zero
  intros s _
  -- 0 s = 0 (Pi.zero_apply), so 0 s * 0 s = 0
  show (0 : ℝ) * 0 = 0
  ring

/-- **Zero wave function is NOT normalised**: `¬ IsNormalised 0`. -/
theorem zero_wave_function_not_normalised (k N : ℕ) :
    ¬ IsNormalised (0 : WaveFunction k N) := by
  unfold IsNormalised
  rw [zero_wave_function_innerProduct_self_zero]
  -- 0 ≠ 1
  intro h
  exact zero_ne_one h

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 7.10 headline — multi-mode wave function
    normalisation structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, basis state
    `state : MultimodeFockState k N`, and arbitrary wave function
    `ψ : WaveFunction k N`:

    1. **Basis states normalised**:
       `IsNormalised (basisStateAsWaveFunction state)`.

    2. **Inner product self non-negative**: `0 ≤ ⟨ψ, ψ⟩`.

    3. **Zero wave function not normalised**:
       `¬ IsNormalised (0 : WaveFunction k N)`. -/
theorem multimode_wave_function_normalised_report
    {k N : ℕ} (state : MultimodeFockState k N) (ψ : WaveFunction k N) :
    IsNormalised (basisStateAsWaveFunction state) ∧
    0 ≤ innerProduct ψ ψ ∧
    ¬ IsNormalised (0 : WaveFunction k N) := by
  refine ⟨?_, ?_, ?_⟩
  · exact basisStateAsWaveFunction_isNormalised state
  · exact innerProduct_self_nonneg ψ
  · exact zero_wave_function_not_normalised k N

end OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
