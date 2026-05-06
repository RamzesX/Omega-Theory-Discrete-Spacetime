/-
  OmegaTheory.QuantumGravity.SubstrateQMProbability

  **Lion's-Pride Phase 9.30 (2026-05-06)**:
  *Substrate QM probability density layer — connects the multi-mode
  Hilbert structure (7.7-7.23) to the QM probability interpretation
  `p(state) := ψ(state)²`, with non-negativity, sum = ⟨ψ,ψ⟩ identity,
  normalised total = 1 iff `IsNormalised`, and basis-state spike.*

  ## Why this file

  Phases 7.7-7.23 built the algebraic + Hilbert structure of the
  multi-mode wave function on `MultimodeFockState k N`.

  This file ships the **physical probability interpretation**: for
  a wave function `ψ`, the QM probability of measuring basis state
  `|state⟩` is:

      p(ψ, state) := ψ(state)²

  This connects the abstract Hilbert structure to physical QM
  observation statistics.  Properties shipped:

  1. **Non-negativity**: `0 ≤ p(ψ, state)` (squares are non-negative).
  2. **Total = inner product**: `Σ_state p(ψ, state) = ⟨ψ, ψ⟩`.
  3. **Normalised total = 1**: `IsNormalised ψ ⟺ Σ_state p = 1`.
  4. **Basis-state spike**: `p(e_state, s) = 1` if `s = state`, else 0.

  These are the defining properties of a discrete probability measure
  on the multi-mode basis.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `probDensity ψ state := ψ(state)²`                    | (def)                                                  |
  | `probDensity_nonneg`                                  | 0 ≤ p(ψ, state)                                        |
  | `probDensity_total_eq_innerProduct`                   | Σ p = ⟨ψ, ψ⟩                                            |
  | `probDensity_total_eq_one_iff_normalised`             | Σ p = 1 ⟺ IsNormalised ψ                                |
  | `probDensity_basis_state_self`                        | p(e_state, state) = 1                                  |
  | `probDensity_basis_state_other`                       | s ≠ state ⟹ p(e_state, s) = 0                           |
  | Headline (4-conjunct)                                 | `substrate_qm_probability_report`                     |

  ## Author

  Lion's-Pride dynamic /loop iteration 89 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateQMProbability

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised

/-! ## 1. Probability density -/

/-- **QM probability density** at basis state `state` of wave
    function `ψ`: `p(ψ, state) := ψ(state)²`. -/
def probDensity {k N : ℕ} (ψ : WaveFunction k N)
    (state : MultimodeFockState k N) : ℝ :=
  (ψ state)^2

/-! ## 2. Non-negativity -/

/-- **Probability density is non-negative**:
    `0 ≤ p(ψ, state)`. -/
theorem probDensity_nonneg
    {k N : ℕ} (ψ : WaveFunction k N) (state : MultimodeFockState k N) :
    0 ≤ probDensity ψ state := by
  unfold probDensity
  exact sq_nonneg (ψ state)

/-! ## 3. Total probability = inner product -/

/-- **Total probability equals self inner product**:
    `Σ_state p(ψ, state) = ⟨ψ, ψ⟩`. -/
theorem probDensity_total_eq_innerProduct
    {k N : ℕ} (ψ : WaveFunction k N) :
    Finset.univ.sum (fun s : MultimodeFockState k N => probDensity ψ s)
      = innerProduct ψ ψ := by
  unfold probDensity innerProduct
  apply Finset.sum_congr rfl
  intros s _
  ring

/-! ## 4. Normalised iff total probability = 1 -/

/-- **Normalised iff total probability = 1**:
    `IsNormalised ψ ⟺ Σ_state p(ψ, state) = 1`. -/
theorem probDensity_total_eq_one_iff_normalised
    {k N : ℕ} (ψ : WaveFunction k N) :
    Finset.univ.sum (fun s : MultimodeFockState k N => probDensity ψ s) = 1
    ↔ IsNormalised ψ := by
  unfold IsNormalised
  rw [probDensity_total_eq_innerProduct]

/-! ## 5. Basis-state probability density -/

/-- **Basis-state probability density at the same state**:
    `p(e_state, state) = 1`. -/
theorem probDensity_basis_state_self
    {k N : ℕ} (state : MultimodeFockState k N) :
    probDensity (basisStateAsWaveFunction state) state = 1 := by
  unfold probDensity basisStateAsWaveFunction
  simp

/-- **Basis-state probability density at a different state**:
    `s ≠ state ⟹ p(e_state, s) = 0`. -/
theorem probDensity_basis_state_other
    {k N : ℕ} (state s : MultimodeFockState k N) (h_ne : s ≠ state) :
    probDensity (basisStateAsWaveFunction state) s = 0 := by
  unfold probDensity basisStateAsWaveFunction
  rw [if_neg h_ne]
  ring

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 9.30 headline — substrate QM probability
    structural report.**

    For multi-mode parameters `k N : ℕ`, basis state
    `state s : MultimodeFockState k N` with `s ≠ state`, and an
    arbitrary wave function `ψ : WaveFunction k N`:

    1. **Non-negativity**: `0 ≤ p(ψ, state)`.

    2. **Total = inner product**:
       `Σ_state p(ψ, state) = ⟨ψ, ψ⟩`.

    3. **Basis-state spike**:
       `p(e_state, state) = 1` and `p(e_state, s) = 0` for `s ≠ state`. -/
theorem substrate_qm_probability_report
    {k N : ℕ} (ψ : WaveFunction k N)
    (state s : MultimodeFockState k N) (h_ne : s ≠ state) :
    0 ≤ probDensity ψ state ∧
    Finset.univ.sum (fun s : MultimodeFockState k N => probDensity ψ s)
      = innerProduct ψ ψ ∧
    probDensity (basisStateAsWaveFunction state) state = 1 ∧
    probDensity (basisStateAsWaveFunction state) s = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact probDensity_nonneg ψ state
  · exact probDensity_total_eq_innerProduct ψ
  · exact probDensity_basis_state_self state
  · exact probDensity_basis_state_other state s h_ne

end OmegaTheory.QuantumGravity.SubstrateQMProbability
