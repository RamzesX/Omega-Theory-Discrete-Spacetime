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

/-! ## Controlled `ℓ²`-type bounds on a finite region

The brief asks for a sanity theorem of the form "the coarse-grained
field has bounded `L²` norm over a finite region." Two versions:

**Sharp bound** (`coarseGrain_info_sharp_bound`): for any non-empty
`region`, the sum of `|ψ|²` is bounded by
`region.card · exp(− min_{p ∈ region} I_KL)`. No positivity hypothesis
on `I_KL` is needed — the minimum is well-defined for any finite
non-empty Finset and the exponential handles negative values cleanly.
This is the form the brief targets.

**Weak Gibbs-form bound** (`coarseGrain_info_bounded`): preserved for
backward compatibility with `QmBridgePaper.lean` and the narrative
paper. Assumes the Gibbs-regime hypothesis
`∀ p ∈ region, 0 ≤ I_KL(g, g₀, p)` and proves `sum |ψ|² ≤ region.card`.
Kept because (a) it is cited by `paper_coarseGrain_exists` in
`QmBridgePaper.lean` and by PAPER_DRAFT.md §4.2, and (b) its
hypothesis is a familiar physical shape even though the sharp form
subsumes it mathematically (when `min I_KL ≥ 0`).

**Upstream theorem landed** (2026-04-15, Capella, team v2-apr15-lean).
The Gibbs hypothesis `∀ p ∈ region, 0 ≤ informationDensityKL ...`
in the weak form is now a theorem `informationDensityKL_nonneg_of_wellDefined`
in `OmegaTheory.Conservation.InformationKL`: at the reference metric
`g = g₀` with unit-volume calibration `|det g(p)| ≥ 1`, the density is
`≥ 2 ≥ 0`.  Matches `DiscreteMetric.flat` exactly; see also
`informationDensityKL_flat_nonneg` for the direct flat-spacetime corollary.
General non-negativity for arbitrary `(g, g₀)` pairs would require a
closed-form Gaussian-KL inequality, which Mathlib v4.29 does not
currently ship.  The weak-form bound below still takes the Gibbs
hypothesis as an argument to remain agnostic to the calibration regime. -/

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

/-- Pointwise sharp bound: `|ψ(p,n)|² ≤ exp(− I_KL(g(n), g₀, q))` for
    every `q` with `I_KL(g(n), g₀, q) ≤ I_KL(g(n), g₀, p)`. In
    particular, in the sharp L² theorem this is applied with `q` the
    argmin of `I_KL` over the region. -/
theorem sq_abs_coarseGrain_le_exp_min
    (s : SnapshotSequence) (p q : LatticePoint) (n : ℕ)
    (h : informationDensityKL (s.metric n) s.reference q ≤
         informationDensityKL (s.metric n) s.reference p) :
    (‖coarseGrain s p n‖) ^ 2 ≤
      Real.exp (- informationDensityKL (s.metric n) s.reference q) := by
  rw [sq_abs_coarseGrain]
  exact Real.exp_le_exp.mpr (by linarith)

/-- **Sharp finite-region `ℓ²` bound**: for any non-empty `region`,

      `∑_{p ∈ region} |ψ(p, n)|² ≤ |region| · exp(− min_{p ∈ region} I_KL(g(n), g₀, p))`.

    This is the form targeted by the brief's
    "`exp(−min(KL)) · |F|`" sanity property. No positivity
    hypothesis on `I_KL` is required; the exponential handles negative
    values, and `Finset.min'` is well-defined on any non-empty finite
    set.

    The bound is tight when `I_KL` is constant on the region (every
    term in the sum equals `exp(−I_KL)` and the bound is an
    equality up to the cast `|region| · exp(...)`).

    See `coarseGrain_info_bounded` below for the weak Gibbs-form
    variant that is easier to cite when a Gibbs hypothesis is already
    in hand. -/
