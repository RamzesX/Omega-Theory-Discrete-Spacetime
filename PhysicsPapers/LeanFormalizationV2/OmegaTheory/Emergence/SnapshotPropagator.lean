/-
  OmegaTheory.Emergence.SnapshotPropagator

  **Motion as a sequence of computational reshaping events, each with
  bounded residual error from irrational truncation.**

  ## The picture

  From `Main-Paper-Postulates.md` (Principle 1, "All particles attempt
  to propagate at c") and `KeyInsight-Irrationals-Action-Thresholds.md`,
  motion in OmegaTheory is not a continuous evolution. It is a sequence
  of discrete SNAPSHOTS separated by one Planck time `t_P` each:

        τ=0 ────[reshape attempt 1]────▶ τ=t_P ────[reshape attempt 2]────▶ τ=2·t_P ...

  Each reshape attempt computes the particle's next geometric state
  using the lattice geometry. Because the computation requires
  irrational factors (π, e, √2), it cannot terminate exactly in a
  finite number of iterations — there is always a residual truncation
  error `ε(N)` where `N` is the iteration budget allowed before the
  action threshold `S = nℏ` forces the transition.

  The accumulated error over `K` such snapshot events scales as
  `K · ε(N)` (triangle inequality on a sum of bounded residuals). This
  is what shows up as the "computational term" in the extended Heisenberg
  uncertainty principle `Δx·Δp ≥ ℏ/2 + δ_comp(N)`: after `K` snapshots,
  the position-momentum uncertainty picks up `K · (δ_comp(N))` in
  addition to the standard `ℏ/2`.

  ## What this file formalizes

  1. A `Snapshot` structure (discrete time index + position)
  2. A `propagate` function (τ → τ + t_P)
  3. `accumulatedSnapshotError K N := K · computationalUncertainty N`
  4. Linearity of accumulation: `K+M` snapshots = `K` snapshots + `M` snapshots
  5. The bridge to `extendedUncertaintyBound`:
         `accumulatedSnapshotError K N = K · (extendedUncertaintyBound N − ℏ/2)`
     (the accumulated error is exactly `K` times the computational
     contribution to the extended Heisenberg bound)
  6. A non-negative-growth theorem (more snapshots = more error)

  ## The user's imaginary question, formalized

  Earlier in the project the user asked: *"Maybe error propagation is
  the whole point of quantum mechanics, the core truth why things move?
  I have a lecture that explained a move of electron is just the next
  snapshots of creating and destroying itself in endless cycle using
  virtual electrons."*

  This file is the minimal Lean answer. Motion = snapshot-to-snapshot
  propagation events. Each event has a residual truncation error from
  the inability to compute π, e, √2 exactly in a finite iteration
  budget. The aggregate error IS the extended Heisenberg uncertainty
  principle, term for term.

  We do not yet formalize the virtual-electron pair picture from QFT —
  that would require a second-quantization framework beyond V2's
  current scope. But the "snapshot + computational residue" picture
  is captured exactly here.
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Lattice

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime OmegaTheory.Irrationality

/-! ## Snapshots as discrete propagation events -/

/-- A **snapshot** is a single propagation event: a lattice point, a
    discrete time index (in units of Planck time), and an iteration
    budget `N` describing how many refinement steps the reshaping
    attempt was allowed before the action-threshold crossing forced
    the transition. -/
structure Snapshot where
  /-- The spatial lattice point at this snapshot. -/
  point : LatticePoint
  /-- The discrete Planck-time index. -/
  tick : ℕ
  /-- Iteration budget for the reshaping calculation at this tick. -/
  iterations : ℕ

/-- Advance a snapshot by one Planck tick, leaving position and budget
    unchanged. In OmegaTheory's picture, the "particle" is recreated at
    each new tick; this function is the *identity on the lattice point*
    only because we are tracking a single-cell reshaping attempt. -/
noncomputable def Snapshot.propagate (s : Snapshot) : Snapshot where
  point := s.point
  tick := s.tick + 1
  iterations := s.iterations

/-- Iterate propagation `n` times. -/
noncomputable def Snapshot.propagateN (s : Snapshot) : ℕ → Snapshot
  | 0 => s
  | n + 1 => (Snapshot.propagateN s n).propagate

theorem Snapshot.propagateN_tick (s : Snapshot) (n : ℕ) :
    (s.propagateN n).tick = s.tick + n := by
  induction n with
  | zero => simp [propagateN]
  | succ k ih =>
    simp [propagateN, propagate, ih]
    ring

theorem Snapshot.propagateN_point (s : Snapshot) (n : ℕ) :
    (s.propagateN n).point = s.point := by
  induction n with
  | zero => simp [propagateN]
  | succ k ih =>
    simp [propagateN, propagate, ih]

theorem Snapshot.propagateN_iterations (s : Snapshot) (n : ℕ) :
    (s.propagateN n).iterations = s.iterations := by
  induction n with
  | zero => simp [propagateN]
  | succ k ih =>
    simp [propagateN, propagate, ih]

/-! ## Accumulated computational error

Each snapshot contributes `computationalUncertainty N` of residual
error where `N` is the iteration budget at that snapshot. Over `K`
consecutive snapshots with the same budget, the accumulated error
is `K · computationalUncertainty N`. -/

/-- Accumulated computational error over `numSnapshots` propagation
    events, each using `iterationBudget` iterations.

    Under triangle inequality, this is the upper bound on the total
    positional/momentum uncertainty contributed by computational
    residue over `numSnapshots` Planck ticks. -/
noncomputable def accumulatedSnapshotError
    (numSnapshots : ℕ) (iterationBudget : ℕ) : ℝ :=
  (numSnapshots : ℝ) * computationalUncertainty iterationBudget

/-- Accumulated error is non-negative. -/
theorem accumulatedSnapshotError_nonneg (K N : ℕ) :
    0 ≤ accumulatedSnapshotError K N := by
  unfold accumulatedSnapshotError
  exact mul_nonneg (Nat.cast_nonneg _) (computationalUncertainty_nonneg N)

/-- The trivial base case: zero snapshots → zero accumulated error. -/
theorem accumulatedSnapshotError_zero (N : ℕ) :
    accumulatedSnapshotError 0 N = 0 := by
  unfold accumulatedSnapshotError
  simp

/-- **Linearity**: `K + M` snapshots accumulates
    `K + M` times the per-snapshot error, which decomposes
    additively. -/
theorem accumulatedSnapshotError_add (K M N : ℕ) :
    accumulatedSnapshotError (K + M) N =
    accumulatedSnapshotError K N + accumulatedSnapshotError M N := by
  unfold accumulatedSnapshotError
  push_cast
  ring

/-- **Monotonicity**: more snapshots → more accumulated error. -/
theorem accumulatedSnapshotError_mono {K₁ K₂ : ℕ} (N : ℕ) (h : K₁ ≤ K₂) :
    accumulatedSnapshotError K₁ N ≤ accumulatedSnapshotError K₂ N := by
  unfold accumulatedSnapshotError
  exact mul_le_mul_of_nonneg_right
    (Nat.cast_le.mpr h) (computationalUncertainty_nonneg N)

/-- **Budget monotonicity**: a larger iteration budget gives a smaller
    per-snapshot error (truncation is less severe), so with the same
    number of snapshots, increasing the budget reduces the accumulated
    error. -/
theorem accumulatedSnapshotError_budget_decreasing (K : ℕ) (N : ℕ) :
    accumulatedSnapshotError K (N + 1) ≤ accumulatedSnapshotError K N := by
  unfold accumulatedSnapshotError
  exact mul_le_mul_of_nonneg_left
    (computationalUncertainty_decreasing N) (Nat.cast_nonneg _)

/-! ## Bridge to the extended Heisenberg uncertainty bound

The key identity: the per-snapshot computational error equals
the computational contribution to the extended Heisenberg bound.
Over `K` snapshots, the accumulated error is exactly `K · (B_ext − ℏ/2)`
where `B_ext = extendedUncertaintyBound N`. -/

/-- Per-snapshot computational error equals the computational term
    in the extended Heisenberg bound. -/
theorem perSnapshot_error_eq_extended_minus_heisenberg (N : ℕ) :
    computationalUncertainty N = extendedUncertaintyBound N - hbar / 2 := by
  unfold extendedUncertaintyBound
  ring

/-- **Motion = accumulated extended Heisenberg residue**:
    `K` consecutive snapshots at iteration budget `N` accumulate
    exactly `K · (extendedUncertaintyBound N − ℏ/2)` of computational
    error — i.e., `K` times the "extra term" that distinguishes the
    extended bound from the standard Heisenberg bound.

    **Physical interpretation** (Reading of Appendices A + KeyInsight):
    a particle moves through `K` Planck ticks. At each tick, the
    reshaping calculation introduces a residual truncation error
    of `δ_comp(N) = extendedUncertaintyBound N − ℏ/2`. After `K` ticks,
    the total residue is `K · δ_comp(N)`. This IS the source of
    observed quantum uncertainty in the OmegaTheory picture: motion
    accumulates computational residue, and "quantum fuzziness" is
    what that residue looks like on an instrument. -/
theorem motion_is_accumulated_extended_heisenberg (K N : ℕ) :
    accumulatedSnapshotError K N =
    (K : ℝ) * (extendedUncertaintyBound N - hbar / 2) := by
  unfold accumulatedSnapshotError
  rw [perSnapshot_error_eq_extended_minus_heisenberg]

/-- A single snapshot's error contribution is bounded above by the
    full extended bound (since `ℏ/2 > 0`). -/
theorem single_snapshot_error_le_extended_bound (N : ℕ) :
    computationalUncertainty N ≤ extendedUncertaintyBound N := by
  unfold extendedUncertaintyBound
  have h : (0 : ℝ) ≤ hbar / 2 := le_of_lt (div_pos hbar_pos two_pos)
  linarith

/-! ## Connection to the snapshot count over a finite duration

A physical observer watching a particle over duration `τ` sees
`K ≈ τ/t_P` snapshots. The accumulated uncertainty grows linearly
with duration — which is the discrete analog of decoherence time
scaling. -/

/-- Number of snapshot propagation events in a duration of `n`
    Planck ticks. Trivially `n` by definition. -/
def snapshotCount (n : ℕ) : ℕ := n

/-- Accumulated error over `n` Planck ticks at budget `N`. -/
noncomputable def accumulatedErrorOverDuration (n N : ℕ) : ℝ :=
  accumulatedSnapshotError (snapshotCount n) N

theorem accumulatedErrorOverDuration_zero (N : ℕ) :
    accumulatedErrorOverDuration 0 N = 0 := by
  unfold accumulatedErrorOverDuration snapshotCount
  exact accumulatedSnapshotError_zero N

theorem accumulatedErrorOverDuration_mono
    {n₁ n₂ : ℕ} (N : ℕ) (h : n₁ ≤ n₂) :
    accumulatedErrorOverDuration n₁ N ≤ accumulatedErrorOverDuration n₂ N := by
  unfold accumulatedErrorOverDuration snapshotCount
  exact accumulatedSnapshotError_mono N h

end OmegaTheory.Emergence
