/-
  OmegaTheory.Conservation.StressEnergy

  Information stress-energy tensor T^(I)_μν.

  In the Omega Theory, the source of Einstein's equations is not
  classical matter but INFORMATION. The stress-energy tensor arises
  from the variation of the information functional with respect to
  the metric: T^(I)_μν = -2 δI/δg^{μν} + g_μν L_I.
-/

import OmegaTheory.Conservation.Information
import OmegaTheory.Geometry.Curvature
import OmegaTheory.Geometry.CurvatureSymmetries

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Information Stress-Energy Tensor -/

/-- The information stress-energy tensor T^(I)_μν.
    This is the source term in the emergent Einstein equations.
    Defined as a (0,2) tensor field. -/
abbrev InformationStressEnergy := LatticePoint → Fin 4 → Fin 4 → ℝ

/-- Structure bundling an information field with its stress-energy tensor
    and the physical relationship between them. -/
structure InformationSource where
  /-- The metric. -/
  g : DiscreteMetric
  /-- Information density. -/
  I : InformationDensity
  /-- Information current. -/
  J : InformationCurrent
  /-- The stress-energy tensor derived from I. -/
  T : InformationStressEnergy
  /-- Mean information density (equilibrium value). -/
  I_bar : ℝ
  /-- The current is conserved (Fourth Noether Law). -/
  conserved : IsConserved J
  /-- Stress-energy is symmetric. -/
  symmetric : ∀ p μ ν, T p μ ν = T p ν μ

/-! ## Stress-Energy Properties -/

/-- The trace of the information stress-energy tensor:
    T = g^{μν} T_μν. -/
noncomputable def stressEnergyTrace (g : DiscreteMetric)
    (T : InformationStressEnergy) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ =>
    Finset.univ.sum fun ν =>
      (inverseMetric (g p)) μ ν * T p μ ν

/-- Vacuum information: T = 0 when information is uniform (no gradients). -/
def vacuumInformation : InformationStressEnergy := fun _ _ _ => 0

/-- Vacuum stress-energy is symmetric. -/
theorem vacuumInformation_symmetric : ∀ p μ ν,
    vacuumInformation p μ ν = vacuumInformation p ν μ :=
  fun _ _ _ => rfl

/-- Vacuum stress-energy trace is zero. -/
theorem vacuumTrace_zero (g : DiscreteMetric) (p : LatticePoint) :
    stressEnergyTrace g vacuumInformation p = 0 := by
  unfold stressEnergyTrace vacuumInformation
  simp

/-! ## Einstein Coupling -/

/-- Einstein coupling constant: κ = 8πG/c⁴. -/
noncomputable def einsteinCoupling : ℝ :=
  8 * Real.pi * G_N / c ^ 4

/-- Einstein coupling is positive. -/
theorem einsteinCoupling_pos : 0 < einsteinCoupling := by
  unfold einsteinCoupling
  apply div_pos
  · apply mul_pos
    apply mul_pos
    · positivity
    · exact Real.pi_pos
    · exact G_N_pos
  · exact pow_pos c_pos 4

/-! ## Emergent Einstein Equations -/

/-- The emergent Einstein equations: G_μν = κ T^(I)_μν.
    This is what we want to PROVE emerges from the healing flow. -/
def SatisfiesEmergentEinstein (g : DiscreteMetric)
    (T : InformationStressEnergy) : Prop :=
  ∀ p μ ν,
    einsteinTensor g μ ν p = einsteinCoupling * T p μ ν

/-- Approximate emergent Einstein equations with O(l_P) corrections. -/
def SatisfiesEmergentEinsteinApprox (g : DiscreteMetric)
    (T : InformationStressEnergy) : Prop :=
  ∀ p μ ν,
    |einsteinTensor g μ ν p - einsteinCoupling * T p μ ν| ≤ l_P

/-- Flat metric with vacuum information satisfies emergent Einstein exactly. -/
theorem flat_vacuum_einstein :
    SatisfiesEmergentEinstein DiscreteMetric.flat vacuumInformation := by
  intro p μ ν
  unfold einsteinTensor vacuumInformation einsteinCoupling
  simp [ricci_flat, scalar_flat]

/-! ## Approximate Conservation

In classical GR, the contracted Bianchi identity gives nabla^mu G_munu = 0
exactly, implying exact stress-energy conservation. On the discrete lattice,
the Bianchi identity holds only approximately: |nabla^mu G_munu| <= C * l_P
(Planck-scale residual). This motivates `ApproxConservedTensorField`: a
(0,2) tensor field with bounded covariant divergence.

The `ConservedCurrent` type from `NoetherMetaStructure.lean` requires EXACT
conservation (discrete divergence = 0). The approximate version below is the
natural generalization for tensor fields on a lattice with defects. -/

/-- A (0,2) tensor field on the lattice. -/
abbrev TensorField02 := LatticePoint → Fin 4 → Fin 4 → ℝ

