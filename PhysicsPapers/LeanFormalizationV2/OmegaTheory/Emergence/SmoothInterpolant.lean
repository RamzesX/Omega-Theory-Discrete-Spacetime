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
import OmegaTheory.Geometry.SmoothMetric
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

/-! ## Continuum → discrete restriction

For any `g_cont : (Fin 4 → ℝ) → MetricTensor` we get a canonical
`DiscreteMetric` by restricting to lattice points via `latticeEmbed`.
Every such restriction admits an interpolant *by construction* — the
smooth field *is* the interpolant and `interpolates` is `rfl`.

This is the common backbone of `perturbedFlatInterpolant` and
`slowlyVaryingInterpolant` below: neither construction needs to
produce the discrete metric "first and then interpolate" — we define
the discrete metric *as* the pullback, so interpolation is free. -/

/-- Restrict a continuum metric field to the lattice via `latticeEmbed`. -/
noncomputable def DiscreteMetric.ofContinuum
    (g_cont : (Fin 4 → ℝ) → MetricTensor) : DiscreteMetric :=
  fun p => g_cont (latticeEmbed p)

/-! ## Interpolant 1 — perturbed flat metric `g = η + ε·h`

Given a smooth continuum perturbation field
`h : (Fin 4 → ℝ) → MetricTensor` with each component `C^4` and a
uniform fourth-derivative bound `M_h`, and a real scale `ε`, the
continuum metric
    `g_cont(x) := η + ε · h(x)`
is smooth, has a fourth-derivative bound `|ε| · M_h`, and
interpolates the discrete metric
    `(DiscreteMetric.ofContinuum (η + ε·h))(p) = η + ε · h(latticeEmbed p)`
by construction.

This is Ingredient (E)-perturbed-flat of the HPW elimination plan. -/

/-- The continuum perturbed-flat metric field `x ↦ η + ε · h(x)`. -/
noncomputable def perturbedFlatField
    (h : (Fin 4 → ℝ) → MetricTensor) (ε : ℝ) : (Fin 4 → ℝ) → MetricTensor :=
  fun x => minkowskiMetric + ε • h x

/-- Component-wise form: `(η + ε·h)(x) μ ν = η μ ν + ε · h(x) μ ν`. -/
theorem perturbedFlatField_component
    (h : (Fin 4 → ℝ) → MetricTensor) (ε : ℝ) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    perturbedFlatField h ε x μ ν
      = minkowskiMetric μ ν + ε * h x μ ν := by
  simp [perturbedFlatField, Matrix.add_apply, Matrix.smul_apply, smul_eq_mul]

/-- Smoothness transfer: if every component `(fun x => h x μ ν)` is `C^4`,
then every component of `perturbedFlatField h ε` is `C^4`. -/
theorem perturbedFlatField_contDiff
    {h : (Fin 4 → ℝ) → MetricTensor} {ε : ℝ}
    (h_smooth : ∀ μ ν : Fin 4,
      ContDiff ℝ 4 (fun x : Fin 4 → ℝ => h x μ ν))
    (μ ν : Fin 4) :
    ContDiff ℝ 4 (fun x : Fin 4 → ℝ => perturbedFlatField h ε x μ ν) := by
  -- Rewrite each component as constant + ε · (component of h).
  have hcomp : (fun x : Fin 4 → ℝ => perturbedFlatField h ε x μ ν)
      = (fun x : Fin 4 → ℝ =>
          (minkowskiMetric μ ν : ℝ) + ε * h x μ ν) := by
    funext x; exact perturbedFlatField_component h ε x μ ν
  rw [hcomp]
  -- Const + ε · (C⁴) is C⁴.
  exact (contDiff_const : ContDiff ℝ 4
      (fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ))).add
    ((h_smooth μ ν).const_smul ε)

