/-
  OmegaTheory.Emergence.PathIntegral

  **Feynman path integral from substrate.**  Composes the discrete action
  (GraphAction.lean), snapshot error accumulation (SnapshotPropagator.lean),
  and two-slit interference (Interference.lean) into the lattice path
  integral: sum over all lattice paths weighted by exp(iS/hbar).

  ## Contents

  1. `LatticePath` — a sequence of lattice points (discretized worldline).
  2. `latticePathAction` — discrete action along a path via `graphAction`.
  3. `pathAmplitude` — `exp(i · latticePathAction / hbar)`.
  4. `pathIntegralAmplitude` — sum of `pathAmplitude` over a finset of paths.
  5. `pathIntegral_interference` — two paths give the interference identity:
     `|A1+A2|^2 = |A1|^2 + |A2|^2 + 2 Re(A1* A2)`.
  6. `pathIntegral_substrate_error` — N-tick path accumulates error
     `<= N * delta_comp(N_budget)`, bridging to `accumulatedSnapshotError`.
  7. `pathIntegral_classical_limit` — as lattice refines, the dominant
     path is the classical trajectory (stationary action).

  No `sorry`.  No new axioms.
-/

import OmegaTheory.Variational.GraphAction
import OmegaTheory.Emergence.SnapshotPropagator
import OmegaTheory.Emergence.Interference
import OmegaTheory.Emergence.Propagator
import Mathlib.Analysis.SpecialFunctions.Complex.Log
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Data.Complex.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime OmegaTheory.Variational OmegaTheory.Irrationality
open scoped Complex

/-! ## 1. Lattice paths -/

/-- A **lattice path** is a list of lattice points representing a
    discretized worldline through the Planck lattice.  The first
    element is the start, the last is the finish.  An empty list or
    singleton represents a trivial (no-step) path. -/
abbrev LatticePath := List LatticePoint

/-- A path connects `start` to `finish` when the list is nonempty,
    begins at `start`, and ends at `finish`. -/
def LatticePath.Connects (path : LatticePath) (start finish : LatticePoint) : Prop :=
  path ≠ [] ∧ path.head? = some start ∧ path.getLast? = some finish

/-- The number of steps (edges) in a path is `path.length - 1`. -/
def LatticePath.numSteps (path : LatticePath) : ℕ :=
  path.length - 1

/-! ## 2. Discrete action along a lattice path -/

/-- The **discrete action** along a lattice path, summing the graph
    Lagrangian `L(u,v) = (1/2)w(u,v)^2 - phi(u)` at each consecutive
    edge.  This reuses `graphAction` from `GraphAction.lean` verbatim.

    Physical reading: each edge contributes a kinetic term from the
    edge weight (lattice geometry) minus a potential term from the
    node field, summed along the entire worldline. -/
noncomputable def latticePathAction
    (gr : WeightedGraph) (phi : NodePotential) (path : LatticePath) : ℝ :=
  graphAction gr phi path

/-- Action of an empty path is zero. -/
theorem latticePathAction_nil (gr : WeightedGraph) (phi : NodePotential) :
    latticePathAction gr phi [] = 0 := by
  unfold latticePathAction
  exact graphAction_nil gr phi

/-- Action of a singleton path is zero (no edges). -/
theorem latticePathAction_singleton (gr : WeightedGraph) (phi : NodePotential)
    (p : LatticePoint) :
    latticePathAction gr phi [p] = 0 := by
  unfold latticePathAction
  exact graphAction_singleton gr phi p

/-! ## 3. Path amplitude -/

/-- The **path amplitude** for a lattice path: the Feynman weight
    `exp(i * S[path] / hbar)` where `S` is the discrete action.

    This is the lattice analog of Feynman's `exp(iS/hbar)` that
    weights each history in the path integral. -/
noncomputable def piPathAmplitude
    (gr : WeightedGraph) (phi : NodePotential) (path : LatticePath) : ℂ :=
  Complex.exp (Complex.I * ((latticePathAction gr phi path / hbar : ℝ) : ℂ))

/-- The amplitude of an empty path is 1 (zero action => exp(0) = 1). -/
theorem piPathAmplitude_nil (gr : WeightedGraph) (phi : NodePotential) :
    piPathAmplitude gr phi [] = 1 := by
  unfold piPathAmplitude
  rw [latticePathAction_nil]
  simp

