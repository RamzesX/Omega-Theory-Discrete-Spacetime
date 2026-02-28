/-
  Geometry.Curvature.Weyl
  =======================

  Weyl tensor (conformally invariant part of curvature).

  Physical meaning:
  Weyl describes how curvature propagates through "empty" spacetime:
  - Photons (massless particles) - perturbations of the lattice
  - Gravitational waves - ripples in spacetime geometry
  - Tidal effects far from massive bodies

  On the Planck lattice:
  - Continuous GR: exact symmetries (= 0)
  - Discrete lattice: approximate symmetries (≤ ℓ_P)

  Definition:
  - weylTensor: C_{ρσμν} = trace-free part of Riemann tensor
-/

import DiscreteSpacetime.Geometry.Curvature.Scalar
import DiscreteSpacetime.Basic.Constants

namespace DiscreteSpacetime.Geometry.Curvature

open DiscreteSpacetime.Basic
open DiscreteSpacetime.Geometry
open Matrix
open BigOperators
open Finset

/-! ## Weyl Tensor Definition -/

/-- Weyl tensor: the trace-free part of Riemann tensor.

    C_{ρσμν} = R_{ρσμν} - (2/(n-2))[g_{ρ[μ} R_{ν]σ} - g_{σ[μ} R_{ν]ρ}]
                       + (2/((n-1)(n-2))) R g_{ρ[μ} g_{ν]σ}

    where n = 4, so:
    - 2/(n-2) = 2/2 = 1
    - 2/((n-1)(n-2)) = 2/(3·2) = 1/3 -/
noncomputable def weylTensor (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  let R := riemannLower g ρ σ μ ν p
  let Ric_μσ := ricciTensor g μ σ p
  let Ric_νσ := ricciTensor g ν σ p
  let Ric_μρ := ricciTensor g μ ρ p
  let Ric_νρ := ricciTensor g ν ρ p
  let S := scalarCurvature g p
  let gp := g p
  R - (1 : ℝ) * (gp ρ μ * Ric_νσ - gp ρ ν * Ric_μσ - gp σ μ * Ric_νρ + gp σ ν * Ric_μρ) +
    (1/3 : ℝ) * S * (gp ρ μ * gp ν σ - gp ρ ν * gp μ σ)

/-! ## Weyl Tensor Properties

    Continuous GR: exact (= 0)
    Discrete lattice: approximate (≤ ℓ_P)
-/

/-- Weyl trace-free property.
    Continuous: g^{ρμ} C_{ρσμν} = 0
    Discrete: |g^{ρμ} C_{ρσμν}| ≤ ℓ_P -/
theorem weyl_tracefree_discrete (g : DiscreteMetric)
    (_hSym : DiscreteMetric.IsEverywhereSymmetric g)
    (_hNd : DiscreteMetric.IsEverywhereNondegenerate g)
    (σ ν : Fin 4) (p : LatticePoint) :
    |(∑ ρ : Fin 4, ∑ μ : Fin 4,
      (inverseMetric (g p)) ρ μ * weylTensor g ρ σ μ ν p)| ≤ ℓ_P := by
  sorry

/-- Weyl antisymmetry in last two indices.
    Continuous: C_{ρσμν} = -C_{ρσνμ}
    Discrete: |C_{ρσμν} + C_{ρσνμ}| ≤ ℓ_P -/
theorem weyl_antisym_34_discrete (g : DiscreteMetric)
    (hSym : DiscreteMetric.IsEverywhereSymmetric g)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |weylTensor g ρ σ μ ν p + weylTensor g ρ σ ν μ p| ≤ ℓ_P := by
  -- The sum is exactly 0: all terms cancel by symmetry
  have h : weylTensor g ρ σ μ ν p + weylTensor g ρ σ ν μ p = 0 := by
    simp only [weylTensor]
    have hR := riemann_lower_antisym_34 g hSym ρ σ μ ν p
    linarith
  rw [h, abs_of_nonneg (le_refl 0)]
  exact le_of_lt PlanckLength_pos

/-- Weyl antisymmetry in first two indices.
    Continuous: C_{ρσμν} = -C_{σρμν}
    Discrete: |C_{ρσμν} + C_{σρμν}| ≤ ℓ_P -/
theorem weyl_antisym_12_discrete (g : DiscreteMetric)
    (hSym : DiscreteMetric.IsEverywhereSymmetric g)
    (hNd : DiscreteMetric.IsEverywhereNondegenerate g)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |weylTensor g ρ σ μ ν p + weylTensor g σ ρ μ ν p| ≤ ℓ_P := by
  have h : weylTensor g ρ σ μ ν p + weylTensor g σ ρ μ ν p = 0 := by
    simp only [weylTensor]
    have hR := riemann_lower_antisym_12 g hSym hNd ρ σ μ ν p
    -- Use metric symmetry
    have hg : ∀ i j : Fin 4, (g p) i j = (g p) j i :=
      fun i j => DiscreteSpacetime.Axioms.Metric.metric_symmetry g p i j
    -- Name the key products to help nlinarith
    set a := (g p) ρ μ
    set b := (g p) ρ ν
    set c := (g p) σ μ
    set d := (g p) σ ν
    set R1 := ricciTensor g ν σ p
    set R2 := ricciTensor g μ σ p
    set R3 := ricciTensor g ν ρ p
    set R4 := ricciTensor g μ ρ p
    set S := scalarCurvature g p
    -- After metric symmetry, (g p) μ σ = c, (g p) ν ρ = b, etc.
    have h1 : (g p) μ σ = c := (hg σ μ).symm ▸ rfl
    have h2 : (g p) ν ρ = b := (hg ρ ν).symm ▸ rfl
    have h3 : (g p) ν σ = d := (hg σ ν).symm ▸ rfl
    have h4 : (g p) μ ρ = a := (hg ρ μ).symm ▸ rfl
    rw [h1, h2, h3, h4]
    nlinarith
  rw [h, abs_of_nonneg (le_refl 0)]
  exact le_of_lt PlanckLength_pos

/-- Weyl pair swap symmetry.
    Continuous: C_{ρσμν} = C_{μνρσ}
    Discrete: |C_{ρσμν} - C_{μνρσ}| ≤ ℓ_P -/
theorem weyl_pair_swap_discrete (g : DiscreteMetric)
    (_hSym : DiscreteMetric.IsEverywhereSymmetric g)
    (_hNd : DiscreteMetric.IsEverywhereNondegenerate g)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |weylTensor g ρ σ μ ν p - weylTensor g μ ν ρ σ p| ≤ ℓ_P := by
  sorry

end DiscreteSpacetime.Geometry.Curvature
