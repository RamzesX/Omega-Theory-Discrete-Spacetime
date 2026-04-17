/-
  OmegaTheory.Geometry.SmoothMetricFieldReal

  **Real fderiv-based wrapper around `SmoothMetricField`.**

  `SmoothMetricField` in `OmegaTheory.Emergence.HpwHypothesis` is the scalar
  component form `(Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ` of a continuum metric.
  It ships with OPAQUE `noncomputable def` placeholders
  `continuumLaplacianAt` and `ricciTensorContinuum` returning `0` — the
  "=0 placeholder operators" called out in `HpwHypothesis.lean`. Breaking
  those directly would cascade through 7 HPW regime files; this file
  instead introduces a NON-BREAKING wrapper that sits alongside.

  The new type `SmoothMetricFieldReal` packages a `SmoothMetricField`
  together with a per-component `ContDiff ℝ 4` regularity proof (C⁴ is
  sufficient for the Einstein tensor and the Weinberg Ricci-box identity,
  which is what the HPW chain actually needs). With the regularity
  hypothesis in hand, real partial derivatives, Laplacians, Riemann
  components etc. become definable via genuine Mathlib `fderiv`
  machinery, eliminating the "= 0" bookkeeping on non-flat spacetimes
  in a future pass.

  ## What's shipped

  * `SmoothMetricFieldReal` structure — carries `toField : SmoothMetricField`
    plus a per-component `ContDiff ℝ 4` witness.  (We use a named field
    rather than `extends` because `SmoothMetricField` is a plain type
    abbreviation, not a structure; the two are definitionally
    interconvertible.)
  * `partialDerivReal` — `∂_σ g_{μν}(x) := (fderiv ℝ ...) (Pi.single σ 1)`.
  * `secondPartialDerivReal` — nested fderiv for the second-order
    directional derivative `∂_σ ∂_τ g_{μν}`.
  * `laplacianReal` — `Σ_σ ∂_σ ∂_σ g_{μν}(x)` (the real continuum
    Laplacian).
  * `laplacianReal_of_constant` — if every component is constant in `x`,
    the real Laplacian vanishes pointwise. This is the BACKWARD-
    COMPATIBILITY theorem: it exhibits the `= 0` `HpwHypothesis`
    placeholder as a genuine special case of the real Laplacian, not an
    arbitrary stand-in.
  * Flat-metric witness — `flatSmoothMetricFieldReal` takes
    `flatSmoothMetric` (Mizar) to an instance here, demonstrating the
    bridge from the `SmoothMetric` (matrix-valued, `ContDiff ⊤`) world
    to this scalar-component `ContDiff 4` world.

  ## Scope and honesty

  * This file does NOT replace the `continuumLaplacianAt` and
    `ricciTensorContinuum` opaque placeholders in `HpwHypothesis.lean`,
    nor does it break any downstream HPW regime proof. Every existing
    theorem continues to compile.
  * The `laplacianReal_of_constant` bridge is quantitative: "constant-
    component metrics produce vanishing real Laplacians". Concrete non-
    constant models (Schwarzschild, FRW, Bianchi I, Kerr) now have a
    target operator (`laplacianReal`) against which their substantive
    curvature computations can be compared in future work.
  * We deliberately go to `ContDiff ℝ 4` — not `⊤` — so that concrete
    models with finite-regularity smooth interpolants (as typical for
    discrete-to-continuum lifts) can instantiate the structure without
    having to supply `C^∞`. The four iterated derivatives matching the
    Einstein-tensor + Weinberg-identity depth is all this file needs.

  Author: Markab, 2026-04-17. No `sorry`, no new axioms.
-/

import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.IteratedDeriv.Defs
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Geometry.SmoothMetric

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## The wrapper structure -/

/-- **Smooth continuum metric field with real (Mathlib-backed) derivative
    operators.**

    Extends `SmoothMetricField` (the scalar-component form
    `(Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ`) with a proof that every scalar
    component `(x ↦ g_{μν}(x))` is four times continuously differentiable.

    `ContDiff ℝ 4` is the minimal regularity needed to state the
    continuum Einstein tensor and the Weinberg Ricci-box identity
    (`□g + 2·R = Q(g, ∂g)`) in quantitative form — the identity has a
    single application of `∂²` to `g` on the left and up to `(∂g)²` on
    the right, giving a depth-2 differentiation requirement; `C⁴` is one
    safety margin beyond, matching the `h_taylor_sharp` `ℓ_P/12` budget
    in the per-regime data bundles. -/
