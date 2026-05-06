/-
  OmegaTheory.Foundations.MultimodeWaveFunctionDistance

  **Lion's-Pride Phase 7.17 (2026-05-06)**:
  *Multi-mode wave-function squared distance metric
  `d²(ψ, φ) := ⟨ψ - φ, ψ - φ⟩` with metric axioms in squared form:
  non-negativity, symmetry, zero-iff-equal, binomial expansion.*

  ## Why this file

  Phase 7.15 (`MultimodeWaveFunctionPositiveDef`) shipped the
  positive-definiteness axiom `⟨ψ, ψ⟩ = 0 ⟺ ψ = 0`.

  Phase 7.12 (`MultimodeWaveFunctionBilinear`) shipped the binomial
  inner-product expansion.

  This file ships the **squared distance metric** induced by the
  inner product:

      d²(ψ, φ) := ⟨ψ - φ, ψ - φ⟩

  Properties:
  1. **Non-negativity**: `0 ≤ d²(ψ, φ)`.
  2. **Symmetry**: `d²(ψ, φ) = d²(φ, ψ)`.
  3. **Reflexivity**: `d²(ψ, ψ) = 0`.
  4. **Zero-iff-equal**: `d²(ψ, φ) = 0 ⟺ ψ = φ` (uses 7.15).
  5. **Binomial expansion**: `d²(ψ, φ) = ⟨ψ,ψ⟩ - 2⟨ψ,φ⟩ + ⟨φ,φ⟩`.

  These are the squared-form metric axioms.  The standard metric
  `d(ψ, φ) := √d²(ψ, φ)` requires `Real.sqrt` machinery and is
  deferred — the squared form suffices for QM applications since
  probabilities and expectation values come from `⟨ψ, ψ⟩` directly,
  not its square root.

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `distSq ψ φ := ⟨ψ - φ, ψ - φ⟩`                          | (def)                                              |
  | `distSq_nonneg`                                        | 0 ≤ d²(ψ, φ)                                       |
  | `distSq_symm`                                          | d²(ψ, φ) = d²(φ, ψ)                                |
  | `distSq_self`                                          | d²(ψ, ψ) = 0                                       |
  | `distSq_eq_zero_iff`                                  | d²(ψ, φ) = 0 ⟺ ψ = φ                                |
  | `distSq_binomial_expand`                              | d²(ψ, φ) = ⟨ψ,ψ⟩ - 2⟨ψ,φ⟩ + ⟨φ,φ⟩                  |
  | Headline (5-conjunct)                                 | `multimode_wave_function_distance_report`         |

  ## Author

  Lion's-Pride dynamic /loop iteration 82 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import OmegaTheory.Foundations.MultimodeWaveFunctionBilinear
import OmegaTheory.Foundations.MultimodeWaveFunctionPositiveDef
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionDistance

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.Foundations.MultimodeWaveFunctionBilinear
open OmegaTheory.Foundations.MultimodeWaveFunctionPositiveDef

/-! ## 1. Squared distance metric -/

/-- **Squared distance metric** between two wave functions:
    `d²(ψ, φ) := ⟨ψ - φ, ψ - φ⟩`. -/
noncomputable def distSq {k N : ℕ} (ψ φ : WaveFunction k N) : ℝ :=
  innerProduct (ψ - φ) (ψ - φ)

/-! ## 2. Non-negativity -/

/-- **Squared distance is non-negative**: `0 ≤ d²(ψ, φ)`. -/
theorem distSq_nonneg
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    0 ≤ distSq ψ φ := by
  unfold distSq
  exact innerProduct_self_nonneg (ψ - φ)

/-! ## 3. Symmetry -/

/-- **Squared distance is symmetric**: `d²(ψ, φ) = d²(φ, ψ)`. -/
theorem distSq_symm
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    distSq ψ φ = distSq φ ψ := by
  unfold distSq innerProduct
  apply Finset.sum_congr rfl
  intros s _
  -- (ψ - φ)(s) · (ψ - φ)(s) = (φ - ψ)(s) · (φ - ψ)(s)
  -- since (a - b)² = (b - a)²
  change (ψ s - φ s) * (ψ s - φ s) = (φ s - ψ s) * (φ s - ψ s)
  ring

/-! ## 4. Reflexivity -/

/-- **Squared distance reflexive**: `d²(ψ, ψ) = 0`. -/
theorem distSq_self
    {k N : ℕ} (ψ : WaveFunction k N) :
    distSq ψ ψ = 0 := by
  unfold distSq innerProduct
  apply Finset.sum_eq_zero
  intros s _
  -- (ψ - ψ)(s) · (ψ - ψ)(s) = 0 · 0 = 0
  change (ψ s - ψ s) * (ψ s - ψ s) = 0
  ring