/-- The covariant divergence of the Einstein tensor, expressed directly
    in terms of `covariantDeriv02`. Definitionally equal to `einsteinDivergence`
    from CurvatureSymmetries; stated as a refl lemma for rewriting. -/
theorem einsteinDiv_eq_covariantDiv (g : DiscreteMetric) (ν : Fin 4)
    (p : LatticePoint) :
    einsteinDivergence g ν p =
    Finset.univ.sum fun α =>
      Finset.univ.sum fun μ =>
        (inverseMetric (g p)) α μ *
        covariantDeriv02 g (fun q μ' ν' => einsteinTensor g μ' ν' q) α μ ν p := by
  rfl

/-- An approximately conserved (0,2) tensor field: its covariant divergence
    is bounded by `C_bound * l_P` at every point and for every free index.

    On the discrete lattice with defects, exact tensor conservation is
    replaced by Planck-scale-bounded deviation. The covariant divergence
    is computed as `g^{alpha mu} nabla_alpha T_{mu nu}` with respect to
    the full Christoffel connection of `g`.

    Note: we do NOT require symmetry T_{mu nu} = T_{nu mu}. On a
    `BoundedSymmetryMetric`, pair swap is only approximate, so the discrete
    Ricci tensor (and hence the Einstein tensor) is not exactly symmetric.
    Requiring symmetry would demand additional structure not available on
    these metrics. The divergence bound is the physically essential property. -/
structure ApproxConservedTensorField where
  /-- The metric with respect to which the covariant divergence is computed. -/
  g : DiscreteMetric
  /-- The (0,2) tensor field. -/
  T : TensorField02
  /-- The bound constant. -/
  C_bound : ℝ
  /-- The bound constant is positive. -/
  C_bound_pos : 0 < C_bound
  /-- Approximate conservation: |nabla^mu T_{mu nu}(p)| <= C * l_P. -/
  div_bounded : ∀ ν p,
    |Finset.univ.sum fun α =>
      Finset.univ.sum fun μ =>
        (inverseMetric (g p)) α μ *
        covariantDeriv02 g T α μ ν p| ≤ C_bound * l_P

end OmegaTheory.Conservation

/-! ## Einstein Tensor as an Approximate Conserved Tensor Field

On a `BianchiMetric`, the Einstein tensor has bounded covariant divergence
by assumption (the contracted Bianchi identity, Appendix D Lemma 2.2).
We construct the `ApproxConservedTensorField` instance directly.

These definitions live in `OmegaTheory.Geometry.BianchiMetric` so that
dot notation on `bm : BianchiMetric` resolves correctly. -/

namespace OmegaTheory.Geometry.BianchiMetric

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation

/-- On a `BianchiMetric`, the Einstein tensor is an `ApproxConservedTensorField`.
    The bound `C_bianchi * l_P` comes directly from the contracted Bianchi
    identity: |nabla^mu G_{mu nu}| <= C_bianchi * l_P. -/
noncomputable def einsteinApproxConserved
    (bm : BianchiMetric) : ApproxConservedTensorField where
  g := bm.g
  T := fun q μ' ν' => einsteinTensor bm.g μ' ν' q
  C_bound := bm.C_bianchi
  C_bound_pos := bm.C_bianchi_pos
  div_bounded := by
    intro ν p
    rw [← einsteinDiv_eq_covariantDiv]
    exact bm.contracted_bianchi_assumption ν p

/-- The divergence bound constant equals the Bianchi constant. -/
theorem einsteinApproxConserved_bound (bm : BianchiMetric) :
    bm.einsteinApproxConserved.C_bound = bm.C_bianchi := rfl

/-- At zero defect (epsilon = 0), the Einstein tensor still forms an
    `ApproxConservedTensorField` with the same Planck-scale bound.
    Even in vacuum, discrete gravity carries a Planck-scale residual. -/
theorem einsteinApproxConserved_zero_defect
    (bm : BianchiMetric) (hε : bm.epsilon = 0) (ν : Fin 4)
    (p : LatticePoint) :
    |Finset.univ.sum fun α =>
      Finset.univ.sum fun μ =>
        (inverseMetric (bm.g p)) α μ *
        covariantDeriv02 bm.g
          (fun q μ' ν' => einsteinTensor bm.g μ' ν' q) α μ ν p| ≤
    bm.C_bianchi * l_P := by
  rw [← einsteinDiv_eq_covariantDiv]
  exact bm.contracted_bianchi_zero_defect hε ν p

/-- The divergence bound is nonneg: C_bianchi * l_P >= 0. -/
theorem einsteinApproxConserved_bound_nonneg (bm : BianchiMetric) :
    0 ≤ bm.einsteinApproxConserved.C_bound * l_P :=
  le_of_lt (mul_pos bm.einsteinApproxConserved.C_bound_pos l_P_pos)

end OmegaTheory.Geometry.BianchiMetric
