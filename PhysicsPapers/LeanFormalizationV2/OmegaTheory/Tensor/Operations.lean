/-
  OmegaTheory.Tensor.Operations

  Error-propagating discrete operators on valued fields.

  The KEY INNOVATION of V2: every lattice operation explicitly tracks
  how errors propagate. Division by l_P is exact (it's a constant),
  but subtraction of valued quantities adds their errors (triangle inequality).

  Error propagation rules:
  - Subtraction: ε(a - b) = ε(a) + ε(b)
  - Division by constant: ε(a / c) = ε(a) / |c|  (c > 0)
  - Forward diff: ε = (ε(p+) + ε(p)) / l_P
  - Second deriv: ε = (ε(p+) + 2·ε(p) + ε(p-)) / l_P²
  - Laplacian: ε = Σ_μ secondDeriv_error
-/

import OmegaTheory.Tensor.ErrorTensor
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Tensor

open OmegaTheory.Foundations
open OmegaTheory.Spacetime

/-! ## Error-propagating difference operators -/

/-- Forward difference of a valued scalar field.
    Value: (f(p+) - f(p)) / l_P  (same as exact forward diff on values)
    Error: (ε(p+) + ε(p)) / l_P  (triangle inequality for subtraction, then divide by constant) -/
noncomputable def valuedForwardDiff (f : ValuedScalarField) (μ : Fin 4)
    (p : LatticePoint) : Valued ℝ :=
  ⟨ ((f (shiftFin p μ)).val - (f p).val) / l_P,
    ⟨ ((f (shiftFin p μ)).error.val + (f p).error.val) / l_P,
      div_nonneg (add_nonneg (f (shiftFin p μ)).error.nonneg (f p).error.nonneg)
        (le_of_lt l_P_pos) ⟩ ⟩

/-- Backward difference of a valued scalar field. -/
noncomputable def valuedBackwardDiff (f : ValuedScalarField) (μ : Fin 4)
    (p : LatticePoint) : Valued ℝ :=
  ⟨ ((f p).val - (f (shiftBackFin p μ)).val) / l_P,
    ⟨ ((f p).error.val + (f (shiftBackFin p μ)).error.val) / l_P,
      div_nonneg (add_nonneg (f p).error.nonneg (f (shiftBackFin p μ)).error.nonneg)
        (le_of_lt l_P_pos) ⟩ ⟩

/-- Symmetric (central) difference of a valued scalar field. -/
noncomputable def valuedSymmetricDiff (f : ValuedScalarField) (μ : Fin 4)
    (p : LatticePoint) : Valued ℝ :=
  ⟨ ((f (shiftFin p μ)).val - (f (shiftBackFin p μ)).val) / (2 * l_P),
    ⟨ ((f (shiftFin p μ)).error.val + (f (shiftBackFin p μ)).error.val) / (2 * l_P),
      div_nonneg
        (add_nonneg (f (shiftFin p μ)).error.nonneg (f (shiftBackFin p μ)).error.nonneg)
        (le_of_lt (mul_pos two_pos l_P_pos)) ⟩ ⟩

/-- Second derivative of a valued scalar field.
    Error: (ε(p+) + 2·ε(p) + ε(p-)) / l_P²
    The factor 2 on ε(p) comes from the -2f(p) coefficient. -/
noncomputable def valuedSecondDeriv (f : ValuedScalarField) (μ : Fin 4)
    (p : LatticePoint) : Valued ℝ :=
  ⟨ ((f (shiftFin p μ)).val - 2 * (f p).val + (f (shiftBackFin p μ)).val) / (l_P ^ 2),
    ⟨ ((f (shiftFin p μ)).error.val + 2 * (f p).error.val +
        (f (shiftBackFin p μ)).error.val) / (l_P ^ 2),
      div_nonneg
        (add_nonneg
          (add_nonneg (f (shiftFin p μ)).error.nonneg
            (mul_nonneg two_pos.le (f p).error.nonneg))
          (f (shiftBackFin p μ)).error.nonneg)
        (le_of_lt l_P_sq_pos) ⟩ ⟩

/-! ## Value component matches exact operators -/

/-- The value of valuedForwardDiff matches the exact forwardDiff. -/
theorem valuedForwardDiff_val (f : ValuedScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedForwardDiff f μ p).val = forwardDiff f.toScalar μ p := by
  simp [valuedForwardDiff, forwardDiff, ValuedScalarField.toScalar]

/-- The value of valuedBackwardDiff matches the exact backwardDiff. -/
theorem valuedBackwardDiff_val (f : ValuedScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedBackwardDiff f μ p).val = backwardDiff f.toScalar μ p := by
  simp [valuedBackwardDiff, backwardDiff, ValuedScalarField.toScalar]

/-- The value of valuedSymmetricDiff matches the exact symmetricDiff. -/
theorem valuedSymmetricDiff_val (f : ValuedScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedSymmetricDiff f μ p).val = symmetricDiff f.toScalar μ p := by
  simp [valuedSymmetricDiff, symmetricDiff, ValuedScalarField.toScalar]

/-- The value of valuedSecondDeriv matches the exact secondDeriv. -/
theorem valuedSecondDeriv_val (f : ValuedScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedSecondDeriv f μ p).val = secondDeriv f.toScalar μ p := by
  simp [valuedSecondDeriv, secondDeriv, ValuedScalarField.toScalar]

/-! ## Exact fields produce zero error -/

/-- Forward diff of an exact field has zero error. -/
theorem valuedForwardDiff_exact_error (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedForwardDiff (ValuedScalarField.exact f) μ p).error.val = 0 := by
  simp [valuedForwardDiff, ValuedScalarField.exact, Valued.exact, ErrorBound.zero]

/-- Backward diff of an exact field has zero error. -/
theorem valuedBackwardDiff_exact_error (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedBackwardDiff (ValuedScalarField.exact f) μ p).error.val = 0 := by
  simp [valuedBackwardDiff, ValuedScalarField.exact, Valued.exact, ErrorBound.zero]

/-- Second derivative of an exact field has zero error. -/
theorem valuedSecondDeriv_exact_error (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    (valuedSecondDeriv (ValuedScalarField.exact f) μ p).error.val = 0 := by
  simp [valuedSecondDeriv, ValuedScalarField.exact, Valued.exact, ErrorBound.zero]

/-! ## Uniform error bounds -/

/-- Forward diff with uniform error ε gives error ≤ 2ε/l_P. -/
theorem valuedForwardDiff_uniform_error (f : ScalarField) (ε : ErrorBound)
    (μ : Fin 4) (p : LatticePoint) :
    (valuedForwardDiff (ValuedScalarField.withUniformError f ε) μ p).error.val =
    (ε.val + ε.val) / l_P := by
  simp [valuedForwardDiff, ValuedScalarField.withUniformError]

/-- Second derivative with uniform error ε gives error = 4ε/l_P². -/
theorem valuedSecondDeriv_uniform_error (f : ScalarField) (ε : ErrorBound)
    (μ : Fin 4) (p : LatticePoint) :
    (valuedSecondDeriv (ValuedScalarField.withUniformError f ε) μ p).error.val =
    (ε.val + 2 * ε.val + ε.val) / (l_P ^ 2) := by
  simp [valuedSecondDeriv, ValuedScalarField.withUniformError]

/-! ## Error cascade: N operations -/

/-- Cascading N additions, each with error ε, gives total error N·ε.
    This is the fundamental bound: if you sum N terms each with error ε,
    the total error is at most N·ε. -/
theorem error_sum_bound (errors : Fin n → ErrorBound) (ε : ErrorBound)
    (h : ∀ i, errors i ≤ ε) :
    (Finset.univ.sum fun i => (errors i).val) ≤ n * ε.val := by
  calc (Finset.univ.sum fun i => (errors i).val)
      ≤ Finset.univ.sum fun _ => ε.val := by
        apply Finset.sum_le_sum; intro i _; exact h i
    _ = n * ε.val := by simp [Finset.sum_const, Finset.card_fin]

end OmegaTheory.Tensor