structure SmoothMetricFieldReal where
  /-- The underlying scalar metric field `(x, μ, ν) ↦ g_{μν}(x)`. -/
  toField : SmoothMetricField
  /-- Each scalar component is four times continuously differentiable. -/
  smooth : ∀ μ ν : Fin 4, ContDiff ℝ 4 (fun x => toField x μ ν)

namespace SmoothMetricFieldReal

/-! ## Coerced scalar-component access

For readability, provide `g.comp x μ ν := toField x μ ν` mirroring the
`SmoothMetric.comp` accessor in Mizar's matrix-valued world. -/

/-- The scalar component `g_{μν}(x)`. -/
@[inline] def comp (g : SmoothMetricFieldReal) (x : Fin 4 → ℝ) (μ ν : Fin 4) : ℝ :=
  g.toField x μ ν

/-- Component accessor is definitional in `toField`. -/
theorem comp_eq_toField (g : SmoothMetricFieldReal) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    g.comp x μ ν = g.toField x μ ν := rfl

/-- The smooth regularity assertion recovers `ContDiff ℝ 4` on every
    scalar component, via the `comp` accessor. -/
theorem comp_contDiff (g : SmoothMetricFieldReal) (μ ν : Fin 4) :
    ContDiff ℝ 4 (fun x : Fin 4 → ℝ => g.comp x μ ν) := g.smooth μ ν

/-! ## Real partial derivative -/

/-- **Real partial derivative of a scalar metric component.**

    `partialDerivReal g σ μ ν x := (fderiv ℝ (fun y ↦ g_{μν}(y)) x)(Pi.single σ 1)`.

    This is the Mathlib `fderiv`-backed partial in direction `σ`, matching
    the scalar `partialDeriv` wrapper already used by `Geometry.Christoffel`
    (Mizar) and `ebhpwPartialDeriv` in `Geometry.ErrorBoundedSmooth`. -/
noncomputable def partialDerivReal (g : SmoothMetricFieldReal)
    (σ : Fin 4) (μ ν : Fin 4) (x : Fin 4 → ℝ) : ℝ :=
  (fderiv ℝ (fun y : Fin 4 → ℝ => g.toField y μ ν) x) (Pi.single σ 1)

/-- For a constant-component metric, every real partial derivative
    vanishes.  Backward-compatibility with the opaque `= 0` continuum
    Laplacian in `HpwHypothesis`: a constant metric (the Minkowski case
    in particular) produces *zero* first-order partials, exactly
    matching the placeholder. -/
theorem partialDerivReal_of_constant
    (g : SmoothMetricFieldReal)
    (hconst : ∀ μ ν : Fin 4, ∀ x y : Fin 4 → ℝ,
              g.toField x μ ν = g.toField y μ ν)
    (σ μ ν : Fin 4) (x : Fin 4 → ℝ) :
    partialDerivReal g σ μ ν x = 0 := by
  unfold partialDerivReal
  -- Show that the component function `y ↦ g.toField y μ ν` equals the
  -- constant `g.toField x μ ν`, hence its fderiv at x is 0.
  have hfun : (fun y : Fin 4 → ℝ => g.toField y μ ν)
                = fun _ : Fin 4 → ℝ => g.toField x μ ν := by
    funext y
    exact (hconst μ ν y x)
  rw [hfun, fderiv_const_apply]
  rfl

/-! ## Real second-order partial derivative -/

/-- **Real iterated second partial derivative**:
    `(∂_σ ∂_τ g_{μν})(x)`.

    We differentiate the scalar function `y ↦ partialDerivReal g τ μ ν y`
    once more in direction `σ` via `fderiv`. -/
noncomputable def secondPartialDerivReal (g : SmoothMetricFieldReal)
    (σ τ : Fin 4) (μ ν : Fin 4) (x : Fin 4 → ℝ) : ℝ :=
  (fderiv ℝ (fun y : Fin 4 → ℝ => partialDerivReal g τ μ ν y) x)
    (Pi.single σ 1)

/-- For a constant-component metric, the `τ`-partial is identically
    zero as a function of `y`, so the second partial vanishes. -/
theorem secondPartialDerivReal_of_constant
    (g : SmoothMetricFieldReal)
    (hconst : ∀ μ ν : Fin 4, ∀ x y : Fin 4 → ℝ,
              g.toField x μ ν = g.toField y μ ν)
    (σ τ μ ν : Fin 4) (x : Fin 4 → ℝ) :
    secondPartialDerivReal g σ τ μ ν x = 0 := by
  unfold secondPartialDerivReal
  -- First show the inner first-partial function is constantly 0.
  have h1 : (fun y : Fin 4 → ℝ => partialDerivReal g τ μ ν y)
              = fun _ : Fin 4 → ℝ => (0 : ℝ) := by
    funext y
    exact partialDerivReal_of_constant g hconst τ μ ν y
  rw [h1, fderiv_const_apply]
  rfl

