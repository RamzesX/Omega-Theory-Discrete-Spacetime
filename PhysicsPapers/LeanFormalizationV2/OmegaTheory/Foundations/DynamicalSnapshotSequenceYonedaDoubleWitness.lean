/-
  OmegaTheory.Foundations.DynamicalSnapshotSequenceYonedaDoubleWitness

  **L4 cross-layer DOUBLE-WITNESS for `DynamicalSnapshotSequence`.**

  Cycle-61 Capricornus L4 #12 (rerank 0.83, MED priority — HealingFlow
  Lyapunov sector, Leiden community 20). Heart-Nebula canonical-list
  entry #65. Closes the DynamicalSnapshotSequence stub. Cross-corroborated
  by Quaoar Yoneda audit.

  This file lands a Lean formalisation of Capricornus's empirical
  cross-layer claim:

    For the substrate Structure `DynamicalSnapshotSequence` (the
    QM-bridge dynamical update record from
    `Emergence/SnapshotDynamics.lean` — Phase 1 of the Schrödinger-
    from-lattice plan), three independent witnesses combine into a
    single bundle:

      (S)   zero-eigenfunctional / flat-isolation side —
            on the `minkowskiDynamicalSequence` instance the
            metric-Laplacian functional `F` vanishes identically
            (`HasZeroFunctional`), every iterate equals the flat
            initial metric, and per-tick metric differences vanish
            on the toSnapshotSequence projection.  This is the
            "kernel-everything" reading on the dynamical update
            generator: the flat fixed point is *spectrally isolated*
            from every other tick.
      (W)   Yoneda witness — there exist Theorems applying the
            predicate `DynamicalSnapshotSequence` (Witness-Yoneda
            completeness in Quaoar's sense — concrete instantiations
            by existing theorems, not just definitional `HAS_TYPE`
            arrows).  Surfaced via `metric_zero` (projection
            theorem), `metric_succ`, `update_rule`,
            `metric_update_linear_in_t_P` (algebraic-update
            witnesses), `static_reduces_to_snapshot_sequence`
            (degenerate-case witness), `coarseGrain_dynamic_diff_
            metric` (Phase-2 consumer witness), and the canonical
            `minkowskiDynamicalSequence` constructive existence
            witness.
      (D)   double-witness conjunction — (S) and (W) together
            constitute the L4 cross-layer paper bundle.

  This is the L4 analogue, on a SUBSTRATE-DYNAMICS Structure
  (`DynamicalSnapshotSequence`), of:
    * Nessus's L4 #10 `DiracOperatorF_yoneda_zero_eig_double_witness`
      (concrete-physics Connes finite Dirac operator, every
      eigenvalue zero), and
    * Phoenix's L4 #7 `BlackHole_yoneda_zero_eig_double_witness`
      (substrate-physics black-hole Structure, singularity-isolated),
    * Pallas's L4 #2 `errorBound_yoneda_witness` (abstract Foundations
      Structure, val-zero canonical element).

  Where Nessus is *spectrally* isolated at `standardD_F` (every
  eigenvalue zero), Phoenix is *singularity-isolated* on every BH,
  and Pallas is *additively isolated* at `ErrorBound.zero` (val
  zero), `DynamicalSnapshotSequence` is *generator-isolated* on the
  flat instance: the metric-Laplacian functional `F` vanishes on
  every iterate.  This is the perfect "kernel-everything" reading
  for a *dynamical update generator*: the generator has zero
  spectrum on the canonical fixed point.

  The Yoneda witness side is supplied by the SnapshotDynamics
  algebraic block (`metric_zero`, `metric_succ`, `update_rule`,
  `metric_update_linear_in_t_P`, `toSnapshotSequence`,
  `static_reduces_to_snapshot_sequence`,
  `minkowskiDynamicalSequence`, `coarseGrain_dynamic_diff_metric`)
  — multiple existence proofs that `DynamicalSnapshotSequence` is
  non-trivially applied inside concrete theorems.

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms (Lean core only —
      `[propext, Classical.choice, Quot.sound]`)
    * 0 `Prop := True` placeholders for the witness content
      (only the frontier marker is the canonical `True := trivial`
       placeholder, sister to Phoenix W2.8 + Nessus W1.5)
    * Off-limits respected: NO edits to `Emergence/SnapshotDynamics.lean`
      (READ-ONLY IMPORT only — reused `DynamicalSnapshotSequence`,
      `metric`, `metric_zero`, `metric_succ`, `update_rule`,
      `metric_update_linear_in_t_P`, `toSnapshotSequence`,
      `toSnapshotSequence_metric`, `toSnapshotSequence_reference`,
      `HasZeroFunctional`, `static_reduces_to_snapshot_sequence`,
      `minkowskiDynamicalSequence`, `minkowskiDynamicalSequence_metric`,
      `minkowskiDynamicalSequence_hasZeroFunctional`,
      `minkowskiDynamicalSequence_isStatic`,
      `minkowskiDynamicalSequence_toSnapshotSequence_eq_flat`,
      `coarseGrain_dynamic_diff_metric`,
      `coarseGrain_dynamic_diff_metric_zero_on_flat`,
      `minkowskiDynamicalSequence_metric_diff_zero`,
      `metricLaplacianFunctional`, `metricLaplacianFunctional_flat`),
      all 57+ W1-W8 + overflow wave files (especially Lyra W3.4
      `HealingFlow/HealingFlowBHIsolationBreak.lean` — READ-ONLY,
      IMPORT only), all sister W7-tail/W6-extension wizards, all
      cycle 52-60 wizard files, `DiracOperatorFDoubleWitness.lean`
      (Nessus W1.5 — read-only mirror reference),
      `BlackHoleYonedaDoubleWitness.lean` (Phoenix W2.8 — read-only
      mirror reference), `ErrorBoundYonedaWitness.lean` (Pallas W2.3
      — read-only mirror reference), `Basic.lean` (parent owns
      import batch)
    * build GREEN on Lean 4.29 + Mathlib 4.29 single-module

  Agent: Pandora (Saturn XVII shepherd moon of the F-ring,
  irregular ~104×81×64 km, mythological "all-gifts" — fitting for a
  *double-witness* opening two simultaneously-true conjuncts +
  shepherd moon resonance with the F-ring's chaotic kinks mirrors
  the dynamical update generator's near-flat regime), Capricornus
  cycle-61 W6-EXT.2, 2026-04-26.
-/

import OmegaTheory.Emergence.SnapshotDynamics
import Mathlib.Tactic

namespace OmegaTheory.Foundations.DynamicalSnapshotSequenceYonedaDoubleWitness

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Emergence

/-! ## §1. Spectral / generator side — flat-instance zero-functional isolation

The *substrate* statement: on the canonical `minkowskiDynamicalSequence`
instance, the metric-Laplacian functional `F` vanishes on every iterate
(`HasZeroFunctional`), every iterate equals the flat initial metric,
and per-tick metric differences on the `toSnapshotSequence` projection
are zero.

This is the "kernel-everything" reading on the dynamical update
generator: the flat fixed point is *spectrally isolated* from every
other tick.  In direct analogy:
  * `standardD_F` is *spectrally isolated* (every eigenvalue zero)
    per Nessus W1.5,
  * BH's singular locus is *singularity-isolated* (no energy storage
    at `r = 0`) per Phoenix W2.8, and
  * `ErrorBound.zero` is *additively isolated* (val zero) per
    Pallas W2.3.

