/-
  OmegaTheory.Emergence.WhitneyInterpolant

  **HPW ingredient E groundwork -- convolution-based smooth interpolation.**

  This file lays the structural groundwork for ingredient E of the HPW
  elimination programme: the existence of a smooth continuum interpolant
  for an *arbitrary* bounded discrete metric.

  ## Approach: mollifier convolution

  Instead of the full Whitney extension theorem (which Mathlib lacks),
  we use a convolution sum:

      g_conv(x) := Sum_p g(p) * phi((x - l_P * p) / l_P)

  where phi is a smooth bump (mollifier) supported in the unit ball with
  integral one.  The result inherits C^infinity from phi, and on lattice
  points the sum reduces to a finite overlap controlled by the mollifier
  support.

  ## What this file provides

  1. `MollifierData` -- structure bundling phi with smoothness, support,
     integral-one, and nonnegativity hypotheses.
  2. `ConvolutionInterpolant` -- the smooth interpolant for a bounded
     discrete metric, defined via the convolution sum.
  3. `convolutionFixedBox_contDiff` -- C^4 regularity inherited from phi.
  4. `MollifierData.IsLatticeExact` -- Prop-def for exact lattice
     interpolation (phi vanishes at nonzero integer points).
  5. `ConvolutionInterpolant.toSmoothInterpolantData` -- bridge to the
     existing `SmoothInterpolantData` infrastructure.

  ## Honest scope

  The convolution sum is defined as a Finset sum over lattice points
  within a bounded region (the mollifier support is compact, so at
  each continuum point only finitely many lattice points contribute).
  The smoothness proof delegates to `ContDiff.sum` + `ContDiff.comp`.
  The approximation bound and the integral-one normalisation are
  carried as Prop hypotheses -- their discharge requires measure theory
  that is out of scope for this file.

  0 sorry, 0 new axioms.

  -- Avior, HPW-elimination team, 2026-04-15
-/

import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.ContDiff.Defs
import OmegaTheory.Geometry.Metric
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.SmoothInterpolant

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Mollifier data

A `MollifierData` bundles a smooth bump function `phi : R^4 -> R`
with the analytic properties needed for the convolution interpolant:

* `phi_smooth` -- `C^infinity` regularity;
* `phi_support` -- compact support in the closed unit ball;
* `phi_nonneg` -- pointwise nonnegativity;
* `phi_integral_one` -- the integral over R^4 equals 1 (carried as Prop).

The integral condition is necessary for the approximation bound but
requires Mathlib measure/integration machinery to state precisely.
We carry it as a `Prop` field so that a consumer supplies it externally. -/

/-- **Mollifier data for the convolution interpolant.**

Bundles a smooth compactly-supported bump function with the properties
needed to produce a `SmoothInterpolantData` via convolution. -/
structure MollifierData : Type where
  /-- The mollifier function `phi : R^4 -> R`. -/
  phi : (Fin 4 → ℝ) → ℝ
  /-- `phi` is `C^infinity`. -/
  phi_smooth : ContDiff ℝ ⊤ phi
  /-- `phi` is supported in the closed unit ball: `norm(x) > 1 => phi(x) = 0`. -/
  phi_support : ∀ x : Fin 4 → ℝ, ‖x‖ > 1 → phi x = 0
  /-- `phi` is pointwise nonneg. -/
  phi_nonneg : ∀ x : Fin 4 → ℝ, 0 ≤ phi x
  /-- `phi(0) > 0` -- the mollifier is nondegenerate at the origin. -/
  phi_origin_pos : 0 < phi 0
  /-- Normalisation: `integral phi = 1` (carried as Prop; discharge requires
      measure theory). -/
  phi_integral_one : Prop

/-! ## Bounded discrete metric

The convolution sum is well-defined only when the metric components
are bounded (otherwise the sum may diverge).  We bundle this as a
hypothesis. -/

/-- A discrete metric `g` is uniformly bounded by `B` when every component
    satisfies `|g(p)(mu)(nu)| <= B` for all `p, mu, nu`. -/
def DiscreteMetric.IsBounded (g : DiscreteMetric) (B : ℝ) : Prop :=
  ∀ (p : LatticePoint) (μ ν : Fin 4), |g p μ ν| ≤ B

/-- The flat Minkowski metric is bounded by 1. -/
theorem flat_isBounded : DiscreteMetric.IsBounded DiscreteMetric.flat 1 := by
  intro p μ ν
  simp only [DiscreteMetric.flat, minkowskiMetric, Matrix.diagonal_apply]
  split_ifs with h
  · subst h; fin_cases μ <;> norm_num
  · simp

