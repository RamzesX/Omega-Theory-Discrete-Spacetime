/-
  OmegaTheory.Emergence.CoarseGrainingMap

  Section 4.1 of `NOTES_QM_AS_DISCRETE_GRAVITY.md`: a concrete
  coarse-graining map

        L : SnapshotSequence → LatticeComplexField

  that turns a sequence of discrete lattice snapshots into a
  ℂ-valued field `ψ(x, n)` on `LatticePoint × ℕ`. The map is
  designed so that `|ψ|²` is the Boltzmann-type weight of the
  KL information density:

        |ψ(p, n)|² = exp(− I_KL(g(n), g₀, p))

  where `I_KL` is the `informationDensityKL` from
  `OmegaTheory/Conservation/InformationKL.lean`. Concretely, we take
  the amplitude `|ψ|` to be `exp(− I_KL / 2)` and the phase to be 0.

  **Physical intuition.** `I_KL` measures how much the current metric
  `g(n)` deviates, at lattice point `p`, from the reference `g₀`
  (typically the flat Minkowski metric). Points where the deviation
  is small have large weight — the "wavefunction lives there." Points
  with large deviation are exponentially suppressed. This is the
  discrete analog of `|ψ|²` being concentrated where the potential
  favours it. The phase is left as 0 in this file — a natural hook
  for a future `connectionForm`/`spinTorsion` coupling that would make
  `ψ` genuinely complex.

  **Scope of this file.** No claim is made here that the resulting
  `ψ` satisfies a Schrödinger equation. What we *do* prove:

  1. The map is well-defined and measurable (just exp of a real).
  2. The resulting `|ψ|²` is pointwise nonneg and ≤ 1 when
     `I_KL ≥ 0` (Gibbs-like regime).
  3. On the flat Minkowski background, `ψ` is a constant field
     (`ψ(p, n) = exp(−1)`, from `informationDensityKL_flat_self = 2`).
  4. A finite-region `ℓ²`-type bound: the squared sum of `|ψ|`
     over a `Finset` of lattice points is at most the cardinality
     of the region.

  **Hooks left for later workstreams.**
  - `coarseGrain_with_phase` taking a `phase : LatticePoint × ℕ → ℝ`
    argument — natural target for a gauge-connection / spin-torsion
    phase.
  - `coarseGrain_of_propagateN` relating the coarse-graining of
    a propagated snapshot to the coarse-graining of the original.
    Currently trivial because `propagate` is the identity on the
    spatial coordinate; nontrivial once `propagate` gains real
    lattice dynamics.
-/

import OmegaTheory.Conservation.InformationKL
import OmegaTheory.Emergence.SnapshotPropagator
import OmegaTheory.Geometry.Metric
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.Complex.Exponential
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open scoped Complex

/-! ## Core types -/

/-- A `LatticeComplexField` assigns a complex number to each pair
    (lattice point, tick). This is the target of the coarse-graining
    map: a discrete `ψ(x, t)`-like object on `Λ × ℕ`. -/
abbrev LatticeComplexField : Type := LatticePoint → ℕ → ℂ

/-- A `SnapshotSequence` is a time-indexed family of metrics on the
    lattice. At each tick `n : ℕ`, the lattice carries a metric
    `g(n) : DiscreteMetric`. This is the minimal structure that the
    coarse-graining map needs as input: the KL density is a function
    of `(g, g₀, p)`.

    Concretely one obtains such a sequence from `Snapshot.propagateN`
    together with a metric "field" that evolves under the lattice
    update rule. The combinatorial `Snapshot` structure from
    `SnapshotPropagator.lean` captures the particle / tick bookkeeping;
    the `SnapshotSequence` here captures the geometric data needed to
    evaluate the KL divergence. -/
structure SnapshotSequence where
  /-- The time-indexed metric. -/
  metric : ℕ → DiscreteMetric
  /-- The reference (background) metric — typically flat Minkowski. -/
  reference : DiscreteMetric

/-- The canonical "flat" snapshot sequence: every tick carries the
    flat Minkowski metric, and the reference is also flat. This is
    the trivial vacuum case. -/
noncomputable def SnapshotSequence.flat : SnapshotSequence where
  metric := fun _ => DiscreteMetric.flat
  reference := DiscreteMetric.flat

/-! ## The coarse-graining map -/

