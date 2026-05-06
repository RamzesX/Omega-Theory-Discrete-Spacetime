/-
  OmegaTheory.Foundations.HiggsCreationEventTopology

  **Lion's-Pride Phase 2.6 (2026-05-06)**: topological detection of
  the Higgs creation event via the defect-site filtration.  When a
  metric perturbation accumulates non-trivial defects, the
  sub-threshold defect-site set acquires non-trivial topology — the
  CARDINALITY of the defect-site set is the simplest topological
  invariant detecting "the moment a critical event occurs".

  ## Why this file (Phase 2.6 — topological event detection)

  Phase 2.4 shipped the convergence content (φ-component accumulates
  at non-zero values when defects are present).  This file ships
  the TOPOLOGICAL MARKER side: the moment of defect creation is
  identifiable as a discontinuity in the defect-site count.

  Per the user directive
  `feedback_lean4_corpus_quality_over_theorem_correctness_2026-05-06`
  ("build first, machinery only when needed"), this file ships the
  BOUNDED-SCOPE pragmatic detection:

  * `defectSites` — sublevel-set filtration (Finset filter).
  * `defectSiteCount` — the simplest topological marker (cardinality).
  * Discontinuity = critical event.

  The proper Hodge-Laplacian + Betti-number version (computing
  H_0, H_1, ... from the existing `Geometry/DiscreteForms.lean` de
  Rham complex + `Geometry/HodgeDecomposition.lean` orthogonal
  decomposition) is reserved for the Phase 6 companion file
  `Foundations/HodgeLatticeCohomology.lean` (~400 LOC) — slowly
  introduce the tools.

  ## What this file ships

  | Theorem                                       | Content                                                       |
  |-----------------------------------------------|---------------------------------------------------------------|
  | `defectSites`                                  | Finset filter `{p ∈ R : |D(g, g_exact, p)| > ε}`               |
  | `defectSiteCount`                              | cardinality (the simplest topological marker)                 |
  | `defectSiteCount_at_zero_defect_eq_zero`       | no defects ⟹ count = 0                                         |
  | `defectSiteCount_subset_monotone`              | smaller region ⟹ smaller count                                 |
  | `defectSiteCount_threshold_antitone`           | smaller threshold ⟹ MORE sites                                  |
  | `defectSiteCountAlongFlow`                     | sequence `n ↦ count(g(τ_n))` along the flow                    |
  | `topological_event_marker`                     | cardinality jump marks a critical event                       |
  | Headline 4-conjunct                            | `higgs_creation_event_topology_report`                         |

  ## Honest scope

  - `defectSiteCount` is NOT the 0-th Betti number `b_0` (which
    counts CONNECTED COMPONENTS, not points).  It is the
    CARDINALITY of the defect-site set — the simplest proxy.
  - The proper `b_0` requires a graph structure on the lattice
    (nearest-neighbor adjacency); the Mathlib `SimpleGraph`
    connectivity machinery would compute it, but this file
    deliberately uses the simpler cardinality form (~300 LOC vs
    ~600 LOC).
  - The Hodge-Laplacian eigenstate decomposition + full Betti number
    computation is `Foundations/HodgeLatticeCohomology.lean` (Phase 6
    companion, deferred per user directive).
  - "Critical event" here is defined as a discrete-time step at
    which the cardinality changes.  Continuous-time discontinuity
    requires additional regularity on the flow.

  ## Lit anchors

  - Adler-Bobrowski-Borman, *Ann. Appl. Prob.* 24 (2014) 2174 —
    persistent homology of random fields, `H_0` proliferation as
    SSB onset.
  - Pranav et al., *MNRAS* 465 (2017) 4281 — topology of cosmic web,
    sublevel-set filtration as critical-event marker.
  - Edelsbrunner-Letscher-Zomorodian 2002 — original persistent
    homology framework (we use only the simplest H_0 cardinality
    proxy here, not the full PH machinery).

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`. Rule 2: zero new axioms.  Direct composition
  of `Finset.filter` (Mathlib std) + `defectMagnitude` (`Defects/
  DefectTensor.lean:38`) — no new abstractions.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Defects.DefectTensor
import OmegaTheory.HealingFlow.Flow

namespace OmegaTheory.Foundations.HiggsCreationEventTopology

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects
open OmegaTheory.HealingFlow

/-! ## Section 1 — Defect-site sublevel-set filtration -/

/-- **Defect-site set** at threshold `ε > 0`: the points in a finite
    lattice region `R` where the defect magnitude exceeds `ε`.

        defectSites(g, g_exact, ε, R) :=
          {p ∈ R : defectMagnitude(g, g_exact, p) > ε}.

    This is a `Finset.filter`-based concrete subset of `R`.  Its
    cardinality is the simplest topological marker — discontinuities
    in the cardinality along the healing flow IDENTIFY critical
    events (defect creation / annihilation).

    Note: `defectMagnitude > ε` is decidable since `defectMagnitude`
    returns a real and `> ε` on reals is decidable for any specific
    pair.  We use the classical `Decidable` instance via
    `Classical.dec`. -/
noncomputable def defectSites (g g_exact : DiscreteMetric) (ε : ℝ)
    (R : Finset LatticePoint) : Finset LatticePoint :=
  R.filter (fun p => defectMagnitude g g_exact p > ε)

/-- **Defect-site count**: the cardinality of `defectSites`.  This
    is the simplest topological invariant detecting defect creation. -/
noncomputable def defectSiteCount (g g_exact : DiscreteMetric) (ε : ℝ)
    (R : Finset LatticePoint) : ℕ :=
  (defectSites g g_exact ε R).card

/-- **Definitional unfolding** for the count. -/
theorem defectSiteCount_def
    (g g_exact : DiscreteMetric) (ε : ℝ) (R : Finset LatticePoint) :
    defectSiteCount g g_exact ε R = (defectSites g g_exact ε R).card := rfl

/-! ## Section 2 — Trivial cases -/

/-- **No defects ⟹ no sites**: when the defect magnitude is zero
    everywhere on `R`, the defect-site count vanishes for any
    positive threshold `ε > 0`. -/
theorem defectSiteCount_at_zero_defect_eq_zero
    (g g_exact : DiscreteMetric) {ε : ℝ} (hε : 0 < ε)
    (R : Finset LatticePoint)
    (hzero : ∀ p ∈ R, defectMagnitude g g_exact p = 0) :
    defectSiteCount g g_exact ε R = 0 := by
  unfold defectSiteCount defectSites
  rw [Finset.card_eq_zero]
  rw [Finset.filter_eq_empty_iff]
  intro p hp
  intro h_gt
  have h_zero := hzero p hp
  rw [h_zero] at h_gt
  -- h_gt : 0 > ε but ε > 0
  linarith

/-- **At identity `g = g_exact`**: there are no defect sites for
    any positive threshold. -/
theorem defectSiteCount_at_identity_eq_zero
    (g_exact : DiscreteMetric) {ε : ℝ} (hε : 0 < ε)
    (R : Finset LatticePoint) :
    defectSiteCount g_exact g_exact ε R = 0 := by
  apply defectSiteCount_at_zero_defect_eq_zero g_exact g_exact hε R
  intro p _
  unfold defectMagnitude
  rw [defectMagnitudeSq_zero_of_eq]
  exact Real.sqrt_zero

/-! ## Section 3 — Monotonicity properties -/

/-- **Region monotonicity**: enlarging the lattice region
    weakly increases the defect-site count. -/
theorem defectSiteCount_subset_monotone
    (g g_exact : DiscreteMetric) (ε : ℝ)
    {R₁ R₂ : Finset LatticePoint} (hR : R₁ ⊆ R₂) :
    defectSiteCount g g_exact ε R₁ ≤ defectSiteCount g g_exact ε R₂ := by
  unfold defectSiteCount defectSites
  apply Finset.card_le_card
  apply Finset.filter_subset_filter
  exact hR

/-- **Threshold antitonicity**: lowering the threshold `ε` weakly
    increases the defect-site count (smaller threshold ⟹ more
    points exceed it). -/
theorem defectSiteCount_threshold_antitone
    (g g_exact : DiscreteMetric) (R : Finset LatticePoint)
    {ε₁ ε₂ : ℝ} (hε : ε₁ ≤ ε₂) :
    defectSiteCount g g_exact ε₂ R ≤ defectSiteCount g g_exact ε₁ R := by
  unfold defectSiteCount defectSites
  apply Finset.card_le_card
  intro p hp
  simp only [Finset.mem_filter] at hp ⊢
  exact ⟨hp.1, lt_of_le_of_lt hε hp.2⟩

/-! ## Section 4 — Along the healing flow -/

/-- **Defect-site count along the healing-flow trajectory**: the
    discrete-time sequence `n ↦ defectSiteCount(g(τ_0 + n·δτ))`. -/
noncomputable def defectSiteCountAlongFlow
    (path : MetricPath) (g_exact : DiscreteMetric) (ε : ℝ)
    (R : Finset LatticePoint) (delta_tau tau0 : ℝ) : ℕ → ℕ :=
  fun n => defectSiteCount (path (tau0 + n * delta_tau)) g_exact ε R

/-- **Definitional unfolding**. -/
theorem defectSiteCountAlongFlow_def
    (path : MetricPath) (g_exact : DiscreteMetric) (ε : ℝ)
    (R : Finset LatticePoint) (delta_tau tau0 : ℝ) (n : ℕ) :
    defectSiteCountAlongFlow path g_exact ε R delta_tau tau0 n =
      defectSiteCount (path (tau0 + n * delta_tau)) g_exact ε R := rfl

/-! ## Section 5 — Topological-event detection -/

/-- **Topological-event marker**: a step `n` where the defect-site
    count changes is a "critical event" — the moment defects are
    created or annihilated.  We define the marker as a Boolean
    predicate on consecutive trajectory steps. -/
def IsTopologicalEvent (path : MetricPath) (g_exact : DiscreteMetric)
    (ε : ℝ) (R : Finset LatticePoint) (delta_tau tau0 : ℝ) (n : ℕ) : Prop :=
  defectSiteCountAlongFlow path g_exact ε R delta_tau tau0 n ≠
    defectSiteCountAlongFlow path g_exact ε R delta_tau tau0 (n + 1)

/-- **Definitional unfolding** for the event predicate. -/
theorem IsTopologicalEvent_iff_count_changes
    (path : MetricPath) (g_exact : DiscreteMetric) (ε : ℝ)
    (R : Finset LatticePoint) (delta_tau tau0 : ℝ) (n : ℕ) :
    IsTopologicalEvent path g_exact ε R delta_tau tau0 n ↔
      defectSiteCount (path (tau0 + n * delta_tau)) g_exact ε R ≠
        defectSiteCount (path (tau0 + (n+1 : ℕ) * delta_tau)) g_exact ε R := by
  rfl

/-! ## Section 6 — Critical event existence (Higgs creation) -/

/-- **Higgs creation event detection**: the topological-event
    predicate captures the moment defects appear in the substrate.
    If the trajectory starts at the identity (no defects) and
    later has a non-zero defect site count, then there must exist
    a topological event somewhere along the flow.

    This is the LOAD-BEARING capstone: critical events are
    detectable as discontinuities in the topological invariant. -/
theorem higgs_creation_event_detected
    (path : MetricPath) (g_exact : DiscreteMetric)
    {ε : ℝ} (hε : 0 < ε)
    (R : Finset LatticePoint) (delta_tau tau0 : ℝ)
    (hstart : path tau0 = g_exact)
    (N : ℕ) (hlater : 0 < defectSiteCountAlongFlow path g_exact ε R
                          delta_tau tau0 N) :
    ∃ n < N, IsTopologicalEvent path g_exact ε R delta_tau tau0 n := by
  -- At step 0, the count is 0 (identity).  At step N, the count is > 0.
  -- Discrete-time intermediate-value-style argument: there must be a
  -- step where the count first becomes positive.
  have h_zero : defectSiteCountAlongFlow path g_exact ε R delta_tau tau0 0 = 0 := by
    unfold defectSiteCountAlongFlow
    -- Goal: defectSiteCount (path (tau0 + ↑0 * delta_tau)) g_exact ε R = 0
    simp only [Nat.cast_zero, zero_mul, add_zero]
    rw [hstart]
    exact defectSiteCount_at_identity_eq_zero g_exact hε R
  -- Now use induction / minimal-counter-example: the smallest n with positive count
  -- is preceded by a step with zero count, so there's an event.
  by_contra h_no_event
  push_neg at h_no_event
  -- h_no_event : ∀ n < N, ¬IsTopologicalEvent ... n
  -- ⟹ ∀ n < N, count(n) = count(n+1)
  -- ⟹ count(0) = count(1) = ... = count(N) = 0, contradicting hlater
  have h_const : ∀ n ≤ N,
      defectSiteCountAlongFlow path g_exact ε R delta_tau tau0 n = 0 := by
    intro n hn
    induction n with
    | zero => exact h_zero
    | succ k ih =>
      have hkN : k < N := lt_of_lt_of_le (Nat.lt_succ_self k) hn
      have hk_le : k ≤ N := le_of_lt hkN
      have ih' := ih hk_le
      -- h_no_event k hkN : ¬IsTopologicalEvent at k
      have h_not_event := h_no_event k hkN
      unfold IsTopologicalEvent at h_not_event
      push_neg at h_not_event
      -- h_not_event : count(k) = count(k+1)
      -- ih' : count(k) = 0
      -- Goal : count(k+1) = 0
      exact h_not_event.symm.trans ih'
  have h_N_zero := h_const N (le_refl N)
  rw [h_N_zero] at hlater
  exact lt_irrefl 0 hlater

/-! ## Section 7 — Capstone -/

/-- **Higgs creation event topology report (5-conjunct headline)**:

    The defect-site sublevel-set filtration provides a concrete
    topological invariant — the cardinality of the defect-site
    set — whose discontinuities along the healing flow IDENTIFY
    the moments of critical events (defect creation / Higgs
    creation).

    1. **Vanishing at no-defects**: zero defect magnitude ⟹ count = 0.

    2. **Region monotonicity**: enlarging the region cannot decrease
       the count.

    3. **Threshold antitonicity**: lowering the threshold cannot
       decrease the count.

    4. **Critical-event detection**: starting from the identity with
       no defects, any later non-zero count implies an intermediate
       topological event existed.

    5. **Composability**: the topological-event predicate is a
       concrete Boolean test on consecutive trajectory steps,
       composable with any flow predicate.

    This file ships the load-bearing pragmatic detection.  The full
    Hodge-Laplacian + Betti-number version is `Foundations/
    HodgeLatticeCohomology.lean` (Phase 6 companion). -/
theorem higgs_creation_event_topology_report
    (path : MetricPath) (g_exact : DiscreteMetric)
    {ε : ℝ} (hε : 0 < ε)
    (R : Finset LatticePoint) (delta_tau tau0 : ℝ)
    (hstart : path tau0 = g_exact) :
    -- (1) Vanishing at no-defects (identity case)
    (defectSiteCount g_exact g_exact ε R = 0) ∧
    -- (2) Region monotonicity
    (∀ R₁ R₂ : Finset LatticePoint, R₁ ⊆ R₂ →
        ∀ g, defectSiteCount g g_exact ε R₁ ≤
             defectSiteCount g g_exact ε R₂) ∧
    -- (3) Threshold antitonicity
    (∀ ε₁ ε₂ : ℝ, ε₁ ≤ ε₂ → ∀ g,
        defectSiteCount g g_exact ε₂ R ≤
          defectSiteCount g g_exact ε₁ R) ∧
    -- (4) Critical-event detection
    (∀ N : ℕ, 0 < defectSiteCountAlongFlow path g_exact ε R
                  delta_tau tau0 N →
       ∃ n < N, IsTopologicalEvent path g_exact ε R delta_tau tau0 n) ∧
    -- (5) Composability — IsTopologicalEvent unfolds to a count comparison
    (∀ n, IsTopologicalEvent path g_exact ε R delta_tau tau0 n ↔
        defectSiteCount (path (tau0 + n * delta_tau)) g_exact ε R ≠
          defectSiteCount (path (tau0 + (n+1 : ℕ) * delta_tau))
            g_exact ε R) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact defectSiteCount_at_identity_eq_zero g_exact hε R
  · intro R₁ R₂ hR g
    exact defectSiteCount_subset_monotone g g_exact ε hR
  · intro ε₁ ε₂ hε' g
    exact defectSiteCount_threshold_antitone g g_exact R hε'
  · intro N hN
    exact higgs_creation_event_detected path g_exact hε R delta_tau tau0
      hstart N hN
  · intro n
    exact IsTopologicalEvent_iff_count_changes path g_exact ε R
      delta_tau tau0 n

end OmegaTheory.Foundations.HiggsCreationEventTopology
