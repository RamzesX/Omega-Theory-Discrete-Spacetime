/-
  OmegaTheory.Spacetime.Operators

  Discrete differential operators on the Planck lattice Λ = l_P · ℤ⁴.
  Ported from V1 (0 sorry). All proofs use field_simp + ring.

  These are the "exact" operators — no error tracking yet.
  Error-propagating versions are built on top in Tensor.Operations.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Spacetime

/-! ## Planck length utility lemmas -/

theorem l_P_sq_pos : l_P ^ 2 > 0 := sq_pos_of_pos l_P_pos
theorem l_P_sq_ne_zero : l_P ^ 2 ≠ 0 := ne_of_gt l_P_sq_pos
theorem two_l_P_ne_zero : 2 * l_P ≠ 0 := mul_ne_zero two_ne_zero l_P_ne_zero

/-! ## Scalar field algebra -/

@[simp] theorem scalarField_add_apply (f g : ScalarField) (p : LatticePoint) :
    (f + g) p = f p + g p := rfl

@[simp] theorem scalarField_smul_apply (k : ℝ) (f : ScalarField) (p : LatticePoint) :
    (k • f) p = k * f p := rfl

@[simp] theorem scalarField_mul_apply (f g : ScalarField) (p : LatticePoint) :
    (f * g) p = f p * g p := rfl

/-! ## Shift helpers for Fin 4 indices -/

/-- Shift a lattice point forward by one step in direction μ (given as Fin 4). -/
def shiftFin (n : LatticePoint) (μ : Fin 4) : LatticePoint :=
  fun i => n i + if i = μ then 1 else 0

/-- Shift a lattice point backward by one step in direction μ (given as Fin 4). -/
def shiftBackFin (n : LatticePoint) (μ : Fin 4) : LatticePoint :=
  fun i => n i - if i = μ then 1 else 0

theorem shiftFin_shiftBackFin (n : LatticePoint) (μ : Fin 4) :
    shiftBackFin (shiftFin n μ) μ = n := by
  ext i; simp [shiftFin, shiftBackFin]

theorem shiftBackFin_shiftFin (n : LatticePoint) (μ : Fin 4) :
    shiftFin (shiftBackFin n μ) μ = n := by
  ext i; simp [shiftFin, shiftBackFin]

theorem shiftFin_comm (n : LatticePoint) (μ ν : Fin 4) :
    shiftFin (shiftFin n μ) ν = shiftFin (shiftFin n ν) μ := by
  ext i; simp [shiftFin]; ring

theorem shiftBackFin_comm (n : LatticePoint) (μ ν : Fin 4) :
    shiftBackFin (shiftBackFin n μ) ν = shiftBackFin (shiftBackFin n ν) μ := by
  ext i; simp [shiftBackFin]; ring

/-! ## Forward Difference Operator

  Δ⁺_μ f(p) = (f(p + ê_μ) - f(p)) / l_P -/

