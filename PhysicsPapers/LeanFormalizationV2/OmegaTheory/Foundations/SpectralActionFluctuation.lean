/-
  OmegaTheory.Foundations.SpectralActionFluctuation

  **Lion's-Pride Phase 6.5b (2026-05-06)**:
  *Trace expansion of the fluctuated Dirac
        D ↦ D + t·H
  to second order — the algebraic backbone of the
  Chamseddine-Connes Higgs mass term from the spectral action.*

  ## Why this file

  In Chamseddine-Connes 1996+, the Higgs scalar field arises by
  fluctuating the finite Dirac operator:

      D_F  ↦  D_F + π(A) + ε J A J⁻¹

  where `A = Σ aᵢ [D_F, bᵢ]` is a Hermitian "1-form" in the algebra.
  The spectral-action expansion in `Λ` and the FLUCTUATION parameter
  `t` produces the Higgs mass term `μ²|H|²` from the `t²`-coefficient
  of `Tr((D_F + tH)²)`.

  This file ships the EXACT FINITE-DIM ALGEBRA of the trace expansion
  to second order:

      (D + tH)² = D² + t·(DH + HD) + t²·H²

      Tr((D + tH)²)  =  Tr(D²) + 2t·Tr(D·H) + t²·Tr(H²)

  These are PURELY ALGEBRAIC identities for any two square matrices
  `D, H` (using cyclicity of trace `Tr(DH) = Tr(HD)`), and are exactly
  what physics needs:

  * The `t²`-coefficient of `Tr((D + tH)²)` is `Tr(H²)`, the kinetic
    Higgs mass-squared at zeroth order in D.
  * The `2t`-coefficient is `Tr(D·H)`, the cross-term that vanishes
    when `H` is anti-correlated with `D` (anti-commuting Higgs/Dirac
    structure).

  Phase 6.5c will ship the QUARTIC trace expansion for the Higgs
  self-coupling λ; that requires further cyclicity bookkeeping.

  ## What this file ships

  | Property                                       | Theorem                                   |
  |------------------------------------------------|-------------------------------------------|
  | `(D + tH)² = D² + t·(DH + HD) + t²H²`           | `fluctuated_sq_expand`                    |
  | `Tr((D + tH)²) = Tr(D²) + 2t·Tr(DH) + t²·Tr(H²)` | `tr_fluctuated_sq`                        |
  | Specialisation: H = 0 collapse                 | `tr_fluctuated_sq_at_zero`                |
  | Specialisation: D = 0 collapse                 | `tr_fluctuated_sq_at_zero_D`              |
  | Headline 2-conjunct                            | `spectral_fluctuation_quadratic_report`   |

  ## Honest scope

  This file ships ONLY the algebraic trace expansion to SECOND ORDER.
  It does NOT ship:

  * The CUBIC or QUARTIC trace expansion (`Phase 6.5c`).
  * The PHYSICAL identification of `H` as the Higgs scalar (that
    requires the `[D, π(a)]` fluctuation construction in Phase 6.5d).
  * The CONTINUUM Higgs mass formula `μ² = c·Tr(D_F²)·Λ²`
    (Phase 6.5e, requires the heat-kernel asymptotic expansion at
    large Λ which is multi-month work).

  What it DOES ship: the GENUINE algebraic backbone of the Higgs
  mass computation in Chamseddine-Connes, written as rigorous Lean
  theorems with concrete matrix-algebra proofs.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Every theorem proved with concrete matrix algebra (Mathlib
  `Matrix.trace_mul_comm` for cyclicity + `Matrix.smul_mul` /
  `Matrix.mul_smul` + `module` for additive linear algebra).
  No abstraction towers — direct matrix manipulation.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.FiniteSpectralTriple
import OmegaTheory.Foundations.HeatKernelCoefficients
import OmegaTheory.Foundations.HeatKernelBochnerForm
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.SpectralActionFluctuation

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.HeatKernelBochnerForm

variable {n : ℕ}

/-! ## 1. Second-order fluctuation: (D + tH)²

    Pure non-commutative algebraic expansion. -/

/-- **(D + tH)² = D² + t·(DH + HD) + t²H²**.

    Algebraic expansion in any (non-commutative) ring; uses
    `(a + b)² = a² + a·b + b·a + b²` and distributing `t`. -/
theorem fluctuated_sq_expand
    (D H : Matrix (Fin n) (Fin n) ℂ) (t : ℂ) :
    (D + t • H) ^ 2
      = D ^ 2 + t • (D * H + H * D) + (t * t) • (H * H) := by
  rw [sq]
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul]
  rw [show D * D = D ^ 2 from (sq D).symm]
  module

/-- **Trace expansion: Tr((D + tH)²) = Tr(D²) + 2t·Tr(D·H) + t²·Tr(H²)**.

    Uses `Tr(DH) = Tr(HD)` (cyclicity) to combine the cross-terms. -/
theorem tr_fluctuated_sq
    (D H : Matrix (Fin n) (Fin n) ℂ) (t : ℂ) :
    ((D + t • H) ^ 2).trace
      = (D ^ 2).trace + 2 * t * (D * H).trace + t ^ 2 * (H * H).trace := by
  rw [fluctuated_sq_expand]
  rw [Matrix.trace_add, Matrix.trace_add]
  rw [Matrix.trace_smul, Matrix.trace_smul]
  rw [Matrix.trace_add]
  rw [Matrix.trace_mul_comm H D]
  simp [smul_eq_mul]
  ring

/-! ## 2. Specialisations -/

/-- **H = 0 collapse**: when there is no Higgs fluctuation,
    `Tr((D + 0)²) = Tr(D²)`. -/
theorem tr_fluctuated_sq_at_zero
    (D : Matrix (Fin n) (Fin n) ℂ) (t : ℂ) :
    ((D + t • (0 : Matrix (Fin n) (Fin n) ℂ)) ^ 2).trace = (D ^ 2).trace := by
  rw [tr_fluctuated_sq]
  simp

/-- **D = 0 collapse**: when there is no background Dirac, the trace is
    pure quadratic in t: `Tr((tH)²) = t²·Tr(H²)`. -/
theorem tr_fluctuated_sq_at_zero_D
    (H : Matrix (Fin n) (Fin n) ℂ) (t : ℂ) :
    (((0 : Matrix (Fin n) (Fin n) ℂ) + t • H) ^ 2).trace
      = t ^ 2 * (H * H).trace := by
  rw [tr_fluctuated_sq]
  simp

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.5b headline — finite-dim spectral fluctuation
    quadratic trace expansion.**

    For matrices D, H ∈ Matrix (Fin n) (Fin n) ℂ and t ∈ ℂ:

    1. **Quadratic algebraic expansion**:
       `(D + tH)² = D² + t·(DH + HD) + t²H²`.

    2. **Quadratic trace expansion** (Higgs mass seed):
       `Tr((D + tH)²) = Tr(D²) + 2t·Tr(D·H) + t²·Tr(H²)`. -/
theorem spectral_fluctuation_quadratic_report
    (D H : Matrix (Fin n) (Fin n) ℂ) (t : ℂ) :
    ((D + t • H) ^ 2 = D ^ 2 + t • (D * H + H * D) + (t * t) • (H * H)) ∧
    (((D + t • H) ^ 2).trace
      = (D ^ 2).trace + 2 * t * (D * H).trace + t ^ 2 * (H * H).trace) :=
  ⟨fluctuated_sq_expand D H t, tr_fluctuated_sq D H t⟩

end OmegaTheory.Foundations.SpectralActionFluctuation
