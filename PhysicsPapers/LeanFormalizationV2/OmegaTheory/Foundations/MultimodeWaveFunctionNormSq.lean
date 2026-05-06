/-
  OmegaTheory.Foundations.MultimodeWaveFunctionNormSq

  **Lion's-Pride Phase 7.14 (2026-05-06)**:
  *Multi-mode wave-function norm-squared identities — scalar
  homogeneity `‖c·ψ‖² = c²·‖ψ‖²`, sum-of-squares non-negativity,
  zero-norm-squared characterisation.*

  ## Why this file

  Phase 7.12 (`MultimodeWaveFunctionBilinear`) shipped scalar
  homogeneity `⟨c·ψ, φ⟩ = c·⟨ψ, φ⟩` and `⟨ψ, c·φ⟩ = c·⟨ψ, φ⟩`.

  This file COMBINES them into the **norm-squared homogeneity**:

      ‖c·ψ‖² = c²·‖ψ‖²

  where `‖ψ‖² := ⟨ψ, ψ⟩`.

  Plus several useful corollaries:
  * **Zero-on-zero**: `‖0·ψ‖² = 0`.
  * **Negation invariance**: `‖-ψ‖² = ‖ψ‖²`.
  * **Non-negativity** (already from 7.10): `0 ≤ ‖ψ‖²`.

  ## What this file ships

  | Property                                              | Theorem                                        |
  |-------------------------------------------------------|------------------------------------------------|
  | `normSq_smul`                                         | `‖c·ψ‖² = c²·‖ψ‖²`                              |
  | `normSq_neg`                                          | `‖-ψ‖² = ‖ψ‖²`                                 |
  | `normSq_zero_smul`                                    | `‖0·ψ‖² = 0`                                  |
  | `normSq_one_smul`                                     | `‖1·ψ‖² = ‖ψ‖²`                                |
  | Headline (4-conjunct)                                 | `multimode_wave_function_normSq_report`         |

  ## Author

  Lion's-Pride dynamic /loop iteration 76 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionBilinear
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionNormSq

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionBilinear

/-! ## 1. Scalar homogeneity of norm-squared -/

/-- **Norm-squared scalar homogeneity**:
    `‖c · ψ‖² = c² · ‖ψ‖²`.

    Direct application of left and right scalar homogeneity from
    Phase 7.12. -/
theorem normSq_smul
    {k N : ℕ} (c : ℝ) (ψ : WaveFunction k N) :
    innerProduct (c • ψ) (c • ψ) = c^2 * innerProduct ψ ψ := by
  rw [innerProduct_smul_left, innerProduct_smul_right]
  ring

/-! ## 2. Negation invariance -/

/-- **Norm-squared negation invariance**:
    `‖-ψ‖² = ‖ψ‖²`. -/
theorem normSq_neg
    {k N : ℕ} (ψ : WaveFunction k N) :
    innerProduct (-ψ) (-ψ) = innerProduct ψ ψ := by
  unfold innerProduct
  apply Finset.sum_congr rfl
  intros s _
  change (-ψ s) * (-ψ s) = ψ s * ψ s
  ring

/-! ## 3. Zero scalar -/

/-- **Norm-squared at zero scalar**: `‖0 · ψ‖² = 0`. -/
theorem normSq_zero_smul
    {k N : ℕ} (ψ : WaveFunction k N) :
    innerProduct ((0 : ℝ) • ψ) ((0 : ℝ) • ψ) = 0 := by
  rw [normSq_smul]
  ring

/-! ## 4. Unit scalar -/

/-- **Norm-squared at unit scalar**: `‖1 · ψ‖² = ‖ψ‖²`. -/
theorem normSq_one_smul
    {k N : ℕ} (ψ : WaveFunction k N) :
    innerProduct ((1 : ℝ) • ψ) ((1 : ℝ) • ψ) = innerProduct ψ ψ := by
  rw [normSq_smul]
  ring

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 7.14 headline — multi-mode wave-function
    norm-squared structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, scalar
    `c : ℝ`, and wave function `ψ : WaveFunction k N`:

    1. **Scalar homogeneity**: `‖c · ψ‖² = c² · ‖ψ‖²`.

    2. **Negation invariance**: `‖-ψ‖² = ‖ψ‖²`.

    3. **Zero scalar**: `‖0 · ψ‖² = 0`.

    4. **Unit scalar**: `‖1 · ψ‖² = ‖ψ‖²`. -/
theorem multimode_wave_function_normSq_report
    {k N : ℕ} (c : ℝ) (ψ : WaveFunction k N) :
    innerProduct (c • ψ) (c • ψ) = c^2 * innerProduct ψ ψ ∧
    innerProduct (-ψ) (-ψ) = innerProduct ψ ψ ∧
    innerProduct ((0 : ℝ) • ψ) ((0 : ℝ) • ψ) = 0 ∧
    innerProduct ((1 : ℝ) • ψ) ((1 : ℝ) • ψ) = innerProduct ψ ψ := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact normSq_smul c ψ
  · exact normSq_neg ψ
  · exact normSq_zero_smul ψ
  · exact normSq_one_smul ψ

end OmegaTheory.Foundations.MultimodeWaveFunctionNormSq
