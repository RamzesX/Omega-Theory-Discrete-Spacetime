/-
  OmegaTheory.Conservation.InformationKL

  Concrete information density from Appendix D §3.1:

    I(g, g₀, p) = ½ log|det g(p)| + ½ Tr(g(p)⁻¹ · g₀(p))

  This has the algebraic structure of a Kullback-Leibler divergence
  between two multivariate Gaussians whose covariance matrices are
  proportional to g and g₀. Specifically, for zero-mean Gaussians:

    D_KL(N(0,Σ) || N(0,Σ₀)) = ½[Tr(Σ₀⁻¹Σ) − d + log(det Σ₀ / det Σ)]

  Our formula differs by conventions but shares the core:
  log-determinant + inverse-metric trace.

  Mathlib v4.29 has abstract KL (klDiv over measures) with Gibbs'
  inequality and converse Gibbs', but no closed-form Gaussian KL.
  We define the finite-dimensional algebraic version directly and
  prove its properties using Matrix.det, Matrix.trace, Real.log.
-/

import OmegaTheory.Geometry.Metric
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

namespace OmegaTheory.Conservation

open OmegaTheory.Geometry
open OmegaTheory.Spacetime
open Matrix Finset

/-! ## Information Density Definition -/

/-- The information density at a lattice point (Appendix D §3.1):
    I(g, g₀, p) = ½ log|det g(p)| + ½ Tr(g(p)⁻¹ · g₀(p)).

    This measures how much the metric g deviates from the reference g₀,
    with the log-determinant capturing volume distortion and the trace
    term capturing shape distortion — the same decomposition as the
    KL divergence between Gaussian distributions. -/
noncomputable def informationDensityKL
    (g g₀ : DiscreteMetric) (p : LatticePoint) : ℝ :=
  (1 / 2) * Real.log |(g p).det| +
  (1 / 2) * ((inverseMetric (g p)) * g₀ p).trace

/-! ## Volume and Shape Decomposition -/

/-- Volume component of the information density. -/
noncomputable def infoDensityVolume
    (g : DiscreteMetric) (p : LatticePoint) : ℝ :=
  (1 / 2) * Real.log |(g p).det|

/-- Shape component of the information density. -/
noncomputable def infoDensityShape
    (g g₀ : DiscreteMetric) (p : LatticePoint) : ℝ :=
  (1 / 2) * ((inverseMetric (g p)) * g₀ p).trace

/-- The info density is the sum of volume and shape components. -/
theorem informationDensityKL_eq_vol_plus_shape
    (g g₀ : DiscreteMetric) (p : LatticePoint) :
    informationDensityKL g g₀ p =
    infoDensityVolume g p + infoDensityShape g g₀ p := rfl

/-! ## Properties at the Reference Metric -/

/-- The trace term at the reference metric: Tr(g⁻¹g) = 4. -/
theorem trace_inverse_mul_self (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) :
    ((inverseMetric (g p)) * g p).trace = (4 : ℝ) := by
  rw [inverse_mul_metric (g p) (hnd p), trace_one, Fintype.card_fin]
  simp

/-- Shape component at reference: ½ · Tr(I₄) = 2. -/
theorem infoDensityShape_self (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) :
    infoDensityShape g g p = 2 := by
  unfold infoDensityShape
  rw [trace_inverse_mul_self g hnd p]; norm_num

/-- At the reference metric (g = g₀), the info density simplifies. -/
theorem informationDensityKL_self (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) :
    informationDensityKL g g p =
    (1 / 2) * Real.log |(g p).det| + 2 := by
  unfold informationDensityKL
  rw [trace_inverse_mul_self g hnd p]; norm_num

/-! ## Flat Metric Values -/

/-- For flat Minkowski metric, log|det η| = 0. -/
theorem flat_log_det (p : LatticePoint) :
    Real.log |(DiscreteMetric.flat p).det| = 0 := by
  have hdet : (DiscreteMetric.flat p).det = -1 := by
    unfold DiscreteMetric.flat minkowskiMetric
    simp [Matrix.det_diagonal, Fin.prod_univ_four]
  rw [hdet, abs_neg, abs_one, Real.log_one]

/-- Volume component vanishes for flat spacetime. -/
theorem infoDensityVolume_flat (p : LatticePoint) :
    infoDensityVolume DiscreteMetric.flat p = 0 := by
  unfold infoDensityVolume; rw [flat_log_det]; ring

/-- Information density of flat spacetime relative to itself. -/
theorem informationDensityKL_flat_self (p : LatticePoint) :
    informationDensityKL DiscreteMetric.flat DiscreteMetric.flat p = 2 := by
  have hnd : ∀ q, IsNondegenerate (DiscreteMetric.flat q) := by
    intro q; exact (DiscreteMetric.flat_lorentzian q).nondegenerate
  simp only [informationDensityKL_self DiscreteMetric.flat hnd p, flat_log_det, mul_zero,
    zero_add]

/-! ## Non-negativity under well-defined metric conditions

  Promotes the Gibbs hypothesis `0 ≤ informationDensityKL(g, g₀, p)` used
  in `CoarseGrainingMap.lean` to a theorem in a concrete regime.  The
  cleanest honest scope (matching `DiscreteMetric.flat` at minimum, per
  the Task #5 spec) is: **at the reference metric** `g = g₀` with the
  natural volume-calibration `|det g(p)| ≥ 1`, the information density
  is `≥ 2 ≥ 0`.  Flat Minkowski satisfies `|det| = 1` exactly and
  realises equality with `I = 2`.  This is the shape the coarse-graining
  theory calls on.

  General non-negativity for arbitrary well-defined pairs `(g, g₀)` is
  the multivariate-Gaussian KL inequality; Mathlib v4.29 does not ship a
  closed-form Gaussian KL, so we do not prove the general result here. -/

/-- **Non-negativity of information density at the reference metric under
    unit-volume normalisation.**  When `g = g₀` is non-degenerate and
    `|det g(p)| ≥ 1`, the information density is at least `2`, hence
    in particular non-negative.  Matches `DiscreteMetric.flat` (where
    `|det flat(p)| = 1` and the bound is tight at `I = 2`). -/
theorem informationDensityKL_nonneg_of_wellDefined
    (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p))
    (hdet : ∀ p, 1 ≤ |(g p).det|)
    (p : LatticePoint) :
    0 ≤ informationDensityKL g g p := by
  rw [informationDensityKL_self g hnd p]
  have hlog : 0 ≤ Real.log |(g p).det| :=
    Real.log_nonneg (hdet p)
  linarith

/-- **Gibbs hypothesis corollary for flat spacetime.**  The Gibbs
    positivity condition used in the weak `ℓ²` bound of
    `CoarseGrainingMap` is a theorem for the flat background. -/
theorem informationDensityKL_flat_nonneg (p : LatticePoint) :
    0 ≤ informationDensityKL DiscreteMetric.flat DiscreteMetric.flat p := by
  rw [informationDensityKL_flat_self]
  norm_num

end OmegaTheory.Conservation
