/-
  OmegaTheory.Geometry.RicciProperties

  **Wave 5 — Ricci-tensor derived properties.**

  Promotes Prop-defs from Mizar's continuum geometry stack to conditional
  theorems where possible, and establishes new structural identities.

  ## What's proven (11 theorems, 0 sorry, 0 new axioms)

  ### Unconditional theorems (no hypotheses beyond `SmoothMetric`)

  * `ricci_alt_contraction_neg` — `Σ_α R^α_{σ μ α}(x) = −ricci g σ μ x`.
    The "alternative contraction" (first-and-fourth indices) differs from
    the standard Ricci (first-and-third) by a sign.

  * `quadraticChristoffel_symm` — `Q_{μν}(x) = Q_{νμ}(x)`.  The Weinberg
    Q term is symmetric in `(μ, ν)`.

  * `flatBackgroundLaplacian_symm` — `□g_{μν}(x) = □g_{νμ}(x)`.  The flat-
    background Laplacian inherits metric symmetry.

  * `einstein_flat_trace` — `Σ_μ G_{μμ}(x) = 0` on Minkowski.

  * `weinbergRicciBox_mono` — monotonicity of `WeinbergRicciBox` in `ε`.

  * `harmonicGaugeBound_mono` — monotonicity of `HarmonicGaugeBound` in `ε`.

  * `ricciBoxDefect_triangle` — triangle inequality decomposition of
    the Ricci-box defect.

  ### Conditional promotions (Prop-def → theorem with honest hypotheses)

  * `ricciSymmetric_of_weinbergIdentity` — **the headline result**.  Under
    `WeinbergIdentity g` alone, `RicciSymmetric g` follows.  Chains
    `flatBackgroundLaplacian_symm` + `quadraticChristoffel_symm`.

  * `einsteinSymmetric_of_weinbergIdentity` — chains the above with
    `einsteinSymmetric_of_ricciSymmetric` to get Einstein symmetry from
    the Weinberg identity.

  * `ricciBoxDefect_symm_of_ricciSymmetric` — Ricci-box defect symmetry
    under `RicciSymmetric g`.

  * `scalarCurvature_swap` — scalar curvature sum invariant under
    `(μ,ν)` swap, under `RicciSymmetric g`.

  ## What's deferred (documented, no sorry)

  * `riemann_antisymm_first_pair` — needs Mathlib Levi-Civita stack.
  * `weinberg_identity_linearised` — needs linearised gravity infrastructure.

  -- Fomalhaut, ricci_properties, 2026-04-15
-/

import OmegaTheory.Geometry.HarmonicGaugeContinuum

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Finset

/-! ## Ricci and the alternative contraction -/

/-- **The alternative contraction `Σ_α R^α_{σ μ α}` equals `−ricci g σ μ x`.**

    The standard Ricci is `ricci g σ μ x = Σ_α R^α_{σ α μ}(x)`.  The
    "alternative" contraction sums `R^α_{σ μ α}(x)` instead.  By
    `riemann_antisymm_mn`, `R^α_{σ μ α} = −R^α_{σ α μ}`, so each summand
    flips sign, and the sum is `−ricci g σ μ x`. -/
theorem ricci_alt_contraction_neg (g : SmoothMetric) (σ μ : Fin 4)
    (x : Fin 4 → ℝ) :
    Finset.univ.sum (fun α => riemann g α σ μ α x) = - ricci g σ μ x := by
  unfold ricci
  -- Each summand: R^α_{σ α μ} = −R^α_{σ μ α} by riemann_antisymm_mn,
  -- so R^α_{σ μ α} = −R^α_{σ α μ}.
  have hsummand : ∀ α : Fin 4,
      riemann g α σ μ α x = - riemann g α σ α μ x := by
    intro α
    have h := riemann_antisymm_mn g α σ α μ x
    -- h : R(α,σ,α,μ) = −R(α,σ,μ,α)
    linarith
  simp_rw [hsummand]
  rw [Finset.sum_neg_distrib]

/-! ## Quadratic-Christoffel symmetry

The Weinberg Q term `Q_{μν}(x) = Σ_{α,β,σ,τ} g^{αβ} Γ^σ_{αμ} Γ^τ_{βν} g_{στ}`
is symmetric in `(μ, ν)`.  The proof swaps the summation variables
`(α ↔ β, σ ↔ τ)` simultaneously and uses the symmetry of `g^{αβ}`,
`g_{στ}`, and Christoffel lower indices. -/

