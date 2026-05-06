/-
  OmegaTheory.Foundations.YukawaDirac

  **Lion's-Pride Phase 6.5a (2026-05-06)**:
  *Yukawa-diagonal Dirac operator and explicit identification of its
  finite-dim Seeley-DeWitt heat-kernel coefficients with Yukawa power
  moments.*

  ## Why this file

  The Chamseddine-Connes 1996+ derivation of the Standard Model
  Lagrangian from a finite spectral triple proceeds via the
  spectral action

      S(D_F, Λ, f)  =  Tr(f(D_F / Λ))

  expanded asymptotically at large Λ via the heat-kernel coefficients
  `a_k(D_F²)`.  In FINITE DIMENSIONS, where `D_F` is an n×n Hermitian
  matrix, the heat-kernel coefficients are simply

      a_k(D_F)  =  Tr(D_F^{2k})    (the 2k-th trace moment)

  This file ships the GENUINE physics piece: when `D_F` is a Yukawa-
  encoded diagonal matrix
      D_F  =  diag(y_1, y_2, ..., y_n),
  the trace moments REDUCE EXPLICITLY to Yukawa power sums:

      a_0(D_F)  =  n                       (fermion d.o.f. count)
      a_1(D_F)  =  Σᵢ yᵢ²                   (Yukawa-square sum)
      a_2(D_F)  =  Σᵢ yᵢ⁴                   (Yukawa-fourth sum)
      a_k(D_F)  =  Σᵢ yᵢ^{2k}              (general)

  ## What this file ships

  | Property                                       | Theorem                                  |
  |------------------------------------------------|------------------------------------------|
  | `yukawaDirac y` (diagonal real matrix)         | (definition)                             |
  | yukawaDirac is Hermitian                       | `yukawaDirac_isHermitian`                |
  | yukawaDirac applied at i j                     | `yukawaDirac_apply`                      |
  | yukawaDirac²(i,i) = yᵢ²                        | `yukawaDirac_sq_diag`                    |
  | a_0 = n (already from HeatKernelCoefficients)  | `yukawaSpectralTriple_a0`                |
  | a_1 = Σᵢ yᵢ²                                   | `yukawaDirac_a1_eq_sum_sq`                |
  | a_k = Σᵢ yᵢ^{2k}                                | `yukawaDirac_ak_eq_sum_pow`               |
  | Headline 4-conjunct                            | `yukawa_dirac_report`                    |

  ## Honest scope

  This file ships the EXPLICIT trace-moment identification for a
  Yukawa-diagonal D_F.  It does NOT ship:

  * The fluctuation `D_F → D_F + [D_F, π(a)]` for `a ∈ A_F` — needed
    to extract the Higgs scalar field from the spectral triple.
  * The `a_2`-coefficient connection to `μ²·H†H` Higgs mass term —
    requires the fluctuation analysis above.
  * The `a_4`-coefficient connection to `λ·(H†H)² + F²` quartic Higgs +
    gauge field strength — same.

  These are scheduled for Phase 6.5b/c per the multi-month
  `b-5-eager-piglet.md` plan.

  What it DOES ship: the rigorous **finite-dim algebraic backbone**:
  the trace-moment computations on a diagonal Yukawa matrix that
  reduce a_k to Σᵢ yᵢ^{2k}.  This is the substantive arithmetic
  underlying Connes' Higgs-mass derivation.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.  Lean core only.
  No abstraction towers — every theorem proved with concrete matrix
  algebra and Finset.sum manipulation, not META compositions.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.FiniteSpectralTriple
import OmegaTheory.Foundations.HeatKernelCoefficients
import Mathlib.LinearAlgebra.Matrix.Diagonal
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.YukawaDirac

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients

/-! ## 1. Yukawa-diagonal Dirac matrix -/

/-- **Yukawa-diagonal Dirac operator** on `ℂ^n`.

    Given `n` real Yukawa eigenvalues `y : Fin n → ℝ`, the Yukawa
    Dirac is the diagonal matrix with entries `(y i, 0)` (real
    diagonal, zero imaginary part) viewed as a complex matrix.

    Physically: each `y i` is a fermion's Yukawa coupling, and `D_F`
    is the finite Dirac operator from the Chamseddine-Connes 1996+
    finite spectral triple. -/
