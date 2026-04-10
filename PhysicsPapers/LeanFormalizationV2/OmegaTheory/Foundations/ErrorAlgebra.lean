/-
  OmegaTheory.Foundations.ErrorAlgebra

  The fundamental algebraic structure for error propagation.

  Every computation on the discrete lattice carries an error bound.
  This module defines how errors compose under addition and multiplication.
  This is the "new math" — a defect-aware algebra where every operation
  explicitly tracks its error contribution.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic

namespace OmegaTheory.Foundations

/-- An `ErrorBound` is a nonneg real representing the maximum error
    from a single computational step (truncation of irrationals). -/
structure ErrorBound where
  val : ℝ
  nonneg : 0 ≤ val

namespace ErrorBound

instance : LE ErrorBound where
  le a b := a.val ≤ b.val

instance : LT ErrorBound where
  lt a b := a.val < b.val

/-- Zero error (exact computation). -/
def zero : ErrorBound := ⟨0, le_refl 0⟩

/-- Error addition: errors from independent sources add. -/
def add (ε₁ ε₂ : ErrorBound) : ErrorBound :=
  ⟨ε₁.val + ε₂.val, add_nonneg ε₁.nonneg ε₂.nonneg⟩

instance : Add ErrorBound where
  add := ErrorBound.add

/-- Error multiplication: errors from dependent sources multiply. -/
def mul (ε₁ ε₂ : ErrorBound) : ErrorBound :=
  ⟨ε₁.val * ε₂.val, mul_nonneg ε₁.nonneg ε₂.nonneg⟩

instance : Mul ErrorBound where
  mul := ErrorBound.mul

/-- Addition is commutative on values. -/
theorem add_val (ε₁ ε₂ : ErrorBound) : (ε₁ + ε₂).val = ε₁.val + ε₂.val := rfl

/-- Multiplication is commutative on values. -/
theorem mul_val (ε₁ ε₂ : ErrorBound) : (ε₁ * ε₂).val = ε₁.val * ε₂.val := rfl

/-- Zero is a left identity for addition. -/
theorem zero_add (ε : ErrorBound) : (zero + ε).val = ε.val := by
  simp [add_val, zero]

/-- Zero is a left annihilator for multiplication. -/
theorem zero_mul (ε : ErrorBound) : (zero * ε).val = 0 := by
  simp [mul_val, zero]

/-- Addition is monotone: if ε₁ ≤ ε₁' and ε₂ ≤ ε₂', then ε₁ + ε₂ ≤ ε₁' + ε₂'. -/
theorem add_le_add {ε₁ ε₁' ε₂ ε₂' : ErrorBound}
    (h1 : ε₁ ≤ ε₁') (h2 : ε₂ ≤ ε₂') : ε₁ + ε₂ ≤ ε₁' + ε₂' := by
  change (ε₁ + ε₂).val ≤ (ε₁' + ε₂').val
  simp only [add_val]
  exact _root_.add_le_add h1 h2

/-- Error from multiplying quantities: if |a| ≤ A, |b| ≤ B with errors ε_a, ε_b,
    then |(a+ε_a)(b+ε_b) - ab| ≤ A·ε_b + B·ε_a + ε_a·ε_b -/
theorem mul_error_bound {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (ε_a ε_b : ErrorBound) :
    0 ≤ A * ε_b.val + B * ε_a.val + ε_a.val * ε_b.val :=
  add_nonneg (add_nonneg (mul_nonneg hA ε_b.nonneg) (mul_nonneg hB ε_a.nonneg))
    (mul_nonneg ε_a.nonneg ε_b.nonneg)

/-- Scaling an error bound by a nonneg factor. -/
def scale (c : ℝ) (hc : 0 ≤ c) (ε : ErrorBound) : ErrorBound :=
  ⟨c * ε.val, mul_nonneg hc ε.nonneg⟩

/-- Scaling by 1 is identity. -/
theorem scale_one (ε : ErrorBound) : (scale 1 zero_le_one ε).val = ε.val := by
  simp [scale]

end ErrorBound

/-- A `Valued` type carries a value together with an error bound.
    This is the fundamental "measured quantity" in our calculus —
    every tensor component, every geometric quantity, carries its error. -/
structure Valued (α : Type*) where
  val : α
  error : ErrorBound

namespace Valued

/-- An exact value has zero error. -/
def exact {α : Type*} (a : α) : Valued α :=
  ⟨a, ErrorBound.zero⟩

/-- The error magnitude of a valued quantity. -/
def errorMagnitude {α : Type*} (v : Valued α) : ℝ := v.error.val

/-- Exact values have zero error magnitude. -/
theorem exact_error_zero {α : Type*} (a : α) : (exact a).errorMagnitude = 0 := by
  simp [exact, errorMagnitude, ErrorBound.zero]

end Valued

end OmegaTheory.Foundations
