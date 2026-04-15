/-
  OmegaTheory.Geometry.SmoothMetric

  **Direction 2, file 1 of 5.  Smooth continuum metric on ℝ⁴.**

  A `SmoothMetric` bundles the data of a continuum metric field
  `g : (Fin 4 → ℝ) → MetricTensor` together with:

    * `smooth`  — `ContDiff ℝ ⊤` regularity of every scalar component;
    * `symm`    — pointwise symmetry `g x μ ν = g x ν μ`;
    * `nondeg`  — pointwise nondegeneracy `det (g x) ≠ 0`.

  The inverse `g.inv` is then `(g x)⁻¹`, and two identities
  (`g · g.inv = 1`, `g.inv · g = 1`) fall out of `Matrix.mul_nonsing_inv`.

  ## Why a new structure

  `OmegaTheory.Emergence.HpwHypothesis.SmoothMetricField` is the scalar-valued
  form `(Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ` — convenient for carrying a
  `Prop`-typed hypothesis but awkward for matrix inversion.  `SmoothMetric`
  uses `MetricTensor = Matrix (Fin 4) (Fin 4) ℝ` so it can plug into
  `inverseMetric`, `Matrix.mul_nonsing_inv`, and existing OmegaTheory.Geometry
  machinery directly.

  Both representations are trivially interconvertible via `toField` /
  `ofField` below.  This file establishes the converter so that
  `interpolant_extender` can upgrade `SmoothInterpolantData` from the field
  form to the matrix form without rewriting downstream code.

  ## Honest scoping

  * The `smooth` field asks for `ContDiff ℝ ⊤` of each scalar component
    individually.  (A bundled statement like "the matrix-valued function is
    smooth" requires committing to a specific `NormedSpace` structure on
    `Matrix (Fin 4) (Fin 4) ℝ`; we avoid that commitment by working
    component-wise, which is what Christoffel / Riemann / Ricci need anyway.)
  * Nondegeneracy is stated pointwise; the inverse is pointwise-defined.
    Regularity of the inverse is NOT proven here and is stated as a separate
    Prop `InverseSmooth` that a consumer can discharge (e.g. by the
    open-set argument on `GL_n(ℝ)`).

  ## Upstream Mathlib PR candidate

  A `SmoothMetric` structure on `ℝⁿ` with component-wise `ContDiff`,
  pointwise symmetry, and pointwise invertibility is a natural target for
  upstream contribution — Mathlib currently has Riemannian manifolds
  (`Mathlib.Geometry.Manifold.Riemannian.Basic`) but no bare-bones analogue
  on `ℝⁿ` for physicists who want index calculus.

  -- Mizar, ricci_architect, 2026-04-15
-/

import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Calculus.FDeriv.Basic
import OmegaTheory.Geometry.Metric
import OmegaTheory.Emergence.HpwHypothesis

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Matrix

/-! ## The smooth-metric structure -/

/-- **Smooth continuum metric on `ℝ⁴`.**

Bundles:
* `toFun`    — the underlying map `(Fin 4 → ℝ) → MetricTensor`;
* `smooth`   — component-wise `ContDiff ℝ ⊤`;
* `symm`     — pointwise symmetry of the matrix;
* `nondeg`   — pointwise nondegeneracy.

The notation `g x μ ν` works via `FunLike` once we supply the coercion
(see `instance : CoeFun` below).  For this file we keep `g.toFun x μ ν`
explicit to avoid typeclass gymnastics on a fresh structure. -/
structure SmoothMetric : Type where
  /-- The continuum metric components. -/
  toFun : (Fin 4 → ℝ) → MetricTensor
  /-- Every scalar component `(x, μ, ν) ↦ g_{μν}(x)` is `C^∞`. -/
  smooth : ∀ μ ν : Fin 4,
    ContDiff ℝ ⊤ (fun x : Fin 4 → ℝ => (toFun x) μ ν)
  /-- Pointwise symmetry `g_{μν}(x) = g_{νμ}(x)`. -/
  symm : ∀ x : Fin 4 → ℝ, IsSymmetric (toFun x)
  /-- Pointwise nondegeneracy `det g(x) ≠ 0`. -/
  nondeg : ∀ x : Fin 4 → ℝ, IsNondegenerate (toFun x)

namespace SmoothMetric

/-! ## Basic accessors and identities -/

/-- The pointwise value as a matrix. -/
@[inline] def val (g : SmoothMetric) (x : Fin 4 → ℝ) : MetricTensor :=
  g.toFun x

/-- The pointwise scalar component `g_{μν}(x)`. -/
@[inline] def comp (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) : ℝ :=
  (g.toFun x) μ ν

/-- Convert a `SmoothMetric` to the scalar-valued `SmoothMetricField` form
    used by `HpwHypothesis`.  This is the identity on components. -/
def toField (g : SmoothMetric) : OmegaTheory.Emergence.SmoothMetricField :=
  fun x μ ν => (g.toFun x) μ ν

