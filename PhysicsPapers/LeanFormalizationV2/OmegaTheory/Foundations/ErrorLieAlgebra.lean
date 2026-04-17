/-
  OmegaTheory.Foundations.ErrorLieAlgebra

  Approximate Lie algebra with bounded error.

  Every Lie bracket computed on the discrete substrate carries a
  truncation error. This module defines Lie-algebraic structures
  (bracket, antisymmetry, Jacobi identity) that hold up to explicit
  error bounds, and proves that zero error recovers exact axioms.

  The substrate error is inherited from `computationalUncertainty`.

  Author: Nunki, 2026-04-15.
-/

import OmegaTheory.Foundations.ErrorAlgebra
import OmegaTheory.Irrationality.Uncertainty

namespace OmegaTheory.Foundations

open OmegaTheory.Irrationality
open OmegaTheory.Spacetime

/-! ## Error Lie Bracket

A bracket operation on a real vector space with bounded deviation
from an ideal bracket. -/

/-- A Lie bracket with bounded error: the actual bracket differs from
    the ideal bracket by at most `bracketError X Y`. -/
class ErrorLieBracket (L : Type*) [Add L] [SMul ℝ L] where
  /-- The approximate bracket operation. -/
  bracket : L → L → L
  /-- The error bound on each bracket computation. -/
  bracketError : L → L → ℝ
  /-- The error is nonneg. -/
  bracketError_nonneg : ∀ X Y : L, 0 ≤ bracketError X Y

namespace ErrorLieBracket

variable {L : Type*} [Add L] [SMul ℝ L] [ErrorLieBracket L]

/-- The bracket error as an `ErrorBound`. -/
noncomputable def bracketErrorBound (X Y : L) : ErrorBound :=
  ⟨bracketError X Y, bracketError_nonneg X Y⟩

end ErrorLieBracket

/-! ## Error Lie Algebra

A Lie algebra where antisymmetry and Jacobi hold up to bounded errors,
and the bracket is approximately bilinear. -/

/-- An approximate Lie algebra: bracket satisfying antisymmetry, Jacobi,
    and bilinearity each up to explicit error bounds. -/
class ErrorLieAlgebra (L : Type*) [Add L] [SMul ℝ L]
    extends ErrorLieBracket L where
  /-- Norm on L used to state the axiom defects. -/
  norm : L → ℝ
  norm_nonneg : ∀ X : L, 0 ≤ norm X
  /-- Antisymmetry error bound. -/
  εAntisym : ℝ
  εAntisym_nonneg : 0 ≤ εAntisym
  /-- Antisymmetry up to error: ‖[X,Y] + [Y,X]‖ ≤ εAntisym. -/
  antisym_error : ∀ X Y : L, norm (bracket X Y + bracket Y X) ≤ εAntisym
  /-- Jacobi error bound. -/
  εJacobi : ℝ
  εJacobi_nonneg : 0 ≤ εJacobi
  /-- Jacobi identity up to error:
      ‖[[X,Y],Z] + [[Y,Z],X] + [[Z,X],Y]‖ ≤ εJacobi. -/
  jacobi_error : ∀ X Y Z : L,
    norm (bracket (bracket X Y) Z +
          bracket (bracket Y Z) X +
          bracket (bracket Z X) Y) ≤ εJacobi
  /-- Linearity error bound. -/
  εLinear : ℝ
  εLinear_nonneg : 0 ≤ εLinear
  /-- Left-linearity up to error:
      ‖[aX₁ + bX₂, Y] − a[X₁,Y] − b[X₂,Y]‖ ≤ εLinear. -/
  linear_error_left : ∀ (a b : ℝ) (X₁ X₂ Y : L),
    norm (bracket (a • X₁ + b • X₂) Y +
      (-1 : ℝ) • (a • bracket X₁ Y + b • bracket X₂ Y)) ≤ εLinear

namespace ErrorLieAlgebra

variable {L : Type*} [Add L] [SMul ℝ L] [ErrorLieAlgebra L]

/-- Antisymmetry error as ErrorBound. -/
noncomputable def antisymErrorBound : ErrorBound :=
  ⟨εAntisym (L := L), εAntisym_nonneg⟩

/-- Jacobi error as ErrorBound. -/
noncomputable def jacobiErrorBound : ErrorBound :=
  ⟨εJacobi (L := L), εJacobi_nonneg⟩

/-- Linearity error as ErrorBound. -/
noncomputable def linearErrorBound : ErrorBound :=
  ⟨εLinear (L := L), εLinear_nonneg⟩

end ErrorLieAlgebra

/-! ## Exact Recovery

When all errors are zero, the ErrorLieAlgebra axioms reduce to exact
Lie algebra axioms. -/

section ExactRecovery

variable {L : Type*} [Add L] [SMul ℝ L] [inst : ErrorLieAlgebra L]

/-- If antisymmetry error is zero, we have exact antisymmetry:
    ‖[X,Y] + [Y,X]‖ = 0 for all X, Y. -/
theorem exact_antisym_of_zero_error
    (hε : ErrorLieAlgebra.εAntisym (L := L) = 0) (X Y : L) :
    ErrorLieAlgebra.norm (ErrorLieBracket.bracket X Y +
      ErrorLieBracket.bracket Y X) = 0 := by
  have h := ErrorLieAlgebra.antisym_error X Y
  rw [hε] at h
  exact le_antisymm h (ErrorLieAlgebra.norm_nonneg _)

/-- If Jacobi error is zero, we have exact Jacobi identity:
    ‖[[X,Y],Z] + [[Y,Z],X] + [[Z,X],Y]‖ = 0. -/
