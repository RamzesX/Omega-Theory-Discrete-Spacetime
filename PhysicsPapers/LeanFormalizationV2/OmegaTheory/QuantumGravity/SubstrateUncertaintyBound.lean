/-
  OmegaTheory.QuantumGravity.SubstrateUncertaintyBound

  **Lion's-Pride Phase 9.33 (2026-05-06)**:
  *Substrate uncertainty bounded form — for normalised multi-mode
  wave functions ψ, the variance is sandwiched: `0 ≤ (ΔN̂)²(ψ) ≤
  ⟨ψ|N̂²|ψ⟩ ≤ (k·N)²`.*

  ## Why this file

  Phase 7.21 (`MultimodeWaveFunctionVarianceNonneg`) shipped:

      IsNormalised ψ ⟹ 0 ≤ varianceN ψ.

  Phase 9.32 (`SubstrateExpectationBound`) shipped:

      IsNormalised ψ ⟹ ⟨ψ|N̂|ψ⟩ ≤ k·N.

  This file ships the analog **second-moment bound** and the
  combined **uncertainty sandwich**:

  1. `⟨ψ|N̂²|ψ⟩ ≤ (k·N)²` for normalised ψ.
  2. `(ΔN̂)²(ψ) ≤ ⟨ψ|N̂²|ψ⟩` (since Var = ⟨N̂²⟩ - ⟨N̂⟩² ≤ ⟨N̂²⟩).
  3. Combined: `0 ≤ (ΔN̂)²(ψ) ≤ (k·N)²` for normalised ψ.

  Physical content: the QM uncertainty in the total-number observable
  is bounded by the maximum capacity squared `(k·N)²`.  This is the
  substrate-side Heisenberg upper bound — finite and concrete.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `expectationN_squared_le_kN_sq_of_normalised`         | normalised ⟹ ⟨ψ\|N̂²\|ψ⟩ ≤ (k·N)²                    |
  | `varianceN_le_expectationN_squared`                   | (ΔN̂)² ≤ ⟨N̂²⟩ (always — trivial sub)                  |
  | `varianceN_le_kN_sq_of_normalised`                    | normalised ⟹ (ΔN̂)² ≤ (k·N)²                          |
  | Headline (3-conjunct)                                 | `substrate_uncertainty_bound_report`                 |

  ## Author

  Lion's-Pride dynamic /loop iteration 93 (2026-05-06).
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
import OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
import OmegaTheory.QuantumGravity.SubstrateExpectationBound
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateUncertaintyBound

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
open OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
open OmegaTheory.Foundations.MultimodeWaveFunctionVariance
open OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
open OmegaTheory.QuantumGravity.SubstrateExpectationBound

/-! ## 1. Second-moment bound -/

/-- **Second-moment bound for normalised ψ**:
    `⟨ψ|N̂²|ψ⟩ ≤ (k·N)²`.

    Proof: `Σ ψ(s)²·n(s)² ≤ Σ ψ(s)²·(k·N)² = (k·N)²·Σ ψ(s)² = (k·N)²`
    using `n(s) ≤ k·N` (Phase 9.32) and `Σ ψ(s)² = 1` (normalised). -/
