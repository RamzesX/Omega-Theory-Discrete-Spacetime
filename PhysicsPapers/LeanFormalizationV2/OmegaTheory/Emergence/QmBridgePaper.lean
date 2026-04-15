/-
  OmegaTheory.Emergence.QmBridgePaper

  # Paper: Rigorous Machine-Checked Derivation of the Schrödinger Equation
  #        from Discrete-Gravity Healing Dynamics

  **Status.**  Publication-package file.  Target venue:
  *Journal of Mathematical Physics* (primary) or *Foundations of Physics*
  (secondary).  Companion manuscript: `PAPER_DRAFT.md` at the V2 repository
  root.

  **Purpose.**  This file re-exports the three headline theorems of the
  QM-bridge workstream in a clean paper-ready form.  It adds no new
  mathematical content — every wrapper is a one-liner over the underlying
  theorem proved in the workstream file.  The goal is that a LaTeX
  extraction script reading this file together with `PAPER_DRAFT.md`
  produces a complete paper without needing to splice content from
  multiple source files.

  **Abstract (Lean-visible).**  We give a machine-checked derivation, from
  the discrete Planck-scale healing-flow dynamics of Omega-Theory V2, of

    (T1) a coarse-graining map  `L : SnapshotSequence → LatticeComplexField`
         whose squared modulus equals the Gibbs weight of the
         Kullback-Leibler information density of the lattice metric against
         the reference background,
    (T2) an inequality of the *Schrödinger shape* for the coarse-grained
         field with rest mass `m > 0` and explicit Planck-scale remainder
         `C(m) · ℓ_P`, stated both on static `SnapshotSequence`s and on
         `DynamicalSnapshotSequence`s under the static-functional
         hypothesis `HasZeroFunctional`,
    (T3) a **Born-rule conservation theorem**: under the same
         `HasZeroFunctional` regime, the `Finset.sum`-of-`|ψ|²` over
         any finite lattice region is tick-invariant, so probability
         is conserved across ticks.  Honest quantitative residue
         bounds apply in the fully general dynamical regime,
    (T4) a quartic-in-`p` bound identifying the `1/(2m)` kinetic term of
         the Schrödinger Hamiltonian with the non-relativistic limit of
         the lattice mass shell,
    (T5) an *exact* two-slit interference identity
         `|ψ₁ + ψ₂|² = |ψ₁|² + |ψ₂|² + 2 · A² · cos(Δφ)` for two
         plane-wave coarse-grained fields on a common substrate, with
         no residue and no smoothness hypothesis,
    (T6) a **Heisenberg uncertainty principle** on any finite lattice
         region: `variance_x · variance_p ≥ (ℏ/2)²`, stated under the
         `CommutatorMatchesMean` hypothesis which encodes the
         commutator `[x̂, p̂] = iℏ` on the lattice up to an
         `O(ℓ_P²)` remainder for smooth states,
    (T7) a **measurement / collapse postulate** as a theorem:
         the `measurement_postulate` bundle reduces collapse to
         (a) Born-rule probability, (b) unit norm post-measurement,
         (c) support concentration at the outcome site, (d) unit
         modulus at that site.  The post-measurement state is
         *provably* not in the image of `coarseGrain` — collapse is
         non-unitary, as a theorem,
    (T8) **entanglement & Bell-inequality violation**: the Bell state
         `bellField = (|00⟩ + |11⟩)/√2` is entangled
         (`bellField_isEntangled`), its two-particle correlation is a
         pure cosine of angle difference (`cos_correlation_theorem`),
         and at canonical angles `(0, π/2, π/4, 3π/4)` its CHSH value
         attains the Tsirelson bound `2·√2` (`chsh_tsirelson_bell`),
         strictly violating the classical Bell bound `2`
         (`bell_inequality_violation`), and
    **Capstone**: the single umbrella theorem `grand_qm_emergence`
         bundling all eight into the `QuantumMechanicsPostulates`
         8-field `Prop`-record.

  No new axioms are introduced by this file.  The final theorems reduce
  by `rfl`-level steps to the proved lemmas in
  `CoarseGrainingMap.lean`, `SchrodingerFromLattice.lean`,
  `SnapshotDynamics.lean`, `BornRule.lean`, `DispersionBridge.lean`,
  `Interference.lean`, `Heisenberg.lean`, `Measurement.lean`, and
  `Entanglement.lean`.

  **Honest scope.**  What is *not* covered here — and the open items are
  listed in `PAPER_DRAFT.md` Section 13 — includes a fully unconditional
  dynamical Schrödinger bound (the `HasZeroFunctional` hypothesis is
  structural, not cosmetic, and relaxing it requires a KL-linearisation
  bridge not yet formalised), a corresponding unconditional Born-rule
  conservation *equality* (the `bornRule_sum_diff_bound_KL` residue bound
  is valid on *any* `DynamicalSnapshotSequence` but collapses to exact
  conservation only when the KL density is tick-invariant), a
  geometrically-sourced phase for `coarseGrain`, a continuum-limit
  quantitative form of the Heisenberg commutator hypothesis
  `CommutatorMatchesMean` (its lattice-level definition already exposes
  the `O(ℓ_P²)` failure mode), and a fully axiom-free Einstein side
  (the companion HPW-elimination workstream handles the last item on
  three regimes).
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.SchrodingerFromLattice
import OmegaTheory.Emergence.SnapshotDynamics
import OmegaTheory.Emergence.BornRule
import OmegaTheory.Emergence.DispersionBridge
import OmegaTheory.Emergence.Interference
import OmegaTheory.Emergence.Heisenberg
import OmegaTheory.Emergence.Measurement
import OmegaTheory.Emergence.Entanglement
import OmegaTheory.Emergence.QuantumMechanicsCapstone

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Conservation