/-! ## 5. Zero iff equal -/

/-- **Zero squared distance iff equal**: `d²(ψ, φ) = 0 ⟺ ψ = φ`.

    Forward direction uses positive-definiteness from Phase 7.15 on
    `ψ - φ`: `⟨ψ - φ, ψ - φ⟩ = 0 ⟹ ψ - φ = 0 ⟹ ψ = φ`. -/
theorem distSq_eq_zero_iff
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    distSq ψ φ = 0 ↔ ψ = φ := by
  unfold distSq
  constructor
  · intro h
    have h_zero : ψ - φ = 0 := (innerProduct_self_eq_zero_iff (ψ - φ)).mp h
    -- ψ - φ = 0 ⟹ ψ = φ
    funext s
    have h_pt : (ψ - φ) s = 0 := by rw [h_zero]; rfl
    change ψ s - φ s = 0 at h_pt
    linarith
  · intro h
    rw [h, sub_self]
    exact zero_wave_function_innerProduct_self_zero k N

/-! ## 6. Binomial expansion -/

/-- **Squared distance binomial expansion**:
    `d²(ψ, φ) = ⟨ψ, ψ⟩ - 2·⟨ψ, φ⟩ + ⟨φ, φ⟩`. -/
theorem distSq_binomial_expand
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    distSq ψ φ = innerProduct ψ ψ - 2 * innerProduct ψ φ + innerProduct φ φ := by
  unfold distSq innerProduct
  -- Pointwise: (ψ-φ)² = ψ² - 2ψφ + φ²
  have h_pt : (fun s : MultimodeFockState k N =>
                  (ψ - φ) s * (ψ - φ) s)
              = (fun s => ψ s * ψ s - 2 * (ψ s * φ s) + φ s * φ s) := by
    funext s
    change (ψ s - φ s) * (ψ s - φ s) =
           ψ s * ψ s - 2 * (ψ s * φ s) + φ s * φ s
    ring
  rw [h_pt]
  -- Σ (a - 2b + c) = Σa - 2·Σb + Σc
  rw [show
        (fun s : MultimodeFockState k N =>
          ψ s * ψ s - 2 * (ψ s * φ s) + φ s * φ s)
        = (fun s => (ψ s * ψ s - 2 * (ψ s * φ s)) + φ s * φ s) from rfl]
  rw [Finset.sum_add_distrib]
  rw [show
        (fun s : MultimodeFockState k N =>
          ψ s * ψ s - 2 * (ψ s * φ s))
        = (fun s => ψ s * ψ s - 2 * (ψ s * φ s)) from rfl]
  rw [Finset.sum_sub_distrib]
  rw [show (fun s : MultimodeFockState k N => 2 * (ψ s * φ s))
        = (fun s => 2 * (ψ s * φ s)) from rfl]
  rw [← Finset.mul_sum]

/-! ## 7. Headline composite report -/

/-- **Lion's-Pride Phase 7.17 headline — multi-mode wave-function
    distance-squared metric structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, and wave
    functions `ψ, φ : WaveFunction k N`:

    1. **Non-negativity**: `0 ≤ d²(ψ, φ)`.

    2. **Symmetry**: `d²(ψ, φ) = d²(φ, ψ)`.

    3. **Reflexivity**: `d²(ψ, ψ) = 0`.

    4. **Zero-iff-equal**: `d²(ψ, φ) = 0 ⟺ ψ = φ`.

    5. **Binomial expansion**:
       `d²(ψ, φ) = ⟨ψ, ψ⟩ - 2·⟨ψ, φ⟩ + ⟨φ, φ⟩`. -/
theorem multimode_wave_function_distance_report
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    0 ≤ distSq ψ φ ∧
    distSq ψ φ = distSq φ ψ ∧
    distSq ψ ψ = 0 ∧
    (distSq ψ φ = 0 ↔ ψ = φ) ∧
    distSq ψ φ = innerProduct ψ ψ - 2 * innerProduct ψ φ + innerProduct φ φ := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact distSq_nonneg ψ φ
  · exact distSq_symm ψ φ
  · exact distSq_self ψ
  · exact distSq_eq_zero_iff ψ φ
  · exact distSq_binomial_expand ψ φ

end OmegaTheory.Foundations.MultimodeWaveFunctionDistance
