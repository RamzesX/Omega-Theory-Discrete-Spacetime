/-
  OmegaTheory.Foundations.MultimodeWaveFunctionBilinear

  **Lion's-Pride Phase 7.12 (2026-05-06)**:
  *Multi-mode wave-function inner-product bilinearity, parallelogram
  identity, and polarisation identity — algebraic structure of the
  inner product beyond Cauchy-Schwarz.*

  ## Why this file

  Phase 7.9 (`MultimodeWaveFunction`) shipped:
  * `innerProduct_add_left`  (linearity in left argument)
  * Inner product symmetry `⟨ψ, φ⟩ = ⟨φ, ψ⟩`

  Phase 7.10 (`MultimodeWaveFunctionNormalised`) shipped the
  `IsNormalised ψ := ⟨ψ, ψ⟩ = 1` predicate and basis-state
  normalisation.

  Phase 7.11 (`MultimodeWaveFunctionCauchySchwarz`) shipped
  `⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩` via Mathlib's
  `Finset.sum_mul_sq_le_sq_mul_sq`.

  This file ships the COMPLETE bilinear structure:

  1. **Linearity in right argument**:
     `⟨ψ, φ + φ'⟩ = ⟨ψ, φ⟩ + ⟨ψ, φ'⟩`.
  2. **Scalar homogeneity** (left and right):
     `⟨c·ψ, φ⟩ = c·⟨ψ, φ⟩` and `⟨ψ, c·φ⟩ = c·⟨ψ, φ⟩`.
  3. **Inner-product expansion** (binomial):
     `⟨ψ + φ, ψ + φ⟩ = ⟨ψ, ψ⟩ + 2·⟨ψ, φ⟩ + ⟨φ, φ⟩`.
  4. **Parallelogram identity**:
     `⟨ψ + φ, ψ + φ⟩ + ⟨ψ - φ, ψ - φ⟩ = 2·⟨ψ, ψ⟩ + 2·⟨φ, φ⟩`.
  5. **Polarisation identity** (real form):
     `4·⟨ψ, φ⟩ = ⟨ψ + φ, ψ + φ⟩ - ⟨ψ - φ, ψ - φ⟩`.

  These are the foundational algebraic identities of any real
  inner-product space.  Combined with Phase 7.11's Cauchy-Schwarz,
  the multi-mode wave-function machinery now has the full algebraic
  spine of a Hilbert space (modulo completeness, which is automatic
  on the finite basis set `MultimodeFockState k N`).

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `innerProduct_add_right`                              | linearity in right argument                       |
  | `innerProduct_smul_left`                              | left scalar homogeneity                           |
  | `innerProduct_smul_right`                             | right scalar homogeneity                          |
  | `innerProduct_add_self_expand`                        | binomial expansion                                |
  | `parallelogram_identity`                              | the parallelogram law                             |
  | `polarisation_identity`                               | the polarisation identity (real)                  |
  | Headline (4-conjunct)                                 | `multimode_wave_function_bilinear_report`        |

  ## Author

  Lion's-Pride dynamic /loop iteration 74 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionBilinear

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction

/-! ## 1. Linearity in right argument -/

/-- **Inner-product linearity in right argument**:
    `⟨ψ, φ + φ'⟩ = ⟨ψ, φ⟩ + ⟨ψ, φ'⟩`. -/
