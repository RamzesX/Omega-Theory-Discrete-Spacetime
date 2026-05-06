/-
  OmegaTheory.Foundations.MultimodeWaveFunctionReverseCS

  **Lion's-Pride Phase 8.8 (2026-05-06)**:
  *Multi-mode wave-function reverse Cauchy-Schwarz threshold —
  if `|⟨ψ, φ⟩| ≥ c`, then `⟨ψ, ψ⟩ · ⟨φ, φ⟩ ≥ c²`. Threshold
  lower bound complementing the squared CS upper bound from 7.11.*

  ## Why this file

  Phase 7.11 (`MultimodeWaveFunctionCauchySchwarz`) shipped:

      ⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩.

  This file ships the contrapositive in threshold form: if
  `|⟨ψ, φ⟩| ≥ c`, then `c² ≤ ⟨ψ, φ⟩²` (squaring), and combined with
  CS, `c² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩`.

  Physical content: a known LOWER bound on the inner-product
  magnitude (e.g., from substrate physical-coupling lower bound)
  IMPLIES a lower bound on the product of self-norms.  This is
  useful for Heisenberg-type uncertainty bounds where one knows
  the commutator expectation but wants to constrain the product
  of variances.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `inner_sq_ge_of_abs_ge`                               | c ≤ |⟨ψ, φ⟩| ⟹ c² ≤ ⟨ψ, φ⟩²                            |
  | `normSq_product_ge_of_inner_abs_ge`                   | 0 ≤ c, c ≤ |⟨ψ, φ⟩| ⟹ c² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩            |
  | Headline (2-conjunct)                                 | `multimode_wave_function_reverse_cs_report`         |

  ## Author

  Lion's-Pride dynamic /loop iteration 96 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionCauchySchwarz
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeWaveFunctionReverseCS

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionCauchySchwarz

/-! ## 1. Inner squared lower bound from absolute value -/

/-- **Inner squared lower bound from absolute value**:
    if `0 ≤ c` and `c ≤ |⟨ψ, φ⟩|`, then `c² ≤ ⟨ψ, φ⟩²`. -/
theorem inner_sq_ge_of_abs_ge
    {k N : ℕ} (ψ φ : WaveFunction k N) (c : ℝ)
    (hc_nn : 0 ≤ c) (h_abs_ge : c ≤ |innerProduct ψ φ|) :
    c^2 ≤ (innerProduct ψ φ)^2 := by
  -- c² ≤ |⟨ψ, φ⟩|² = ⟨ψ, φ⟩²
  have h_sq : c^2 ≤ |innerProduct ψ φ|^2 := by
    nlinarith [hc_nn, h_abs_ge, abs_nonneg (innerProduct ψ φ)]
  rwa [sq_abs] at h_sq

/-! ## 2. Norm-squared product lower bound -/

/-- **Norm-squared product lower bound from inner-product
    threshold**: if `0 ≤ c` and `c ≤ |⟨ψ, φ⟩|`, then
    `c² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩`. -/
theorem normSq_product_ge_of_inner_abs_ge
    {k N : ℕ} (ψ φ : WaveFunction k N) (c : ℝ)
    (hc_nn : 0 ≤ c) (h_abs_ge : c ≤ |innerProduct ψ φ|) :
    c^2 ≤ innerProduct ψ ψ * innerProduct φ φ := by
  -- Step 1: c² ≤ ⟨ψ, φ⟩² from threshold
  have h1 : c^2 ≤ (innerProduct ψ φ)^2 :=
    inner_sq_ge_of_abs_ge ψ φ c hc_nn h_abs_ge
  -- Step 2: ⟨ψ, φ⟩² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩ from Cauchy-Schwarz
  have h2 : (innerProduct ψ φ)^2 ≤ innerProduct ψ ψ * innerProduct φ φ :=
    cauchy_schwarz_sq ψ φ
  -- Combine: c² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩
  linarith

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 8.8 headline — multi-mode wave-function
    reverse Cauchy-Schwarz threshold structural report.**

    For multi-mode parameters `k N : ℕ`, wave functions
    `ψ φ : WaveFunction k N`, and a non-negative threshold `c : ℝ`
    with `c ≤ |⟨ψ, φ⟩|`:

    1. **Squared lower bound**:
       `c² ≤ ⟨ψ, φ⟩²`.

    2. **Norm-squared product lower bound**:
       `c² ≤ ⟨ψ, ψ⟩ · ⟨φ, φ⟩`. -/
theorem multimode_wave_function_reverse_cs_report
    {k N : ℕ} (ψ φ : WaveFunction k N) (c : ℝ)
    (hc_nn : 0 ≤ c) (h_abs_ge : c ≤ |innerProduct ψ φ|) :
    c^2 ≤ (innerProduct ψ φ)^2 ∧
    c^2 ≤ innerProduct ψ ψ * innerProduct φ φ := by
  refine ⟨?_, ?_⟩
  · exact inner_sq_ge_of_abs_ge ψ φ c hc_nn h_abs_ge
  · exact normSq_product_ge_of_inner_abs_ge ψ φ c hc_nn h_abs_ge

end OmegaTheory.Foundations.MultimodeWaveFunctionReverseCS
