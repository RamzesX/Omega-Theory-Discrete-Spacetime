/-
  OmegaTheory.Foundations.MultimodeWaveFunctionPositiveDef

  **Lion's-Pride Phase 7.15 (2026-05-06)**:
  *Multi-mode wave-function POSITIVE-DEFINITENESS:
  `‖ψ‖² = 0 ⟺ ψ = 0` (the third inner-product-space axiom).*

  ## Why this file

  Phase 7.10 (`MultimodeWaveFunctionNormalised`) shipped the
  non-negativity bound `0 ≤ ⟨ψ, ψ⟩` and the zero-wave-function
  identity `⟨0, 0⟩ = 0`.

  This file ships the CONVERSE: if `⟨ψ, ψ⟩ = 0`, then `ψ = 0`.

  Combined with `0 ≤ ⟨ψ, ψ⟩` and `⟨ψ, ψ⟩ ≥ 0`, this completes
  the inner-product-space axiom of POSITIVE-DEFINITENESS:

      ⟨ψ, ψ⟩ = 0 ⟺ ψ = 0

  This is the third axiom of an inner product space (after
  bilinearity from 7.12 and symmetry from 7.9).  With Cauchy-Schwarz
  from 7.11, parallelogram from 7.12, and norm-squared homogeneity
  from 7.14, the multi-mode wave function on `MultimodeFockState k N`
  IS a real Hilbert space — the finite-basis case automatically
  gives completeness.

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `innerProduct_self_eq_zero_iff`                       | ⟨ψ, ψ⟩ = 0 ⟺ ψ = 0                                |
  | `innerProduct_self_pos_of_ne_zero`                    | ψ ≠ 0 ⟹ 0 < ⟨ψ, ψ⟩                                |
  | `innerProduct_self_eq_zero_of_zero`                   | ⟨0, 0⟩ = 0 (alias of 7.10)                        |
  | Headline (3-conjunct)                                 | `multimode_wave_function_positive_def_report`     |

  ## Author

  Lion's-Pride dynamic /loop iteration 77 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionPositiveDef

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised

/-! ## 1. Positive-definiteness: ⟨ψ, ψ⟩ = 0 ⟺ ψ = 0 -/

/-- **Positive-definiteness**: `⟨ψ, ψ⟩ = 0 ⟺ ψ = 0`.

    Forward direction: if the sum `Σ_s ψ(s)² = 0` and each summand
    is `≥ 0`, then each summand is exactly `0`, hence each `ψ(s) = 0`.
    By function extensionality, `ψ = 0`.

    Backward direction: trivial — substitute `ψ = 0`. -/
theorem innerProduct_self_eq_zero_iff
    {k N : ℕ} (ψ : WaveFunction k N) :
    innerProduct ψ ψ = 0 ↔ ψ = 0 := by
  constructor
  · intro h
    -- ⟨ψ, ψ⟩ = Σ ψ(s)² = 0 with all summands ≥ 0 ⟹ each ψ(s)² = 0
    unfold innerProduct at h
    -- Use Finset.sum_eq_zero_iff_of_nonneg on the non-negative summands
    have h_nonneg : ∀ s ∈ (Finset.univ : Finset (MultimodeFockState k N)),
                    0 ≤ ψ s * ψ s := by
      intros s _
      exact mul_self_nonneg (ψ s)
    rw [Finset.sum_eq_zero_iff_of_nonneg h_nonneg] at h
    -- h: ∀ s ∈ Finset.univ, ψ(s) * ψ(s) = 0
    -- Need: ψ = 0, i.e., ∀ s, ψ(s) = 0
    funext s
    have h_self : ψ s * ψ s = 0 := h s (Finset.mem_univ s)
    -- ψ(s) * ψ(s) = 0 ⟹ ψ(s) = 0 via mul_self_eq_zero
    rw [mul_self_eq_zero] at h_self
    -- h_self : ψ s = 0; goal: ψ s = 0 (Pi.zero_apply)
    show ψ s = (0 : WaveFunction k N) s
    rw [h_self]
    rfl
  · intro h
    -- ψ = 0 ⟹ ⟨0, 0⟩ = 0 from Phase 7.10
    rw [h]
    exact zero_wave_function_innerProduct_self_zero k N

/-! ## 2. Strict positivity for non-zero wave functions -/

/-- **Strict positivity**: if `ψ ≠ 0`, then `0 < ⟨ψ, ψ⟩`.

    Combines non-negativity (Phase 7.10) with positive-definiteness:
    `⟨ψ, ψ⟩ ≥ 0` always, and `⟨ψ, ψ⟩ = 0 ⟺ ψ = 0`, so under
    `ψ ≠ 0` the inequality is strict. -/
theorem innerProduct_self_pos_of_ne_zero
    {k N : ℕ} (ψ : WaveFunction k N) (h_ne : ψ ≠ 0) :
    0 < innerProduct ψ ψ := by
  have h_nn := innerProduct_self_nonneg ψ
  -- 0 ≤ ⟨ψ, ψ⟩; need 0 < ⟨ψ, ψ⟩ given ψ ≠ 0
  rcases lt_or_eq_of_le h_nn with h_lt | h_eq
  · exact h_lt
  · -- 0 = ⟨ψ, ψ⟩ ⟹ ⟨ψ, ψ⟩ = 0 ⟹ ψ = 0 ⟹ contradiction
    exfalso
    apply h_ne
    rw [← (innerProduct_self_eq_zero_iff ψ).mp h_eq.symm]

/-! ## 3. Zero-on-zero alias -/

/-- **Zero-on-zero**: `⟨0, 0⟩ = 0` (alias of Phase 7.10's
    `zero_wave_function_innerProduct_self_zero`). -/
theorem innerProduct_self_eq_zero_of_zero (k N : ℕ) :
    innerProduct (0 : WaveFunction k N) 0 = 0 :=
  zero_wave_function_innerProduct_self_zero k N

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 7.15 headline — multi-mode wave-function
    positive-definiteness structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, and wave
    function `ψ : WaveFunction k N`:

    1. **Zero characterisation** (positive-definiteness):
       `⟨ψ, ψ⟩ = 0 ⟺ ψ = 0`.

    2. **Strict positivity for non-zero**:
       `ψ ≠ 0 ⟹ 0 < ⟨ψ, ψ⟩`.

    3. **Zero-on-zero**: `⟨0, 0⟩ = 0`. -/
theorem multimode_wave_function_positive_def_report
    {k N : ℕ} (ψ : WaveFunction k N) (h_ne : ψ ≠ 0) :
    (innerProduct ψ ψ = 0 ↔ ψ = 0) ∧
    0 < innerProduct ψ ψ ∧
    innerProduct (0 : WaveFunction k N) 0 = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · exact innerProduct_self_eq_zero_iff ψ
  · exact innerProduct_self_pos_of_ne_zero ψ h_ne
  · exact innerProduct_self_eq_zero_of_zero k N

end OmegaTheory.Foundations.MultimodeWaveFunctionPositiveDef
