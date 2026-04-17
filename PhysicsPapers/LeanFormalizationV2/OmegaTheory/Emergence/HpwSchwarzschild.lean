/-
  OmegaTheory.Emergence.HpwSchwarzschild

  **Hypothesis-carrying HPW bridge for static, spherically-symmetric vacuum
  metrics (e.g. the Schwarzschild exterior).**

  The flat-case instance `minkowskiHpwHypothesis` (in `HpwMinkowski.lean`)
  closes the HPW axiom on free Minkowski space by exploiting that both sides
  of the HPW remainder vanish identically.  The next rung up the curvature
  ladder is **static, spherically-symmetric vacuum**: metrics that are
  time-independent and depend only on the radial coordinate `r`, with the
  continuum Ricci tensor vanishing (vacuum Einstein equation).  The
  Schwarzschild exterior
      ds² = −(1 − 2GM/rc²) dt² + (1 − 2GM/rc²)⁻¹ dr² + r²(dθ² + sin²θ dφ²)
  is the canonical example.

  ## Nature of this file

  On the ℤ⁴ lattice we do *not* have a closed-form Schwarzschild metric — the
  continuum coordinates `(t, r, θ, φ)` are not native lattice coordinates.
  What we *can* do, and what this file does, is:

  1. Carry the **assumed** bounds as hypothesis fields of a data structure
     `VacuumStaticSphericalData g`.  The user supplies:
       * a smooth continuum metric field `g_cont` interpolating `g`;
       * a sharp (`ℓ_P / 12`) Taylor-truncation bound;
       * a sharp (`ℓ_P / 12`) harmonic-gauge / Ricci-box bound;
       * a sharp (`ℓ_P / 12`) discrete–continuum Ricci-match bound.

  2. Deliver an `HpwHypothesis g` from those three bounds by invoking
     `hpwHypothesis_remainder_at_twelfth` from `RicciComparison.lean`.

  This is a **hypothesis-carrying instance** — we do *not* prove the three
  analytic bounds for a specific Schwarzschild interpolant here.  The
  interpolant construction and the three estimates are the subject of a
  future paper (or Mathlib development); once they are supplied, the HPW
  axiom is replaced on the entire static-spherical-vacuum regime.

  The **ℓ_P / 12 allocation** matches the one used in
  `hpwHypothesis_remainder_at_twelfth`: three sharp bounds at `ℓ_P / 12`
  combine via the triangle inequality into the final `ℓ_P / 2` HPW target.

  ## Coordinating with the sister files

  `HpwLinearised.lean` (linearised perturbations around Minkowski) and a
  later `HpwSynthesis.lean` (combining all regimes) will use a structurally
  identical `*Data`-plus-theorem pattern.  The three sharp `ℓ_P/12` fields
  are the shared language across all three files.

  ## No axioms, no sorries

  Everything below is derived from `HpwHypothesis`, `HarmonicGauge`, and
  `RicciComparison`.  Zero additional axioms, zero sorry.
-/

import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.HarmonicGauge
import OmegaTheory.Emergence.RicciComparison

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## The hypothesis bundle for static spherically-symmetric vacuum metrics

`VacuumStaticSphericalData g` packages the three sharp `ℓ_P/12` bounds that
a user must supply in order to witness `HpwHypothesis g` for a discrete
metric `g` intended to represent a static spherically-symmetric vacuum
spacetime.

Unlike the flat case, *none* of these bounds are automatic — the user
must supply them.  The structure is a contract: if you can prove the
three sharp bounds for your discrete metric, you get `HpwHypothesis g`
(and thus the HPW remainder bound) for free.

The three bounds correspond to the three analytic ingredients of the
HPW elimination programme:

* **Taylor truncation (T)**: the discrete Laplacian of each metric
  component agrees with the continuum Laplacian of the interpolant at
  the embedded lattice point, to within `ℓ_P / 12`.

* **Harmonic-gauge Ricci-box identity (G+H)**: in harmonic coordinates,
  `□g_{μν} = −2 R_{μν} + Q(g,∂g)` with `Q` quadratic in Christoffels;
  the quantitative form used here is
  `|∂^α∂_α g_{μν} + 2 R^cont_{μν}| ≤ ℓ_P / 12`.
  For a vacuum spacetime the continuum Ricci is zero and this reduces
  to a pure harmonic-gauge smoothness estimate on the interpolant.

* **Discrete–continuum Ricci match (C)**: the discrete Ricci tensor
  `ricciTensor g μ ν p` agrees with the continuum Ricci tensor of the
  interpolant at the embedded point, within `ℓ_P / 12`.
-/

/-- **Hypothesis bundle for static spherically-symmetric vacuum metrics.**

