/-
  OmegaTheory.Foundations.SubstrateSeeleyDeWittA2

  **Lion's-Pride Phase 6.5m (2026-05-06)**:
  *Substrate-side Seeley-DeWitt `a_2` coefficient using the EXISTING
  `OmegaTheory.Geometry.Curvature.scalarCurvature` infrastructure —
  closing the "we don't have curved heat-kernel coefficients" deferral.*

  ## Why this file

  Earlier closing memos labelled "Seeley-DeWitt a_2 = -R/6 in dim d > 0"
  as a multi-month frontier deferral.  The user pushed back: we already
  have `scalarCurvature` defined in `OmegaTheory/Geometry/Curvature.lean`
  (line 183) on the substrate's `DiscreteMetric`.  Bochner-Lichnerowicz
  in d=4:

      D²  =  ∇*∇  +  (1/4) R                      (continuum)

  Heat-kernel a_2 (off-diagonal trace coefficient) in d-dim:

      a_2(D²)(x)  =  −R(x)/6  +  tr E(x)            (Vassilevich 2003 §2.1)

  For our substrate setup, both sides are defined via existing
  infrastructure:

  * `R(x)` = `scalarCurvature g p` from `Geometry.Curvature` (already
    defined).
  * `tr E(x)` = the trace of the endomorphism part of D² (zero for
    pure Dirac on Riemannian manifold; non-zero when there's a torsion
    or potential term).

  This file ships:

  * `a_2_substrate g p := -scalarCurvature g p / 6` — the substrate
    Seeley-DeWitt a_2 for the spin-Laplacian (E = 0 case).
  * `a_2_substrate_flat = 0` — vanishes for flat metric.
  * `a_2_substrate_neg_iff` — characterisation in terms of scalar
    curvature sign.
  * Headline 4-conjunct.

  ## Honest scope

  This is the DEFINITIONAL bridge from substrate scalarCurvature to a
  Seeley-DeWitt-style a_2 coefficient.  It does NOT prove:

  * The Bochner-Lichnerowicz identity D² = Δ + R/4 on the substrate
    (would need careful spin-connection algebra; tractable but
    separate sub-phase).
  * The full heat-kernel asymptotic
    `Tr(e^{-tD²}) ~ Σ_k (4πt)^{(k-d)/2} ∫ a_k`
    (needs continuous integration on lattice; tractable but separate).

  What it DOES ship: the rigorous DEFINITION of a_2 in terms of our
  existing scalarCurvature, with structural properties verified.

  ## Lion's-Pride doctrine applied (BUILD_MATHLIB_MACHINERY_T6_13)

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure composition via `Geometry.Curvature.scalarCurvature` +
  `Geometry.Curvature.scalar_flat`.  Acknowledges that the user was
  right: we already have the geometry infrastructure for a_2; no
  multi-month deferral needed.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Foundations.HeatKernelCoefficients
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.SubstrateSeeleyDeWittA2

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## 1. Substrate Seeley-DeWitt a_2 from scalarCurvature

    In Vassilevich 2003 conventions, the Seeley-DeWitt a_2 coefficient
    for the spin-Laplacian on a Riemannian manifold is
        a_2(x) = -R(x)/6 + tr E(x)
    For the pure Dirac case (E = 0), this reduces to -R/6. -/

/-- **Substrate-side Seeley-DeWitt a_2 coefficient** (E = 0 case):
    `a_2_substrate g p := -scalarCurvature g p / 6`. -/
noncomputable def a_2_substrate (g : DiscreteMetric) (p : LatticePoint) : ℝ :=
  -scalarCurvature g p / 6

/-- **Flat-metric vanishing**: `a_2_substrate (flat metric) p = 0`.
    Direct from `scalar_flat`. -/
theorem a_2_substrate_flat (p : LatticePoint) :
    a_2_substrate DiscreteMetric.flat p = 0 := by
  unfold a_2_substrate
  rw [scalar_flat]
  norm_num

/-- **Sign characterisation**: `a_2_substrate g p > 0` iff
    `scalarCurvature g p < 0` (i.e., negatively-curved substrate region
    contributes positively to the trace correction). -/
theorem a_2_substrate_pos_iff (g : DiscreteMetric) (p : LatticePoint) :
    0 < a_2_substrate g p ↔ scalarCurvature g p < 0 := by
  unfold a_2_substrate
  constructor
  · intro h
    nlinarith
  · intro h
    nlinarith

/-- **Linearity**: `a_2_substrate` is linear in scalarCurvature
    (with coefficient `-1/6`). -/
theorem a_2_substrate_eq (g : DiscreteMetric) (p : LatticePoint) :
    a_2_substrate g p = -scalarCurvature g p / 6 := rfl

/-- **a_2 vanishing iff scalar curvature vanishes**. -/
theorem a_2_substrate_eq_zero_iff (g : DiscreteMetric) (p : LatticePoint) :
    a_2_substrate g p = 0 ↔ scalarCurvature g p = 0 := by
  unfold a_2_substrate
  constructor
  · intro h
    nlinarith
  · intro h
    rw [h]
    norm_num

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 6.5m headline — substrate Seeley-DeWitt a_2
    coefficient via scalarCurvature.**

    For any DiscreteMetric `g` and LatticePoint `p`:

    1. **Definition**: `a_2_substrate g p = -R(p)/6` where `R = scalarCurvature`.

    2. **Flat-vanishing**: `a_2_substrate (flat) p = 0`.

    3. **Sign characterisation**: `a_2 > 0 ↔ R < 0`.

    4. **Vanishing characterisation**: `a_2 = 0 ↔ R = 0`. -/
theorem substrate_seeley_de_witt_a2_report (g : DiscreteMetric) (p : LatticePoint) :
    a_2_substrate g p = -scalarCurvature g p / 6 ∧
    a_2_substrate DiscreteMetric.flat p = 0 ∧
    (0 < a_2_substrate g p ↔ scalarCurvature g p < 0) ∧
    (a_2_substrate g p = 0 ↔ scalarCurvature g p = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact a_2_substrate_eq g p
  · exact a_2_substrate_flat p
  · exact a_2_substrate_pos_iff g p
  · exact a_2_substrate_eq_zero_iff g p

end OmegaTheory.Foundations.SubstrateSeeleyDeWittA2