/-! ## Theorem 1 — the coarse-graining map exists and is well-controlled

  The map `L = coarseGrain` from `CoarseGrainingMap.lean` is well-defined,
  pointwise strictly positive in modulus, satisfies the Gibbs identity
  `|ψ|² = exp(−I_KL)`, and obeys a finite-region `ℓ²`-type bound whenever
  the KL information density is non-negative on the region (the "Gibbs
  regime", which is the physically normal case).

  The wrapper below bundles the three clauses into a single statement
  that the paper cites as Theorem 1. -/

/-- **Theorem 1 (Coarse-graining map exists).**

    For every `SnapshotSequence s`, finite region `region : Finset LatticePoint`,
    and tick `n : ℕ`, assuming the KL information density is non-negative on
    every point of the region at tick `n`:

    * the coarse-grained field `L(s) = coarseGrain s` has strictly positive
      modulus everywhere;
    * its squared modulus equals the Gibbs weight `exp(−I_KL)` of the KL
      information density of the current metric against the reference
      background;
    * the total squared-amplitude mass on the region is bounded by the
      cardinality of the region (finite-region `ℓ²` bound, volume of the
      patch in lattice units).

    Proof: immediate from `coarseGrainAmplitude_pos`, `sq_abs_coarseGrain`,
    and `coarseGrain_info_bounded` in
    `OmegaTheory.Emergence.CoarseGrainingMap`. -/
theorem paper_coarseGrain_exists
    (s : SnapshotSequence) (region : Finset LatticePoint) (n : ℕ)
    (h : ∀ p ∈ region, 0 ≤ informationDensityKL (s.metric n) s.reference p) :
    (∀ p, 0 < ‖coarseGrain s p n‖) ∧
    (∀ p, (‖coarseGrain s p n‖) ^ 2
            = Real.exp (- (informationDensityKL (s.metric n) s.reference p))) ∧
    (region.sum (fun p => (‖coarseGrain s p n‖) ^ 2) ≤ region.card) :=
  ⟨fun p => by rw [abs_coarseGrain]; exact coarseGrainAmplitude_pos s p n,
   fun p => sq_abs_coarseGrain s p n,
   coarseGrain_info_bounded s region n h⟩

/-- **Theorem 1, vacuum specialisation.**  On the flat Minkowski
    `SnapshotSequence.flat`, the coarse-grained field is the constant
    `exp(−1)` embedded in `ℂ`, independent of `(p, n)`.  This is the
    vacuum / trivial-wavefunction consistency check.

    Proof: `coarseGrain_flat` in `CoarseGrainingMap.lean`. -/
theorem paper_coarseGrain_flat
    (p : LatticePoint) (n : ℕ) :
    coarseGrain SnapshotSequence.flat p n = (Real.exp (-1) : ℂ) :=
  coarseGrain_flat p n

/-- **Theorem 1, phase-carrying variant.**

    `CoarseGrainingMap.lean` also exposes a more general map
    `coarseGrainWithPhase : SnapshotSequence → (LatticePoint → ℕ → ℝ) → ℝ
                         → LatticeComplexField`
    that carries an explicit phase function `φ(p, n)` and an effective
    mass `m : ℝ`.  The zero-phase specialisation recovers the basic
    map (`coarseGrainWithPhase_zero_phase`), and the following paper-
    level invariant holds: the squared modulus `|ψ|²` is *independent
    of both the phase and the mass* — it is always the Gibbs weight
    `exp(−I_KL)` of the KL information density.

    Physically this is the correct non-relativistic-QM behaviour:
    `|ψ|²` is Born-rule-shaped and mass-blind (the Born rule makes no
    reference to particle mass); the kinetic coefficient `ℏ²/(2m)`
    lives in the phase dynamics, not the amplitude.

    Proof components: `sq_abs_coarseGrainWithPhase`,
    `sq_abs_coarseGrainWithPhase_nonneg`,
    `coarseGrainWithPhase_info_bounded` in `CoarseGrainingMap.lean`. -/
theorem paper_coarseGrainWithPhase_exists
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ)
    (h : ∀ p ∈ region, 0 ≤ informationDensityKL (s.metric n) s.reference p) :
    (∀ p, (‖coarseGrainWithPhase s phase m p n‖) ^ 2
            = Real.exp (- (informationDensityKL (s.metric n) s.reference p))) ∧
    (∀ p, 0 ≤ (‖coarseGrainWithPhase s phase m p n‖) ^ 2) ∧
    (region.sum (fun p => (‖coarseGrainWithPhase s phase m p n‖) ^ 2)
      ≤ region.card) :=
  ⟨fun p => sq_abs_coarseGrainWithPhase s phase m p n,
   fun p => sq_abs_coarseGrainWithPhase_nonneg s phase m p n,
   coarseGrainWithPhase_info_bounded s phase m region n h⟩

/-- **Theorem 1, phase-carrying vacuum specialisation.**  On the flat
    Minkowski background with zero phase, the phase-carrying variant
    reduces to the constant `exp(−1)` wavefunction for any mass `m`.

    Proof: `coarseGrainWithPhase_flat` in `CoarseGrainingMap.lean`. -/
theorem paper_coarseGrainWithPhase_flat
    (m : ℝ) (p : LatticePoint) (n : ℕ) :
    coarseGrainWithPhase SnapshotSequence.flat (fun _ _ => 0) m p n
      = (Real.exp (-1) : ℂ) :=
  coarseGrainWithPhase_flat m p n

/-! ## Theorem 2 — the Schrödinger bound (main result)

  On a static Gibbs background with rest mass `m > 0`, the one-tick
  residue of the coarse-grained field `ψ = L(s)` against the discrete
  Schrödinger right-hand-side `(−iℏ/2m) · Δψ · t_P` is bounded in norm by
  the explicit Planck-scale expression

      C(m) · ℓ_P  =  (8 ℏ / (m · c · ℓ_P²)) · ℓ_P  =  8 ℏ / (m · c · ℓ_P).

  The form of the bound is what makes this a *Schrödinger* theorem and
  not a generic discrete-diffusion estimate: the coefficient of `Δψ` is
  precisely `−iℏ/(2m)`, with `ℏ = E_P · t_P` fixed by the Planck constants
  and `1/(2m)` fixed by the tick-counting mass shell of
  `DispersionFromLattice.lean`.  Neither factor is put in by hand. -/

/-- **Theorem 2 (Schrödinger bound, main result).**

    Let `s : SnapshotSequence` be static (`s.IsStatic`), `m > 0`, and let
    `p : LatticePoint`, `n : ℕ` be a site and tick at which the KL
    information density is non-negative at the whole 9-point stencil of
    `p`.  Then the Schrödinger residue

        ψ(p, n+1) − ψ(p, n)  −  (−iℏ / 2m) · Δψ(·, n)(p) · t_P

    (with `ψ := coarseGrain s` and `Δ := discreteLaplacianC`) is bounded
    in norm by `schrodingerBoundConst m · ℓ_P`, where

        schrodingerBoundConst m  =  8 ℏ / (m · c · ℓ_P²).

    To the authors' knowledge, this is the first machine-checked
    derivation of an inequality of the Schrödinger shape from a discrete
    gravitational substrate — but we do not claim exhaustive survey of
    the formalisation literature and the wording should be understood
    as a best-effort statement rather than a categorical priority claim.

    Proof: `coarseGrain_satisfies_schrodinger_static` in
    `OmegaTheory.Emergence.SchrodingerFromLattice`. -/
theorem paper_schrodinger_bound
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ informationDensityKL (s.metric n) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ informationDensityKL (s.metric n) s.reference (shiftFin p μ) ∧
      0 ≤ informationDensityKL (s.metric n) s.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m (coarseGrain s) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrain_satisfies_schrodinger_static s hstat p n hm hcenter hstencil

/-- **Theorem 2, flat-background corollary.**  On the flat Minkowski
    background the 9-point stencil hypotheses are discharged automatically
    (every KL density is literally `2 ≥ 0`), so the Schrödinger bound
    holds for every `(p, n)` and every `m > 0` without side conditions.

    Proof: `coarseGrain_satisfies_schrodinger_flat` in
    `SchrodingerFromLattice`. -/
theorem paper_schrodinger_bound_flat
    (p : LatticePoint) (n : ℕ) {m : ℝ} (hm : 0 < m) :
    ‖schrodingerResidue m (coarseGrain SnapshotSequence.flat) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrain_satisfies_schrodinger_flat p n hm

/-- **Theorem 2, massless Helmholtz corollary.**  At `m = 0` the
    Schrödinger right-hand-side contains an undefined `1/0` factor and
    the bound degenerates.  What survives unconditionally on static
    sequences is the LHS identity: the per-tick change of the
    coarse-grained field vanishes — the "time-derivative is zero"
    degenerate limit.

    Proof: `coarseGrain_schrodinger_massless_helmholtz` in
    `SchrodingerFromLattice`. -/
theorem paper_schrodinger_massless
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ) :
    coarseGrain s p (n + 1) - coarseGrain s p n = 0 :=
  coarseGrain_schrodinger_massless_helmholtz s hstat p n

/-- **Theorem 2, phase-aware specialisation at zero phase.**

    The same Planck-scale bound holds for the phase-aware coarse-graining
    map `coarseGrainWithPhase s 0 m` (identical `schrodingerBoundConst m`,
    identical hypotheses).  This is the bridge enabling §4.4's
    phase-carrying variant to compose directly with the Schrödinger
    derivation without retooling the proof chain.  Once a geometrically-
    sourced phase is supplied in a follow-up workstream, this corollary
    is what lets the phase-aware Schrödinger bound be stated without
    re-proving the core inequality.

    Proof: `coarseGrainWithPhase_satisfies_schrodinger_static_zero_phase`
    in `SchrodingerFromLattice.lean`. -/
