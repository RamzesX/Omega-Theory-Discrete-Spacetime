/-
  OmegaTheory.Geometry.WedgeProduct

  Wedge product of discrete forms and gl(4,R)-valued form algebra.
  Packages Christoffel symbols as connection 1-forms.

  This bridges the discrete exterior calculus (DiscreteForms.lean) to the
  existing curvature infrastructure (Connection.lean, Curvature.lean).

  The key definition is `connectionForm g : GLValued1Form` which repackages
  the Christoffel symbol Gamma^rho_{mu sigma} as a gl(4,R)-valued 1-form
  omega^rho_sigma(p, mu) = Gamma^rho_{mu sigma}(p). The form index is mu
  (the covariant derivative direction), while rho and sigma are fiber
  (Lie algebra) indices.

  The curvature 2-form Omega = d(omega) + omega wedge omega is defined
  here; the structure equation (Omega = Riemann tensor) and differential
  Bianchi identity are in StructureEquation.lean.
-/

import OmegaTheory.Geometry.DiscreteForms
import OmegaTheory.Geometry.Connection
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime

/-! ## Wedge Product of 1-Forms

  The wedge product of two 1-forms alpha and beta is a 2-form:
    (alpha ∧ beta)(p, mu, nu) = alpha(p, mu) * beta(p, nu) - alpha(p, nu) * beta(p, mu) -/

/-- Wedge product of two discrete 1-forms. -/
noncomputable def wedge11 (α β : Discrete1Form) : Discrete2Form :=
  fun p μ ν => α p μ * β p ν - α p ν * β p μ

/-- The wedge product is automatically antisymmetric. -/
theorem wedge11_antisymmetric (α β : Discrete1Form) :
    IsAntisymmetric2 (wedge11 α β) := by
  intro p μ ν; unfold wedge11; ring

/-- The wedge product is anticommutative: α∧β = -β∧α. -/
theorem wedge11_anticomm (α β : Discrete1Form) (p : LatticePoint)
    (μ ν : Fin 4) :
    wedge11 α β p μ ν = -wedge11 β α p μ ν := by
  unfold wedge11; ring

/-- Wedge of a 1-form with itself is zero: α∧α = 0. -/
theorem wedge11_self (α : Discrete1Form) (p : LatticePoint)
    (μ ν : Fin 4) :
    wedge11 α α p μ ν = 0 := by
  unfold wedge11; ring

/-! ## gl(4,R)-Valued Forms

  Connection forms and curvature forms carry Lie algebra indices
  (ρ, σ) in addition to the spacetime form indices (μ, ν). -/

/-- A gl(4,R)-valued 1-form: fiber indices ρ σ, form index μ. -/
abbrev GLValued1Form := Fin 4 → Fin 4 → Discrete1Form

/-- A gl(4,R)-valued 2-form: fiber indices ρ σ, form indices μ ν. -/
abbrev GLValued2Form := Fin 4 → Fin 4 → Discrete2Form

/-! ## Exterior Derivative on gl-Valued Forms -/

/-- Exterior derivative on gl(4,R)-valued 1-forms:
    (dω)^ρ_σ = d₁(ω^ρ_σ).
    The exterior derivative acts fiberwise. -/
noncomputable def dGL1 (ω : GLValued1Form) : GLValued2Form :=
  fun ρ σ => d1 (ω ρ σ)

/-- dGL1 preserves antisymmetry (since d₁ produces antisymmetric 2-forms). -/
theorem dGL1_antisymmetric (ω : GLValued1Form) (ρ σ : Fin 4) :
    IsAntisymmetric2 (dGL1 ω ρ σ) :=
  d1_antisymmetric (ω ρ σ)

/-! ## Matrix-Valued Wedge Product -/

/-- Wedge product of gl(4,R)-valued 1-forms:
    (ω₁ ∧ ω₂)^ρ_σ(p, μ, ν) = Σ_λ (ω₁^ρ_λ(p,μ) * ω₂^lσ(p,ν) - ω₁^ρ_λ(p,ν) * ω₂^lσ(p,μ))

    This is the "matrix multiplication + wedge product" that captures
    the ω∧ω term in the curvature 2-form. -/
noncomputable def wedgeGL (ω₁ ω₂ : GLValued1Form) : GLValued2Form :=
  fun ρ σ p μ ν =>
    Finset.univ.sum fun l =>
      ω₁ ρ l p μ * ω₂ l σ p ν -
      ω₁ ρ l p ν * ω₂ l σ p μ

/-- The gl-valued wedge product is antisymmetric in the form indices. -/
theorem wedgeGL_antisymmetric (ω₁ ω₂ : GLValued1Form) (ρ σ : Fin 4) :
    IsAntisymmetric2 (wedgeGL ω₁ ω₂ ρ σ) := by
  intro p μ ν; simp only [wedgeGL]
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl; intro l _
  ring

/-! ## Connection 1-Form

  The Levi-Civita connection 1-form packages the Christoffel symbols:
    ω^ρ_σ(p, μ) := Γ^ρ_{μ σ}(p)

  Index convention: the 1-form index is μ (the direction of parallel
  transport / covariant derivative). The fiber indices ρ (upper) and σ
  (lower) label the gl(4,R) matrix entry. -/

/-- The connection 1-form: ω^ρ_σ(p, μ) = Γ^ρ_{μ σ}(p). -/
noncomputable def connectionForm (g : DiscreteMetric) : GLValued1Form :=
  fun ρ σ p μ => christoffelSymbol g ρ μ σ p