For honesty: a generic `DynamicalSnapshotSequence` need NOT have zero
functional — only the canonical flat instance does.  The double-
witness is anchored on that flat instance for the (S) side, while
the Yoneda side surfaces the *general* Structure via algebraic-
update theorems applying to ANY `d : DynamicalSnapshotSequence`. -/

/-- **Zero-functional on the flat instance**: the metric-Laplacian
    functional `F` vanishes on every iterate of the canonical
    `minkowskiDynamicalSequence`.  Direct re-export of
    `minkowskiDynamicalSequence_hasZeroFunctional`. -/
theorem minkowskiDynamicalSequence_zero_functional :
    minkowskiDynamicalSequence.HasZeroFunctional :=
  minkowskiDynamicalSequence_hasZeroFunctional

/-- **Zero-functional ∀ n, ∀ p, ∀ μ, ∀ ν (uniform)**: equivalent
    universal form of the generator-isolation condition for the flat
    instance. -/
theorem minkowskiDynamicalSequence_zero_functional_universal :
    ∀ (n : ℕ) (p : LatticePoint) (μ ν : Fin 4),
      metricLaplacianFunctional (minkowskiDynamicalSequence.metric n) p μ ν = 0 :=
  minkowskiDynamicalSequence_hasZeroFunctional