theorem coarseGrain_info_sharp_bound
    (s : SnapshotSequence) (region : Finset LatticePoint) (n : ℕ)
    (hne : region.Nonempty) :
    (region.sum fun p => (‖coarseGrain s p n‖) ^ 2) ≤
      (region.card : ℝ) * Real.exp (-((region.image
        fun p => informationDensityKL (s.metric n) s.reference p).min'
          (hne.image _))) := by
  set m_I : ℝ :=
    (region.image fun p => informationDensityKL (s.metric n) s.reference p).min'
      (hne.image _) with hm_I
  have hterm : ∀ p ∈ region,
      (‖coarseGrain s p n‖) ^ 2 ≤ Real.exp (-m_I) := by
    intro p hp
    rw [sq_abs_coarseGrain]
    apply Real.exp_le_exp.mpr
    have hmem : informationDensityKL (s.metric n) s.reference p ∈
        region.image fun q => informationDensityKL (s.metric n) s.reference q :=
      Finset.mem_image.mpr ⟨p, hp, rfl⟩
    have hmin : m_I ≤ informationDensityKL (s.metric n) s.reference p := by
      rw [hm_I]; exact Finset.min'_le _ _ hmem
    linarith
  calc (region.sum fun p => (‖coarseGrain s p n‖) ^ 2)
      ≤ region.sum (fun _ => Real.exp (-m_I)) :=
          Finset.sum_le_sum hterm
    _ = (region.card : ℝ) * Real.exp (-m_I) := by
          rw [Finset.sum_const, nsmul_eq_mul]

/-- **Finite-region `ℓ²` bound**: if the KL information density is
    nonneg on `region`, the total squared-amplitude sum is bounded
    by the cardinality of the region.

    This is the `coarseGrain_info_bounded` sanity theorem required by
    the brief. It controls the `L²` mass of the coarse-grained field
    over any finite patch of lattice, with the bound being simply the
    volume of the patch (in lattice units). Subsumed by
    `coarseGrain_info_sharp_bound` when the region is non-empty, but
    preserved here because (a) no non-emptiness hypothesis is needed
    and (b) it is cited by `paper_coarseGrain_exists` downstream. -/
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

/-! ## Phase-accepting variant with explicit effective mass

Downstream consumers (`DispersionFromLattice`, `schrodinger_prover`) need a
signature that carries an explicit phase function and an effective mass
parameter `m : ℝ`, so that a plane-wave ansatz
`ψ(p, n) = |ψ| · exp(i · (k · p − ω(m) · n))` can be slotted in without
touching the amplitude. The amplitude is deliberately mass-independent:
`|ψ|² = exp(−I_KL)` is a Born-rule-shaped Gibbs weight, and in the
non-relativistic Schrödinger regime `m` enters only through the kinetic
propagator `(ℏ²/2m) Δ`, i.e. through the phase, not the probability
density.

This variant is a strict generalisation: `coarseGrain` is recovered as
`coarseGrainWithPhase s (fun _ _ => 0) m` for any `m`. -/