theorem exact_jacobi_of_zero_error
    (hε : ErrorLieAlgebra.εJacobi (L := L) = 0) (X Y Z : L) :
    ErrorLieAlgebra.norm (ErrorLieBracket.bracket (ErrorLieBracket.bracket X Y) Z +
      ErrorLieBracket.bracket (ErrorLieBracket.bracket Y Z) X +
      ErrorLieBracket.bracket (ErrorLieBracket.bracket Z X) Y) = 0 := by
  have h := ErrorLieAlgebra.jacobi_error X Y Z
  rw [hε] at h
  exact le_antisymm h (ErrorLieAlgebra.norm_nonneg _)

/-- If linearity error is zero, we have exact left-linearity. -/
theorem exact_linearity_of_zero_error
    (hε : ErrorLieAlgebra.εLinear (L := L) = 0)
    (a b : ℝ) (X₁ X₂ Y : L) :
    ErrorLieAlgebra.norm (ErrorLieBracket.bracket (a • X₁ + b • X₂) Y +
      (-1 : ℝ) • (a • ErrorLieBracket.bracket X₁ Y +
        b • ErrorLieBracket.bracket X₂ Y)) = 0 := by
  have h := ErrorLieAlgebra.linear_error_left a b X₁ X₂ Y
  rw [hε] at h
  exact le_antisymm h (ErrorLieAlgebra.norm_nonneg _)

/-- Full exact recovery: all three axioms hold exactly when all errors vanish. -/
theorem exact_lie_algebra_of_all_errors_zero
    (hA : ErrorLieAlgebra.εAntisym (L := L) = 0)
    (hJ : ErrorLieAlgebra.εJacobi (L := L) = 0)
    (hL : ErrorLieAlgebra.εLinear (L := L) = 0) :
    (∀ X Y : L, ErrorLieAlgebra.norm
      (ErrorLieBracket.bracket X Y + ErrorLieBracket.bracket Y X) = 0) ∧
    (∀ X Y Z : L, ErrorLieAlgebra.norm
      (ErrorLieBracket.bracket (ErrorLieBracket.bracket X Y) Z +
       ErrorLieBracket.bracket (ErrorLieBracket.bracket Y Z) X +
       ErrorLieBracket.bracket (ErrorLieBracket.bracket Z X) Y) = 0) ∧
    (∀ (a b : ℝ) (X₁ X₂ Y : L), ErrorLieAlgebra.norm
      (ErrorLieBracket.bracket (a • X₁ + b • X₂) Y +
       (-1 : ℝ) • (a • ErrorLieBracket.bracket X₁ Y +
         b • ErrorLieBracket.bracket X₂ Y)) = 0) :=
  ⟨exact_antisym_of_zero_error hA,
   exact_jacobi_of_zero_error hJ,
   exact_linearity_of_zero_error hL⟩

end ExactRecovery

/-! ## Substrate Lie Bracket Error

The discrete substrate's Lie bracket error is bounded by the
computational uncertainty from irrational truncation, which
decreases with iteration count N and tends to 0. -/

/-- Substrate Lie bracket error at iteration count N.
    Inherited from `computationalUncertainty`. -/
noncomputable def substrateLieBracketError (N : ℕ) : ℝ :=
  computationalUncertainty N

/-- Substrate Lie bracket error is nonneg. -/
theorem substrateLieBracketError_nonneg (N : ℕ) :
    0 ≤ substrateLieBracketError N :=
  computationalUncertainty_nonneg N

/-- Substrate Lie bracket error is positive. -/
theorem substrateLieBracketError_pos (N : ℕ) :
    0 < substrateLieBracketError N :=
  computationalUncertainty_pos N

/-- Substrate Lie bracket error as ErrorBound. -/
noncomputable def substrateLieBracketErrorBound (N : ℕ) : ErrorBound :=
  ⟨substrateLieBracketError N, substrateLieBracketError_nonneg N⟩

/-- Substrate Lie bracket error is decreasing in N. -/
theorem substrateLieBracketError_decreasing (N : ℕ) :
    substrateLieBracketError (N + 1) ≤ substrateLieBracketError N :=
  computationalUncertainty_decreasing N

/-- Substrate Lie bracket error tends to 0: for any ε > 0,
    there exists N such that the error is below ε.

    Proof: `computationalUncertainty N = l_P · 4/(2N+3)`, so
    choosing N large enough makes this arbitrarily small. -/
theorem substrateLieBracketError_tendsto_zero (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, substrateLieBracketError N < ε := by
  unfold substrateLieBracketError computationalUncertainty
  suffices ∃ N : ℕ, l_P * (dominantErrorBound N).val < ε by exact this
  obtain ⟨N, hN⟩ := exists_nat_gt (4 * l_P / ε)
  use N
  unfold dominantErrorBound piErrorBound pi_error_val
  simp only
  -- Goal: l_P * (4 / (2 * ↑N + 3)) < ε
  have hd : (0 : ℝ) < 2 * ↑N + 3 := by positivity
  have hlP := l_P_pos
  have hrw : l_P * (4 / (2 * ↑N + 3)) = 4 * l_P / (2 * ↑N + 3) := by ring
  rw [hrw, div_lt_iff₀ hd]
  -- Goal: 4 * l_P < ε * (2 * ↑N + 3)
  have hstep : ε * (2 * (4 * l_P / ε) + 3) = 8 * l_P + 3 * ε := by
    field_simp; ring
  nlinarith

/-- The error bound sequence is monotonically decreasing. -/
theorem substrateLieBracketErrorBound_decreasing (N : ℕ) :
    substrateLieBracketErrorBound (N + 1) ≤ substrateLieBracketErrorBound N :=
  substrateLieBracketError_decreasing N

end OmegaTheory.Foundations
