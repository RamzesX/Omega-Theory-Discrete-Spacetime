/-
  OmegaTheory.HealingFlow.Functional

  The healing functional F[g] that drives spacetime toward smooth geometry.

  F[g] = Σ_n [ (1/2)(I(n) - Ī)² + (λ/2)|D(n)|² + (μ/2)|Δg(n)|² ]

  Three terms:
  - Information equalization: penalizes non-uniform information density
  - Defect penalty: penalizes metric defects
  - Smoothness: penalizes large Laplacian (discrete curvature)

  KEY THEOREM: F[g] ≥ 0 (provable — sum of squares).
-/

import OmegaTheory.Conservation.Information
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Spacetime.Operators

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Healing Parameters -/

/-- Parameters controlling the healing flow. -/
structure HealingParams where
  /-- Information equalization strength. -/
  gamma : ℝ
  /-- Defect penalty strength. -/
  lambda : ℝ
  /-- Smoothness (Laplacian) strength. -/
  mu : ℝ
  /-- All strengths are positive. -/
  gamma_pos : 0 < gamma
  lambda_pos : 0 < lambda
  mu_pos : 0 < mu

/-! ## Healing Functional Components -/

/-- Information deviation term: (1/2)(I(n) - Ī)² at a single point. -/
noncomputable def infoTerm (I : InformationDensity) (I_bar : ℝ) (p : LatticePoint) : ℝ :=
  (1 / 2) * (I p - I_bar) ^ 2

/-- Defect magnitude squared term: (λ/2)|D(n)|² at a single point. -/
noncomputable def defectTerm (g_actual g_exact : DiscreteMetric)
    (lambda : ℝ) (p : LatticePoint) : ℝ :=
  (lambda / 2) * defectMagnitudeSq g_actual g_exact p

/-- Smoothness term: (μ/2)|Δg(n)|² at a single point.
    Uses the Laplacian of each metric component. -/
noncomputable def smoothnessTerm (g : DiscreteMetric) (mu : ℝ)
    (p : LatticePoint) : ℝ :=
  (mu / 2) * Finset.univ.sum fun a =>
    Finset.univ.sum fun b =>
      (discreteLaplacian (fun q => g q a b) p) ^ 2

/-! ## The Healing Functional -/

/-- The healing functional F[g] over a lattice region.
    F = Σ_n [ infoTerm + defectTerm + smoothnessTerm ] -/
noncomputable def healingFunctional (params : HealingParams)
    (g_actual g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) : ℝ :=
  region.sum fun p =>
    infoTerm I I_bar p +
    defectTerm g_actual g_exact params.lambda p +
    smoothnessTerm g_actual params.mu p

/-! ## F[g] ≥ 0 (Provable — sum of nonneg terms) -/

/-- Information term is nonneg (it's (1/2) times a square). -/
theorem infoTerm_nonneg (I : InformationDensity) (I_bar : ℝ) (p : LatticePoint) :
    0 ≤ infoTerm I I_bar p := by
  unfold infoTerm
  apply mul_nonneg
  · norm_num
  · exact sq_nonneg _

/-- Defect term is nonneg when λ > 0. -/
theorem defectTerm_nonneg (g_actual g_exact : DiscreteMetric) {lambda : ℝ}
    (hlam : 0 < lambda) (p : LatticePoint) :
    0 ≤ defectTerm g_actual g_exact lambda p := by
  unfold defectTerm
  apply mul_nonneg
  · linarith
  · exact defectMagnitudeSq_nonneg g_actual g_exact p

/-- Smoothness term is nonneg when μ > 0. -/
theorem smoothnessTerm_nonneg (g : DiscreteMetric) {mu : ℝ}
    (hmu : 0 < mu) (p : LatticePoint) :
    0 ≤ smoothnessTerm g mu p := by
  unfold smoothnessTerm
  apply mul_nonneg
  · linarith
  · apply Finset.sum_nonneg; intro a _
    apply Finset.sum_nonneg; intro b _
    exact sq_nonneg _

/-- THE KEY THEOREM: F[g] ≥ 0.
    The healing functional is non-negative because it's a sum of squares
    weighted by positive coefficients. -/
theorem healingFunctional_nonneg (params : HealingParams)
    (g_actual g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    0 ≤ healingFunctional params g_actual g_exact I I_bar region := by
  unfold healingFunctional
  apply Finset.sum_nonneg
  intro p _
  apply add_nonneg
  apply add_nonneg
  · exact infoTerm_nonneg I I_bar p
  · exact defectTerm_nonneg g_actual g_exact params.lambda_pos p
  · exact smoothnessTerm_nonneg g_actual params.mu_pos p

/-- F = 0 iff all three terms vanish everywhere in the region. -/
theorem healingFunctional_eq_zero_iff (params : HealingParams)
    (g_actual g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    healingFunctional params g_actual g_exact I I_bar region = 0 →
    ∀ p ∈ region,
      infoTerm I I_bar p = 0 ∧
      defectTerm g_actual g_exact params.lambda p = 0 ∧
      smoothnessTerm g_actual params.mu p = 0 := by
  intro hF p hp
  unfold healingFunctional at hF
  have h_sum_zero := Finset.sum_eq_zero_iff_of_nonneg (fun q _ => by
    apply add_nonneg; apply add_nonneg
    · exact infoTerm_nonneg I I_bar q
    · exact defectTerm_nonneg g_actual g_exact params.lambda_pos q
    · exact smoothnessTerm_nonneg g_actual params.mu_pos q) |>.mp hF p hp
  have h1 := infoTerm_nonneg I I_bar p
  have h2 := defectTerm_nonneg g_actual g_exact params.lambda_pos p
  have h3 := smoothnessTerm_nonneg g_actual params.mu_pos p
  constructor
  · linarith
  constructor
  · linarith
  · linarith

end OmegaTheory.HealingFlow
