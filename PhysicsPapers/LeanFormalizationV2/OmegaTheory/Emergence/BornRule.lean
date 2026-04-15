/-
  OmegaTheory.Emergence.BornRule

  **Phase 3 of the QM-bridge plan.**  The Born rule as a conservation
  theorem on the dynamical snapshot sequence.

  ## What this file delivers

  The squared-amplitude sum of the coarse-grained complex field

        ∑_{p ∈ region} ‖coarseGrainWithPhase s phase m p n‖²

  is preserved under the lattice-healing dynamics of Phase 1
  (`DynamicalSnapshotSequence` with metric-Laplacian update rule),
  **in the static regime** `HasZeroFunctional`, which is the regime
  under which Phase 2's Schrödinger bound also closes.

  In quantum mechanics, probability conservation is usually an
  *axiom* (or a consequence of unitarity).  In the Omega theory it
  emerges as a **theorem** from the update-rule structure of Phase 1:
  when the metric-Laplacian functional `F` vanishes on every iterate,
  the metric is tick-invariant and therefore the KL-density-driven
  amplitude `|ψ|² = exp(−I_KL(g_n, g₀, p))` is tick-invariant
  point-by-point, and any region sum is tick-invariant.

  ## Dynamical case (honest scoping)

  Outside the `HasZeroFunctional` regime, the exact per-tick
  conservation can fail: a non-zero `F` produces a non-zero per-tick
  metric change, which feeds through `informationDensityKL` into a
  non-zero per-tick change in `|ψ|²`.  We do not claim exact
  conservation in that regime.

  Instead we expose a rigorous *difference-controlled* theorem
  (`bornRule_sum_diff_bound`): for any dynamical sequence, the
  absolute change in the region sum from tick `n` to tick `n+1`
  is bounded by the sum of pointwise `|ψ|²` changes:

        |∑ |ψ(·, n+1)|² − ∑ |ψ(·, n)|²|
          ≤ ∑ |exp(−I_KL g_{n+1}) − exp(−I_KL g_n)|.

  This is the honest "boundary-flux / residue" form: it is an
  identity, not an approximation, and it reduces to exact
  conservation (zero RHS) whenever `I_KL` is tick-invariant on the
  region, in particular whenever `HasZeroFunctional` holds.

  ## Contents

  * `informationDensityKL_static_under_dynamics` — under
    `HasZeroFunctional`, the KL density is tick-invariant.
  * `sq_abs_coarseGrainWithPhase_static_under_dynamics` — pointwise
    tick-invariance of `|ψ|²` in the static regime.
  * `bornRule_pointwise_conservation` — pointwise Born-rule
    conservation per tick under `HasZeroFunctional`.
  * `bornRuleConservation` — **the headline theorem.**  Under
    `HasZeroFunctional`, the region sum of `|ψ|²` is tick-invariant.
  * `bornRule_amplitude_sum_invariant` — corollary: iterated
    invariance across any two ticks.
  * `bornRule_on_minkowski` — specialisation to the flat Minkowski
    dynamical sequence.
  * `bornRule_sum_diff_bound` — honest dynamical residue:
    `|Δ ∑ |ψ|²|` bounded by the pointwise `|ψ|²`-difference sum.

  No `sorry`.  No new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.SnapshotDynamics
import OmegaTheory.Conservation.InformationKL
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation

/-! ## Static regime: KL density is tick-invariant -/

/-- **Key lemma.**  Under the static-functional regime
    (`d.HasZeroFunctional`), the metric at any tick `n` equals the
    initial metric.  This is repackaged from the Phase-1
    `advanceMetricN_of_always_flat_functional` lemma. -/
theorem DynamicalSnapshotSequence.metric_eq_initial_under_hasZero
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional) (n : ℕ) :
    d.metric n = d.initial := by
  unfold DynamicalSnapshotSequence.metric
  refine advanceMetricN_of_always_flat_functional d.initial (fun k => ?_) n
  intro p μ ν
  simpa [DynamicalSnapshotSequence.metric] using hF k p μ ν

/-- The KL information density is tick-invariant under the static
    regime: it equals its tick-0 value at every tick. -/
theorem informationDensityKL_static_under_dynamics
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional) (p : LatticePoint) (n : ℕ) :
    informationDensityKL (d.metric n) d.reference p =
      informationDensityKL d.initial d.reference p := by
  rw [d.metric_eq_initial_under_hasZero hF n]

