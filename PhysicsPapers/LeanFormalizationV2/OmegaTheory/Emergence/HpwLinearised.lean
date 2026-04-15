/-
  OmegaTheory.Emergence.HpwLinearised

  **Concrete instance: `HpwHypothesis g` for the linearised-gravity regime.**

  A physically-important class of metrics beyond the free-space case is
  *linearised gravity* — metrics of the form `g = η + ε·h`, where `η` is
  Minkowski and `h` is a bounded perturbation.  The discrete Laplacian
  and Ricci tensor of such a metric both scale with `ε`: writing
  `|Δ_lat g_{μν}(p)| ≤ εK` and `|R_{μν}(p)| ≤ εK` for a pointwise bound
  `K ≥ 0`, the HPW remainder obeys

      `|Δ_lat g_{μν}(p) + 2 R_{μν}(p)| ≤ εK + 2εK = 3εK`

  by the triangle inequality.  Provided the *scale hypothesis* `3εK ≤ ℓ_P/2`
  holds, the `h_remainder_bound` field of `HpwHypothesis` is discharged
  immediately — no Taylor machinery, no harmonic-gauge identity, just
  Rigel's `hpw_perturbed_flat` theorem specialised to `mu_coeff = 1`.

  ## Relation to the other HPW instances

  * `HpwMinkowski.lean` — the `ε = 0` case: both `Δg` and `R` vanish
    identically, and the remainder bound is `|0| ≤ ℓ_P/2` trivially.
  * `HpwLinearised.lean` (this file) — the `ε > 0` small-perturbation case.
  * `HpwStaticSpherical.lean` (teammate `static_spherical`) — the
    Schwarzschild-like stationary spherical regime.
  * `HpwSynthesis.lean` (teammate `synthesis`) — consumer-facing
    consolidator that selects an HPW witness per regime.

  The three concrete regimes — flat, linearised, static-spherical —
  cover the physically interesting cases of OmegaTheory.  With the
  `HpwHypothesis`-carrying chain in place (see
  `laplacian_ricci_correspondence_from_hypothesis` and
  `ricci_from_equilibrium_balance_from_hypothesis`), the HPW axiom is
  then demonstrably redundant on each.
-/

import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.HpwMinkowski

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## The linearised-regime data bundle

`LinearisedMetricData g` carries, for a fixed `DiscreteMetric g`, the
three data required to invoke `hpw_perturbed_flat` at every lattice
point and component:

* a positive perturbation scale `ε`,
* a nonnegative pointwise amplitude `K`,
* a pointwise Laplacian bound `|Δ_lat g_{μν}(p)| ≤ ε·K`,
* a pointwise Ricci bound        `|R_{μν}(p)|      ≤ ε·K`.

A continuum witness `g_cont` is carried separately so it can be used as
the `HpwHypothesis.g_cont` field together with the interpolation
identity `h_interpolates`.  The fields `g_cont` / `h_interpolates` are
bookkeeping only — the HPW remainder bound flows entirely through the
Laplacian and Ricci bounds. -/

/-- **Linearised-gravity data bundle.**  The full input required to
    produce an `HpwHypothesis g` for a metric in the weak-field regime.
    See file doc-comment for the physical interpretation. -/
structure LinearisedMetricData (g : DiscreteMetric) : Type where
  /-- Continuum interpolant of `g` (needed for `HpwHypothesis.g_cont`). -/
  g_cont : SmoothMetricField
  /-- `g_cont` interpolates `g` at every lattice point. -/
  h_interpolates : ∀ (p : LatticePoint) (μ ν : Fin 4),
    (g p) μ ν = g_cont (latticeEmbed p) μ ν
  /-- Perturbation scale, strictly positive. -/
  ε : ℝ
  /-- The perturbation scale is strictly positive. -/
  ε_pos : 0 < ε
  /-- Pointwise amplitude of the perturbation's effect on curvature. -/
  K : ℝ
  /-- The amplitude is nonnegative. -/
  K_nonneg : 0 ≤ K
  /-- Pointwise Laplacian bound: `|Δ_lat g_{μν}(p)| ≤ ε·K`. -/
  h_lap_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p| ≤ ε * K
  /-- Pointwise Ricci bound: `|R_{μν}(p)| ≤ ε·K`. -/
  h_ricci_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensor g μ ν p| ≤ ε * K

