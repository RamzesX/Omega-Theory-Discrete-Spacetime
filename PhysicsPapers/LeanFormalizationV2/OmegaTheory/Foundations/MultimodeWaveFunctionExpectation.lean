/-
  OmegaTheory.Foundations.MultimodeWaveFunctionExpectation

  **Lion's-Pride Phase 7.18 (2026-05-06)**:
  *Multi-mode wave-function QM expectation value for the total
  number operator: `⟨ψ| N̂ |ψ⟩ := Σ_state ψ(state)² · n(state)`,
  with non-negativity, basis-state evaluation, zero on zero, and
  expectation-≥0-under-non-negative-eigenvalues sanity check.*

  ## Why this file

  The previous multi-mode Hilbert scaffold (7.7-7.17) built the
  algebraic + metric structure of `WaveFunction k N`.  This file
  introduces the QM-side of the picture: **expectation values** of
  diagonal observables.

  For a basis-diagonal observable `Â` with eigenvalue `a(state)` on
  basis state `|state⟩`, the QM expectation value of a wave function
  `ψ` is:

      ⟨ψ| Â |ψ⟩ := Σ_state ψ(state)² · a(state)

  Specialised to the total number operator `N̂` (Phase 7.7):

      ⟨ψ| N̂ |ψ⟩ := Σ_state ψ(state)² · totalNumberEigenvalue state

  Properties shipped:

  1. **Non-negativity**: `0 ≤ ⟨ψ| N̂ |ψ⟩` (since both factors ≥ 0).
  2. **Basis-state evaluation**:
     `⟨e_state| N̂ |e_state⟩ = totalNumberEigenvalue state`.
  3. **Zero on zero**: `⟨0| N̂ |0⟩ = 0`.
  4. **Vacuum expectation = 0**: at the vacuum state (all zeros),
     `⟨vacuum| N̂ |vacuum⟩ = 0`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `expectationN ψ`                                      | (def) `Σ ψ(s)² · totalNumberEigenvalue s`             |
  | `expectationN_nonneg`                                 | 0 ≤ ⟨ψ\|N̂\|ψ⟩                                          |
  | `expectationN_basis_state`                            | ⟨e_state\|N̂\|e_state⟩ = totalN(state)                  |
  | `expectationN_zero`                                   | ⟨0\|N̂\|0⟩ = 0                                          |
  | Headline (3-conjunct)                                 | `multimode_wave_function_expectation_report`         |

  ## Author

  Lion's-Pride dynamic /loop iteration 83 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeNumberOperators
import OmegaTheory.Foundations.MultimodeWaveFunction
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionExpectation

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators
open OmegaTheory.Foundations.MultimodeWaveFunction

/-! ## 1. Total-number expectation value -/

/-- **Multi-mode total-number expectation value**:
    `⟨ψ| N̂ |ψ⟩ := Σ_state ψ(state)² · totalNumberEigenvalue state`. -/
noncomputable def expectationN
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) : ℝ :=
  Finset.univ.sum fun s : MultimodeFockState k N =>
    (ψ s)^2 * (totalNumberEigenvalue s : ℝ)

/-! ## 2. Non-negativity -/

/-- **Expectation value is non-negative**:
    `0 ≤ ⟨ψ| N̂ |ψ⟩` since both `ψ(s)² ≥ 0` and `n(s) ≥ 0`. -/
theorem expectationN_nonneg
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) :
    0 ≤ expectationN ψ := by
  unfold expectationN
  apply Finset.sum_nonneg
  intros s _
  -- ψ(s)² · totalNumberEigenvalue s ≥ 0
  apply mul_nonneg
  · exact sq_nonneg (ψ s)
  · -- totalNumberEigenvalue : ℕ, coerced to ℝ
    exact_mod_cast (Nat.zero_le _)

/-! ## 3. Basis-state evaluation -/

/-- **Basis-state expectation**:
    `⟨e_state| N̂ |e_state⟩ = totalNumberEigenvalue state`. -/
theorem expectationN_basis_state
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N) :
    expectationN (basisStateAsWaveFunction state) =
      (totalNumberEigenvalue state : ℝ) := by
  unfold expectationN basisStateAsWaveFunction
  -- Σ_s ((if s = state then 1 else 0)² · totalN(s))
  -- only s = state contributes 1·totalN(state) = totalN(state)
  -- pointwise: (if s = state then 1 else 0)² = (if s = state then 1 else 0)
  have h_pt : (fun s : MultimodeFockState k N =>
                  (if s = state then (1 : ℝ) else 0)^2
                  * (totalNumberEigenvalue s : ℝ))
              = (fun s => if s = state then (totalNumberEigenvalue s : ℝ) else 0) := by
    funext s
    by_cases h : s = state
    · simp [h]
    · simp [h]
  rw [h_pt, Finset.sum_ite_eq']
  simp

/-! ## 4. Zero wave function -/

/-- **Zero wave function**: `⟨0| N̂ |0⟩ = 0`. -/
theorem expectationN_zero
    (k N : ℕ) [NeZero k] :
    expectationN (0 : WaveFunction k N) = 0 := by
  unfold expectationN
  apply Finset.sum_eq_zero
  intros s _
  -- (0)(s)² · totalN(s) = 0² · totalN(s) = 0
  show ((0 : WaveFunction k N) s)^2 * (totalNumberEigenvalue s : ℝ) = 0
  show (0 : ℝ)^2 * (totalNumberEigenvalue s : ℝ) = 0
  ring

/-! ## 5. Vacuum state expectation -/

/-- **Vacuum state**: the all-zero `MultimodeFockState`, where every
    mode `i : Fin k` has occupation `⟨0, succ_pos N⟩`. -/
def vacuumState (k N : ℕ) : MultimodeFockState k N :=
  fun _ => ⟨0, Nat.succ_pos N⟩

/-- **Vacuum expectation value = 0**: at the vacuum state, the total
    number is 0, so `⟨vacuum| N̂ |vacuum⟩ = 0`. -/
theorem expectationN_vacuum
    {k N : ℕ} [NeZero k] :
    expectationN (basisStateAsWaveFunction (vacuumState k N)) = 0 := by
  rw [expectationN_basis_state]
  -- totalNumberEigenvalue (vacuumState k N) = Σ_i (⟨0, _⟩ : Fin (N+1)).val = Σ_i 0 = 0
  unfold totalNumberEigenvalue vacuumState
  simp

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 7.18 headline — multi-mode wave-function
    QM expectation-value structural report.**

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`), basis state
    `state : MultimodeFockState k N`, and arbitrary wave function
    `ψ : WaveFunction k N`:

    1. **Non-negativity**: `0 ≤ ⟨ψ| N̂ |ψ⟩`.

    2. **Basis-state evaluation**:
       `⟨e_state| N̂ |e_state⟩ = totalNumberEigenvalue state`.

    3. **Vacuum expectation**: `⟨vacuum| N̂ |vacuum⟩ = 0`. -/
theorem multimode_wave_function_expectation_report
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N)
    (ψ : WaveFunction k N) :
    0 ≤ expectationN ψ ∧
    expectationN (basisStateAsWaveFunction state) =
      (totalNumberEigenvalue state : ℝ) ∧
    expectationN (basisStateAsWaveFunction (vacuumState k N)) = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · exact expectationN_nonneg ψ
  · exact expectationN_basis_state state
  · exact expectationN_vacuum

end OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