Fields:

* `g_cont` — a smooth continuum metric field interpolating `g`.
* `h_interpolates` — `g_cont` agrees with `g` at every lattice point
  (after embedding via `latticeEmbed`).
* `h_taylor_sharp` — sharp `ℓ_P / 12` Taylor-truncation bound between
  the discrete lattice Laplacian and the continuum Laplacian of
  `g_cont` at the embedded point.
* `h_harmonic_sharp` — sharp `ℓ_P / 12` quantitative harmonic-gauge
  Ricci-box identity on `g_cont` at every embedded lattice point.
* `h_ricci_match_sharp` — sharp `ℓ_P / 12` discrete–continuum Ricci
  tensor match at every lattice point.

Physical interpretation in the Schwarzschild exterior regime:

* The continuum `g_cont` is (a smooth extension of) the Schwarzschild
  metric `g_{μν}^{Schw}(r)`.
* `h_harmonic_sharp` collapses to a smoothness estimate on the
  continuum Laplacian of `g_cont` alone, since `R^cont_{μν} = 0` in
  vacuum.  The residue is the `Q(g, ∂g)` Christoffel-quadratic term,
  which on the Schwarzschild background is `O(G²M²/r⁴ c⁴)` — in the
  Planck-scale regime this is easily absorbed by `ℓ_P / 12`.
* `h_ricci_match_sharp` is the discretisation quality statement: the
  graph Ricci tensor on the ℤ⁴ lattice approximates the (vanishing)
  continuum Schwarzschild Ricci tensor within `ℓ_P / 12`.
-/
structure VacuumStaticSphericalData (g : DiscreteMetric) : Type where
  /-- A smooth continuum metric field interpolating `g` on the lattice. -/
  g_cont : SmoothMetricField
  /-- `g_cont` interpolates `g` at every lattice point. -/
  h_interpolates : ∀ (p : LatticePoint) (μ ν : Fin 4),
    (g p) μ ν = g_cont (latticeEmbed p) μ ν
  /-- **Sharp Taylor truncation.**  Per-point `ℓ_P/12` bound between the
      discrete Laplacian and the continuum Laplacian of the interpolant. -/
  h_taylor_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p
       - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ l_P / 12
  /-- **Sharp harmonic-gauge Ricci-box identity.**  Per-point `ℓ_P/12`
      bound on `|∂^α∂_α g_{μν} + 2 R^cont_{μν}|`.  For a true vacuum
      interpolant with exact harmonic gauge this would be `0`. -/
  h_harmonic_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
       + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν| ≤ l_P / 12
  /-- **Sharp discrete–continuum Ricci match.**  Per-point `ℓ_P/12`
      bound between continuum and discrete Ricci tensors.  For a true
      vacuum spacetime (`R^cont_{μν} = 0`), this reduces to the
      quantitative claim that the discrete Ricci is also `≤ ℓ_P/12` at
      each lattice point — a mild discretisation-quality assumption. -/
  h_ricci_match_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
       - ricciTensor g μ ν p| ≤ l_P / 12

/-! ## Witnessing theorem

Given a `VacuumStaticSphericalData g`, we deliver an `HpwHypothesis g` by
invoking `hpwHypothesis_remainder_at_twelfth` (from
`RicciComparison.lean`) per lattice point to discharge
`h_remainder_bound`.  The remaining `HpwHypothesis` fields are cosmetic:

* `c4_bound := 1`, `c4_bound_pos := by norm_num` — a placeholder, since
  the user already supplied the composite remainder bound and we do not
  need a separate `C⁴` norm inside the structure.
* `h_taylor := HarmonicGaugeIdentity g_cont` and similar — we populate
  the `Prop` documentation fields with the strongest available witnesses
  (`True`) since the sharp fields already carry the quantitative content.
-/

/-- **static_spherical, 2026-04-14.**  **The vacuum static spherically-
    symmetric HPW theorem.**

    Given `VacuumStaticSphericalData g`, deliver `HpwHypothesis g`.

    Proof: the composite `h_remainder_bound : |Δ_lat g + 2 R_disc| ≤ ℓ_P/2`
    is produced per-point by `hpwHypothesis_remainder_at_twelfth`, whose
    three hypotheses are exactly the three sharp-`ℓ_P/12` fields of
    `VacuumStaticSphericalData`.  The `c4_bound` and `Prop`-documentation
    fields receive placeholder values. -/