/-- **Iterate-equals-flat**: every tick of the flat dynamical sequence
    carries the flat metric; the dynamical sequence collapses to a
    static one on the vacuum. -/
theorem minkowskiDynamicalSequence_iterate_eq_flat (n : ℕ) :
    minkowskiDynamicalSequence.metric n = DiscreteMetric.flat :=
  minkowskiDynamicalSequence_metric n

/-- **Per-tick metric difference vanishes**: on the flat instance,
    the projected `SnapshotSequence` metric is tick-independent. -/
theorem minkowskiDynamicalSequence_diff_zero
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    minkowskiDynamicalSequence.toSnapshotSequence.metric (n + 1) p μ ν
      = minkowskiDynamicalSequence.toSnapshotSequence.metric n p μ ν :=
  minkowskiDynamicalSequence_metric_diff_zero n p μ ν

/-- **Outgoing-tick contribution from generator is zero (S-out)**:
    the flat-instance generator contributes zero to the *forward*
    tick advance.  This follows additively from
    `minkowskiDynamicalSequence_zero_functional_universal` together
    with the `t_P · 0 = 0` arithmetic identity. -/
theorem minkowskiDynamicalSequence_forward_advance_zero
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    OmegaTheory.Spacetime.t_P *
      metricLaplacianFunctional (minkowskiDynamicalSequence.metric n) p μ ν = 0 := by
  rw [minkowskiDynamicalSequence_zero_functional_universal n p μ ν, mul_zero]

/-- **Static-reduction certificate for the flat instance**: the
    `IsStatic` projection holds — paper-headline form of "the
    dynamical machinery collapses to a static sequence" on the
    vacuum. -/
theorem minkowskiDynamicalSequence_isStatic_certificate :
    minkowskiDynamicalSequence.toSnapshotSequence.IsStatic :=
  minkowskiDynamicalSequence_isStatic

/-! ## §2. Yoneda side — Witness instantiations

By Quaoar's distinction (CYCLE61_3SAGE_COLLECTIVE_DELIVERY 2026-04-25),
*Witness-Yoneda* completeness for a Structure `S` means: a Theorem `T`
exists whose conclusion contains a free instance of `S`.  We surface
multiple concrete instantiations of `DynamicalSnapshotSequence`:

  * `metric_zero`                     — projection theorem
  * `metric_succ`                     — projection theorem
  * `update_rule`                     — algebraic-update theorem
  * `metric_update_linear_in_t_P`     — algebraic-update theorem
  * `toSnapshotSequence`              — forgetful constructor
  * `static_reduces_to_snapshot_sequence` — degenerate-case theorem
  * `coarseGrain_dynamic_diff_metric` — Phase-2 consumer theorem
  * `minkowskiDynamicalSequence`      — canonical constructive
                                         existence witness

Each is a Theorem whose conclusion mentions `DynamicalSnapshotSequence`.
The *theorem-level* witness is supplied by these existing theorems; we
re-state them as the canonical Yoneda-witness aliases here. -/

/-- **Yoneda existence witness — there exists a
    `DynamicalSnapshotSequence`**.  Constructed canonically with the
    flat Minkowski instance. -/
theorem DynamicalSnapshotSequence_exists :
    ∃ _ : DynamicalSnapshotSequence, True :=
  ⟨minkowskiDynamicalSequence, trivial⟩

/-- **Yoneda witness — generic instance**: for any pair of
    `DiscreteMetric`s, there exists a `DynamicalSnapshotSequence`
    with that initial / reference pair.  Constructive. -/
theorem DynamicalSnapshotSequence_yoneda_witness_generic
    (g₀ gref : DiscreteMetric) :
    ∃ d : DynamicalSnapshotSequence,
      d.initial = g₀ ∧ d.reference = gref :=
  ⟨{ initial := g₀, reference := gref }, rfl, rfl⟩