-- The `iteratedFDeriv` side-chain on `MetricTensor`-valued functions
-- involves heavy whnf on `Fin 4 → Fin 4 → ℝ`; bump the limit to 400000
-- so the chain of `iteratedFDeriv_add_apply` and
-- `iteratedFDeriv_const_smul_apply'` resolves without timing out.
set_option maxHeartbeats 400000 in
/-- Fourth-derivative transfer: the C⁴ bound `‖iteratedFDeriv ℝ 4 (h · μ ν)‖ ≤ M_h`
scales to `‖iteratedFDeriv ℝ 4 (perturbedFlatField h ε · μ ν)‖ ≤ |ε| · M_h`. -/
theorem perturbedFlatField_c4_bound
    {h : (Fin 4 → ℝ) → MetricTensor} {ε M_h : ℝ}
    (h_smooth : ∀ μ ν : Fin 4,
      ContDiff ℝ 4 (fun x : Fin 4 → ℝ => h x μ ν))
    (h_bound : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => h y μ ν) x‖ ≤ M_h)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => perturbedFlatField h ε y μ ν) x‖
      ≤ |ε| * M_h := by
  -- Work with an `ε • _` summand directly (bypass the `*` ↔ `•` whnf trap).
  -- Step 1: rewrite the component as `const + ε • (h · μ ν)`.
  have hcomp : (fun y : Fin 4 → ℝ => perturbedFlatField h ε y μ ν)
      = (fun y : Fin 4 → ℝ =>
          (minkowskiMetric μ ν : ℝ) + ε • h y μ ν) := by
    funext y
    rw [perturbedFlatField_component h ε y μ ν, smul_eq_mul]
  rw [hcomp]
  -- Step 2: split the add via `iteratedFDeriv_add_apply`.
  have hConstCD : ContDiff ℝ 4
      (fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ)) := contDiff_const
  have hSmulCD : ContDiff ℝ 4
      (fun y : Fin 4 → ℝ => ε • h y μ ν) :=
    (h_smooth μ ν).const_smul ε
  have hSum :
      iteratedFDeriv ℝ 4
        (fun y : Fin 4 → ℝ =>
          (minkowskiMetric μ ν : ℝ) + ε • h y μ ν) x
        = iteratedFDeriv ℝ 4
            (fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ)) x
          + iteratedFDeriv ℝ 4
              (fun y : Fin 4 → ℝ => ε • h y μ ν) x :=
    iteratedFDeriv_add_apply hConstCD.contDiffAt hSmulCD.contDiffAt
  rw [hSum]
  -- Step 3: constant 4th-derivative vanishes.
  have h4Const :
      iteratedFDeriv ℝ 4
          (fun _ : Fin 4 → ℝ => (minkowskiMetric μ ν : ℝ)) x = 0 := by
    have hall :
        (iteratedFDeriv ℝ 4 fun _ : Fin 4 → ℝ =>
            (minkowskiMetric μ ν : ℝ)) = 0 :=
      iteratedFDeriv_const_of_ne (by decide) _
    exact congrFun hall x
  rw [h4Const, zero_add]
  -- Step 4: scalar-smul commutes with iteratedFDeriv.
  have hSmulEq : iteratedFDeriv ℝ 4
        (fun y : Fin 4 → ℝ => ε • h y μ ν) x
      = ε • iteratedFDeriv ℝ 4
          (fun y : Fin 4 → ℝ => h y μ ν) x :=
    iteratedFDeriv_const_smul_apply' (h_smooth μ ν).contDiffAt
  rw [hSmulEq, norm_smul]
  -- Step 5: pair with hypothesis.
  have habs : ‖ε‖ = |ε| := Real.norm_eq_abs ε
  rw [habs]
  exact mul_le_mul_of_nonneg_left (h_bound μ ν x) (abs_nonneg ε)

/-- **Interpolant-extender, Apr 15 2026.**  **Perturbed-flat interpolant.**

Given a smooth continuum perturbation field `h` with each component `C^4`
and a uniform fourth-derivative bound `M_h ≥ 0`, and a real scale `ε`,
we obtain a `SmoothInterpolantData` for the *pullback* discrete metric
`DiscreteMetric.ofContinuum (perturbedFlatField h ε)`.  The C⁴ bound is
`|ε| · M_h`.

This is the honest statement: we do NOT claim every discrete metric
admits a perturbed-flat interpolant — only the ones which already
arise as the restriction of a smooth perturbed-flat field.  Models that
build their discrete metric *from* the continuum field (as is standard
in lattice gauge theory) satisfy this hypothesis by construction. -/
noncomputable def perturbedFlatInterpolant
    (h : (Fin 4 → ℝ) → MetricTensor) (ε M_h : ℝ)
    (h_smooth : ∀ μ ν : Fin 4,
      ContDiff ℝ 4 (fun x : Fin 4 → ℝ => h x μ ν))
    (h_bound : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => h y μ ν) x‖ ≤ M_h)
    (hM_nonneg : 0 ≤ M_h) :
    SmoothInterpolantData
      (DiscreteMetric.ofContinuum (perturbedFlatField h ε)) where
  g_cont := perturbedFlatField h ε
  smooth := perturbedFlatField_contDiff h_smooth
  c4_bound := |ε| * M_h
  bound_nonneg := mul_nonneg (abs_nonneg ε) hM_nonneg
  c4_estimate := perturbedFlatField_c4_bound h_smooth h_bound
  interpolates := by
    intro p μ ν
    -- By definition of `DiscreteMetric.ofContinuum`, this is `rfl`.
    rfl

