/-
  OmegaTheory.QuantumGravity.SubstrateExpectationBound

  **Lion's-Pride Phase 9.32 (2026-05-06)**:
  *Substrate-physics expectation bound — for any normalised
  multi-mode wave function ψ on `MultimodeFockState k N`, the
  total-number expectation is bounded:
  `⟨ψ|N̂|ψ⟩ ≤ k · N`.*

  ## Why this file

  Phase 7.18 (`MultimodeWaveFunctionExpectation`) shipped:

      ⟨ψ| N̂ |ψ⟩ := Σ_state ψ(state)² · totalNumberEigenvalue state

  Phase 9.31 (`SubstrateBornRule`) shipped Born probability and
  total-probability = 1 for normalised ψ.

  This file bridges them: since each `totalNumberEigenvalue state`
  is bounded by `k · N` (the product of mode count `k` and per-mode
  truncation `N`), and `Σ_state ψ(state)² = 1` for normalised ψ,
  the expectation is bounded:

      ⟨ψ| N̂ |ψ⟩ = Σ ψ(s)² · n(s) ≤ Σ ψ(s)² · (k·N) = (k·N) · 1 = k·N.

  This is a CONCRETE NUMERICAL bound — a physical statement that
  the QM expectation of the total occupation is at most the maximum
  capacity `k·N`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `totalNumberEigenvalue_le_kN`                         | totalN(state) ≤ k·N                                   |
  | `expectationN_le_kN_of_normalised`                    | normalised ⟹ ⟨ψ\|N̂\|ψ⟩ ≤ k·N                         |
  | Headline (2-conjunct)                                 | `substrate_expectation_bound_report`                 |

  ## Author

  Lion's-Pride dynamic /loop iteration 92 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeNumberOperators
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
import OmegaTheory.QuantumGravity.SubstrateQMProbability
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateExpectationBound

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
open OmegaTheory.QuantumGravity.SubstrateQMProbability

/-! ## 1. Total-number eigenvalue bound -/

/-- **totalNumberEigenvalue ≤ k · N**: for any multi-mode basis
    state, the total occupation is at most `k · N` since each of
    the `k` modes has occupation in `Fin (N+1)` (so at most `N`). -/
theorem totalNumberEigenvalue_le_kN
    {k N : ℕ} (state : MultimodeFockState k N) :
    totalNumberEigenvalue state ≤ k * N := by
  unfold totalNumberEigenvalue
  -- Σ_{i ∈ Fin k} (state i).val ≤ Σ_{i ∈ Fin k} N = k · N
  calc Finset.univ.sum (fun i : Fin k => (state i).val)
      ≤ Finset.univ.sum (fun i : Fin k => N) := by
        apply Finset.sum_le_sum
        intros i _
        -- (state i).val < N+1, so ≤ N
        have h_lt : (state i).val < N + 1 := (state i).isLt
        omega
    _ = k * N := by
        rw [Finset.sum_const]
        simp [Finset.card_univ, Fintype.card_fin]

/-! ## 2. Expectation bound for normalised wave functions -/

/-- **Expectation bound for normalised ψ**:
    `IsNormalised ψ ⟹ ⟨ψ| N̂ |ψ⟩ ≤ k · N`.

    Proof: `⟨ψ|N̂|ψ⟩ = Σ ψ(s)² · n(s) ≤ Σ ψ(s)² · (k·N) =
    (k·N) · Σ ψ(s)² = k·N` for normalised ψ. -/
theorem expectationN_le_kN_of_normalised
    {k N : ℕ} [NeZero k] (ψ : WaveFunction k N)
    (h_norm : IsNormalised ψ) :
    expectationN ψ ≤ (k * N : ℝ) := by
  unfold expectationN
  -- Σ_s ψ(s)² · totalN(s) ≤ Σ_s ψ(s)² · (k·N) = (k·N) · Σ_s ψ(s)² = k·N
  have h_pointwise : ∀ s ∈ (Finset.univ : Finset (MultimodeFockState k N)),
      (ψ s)^2 * (totalNumberEigenvalue s : ℝ) ≤ (ψ s)^2 * (k * N : ℝ) := by
    intros s _
    apply mul_le_mul_of_nonneg_left
    · exact_mod_cast totalNumberEigenvalue_le_kN s
    · exact sq_nonneg (ψ s)
  calc Finset.univ.sum (fun s : MultimodeFockState k N =>
        (ψ s)^2 * (totalNumberEigenvalue s : ℝ))
      ≤ Finset.univ.sum (fun s : MultimodeFockState k N =>
          (ψ s)^2 * (k * N : ℝ)) := Finset.sum_le_sum h_pointwise
    _ = (k * N : ℝ) * Finset.univ.sum (fun s : MultimodeFockState k N => (ψ s)^2) := by
        rw [← Finset.sum_mul]
        ring_nf
    _ = (k * N : ℝ) * innerProduct ψ ψ := by
        congr 1
        unfold innerProduct
        apply Finset.sum_congr rfl
        intros s _
        ring
    _ = (k * N : ℝ) * 1 := by
        unfold IsNormalised at h_norm
        rw [h_norm]
    _ = (k * N : ℝ) := by ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.32 headline — substrate expectation bound
    structural report.**

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`), basis state
    `state : MultimodeFockState k N`, and a NORMALISED wave function
    `ψ : WaveFunction k N`:

    1. **Per-state total-number bound**:
       `totalNumberEigenvalue state ≤ k · N`.

    2. **Expectation bound for normalised ψ**:
       `⟨ψ| N̂ |ψ⟩ ≤ k · N`. -/
theorem substrate_expectation_bound_report
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N)
    (ψ : WaveFunction k N) (h_norm : IsNormalised ψ) :
    totalNumberEigenvalue state ≤ k * N ∧
    expectationN ψ ≤ (k * N : ℝ) := by
  refine ⟨?_, ?_⟩
  · exact totalNumberEigenvalue_le_kN state
  · exact expectationN_le_kN_of_normalised ψ h_norm

end OmegaTheory.QuantumGravity.SubstrateExpectationBound