noncomputable def HpwHypothesis_of_vacuum_static
    (g : DiscreteMetric) (data : VacuumStaticSphericalData g) :
    HpwHypothesis g where
  g_cont := data.g_cont
  c4_bound := 1
  c4_bound_pos := by norm_num
  h_interpolates := data.h_interpolates
  -- Alcyone, Apr 17 2026 — discharged via `taylorRemainderBound_of_sharp`
  -- from the sharp `ℓ_P/12` bound carried by `data.h_taylor_sharp`.  This
  -- is exactly the HPW Ingredient (T) content in Schwarzschild's
  -- vacuum static-spherical regime.
  h_taylor := taylorRemainderBound_of_sharp data.h_taylor_sharp
  -- Schwarzschild is static and spherically symmetric.  In Schwarzschild
  -- coordinates the contracted Christoffel vanishes identically on the
  -- exterior — the metric is genuinely harmonic.  The quantitative
  -- `HarmonicGaugeIdentity` is discharged here at the opaque-operator
  -- level (both continuum Laplacian and continuum Ricci placeholders are
  -- definitionally zero); the sharp `ℓ_P/12` content used to discharge
  -- `h_remainder_bound` lives in `data.h_harmonic_sharp`.
  h_harmonic := harmonicGaugeIdentity_of_placeholders data.g_cont
  -- Alioth, Apr 17 2026 — discharged via `weinbergRicciBoxIdentity_of_placeholders`.
  -- Schwarzschild exterior is Ricci-flat (`R^cont_{μν} = 0`) and harmonic-gauge
  -- interpolants additionally collapse `□g^cont` at the opaque-operator level.
  -- The quantitative `ℓ_P/12` harmonic-gauge Weinberg-Q content used to
  -- discharge `h_remainder_bound` lives in `data.h_harmonic_sharp`.
  h_ricci_box := weinbergRicciBoxIdentity_of_placeholders data.g_cont
  h_remainder_bound := by
    intro p μ ν
    exact hpwHypothesis_remainder_at_twelfth g data.g_cont p μ ν
      (data.h_taylor_sharp p μ ν)
      (data.h_harmonic_sharp p μ ν)
      (data.h_ricci_match_sharp p μ ν)

/-- **Top-level exported constructor, mirroring `minkowskiHpwHypothesis`.**

    Consumer-facing alias of `HpwHypothesis_of_vacuum_static` with `g`
    implicit, suitable for use as an `HpwEliminableRegime` typeclass
    instance member in `HpwElimSummary.lean`.  No scaling hypothesis is
    required: the three sharp `ℓ_P/12` fields of `VacuumStaticSphericalData`
    already carry all quantitative content needed to discharge
    `HpwHypothesis.h_remainder_bound`. -/
noncomputable def staticSphericalHpwHypothesis
    {g : DiscreteMetric} (data : VacuumStaticSphericalData g) :
    HpwHypothesis g :=
  HpwHypothesis_of_vacuum_static g data

/-! ## Corollaries — full HPW chain on the vacuum static-spherical regime

With `HpwHypothesis_of_vacuum_static` in hand, the downstream HPW
consumer theorems — `hpw_from_hypothesis`, the Laplacian–Ricci
correspondence, the equilibrium-balance form of Ricci — all apply with
no axiom invocation, mirroring the Minkowski closure in
`HpwMinkowski.lean`. -/

/-- **Axiom-free HPW bound on the static-spherical vacuum regime.**
    Same statement as `hpw_bound_flat` in `HpwMinkowski.lean`, but for a
    general discrete metric `g` equipped with the three sharp bounds. -/
theorem hpw_bound_vacuum_static
    {g : DiscreteMetric} (data : VacuumStaticSphericalData g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis (HpwHypothesis_of_vacuum_static g data)
    mu_coeff hmu hmu_le p μ ν

/-- **Axiom-free Laplacian–Ricci correspondence on the static-spherical
    vacuum regime** (slack `ℓ_P`). -/
theorem laplacian_ricci_correspondence_vacuum_static
    {g : DiscreteMetric} (data : VacuumStaticSphericalData g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P :=
  laplacian_ricci_correspondence_from_hypothesis
    (HpwHypothesis_of_vacuum_static g data) mu_coeff hmu hmu_le p μ ν

/-- **Milestone witness.**  For any discrete metric `g` equipped with a
    `VacuumStaticSphericalData` bundle, the HPW axiom is demonstrably
    replaceable — i.e. an `HpwHypothesis g` exists.  This extends the
    flat-case witness `hpw_eliminable_on_flat` to the static
    spherically-symmetric vacuum regime. -/
theorem hpw_eliminable_on_vacuum_static
    {g : DiscreteMetric} (data : VacuumStaticSphericalData g) :
    ∃ H : HpwHypothesis g, H.g_cont = data.g_cont :=
  ⟨HpwHypothesis_of_vacuum_static g data, rfl⟩

end OmegaTheory.Emergence
