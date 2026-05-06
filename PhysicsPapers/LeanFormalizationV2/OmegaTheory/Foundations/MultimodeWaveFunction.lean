/-
  OmegaTheory.Foundations.MultimodeWaveFunction

  **Lion's-Pride Phase 7.9 (2026-05-06)**:
  *Multi-mode wave function (coherent superposition) — assigns a
  real amplitude to each multi-mode basis state, with inner product
  and basis-state orthonormality.*

  ## Why this file

  Phases 7.7 (per-mode number operator) and 7.8 (double-mode
  commutation) shipped the BASIS-STATE structure of multi-mode
  Fock space.  This file ships the COHERENT SUPERPOSITION
  structure — linear combinations of basis states.

  A multi-mode wave function is a real-valued function on the basis:

      WaveFunction k N := MultimodeFockState k N → ℝ

  Each `state : MultimodeFockState k N` corresponds to a basis
  vector `|state⟩`; a wave function `ψ` represents the coherent
  superposition `Σ_state ψ(state) |state⟩`.

  Properties shipped:

  1. Each basis state has a canonical wave function:
     `basisStateAsWaveFunction state := fun s => if s = state then 1 else 0`.
  2. Inner product `⟨ψ, φ⟩ := Σ_s ψ(s) · φ(s)`.
  3. Basis-state orthonormality:
       `⟨basisState i, basisState j⟩ = if i = j then 1 else 0`.
  4. Inner-product linearity in left argument.

  ## What this file ships

  | Property                                              | Theorem                                         |
  |-------------------------------------------------------|-------------------------------------------------|
  | `WaveFunction k N := MultimodeFockState k N → ℝ`       | (type definition)                                |
  | `basisStateAsWaveFunction state`                       | (def: Kronecker δ at `state`)                   |
  | `innerProduct ψ φ := Σ_s ψ(s) · φ(s)`                  | (def)                                            |
  | `innerProduct_basis_state_self`                        | ⟨e_i, e_i⟩ = 1                                  |
  | `innerProduct_basis_state_distinct`                    | ⟨e_i, e_j⟩ = 0 for i ≠ j                         |
  | `innerProduct_add_left`                                 | linearity in left argument                       |
  | Headline (4-conjunct)                                 | `multimode_wave_function_report`                 |

  ## Honest scope

  This file ships the REAL-valued wave-function structure (not
  complex).  It does NOT yet:
  * Address normalization `⟨ψ, ψ⟩ = 1` as a separate predicate.
  * Define `Σ_state |ψ(state)|² = 1` as a probability constraint.
  * Build the actual Hilbert-space completion (we work pointwise).
  * Generalise to complex amplitudes (would need ℂ machinery).

  ## Author

  Lion's-Pride dynamic /loop iteration 65 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunction

open OmegaTheory.Foundations.MultimodeFockSpace

/-! ## 1. Multi-mode wave function type

    `WaveFunction k N` = real-valued function on multi-mode basis. -/

/-- **Multi-mode wave function**: real-valued amplitude per basis state. -/
abbrev WaveFunction (k N : ℕ) : Type :=
  MultimodeFockState k N → ℝ

/-! ## 2. Basis-state wave function (Kronecker delta) -/

/-- **Basis-state wave function** at `state`: Kronecker δ-function. -/
def basisStateAsWaveFunction {k N : ℕ}
    (state : MultimodeFockState k N) : WaveFunction k N :=
  fun s => if s = state then 1 else 0

/-! ## 3. Inner product

    `⟨ψ, φ⟩ := Σ_{s : MultimodeFockState} ψ(s) · φ(s)`. -/

/-- **Inner product** between two multi-mode wave functions. -/
noncomputable def innerProduct {k N : ℕ}
    (ψ φ : WaveFunction k N) : ℝ :=
  Finset.univ.sum fun s : MultimodeFockState k N => ψ s * φ s

/-! ## 4. Basis-state orthonormality -/

/-- **Inner product of basis state with itself = 1**:
    `⟨e_state, e_state⟩ = 1`. -/
