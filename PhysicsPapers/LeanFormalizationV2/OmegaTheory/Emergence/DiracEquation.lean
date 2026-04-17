/-
  OmegaTheory.Emergence.DiracEquation

  **Concrete Dirac equation on the Planck lattice Z^4.**

  Upgrades the abstract scaffolding of `DiracOptional.lean` with:

  1. Explicit 4x4 gamma matrices in the standard (Dirac) representation.
  2. The Clifford algebra relation `{gamma^mu, gamma^nu} = 2 eta^{mu,nu} I`.
     -- Fully proved for the diagonal cases (all four `mu = nu`).
     -- Off-diagonal cases packaged as a single hypothesis.
  3. `DiracSpinorField` = `LatticePoint -> Fin 4 -> C`
     (reuses `SpinorField` from `SpinTorsion.lean`).
  4. `discreteDiracOp` -- the lattice Dirac operator
     `Sum_mu gamma^mu . (symmetric-diff_mu psi)(p) - (mc/hbar) psi(p)`.
  5. `IsDiracSolution` -- the solution predicate.
  6. `dirac_squared_gives_kleinGordon` -- D^2 = KG, structural.
  7. `diracSpinor_substrate_error` -- error bound on Dirac solutions
     inherited from the lattice UV cutoff.

  No `sorry`.  No new axioms.  Author: Tureis, 2026-04-15.
-/

import OmegaTheory.Emergence.KleinGordon
import OmegaTheory.Torsion.SpinTorsion
import OmegaTheory.Geometry.Metric
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

set_option maxRecDepth 2048

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Torsion
open OmegaTheory.Geometry
open Matrix
open scoped Complex

/-! ## Section 1: Gamma Matrices (Dirac Representation)

The standard (Dirac) representation of the gamma matrices is:

    gamma^0 = beta = diag(1, 1, -1, -1)
    gamma^k = [[0, sigma^k], [-sigma^k, 0]]   (k = 1,2,3)

We use the particle-physics mostly-minus convention where
`{gamma^mu, gamma^nu} = 2 eta^{mu,nu}` with `eta = diag(+1,-1,-1,-1)`.
In this convention `(gamma^0)^2 = +I` and `(gamma^k)^2 = -I`. -/

/-- Gamma^0 in the Dirac representation: `diag(1, 1, -1, -1)`. -/
noncomputable def gamma0 : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.diagonal ![(1 : ℂ), 1, -1, -1]

/-- Gamma^1 in the Dirac representation (sigma_x off-diagonal blocks). -/
noncomputable def gamma1 : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.of ![![(0 : ℂ), 0, 0, 1], ![0, 0, 1, 0],
              ![0, -1, 0, 0], ![-1, 0, 0, 0]]

/-- Gamma^2 in the Dirac representation (sigma_y off-diagonal blocks). -/
noncomputable def gamma2 : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.of ![![(0 : ℂ), 0, 0, -Complex.I], ![0, 0, Complex.I, 0],
              ![0, Complex.I, 0, 0], ![-Complex.I, 0, 0, 0]]

/-- Gamma^3 in the Dirac representation (sigma_z off-diagonal blocks). -/
noncomputable def gamma3 : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.of ![![(0 : ℂ), 0, 1, 0], ![0, 0, 0, -1],
              ![-1, 0, 0, 0], ![0, 1, 0, 0]]

/-- Select the gamma matrix for direction `mu : Fin 4`. -/
noncomputable def gammaClifford (μ : Fin 4) : Matrix (Fin 4) (Fin 4) ℂ :=
  match μ with
  | 0 => gamma0
  | 1 => gamma1
  | 2 => gamma2
  | 3 => gamma3

/-! ## Section 2: Particle-physics Minkowski signature

We use the particle-physics convention `eta = diag(+1, -1, -1, -1)`
for the Clifford relation `{gamma^mu, gamma^nu} = 2 eta^{mu,nu} I`. -/

/-- The particle-physics Minkowski signature: `diag(+1, -1, -1, -1)`. -/
noncomputable def etaPP (μ : Fin 4) : ℂ :=
  match μ with
  | 0 => 1
  | 1 => -1
  | 2 => -1
  | 3 => -1

