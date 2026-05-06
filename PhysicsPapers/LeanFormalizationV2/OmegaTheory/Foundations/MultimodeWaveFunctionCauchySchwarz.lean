/-
  OmegaTheory.Foundations.MultimodeWaveFunctionCauchySchwarz

  **Lion's-Pride Phase 7.11 (2026-05-06)**:
  *Multi-mode wave function Cauchy-Schwarz inequality —
  `⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩` for any pair of multi-mode
  wave functions, in squared form (no √-machinery needed).*

  ## Why this file

  Phase 7.10 (`MultimodeWaveFunctionNormalised`) shipped:
  * `IsNormalised ψ := ⟨ψ, ψ⟩ = 1`
  * `0 ≤ ⟨ψ, ψ⟩` (sum of squares)

  This file ships the **Cauchy-Schwarz inequality** in squared form:

      ⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩

  This is the foundational inequality of inner-product spaces, and
  the substrate-machinery building block for:
  * Triangle inequality `‖ψ + φ‖ ≤ ‖ψ‖ + ‖φ‖`
  * QM probability bounds `|⟨ψ, φ⟩| ≤ 1` for normalised states
  * Heisenberg uncertainty `(Δa)(Δb) ≥ |⟨[a,b]⟩|/2`

  We cite Mathlib's `Finset.sum_mul_sq_le_sq_mul_sq` directly —
  the discrete Cauchy-Schwarz over a finset of reals.

  ## What this file ships

  | Property                                              | Theorem                                         |
  |-------------------------------------------------------|-------------------------------------------------|
  | `cauchy_schwarz_sq`                                    | ⟨ψ,φ⟩² ≤ ⟨ψ,ψ⟩·⟨φ,φ⟩                            |
  | `cauchy_schwarz_for_normalised`                        | normalised ψ, φ ⟹ ⟨ψ,φ⟩² ≤ 1                     |
  | `cauchy_schwarz_basis_distinct`                        | distinct basis ⟹ ⟨e_i, e_j⟩² ≤ 1·1 = 1 (vacuous)  |
  | Headline (3-conjunct)                                 | `multimode_wave_function_cauchy_schwarz_report`  |

  ## Author

  Lion's-Pride dynamic /loop iteration 73 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionCauchySchwarz

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised

/-! ## 1. The squared Cauchy-Schwarz inequality

    `⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩`. -/

/-- **Cauchy-Schwarz (squared form)**:
    `⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩` for any pair of multi-mode wave
    functions `ψ, φ`.

    Direct application of `Finset.sum_mul_sq_le_sq_mul_sq` on the
    universal finset of basis states. -/
theorem cauchy_schwarz_sq
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    (innerProduct ψ φ)^2 ≤ innerProduct ψ ψ * innerProduct φ φ := by
  unfold innerProduct
  -- Goal: (Σ_s ψ s · φ s)² ≤ (Σ_s ψ s · ψ s) · (Σ_s φ s · φ s)
  -- Mathlib: (Σ f·g)² ≤ (Σ f²)·(Σ g²), so we need ψ s · ψ s = (ψ s)²
  have hψ : (fun s : MultimodeFockState k N => ψ s * ψ s) =
            (fun s => (ψ s)^2) := by
    funext s; ring
  have hφ : (fun s : MultimodeFockState k N => φ s * φ s) =
            (fun s => (φ s)^2) := by
    funext s; ring
  rw [hψ, hφ]
  exact Finset.sum_mul_sq_le_sq_mul_sq Finset.univ ψ φ

/-! ## 2. Normalised consequence -/

/-- **Cauchy-Schwarz for normalised states**:
    if `ψ, φ` are both normalised, then `⟨ψ, φ⟩² ≤ 1`. -/
theorem cauchy_schwarz_for_normalised
    {k N : ℕ} (ψ φ : WaveFunction k N)
    (hψ : IsNormalised ψ) (hφ : IsNormalised φ) :
    (innerProduct ψ φ)^2 ≤ 1 := by
  have h := cauchy_schwarz_sq ψ φ
  unfold IsNormalised at hψ hφ
  rw [hψ, hφ] at h
  linarith

/-! ## 3. Basis-state corollary -/

/-- **Basis-state Cauchy-Schwarz** (consistency check):
    for distinct basis states `state1 ≠ state2`,
    `⟨e_state1, e_state2⟩² = 0 ≤ 1`.

    This is a sanity-check: orthogonality directly implies the
    Cauchy-Schwarz bound is saturated to zero. -/
theorem cauchy_schwarz_basis_distinct
    {k N : ℕ} (state1 state2 : MultimodeFockState k N)
    (h_neq : state1 ≠ state2) :
    (innerProduct (basisStateAsWaveFunction state1)
                  (basisStateAsWaveFunction state2))^2 ≤ 1 := by
  rw [innerProduct_basis_state_distinct state1 state2 h_neq]
  norm_num

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 7.11 headline — multi-mode wave function
    Cauchy-Schwarz structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, and pair
    of wave functions `ψ, φ : WaveFunction k N`:

    1. **Squared Cauchy-Schwarz**:
       `⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩`.

    2. **Normalised consequence** (when both are normalised):
       `⟨ψ, φ⟩² ≤ 1`.

    3. **Inner-product squared non-negative**:
       `0 ≤ (innerProduct ψ φ)^2`. -/
theorem multimode_wave_function_cauchy_schwarz_report
    {k N : ℕ} (ψ φ : WaveFunction k N)
    (hψ : IsNormalised ψ) (hφ : IsNormalised φ) :
    (innerProduct ψ φ)^2 ≤ innerProduct ψ ψ * innerProduct φ φ ∧
    (innerProduct ψ φ)^2 ≤ 1 ∧
    0 ≤ (innerProduct ψ φ)^2 := by
  refine ⟨?_, ?_, ?_⟩
  · exact cauchy_schwarz_sq ψ φ
  · exact cauchy_schwarz_for_normalised ψ φ hψ hφ
  · exact sq_nonneg (innerProduct ψ φ)

end OmegaTheory.Foundations.MultimodeWaveFunctionCauchySchwarz