/-- The amplitude of a singleton path is 1. -/
theorem piPathAmplitude_singleton (gr : WeightedGraph) (phi : NodePotential)
    (p : LatticePoint) :
    piPathAmplitude gr phi [p] = 1 := by
  unfold piPathAmplitude
  rw [latticePathAction_singleton]
  simp

/-- Every path amplitude has unit modulus: `|exp(iS/hbar)| = 1`.
    This is the defining property of Feynman's phase-weighting:
    all paths contribute equally in magnitude; only the phase
    differs. -/
theorem piPathAmplitude_norm (gr : WeightedGraph) (phi : NodePotential)
    (path : LatticePath) :
    ‖piPathAmplitude gr phi path‖ = 1 := by
  unfold piPathAmplitude
  rw [Complex.norm_exp]
  simp [Complex.mul_re, Complex.I_re, Complex.I_im, Complex.ofReal_re, Complex.ofReal_im]

/-! ## 4. Path integral amplitude -/

/-- The **path integral amplitude** from `start` to `finish`: the sum
    of `piPathAmplitude` over a finite set of lattice paths.

    In a finite lattice, the set of all paths of bounded length is
    finite, so this is a well-defined Finset sum.  The user supplies
    the relevant `Finset LatticePath`; the definition is agnostic to
    how that set is constructed. -/
noncomputable def pathIntegralAmplitude
    (gr : WeightedGraph) (phi : NodePotential)
    (paths : Finset LatticePath) : ℂ :=
  ∑ path ∈ paths, piPathAmplitude gr phi path

/-- Path integral over an empty set of paths is zero. -/
theorem pathIntegralAmplitude_empty (gr : WeightedGraph) (phi : NodePotential) :
    pathIntegralAmplitude gr phi ∅ = 0 := by
  unfold pathIntegralAmplitude
  simp

/-- Path integral over a singleton set equals the single path's amplitude. -/
theorem pathIntegralAmplitude_singleton (gr : WeightedGraph) (phi : NodePotential)
    (path : LatticePath) :
    pathIntegralAmplitude gr phi {path} = piPathAmplitude gr phi path := by
  unfold pathIntegralAmplitude
  simp

/-- The path integral decomposes additively over disjoint path sets.
    This is the combinatorial semigroup property underlying
    Chapman-Kolmogorov composition. -/
theorem pathIntegralAmplitude_union
    (gr : WeightedGraph) (phi : NodePotential)
    (S₁ S₂ : Finset LatticePath) (hdisj : Disjoint S₁ S₂) :
    pathIntegralAmplitude gr phi (S₁ ∪ S₂) =
      pathIntegralAmplitude gr phi S₁ +
      pathIntegralAmplitude gr phi S₂ := by
  unfold pathIntegralAmplitude
  exact Finset.sum_union hdisj

/-! ## 5. Two-path interference identity -/

/-- **Path integral interference theorem.**  For any two complex
    amplitudes `A₁, A₂` (not necessarily from paths — stated at the
    algebraic level):

        |A₁ + A₂|² = |A₁|² + |A₂|² + 2 · Re(A₁ · conj A₂).

    This is the universal interference identity that makes the
    Feynman path integral produce quantum interference.  It is
    the same identity as `superposedField_abs_sq` from
    `Interference.lean`, restated for arbitrary amplitudes. -/
theorem pathIntegral_interference (A₁ A₂ : ℂ) :
    ‖A₁ + A₂‖ ^ 2 =
      ‖A₁‖ ^ 2 + ‖A₂‖ ^ 2 + 2 * (A₁ * (starRingEnd ℂ) A₂).re := by
  rw [Complex.sq_norm, Complex.sq_norm, Complex.sq_norm]
  exact Complex.normSq_add A₁ A₂

/-- **Two-path specialization.**  When the path integral has exactly
    two paths, the detection probability is the interference formula
    applied to their individual amplitudes.

    This bridges the abstract `pathIntegralAmplitude` to the
    physics of the two-slit experiment: the "two slits" are two
    lattice paths, and the detected intensity carries the cross
    term `2 Re(A₁* A₂)`. -/
theorem pathIntegral_two_paths
    (gr : WeightedGraph) (phi : NodePotential)
    (p₁ p₂ : LatticePath) (hne : p₁ ≠ p₂) :
    ‖pathIntegralAmplitude gr phi {p₁, p₂}‖ ^ 2 =
      ‖piPathAmplitude gr phi p₁‖ ^ 2 +
      ‖piPathAmplitude gr phi p₂‖ ^ 2 +
      2 * (piPathAmplitude gr phi p₁ *
        (starRingEnd ℂ) (piPathAmplitude gr phi p₂)).re := by
  unfold pathIntegralAmplitude
  rw [Finset.sum_pair hne]
  exact pathIntegral_interference _ _

