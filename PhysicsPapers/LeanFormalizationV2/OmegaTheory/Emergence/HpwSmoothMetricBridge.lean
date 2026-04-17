/-
  OmegaTheory.Emergence.HpwSmoothMetricBridge

  **HPW strict-track bridge: `SmoothMetric` → `HpwHypothesis`.**

  Electra's diagnosis (2026-04-17): the standard `HpwHypothesis` structure
  carries three "analytic" fields (`h_taylor`, `h_harmonic`, `h_ricci_box`)
  whose types refer to the opaque continuum operators
  `continuumLaplacianAt ≡ 0` and `ricciTensorContinuum ≡ 0` from
  `Emergence.HpwHypothesis`.  The resulting propositions — `TaylorRemainderBound`,
  `HarmonicGaugeIdentity`, `WeinbergRicciBoxIdentity` — are therefore
  *trivially* satisfied by ANY `SmoothMetricField`, because both sides of
  the bound vanish definitionally.

  Mizar's `OmegaTheory.Geometry` stack ships the **real** semantic content:
  `HarmonicGaugeBound g ε` (contracted Christoffel bounded by `ε`) and
  `WeinbergRicciBox g ε` (`|R + (1/2)·□g| ≤ ε`) both phrased on a real
  `SmoothMetric`, with the flat-Minkowski case discharged at `ε = 0`
  by `harmonicGauge_flat` + `weinbergRicciBox_flat`.

  This file builds the **interpretation bridge (Option B)**:

  * `bridge : SmoothMetric → SmoothMetricField` — readable alias for
    `SmoothMetric.toField`.
  * `bridge_preserves_laplacian`, `bridge_preserves_ricci` — the bridge
    maps to the opaque-zero world on the standard track.
  * `HpwHypothesisStrict g` — a parallel hypothesis bundle carrying
    Mizar's real `HarmonicGaugeBound` and `WeinbergRicciBox` plus a
    direct lattice-Laplacian bound at the `ℓ_P/6` budget.
  * `HpwHypothesisStrict.toStandard` — forgetful map producing a
    standard `HpwHypothesis` from a strict one.
  * `flatStrictHypothesis` — concrete strict witness for flat Minkowski,
    using `harmonicGauge_flat`, `weinbergRicciBox_flat`,
    `discreteLaplacian_const`, and `ricciTensor_flat_eq_zero`.

  **Critical: this file does NOT modify `HpwHypothesis`, the standard
  field types, or any existing regime file.**  It is a pure parallel
  track.  Consumers may use the standard hypothesis (cheap, trivial
  placeholders) or the strict hypothesis (real Mizar-backed bounds);
  the forgetful map `toStandard` glues the two tracks together.

  ## Which regimes discharge strictly (Apr 17 report)

  Flat Minkowski regime is discharged fully strictly:
  `flatStrictHypothesis` is a concrete witness of
  `HpwHypothesisStrict DiscreteMetric.flat`, chaining `harmonicGauge_flat`
  (Mizar, `Geometry.HarmonicGaugeContinuum`), `weinbergRicciBox_flat`
  (Mizar, `Geometry.RicciTensor`), `discreteLaplacian_const` (Spacetime.
  Operators), and `ricciTensor_flat_eq_zero` (Emergence.RicciComparison).

  Non-flat strict regimes (Schwarzschild, FRW, Bianchi I, de Sitter, Kerr,
  linearised) are NOT discharged strictly in this file — they currently
  sit on the standard (placeholder) track in `Emergence/Hpw*.lean`.
  Upgrading them requires supplying a `SmoothMetric` witness with concrete
  Christoffel + Ricci + flat-background-Laplacian bounds for the specific
  metric, plus matching the pullback identity on lattice points.  Each
  such regime is a self-contained formalisation effort (roughly
  `ricci_schwarzschild_bound_proof`, `harmonicGauge_schwarzschild_proof`,
  etc.).  Architecturally, the bridge below is the bottleneck those
  regimes will plug into.

  -- Caph (β Cassiopeiae), 2026-04-17
-/

import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.RicciComparison
import OmegaTheory.Geometry.HarmonicGaugeContinuum
import OmegaTheory.Geometry.RicciTensor

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Part 1 — the type-level bridge

The forward direction `SmoothMetric → SmoothMetricField` already exists
as `SmoothMetric.toField`.  We define `bridge` as a readable alias so
downstream statements can say "`bridge g_smooth` uses Mizar's real
metric" without committing to the `toField` spelling. -/