/-- **Quadratic-Christoffel symmetry.**  `Q_{μν}(x) = Q_{νμ}(x)`.

    UNCONDITIONAL — no hypotheses beyond `SmoothMetric`. -/
theorem quadraticChristoffel_symm (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) :
    quadraticChristoffel g μ ν x = quadraticChristoffel g ν μ x := by
  unfold quadraticChristoffel
  -- Each summand f(α,β,σ,τ) = g^{αβ}·(Γ^σ_{αμ}·Γ^τ_{βν}·g_{στ}).
  -- After reindexing (α,β,σ,τ) ↦ (β,α,τ,σ) the summand becomes
  -- g^{βα}·(Γ^τ_{βμ}·Γ^σ_{αν}·g_{τσ}) = g^{αβ}·(Γ^σ_{αν}·Γ^τ_{βμ}·g_{στ})
  -- by invComp_symm, comp_symm, and ring.  That's exactly the (ν,μ) body.
  --
  -- In Lean: swap (α ↔ β) via sum_comm, then at the leaves show pointwise
  -- equality using the symmetries.

  -- Step 1: the LHS as a 4-fold sum equals one with (α,β) swapped.
  -- After Finset.sum_comm, the outer sum runs over what was β, inner over α.
  -- The body at (β_new = old_β, α_new = old_α) is:
  --   Σ_σ Σ_τ g^{α_old β_old} (Γ^σ_{α_old μ} · Γ^τ_{β_old ν} · g_{στ})
  -- = Σ_σ Σ_τ g^{inner outer} (Γ^σ_{inner μ} · Γ^τ_{outer ν} · g_{στ})
  -- So after sum_comm the body at (a, b) is g^{ba}·(Γ^σ_{bμ}·Γ^τ_{aν}·g_{στ}).
  -- We then match against the RHS body at (a, b) = g^{ab}·(Γ^σ_{aν}·Γ^τ_{bμ}·g_{στ}).
  -- Use invComp_symm and then show the inner sums match.
  --
  -- Rather than fighting sum_comm on nested sums, show the inner summands
  -- are equal up to reindexing σ ↔ τ, combined with α ↔ β swap.
  --
  -- We work by showing: for fixed (α, β),
  --   Σ_σ Σ_τ g^{αβ}·(Γ^σ_{αμ}·Γ^τ_{βν}·g_{στ})
  -- = Σ_σ Σ_τ g^{αβ}·(Γ^σ_{αν}·Γ^τ_{βμ}·g_{στ})
  -- by a double sum_comm.  But actually this is NOT true for fixed (α,β) —
  -- we need the (α ↔ β) swap too.
  --
  -- Clean approach: work on the 4-fold sum directly.
  -- LHS body at (α,β,σ,τ) = g^{αβ} · Γ^σ_{αμ} · Γ^τ_{βν} · g_{στ}
  -- RHS body at (α,β,σ,τ) = g^{αβ} · Γ^σ_{αν} · Γ^τ_{βμ} · g_{στ}
  -- Reindex LHS by (α,β,σ,τ) → (β,α,τ,σ):
  --   g^{βα} · Γ^τ_{βμ} · Γ^σ_{αν} · g_{τσ}
  -- = g^{αβ} · Γ^σ_{αν} · Γ^τ_{βμ} · g_{στ}   [by invComp_symm + comp_symm + ring]
  -- This is exactly the RHS body.  QED by Finset.sum_comm (twice).

  -- Formally: swap α ↔ β at the top level.
  conv_lhs => rw [Finset.sum_comm]
  apply Finset.sum_congr rfl; intro a _
  apply Finset.sum_congr rfl; intro b _
  -- Use invComp_symm
  rw [g.invComp_symm x b a]
  -- Now need: Σ_σ Σ_τ g^{ab}·(Γ^σ_{bμ}·Γ^τ_{aν}·g_{στ})
  --         = Σ_σ Σ_τ g^{ab}·(Γ^σ_{aν}·Γ^τ_{bμ}·g_{στ})
  -- Swap the double sum σ ↔ τ on the LHS.
  -- After swap: Σ_τ Σ_σ g^{ab}·(Γ^σ_{bμ}·Γ^τ_{aν}·g_{στ})
  -- Then at position (s_outer, t_inner) the body is:
  --   g^{ab}·(Γ^t_{bμ}·Γ^s_{aν}·g_{ts})
  -- = g^{ab}·(Γ^s_{aν}·Γ^t_{bμ}·g_{st})   [by comp_symm + ring]
  -- which matches the RHS at (s, t).
  rw [Finset.sum_comm (f := fun σ τ =>
    g.invComp x a b * (christoffel g σ b μ x * christoffel g τ a ν x * g.comp x σ τ))]
  apply Finset.sum_congr rfl; intro s _
  apply Finset.sum_congr rfl; intro t _
  rw [g.comp_symm x t s]
  ring