noncomputable def forwardDiff (f : ScalarField) (μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  (f (shiftFin p μ) - f p) / l_P

theorem forwardDiff_add (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (f + g) μ p = forwardDiff f μ p + forwardDiff g μ p := by
  unfold forwardDiff; simp only [scalarField_add_apply]; field_simp; ring

theorem forwardDiff_smul (k : ℝ) (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (k • f) μ p = k * forwardDiff f μ p := by
  unfold forwardDiff; simp only [scalarField_smul_apply]; field_simp

theorem forwardDiff_const (k : ℝ) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (fun _ => k) μ p = 0 := by
  unfold forwardDiff; simp

/-! ## Backward Difference Operator

  Δ⁻_μ f(p) = (f(p) - f(p - ê_μ)) / l_P -/

noncomputable def backwardDiff (f : ScalarField) (μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  (f p - f (shiftBackFin p μ)) / l_P

theorem backwardDiff_add (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    backwardDiff (f + g) μ p = backwardDiff f μ p + backwardDiff g μ p := by
  unfold backwardDiff; simp only [scalarField_add_apply]; field_simp; ring

theorem backwardDiff_smul (k : ℝ) (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    backwardDiff (k • f) μ p = k * backwardDiff f μ p := by
  unfold backwardDiff; simp only [scalarField_smul_apply]; field_simp

theorem backwardDiff_const (k : ℝ) (μ : Fin 4) (p : LatticePoint) :
    backwardDiff (fun _ => k) μ p = 0 := by
  unfold backwardDiff; simp

/-! ## Symmetric (Central) Difference Operator

  δ_μ f(p) = (f(p + ê_μ) - f(p - ê_μ)) / (2 l_P) -/

noncomputable def symmetricDiff (f : ScalarField) (μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  (f (shiftFin p μ) - f (shiftBackFin p μ)) / (2 * l_P)

theorem symmetricDiff_add (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    symmetricDiff (f + g) μ p = symmetricDiff f μ p + symmetricDiff g μ p := by
  unfold symmetricDiff; simp only [scalarField_add_apply]; field_simp; ring

theorem symmetricDiff_smul (k : ℝ) (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    symmetricDiff (k • f) μ p = k * symmetricDiff f μ p := by
  unfold symmetricDiff; simp only [scalarField_smul_apply]; field_simp

theorem symmetricDiff_const (k : ℝ) (μ : Fin 4) (p : LatticePoint) :
    symmetricDiff (fun _ => k) μ p = 0 := by
  unfold symmetricDiff; simp

theorem symmetricDiff_eq_average (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    symmetricDiff f μ p = (forwardDiff f μ p + backwardDiff f μ p) / 2 := by
  unfold symmetricDiff forwardDiff backwardDiff
  have h : l_P ≠ 0 := l_P_ne_zero
  have h2 : (2 : ℝ) ≠ 0 := two_ne_zero
  have step1 : (f (shiftFin p μ) - f p) / l_P + (f p - f (shiftBackFin p μ)) / l_P =
               (f (shiftFin p μ) - f (shiftBackFin p μ)) / l_P := by
    rw [← add_div]; congr 1; ring
  rw [step1, div_div]; congr 1; ring

/-! ## Second Derivative

  ∂²_μ f(p) = (f(p+) - 2f(p) + f(p-)) / l_P² -/

noncomputable def secondDeriv (f : ScalarField) (μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  (f (shiftFin p μ) - 2 * f p + f (shiftBackFin p μ)) / (l_P ^ 2)

theorem secondDeriv_add (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    secondDeriv (f + g) μ p = secondDeriv f μ p + secondDeriv g μ p := by
  unfold secondDeriv; simp only [scalarField_add_apply]; field_simp; ring

theorem secondDeriv_smul (k : ℝ) (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    secondDeriv (k • f) μ p = k * secondDeriv f μ p := by
  unfold secondDeriv; simp only [scalarField_smul_apply]; field_simp

theorem secondDeriv_const (k : ℝ) (μ : Fin 4) (p : LatticePoint) :
    secondDeriv (fun _ => k) μ p = 0 := by
  unfold secondDeriv
  have : k - 2 * k + k = 0 := by ring
  rw [this, zero_div]

theorem secondDeriv_eq_forward_backward (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    secondDeriv f μ p = forwardDiff (fun q => backwardDiff f μ q) μ p := by
  unfold secondDeriv forwardDiff backwardDiff
  simp only [shiftFin_shiftBackFin, shiftBackFin_shiftFin]
  field_simp; ring

/-! ## Discrete Laplacian

  Δf(p) = Σ_μ ∂²_μ f(p) -/

noncomputable def discreteLaplacian (f : ScalarField) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 => secondDeriv f μ p

theorem discreteLaplacian_add (f g : ScalarField) (p : LatticePoint) :
    discreteLaplacian (f + g) p = discreteLaplacian f p + discreteLaplacian g p := by
  simp only [discreteLaplacian, secondDeriv_add, ← Finset.sum_add_distrib]

theorem discreteLaplacian_smul (k : ℝ) (f : ScalarField) (p : LatticePoint) :
    discreteLaplacian (k • f) p = k * discreteLaplacian f p := by
  simp only [discreteLaplacian, secondDeriv_smul, ← Finset.mul_sum]

theorem discreteLaplacian_const (k : ℝ) (p : LatticePoint) :
    discreteLaplacian (fun _ => k) p = 0 := by
  simp only [discreteLaplacian, secondDeriv_const, Finset.sum_const_zero]

/-! ## Discrete Gradient and Divergence -/

noncomputable def discreteGradient (f : ScalarField) (p : LatticePoint) (μ : Fin 4) : ℝ :=
  symmetricDiff f μ p

noncomputable def discreteDivergence (v : LatticePoint → Fin 4 → ℝ)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 => backwardDiff (fun q => v q μ) μ p

/-! ## Mixed Shift Commutativity -/

theorem shiftFin_shiftBackFin_comm (n : LatticePoint) (μ ν : Fin 4) :
    shiftFin (shiftBackFin n μ) ν = shiftBackFin (shiftFin n ν) μ := by
  ext i; simp [shiftFin, shiftBackFin]; ring

theorem shiftBackFin_shiftFin_comm (n : LatticePoint) (μ ν : Fin 4) :
    shiftBackFin (shiftFin n μ) ν = shiftFin (shiftBackFin n ν) μ := by
  ext i; simp [shiftFin, shiftBackFin]; ring

/-! ## Operator Commutativity -/

theorem forwardDiff_comm (f : ScalarField) (μ ν : Fin 4) (p : LatticePoint) :
    forwardDiff (fun q => forwardDiff f ν q) μ p =
    forwardDiff (fun q => forwardDiff f μ q) ν p := by
  unfold forwardDiff
  have hcomm := shiftFin_comm p μ ν
  field_simp
  rw [hcomm]
  ring

theorem backwardDiff_comm (f : ScalarField) (μ ν : Fin 4) (p : LatticePoint) :
    backwardDiff (fun q => backwardDiff f ν q) μ p =
    backwardDiff (fun q => backwardDiff f μ q) ν p := by
  unfold backwardDiff
  have hcomm := shiftBackFin_comm p μ ν
  field_simp
  rw [hcomm]
  ring

/-! ## Symmetric Difference Commutativity -/

theorem symmetricDiff_comm (f : ScalarField) (μ ν : Fin 4) (p : LatticePoint) :
    symmetricDiff (fun q => symmetricDiff f ν q) μ p =
    symmetricDiff (fun q => symmetricDiff f μ q) ν p := by
  unfold symmetricDiff
  have hcomm1 := shiftFin_comm p μ ν
  have hcomm2 := shiftBackFin_comm p μ ν
  have hcomm3 := shiftFin_shiftBackFin_comm p ν μ
  have hcomm4 := shiftBackFin_shiftFin_comm p ν μ
  field_simp
  rw [hcomm1, hcomm2, hcomm3, hcomm4]
  ring

/-! ## Forward Difference Linearity Supplement -/

theorem forwardDiff_sub (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (f - g) μ p = forwardDiff f μ p - forwardDiff g μ p := by
  unfold forwardDiff; simp only [Pi.sub_apply]; field_simp; ring

theorem forwardDiff_neg (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (-f) μ p = -forwardDiff f μ p := by
  unfold forwardDiff; simp only [Pi.neg_apply]; field_simp; ring

/-! ## Discrete Product Rule (Leibniz) -/

theorem forwardDiff_mul (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (f * g) μ p =
    f p * forwardDiff g μ p + forwardDiff f μ p * g (shiftFin p μ) := by
  unfold forwardDiff; simp only [scalarField_mul_apply]; field_simp; ring

theorem backwardDiff_mul (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    backwardDiff (f * g) μ p =
    f p * backwardDiff g μ p + backwardDiff f μ p * g (shiftBackFin p μ) := by
  unfold backwardDiff; simp only [scalarField_mul_apply]; field_simp; ring

/-! ## Bridge: Forward ↔ Symmetric Difference -/

/-- The forward difference equals the symmetric difference plus an O(l_P) correction:
    Δ⁺f = δf + (l_P/2) · ∂²f.  This is the key bridge between the DEC infrastructure
    (which uses forwardDiff) and the curvature infrastructure (which uses symmetricDiff). -/
theorem forwardDiff_eq_symmetricDiff_add (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff f μ p = symmetricDiff f μ p + (l_P / 2) * secondDeriv f μ p := by
  unfold forwardDiff symmetricDiff secondDeriv
  field_simp [l_P_ne_zero]
  ring

end OmegaTheory.Spacetime
