/-
  OmegaTheory.Foundations.HeatKernelTaylorConvergence

  **Lion's-Pride Phase 6.5k (2026-05-06)**:
  *Proof that `Tr(e^{-t·D²})` admits the convergent Taylor series
  `Σ' k : ℕ, (-t)^k / k! · a_k(T)` (an actual `tsum`, not just a
  formal Taylor partial sum), via Mathlib's `NormedSpace.exp_eq_tsum`
  composed with continuity of trace on finite-dim matrices.*

  ## Why this file

  Phase 6.4 shipped the formal Taylor TRUNCATION:

      truncatedHeatTrace T N t  =  Σ_{k=0..N} (-t)^k / k! · a_k(T)

  Phase 6.5j shipped the GENUINE analytic heat kernel for Yukawa-
  diagonal D in closed form `Tr(e^{-t·D²}) = Σᵢ exp(-t·y_i²)`.

  This file ships the FULL convergent Taylor series identity for ANY
  finite spectral triple (not just Yukawa-diagonal):

      Tr(e^{-t·D²})  =  Σ' k, (n!⁻¹ : ℂ) • (-(t • D²))^k          (Mathlib exp)
                     =  Σ' k, (-t)^k / k! · Tr(D^{2k})              (trace + smul algebra)
                     =  Σ' k, (-t)^k / k! · a_k(T)

  The tsum is GUARANTEED to converge in finite dim: matrix exponential
  always converges absolutely.  Hence `truncatedHeatTrace T N t` IS
  the N-th partial sum of an actual convergent infinite series.

  The work is:

  1. `Matrix.traceCLM` — upgrade `Matrix.traceLinearMap` to a
     `ContinuousLinearMap` (uses `LinearMap.toContinuousLinearMap` from
     finite-dim infrastructure).
  2. Apply `ContinuousLinearMap.map_tsum` to swap trace and tsum.
  3. Identify each summand `Tr((-(t • D²))^k / k!) = (-t)^k / k! · a_k`.

  ## What this file ships

  | Property                                          | Theorem                                   |
  |---------------------------------------------------|-------------------------------------------|
  | Matrix trace as continuous linear map             | `Matrix.traceCLM` (definition)            |
  | `Tr(e^{-t·D²}) = Σ' k, (-t)^k/k! · a_k(T)`        | `tr_heatKernel_eq_tsum_heatKernelCoef`    |
  | Headline 2-conjunct                                | `heat_kernel_taylor_convergence_report`    |

  ## Honest scope

  This file ships the rigorous convergent-Taylor identity for any
  finite spectral triple.  It does NOT ship:

  * The remainder bound `|Tr(e^{-t·D²}) − truncatedHeatTrace T N t|`.
  * The CONTINUUM heat kernel for d-dim smooth manifolds (Vassilevich
    multi-month port; that needs PDE theory genuinely beyond our
    current Lean reach).

  What it DOES ship: the bridge from FORMAL truncated Taylor (Phase 6.4)
  to the analytic heat trace (Mathlib `NormedSpace.exp`) for ALL finite
  spectral triples — closing one of the three multi-month deferrals.

  ## Lion's-Pride doctrine applied (BUILD_MATHLIB_MACHINERY_T6_13)

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Mathlib lacked `Matrix.traceCLM` (continuous trace) — we BUILD IT
  HERE via `LinearMap.toContinuousLinearMap` on the finite-dim trace.
  Then `ContinuousLinearMap.map_tsum` gives the convergence theorem.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.ContinuumHeatKernelYukawa
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.Matrix.Normed
import Mathlib.Topology.Algebra.Module.FiniteDimension
import Mathlib.Topology.Algebra.InfiniteSum.Module
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

-- Activate L^∞ matrix norm + algebra in this file (Mathlib doesn't pick a canonical
-- matrix norm globally; we choose the L^∞ operator norm — Mathlib's recommended
-- pattern for `NormedSpace.exp` work on matrices).
attribute [local instance] Matrix.linftyOpNormedRing
attribute [local instance] Matrix.linftyOpNormedAlgebra

namespace OmegaTheory.Foundations.HeatKernelTaylorConvergence

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.YukawaDirac
open OmegaTheory.Foundations.ContinuumHeatKernelYukawa

variable {n : ℕ}

