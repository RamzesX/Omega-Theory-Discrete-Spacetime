/-
  OmegaTheory.Emergence.SmoothInterpolant

  Smooth continuum interpolant of a discrete lattice metric.

  This file formalises the *hypothesis* structure that enters the
  hypothesis-carrying form of the HPW laplacian–Ricci convergence theorem
  (ingredient E of the HPW elimination plan).  Rather than proving the
  Whitney-style existence of a smooth extension from `Z^4` to `R^4` in
  full generality (which requires Mathlib convolution tooling that we
  do not yet wield), we bundle the needed continuum data into a
  dependent structure `SmoothInterpolantData g` and exhibit a concrete
  witness for the flat Minkowski metric.

  Downstream consumers (in particular the Architect's `HpwHypothesis`)
  may then take a `SmoothInterpolantData g` as input; the burden of
  producing one is discharged by the physical model on a case-by-case
  basis (e.g. for flat space, the witness below).

  ## Ambition level achieved

  Level 2 of the three-tier plan:
  * the `SmoothInterpolantData` structure is *inhabited*;
  * `minkowskiInterpolant` is a fully constructive witness (the constant
    Minkowski metric), with a proof that it is `ContDiff R ∞` (hence
    `ContDiff R 4`) and that it interpolates `DiscreteMetric.flat`.

  No `sorry`, no new axioms.

  -- Interpolant-constructor, HPW-elimination team, 2026-04-14
-/

import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.ContDiff.Defs
import OmegaTheory.Geometry.Metric
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.HpwHypothesis

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Continuum coordinates of a lattice point

A lattice point `p : LatticePoint = Fin 4 → Z` sits at the continuum
position `l_P · p` in `R^4`.  The embedding `latticeEmbed` is defined
in `HpwHypothesis.lean` and shared by both files.  We re-use it here
so that a `SmoothInterpolantData g` can be fed directly into the
Architect's `HpwHypothesis g` bundle. -/

/-! ## Smooth interpolant data

We package the continuum field `g_cont`, its `C^4` regularity, a
uniform `C^4` derivative bound, and the interpolation identity into a
single structure.  The `C^4` bound field is present because downstream
Taylor-remainder arguments need a bound on the fourth derivatives of
`g_cont`; we state it pointwise via `‖iteratedFDeriv R 4 …‖ ≤ M`.
-/

/-- Smoothness-and-interpolation data for a discrete metric `g`.

Fields:
* `g_cont`       — a continuum metric field `R^4 → MetricTensor`;
* `smooth`       — `g_cont` viewed as a function with values in
  `Fin 4 → Fin 4 → R` is `C^4` (in fact `C^n` for every `n` when taken
  strict; we ask only for `ContDiff R 4`);
* `c4_bound`     — a nonneg real `M` such that the fourth iterated
  Fréchet derivative of `fun x => g_cont x μ ν` is bounded by `M`
  uniformly in `x` for every fixed `(μ, ν)`;
* `bound_nonneg` — positivity of the bound;
* `interpolates` — `g_cont (l_P · p) μ ν = g p μ ν` for every lattice
  point `p` and every pair of indices `(μ, ν)`.
-/
structure SmoothInterpolantData (g : DiscreteMetric) : Type where
  /-- The smooth continuum metric field on `R^4`. -/
  g_cont : (Fin 4 → ℝ) → MetricTensor
  /-- `C^4` regularity of every component `g_cont · μ ν`. -/
  smooth : ∀ μ ν : Fin 4, ContDiff ℝ 4 (fun x : Fin 4 → ℝ => g_cont x μ ν)
  /-- Uniform bound on fourth derivatives of each component. -/
  c4_bound : ℝ
  /-- The bound is nonnegative. -/
  bound_nonneg : 0 ≤ c4_bound
  /-- The bound controls each component's fourth iterated derivative. -/
  c4_estimate :
    ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => g_cont y μ ν) x‖ ≤ c4_bound
  /-- Interpolation of the discrete metric at lattice points. -/
  interpolates :
    ∀ (p : LatticePoint) (μ ν : Fin 4),
      g_cont (latticeEmbed p) μ ν = g p μ ν

/-! ## Minkowski witness

The flat-space discrete metric has an obvious smooth interpolant:
the constant Minkowski tensor `eta = diag(-1,1,1,1)` viewed as a
function `R^4 -> MetricTensor`.  Every component is constant, hence
`C^infty`; all fourth derivatives vanish, so we may take the bound
`M = 0`; and agreement with `DiscreteMetric.flat` is `rfl`. -/

/-- Constant Minkowski metric, viewed as a function `R^4 → MetricTensor`. -/
noncomputable def minkowskiInterpolantField : (Fin 4 → ℝ) → MetricTensor :=
  fun _ => minkowskiMetric

/-- Each component of the Minkowski interpolant is the constant function
`(fun _ => minkowskiMetric μ ν)`. -/
theorem minkowskiInterpolantField_component (μ ν : Fin 4) :
    (fun x : Fin 4 → ℝ => minkowskiInterpolantField x μ ν)
      = fun _ : Fin 4 → ℝ => minkowskiMetric μ ν := by
  rfl

/-- Every component of the Minkowski interpolant is `C^n` for every `n`. -/
theorem minkowskiInterpolantField_contDiff (μ ν : Fin 4) (n : WithTop ℕ∞) :
    ContDiff ℝ n (fun x : Fin 4 → ℝ => minkowskiInterpolantField x μ ν) := by
  simpa [minkowskiInterpolantField_component] using
    (contDiff_const : ContDiff ℝ n
      (fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ)))

/-- The fourth iterated derivative of a component of the Minkowski
interpolant vanishes identically. -/
theorem minkowskiInterpolantField_iteratedFDeriv_four
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    iteratedFDeriv ℝ 4
        (fun y : Fin 4 → ℝ => minkowskiInterpolantField y μ ν) x = 0 := by
  have hfun :
      (fun y : Fin 4 → ℝ => minkowskiInterpolantField y μ ν)
        = fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ) := rfl
  rw [hfun]
  have h4 :
      (iteratedFDeriv ℝ 4 fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ)) = 0 :=
    iteratedFDeriv_const_of_ne (by decide) _
  exact congrFun h4 x

/-- Continuum embedding of a `DiscreteMetric.flat` lattice point is again
Minkowski.  This is the interpolation identity for the flat witness. -/
theorem minkowskiInterpolantField_interpolates_flat
    (p : LatticePoint) (μ ν : Fin 4) :
    minkowskiInterpolantField (latticeEmbed p) μ ν
      = (DiscreteMetric.flat p) μ ν := by
  rfl

/-- The Minkowski witness: `SmoothInterpolantData` for `DiscreteMetric.flat`. -/
noncomputable def minkowskiInterpolant :
    SmoothInterpolantData DiscreteMetric.flat where
  g_cont := minkowskiInterpolantField
  smooth := fun μ ν =>
    minkowskiInterpolantField_contDiff μ ν 4
  c4_bound := 0
  bound_nonneg := le_refl 0
  c4_estimate := by
    intro μ ν x
    have h0 := minkowskiInterpolantField_iteratedFDeriv_four μ ν x
    simp [h0]
  interpolates := fun p μ ν =>
    minkowskiInterpolantField_interpolates_flat p μ ν

/-- Inhabitance corollary: *some* `SmoothInterpolantData` exists for the
flat discrete metric. -/
theorem exists_smoothInterpolant_flat :
    ∃ D : SmoothInterpolantData DiscreteMetric.flat, D.c4_bound = 0 :=
  ⟨minkowskiInterpolant, rfl⟩

end OmegaTheory.Emergence