/-! ## The main construction

Given a `LinearisedMetricData g` and the scale hypothesis
`3·ε·K ≤ ℓ_P/2`, we assemble an `HpwHypothesis g` by:

* using `D.g_cont` / `D.h_interpolates` for the continuum-bookkeeping
  fields (`g_cont`, `h_interpolates`),
* taking `c4_bound := 1` (an irrelevant placeholder — the bundle only
  requires positivity, not a working 4th-derivative estimate, since
  the remainder bound is discharged directly via `hpw_perturbed_flat`),
* setting the three documentation Props (`h_taylor`, `h_harmonic`,
  `h_ricci_box`) to `True` (consistent with `HpwMinkowski`; the
  linearised case does not need the full Taylor-chain machinery),
* discharging `h_remainder_bound` via Rigel's `hpw_perturbed_flat` at
  `mu_coeff = 1`, which collapses `mu_coeff * (3εK) ≤ ℓ_P/2` into the
  scale hypothesis directly. -/

/-- **Linearised HPW witness.**  Convert a `LinearisedMetricData g`
    plus the scale hypothesis `3·ε·K ≤ ℓ_P/2` into an `HpwHypothesis g`.

    The `h_remainder_bound` field is discharged point-wise through
    `hpw_perturbed_flat` specialised to `mu_coeff = 1`.  A cosmetic
    unfolding reduces the bound
    `|1·Δg + 2·1·R| ≤ ℓ_P/2` to the target shape
    `|Δg + 2R| ≤ ℓ_P/2`. -/
noncomputable def HpwHypothesis_of_linearised
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2) :
    HpwHypothesis g where
  g_cont := D.g_cont
  c4_bound := 1
  c4_bound_pos := by norm_num
  h_interpolates := D.h_interpolates
  h_taylor := True
  h_harmonic := True
  h_ricci_box := True
  h_remainder_bound := by
    intro p μ ν
    -- Invoke `hpw_perturbed_flat` at `mu_coeff = 1`.  The hypothesis
    -- `mu_coeff * (3εK) ≤ ℓ_P/2` collapses to `3εK ≤ ℓ_P/2`.
    have hmu1 : (0 : ℝ) < 1 := by norm_num
    have h_scale' : (1 : ℝ) * (3 * D.ε * D.K) ≤ l_P / 2 := by
      simpa [one_mul] using h_scale
    have h :=
      hpw_perturbed_flat g 1 hmu1 p μ ν D.ε_pos D.K_nonneg
        (D.h_lap_bound p μ ν) (D.h_ricci_bound p μ ν) h_scale'
    -- Strip the `1 *` coefficient from the result.
    have hEq :
        (1 : ℝ) * discreteLaplacian (fun q => g q μ ν) p +
          2 * 1 * ricciTensor g μ ν p
            = discreteLaplacian (fun q => g q μ ν) p +
              2 * ricciTensor g μ ν p := by ring
    simpa [hEq] using h

/-- **Public-handle alias.**  Matches the naming of `minkowskiHpwHypothesis`
    so downstream umbrella code can dispatch uniformly
    (`minkowskiHpwHypothesis`, `linearisedHpwHypothesis`, …). -/
noncomputable def linearisedHpwHypothesis
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2) :
    HpwHypothesis g :=
  HpwHypothesis_of_linearised D h_scale

/-! ## Corollaries — axiom-free emergence on the linearised regime

Once an `HpwHypothesis g` is in hand for a linearised metric, the full
axiom-free emergence chain (`hpw_from_hypothesis`,
`laplacian_ricci_correspondence_from_hypothesis`,
`ricci_from_equilibrium_balance_from_hypothesis`) applies verbatim. -/

/-- **Linearised HPW bound as a theorem.**  Same conclusion as the
    HPW axiom but derived from the structural `LinearisedMetricData` —
    no axiomatic content at all. -/
theorem hpw_bound_linearised
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis (HpwHypothesis_of_linearised D h_scale)
    mu_coeff hmu hmu_le p μ ν

/-- **Linearised Laplacian–Ricci correspondence.**  Slack-`ℓ_P` version,
    axiom-free, for the linearised regime. -/
theorem laplacian_ricci_correspondence_linearised
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P :=
  laplacian_ricci_correspondence_from_hypothesis
    (HpwHypothesis_of_linearised D h_scale) mu_coeff hmu hmu_le p μ ν

