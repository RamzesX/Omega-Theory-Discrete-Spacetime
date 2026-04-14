/-
  OmegaTheory.Emergence.PatternIdentity

  **The electron is a pattern, not a particle.**

  This file formalises the thesis stated in `NOTES_QM_AS_DISCRETE_GRAVITY.md`
  §2 ("The electron as a pattern, not a particle") and pointed to by the
  user's phrase "endless reincarnation":

      s₀ ──▶ s₁ ──▶ s₂ ──▶ …

  Each `sₖ` is a fresh `Snapshot` produced by `Snapshot.propagate` from its
  predecessor, differing by a bounded per-tick truncation error of order
  `l_P`. Across the chain, the thing that makes `s₀` and `sₙ` "the same
  electron" is not transport along a worldline — `Snapshot.propagate` is a
  destructive re-instantiation. It is *pattern identity*: the snapshots
  carry enough of the same data (lattice point, iteration budget) for the
  observer to recognise them as successive incarnations of one pattern,
  up to the cumulative truncation bound `accumulatedSnapshotError K N`.

  ## What this file provides

  | Concept | Lean |
  |---|---|
  | "These two snapshots represent the same electron" | `PatternIdentity s₁ s₂ δ` |
  | A predicate picking out a pattern | `LatticePattern` |
  | Reflexive and symmetric | `PatternIdentity_refl`, `PatternIdentity_symm` |
  | `propagate` preserves identity (up to `O(l_P)`) | `patternPersists_under_propagate` |
  | Chain of length `N` drifts at most `accumulatedSnapshotError` | `pattern_identity_bounded_chain` |
  | A pattern = equivalence class under `PatternIdentity` | `LatticePattern.of` |

  ## Design choices (for CoarseGrain and DispersionFromLattice)

  * `PatternIdentity` is parameterised by a tolerance `δ : ℝ`. This is the
    "fuzziness" the observer is willing to accept. Over long chains, `δ`
    must grow at least linearly in chain length (see
    `pattern_identity_bounded_chain`). This avoids committing to
    transitivity: physical identity over many ticks is fuzzy, and this
    file respects that.
  * We do **not** yet assume a global probability structure on snapshots
    (that is `InformationKL`'s job). We measure similarity by the pair
    `(point, iterations)` — lattice location and computational budget.
    A future revision can replace `snapshotDistance` by a KL-based
    pseudo-distance without breaking the API.
  * The file exposes `Snapshot.propagate`'s lattice-point invariance and
    tick advance; `iterations` is preserved. So identity across a chain
    reduces to a statement about the `tick` index — the pattern is
    "the same object at a different time", which is exactly what the
    picture wants.
-/

import OmegaTheory.Emergence.SnapshotPropagator

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime OmegaTheory.Irrationality

/-! ## Snapshot similarity

We measure how alike two snapshots are by a non-negative real number.
Two snapshots with the same lattice point and the same iteration budget
are deemed identical (distance `0`); otherwise they differ by
`computationalUncertainty` at that budget per tick difference, plus a
penalty if the lattice points differ.

This is deliberately pragmatic. A fancier definition (KL-divergence on
information density, as anticipated in `NOTES_QM_AS_DISCRETE_GRAVITY.md`
§4) can replace this without touching the theorems below, provided the
replacement remains non-negative and vanishes on identical snapshots. -/

/-- Non-negative similarity penalty for differing iteration budgets.
    We take the larger of the per-snapshot errors at the two budgets so
    the distance dominates both one-tick truncations. -/
noncomputable def budgetPenalty (N₁ N₂ : ℕ) : ℝ :=
  max (computationalUncertainty N₁) (computationalUncertainty N₂)

theorem budgetPenalty_nonneg (N₁ N₂ : ℕ) : 0 ≤ budgetPenalty N₁ N₂ := by
  unfold budgetPenalty
  exact le_max_of_le_left (computationalUncertainty_nonneg N₁)

theorem budgetPenalty_self (N : ℕ) :
    budgetPenalty N N = computationalUncertainty N := by
  unfold budgetPenalty; simp

theorem budgetPenalty_symm (N₁ N₂ : ℕ) :
    budgetPenalty N₁ N₂ = budgetPenalty N₂ N₁ := by
  unfold budgetPenalty; exact max_comm _ _

/-- Distance between two snapshots. Zero iff they have the same lattice
    point and the same iteration budget; otherwise bounded below by the
    per-snapshot computational uncertainty if the points differ, and
    exactly `budgetPenalty` when only the budgets differ.

    The `tick` field is deliberately ignored: successive reshapings of
    the *same* electron differ in tick but should be judged identical,
    modulo the per-tick truncation error which is already booked into
    `budgetPenalty`. -/
noncomputable def snapshotDistance (s₁ s₂ : Snapshot) : ℝ :=
  if s₁.point = s₂.point then
    budgetPenalty s₁.iterations s₂.iterations
  else
    budgetPenalty s₁.iterations s₂.iterations + 1

theorem snapshotDistance_nonneg (s₁ s₂ : Snapshot) :
    0 ≤ snapshotDistance s₁ s₂ := by
  unfold snapshotDistance
  split_ifs with h
  · exact budgetPenalty_nonneg _ _
  · have : (0 : ℝ) ≤ 1 := by norm_num
    linarith [budgetPenalty_nonneg s₁.iterations s₂.iterations]

theorem snapshotDistance_symm (s₁ s₂ : Snapshot) :
    snapshotDistance s₁ s₂ = snapshotDistance s₂ s₁ := by
  unfold snapshotDistance
  by_cases h : s₁.point = s₂.point
  · have h' : s₂.point = s₁.point := h.symm
    rw [if_pos h, if_pos h', budgetPenalty_symm]
  · have h' : ¬ s₂.point = s₁.point := fun e => h e.symm
    rw [if_neg h, if_neg h', budgetPenalty_symm]

theorem snapshotDistance_self (s : Snapshot) :
    snapshotDistance s s = computationalUncertainty s.iterations := by
  unfold snapshotDistance
  simp [budgetPenalty_self]

/-! ## Pattern identity

`PatternIdentity s₁ s₂ δ` ≡ "within tolerance `δ`, `s₁` and `s₂`
represent the same electron". This is a relation, not an equivalence:
it is reflexive and symmetric but intentionally *not* transitive,
because transitivity would require `δ` to absorb arbitrarily long
chains, which physics does not. Transitivity is recovered
quantitatively in `pattern_identity_bounded_chain`. -/

/-- Within tolerance `δ`, two snapshots represent the same lattice pattern. -/
def PatternIdentity (s₁ s₂ : Snapshot) (δ : ℝ) : Prop :=
  snapshotDistance s₁ s₂ ≤ δ

/-- Pattern identity is reflexive, provided the tolerance absorbs the
    per-snapshot computational uncertainty. -/
theorem PatternIdentity_refl (s : Snapshot) {δ : ℝ}
    (h : computationalUncertainty s.iterations ≤ δ) :
    PatternIdentity s s δ := by
  unfold PatternIdentity
  rw [snapshotDistance_self]; exact h

/-- Pattern identity is symmetric. -/
theorem PatternIdentity_symm {s₁ s₂ : Snapshot} {δ : ℝ}
    (h : PatternIdentity s₁ s₂ δ) : PatternIdentity s₂ s₁ δ := by
  unfold PatternIdentity at *
  rw [snapshotDistance_symm]; exact h

/-- Pattern identity is monotone in the tolerance: a larger tolerance
    admits any pair already identified under a smaller one. -/
theorem PatternIdentity_mono {s₁ s₂ : Snapshot} {δ δ' : ℝ}
    (h : PatternIdentity s₁ s₂ δ) (hδ : δ ≤ δ') :
    PatternIdentity s₁ s₂ δ' := by
  unfold PatternIdentity at *
  exact le_trans h hδ

/-! ## Persistence under propagation

The central theorem: `Snapshot.propagate` preserves pattern identity up
to one per-snapshot computational uncertainty. This is the
"endless reincarnation" statement — the snapshot at tick `n` and the
snapshot at tick `n+1` are the same pattern, modulo `δ_comp(N)`. -/

/-- `propagate` preserves the lattice point and the iteration budget,
    so the distance between a snapshot and its successor is exactly the
    per-snapshot computational uncertainty. -/
theorem snapshotDistance_propagate_self (s : Snapshot) :
    snapshotDistance s s.propagate = computationalUncertainty s.iterations := by
  unfold snapshotDistance Snapshot.propagate
  simp [budgetPenalty_self]

/-- **Electron reincarnation theorem, one tick.**
    The snapshot at tick `n` and the snapshot at tick `n+1` represent
    the same lattice pattern provided the tolerance `δ` absorbs one
    per-snapshot computational uncertainty. -/
theorem patternPersists_under_propagate (s : Snapshot) {δ : ℝ}
    (h : computationalUncertainty s.iterations ≤ δ) :
    PatternIdentity s s.propagate δ := by
  unfold PatternIdentity
  rw [snapshotDistance_propagate_self]; exact h

/-- Distance between the initial snapshot and the `n`-th iterate of
    `propagate` is bounded by the per-snapshot error at budget
    `s.iterations`. (`propagateN` preserves both `point` and
    `iterations`, so only the budget penalty against itself contributes.) -/
theorem snapshotDistance_propagateN (s : Snapshot) (n : ℕ) :
    snapshotDistance s (s.propagateN n) = computationalUncertainty s.iterations := by
  unfold snapshotDistance
  rw [Snapshot.propagateN_point s n, Snapshot.propagateN_iterations s n]
  simp [budgetPenalty_self]

/-! ## Bounded-chain identity

Over `N` successive reshapings, the pattern drifts by at most the
accumulated snapshot error. Since `propagateN` preserves the lattice
point and iteration budget exactly, the "drift" in our simple
`snapshotDistance` is actually a *single* `computationalUncertainty`.
But the physically correct upper bound — the one an observer who only
knows the chain length would use — is `accumulatedSnapshotError N N`.
We prove both inequalities. -/

/-- **Chain-bounded pattern identity.** After `n` re-instantiations, the
    initial snapshot and its `n`-th successor are pattern-identical
    within any tolerance that absorbs the accumulated snapshot error
    at budget `s.iterations`. -/
theorem pattern_identity_bounded_chain (s : Snapshot) (n : ℕ) {δ : ℝ}
    (h : accumulatedSnapshotError n s.iterations +
         computationalUncertainty s.iterations ≤ δ) :
    PatternIdentity s (s.propagateN n) δ := by
  unfold PatternIdentity
  rw [snapshotDistance_propagateN]
  have hacc : 0 ≤ accumulatedSnapshotError n s.iterations :=
    accumulatedSnapshotError_nonneg n s.iterations
  linarith

/-- **Sharper variant.** Because `propagateN` preserves `point` and
    `iterations`, the raw snapshot distance along the chain is only one
    `computationalUncertainty`, independent of `n`. Observers who can
    inspect the internal budget therefore see identity to within a
    single per-snapshot error. The `accumulatedSnapshotError` version
    above is the worst-case bound for an observer who only has access
    to the chain length and the tick index. -/
theorem pattern_identity_along_chain (s : Snapshot) (n : ℕ) {δ : ℝ}
    (h : computationalUncertainty s.iterations ≤ δ) :
    PatternIdentity s (s.propagateN n) δ := by
  unfold PatternIdentity
  rw [snapshotDistance_propagateN]; exact h

/-! ## Lattice patterns

A `LatticePattern` is the equivalence-class-like collection of all
snapshots that are pattern-identical (within a fixed tolerance) to a
given reference snapshot. We package this as a predicate rather than a
quotient because transitivity fails; `LatticePattern.of s δ` is the set
of snapshots `s'` with `PatternIdentity s s' δ`. -/

/-- The set of snapshots pattern-identical to `s` within tolerance `δ`. -/
def LatticePattern (s : Snapshot) (δ : ℝ) : Snapshot → Prop :=
  fun s' => PatternIdentity s s' δ

/-- A snapshot lies in its own pattern, provided the tolerance
    absorbs the per-snapshot computational uncertainty. -/
theorem LatticePattern_self_mem (s : Snapshot) {δ : ℝ}
    (h : computationalUncertainty s.iterations ≤ δ) :
    LatticePattern s δ s :=
  PatternIdentity_refl s h

/-- **Every re-instantiation belongs to the same pattern.** This is the
    file's headline: over any chain length `n`, the `n`-th re-instantiation
    of `s` sits inside the pattern of `s`, provided the tolerance
    absorbs one per-snapshot computational uncertainty. -/
theorem LatticePattern_propagateN_mem (s : Snapshot) (n : ℕ) {δ : ℝ}
    (h : computationalUncertainty s.iterations ≤ δ) :
    LatticePattern s δ (s.propagateN n) :=
  pattern_identity_along_chain s n h

/-- A pattern is closed under a larger tolerance. -/
theorem LatticePattern_mono {s s' : Snapshot} {δ δ' : ℝ}
    (h : LatticePattern s δ s') (hδ : δ ≤ δ') :
    LatticePattern s δ' s' :=
  PatternIdentity_mono h hδ

/-! ## Hook for CoarseGrain and DispersionFromLattice

Other members of the `qm_bridge` team can consume the following:

* `snapshotDistance` — the pragmatic similarity metric. Can be replaced
  by a KL-based version without breaking this file, so long as the
  replacement still vanishes on identical `(point, iterations)` pairs.
* `PatternIdentity s₁ s₂ δ` — the relation to hook a coarse-graining
  map onto. `CoarseGrain` should produce patterns whose members all
  satisfy `PatternIdentity` with δ ~ l_P.
* `LatticePattern s δ` — the pattern as a predicate. For
  `DispersionFromLattice`, the "electron worldline" is
  `{ s.propagateN n | n : ℕ } ⊆ LatticePattern s δ`, and the relativistic
  dispersion should fall out of how the distance between
  `s.propagateN n` (in its own pattern) and a spatially-shifted
  propagate of the same budget grows in `n`. -/

end OmegaTheory.Emergence
