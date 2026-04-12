/-
  OmegaTheory.Conservation.InformationKLBridge

  Bridge between the concrete KL divergence information density
  (InformationKL.lean) and the abstract conservation law machinery
  (Information.lean + NoetherMetaStructure.lean).

  The key insight: informationDensityKL g g₀ is a SCALAR FIELD
  (LatticePoint → ℝ), so we can apply the gradient current conservation
  machinery directly. The question is: when is this scalar field harmonic?

  Results:
  1. Flat metric: I_KL(η,η) = 2 everywhere → harmonic → exactly conserved
  2. Self-reference: I_KL(g,g) harmonic iff log|det g| is harmonic
  3. Approximate conservation: conditional on KLEquilibriumData hypothesis

  The flat case gives a concrete new ConservedCurrent instance.
  The self-reference case closes the loop between the concrete KL formula
  and the abstract Noether structure.
-/

import OmegaTheory.Conservation.Information
import OmegaTheory.Conservation.InformationKL
import OmegaTheory.Conservation.NoetherMetaStructure
import Mathlib.Tactic

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## The Divergence-Laplacian Identity

  For ANY scalar field φ, div(grad φ) = Laplacian(φ).
  This is extracted from the proof of `harmonic_gradient_current_conserved`
  in Information.lean, where it was proven inline. -/

/-- The divergence of the gradient current equals the discrete Laplacian.
    div(∇φ) = Σ_μ Δ⁻_μ(Δ⁺_μ φ) = Δφ. -/
theorem divergence_gradientCurrent_eq_laplacian (φ : ScalarField) (p : LatticePoint) :
    informationDivergence (gradientCurrent φ) p = discreteLaplacian φ p := by
  unfold informationDivergence discreteDivergence gradientCurrent discreteLaplacian
  congr 1; ext μ
  unfold backwardDiff forwardDiff secondDeriv
  simp only [shiftBackFin_shiftFin]
  field_simp; ring

/-! ## KL Gradient Current -/

/-- The gradient current of the KL information density. -/
noncomputable def informationKLCurrent
    (g g₀ : DiscreteMetric) : InformationCurrent :=
  gradientCurrent (informationDensityKL g g₀)

/-! ## Flat Exact Conservation

  For flat Minkowski metric: I_KL(η,η) = 2 at every point (proven in
  InformationKL.lean). A constant field has Laplacian 0, so the KL
  gradient current is exactly conserved. -/

/-- The flat KL information density is constant (= 2 everywhere). -/
theorem informationKL_flat_is_const :
    informationDensityKL DiscreteMetric.flat DiscreteMetric.flat =
    fun _ => (2 : ℝ) :=
  funext informationDensityKL_flat_self

/-- The flat KL information density is harmonic (Laplacian = 0). -/
theorem informationKL_flat_harmonic :
    IsHarmonic (informationDensityKL DiscreteMetric.flat DiscreteMetric.flat) := by
  intro p
  rw [informationKL_flat_is_const]
  exact discreteLaplacian_const 2 p

/-- The flat KL gradient current is exactly conserved. -/
theorem informationKL_flat_conserved :
    IsConserved (informationKLCurrent DiscreteMetric.flat DiscreteMetric.flat) :=
  harmonic_gradient_current_conserved _ informationKL_flat_harmonic

/-- ConservedCurrent instance for flat KL information. -/
noncomputable def informationKL_flat_conservedCurrent : ConservedCurrent where
  current := informationKLCurrent DiscreteMetric.flat DiscreteMetric.flat
  conserved := informationKL_flat_conserved

/-! ## Self-Reference Decomposition

  When g₀ = g (self-reference), the KL density simplifies to
  I(g,g,p) = ½ log|det g(p)| + 2 (from informationDensityKL_self).

  By linearity of the Laplacian:
    Δ(I(g,g)) = ½ · Δ(log|det g|) + Δ(2) = ½ · Δ(log|det g|) + 0

  So I(g,g) is harmonic iff log|det g| is harmonic. -/

/-- The log-determinant field: p ↦ log|det g(p)|. -/
noncomputable def logDetField (g : DiscreteMetric) : ScalarField :=
  fun p => Real.log |(g p).det|