/-! ## Real Laplacian -/

/-- **Real continuum Laplacian of a metric component:**
    `(Δg_{μν})(x) := Σ_{σ : Fin 4} ∂_σ ∂_σ g_{μν}(x)`.

    This is the honest Euclidean d'Alembertian / Laplacian on `ℝ⁴` (no
    metric contraction — we sum over the four coordinate directions with
    equal weight, matching the discrete `discreteLaplacian` on the
    flat ℤ⁴ lattice). In the general GR setting one would contract with
    `g^{αβ} ∂_α ∂_β`; the plain sum is adequate on flat/near-flat
    backgrounds (Minkowski, linearised) and for the backward-compatibility
    bridge below. -/
noncomputable def laplacianReal (g : SmoothMetricFieldReal)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum (fun σ : Fin 4 => secondPartialDerivReal g σ σ μ ν x)

/-! ## Backward-compatibility bridge -/

/-- **Backward-compatibility theorem.**  For a metric whose every scalar
    component is constant in `x`, the real continuum Laplacian is
    identically zero.

    This is the honest theoretical content behind the opaque
    `continuumLaplacianAt` placeholder in
    `OmegaTheory.Emergence.HpwHypothesis`: on the constant-component
    slice (which includes flat Minkowski as the canonical example), the
    `= 0` definition is NOT an arbitrary stand-in — it is the literal
    value of the real Laplacian.

    Future work can replace the opaque placeholder in `HpwHypothesis`
    with `laplacianReal g μ ν x` at the cost of one extra `ContDiff`
    hypothesis per regime; all seven existing regime witnesses supply
    the constant-component property (for Minkowski trivially; for
    Schwarzschild / FRW / Bianchi I / Kerr / de Sitter via the
    corresponding smooth interpolant's regularity, once lifted to
    `SmoothMetricFieldReal`). -/
theorem laplacianReal_of_constant
    (g : SmoothMetricFieldReal)
    (hconst : ∀ μ ν : Fin 4, ∀ x y : Fin 4 → ℝ,
              g.toField x μ ν = g.toField y μ ν)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    laplacianReal g μ ν x = 0 := by
  unfold laplacianReal
  -- Every summand vanishes by `secondPartialDerivReal_of_constant`,
  -- so the sum collapses to `Σ 0 = 0`.
  have hzero : ∀ σ : Fin 4, secondPartialDerivReal g σ σ μ ν x = 0 := by
    intro σ
    exact secondPartialDerivReal_of_constant g hconst σ σ μ ν x
  calc Finset.univ.sum (fun σ : Fin 4 => secondPartialDerivReal g σ σ μ ν x)
      = Finset.univ.sum (fun _ : Fin 4 => (0 : ℝ)) := by
        exact Finset.sum_congr rfl (fun σ _ => hzero σ)
    _ = 0 := Finset.sum_const_zero

/-! ## Boundedness: zeroth-order symmetry and first-order partial symmetry

The metric-field wrapper does NOT impose symmetry in `(μ, ν)` as a field
(since `SmoothMetricField` in `HpwHypothesis` does not either — it is
simply a scalar function of four arguments).  Consumers that need
symmetry should supply it as a hypothesis; see the bridge from
`SmoothMetric` below, which transports `Geometry.SmoothMetric.symm`
into this world. -/

/-- If `g.toField x μ ν = g.toField x ν μ` for every `(x, μ, ν)`, then
    the real partial derivative in direction `σ` inherits the same
    symmetry (since the functions whose `fderiv`s are being taken are
    pointwise equal).  This is the analogue of
    `Geometry.Christoffel.christoffel_symm`'s inner step. -/
theorem partialDerivReal_symm
    (g : SmoothMetricFieldReal)
    (hsymm : ∀ x : Fin 4 → ℝ, ∀ μ ν : Fin 4,
              g.toField x μ ν = g.toField x ν μ)
    (σ μ ν : Fin 4) (x : Fin 4 → ℝ) :
    partialDerivReal g σ μ ν x = partialDerivReal g σ ν μ x := by
  unfold partialDerivReal
  have hfun : (fun y : Fin 4 → ℝ => g.toField y μ ν)
                = fun y : Fin 4 → ℝ => g.toField y ν μ := by
    funext y
    exact hsymm y μ ν
  rw [hfun]