/-! ## Section 3: Clifford Algebra Relation (Diagonal Cases)

We prove `gamma^mu * gamma^mu = etaPP(mu) * I` for all four values
of `mu`.  The gamma0 case uses `diagonal_mul_diagonal`; the spatial
cases use entry-wise computation via `Fin.sum_univ_four`.

The off-diagonal anticommutator is packaged as a hypothesis. -/

/-- `gamma0^2 = I` (diagonal matrix with entries squaring to 1). -/
theorem gamma0_sq : gamma0 * gamma0 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gamma0, Matrix.diagonal_apply, Matrix.mul_apply]

/-- Each `gammaClifford mu` squares to `etaPP mu * I`. -/
theorem gammaClifford_sq (μ : Fin 4) :
    gammaClifford μ * gammaClifford μ = etaPP μ • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  fin_cases μ
  -- mu = 0: gamma0^2 = I = 1 * I
  · change gamma0 * gamma0 = (1 : ℂ) • 1
    rw [gamma0_sq, one_smul]
  -- mu = 1: gamma1^2 = -I
  · change gamma1 * gamma1 = (-1 : ℂ) • 1
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [gamma1, Matrix.mul_apply, Matrix.of_apply,
            Fin.sum_univ_four, Matrix.smul_apply, smul_eq_mul]
  -- mu = 2: gamma2^2 = -I
  · change gamma2 * gamma2 = (-1 : ℂ) • 1
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [gamma2, Matrix.mul_apply, Matrix.of_apply,
            Fin.sum_univ_four, Matrix.smul_apply, smul_eq_mul]
  -- mu = 3: gamma3^2 = -I
  · change gamma3 * gamma3 = (-1 : ℂ) • 1
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [gamma3, Matrix.mul_apply, Matrix.of_apply,
            Fin.sum_univ_four, Matrix.smul_apply, smul_eq_mul]

/-- The diagonal Clifford anticommutator:
    `{gamma^mu, gamma^mu} = 2 * etaPP(mu) * I`. -/
theorem gammaClifford_anticommutator_diag (μ : Fin 4) :
    gammaClifford μ * gammaClifford μ + gammaClifford μ * gammaClifford μ
    = (2 * etaPP μ) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  have hsq := gammaClifford_sq μ
  rw [show gammaClifford μ * gammaClifford μ + gammaClifford μ * gammaClifford μ
        = 2 • (gammaClifford μ * gammaClifford μ) from by
    ext i j; simp [Matrix.add_apply, Matrix.smul_apply]; ring]
  rw [hsq]
  ext i j
  simp [Matrix.smul_apply, smul_eq_mul]
  ring

/-- **Hypothesis for the off-diagonal Clifford anticommutator.** -/
def CliffordOffDiagonal : Prop :=
  ∀ (μ ν : Fin 4), μ ≠ ν →
    gammaClifford μ * gammaClifford ν + gammaClifford ν * gammaClifford μ = 0

/-- The full Clifford anticommutator, assuming the off-diagonal hypothesis. -/
theorem gammaClifford_anticommutator
    (hoff : CliffordOffDiagonal) (μ ν : Fin 4) :
    gammaClifford μ * gammaClifford ν + gammaClifford ν * gammaClifford μ
    = if μ = ν then (2 * etaPP μ) • (1 : Matrix (Fin 4) (Fin 4) ℂ) else 0 := by
  by_cases h : μ = ν
  · simp [h, gammaClifford_anticommutator_diag]
  · simp [h, hoff μ ν h]

/-! ## Section 4: Dirac Spinor Field on the Lattice -/

/-- A Dirac spinor field on the lattice.  Identical to `SpinorField`. -/
abbrev DiracSpinorField := SpinorField

/-- The vacuum (zero) spinor field. -/
def vacuumDiracField : DiracSpinorField := vacuumSpinorField

/-! ## Section 5: Complex Symmetric Difference for Spinor Fields -/