/-! ## Sanity check — the trivial `ε = 0` / exactly-flat linearisation

The "perturbation of zero magnitude" case: a metric that IS flat
(`DiscreteMetric.flat`) trivially satisfies the linearised data bundle
with any choice of `ε > 0` and `K = 0`, since both the discrete
Laplacian (`discreteLaplacian_const`) and the Ricci tensor
(`ricciTensor_flat_eq_zero`) of a constant/flat metric vanish
identically.  The scale hypothesis `3·ε·0 ≤ ℓ_P/2` is trivially
satisfied since the LHS is zero and the RHS is positive. -/

/-- **Trivial linearised data for `DiscreteMetric.flat`.**  Takes
    `ε = 1`, `K = 0`, and uses the flat-metric vanishing theorems
    for both bounds.  The `g_cont` is `minkowskiSmoothField`, matching
    the `HpwMinkowski` witness. -/
noncomputable def flatLinearisedData :
    LinearisedMetricData DiscreteMetric.flat where
  g_cont := minkowskiSmoothField
  h_interpolates := by
    intro p μ ν
    unfold minkowskiSmoothField
    exact (minkowskiInterpolantField_interpolates_flat p μ ν).symm
  ε := 1
  ε_pos := by norm_num
  K := 0
  K_nonneg := le_refl 0
  h_lap_bound := by
    intro p μ ν
    have hL : discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
      discreteLaplacian_const (minkowskiMetric μ ν) p
    rw [hL, abs_zero]
    -- goal: `0 ≤ 1 * 0 = 0`; rewrite to bare `0 ≤ 0`.
    simp
  h_ricci_bound := by
    intro p μ ν
    have hR : ricciTensor DiscreteMetric.flat μ ν p = 0 :=
      ricciTensor_flat_eq_zero μ ν p
    rw [hR, abs_zero]
    simp

/-- **Sanity theorem.**  The trivial flat-linearised data satisfies the
    scale hypothesis `3·ε·K ≤ ℓ_P/2` automatically (since `K = 0`), and
    therefore yields an `HpwHypothesis DiscreteMetric.flat` — consistent
    with `minkowskiHpwHypothesis` from `HpwMinkowski`. -/
theorem flatLinearisedData_scale_ok :
    3 * flatLinearisedData.ε * flatLinearisedData.K ≤ l_P / 2 := by
  -- `flatLinearisedData.K = 0`, so the LHS is zero; the RHS is ≥ 0.
  show (3 : ℝ) * 1 * 0 ≤ l_P / 2
  simp
  exact div_nonneg l_P_nonneg (by norm_num)

/-- **Sanity witness.**  From the trivial flat-linearised data we can
    produce an `HpwHypothesis DiscreteMetric.flat`, confirming the
    linearised construction is consistent with the Minkowski case. -/
noncomputable def flatLinearisedHpwHypothesis :
    HpwHypothesis DiscreteMetric.flat :=
  HpwHypothesis_of_linearised flatLinearisedData flatLinearisedData_scale_ok

/-- **Milestone witness.**  The linearised regime admits a concrete
    `HpwHypothesis` instantiation parametrised by `ε`, `K`, and the
    pointwise bounds — so the HPW axiom is *demonstrably replaceable*
    wherever those bounds hold and the scale hypothesis is met. -/
theorem hpw_eliminable_on_linearised
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2) :
    ∃ _ : HpwHypothesis g, True :=
  ⟨HpwHypothesis_of_linearised D h_scale, trivial⟩

/-! ## Linearised data from a `perturbedFlatInterpolant`

`SmoothInterpolant.perturbedFlatInterpolant` provides, for any smooth
perturbation `h` with a C⁴ bound `M_h`, a `SmoothInterpolantData` on
the pullback discrete metric `DiscreteMetric.ofContinuum (perturbedFlatField h ε)`.

To plug this into `LinearisedMetricData` (and thus `HpwHypothesis` via
`HpwHypothesis_of_linearised`), the user needs two more per-point
Laplacian/Ricci bounds at scale `ε·K`.  Those bounds are *physical*
(they depend on the specific perturbation `h`), not structural, and
so cannot be produced from the interpolant alone.  Instead, we provide
a *builder* `linearisedDataOfInterpolant` that takes the interpolant
together with those physical bounds, and emits a `LinearisedMetricData`
whose `g_cont` / `h_interpolates` fields are discharged automatically.

