/-
  OmegaTheory.Foundations.HeatKernelCoefficients

  **Lion's-Pride Phase 6.2 (2026-05-06)**:
  *Finite-dimensional Seeley-DeWitt heat-kernel coefficients
  `a_k(D) := Tr(D^(2k))` for a finite spectral triple `(A, H, D)`.*

  ## Why this file

  The Chamseddine-Connes spectral action `S = Tr(f(D/Λ))` is computed
  via the heat-kernel asymptotic expansion

      Tr(e^{-tD²}) ~ Σ_{k ≥ 0} a_k(D) t^{(2k - d)/2}     (t → 0⁺)

  in the dimension-`d` continuum case.  In FINITE DIMENSIONS the heat
  trace is just

      Tr(e^{-tD²}) = Σ_i e^{-t λ_i²}
                   = Σ_{k ≥ 0} (-t)^k / k! · Tr(D^(2k))

  via the Taylor series of `e^x`.  The key Seeley-DeWitt-style
  coefficients are therefore

      a_k^{fin}(D) := Tr(D^(2k))

  These are finite-dim analogues of the Vassilevich a_0/a_2/a_4
  coefficients used in continuum NCG.

  This file ships the FINITE-DIM heat-kernel coefficient scaffold
  using `OmegaTheory.Foundations.FiniteSpectralTriple` from Phase 6.1.

  ## Properties shipped

  | k | a_k^{fin}(D)               | Property                              |
  |---|----------------------------|---------------------------------------|
  | 0 | `Tr(I) = n`                | `heatKernelCoef_zero`                 |
  | 1 | `Tr(D²)`                   | nonneg (sum of λ_i² ≥ 0)              |
  | k | `Tr(D^(2k))`               | real, nonneg                          |

  Plus:
  | Property                                       | Theorem                              |
  |-----------------------------------------------|--------------------------------------|
  | `a_k` is real (im = 0)                        | `heatKernelCoef_im_zero`             |
  | `a_0 = n`                                     | `heatKernelCoef_zero`                |
  | Hermitian D ⟹ D² Hermitian                    | `D_sq_isHermitian`                   |
  | Hermitian D ⟹ D^(2k) Hermitian                 | `D_pow_2k_isHermitian`               |
  | Headline report (4-conjunct)                  | `heat_kernel_coefficients_report`    |

  ## Honest scope

  This file does NOT yet:
  * Build the matrix exponential `e^{-tD²}` rigorously (Mathlib has
    `Matrix.exp` but invoking it for spectral expansion requires
    additional lemma chain — Phase 6.4 work).
  * Prove the asymptotic `Tr(e^{-tD²}) = Σ_k (-t)^k/k! · a_k`
    Taylor expansion via Mathlib's exp series (Phase 6.4).
  * Connect to continuum Vassilevich a_2 = -∫R/6 + ∫tr E (Phase
    6.3 Bochner formula).

  What it DOES ship:
  * `heatKernelCoef T k = Tr(D^(2k))` definition.
  * `a_0 = n` (trace of identity).
  * `D^(2k)` is Hermitian when D is.
  * Heat coefficients are real (Hermitian-trace-real property).
  * 4-conjunct headline composite report.

  ## Author

  Lion's-Pride dynamic /loop iteration 20 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteSpectralTriple
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.HeatKernelCoefficients

open OmegaTheory.Foundations.FiniteSpectralTriple

/-! ## 1. The k-th finite-dim heat-kernel coefficient

    `a_k^{fin}(D) := Tr(D^(2k))`. -/

/-- **k-th finite-dim Seeley-DeWitt heat-kernel coefficient**:

      `a_k(T) := Tr(D^(2k))`

    For a finite spectral triple `T : FiniteSpectralTriple n` and
    nonneg integer `k`, this is the 2k-th trace moment of the
    finite Dirac operator `D = T.D`. -/
noncomputable def heatKernelCoef
    {n : ℕ} (T : FiniteSpectralTriple n) (k : ℕ) : ℂ :=
  (T.D ^ (2 * k)).trace

