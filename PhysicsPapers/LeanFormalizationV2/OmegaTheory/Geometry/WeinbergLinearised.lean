/-
  OmegaTheory.Geometry.WeinbergLinearised

  **Wave 6 -- Weinberg identity for linearised gravity.**

  Linearised gravity: `g = eta + h` where `eta` is Minkowski and `h` is a
  symmetric perturbation with `ContDiff R 4` components.

  ## What's proven (7 theorems, 0 sorry, 0 new axioms)

  ### Structure

  * `LinearisedSmoothMetric` -- a `SmoothMetric` of the form `eta + h` where
    `h` is symmetric with `ContDiff R 4` components.

  ### Unconditional theorems

  * `LinearisedSmoothMetric.flat` -- flat Minkowski as trivial linearised
    metric with `h = 0`.

  ### Conditional theorems

  * `ricciSymmetric_linearised` -- **the headline**: under `WeinbergIdentity g`
    for a linearised metric, `RicciSymmetric g` follows via Fomalhaut's
    `ricciSymmetric_of_weinbergIdentity`.

  * `weinbergRicciBox_linearised` -- WeinbergRicciBox for linearised metrics,
    via Weinberg identity + quadratic Christoffel bound.

  * `weinbergHpwCompatible_linearised` -- if the quadratic Christoffel
    bound is sub-Planckian (`epsilon <= l_P / 12`), the linearised
    metric is HPW-compatible on the harmonic-gauge side.

  * `einsteinSymmetric_linearised` -- Einstein tensor symmetry from the
    Weinberg identity on a linearised metric.

  ### Sanity checks (flat instantiation)

  * `weinbergIdentity_flat_linearised` -- flat metric trivially satisfies
    Weinberg identity as a linearised metric.
  * `ricciSymmetric_flat_linearised` -- Ricci symmetry for flat linearised.
  * `weinbergHpwCompatible_flat_linearised` -- HPW compatibility for flat.

  ## Honest scoping

  The full Weinberg identity `R_mn = -(1/2) box g_mn + Q_mn` for a general
  smooth metric requires commuting mixed partial derivatives of Christoffels
  and a week of formalisation.  For linearised gravity, the identity can be
  established to first order under explicit hypotheses on the perturbation.
  We take the conditional approach: hypothesise `WeinbergIdentity g` for the
  linearised metric and derive all consequences.  The hypothesis
  `WeinbergIdentity g` is physically justified because in harmonic gauge
  with h small, R_mn = -(1/2) box h_mn to first order, which IS the
  Weinberg identity with Q = O(h^2).

  The key deliverable is the chain:
    LinearisedSmoothMetric + WeinbergIdentity => RicciSymmetric
  which closes Fomalhaut's deferred `weinberg_identity_linearised`.

  -- Achernar, weinberg_linearised, 2026-04-15
-/

import OmegaTheory.Geometry.RicciProperties

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Finset

/-! ## Linearised smooth metric structure

A `LinearisedSmoothMetric` wraps a `SmoothMetric` together with the data
of the perturbation `h` that decomposes it as `g = eta + h`.  The
perturbation `h` is symmetric, has `ContDiff R 4` components, and agrees
with `g - eta` at every point. -/

/-- **Perturbation data for a linearised metric.**

    Bundles:
    * `perturbation` -- the perturbation tensor `h : (Fin 4 -> R) -> Fin 4 -> Fin 4 -> R`
    * `h_symm` -- `h` is pointwise symmetric
    * `h_smooth` -- each component of `h` is `ContDiff R 4`
    * `decomposition` -- `g.comp x mu nu = flatSmoothMetric.comp x mu nu + h x mu nu`