/-- The coarse-graining map with an explicit **phase function** and an
    explicit **effective mass** `m : ℝ`.

    Amplitude: `|ψ(p, n)| = exp(−I_KL(g(n), g₀, p) / 2)` — identical to
    the mass-free `coarseGrain`, independent of `m`.

    Phase: `arg ψ(p, n) = phase p n`, a user-supplied real function.

    The `m` parameter is **not used in the amplitude**. It is carried as
    a first-class argument so that downstream theorems about the phase
    (dispersion, Schrödinger evolution) have a concrete hook for `m`
    without plumbing a mass through every call site. A future
    `coarseGrain_phase_from_mass` helper in `DispersionFromLattice` can
    instantiate `phase` as a plane-wave with frequency depending on `m`.

    **Mass identification with `SpecialRelativity.relativisticEnergy`.**
    The `m : ℝ` argument is the **rest mass** of the pattern being
    coarse-grained, taken as a free external parameter. It does *not*
    enter the amplitude (see `abs_coarseGrainWithPhase`,
    `sq_abs_coarseGrainWithPhase`) and only affects the output through
    the user-supplied `phase`. The intended instantiation is a
    plane-wave ansatz
    ```
    phase p n := k · p − ω(m, k) · n,
    ℏ · ω(m, k) = relativisticEnergy (ℏ · k) m
    ```
    in which the same `m` parametrises `relativisticEnergy`.

    **What is theorem-backed in *this* file** — phase/mass-independence
    of `|ψ|²` (`abs_coarseGrainWithPhase`, `sq_abs_coarseGrainWithPhase`),
    the zero-phase specialisation to `coarseGrain`
    (`coarseGrainWithPhase_zero_phase`), the flat-vacuum corollary, and
    the L² bounds (weak and sharp). **What is theorem-backed downstream
    and cited narratively here**: `DispersionBridge.nonRelativistic_energy_approx`
    bounds the non-relativistic limit of the dispersion by
    `|relativisticEnergy p m − (mc² + p²/(2m))| ≤ p⁴/(4 m³ c²)`, and
    `SchrodingerFromLattice.coarseGrainWithPhase_satisfies_schrodinger_static_zero_phase`
    exercises `coarseGrainWithPhase s (fun _ _ => 0) m` through a
    Schrödinger residue bound under static-metric and regularity
    hypotheses. Composing `coarseGrainWithPhase s (planeWavePhase k ω) m`
    end-to-end through a full Schrödinger limit (non-static sequences,
    non-zero phase) is not yet a landed theorem.

    **Scope of `m`.** V2 does *not* derive `m` from lattice defect
    structure: a future construction identifying `m` with a
    defect-charge / winding number would close that gap, but at this
    stage the identification between the `m` carried here and the `m`
    in `relativisticEnergy` is **definitional, not theorem-level** —
    they are the same Lean binder. -/
noncomputable def coarseGrainWithPhase
    (s : SnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ)
    (_m : ℝ) : LatticeComplexField :=
  fun p n =>
    (coarseGrainAmplitude s p n : ℂ) *
      Complex.exp (Complex.I * (phase p n : ℂ))

/-- `coarseGrainWithPhase` generalises `coarseGrain`: taking the zero phase
    (and any mass) reproduces the original map exactly. -/
theorem coarseGrainWithPhase_zero_phase
    (s : SnapshotSequence) (m : ℝ) (p : LatticePoint) (n : ℕ) :
    coarseGrainWithPhase s (fun _ _ => 0) m p n = coarseGrain s p n := by
  unfold coarseGrainWithPhase coarseGrain coarseGrainPhase
  simp

/-- The amplitude of the phase-accepting variant equals the mass-free
    amplitude — independent of both `phase` and `m`. This is the
    formal statement that `|ψ|` does not see the mass. -/
theorem abs_coarseGrainWithPhase
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖coarseGrainWithPhase s phase m p n‖ = coarseGrainAmplitude s p n := by
  unfold coarseGrainWithPhase
  rw [norm_mul]
  have h1 : ‖((coarseGrainAmplitude s p n : ℂ))‖ =
      coarseGrainAmplitude s p n := by
    rw [Complex.norm_real,
      Real.norm_of_nonneg (coarseGrainAmplitude_nonneg s p n)]
  have h2 : ‖Complex.exp (Complex.I * (phase p n : ℂ))‖ = 1 := by
    rw [Complex.norm_exp]
    simp [Complex.ofReal_re, Complex.ofReal_im]
  rw [h1, h2, mul_one]

/-- Squared magnitude of the phase-accepting variant is the same Gibbs
    weight of the KL information density: mass and phase do not enter
    `|ψ|²`. -/
