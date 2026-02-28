/-
  Axioms.Information
  ===================

  Axioms for information conservation in Omega-Theory.

  This module establishes the Fourth Noether Law:
  information is conserved as a fundamental symmetry of nature,
  on par with energy, momentum, and angular momentum.

  Key concepts:
  - Information density rho_I at each lattice point
  - Information current J^mu_I (4-vector flow)
  - Conservation law: partial_mu J^mu_I = 0
  - Total information is constant in any closed region
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Group.Finset
import DiscreteSpacetime.Basic.Constants
import DiscreteSpacetime.Basic.Lattice
import DiscreteSpacetime.Basic.Operators

namespace DiscreteSpacetime.Axioms

open DiscreteSpacetime.Basic

/-! ## Information Fields -/

/-- Information density field on the lattice.
    rho_I(p) represents the amount of information content at lattice point p.
    Measured in natural units (bits or nats). -/
def InformationDensity := LatticeScalarField

/-- Information current (4-vector) on the lattice.
    J^mu_I(p) represents the flow of information in direction mu at point p.
    The 0-component is the information density, spatial components are flux. -/
def InformationCurrent := LatticeVectorField

/-- The information 4-current at a point.
    J^mu = (rho_I * c, j^1, j^2, j^3) where j^i is spatial flux. -/
structure Information4Current (p : LatticePoint) where
  /-- Time component (information density) -/
  density : ℝ
  /-- Spatial flux components -/
  flux : Fin 3 → ℝ

/-- Convert information 4-current to a vector field value -/
def Information4Current.toVectorField {p : LatticePoint} (J : Information4Current p) :
    SpacetimeIndex → ℝ :=
  fun μ => if μ = timeIndex then J.density else J.flux ⟨μ.val - 1, by
    have hμ := μ.isLt
    simp only [spacetimeDim] at hμ
    omega⟩

/-! ## Information Conservation Axiom (Fourth Noether Law) -/

/-- A physically realizable information current (satisfies conservation).
    Not every vector field is a physical information current —
    only those arising from actual information flow satisfy div J = 0. -/
structure ConservedInformationCurrent where
  /-- The underlying vector field -/
  current : InformationCurrent
  /-- Conservation law holds for this current -/
  conserved : ∀ (p : LatticePoint), discreteDivergence current p = 0

/-- The conservation law for physical information currents.
    Note: This applies only to `ConservedInformationCurrent`, not to arbitrary
    vector fields. The previous version universally quantified over all
    `InformationCurrent` (= LatticeVectorField = LatticePoint → Fin 4 → ℝ),
    which made ALL vector fields divergence-free — a mathematical absurdity.

    The conservation law is now built into the `ConservedInformationCurrent`
    structure as a constraint, which is the standard Lean 4 pattern for
    restricting axioms to physically meaningful subtypes. -/
theorem info_conservation (J : ConservedInformationCurrent) (p : LatticePoint) :
  discreteDivergence J.current p = 0 := J.conserved p

/-- Alternative statement: divergence of information current vanishes everywhere -/
def informationConserved (J : InformationCurrent) : Prop :=
  ∀ p : LatticePoint, discreteDivergence J p = 0

/-! ## Total Information Conservation -/

/-- PHYSICS AXIOM: Total Information Constant

    The total information content of any closed system is constant.
    For a finite lattice region R with no flux through boundary:

    Sum_{p in R} rho_I(p) = constant

    This is the integrated form of the local conservation law.

    This cannot be proven mathematically; it is a physical postulate.

    Falsifiable prediction:
    - Measurement of an isolated system should show constant information
    - Entropy increases, but information is conserved (apparent loss is spreading)
-/
axiom total_info_constant :
  -- Total information is conserved (for closed systems)
  ∀ (rho : InformationDensity) (R : LatticeRegion),
    -- If flux through boundary is zero, total is constant
    True  -- Placeholder: requires boundary flux formalism

/-- Total information in a region (discrete sum) -/
noncomputable def totalInformation (rho : InformationDensity) (points : Finset LatticePoint) : ℝ :=
  points.sum fun p => rho p

/-! ## Information Positivity -/

/-- A physically valid information density field.
    Not every scalar field is a physical information density —
    only non-negative ones represent actual information content. -/
structure PhysicalInformationDensity where
  /-- The underlying scalar field -/
  field : InformationDensity
  /-- Non-negativity constraint -/
  nonneg : ∀ p, field p ≥ 0