noncomputable def yukawaDirac {n : ℕ} (y : Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℂ :=
  Matrix.diagonal (fun i => (y i : ℂ))

/-- **yukawaDirac at (i, i) = y i** (cast to ℂ). -/
theorem yukawaDirac_apply_diag {n : ℕ} (y : Fin n → ℝ) (i : Fin n) :
    yukawaDirac y i i = (y i : ℂ) := by
  unfold yukawaDirac
  rw [Matrix.diagonal_apply_eq]

/-- **yukawaDirac at (i, j) = 0** when `i ≠ j`. -/
theorem yukawaDirac_apply_off_diag {n : ℕ} (y : Fin n → ℝ)
    {i j : Fin n} (h : i ≠ j) :
    yukawaDirac y i j = 0 := by
  unfold yukawaDirac
  rw [Matrix.diagonal_apply_ne _ h]

/-- **yukawaDirac is Hermitian**: a real diagonal matrix is Hermitian
    since `(diag(rᵢ))ᴴ = diag(conj rᵢ) = diag(rᵢ)` (real ⟹ self-conj). -/
theorem yukawaDirac_isHermitian {n : ℕ} (y : Fin n → ℝ) :
    (yukawaDirac y).IsHermitian := by
  unfold yukawaDirac
  rw [Matrix.isHermitian_diagonal_iff]
  intro i
  change star ((y i : ℂ)) = (y i : ℂ)
  rw [RCLike.star_def, Complex.conj_ofReal]

/-! ## 2. Yukawa Dirac as a finite spectral triple -/

/-- **Standard-Model finite spectral triple from Yukawa eigenvalues**.

    Given `y : Fin n → ℝ` Yukawa couplings, build the finite spectral
    triple `(A, ℂ^n, D_F)` with `D_F` the Yukawa-diagonal Dirac.
    The `algebraDim` is set to `n` (canonical choice; the actual
    Chamseddine-Connes A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ) has dim 14, set in
    Phase 6.5b downstream when packaging the SM-specific eigenvalues). -/