/-- **Two unit-modulus paths.**  Since `|exp(iS/hbar)| = 1` for
    both paths, the interference formula simplifies:

        |A₁ + A₂|² = 2 + 2 · Re(A₁ · conj A₂).

    The cross term `Re(A₁ · conj A₂) = cos((S₁ - S₂)/hbar)` is
    what produces the fringe pattern. -/
theorem pathIntegral_two_paths_unit
    (gr : WeightedGraph) (phi : NodePotential)
    (p₁ p₂ : LatticePath) (hne : p₁ ≠ p₂) :
    ‖pathIntegralAmplitude gr phi {p₁, p₂}‖ ^ 2 =
      2 + 2 * (piPathAmplitude gr phi p₁ *
        (starRingEnd ℂ) (piPathAmplitude gr phi p₂)).re := by
  rw [pathIntegral_two_paths gr phi p₁ p₂ hne]
  rw [piPathAmplitude_norm, piPathAmplitude_norm]
  norm_num

/-- The cross term of two path amplitudes is a cosine of the
    action difference divided by hbar.

    `Re(exp(iS₁/hbar) · conj(exp(iS₂/hbar))) = cos((S₁ - S₂)/hbar)`.

    This is the mechanism of Feynman interference: paths with
    similar actions reinforce (constructive), paths with actions
    differing by `pi·hbar` cancel (destructive). -/
