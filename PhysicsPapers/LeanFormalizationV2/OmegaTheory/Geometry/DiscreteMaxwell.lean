/-
  OmegaTheory.Geometry.DiscreteMaxwell

  Discrete Maxwell equations on the Planck lattice via the DEC.
  The electromagnetic field strength F is a closed antisymmetric 2-form.
  The source current J = delta_1(F) is automatically conserved by delta^2=0.

  This creates a new ConservedCurrent instance: the Maxwell current,
  joining the harmonic gradient current and U(1) link current as the
  third concrete instance of the fourth Noether law.

  Key results:
  1. `codiff0_eq_discreteDivergence` — bridge between Hodge codifferential and
     the existing discrete divergence from Operators.lean
  2. `maxwell_charge_conservation` — discrete Gauss's law: div(J) = 0
  3. `maxwellConservedCurrent` — new ConservedCurrent from any antisymmetric 2-form

  Agent: Lyra (April 13, 2026)
-/

import OmegaTheory.Geometry.HodgeStar
import OmegaTheory.Conservation.NoetherMetaStructure
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime OmegaTheory.Conservation

/-! ## Bridge: Hodge Codifferential = Discrete Divergence

  The codifferential `codiff0` (from HodgeStar.lean) and the discrete
  divergence `discreteDivergence` (from Operators.lean) compute the
  same quantity: Σ_μ Δ⁻_μ(ω(·,μ))(p). They are definitionally equal. -/

/-- The Hodge codifferential on 1-forms equals the discrete divergence.
    This bridges the de Rham theory to the conservation law machinery. -/
theorem codiff0_eq_discreteDivergence (ω : Discrete1Form) (p : LatticePoint) :
    codiff0 ω p = discreteDivergence ω p := by
  rfl

/-- The Hodge codifferential on 1-forms equals the information divergence.
    Direct bridge to `IsConserved`. -/
theorem codiff0_eq_informationDivergence (ω : Discrete1Form) (p : LatticePoint) :
    codiff0 ω p = informationDivergence ω p := by
  rfl

/-- A 1-form is co-closed (codiff0 = 0) iff it is conserved in the information sense. -/
theorem isCoClosed1_iff_isConserved (ω : Discrete1Form) :
    IsCoClosed1 ω ↔ IsConserved ω := by
  constructor
  · intro h p; rw [← codiff0_eq_informationDivergence]; exact h p
  · intro h p; rw [codiff0_eq_informationDivergence]; exact h p

/-! ## Discrete Maxwell Equations

  For a 2-form F (the field strength / curvature of a U(1) connection):
  - Homogeneous equations: dF = 0 (Bianchi identity, automatic if F = dA)
  - Inhomogeneous equations: delta(F) = J (defines the source current)
  - Conservation: div(J) = delta(J) = delta(delta(F)) = 0 (by delta^2=0) -/

/-- The Maxwell source current: J = delta_1(F) (codifferential of field strength). -/
noncomputable def maxwellCurrent (F : Discrete2Form) : Discrete1Form :=
  codiff1 F

/-- Discrete charge conservation (Gauss's law):
    The divergence of the Maxwell current vanishes for any antisymmetric 2-form.
    This is the physical content of delta^2 = 0. -/
theorem maxwell_charge_conservation (F : Discrete2Form) (hanti : IsAntisymmetric2 F)
    (p : LatticePoint) :
    codiff0 (maxwellCurrent F) p = 0 :=
  codiff0_comp_codiff1 F hanti p

/-- The Maxwell current is conserved in the information-theoretic sense. -/
theorem maxwell_current_isConserved (F : Discrete2Form) (hanti : IsAntisymmetric2 F) :
    IsConserved (maxwellCurrent F) := by
  intro p
  rw [← codiff0_eq_informationDivergence]
  exact maxwell_charge_conservation F hanti p

/-- A new ConservedCurrent instance: the Maxwell current from any antisymmetric 2-form.
    This is the third concrete instance of the fourth Noether law, after
    the harmonic gradient current and the U(1) link current. -/
noncomputable def maxwellConservedCurrent (F : Discrete2Form) (hanti : IsAntisymmetric2 F) :
    ConservedCurrent where
  current := maxwellCurrent F
  conserved := maxwell_current_isConserved F hanti

/-- For an exact field strength F = dA (from a gauge potential A),
    the homogeneous Maxwell equation dF = 0 holds automatically by d^2=0. -/
theorem maxwell_homogeneous (A : Discrete1Form) (p : LatticePoint) (μ ν α : Fin 4) :
    d2 (d1 A) p μ ν α = 0 :=
  d2_comp_d1 A p μ ν α

/-- An exact antisymmetric field strength dA gives a ConservedCurrent
    with BOTH Maxwell equations satisfied: dF = 0 and div(delta F) = 0. -/
noncomputable def exactMaxwellConservedCurrent (A : Discrete1Form)
    (hanti : IsAntisymmetric2 (d1 A)) : ConservedCurrent :=
  maxwellConservedCurrent (d1 A) hanti

/-- d1 always produces antisymmetric 2-forms, so any gauge potential
    gives a valid Maxwell field strength. -/
theorem maxwellFromPotential (A : Discrete1Form) :
    IsAntisymmetric2 (d1 A) :=
  d1_antisymmetric A

/-- Every gauge potential gives a conserved Maxwell current. No conditions needed. -/
noncomputable def maxwellFromAny (A : Discrete1Form) : ConservedCurrent :=
  maxwellConservedCurrent (d1 A) (maxwellFromPotential A)

/-! ## Gauge Invariance

  Under a gauge transformation A → A + d₀(χ), the field strength F = d₁A
  is unchanged (because d²=0), and hence the Maxwell current and the
  ConservedCurrent are gauge-invariant. -/

/-- Gauge invariance of the field strength:
    d₁(A + d₀χ) = d₁(A). The exact part d₀χ is killed by d²=0. -/
theorem gauge_invariance (A : Discrete1Form) (χ : Discrete0Form)
    (p : LatticePoint) (μ ν : Fin 4) :
    d1 (add1Form A (d0 χ)) p μ ν = d1 A p μ ν := by
  have h := congr_fun (congr_fun (congr_fun (d1_add A (d0 χ)) p) μ) ν
  simp only [add2Form] at h
  rw [h, d1_comp_d0 χ p μ ν, add_zero]

/-- Gauge invariance of the Maxwell current: J(A + dχ) = J(A). -/
theorem gauge_invariance_current (A : Discrete1Form) (χ : Discrete0Form)
    (p : LatticePoint) (ν : Fin 4) :
    maxwellCurrent (d1 (add1Form A (d0 χ))) p ν =
    maxwellCurrent (d1 A) p ν := by
  unfold maxwellCurrent codiff1
  apply Finset.sum_congr rfl; intro μ _
  congr 1; ext q; exact gauge_invariance A χ q μ ν

/-- The ConservedCurrent from a gauge-transformed potential equals the original. -/
theorem gauge_invariance_conserved (A : Discrete1Form) (χ : Discrete0Form) :
    (maxwellFromAny (add1Form A (d0 χ))).current =
    (maxwellFromAny A).current := by
  ext p ν; exact gauge_invariance_current A χ p ν

end OmegaTheory.Geometry
