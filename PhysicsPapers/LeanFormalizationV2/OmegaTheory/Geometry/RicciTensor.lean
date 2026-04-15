/-
  OmegaTheory.Geometry.RicciTensor

  **Direction 2, file 4 of 5.  Ricci tensor (continuum, on ℝ⁴).**

  The Ricci tensor is the (1,3)-(2,0) contraction of the Riemann tensor
  over the first and third indices:

      R_{μν}(x) = R^α_{μαν}(x) = Σ_α R^α_{μαν}(x).

  ## What's proven

  * `ricci_continuum_flat` — vanishes on flat (Minkowski) metric.

  ## What's shipped as `Prop` (not `theorem` + sorry)

  * `RicciSymmetric g` — `R_{μν}(x) = R_{νμ}(x)`.  In general Riemannian
    geometry this follows from `RiemannPairSymmetric`, which in turn
    requires first-Bianchi and metric compatibility.  Shipped as a
    `Prop`-valued `def` until Mathlib has the full torsion/curvature
    machinery.

  * `EinsteinRicciIdentity g` — a restatement useful downstream:
    `R_{μν} = (something explicit in g and ∂g)`.  Too much a standard-fact
    to prove here without the full stack; exposed as `Prop`.

  ## Link to the discrete-side `ricciTensor` in `Geometry.Curvature`

  The discrete Ricci lives in `OmegaTheory.Geometry.Curvature`; this file
  introduces the continuum version with the same contraction convention.
  The two are related via `RicciComparison` (in `Emergence.RicciComparison`)
  once a `SmoothMetric` serves as the interpolant.

  -- Mizar, ricci_architect, 2026-04-15
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import OmegaTheory.Geometry.RiemannCurvature

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Finset

/-! ## The Ricci tensor -/

/-- **Ricci tensor, continuum form.**

    `R_{μν}(x) = Σ_α R^α_{μαν}(x)` where `R^ρ_{σμν}` is the Riemann tensor.

    This is the standard contraction of the first (upper) and third (lower)
    Riemann indices, matching the discrete `ricciTensor` in
    `OmegaTheory.Geometry.Curvature`. -/