theorem innerProduct_add_right
    {k N : ℕ} (ψ φ φ' : WaveFunction k N) :
    innerProduct ψ (φ + φ') = innerProduct ψ φ + innerProduct ψ φ' := by
  unfold innerProduct
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intros s _
  change ψ s * (φ s + φ' s) = ψ s * φ s + ψ s * φ' s
  ring

/-! ## 2. Scalar homogeneity -/

/-- **Inner-product left scalar homogeneity**:
    `⟨c · ψ, φ⟩ = c · ⟨ψ, φ⟩`. -/
theorem innerProduct_smul_left
    {k N : ℕ} (c : ℝ) (ψ φ : WaveFunction k N) :
    innerProduct (c • ψ) φ = c * innerProduct ψ φ := by
  unfold innerProduct
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intros s _
  change (c * ψ s) * φ s = c * (ψ s * φ s)
  ring

/-- **Inner-product right scalar homogeneity**:
    `⟨ψ, c · φ⟩ = c · ⟨ψ, φ⟩`. -/
theorem innerProduct_smul_right
    {k N : ℕ} (c : ℝ) (ψ φ : WaveFunction k N) :
    innerProduct ψ (c • φ) = c * innerProduct ψ φ := by
  unfold innerProduct
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intros s _
  change ψ s * (c * φ s) = c * (ψ s * φ s)
  ring

/-! ## 3. Inner-product binomial expansion -/

/-- **Inner-product self-expansion** (binomial):
    `⟨ψ + φ, ψ + φ⟩ = ⟨ψ, ψ⟩ + 2·⟨ψ, φ⟩ + ⟨φ, φ⟩`. -/
theorem innerProduct_add_self_expand
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    innerProduct (ψ + φ) (ψ + φ) =
      innerProduct ψ ψ + 2 * innerProduct ψ φ + innerProduct φ φ := by
  unfold innerProduct
  -- Expand pointwise: (ψ+φ)(s) · (ψ+φ)(s) = ψ²+2ψφ+φ²
  -- Then split sum + sum_add_distrib + Finset.mul_sum
  have h_pt : (fun s : MultimodeFockState k N =>
                  (ψ + φ) s * (ψ + φ) s)
              = (fun s => ψ s * ψ s + 2 * (ψ s * φ s) + φ s * φ s) := by
    funext s
    change (ψ s + φ s) * (ψ s + φ s) =
           ψ s * ψ s + 2 * (ψ s * φ s) + φ s * φ s
    ring
  rw [h_pt]
  -- Σ (a + b + c) = Σa + Σb + Σc
  rw [show
        (fun s : MultimodeFockState k N =>
          ψ s * ψ s + 2 * (ψ s * φ s) + φ s * φ s)
        = (fun s => (ψ s * ψ s + 2 * (ψ s * φ s)) + φ s * φ s) by rfl]
  rw [Finset.sum_add_distrib]
  rw [show
        (fun s : MultimodeFockState k N =>
          ψ s * ψ s + 2 * (ψ s * φ s))
        = (fun s => ψ s * ψ s + 2 * (ψ s * φ s)) from rfl]
  rw [Finset.sum_add_distrib]
  -- Pull constant 2 out
  rw [show (fun s : MultimodeFockState k N => 2 * (ψ s * φ s))
        = (fun s => 2 * (ψ s * φ s)) from rfl]
  rw [← Finset.mul_sum]

/-! ## 4. Parallelogram identity -/

/-- **Parallelogram identity**:
    `⟨ψ + φ, ψ + φ⟩ + ⟨ψ - φ, ψ - φ⟩ = 2·⟨ψ, ψ⟩ + 2·⟨φ, φ⟩`.

    Direct algebraic identity from binomial expansion. -/
theorem parallelogram_identity
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    innerProduct (ψ + φ) (ψ + φ) + innerProduct (ψ - φ) (ψ - φ) =
      2 * innerProduct ψ ψ + 2 * innerProduct φ φ := by
  unfold innerProduct
  rw [← Finset.sum_add_distrib]
  rw [show ((2 : ℝ) * (Finset.univ.sum fun s : MultimodeFockState k N => ψ s * ψ s) +
            (2 : ℝ) * (Finset.univ.sum fun s => φ s * φ s))
        = Finset.univ.sum (fun s : MultimodeFockState k N =>
            2 * (ψ s * ψ s) + 2 * (φ s * φ s)) by
        rw [Finset.sum_add_distrib]
        congr 1
        · rw [← Finset.mul_sum]
        · rw [← Finset.mul_sum]]
  apply Finset.sum_congr rfl
  intros s _
  change (ψ s + φ s) * (ψ s + φ s) + (ψ s - φ s) * (ψ s - φ s)
         = 2 * (ψ s * ψ s) + 2 * (φ s * φ s)
  ring

/-! ## 5. Polarisation identity (real form) -/

/-- **Polarisation identity** (real form):
    `4·⟨ψ, φ⟩ = ⟨ψ + φ, ψ + φ⟩ - ⟨ψ - φ, ψ - φ⟩`. -/
theorem polarisation_identity
    {k N : ℕ} (ψ φ : WaveFunction k N) :
    4 * innerProduct ψ φ =
      innerProduct (ψ + φ) (ψ + φ) - innerProduct (ψ - φ) (ψ - φ) := by
  unfold innerProduct
  rw [show ((4 : ℝ) * (Finset.univ.sum fun s : MultimodeFockState k N => ψ s * φ s))
        = Finset.univ.sum (fun s : MultimodeFockState k N => 4 * (ψ s * φ s))
        from by rw [Finset.mul_sum]]
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intros s _
  change 4 * (ψ s * φ s) = (ψ s + φ s) * (ψ s + φ s) - (ψ s - φ s) * (ψ s - φ s)
  ring

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 7.12 headline — multi-mode wave-function
    bilinear / parallelogram / polarisation structural report.**

    For any number of modes `k : ℕ`, truncation `N : ℕ`, and wave
    functions `ψ, φ, φ' : WaveFunction k N`, scalar `c : ℝ`:

    1. **Linearity in right argument**:
       `⟨ψ, φ + φ'⟩ = ⟨ψ, φ⟩ + ⟨ψ, φ'⟩`.

    2. **Right scalar homogeneity**:
       `⟨ψ, c · φ⟩ = c · ⟨ψ, φ⟩`.

    3. **Parallelogram identity**:
       `⟨ψ + φ, ψ + φ⟩ + ⟨ψ - φ, ψ - φ⟩ = 2·⟨ψ, ψ⟩ + 2·⟨φ, φ⟩`.

    4. **Polarisation identity**:
       `4·⟨ψ, φ⟩ = ⟨ψ + φ, ψ + φ⟩ - ⟨ψ - φ, ψ - φ⟩`. -/
theorem multimode_wave_function_bilinear_report
    {k N : ℕ} (c : ℝ) (ψ φ φ' : WaveFunction k N) :
    innerProduct ψ (φ + φ') = innerProduct ψ φ + innerProduct ψ φ' ∧
    innerProduct ψ (c • φ) = c * innerProduct ψ φ ∧
    innerProduct (ψ + φ) (ψ + φ) + innerProduct (ψ - φ) (ψ - φ) =
      2 * innerProduct ψ ψ + 2 * innerProduct φ φ ∧
    4 * innerProduct ψ φ =
      innerProduct (ψ + φ) (ψ + φ) - innerProduct (ψ - φ) (ψ - φ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact innerProduct_add_right ψ φ φ'
  · exact innerProduct_smul_right c ψ φ
  · exact parallelogram_identity ψ φ
  · exact polarisation_identity ψ φ

end OmegaTheory.Foundations.MultimodeWaveFunctionBilinear