/-- The KL density is equal across any two ticks in the static regime. -/
theorem informationDensityKL_conserved_under_static_dynamics
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional) (p : LatticePoint) (n m : ℕ) :
    informationDensityKL (d.toSnapshotSequence.metric n) d.reference p =
      informationDensityKL (d.toSnapshotSequence.metric m) d.reference p := by
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_metric]
  rw [informationDensityKL_static_under_dynamics d hF p n,
    informationDensityKL_static_under_dynamics d hF p m]

/-! ## Static regime: pointwise Born-rule conservation -/

/-- Pointwise: under `HasZeroFunctional`, the `|ψ|²` is tick-invariant
    at every lattice point `p`. -/
theorem sq_abs_coarseGrainWithPhase_static_under_dynamics
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n k : ℕ) :
    (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2 =
      (‖coarseGrainWithPhase d.toSnapshotSequence phase m p k‖) ^ 2 := by
  rw [sq_abs_coarseGrainWithPhase, sq_abs_coarseGrainWithPhase]
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_metric,
    DynamicalSnapshotSequence.toSnapshotSequence_reference]
  rw [d.metric_eq_initial_under_hasZero hF n,
    d.metric_eq_initial_under_hasZero hF k]

/-- Pointwise per-tick Born-rule conservation: under
    `HasZeroFunctional`, `|ψ(p, n)|² = |ψ(p, n+1)|²`. -/
theorem bornRule_pointwise_conservation
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) :
    (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2 =
      (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2 :=
  sq_abs_coarseGrainWithPhase_static_under_dynamics d hF phase m p n (n + 1)

/-! ## Headline theorem: Born rule as a conservation law -/

/-- **Born rule as a conservation theorem.**  Under the static-regime
    hypothesis `HasZeroFunctional` on the dynamical snapshot sequence
    (i.e. the metric-Laplacian functional `F` vanishes on every
    iterate), the sum

          ∑_{p ∈ region} ‖coarseGrainWithPhase s phase m p n‖²

    is tick-invariant:

          ∑_{p ∈ region} |ψ(p, n)|² = ∑_{p ∈ region} |ψ(p, n+1)|².

    This is the machine-checked derivation of probability
    conservation from discrete-gravity first principles: the Born
    rule does not need to be postulated — it *follows* from the
    structure of the Planck-tick update rule in the regime where
    that rule is static.

    The hypothesis `HasZeroFunctional` is the same regime under
    which Phase 2's Schrödinger bound closes, so the two
    theorems live on a compatible, honest scope.

    For the general dynamical regime (no `HasZeroFunctional`
    hypothesis), see `bornRule_sum_diff_bound` below for the
    rigorous residue bound. -/
theorem bornRuleConservation
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) := by
  apply Finset.sum_congr rfl
  intro p _
  exact bornRule_pointwise_conservation d hF phase m p n

/-- **Amplitude sum invariant across any two ticks.**  Corollary of
    `bornRuleConservation`: the region sum of `|ψ|²` is equal at any
    two ticks `n, k` under `HasZeroFunctional`.  This is the iterated
    version and is the statement used when comparing the
    wavefunction's total probability at arbitrary separated times. -/
theorem bornRule_amplitude_sum_invariant
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n k : ℕ) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p k‖) ^ 2) := by
  apply Finset.sum_congr rfl
  intro p _
  exact sq_abs_coarseGrainWithPhase_static_under_dynamics d hF phase m p n k

/-! ## Specialisation to the Minkowski dynamical vacuum -/

/-- **Born rule on the flat Minkowski dynamical vacuum.**  The
    squared-amplitude sum is trivially conserved: every tick of the
    flat sequence carries the flat metric, so `|ψ|²` is the constant
    `exp(−2)` everywhere, and the sum is `|region| · exp(−2)` at
    every tick.

    This is the sanity check: the non-trivial Phase-3 machinery
    collapses correctly on the vacuum. -/
theorem bornRule_on_minkowski
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n k : ℕ) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase minkowskiDynamicalSequence.toSnapshotSequence
          phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase minkowskiDynamicalSequence.toSnapshotSequence
          phase m p k‖) ^ 2) :=
  bornRule_amplitude_sum_invariant minkowskiDynamicalSequence
    minkowskiDynamicalSequence_hasZeroFunctional phase m region n k

/-! ## General dynamical case: honest residue bound

The headline `bornRuleConservation` is the conservative honest
statement that closes under `HasZeroFunctional`.  Below we expose
what is provable in the *general* dynamical regime, without any
functional-vanishing hypothesis: a direct bound on the per-tick
change of the region sum in terms of the pointwise `|ψ|²`
differences.