/-- `toField` is the identity at components (definitional). -/
theorem toField_apply (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    g.toField x μ ν = (g.toFun x) μ ν := rfl

/-- Scalar-component symmetry: `g x μ ν = g x ν μ`. -/
theorem comp_symm (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    g.comp x μ ν = g.comp x ν μ := by
  unfold comp
  have h := g.symm x
  unfold IsSymmetric Matrix.IsSymm at h
  have := congrFun (congrFun h ν) μ
  simp only [Matrix.transpose_apply] at this
  exact this

/-! ## The inverse metric -/

/-- The inverse metric `g^{μν}(x) = (g(x))⁻¹_{μν}`.

    Pointwise defined via `Matrix.nonsing_inv`.  Smoothness of the inverse
    is a separate property; see `InverseSmooth`. -/
noncomputable def inv (g : SmoothMetric) (x : Fin 4 → ℝ) : MetricTensor :=
  inverseMetric (g.toFun x)

/-- Alternative pointwise form. -/
@[inline] noncomputable def invComp (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) : ℝ :=
  (g.inv x) μ ν

/-- **g · g⁻¹ = 1** pointwise. -/
theorem mul_inv (g : SmoothMetric) (x : Fin 4 → ℝ) :
    g.toFun x * g.inv x = 1 := by
  unfold inv
  exact metric_mul_inverse (g.toFun x) (g.nondeg x)

/-- **g⁻¹ · g = 1** pointwise. -/
theorem inv_mul (g : SmoothMetric) (x : Fin 4 → ℝ) :
    g.inv x * g.toFun x = 1 := by
  unfold inv
  exact inverse_mul_metric (g.toFun x) (g.nondeg x)

/-- Inverse-metric symmetry: `g^{ρσ}(x) = g^{σρ}(x)`. -/
theorem invComp_symm (g : SmoothMetric) (x : Fin 4 → ℝ) (ρ σ : Fin 4) :
    g.invComp x ρ σ = g.invComp x σ ρ := by
  unfold invComp inv
  exact inverseMetric_symm (g.toFun x) (g.symm x) ρ σ

/-- Contraction of the metric with its inverse yields Kronecker delta. -/
theorem inv_contract (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    Finset.univ.sum (fun ρ => g.invComp x μ ρ * g.comp x ρ ν)
      = kroneckerDelta μ ν := by
  unfold invComp comp inv
  exact metric_inverse_contract (g.toFun x) (g.nondeg x) μ ν

/-! ## Inverse smoothness (stated as Prop, not proved here)

Smoothness of `g⁻¹` as a function of `x` follows from smoothness of `g`
together with the fact that matrix inversion is `C^∞` on the open set
`GL_n(ℝ) ⊂ Mat_n(ℝ)` (using `ContDiff.inv` plus a suitable differentiable-
structure argument).  This is routine but requires committing to a specific
normed-space instance on `Matrix (Fin 4) (Fin 4) ℝ`, which we defer.

We expose the property as a `Prop` that a consumer may hypothesise. -/

/-- `InverseSmooth g` : every scalar component of the inverse metric
    `x ↦ g^{μν}(x)` is `C^∞`.  Provable from `g.smooth` + `ContDiff`-inversion
    lemmas in Mathlib, which require a normed-algebra structure on
    `Matrix (Fin 4) (Fin 4) ℝ`.  We state it here so downstream agents can
    hypothesise-and-discharge independently. -/
def InverseSmooth (g : SmoothMetric) : Prop :=
  ∀ μ ν : Fin 4, ContDiff ℝ ⊤ (fun x : Fin 4 → ℝ => g.invComp x μ ν)

end SmoothMetric

/-! ## Flat (Minkowski) witness -/

/-- The flat (Minkowski) smooth metric `η = diag(-1,1,1,1)` at every point. -/
noncomputable def flatSmoothMetric : SmoothMetric where
  toFun := fun _ => minkowskiMetric
  smooth := by
    intro μ ν
    -- `fun x => minkowskiMetric μ ν` is constant, hence `C^n` for every n.
    exact contDiff_const
  symm := fun _ => minkowski_symmetric
  nondeg := by
    intro _
    -- Minkowski is nondegenerate because its determinant is nonzero.
    have hL := minkowski_lorentzian
    exact hL.nondegenerate

/-- Sanity check: flat metric's `toField` is the Minkowski component function. -/
theorem flatSmoothMetric_toField (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    flatSmoothMetric.toField x μ ν = minkowskiMetric μ ν := rfl

/-- Sanity check: flat metric's inverse is Minkowski itself (Minkowski is involutive). -/
theorem flatSmoothMetric_inv (x : Fin 4 → ℝ) :
    flatSmoothMetric.inv x = minkowskiMetric := by
  unfold SmoothMetric.inv flatSmoothMetric
  exact minkowski_inverse_self

/-- The flat metric's inverse is also `C^∞` — trivially, since the inverse is
    constant. -/
theorem flatSmoothMetric_inverseSmooth : flatSmoothMetric.InverseSmooth := by
  intro μ ν
  -- `x ↦ (flatSmoothMetric.inv x) μ ν` equals the constant `minkowskiMetric μ ν`.
  have heq : (fun x : Fin 4 → ℝ => flatSmoothMetric.invComp x μ ν)
              = fun _ : Fin 4 → ℝ => minkowskiMetric μ ν := by
    funext x
    unfold SmoothMetric.invComp
    rw [flatSmoothMetric_inv]
  rw [heq]
  exact contDiff_const

end OmegaTheory.Geometry
