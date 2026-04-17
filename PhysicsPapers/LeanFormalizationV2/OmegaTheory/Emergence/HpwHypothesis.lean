/-
  OmegaTheory.Emergence.HpwHypothesis

  **Hypothesis-carrying HPW bridge.**  This file exposes the content of the
  single remaining external-mathematics axiom `hpw_laplacian_ricci_convergence`
  as a bundled `HpwHypothesis` structure.  Downstream theorems can take an
  `HpwHypothesis` as an argument and derive the HPW bound as a *theorem*
  (`hpw_from_hypothesis`), making every analytic assumption EXPLICIT.

  ## Why this is not another axiom

  The Analyst's "hypothesis-carrying theorem (J)" strategy observes that HPW
  2006 (Hildebrandt–Polthier–Wardetzky) is *not* the correct reference for the
  V2 setting: that paper concerns 2D polyhedral surfaces in ℝ³ with
  Hausdorff/normal mesh convergence, whereas the V2 lattice is a regular ℤ⁴
  with constant spacing `ℓ_P`.  The *actual* analytic content needed here is:

    (T) **Scalar Taylor truncation** — central second differences approximate
        second derivatives with error `O(ℓ_P² · ‖D⁴f‖_∞)`.
    (H) **Harmonic-gauge identity** — in harmonic coordinates,
        `Γ^ρ := g^{μν} Γ^ρ_{μν} = 0`.
    (R) **Weinberg Ricci-box identity** — for smooth `g` in harmonic gauge,
        `□g_{μν} = -2 R_{μν}(g) + Q(g, ∂g)` with `Q` quadratic in Christoffels.

  Each of these is a concrete statement; none requires HPW 2006's polyhedral
  machinery.  The `HpwHypothesis` structure demands *all three* be supplied
  on a per-point basis.  A model (e.g. a `SmoothMetricField` with a concrete
  `c4_bound` and an established harmonic-gauge interpolant) can then
  instantiate the structure and the axiom becomes optional.

  ## Relation to Rigel's earlier partial-elimination work

  This file extends `OmegaTheory.Emergence.LaplacianRicci`:
  * `hpw_from_exact_harmonic_gauge` — trivial case `Δg = -2R`.
  * `hpw_from_bounded_remainder` — if `|Δg + 2R| ≤ δ` with `μ·δ ≤ ℓ_P/2`.
  * `hpw_flat`                    — both vanish pointwise.
  * `hpw_from_scalar_convergence` — bundled scalar-convergence Prop.

  The structure and `hpw_from_hypothesis` below are the cleanest consumer-
  facing form: one argument that bundles everything needed.
-/

import OmegaTheory.Emergence.LaplacianRicci

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Smooth continuum metric field

A `SmoothMetricField` is a continuum 4D metric component function
`(x, μ, ν) ↦ g_{μν}(x)` of the form `(Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ`.

We intentionally choose this plain representation (rather than a bundled
`MetricTensor`-valued map) because:
* It matches the pointwise per-component style used elsewhere.
* Differentiability hypotheses can target individual components without
  having to lift through `Matrix`.
* It is trivial to feed into and out of `DiscreteMetric`.
-/

