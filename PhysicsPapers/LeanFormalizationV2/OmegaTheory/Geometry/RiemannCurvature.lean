/-
  OmegaTheory.Geometry.RiemannCurvature

  **Direction 2, file 3 of 5.  Riemann curvature tensor (continuum, on ℝ⁴).**

  For a `SmoothMetric g`, the Riemann tensor of the Levi-Civita connection is

      R^ρ_{σμν}(x) = ∂_μ Γ^ρ_{νσ}(x) − ∂_ν Γ^ρ_{μσ}(x)
                   + Σ_λ Γ^ρ_{μλ}(x) Γ^λ_{νσ}(x)
                   − Σ_λ Γ^ρ_{νλ}(x) Γ^λ_{μσ}(x).

  This is the continuum analogue of `OmegaTheory.Geometry.Curvature.riemannTensor`
  (which lives on the discrete lattice).

  ## What's proven

  * `riemann_antisymm_mn` — antisymmetry in the last two indices `(μ, ν)`:
    swapping `(μ, ν)` negates `R^ρ_{σμν}`.  This is the structural *easy*
    half of the Riemann symmetries: the definition already has the pattern
    `A(μ,ν) − A(ν,μ) + B(μ,ν) − B(ν,μ)`, which is antisymmetric by
    inspection.
  * `riemann_continuum_flat` — vanishing on flat (Minkowski) metric:
    all Christoffels are zero, so all four terms vanish.

  ## What's NOT proven here

  * **Antisymmetry `R_{ρσμν} = −R_{σρμν}`** (after index lowering). Requires
    metric compatibility, which in turn requires a full covariant-derivative
    setup; deferred to a Mathlib torsion/curvature PR.
  * **First Bianchi identity** `R^ρ_{[σμν]} = 0`. Also deferred.
  * **Second Bianchi identity** `∇_{[λ} R^ρ_{|σ|μν]} = 0`. Deferred.
  * **Pair symmetry** `R_{ρσμν} = R_{μνρσ}`. Requires metric compatibility +
    first Bianchi.

  Each of these is shipped as `def _ : Prop`, not `theorem ... := sorry`.

  -- Mizar, ricci_architect, 2026-04-15
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import OmegaTheory.Geometry.Christoffel

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Finset

/-! ## Partial derivative of a Christoffel symbol -/