theorem sq_abs_coarseGrainWithPhase
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) :
    (‖coarseGrainWithPhase s phase m p n‖) ^ 2 =
      Real.exp (- (informationDensityKL (s.metric n) s.reference p)) := by
  rw [abs_coarseGrainWithPhase]
  unfold coarseGrainAmplitude
  rw [← Real.exp_nat_mul]
  congr 1
  ring

/-- Non-negativity of `|ψ|²` for the phase-accepting variant. This is
    the `coarseGrainL_nonneg_sq` sanity property required by the brief:
    squared magnitudes are non-negative (trivially, since they are
    `exp` of a real number). -/
theorem sq_abs_coarseGrainWithPhase_nonneg
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) :
    0 ≤ (‖coarseGrainWithPhase s phase m p n‖) ^ 2 := by
  rw [sq_abs_coarseGrainWithPhase]
  exact le_of_lt (Real.exp_pos _)

/-- On a flat snapshot sequence with zero phase, the phase-accepting
    variant is the constant amplitude `exp(−1)`, for any mass `m`.
    This is the `coarseGrainL_flat_is_constant` sanity property from
    the brief: vacuum + flat metric ⇒ uniform wavefunction. -/
theorem coarseGrainWithPhase_flat
    (m : ℝ) (p : LatticePoint) (n : ℕ) :
    coarseGrainWithPhase SnapshotSequence.flat (fun _ _ => 0) m p n =
      (Real.exp (-1) : ℂ) := by
  rw [coarseGrainWithPhase_zero_phase, coarseGrain_flat]

/-- Finite-region `ℓ²` bound for the phase-accepting variant: identical
    to `coarseGrain_info_bounded` since phase and mass do not enter
    `|ψ|²`. -/
theorem coarseGrainWithPhase_info_bounded
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ)
    (h : ∀ p ∈ region, 0 ≤ informationDensityKL (s.metric n) s.reference p) :
    (region.sum fun p => (‖coarseGrainWithPhase s phase m p n‖) ^ 2) ≤
      region.card := by
  calc region.sum (fun p => (‖coarseGrainWithPhase s phase m p n‖) ^ 2)
      = region.sum (fun p => (‖coarseGrain s p n‖) ^ 2) := by
          apply Finset.sum_congr rfl
          intro p _
          rw [sq_abs_coarseGrainWithPhase, sq_abs_coarseGrain]
    _ ≤ region.card := coarseGrain_info_bounded s region n h

/-- **Sharp finite-region `ℓ²` bound for the phase-accepting variant**:
    the phased `|ψ|²` inherits the sharp bound from
    `coarseGrain_info_sharp_bound`, since the amplitude is phase- and
    mass-independent. -/
theorem coarseGrainWithPhase_info_sharp_bound
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ)
    (hne : region.Nonempty) :
    (region.sum fun p => (‖coarseGrainWithPhase s phase m p n‖) ^ 2) ≤
      (region.card : ℝ) * Real.exp (-((region.image
        fun p => informationDensityKL (s.metric n) s.reference p).min'
          (hne.image _))) := by
  have hrw : (region.sum fun p => (‖coarseGrainWithPhase s phase m p n‖) ^ 2) =
      (region.sum fun p => (‖coarseGrain s p n‖) ^ 2) := by
    apply Finset.sum_congr rfl
    intro p _
    rw [sq_abs_coarseGrainWithPhase, sq_abs_coarseGrain]
  rw [hrw]
  exact coarseGrain_info_sharp_bound s region n hne

/-! ## Plane-wave adapters on the lattice

Utilities for instantiating `coarseGrainWithPhase` with a plane-wave
phase `phase p n := k · p − ω · n`. `LatticePoint` is
`Fin 4 → ℤ` (see `Spacetime/Lattice.lean`), so we provide the two
missing pieces: an integer dot product `k · p` cast to `ℝ`, and the
ℓ² norm `‖p‖₂` as a real. These are the adapters `dispersion_wire`
asked for; they carry no physics of their own, only bookkeeping. -/