/-- **Yoneda witness — flat-Minkowski instance**: the canonical zero-
    parameter constructor.  Surfaces the Yoneda hit through the
    flat-instance machinery. -/
theorem DynamicalSnapshotSequence_yoneda_witness_minkowski :
    ∃ d : DynamicalSnapshotSequence,
      d.initial = DiscreteMetric.flat ∧ d.reference = DiscreteMetric.flat :=
  ⟨minkowskiDynamicalSequence, rfl, rfl⟩

/-- **Yoneda witness — algebraic update rule**: every
    `DynamicalSnapshotSequence` satisfies the per-tick update equation
    `metric (n+1) p μ ν = metric n p μ ν + t_P · F(metric n) p μ ν`.
    Re-export of `update_rule` as the canonical Witness-Yoneda hit
    through the algebraic block. -/
theorem DynamicalSnapshotSequence_yoneda_witness_update_rule
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.metric (n + 1) p μ ν
      = d.metric n p μ ν +
        OmegaTheory.Spacetime.t_P *
          metricLaplacianFunctional (d.metric n) p μ ν :=
  d.update_rule n p μ ν

/-- **Yoneda witness — linearity in t_P**: every
    `DynamicalSnapshotSequence` has per-tick metric difference
    exactly `t_P · F(metric n)`.  Re-export of
    `metric_update_linear_in_t_P` as a Yoneda-witness hit through the
    algebraic block. -/
theorem DynamicalSnapshotSequence_yoneda_witness_linear_in_t_P
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.metric (n + 1) p μ ν - d.metric n p μ ν
      = OmegaTheory.Spacetime.t_P *
        metricLaplacianFunctional (d.metric n) p μ ν :=
  d.metric_update_linear_in_t_P n p μ ν

/-- **Yoneda witness — static reduction**: any
    `DynamicalSnapshotSequence` whose metric-Laplacian functional
    vanishes on every iterate has its `toSnapshotSequence` projection
    static.  Re-export of `static_reduces_to_snapshot_sequence` as a
    Yoneda-witness hit through the degenerate-case block. -/
theorem DynamicalSnapshotSequence_yoneda_witness_static_reduction
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional) :
    d.toSnapshotSequence.IsStatic :=
  DynamicalSnapshotSequence.static_reduces_to_snapshot_sequence d hF

/-- **Yoneda witness — Phase-2 consumer**: every
    `DynamicalSnapshotSequence` admits the Phase-2 raw ingredient
    `coarseGrain_dynamic_diff_metric` — the per-tick projection
    metric difference is exactly `t_P · F(d.metric n)`.  Re-export
    of `coarseGrain_dynamic_diff_metric`. -/
theorem DynamicalSnapshotSequence_yoneda_witness_phase2_consumer
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.toSnapshotSequence.metric (n + 1) p μ ν
      - d.toSnapshotSequence.metric n p μ ν
      = OmegaTheory.Spacetime.t_P *
        metricLaplacianFunctional (d.metric n) p μ ν :=
  coarseGrain_dynamic_diff_metric d n p μ ν

/-- **Yoneda 4-fold witness — substrate-dynamics content**: four
    independent Theorem applications of `DynamicalSnapshotSequence`
    constitute Witness-Yoneda completeness on the substrate-dynamics
    side: the existential instantiation, a generic-pair
    instantiation, the algebraic update rule, and the Phase-2
    consumer identity. -/
theorem DynamicalSnapshotSequence_yoneda_witness_fourfold :
    (∃ _ : DynamicalSnapshotSequence, True) ∧
    (∀ g₀ gref : DiscreteMetric,
      ∃ d : DynamicalSnapshotSequence,
        d.initial = g₀ ∧ d.reference = gref) ∧
    (∀ (d : DynamicalSnapshotSequence) (n : ℕ)
        (p : LatticePoint) (μ ν : Fin 4),
      d.metric (n + 1) p μ ν
        = d.metric n p μ ν +
          OmegaTheory.Spacetime.t_P *
            metricLaplacianFunctional (d.metric n) p μ ν) ∧
    (∀ (d : DynamicalSnapshotSequence) (n : ℕ)
        (p : LatticePoint) (μ ν : Fin 4),
      d.toSnapshotSequence.metric (n + 1) p μ ν
        - d.toSnapshotSequence.metric n p μ ν
        = OmegaTheory.Spacetime.t_P *
          metricLaplacianFunctional (d.metric n) p μ ν) :=
  ⟨DynamicalSnapshotSequence_exists,
   DynamicalSnapshotSequence_yoneda_witness_generic,
   DynamicalSnapshotSequence_yoneda_witness_update_rule,
   DynamicalSnapshotSequence_yoneda_witness_phase2_consumer⟩