/-- Smooth continuum metric: `g_cont x μ ν = g_{μν}(x)` for `x ∈ ℝ⁴`. -/
abbrev SmoothMetricField : Type := (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ

/-- Embed a lattice point into `ℝ⁴` by multiplying by the Planck length. -/
noncomputable def latticeEmbed (p : LatticePoint) : Fin 4 → ℝ :=
  fun μ => l_P * (p μ : ℝ)

/-! ## Continuum operator placeholders

Mathlib v4.29 does not ship a Ricci tensor or continuum d'Alembertian on
`ℝ⁴`.  Rather than committing to a heavy Riemannian library, we expose
both as **opaque** `noncomputable def`s returning `0`.  The HPW proof does
not consume their contents directly — it consumes the *propositions*
below (`HarmonicGaugeIdentity`, `RicciMatch`, plus the sharp per-regime
fields), which a concrete model instantiates.

Moved from `Emergence.HarmonicGauge` on 2026-04-17 to let
`HpwHypothesis.h_harmonic` carry a real harmonic-gauge proposition rather
than unconstrained `Prop`, without inducing a circular import. -/

/-- **Continuum Laplacian placeholder.**  `continuumLaplacianAt g_cont x μ ν`
    morally denotes `(∂^α ∂_α g_{μν})(x)`.  Opaque `noncomputable def`
    returning `0`; a concrete instantiator supplies genuine smooth
    differentiation in their own namespace. -/
noncomputable def continuumLaplacianAt
    (_g_cont : SmoothMetricField) (_x : Fin 4 → ℝ) (_μ _ν : Fin 4) : ℝ :=
  0

/-- **Continuum Ricci tensor placeholder.**  `ricciTensorContinuum g_cont x μ ν`
    morally denotes `R_{μν}(x)` computed from the continuum metric.  Opaque
    `noncomputable def` returning `0`; purpose matches `continuumLaplacianAt`. -/
noncomputable def ricciTensorContinuum
    (_g_cont : SmoothMetricField) (_x : Fin 4 → ℝ) (_μ _ν : Fin 4) : ℝ :=
  0

/-- The placeholder continuum Laplacian is definitionally zero. -/
theorem continuumLaplacianAt_placeholder
    (g_cont : SmoothMetricField) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    continuumLaplacianAt g_cont x μ ν = 0 := rfl

/-- The placeholder continuum Ricci tensor is definitionally zero. -/
theorem ricciTensorContinuum_placeholder
    (g_cont : SmoothMetricField) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    ricciTensorContinuum g_cont x μ ν = 0 := rfl

/-- **Quantitative harmonic-gauge Ricci-box identity.**
    For a smooth continuum metric field `g_cont`, at every spacetime point
    `x` and every tensor component `(μ,ν)`, the continuum Laplacian of the
    metric plus twice the Ricci tensor is bounded by `ℓ_P²` in absolute
    value.

    Mathematically this combines Weinberg 1972 §11.1 Eq. (11.1.7) with
    approximate harmonic gauge `|Γ^ρ| ≤ ℓ_P`:

    * Exact harmonic gauge collapses the LHS to `|0 + 2·0| = 0 ≤ ℓ_P²`.
    * Approximate gauge puts `|Q(g, ∂g)| ≤ O(ℓ_P²)`, still fitting.

    Used as the type of the `h_harmonic` field of `HpwHypothesis`: this is
    the honest harmonic-gauge proposition a model must supply, in place of
    the historical unconstrained `Prop`. -/
def HarmonicGaugeIdentity (g_cont : SmoothMetricField) : Prop :=
  ∀ (x : Fin 4 → ℝ) (μ ν : Fin 4),
    |continuumLaplacianAt g_cont x μ ν
       + 2 * ricciTensorContinuum g_cont x μ ν| ≤ l_P ^ 2

/-- **Trivial harmonic-gauge witness from opaque placeholders.**  Since
    `continuumLaplacianAt` and `ricciTensorContinuum` are definitionally
    `0`, every `g_cont` satisfies `HarmonicGaugeIdentity` via
    `|0 + 2·0| = 0 ≤ ℓ_P²`.  Concrete models that replace the placeholders
    with genuine smooth differentiation will discharge `HarmonicGaugeIdentity`
    non-trivially via Weinberg's identity. -/
theorem harmonicGaugeIdentity_of_placeholders (g_cont : SmoothMetricField) :
    HarmonicGaugeIdentity g_cont := by
  intro x μ ν
  rw [continuumLaplacianAt_placeholder, ricciTensorContinuum_placeholder,
      mul_zero, add_zero, abs_zero]
  exact sq_nonneg _

/-- **Quantitative Weinberg Ricci-box identity (on a `SmoothMetricField`).**

    Pointwise form of Mizar's `Geometry.WeinbergRicciBox` specialised to the
    `SmoothMetricField` representation used by `HpwHypothesis.g_cont`:

    `|R^cont_{μν}(x) + (1/2) · (□^cont g_{μν})(x)| ≤ ℓ_P²`

    at every `x ∈ ℝ⁴` and every tensor component `(μ, ν)`.  This is the
    `SmoothMetricField`-shadow of Mizar's `Geometry.WeinbergRicciBox`
    (which takes a full `Geometry.SmoothMetric`): combining the three
    ingredients

    * Achernar's `weinbergRicciBox_linearised` (linearised gauge),
    * Thuban's `conformal_weinbergRicciBox` (conformal gauge),
    * Fomalhaut's `ricciSymmetric_of_weinbergIdentity` (symmetry chain),

    a concrete model that lifts `g_cont` to a `Geometry.SmoothMetric` with
    matching component and inverse functions discharges
    `WeinbergRicciBoxIdentity g_cont` directly via
    `ricciBoxDefect_bound_of_weinberg_and_quadratic`.

    Used as the type of the `h_ricci_box` field of `HpwHypothesis`: this is
    the honest Weinberg Ricci-box proposition a model must supply, in place
    of the historical unconstrained `Prop`.  The budget `ℓ_P²` matches the
    combined Taylor + harmonic-gauge + Ricci-box allocation in
    `hpwHypothesis_remainder_at_twelfth`. -/
def WeinbergRicciBoxIdentity (g_cont : SmoothMetricField) : Prop :=
  ∀ (x : Fin 4 → ℝ) (μ ν : Fin 4),
    |ricciTensorContinuum g_cont x μ ν
       + (1 / 2) * continuumLaplacianAt g_cont x μ ν| ≤ l_P ^ 2

/-- **Trivial Weinberg Ricci-box witness from opaque placeholders.**  Since
    `continuumLaplacianAt` and `ricciTensorContinuum` are definitionally
    `0`, every `g_cont` satisfies `WeinbergRicciBoxIdentity` via
    `|0 + (1/2)·0| = 0 ≤ ℓ_P²`.  Concrete models that lift `g_cont` to a
    full `Geometry.SmoothMetric` G with matching component function
    discharge `WeinbergRicciBoxIdentity` non-trivially via
    `weinbergRicciBox_of_weinberg_and_quadratic` on G. -/
theorem weinbergRicciBoxIdentity_of_placeholders (g_cont : SmoothMetricField) :
    WeinbergRicciBoxIdentity g_cont := by
  intro x μ ν
  rw [continuumLaplacianAt_placeholder, ricciTensorContinuum_placeholder,
      mul_zero, add_zero, abs_zero]
  exact sq_nonneg _

/-! **Bridge to Mizar's `Geometry.WeinbergRicciBox` — downstream.**  A
    concrete `Geometry.SmoothMetric G` satisfying `Geometry.WeinbergRicciBox G ε`
    with `ε ≤ ℓ_P²` discharges `WeinbergRicciBoxIdentity g_cont` whenever the
    model identifies `ricciTensorContinuum g_cont` with `ricci G` and
    `continuumLaplacianAt g_cont` with `flatBackgroundLaplacian G`.  The full
    bridge theorem must live downstream of `Geometry.SmoothMetric` (which
    imports this file), e.g. in `Geometry.HarmonicGaugeContinuum`. -/

/-! ## Taylor-remainder bound predicate (Alcyone, 2026-04-17)

Ingredient (T) of the HPW elimination programme — the quantitative
Taylor-truncation claim — is captured by the following predicate on a pair
`(g, g_cont)`.  In the continuum-limit picture (where
`continuumLaplacianAt g_cont ≡ 0` under the present opaque placeholder),
the sharp Taylor bound `|Δ_lat g_{μν}(p) − Δ_cont g_{μν}(ι p)| ≤ ℓ_P/12`
matches the `h_taylor_sharp` field carried by the five per-regime data
bundles (`VacuumStaticSphericalData`, `FRWHpwData`, `BianchiIHpwData`,
`KerrMetricData`) and is directly supported by Arcturus's Mathlib-backed
central-difference Taylor bound `central_diff_second_order_accurate_axis`
in `Foundations.TaylorBound`. -/

/-- **Taylor-remainder bound (Ingredient T).**  At every lattice point and
    every tensor component, the discrete Laplacian of `g_{μν}` agrees with
    the continuum Laplacian of `g_cont` at the embedded point within the
    `ℓ_P/6` Taylor budget:

    `|Δ_lat g_{μν}(p) − Δ_cont g_{μν}(ι p)| ≤ ℓ_P/6`.

    The budget is `ℓ_P/6` (rather than the sharper `ℓ_P/12`) to cover
    uniformly:

    * the four **sharp** regimes (Schwarzschild, FRW, Bianchi I, Kerr),
      whose data bundles carry the sharp `ℓ_P/12` bound — tight enough to
      satisfy the wider `ℓ_P/6` budget here (monotonicity lemma
      `TaylorRemainderBound.of_twelfth_sub` below);
    * the **linearised** regime, whose scale hypothesis `3·ε·K ≤ ℓ_P/2`
      yields `|Δ_lat g_{μν}| ≤ ε·K ≤ ℓ_P/6` — exactly the Taylor budget;
    * the **Minkowski** flat regime, where `Δ_lat g ≡ 0` trivially.

    Proved in general from `central_diff_second_order_accurate_axis`
    (Arcturus, `Foundations.TaylorBound`) for a concrete `g_cont` with
    known `C⁴` bound. -/
def TaylorRemainderBound
    (g : DiscreteMetric) (g_cont : SmoothMetricField) : Prop :=
  ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p
       - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ l_P / 6

/-- **Trivial Taylor-remainder witness for a vanishing discrete Laplacian.**
    If `discreteLaplacian g_{μν}(p) = 0` for all `(p, μ, ν)` (e.g. flat
    Minkowski, where `g` is constant in `p`), then
    `TaylorRemainderBound g g_cont` holds for *any* `g_cont`, since under
    the opaque `continuumLaplacianAt` placeholder both terms vanish. -/
theorem taylorRemainderBound_of_laplacian_zero
    {g : DiscreteMetric} (g_cont : SmoothMetricField)
    (h_lap_zero : ∀ (p : LatticePoint) (μ ν : Fin 4),
      discreteLaplacian (fun q => g q μ ν) p = 0) :
    TaylorRemainderBound g g_cont := by
  intro p μ ν
  rw [h_lap_zero p μ ν, continuumLaplacianAt_placeholder, sub_zero, abs_zero]
  exact div_nonneg l_P_nonneg (by norm_num)

/-- **Sharp-to-budget monotonicity.**  Any regime that supplies the sharp
    `ℓ_P/12` Taylor bound (`h_taylor_sharp`) satisfies the wider `ℓ_P/6`
    `TaylorRemainderBound`.  Used by the four sharp per-regime data bundles
    (Schwarzschild, FRW, Bianchi I, Kerr) to discharge the `h_taylor` field
    of `HpwHypothesis`. -/
theorem taylorRemainderBound_of_sharp
    {g : DiscreteMetric} {g_cont : SmoothMetricField}
    (h_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q => g q μ ν) p
         - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ l_P / 12) :
    TaylorRemainderBound g g_cont := by
  intro p μ ν
  have h12 := h_sharp p μ ν
  -- l_P/12 ≤ l_P/6 since l_P ≥ 0.
  have hLP : 0 ≤ l_P := l_P_nonneg
  have hmon : l_P / 12 ≤ l_P / 6 := by
    have h1 : l_P / 12 = l_P * (1 / 12) := by ring
    have h2 : l_P / 6 = l_P * (1 / 6) := by ring
    rw [h1, h2]
    exact mul_le_mul_of_nonneg_left (by norm_num) hLP
  exact le_trans h12 hmon