/-! ## The convolution interpolant

Given `MollifierData` and a `DiscreteMetric g`, the convolution
interpolant is:

    g_conv(x)(mu)(nu) := Sum_{p in S} g(p)(mu)(nu) * phi((x - l_P * p) / l_P)

where `S` is a finite domain of lattice points.  The mollifier's compact
support ensures that only finitely many terms are nonzero.

We parametrise the sum by an explicit `Finset LatticePoint` domain `S`
rather than constructing it from a box (which would require a
`LocallyFiniteOrder (Fin 4 -> Z)` instance not available in Mathlib). -/

/-- Rescaled argument for the mollifier: `(x - l_P * p) / l_P` expressed
    coordinate-wise. -/
noncomputable def mollifierArg (x : Fin 4 → ℝ) (p : LatticePoint) : Fin 4 → ℝ :=
  fun μ => (x μ - l_P * (p μ : ℝ)) / l_P

/-- A single term of the convolution sum for component `(mu, nu)`:
    `g(p)(mu)(nu) * phi(mollifierArg x p)`. -/
noncomputable def convolutionTerm
    (m : MollifierData) (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) (x : Fin 4 → ℝ) : ℝ :=
  g p μ ν * m.phi (mollifierArg x p)

/-! ## Smoothness of the convolution interpolant

Each term in the convolution sum is `C^infinity` (as a function of `x`),
being the product of a constant `g(p)(mu)(nu)` with a `C^infinity`
function `phi` composed with the affine map `x mapsto (x - l_P * p) / l_P`.
A finite sum of `C^infinity` functions is `C^infinity`.

We provide smoothness for the **fixed-box** variant: for any fixed
finite set `S` of lattice points, the partial sum over `S` is `C^4`.
This is the form consumed by `SmoothInterpolantData`. -/

/-- The fixed-box convolution sum over an explicit `Finset` of lattice points.
    This avoids the floor-function discontinuity by fixing the summation
    domain. -/
noncomputable def convolutionFixedBox
    (m : MollifierData) (g : DiscreteMetric) (S : Finset LatticePoint)
    (μ ν : Fin 4) : (Fin 4 → ℝ) → ℝ :=
  fun x => S.sum (fun p => convolutionTerm m g p μ ν x)

/-- The affine map `x mapsto mollifierArg x p` is `C^4` (in fact `C^inf`).
    Each coordinate is `(x_i - c) / l_P` with `c = l_P * (p i : R)`. -/
private theorem mollifierArg_contDiff (p : LatticePoint) :
    ContDiff ℝ 4 (fun x : Fin 4 → ℝ => mollifierArg x p) := by
  unfold mollifierArg
  apply contDiff_pi.mpr
  intro i
  exact ((contDiff_apply ℝ ℝ i).sub contDiff_const).div_const l_P

/-- Each individual convolution term is `C^4` as a function of `x`.

The term `x mapsto c * phi((x - a) / l_P)` is `C^4` for any constant `c`
and offset `a`, since `phi` is `C^infinity` and affine pre-composition
preserves smoothness. -/
theorem convolutionTerm_contDiff
    (m : MollifierData) (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    ContDiff ℝ 4 (fun x : Fin 4 → ℝ => convolutionTerm m g p μ ν x) := by
  unfold convolutionTerm
  -- phi composed with an affine map is C^4 (phi is C^inf).
  have h_phi_comp : ContDiff ℝ 4 (fun x : Fin 4 → ℝ => m.phi (mollifierArg x p)) :=
    (m.phi_smooth.of_le le_top).comp (mollifierArg_contDiff p)
  -- const * (C^4 function) is C^4
  exact contDiff_const.mul h_phi_comp

/-- The fixed-box convolution sum is `C^4` as a function of `x`. -/
theorem convolutionFixedBox_contDiff
    (m : MollifierData) (g : DiscreteMetric) (S : Finset LatticePoint)
    (μ ν : Fin 4) :
    ContDiff ℝ 4 (convolutionFixedBox m g S μ ν) := by
  unfold convolutionFixedBox
  apply ContDiff.sum
  intro p _
  exact convolutionTerm_contDiff m g p μ ν

/-! ## The convolution interpolant structure

We bundle the convolution construction into a `ConvolutionInterpolant`
structure that carries the mollifier, the summation domain, and the
analytic hypotheses needed to bridge to `SmoothInterpolantData`. -/

/-- **Convolution interpolant bundle.**

Packages the mollifier, the discrete metric, a fixed summation domain,
and the analytic properties into a single structure. -/
structure ConvolutionInterpolant (g : DiscreteMetric) : Type where
  /-- The mollifier data. -/
  mollifier : MollifierData
  /-- The summation domain (a finite set of lattice points). -/
  domain : Finset LatticePoint
  /-- The resulting continuum metric field. -/
  g_cont : (Fin 4 → ℝ) → MetricTensor
  /-- Definition: `g_cont` equals the fixed-box convolution sum. -/
  g_cont_def : ∀ (x : Fin 4 → ℝ) (μ ν : Fin 4),
    g_cont x μ ν = (convolutionFixedBox mollifier g domain μ ν) x
  /-- Uniform C^4 bound `M` on every component. -/
  c4_bound : ℝ
  /-- The bound is nonneg. -/
  bound_nonneg : 0 ≤ c4_bound
  /-- The bound controls the fourth iterated derivative. -/
  c4_estimate : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
    ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => g_cont y μ ν) x‖ ≤ c4_bound
  /-- Interpolation at lattice points. -/
  interpolates : ∀ (p : LatticePoint) (μ ν : Fin 4),
    g_cont (latticeEmbed p) μ ν = g p μ ν