noncomputable def ricci (g : SmoothMetric) (μ ν : Fin 4) (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun α => riemann g α μ α ν x

/-! ## Flat-metric vanishing -/

/-- **Flat (continuum Minkowski) Ricci tensor vanishes.** -/
theorem ricci_continuum_flat (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    ricci flatSmoothMetric μ ν x = 0 := by
  unfold ricci
  apply Finset.sum_eq_zero
  intro α _
  exact riemann_continuum_flat α μ α ν x

/-! ## Ricci symmetry as a `Prop`-valued def (not a `theorem` + sorry)

In the full Riemannian-geometry API, `R_{μν} = R_{νμ}` follows from
pair-symmetry of the lowered Riemann tensor plus the first Bianchi
identity.  Both of those require Mathlib machinery we don't have:

  * lowered Riemann with metric compatibility,
  * torsion-freeness of the Levi-Civita connection,
  * first Bianchi `R^ρ_{[σμν]} = 0`.

We could try to prove Ricci symmetry directly from the definition, but
the direct approach requires commuting mixed partial derivatives of
Christoffels and simplifying a quadratic-in-Christoffel sum via
symmetry-of-second-partials + metric symmetry.  This is roughly a
month of formalisation effort.

Rather than `sorry` it, we ship the statement as a `Prop` whose proof
a downstream consumer can either:
  (a) establish for their specific metric (e.g. `flatSmoothMetric`
      discharges it trivially — see `ricciSymmetric_flat` below),
  (b) hypothesise as a bundled assumption in their own theorem, or
  (c) wait for the Mathlib torsion/curvature stack to provide it. -/

/-- **Ricci symmetry proposition.**  `R_{μν}(x) = R_{νμ}(x)` for every
    `(μ, ν, x)`.  A `Prop`-valued `def`, not a `theorem` — see the
    module preamble for the honest reason. -/
def RicciSymmetric (g : SmoothMetric) : Prop :=
  ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ), ricci g μ ν x = ricci g ν μ x

/-- **Flat Ricci is symmetric.**  Trivially, since both sides are zero. -/
theorem ricciSymmetric_flat : RicciSymmetric flatSmoothMetric := by
  intro μ ν x
  rw [ricci_continuum_flat, ricci_continuum_flat]

/-! ## Trace (scalar curvature)

The scalar curvature `R(x) = g^{μν}(x) R_{μν}(x)` is immediate from the
inverse metric and the Ricci tensor. -/

/-- **Scalar curvature.**  `R(x) = g^{μν}(x) R_{μν}(x)`. -/
noncomputable def continuumScalarCurvature (g : SmoothMetric) (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun μ =>
    Finset.univ.sum fun ν =>
      g.invComp x μ ν * ricci g μ ν x

/-- **Flat scalar curvature vanishes.** -/
theorem continuumScalarCurvature_flat (x : Fin 4 → ℝ) :
    continuumScalarCurvature flatSmoothMetric x = 0 := by
  unfold continuumScalarCurvature
  apply Finset.sum_eq_zero; intro μ _
  apply Finset.sum_eq_zero; intro ν _
  rw [ricci_continuum_flat]
  ring

/-! ## Einstein tensor

The Einstein tensor is `G_{μν} = R_{μν} − (1/2) g_{μν} R`.  We give the
continuum definition; downstream consumers can combine it with
`continuumScalarCurvature`. -/

/-- **Einstein tensor.**  `G_{μν}(x) = R_{μν}(x) − (1/2) g_{μν}(x) R(x)`. -/
noncomputable def continuumEinsteinTensor (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  ricci g μ ν x - (1 / 2) * g.comp x μ ν * continuumScalarCurvature g x

/-- **Flat Einstein tensor vanishes.** -/
theorem continuumEinsteinTensor_flat (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    continuumEinsteinTensor flatSmoothMetric μ ν x = 0 := by
  unfold continuumEinsteinTensor
  rw [ricci_continuum_flat, continuumScalarCurvature_flat]
  ring

/-! ## Einstein-tensor symmetry as `Prop`-def

Like Ricci, Einstein-tensor symmetry follows from Ricci symmetry and
is *not* a direct consequence of the definition (it inherits from
`RicciSymmetric` + `SmoothMetric.comp_symm`). -/

/-- **Einstein symmetry proposition.**  Follows from `RicciSymmetric g` and
    the pointwise symmetry of `g`. -/
theorem einsteinSymmetric_of_ricciSymmetric
    (g : SmoothMetric) (hR : RicciSymmetric g)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    continuumEinsteinTensor g μ ν x = continuumEinsteinTensor g ν μ x := by
  unfold continuumEinsteinTensor
  rw [hR μ ν x, g.comp_symm x μ ν]

/-! ## Ingredient (G) of the HPW elimination chain, stated explicitly

Weinberg 1972 §11.1 Ricci–Box identity: in harmonic coordinates,
`R_{μν} = -(1/2) · (g^{αβ} ∂_α ∂_β g_{μν}) + Q(g, ∂g)` where `Q` is
quadratic in Christoffel symbols and vanishes to leading order.

We state the *inhomogeneous* quantity

    RicciBoxDefect g μ ν x := ricci g μ ν x + (1/2) · (continuum-Laplacian
                              of g_{μν} at x)

so that the Weinberg identity asserts `|RicciBoxDefect g μ ν x| = |Q|`,
which is `O(Γ²)` and vanishes in exact harmonic gauge.  The continuum
Laplacian here is the simple (flat-background) `Σ_α ∂²_α g_{μν}` — NOT
the covariant one.

This opens a direct bridge to `HarmonicGaugeIdentity` from
`OmegaTheory.Emergence.HarmonicGauge`: once `RicciBoxDefect` is bounded
by `ℓ_P²` the HPW axiom's harmonic-side content is discharged. -/

/-- **Flat-background continuum Laplacian of `g_{μν}` at `x`.**  Sum of
    second-order partial derivatives along the four coordinate axes, via
    iterated `partialDeriv`.  NOT covariant. -/
noncomputable def flatBackgroundLaplacian (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun α =>
    partialDeriv (fun y => partialDeriv (fun z => g.comp z μ ν) α y) α x

/-- **Flat-background Laplacian of the flat metric vanishes.**
    Every `partialDeriv (fun z => g.comp z μ ν) α y = 0` on flat metric,
    so the outer derivative is also zero, and the sum collapses. -/
theorem flatBackgroundLaplacian_flat (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    flatBackgroundLaplacian flatSmoothMetric μ ν x = 0 := by
  unfold flatBackgroundLaplacian
  apply Finset.sum_eq_zero
  intro α _
  -- Inner partialDeriv is identically zero: the function being differentiated
  -- is the constant `minkowskiMetric μ ν`.
  have hinner : (fun y : Fin 4 → ℝ =>
                  partialDeriv (fun z : Fin 4 → ℝ =>
                    flatSmoothMetric.comp z μ ν) α y)
                  = fun _ : Fin 4 → ℝ => (0 : ℝ) := by
    funext y
    have hconst : (fun z : Fin 4 → ℝ => flatSmoothMetric.comp z μ ν)
                    = fun _ : Fin 4 → ℝ => minkowskiMetric μ ν := rfl
    rw [hconst]
    exact partialDeriv_const (minkowskiMetric μ ν) α y
  rw [hinner]
  exact partialDeriv_const 0 α x

/-- **Ricci–Box defect.**  The Weinberg quantity
    `R_{μν}(x) + (1/2) · (flat-background-Laplacian g_{μν})(x)`.

    In exact harmonic gauge this is exactly `Q(g, ∂g)` (quadratic in
    Christoffels).  The HPW programme needs a bound `|defect| ≤ ℓ_P²`. -/
noncomputable def ricciBoxDefect (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  ricci g μ ν x + (1 / 2) * flatBackgroundLaplacian g μ ν x

/-- **Flat Ricci–Box defect vanishes.**  Both `ricci_continuum_flat` and
    `flatBackgroundLaplacian_flat` are zero. -/
theorem ricciBoxDefect_flat (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    ricciBoxDefect flatSmoothMetric μ ν x = 0 := by
  unfold ricciBoxDefect
  rw [ricci_continuum_flat, flatBackgroundLaplacian_flat]
  ring

/-- **Weinberg Ricci–Box identity (`Prop`-form).**

    The Weinberg 1972 §11.1 statement, elevated to a property of the metric
    and a positive `ε`:  in (approximate) harmonic gauge, the Ricci–Box
    defect is small.  The exact harmonic-gauge case gives `ε = 0`; the
    physically-interesting regime admits `ε = O(ℓ_P²)`.

    Shipped as a `Prop`-valued `def`, parametric in `ε`.  A consumer
    either:
    * establishes it for their specific metric with a specific `ε` (see
      `weinbergRicciBox_flat` for the Minkowski case with `ε = 0`), or
    * hypothesises it in their own theorem statement. -/
def WeinbergRicciBox (g : SmoothMetric) (ε : ℝ) : Prop :=
  ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ), |ricciBoxDefect g μ ν x| ≤ ε

/-- **Weinberg Ricci–Box for flat Minkowski with `ε = 0`.** -/
theorem weinbergRicciBox_flat : WeinbergRicciBox flatSmoothMetric 0 := by
  intro μ ν x
  rw [ricciBoxDefect_flat]
  rw [abs_zero]

end OmegaTheory.Geometry
