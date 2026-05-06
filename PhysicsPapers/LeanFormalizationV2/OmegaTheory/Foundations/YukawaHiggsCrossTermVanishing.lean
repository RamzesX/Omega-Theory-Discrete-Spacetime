/-
  OmegaTheory.Foundations.YukawaHiggsCrossTermVanishing

  **Lion's-Pride Phase 6.5c (2026-05-06)**:
  *The cross-term `Tr(D·H)` in the spectral action expansion VANISHES
  when D is diagonal (Yukawa) and H is strictly off-diagonal (Higgs)
  — the orthogonal-decomposition theorem that explains why Higgs and
  Yukawa eigenvalues live in commuting subspaces of the finite
  spectral triple.*

  ## Why this file

  In Chamseddine-Connes, the finite spectral triple has Dirac operator
  decomposed as

      D_F  =  diag(Yukawa eigenvalues)  ⊕  off-diagonal-Higgs-block

  The spectral-action expansion `Tr((D + tH)²)`:

      Tr((D + tH)²)  =  Tr(D²) + 2t·Tr(D·H) + t²·Tr(H²)

  has cross-term `2t·Tr(D·H)`.  When `H` is the Higgs fluctuation
  (strictly off-diagonal in the basis where `D` is diagonal), the
  cross-term VANISHES:

      Tr(D · H)  =  Σᵢⱼ Dᵢⱼ · Hⱼᵢ
                =  Σᵢ Dᵢᵢ · Hᵢᵢ      (only diagonal contributes)
                =  Σᵢ Dᵢᵢ · 0       (Hᵢᵢ = 0 by off-diag hypothesis)
                =  0

  Hence the spectral action SIMPLIFIES to:

      Tr((D + tH)²)  =  Tr(D²) + t²·Tr(H²)         (NO cross-term)

  This is the EXACT REASON why in Chamseddine-Connes, the Higgs mass
  comes from `Tr(H²)` alone (with `Tr(D²)` providing only an additive
  constant), and the Yukawa eigenvalues set the COEFFICIENT via the
  finite-dim heat-kernel expansion.

  ## What this file ships

  | Property                                          | Theorem                                |
  |---------------------------------------------------|----------------------------------------|
  | `Tr(D · H) = 0` for diagonal D, off-diag H        | `tr_diag_offDiag_eq_zero`               |
  | Cross-term-free fluctuation: `Tr((D+tH)²) = ...`  | `tr_fluctuated_sq_orthogonal`           |
  | Yukawa-specialised: D = diag(y), H off-diagonal   | `tr_yukawa_offDiag_fluctuation`         |
  | Headline 3-conjunct                               | `yukawa_higgs_orthogonal_report`         |

  ## Honest scope

  This file ships ONLY the orthogonality theorem and its specialisation
  to Yukawa-diagonal `D`.  It does NOT ship:

  * The PHYSICAL identification of `H` as the SU(2)-doublet Higgs field
    (that requires the gauge-field ω in Phase 6.5d).
  * The connection of `Tr(H²)` to `μ²·H†H` continuum form
    (Phase 6.5e, large-Λ heat-kernel asymptotic).

  What it DOES ship: the rigorous algebraic theorem that, given a
  diagonal Dirac and a strictly-off-diagonal Higgs perturbation, the
  cross-term in the spectral action expansion is exactly zero.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Concrete proof via `Matrix.trace_diagonal_mul_offDiagonal` style
  reasoning — diagonal × off-diagonal traces to zero by the diagonal
  being supported only on `i = j` while the off-diagonal vanishes there.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.YukawaDirac
import OmegaTheory.Foundations.SpectralActionFluctuation
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.YukawaHiggsCrossTermVanishing

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.HeatKernelBochnerForm
open OmegaTheory.Foundations.SpectralActionFluctuation
open OmegaTheory.Foundations.YukawaDirac

/-! ## 1. Definition: off-diagonal predicate

    A matrix `H` is "off-diagonal" if its diagonal entries vanish:
    `Hᵢᵢ = 0` for all `i`. -/