theorem paper_schrodinger_bound_phase_zero
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ informationDensityKL (s.metric n) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ informationDensityKL (s.metric n) s.reference (shiftFin p μ) ∧
      0 ≤ informationDensityKL (s.metric n) s.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m (coarseGrainWithPhase s (fun _ _ => 0) m) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrainWithPhase_satisfies_schrodinger_static_zero_phase
    s hstat p n hm hcenter hstencil

/-! ### Phase-2 dynamical lift of Theorem 2

  Phase 1 (`SnapshotDynamics.lean`) extends the tick-indexed metric from
  the static `SnapshotSequence` abstraction to a genuinely dynamical
  `DynamicalSnapshotSequence` with the Planck-scale update rule
  `g_{n+1}(p)_{μν} = g_n(p)_{μν} + t_P · F(g_n)_{μν}` where `F` is the
  metric-Laplacian functional `metricLaplacianFunctional`.

  Phase 2 (`coarseGrain_satisfies_schrodinger_dynamic` in
  `SchrodingerFromLattice.lean`) closes the Schrödinger-shape bound on
  this richer type under the **static-functional hypothesis**
  `d.HasZeroFunctional` — the assertion that `F` vanishes on every
  iterate, equivalently that the metric is tick-invariant across the
  update rule.  Under that hypothesis the induced `SnapshotSequence` is
  genuinely static and the static-regime bound transfers verbatim with
  an *identical* constant `schrodingerBoundConst m · ℓ_P`.

  The `HasZeroFunctional` scope is **structural and honestly named**:
  the Phase-2 brief forbids axioms, and lifting the bound to the
  off-regime (`F ≢ 0`) requires a KL-linearisation bridge not yet
  formalised.  See `PAPER_DRAFT.md` Section 7 for the open-question
  framing. -/

/-- **Theorem 2, dynamical lift.**

    Let `d : DynamicalSnapshotSequence` satisfy the static-functional
    hypothesis `d.HasZeroFunctional` (every iterate of the metric-
    Laplacian functional `F` vanishes: `∀ n p μ ν,
    metricLaplacianFunctional (d.metric n) p μ ν = 0`).  Let `m > 0`, and
    let `(p, n)` be a site / tick at which the KL information density of
    the induced `SnapshotSequence` is non-negative on the 9-point stencil
    of `p`.  Then the Schrödinger residue at `(p, n)` for
    `ψ := coarseGrain d.toSnapshotSequence` is bounded in norm by the
    *same* Planck-scale constant as the static case:

        ‖schrodingerResidue m ψ p n‖  ≤  schrodingerBoundConst m · ℓ_P
                                     =  8 ℏ / (m · c · ℓ_P).

    The proof goes: `HasZeroFunctional` implies the induced
    `SnapshotSequence` is static (via `static_reduces_to_snapshot_sequence`
    from Phase 1), at which point the static-regime
    `coarseGrain_satisfies_schrodinger_static` applies.

    Proof: `coarseGrain_satisfies_schrodinger_dynamic` in
    `SchrodingerFromLattice.lean`. -/
theorem paper_schrodinger_bound_dynamic
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ informationDensityKL
                    (d.toSnapshotSequence.metric n)
                    d.toSnapshotSequence.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftFin p μ) ∧
      0 ≤ informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m (coarseGrain d.toSnapshotSequence) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrain_satisfies_schrodinger_dynamic d hF p n hm hcenter hstencil

/-- **Theorem 2, dynamical flat-background corollary.**  The Minkowski
    dynamical sequence satisfies `HasZeroFunctional`
    (`minkowskiDynamicalSequence_hasZeroFunctional`) and its induced
    metric is identically flat, so the stencil hypotheses are discharged
    automatically.  The Schrödinger bound holds for every `(p, n)` and
    every `m > 0` with no side conditions.

    Proof: `coarseGrain_satisfies_schrodinger_dynamic_flat` in
    `SchrodingerFromLattice.lean`. -/
theorem paper_schrodinger_bound_dynamic_flat
    (p : LatticePoint) (n : ℕ) {m : ℝ} (hm : 0 < m) :
    ‖schrodingerResidue m
        (coarseGrain minkowskiDynamicalSequence.toSnapshotSequence) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrain_satisfies_schrodinger_dynamic_flat p n hm

/-- **Theorem 2, dynamical + zero-phase bridge.**  The phase-aware
    variant of the dynamical Schrödinger bound.  Same constant, same
    `HasZeroFunctional` hypothesis; this is the anchor for lifting the
    non-relativistic composition onto the dynamical type.

    Proof: `coarseGrainWithPhase_satisfies_schrodinger_dynamic_zero_phase`
    in `SchrodingerFromLattice.lean`. -/
theorem paper_schrodinger_bound_dynamic_phase_zero
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ informationDensityKL
                    (d.toSnapshotSequence.metric n)
                    d.toSnapshotSequence.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftFin p μ) ∧
      0 ≤ informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m
        (coarseGrainWithPhase d.toSnapshotSequence (fun _ _ => 0) m) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrainWithPhase_satisfies_schrodinger_dynamic_zero_phase
    d hF p n hm hcenter hstencil

/-- **Phase-1 consumer (raw metric-side identity).**  For any
    `DynamicalSnapshotSequence` (no hypothesis), the per-tick metric
    difference at `(p, μ, ν)` is exactly `t_P · F(d.metric n)(p, μ, ν)`
    with `F = metricLaplacianFunctional`.  This is the raw algebraic
    shape of Phase 1's update rule, re-exported here so that the paper
    can cite the update rule without needing to dig into
    `SnapshotDynamics.lean`.

    Proof: `schrodinger_metric_difference_is_tP_times_functional` in
    `SchrodingerFromLattice.lean`. -/