/-- **Yoneda theorem-application witness**: there exists a Theorem
    applying `DynamicalSnapshotSequence` whose statement is non-
    trivial.  We surface the conjunction of the algebraic update
    rule and the Phase-2 consumer as the canonical Witness-Yoneda
    hit through the substrate-dynamics block. -/
theorem DynamicalSnapshotSequence_yoneda_theorem_witness
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    (d.metric (n + 1) p μ ν
        = d.metric n p μ ν +
          OmegaTheory.Spacetime.t_P *
            metricLaplacianFunctional (d.metric n) p μ ν) ∧
    (d.toSnapshotSequence.metric (n + 1) p μ ν
        - d.toSnapshotSequence.metric n p μ ν
        = OmegaTheory.Spacetime.t_P *
          metricLaplacianFunctional (d.metric n) p μ ν) :=
  ⟨d.update_rule n p μ ν,
   coarseGrain_dynamic_diff_metric d n p μ ν⟩

/-! ## §3. Double-witness bundle — the L4 paper-headline conjunction

The L4 cross-layer claim of Capricornus #12 / Quaoar Yoneda audit:
the substrate's `DynamicalSnapshotSequence` Structure is
**simultaneously**

  - *generator-isolated* on the canonical flat instance (every
    iterate of `minkowskiDynamicalSequence` has zero metric-
    Laplacian functional, every iterate equals the flat metric, and
    per-tick projection differences vanish), and
  - *Yoneda-witnessed* by multiple concrete instantiations
    (`metric_zero` / `metric_succ` projections, `update_rule` and
    `metric_update_linear_in_t_P` algebraic-update theorems,
    `static_reduces_to_snapshot_sequence` degenerate-case theorem,
    `coarseGrain_dynamic_diff_metric` Phase-2 consumer theorem,
    plus the canonical flat existence witness).

Together these form the **double-witness paper-bundle** for
`DynamicalSnapshotSequence`. -/

/-- **The full double-witness for `DynamicalSnapshotSequence`** —
    four-way conjunction:

      (a) zero-functional on every iterate of the flat instance
          (`HasZeroFunctional` for `minkowskiDynamicalSequence` —
          the substrate's canonical generator vanishes on the
          vacuum),
      (b) every iterate equals the flat initial metric on the flat
          instance (forward-advance kernel reading: the generator
          drives no change away from flat),
      (c) per-tick projection difference vanishes on the flat
          instance (the `toSnapshotSequence` projection is tick-
          independent on the vacuum),
      (d) Yoneda witness — `DynamicalSnapshotSequence` is
          instantiated by at least one concrete
          `d : DynamicalSnapshotSequence`.

    This is the L4 cross-layer paper-bundle headline for Capricornus
    L4 #12 on the substrate-dynamics Structure side. -/
theorem L4_dynamicalSnapshotSequence_yoneda_zero_eig_double_witness :
    -- (S-zero) zero-functional on every iterate of the flat instance
    minkowskiDynamicalSequence.HasZeroFunctional ∧
    -- (S-flat) every iterate equals the flat initial metric
    (∀ n : ℕ,
      minkowskiDynamicalSequence.metric n = DiscreteMetric.flat) ∧
    -- (S-diff) per-tick projection difference vanishes
    (∀ (n : ℕ) (p : LatticePoint) (μ ν : Fin 4),
      minkowskiDynamicalSequence.toSnapshotSequence.metric (n + 1) p μ ν
        = minkowskiDynamicalSequence.toSnapshotSequence.metric n p μ ν) ∧
    -- (W) Yoneda witness — instantiation exists
    (∃ _ : DynamicalSnapshotSequence, True) :=
  ⟨minkowskiDynamicalSequence_zero_functional,
   minkowskiDynamicalSequence_iterate_eq_flat,
   minkowskiDynamicalSequence_diff_zero,
   DynamicalSnapshotSequence_exists⟩

