/-
  OmegaTheory.Foundations.HeatKernelBochnerForm

  **Lion's-Pride Phase 6.3 (2026-05-06)**:
  *Bochner-style algebraic identity for finite-dim heat-kernel coefficients:
  `a_k(T) = Tr(D^(2k)) = Tr((D²)^k)`.*

  ## Why this file

  In continuum NCG, the Bochner-Weitzenböck identity reads
      D² = Δ + R/4
  on a Riemannian spin manifold, where `Δ` is the Bochner Laplacian
  and `R/4` is the curvature correction.  This identity is the bridge
  from `D²` (squared finite Dirac) to the heat-kernel asymptotics:

      Tr(e^{-tD²}) = Tr(e^{-t(Δ + R/4)})

  In FINITE DIMENSIONS the analogue is the algebraic identity:
      `D^(2k) = (D²)^k`
  which lets us re-express the heat coefficients

      a_k(T) := Tr(D^(2k)) = Tr((D²)^k)

  In our Lion's-Pride scaffold this is the key reduction:  we never
  need to compute `D^(2k)` directly when we can compute `(D²)^k`
  iteratively.  Every heat coefficient becomes a power of `D²` traced.

  ## What this file ships

  | Property                                          | Theorem                                 |
  |--------------------------------------------------|-----------------------------------------|
  | `D^(2k) = (D²)^k`                                | `D_pow_two_k_eq_D_sq_pow_k`             |
  | `a_k = Tr((D²)^k)`                               | `heatKernelCoef_eq_D_sq_pow_trace`      |
  | `a_1 = Tr(D²)`                                   | `heatKernelCoef_one_eq`                 |
  | `a_2 = Tr((D²)²) = Tr(D⁴)`                       | `heatKernelCoef_two_eq`                 |
  | `D² is Hermitian`                                | `D_sq_isHermitian` (re-exported)         |
  | `(D²)^k is Hermitian for all k`                  | `D_sq_pow_isHermitian`                  |
  | Headline: 5-conjunct Bochner-form report         | `heat_kernel_bochner_form_report`       |

  ## Honest scope

  This file does NOT derive the continuum Bochner formula `D² = Δ + R/4`
  on a Riemannian manifold (that's Phase 6.3-cont in Foundations/
  ContinuumBochnerFormula.lean, multi-month work requiring Riemann
  curvature + spin connection on a smooth manifold).

  What it DOES ship: the FINITE-DIM Bochner-shape `D^(2k) = (D²)^k`
  algebraic identity and its consequences for heat-kernel coefficients.
  This is the algebraic backbone the continuum theorem will compose with.

  ## Author

  Lion's-Pride dynamic /loop iteration 22 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.HeatKernelCoefficients
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.HeatKernelBochnerForm

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients

variable {n : ℕ}

/-! ## 1. The fundamental identity: `D^(2k) = (D²)^k`

    Pure algebraic identity in any monoid: `x^(2k) = (x²)^k`.
    Proven via `pow_mul`. -/

/-- **`D^(2k) = (D²)^k`**.

    For any finite spectral triple `T : FiniteSpectralTriple n` and
    `k : ℕ`, the `2k`-th power of `T.D` equals the `k`-th power of
    `T.D²`. -/
theorem D_pow_two_k_eq_D_sq_pow_k
    (T : FiniteSpectralTriple n) (k : ℕ) :
    T.D ^ (2 * k) = (T.D ^ 2) ^ k := by
  rw [pow_mul]

/-! ## 2. Heat-kernel coefficients in Bochner form

    `a_k(T) := Tr(D^(2k)) = Tr((D²)^k)`. -/

/-- **Heat-kernel coefficient via D²**:
    `heatKernelCoef T k = ((T.D²)^k).trace`. -/
theorem heatKernelCoef_eq_D_sq_pow_trace
    (T : FiniteSpectralTriple n) (k : ℕ) :
    heatKernelCoef T k = ((T.D ^ 2) ^ k).trace := by
  unfold heatKernelCoef
  rw [D_pow_two_k_eq_D_sq_pow_k T k]

/-- **First heat coefficient**:
    `a_1(T) = Tr(D²)`. -/
theorem heatKernelCoef_one_eq
    (T : FiniteSpectralTriple n) :
    heatKernelCoef T 1 = (T.D ^ 2).trace := by
  rw [heatKernelCoef_eq_D_sq_pow_trace T 1, pow_one]

/-- **Second heat coefficient**:
    `a_2(T) = Tr((D²)²) = Tr(D⁴)`. -/
theorem heatKernelCoef_two_eq
    (T : FiniteSpectralTriple n) :
    heatKernelCoef T 2 = ((T.D ^ 2) ^ 2).trace :=
  heatKernelCoef_eq_D_sq_pow_trace T 2

/-! ## 3. Hermiticity of (D²)^k

    Powers of D² are Hermitian (since D² is Hermitian and Hermiticity
    is preserved under powers via `Matrix.conjTranspose_pow`). -/

/-- **`(D²)^k` is Hermitian for any k**, derived from `D_pow_isHermitian`. -/
theorem D_sq_pow_isHermitian
    (T : FiniteSpectralTriple n) (k : ℕ) :
    ((T.D ^ 2) ^ k).IsHermitian := by
  -- (D²)^k = D^(2k) by pow_mul, and D^(2k) is Hermitian by D_pow_isHermitian
  rw [← pow_mul]
  exact D_pow_isHermitian T (2 * k)

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6.3 headline — finite-dim Bochner-form
    heat-kernel coefficients structural report.**

    For any finite spectral triple `T : FiniteSpectralTriple n`:

    1. **Algebraic identity**: `D^(2k) = (D²)^k`.

    2. **Heat coefficient via D²**: `a_k(T) = Tr((D²)^k)`.

    3. **First coefficient**: `a_1(T) = Tr(D²)`.

    4. **Second coefficient**: `a_2(T) = Tr((D²)²)`.

    5. **`(D²)^k` is Hermitian** for all k. -/
theorem heat_kernel_bochner_form_report
    (T : FiniteSpectralTriple n) (k : ℕ) :
    T.D ^ (2 * k) = (T.D ^ 2) ^ k ∧
    heatKernelCoef T k = ((T.D ^ 2) ^ k).trace ∧
    heatKernelCoef T 1 = (T.D ^ 2).trace ∧
    heatKernelCoef T 2 = ((T.D ^ 2) ^ 2).trace ∧
    ((T.D ^ 2) ^ k).IsHermitian := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact D_pow_two_k_eq_D_sq_pow_k T k
  · exact heatKernelCoef_eq_D_sq_pow_trace T k
  · exact heatKernelCoef_one_eq T
  · exact heatKernelCoef_two_eq T
  · exact D_sq_pow_isHermitian T k

end OmegaTheory.Foundations.HeatKernelBochnerForm