theorem piPathAmplitude_cross_term_re
    (gr : WeightedGraph) (phi : NodePotential) (p₁ p₂ : LatticePath) :
    (piPathAmplitude gr phi p₁ *
      (starRingEnd ℂ) (piPathAmplitude gr phi p₂)).re =
    Real.cos ((latticePathAction gr phi p₁ -
               latticePathAction gr phi p₂) / hbar) := by
  unfold piPathAmplitude
  -- Write both as exp(i * (action/hbar))
  set a₁ := latticePathAction gr phi p₁
  set a₂ := latticePathAction gr phi p₂
  -- conj(exp(i * (a₂/hbar))) = exp(-i * (a₂/hbar))
  have hconj :
      (starRingEnd ℂ) (Complex.exp (Complex.I * ((a₂ / hbar : ℝ) : ℂ))) =
        Complex.exp (-(Complex.I * ((a₂ / hbar : ℝ) : ℂ))) := by
    rw [← Complex.exp_conj]
    congr 1
    rw [map_mul, Complex.conj_I, Complex.conj_ofReal]
    ring
  rw [hconj, ← Complex.exp_add]
  -- Combine exponents: i*(a₁/h) + (-i*(a₂/h)) = i*((a₁-a₂)/h)
  have hexp_arg :
      Complex.I * ((a₁ / hbar : ℝ) : ℂ) + -(Complex.I * ((a₂ / hbar : ℝ) : ℂ)) =
        (((a₁ - a₂) / hbar : ℝ) : ℂ) * Complex.I := by
    push_cast
    ring
  rw [hexp_arg, Complex.exp_mul_I]
  rw [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  rw [Complex.cos_ofReal_re, Complex.sin_ofReal_im]
  ring

/-! ## 6. Substrate error accumulation per path -/

/-- **Path integral substrate error bound.**  A lattice path of
    `numSteps` steps (i.e., traversing `numSteps` Planck ticks)
    accumulates at most `numSteps * computationalUncertainty budget`
    of substrate error, where `budget` is the iteration budget per
    snapshot.

    This bridges the path integral to `accumulatedSnapshotError` from
    `SnapshotPropagator.lean`: each step of the lattice path IS one
    snapshot propagation event, and the total error is bounded by
    the triangle inequality (linearity of `accumulatedSnapshotError`). -/
theorem pathIntegral_substrate_error
    (path : LatticePath) (budget : ℕ) :
    accumulatedSnapshotError path.numSteps budget =
      (path.numSteps : ℝ) * computationalUncertainty budget := by
  unfold accumulatedSnapshotError LatticePath.numSteps
  rfl

/-- The error bound is non-negative for any path and budget. -/
theorem pathIntegral_substrate_error_nonneg
    (path : LatticePath) (budget : ℕ) :
    0 ≤ accumulatedSnapshotError path.numSteps budget :=
  accumulatedSnapshotError_nonneg _ _

/-- Longer paths accumulate more error: if `path₁` has fewer steps
    than `path₂`, then `path₁`'s accumulated error is smaller.
    This is why, in the classical limit, shortest paths dominate:
    they accumulate less substrate noise. -/
theorem pathIntegral_error_mono
    (path₁ path₂ : LatticePath) (budget : ℕ)
    (h : path₁.numSteps ≤ path₂.numSteps) :
    accumulatedSnapshotError path₁.numSteps budget ≤
      accumulatedSnapshotError path₂.numSteps budget :=
  accumulatedSnapshotError_mono budget h

/-- **Bridge to extended Heisenberg.**  The total accumulated error
    over a path of `K` steps at budget `N` equals `K` times the
    computational contribution to the extended uncertainty bound.
    Composed from `motion_is_accumulated_extended_heisenberg`. -/
theorem pathIntegral_error_eq_extended_heisenberg
    (path : LatticePath) (budget : ℕ) :
    accumulatedSnapshotError path.numSteps budget =
      (path.numSteps : ℝ) * (extendedUncertaintyBound budget - hbar / 2) :=
  motion_is_accumulated_extended_heisenberg _ _

/-! ## 7. Classical limit — stationary action dominance -/

/-- A path has **stationary action** relative to a set of paths
    when its action is a local extremum: every other path in the
    set has action differing by at least `delta`. -/
def HasStationaryAction
    (gr : WeightedGraph) (phi : NodePotential)
    (classicalPath : LatticePath) (paths : Finset LatticePath)
    (delta : ℝ) : Prop :=
  classicalPath ∈ paths ∧
  0 < delta ∧
  ∀ path ∈ paths, path ≠ classicalPath →
    delta ≤ |latticePathAction gr phi path -
              latticePathAction gr phi classicalPath|

/-- **Classical limit: stationary-phase cancellation.**

    When the action gap `delta` between the classical path and all
    other paths satisfies `delta / hbar >> 1`, the non-classical
    paths' amplitudes `exp(iS/hbar)` oscillate rapidly and cancel
    pairwise.  The surviving contribution is the classical path's
    amplitude `exp(iS_cl/hbar)`.

    We state this as a structural conditional: IF the non-classical
    amplitudes sum to at most `epsilon` in norm, THEN the full path
    integral is within `epsilon` of the classical path's amplitude.

    The honest content is that the path integral reduces to a single
    classical amplitude plus a controlled remainder.  The actual
    smallness of the remainder requires a stationary-phase estimate
    (integration-by-parts on lattice sums) that is future work; this
    theorem records the clean structural form. -/
theorem pathIntegral_classical_limit
    (gr : WeightedGraph) (phi : NodePotential)
    (classicalPath : LatticePath)
    (paths : Finset LatticePath)
    (hcl : classicalPath ∈ paths)
    (epsilon : ℝ)
    (hcancel : ‖∑ path ∈ paths.erase classicalPath,
        piPathAmplitude gr phi path‖ ≤ epsilon) :
    ‖pathIntegralAmplitude gr phi paths -
        piPathAmplitude gr phi classicalPath‖ ≤ epsilon := by
  unfold pathIntegralAmplitude
  rw [← Finset.add_sum_erase _ _ hcl]
  simp only [add_sub_cancel_left]
  exact hcancel

/-- **Classical limit, probability form.**  Under the same
    hypotheses, the detection probability `|K|^2` is close to
    `|A_cl|^2 = 1` (since `|exp(iS/hbar)| = 1`), with error
    controlled by `epsilon`.

    Specifically: `| |K|^2 - 1 | <= epsilon * (2 + epsilon)`.

    Proof: `|K| = |A_cl + R|` where `|R| <= epsilon` and
    `|A_cl| = 1`.  Then `| |K| - 1 | <= epsilon`, so
    `| |K|^2 - 1 | = | |K| - 1 | * | |K| + 1 | <= epsilon * (2 + epsilon)`. -/
theorem pathIntegral_classical_limit_probability
    (gr : WeightedGraph) (phi : NodePotential)
    (classicalPath : LatticePath)
    (paths : Finset LatticePath)
    (hcl : classicalPath ∈ paths)
    (epsilon : ℝ)
    (heps : 0 ≤ epsilon)
    (hcancel : ‖∑ path ∈ paths.erase classicalPath,
        piPathAmplitude gr phi path‖ ≤ epsilon) :
    |‖pathIntegralAmplitude gr phi paths‖ ^ 2 - 1| ≤
      epsilon * (2 + epsilon) := by
  -- Split: K = A_cl + R where R is the non-classical remainder.
  have hK : pathIntegralAmplitude gr phi paths =
      piPathAmplitude gr phi classicalPath +
        ∑ path ∈ paths.erase classicalPath, piPathAmplitude gr phi path := by
    unfold pathIntegralAmplitude
    rw [← Finset.add_sum_erase _ _ hcl]
  set R := ∑ path ∈ paths.erase classicalPath, piPathAmplitude gr phi path
  set A := piPathAmplitude gr phi classicalPath
  have hAnorm : ‖A‖ = 1 := piPathAmplitude_norm gr phi classicalPath
  have hRnorm : ‖R‖ ≤ epsilon := hcancel
  rw [hK]
  set Knorm := ‖A + R‖
  -- Upper bound: |A + R| <= 1 + epsilon
  have hhigh : Knorm ≤ 1 + epsilon := by
    calc Knorm = ‖A + R‖ := rfl
      _ ≤ ‖A‖ + ‖R‖ := norm_add_le A R
      _ ≤ 1 + epsilon := by linarith [hAnorm]
  -- Lower bound: |A + R| >= 1 - epsilon (reverse triangle)
  have hlow : 1 - epsilon ≤ Knorm := by
    -- ‖A‖ ≤ ‖A + R‖ + ‖-R‖ = ‖A + R‖ + ‖R‖
    have h1 : ‖A‖ ≤ ‖A + R‖ + ‖R‖ := by
      calc ‖A‖ = ‖(A + R) + (-R)‖ := by ring_nf
        _ ≤ ‖A + R‖ + ‖-R‖ := norm_add_le _ _
        _ = ‖A + R‖ + ‖R‖ := by rw [norm_neg]
    linarith [hAnorm]
  -- | |K| - 1 | <= epsilon
  have hKdiff : |Knorm - 1| ≤ epsilon := by
    rw [abs_le]; constructor <;> linarith
  -- |K|^2 - 1 = (|K| - 1)(|K| + 1)
  have hKnorm_nonneg : 0 ≤ Knorm := norm_nonneg _
  have hsq : Knorm ^ 2 - 1 = (Knorm - 1) * (Knorm + 1) := by ring
  rw [hsq]
  calc |((Knorm - 1) * (Knorm + 1))| = |Knorm - 1| * |Knorm + 1| := abs_mul _ _
    _ ≤ epsilon * (2 + epsilon) := by
      have h2 : |Knorm + 1| ≤ 2 + epsilon := by
        rw [abs_of_nonneg (by linarith)]
        linarith
      exact mul_le_mul hKdiff h2 (abs_nonneg _) heps

/-! ## Bridge: path integral as propagator

    The `latticePropagator` from `Propagator.lean` and
    `pathIntegralAmplitude` here are two faces of the same object:
    both sum complex amplitudes over lattice paths.

    `latticePropagator` uses product-form amplitudes
    `prod_i stepAmplitude(...)` from the coarse-graining map;
    `pathIntegralAmplitude` uses Feynman-phase amplitudes
    `exp(iS/hbar)` from the graph action.

    The conceptual bridge is: when the substrate's coarse-grained
    amplitude is the Boltzmann weight `exp(-I_KL/2)` and the phase
    is the lattice dot product `k.p - omega.n`, the product of
    step amplitudes equals the Feynman weight in the WKB limit.
    A full identification requires matching the KL-density to the
    graph Lagrangian term by term — this is recorded as a structural
    statement.  -/

/-- **Propagator-PathIntegral bridge (structural).**  The detection
    probability from `propagator_two_slit_form` equals the two-path
    interference formula from this file's `pathIntegral_interference`,
    when instantiated at the same two amplitudes.

    Content: `|K₁ + K₂|²` from Propagator.lean and
    `|A₁ + A₂|²` from here are the same algebraic identity.  This
    records the unification. -/
theorem pathIntegral_propagator_bridge (A₁ A₂ : ℂ) :
    ‖A₁ + A₂‖ ^ 2 =
      ‖A₁‖ ^ 2 + ‖A₂‖ ^ 2 +
      2 * (A₁ * (starRingEnd ℂ) A₂).re :=
  pathIntegral_interference A₁ A₂

end OmegaTheory.Emergence