/-- **Off-diagonal predicate**: `H` has zero diagonal entries. -/
def IsOffDiagonal {n : ℕ} (H : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  ∀ i : Fin n, H i i = 0

/-! ## 2. Trace of `D · H` for D diagonal, H off-diagonal -/

/-- **Diagonal × off-diagonal trace vanishes**.

    For `D = diag(d)` and `H` off-diagonal, the trace
    `Tr(D · H) = Σᵢ (D·H)ᵢᵢ = Σᵢ dᵢ · Hᵢᵢ = Σᵢ dᵢ · 0 = 0`. -/
theorem tr_diag_offDiag_eq_zero {n : ℕ}
    (d : Fin n → ℂ) (H : Matrix (Fin n) (Fin n) ℂ)
    (hH : IsOffDiagonal H) :
    (Matrix.diagonal d * H).trace = 0 := by
  rw [Matrix.trace]
  apply Finset.sum_eq_zero
  intros i _
  -- (diag d * H) i i = Σⱼ (diag d) i j · H j i
  --                 = (diag d) i i · H i i (only j = i contributes)
  --                 = d i · H i i
  --                 = d i · 0 (off-diag)
  --                 = 0
  simp [Matrix.mul_apply, Matrix.diagonal_apply,
        Finset.sum_ite_eq', hH i]

/-! ## 3. Cross-term-free spectral fluctuation -/

/-- **Spectral fluctuation without cross-term**.

    When `D = diag(d)` and `H` is off-diagonal, the Higgs cross-term
    in `Tr((D + tH)²)` vanishes:

      `Tr((D + tH)²)  =  Tr(D²) + t²·Tr(H²)`. -/
theorem tr_fluctuated_sq_orthogonal {n : ℕ}
    (d : Fin n → ℂ) (H : Matrix (Fin n) (Fin n) ℂ)
    (hH : IsOffDiagonal H) (t : ℂ) :
    ((Matrix.diagonal d + t • H) ^ 2).trace
      = ((Matrix.diagonal d) ^ 2).trace + t ^ 2 * (H * H).trace := by
  rw [tr_fluctuated_sq]
  rw [tr_diag_offDiag_eq_zero d H hH]
  ring

/-! ## 4. Specialisation to Yukawa-diagonal Dirac -/

/-- **Yukawa-specialised fluctuation**: when D is the Yukawa-diagonal
    Dirac and H is off-diagonal (Higgs), the trace simplifies. -/
theorem tr_yukawa_offDiag_fluctuation {n : ℕ}
    (y : Fin n → ℝ) (H : Matrix (Fin n) (Fin n) ℂ)
    (hH : IsOffDiagonal H) (t : ℂ) :
    ((yukawaDirac y + t • H) ^ 2).trace
      = ((yukawaDirac y) ^ 2).trace + t ^ 2 * (H * H).trace := by
  unfold yukawaDirac
  exact tr_fluctuated_sq_orthogonal (fun i => (y i : ℂ)) H hH t

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5c headline — Yukawa/Higgs orthogonal
    decomposition theorem.**

    For Yukawa eigenvalues `y : Fin n → ℝ`, an off-diagonal Higgs
    perturbation `H : Matrix (Fin n) (Fin n) ℂ`, and `t : ℂ`:

    1. **Cross-term vanishing**: `Tr(yukawaDirac y · H) = 0`.

    2. **Cross-term-free expansion**:
       `Tr((yukawaDirac y + tH)²)  =  Tr((yukawaDirac y)²) + t²·Tr(H²)`.

    3. **Yukawa power-sum form**: combining with Phase 6.5a,
       `Tr((yukawaDirac y + tH)²) = Σᵢ (y i)² + t² · Tr(H²)` (via
       `yukawaDirac_ak_eq_sum_pow` for `k = 1`). -/
theorem yukawa_higgs_orthogonal_report {n : ℕ} (h : 0 < n)
    (y : Fin n → ℝ) (H : Matrix (Fin n) (Fin n) ℂ)
    (hH : IsOffDiagonal H) (t : ℂ) :
    ((yukawaDirac y) * H).trace = 0 ∧
    ((yukawaDirac y + t • H) ^ 2).trace
      = ((yukawaDirac y) ^ 2).trace + t ^ 2 * (H * H).trace ∧
    ((yukawaDirac y + t • H) ^ 2).trace
      = (∑ i : Fin n, ((y i : ℂ)) ^ 2) + t ^ 2 * (H * H).trace := by
  refine ⟨?_, ?_, ?_⟩
  · unfold yukawaDirac
    exact tr_diag_offDiag_eq_zero (fun i => (y i : ℂ)) H hH
  · exact tr_yukawa_offDiag_fluctuation y H hH t
  · rw [tr_yukawa_offDiag_fluctuation y H hH t]
    have h_sq : ((yukawaDirac y) ^ 2).trace = ∑ i : Fin n, ((y i : ℂ)) ^ 2 := by
      have h_a1 := yukawaSpectralTriple_a1 h y
      unfold heatKernelCoef at h_a1
      rw [yukawaSpectralTriple_D_eq] at h_a1
      simpa [show 2 * 1 = 2 from rfl] using h_a1
    rw [h_sq]

end OmegaTheory.Foundations.YukawaHiggsCrossTermVanishing