/-- **Corollary.**  The `ε = 0` degenerate perturbed-flat interpolant recovers
    the Minkowski case (modulo matching the discrete metric up to `rfl`). -/
theorem perturbedFlatField_zero_eps (h : (Fin 4 → ℝ) → MetricTensor) :
    perturbedFlatField h 0 = fun _ => minkowskiMetric := by
  funext x
  simp [perturbedFlatField]

/-! ## Interpolant 2 — slowly-varying metric

Given any smooth `g_cont : (Fin 4 → ℝ) → MetricTensor` with uniform C⁴
bound `M ≥ 0` on every component, the discrete restriction
`DiscreteMetric.ofContinuum g_cont` admits `g_cont` itself as a
smooth interpolant with the same C⁴ bound.

This is the honest "slowly-varying" witness: any continuum metric whose
Fréchet 4th derivatives are uniformly bounded provides its own discrete
restriction's interpolant, with the bound transferring verbatim.  The
name "slowly-varying" reflects the physical intuition that a *small*
`M` ⇔ a metric whose large-scale features (the 4th-derivative scale)
vary slowly relative to the sampling frequency. -/

/-- **Interpolant-extender, Apr 15 2026.**  **Slowly-varying interpolant.**

For any smooth continuum metric `g_cont` with uniform C⁴ bound `M`, the
discrete restriction `DiscreteMetric.ofContinuum g_cont` admits
`g_cont` as its own `SmoothInterpolantData`, with `c4_bound = M`.

The smoothness hypothesis and the bound hypothesis are *exactly* the
fields of `SmoothInterpolantData`, so the construction is trivial — it
is essentially an identity-repackaging.  Its value is pedagogical: it
formalises the intuition that "every smooth continuum metric is its own
interpolant for the lattice it samples". -/
noncomputable def slowlyVaryingInterpolant
    (g_cont : (Fin 4 → ℝ) → MetricTensor) (M : ℝ)
    (h_smooth : ∀ μ ν : Fin 4,
      ContDiff ℝ 4 (fun x : Fin 4 → ℝ => g_cont x μ ν))
    (h_bound : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => g_cont y μ ν) x‖ ≤ M)
    (hM_nonneg : 0 ≤ M) :
    SmoothInterpolantData (DiscreteMetric.ofContinuum g_cont) where
  g_cont := g_cont
  smooth := h_smooth
  c4_bound := M
  bound_nonneg := hM_nonneg
  c4_estimate := h_bound
  interpolates := fun _ _ _ => rfl

/-- **Corollary.**  The Minkowski interpolant is a special case of the
    slowly-varying construction, with `M = 0`. -/
theorem slowlyVaryingInterpolant_minkowski_c4_bound :
    (slowlyVaryingInterpolant minkowskiInterpolantField 0
        (fun μ ν => minkowskiInterpolantField_contDiff μ ν 4)
        (fun μ ν x => by
          have h0 := minkowskiInterpolantField_iteratedFDeriv_four μ ν x
          simp [h0])
        (le_refl 0)).c4_bound = 0 :=
  rfl

/-! ## Downstream hand-off

Both `perturbedFlatInterpolant` and `slowlyVaryingInterpolant` produce
`SmoothInterpolantData g` for a `DiscreteMetric g := DiscreteMetric.ofContinuum g_cont`.
Consumers of `HpwHypothesis.g_cont : SmoothMetricField` can extract the
required curried-component field via:

    fun x μ ν => (interpolant.g_cont x) μ ν

which is exactly the shape `minkowskiSmoothField` already exhibits in
`HpwMinkowski.lean`.  A future `perturbedFlatSmoothField` wrapper and
the corresponding `HpwHypothesis` instance can be added when (and only
when) the Laplacian/Ricci bounds for perturbed-flat metrics are also
provided — that lives in `HpwLinearised.lean`, not here. -/

/-- Curried-component adapter from an interpolant's `g_cont` field to a
    `SmoothMetricField`, matching the `HpwHypothesis.g_cont` type. -/
noncomputable def SmoothInterpolantData.toSmoothMetricField
    {g : DiscreteMetric} (D : SmoothInterpolantData g) : SmoothMetricField :=
  fun x μ ν => (D.g_cont x) μ ν

/-- Interpolation identity re-expressed in the `SmoothMetricField` shape —
    useful when instantiating `HpwHypothesis.h_interpolates`. -/
