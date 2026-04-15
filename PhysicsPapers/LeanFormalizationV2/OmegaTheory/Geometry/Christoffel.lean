/-
  OmegaTheory.Geometry.Christoffel

  **Direction 2, file 2 of 5.  Christoffel symbols (continuum, on ℝ⁴).**

  Defines the Christoffel symbols of the second kind for a `SmoothMetric`:

      Γ^α_{μν}(x) = (1/2) Σ_β g^{αβ}(x) ·
                    ( ∂_μ g_{νβ}(x) + ∂_ν g_{μβ}(x) − ∂_β g_{μν}(x) )

  where `∂_σ f(x)` denotes the partial derivative of the scalar function
  `f : (Fin 4 → ℝ) → ℝ` in direction `Pi.single σ 1`.

  ## What's proven

  * `christoffel_symm` — symmetry in the lower two indices `(μ, ν)`.
    The proof rewrites
        ∂_μ g_{νβ} + ∂_ν g_{μβ} − ∂_β g_{μν}
      = ∂_ν g_{μβ} + ∂_μ g_{νβ} − ∂_β g_{νμ}
    using `comp_symm` of the metric on the third term.
  * `christoffel_flat` — vanishing on flat (Minkowski) `g`, since the
    metric is constant and all partials are zero.

  ## Why a custom `partialDeriv` rather than `fderiv` directly

  Mathlib's `fderiv ℝ f x` produces a `(Fin 4 → ℝ) →L[ℝ] ℝ`, so a *partial*
  in direction `σ` is `(fderiv ℝ f x) (Pi.single σ 1)`.  We package this as
  a small wrapper `partialDeriv` for readability and to make the symmetry
  proof a one-line `congr` rather than a hidden argument shuffle.

  -- Mizar, ricci_architect, 2026-04-15
-/

import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import OmegaTheory.Geometry.SmoothMetric

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Matrix

/-! ## Continuum partial derivative -/

/-- Partial derivative of `f : (Fin 4 → ℝ) → ℝ` in direction `σ`, evaluated
    at `x`.  This is the `Pi.single σ 1` evaluation of `fderiv ℝ f x`. -/