/-- The connection form at flat metric vanishes. -/
theorem connectionForm_flat (ρ σ : Fin 4) (p : LatticePoint) (μ : Fin 4) :
    connectionForm DiscreteMetric.flat ρ σ p μ = 0 := by
  unfold connectionForm
  exact christoffel_flat ρ μ σ p

/-- Connection form symmetry in fiber index (from Christoffel symmetry):
    ω^ρ_σ(p, μ) = ω^ρ_μ(p, σ) when the metric is symmetric.
    This is Γ^ρ_{μσ} = Γ^ρ_{σμ} repackaged. -/
theorem connectionForm_fiber_symm (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric)
    (ρ σ : Fin 4) (p : LatticePoint) (μ : Fin 4) :
    connectionForm g ρ σ p μ = connectionForm g ρ μ p σ := by
  unfold connectionForm
  exact christoffel_symmetry g hsym ρ μ σ p

/-! ## Curvature 2-Form

  The curvature 2-form is defined by the Cartan structure equation:
    Ω^ρ_σ = dω^ρ_σ + (ω ∧ ω)^ρ_σ

  This DEFINES the curvature 2-form. The theorem that it equals the
  Riemann tensor is in StructureEquation.lean. -/

/-- The curvature 2-form: Ω = dω + ω∧ω (Cartan structure equation). -/
noncomputable def curvatureForm (g : DiscreteMetric) : GLValued2Form :=
  fun ρ σ p μ ν =>
    dGL1 (connectionForm g) ρ σ p μ ν +
    wedgeGL (connectionForm g) (connectionForm g) ρ σ p μ ν

/-- The curvature form vanishes for flat metric (since ω = 0). -/
theorem curvatureForm_flat (ρ σ : Fin 4) (p : LatticePoint) (μ ν : Fin 4) :
    curvatureForm DiscreteMetric.flat ρ σ p μ ν = 0 := by
  unfold curvatureForm dGL1 d1 wedgeGL connectionForm
  simp [christoffel_flat, forwardDiff_const]

/-- The curvature form is antisymmetric in the form indices. -/
theorem curvatureForm_antisymmetric (g : DiscreteMetric) (ρ σ : Fin 4) :
    IsAntisymmetric2 (curvatureForm g ρ σ) := by
  intro p μ ν
  unfold curvatureForm
  have h1 := dGL1_antisymmetric (connectionForm g) ρ σ p μ ν
  have h2 := wedgeGL_antisymmetric (connectionForm g) (connectionForm g) ρ σ p μ ν
  linarith

/-! ## Wedge Product of 1-form and 2-form

  For the covariant exterior derivative (needed for the Bianchi identity),
  we need the wedge product of a 1-form with a 2-form, producing a 3-form. -/

/-- Wedge product of a gl-valued 1-form with a gl-valued 2-form:
    (ω ∧ Φ)^ρ_σ(p, μ, ν, α) = Σ_λ [
      ω^ρ_λ(p,μ) * Φ^lσ(p,ν,α) - ω^ρ_λ(p,ν) * Φ^lσ(p,μ,α)
      + ω^ρ_λ(p,α) * Φ^lσ(p,μ,ν)
    ] -/
noncomputable def wedgeGL12 (ω : GLValued1Form) (Φ : GLValued2Form) :
    Fin 4 → Fin 4 → Discrete3Form :=
  fun ρ σ p μ ν α =>
    Finset.univ.sum fun l =>
      ω ρ l p μ * Φ l σ p ν α -
      ω ρ l p ν * Φ l σ p μ α +
      ω ρ l p α * Φ l σ p μ ν

/-- Wedge product of a gl-valued 2-form with a gl-valued 1-form:
    (Φ ∧ ω)^ρ_σ(p, μ, ν, α) = Σ_λ [
      Φ^ρ_λ(p,μ,ν) * ω^lσ(p,α) - Φ^ρ_λ(p,μ,α) * ω^lσ(p,ν)
      + Φ^ρ_λ(p,ν,α) * ω^lσ(p,μ)
    ] -/
noncomputable def wedgeGL21 (Φ : GLValued2Form) (ω : GLValued1Form) :
    Fin 4 → Fin 4 → Discrete3Form :=
  fun ρ σ p μ ν α =>
    Finset.univ.sum fun l =>
      Φ ρ l p μ ν * ω l σ p α -
      Φ ρ l p μ α * ω l σ p ν +
      Φ ρ l p ν α * ω l σ p μ

/-! ## Covariant Exterior Derivative -/

/-- The covariant exterior derivative of a gl-valued 2-form:
    D_ω(Φ) = dΦ + ω ∧ Φ - Φ ∧ ω.

    For Φ = Ω (the curvature 2-form), the differential Bianchi identity
    states D_ω(Ω) = 0. -/
noncomputable def covariantExtDeriv (ω : GLValued1Form) (Φ : GLValued2Form) :
    Fin 4 → Fin 4 → Discrete3Form :=
  fun ρ σ p μ ν α =>
    d2 (Φ ρ σ) p μ ν α +
    wedgeGL12 ω Φ ρ σ p μ ν α -
    wedgeGL21 Φ ω ρ σ p μ ν α

-- Note: the theorem that D_omega(Omega) = 0 (differential Bianchi identity)
-- is in StructureEquation.lean, along with the proof that curvatureForm
-- equals the Riemann tensor.

end OmegaTheory.Geometry