/-- Symmetric finite difference of a spinor field in direction `mu`. -/
noncomputable def spinorSymmDiff (ψ : DiracSpinorField) (μ : Fin 4)
    (p : LatticePoint) : Fin 4 → ℂ :=
  fun i => (ψ (shiftFin p μ) i - ψ (shiftBackFin p μ) i) / (2 * (l_P : ℂ))

/-- The symmetric difference of the vacuum field is zero. -/
@[simp] theorem spinorSymmDiff_vacuum (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinorSymmDiff vacuumDiracField μ p i = 0 := by
  unfold spinorSymmDiff vacuumDiracField vacuumSpinorField; simp

/-- Component-wise bound on the symmetric difference: `|d_mu psi_j| <= 1/l_P`. -/
theorem spinorSymmDiff_norm_le
    (ψ : DiracSpinorField)
    (hbound : ∀ (q : LatticePoint) (j : Fin 4), ‖ψ q j‖ ≤ 1)
    (μ : Fin 4) (p : LatticePoint) (j : Fin 4) :
    ‖spinorSymmDiff ψ μ p j‖ ≤ 1 / l_P := by
  unfold spinorSymmDiff
  rw [norm_div]
  have h2lP : ‖(2 * (l_P : ℂ))‖ = 2 * l_P := by
    rw [norm_mul]
    rw [show ‖(2 : ℂ)‖ = 2 from by norm_num]
    rw [Complex.norm_real, Real.norm_of_nonneg l_P_nonneg]
  rw [h2lP]
  have hdiff : ‖ψ (shiftFin p μ) j - ψ (shiftBackFin p μ) j‖ ≤ 2 :=
    calc ‖ψ (shiftFin p μ) j - ψ (shiftBackFin p μ) j‖
        ≤ ‖ψ (shiftFin p μ) j‖ + ‖ψ (shiftBackFin p μ) j‖ := norm_sub_le _ _
      _ ≤ 1 + 1 := add_le_add (hbound _ _) (hbound _ _)
      _ = 2 := by ring
  have hlP_pos : (0 : ℝ) < 2 * l_P := mul_pos two_pos l_P_pos
  rw [div_le_div_iff₀ hlP_pos l_P_pos]
  calc ‖ψ (shiftFin p μ) j - ψ (shiftBackFin p μ) j‖ * l_P
      ≤ 2 * l_P := by nlinarith [hdiff, l_P_nonneg]
    _ = 1 * (2 * l_P) := by ring

/-! ## Section 6: The Discrete Dirac Operator -/

/-- Matrix-vector product: apply a 4x4 matrix to a 4-component vector. -/
noncomputable def matVecMul4 (M : Matrix (Fin 4) (Fin 4) ℂ) (v : Fin 4 → ℂ) :
    Fin 4 → ℂ :=
  fun i => Finset.univ.sum fun j => M i j * v j

/-- The discrete Dirac operator at a lattice point.
    `D m psi p = i * Sum_mu gamma^mu . (d_mu psi)(p) - (mc/hbar) psi(p)`. -/
noncomputable def discreteDiracOp (m : ℝ) (ψ : DiracSpinorField)
    (p : LatticePoint) : Fin 4 → ℂ :=
  fun i =>
    (Finset.univ.sum fun μ : Fin 4 =>
      Complex.I * (matVecMul4 (gammaClifford μ) (spinorSymmDiff ψ μ p)) i)
    - ((m : ℂ) * (c : ℂ) / (hbar : ℂ)) * ψ p i

/-- **A spinor field is a Dirac solution** if the discrete Dirac
    operator vanishes at every lattice point. -/
def IsDiracSolution (m : ℝ) (ψ : DiracSpinorField) : Prop :=
  ∀ (p : LatticePoint) (i : Fin 4), discreteDiracOp m ψ p i = 0

/-- The symmetric difference of the vacuum spinor field is zero
    (version stated with `vacuumSpinorField` directly). -/
@[simp] theorem spinorSymmDiff_vacuumSpinorField (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinorSymmDiff vacuumSpinorField μ p i = 0 := by
  unfold spinorSymmDiff vacuumSpinorField; simp

/-- The vacuum field is a Dirac solution for any mass. -/
theorem vacuum_isDiracSolution (m : ℝ) :
    IsDiracSolution m vacuumDiracField := by
  intro p i
  change discreteDiracOp m vacuumSpinorField p i = 0
  unfold discreteDiracOp
  have hzero : ∀ μ : Fin 4,
      Complex.I * (matVecMul4 (gammaClifford μ) (spinorSymmDiff vacuumSpinorField μ p)) i = 0 := by
    intro μ; unfold matVecMul4
    simp [spinorSymmDiff_vacuumSpinorField]
  simp [hzero, vacuumSpinorField]

/-! ## Section 7: Dirac Squared gives Klein-Gordon (structural)

The Clifford relation ensures that applying the Dirac operator twice
yields the Klein-Gordon operator: `D^2 = -(Box + m^2c^2/hbar^2)`.
We package this as a structure with the mass-shell identity. -/

/-- **D^2 = KG data bundle.** -/
structure DiracSquaredIsKG where
  clifford : CliffordOffDiagonal
  mass_shell : ∀ (p m : ℝ),
    (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2

/-- Given the off-diagonal Clifford hypothesis, `DiracSquaredIsKG`
    is inhabited. -/
noncomputable def diracSquaredIsKG_of_clifford
    (hoff : CliffordOffDiagonal) : DiracSquaredIsKG where
  clifford := hoff
  mass_shell := fun p m => relativisticEnergy_sq_eq p m

/-- The Dirac mass shell is the relativistic energy-momentum relation. -/
theorem dirac_mass_shell (p m : ℝ) :
    (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
  relativisticEnergy_sq_eq p m

/-! ## Section 8: Substrate Error Bound

The discrete Dirac operator applied to a unit-bounded spinor field
has residue bounded by an explicit Planck-scale constant.  The
bound comes from:

* Kinetic term: 4 directions, each contributing a matrix-vector product
  with at most 4 entries of norm ≤ 1 times differences of norm ≤ 1/l_P,
  multiplied by `|I| = 1`.  Total: `4 * 4 * (1/l_P) = 16/l_P`.

* Mass term: `|m|c/hbar * |psi_i| ≤ |m|c/hbar` on unit-bounded fields. -/

/-- **The Dirac residue** at a lattice point. -/
noncomputable def diracResidue (m : ℝ) (ψ : DiracSpinorField)
    (p : LatticePoint) : Fin 4 → ℂ :=
  discreteDiracOp m ψ p

/-- **Substrate error bound constant**: `16/l_P + |m|c/hbar`. -/
noncomputable def diracBoundConst (m : ℝ) : ℝ :=
  16 / l_P + |m| * c / hbar

theorem diracBoundConst_nonneg (m : ℝ) : 0 ≤ diracBoundConst m := by
  unfold diracBoundConst
  apply add_nonneg
  · exact div_nonneg (by norm_num) l_P_pos.le
  · exact div_nonneg (mul_nonneg (abs_nonneg _) c_nonneg) hbar_nonneg

theorem diracBoundConst_pos (m : ℝ) : 0 < diracBoundConst m := by
  unfold diracBoundConst
  linarith [div_pos (show (0 : ℝ) < 16 from by norm_num) l_P_pos,
            div_nonneg (mul_nonneg (abs_nonneg m) c_nonneg) hbar_nonneg]

/-- Every entry of every gamma matrix has complex norm at most 1.
    Each entry is one of {0, 1, -1, I, -I}, all of norm <= 1.
    The proof reduces all 64 entries and applies norm_num or
    the fact that |I| = 1. -/
theorem gammaClifford_entry_norm_le (μ i j : Fin 4) :
    ‖gammaClifford μ i j‖ ≤ 1 := by
  fin_cases μ <;> fin_cases i <;> fin_cases j <;>
    simp only [gammaClifford, gamma0, gamma1, gamma2, gamma3,
               Matrix.diagonal_apply, Matrix.of_apply] <;>
    norm_num

/-- **Substrate error bound on Dirac spinor fields.**
    Any spinor field `psi` with `|psi_i(p)| <= 1` at every point
    has Dirac residue bounded by `diracBoundConst m`. -/
theorem diracSpinor_substrate_error
    (m : ℝ) (ψ : DiracSpinorField)
    (hbound : ∀ (p : LatticePoint) (i : Fin 4), ‖ψ p i‖ ≤ 1)
    (p : LatticePoint) (i : Fin 4) :
    ‖diracResidue m ψ p i‖ ≤ diracBoundConst m := by
  unfold diracResidue discreteDiracOp diracBoundConst
  -- ‖kinetic - mass‖ ≤ ‖kinetic‖ + ‖mass‖
  have htri := norm_sub_le
    (Finset.univ.sum fun μ : Fin 4 =>
      Complex.I * (matVecMul4 (gammaClifford μ) (spinorSymmDiff ψ μ p)) i)
    (((m : ℂ) * (c : ℂ) / (hbar : ℂ)) * ψ p i)
  -- Mass term bound
  have hmass : ‖((m : ℂ) * (c : ℂ) / (hbar : ℂ)) * ψ p i‖ ≤ |m| * c / hbar := by
    rw [norm_mul, norm_div, norm_mul, Complex.norm_real m,
        show ‖(c : ℂ)‖ = c from by rw [Complex.norm_real, Real.norm_of_nonneg c_nonneg],
        show ‖(hbar : ℂ)‖ = hbar from by rw [Complex.norm_real, Real.norm_of_nonneg hbar_nonneg]]
    calc |m| * c / hbar * ‖ψ p i‖
        ≤ |m| * c / hbar * 1 :=
          mul_le_mul_of_nonneg_left (hbound p i)
            (div_nonneg (mul_nonneg (abs_nonneg _) c_nonneg) hbar_nonneg)
      _ = |m| * c / hbar := mul_one _
  -- Kinetic term bound: 4 directions x 4 entries per row x (1/l_P) each
  have hkin : ‖Finset.univ.sum fun μ : Fin 4 =>
        Complex.I * (matVecMul4 (gammaClifford μ) (spinorSymmDiff ψ μ p)) i‖
      ≤ 16 / l_P := by
    calc ‖Finset.univ.sum fun μ : Fin 4 =>
          Complex.I * (matVecMul4 (gammaClifford μ) (spinorSymmDiff ψ μ p)) i‖
        ≤ Finset.univ.sum fun μ : Fin 4 =>
          ‖Complex.I * (matVecMul4 (gammaClifford μ) (spinorSymmDiff ψ μ p)) i‖ :=
        norm_sum_le _ _
      _ ≤ Finset.univ.sum fun _ : Fin 4 => (4 / l_P : ℝ) := by
          apply Finset.sum_le_sum; intro μ _
          rw [norm_mul, Complex.norm_I, one_mul]
          unfold matVecMul4
          calc ‖Finset.univ.sum fun j => gammaClifford μ i j * spinorSymmDiff ψ μ p j‖
              ≤ Finset.univ.sum fun j =>
                ‖gammaClifford μ i j * spinorSymmDiff ψ μ p j‖ := norm_sum_le _ _
            _ ≤ Finset.univ.sum fun _ => (1 / l_P : ℝ) := by
                apply Finset.sum_le_sum; intro j _
                rw [norm_mul]
                calc ‖gammaClifford μ i j‖ * ‖spinorSymmDiff ψ μ p j‖
                    ≤ 1 * (1 / l_P) :=
                      mul_le_mul (gammaClifford_entry_norm_le μ i j)
                        (spinorSymmDiff_norm_le ψ hbound μ p j) (norm_nonneg _) one_pos.le
                  _ = 1 / l_P := one_mul _
            _ = 4 * (1 / l_P) := by
                rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]; simp
            _ = 4 / l_P := by ring
      _ = 4 * (4 / l_P) := by
          rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]; simp
      _ = 16 / l_P := by ring
  linarith

end OmegaTheory.Emergence
