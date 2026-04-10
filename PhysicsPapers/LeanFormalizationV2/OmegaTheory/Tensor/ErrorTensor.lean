/-
  OmegaTheory.Tensor.ErrorTensor

  Valued tensor fields — tensor fields where every component carries
  an explicit error bound. This is the foundation of V2's innovation:
  error tracking is structural, not a bolt-on bridge.

  A `ValuedScalarField` assigns a `Valued ℝ` to each lattice point.
  A `ValuedTensorField p q` assigns a `Valued ℝ` to each (point, indices) tuple.
-/

import OmegaTheory.Foundations.ErrorAlgebra
import OmegaTheory.Spacetime.Lattice

namespace OmegaTheory.Tensor

open OmegaTheory.Foundations
open OmegaTheory.Spacetime

/-! ## Valued Fields -/

/-- A scalar field where each point carries a value and an error bound. -/
abbrev ValuedScalarField := LatticePoint → Valued ℝ

/-- A tensor field of type (p,q) where each component carries an error bound. -/
abbrev ValuedTensorField (p q : ℕ) :=
  LatticePoint → (Fin p → Fin 4) → (Fin q → Fin 4) → Valued ℝ

/-- Valued metric: a (0,2) valued tensor field. -/
abbrev ValuedTensor02Field := ValuedTensorField 0 2

/-- Valued (2,0) tensor field (e.g., inverse metric with error). -/
abbrev ValuedTensor20Field := ValuedTensorField 2 0

/-! ## Lifting exact fields into valued fields -/

/-- Lift an ordinary scalar field to a valued field with zero error. -/
def ValuedScalarField.exact (f : ScalarField) : ValuedScalarField :=
  fun p => Valued.exact (f p)

/-- Lift an ordinary tensor field to a valued tensor field with zero error. -/
def ValuedTensorField.exact {p q : ℕ} (f : LatticeTensorField p q) :
    ValuedTensorField p q :=
  fun n upper lower => Valued.exact (f n upper lower)

/-! ## Extracting values and errors -/

/-- Extract the value component of a valued scalar field. -/
def ValuedScalarField.toScalar (f : ValuedScalarField) : ScalarField :=
  fun p => (f p).val

/-- Extract the error bound at each point. -/
def ValuedScalarField.errorAt (f : ValuedScalarField) (p : LatticePoint) :
    ErrorBound := (f p).error

/-- Extract the value component of a valued tensor field. -/
def ValuedTensorField.toTensor {p q : ℕ} (f : ValuedTensorField p q) :
    LatticeTensorField p q :=
  fun n upper lower => (f n upper lower).val

/-- Extract the error bound of a specific component. -/
def ValuedTensorField.errorAt {p q : ℕ} (f : ValuedTensorField p q)
    (n : LatticePoint) (upper : Fin p → Fin 4) (lower : Fin q → Fin 4) :
    ErrorBound := (f n upper lower).error

/-! ## Exact field properties -/

/-- Exact scalar fields have zero error everywhere. -/
theorem ValuedScalarField.exact_error_zero (f : ScalarField) (p : LatticePoint) :
    (ValuedScalarField.exact f p).error = ErrorBound.zero := by
  simp [ValuedScalarField.exact, Valued.exact, ErrorBound.zero]

/-- Exact scalar fields preserve values. -/
theorem ValuedScalarField.exact_val (f : ScalarField) (p : LatticePoint) :
    (ValuedScalarField.exact f p).val = f p := by
  simp [ValuedScalarField.exact, Valued.exact]

/-- Exact tensor fields have zero error everywhere. -/
theorem ValuedTensorField.exact_error_zero {p q : ℕ} (f : LatticeTensorField p q)
    (n : LatticePoint) (upper : Fin p → Fin 4) (lower : Fin q → Fin 4) :
    (ValuedTensorField.exact f n upper lower).error = ErrorBound.zero := by
  simp [ValuedTensorField.exact, Valued.exact, ErrorBound.zero]

/-- Exact tensor fields preserve values. -/
theorem ValuedTensorField.exact_val {p q : ℕ} (f : LatticeTensorField p q)
    (n : LatticePoint) (upper : Fin p → Fin 4) (lower : Fin q → Fin 4) :
    (ValuedTensorField.exact f n upper lower).val = f n upper lower := by
  simp [ValuedTensorField.exact, Valued.exact]

/-- Round-trip: extracting value from exact field gives back the original. -/
theorem ValuedScalarField.exact_toScalar (f : ScalarField) :
    (ValuedScalarField.exact f).toScalar = f := by
  ext p; simp [toScalar, exact, Valued.exact]

/-- Round-trip for tensor fields. -/
theorem ValuedTensorField.exact_toTensor {p q : ℕ} (f : LatticeTensorField p q) :
    (ValuedTensorField.exact f).toTensor = f := by
  ext n upper lower; simp [toTensor, exact, Valued.exact]

/-! ## Uniform error fields -/

/-- A valued scalar field with uniform error ε at every point. -/
def ValuedScalarField.withUniformError (f : ScalarField) (ε : ErrorBound) :
    ValuedScalarField :=
  fun p => ⟨f p, ε⟩

/-- Uniform error fields have the stated error at every point. -/
theorem ValuedScalarField.uniformError_eq (f : ScalarField) (ε : ErrorBound)
    (p : LatticePoint) :
    (ValuedScalarField.withUniformError f ε p).error = ε := rfl

/-- Uniform error fields preserve values. -/
theorem ValuedScalarField.uniformError_val (f : ScalarField) (ε : ErrorBound)
    (p : LatticePoint) :
    (ValuedScalarField.withUniformError f ε p).val = f p := rfl

/-! ## Pointwise operations on valued fields -/

/-- Add two valued scalar fields: values add, errors add. -/
def ValuedScalarField.add (f g : ValuedScalarField) : ValuedScalarField :=
  fun p => ⟨(f p).val + (g p).val, (f p).error + (g p).error⟩

/-- Subtraction of valued scalar fields: values subtract, errors add
    (triangle inequality). -/
def ValuedScalarField.sub (f g : ValuedScalarField) : ValuedScalarField :=
  fun p => ⟨(f p).val - (g p).val, (f p).error + (g p).error⟩

/-- Addition preserves the error addition rule. -/
theorem ValuedScalarField.add_error (f g : ValuedScalarField) (p : LatticePoint) :
    (ValuedScalarField.add f g p).error = (f p).error + (g p).error := rfl

/-- Subtraction error equals sum of input errors (triangle inequality). -/
theorem ValuedScalarField.sub_error (f g : ValuedScalarField) (p : LatticePoint) :
    (ValuedScalarField.sub f g p).error = (f p).error + (g p).error := rfl

/-- Adding exact fields produces an exact field. -/
theorem ValuedScalarField.add_exact (f g : ScalarField) :
    ValuedScalarField.add (exact f) (exact g) =
    fun p => ⟨f p + g p, ErrorBound.zero + ErrorBound.zero⟩ := by
  ext p <;> simp [add, exact, Valued.exact, ErrorBound.zero]

end OmegaTheory.Tensor