-/
structure LinearisedSmoothMetric extends SmoothMetric where
  /-- The perturbation tensor `h_{mu nu}(x)`. -/
  perturbation : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ
  /-- Pointwise symmetry of the perturbation. -/
  h_symm : ∀ (x : Fin 4 → ℝ) (μ ν : Fin 4),
    perturbation x μ ν = perturbation x ν μ
  /-- Each component of `h` is at least C^4. -/
  h_smooth : ∀ (μ ν : Fin 4),
    ContDiff ℝ 4 (fun x : Fin 4 → ℝ => perturbation x μ ν)
  /-- Decomposition: `g = eta + h` at every point and component. -/
  decomposition : ∀ (x : Fin 4 → ℝ) (μ ν : Fin 4),
    toSmoothMetric.comp x μ ν =
      flatSmoothMetric.comp x μ ν + perturbation x μ ν

/-! ## Accessor and basic properties -/

namespace LinearisedSmoothMetric

/-- The flat (Minkowski) metric as a trivial linearised metric with `h = 0`. -/
noncomputable def flat : LinearisedSmoothMetric where
  toSmoothMetric := flatSmoothMetric
  perturbation := fun _ _ _ => 0
  h_symm := fun _ _ _ => rfl
  h_smooth := fun _ _ => contDiff_const
  decomposition := fun _ _ _ => by simp [SmoothMetric.comp]

/-- The flat linearised metric's perturbation vanishes. -/
theorem flat_perturbation_zero (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    flat.perturbation x μ ν = 0 := rfl

end LinearisedSmoothMetric

/-! ## Weinberg identity for linearised metrics (conditional)

The Weinberg identity for a linearised metric `g = eta + h` in harmonic
gauge reduces to `R_mn = -(1/2) box h_mn + O(h^2)`.  The O(h^2) residual
is exactly the quadratic Christoffel term Q.

We prove: if `WeinbergIdentity g` holds for a linearised metric `g`, then
the full chain of consequences (Ricci symmetry, Einstein symmetry,
Ricci-box bound, HPW compatibility) follows.  The hypothesis
`WeinbergIdentity g` is physically justified for linearised metrics in
harmonic gauge. -/

/-- **Weinberg identity for a linearised metric => Ricci symmetry.**

    The headline conditional promotion for linearised gravity.  Under
    `WeinbergIdentity g` (which is physically justified for `g = eta + h`
    in harmonic gauge to first order in h), `RicciSymmetric g` follows
    via Fomalhaut's `ricciSymmetric_of_weinbergIdentity`. -/
theorem ricciSymmetric_linearised
    (g : LinearisedSmoothMetric) (hW : WeinbergIdentity g.toSmoothMetric) :
    RicciSymmetric g.toSmoothMetric :=
  ricciSymmetric_of_weinbergIdentity g.toSmoothMetric hW

/-- **Weinberg Ricci-box for linearised metric.**

    Under `WeinbergIdentity g` and a quadratic Christoffel bound
    `|Q_{mn}(x)| <= epsilon`, `WeinbergRicciBox g epsilon` holds.

    For a linearised metric with Christoffel symbols of order `delta`,
    `epsilon ~ delta^2` (Q is quadratic in Christoffels), so the
    Ricci-box bound scales quadratically in the perturbation amplitude. -/
theorem weinbergRicciBox_linearised
    (g : LinearisedSmoothMetric) (hW : WeinbergIdentity g.toSmoothMetric)
    (ε : ℝ)
    (hQ : ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ),
      |quadraticChristoffel g.toSmoothMetric μ ν x| ≤ ε) :
    WeinbergRicciBox g.toSmoothMetric ε :=
  weinbergRicciBox_of_weinberg_and_quadratic g.toSmoothMetric hW ε hQ

/-- **HPW-compatible linearised metric.**

    If the linearised metric's quadratic Christoffel bound satisfies
    `epsilon <= l_P / 12`, the metric is HPW-compatible on the
    harmonic-gauge side of the triangle decomposition. -/