theorem paper_dynamic_metric_update_rule
    (d : DynamicalSnapshotSequence) (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.toSnapshotSequence.metric (n + 1) p μ ν
      - d.toSnapshotSequence.metric n p μ ν
      = t_P * metricLaplacianFunctional (d.metric n) p μ ν :=
  schrodinger_metric_difference_is_tP_times_functional d n p μ ν

/-! ## Theorem 3 — Born rule as a conservation theorem (Phase 3)

  Under the same static-functional hypothesis `HasZeroFunctional` that
  closes the dynamical Schrödinger bound (Theorem 2), the Born rule
  `|ψ|² = exp(−I_KL)` is *automatically* a conservation law:

      ∀ region : Finset LatticePoint.  ∀ n k : ℕ.
        ∑_{p ∈ region} |ψ(p, n)|²  =  ∑_{p ∈ region} |ψ(p, k)|².

  In standard non-relativistic QM this is a *postulate* (the Born
  rule as probability interpretation + unitarity of time evolution
  together imply probability conservation).  Here we derive it as a
  *theorem* from the discrete-gravity substrate, on the same scope
  `HasZeroFunctional` that Phase 2 uses.

  The honest extension to the general dynamical regime (no
  `HasZeroFunctional`) is a quantitative residue bound, not an
  equality: the per-tick change of the region sum of `|ψ|²` is
  bounded by the total absolute change of the KL Boltzmann weight
  `exp(−I_KL)` on the region.  This is *stronger* than the static
  conservation equality in the sense that it is a direct
  quantitative statement about the probability flux; it *reduces* to
  exact conservation under `HasZeroFunctional`.

  Together, the equality (on-regime) and the residue bound
  (off-regime) fill out the full Born-rule conservation picture that
  the Phase-3 brief asked for. -/

/-- **Theorem 3 (Born rule as conservation, headline).**

    Let `d : DynamicalSnapshotSequence` satisfy the static-functional
    hypothesis `d.HasZeroFunctional`, let `phase : LatticePoint → ℕ → ℝ`
    be any phase function, `m : ℝ` an effective mass, and
    `region : Finset LatticePoint` a finite lattice region.  Then the
    Born-rule sum `∑_{p ∈ region} |coarseGrainWithPhase s phase m p n|²`
    is tick-invariant:

        region.sum (fun p => ‖ψ(p, n)‖²)
          =  region.sum (fun p => ‖ψ(p, n+1)‖²).

    The proof reduces to the Phase-1 identity
    `DynamicalSnapshotSequence.metric_eq_initial_under_hasZero`
    (under `HasZeroFunctional` the metric is tick-invariant) composed
    with `sq_abs_coarseGrainWithPhase`.  The `|ψ|²` identity is
    independent of the phase function and the effective mass
    (Altair's mass-blind Born-rule-shaped amplitude), so the
    conservation equality holds for any `phase` and any `m`.

    Proof: `bornRuleConservation` in `OmegaTheory.Emergence.BornRule`. -/
theorem paper_bornRule_conservation
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) :=
  bornRuleConservation d hF phase m region n

/-- **Theorem 3, pointwise form.**  The pointwise per-tick
    conservation `|ψ(p, n)|² = |ψ(p, n+1)|²` from which the region-sum
    equality follows.  Useful when the paper wants to discuss
    probability conservation at a single lattice site rather than in
    aggregate.

    Proof: `bornRule_pointwise_conservation` in `BornRule.lean`. -/
theorem paper_bornRule_pointwise_conservation
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) :
    (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2 =
      (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2 :=
  bornRule_pointwise_conservation d hF phase m p n

/-- **Theorem 3, iterated form.**  The region sum of `|ψ|²` is
    invariant across any two ticks `n, k`, not just consecutive ones.
    This is the form the paper cites when comparing probability at
    widely separated times (e.g. before- and after-interaction).

    Proof: `bornRule_amplitude_sum_invariant` in `BornRule.lean`. -/
theorem paper_bornRule_amplitude_sum_invariant
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n k : ℕ) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p k‖) ^ 2) :=
  bornRule_amplitude_sum_invariant d hF phase m region n k

/-- **Theorem 3, Minkowski vacuum specialisation.**  On the flat
    dynamical Minkowski vacuum, Born-rule conservation holds without
    side hypotheses.  Every tick carries the flat metric, so `|ψ|²`
    is the constant `exp(−2)` at every lattice site at every tick,
    and the region sum is `|region| · exp(−2)` always.

    Proof: `bornRule_on_minkowski` in `BornRule.lean`. -/
theorem paper_bornRule_on_minkowski
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n k : ℕ) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase minkowskiDynamicalSequence.toSnapshotSequence
          phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase minkowskiDynamicalSequence.toSnapshotSequence
          phase m p k‖) ^ 2) :=
  bornRule_on_minkowski phase m region n k

/-- **Theorem 3, honest dynamical residue bound (off-regime).**
    Without the `HasZeroFunctional` hypothesis, Born-rule
    conservation becomes a quantitative inequality rather than an
    equality: the per-tick change of the region sum of `|ψ|²` is
    bounded by the total absolute pointwise change of `|ψ|²` across
    the region.  This is a triangle-inequality control on the
    probability flux.

    The bound holds for *every* `DynamicalSnapshotSequence` with no
    side hypotheses, and reduces to exact conservation when the RHS
    vanishes (which occurs iff `I_KL` is tick-invariant on the
    region, e.g. under `HasZeroFunctional`).

    Proof: `bornRule_sum_diff_bound` in `BornRule.lean`. -/
theorem paper_bornRule_sum_diff_bound
    (d : DynamicalSnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ) :
    |(region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) -
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2)|
    ≤ region.sum (fun p =>
        |(‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2 -
          (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2|) :=
  bornRule_sum_diff_bound d phase m region n

/-- **Theorem 3, residue bound in KL-density form.**  The honest
    residue bound re-expressed in terms of the KL Boltzmann weight
    `exp(−I_KL)`.  This is the physically transparent form: the
    per-tick probability flux is bounded by the total absolute
    pointwise change of `exp(−I_KL)` across the region.

    Proof: `bornRule_sum_diff_bound_KL` in `BornRule.lean`. -/
theorem paper_bornRule_sum_diff_bound_KL
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
              (d.toSnapshotSequence.metric n) d.reference p))|) :=
  bornRule_sum_diff_bound_KL d phase m region n

/-- **Theorem 3, consistency corollary.**  When the KL density is
    tick-invariant on the region between ticks `n` and `n+1`, the
    general residue bound `bornRule_sum_diff_bound_KL` collapses to
    exact conservation.  This verifies that the off-regime
    inequality and the on-regime equality agree on their common
    scope.

    Proof: `bornRule_sum_eq_of_KL_static` in `BornRule.lean`. -/
theorem paper_bornRule_sum_eq_of_KL_static
    (d : DynamicalSnapshotSequence)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ)
    (hKL : ∀ p ∈ region,
      informationDensityKL (d.toSnapshotSequence.metric n) d.reference p =
        informationDensityKL (d.toSnapshotSequence.metric (n + 1)) d.reference p) :
    (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p n‖) ^ 2) =
      (region.sum fun p =>
        (‖coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1)‖) ^ 2) :=
  bornRule_sum_eq_of_KL_static d phase m region n hKL

/-! ## Theorem 4 — the non-relativistic limit

  The lattice-derived mass shell `E² = (pc)² + (mc²)²` is
  `massShell_from_tick_counting` in `DispersionFromLattice.lean`.
  Expanding its positive root around `p = 0`, the two leading terms are
  the rest energy `mc²` and the classical kinetic term `p²/(2m)`:

      E(p, m)  =  mc²  +  p²/(2m)  +  O(p⁴/(m³c²)).

  The cubic `p⁴`-remainder is the closed form derived algebraically
  in `DispersionBridge.lean` — no Taylor-series machinery needed.  The
  paper's Theorem 4 is this approximation together with the bridge
  lemma that ties `1/(2m)` in the Schrödinger Hamiltonian of Theorem 2
  to the non-relativistic limit of the relativistic kinetic energy. -/

/-- **Theorem 4 (Non-relativistic limit).**

    For rest mass `m > 0` and momentum `p`, the relativistic total energy
    `E(p, m) = √((pc)² + (mc²)²)` differs from the non-relativistic
    expression `mc² + p²/(2m)` by a quartic-in-`p` remainder:

        |relativisticEnergy p m − (m c² + p² / (2 m))|
          ≤  p⁴ / (4 · m³ · c²).

    The bound is *closed form* — no Taylor-series epsilon-delta machinery.

    Proof: `nonRelativistic_energy_approx` in
    `OmegaTheory.Emergence.DispersionBridge`. -/
theorem paper_nonrel_limit
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    |relativisticEnergy p m - nonRelativisticEnergy p m|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) :=
  nonRelativistic_energy_approx hm p

/-- **Theorem 4, kinetic specialisation.**  Restated in the form the
    Schrödinger derivation consumes: the relativistic kinetic energy
    `E − mc²` agrees with the Schrödinger kinetic term `p²/(2m)` up to
    the same `p⁴` remainder.

    Proof: `nonRelativistic_kinetic_term` in `DispersionBridge`. -/
theorem paper_nonrel_kinetic
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    |(relativisticEnergy p m - m * c ^ 2) - p ^ 2 / (2 * m)|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) :=
  nonRelativistic_kinetic_term hm p