/-! ## Flat-background Laplacian symmetry -/

/-- **Flat-background Laplacian symmetry in `(μ, ν)`.**

    `flatBackgroundLaplacian g μ ν x = flatBackgroundLaplacian g ν μ x`.

    Each summand is `∂²_α g_{μν}(x)`.  Since
    `fun z => g.comp z μ ν = fun z => g.comp z ν μ` by `comp_symm`,
    the partial derivatives (and hence the Laplacian) are equal. -/
theorem flatBackgroundLaplacian_symm (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) :
    flatBackgroundLaplacian g μ ν x = flatBackgroundLaplacian g ν μ x := by
  unfold flatBackgroundLaplacian
  apply Finset.sum_congr rfl
  intro α _
  have hf : (fun z : Fin 4 → ℝ => g.comp z μ ν)
              = fun z : Fin 4 → ℝ => g.comp z ν μ := by
    funext z; exact g.comp_symm z μ ν
  have hinner : (fun y : Fin 4 → ℝ =>
                  partialDeriv (fun z => g.comp z μ ν) α y)
                = fun y : Fin 4 → ℝ =>
                  partialDeriv (fun z => g.comp z ν μ) α y := by
    funext y; rw [hf]
  rw [hinner]

/-! ## Ricci-box defect symmetry -/

/-- **Ricci-box defect symmetry (conditional).**

    If `RicciSymmetric g`, then the Ricci-box defect inherits the
    `(μ, ν)` symmetry:  `ricciBoxDefect g μ ν x = ricciBoxDefect g ν μ x`. -/
theorem ricciBoxDefect_symm_of_ricciSymmetric
    (g : SmoothMetric) (hR : RicciSymmetric g) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) :
    ricciBoxDefect g μ ν x = ricciBoxDefect g ν μ x := by
  unfold ricciBoxDefect
  rw [hR μ ν x, flatBackgroundLaplacian_symm g μ ν x]

/-! ## Weinberg identity → Ricci symmetry (the headline conditional promotion)

If the Weinberg identity holds, then Ricci symmetry reduces to the
symmetry of `Q` plus the flat-background Laplacian — both of which we
have proved unconditionally.  This is the main theorem of this file:
the Ricci symmetry Prop-def becomes a theorem under the *single*
hypothesis `WeinbergIdentity g`. -/

/-- **Weinberg identity implies Ricci symmetry.**

    Under `WeinbergIdentity g` (the Ricci-box identity
    `R_{μν} = −(1/2)·□g_{μν} + Q_{μν}`), Ricci symmetry follows from:
      * `flatBackgroundLaplacian_symm` (unconditional),
      * `quadraticChristoffel_symm` (unconditional).

    This is a **conditional promotion** of `RicciSymmetric g` from a
    Prop-def to a theorem with a single honest hypothesis. -/
theorem ricciSymmetric_of_weinbergIdentity
    (g : SmoothMetric) (hW : WeinbergIdentity g) :
    RicciSymmetric g := by
  intro μ ν x
  have hW_mn := hW μ ν x
  have hW_nm := hW ν μ x
  rw [hW_mn, hW_nm]
  rw [flatBackgroundLaplacian_symm g μ ν x]
  rw [quadraticChristoffel_symm g μ ν x]

/-! ## Einstein symmetry from Weinberg (chain) -/

/-- **Einstein tensor symmetry from the Weinberg identity.**

    Chains `ricciSymmetric_of_weinbergIdentity` with
    `einsteinSymmetric_of_ricciSymmetric`.  Under `WeinbergIdentity g`,
    the Einstein tensor is symmetric. -/
theorem einsteinSymmetric_of_weinbergIdentity
    (g : SmoothMetric) (hW : WeinbergIdentity g)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    continuumEinsteinTensor g μ ν x = continuumEinsteinTensor g ν μ x :=
  einsteinSymmetric_of_ricciSymmetric g
    (ricciSymmetric_of_weinbergIdentity g hW) μ ν x

/-! ## Flat-metric Einstein tensor trace -/