/-- Self-referenced KL density equals ½ · logDetField + 2 (as functions). -/
theorem informationKL_self_eq (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) :
    informationDensityKL g g =
    fun p => (1 / 2) * logDetField g p + 2 :=
  funext fun p => informationDensityKL_self g hnd p

/-- Laplacian of the self-referenced KL density decomposes:
    Δ(I_KL(g,g)) = ½ · Δ(log|det g|). -/
theorem laplacian_informationKL_self (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) :
    discreteLaplacian (informationDensityKL g g) p =
    (1 / 2) * discreteLaplacian (logDetField g) p := by
  rw [informationKL_self_eq g hnd]
  simp only [discreteLaplacian]
  -- Each secondDeriv of (½ · logDet + 2) factors to ½ · secondDeriv(logDet)
  have h_each : ∀ μ, secondDeriv (fun q => (1 / 2) * logDetField g q + 2) μ p =
      (1 / 2) * secondDeriv (logDetField g) μ p := by
    intro μ; simp only [secondDeriv]; ring
  simp_rw [h_each, ← Finset.mul_sum]

/-- Self-referenced KL density is harmonic iff log-determinant is harmonic. -/
theorem informationKL_self_harmonic_iff (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) :
    IsHarmonic (informationDensityKL g g) ↔
    IsHarmonic (logDetField g) := by
  constructor
  · intro h p
    have := laplacian_informationKL_self g hnd p
    rw [h p] at this
    linarith
  · intro h p
    rw [laplacian_informationKL_self g hnd p, h p, mul_zero]

/-- If the metric log-determinant is harmonic, the self-referenced KL
    gradient current is exactly conserved. -/
theorem informationKL_self_conserved (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p))
    (hlog : IsHarmonic (logDetField g)) :
    IsConserved (informationKLCurrent g g) :=
  harmonic_gradient_current_conserved _
    ((informationKL_self_harmonic_iff g hnd).mpr hlog)

/-- ConservedCurrent instance for self-referenced KL with harmonic log-det. -/
noncomputable def informationKL_self_conservedCurrent (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p))
    (hlog : IsHarmonic (logDetField g)) : ConservedCurrent where
  current := informationKLCurrent g g
  conserved := informationKL_self_conserved g hnd hlog

/-! ## Approximate Conservation Framework

  At healing-flow equilibrium with bounded defects, the KL density is
  approximately harmonic. We parameterize this by a bound on the Laplacian.
  This matches the project convention: use structure fields for bounded
  assumptions rather than axioms. -/

/-- Data for approximate conservation of the KL density. -/
structure KLEquilibriumData where
  g : DiscreteMetric
  g₀ : DiscreteMetric
  C : ℝ
  C_nonneg : 0 ≤ C
  laplacian_bound : ∀ p,
    |discreteLaplacian (informationDensityKL g g₀) p| ≤ C

/-- At approximate KL equilibrium, the KL gradient current has
    bounded divergence. -/
theorem informationKL_approx_conserved (data : KLEquilibriumData)
    (p : LatticePoint) :
    |informationDivergence (informationKLCurrent data.g data.g₀) p| ≤ data.C := by
  unfold informationKLCurrent
  rw [divergence_gradientCurrent_eq_laplacian]
  exact data.laplacian_bound p

/-- Approximate conservation: divergence is bounded by C at every point. -/
theorem informationKL_approx_divergence_bounded (data : KLEquilibriumData) :
    ∀ p, |informationDivergence (informationKLCurrent data.g data.g₀) p| ≤ data.C :=
  fun p => informationKL_approx_conserved data p

/-! ## Global Conservation on Finite Regions

  For any finite region, the total divergence of the flat KL current vanishes. -/

/-- Total divergence of flat KL current over any finite region is zero. -/
theorem informationKL_flat_total_divergence_zero (region : Finset LatticePoint) :
    region.sum (fun p => informationDivergence
      (informationKLCurrent DiscreteMetric.flat DiscreteMetric.flat) p) = 0 := by
  apply Finset.sum_eq_zero
  intro p _
  exact informationKL_flat_conserved p

end OmegaTheory.Conservation