/-- Information non-negativity for physical information densities.

    Information density is non-negative everywhere:
    rho_I(p) >= 0 for all lattice points p.

    This reflects that:
    - Information is a positive quantity
    - Negative information has no physical meaning
    - Minimum information is zero (vacuum state)

    Note: The previous version was an `axiom` universally quantified over all
    `InformationDensity` (= LatticeScalarField = LatticePoint → ℝ),
    which claimed ALL functions from lattice points to reals are non-negative.
    That is inconsistent (take f(p) = -1).

    Now this is a theorem that extracts the `.nonneg` field from
    `PhysicalInformationDensity`, restricting the claim to physical fields. -/
theorem info_positive (rho : PhysicalInformationDensity) (p : LatticePoint) :
  rho.field p ≥ 0 := rho.nonneg p

/-! ## Information Bounds -/

/-- PHYSICS AXIOM: Bekenstein Bound (Information Capacity)

    The information content of any region is bounded by its surface area
    in Planck units (holographic principle):

    I <= A / (4 * l_P^2)

    where A is the surface area of the boundary.

    This cannot be proven mathematically; it is a physical postulate.

    Falsifiable prediction:
    - Any system exceeding the Bekenstein bound would collapse to a black hole
    - Black holes saturate the bound (maximum information density)
-/
axiom bekenstein_bound :
  -- Information bounded by surface area
  ∀ (rho : InformationDensity) (R : LatticeRegion),
    -- Total information <= Area / (4 * l_P^2)
    True  -- Placeholder: requires surface area definition

/-- Maximum information density per lattice point (Planck density) -/
noncomputable def maxInformationDensity : ℝ := 1 / (ℓ_P ^ 2)

/-! ## Information Flow -/

/-- Information flux through a surface.
    Represents the rate of information transfer across a boundary. -/
noncomputable def informationFlux (J : InformationCurrent) (p : LatticePoint)
    (μ : SpacetimeIndex) : ℝ :=
  J p μ

/-- Net information flow out of a point (discrete divergence) -/
noncomputable def netInformationFlow (J : InformationCurrent) (p : LatticePoint) : ℝ :=
  discreteDivergence J p

/-- A conserved information current satisfies div J = 0 -/
theorem conserved_current_zero_divergence (J : InformationCurrent)
    (hcons : informationConserved J) (p : LatticePoint) :
    netInformationFlow J p = 0 := hcons p

/-! ## Information Entropy Relation -/

/-- Shannon entropy of an information distribution.
    S = -Sum_p rho(p) * log(rho(p))
    Note: Information is conserved, entropy can increase (information spreads). -/
noncomputable def shannonEntropy (rho : InformationDensity) (points : Finset LatticePoint) : ℝ :=
  -(points.sum fun p => if rho p > 0 then rho p * Real.log (rho p) else 0)

/-- PHYSICS AXIOM: Information-Entropy Distinction

    Information and entropy are distinct concepts:
    - Information I is the total content (conserved)
    - Entropy S measures the spread/accessibility (can increase)

    Second Law: dS/dt >= 0 (entropy increases)
    Fourth Law: dI/dt = 0 (information conserved)

    These are compatible because entropy increase corresponds to
    information spreading/mixing, not information loss.

    This cannot be proven mathematically; it is a physical postulate.

    Falsifiable prediction:
    - Entropy decrease in isolated system would violate Second Law
    - Information change in isolated system would violate Fourth Law
-/
axiom info_entropy_distinction :
  -- Information and entropy evolve independently
  -- I = constant, S = increasing
  True

/-! ## Discrete Continuity Equation -/

/-- The discrete continuity equation for information.
    This is the lattice version of partial_mu J^mu = 0. -/
theorem discrete_continuity (J : InformationCurrent) (p : LatticePoint)
    (hcons : informationConserved J) :
    -- Time derivative of density + spatial divergence = 0
    discreteDivergence J p = 0 := hcons p

/-- Information current from density evolution.
    Given a density field at two times, construct the current that
    satisfies the continuity equation. -/
noncomputable def currentFromDensityEvolution
    (rho_now rho_next : InformationDensity) : InformationCurrent :=
  fun p μ =>
    if μ = timeIndex then
      (rho_now p + rho_next p) / 2  -- Average density
    else
      -- Spatial flux determined by continuity
      0  -- Placeholder: requires solving continuity equation

/-! ## Vacuum Information -/

/-- Vacuum state has zero information density -/
def vacuumInformation : InformationDensity := LatticeScalarField.zero

/-- Vacuum information density is everywhere zero -/
theorem vacuum_info_zero (p : LatticePoint) : vacuumInformation p = 0 := rfl

/-- Vacuum information satisfies positivity -/
theorem vacuum_info_nonneg (p : LatticePoint) : vacuumInformation p ≥ 0 := by
  simp [vacuumInformation, LatticeScalarField.zero]

end DiscreteSpacetime.Axioms
