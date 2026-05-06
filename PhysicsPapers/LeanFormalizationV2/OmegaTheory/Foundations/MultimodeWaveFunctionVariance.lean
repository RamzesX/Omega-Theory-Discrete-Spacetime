/-
  OmegaTheory.Foundations.MultimodeWaveFunctionVariance

  **Lion's-Pride Phase 7.20 (2026-05-06)**:
  *Multi-mode wave-function variance of the total number operator:
  `(ΔN̂)²(ψ) := ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²`, with basis-state evaluation
  (zero — eigenstates have zero variance) and vacuum evaluation.*

  ## Why this file

  Phase 7.18 (`MultimodeWaveFunctionExpectation`) shipped
  `⟨ψ|N̂|ψ⟩`.  Phase 7.19 (`MultimodeWaveFunctionSecondMoment`)
  shipped `⟨ψ|N̂²|ψ⟩`.

  This file ships the **variance** (uncertainty squared):

      (ΔN̂)²(ψ) := ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²

  This is the QM substrate-side input to **Heisenberg uncertainty**.
  For an observable `Â` on a normalised state `|ψ⟩`, the variance
  `(ΔÂ)²` quantifies the spread of measurement outcomes around the
  expectation value `⟨Â⟩`.

  Properties shipped:

  1. **Basis-state evaluation = 0**: basis states `|state⟩` are
     EIGENSTATES of `N̂` with eigenvalue `n(state)`, so
     `⟨e_state|N̂²|e_state⟩ - ⟨e_state|N̂|e_state⟩² = n² - n² = 0`.
  2. **Vacuum evaluation = 0**: vacuum state has `n = 0`, so
     `(ΔN̂)²(vacuum) = 0 - 0 = 0`.
  3. **Variance equals binomial form**:
     `(ΔN̂)²(ψ) = ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²` (definitional).

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `varianceN ψ := ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²`                  | (def)                                                  |
  | `varianceN_basis_state`                               | basis state ⟹ varianceN = 0                            |
  | `varianceN_vacuum`                                    | vacuum ⟹ varianceN = 0                                 |
  | `varianceN_eq_difference`                             | varianceN = ⟨N̂²⟩ - ⟨N̂⟩² (definitional)                  |
  | Headline (3-conjunct)                                 | `multimode_wave_function_variance_report`             |

  ## Honest scope

  This file ships the variance as a SIGNED QUANTITY (it can be
  computed for any wave function).  The non-negativity claim
  `0 ≤ (ΔN̂)²(ψ)` for general normalised `ψ` requires the discrete
  Cauchy-Schwarz inequality applied to `(ψ(s)·n(s), ψ(s))`, and
  is deferred to Phase 7.21.

  ## Author

  Lion's-Pride dynamic /loop iteration 85 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeNumberOperators
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
import OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionVariance

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
open OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment

/-! ## 1. Variance definition -/

/-- **Multi-mode total-number variance**:
    `(ΔN̂)²(ψ) := ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²`. -/
noncomputable def varianceN
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) : ℝ :=
  expectationN_squared ψ - (expectationN ψ)^2

/-! ## 2. Variance equals difference (definitional) -/

/-- **Variance definitional identity**:
    `varianceN ψ = ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²`. -/
theorem varianceN_eq_difference
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) :
    varianceN ψ = expectationN_squared ψ - (expectationN ψ)^2 :=
  rfl

/-! ## 3. Basis-state variance = 0 (eigenstate property) -/

/-- **Basis-state variance = 0**: basis states are eigenstates of
    N̂ with eigenvalue `n(state)`, so `(ΔN̂)²(e_state) = 0`. -/
theorem varianceN_basis_state
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N) :
    varianceN (basisStateAsWaveFunction state) = 0 := by
  unfold varianceN
  rw [expectationN_squared_basis_state, expectationN_basis_state]
  ring

/-! ## 4. Vacuum-state variance = 0 -/

/-- **Vacuum-state variance = 0**: at the vacuum (n = 0),
    `(ΔN̂)²(vacuum) = 0² - 0² = 0`. -/
theorem varianceN_vacuum
    {k N : ℕ} [NeZero k] :
    varianceN (basisStateAsWaveFunction (vacuumState k N)) = 0 := by
  exact varianceN_basis_state (vacuumState k N)

/-! ## 5. Zero wave function variance = 0 -/

/-- **Zero wave function**: `(ΔN̂)²(0) = 0 - 0² = 0`. -/
theorem varianceN_zero
    (k N : ℕ) [NeZero k] :
    varianceN (0 : WaveFunction k N) = 0 := by
  unfold varianceN
  rw [expectationN_squared_zero, show expectationN (0 : WaveFunction k N) = 0 from by
    unfold expectationN
    apply Finset.sum_eq_zero
    intros s _
    show ((0 : WaveFunction k N) s)^2 * (totalNumberEigenvalue s : ℝ) = 0
    show (0 : ℝ)^2 * (totalNumberEigenvalue s : ℝ) = 0
    ring]
  ring

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 7.20 headline — multi-mode wave-function
    variance structural report.**

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`), basis state
    `state : MultimodeFockState k N`, and arbitrary wave function
    `ψ : WaveFunction k N`:

    1. **Basis-state variance = 0** (eigenstate property).

    2. **Vacuum-state variance = 0**.

    3. **Variance binomial form**:
       `varianceN ψ = ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²`. -/
theorem multimode_wave_function_variance_report
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N)
    (ψ : WaveFunction k N) :
    varianceN (basisStateAsWaveFunction state) = 0 ∧
    varianceN (basisStateAsWaveFunction (vacuumState k N)) = 0 ∧
    varianceN ψ = expectationN_squared ψ - (expectationN ψ)^2 := by
  refine ⟨?_, ?_, ?_⟩
  · exact varianceN_basis_state state
  · exact varianceN_vacuum
  · exact varianceN_eq_difference ψ

end OmegaTheory.Foundations.MultimodeWaveFunctionVariance