/-- **Flat Einstein tensor trace vanishes.**

    `Σ_μ G_{μμ}(x) = 0` on Minkowski.  Each `G_{μμ} = 0` by
    `continuumEinsteinTensor_flat`. -/
theorem einstein_flat_trace (x : Fin 4 → ℝ) :
    Finset.univ.sum (fun μ =>
      continuumEinsteinTensor flatSmoothMetric μ μ x) = 0 := by
  apply Finset.sum_eq_zero
  intro μ _
  exact continuumEinsteinTensor_flat μ μ x

/-! ## Scalar curvature swap symmetry -/

/-- **Scalar curvature invariant under `(μ,ν)` swap.**

    If `RicciSymmetric g`, the double sum `Σ_{μ,ν} g^{μν} R_{μν}` equals
    the same sum with every `(μ,ν)` replaced by `(ν,μ)`. -/
theorem scalarCurvature_swap (g : SmoothMetric) (hR : RicciSymmetric g)
    (x : Fin 4 → ℝ) :
    Finset.univ.sum (fun μ =>
      Finset.univ.sum (fun ν =>
        g.invComp x μ ν * ricci g μ ν x))
    = Finset.univ.sum (fun ν =>
      Finset.univ.sum (fun μ =>
        g.invComp x ν μ * ricci g ν μ x)) := by
  apply Finset.sum_congr rfl
  intro μ _
  apply Finset.sum_congr rfl
  intro ν _
  rw [g.invComp_symm x μ ν, hR μ ν x]

/-! ## WeinbergRicciBox monotonicity -/

/-- **WeinbergRicciBox monotonicity.**  If `WeinbergRicciBox g ε₁` and
    `ε₁ ≤ ε₂`, then `WeinbergRicciBox g ε₂`. -/
theorem weinbergRicciBox_mono (g : SmoothMetric) (ε₁ ε₂ : ℝ)
    (h : WeinbergRicciBox g ε₁) (hle : ε₁ ≤ ε₂) :
    WeinbergRicciBox g ε₂ := by
  intro μ ν x
  exact le_trans (h μ ν x) hle

/-! ## HarmonicGaugeBound monotonicity -/

/-- **HarmonicGaugeBound monotonicity.**  If `HarmonicGaugeBound g ε₁`
    and `ε₁ ≤ ε₂`, then `HarmonicGaugeBound g ε₂`. -/
theorem harmonicGaugeBound_mono (g : SmoothMetric) (ε₁ ε₂ : ℝ)
    (h : HarmonicGaugeBound g ε₁) (hle : ε₁ ≤ ε₂) :
    HarmonicGaugeBound g ε₂ := by
  intro ρ x
  exact le_trans (h ρ x) hle

/-! ## Ricci-box defect triangle inequality -/

/-- **Ricci-box defect decomposes into Ricci + Laplacian parts.**

    `|ricciBoxDefect g μ ν x| ≤ |ricci g μ ν x| + (1/2) * |□g_{μν}(x)|`.

    Direct application of the triangle inequality. -/
theorem ricciBoxDefect_triangle (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) :
    |ricciBoxDefect g μ ν x| ≤
      |ricci g μ ν x| + 1 / 2 * |flatBackgroundLaplacian g μ ν x| := by
  unfold ricciBoxDefect
  set R := ricci g μ ν x
  set L := flatBackgroundLaplacian g μ ν x
  -- Triangle inequality: |R + (1/2)·L| ≤ |R| + |(1/2)·L| = |R| + (1/2)·|L|.
  have h1 : |R + 1 / 2 * L| ≤ |R| + |1 / 2 * L| := abs_add_le R (1 / 2 * L)
  have h2 : |1 / 2 * L| = 1 / 2 * |L| := by
    rw [abs_mul]
    congr 1
    simp [abs_of_nonneg]
  linarith

/-! ## DEFERRED — documented scope boundaries

### `riemann_antisymm_first_pair`
`R^ρ_{σμν} = −R^σ_{ρμν}` (first-pair antisymmetry after lowering).
Requires metric compatibility of the Levi-Civita connection.
-- OPEN: needs Mathlib Levi-Civita / metric-compatibility stack.

### `weinberg_identity_linearised`
Extending `weinbergIdentity_flat` to linearised gravity `g = η + h`.
Requires a perturbation framework: first-order Christoffel expansion
`Γ = Γ⁽¹⁾(h) + O(h²)`, first-order Riemann, etc.
-- OPEN: needs linearised gravity infrastructure (metric decomposition,
   perturbation expansion of Christoffels and Riemann).
-/

end OmegaTheory.Geometry
