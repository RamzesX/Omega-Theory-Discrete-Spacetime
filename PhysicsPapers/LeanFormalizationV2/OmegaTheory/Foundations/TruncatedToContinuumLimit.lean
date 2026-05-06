/-
  OmegaTheory.Foundations.TruncatedToContinuumLimit

  **Lion's-Pride Phase 6.5l (2026-05-06)**:
  *Convergence theorem: the FORMAL truncated heat trace
  `truncatedHeatTrace T N t` converges to the ANALYTIC heat trace
  `Tr(e^{-t·D²})` as N → ∞ — closing the formal-vs-analytic loop.*

  ## Why this file

  Phase 6.4 shipped the formal truncation:
      truncatedHeatTrace T N t  =  Σ_{k=0..N} (-t)^k/k! · a_k(T)

  Phase 6.5k shipped the convergent tsum identity:
      Tr(e^{-t·D²})  =  Σ' k, (k!⁻¹) · (-t)^k · a_k(T)

  This file ships the bridge: the truncated heat trace IS the N-th
  partial sum of the convergent series.  Hence as N → ∞:

      truncatedHeatTrace T N t  →  Tr(e^{-t·D²})

  The convergence is in the topology of ℂ (the trace's target).

  ## What this file ships

  | Property                                          | Theorem                                  |
  |---------------------------------------------------|------------------------------------------|
  | Truncated heat trace summand identification       | `truncatedHeatTrace_eq_partial_sum`       |
  | Limit of partial sums = tsum (Mathlib std)        | (used directly via `HasSum.tsum_eq`)      |
  | Truncated → analytic as N → ∞                     | `truncatedHeatTrace_tendsto_continuum`     |
  | Headline 2-conjunct                                | `truncated_to_continuum_limit_report`      |

  ## Honest scope

  This file ships the rigorous limit theorem identifying
  `truncatedHeatTrace` with the partial-sum-of-tsum form of the
  Mathlib analytic heat trace.

  ## Lion's-Pride doctrine applied (BUILD_MATHLIB_MACHINERY_T6_13)

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Direct composition via Phase 6.4 + Phase 6.5k + Mathlib `HasSum`/
  `tsum_eq_sum` + `Tendsto.partialSums_atTop`.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.HeatKernelTaylorConvergence
import OmegaTheory.Foundations.SpectralActionTruncated
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

attribute [local instance] Matrix.linftyOpNormedRing
attribute [local instance] Matrix.linftyOpNormedAlgebra

namespace OmegaTheory.Foundations.TruncatedToContinuumLimit

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.SpectralActionTruncated
open OmegaTheory.Foundations.HeatKernelTaylorConvergence

variable {n : ℕ}

/-! ## 1. Truncated heat trace = partial sum form -/

/-- **Truncated heat trace as a partial sum**:

    `truncatedHeatTrace T N t
       = Σ_{k ∈ range(N+1)}, (k!⁻¹ : ℂ) · (-t)^k · a_k(T)`

    Same as Phase 6.4 definition, but rewritten to match the summand
    form used in the convergent tsum identity (Phase 6.5k). -/
theorem truncatedHeatTrace_eq_partial_sum
    (T : FiniteSpectralTriple n) (N : ℕ) (t : ℂ) :
    truncatedHeatTrace T N t
      = ∑ k ∈ Finset.range (N + 1),
          ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k := by
  unfold truncatedHeatTrace
  apply Finset.sum_congr rfl
  intros k _
  -- Goal: (-t)^k / k! * a_k = (k!⁻¹) * (-t)^k * a_k
  ring

/-! ## 2. Truncated → analytic heat trace as N → ∞ -/

/-- **Convergence theorem**: `truncatedHeatTrace T N t → Tr(e^{-t·D²})` as N → ∞.

    The truncated heat trace IS the N-th partial sum of the convergent
    series `Σ' k, (k!⁻¹) · (-t)^k · a_k(T)`, which by Phase 6.5k equals
    `Tr(e^{-t·D²})`.  Standard `tsum_eq_partial_sum_limit` closes this. -/
theorem truncatedHeatTrace_tendsto_continuum
    (T : FiniteSpectralTriple n) (t : ℂ) :
    Filter.Tendsto (fun N : ℕ => truncatedHeatTrace T N t)
      Filter.atTop
      (nhds (NormedSpace.exp (-(t • T.D ^ 2))).trace) := by
  -- Express truncated heat trace as partial sums of the Taylor series
  have h_summand : ∀ N : ℕ, truncatedHeatTrace T N t
        = ∑ k ∈ Finset.range (N + 1),
            ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k := by
    intro N; exact truncatedHeatTrace_eq_partial_sum T N t
  -- Use Phase 6.5k: tsum of the same summand = analytic heat trace
  have h_tsum : (NormedSpace.exp (-(t • T.D ^ 2))).trace
      = ∑' k : ℕ, ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k :=
    tr_heatKernel_eq_tsum_heatKernelCoef T t
  -- The series is summable (since exp_eq_tsum converges)
  have h_summable :
      Summable (fun k : ℕ => ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k) := by
    -- summability transferred from the matrix exp series via trace
    have h_mat_sum : Summable (fun k : ℕ =>
        ((Nat.factorial k : ℂ)⁻¹) • (-(t • T.D ^ 2)) ^ k) := by
      have := NormedSpace.expSeries_summable' (𝕂 := ℂ) (-(t • T.D ^ 2))
      simpa using this
    -- pull through traceCLM
    have h_trace_sum := h_mat_sum.mapL (Matrix.traceCLM n)
    -- Each summand: traceCLM ((k!⁻¹) • (-(t • D²))^k) = (k!⁻¹) * (-t)^k * a_k
    convert h_trace_sum using 1
    ext k
    rw [Matrix.traceCLM_apply]
    rw [show (-(t • T.D ^ 2 : Matrix (Fin n) (Fin n) ℂ)) ^ k
          = ((-t) ^ k) • (T.D ^ 2) ^ k from by
         rw [show -(t • T.D ^ 2 : Matrix (Fin n) (Fin n) ℂ)
              = (-t) • T.D ^ 2 from by rw [neg_smul]]
         rw [smul_pow]]
    rw [show ((T.D ^ 2 : Matrix (Fin n) (Fin n) ℂ)) ^ k = T.D ^ (2 * k) from
         (pow_mul T.D 2 k).symm]
    rw [Matrix.trace_smul, Matrix.trace_smul]
    unfold heatKernelCoef
    rw [smul_eq_mul, smul_eq_mul]
    ring
  -- Apply: partial sums of a summable series tend to its tsum
  rw [h_tsum]
  -- Replace lhs function with the partial-sum form
  have h_eq : (fun N : ℕ => truncatedHeatTrace T N t)
      = (fun N : ℕ => ∑ k ∈ Finset.range (N + 1),
          ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k) := by
    funext N; exact h_summand N
  rw [h_eq]
  -- partial sums Σ_{k < N+1} → Σ' k from summability
  -- HasSum.tendsto_sum_nat gives Σ_{k < N} → tsum, so we shift N → N+1
  have htend : Filter.Tendsto
      (fun N : ℕ => ∑ k ∈ Finset.range N,
          ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k)
      Filter.atTop
      (nhds (∑' k : ℕ, ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k)) :=
    h_summable.hasSum.tendsto_sum_nat
  -- (fun N => Σ k ∈ range (N+1), f k) = (fun n => Σ k ∈ range n, f k) ∘ Nat.succ
  have h_succ_atTop : Filter.Tendsto Nat.succ Filter.atTop Filter.atTop :=
    Filter.tendsto_atTop_atTop.mpr fun b => ⟨b, fun a ha => by omega⟩
  exact htend.comp h_succ_atTop

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.5l headline — truncated to continuum convergence.**

    For any finite spectral triple `T : FiniteSpectralTriple n` and
    parameter `t : ℂ`:

    1. **Truncated as partial sum**: `truncatedHeatTrace T N t` equals
       the partial sum `Σ_{k ≤ N} (k!⁻¹) · (-t)^k · a_k(T)`.

    2. **Convergence to analytic heat trace**:
       `truncatedHeatTrace T N t → Tr(e^{-t·D²})` as `N → ∞`. -/
theorem truncated_to_continuum_limit_report
    (T : FiniteSpectralTriple n) (t : ℂ) :
    (∀ N : ℕ, truncatedHeatTrace T N t
      = ∑ k ∈ Finset.range (N + 1),
          ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k) ∧
    Filter.Tendsto (fun N : ℕ => truncatedHeatTrace T N t)
      Filter.atTop
      (nhds (NormedSpace.exp (-(t • T.D ^ 2))).trace) := by
  refine ⟨?_, ?_⟩
  · intro N; exact truncatedHeatTrace_eq_partial_sum T N t
  · exact truncatedHeatTrace_tendsto_continuum T t

end OmegaTheory.Foundations.TruncatedToContinuumLimit