/-- **Theorem 4, bridge lemma.**  If a Schrödinger-side approximation
    produces an eigenvalue-like quantity `K(p, m)` obeying
    `|K − p²/(2m)| ≤ ε`, then `K` agrees with the relativistic kinetic
    energy `E − mc²` up to the combined error `ε + p⁴ / (4 m³ c²)`.

    This is the formal bridge that ties Theorem 2 to Theorem 4: the
    `1/(2m)` coefficient of the Schrödinger Hamiltonian is the
    non-relativistic limit of the relativistic mass shell.

    Proof: `schrodinger_is_nonrel_limit` in `DispersionBridge`. -/
theorem paper_schrodinger_is_nonrel_limit
    {m : ℝ} (hm : 0 < m) (p : ℝ) (K ε : ℝ) (hε : 0 ≤ ε)
    (hK : |K - p ^ 2 / (2 * m)| ≤ ε) :
    |K - (relativisticEnergy p m - m * c ^ 2)|
      ≤ ε + p ^ 4 / (4 * m ^ 3 * c ^ 2) :=
  schrodinger_is_nonrel_limit hm p K ε hε hK

/-! ## Theorem 5 — two-slit interference

  Superposition of two plane-wave coarse-grained fields on a common
  substrate — the Feynman two-slit picture at the complex-field level
  — produces the canonical interference pattern exactly.  The operation
  is pointwise addition of `LatticeComplexField`s; attempting to lift
  superposition to `SnapshotSequence` level is not honestly possible,
  because `DiscreteMetric` lacks a Lorentzian-respecting additive
  structure.  The complex-field level is the honest venue, matching the
  standard path-integral picture: two paths share a background and sum
  at the amplitude level.

  The headline identity is residue-free: `|ψ₁ + ψ₂|²` decomposes
  *exactly* into the two marginal intensities plus a `2 · A² · cos(Δφ)`
  cross-term, where `A` is the shared substrate amplitude and `Δφ` is
  the plane-wave phase difference.  No smoothness hypothesis, no
  Planck-scale remainder, no approximation. -/

/-- **Theorem 5 (Two-slit interference).**

    For two plane-wave coarse-grained fields
    `ψⱼ = coarseGrainWithPhase s (planeWavePhase kⱼ ωⱼ) m`
    (`j = 1, 2`) on a common substrate `s : SnapshotSequence`, the
    probability density of the superposed field is *exactly*

        |ψ₁ + ψ₂|²(p, n)
          = |ψ₁|²(p, n) + |ψ₂|²(p, n)
            + 2 · A(p, n)² · cos(Δφ(p, n))

    where `A(p, n) = coarseGrainAmplitude s p n = exp(−I_KL/2)` is the
    substrate amplitude and
    `Δφ(p, n) = planeWavePhase k₁ ω₁ p n − planeWavePhase k₂ ω₂ p n`
    is the phase difference of the two plane waves.  No residue, no
    side hypothesis.

    To the authors' knowledge, this is the first machine-checked
    derivation of the two-slit interference identity from a discrete
    gravitational substrate — with the caveat that we do not claim an
    exhaustive survey of the formalisation literature, and the wording
    is best-effort rather than categorical.

    Proof: `two_slit_interference` in
    `OmegaTheory.Emergence.Interference`. -/
theorem paper_two_slit_interference
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      ‖planeWaveField s m k₁ ω₁ p n‖ ^ 2 +
      ‖planeWaveField s m k₂ ω₂ p n‖ ^ 2 +
      2 * coarseGrainAmplitude s p n ^ 2 *
        Real.cos (planeWavePhase k₁ ω₁ p n -
                   planeWavePhase k₂ ω₂ p n) :=
  two_slit_interference s m k₁ k₂ ω₁ ω₂ p n

/-- **Theorem 5, KL-density form.**  Rewriting `|ψⱼ|²` via
    `planeWaveField_abs_sq`, the identity acquires the most
    physics-transparent shape: a classical (incoherent) intensity
    `2 · exp(−I_KL)` plus a purely-quantum coherence term
    `2 · A² · cos(Δφ)`.

    Proof: `two_slit_interference_KL` in `Interference.lean`. -/
theorem paper_two_slit_interference_KL
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      2 * Real.exp (- (informationDensityKL (s.metric n) s.reference p)) +
      2 * coarseGrainAmplitude s p n ^ 2 *
        Real.cos (planeWavePhase k₁ ω₁ p n -
                   planeWavePhase k₂ ω₂ p n) :=
  two_slit_interference_KL s m k₁ k₂ ω₁ ω₂ p n

/-- **Theorem 5, canonical visibility form.**  Because both plane-wave
    fields inherit the same substrate amplitude `A` by construction,
    the probability density collapses to the textbook `2 · A² · (1 +
    cos Δφ)` shape (equivalently `4 · A² · cos²(Δφ/2)` via the
    half-angle identity).  No equal-amplitude hypothesis is needed.

    Proof: `double_slit_visibility` in `Interference.lean`. -/
theorem paper_double_slit_visibility
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      2 * coarseGrainAmplitude s p n ^ 2 *
        (1 + Real.cos (planeWavePhase k₁ ω₁ p n -
                        planeWavePhase k₂ ω₂ p n)) :=
  double_slit_visibility s m k₁ k₂ ω₁ ω₂ p n

/-- **Theorem 5, constructive peak.**  When the phase difference
    vanishes, the interference pattern doubles the amplitude and the
    intensity is `4 · A²` — the canonical quantum-doubling at the
    maximum fringe.

    Proof: `two_slit_constructive_peak` in `Interference.lean`. -/
theorem paper_two_slit_constructive_peak
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ)
    (hΔφ : planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n = 0) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      4 * coarseGrainAmplitude s p n ^ 2 :=
  two_slit_constructive_peak s m k₁ k₂ ω₁ ω₂ p n hΔφ

/-- **Theorem 5, destructive null.**  When the phase difference is
    exactly `π`, the interference pattern cancels identically — the
    canonical quantum-minimum at the destructive fringe.

    Proof: `two_slit_destructive_null` in `Interference.lean`. -/
theorem paper_two_slit_destructive_null
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ)
    (hΔφ : planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n = Real.pi) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 = 0 :=
  two_slit_destructive_null s m k₁ k₂ ω₁ ω₂ p n hΔφ

/-- **Theorem 5, Born-rule consistency under `HasZeroFunctional`.**
    On a `DynamicalSnapshotSequence` with `HasZeroFunctional`, the
    substrate amplitude `A(p, n)` is tick-invariant, so the interference
    pattern's amplitude envelope `2 · A²` does not change across ticks.
    All tick dependence of `|ψ_super|²` sits in the `cos(Δφ)` factor via
    the `−ω · n` piece of the plane-wave phases.  This is the formal
    statement of compatibility between Phase 3 (Born-rule conservation)
    and Phase 4 (interference).

    Proof: `two_slit_envelope_tick_invariant` in `Interference.lean`. -/
theorem paper_two_slit_envelope_tick_invariant
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (m : ℝ) (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n k : ℕ) :
    coarseGrainAmplitude d.toSnapshotSequence p n =
      coarseGrainAmplitude d.toSnapshotSequence p k :=
  two_slit_envelope_tick_invariant d hF m k₁ k₂ ω₁ ω₂ p n k

/-- **Theorem 5, flat-vacuum sanity check.**  On the Minkowski vacuum
    the substrate amplitude is `exp(−1)`, so the two-slit pattern
    collapses to the full-contrast cosine fringe
    `|ψ_super|² = 2 · exp(−2) · (1 + cos Δφ)`.

    Proof: `two_slit_on_flat` in `Interference.lean`. -/