noncomputable def partialDeriv (f : (Fin 4 → ℝ) → ℝ) (σ : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  (fderiv ℝ f x) (Pi.single σ 1)

/-- The partial derivative of a constant function vanishes. -/
theorem partialDeriv_const (c : ℝ) (σ : Fin 4) (x : Fin 4 → ℝ) :
    partialDeriv (fun _ : Fin 4 → ℝ => c) σ x = 0 := by
  unfold partialDeriv
  rw [fderiv_const_apply]
  rfl

/-! ## Christoffel symbols -/

/-- **Christoffel symbol of the second kind, continuum form.**

    `Γ^α_{μν}(x) = (1/2) Σ_β g^{αβ}(x) (∂_μ g_{νβ} + ∂_ν g_{μβ} − ∂_β g_{μν})(x)`. -/
noncomputable def christoffel (g : SmoothMetric) (α μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  (1 / 2) * Finset.univ.sum fun β =>
    g.invComp x α β *
      ( partialDeriv (fun y => g.comp y ν β) μ x
      + partialDeriv (fun y => g.comp y μ β) ν x
      - partialDeriv (fun y => g.comp y μ ν) β x )

/-! ## Symmetry in the lower two indices -/

/-- **Christoffel symmetry in `(μ, ν)`.**

    `Γ^α_{μν}(x) = Γ^α_{νμ}(x)` for every `α, μ, ν, x`.

    The first two terms `∂_μ g_{νβ} + ∂_ν g_{μβ}` are manifestly symmetric
    in `(μ, ν)`.  The third term `∂_β g_{μν}` becomes `∂_β g_{νμ}` via
    pointwise metric symmetry — but since the partial derivative is taken of
    the function `y ↦ g.comp y μ ν`, and that function equals
    `y ↦ g.comp y ν μ` everywhere by `comp_symm`, the partial derivatives
    agree as well. -/
theorem christoffel_symm (g : SmoothMetric) (α μ ν : Fin 4) (x : Fin 4 → ℝ) :
    christoffel g α μ ν x = christoffel g α ν μ x := by
  unfold christoffel
  congr 1
  apply Finset.sum_congr rfl
  intro β _
  -- Show inside-the-sum: g^{αβ}·(...) μν = g^{αβ}·(...) νμ
  congr 1
  -- Now: (∂_μ g_{νβ} + ∂_ν g_{μβ} − ∂_β g_{μν})
  --    = (∂_ν g_{μβ} + ∂_μ g_{νβ} − ∂_β g_{νμ})
  -- The first two flip; the third needs comp_symm via `funext`.
  have hf : (fun y : Fin 4 → ℝ => g.comp y μ ν)
              = fun y : Fin 4 → ℝ => g.comp y ν μ := by
    funext y
    exact g.comp_symm y μ ν
  rw [hf]
  ring

/-! ## Flat-metric vanishing -/

/-- **Flat (continuum Minkowski) Christoffel symbols vanish.**  For the
    constant Minkowski metric, every component is constant, so every
    `partialDeriv` of `g.comp · μ ν` is zero, making each summand zero.

    (Named `christoffel_continuum_flat` to avoid clashing with the discrete
    analogue `christoffel_flat` in `OmegaTheory.Geometry.Connection`.) -/
theorem christoffel_continuum_flat (α μ ν : Fin 4) (x : Fin 4 → ℝ) :
    christoffel flatSmoothMetric α μ ν x = 0 := by
  unfold christoffel
  -- Each `g.comp · μ ν` is the constant `minkowskiMetric μ ν`, so each
  -- partial derivative is `0`, the inner factor is `0 + 0 - 0 = 0`,
  -- and the whole sum vanishes.
  have hpartial : ∀ μ' ν' σ : Fin 4,
      partialDeriv (fun y : Fin 4 → ℝ => flatSmoothMetric.comp y μ' ν') σ x = 0 := by
    intro μ' ν' σ
    have hconst : (fun y : Fin 4 → ℝ => flatSmoothMetric.comp y μ' ν')
                    = fun _ : Fin 4 → ℝ => minkowskiMetric μ' ν' := by
      rfl
    rw [hconst]
    exact partialDeriv_const (minkowskiMetric μ' ν') σ x
  -- Now every summand is `g.invComp x α β · 0 = 0`.
  have hzero : ∀ β : Fin 4,
      flatSmoothMetric.invComp x α β *
        ( partialDeriv (fun y => flatSmoothMetric.comp y ν β) μ x
        + partialDeriv (fun y => flatSmoothMetric.comp y μ β) ν x
        - partialDeriv (fun y => flatSmoothMetric.comp y μ ν) β x ) = 0 := by
    intro β
    rw [hpartial ν β μ, hpartial μ β ν, hpartial μ ν β]
    ring
  -- Sum of zeros is zero.
  rw [Finset.sum_congr rfl (fun β _ => hzero β), Finset.sum_const_zero, mul_zero]

/-! ## A symmetric-derivative wrapper

The `christoffel` formula combines three partial derivatives into a
"symmetric combination" `S(μ,ν,β,β')`.  We expose this as a separate
abbreviation so consumers can reason about its structure without unfolding
the full Christoffel definition. -/

/-- The symmetric metric-derivative combination
    `S^β_{μν}(x) = ∂_μ g_{νβ} + ∂_ν g_{μβ} − ∂_β g_{μν}` evaluated at `x`. -/
noncomputable def metricDerivCombo (g : SmoothMetric) (β μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  partialDeriv (fun y => g.comp y ν β) μ x
  + partialDeriv (fun y => g.comp y μ β) ν x
  - partialDeriv (fun y => g.comp y μ ν) β x

/-- The Christoffel formula re-expressed via `metricDerivCombo`. -/
theorem christoffel_eq_combo (g : SmoothMetric) (α μ ν : Fin 4) (x : Fin 4 → ℝ) :
    christoffel g α μ ν x =
      (1 / 2) * Finset.univ.sum fun β =>
        g.invComp x α β * metricDerivCombo g β μ ν x := rfl

/-- The symmetric-derivative combination is symmetric in `(μ, ν)`.  This is
    the *core* of `christoffel_symm`. -/
theorem metricDerivCombo_symm (g : SmoothMetric) (β μ ν : Fin 4) (x : Fin 4 → ℝ) :
    metricDerivCombo g β μ ν x = metricDerivCombo g β ν μ x := by
  unfold metricDerivCombo
  have hf : (fun y : Fin 4 → ℝ => g.comp y μ ν)
              = fun y : Fin 4 → ℝ => g.comp y ν μ := by
    funext y
    exact g.comp_symm y μ ν
  rw [hf]
  ring

end OmegaTheory.Geometry