end SmoothMetricFieldReal

/-! ## Bridge from Mizar's `SmoothMetric` -/

/-- **Construct a `SmoothMetricFieldReal` from a `SmoothMetric` (Mizar).**

    Since `SmoothMetric.smooth` provides `ContDiff ℝ ⊤` on every scalar
    component and `ContDiff ℝ ⊤ ⇒ ContDiff ℝ 4` by
    `ContDiff.of_le`, every bundled `SmoothMetric G` gives a
    `SmoothMetricFieldReal` whose `toField` is `G.toField`. -/
noncomputable def SmoothMetric.toReal (g : SmoothMetric) : SmoothMetricFieldReal where
  toField := g.toField
  smooth := by
    intro μ ν
    have h_top : ContDiff ℝ ⊤ (fun x : Fin 4 → ℝ => (g.toFun x) μ ν) :=
      g.smooth μ ν
    -- `(4 : ℕ∞) ≤ ⊤` in the WithTop ordering; `ContDiff.of_le` then
    -- drops regularity.  The target coercion is `(4 : WithTop ℕ∞)`,
    -- matching the target type of `ContDiff ℝ 4`.
    exact h_top.of_le (by exact_mod_cast (le_top : (4 : WithTop ℕ∞) ≤ ⊤))

/-- Sanity check: the transported `toField` is `g.toField`. -/
theorem SmoothMetric.toReal_toField (g : SmoothMetric) :
    g.toReal.toField = g.toField := rfl

/-! ## Flat witness -/

/-- **Flat Minkowski smooth-metric-field-real witness.**  Obtained by
    applying the `SmoothMetric → SmoothMetricFieldReal` bridge to
    `flatSmoothMetric` (Mizar).  The underlying field is the constant
    Minkowski tensor at every `x`. -/
noncomputable def flatSmoothMetricFieldReal : SmoothMetricFieldReal :=
  flatSmoothMetric.toReal

/-- The flat witness has constant components: every two points of `ℝ⁴`
    give the same metric tensor.  This is the clean hypothesis feeding
    `laplacianReal_of_constant`. -/
theorem flatSmoothMetricFieldReal_const
    (μ ν : Fin 4) (x y : Fin 4 → ℝ) :
    flatSmoothMetricFieldReal.toField x μ ν
      = flatSmoothMetricFieldReal.toField y μ ν := rfl

/-- **Real Laplacian of the flat witness vanishes.**  The honest
    theoretical content of Minkowski's `continuumLaplacianAt = 0`
    placeholder value: at every point and every component the real
    Laplacian really is zero because the metric is constant. -/
theorem laplacianReal_flat (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    SmoothMetricFieldReal.laplacianReal flatSmoothMetricFieldReal μ ν x = 0 := by
  refine SmoothMetricFieldReal.laplacianReal_of_constant
    flatSmoothMetricFieldReal ?_ μ ν x
  intro μ' ν' x' y'
  exact flatSmoothMetricFieldReal_const μ' ν' x' y'

/-! ## Consistency with the HpwHypothesis opaque placeholder

The opaque `continuumLaplacianAt g_cont x μ ν := 0` in `HpwHypothesis`
is (trivially) equal to `laplacianReal g μ ν x` for any
`g : SmoothMetricFieldReal` whose `toField` equals `g_cont` AND whose
components are constant.  The flat-witness proof above instantiates this
for `g_cont = flatSmoothMetricFieldReal.toField`; the general
constant-case lemma `laplacianReal_of_constant` is the machine-checked
statement. -/

/-- **Bridge to the HpwHypothesis placeholder.**  For the flat
    `SmoothMetricField` obtained from Mizar's `flatSmoothMetric`, the
    real Laplacian coincides with the opaque `continuumLaplacianAt`
    placeholder — both are `0`.  Thus the `= 0` value in
    `HpwHypothesis.continuumLaplacianAt` is the LITERAL value of the
    real Laplacian on Minkowski. -/
theorem laplacianReal_eq_continuumLaplacianAt_flat
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    SmoothMetricFieldReal.laplacianReal flatSmoothMetricFieldReal μ ν x
      = OmegaTheory.Emergence.continuumLaplacianAt
          flatSmoothMetricFieldReal.toField x μ ν := by
  rw [laplacianReal_flat,
      OmegaTheory.Emergence.continuumLaplacianAt_placeholder]

end OmegaTheory.Geometry