/-! ## 1. Matrix trace as a continuous linear map

    For finite-dim Matrix(Fin n)(Fin n)(ℂ), all linear maps to ℂ are
    continuous. Upgrade `Matrix.traceLinearMap ℂ ℂ` via Mathlib's
    `LinearMap.toContinuousLinearMap`. -/

/-- **Matrix trace as a continuous linear map** on `Matrix (Fin n) (Fin n) ℂ`.
    Uses finite-dim auto-continuity of all linear maps. -/
noncomputable def Matrix.traceCLM (n : ℕ) :
    Matrix (Fin n) (Fin n) ℂ →L[ℂ] ℂ :=
  LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) ℂ ℂ)

/-- **Application of `Matrix.traceCLM` agrees with `Matrix.trace`**. -/
theorem Matrix.traceCLM_apply (M : Matrix (Fin n) (Fin n) ℂ) :
    Matrix.traceCLM n M = M.trace := by
  rfl

/-! ## 2. Heat trace as a convergent tsum -/

/-- **`Tr(e^{-t·D²}) = Σ' k, (k!⁻¹ : ℂ) · (-t)^k · a_k(T)`** (convergent tsum).

    For any finite spectral triple T and parameter t : ℂ, the trace of
    the analytic heat kernel admits the convergent Taylor series in
    powers of (-t). -/
theorem tr_heatKernel_eq_tsum_heatKernelCoef
    (T : FiniteSpectralTriple n) (t : ℂ) :
    (NormedSpace.exp (-(t • T.D ^ 2))).trace
      = ∑' k : ℕ, ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k := by
  -- Mathlib: exp(X) = Σ' n, (n!⁻¹ : 𝕂) • X^n
  -- After substitution, beta-reduce the lambda
  have h_exp : NormedSpace.exp (-(t • T.D ^ 2))
      = ∑' k : ℕ, ((Nat.factorial k : ℂ)⁻¹) • (-(t • T.D ^ 2)) ^ k := by
    rw [NormedSpace.exp_eq_tsum (𝕂 := ℂ)]
  rw [h_exp]
  -- Pass trace through tsum via ContinuousLinearMap.map_tsum
  have h_summable : Summable (fun k : ℕ =>
      ((Nat.factorial k : ℂ)⁻¹) • (-(t • T.D ^ 2)) ^ k) := by
    have := NormedSpace.expSeries_summable' (𝕂 := ℂ) (-(t • T.D ^ 2))
    simpa using this
  have h_map_tsum := (Matrix.traceCLM n).map_tsum h_summable
  rw [show (∑' k : ℕ, ((Nat.factorial k : ℂ)⁻¹) • (-(t • T.D ^ 2)) ^ k).trace
        = (Matrix.traceCLM n) (∑' k : ℕ,
              ((Nat.factorial k : ℂ)⁻¹) • (-(t • T.D ^ 2)) ^ k)
       from by rw [Matrix.traceCLM_apply]]
  rw [h_map_tsum]
  congr 1
  ext k
  -- Goal: traceCLM ((k!⁻¹) • (-(t • D²))^k) = (k!⁻¹) * (-t)^k * a_k(T)
  rw [Matrix.traceCLM_apply]  -- traceCLM = trace
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

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.5k headline — heat-kernel Taylor convergence.**

    For any finite spectral triple `T : FiniteSpectralTriple n` and
    parameter `t : ℂ`:

    1. **`Matrix.traceCLM` agrees with trace**: pure α-equivalence.

    2. **Convergent Taylor series identity**:
       `Tr(e^{-t·D²}) = Σ' k, (k!⁻¹) · (-t)^k · a_k(T)`
       — an actual `tsum`, not a truncated partial sum.  Each
       `truncatedHeatTrace T N t` is the N-th partial sum of this
       genuinely convergent infinite series. -/
theorem heat_kernel_taylor_convergence_report
    (T : FiniteSpectralTriple n) (t : ℂ) :
    (∀ M : Matrix (Fin n) (Fin n) ℂ, Matrix.traceCLM n M = M.trace) ∧
    (NormedSpace.exp (-(t • T.D ^ 2))).trace
      = ∑' k : ℕ, ((Nat.factorial k : ℂ)⁻¹) * (-t) ^ k * heatKernelCoef T k := by
  refine ⟨?_, ?_⟩
  · intro M; exact Matrix.traceCLM_apply M
  · exact tr_heatKernel_eq_tsum_heatKernelCoef T t

end OmegaTheory.Foundations.HeatKernelTaylorConvergence
