/-
  OmegaTheory.Variational.DiscreteNoether

  Discrete Noether theorem on graphs and the bridge to V2's
  harmonic_gradient_current_conserved.

  KEY RESULT: gauge symmetry (harmonic shift) implies conservation.
  This is a ONE-LINE bridge to the proven Fourth Noether Law.

  V1 had 9 placeholder theorems here. V2 has the REAL proof via
  the gradient flow / Laplacian argument in Conservation/Information.lean.
-/

import OmegaTheory.Variational.GraphAction
import OmegaTheory.Conservation.Information
import OmegaTheory.Spacetime.Operators
import Mathlib.Tactic

namespace OmegaTheory.Variational

open OmegaTheory.Spacetime
open OmegaTheory.Conservation

/-! ## Lattice Symmetries -/

/-- A lattice symmetry: bijective map on lattice points. -/
structure LatticeSymmetry where
  transform : LatticePoint → LatticePoint
  inverse : LatticePoint → LatticePoint
  left_inv : ∀ p, inverse (transform p) = p
  right_inv : ∀ p, transform (inverse p) = p

/-- Identity symmetry. -/
def LatticeSymmetry.id : LatticeSymmetry where
  transform := _root_.id
  inverse := _root_.id
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl

/-- Translation symmetry: shift all points by n in direction μ. -/
def latticeTranslation (μ : Fin 4) (n : ℤ) : LatticeSymmetry where
  transform := fun p i => p i + if i = μ then n else 0
  inverse := fun p i => p i - if i = μ then n else 0
  left_inv := fun p => by ext i; simp
  right_inv := fun p => by ext i; simp

/-- Translations compose additively. -/
theorem translation_compose (μ : Fin 4) (m n : ℤ) (p : LatticePoint) :
    (latticeTranslation μ m).transform ((latticeTranslation μ n).transform p) =
    (latticeTranslation μ (m + n)).transform p := by
  ext i; simp [latticeTranslation]; split_ifs <;> ring

/-- Translations commute. -/
theorem translation_comm (μ ν : Fin 4) (m n : ℤ) (p : LatticePoint) :
    (latticeTranslation μ m).transform ((latticeTranslation ν n).transform p) =
    (latticeTranslation ν n).transform ((latticeTranslation μ m).transform p) := by
  ext i; simp [latticeTranslation]; ring

/-! ## Gauge Transformations -/

/-- A gauge transformation: shift a scalar field by a harmonic function.
    If Λ is harmonic (ΔΛ = 0), then φ → φ + Λ preserves the Lagrangian. -/
structure GaugeTransformation where
  /-- The gauge function. -/
  Lambda : ScalarField
  /-- The gauge function is harmonic. -/
  isHarmonic : IsHarmonic Lambda

/-- The gauge-transformed field. -/
def GaugeTransformation.apply (gauge : GaugeTransformation)
    (φ : ScalarField) : ScalarField :=
  fun p => φ p + gauge.Lambda p

/-! ## THE KEY BRIDGE: Gauge Symmetry → Conservation

V1 had `discrete_noether` as a placeholder (proved True).
V2 has the REAL theorem: harmonic gauge invariance implies
conservation of the gradient current.

This is a direct consequence of harmonic_gradient_current_conserved
from Conservation/Information.lean. -/

/-- Gauge symmetry implies conservation of the associated current.
    This bridges the variational (Noether) perspective to the
    proven conservation law in Conservation/Information.lean.

    ## HONESTY NOTE

    The proof is a ONE-LINE delegation to `harmonic_gradient_current_conserved`.
    This theorem is NOT an independent Noether result — it is the same
    scalar-harmonic identity `div(∇φ) = Δφ = 0` packaged under a different
    name. Readers should not interpret the name as a tensor-valued Noether
    theorem applicable to stress-energy currents; it is the *scalar
    harmonic* Noether instance, which is the only concrete instance V2
    currently proves.

    A genuine tensor-valued Noether theorem (stress-energy conservation
    from diffeomorphism invariance) requires machinery beyond V2's current
    `ConservedCurrent` type, and is listed as future work in the strategic
    plan. -/
theorem gauge_symmetry_implies_conservation (gauge : GaugeTransformation) :
    IsConserved (gradientCurrent gauge.Lambda) :=
  harmonic_gradient_current_conserved gauge.Lambda gauge.isHarmonic

/-! ## Momentum Conservation from Translation Symmetry -/

/-- A field is translation-invariant in direction μ if it's constant along μ. -/
def IsTranslationInvariant (φ : ScalarField) (μ : Fin 4) : Prop :=
  ∀ p, φ (fun i => p i + if i = μ then 1 else 0) = φ p

/-- The canonical momentum in direction μ: p_μ = ∂φ/∂(∂_μφ).
    For the quadratic Lagrangian L = (1/2)|∇φ|², this is ∂_μφ. -/
noncomputable def canonicalMomentum (φ : ScalarField) (μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  forwardDiff φ μ p

/-- The momentum current is the gradient current. -/
theorem momentum_is_gradient (φ : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    canonicalMomentum φ μ p = gradientCurrent φ p μ := by
  simp [canonicalMomentum, gradientCurrent]

/-- For a harmonic field, momentum is conserved (divergence-free).
    This is the scalar-harmonic instance of Noether's theorem:
    translation symmetry → momentum conservation for a harmonic scalar.

    ## HONESTY NOTE

    Like `gauge_symmetry_implies_conservation`, this is a one-line
    delegation to `harmonic_gradient_current_conserved` — the same
    underlying identity renamed for the variational-principle
    audience. It is NOT an independent theorem. Three different names
    (`harmonic_gradient_current_conserved`, `gauge_symmetry_implies_conservation`,
    `momentum_conservation`) export the same Laplacian identity
    `Δφ = 0 → div(∇φ) = 0`. -/
theorem momentum_conservation (φ : ScalarField) (hφ : IsHarmonic φ) :
    IsConserved (gradientCurrent φ) :=
  harmonic_gradient_current_conserved φ hφ

/-! ## Energy from Time Translation

Energy conservation follows from time-translation invariance.
For time-independent Lagrangians, the Hamiltonian (energy) is conserved. -/

/-- The graph Hamiltonian: H = p·∂φ - L = (1/2)|∇φ|² + V(φ).
    For our quadratic Lagrangian, H = Σ_μ (1/2)(∂_μφ)². -/
noncomputable def graphHamiltonian (φ : ScalarField) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    (1 / 2 : ℝ) * (forwardDiff φ μ p) ^ 2

/-- Hamiltonian is nonneg (sum of squares). -/
theorem graphHamiltonian_nonneg (φ : ScalarField) (p : LatticePoint) :
    0 ≤ graphHamiltonian φ p := by
  unfold graphHamiltonian
  apply Finset.sum_nonneg
  intro μ _
  apply mul_nonneg (by norm_num) (sq_nonneg _)

end OmegaTheory.Variational