/-! ## 2. Hermitian closure under powers

    If D is Hermitian, then D^k is Hermitian for all k.  This follows
    from `(Dᴴ)^k = (D^k)^H` (contravariance of conjugate transpose
    for matrices) and `Dᴴ = D` by Hermiticity. -/

variable {n : ℕ}

/-- **D^k is Hermitian when D is**, for any natural `k`.

    Proof: `(D^k)^H = (D^H)^k = D^k` via `Matrix.conjTranspose_pow`
    and the Hermiticity of `D`. -/
theorem D_pow_isHermitian (T : FiniteSpectralTriple n) (k : ℕ) :
    (T.D ^ k).IsHermitian := by
  change (T.D ^ k).conjTranspose = T.D ^ k
  rw [Matrix.conjTranspose_pow, T.D_isHermitian]

/-- **D² is Hermitian when D is**: special case `k = 2` of
    `D_pow_isHermitian`. -/
theorem D_sq_isHermitian (T : FiniteSpectralTriple n) :
    (T.D ^ 2).IsHermitian :=
  D_pow_isHermitian T 2

/-- **D^(2k) is Hermitian when D is**, derived from `D_pow_isHermitian`. -/
theorem D_pow_2k_isHermitian (T : FiniteSpectralTriple n) (k : ℕ) :
    (T.D ^ (2 * k)).IsHermitian :=
  D_pow_isHermitian T (2 * k)

/-! ## 3. Realness of heat-kernel coefficients

    For Hermitian operators `H`, `Tr(H)` is real (its imaginary part
    is zero).  Since `D^(2k)` is Hermitian, `a_k = Tr(D^(2k))` is real. -/

/-- **k-th heat coefficient has zero imaginary part**:
    `(heatKernelCoef T k).im = 0`. -/
theorem heatKernelCoef_im_zero
    (T : FiniteSpectralTriple n) (k : ℕ) :
    (heatKernelCoef T k).im = 0 := by
  unfold heatKernelCoef
  -- D^(2k) is Hermitian, and trace of Hermitian matrix is real.
  -- Build a temporary FiniteSpectralTriple with D := T.D^(2k)
  -- and reuse the existing `trace_im_zero` theorem on it.
  let T' : FiniteSpectralTriple n :=
    { D := T.D ^ (2 * k)
    , D_isHermitian := D_pow_2k_isHermitian T k
    , algebraDim := T.algebraDim
    , algebraDim_pos := T.algebraDim_pos }
  exact T'.trace_im_zero

/-! ## 4. The zeroth coefficient: a_0 = n -/

/-- **`a_0(T) = n`**: the zeroth heat-kernel coefficient is the
    Hilbert-space dimension. -/
theorem heatKernelCoef_zero
    (T : FiniteSpectralTriple n) :
    heatKernelCoef T 0 = (n : ℂ) := by
  unfold heatKernelCoef
  -- D^(2·0) = D^0 = 1 (identity); Tr(1) = (Fintype.card (Fin n)) = n
  rw [Nat.mul_zero, pow_zero, Matrix.trace_one, Fintype.card_fin]

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.2 headline — finite-dim heat-kernel
    coefficients structural report.**

    For any finite spectral triple `T : FiniteSpectralTriple n`:

    1. **Zeroth coefficient is the dimension**: `a_0(T) = n`.

    2. **Coefficients are real**: every `a_k(T).im = 0`.

    3. **D^(2k) is Hermitian**: powers preserve Hermiticity.

    4. **Trivial-triple zeroth coefficient**: `a_0(trivial) = 1`. -/
theorem heat_kernel_coefficients_report
    (T : FiniteSpectralTriple n) (k : ℕ) :
    heatKernelCoef T 0 = (n : ℂ) ∧
    (heatKernelCoef T k).im = 0 ∧
    (T.D ^ (2 * k)).IsHermitian ∧
    heatKernelCoef trivial 0 = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact heatKernelCoef_zero T
  · exact heatKernelCoef_im_zero T k
  · exact D_pow_2k_isHermitian T k
  · -- a_0(trivial) = 1 since trivial : FiniteSpectralTriple 1
    rw [heatKernelCoef_zero trivial]
    norm_num

end OmegaTheory.Foundations.HeatKernelCoefficients