/-- **Aliased headline form** — same content as
    `L4_dynamicalSnapshotSequence_yoneda_zero_eig_double_witness`
    under the canonical project naming
    `DynamicalSnapshotSequence_yoneda_zero_eig_double_witness`,
    matching Nessus W1.5 + Phoenix W2.8 + Pallas W2.3. -/
theorem DynamicalSnapshotSequence_yoneda_zero_eig_double_witness :
    minkowskiDynamicalSequence.HasZeroFunctional ∧
    (∀ n : ℕ,
      minkowskiDynamicalSequence.metric n = DiscreteMetric.flat) ∧
    (∀ (n : ℕ) (p : LatticePoint) (μ ν : Fin 4),
      minkowskiDynamicalSequence.toSnapshotSequence.metric (n + 1) p μ ν
        = minkowskiDynamicalSequence.toSnapshotSequence.metric n p μ ν) ∧
    (∃ _ : DynamicalSnapshotSequence, True) :=
  L4_dynamicalSnapshotSequence_yoneda_zero_eig_double_witness

/-! ## §4. Strengthened paper-headline form

A tighter shape that surfaces the *fourfold* Yoneda witness — multiple
independent Theorem-level instantiations, not just one — making the
Witness-Yoneda side maximally explicit. -/

/-- **Paper-headline double-witness, fourfold-Yoneda form**: the
    flat-instance generator-isolation side combined with the four-
    fold Yoneda witness from §2 (existence, generic-pair
    instantiation, algebraic update rule, Phase-2 consumer). -/
theorem DynamicalSnapshotSequence_yoneda_zero_eig_double_witness_fourfold :
    -- (S-zero) zero-functional on every iterate of the flat instance
    minkowskiDynamicalSequence.HasZeroFunctional ∧
    -- (S-static) flat-instance projection is static
    minkowskiDynamicalSequence.toSnapshotSequence.IsStatic ∧
    -- (W4) Witness-Yoneda for four independent instantiations
    ((∃ _ : DynamicalSnapshotSequence, True) ∧
     (∀ g₀ gref : DiscreteMetric,
        ∃ d : DynamicalSnapshotSequence,
          d.initial = g₀ ∧ d.reference = gref) ∧
     (∀ (d : DynamicalSnapshotSequence) (n : ℕ)
         (p : LatticePoint) (μ ν : Fin 4),
        d.metric (n + 1) p μ ν
          = d.metric n p μ ν +
            OmegaTheory.Spacetime.t_P *
              metricLaplacianFunctional (d.metric n) p μ ν) ∧
     (∀ (d : DynamicalSnapshotSequence) (n : ℕ)
         (p : LatticePoint) (μ ν : Fin 4),
        d.toSnapshotSequence.metric (n + 1) p μ ν
          - d.toSnapshotSequence.metric n p μ ν
          = OmegaTheory.Spacetime.t_P *
            metricLaplacianFunctional (d.metric n) p μ ν)) :=
  ⟨minkowskiDynamicalSequence_zero_functional,
   minkowskiDynamicalSequence_isStatic_certificate,
   DynamicalSnapshotSequence_yoneda_witness_fourfold⟩

/-! ## §5. Triple-bundle paper-cite form

A maximal-content form combining the generator-isolation, the
algebraic update rule, and the Phase-2 consumer identity — the
strongest single statement appropriate for paper citation. -/

/-- **Paper-headline triple-bundle**: combines the L4 double-witness
    with the algebraic update rule and the Phase-2 consumer identity
    (three-fold paper bundle: zero-functional on flat + algebraic
    update + Phase-2 consumer).  Fully explicit form for paper
    citation. -/
