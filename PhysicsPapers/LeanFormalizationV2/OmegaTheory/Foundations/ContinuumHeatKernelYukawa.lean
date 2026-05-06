/-
  OmegaTheory.Foundations.ContinuumHeatKernelYukawa

  **Lion's-Pride Phase 6.5j (2026-05-06)**:
  *Genuine analytic heat kernel `e^{-t·D²}` for the Yukawa-diagonal
  Dirac, computed via Mathlib's matrix exponential.  Trace closed-form
  `Tr(e^{-t·D²}) = Σᵢ e^{-t·y_i²}` — this IS the continuum heat trace
  (not a truncated Taylor approximation), the spectral function of
  the substrate finite spectral triple.*

  ## Why this file

  Phases 6b, 6d, 6.5h shipped the FORMAL Taylor expansion

      truncatedHeatTrace T N t  =  Σ_{k=0..N} (-t)^k / k! · a_k(T)

  This file shows that for the Yukawa-diagonal Dirac, the FULL
  analytic heat kernel `e^{-t·D²}` (Mathlib's `NormedSpace.exp` on
  matrices) admits a clean closed-form via `Matrix.exp_diagonal`:

      e^{-t·D²}  =  diag(e^{-t·y_1²}, ..., e^{-t·y_n²})

  Hence the full continuum heat trace is

      Tr(e^{-t·D²})  =  Σᵢ e^{-t·y_i²}

  This is the GENUINE spectral function of the Yukawa spectral triple.
  As `t → 0⁺`, Taylor expansion of `e^{-t·y²}` recovers our truncated
  heat trace.  As `t → ∞`, the lowest Yukawa eigenvalue dominates
  (heat kernel concentrates on ground state).

  ## What this file ships

  | Property                                          | Theorem                                       |
  |---------------------------------------------------|-----------------------------------------------|
  | `(yukawaDirac y)² = diagonal(y_i²)`                | `yukawaDirac_sq_eq_diagonal_sq`                |
  | `e^{-t·D²}` for D Yukawa-diag is diagonal          | `exp_neg_t_yukawaDirac_sq`                     |
  | `Tr(e^{-t·D²}) = Σᵢ e^{-t·y_i²}` (continuum)      | `tr_exp_neg_t_yukawaDirac_sq`                  |
  | Heat trace at t = 0 = n                           | `tr_exp_zero_yukawaDirac_sq`                   |
  | Headline 4-conjunct                                | `continuum_heat_kernel_yukawa_report`           |

  ## Honest scope

  This file ships the ANALYTIC (not just formal-Taylor) continuum
  heat kernel for the Yukawa-diagonal Dirac in finite dim.  It does
  NOT ship:

  * The continuum heat kernel for a smooth manifold + Riemannian
    metric (multi-month Vassilevich port; needs PDE theory not in
    Mathlib).
  * The connection to Seeley-DeWitt coefficients in dimension d > 0
    (asymptotic at coincident points x → y).

  What it DOES ship: the rigorous closed-form formula for the
  spectral function of the Yukawa spectral triple, using
  Mathlib's matrix exponential on a diagonal matrix.

  This is genuinely the CONTINUUM heat kernel for a finite-dim
  spectral triple — no asymptotic, no truncation, no approximation.
  The diagonal-matrix structure makes everything explicit.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure composition: `Matrix.diagonal_pow` + `Matrix.diagonal_smul` +
  `Matrix.exp_diagonal` + `Matrix.trace_diagonal`. No abstraction
  towers.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.YukawaDirac
import OmegaTheory.Foundations.YukawaHeatKernelExpansion
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.ContinuumHeatKernelYukawa

open OmegaTheory.Foundations.YukawaDirac
open OmegaTheory.Foundations.YukawaHeatKernelExpansion
open NormedSpace

variable {n : ℕ}

/-! ## 1. yukawaDirac² is diagonal: (D²)ᵢᵢ = y_i² -/

/-- **`(yukawaDirac y)² = diagonal(y_i²)`** as a complex matrix. -/
theorem yukawaDirac_sq_eq_diagonal_sq (y : Fin n → ℝ) :
    (yukawaDirac y) ^ 2 = Matrix.diagonal (fun i => ((y i : ℂ)) ^ 2) := by
  unfold yukawaDirac
  rw [Matrix.diagonal_pow]
  congr 1

/-! ## 2. The matrix exponential of `-t·yukawaDirac²` is diagonal -/

/-- **Continuum heat kernel = diagonal of exp(-t·y_i²)**.

    For Yukawa-diagonal Dirac and parameter `t : ℂ`,
        `e^{-t·D²} = diag(e^{-t·y_1²}, ..., e^{-t·y_n²})`.

    Mathlib's `Matrix.exp_diagonal` directly gives this formula since
    the input is diagonal. -/