noncomputable def yukawaSpectralTriple {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    FiniteSpectralTriple n where
  D := yukawaDirac y
  D_isHermitian := yukawaDirac_isHermitian y
  algebraDim := n
  algebraDim_pos := h

/-- **The Dirac of yukawaSpectralTriple is yukawaDirac**. -/
theorem yukawaSpectralTriple_D_eq {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    (yukawaSpectralTriple h y).D = yukawaDirac y := rfl

/-! ## 3. Diagonal-matrix powers: D^k(i,i) = (y i)^k -/

/-- **yukawaDirac^k at (i, i) = (y i)^k** (cast to ℂ).

    Diagonal matrices are closed under powers: `(diag v)^k = diag (v^k)`,
    so the (i, i)-entry of the k-th power is just `(y i)^k`. -/
theorem yukawaDirac_pow_diag {n : ℕ} (y : Fin n → ℝ) (k : ℕ) (i : Fin n) :
    ((yukawaDirac y) ^ k) i i = ((y i : ℂ)) ^ k := by
  unfold yukawaDirac
  rw [Matrix.diagonal_pow, Matrix.diagonal_apply_eq, Pi.pow_apply]

/-- **yukawaDirac^k at (i, j) = 0** when `i ≠ j`.

    Diagonal-power preserves diagonal structure. -/
theorem yukawaDirac_pow_off_diag {n : ℕ} (y : Fin n → ℝ) (k : ℕ)
    {i j : Fin n} (h : i ≠ j) :
    ((yukawaDirac y) ^ k) i j = 0 := by
  unfold yukawaDirac
  rw [Matrix.diagonal_pow, Matrix.diagonal_apply_ne _ h]

/-! ## 4. Trace of yukawaDirac^k = Σ (y i)^k -/

/-- **Trace of yukawaDirac^k = Σᵢ (y i)^k** (cast to ℂ).

    The trace is the sum of diagonal entries, and for a diagonal
    matrix raised to the k-th power, the diagonal at (i, i) is
    `(y i)^k`.  Hence `Tr(D^k) = Σᵢ (y i)^k`. -/
theorem yukawaDirac_trace_pow {n : ℕ} (y : Fin n → ℝ) (k : ℕ) :
    ((yukawaDirac y) ^ k).trace = ∑ i : Fin n, ((y i : ℂ)) ^ k := by
  rw [Matrix.trace]
  apply Finset.sum_congr rfl
  intros i _
  exact yukawaDirac_pow_diag y k i

/-! ## 5. Heat-kernel coefficients of yukawaSpectralTriple -/

/-- **a_k(yukawaSpectralTriple) = Σᵢ (y i)^{2k}**.

    The k-th heat-kernel coefficient
    `a_k(T) := Tr(T.D^{2k})`
    of the Yukawa spectral triple equals the (2k)-th Yukawa power sum.

    This is the GENUINE physical content of finite-dim Connes:
    spectral-action coefficients are EXPLICIT polynomial functions
    of the Yukawa eigenvalues. -/
theorem yukawaDirac_ak_eq_sum_pow {n : ℕ} (h : 0 < n) (y : Fin n → ℝ)
    (k : ℕ) :
    heatKernelCoef (yukawaSpectralTriple h y) k
      = ∑ i : Fin n, ((y i : ℂ)) ^ (2 * k) := by
  unfold heatKernelCoef
  rw [yukawaSpectralTriple_D_eq]
  exact yukawaDirac_trace_pow y (2 * k)

/-- **a_0(yukawaSpectralTriple) = n** (number of fermion d.o.f.).

    Specializing `k = 0`: `Σᵢ (y i)^0 = Σᵢ 1 = n`.  Already follows
    from `heatKernelCoef_zero` in Phase 6.2, but we re-derive it here
    via the Yukawa-power-sum form for consistency. -/
theorem yukawaSpectralTriple_a0 {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    heatKernelCoef (yukawaSpectralTriple h y) 0 = (n : ℂ) := by
  rw [yukawaDirac_ak_eq_sum_pow h y 0]
  simp [Finset.sum_const, Finset.card_univ]

/-- **a_1(yukawaSpectralTriple) = Σᵢ (y i)²**.

    The first heat-kernel coefficient equals the SUM OF SQUARED YUKAWA
    COUPLINGS — physically the trace of `D_F²` which appears in the
    spectral-action expansion as the Higgs mass-squared coefficient
    times the Higgs-doublet norm `H†H`. -/
theorem yukawaSpectralTriple_a1 {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    heatKernelCoef (yukawaSpectralTriple h y) 1
      = ∑ i : Fin n, ((y i : ℂ)) ^ 2 := by
  rw [yukawaDirac_ak_eq_sum_pow h y 1]

/-- **a_2(yukawaSpectralTriple) = Σᵢ (y i)⁴**.

    The second heat-kernel coefficient equals the SUM OF FOURTH-POWER
    YUKAWA COUPLINGS — physically the trace of `D_F⁴` which contains
    the Higgs quartic coupling λ in the Connes derivation. -/
theorem yukawaSpectralTriple_a2 {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    heatKernelCoef (yukawaSpectralTriple h y) 2
      = ∑ i : Fin n, ((y i : ℂ)) ^ 4 := by
  rw [yukawaDirac_ak_eq_sum_pow h y 2]

/-! ## 6. Realness of Yukawa-power sums -/

/-- **a_k(yukawaSpectralTriple) is real** (zero imaginary part).

    Specialization of `heatKernelCoef_im_zero` to the Yukawa case;
    follows since each `(y i : ℂ)^(2k)` is real (real-base power). -/
theorem yukawaSpectralTriple_ak_im_zero {n : ℕ} (h : 0 < n)
    (y : Fin n → ℝ) (k : ℕ) :
    (heatKernelCoef (yukawaSpectralTriple h y) k).im = 0 := by
  exact heatKernelCoef_im_zero (yukawaSpectralTriple h y) k

/-! ## 7. Non-negativity of a_1 (sum-of-squares form) -/

/-- **a_1(yukawaSpectralTriple) has non-negative real part**.

    Each `(y i)²` is a non-negative real, hence so is the sum.  The
    real part of `a_1` is therefore `≥ 0`. -/
theorem yukawaSpectralTriple_a1_re_nonneg {n : ℕ} (h : 0 < n)
    (y : Fin n → ℝ) :
    0 ≤ (heatKernelCoef (yukawaSpectralTriple h y) 1).re := by
  rw [yukawaSpectralTriple_a1 h y]
  -- Σᵢ (y i : ℂ)² has re = Σᵢ (y i)² ≥ 0
  rw [Complex.re_sum]
  apply Finset.sum_nonneg
  intros i _
  -- Goal: 0 ≤ ((y i : ℂ)^2).re; expand to ℝ via push_cast
  have : ((y i : ℂ))^2 = ((y i)^2 : ℝ) := by push_cast; rfl
  rw [this, Complex.ofReal_re]
  exact sq_nonneg _

/-! ## 8. Headline composite report -/

/-- **Lion's-Pride Phase 6.5a headline — Yukawa-Dirac heat-kernel
    structural report.**

    For any `n > 0`, Yukawa eigenvalues `y : Fin n → ℝ`:

    1. **yukawaDirac is Hermitian**.

    2. **a_0 = n** (number of fermion degrees of freedom).

    3. **a_1 = Σᵢ (y i)²** (sum of squared Yukawa couplings = trace
       of D_F², the Higgs-mass-squared spectral-action coefficient).

    4. **a_2 = Σᵢ (y i)⁴** (sum of fourth-power Yukawa couplings =
       trace of D_F⁴, contributing to the Higgs-quartic λ in the
       Chamseddine-Connes derivation). -/
theorem yukawa_dirac_report {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) :
    (yukawaDirac y).IsHermitian ∧
    heatKernelCoef (yukawaSpectralTriple h y) 0 = (n : ℂ) ∧
    heatKernelCoef (yukawaSpectralTriple h y) 1
      = ∑ i : Fin n, ((y i : ℂ)) ^ 2 ∧
    heatKernelCoef (yukawaSpectralTriple h y) 2
      = ∑ i : Fin n, ((y i : ℂ)) ^ 4 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact yukawaDirac_isHermitian y
  · exact yukawaSpectralTriple_a0 h y
  · exact yukawaSpectralTriple_a1 h y
  · exact yukawaSpectralTriple_a2 h y

end OmegaTheory.Foundations.YukawaDirac
