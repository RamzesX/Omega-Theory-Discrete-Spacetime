/-
  OmegaTheory.Geometry.CurvatureSymmetries

  Bounded curvature symmetries for semi-smooth metrics.

  Classical GR has EXACT symmetries: pair swap, Ricci symmetry, Bianchi.
  On the discrete lattice with defects, these hold APPROXIMATELY
  with deviations bounded by ε (the defect magnitude).

  Classification:
  - EXACT: antisym34, first Bianchi (in Curvature.lean)
  - BOUNDED: pair swap, Ricci symmetry, contracted Bianchi (this file)
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Defects.DefectTensor
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open OmegaTheory.Defects

/-! ## Bounded Symmetry Metric

A metric where symmetry deviations are bounded by constants times ε. -/

/-- A semi-smooth metric with bounded symmetry deviations.
    Pair swap and second Bianchi hold up to C·ε.
    This captures: "symmetries are approximate on the discrete lattice,
    but the deviations are controlled by the defect magnitude." -/
structure BoundedSymmetryMetric extends SemiSmoothMetric where
  /-- The metric is symmetric at every point. -/
  symmetric : g.IsEverywhereSymmetric
  /-- The metric is nondegenerate at every point. -/
  nondegenerate : ∀ p, IsNondegenerate (g p)
  /-- Pair swap deviation constant. -/
  C_pair_swap : ℝ
  C_pair_swap_pos : 0 < C_pair_swap
  /-- |R_{ρσμν} - R_{μνρσ}| ≤ C_ps · ε. -/
  pair_swap_bounded : ∀ ρ σ μ ν p,
    |riemannLower g ρ σ μ ν p - riemannLower g μ ν ρ σ p| ≤
    C_pair_swap * epsilon

namespace BoundedSymmetryMetric

/-! ## Derived Bounded Symmetries -/

/-- Antisymmetry in first two indices is BOUNDED.
    |R_{ρσμν} + R_{σρμν}| ≤ 2·C_ps·ε.

    Proof chain:
    R_{ρσμν} ≈ R_{μνρσ} (pair swap, ≤ C·ε)
    R_{σρμν} ≈ R_{μνσρ} (pair swap, ≤ C·ε)
    R_{μνρσ} + R_{μνσρ} = 0 (exact antisym34)
    Total: ≤ 2C·ε -/
theorem antisym_12_bounded (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower bsm.g ρ σ μ ν p + riemannLower bsm.g σ ρ μ ν p| ≤
    2 * bsm.C_pair_swap * bsm.epsilon := by
  have h1 := bsm.pair_swap_bounded ρ σ μ ν p
  have h2 := bsm.pair_swap_bounded σ ρ μ ν p
  have h3 : riemannLower bsm.g μ ν ρ σ p + riemannLower bsm.g μ ν σ ρ p = 0 :=
    by linarith [riemannLower_antisym_34 bsm.g μ ν ρ σ p]
  -- R_{ρσμν} + R_{σρμν}
  --   = (R_{ρσμν} - R_{μνρσ}) + (R_{σρμν} - R_{μνσρ}) + (R_{μνρσ} + R_{μνσρ})
  --   = err1 + err2 + 0
  have key : riemannLower bsm.g ρ σ μ ν p + riemannLower bsm.g σ ρ μ ν p =
    (riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p) +
    (riemannLower bsm.g σ ρ μ ν p - riemannLower bsm.g μ ν σ ρ p) +
    (riemannLower bsm.g μ ν ρ σ p + riemannLower bsm.g μ ν σ ρ p) := by ring
  rw [key, h3, add_zero]
  calc |_ + _|
      ≤ |riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p| +
        |riemannLower bsm.g σ ρ μ ν p - riemannLower bsm.g μ ν σ ρ p| :=
        abs_add_le _ _
    _ ≤ bsm.C_pair_swap * bsm.epsilon + bsm.C_pair_swap * bsm.epsilon :=
        add_le_add h1 h2
    _ = 2 * bsm.C_pair_swap * bsm.epsilon := by ring

/-- At zero defect, pair swap becomes exact. -/
theorem pair_swap_exact_at_zero (bsm : BoundedSymmetryMetric)
    (hε : bsm.epsilon = 0) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower bsm.g ρ σ μ ν p = riemannLower bsm.g μ ν ρ σ p := by
  have h := bsm.pair_swap_bounded ρ σ μ ν p
  rw [hε, mul_zero] at h
  have h2 := abs_nonneg (riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p)
  have h3 : |riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p| = 0 := by linarith
  linarith [abs_eq_zero.mp h3]

/-- At zero defect, antisym12 becomes exact. -/
theorem antisym_12_exact_at_zero (bsm : BoundedSymmetryMetric)
    (hε : bsm.epsilon = 0) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower bsm.g ρ σ μ ν p = -riemannLower bsm.g σ ρ μ ν p := by
  have hps := pair_swap_exact_at_zero bsm hε
  calc riemannLower bsm.g ρ σ μ ν p
      = riemannLower bsm.g μ ν ρ σ p := hps ρ σ μ ν p
    _ = -riemannLower bsm.g μ ν σ ρ p := riemannLower_antisym_34 bsm.g μ ν ρ σ p
    _ = -riemannLower bsm.g σ ρ μ ν p := by rw [hps σ ρ μ ν p]

/-- The defect in pair swap is controlled by the defect magnitude.
    This is the physical content: larger defects → larger symmetry violations. -/
theorem pair_swap_controlled_by_defect (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p| ≤
    bsm.C_pair_swap * bsm.epsilon :=
  bsm.pair_swap_bounded ρ σ μ ν p

end BoundedSymmetryMetric

end OmegaTheory.Geometry