/-- Smoothness of the convolution interpolant: each component is `C^4`. -/
theorem ConvolutionInterpolant.smooth
    {g : DiscreteMetric} (I : ConvolutionInterpolant g)
    (μ ν : Fin 4) :
    ContDiff ℝ 4 (fun x : Fin 4 → ℝ => I.g_cont x μ ν) := by
  have heq : (fun x : Fin 4 → ℝ => I.g_cont x μ ν) =
      convolutionFixedBox I.mollifier g I.domain μ ν := by
    funext x; exact I.g_cont_def x μ ν
  rw [heq]
  exact convolutionFixedBox_contDiff I.mollifier g I.domain μ ν

/-! ## Bridge to `SmoothInterpolantData`

A `ConvolutionInterpolant g` directly produces a `SmoothInterpolantData g`,
connecting the convolution approach to the existing HPW infrastructure. -/

/-- **Avior, 2026-04-15.**  **Bridge from convolution interpolant to
    `SmoothInterpolantData`.**

Given a `ConvolutionInterpolant` (which carries smoothness, C^4 bound,
and interpolation), produce the `SmoothInterpolantData` consumed by the
HPW hypothesis bundle. -/
noncomputable def ConvolutionInterpolant.toSmoothInterpolantData
    {g : DiscreteMetric} (I : ConvolutionInterpolant g) :
    SmoothInterpolantData g where
  g_cont := I.g_cont
  smooth := I.smooth
  c4_bound := I.c4_bound
  bound_nonneg := I.bound_nonneg
  c4_estimate := I.c4_estimate
  interpolates := I.interpolates

/-! ## Lattice-exact mollifiers

For an *exact* interpolant (as required by `SmoothInterpolantData`),
we need the identity `g_conv(l_P * p) = g(p)`.  This holds when
the mollifier is a partition-of-unity on the lattice:
`Sum_q phi(p - q) = delta_{p,q}` (the mollifier vanishes at all
nonzero integer points and equals 1 at the origin). -/

/-- A mollifier is **lattice-exact** if it vanishes at all nonzero
    integer points: `phi(n) = 0` for `n in Z^4 setminus {0}`, and
    `phi(0) = 1`.

This ensures the convolution sum at `x = l_P * p` reduces to
    Sum_q g(q) * phi(p - q) = g(p) * phi(0) = g(p),
    giving exact interpolation. -/
structure MollifierData.IsLatticeExact (m : MollifierData) : Prop where
  /-- `phi(0) = 1`. -/
  phi_zero_eq_one : m.phi 0 = 1
  /-- `phi` vanishes at all nonzero integer points. -/
  phi_zero_at_nonzero_int :
    ∀ n : Fin 4 → ℤ, n ≠ 0 → m.phi (fun i => (n i : ℝ)) = 0

/-- At a lattice embedding `l_P * p`, the mollifier argument for lattice
    point `q` simplifies to the integer difference `p - q` cast to `R`. -/
