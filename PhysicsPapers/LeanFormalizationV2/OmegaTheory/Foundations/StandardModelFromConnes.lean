/-
  OmegaTheory.Foundations.StandardModelFromConnes

  **Lion's-Pride Phase 6.5e (2026-05-06)** — Phase 6 CAPSTONE.

  *The full finite-dim spectral action expansion for the
  Standard-Model-flavoured Yukawa-diagonal Dirac with an off-diagonal
  Hermitian Higgs perturbation:*

      Tr((yukawaDirac y + t·H)²)  =  Σᵢ (y i)²  +  t²·‖H‖_F²

  *where `‖H‖_F² := Σᵢⱼ |Hᵢⱼ|²` is the Frobenius norm squared.*

  This is the HONEST finite-dim Standard-Model-from-Connes derivation:
  the Higgs mass-squared coefficient (the t²-piece) is EXACTLY the
  Frobenius norm of the Higgs perturbation, while the Yukawa-square
  sum (the t⁰-piece) is EXACTLY the trace of `D_F²`.

  ## Why this file

  This file ties together Phases 6.5a-6.5d into a single capstone:

  | Phase | File                                    | Result                          |
  |-------|-----------------------------------------|----------------------------------|
  | 6.5a  | YukawaDirac                             | a_k(yukawaDirac) = Σ y^(2k)      |
  | 6.5b  | SpectralActionFluctuation               | Tr((D+tH)²) = Tr D² + 2t·Tr DH + t²·Tr H² |
  | 6.5c  | YukawaHiggsCrossTermVanishing           | Tr(D·H) = 0 if D diag, H off-diag |
  | 6.5d  | HiggsMassPositivity                     | Tr(H²).re ≥ 0 if H Hermitian     |

  The capstone is the rigorous theorem closing the Higgs mass-squared
  coefficient in the spectral action expansion as the Frobenius norm
  squared of the Higgs perturbation matrix.

  ## What this file ships

  | Property                                          | Theorem                               |
  |---------------------------------------------------|---------------------------------------|
  | `‖H‖_F² := Σᵢⱼ |Hᵢⱼ|²` (Frobenius norm squared)    | `frobeniusNormSq` (definition)        |
  | `Frobenius squared = Tr(H²).re` (Hermitian H)      | `frobeniusNormSq_eq_tr_sq_re`          |
  | `Frobenius non-negativity`                        | `frobeniusNormSq_nonneg`              |
  | Yukawa square sum: `Tr(yukawaDirac²) = Σ y²`      | `tr_yukawaDirac_sq_eq_sum_sq`         |
  | Full SM capstone formula                          | `standardModel_spectralAction_formula` |
  | Headline composite report                         | `standardModel_from_connes_report`     |

  ## Honest scope

  This file ships ONLY the FINITE-DIM algebraic capstone of the
  spectral action quadratic expansion.  It does NOT ship:

  * The continuum heat-kernel asymptotic expansion at large Λ (multi-
    month — needs Vassilevich port for ad-hoc dimension d).
  * The PHYSICAL identification of `H` as the SU(2)-doublet Higgs field
    in the SM (needs the gauge-field 1-form A = Σᵢ aᵢ[D_F, bᵢ] from
    the inner-fluctuation construction; that's Phase 6.5f+).
  * The numerical Higgs mass (μ²) value (needs the cutoff function f
    and its asymptotic moments at large Λ).

  What it DOES ship: the GENUINE finite-dim algebraic backbone of the
  Chamseddine-Connes Higgs derivation.  Every theorem is concrete,
  proved, with Lean-core-only axioms.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure composition via theorems from Phases 6.5a-6.5d.  No new heavy
  algebra; the work is in showing the pieces fit together cleanly.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.YukawaDirac
import OmegaTheory.Foundations.SpectralActionFluctuation
import OmegaTheory.Foundations.YukawaHiggsCrossTermVanishing
import OmegaTheory.Foundations.HiggsMassPositivity
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.StandardModelFromConnes

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.SpectralActionFluctuation
open OmegaTheory.Foundations.YukawaHiggsCrossTermVanishing
open OmegaTheory.Foundations.YukawaDirac
open OmegaTheory.Foundations.HiggsMassPositivity
open scoped Matrix

variable {n : ℕ}

/-! ## 1. Frobenius norm squared

    The (squared) Frobenius norm of `H` is `Σᵢⱼ |Hᵢⱼ|²`.  For Hermitian
    H, this equals `(H * H).trace.re`. -/

/-- **Frobenius norm squared** of a complex matrix:
    `‖H‖_F² := Σᵢⱼ |Hᵢⱼ|²`. -/
noncomputable def frobeniusNormSq {n : ℕ} (H : Matrix (Fin n) (Fin n) ℂ) : ℝ :=
  ∑ i : Fin n, ∑ j : Fin n, ‖H i j‖ ^ 2

/-- **Frobenius norm squared is non-negative**. -/
theorem frobeniusNormSq_nonneg (H : Matrix (Fin n) (Fin n) ℂ) :
    0 ≤ frobeniusNormSq H := by
  unfold frobeniusNormSq
  apply Finset.sum_nonneg
  intros i _
  apply Finset.sum_nonneg
  intros j _
  exact sq_nonneg _

/-- **For Hermitian H: `‖H‖_F² = (H * H).trace.re`**.

    The Frobenius norm squared equals the real part of the trace of
    `H²`. This is the connection between the algebraic spectral-action
    coefficient and the geometric norm. -/
theorem frobeniusNormSq_eq_tr_sq_re
    (H : Matrix (Fin n) (Fin n) ℂ) (hH : H.IsHermitian) :
    frobeniusNormSq H = (H * H).trace.re := by
  unfold frobeniusNormSq
  -- Reuse: (H * H).trace = (H * H†).trace and entry-wise expansion
  rw [tr_sq_eq_tr_mul_conjTranspose H hH]
  rw [Matrix.trace, Complex.re_sum]
  apply Finset.sum_congr rfl
  intros i _
  rw [Matrix.diag_apply]
  rw [Matrix.mul_apply]
  rw [Complex.re_sum]
  apply Finset.sum_congr rfl
  intros j _
  rw [Matrix.conjTranspose_apply]
  rw [show star (H i j) = (starRingEnd ℂ) (H i j) from rfl]
  rw [Complex.mul_conj, Complex.normSq_eq_norm_sq]
  rw [show (((‖H i j‖ ^ 2 : ℝ) : ℂ)).re = ‖H i j‖ ^ 2 from Complex.ofReal_re _]

/-! ## 2. Yukawa-square sum -/

/-- **Trace of yukawaDirac² = Σᵢ (y i)²** (cast to ℂ). -/
theorem tr_yukawaDirac_sq_eq_sum_sq (y : Fin n → ℝ) :
    ((yukawaDirac y) ^ 2).trace = ∑ i : Fin n, ((y i : ℂ)) ^ 2 :=
  yukawaDirac_trace_pow y 2

/-- **Real part of the Yukawa-square sum equals the real Yukawa-squared sum**. -/
theorem tr_yukawaDirac_sq_re (y : Fin n → ℝ) :
    ((yukawaDirac y) ^ 2).trace.re = ∑ i : Fin n, (y i) ^ 2 := by
  rw [tr_yukawaDirac_sq_eq_sum_sq]
  rw [Complex.re_sum]
  apply Finset.sum_congr rfl
  intros i _
  rw [← Complex.ofReal_pow, Complex.ofReal_re]

/-! ## 3. The full SM spectral-action capstone formula -/

/-- **Standard-Model-from-Connes spectral-action formula (real-part)**.

    For Yukawa eigenvalues `y : Fin n → ℝ`, an off-diagonal Hermitian
    Higgs perturbation `H : Matrix (Fin n) (Fin n) ℂ`, and `t : ℝ`:

      Re(Tr((yukawaDirac y + (t : ℂ) • H)²))
        =  Σᵢ (y i)²   +   t² · ‖H‖_F²

    The Yukawa eigenvalues set the t⁰-coefficient (fermion mass scale)
    and the Frobenius norm squared sets the t²-coefficient (Higgs mass
    coefficient). -/
theorem standardModel_spectralAction_formula
    (y : Fin n → ℝ) (H : Matrix (Fin n) (Fin n) ℂ)
    (hH_hermitian : H.IsHermitian) (hH_offDiag : IsOffDiagonal H) (t : ℝ) :
    ((yukawaDirac y + (t : ℂ) • H) ^ 2).trace.re
      = (∑ i : Fin n, (y i) ^ 2) + t ^ 2 * frobeniusNormSq H := by
  rw [tr_yukawa_offDiag_fluctuation y H hH_offDiag (t : ℂ)]
  rw [Complex.add_re]
  rw [tr_yukawaDirac_sq_re]
  rw [Complex.mul_re]
  -- Goal: ... = Σ(y i)² + t² * frobeniusNormSq H
  -- Use t² = ((t:ℂ))² with no imaginary part
  rw [show (((t : ℝ) : ℂ) ^ 2).re = t ^ 2 from by
       rw [← Complex.ofReal_pow, Complex.ofReal_re]]
  rw [show (((t : ℝ) : ℂ) ^ 2).im = 0 from by
       rw [← Complex.ofReal_pow, Complex.ofReal_im]]
  rw [zero_mul, sub_zero]
  rw [frobeniusNormSq_eq_tr_sq_re H hH_hermitian]

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6 CAPSTONE — Standard-Model-from-Connes spectral
    action quadratic formula.**

    For Yukawa eigenvalues `y : Fin n → ℝ`, an off-diagonal Hermitian
    Higgs perturbation `H`, and a real fluctuation parameter `t`:

    1. **Frobenius norm non-negativity**: `0 ≤ ‖H‖_F²`.

    2. **Frobenius-trace identity**: `‖H‖_F² = (H * H).trace.re` for
       Hermitian H.

    3. **Yukawa square-sum trace**:
       `(yukawaDirac y)².trace.re = Σᵢ (y i)²`.

    4. **Full SM spectral action formula**:
       `Re(Tr((yukawaDirac y + t·H)²)) = Σᵢ (y i)² + t² · ‖H‖_F²`.

    This is the rigorous finite-dim capstone of the Chamseddine-Connes
    Higgs-mass derivation. -/
theorem standardModel_from_connes_report
    (y : Fin n → ℝ) (H : Matrix (Fin n) (Fin n) ℂ)
    (hH_hermitian : H.IsHermitian) (hH_offDiag : IsOffDiagonal H) (t : ℝ) :
    0 ≤ frobeniusNormSq H ∧
    frobeniusNormSq H = (H * H).trace.re ∧
    ((yukawaDirac y) ^ 2).trace.re = ∑ i : Fin n, (y i) ^ 2 ∧
    ((yukawaDirac y + (t : ℂ) • H) ^ 2).trace.re
      = (∑ i : Fin n, (y i) ^ 2) + t ^ 2 * frobeniusNormSq H := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact frobeniusNormSq_nonneg H
  · exact frobeniusNormSq_eq_tr_sq_re H hH_hermitian
  · exact tr_yukawaDirac_sq_re y
  · exact standardModel_spectralAction_formula y H hH_hermitian hH_offDiag t

end OmegaTheory.Foundations.StandardModelFromConnes
