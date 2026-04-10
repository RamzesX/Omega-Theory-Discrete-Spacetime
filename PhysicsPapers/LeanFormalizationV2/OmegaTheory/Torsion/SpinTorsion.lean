/-
  OmegaTheory.Torsion.SpinTorsion

  Dirac spinors, spin-torsion coupling, and spin statistics.
  Ported from V1 (0 sorry). All coupling constants proven positive.
-/

import OmegaTheory.Torsion.Torsion
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

namespace OmegaTheory.Torsion

open OmegaTheory.Spacetime

/-! ## Dirac Spinor -/

abbrev DiracSpinor := Fin 4 → ℂ
abbrev SpinorField := LatticePoint → DiracSpinor

def vacuumSpinorField : SpinorField := fun _ _ => 0

/-! ## Spin Density -/

noncomputable def spinDensity (ψ : SpinorField) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun i => Complex.normSq (ψ p i)

theorem spinDensity_nonneg (ψ : SpinorField) (p : LatticePoint) :
    0 ≤ spinDensity ψ p := by
  unfold spinDensity
  apply Finset.sum_nonneg; intro i _
  exact Complex.normSq_nonneg _

theorem vacuum_spinDensity_zero (p : LatticePoint) :
    spinDensity vacuumSpinorField p = 0 := by
  simp [spinDensity, vacuumSpinorField, Complex.normSq]

/-! ## Coupling Constants -/

/-- Spin-torsion coupling: κ = l_P²/ℏ. -/
noncomputable def torsionSpinCoupling : ℝ := l_P ^ 2 / hbar

theorem torsionSpinCoupling_pos : 0 < torsionSpinCoupling := by
  unfold torsionSpinCoupling
  exact div_pos (sq_pos_of_pos l_P_pos) hbar_pos

/-- Spin-information coupling: σ_I = ℏ/(2 M_P c). -/
noncomputable def spinInfoCoupling : ℝ := hbar / (2 * M_P * c)

theorem spinInfoCoupling_pos : 0 < spinInfoCoupling := by
  unfold spinInfoCoupling
  exact div_pos hbar_pos (mul_pos (mul_pos two_pos M_P_pos) c_pos)

/-- Torsion-information coupling: β = l_P³/(ℏc). -/
noncomputable def torsionInfoCoupling : ℝ := l_P ^ 3 / (hbar * c)

theorem torsionInfoCoupling_pos : 0 < torsionInfoCoupling := by
  unfold torsionInfoCoupling
  exact div_pos (pow_pos l_P_pos 3) (mul_pos hbar_pos c_pos)

/-! ## Spin Statistics -/

structure SpinStatistics where
  spin : ℚ
  nLoops : ℕ
  isBoson : Bool
  deriving DecidableEq, Repr

def electronSpin : SpinStatistics := ⟨1/2, 1, false⟩
def photonSpin : SpinStatistics := ⟨1, 2, true⟩
def gravitonSpin : SpinStatistics := ⟨2, 4, true⟩

/-! ## Torsion from Spin

The Cartan algebraic equation: S = (l_P²/ℏ) · τ
where τ is the spin tensor. -/

noncomputable def torsionFromSpinDensity (n : ℝ) : ℝ :=
  torsionSpinCoupling * n

theorem torsionFromSpin_nonneg (n : ℝ) (hn : 0 ≤ n) :
    0 ≤ torsionFromSpinDensity n :=
  mul_nonneg (le_of_lt torsionSpinCoupling_pos) hn

end OmegaTheory.Torsion