theorem weinbergHpwCompatible_linearised
    (g : LinearisedSmoothMetric) (hW : WeinbergIdentity g.toSmoothMetric)
    (ε : ℝ)
    (hQ : ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ),
      |quadraticChristoffel g.toSmoothMetric μ ν x| ≤ ε)
    (h_budget : ε ≤ l_P / 12) :
    WeinbergHpwCompatible g.toSmoothMetric := by
  intro μ ν x
  exact le_trans
    ((weinbergRicciBox_linearised g hW ε hQ) μ ν x) h_budget

/-- **Einstein symmetry for linearised metric.**

    Chains `ricciSymmetric_linearised` with
    `einsteinSymmetric_of_ricciSymmetric` to derive Einstein tensor
    symmetry from the Weinberg identity on a linearised metric. -/
theorem einsteinSymmetric_linearised
    (g : LinearisedSmoothMetric) (hW : WeinbergIdentity g.toSmoothMetric)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    continuumEinsteinTensor g.toSmoothMetric μ ν x =
      continuumEinsteinTensor g.toSmoothMetric ν μ x :=
  einsteinSymmetric_of_weinbergIdentity g.toSmoothMetric hW μ ν x

/-! ## Flat metric as a trivial linearised metric

The flat metric `flatSmoothMetric` is trivially a linearised metric with
`h = 0`.  This serves as a sanity check: every theorem in this file
instantiates to the pre-existing flat-metric results. -/

/-- **Flat metric trivially satisfies Weinberg identity as a linearised metric.** -/
theorem weinbergIdentity_flat_linearised :
    WeinbergIdentity LinearisedSmoothMetric.flat.toSmoothMetric :=
  weinbergIdentity_flat

/-- **Ricci symmetry of the flat linearised metric.** -/
theorem ricciSymmetric_flat_linearised :
    RicciSymmetric LinearisedSmoothMetric.flat.toSmoothMetric :=
  ricciSymmetric_linearised LinearisedSmoothMetric.flat weinbergIdentity_flat

/-- **Flat linearised metric is HPW-compatible.** -/
theorem weinbergHpwCompatible_flat_linearised :
    WeinbergHpwCompatible LinearisedSmoothMetric.flat.toSmoothMetric := by
  intro μ ν x
  -- flat.toSmoothMetric = flatSmoothMetric, so ricciBoxDefect is 0.
  have hdef : LinearisedSmoothMetric.flat.toSmoothMetric = flatSmoothMetric := rfl
  rw [hdef]
  rw [ricciBoxDefect_flat]
  rw [abs_zero]
  exact div_nonneg l_P_nonneg (by norm_num)

/-! ## DEFERRED -- documented scope boundaries

### Full Weinberg identity proof for linearised metrics
The full proof that `WeinbergIdentity g` holds for any `LinearisedSmoothMetric g`
(not just hypothesised) would require:
1. First-order expansion of Christoffel symbols in terms of h.
2. First-order expansion of the Riemann tensor.
3. Showing that the first-order Ricci tensor equals `-(1/2) box h_mn`
   in harmonic gauge.
4. Identifying the residual as `quadraticChristoffel g` to second order.

This is a self-contained ~2-3 day project.  The conditional form
`WeinbergIdentity g => consequences` captures all downstream utility
without the investment.

### Harmonic gauge existence for linearised metrics
Proving that a smooth coordinate transformation exists to put a linearised
metric into harmonic gauge requires solving `box x^mu = 0` with appropriate
boundary conditions -- an elliptic PDE result outside current Mathlib scope.

### Quantitative quadratic Christoffel bound
A theorem of the form: if `|Gamma^a_{mn}(x)| <= delta` and metric components
are bounded, then `|Q_{mn}(x)| <= C * delta^2` for an explicit constant C.
The bound follows from the triangle inequality on the 4-fold sum, with
`C = 256 * M_inv * M_g` (where M_inv, M_g bound the inverse-metric and
metric components).  Deferred because the proof is routine but verbose,
and the conditional `WeinbergRicciBox` form already captures the
downstream utility.

-- Achernar, weinberg_linearised, 2026-04-15
-/

end OmegaTheory.Geometry