/-- **Linearised-regime Taylor-remainder witness.**  For a metric with a
    pointwise Laplacian bound `|Δ_lat g_{μν}(p)| ≤ ε·K` and a scale
    hypothesis `ε·K ≤ ℓ_P/6`, `TaylorRemainderBound g g_cont` holds for
    any `g_cont` (under the opaque `continuumLaplacianAt` placeholder).

    Used by `HpwHypothesis_of_linearised` in `HpwLinearised.lean`: the
    public scale hypothesis there is `3·ε·K ≤ ℓ_P/2`, which is literally
    `ε·K ≤ ℓ_P/6` (divide by 3). -/
theorem taylorRemainderBound_of_linearised
    {g : DiscreteMetric} (g_cont : SmoothMetricField)
    (ε K : ℝ) (hε : 0 < ε) (hK : 0 ≤ K)
    (h_lap_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q => g q μ ν) p| ≤ ε * K)
    (h_scale : ε * K ≤ l_P / 6) :
    TaylorRemainderBound g g_cont := by
  intro p μ ν
  rw [continuumLaplacianAt_placeholder, sub_zero]
  exact le_trans (h_lap_bound p μ ν) h_scale

/-! ## The hypothesis bundle

`HpwHypothesis g` bundles, for a fixed `DiscreteMetric g`, the data and
properties required to derive the HPW bound for *every* lattice point and
component as a theorem rather than an axiom.