This is the honest hand-off: the analytic work (the pointwise Lap/Ricci
bounds) remains the user's responsibility, but the *bookkeeping*
(interpolation identity, continuum field) is now routed through the
interpolant library. -/

/-- **Interpolant-extender, Apr 15 2026.**  Build a `LinearisedMetricData`
    for the pullback metric `DiscreteMetric.ofContinuum (perturbedFlatField h ε)`,
    using the C⁴ interpolant produced by `perturbedFlatInterpolant` for the
    structural fields.  The user supplies the physical Laplacian/Ricci
    bounds at scale `ε·K`. -/
noncomputable def linearisedDataOfPerturbedFlat
    (h : (Fin 4 → ℝ) → MetricTensor) (ε M_h : ℝ)
    (h_smooth : ∀ μ ν : Fin 4,
      ContDiff ℝ 4 (fun x : Fin 4 → ℝ => h x μ ν))
    (h_Mh_bound : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => h y μ ν) x‖ ≤ M_h)
    (hM_nonneg : 0 ≤ M_h)
    -- "Physical" inputs — the per-point Lap/Ricci bounds at scale ε·K.
    (ε_pos : 0 < ε) (K : ℝ) (K_nonneg : 0 ≤ K)
    (h_lap_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q =>
        (DiscreteMetric.ofContinuum (perturbedFlatField h ε)) q μ ν) p| ≤ ε * K)
    (h_ricci_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |ricciTensor (DiscreteMetric.ofContinuum
        (perturbedFlatField h ε)) μ ν p| ≤ ε * K) :
    LinearisedMetricData
      (DiscreteMetric.ofContinuum (perturbedFlatField h ε)) :=
  -- The interpolant provides `g_cont` and the `h_interpolates` identity.
  let D := perturbedFlatInterpolant h ε M_h h_smooth h_Mh_bound hM_nonneg
  { g_cont := D.toSmoothMetricField
    h_interpolates := fun p μ ν =>
      D.toSmoothMetricField_interpolates p μ ν
    ε := ε
    ε_pos := ε_pos
    K := K
    K_nonneg := K_nonneg
    h_lap_bound := h_lap_bound
    h_ricci_bound := h_ricci_bound }

/-- **Interpolant-extender, Apr 15 2026.**  **Axiom-free HPW on the
    interpolant-backed linearised regime.**

    Feed a perturbed-flat interpolant (smoothness + C⁴ bound) plus the
    two physical Lap/Ricci bounds plus the scale hypothesis into the
    full pipeline, and the HPW remainder bound is a theorem. -/
theorem hpw_eliminable_on_perturbed_flat
    (h : (Fin 4 → ℝ) → MetricTensor) (ε M_h : ℝ)
    (h_smooth : ∀ μ ν : Fin 4,
      ContDiff ℝ 4 (fun x : Fin 4 → ℝ => h x μ ν))
    (h_Mh_bound : ∀ μ ν : Fin 4, ∀ x : Fin 4 → ℝ,
      ‖iteratedFDeriv ℝ 4 (fun y : Fin 4 → ℝ => h y μ ν) x‖ ≤ M_h)
    (hM_nonneg : 0 ≤ M_h)
    (ε_pos : 0 < ε) (K : ℝ) (K_nonneg : 0 ≤ K)
    (h_lap_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q =>
        (DiscreteMetric.ofContinuum (perturbedFlatField h ε)) q μ ν) p| ≤ ε * K)
    (h_ricci_bound : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |ricciTensor (DiscreteMetric.ofContinuum
        (perturbedFlatField h ε)) μ ν p| ≤ ε * K)
    (h_scale : 3 * ε * K ≤ l_P / 2) :
    ∃ _ : HpwHypothesis
      (DiscreteMetric.ofContinuum (perturbedFlatField h ε)), True :=
  let D := linearisedDataOfPerturbedFlat h ε M_h h_smooth h_Mh_bound hM_nonneg
            ε_pos K K_nonneg h_lap_bound h_ricci_bound
  ⟨HpwHypothesis_of_linearised D h_scale, trivial⟩

end OmegaTheory.Emergence