/-- Integer dot product of two lattice points, cast to ℝ. Used by the
    plane-wave phase `phase p n := latticeDot k p − ω * n`. -/
noncomputable def latticeDot (k p : LatticePoint) : ℝ :=
  ((Finset.univ.sum fun i : Fin 4 => k i * p i : ℤ) : ℝ)

/-- `latticeDot` is symmetric — trivially, since multiplication on ℤ is. -/
theorem latticeDot_symm (k p : LatticePoint) :
    latticeDot k p = latticeDot p k := by
  unfold latticeDot
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- Squared ℓ² norm of a lattice point, as a non-negative real. Defined
    via the cast of the integer sum of squares. Kept separate from
    `latticeL2Norm` so `sqrt`-free identities stay clean. -/
noncomputable def latticeL2NormSq (p : LatticePoint) : ℝ :=
  ((Finset.univ.sum fun i : Fin 4 => (p i) ^ 2 : ℤ) : ℝ)

theorem latticeL2NormSq_nonneg (p : LatticePoint) :
    0 ≤ latticeL2NormSq p := by
  unfold latticeL2NormSq
  have : (0 : ℤ) ≤ Finset.univ.sum fun i : Fin 4 => (p i) ^ 2 :=
    Finset.sum_nonneg (fun i _ => sq_nonneg _)
  exact_mod_cast this

/-- The ℓ² norm of a lattice point, as a non-negative real. Provided
    for the anticipated 4D plane-wave instantiation in
    `DispersionBridge`: feeding `ℏ · latticeL2Norm k` into the scalar
    `p` slot of `relativisticEnergy p m` would give the dispersion
    `ω(m, k) = relativisticEnergy (ℏ · ‖k‖₂) m / ℏ`. The adapter itself
    is independent of any theorem about that dispersion; the sqrt-free
    identities (`latticeL2Norm_sq`, `latticeL2Norm_nonneg`,
    `latticeL2Norm_zero`) are what is theorem-backed here. -/
noncomputable def latticeL2Norm (p : LatticePoint) : ℝ :=
  Real.sqrt (latticeL2NormSq p)

/-- The ℓ² norm is non-negative. -/
theorem latticeL2Norm_nonneg (p : LatticePoint) : 0 ≤ latticeL2Norm p :=
  Real.sqrt_nonneg _

/-- Squaring the ℓ² norm recovers `latticeL2NormSq`. -/
theorem latticeL2Norm_sq (p : LatticePoint) :
    (latticeL2Norm p) ^ 2 = latticeL2NormSq p := by
  unfold latticeL2Norm
  exact Real.sq_sqrt (latticeL2NormSq_nonneg p)

/-- The zero lattice point has zero ℓ² norm. Sanity lemma for the
    plane-wave instantiation at `k = 0` (constant ψ up to time phase). -/
theorem latticeL2Norm_zero : latticeL2Norm (fun _ => (0 : ℤ)) = 0 := by
  unfold latticeL2Norm latticeL2NormSq
  simp

/-- **Plane-wave phase** built from an integer wavevector `k` and a
    real frequency `ω`. Intended use:
    `coarseGrainWithPhase s (planeWavePhase k ω) m`, with
    `ω = relativisticEnergy (hbar * latticeL2Norm k) m / hbar`
    (see `DispersionBridge`). -/
noncomputable def planeWavePhase
    (k : LatticePoint) (ω : ℝ) : LatticePoint → ℕ → ℝ :=
  fun p n => latticeDot k p - ω * (n : ℝ)

/-- At `k = 0` and `ω = 0`, the plane-wave phase is identically zero,
    recovering the mass-free `coarseGrain`. -/
theorem planeWavePhase_zero (p : LatticePoint) (n : ℕ) :
    planeWavePhase (fun _ => (0 : ℤ)) 0 p n = 0 := by
  unfold planeWavePhase latticeDot
  simp

end OmegaTheory.Emergence