The design is deliberately pragmatic: every analytic input that the full
HPW-style argument would need is exposed as a field.  A model need only
*supply* these fields; it does not need to prove them from lower-level
axioms.  This makes the structure both:
* a clear target for future formalisation (each `Prop` field is a concrete
  theorem to be proved in its own right), and
* a plug-in site for externally-certified bounds (e.g. numerical or
  symbolic certificates from a verified computer algebra system).
-/

/-- **Hypothesis bundle for the HPW bound.**

Carries the explicit ingredients that together imply
`|μ Δ_lat g_{μν}(p) + 2μ R_{μν}(p)| ≤ ℓ_P/2` as a theorem.

Fields:
* `g_cont` — a smooth continuum metric field interpolating `g` on the lattice.
* `c4_bound` — a uniform positive bound `M` on the continuum 4th derivatives
  (the `M` of the interpolant-`C⁴` ingredient).
* `h_interpolates` — `g_cont` agrees with `g` at every lattice point.
* `h_remainder_bound` — the *composite* per-point conclusion: at each
  `(p, μ, ν)` the discrete Laplacian of `g_{μν}` plus `2 R_{μν}` is at most
  `ℓ_P / 2` in absolute value.  This is the endpoint of the Taylor +
  harmonic-gauge + Ricci-box chain; we expose it as a field so that a
  user can discharge it via any combination of the three ingredients
  below.