/-- **The bridge.**  Send a real `SmoothMetric` to the curried-component
    `SmoothMetricField` required by `HpwHypothesis.g_cont`. -/
noncomputable def bridge (g : SmoothMetric) : SmoothMetricField :=
  g.toField

/-- Componentwise identity of the bridge: `bridge g x μ ν = g.toFun x μ ν`. -/
theorem bridge_apply (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    bridge g x μ ν = (g.toFun x) μ ν := rfl

/-! ## Part 2 — bridge-preserves identities

Under the current opaque placeholders, the *Laplacian* and *Ricci*
predicates in `HpwHypothesis` degenerate to `0`-valued statements.
These two identities formalise that degeneracy pointwise; they are the
"rfl-packaging" that downstream consumers use when connecting Mizar's
real `ricci g μ ν x` / `flatBackgroundLaplacian g μ ν x` to the
standard-track fields. -/

/-- **Bridge preserves Laplacian (standard-track).**  On the bridge of
    any `SmoothMetric`, the standard-track `continuumLaplacianAt` is
    definitionally zero — matching `continuumLaplacianAt_placeholder`. -/
theorem bridge_preserves_laplacian
    (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    continuumLaplacianAt (bridge g) x μ ν = 0 :=
  continuumLaplacianAt_placeholder (bridge g) x μ ν

/-- **Bridge preserves Ricci (standard-track).**  On the bridge of any
    `SmoothMetric`, the standard-track `ricciTensorContinuum` is
    definitionally zero — matching `ricciTensorContinuum_placeholder`. -/
theorem bridge_preserves_ricci
    (g : SmoothMetric) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    ricciTensorContinuum (bridge g) x μ ν = 0 :=
  ricciTensorContinuum_placeholder (bridge g) x μ ν

/-- **Combined corollary.**  Every bridged smooth metric satisfies the
    standard-track `HarmonicGaugeIdentity` trivially. -/
theorem bridge_harmonicGaugeIdentity (g : SmoothMetric) :
    HarmonicGaugeIdentity (bridge g) :=
  harmonicGaugeIdentity_of_placeholders (bridge g)

/-- **Combined corollary.**  Every bridged smooth metric satisfies the
    standard-track `WeinbergRicciBoxIdentity` trivially. -/
theorem bridge_weinbergRicciBoxIdentity (g : SmoothMetric) :
    WeinbergRicciBoxIdentity (bridge g) :=
  weinbergRicciBoxIdentity_of_placeholders (bridge g)

/-! ## Part 3 — the strict hypothesis bundle

`HpwHypothesisStrict g` is the *content-rich* parallel of `HpwHypothesis`:
instead of the opaque-placeholder fields, it carries

* `g_smooth : SmoothMetric`   — Mizar's real continuum metric;
* `h_lat_lap_bound_strict`    — direct Taylor bound on the lattice
                                 Laplacian (bounds `|Δ_lat g|` within
                                 `ℓ_P/6`, matching the standard
                                 `TaylorRemainderBound` budget);
* `h_harmonic_strict`         — `HarmonicGaugeBound g_smooth (ℓ_P/12)`,
                                 the real contracted-Christoffel bound
                                 from `Geometry.HarmonicGaugeContinuum`;
* `h_ricci_box_strict`        — `WeinbergRicciBox g_smooth (ℓ_P/12)`,
                                 the real `|R + (1/2)·□g|` bound from
                                 `Geometry.RicciTensor`.

The `h_lat_lap_bound_strict` is formulated so the strict bundle upgrades
cleanly to the standard `TaylorRemainderBound`; it is the cheapest field
that closes the strict → standard forgetful map without needing an
external bound on `|R|`.  All regimes that admit a strict bundle
(flat, linearised-small-`ε`, ...) also carry this bound by construction.
For example, flat Minkowski has `Δ_lat g ≡ 0` via
`discreteLaplacian_const`, so the bound holds with slack zero. -/

/-- **Strict HPW hypothesis.**  Content-rich parallel of `HpwHypothesis`
    carrying Mizar's real smooth metric plus real harmonic-gauge +
    Weinberg-Ricci-box bounds at the sharp `ℓ_P/12` budget, and a direct
    lattice-Laplacian bound at the `ℓ_P/6` Taylor budget. -/
structure HpwHypothesisStrict (g : DiscreteMetric) : Type where
  /-- Mizar's real continuum smooth metric. -/
  g_smooth : SmoothMetric
  /-- Lattice restriction agreement: the discrete metric matches the
      continuum restriction at lattice points. -/
  h_interpolates_strict : ∀ (p : LatticePoint) (μ ν : Fin 4),
    (g p) μ ν = (g_smooth.toFun (latticeEmbed p)) μ ν
  /-- **Strict Taylor / lattice-Laplacian bound.**  The lattice Laplacian
      of every metric component is bounded by `ℓ_P/6` — the
      `TaylorRemainderBound` budget.  Concrete regimes discharge this:
      flat via `discreteLaplacian_const`; linearised via the scale
      hypothesis `3·ε·K ≤ ℓ_P/2`.  Satisfying this field is strictly
      stronger than satisfying the standard `h_taylor` field under the
      opaque placeholders (since the standard target sees
      `continuumLaplacianAt = 0`). -/
  h_lat_lap_bound_strict : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p| ≤ l_P / 6
  /-- **Strict harmonic-gauge bound.**  `|g^{αβ} Γ^ρ_{αβ}| ≤ ℓ_P/12` at
      every `(ρ, x)`.  Real content from `Geometry.HarmonicGaugeContinuum`. -/
  h_harmonic_strict : HarmonicGaugeBound g_smooth (l_P / 12)
  /-- **Strict Weinberg Ricci-box bound.**  `|R + (1/2)·□g| ≤ ℓ_P/12` at
      every `(μ, ν, x)`.  Real content from `Geometry.RicciTensor`. -/
  h_ricci_box_strict : WeinbergRicciBox g_smooth (l_P / 12)
  /-- **Composite remainder bound.**  Matches `HpwHypothesis.h_remainder_bound`.
      A concrete regime discharges this by combining the three strict
      bounds through the triangle decomposition, or directly from
      lattice-specific vanishing (e.g. flat). -/
  h_remainder_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p + 2 * ricciTensor g μ ν p|
      ≤ l_P / 2

/-! ## Part 4 — strict → standard forgetful map

The strict hypothesis implies the standard hypothesis.  The three
analytic standard fields are discharged through the
opaque-placeholder identities (`bridge_harmonicGaugeIdentity`,
`bridge_weinbergRicciBoxIdentity`, `bridge_preserves_laplacian`).
The `h_taylor` field collapses under the placeholder to the absolute
bound `|Δ_lat g| ≤ ℓ_P/6` which is exactly `h_lat_lap_bound_strict`.
The composite `h_remainder_bound` carries over verbatim. -/

/-- **`HpwHypothesisStrict → HpwHypothesis` forgetful map.**

    A strict hypothesis bundle produces a standard hypothesis bundle by:

    * bridging `g_smooth : SmoothMetric` to a `SmoothMetricField` via
      `bridge`;
    * discharging `h_taylor` directly from `h_lat_lap_bound_strict`
      (under the opaque placeholder the continuum Laplacian is 0, so
      `TaylorRemainderBound` reduces to `|Δ_lat g| ≤ ℓ_P/6`);
    * discharging `h_harmonic`, `h_ricci_box` via the placeholder
      identities (`bridge_harmonicGaugeIdentity`,
      `bridge_weinbergRicciBoxIdentity`);
    * forwarding `h_remainder_bound` verbatim. -/
noncomputable def HpwHypothesisStrict.toStandard
    {g : DiscreteMetric} (H : HpwHypothesisStrict g) : HpwHypothesis g where
  g_cont := bridge H.g_smooth
  c4_bound := 1
  c4_bound_pos := by norm_num
  h_interpolates := by
    intro p μ ν
    rw [bridge_apply]
    exact H.h_interpolates_strict p μ ν
  h_taylor := by
    intro p μ ν
    rw [continuumLaplacianAt_placeholder, sub_zero]
    exact H.h_lat_lap_bound_strict p μ ν
  h_harmonic := bridge_harmonicGaugeIdentity H.g_smooth
  h_ricci_box := bridge_weinbergRicciBoxIdentity H.g_smooth
  h_remainder_bound := H.h_remainder_bound

/-! ## Part 5 — the concrete flat Minkowski strict witness

Every ingredient is already proved in Mizar's `Geometry` stack plus
`RicciComparison`:

* `flatSmoothMetric` — the flat `SmoothMetric` witness.
* `harmonicGauge_flat` — exact harmonic gauge, which is
  `HarmonicGaugeBound flatSmoothMetric 0` — hence within `ℓ_P/12`.
* `weinbergRicciBox_flat` — `WeinbergRicciBox flatSmoothMetric 0`,
  within `ℓ_P/12`.
* `discreteLaplacian_const` — `Δ_lat g ≡ 0` on flat.
* `ricciTensor_flat_eq_zero` — `R_{μν} ≡ 0` on flat.

Chaining these gives a fully strict Minkowski witness.  Unlike
`minkowskiHpwHypothesis` in `HpwMinkowski.lean`, this witness does NOT
use `h_ricci_box := True` or other placeholder-level tricks; every
bound is real-content. -/

/-- **Flat harmonic-gauge bound within `ℓ_P/12`.**  `harmonicGauge_flat`
    delivers the exact `= 0` form; we relax to the `ℓ_P/12` budget via
    `harmonicGaugeBound_flat`. -/
theorem flat_harmonicGaugeBound_twelfth :
    HarmonicGaugeBound flatSmoothMetric (l_P / 12) :=
  harmonicGaugeBound_flat (l_P / 12)
    (div_nonneg l_P_nonneg (by norm_num))

/-- **Flat Weinberg-Ricci-box bound within `ℓ_P/12`.**  `weinbergRicciBox_flat`
    delivers the exact `ε = 0` form; we relax to `ℓ_P/12`. -/
theorem flat_weinbergRicciBox_twelfth :
    WeinbergRicciBox flatSmoothMetric (l_P / 12) := by
  intro μ ν x
  have h0 := weinbergRicciBox_flat μ ν x
  -- `h0 : |ricciBoxDefect flatSmoothMetric μ ν x| ≤ 0`.  Upgrade to ℓ_P/12.
  have hLP : 0 ≤ l_P / 12 := div_nonneg l_P_nonneg (by norm_num)
  exact le_trans h0 hLP

/-- **Concrete strict Minkowski bundle.**  The flat regime is discharged
    fully at the strict level, with Mizar-backed real-content bounds
    rather than opaque-placeholder trivialities. -/
noncomputable def flatStrictHypothesis :
    HpwHypothesisStrict DiscreteMetric.flat where
  g_smooth := flatSmoothMetric
  h_interpolates_strict := by
    intro p μ ν
    -- `DiscreteMetric.flat p μ ν = minkowskiMetric μ ν` (by `DiscreteMetric.flat`
    -- definition) and `flatSmoothMetric.toFun x = minkowskiMetric` (by
    -- `flatSmoothMetric` definition).  Both reduce to `rfl`.
    rfl
  h_lat_lap_bound_strict := by
    intro p μ ν
    -- On flat, each metric component is constant, so the lattice Laplacian
    -- is zero; `|0| = 0 ≤ ℓ_P/6`.
    have hL : discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
      discreteLaplacian_const (minkowskiMetric μ ν) p
    rw [hL, abs_zero]
    exact div_nonneg l_P_nonneg (by norm_num)
  h_harmonic_strict := flat_harmonicGaugeBound_twelfth
  h_ricci_box_strict := flat_weinbergRicciBox_twelfth
  h_remainder_bound := by
    intro p μ ν
    have hL : discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
      discreteLaplacian_const (minkowskiMetric μ ν) p
    have hR : ricciTensor DiscreteMetric.flat μ ν p = 0 :=
      ricciTensor_flat_eq_zero μ ν p
    rw [hL, hR, mul_zero, add_zero, abs_zero]
    exact div_nonneg l_P_nonneg (by norm_num)

/-- **Strict flat emergence milestone.**  The flat Minkowski regime
    admits a strict (Mizar-backed) HPW hypothesis whose underlying
    `SmoothMetric` is `flatSmoothMetric`. -/
theorem hpw_strict_eliminable_on_flat :
    ∃ H : HpwHypothesisStrict DiscreteMetric.flat,
      H.g_smooth = flatSmoothMetric :=
  ⟨flatStrictHypothesis, rfl⟩

/-- **The strict flat bundle's standard forgetful image** is a bona-fide
    `HpwHypothesis DiscreteMetric.flat`.  Since `HpwHypothesisStrict.toStandard`
    is the generic forgetful map, this corollary just names the composition. -/
noncomputable def flatStrictHypothesis_toStandard :
    HpwHypothesis DiscreteMetric.flat :=
  flatStrictHypothesis.toStandard

end OmegaTheory.Emergence