theorem SmoothInterpolantData.toSmoothMetricField_interpolates
    {g : DiscreteMetric} (D : SmoothInterpolantData g)
    (p : LatticePoint) (μ ν : Fin 4) :
    (g p) μ ν = D.toSmoothMetricField (latticeEmbed p) μ ν := by
  unfold SmoothInterpolantData.toSmoothMetricField
  exact (D.interpolates p μ ν).symm

/-! ## Stretch goal — bump-convolution interpolant (not formalised here)

The "every discrete metric admits a smooth interpolant" theorem asserts:
for an arbitrary `g : DiscreteMetric`, there exists a
`SmoothInterpolantData g`.  The standard construction uses
`SmoothBumpFunction` on `ℝ⁴` convolved against the counting measure on
`ℓ_P · ℤ⁴`.

We deliberately *omit* this construction in the present file:

* The interpolation identity requires a non-trivial measure-theoretic
  argument (bump integrals pair with lattice deltas), which imports
  Mathlib convolution/measure infrastructure not currently in the V2
  dependency tree.
* None of the downstream consumers (`HpwLinearised`, `HpwSchwarzschild`,
  `HpwMinkowski`) actually *need* a generic existence theorem — they
  accept bespoke interpolant data on a per-regime basis.
* A correct-but-vacuous Whitney extension argument would add axiom-like
  surface area (through Mathlib convolution imports) without unlocking
  a new theorem.

If a future consumer requires a *generic* smooth interpolant for an
adversarial `g`, this file should be extended with:

```
noncomputable def bumpConvolutionInterpolant
    (g : DiscreteMetric)
    (h_bound : ∀ p μ ν, ‖(g p) μ ν‖ ≤ M) :
    SmoothInterpolantData g
```

using `Mathlib.Analysis.Calculus.BumpFunction.Convolution`.  This is
tracked as future work. -/

/-! ## Bridge from `OmegaTheory.Geometry.SmoothMetric`

`Mizar (ricci_architect)` ships `OmegaTheory.Geometry.SmoothMetric`, a
bundled `C^∞`-smooth pointwise-invertible continuum metric on `ℝ⁴`.  It
is the natural producer of continuum metrics from the
Christoffel / Riemann / Ricci side.  `SmoothInterpolantData` and
`SmoothMetric` are deliberately *separate* structures:

* `SmoothMetric` asks for `ContDiff ℝ ⊤` (i.e. `C^∞`) and carries
  pointwise matrix algebra (symmetry, nondegeneracy, inverse).
* `SmoothInterpolantData` asks only for `ContDiff ℝ 4` and additionally
  carries a uniform fourth-derivative bound and an interpolation
  identity for a specific discrete metric.

The one-way bridge below consumes a `SmoothMetric` and produces a
`SmoothInterpolantData` for the pullback `DiscreteMetric.ofContinuum g.toFun`.
The user must still supply the C⁴ bound — that is *not* implied by
smoothness and is a physical input.  Smoothness is downgraded `C^∞ → C^4`
via `ContDiff.of_le`. -/

/-- **Interpolant-extender × Mizar, Apr 15 2026.**  **Bridge from
    `SmoothMetric` to `SmoothInterpolantData`.**

    Given Mizar's `SmoothMetric g` together with a user-supplied
    pointwise fourth-derivative bound `M`, produce a
    `SmoothInterpolantData` for the pullback discrete metric
    `DiscreteMetric.ofContinuum g.toFun`.

    The `C^∞` regularity of `g.smooth` is downgraded to `C^4` via
    `ContDiff.of_le`.  Interpolation is by construction (`rfl`). -/
noncomputable def SmoothInterpolantData.ofSmoothMetric
    (g : OmegaTheory.Geometry.SmoothMetric) (M : ℝ)
    (h_bound : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4
        (fun y : Fin 4 → ℝ => (g.toFun y) μ ν) x‖ ≤ M)
    (hM_nonneg : 0 ≤ M) :
    SmoothInterpolantData (DiscreteMetric.ofContinuum g.toFun) where
  g_cont := g.toFun
  smooth := fun μ ν =>
    -- `ContDiff ℝ ⊤ f → ContDiff ℝ 4 f` via `of_le` and `(4 : WithTop ℕ∞) ≤ ⊤`.
    (g.smooth μ ν).of_le (by decide)
  c4_bound := M
  bound_nonneg := hM_nonneg
  c4_estimate := h_bound
  interpolates := fun _ _ _ => rfl

end OmegaTheory.Emergence