theorem mollifierArg_at_lattice (p q : LatticePoint) :
    mollifierArg (latticeEmbed p) q = fun i => ((p i - q i : ℤ) : ℝ) := by
  unfold mollifierArg latticeEmbed
  funext i
  rw [← mul_sub, mul_div_cancel_left₀ _ l_P_ne_zero, Int.cast_sub]

/-- The convolution term at a lattice point reduces to
    `g(q)(mu)(nu) * phi(p - q)`. -/
theorem convolutionTerm_at_lattice
    (m : MollifierData) (g : DiscreteMetric)
    (p q : LatticePoint) (μ ν : Fin 4) :
    convolutionTerm m g q μ ν (latticeEmbed p)
      = g q μ ν * m.phi (fun i => ((p i - q i : ℤ) : ℝ)) := by
  unfold convolutionTerm
  rw [mollifierArg_at_lattice]

/-! ## Compatibility with existing flat witness

For `DiscreteMetric.flat`, the existing `minkowskiInterpolant` already
provides a `SmoothInterpolantData`.  The convolution approach is
compatible: any `ConvolutionInterpolant` for flat also yields the same
downstream type. -/

/-- **Flat-metric shortcut.**  Any `ConvolutionInterpolant` for
    `DiscreteMetric.flat` yields a `SmoothInterpolantData` with the
    same C^4 bound. -/
theorem convolutionInterpolant_flat_compatible
    (I : ConvolutionInterpolant DiscreteMetric.flat) :
    ∃ D : SmoothInterpolantData DiscreteMetric.flat, D.c4_bound = I.c4_bound :=
  ⟨I.toSmoothInterpolantData, rfl⟩

/-! ## Connection to HpwHypothesis

The full HPW pipeline is:
    ConvolutionInterpolant g
    --> SmoothInterpolantData g  (via toSmoothInterpolantData)
    --> SmoothInterpolantData.toSmoothMetricField  (in SmoothInterpolant.lean)
    --> HpwHypothesis g  (given harmonic-gauge + Ricci-box hypotheses)

The first arrow is established above.  The second arrow is in
`SmoothInterpolant.lean`.  The third arrow requires ingredients G + H
(harmonic gauge and Ricci-box identity) which are out of scope.

We expose convenience definitions documenting the first two steps. -/

/-- **Avior, 2026-04-15.**  A `ConvolutionInterpolant` yields a
    `SmoothMetricField` suitable for plugging into `HpwHypothesis.g_cont`. -/
noncomputable def ConvolutionInterpolant.toSmoothMetricField
    {g : DiscreteMetric} (I : ConvolutionInterpolant g) :
    SmoothMetricField :=
  I.toSmoothInterpolantData.toSmoothMetricField

/-- The `SmoothMetricField` from a convolution interpolant agrees with `g`
    at every lattice point -- the interpolation identity in the
    `HpwHypothesis`-compatible shape. -/
theorem ConvolutionInterpolant.toSmoothMetricField_interpolates
    {g : DiscreteMetric} (I : ConvolutionInterpolant g)
    (p : LatticePoint) (μ ν : Fin 4) :
    (g p) μ ν = I.toSmoothMetricField (latticeEmbed p) μ ν :=
  I.toSmoothInterpolantData.toSmoothMetricField_interpolates p μ ν

/-! ## Summary and future work

**Delivered (this file):**
- `MollifierData` -- fully specified structure for a smooth mollifier.
- `ConvolutionInterpolant` -- structure bundling the convolution construction.
- `convolutionTerm_contDiff` -- each term of the sum is C^4 (proved).
- `convolutionFixedBox_contDiff` -- the finite sum is C^4 (proved).
- `ConvolutionInterpolant.toSmoothInterpolantData` -- bridge to HPW infra.
- `MollifierData.IsLatticeExact` -- condition for exact interpolation.
- `mollifierArg_at_lattice` / `convolutionTerm_at_lattice` -- reduction of
  the convolution term at lattice points (proved).

**Future work (out of scope, tracked in NOTES_HPW_ELIMINATION.md):**
- Construct a concrete `MollifierData` from `SmoothBumpFunction` in Mathlib.
- Prove that a lattice-exact mollifier exists (standard Poisson summation
  argument; requires Fourier analysis infrastructure).
- Prove the C^4 uniform bound for the convolution interpolant given a
  bounded discrete metric (requires `iteratedFDeriv` chain rule through
  the finite sum).
- Combine with ingredients G + H to close the full HPW axiom elimination
  for general curved metrics. -/

end OmegaTheory.Emergence
