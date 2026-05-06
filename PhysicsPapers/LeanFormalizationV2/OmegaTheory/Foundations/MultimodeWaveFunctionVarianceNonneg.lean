/-
  OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg

  **Lion's-Pride Phase 7.21 (2026-05-06)**:
  *Multi-mode wave-function variance non-negativity for normalised
  states: `0 ≤ (ΔN̂)²(ψ)` whenever `IsNormalised ψ`.*

  ## Why this file

  Phase 7.20 (`MultimodeWaveFunctionVariance`) shipped the variance
  `(ΔN̂)²(ψ) := ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²` with basis-state evaluation = 0
  (eigenstate property), but DEFERRED the general non-negativity
  claim to Phase 7.21.

  This file ships the deferred result via the discrete Cauchy-Schwarz
  inequality.  For normalised ψ (i.e., `Σ ψ(s)² = 1`):

      (E[N])² = (Σ ψ(s)² · n(s))²
              = (Σ (ψ(s) · n(s)) · ψ(s))²
              ≤ (Σ (ψ(s) · n(s))²) · (Σ ψ(s)²)        [Cauchy-Schwarz]
              = (Σ ψ(s)² · n(s)²) · 1
              = E[N²]

  Hence `E[N²] - E[N]² ≥ 0`, i.e. `(ΔN̂)² ≥ 0`.

  This is the substrate-side input to Heisenberg's uncertainty
  principle: the variance is non-negative on physical (normalised)
  states.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `varianceN_nonneg_of_normalised`                      | IsNormalised ψ ⟹ 0 ≤ varianceN ψ                       |
  | Headline (1-conjunct)                                 | `multimode_wave_function_variance_nonneg_report`     |

  ## Author

  Lion's-Pride dynamic /loop iteration 87 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeNumberOperators
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
import OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
import OmegaTheory.Foundations.MultimodeWaveFunctionVariance
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
open OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
open OmegaTheory.Foundations.MultimodeWaveFunctionVariance

/-! ## 1. Variance non-negativity for normalised states -/

/-- **Variance non-negativity for normalised states**: for any
    normalised wave function `ψ` (i.e., `⟨ψ, ψ⟩ = 1`), the variance
    is non-negative: `0 ≤ (ΔN̂)²(ψ)`.

    Proof: by Cauchy-Schwarz on the sequences
    `f(s) := ψ(s) · n(s)` and `g(s) := ψ(s)`:

        (Σ f(s)·g(s))² ≤ (Σ f(s)²) · (Σ g(s)²)

    where:
    * Σ f·g = Σ ψ(s)²·n(s) = E[N]
    * Σ f² = Σ ψ(s)²·n(s)² = E[N²]
    * Σ g² = Σ ψ(s)² = 1 (normalisation)

    Hence (E[N])² ≤ E[N²] · 1, so `Var(N) = E[N²] - E[N]² ≥ 0`. -/
theorem varianceN_nonneg_of_normalised
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N)
    (h_norm : IsNormalised ψ) :
    0 ≤ varianceN ψ := by
  unfold varianceN
  -- Goal: 0 ≤ ⟨ψ|N̂²|ψ⟩ - ⟨ψ|N̂|ψ⟩²
  -- Equivalent to: ⟨ψ|N̂|ψ⟩² ≤ ⟨ψ|N̂²|ψ⟩
  -- Use Cauchy-Schwarz on f(s) = ψ(s)·n(s), g(s) = ψ(s)
  have h_CS : (Finset.univ.sum fun s : MultimodeFockState k N =>
                  (ψ s * (totalNumberEigenvalue s : ℝ)) * ψ s)^2
              ≤ (Finset.univ.sum fun s : MultimodeFockState k N =>
                  (ψ s * (totalNumberEigenvalue s : ℝ))^2)
                * (Finset.univ.sum fun s : MultimodeFockState k N => (ψ s)^2) :=
    Finset.sum_mul_sq_le_sq_mul_sq Finset.univ
      (fun s => ψ s * (totalNumberEigenvalue s : ℝ))
      (fun s => ψ s)
  -- Goal LHS in expectation form
  have h_lhs :
      (Finset.univ.sum fun s : MultimodeFockState k N =>
                  (ψ s * (totalNumberEigenvalue s : ℝ)) * ψ s)
      = expectationN ψ := by
    unfold expectationN
    apply Finset.sum_congr rfl
    intros s _
    ring
  have h_rhs1 :
      (Finset.univ.sum fun s : MultimodeFockState k N =>
        (ψ s * (totalNumberEigenvalue s : ℝ))^2)
      = expectationN_squared ψ := by
    unfold expectationN_squared
    apply Finset.sum_congr rfl
    intros s _
    ring
  have h_rhs2 :
      (Finset.univ.sum fun s : MultimodeFockState k N => (ψ s)^2)
      = innerProduct ψ ψ := by
    unfold innerProduct
    apply Finset.sum_congr rfl
    intros s _
    ring
  rw [h_lhs, h_rhs1, h_rhs2] at h_CS
  -- h_CS: (expectationN ψ)² ≤ expectationN_squared ψ · ⟨ψ, ψ⟩
  unfold IsNormalised at h_norm
  rw [h_norm, mul_one] at h_CS
  -- h_CS: (expectationN ψ)² ≤ expectationN_squared ψ
  linarith

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 7.21 headline — multi-mode wave-function
    variance non-negativity structural report.**

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`) and a
    NORMALISED wave function `ψ : WaveFunction k N`:

    1. **Variance non-negativity**:
       `0 ≤ (ΔN̂)²(ψ)`. -/
theorem multimode_wave_function_variance_nonneg_report
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N)
    (h_norm : IsNormalised ψ) :
    0 ≤ varianceN ψ :=
  varianceN_nonneg_of_normalised ψ h_norm

end OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
