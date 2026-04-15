/-
  OmegaTheory.Emergence.SnapshotDynamics

  **Phase 1 of the QM-bridge plan.**  A dynamical update rule for
  `SnapshotSequence` that advances the metric by one Planck tick via
  a local Laplacian-of-metric feedback:

        metric (n+1) μν (p) = metric n μν (p)
                             + t_P · F(metric n) μν (p)

  where the metric-functional `F` is the component-wise discrete
  Laplacian:

        F(g) μν (p) := discreteLaplacian (fun q => g q μ ν) p .

  ## Why this choice of F

  1. It matches the Schrödinger RHS shape: `coarseGrain` is built from
     `informationDensityKL g g₀ p`, and the Laplacian of the metric
     lifts cleanly through the KL construction to a Laplacian of
     `|ψ|²`.
  2. It is trivial on the flat Minkowski background (every metric
     component is spatially constant, so `discreteLaplacian` on it
     vanishes).  The dynamical sequence therefore agrees with the
     existing flat static sequence on the vacuum.
  3. The per-tick change is exactly `t_P · F(g n)` by construction,
     so the `O(t_P)` control needed for Phase 2 is immediate.
  4. No new external math is introduced: `discreteLaplacian` is the
     real-valued lattice Laplacian already used throughout V2
     (`OmegaTheory.Spacetime.Operators`).

  ## Exports

  * `metricLaplacianFunctional g` — the functional `F` above.
  * `DynamicalSnapshotSequence` — bundles a base metric, a reference,
    and the recorded fact that tick `n+1`'s metric arises from tick
    `n`'s metric via the Laplacian-of-metric update with step `t_P`.
  * `DynamicalSnapshotSequence.toSnapshotSequence` — forgetful map
    into the static-style `SnapshotSequence`.
  * `minkowskiDynamicalSequence` — the flat Minkowski instance.
  * `DynamicalSnapshotSequence.static_reduces_to_snapshot_sequence` —
    the F ≡ 0 specialisation reduces to a static `SnapshotSequence`.
  * `DynamicalSnapshotSequence.metric_update_linear_in_t_P` — the
    per-tick metric change is exactly `t_P · F(metric n)`.
  * `coarseGrain_dynamic_diff_metric` — the structural consumer for
    Phase 2: the raw per-tick metric difference expressed as
    `t_P · F(metric n)`.

  ## No `sorry`.  No new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## The metric-level Laplacian functional `F` -/

/-- The functional `F(g)` used by the dynamical update rule.  For each
    component `(μ, ν)` and lattice point `p`, it takes the discrete
    Laplacian of the scalar field `q ↦ g q μ ν`.

    This is the same formula as `discreteLaplacian` on a scalar field,
    applied component-wise.  It takes a `DiscreteMetric` in and returns
    a new `DiscreteMetric`-shaped object. -/
noncomputable def metricLaplacianFunctional
    (g : DiscreteMetric) : DiscreteMetric :=
  fun p μ ν => discreteLaplacian (fun q => g q μ ν) p