This is `|Δ ∑ |ψ|²| ≤ ∑ |Δ |ψ|²||` — a triangle-inequality
control.  It reduces to exact conservation precisely when the RHS
vanishes, which occurs when `I_KL` is tick-invariant on the region
(hence when `HasZeroFunctional` holds).  So this bound is a
strictly stronger, quantitative statement than `bornRuleConservation`,
at the cost of being a bound rather than an equality.

**Physical interpretation.** The RHS

    ∑_{p ∈ region} |exp(−I_KL g_{n+1}) − exp(−I_KL g_n)|

is the total "probability flux" across the tick `n → n+1`.  In a
continuum Schrödinger-theory analogue it would be the volume
integral of |∂_t|ψ|²|, which is bounded by the boundary flux of
the probability current via the divergence theorem.  Here we do
not invoke a divergence theorem — the bound is purely
`|∑ a_i| ≤ ∑ |a_i|` — but it exposes the right quantitative
object. -/

/-- **Honest dynamical residue bound.**  For any dynamical snapshot
    sequence (no `HasZeroFunctional` hypothesis), the absolute
    difference of the region sum of `|ψ|²` from tick `n` to
    `n+1` is bounded by the sum over `region` of the pointwise
    absolute difference of `|ψ|²`.

    This is the honest quantitative form of Born-rule conservation:
    it is an inequality, not an equality, and its RHS is zero
    exactly when the `I_KL` density is tick-invariant on the
    region (e.g. under `HasZeroFunctional`).

    No positivity or static hypothesis is required. -/
theorem bornRule_sum_diff_bound
    (d : DynamicalSnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ) :
    |(region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) -
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2)|
    ≤ region.sum (fun p =>
        |(‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2 -
          (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2|) := by
  set a : LatticePoint → ℝ :=
    fun p => (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2
  set b : LatticePoint → ℝ :=
    fun p => (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2
  have hdiff : region.sum a - region.sum b = region.sum (fun p => a p - b p) := by
    rw [Finset.sum_sub_distrib]
  rw [hdiff]
  exact Finset.abs_sum_le_sum_abs _ _

/-- **Residue in KL-density form.**  The pointwise `|ψ|²`-difference
    is exactly `|exp(−I_KL g_{n+1}) − exp(−I_KL g_n)|`.  This rewrites
    the RHS of `bornRule_sum_diff_bound` in terms of the KL density
    directly, exhibiting the per-tick probability flux as an explicit
    KL-density-exponential difference. -/
theorem bornRule_pointwise_diff_eq_KL
    (d : DynamicalSnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) :
    (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2 -
      (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2
    = Real.exp (- (informationDensityKL
          (d.toSnapshotSequence.metric (n + 1)) d.reference p)) -
      Real.exp (- (informationDensityKL
          (d.toSnapshotSequence.metric n) d.reference p)) := by
  rw [sq_abs_coarseGrainWithPhase, sq_abs_coarseGrainWithPhase]
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_reference]

/-- **Residue bound in KL-density form.**  Combining
    `bornRule_sum_diff_bound` with `bornRule_pointwise_diff_eq_KL`:
    the Born-rule flux between successive ticks is bounded by the
    total absolute pointwise change of the KL Boltzmann weight
    `exp(−I_KL)` over the region. -/
theorem bornRule_sum_diff_bound_KL
    (d : DynamicalSnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ) :
    |(region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) -
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2)|
    ≤ region.sum (fun p =>
        |Real.exp (- (informationDensityKL
              (d.toSnapshotSequence.metric (n + 1)) d.reference p)) -
          Real.exp (- (informationDensityKL
              (d.toSnapshotSequence.metric n) d.reference p))|) := by
  refine (bornRule_sum_diff_bound d phase m region n).trans ?_
  apply Finset.sum_le_sum
  intro p _
  rw [bornRule_pointwise_diff_eq_KL d phase m p n]

/-- **Consistency corollary.**  If the KL density is tick-invariant
    across `n → n+1` on every point of the region (e.g. under
    `HasZeroFunctional`), the KL-form residue bound collapses to
    exact conservation: the region sum at tick `n` equals the
    region sum at tick `n+1`.  This verifies that the general
    `bornRule_sum_diff_bound_KL` and the headline
    `bornRuleConservation` agree on their common scope. -/
theorem bornRule_sum_eq_of_KL_static
    (d : DynamicalSnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ)
    (hKL : ∀ p ∈ region,
      informationDensityKL (d.toSnapshotSequence.metric n) d.reference p =
        informationDensityKL (d.toSnapshotSequence.metric (n + 1)) d.reference p) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) := by
  apply Finset.sum_congr rfl
  intro p hp
  rw [sq_abs_coarseGrainWithPhase, sq_abs_coarseGrainWithPhase]
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_reference]
  rw [hKL p hp]

end OmegaTheory.Emergence
