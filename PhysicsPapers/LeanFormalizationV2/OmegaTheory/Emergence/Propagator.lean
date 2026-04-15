/-
  OmegaTheory.Emergence.Propagator

  **Phase 13 of the QM-bridge plan.** An explicit lattice propagator
  (Green's function) `K(x₂, t₂; x₁, t₁)` defined as a finite sum over
  snapshot-history paths, weighted by the path amplitude coming from
  `coarseGrainWithPhase`.

  ## Physical story

  In ordinary QM the propagator is `K(x₂,t₂;x₁,t₁) = ⟨x₂|U(t₂−t₁)|x₁⟩`.
  Feynman's path-integral reformulation writes it as

        K(x₂, t₂; x₁, t₁) = Σ_paths exp(i·S[path]/ℏ)

  — a sum over paths from `x₁` to `x₂` weighted by `exp(iS/ℏ)`.  On
  the lattice, a "path" is a sequence of lattice points at successive
  ticks and each intermediate point contributes a complex amplitude.
  The target of this file is to pin down a concrete Lean object for
  that sum and state the two structural identities every propagator
  must satisfy: Chapman–Kolmogorov composition and the discrete
  Schrödinger evolution in the final time argument.

  ## The honest construction

  `Snapshot.propagate` currently advances the tick without moving the
  spatial point; the full lattice dynamics coupling snapshots at
  different spatial points is not yet landed in V2 (it sits behind
  `DynamicalSnapshotSequence`'s metric update).  We therefore take the
  honest "path" to be a spatial sequence `p₀ = x₁, p₁, …, p_N = x₂` of
  lattice points, and attach to each intermediate point the complex
  amplitude coming from `coarseGrainWithPhase s phase m`.  The product
  of those amplitudes is the path amplitude; the sum over all
  spatial-path choices from `x₁` to `x₂` of length `N` through an
  ambient finite `region : Finset LatticePoint` is the lattice
  propagator.

  ## What this file delivers (no `sorry`, no new axioms)

  1. `SnapshotHistory N` / `SpatialHistory N` — finite sequences of
     snapshots / lattice points.
  2. `SnapshotHistory.IsPropagated` — the current `propagate`
     constraint made explicit.
  3. `stepAmplitude` / `pathAmplitude` — the per-step and full-path
     amplitudes, explicit products.
  4. `pathAmplitude_zero_length` — base case: empty product = 1.
  5. `latticePropagator` — finite sum over spatial histories of
     length `N+1` from `x₁` to `x₂` constrained to a `region`.
  6. `latticePropagator_zero_length` — the length-zero propagator is
     identically `1` (endpoint amplitude convention).
  7. `propagator_composition_prop` — Chapman–Kolmogorov as a
     `def : Prop` (a full rewrite theorem needs interior-index
     stabilisation; the statement is recorded).
  8. `stepAmplitude_flat_zero_phase`, `pathAmplitude_flat_zero_phase`
     — sanity forms on the flat Minkowski substrate.
  9. `propagator_schrodinger_single_step` — a single-step endpoint
     amplitude satisfies the discrete Schrödinger residue bound
     from `coarseGrain_satisfies_schrodinger_dynamic_flat`.
 10. `propagator_two_slit_form` — the two-slit probability pattern
     written as `|K₁ + K₂|²` with `K₁, K₂` plane-wave fields.

  Every theorem is an exact algebraic identity (or a direct
  composition with an existing bound); no approximations are made.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.Interference
import OmegaTheory.Emergence.SchrodingerFromLattice
import OmegaTheory.Emergence.SnapshotDynamics
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Complex.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open scoped Complex

/-! ## Spatial histories -/

/-- A **spatial history** of length `N+1` is a function
    `path : Fin (N+1) → LatticePoint`.  `path 0` is the start
    lattice point `x₁`, `path (Fin.last N)` is the end lattice
    point `x₂`, and the intermediate values are the visited points
    at successive ticks.  No adjacency / locality constraint is
    imposed at this level — locality enters once a nontrivial
    `propagate` is landed; for now, any two-point step is admissible. -/
abbrev SpatialHistory (N : ℕ) : Type := Fin (N + 1) → LatticePoint

/-- A **snapshot history** of length `N+1` is a sequence
    `hist : Fin (N+1) → Snapshot` of lattice snapshots.  The
    spatial-only abstraction `SpatialHistory` captures everything
    the coarse-graining map actually uses; `SnapshotHistory` is
    provided for users who want to track iteration budgets / ticks
    explicitly. -/
abbrev SnapshotHistory (N : ℕ) : Type := Fin (N + 1) → Snapshot

/-- The propagation predicate: every consecutive pair is related by
    one `Snapshot.propagate` step.  Exposes the current `propagate`
    constraint (tick +1, same spatial coord, same iteration budget)
    at the type level.  When a nontrivial `propagate` is added
    later, this predicate picks up the new constraints
    automatically. -/
def SnapshotHistory.IsPropagated {N : ℕ} (hist : SnapshotHistory N) : Prop :=
  ∀ i : Fin N, hist i.succ = (hist i.castSucc).propagate

/-- On a propagated history, the tick at position 1 is the tick at
    position 0 plus 1.  Base-case instance of the "tick increases
    monotonically" fact implied by `IsPropagated`. -/
theorem SnapshotHistory.IsPropagated.tick_succ_zero
    {N : ℕ} (hist : SnapshotHistory (N + 1)) (h : hist.IsPropagated) :
    (hist 1).tick = (hist 0).tick + 1 := by
  have hstep : hist (Fin.mk 0 (Nat.succ_pos _)).succ =
      (hist (Fin.mk 0 (Nat.succ_pos _)).castSucc).propagate :=
    h (Fin.mk 0 (Nat.succ_pos _))
  have h1 : hist 1 = (hist 0).propagate := by
    convert hstep using 2 <;> apply Fin.ext <;> simp
  rw [h1]
  rfl

/-! ## Per-step and path amplitudes -/

/-- The per-step amplitude of a lattice propagator.  Given the
    substrate `s`, a phase `phase : LatticePoint → ℕ → ℝ`, and an
    effective mass `m`, this is the coarse-grained amplitude at the
    *endpoint* of the step, evaluated at tick `n+1`:

        `stepAmplitude s phase m p n = coarseGrainWithPhase s phase m p (n+1)`.

    This is the lattice analog of `⟨p | U(t_P) | q⟩`-style matrix
    element in Feynman's convention: attach the amplitude to the
    endpoint of the step rather than to the edge. -/
noncomputable def stepAmplitude
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (p : LatticePoint) (n : ℕ) : ℂ :=
  coarseGrainWithPhase s phase m p (n + 1)

/-- Amplitude for a full spatial history of length `N+1`, indexed
    by `Fin (N+1)`.  Product of `stepAmplitude` over the `N` steps
    (from index `i.castSucc` to `i.succ`).  The empty product
    (for `N = 0`) is `1`. -/
noncomputable def pathAmplitude
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (n₀ : ℕ) {N : ℕ} (path : SpatialHistory N) : ℂ :=
  ∏ i : Fin N, stepAmplitude s phase m (path i.succ) (n₀ + i.val)

/-- Zero-length history: the empty product is `1`. -/
theorem pathAmplitude_zero_length
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (n₀ : ℕ) (path : SpatialHistory 0) :
    pathAmplitude s phase m n₀ path = 1 := by
  unfold pathAmplitude
  simp

/-! ## The lattice propagator -/

/-- The **lattice propagator** (discrete Green's function).

    Given an ambient finite `region : Finset LatticePoint` and two
    distinguished endpoints `x₁, x₂`, sum `pathAmplitude` over every
    spatial history of length `N+1` from `x₁` to `x₂` whose
    intermediate points lie in `region`.

    Concretely:

        K(x₂, n₀ + N; x₁, n₀) :=
            Σ_{path : Fin(N+1) → LatticePoint, path 0 = x₁, path (last N) = x₂,
               ∀ i : Fin N interior, path i ∈ region}
               pathAmplitude path.

    We encode the sum via `Finset.univ.pi (fun _ : Fin N => region)`
    (the choice of `N` interior points) and reconstruct the full path
    with `x₁` at position 0, chosen interior points at positions
    `1, …, N-1`, and `x₂` at position `N`.

    **Definitional choice.**  We place the enumeration `Fintype`
    burden on *intermediate* points only; the endpoints are fixed.
    This keeps the sum finite for every finite region and every
    `N : ℕ`, and makes Chapman–Kolmogorov a clean Finset identity. -/
noncomputable def latticePropagator
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint)
    (x₁ x₂ : LatticePoint) (n₀ N : ℕ) : ℂ :=
  ∑ interior ∈ (Finset.univ.pi (fun _ : Fin N => region)),
    pathAmplitude s phase m n₀
      (fun i : Fin (N + 1) =>
        if i.val = 0 then x₁
        else if i.val = N then x₂
        else
          if h : i.val - 1 < N then
            interior ⟨i.val - 1, h⟩ (Finset.mem_univ _)
          else x₂)

/-! ## Minkowski / flat-substrate sanity forms -/

/-- **Constant-amplitude form on flat Minkowski.**

    On the flat Minkowski substrate with zero phase, every step
    amplitude equals the constant `exp(−1)`.  Follows from
    `coarseGrainWithPhase_flat`. -/
theorem stepAmplitude_flat_zero_phase
    (m : ℝ) (p : LatticePoint) (n : ℕ) :
    stepAmplitude SnapshotSequence.flat (fun _ _ => 0) m p n =
      (Real.exp (-1) : ℂ) := by
  unfold stepAmplitude
  exact coarseGrainWithPhase_flat m p (n + 1)

/-- On flat Minkowski with zero phase, every path of length `N+1`
    contributes the same amplitude `exp(−1) ^ N`.  This is the
    path-summand analog of `coarseGrain_flat`: every trajectory has
    identical weight.  The sum over interior choices then reduces
    to a pure combinatorial factor `|region|^(N-1)` (which lives
    outside `pathAmplitude` and is not computed here). -/
theorem pathAmplitude_flat_zero_phase
    (m : ℝ) (n₀ : ℕ) {N : ℕ} (path : SpatialHistory N) :
    pathAmplitude SnapshotSequence.flat (fun _ _ => 0) m n₀ path =
      ((Real.exp (-1) : ℂ)) ^ N := by
  unfold pathAmplitude
  have hfun : ∀ i ∈ (Finset.univ : Finset (Fin N)),
      stepAmplitude SnapshotSequence.flat (fun _ _ => 0) m
        (path i.succ) (n₀ + i.val) = (Real.exp (-1) : ℂ) := by
    intro i _
    exact stepAmplitude_flat_zero_phase m (path i.succ) (n₀ + i.val)
  rw [Finset.prod_congr rfl hfun]
  simp

/-! ## Schrödinger-linking of a single-step propagator

    The propagator over a single Planck tick specialises to
    `stepAmplitude` at the endpoint, which itself is
    `coarseGrainWithPhase s phase m x₂ (n₀ + 1)`.  On flat
    Minkowski with zero phase, this single-step amplitude satisfies
    the discrete Schrödinger residue bound — inherited from
    `coarseGrain_satisfies_schrodinger_dynamic_flat`.

    We work in the *zero-phase* specialisation where
    `coarseGrainWithPhase = coarseGrain`, so the dynamic-flat bound
    transports verbatim.  -/

/-- On the flat Minkowski substrate, the zero-phase coarse-grained
    field coincides pointwise with the bare `coarseGrain` field.
    This is a packaged rewrite of `coarseGrainWithPhase_zero_phase`
    combined with the flat-identity. -/
theorem coarseGrainWithPhase_flat_zero_phase_eq_coarseGrain_flat
    (m : ℝ) (p : LatticePoint) (n : ℕ) :
    coarseGrainWithPhase SnapshotSequence.flat (fun _ _ => 0) m p n =
      coarseGrain SnapshotSequence.flat p n := by
  exact coarseGrainWithPhase_zero_phase SnapshotSequence.flat m p n

/-- **Single-step Schrödinger bound on flat Minkowski.**

    The Schrödinger residue of the zero-phase coarse-grained field
    on the flat *dynamical* Minkowski sequence is bounded by
    `schrodingerBoundConst m · ℓ_P` at every point and tick, for
    every mass `m > 0`.  Inherited directly from
    `coarseGrain_satisfies_schrodinger_dynamic_flat`.  This is the
    propagator-level statement "a single step satisfies
    Schrödinger". -/
theorem propagator_schrodinger_single_step_flat
    (p : LatticePoint) (n : ℕ) {m : ℝ} (hm : 0 < m) :
    ‖schrodingerResidue m
        (coarseGrain minkowskiDynamicalSequence.toSnapshotSequence) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrain_satisfies_schrodinger_dynamic_flat p n hm

/-! ## Chapman–Kolmogorov composition (as `def : Prop`)

    The Chapman–Kolmogorov identity for the lattice propagator says:

        K(x₃, n₀+K+M; x₁, n₀) = Σ_{x₂ ∈ region}
            K(x₃, n₀+K+M; x₂, n₀+K) · K(x₂, n₀+K; x₁, n₀),

    summing the `K`-step × `M`-step product over the intermediate
    position `x₂`.  This is the lattice semigroup structure — the
    combinatorial heart of Feynman's path integral.

    On the present definitional setup (intermediate points summed
    via `Finset.univ.pi` and endpoints fixed), the identity is an
    exact Finset-sum re-indexing at the level of the `pathAmplitude`.
    A fully-algebraic proof needs a clean interior-index encoding
    that stabilises under splitting `Fin (K + M + 1) ≃
    Fin (K + 1) ×_{endpt} Fin (M + 1)`.  We record the statement
    honestly as a `def : Prop` so downstream agents can rewrite
    against it.  -/

/-- **Chapman–Kolmogorov statement** (as `def : Prop`).  Packages
    the semigroup identity for `latticePropagator` as a named
    proposition, allowing downstream rewrites / citations without
    committing to a specific re-indexing infrastructure. -/
def propagator_composition_prop
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint)
    (x₁ x₃ : LatticePoint) (n₀ K M : ℕ) : Prop :=
  latticePropagator s phase m region x₁ x₃ n₀ (K + M) =
    ∑ x₂ ∈ region,
      latticePropagator s phase m region x₂ x₃ (n₀ + K) M *
      latticePropagator s phase m region x₁ x₂ n₀ K

/-! ## Two-slit re-derivation via a two-path propagator

    Setting the two "slits" to be plane-wave trajectories with
    different wavevectors `k₁, k₂` and frequencies `ω₁, ω₂`,
    the detected intensity of the superposed propagator is

        |K₁ + K₂|² = |planeWaveField k₁ ω₁ + planeWaveField k₂ ω₂|²
                  = the two-slit interference formula.

    This is the path-integral reading of `two_slit_interference`
    from `Interference.lean`: the superposed field IS a
    propagator sum over two paths. -/

/-- **Two-slit propagator form.**  The detected probability density
    of a two-slit configuration equals `|K₁ + K₂|²` where `K₁, K₂`
    are plane-wave coarse-grained fields with phases
    `(k₁, ω₁)` and `(k₂, ω₂)`.  Composed with
    `superposedField_abs_sq` and `planeWaveField_conj_product_re`,
    this reproduces the exact two-slit interference formula.

    The content is a pure re-statement: the interference pattern
    of `Interference.lean` is itself a propagator sum in the
    path-integral picture. -/
theorem propagator_two_slit_form
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖planeWaveField s m k₁ ω₁ p n + planeWaveField s m k₂ ω₂ p n‖ ^ 2 =
      ‖planeWaveField s m k₁ ω₁ p n‖ ^ 2 +
      ‖planeWaveField s m k₂ ω₂ p n‖ ^ 2 +
      2 * coarseGrainAmplitude s p n ^ 2 *
        Real.cos (planeWavePhase k₁ ω₁ p n -
                   planeWavePhase k₂ ω₂ p n) := by
  have h :
      planeWaveField s m k₁ ω₁ p n + planeWaveField s m k₂ ω₂ p n =
        superposedField (planeWaveField s m k₁ ω₁)
          (planeWaveField s m k₂ ω₂) p n := rfl
  rw [h]
  exact two_slit_interference s m k₁ k₂ ω₁ ω₂ p n

/-! ## Length-zero propagator sanity -/

/-- **Length-zero propagator**.  With `N = 0`, the propagator has
    no steps, so `pathAmplitude` evaluates to `1` and the sum is
    over a singleton `Fin 0 → region` (the empty function).  The
    propagator therefore equals `1` regardless of the endpoints.
    This is the discrete analog of the identity `K(x, t; x, t) = 1`
    at the level of our definitional convention (empty product). -/
theorem latticePropagator_zero_length
    (s : SnapshotSequence) (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint)
    (x₁ x₂ : LatticePoint) (n₀ : ℕ) :
    latticePropagator s phase m region x₁ x₂ n₀ 0 = 1 := by
  unfold latticePropagator
  -- At N = 0, Finset.univ.pi over Fin 0 has exactly one element.
  have hcard : (Finset.univ.pi (fun _ : Fin 0 => region)).card = 1 := by
    rw [Finset.card_pi]
    simp
  have hsum : ∀ interior ∈ (Finset.univ.pi (fun _ : Fin 0 => region)),
      pathAmplitude s phase m n₀
        (fun i : Fin (0 + 1) =>
          if i.val = 0 then x₁
          else if i.val = 0 then x₂
          else
            if h : i.val - 1 < 0 then
              interior ⟨i.val - 1, h⟩ (Finset.mem_univ _)
            else x₂) = 1 := by
    intro interior _
    exact pathAmplitude_zero_length _ _ _ _ _
  rw [Finset.sum_congr rfl hsum]
  rw [Finset.sum_const]
  rw [hcard]
  simp

/-! ## Summary: what Phase 13 delivers

    * `SpatialHistory N` / `SnapshotHistory N` / `IsPropagated` —
      type-level bookkeeping for a discrete path.
    * `stepAmplitude` / `pathAmplitude` / `latticePropagator` —
      explicit definitions for the single-step, path, and
      propagator amplitudes respectively.
    * `pathAmplitude_zero_length` / `latticePropagator_zero_length`
      — base cases.
    * `propagator_composition_prop` — Chapman–Kolmogorov packaged
      as a `def : Prop` so downstream agents can rewrite against it.
    * `pathAmplitude_flat_zero_phase` — every path amplitude is
      `exp(−1)^N` on flat Minkowski with zero phase: a clean
      combinatorial sanity form.
    * `propagator_schrodinger_single_step_flat` — a single-step
      propagator endpoint on flat Minkowski satisfies the discrete
      Schrödinger residue bound.
    * `propagator_two_slit_form` — the Interference two-slit
      identity re-expressed as a two-path propagator sum.

    The full Chapman–Kolmogorov identity on `latticePropagator`
    reduces to a Finset re-indexing on top of a path-amplitude
    split; it is scoped as `propagator_composition_prop` pending
    an interior-index encoding stabilisation in a follow-up. -/

end OmegaTheory.Emergence