theorem exp_neg_t_yukawaDirac_sq (y : Fin n → ℝ) (t : ℂ) :
    NormedSpace.exp (-(t • (yukawaDirac y) ^ 2))
      = Matrix.diagonal (fun i => NormedSpace.exp (-(t * ((y i : ℂ)) ^ 2))) := by
  rw [yukawaDirac_sq_eq_diagonal_sq]
  -- -(t • diagonal v) = diagonal (-(t • v)) = diagonal (fun i => -(t * v i))
  rw [show -(t • Matrix.diagonal (fun i : Fin n => ((y i : ℂ)) ^ 2))
         = Matrix.diagonal (fun i : Fin n => -(t * ((y i : ℂ)) ^ 2)) from by
       rw [← Matrix.diagonal_smul, ← Matrix.diagonal_neg]
       ext i j
       simp [Matrix.diagonal, smul_eq_mul]]
  rw [Matrix.exp_diagonal]
  congr 1
  rw [Pi.exp_def]

/-! ## 3. The trace of the continuum heat kernel -/

/-- **`Tr(e^{-t·D²}) = Σᵢ e^{-t·y_i²}`** — continuum heat-trace
    closed form for the Yukawa-diagonal Dirac.

    This is the analytic spectral function: each Yukawa eigenvalue
    `y_i` contributes a factor `e^{-t·y_i²}` to the heat trace.  At
    `t → 0⁺` it Taylor-expands to our truncated heat trace; at
    `t → ∞` the lowest Yukawa eigenvalue dominates. -/
theorem tr_exp_neg_t_yukawaDirac_sq (y : Fin n → ℝ) (t : ℂ) :
    (NormedSpace.exp (-(t • (yukawaDirac y) ^ 2))).trace
      = ∑ i : Fin n, NormedSpace.exp (-(t * ((y i : ℂ)) ^ 2)) := by
  rw [exp_neg_t_yukawaDirac_sq]
  rw [Matrix.trace_diagonal]

/-! ## 4. Heat trace at t = 0 -/

/-- **At t = 0, the heat trace is `n`** (number of fermion d.o.f.).

    `Tr(e^0) = Tr(I) = n` since `exp(0) = 1`. -/
theorem tr_exp_zero_yukawaDirac_sq (y : Fin n → ℝ) :
    (NormedSpace.exp (-((0 : ℂ) • (yukawaDirac y) ^ 2))).trace = (n : ℂ) := by
  rw [tr_exp_neg_t_yukawaDirac_sq]
  simp [NormedSpace.exp_zero]

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5j headline — continuum heat kernel of
    Yukawa-diagonal Dirac.**

    For Yukawa eigenvalues `y : Fin n → ℝ` and parameter `t : ℂ`:

    1. **Squared Dirac is diagonal**:
       `(yukawaDirac y)² = diagonal(y_i²)` (cast to ℂ).

    2. **Heat kernel is diagonal of exp**:
       `e^{-t·D²} = diag(e^{-t·y_1²}, ..., e^{-t·y_n²})`.

    3. **Spectral heat trace closed-form** (CONTINUUM, not truncated):
       `Tr(e^{-t·D²}) = Σᵢ e^{-t·y_i²}`.

    4. **At t = 0**: heat trace equals `n` (fermion d.o.f. count).

    This is the rigorous analytic spectral function of the Yukawa
    spectral triple — the genuine continuum heat kernel, not a
    truncated Taylor approximation. -/
theorem continuum_heat_kernel_yukawa_report (y : Fin n → ℝ) (t : ℂ) :
    (yukawaDirac y) ^ 2 = Matrix.diagonal (fun i => ((y i : ℂ)) ^ 2) ∧
    NormedSpace.exp (-(t • (yukawaDirac y) ^ 2))
      = Matrix.diagonal (fun i => NormedSpace.exp (-(t * ((y i : ℂ)) ^ 2))) ∧
    (NormedSpace.exp (-(t • (yukawaDirac y) ^ 2))).trace
      = ∑ i : Fin n, NormedSpace.exp (-(t * ((y i : ℂ)) ^ 2)) ∧
    (NormedSpace.exp (-((0 : ℂ) • (yukawaDirac y) ^ 2))).trace = (n : ℂ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact yukawaDirac_sq_eq_diagonal_sq y
  · exact exp_neg_t_yukawaDirac_sq y t
  · exact tr_exp_neg_t_yukawaDirac_sq y t
  · exact tr_exp_zero_yukawaDirac_sq y

end OmegaTheory.Foundations.ContinuumHeatKernelYukawa