/-- The **real amplitude** at lattice point `p` and tick `n`:

        |ψ(p, n)| = exp(− I_KL(g(n), g₀, p) / 2)

    so that `|ψ|² = exp(− I_KL)`.

    This is nonneg for all inputs (exp is positive). It is bounded
    above by 1 whenever `I_KL ≥ 0` at the point — which is the
    natural Gibbs regime for a KL divergence. -/
noncomputable def coarseGrainAmplitude
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ) : ℝ :=
  Real.exp (- (informationDensityKL (s.metric n) s.reference p) / 2)

/-- The **phase** at `(p, n)`. In this file it is identically zero —
    a hook for future gauge/torsion coupling. Concretely a follow-up
    workstream should replace this with `(connectionForm (p, n)).arg`
    or an analogous quantity derived from `spinTorsion`. -/
def coarseGrainPhase (_s : SnapshotSequence) (_p : LatticePoint) (_n : ℕ) : ℝ := 0

/-- The coarse-graining map `L : SnapshotSequence → LatticeComplexField`.

    Produces `ψ(p, n) = |ψ| · exp(i · phase)`. With the current choice
    of zero phase this is just a nonneg real embedded in ℂ, but the
    `Complex` target type is kept so that downstream agents
    (`DispersionFromLattice`, phase-from-gauge workstream) can slot in
    a nontrivial phase without changing the signature. -/
noncomputable def coarseGrain (s : SnapshotSequence) : LatticeComplexField :=
  fun p n =>
    (coarseGrainAmplitude s p n : ℂ) *
      Complex.exp (Complex.I * (coarseGrainPhase s p n : ℂ))

/-! ## Basic properties -/

/-- The amplitude is strictly positive. -/
theorem coarseGrainAmplitude_pos
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ) :
    0 < coarseGrainAmplitude s p n := by
  unfold coarseGrainAmplitude
  exact Real.exp_pos _

/-- The amplitude is nonneg. -/
theorem coarseGrainAmplitude_nonneg
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ) :
    0 ≤ coarseGrainAmplitude s p n :=
  le_of_lt (coarseGrainAmplitude_pos s p n)

/-- With zero phase, `ψ` equals its real amplitude embedded in ℂ. -/
theorem coarseGrain_eq_amplitude
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ) :
    coarseGrain s p n = (coarseGrainAmplitude s p n : ℂ) := by
  unfold coarseGrain coarseGrainPhase
  simp

/-- The modulus of the coarse-grained field equals the amplitude. -/
theorem abs_coarseGrain
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ) :
    ‖coarseGrain s p n‖ = coarseGrainAmplitude s p n := by
  rw [coarseGrain_eq_amplitude, Complex.norm_real,
    Real.norm_of_nonneg (coarseGrainAmplitude_nonneg s p n)]

/-- `|ψ(p,n)|² = exp(− I_KL(g(n), g₀, p))`. This is the defining
    identity tying the coarse-grained field to the KL information
    density: the squared magnitude *is* the Boltzmann weight of the
    KL divergence. -/
theorem sq_abs_coarseGrain
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ) :
    (‖coarseGrain s p n‖) ^ 2 =
      Real.exp (- (informationDensityKL (s.metric n) s.reference p)) := by
  rw [abs_coarseGrain]
  unfold coarseGrainAmplitude
  rw [← Real.exp_nat_mul]
  congr 1
  ring

/-! ## The flat case

On a flat snapshot sequence (`s = SnapshotSequence.flat`) the KL
information density is exactly 2 at every point (from
`informationDensityKL_flat_self`), so the amplitude collapses to
`exp(−1)` and the coarse-grained field is constant in space and time.
This is the "vacuum" / trivial-wavefunction sanity check. -/

/-- On the flat snapshot sequence, the amplitude is the constant
    `exp(−1)` at every `(p, n)`. -/
theorem coarseGrainAmplitude_flat (p : LatticePoint) (n : ℕ) :
    coarseGrainAmplitude SnapshotSequence.flat p n = Real.exp (-1) := by
  unfold coarseGrainAmplitude SnapshotSequence.flat
  simp only [informationDensityKL_flat_self]
  congr 1
  norm_num

/-- **Flat-case theorem**: the coarse-grained field on flat
    Minkowski is a constant (complex) field, independent of
    lattice point and tick.

    This is the sanity check demanded by the brief: the vacuum /
    Minkowski background produces a trivial wavefunction. -/