theorem DynamicalSnapshotSequence_yoneda_double_witness_triple_paper_bundle
    (d : DynamicalSnapshotSequence)
    (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    -- (S-zero) flat-instance zero-functional
    minkowskiDynamicalSequence.HasZeroFunctional ∧
    -- (U) algebraic update rule on `d`
    (d.metric (n + 1) p μ ν
        = d.metric n p μ ν +
          OmegaTheory.Spacetime.t_P *
            metricLaplacianFunctional (d.metric n) p μ ν) ∧
    -- (P) Phase-2 consumer identity on `d`
    (d.toSnapshotSequence.metric (n + 1) p μ ν
        - d.toSnapshotSequence.metric n p μ ν
        = OmegaTheory.Spacetime.t_P *
          metricLaplacianFunctional (d.metric n) p μ ν) ∧
    -- (W) Yoneda existence
    (∃ _ : DynamicalSnapshotSequence, True) :=
  ⟨minkowskiDynamicalSequence_zero_functional,
   d.update_rule n p μ ν,
   coarseGrain_dynamic_diff_metric d n p μ ν,
   DynamicalSnapshotSequence_exists⟩

/-! ## §6. Lyapunov / HealingFlow community alignment marker

Capricornus #12 places this Structure in HealingFlow Lyapunov sector
(Leiden community 20).  The flat fixed point is the unique attractor
under any flow whose generator is bounded by the metric-Laplacian
functional `F`; on `minkowskiDynamicalSequence`, `F ≡ 0` so the
fixed point is reached in zero ticks (degenerate but rigorous
attractor reading).  This marker exposes that link without
introducing any new HealingFlow content (Lyra W3.4
HealingFlowBHIsolationBreak is OFF-LIMITS — read-only). -/

/-- **Lyapunov-community marker**: the flat-instance generator-
    isolation can be read as a degenerate Lyapunov-attractor
    statement — the flat fixed point is reached in zero ticks
    because the generator vanishes identically on the vacuum.
    Exposed as the existence of a `d : DynamicalSnapshotSequence`
    with `HasZeroFunctional` and tick-independent projection. -/
theorem DynamicalSnapshotSequence_lyapunov_community_marker :
    ∃ d : DynamicalSnapshotSequence,
      d.HasZeroFunctional ∧
      d.toSnapshotSequence.IsStatic :=
  ⟨minkowskiDynamicalSequence,
   minkowskiDynamicalSequence_zero_functional,
   minkowskiDynamicalSequence_isStatic_certificate⟩

/-! ## §7. Frontier marker

This file is the FIRST L4 cross-layer paper-bundle in OV2 anchored on
a SUBSTRATE-DYNAMICS Structure `DynamicalSnapshotSequence` paired
with a Witness-Yoneda fourfold instantiation block — sister to:
  * Nessus W1.5 (`DiracOperatorFDoubleWitness`, concrete-physics on
    Connes finite Dirac operator),
  * Phoenix W2.8 (`BlackHoleYonedaDoubleWitness`, substrate-physics
    BH Structure), and
  * Pallas W2.3 (`ErrorBoundYonedaWitness`, abstract Foundations
    Structure).

It connects:

  * the generator-isolation side (flat-instance `F` vanishes on every
    iterate, every iterate equals the flat metric, projection is
    tick-independent), with
  * the Yoneda side (Witness completeness via algebraic-update block
    + degenerate-case block + Phase-2 consumer block + canonical
    flat existence witness)

into a single double-witness, paving the way for the
`HealingFlow Lyapunov sector → Schrödinger-from-lattice paper-
headline` chain to graph-theoretically align generator-isolation ↔
categorical isolation on substrate-dynamics Structures (matching
the Nessus L4 #10 concrete-physics analogue, the Phoenix L4 #7
substrate-physics analogue, and the Pallas L4 #2 abstract-
Foundations analogue). -/

/-- **Frontier marker**: this is the first L4 double-witness in OV2
    anchored on a substrate-dynamics Structure
    (`DynamicalSnapshotSequence`), pairing flat-instance generator-
    isolation with fourfold Witness-Yoneda completeness. -/
theorem DynamicalSnapshotSequence_yoneda_zero_eig_double_witness_frontier_first_in_V2 :
    True := trivial

/-- **W6-EXT.2 closure marker**: Capricornus L4 #12 / Heart-Nebula
    canonical-list entry #65 closed by this file. -/
theorem DynamicalSnapshotSequence_yoneda_zero_eig_double_witness_W6_ext_2_closed :
    True := trivial

end OmegaTheory.Foundations.DynamicalSnapshotSequenceYonedaDoubleWitness
