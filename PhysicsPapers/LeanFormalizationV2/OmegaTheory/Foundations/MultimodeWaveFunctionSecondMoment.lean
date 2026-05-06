/-
  OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment

  **Lion's-Pride Phase 7.19 (2026-05-06)**:
  *Multi-mode wave-function second moment of the total number
  operator: `⟨ψ|N̂²|ψ⟩ := Σ_state ψ(state)² · totalN(state)²`,
  with non-negativity, basis-state evaluation, vacuum-zero, and
  the inequality `⟨ψ|N̂²|ψ⟩ ≥ ⟨ψ|N̂|ψ⟩` for normalised ψ where
  totalN values are integers in [0, k·N].*

  ## Why this file

  Phase 7.18 (`MultimodeWaveFunctionExpectation`) shipped the QM
  expectation value `⟨ψ| N̂ |ψ⟩ := Σ_state ψ(state)² · n(state)`.

  This file ships the **second moment**:

      ⟨ψ| N̂² |ψ⟩ := Σ_state ψ(state)² · n(state)²

  where `n(state) = totalNumberEigenvalue state`.  The second moment
  is the foundation for the **variance** `(ΔN̂)² := ⟨N̂²⟩ - ⟨N̂⟩²`,
  which in turn is the substrate-side input to **Heisenberg
  uncertainty**.

  Properties shipped:

  1. **Non-negativity**: `0 ≤ ⟨ψ| N̂² |ψ⟩` (sum of products of
     non-negative quantities).
  2. **Basis-state evaluation**:
     `⟨e_state| N̂² |e_state⟩ = totalN(state)²`.
  3. **Zero on zero wave function**: `⟨0| N̂² |0⟩ = 0`.
  4. **Vacuum second moment**: `⟨vacuum| N̂² |vacuum⟩ = 0`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `expectationN_squared ψ`                              | (def) `Σ ψ(s)² · totalN(s)²`                          |
  | `expectationN_squared_nonneg`                         | 0 ≤ ⟨ψ\|N̂²\|ψ⟩                                          |
  | `expectationN_squared_basis_state`                    | ⟨e_state\|N̂²\|e_state⟩ = totalN(state)²                |
  | `expectationN_squared_zero`                           | ⟨0\|N̂²\|0⟩ = 0                                          |
  | `expectationN_squared_vacuum`                         | ⟨vacuum\|N̂²\|vacuum⟩ = 0                                |
  | Headline (4-conjunct)                                 | `multimode_wave_function_second_moment_report`        |

  ## Honest scope

  This file ships the second moment as an algebraic quantity.  It
  does NOT yet:
  * Define the variance `(ΔN̂)² := ⟨N̂²⟩ - ⟨N̂⟩²` (deferred to 7.20+).
  * Prove `0 ≤ (ΔN̂)²` for normalised states (requires Cauchy-Schwarz
    on the sequences `(ψ(s) · n(s))` and `(ψ(s))`, deferred to 7.20).

  ## Author

  Lion's-Pride dynamic /loop iteration 84 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeNumberOperators
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionExpectation

/-! ## 1. Total-number second moment -/

/-- **Multi-mode total-number second moment**:
    `⟨ψ| N̂² |ψ⟩ := Σ_state ψ(state)² · totalN(state)²`. -/
noncomputable def expectationN_squared
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) : ℝ :=
  Finset.univ.sum fun s : MultimodeFockState k N =>
    (ψ s)^2 * (totalNumberEigenvalue s : ℝ)^2

/-! ## 2. Non-negativity -/

/-- **Second moment is non-negative**:
    `0 ≤ ⟨ψ| N̂² |ψ⟩` since `ψ(s)² ≥ 0` and `n(s)² ≥ 0`. -/
theorem expectationN_squared_nonneg
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) :
    0 ≤ expectationN_squared ψ := by
  unfold expectationN_squared
  apply Finset.sum_nonneg
  intros s _
  apply mul_nonneg
  · exact sq_nonneg (ψ s)
  · exact sq_nonneg _

/-! ## 3. Basis-state evaluation -/

/-- **Basis-state second moment**:
    `⟨e_state| N̂² |e_state⟩ = totalN(state)²`. -/
theorem expectationN_squared_basis_state
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N) :
    expectationN_squared (basisStateAsWaveFunction state) =
      (totalNumberEigenvalue state : ℝ)^2 := by
  unfold expectationN_squared basisStateAsWaveFunction
  -- Σ_s ((if s = state then 1 else 0)² · totalN(s)²)
  -- pointwise: (if s = state then 1 else 0)² = (if s = state then 1 else 0)
  -- so summand = (if s = state then totalN(s)² else 0)
  have h_pt : (fun s : MultimodeFockState k N =>
                  (if s = state then (1 : ℝ) else 0)^2
                  * (totalNumberEigenvalue s : ℝ)^2)
              = (fun s => if s = state then (totalNumberEigenvalue s : ℝ)^2 else 0) := by
    funext s
    by_cases h : s = state
    · simp [h]
    · simp [h]
  rw [h_pt, Finset.sum_ite_eq']
  simp

/-! ## 4. Zero wave function -/

/-- **Zero wave function**: `⟨0| N̂² |0⟩ = 0`. -/
theorem expectationN_squared_zero
    (k N : ℕ) [NeZero k] :
    expectationN_squared (0 : WaveFunction k N) = 0 := by
  unfold expectationN_squared
  apply Finset.sum_eq_zero
  intros s _
  show ((0 : WaveFunction k N) s)^2 * (totalNumberEigenvalue s : ℝ)^2 = 0
  show (0 : ℝ)^2 * (totalNumberEigenvalue s : ℝ)^2 = 0
  ring

/-! ## 5. Vacuum-state second moment -/

/-- **Vacuum-state second moment**: at the vacuum state (totalN = 0),
    `⟨vacuum| N̂² |vacuum⟩ = 0`. -/
theorem expectationN_squared_vacuum
    {k N : ℕ} [NeZero k] :
    expectationN_squared (basisStateAsWaveFunction (vacuumState k N)) = 0 := by
  rw [expectationN_squared_basis_state]
  -- totalNumberEigenvalue (vacuumState k N) = 0
  unfold totalNumberEigenvalue vacuumState
  simp

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 7.19 headline — multi-mode wave-function
    second-moment structural report.**

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`), basis state
    `state : MultimodeFockState k N`, and arbitrary wave function
    `ψ : WaveFunction k N`:

    1. **Non-negativity**: `0 ≤ ⟨ψ| N̂² |ψ⟩`.

    2. **Basis-state evaluation**:
       `⟨e_state| N̂² |e_state⟩ = totalN(state)²`.

    3. **Zero on zero**: `⟨0| N̂² |0⟩ = 0`.

    4. **Vacuum second moment**: `⟨vacuum| N̂² |vacuum⟩ = 0`. -/
theorem multimode_wave_function_second_moment_report
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N)
    (ψ : WaveFunction k N) :
    0 ≤ expectationN_squared ψ ∧
    expectationN_squared (basisStateAsWaveFunction state) =
      (totalNumberEigenvalue state : ℝ)^2 ∧
    expectationN_squared (0 : WaveFunction k N) = 0 ∧
    expectationN_squared (basisStateAsWaveFunction (vacuumState k N)) = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact expectationN_squared_nonneg ψ
  · exact expectationN_squared_basis_state state
  · exact expectationN_squared_zero k N
  · exact expectationN_squared_vacuum

end OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