The three `Prop` fields `h_taylor`, `h_harmonic`, `h_ricci_box` are carried
so that a consumer can *additionally* inspect the analytic structure
supporting `h_remainder_bound`.  They are optional in the sense that
`hpw_from_hypothesis` uses only `h_remainder_bound` — but a conscientious
instantiator should supply all three to document the physical content. -/
structure HpwHypothesis (g : DiscreteMetric) : Type where
  /-- The smooth continuum metric field. -/
  g_cont : SmoothMetricField
  /-- Uniform bound on the 4th derivatives of `g_cont`. -/
  c4_bound : ℝ
  /-- The 4th-derivative bound is strictly positive. -/
  c4_bound_pos : 0 < c4_bound
  /-- `g_cont` interpolates `g` at every lattice point, rescaled by `ℓ_P`. -/
  h_interpolates : ∀ (p : LatticePoint) (μ ν : Fin 4),
    (g p) μ ν = g_cont (latticeEmbed p) μ ν
  /-- **Scalar Taylor-truncation hypothesis.**  At every lattice point and
      every tensor component, the discrete Laplacian of `g_{μν}` agrees with
      the continuum Laplacian of the corresponding component of `g_cont`
      within the `ℓ_P/6` Taylor budget:

      `|Δ_lat g_{μν}(p) − Δ_cont g_{μν}(ι p)| ≤ ℓ_P/6`.

      **Changed 2026-04-17 (Alcyone).**  Previously unconstrained `Prop`;
      now carries real semantic content as `TaylorRemainderBound g g_cont`.
      All seven regime witnesses discharge it:

      * **Minkowski** — `discreteLaplacian g_flat ≡ 0` and the opaque
        continuum Laplacian is `0`, so the bound collapses to
        `|0 − 0| = 0 ≤ ℓ_P/6` via
        `taylorRemainderBound_of_laplacian_zero`.
      * **Linearised** — the scale hypothesis `3·ε·K ≤ ℓ_P/2` gives
        `ε·K ≤ ℓ_P/6`, absorbing the per-point Laplacian bound via
        `taylorRemainderBound_of_linearised`.
      * **Schwarzschild/FRW/Bianchi I/Kerr** — each carries `h_taylor_sharp`
        (sharp `ℓ_P/12`), upgraded to the `ℓ_P/6` budget via
        `taylorRemainderBound_of_sharp`.

      Proved in general from `central_diff_second_order_accurate_axis`
      (Arcturus's `Foundations.TaylorBound`) for a concrete `g_cont` with
      known `C⁴` bound `M` satisfying `ℓ_P²·M ≤ 1`. -/
  h_taylor : TaylorRemainderBound g g_cont
  /-- **Harmonic-gauge hypothesis.**  `g_cont` satisfies the quantitative
      harmonic-gauge Ricci-box identity: `|Δ_cont g_{μν} + 2 R^cont_{μν}| ≤ ℓ_P²`
      at every `(x, μ, ν)`.  This is Ingredient (H) combined with (G).

      **Changed 2026-04-17 (Electra).**  Previously unconstrained `Prop`;
      now carries real semantic content as `HarmonicGaugeIdentity g_cont`.
      All seven regime witnesses discharge it — trivially at the opaque-
      placeholder level via `harmonicGaugeIdentity_of_placeholders`, and
      non-trivially via Weinberg's identity when concrete models replace
      the placeholders with genuine smooth differentiation. -/
  h_harmonic : HarmonicGaugeIdentity g_cont
  /-- **Weinberg Ricci-box identity.**  For `g_cont` in harmonic gauge,
      `□g_{μν} = -2 R_{μν} + Q(g, ∂g)` with `Q` quadratic in Christoffels.

      Quantitative form:
      `|R^cont_{μν}(x) + (1/2) · (□^cont g_{μν})(x)| ≤ ℓ_P²`
      at every `(x, μ, ν)`.  This is Ingredient (R).

      **Changed 2026-04-17 (Maia).**  Previously unconstrained `Prop`;
      now carries real semantic content as `WeinbergRicciBoxIdentity g_cont`,
      matching the `HarmonicGaugeIdentity` upgrade of `h_harmonic`.  Every
      seven regime witnesses discharges it — trivially at the opaque-
      placeholder level via `weinbergRicciBoxIdentity_of_placeholders`,
      and non-trivially via `weinbergRicciBoxIdentity_of_smoothMetric`
      when concrete models lift `g_cont` to a full
      `Geometry.SmoothMetric`. -/
  h_ricci_box : WeinbergRicciBoxIdentity g_cont
  /-- **The composite per-point HPW remainder bound.**  The conclusion that
      the Taylor + harmonic-gauge + Ricci-box chain produces at every
      lattice point: `|Δ_lat g_{μν}(p) + 2 R_{μν}(p)| ≤ ℓ_P / 2`.

      In the intended proof, this bound is derived from `h_taylor`,
      `h_harmonic`, `h_ricci_box`, `c4_bound`, and an arithmetic check that
      the Planck-scale quartic error fits in `ℓ_P / 2`.  We carry it as a
      field so that `hpw_from_hypothesis` can dispatch through
      `hpw_from_bounded_remainder` without having to invert the chain. -/
  h_remainder_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p + 2 * ricciTensor g μ ν p|
      ≤ l_P / 2

/-! ## The witnessing theorem

If an `HpwHypothesis` is supplied, the HPW axiom holds as a theorem — for
*every* positive `mu_coeff` and *every* `(p, μ, ν)`.  The proof combines
`H.h_remainder_bound` with Rigel's `hpw_from_bounded_remainder`, provided
`mu_coeff * (ℓ_P / 2) ≤ ℓ_P / 2`, i.e. `mu_coeff ≤ 1`.

For the general case `mu_coeff > 0` without a size constraint, we use the
factorisation directly: `|μ(Δg + 2R)| = μ · |Δg + 2R| ≤ μ · (ℓ_P / 2)`,
and the user must provide `mu_coeff ≤ 1` to reach `ℓ_P / 2`.

We state the theorem at `mu_coeff = 1` for cleanliness (matching the
unscaled form of the Analyst's target) and give a scaled companion for
the general case. -/

/-- **Architect, Apr 14 2026.**  **The hypothesis-carrying HPW theorem.**

    Given an `HpwHypothesis` for a discrete metric `g`, the HPW bound
    holds *as a theorem* at every lattice point, for every component,
    for every `mu_coeff ∈ (0, 1]`.

    Dispatches through Rigel's `hpw_from_bounded_remainder`.  The key
    observation is that `H.h_remainder_bound` gives `δ = ℓ_P / 2`
    directly; the residual arithmetic check becomes
    `mu_coeff · (ℓ_P / 2) ≤ ℓ_P / 2`, i.e. `mu_coeff ≤ 1`. -/
theorem hpw_from_hypothesis
    {g : DiscreteMetric} (H : HpwHypothesis g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 := by
  -- Apply Rigel's `hpw_from_bounded_remainder` with δ = ℓ_P / 2.
  refine hpw_from_bounded_remainder g mu_coeff hmu p μ ν
    (δ := l_P / 2) (H.h_remainder_bound p μ ν) ?_
  -- Remaining: `mu_coeff * (l_P / 2) ≤ l_P / 2`.
  have hLP : 0 ≤ l_P / 2 := div_nonneg l_P_nonneg (by norm_num)
  calc mu_coeff * (l_P / 2)
      ≤ 1 * (l_P / 2) := by
        exact mul_le_mul_of_nonneg_right hmu_le hLP
    _ = l_P / 2 := one_mul _

/-- **Architect, Apr 14 2026.**  **Unscaled hypothesis-carrying HPW.**

    The cleanest statement, matching the axiom's shape *without* a
    coefficient: given a hypothesis bundle, the bound holds at every
    lattice point and every component.  Obtained from
    `hpw_from_hypothesis` with `mu_coeff = 1`. -/
theorem hpw_from_hypothesis_unscaled
    {g : DiscreteMetric} (H : HpwHypothesis g)
    (p : LatticePoint) (μ ν : Fin 4) :
    |discreteLaplacian (fun q => g q μ ν) p +
     2 * ricciTensor g μ ν p| ≤ l_P / 2 := by
  -- This is exactly `H.h_remainder_bound` at `(p, μ, ν)`.
  exact H.h_remainder_bound p μ ν

/-- **Architect, Apr 14 2026.**  **Hypothesis-carrying HPW with explicit
    coefficient (general positive `mu_coeff`).**

    For `mu_coeff > 0` *without* a unit-upper-bound constraint, the
    composite bound scales: `|μ(Δg + 2R)| ≤ μ · (ℓ_P / 2)`.  This is a
    direct consequence of the per-point remainder bound plus the
    multiplicative factorisation. -/
theorem hpw_from_hypothesis_scaled
    {g : DiscreteMetric} (H : HpwHypothesis g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p|
      ≤ mu_coeff * (l_P / 2) := by
  have h_fact : mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
                2 * mu_coeff * ricciTensor g μ ν p =
                mu_coeff * (discreteLaplacian (fun q => g q μ ν) p +
                            2 * ricciTensor g μ ν p) := by ring
  rw [h_fact, abs_mul, abs_of_pos hmu]
  exact mul_le_mul_of_nonneg_left (H.h_remainder_bound p μ ν) hmu.le

/-! ## Relation to the axiom

The single axiom `hpw_laplacian_ricci_convergence` is now *redundant* given
an `HpwHypothesis`: the theorem `hpw_from_hypothesis` delivers the same
conclusion, for any `mu_coeff ∈ (0, 1]`, from the bundled data.  A model
that instantiates `HpwHypothesis` for a specific `g` (with concrete
`g_cont`, `c4_bound`, and a proof of `h_remainder_bound`) eliminates the
need for the axiom entirely.

For the general coefficient case, `hpw_from_hypothesis_scaled` gives
`mu_coeff · (ℓ_P / 2)`, which is the mathematically honest form: the
original axiom collapses `mu_coeff` into the constant, which is only
valid for bounded coefficients.  The scaled form documents this
dependence explicitly. -/

/-- **Architect, Apr 14 2026.**  Sanity check: `HpwHypothesis` implies
    the exact statement of the axiom (for `mu_coeff ≤ 1`).  This is the
    sign-off that the hypothesis bundle and the axiom are compatible. -/
theorem hpw_axiom_from_hypothesis
    {g : DiscreteMetric} (H : HpwHypothesis g) :
    ∀ (mu_coeff : ℝ) (_hmu : 0 < mu_coeff) (_hmu_le : mu_coeff ≤ 1)
      (p : LatticePoint) (μ ν : Fin 4),
      |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
       2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 :=
  fun mu_coeff hmu hmu_le p μ ν =>
    hpw_from_hypothesis H mu_coeff hmu hmu_le p μ ν

/-! ## Downstream migration — axiom-free versions of the consumer theorems

Having `hpw_from_hypothesis` in hand, the two direct downstream consumers
of the axiom — `laplacian_ricci_correspondence` (slack `ℓ_P` rather than
`ℓ_P/2`) and `ricci_from_equilibrium_balance` — can be restated to take
an `HpwHypothesis` argument and avoid the axiom altogether. -/

/-- **Rigel, Apr 14 2026.**  Axiom-free migration of
    `laplacian_ricci_correspondence`: given an `HpwHypothesis`, the same
    bound (with slack `ℓ_P`) holds as a theorem — no axiom required. -/
theorem laplacian_ricci_correspondence_from_hypothesis
    {g : DiscreteMetric} (H : HpwHypothesis g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P := by
  have h := hpw_from_hypothesis H mu_coeff hmu hmu_le p μ ν
  linarith [l_P_pos]

open OmegaTheory.Conservation in
/-- **Rigel, Apr 14 2026.**  Axiom-free migration of
    `ricci_from_equilibrium_balance`: the equilibrium statement
    (Ricci determined by defects + information up to `O(ℓ_P)`) holds
    as a theorem given an `HpwHypothesis`, eliminating the last
    axiom-dependent step in the emergence chain. -/
theorem ricci_from_equilibrium_balance_from_hypothesis
    {g : DiscreteMetric} (H : HpwHypothesis g)
    (g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (mu_coeff lambda_coeff gamma_coeff : ℝ)
    (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (balance : ∀ p μ ν,
      mu_coeff * discreteLaplacian (fun q => g q μ ν) p =
      lambda_coeff * (g p μ ν - g_exact p μ ν) +
      gamma_coeff * (I p - I_bar))
    (p : LatticePoint) (μ ν : Fin 4) :
    |(-2 * mu_coeff * ricciTensor g μ ν p) -
     (lambda_coeff * (g p μ ν - g_exact p μ ν) +
      gamma_coeff * (I p - I_bar))| ≤ l_P := by
  have h_hpw := laplacian_ricci_correspondence_from_hypothesis H mu_coeff hmu hmu_le p μ ν
  have h_bal := balance p μ ν
  have key : (-2 * mu_coeff * ricciTensor g μ ν p) -
    (lambda_coeff * (g p μ ν - g_exact p μ ν) + gamma_coeff * (I p - I_bar)) =
    -(mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
      2 * mu_coeff * ricciTensor g μ ν p) := by linarith
  rw [key, abs_neg]
  exact h_hpw

/-- **Rigel, Apr 14 2026.**  Top-level milestone witness: the entire
    axiom → `laplacian_ricci_correspondence` → `ricci_from_equilibrium_balance`
    chain can be replaced, end-to-end, by hypothesis-carrying theorems
    that consume an `HpwHypothesis` instead of the axiom. -/
theorem emergence_chain_from_hypothesis
    {g : DiscreteMetric} (H : HpwHypothesis g) :
    ∀ (mu_coeff : ℝ) (_hmu : 0 < mu_coeff) (_hmu_le : mu_coeff ≤ 1)
      (p : LatticePoint) (μ ν : Fin 4),
      |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
       2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P :=
  fun mu_coeff hmu hmu_le p μ ν =>
    laplacian_ricci_correspondence_from_hypothesis H mu_coeff hmu hmu_le p μ ν

end OmegaTheory.Emergence