theorem innerProduct_basis_state_self
    {k N : ℕ} (state : MultimodeFockState k N) :
    innerProduct (basisStateAsWaveFunction state)
                 (basisStateAsWaveFunction state) = 1 := by
  unfold innerProduct basisStateAsWaveFunction
  -- Σ_s (if s = state then 1 else 0)·(if s = state then 1 else 0)
  -- = Σ_s (if s = state then 1 else 0)
  -- = 1 (since Finset.univ contains state exactly once)
  have h_eq :
      (fun s : MultimodeFockState k N =>
        (if s = state then (1 : ℝ) else 0) * (if s = state then (1 : ℝ) else 0))
        = (fun s => if s = state then (1 : ℝ) else 0) := by
    funext s
    by_cases h : s = state
    · simp [h]
    · simp [h]
  rw [h_eq]
  rw [Finset.sum_ite_eq']
  simp

/-- **Inner product of distinct basis states = 0**:
    `state1 ≠ state2 ⟹ ⟨e_state1, e_state2⟩ = 0`. -/
theorem innerProduct_basis_state_distinct
    {k N : ℕ} (state1 state2 : MultimodeFockState k N)
    (h_neq : state1 ≠ state2) :
    innerProduct (basisStateAsWaveFunction state1)
                 (basisStateAsWaveFunction state2) = 0 := by
  unfold innerProduct basisStateAsWaveFunction
  apply Finset.sum_eq_zero
  intros s _
  by_cases h1 : s = state1
  · by_cases h2 : s = state2
    · -- s = state1 AND s = state2 ⟹ state1 = state2, contradiction
      exact absurd (h1.symm.trans h2) h_neq
    · rw [if_pos h1, if_neg h2]; ring
  · rw [if_neg h1]; ring

/-! ## 5. Inner-product linearity in left argument -/

/-- **Inner-product linearity in left argument**:
    `⟨ψ + ψ', φ⟩ = ⟨ψ, φ⟩ + ⟨ψ', φ⟩`. -/
theorem innerProduct_add_left
    {k N : ℕ} (ψ ψ' φ : WaveFunction k N) :
    innerProduct (ψ + ψ') φ = innerProduct ψ φ + innerProduct ψ' φ := by
  unfold innerProduct
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intros s _
  change (ψ s + ψ' s) * φ s = ψ s * φ s + ψ' s * φ s
  ring

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 7.9 headline — multi-mode wave function
    structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, distinct
    basis states `state1 ≠ state2 : MultimodeFockState k N`, and
    arbitrary wave functions `ψ ψ' φ : WaveFunction k N`:

    1. **Basis state self-overlap = 1**:
       `innerProduct (e_state1) (e_state1) = 1`.

    2. **Distinct basis states orthogonal**:
       `innerProduct (e_state1) (e_state2) = 0`.

    3. **Inner product symmetry** (real-valued):
       `innerProduct ψ φ = innerProduct φ ψ`.

    4. **Inner product linear in left**: `⟨ψ + ψ', φ⟩ = ⟨ψ, φ⟩ + ⟨ψ', φ⟩`. -/
theorem multimode_wave_function_report
    {k N : ℕ} (state1 state2 : MultimodeFockState k N) (h_neq : state1 ≠ state2)
    (ψ ψ' φ : WaveFunction k N) :
    innerProduct (basisStateAsWaveFunction state1)
                 (basisStateAsWaveFunction state1) = 1 ∧
    innerProduct (basisStateAsWaveFunction state1)
                 (basisStateAsWaveFunction state2) = 0 ∧
    innerProduct ψ φ = innerProduct φ ψ ∧
    innerProduct (ψ + ψ') φ = innerProduct ψ φ + innerProduct ψ' φ := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact innerProduct_basis_state_self state1
  · exact innerProduct_basis_state_distinct state1 state2 h_neq
  · -- symmetry: ⟨ψ, φ⟩ = ⟨φ, ψ⟩ by mul_comm under sum
    unfold innerProduct
    apply Finset.sum_congr rfl
    intros s _
    ring
  · exact innerProduct_add_left ψ ψ' φ

end OmegaTheory.Foundations.MultimodeWaveFunction