theorem expectationN_squared_le_kN_sq_of_normalised
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N)
    (h_norm : IsNormalised ψ) :
    expectationN_squared ψ ≤ ((k * N : ℝ))^2 := by
  unfold expectationN_squared
  -- Σ ψ(s)² · n(s)² ≤ Σ ψ(s)² · (k·N)² = (k·N)² · Σ ψ(s)² = (k·N)² · 1
  have h_pointwise : ∀ s ∈ (Finset.univ : Finset (MultimodeFockState k N)),
      (ψ s)^2 * (totalNumberEigenvalue s : ℝ)^2 ≤ (ψ s)^2 * ((k * N : ℝ))^2 := by
    intros s _
    apply mul_le_mul_of_nonneg_left
    · -- (totalN(s))² ≤ (k·N)² since totalN(s) ≤ k·N and both non-neg
      have h_n_le : (totalNumberEigenvalue s : ℝ) ≤ (k * N : ℝ) := by
        exact_mod_cast totalNumberEigenvalue_le_kN s
      have h_n_nn : (0 : ℝ) ≤ (totalNumberEigenvalue s : ℝ) := by
        exact_mod_cast (Nat.zero_le _)
      have h_kN_nn : (0 : ℝ) ≤ (k * N : ℝ) := by positivity
      nlinarith [h_n_le, h_n_nn, h_kN_nn]
    · exact sq_nonneg (ψ s)
  calc Finset.univ.sum (fun s : MultimodeFockState k N =>
        (ψ s)^2 * (totalNumberEigenvalue s : ℝ)^2)
      ≤ Finset.univ.sum (fun s : MultimodeFockState k N =>
          (ψ s)^2 * ((k * N : ℝ))^2) := Finset.sum_le_sum h_pointwise
    _ = ((k * N : ℝ))^2 * Finset.univ.sum (fun s : MultimodeFockState k N => (ψ s)^2) := by
        rw [← Finset.sum_mul]
        ring_nf
    _ = ((k * N : ℝ))^2 * innerProduct ψ ψ := by
        congr 1
        unfold innerProduct
        apply Finset.sum_congr rfl
        intros s _
        ring
    _ = ((k * N : ℝ))^2 * 1 := by
        unfold IsNormalised at h_norm
        rw [h_norm]
    _ = ((k * N : ℝ))^2 := by ring

/-! ## 2. Variance ≤ second moment -/

/-- **Variance ≤ second moment** (always):
    `(ΔN̂)²(ψ) ≤ ⟨ψ|N̂²|ψ⟩`.

    Proof: `Var = ⟨N̂²⟩ - ⟨N̂⟩² ≤ ⟨N̂²⟩` since `⟨N̂⟩² ≥ 0`. -/
theorem varianceN_le_expectationN_squared
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N) :
    varianceN ψ ≤ expectationN_squared ψ := by
  unfold varianceN
  have h_sq : 0 ≤ (expectationN ψ)^2 := sq_nonneg _
  linarith

/-! ## 3. Combined variance bound -/

/-- **Variance bound for normalised ψ**:
    `(ΔN̂)²(ψ) ≤ (k·N)²` for normalised ψ.

    Combines `Var ≤ ⟨N̂²⟩` (always) with `⟨N̂²⟩ ≤ (k·N)²` (normalised). -/
theorem varianceN_le_kN_sq_of_normalised
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N)
    (h_norm : IsNormalised ψ) :
    varianceN ψ ≤ ((k * N : ℝ))^2 := by
  have h1 : varianceN ψ ≤ expectationN_squared ψ :=
    varianceN_le_expectationN_squared ψ
  have h2 : expectationN_squared ψ ≤ ((k * N : ℝ))^2 :=
    expectationN_squared_le_kN_sq_of_normalised ψ h_norm
  linarith

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 9.33 headline — substrate uncertainty
    bounded form structural report.**

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`) and a
    NORMALISED wave function `ψ : WaveFunction k N`:

    1. **Second-moment bound**:
       `⟨ψ|N̂²|ψ⟩ ≤ (k·N)²`.

    2. **Variance ≤ second moment** (always):
       `(ΔN̂)²(ψ) ≤ ⟨ψ|N̂²|ψ⟩`.

    3. **Variance bound for normalised ψ**:
       `(ΔN̂)²(ψ) ≤ (k·N)²`. -/
theorem substrate_uncertainty_bound_report
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N)
    (h_norm : IsNormalised ψ) :
    expectationN_squared ψ ≤ ((k * N : ℝ))^2 ∧
    varianceN ψ ≤ expectationN_squared ψ ∧
    varianceN ψ ≤ ((k * N : ℝ))^2 := by
  refine ⟨?_, ?_, ?_⟩
  · exact expectationN_squared_le_kN_sq_of_normalised ψ h_norm
  · exact varianceN_le_expectationN_squared ψ
  · exact varianceN_le_kN_sq_of_normalised ψ h_norm

end OmegaTheory.QuantumGravity.SubstrateUncertaintyBound