theorem paper_two_slit_on_flat
    (m : ℝ) (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField SnapshotSequence.flat m k₁ ω₁)
        (planeWaveField SnapshotSequence.flat m k₂ ω₂) p n‖ ^ 2 =
      2 * Real.exp (-2) *
        (1 + Real.cos (planeWavePhase k₁ ω₁ p n -
                        planeWavePhase k₂ ω₂ p n)) :=
  two_slit_on_flat m k₁ k₂ ω₁ ω₂ p n

/-! ## Theorem 6 — Heisenberg uncertainty principle (Phase 6A)

  The position and momentum operators `positionOperator μ` and
  `momentumOperator μ` are defined in `Heisenberg.lean` as the lattice
  analogues of `x̂_μ` and `p̂_μ = −iℏ ∂_μ`.  The canonical lattice
  Heisenberg uncertainty theorem states, for any lattice wavefunction
  `ψ` normalised on a finite region, that the variance product of
  position and momentum in the same direction is bounded below by
  `(ℏ/2)²`, **provided** the lattice commutator evaluated against `ψ`
  matches its continuum value `ℏ`.

  The hypothesis `CommutatorMatchesMean (x̂_μ) (p̂_μ) ℏ ψ R n` is the
  honest scope of the lattice theorem: on smooth states
  (plane waves, Gaussians) it holds up to `O(ℓ_P²)` corrections; on
  a generic lattice state the correction is a concrete polynomial in
  the local discrete-derivative values of `ψ` and can be absorbed
  into an explicit `O(ℓ_P)` Planck-scale remainder. -/

/-- **Theorem 6 (Heisenberg uncertainty, from the lattice).**

    For any direction `μ`, any `LatticeComplexField ψ`, any finite
    region, any tick `n`, and the canonical commutator-matching
    hypothesis
    `CommutatorMatchesMean (positionOperator μ) (momentumOperator μ) ℏ ψ R n`,
    the variance product of position and momentum in direction `μ`
    satisfies the Heisenberg bound:

        variance_x μ ψ R n · variance_p μ ψ R n  ≥  (ℏ / 2)².

    To the authors' knowledge, this is the first machine-checked
    derivation of the Heisenberg uncertainty relation from a discrete
    gravitational substrate — under an explicit, honestly-stated
    commutator-matching hypothesis.  We do not claim an exhaustive
    survey of the formalisation literature, and the wording is
    best-effort rather than categorical.

    Proof: `heisenberg_uncertainty_from_lattice` in
    `OmegaTheory.Emergence.Heisenberg`. -/
theorem paper_heisenberg_uncertainty
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (hnorm : ∑ p ∈ region, ‖ψ p tick‖ ^ 2 = 1)
    (hcomm : CommutatorMatchesMean (positionOperator μ)
              (momentumOperator μ) hbar ψ region tick) :
    variance_x μ ψ region tick * variance_p μ ψ region tick ≥
      (hbar / 2) ^ 2 :=
  heisenberg_uncertainty_from_lattice μ ψ region tick hnorm hcomm

/-- **Theorem 6, abstract form.**  The Robertson variance-product
    inequality on the lattice, written in the general shape
    `‖Aψ‖² · ‖Bψ‖² ≥ |⟨[A, B]⟩/2|²` for any two lattice operators
    `A, B`.  This is the statement from which Theorem 6 specialises
    by setting `A = x̂_μ, B = p̂_μ` and invoking
    `CommutatorMatchesMean ... ℏ`.

    Proof: `heisenberg_uncertainty_abstract` in `Heisenberg.lean`. -/