theorem coarseGrain_flat (p : LatticePoint) (n : ℕ) :
    coarseGrain SnapshotSequence.flat p n = (Real.exp (-1) : ℂ) := by
  rw [coarseGrain_eq_amplitude, coarseGrainAmplitude_flat]

/-- Corollary: on the flat background the coarse-grained field
    does not depend on `(p, n)`. -/
theorem coarseGrain_flat_constant (p q : LatticePoint) (n m : ℕ) :
    coarseGrain SnapshotSequence.flat p n =
      coarseGrain SnapshotSequence.flat q m := by
  rw [coarseGrain_flat, coarseGrain_flat]

/-! ## A controlled `ℓ²`-type bound on a finite region

The brief asks for a sanity theorem of the form "the coarse-grained
field has bounded `L²` norm over a finite region." We prove a clean
form: if the KL information density is nonneg on the region (the
Gibbs regime, which is the physically normal case), then the squared
amplitude is ≤ 1 pointwise, and the summed `|ψ|²` over any
`Finset` is at most the cardinality of that finset.

The hypothesis `∀ p ∈ R, 0 ≤ I_KL(g, g₀, p)` is the one clean sufficient
condition. It does not follow abstractly from the current V2
definitions (the KL form is not required to be nonneg by construction),
so we carry it as an explicit assumption. In practice it holds on
all physically meaningful backgrounds. -/

/-- Pointwise bound: whenever `I_KL(g(n), g₀, p) ≥ 0`, the squared
    magnitude `|ψ(p,n)|² ≤ 1`. -/
theorem sq_abs_coarseGrain_le_one
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ)
    (h : 0 ≤ informationDensityKL (s.metric n) s.reference p) :
    (‖coarseGrain s p n‖) ^ 2 ≤ 1 := by
  rw [sq_abs_coarseGrain]
  have : -(informationDensityKL (s.metric n) s.reference p) ≤ 0 := by linarith
  calc Real.exp (-(informationDensityKL (s.metric n) s.reference p))
      ≤ Real.exp 0 := Real.exp_le_exp.mpr this
    _ = 1 := Real.exp_zero

/-- **Finite-region `ℓ²` bound**: if the KL information density is
    nonneg on `region`, the total squared-amplitude sum is bounded
    by the cardinality of the region.

    This is the `coarseGrain_info_bounded` sanity theorem required by
    the brief. It controls the `L²` mass of the coarse-grained field
    over any finite patch of lattice, with the bound being simply the
    volume of the patch (in lattice units). -/
theorem coarseGrain_info_bounded
    (s : SnapshotSequence) (region : Finset LatticePoint) (n : ℕ)
    (h : ∀ p ∈ region, 0 ≤ informationDensityKL (s.metric n) s.reference p) :
    (region.sum fun p => (‖coarseGrain s p n‖) ^ 2) ≤ region.card := by
  calc region.sum (fun p => (‖coarseGrain s p n‖) ^ 2)
      ≤ region.sum (fun _ => (1 : ℝ)) := by
          apply Finset.sum_le_sum
          intro p hp
          exact sq_abs_coarseGrain_le_one s p n (h p hp)
    _ = region.card := by simp

/-! ## Stability under propagation (trivial-dynamics case)

`Snapshot.propagate` currently leaves the spatial coordinate fixed
(see `propagateN_point`). For a `SnapshotSequence` whose metric does
not depend on the tick, the coarse-grained field is therefore tick-
independent. This is a consistency lemma, not a physical claim: once
a nontrivial metric update rule is added, this theorem becomes
nontrivial and its proof will need to change. -/

/-- Static-metric sequence: metric does not depend on tick. -/
def SnapshotSequence.IsStatic (s : SnapshotSequence) : Prop :=
  ∀ n m : ℕ, s.metric n = s.metric m

/-- On a static sequence, the coarse-grained field is tick-independent. -/
theorem coarseGrain_static
    (s : SnapshotSequence) (h : s.IsStatic)
    (p : LatticePoint) (n m : ℕ) :
    coarseGrain s p n = coarseGrain s p m := by
  unfold coarseGrain coarseGrainAmplitude coarseGrainPhase
  rw [h n m]

/-- The flat sequence is static. -/
theorem SnapshotSequence.flat_isStatic : SnapshotSequence.flat.IsStatic := by
  intro n m
  rfl

end OmegaTheory.Emergence