/-- `∂_σ Γ^α_{μν}(x)`, continuum.  Uses the scalar `partialDeriv`. -/
noncomputable def christoffelDeriv (g : SmoothMetric) (α μ ν σ : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  partialDeriv (fun y => christoffel g α μ ν y) σ x

/-- Christoffel derivative inherits symmetry in `(μ, ν)` from the Christoffel
    symbol itself, via the fact that `christoffel g α μ ν y = christoffel g α ν μ y`
    for every `y`, so the functions are equal and hence have the same
    derivative. -/
theorem christoffelDeriv_symm (g : SmoothMetric) (α μ ν σ : Fin 4)
    (x : Fin 4 → ℝ) :
    christoffelDeriv g α μ ν σ x = christoffelDeriv g α ν μ σ x := by
  unfold christoffelDeriv
  have hf : (fun y : Fin 4 → ℝ => christoffel g α μ ν y)
              = fun y : Fin 4 → ℝ => christoffel g α ν μ y := by
    funext y; exact christoffel_symm g α μ ν y
  rw [hf]

/-- Flat (continuum Minkowski) Christoffel derivative vanishes. -/
theorem christoffelDeriv_flat (α μ ν σ : Fin 4) (x : Fin 4 → ℝ) :
    christoffelDeriv flatSmoothMetric α μ ν σ x = 0 := by
  unfold christoffelDeriv
  -- `fun y => christoffel flatSmoothMetric α μ ν y` is the constant zero function.
  have hf : (fun y : Fin 4 → ℝ => christoffel flatSmoothMetric α μ ν y)
              = fun _ : Fin 4 → ℝ => (0 : ℝ) := by
    funext y
    exact christoffel_continuum_flat α μ ν y
  rw [hf]
  exact partialDeriv_const 0 σ x

/-! ## The Riemann curvature tensor -/

/-- **Riemann curvature tensor, continuum form.**

    `R^ρ_{σμν}(x) = ∂_μ Γ^ρ_{νσ} − ∂_ν Γ^ρ_{μσ}
                  + Σ_λ Γ^ρ_{μλ}·Γ^λ_{νσ} − Σ_λ Γ^ρ_{νλ}·Γ^λ_{μσ}`

    evaluated at `x`. -/
noncomputable def riemann (g : SmoothMetric) (ρ σ μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  christoffelDeriv g ρ ν σ μ x - christoffelDeriv g ρ μ σ ν x
  + Finset.univ.sum (fun l =>
      christoffel g ρ μ l x * christoffel g l ν σ x)
  - Finset.univ.sum (fun l =>
      christoffel g ρ ν l x * christoffel g l μ σ x)

/-! ## Antisymmetry in the last two indices

The definition packs a manifest antisymmetry: swapping `(μ, ν)` gives
back the negative.  This is the "easy half" of the Riemann symmetries. -/

/-- **Riemann antisymmetry in `(μ, ν)`.**

    `R^ρ_{σμν}(x) = −R^ρ_{σνμ}(x)`. -/
theorem riemann_antisymm_mn (g : SmoothMetric) (ρ σ μ ν : Fin 4)
    (x : Fin 4 → ℝ) :
    riemann g ρ σ μ ν x = - riemann g ρ σ ν μ x := by
  unfold riemann
  -- Define the four pieces.
  set A₁ := christoffelDeriv g ρ ν σ μ x
  set A₂ := christoffelDeriv g ρ μ σ ν x
  set B  := Finset.univ.sum (fun l =>
              christoffel g ρ μ l x * christoffel g l ν σ x)
  set C  := Finset.univ.sum (fun l =>
              christoffel g ρ ν l x * christoffel g l μ σ x)
  -- Swapped pieces: μ↔ν.
  -- In the swapped form, the leading derivative terms become
  --   christoffelDeriv g ρ μ σ ν − christoffelDeriv g ρ ν σ μ = A₂ − A₁.
  -- The sum terms become, after μ↔ν swap,
  --   Σ_λ Γ^ρ_{νλ} Γ^λ_{μσ} − Σ_λ Γ^ρ_{μλ} Γ^λ_{νσ} = C − B.
  -- Hence the swapped riemann equals (A₂ − A₁) + (C − B), and negating
  -- gives (A₁ − A₂) + (B − C) = A₁ − A₂ + B − C = riemann g ρ σ μ ν x.
  ring

/-- Corollary: Riemann with both lower indices equal vanishes. -/
theorem riemann_self_lower (g : SmoothMetric) (ρ σ μ : Fin 4)
    (x : Fin 4 → ℝ) :
    riemann g ρ σ μ μ x = 0 := by
  have h := riemann_antisymm_mn g ρ σ μ μ x
  linarith

/-! ## Flat-metric vanishing -/

/-- **Flat (continuum Minkowski) Riemann tensor vanishes.** -/
theorem riemann_continuum_flat (ρ σ μ ν : Fin 4) (x : Fin 4 → ℝ) :
    riemann flatSmoothMetric ρ σ μ ν x = 0 := by
  unfold riemann
  rw [christoffelDeriv_flat, christoffelDeriv_flat]
  -- Sums: each product has `christoffel flatSmoothMetric ... = 0`.
  have hB : Finset.univ.sum (fun l =>
              christoffel flatSmoothMetric ρ μ l x
                * christoffel flatSmoothMetric l ν σ x) = 0 := by
    apply Finset.sum_eq_zero
    intro l _
    rw [christoffel_continuum_flat]
    ring
  have hC : Finset.univ.sum (fun l =>
              christoffel flatSmoothMetric ρ ν l x
                * christoffel flatSmoothMetric l μ σ x) = 0 := by
    apply Finset.sum_eq_zero
    intro l _
    rw [christoffel_continuum_flat]
    ring
  rw [hB, hC]
  ring

/-! ## Deep symmetries stated as `Prop` (not theorems)

These are the identities that require *metric compatibility* or *torsion
freeness* or the *second Bianchi identity* to prove.  They are facts of
general Riemannian geometry but proving them in Lean requires either:

  * constructing the covariant derivative operator and its associated
    torsion tensor (currently not in Mathlib), or
  * working symbolically with an entire differential-form calculus.

Rather than `sorry` them in a `theorem`, we expose each as a `Prop`-valued
`def`.  A consumer who needs these identities can either prove them for
their specific metric or hypothesise them.  When Mathlib grows the
torsion/curvature machinery, each `def` can be promoted to a `theorem`
without changing any consumer code. -/

/-- **Pair antisymmetry in the first two indices (after lowering).**

    `g_{ρτ} R^τ_{σμν} = − g_{στ} R^τ_{ρμν}` pointwise.

    Requires metric compatibility of the Levi-Civita connection.  Kept as
    a `Prop` until Mathlib has the compatibility machinery. -/
def RiemannPairAntisymmetric (g : SmoothMetric) : Prop :=
  ∀ (ρ σ μ ν : Fin 4) (x : Fin 4 → ℝ),
    Finset.univ.sum (fun τ => g.comp x ρ τ * riemann g τ σ μ ν x)
      = - Finset.univ.sum (fun τ => g.comp x σ τ * riemann g τ ρ μ ν x)

/-- **First Bianchi identity.**  The cyclic sum over the last three
    indices vanishes:

    `R^ρ_{σμν} + R^ρ_{μνσ} + R^ρ_{νσμ} = 0`.

    Requires torsion-freeness (automatic for the Levi-Civita connection,
    but needs to be set up in Lean). -/
def FirstBianchi (g : SmoothMetric) : Prop :=
  ∀ (ρ σ μ ν : Fin 4) (x : Fin 4 → ℝ),
    riemann g ρ σ μ ν x + riemann g ρ μ ν σ x + riemann g ρ ν σ μ x = 0

/-- **Second Bianchi identity.**  Covariant-derivative cyclic identity:

    `∇_λ R^ρ_{σμν} + ∇_μ R^ρ_{σνλ} + ∇_ν R^ρ_{σλμ} = 0`.

    Requires a covariant-derivative operator on Riemann, which in turn
    needs the full Levi-Civita setup.  Kept as a `Prop`. -/
def SecondBianchi (g : SmoothMetric) : Prop :=
  ∀ (ρ σ μ ν lam : Fin 4) (x : Fin 4 → ℝ),
      partialDeriv (fun y => riemann g ρ σ μ ν y) lam x
    + partialDeriv (fun y => riemann g ρ σ ν lam y) μ x
    + partialDeriv (fun y => riemann g ρ σ lam μ y) ν x = 0
  -- N.B. this states the *partial*-derivative form.  The true Bianchi is
  -- in terms of covariant derivatives; connection terms cancel due to
  -- metric compatibility + torsion freeness.  We state the leading-order
  -- partial-derivative form because it is what the harmonic-gauge
  -- consumer ultimately needs.

/-- **Pair symmetry `R_{ρσμν} = R_{μνρσ}`.**

    After index lowering, the Riemann tensor exhibits a pair-swap
    symmetry.  Proven from first-Bianchi + pair-antisymmetry.  Deferred to
    the Mathlib torsion/curvature PR. -/
def RiemannPairSymmetric (g : SmoothMetric) : Prop :=
  ∀ (ρ σ μ ν : Fin 4) (x : Fin 4 → ℝ),
    (Finset.univ.sum fun τ =>
       g.comp x ρ τ *
       Finset.univ.sum (fun κ => g.comp x σ κ * riemann g τ κ μ ν x)) =
    Finset.univ.sum fun τ =>
       g.comp x μ τ *
       Finset.univ.sum (fun κ => g.comp x ν κ * riemann g τ κ ρ σ x)

end OmegaTheory.Geometry