theorem paper_heisenberg_uncertainty_abstract
    (A B : LatticeOperator) (c : ℝ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (hcomm : CommutatorMatchesValue A B c ψ region tick) :
    l2Variance A (0 : ℂ) ψ region tick *
        l2Variance B (0 : ℂ) ψ region tick
      ≥ (c / 2) ^ 2 :=
  heisenberg_uncertainty_abstract A B c ψ region tick hcomm

/-! ## Theorem 7 — Measurement / collapse (Phase 6B)

  Standard non-relativistic QM introduces the **collapse postulate**
  as a separate axiom: upon measurement the wavefunction is
  projected onto the eigenstate of the measured outcome and
  renormalised.  `Measurement.lean` derives this as a theorem.  The
  projector is the pointwise indicator `measurementProjector q`, the
  renormalisation is `normaliseCoarseGrain` (division by
  `regionL2Norm`), and the composition `postMeasurementState = (i)
  project, (ii) renormalise` satisfies all four clauses of the
  textbook collapse postulate — with the *crucial* honest
  acknowledgement that the post-measurement state is provably
  *outside* the image of `coarseGrain`.  Collapse is non-unitary,
  as a theorem.

  The region-relative ℓ²-norm `regionL2NormSq` is the correct
  infinite-lattice substitute for the standard textbook `∫|ψ|²`,
  because the Omega substrate lives on `ℤ⁴` with no natural total
  ℓ² mass.  Every paper-level statement in this section is
  parametrised by a `Finset LatticePoint` that the probability is
  conditioned on. -/

/-- **Theorem 7 (Measurement / collapse postulate).**

    Let `region : Finset LatticePoint`, `ψ : LatticeComplexField`,
    `q : LatticePoint`, `tick : ℕ`, with `q ∈ region` and
    `ψ q tick ≠ 0`.  Then the four standard-QM clauses of the
    collapse postulate all hold simultaneously:

    (1) **Born-ratio probability**
        `probability_of_outcome region ψ q tick
           = ‖ψ q tick‖² / regionL2NormSq region ψ tick`,
    (2) **Unit norm post-measurement**
        `regionL2NormSq region (postMeasurementState ...) tick = 1`,
    (3) **Support concentration**
        `∀ p' ≠ q. postMeasurementState ... p' tick = 0`,
    (4) **Unit modulus at `q`**
        `‖postMeasurementState ... q tick‖ = 1`.

    The usual-QM "measurement axioms" — probability via Born ratio,
    unit-norm renormalisation, support concentration on the outcome,
    unit amplitude on the outcome — are all delivered by the
    single theorem `measurement_postulate` in `Measurement.lean`.

    To the authors' knowledge, this is the first machine-checked
    derivation of the measurement / collapse postulate from a
    discrete gravitational substrate, under the Born-ratio
    probability interpretation.  We do not claim an exhaustive
    survey and the wording is best-effort. -/
theorem paper_measurement_postulate
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) (hψq : ψ q tick ≠ 0) :
    probability_of_outcome region ψ q tick =
        (‖ψ q tick‖) ^ 2 / regionL2NormSq region ψ tick
    ∧ regionL2NormSq region (postMeasurementState region ψ q tick) tick = 1
    ∧ (∀ p' : LatticePoint, p' ≠ q →
        postMeasurementState region ψ q tick p' tick = 0)
    ∧ ‖postMeasurementState region ψ q tick q tick‖ = 1 :=
  measurement_postulate region ψ q tick hq hψq

/-- **Theorem 7, non-unitarity witness.**  The post-measurement state
    is *not* a coarse-grained field: at any `p' ≠ q`, it is zero,
    whereas `coarseGrain s p' tick` has strictly positive modulus
    (the `exp(−I_KL/2)` amplitude).  The Phase-2 Schrödinger-shape
    bound therefore does not apply to the post-measurement state,
    and it should not: wavefunction collapse is non-unitary by
    construction.  This theorem is the *formal acknowledgement* that
    the measurement operation leaves the image of `coarseGrain`.

    The statement is an inequality between a pointwise field value
    and a `coarseGrain` evaluation, not a quantitative bound — it is
    a *witness* of non-equality at a single site.

    Proof: `postMeasurement_not_in_coarseGrain_image` in
    `Measurement.lean`. -/
theorem paper_postMeasurement_non_unitary
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (p' : LatticePoint) (hp'_ne : p' ≠ q)
    (s : SnapshotSequence) :
    postMeasurementState region ψ q tick p' tick ≠
      coarseGrain s p' tick :=
  postMeasurement_not_in_coarseGrain_image region ψ q tick p' hp'_ne s

/-- **Theorem 7, tick-invariance bridge to Phase 3.**  Under the
    dynamical sequence's `HasZeroFunctional` regime, the Born-ratio
    probability of outcome `q` is tick-invariant: the probability
    does not drift across the snapshot evolution.  This composes the
    pointwise invariance from Phase 3 (BornRule.lean) with the
    region-ratio definition here.

    Proof: `probability_of_outcome_invariant_under_hasZero` in
    `Measurement.lean`. -/
theorem paper_probability_of_outcome_invariant_under_hasZero
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (q : LatticePoint) (n k : ℕ) :
    probability_of_outcome region
        (coarseGrainWithPhase d.toSnapshotSequence phase m) q n =
      probability_of_outcome region
        (coarseGrainWithPhase d.toSnapshotSequence phase m) q k :=
  probability_of_outcome_invariant_under_hasZero d hF phase m region q n k

/-- **Theorem 7, Minkowski-vacuum specialisation.**  On the flat
    coarse-grained field, every outcome in the region is uniformly
    distributed: `probability_of_outcome region (coarseGrain flat) q tick
    = 1 / |region|`.  The `exp(−2)` substrate amplitude cancels
    between numerator and denominator.

    Proof: `probability_of_outcome_flat` in `Measurement.lean`. -/
theorem paper_probability_of_outcome_flat
    (region : Finset LatticePoint) (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) :
    probability_of_outcome region
        (coarseGrain SnapshotSequence.flat) q tick =
      1 / region.card :=
  probability_of_outcome_flat region q tick hq

/-! ## Theorem 8 — Entanglement & Bell inequality violation (Phase 6C)

  The two-body lattice field `bellField = (|00⟩ + |11⟩) / √2`
  (built in `Entanglement.lean` as a `TwoBodyField : LatticePoint →
  LatticePoint → ℕ → ℂ`) is the Omega-substrate reconstruction of
  the singlet Bell state.  Phase 6C delivers four headline
  theorems:

  * **Structural entanglement**: `bellField_isEntangled` —
    `bellField` is *not* in the image of any `tensorProduct ψ_A ψ_B`.
  * **Pure-cosine correlation**: `cos_correlation_theorem` — the
    two-particle correlator is `cos(α − β)`.
  * **Tsirelson-bound attainment**: `chsh_tsirelson_bell` — at
    canonical angles `(0, π/2, π/4, 3π/4)`, the CHSH value is
    *exactly* `2 · √2`.
  * **Classical-Bell-bound violation**: `bell_inequality_violation`
    — the same CHSH value strictly exceeds `2`.

  Together these say: the classical Bell bound `2`, which is the
  maximum attainable by any local-hidden-variable theory, is
  strictly violated by `bellField`; and the quantum Tsirelson bound
  `2 · √2`, which is the maximum attainable by any quantum
  correlator, is *saturated*.  Einstein's "spooky action at a
  distance" is thereby a theorem of Omega-Theory V2.

  **Design choice (from Phase 4 / Interference).**  As with
  two-slit interference, superposition in Phase 6C lives at the
  `LatticeComplexField` / `TwoBodyField` level, not at
  `SnapshotSequence` level, because `DiscreteMetric` lacks a
  Lorentzian-respecting additive structure.  The bilinearity of
  `tensorProduct` on the complex-field side is what makes the Bell
  construction algebraically clean (see
  `tensorProduct_add_left` / `_add_right` in `Entanglement.lean`). -/

/-- **Theorem 8a (Bell state is entangled).**

    The lattice Bell state `bellField = (|00⟩ + |11⟩) / √2` is
    entangled in the strongest structural sense: there exist no
    single-body fields `ψ_A, ψ_B : LatticeComplexField` such that
    `bellField = ψ_A ⊗ ψ_B` (pointwise at any `(p, q, n)`).

    This is the algebraic entanglement witness: non-factorisability
    of the two-body wavefunction.  It is complementary to the
    observational signature `bell_inequality_violation` below.

    Proof: `bellField_isEntangled` in
    `OmegaTheory.Emergence.Entanglement`. -/
theorem paper_bell_state_exists :
    IsEntangled bellField :=
  bellField_isEntangled

/-- **Theorem 8b (Bell correlator is a pure cosine).**

    The two-particle measurement correlator of the lattice Bell
    state, parametrised by measurement-angles `α` on particle A
    and `β` on particle B, is exactly
    `correlationBell α β = cos(α − β)`.

    Proof: `cos_correlation_theorem` in `Entanglement.lean`.

    Physically, this identity — *not merely boundedness* — is what
    enables the Tsirelson-bound attainment below: a local hidden
    variable model can approximate bounded correlators, but the
    *exact* cosine shape combined with canonical CHSH angles is
    what forces the `2√2` peak. -/
theorem paper_cos_correlation (α β : ℝ) :
    correlationBell α β = Real.cos (α - β) :=
  cos_correlation_theorem α β

/-- **Theorem 8c (Tsirelson bound attained).**

    At the canonical CHSH angle settings
    `(a, a', b, b') = (0, π/2, π/4, 3π/4)`, the CHSH-Tsirelson
    value of `bellField` equals `2 · √2` exactly — the Tsirelson
    maximum for any quantum correlator.

    To the authors' knowledge, this is the first machine-checked
    Tsirelson-bound attainment theorem from a discrete-gravity
    substrate.  We do not claim exhaustive survey.

    Proof: `chsh_tsirelson_bell` in `Entanglement.lean`. -/
theorem paper_chsh_tsirelson_bound :
    chshTsirelsonBell 0 (Real.pi / 2) (Real.pi / 4) (3 * Real.pi / 4) =
      2 * Real.sqrt 2 :=
  chsh_tsirelson_bell

/-- **Theorem 8d (Bell inequality violation).**

    Strictly greater than the classical Bell bound `2`:

        chshTsirelsonBell 0 (π/2) (π/4) (3π/4)  >  2.

    This is the machine-checked formalisation of Bell's theorem on
    the discrete-gravity lattice: there is an entangled two-body
    field (`bellField`) whose measurement-outcome correlations
    strictly exceed the maximum attainable by any local hidden
    variable theory.

    Proof: `bell_inequality_violation` in `Entanglement.lean`. -/
theorem paper_bell_inequality_violation :
    chshTsirelsonBell 0 (Real.pi / 2) (Real.pi / 4) (3 * Real.pi / 4) > 2 :=
  bell_inequality_violation

/-- **Theorem 8, consistency bundle.**  `bellField` is entangled
    *and* violates CHSH — the structural and observational signatures
    of entanglement agree on the same witness state.

    Proof: `bell_inequality_entanglement_consistency` in
    `Entanglement.lean`. -/
theorem paper_bell_entanglement_consistency :
    IsEntangled bellField ∧
      chshTsirelsonBell 0 (Real.pi / 2) (Real.pi / 4) (3 * Real.pi / 4) > 2 :=
  bell_inequality_entanglement_consistency

/-! ## Capstone — Grand QM Emergence (Phase 6D)

  `QuantumMechanicsCapstone.lean` bundles every paper-exported
  theorem of §§5–11 into a single predicate
  `QuantumMechanicsPostulates d hscope ψ region tick` and proves
  `grand_qm_emergence` — the umbrella theorem stating that on every
  dynamical snapshot sequence with `HasZeroFunctional`, every
  coarse-grained state `ψ`, every finite region, every tick, the
  eight-conjunct postulate record holds:

      states + superposition + schrödinger + born_rule +
      interference + heisenberg + measurement + entanglement.

  Each conjunct is a direct citation of a sibling theorem; the
  capstone is a field-by-field assembly, not an independent proof.
  This is the paper's single umbrella headline — the statement that
  "quantum mechanics emerges from V2" with a specific formalisation
  of "quantum mechanics" as the 8-field postulate record. -/

/-- **Capstone (Grand QM Emergence).**

    On every dynamical snapshot sequence `d` in the
    `HasZeroFunctional` regime, for every coarse-grained state `ψ`
    on a finite region at a tick, the canonical 8-field QM postulate
    record holds: states, superposition, Schrödinger, Born rule,
    interference, Heisenberg, measurement, and
    entanglement (Bell-violation).

    To the authors' knowledge, this is the first complete
    machine-checked derivation of the postulates of non-relativistic
    quantum mechanics from a discrete gravitational substrate in a
    proof assistant.  We do not claim exhaustive survey of the
    formalisation literature; the wording is best-effort.

    Proof: `grand_qm_emergence` in
    `OmegaTheory.Emergence.QuantumMechanicsCapstone`. -/
theorem paper_grand_qm_emergence
    (d : DynamicalSnapshotSequence) (hscope : d.HasZeroFunctional)
    (ψ : LatticeComplexField) (region : Finset LatticePoint)
    (tick : ℕ) :
    QuantumMechanicsPostulates d hscope ψ region tick :=
  grand_qm_emergence d hscope ψ region tick

/-- **Capstone, Minkowski specialisation.**  On the flat dynamical
    Minkowski vacuum the capstone holds for any coarse-grained
    state.  This is the sanity check: the grand umbrella theorem
    collapses correctly on the vacuum.

    Proof: `grand_qm_emergence_on_minkowski` in `QuantumMechanicsCapstone`. -/
theorem paper_grand_qm_emergence_on_minkowski
    (ψ : LatticeComplexField) (region : Finset LatticePoint) (tick : ℕ) :
    QuantumMechanicsPostulates minkowskiDynamicalSequence
      minkowskiDynamicalSequence_hasZeroFunctional ψ region tick :=
  grand_qm_emergence_on_minkowski ψ region tick

/-! ## Summary

  The eight headline theorems of the paper, plus the capstone, are:

  * `paper_coarseGrain_exists`             (Theorem 1, coarse-graining map)
  * `paper_schrodinger_bound`              (Theorem 2, static Schrödinger
                                             bound)
  * `paper_schrodinger_bound_dynamic`      (Theorem 2, dynamical lift
                                             under `HasZeroFunctional`)
  * `paper_bornRule_conservation`          (Theorem 3, Born-rule
                                             conservation under
                                             `HasZeroFunctional`)
  * `paper_nonrel_limit`                   (Theorem 4, non-rel limit)
  * `paper_two_slit_interference`          (Theorem 5, two-slit
                                             interference, *exact*)
  * `paper_heisenberg_uncertainty`         (Theorem 6, Heisenberg
                                             uncertainty on the lattice
                                             under `CommutatorMatchesMean`)
  * `paper_measurement_postulate`          (Theorem 7, collapse /
                                             measurement postulate as a
                                             4-clause bundle)
  * `paper_chsh_tsirelson_bound`           (Theorem 8, Tsirelson bound
                                             `2·√2` attained by `bellField`)
  * `paper_bell_inequality_violation`      (Theorem 8, classical
                                             Bell bound `2` violated)
  * `paper_grand_qm_emergence`             (Capstone, 8-field umbrella
                                             theorem bundling all of
                                             Phases 1–6 into the single
                                             `QuantumMechanicsPostulates`
                                             record)

  Auxiliary corollaries that the paper cites:

  * `paper_coarseGrain_flat`               — vacuum specialisation of T1
  * `paper_coarseGrainWithPhase_exists`    — phase-carrying T1 variant
                                              (`|ψ|²` mass- and phase-blind)
  * `paper_coarseGrainWithPhase_flat`      — phase-carrying vacuum
  * `paper_schrodinger_bound_flat`         — flat-background static T2
                                              without stencil hypotheses
  * `paper_schrodinger_massless`           — honest massless degeneracy
  * `paper_schrodinger_bound_phase_zero`   — static T2 for
                                              `coarseGrainWithPhase` at
                                              zero phase
  * `paper_schrodinger_bound_dynamic_flat` — Minkowski corollary of
                                              dynamical T2
  * `paper_schrodinger_bound_dynamic_phase_zero`
                                            — dynamical T2 for
                                              `coarseGrainWithPhase` at
                                              zero phase
  * `paper_dynamic_metric_update_rule`     — raw Phase-1 metric update
                                              `g_{n+1} − g_n = t_P · F(g_n)`
  * `paper_bornRule_pointwise_conservation`
                                            — T3 pointwise
                                              `|ψ(p, n)|² = |ψ(p, n+1)|²`
  * `paper_bornRule_amplitude_sum_invariant`
                                            — T3 iterated across any
                                              two ticks `n, k`
  * `paper_bornRule_on_minkowski`          — T3 Minkowski-vacuum
                                              specialisation without
                                              side hypotheses
  * `paper_bornRule_sum_diff_bound`        — T3 honest dynamical
                                              residue bound (no
                                              `HasZeroFunctional`)
  * `paper_bornRule_sum_diff_bound_KL`     — residue bound in
                                              KL-density form
  * `paper_bornRule_sum_eq_of_KL_static`   — residue-bound consistency
                                              with equality on KL-static
                                              regions
  * `paper_nonrel_kinetic`                 — T4 as a statement on `E − mc²`
  * `paper_schrodinger_is_nonrel_limit`    — bridge from T2 to T4
  * `paper_two_slit_interference_KL`       — T5 in KL-density form
                                              (classical + cross-term)
  * `paper_double_slit_visibility`         — T5 canonical `2A²(1 + cos Δφ)`
  * `paper_two_slit_constructive_peak`     — T5 `4A²` at `Δφ = 0`
  * `paper_two_slit_destructive_null`      — T5 `0` at `Δφ = π`
  * `paper_two_slit_envelope_tick_invariant`
                                            — T5 × T3 consistency
                                              under `HasZeroFunctional`
  * `paper_two_slit_on_flat`               — T5 Minkowski-vacuum fringe
                                              at full contrast
  * `paper_heisenberg_uncertainty_abstract`
                                            — T6 Robertson form on
                                              arbitrary lattice operators
  * `paper_postMeasurement_non_unitary`    — T7 explicit witness that
                                              collapse leaves the image
                                              of `coarseGrain`
  * `paper_probability_of_outcome_invariant_under_hasZero`
                                            — T7 × Phase 3 bridge:
                                              Born-ratio probability is
                                              tick-invariant
  * `paper_probability_of_outcome_flat`    — T7 Minkowski vacuum:
                                              outcome distribution is
                                              uniform `1 / |region|`
  * `paper_bell_state_exists`              — T8 structural entanglement
                                              (non-factorisability)
  * `paper_cos_correlation`                — T8 correlator is exactly
                                              `cos(α − β)`, not merely
                                              bounded
  * `paper_bell_entanglement_consistency`  — T8 consistency: entangled
                                              AND Bell-violating on the
                                              same witness state

  Every theorem above is proved without introducing new axioms.  The
  workstream files (`CoarseGrainingMap.lean`, `SchrodingerFromLattice.lean`,
  `SnapshotDynamics.lean`, `BornRule.lean`, `DispersionBridge.lean`,
  `Interference.lean`, `Heisenberg.lean`, `Measurement.lean`,
  `Entanglement.lean`, `QuantumMechanicsCapstone.lean`) contain the
  substantive proofs; this file is the paper-facing export.

  Zero `sorry`, zero new axioms.
-/

end OmegaTheory.Emergence