/-- `F` vanishes on any metric whose components are spatially constant. -/
theorem metricLaplacianFunctional_of_constant
    (c : Fin 4 → Fin 4 → ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    metricLaplacianFunctional (fun _ => fun i j => c i j) p μ ν = 0 := by
  unfold metricLaplacianFunctional
  exact discreteLaplacian_const _ _

/-- `F` vanishes on the flat Minkowski metric. -/
theorem metricLaplacianFunctional_flat (p : LatticePoint) (μ ν : Fin 4) :
    metricLaplacianFunctional DiscreteMetric.flat p μ ν = 0 := by
  unfold metricLaplacianFunctional DiscreteMetric.flat
  exact discreteLaplacian_const _ _

/-! ## The dynamical update rule at the metric level -/

/-- Advance a `DiscreteMetric` by one Planck tick using the
    Laplacian-of-metric functional:

        advance g p μ ν = g p μ ν + t_P · F(g) p μ ν .

    This is *defined* as an explicit formula on `DiscreteMetric`;
    subsequent theorems expose its key algebraic properties. -/
noncomputable def advanceMetric (g : DiscreteMetric) : DiscreteMetric :=
  fun p μ ν => g p μ ν + t_P * metricLaplacianFunctional g p μ ν

/-- The per-tick increment of `advanceMetric` at `(p, μ, ν)` is exactly
    `t_P · F(g) p μ ν`. -/
theorem advanceMetric_sub (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    advanceMetric g p μ ν - g p μ ν
      = t_P * metricLaplacianFunctional g p μ ν := by
  unfold advanceMetric
  ring

/-- Advancing the flat Minkowski metric leaves it unchanged (since `F`
    vanishes on constants). -/
theorem advanceMetric_flat (p : LatticePoint) (μ ν : Fin 4) :
    advanceMetric DiscreteMetric.flat p μ ν =
      DiscreteMetric.flat p μ ν := by
  unfold advanceMetric
  rw [metricLaplacianFunctional_flat]
  ring

/-- If `F(g)` vanishes identically, `advanceMetric` is the identity. -/
theorem advanceMetric_of_zero_functional
    (g : DiscreteMetric)
    (hF : ∀ p μ ν, metricLaplacianFunctional g p μ ν = 0)
    (p : LatticePoint) (μ ν : Fin 4) :
    advanceMetric g p μ ν = g p μ ν := by
  unfold advanceMetric
  rw [hF p μ ν]
  ring

/-! ## Iterated advance -/

/-- Iterate `advanceMetric` `n` times. -/
noncomputable def advanceMetricN (g : DiscreteMetric) : ℕ → DiscreteMetric
  | 0 => g
  | n + 1 => advanceMetric (advanceMetricN g n)

theorem advanceMetricN_zero (g : DiscreteMetric) :
    advanceMetricN g 0 = g := rfl

theorem advanceMetricN_succ (g : DiscreteMetric) (n : ℕ) :
    advanceMetricN g (n + 1) = advanceMetric (advanceMetricN g n) := rfl

/-- If `F` vanishes on `g` AND on every iterate, `advanceMetricN` is
    the identity.  This is the hypothesis that makes the dynamical
    sequence reduce to a static one. -/
theorem advanceMetricN_of_always_flat_functional
    (g : DiscreteMetric)
    (hF : ∀ n p μ ν, metricLaplacianFunctional (advanceMetricN g n) p μ ν = 0)
    (n : ℕ) : advanceMetricN g n = g := by
  induction n with
  | zero => rfl
  | succ k ih =>
      rw [advanceMetricN_succ]
      funext p μ ν
      have hstep : advanceMetric (advanceMetricN g k) p μ ν
                    = advanceMetricN g k p μ ν :=
        advanceMetric_of_zero_functional (advanceMetricN g k) (hF k) p μ ν
      rw [hstep]
      exact congrFun (congrFun (congrFun ih p) μ) ν

/-- On the flat Minkowski metric every iterate is flat. -/
theorem advanceMetricN_flat (n : ℕ) :
    advanceMetricN DiscreteMetric.flat n = DiscreteMetric.flat := by
  induction n with
  | zero => rfl
  | succ k ih =>
      rw [advanceMetricN_succ, ih]
      funext p μ ν
      exact advanceMetric_flat p μ ν

/-! ## The dynamical snapshot sequence -/

/-- A `DynamicalSnapshotSequence` is a `SnapshotSequence`-shaped object
    whose tick-`n` metric is obtained from the tick-0 metric by `n`
    iterations of `advanceMetric`.

    Concretely, we store the initial metric and the reference; the
    sequence of metrics is derived.  This guarantees that every
    instance satisfies the dynamical update equation by construction —
    no side condition is needed. -/
structure DynamicalSnapshotSequence where
  /-- The initial metric at tick 0. -/
  initial : DiscreteMetric
  /-- The reference (background) metric. -/
  reference : DiscreteMetric

namespace DynamicalSnapshotSequence

/-- The metric at tick `n`: iterate `advanceMetric` `n` times starting
    from `initial`. -/
noncomputable def metric (d : DynamicalSnapshotSequence) (n : ℕ) :
    DiscreteMetric :=
  advanceMetricN d.initial n

@[simp] theorem metric_zero (d : DynamicalSnapshotSequence) :
    d.metric 0 = d.initial := rfl

theorem metric_succ (d : DynamicalSnapshotSequence) (n : ℕ) :
    d.metric (n + 1) = advanceMetric (d.metric n) := rfl

/-- **Update rule, stated algebraically.**  At every tick `n`,

        d.metric (n+1) p μ ν
          = d.metric n p μ ν + t_P · F(d.metric n) p μ ν.

    This is the dynamical update rule: the metric at tick `n+1`
    depends on the metric at tick `n` via a specific local
    computation. -/
theorem update_rule (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.metric (n + 1) p μ ν
      = d.metric n p μ ν +
        t_P * metricLaplacianFunctional (d.metric n) p μ ν := by
  rw [metric_succ]
  rfl

/-- **Per-tick change linear in `t_P`.**  The tick-`n` → tick-`n+1`
    metric difference is exactly `t_P · F(d.metric n)`.  No big-`O`;
    this is an equality.

    This is the `metric_update_linear_in_t_P` deliverable from the
    Phase-1 brief. -/
theorem metric_update_linear_in_t_P (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.metric (n + 1) p μ ν - d.metric n p μ ν
      = t_P * metricLaplacianFunctional (d.metric n) p μ ν := by
  rw [update_rule d n p μ ν]
  ring

/-- The forgetful map into the static-style `SnapshotSequence`.  Two
    downstream files (`CoarseGrainingMap`, `SchrodingerFromLattice`)
    already operate on `SnapshotSequence`; this lets them consume a
    dynamical sequence as input. -/
noncomputable def toSnapshotSequence
    (d : DynamicalSnapshotSequence) : SnapshotSequence where
  metric := d.metric
  reference := d.reference

@[simp] theorem toSnapshotSequence_metric
    (d : DynamicalSnapshotSequence) (n : ℕ) :
    d.toSnapshotSequence.metric n = d.metric n := rfl

@[simp] theorem toSnapshotSequence_reference
    (d : DynamicalSnapshotSequence) :
    d.toSnapshotSequence.reference = d.reference := rfl

end DynamicalSnapshotSequence

/-! ## Static reduction

    When `F` vanishes on `d.initial` and on every iterate, the
    dynamical update is the identity and the dynamical sequence
    coincides with a static `SnapshotSequence`. -/

/-- The static case: `F(d.metric n) ≡ 0` for every `n`.  This is the
    hypothesis under which the dynamical rule reduces to a static
    sequence. -/
def DynamicalSnapshotSequence.HasZeroFunctional
    (d : DynamicalSnapshotSequence) : Prop :=
  ∀ n p μ ν,
    metricLaplacianFunctional (d.metric n) p μ ν = 0

/-- **Static reduction theorem.**  If `F` vanishes on every iterate,
    the metric is constant in tick, i.e. `d.metric n = d.initial` for
    every `n`, and the induced `SnapshotSequence` is static. -/
theorem DynamicalSnapshotSequence.static_reduces_to_snapshot_sequence
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional) :
    d.toSnapshotSequence.IsStatic := by
  intro n m
  have hn : d.metric n = d.initial := by
    unfold DynamicalSnapshotSequence.metric
    exact advanceMetricN_of_always_flat_functional d.initial
      (fun k => by
        have := hF k
        intro p μ ν
        simpa [DynamicalSnapshotSequence.metric] using this p μ ν) n
  have hm : d.metric m = d.initial := by
    unfold DynamicalSnapshotSequence.metric
    exact advanceMetricN_of_always_flat_functional d.initial
      (fun k => by
        have := hF k
        intro p μ ν
        simpa [DynamicalSnapshotSequence.metric] using this p μ ν) m
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_metric]
  rw [hn, hm]

/-! ## The flat Minkowski dynamical instance

    On the flat metric, `F` vanishes identically, so the dynamical
    sequence is "trivial" — it equals the static Minkowski sequence
    tick-by-tick. -/

/-- The flat Minkowski dynamical sequence: start from the flat metric
    and evolve under the Laplacian-of-metric rule.  Because `F`
    vanishes on constants, the sequence is tick-independent. -/
noncomputable def minkowskiDynamicalSequence : DynamicalSnapshotSequence where
  initial := DiscreteMetric.flat
  reference := DiscreteMetric.flat

/-- Every tick of the flat dynamical sequence carries the flat metric. -/
theorem minkowskiDynamicalSequence_metric (n : ℕ) :
    minkowskiDynamicalSequence.metric n = DiscreteMetric.flat := by
  unfold minkowskiDynamicalSequence DynamicalSnapshotSequence.metric
  exact advanceMetricN_flat n

/-- The flat dynamical sequence has `F ≡ 0` on every iterate. -/
theorem minkowskiDynamicalSequence_hasZeroFunctional :
    minkowskiDynamicalSequence.HasZeroFunctional := by
  intro n p μ ν
  rw [minkowskiDynamicalSequence_metric n]
  exact metricLaplacianFunctional_flat p μ ν

/-- The flat dynamical sequence is static (sanity check: the trivial
    instance of Phase 1 satisfies Phase 2's static hypothesis for
    free). -/
theorem minkowskiDynamicalSequence_isStatic :
    minkowskiDynamicalSequence.toSnapshotSequence.IsStatic :=
  DynamicalSnapshotSequence.static_reduces_to_snapshot_sequence
    minkowskiDynamicalSequence
    minkowskiDynamicalSequence_hasZeroFunctional

/-- The forgetful image of the flat dynamical sequence coincides with
    the existing `SnapshotSequence.flat`. -/
theorem minkowskiDynamicalSequence_toSnapshotSequence_eq_flat :
    minkowskiDynamicalSequence.toSnapshotSequence = SnapshotSequence.flat := by
  unfold SnapshotSequence.flat
    DynamicalSnapshotSequence.toSnapshotSequence minkowskiDynamicalSequence
  congr 1
  funext n
  exact minkowskiDynamicalSequence_metric n

/-! ## Phase-2 raw ingredient: per-tick coarse-grain difference

    The rest of this file exposes the *structural* lemma that Phase 2
    consumes.  We do not close the full Schrödinger bound here —
    that is Phase 2's job — but we expose the per-tick metric
    difference as an explicit `t_P · F(g n)`-shaped object. -/

/-- **Structural theorem (the Phase-2 consumer lemma).**

    The per-tick metric change of a dynamical snapshot sequence is
    exactly `t_P` times the Laplacian-of-metric functional at tick
    `n`.  This is the *raw ingredient* Phase 2 feeds into the
    coarse-graining:

        L(d, p, n+1) − L(d, p, n)
            (by chain rule through I_KL)
          = ( ∂L/∂g · (d.metric (n+1) − d.metric n) ) + O(t_P²)
            (by this lemma)
          = t_P · ( ∂L/∂g · F(d.metric n) ) + O(t_P²),

    where the first step is the linearisation of
    `informationDensityKL g g₀ p` in `g` and the second step is this
    lemma.  Phase 2's job is to formalise `∂L/∂g · F(g)` as
    `(−iℏ Δ/2m) · L(g)` plus an `O(ℓ_P)` residual.

    In this file we supply the middle step *as an equality*, leaving
    no ambiguity about the size of the per-tick metric perturbation. -/
theorem coarseGrain_dynamic_diff_metric
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.toSnapshotSequence.metric (n + 1) p μ ν
      - d.toSnapshotSequence.metric n p μ ν
      = t_P * metricLaplacianFunctional (d.metric n) p μ ν := by
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_metric]
  exact d.metric_update_linear_in_t_P n p μ ν

/-- Corollary of `coarseGrain_dynamic_diff_metric`: on a dynamical
    sequence whose functional vanishes at tick `n`, the metric does
    not change from tick `n` to tick `n+1`.  This lifts to "the
    coarse-grained field does not change" via `coarseGrain_static`
    applied locally, and is the bridge Phase 2 uses on the flat /
    near-flat regime. -/
theorem coarseGrain_dynamic_diff_metric_zero_on_flat
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4)
    (hF : metricLaplacianFunctional (d.metric n) p μ ν = 0) :
    d.toSnapshotSequence.metric (n + 1) p μ ν
      = d.toSnapshotSequence.metric n p μ ν := by
  have h := coarseGrain_dynamic_diff_metric d n p μ ν
  rw [hF, mul_zero] at h
  linarith

/-- **Flat-sequence corollary**: on the Minkowski dynamical sequence
    every per-tick metric difference is zero.  Sanity check that the
    non-trivial `DynamicalSnapshotSequence` machinery collapses to
    the static flat case on the vacuum. -/
theorem minkowskiDynamicalSequence_metric_diff_zero
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    minkowskiDynamicalSequence.toSnapshotSequence.metric (n + 1) p μ ν
      = minkowskiDynamicalSequence.toSnapshotSequence.metric n p μ ν := by
  apply coarseGrain_dynamic_diff_metric_zero_on_flat
  exact minkowskiDynamicalSequence_hasZeroFunctional n p μ ν

end OmegaTheory.Emergence
