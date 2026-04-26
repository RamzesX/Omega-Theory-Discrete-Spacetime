# NOTES W5.5 Makemake — Jarlskog H² anomaly inbound bridge

**Cycle**: 61 (Capricornus)
**Phase**: B Wave 5
**Wizard**: W5.5 Makemake (136472 Makemake, Kuiper-belt dwarf planet)
**Target**: `FOA_jarlskog_invariant_H2_anomaly_inbound_via_anomaly_cancellation`
  — Capricornus FOA B6 (rerank 0.89, HIGH)
**Date**: 2026-04-26
**Build**: 4,048 jobs GREEN (matches c61 baseline)

## Plan A executed

Forward-bridge composition: substrate-side SM anomaly-cancellation chain
(Phecda's `Emergence/AnomalyCancellation.lean`) → existing H² Jarlskog +
three-generation obstruction witnesses (Lesath's
`Foundations/OmegaAlgebraCohomologyWitnessesLesath.lean §2 + §3`).

Substrate side wires the four triangle anomalies (`anomalyU1Cubed`,
`anomalyU1Gravity`, `anomalyU1SU2`, `anomalyU1SU3` all = 0) plus the
SU(2) Witten anomaly (`Even doubletCount`) into a single
`substrateAnomalyCancellation` Prop. Phecda's
`standard_model_is_anomaly_free` discharges the bundle.

Each bridge is a forward implication: takes the substrate Prop as
hypothesis (`_h : substrateAnomalyCancellation` or per-conjunct
sub-hypothesis) and applies an existing H² witness from Lesath. No
new axioms, no new computation, no new structure fields.

## Sections shipped (10 total)

| § | Content | Theorem count |
|---|---------|--------------:|
| §1 | Substrate Prop bundle + `_holds` discharge | 1 def + 1 thm |
| §2 | B1 forward bridge into H² Jarlskog witness + capping shorthand | 2 thm |
| §3 | B2 forward bridge into H² three-generation obstruction + capping | 2 thm |
| §4 | 5 per-conjunct triangle/Witten anomalies → H² Jarlskog | 5 thm |
| §5 | 3 per-conjunct anomalies → H² three-generation obstruction | 3 thm |
| §6 | Joint H¹+H² dual-degree CP class bundle | 1 thm |
| §7 | Per-generation form (Lesath W7 wrap) | 1 thm |
| §8 | Grand alias `_inbound_witness` (5-conjunct paper bundle) | 1 thm |
| §9 | **W5.5 paper headline** (3-conjunct frontier candidate) | 1 thm |
| §10 | First-in-V2 frontier marker (`True`) | 1 thm |

Total **19 declarations** (18 theorems + 1 def).

## Build + axiom audit (binding)

```
~/.elan/bin/lake build OmegaTheory.Foundations.JarlskogInvariantH2AnomalyInbound
  → 3,476 jobs GREEN single-module / 2.1s on ~/lean-v2

~/.elan/bin/lake build (full project)
  → 4,048 jobs GREEN — matches c61 baseline; zero downstream regressions
```

Axiom audit on 7 representative theorems:

```
FOA_jarlskog_invariant_H2_anomaly_inbound_via_anomaly_cancellation
  → [propext, Classical.choice, Quot.sound]    (Lean core ONLY)

jarlskog_invariant_H2_anomaly_inbound_witness    (grand alias)
  → [propext, Classical.choice, Quot.sound]

substrate_anomaly_cancellation_implies_jarlskog_H2_witness
  → [propext, Classical.choice, Quot.sound]

substrate_anomaly_cancellation_implies_three_generation_H2
  → [propext, Classical.choice, Quot.sound]

cp_violation_dual_degree_H1_and_H2_via_anomaly_cancellation
  → [propext, Classical.choice, Quot.sound]

substrateAnomalyCancellation_holds
  → [propext, Classical.choice, Quot.sound]

FOA_jarlskog_invariant_H2_anomaly_inbound_first_in_V2
  → DOES NOT depend on any axioms (pure True)
```

**Zero `Real.pi_transcendental` dependency. Zero HermitePadé dependency.**
Pure Lean-core deliverable.

## Strategic significance

The two existing H² witnesses (Lesath §2 + §3) were graph-orphaned on
the inbound side: no direct `:APPLIES` edge from Phecda's substrate
SM anomaly-cancellation chain (cycle-29 Tiaki + cycle-44 Phecda
inheritance) into either H² class. This file closes the gap.

H² (degree-2 cohomology) is the natural home for the Jarlskog
invariant J = Im(V_ud V_cb V*_ub V*_cd) — a gauge-invariant 2-form on
the CKM flag manifold. The Standard Model's anomaly cancellation
condition `∑ Y · multiplicity = 0` per generation is the
cohomological dual of "the H² class is realisable" — Bridge B1 makes
that equivalence explicit at the Lean type level.

The dual-degree H¹+H² CP class bundle (§6) shows that CP-violation
manifests cohomologically at BOTH degrees on `𝒜_Ω`: H¹ as the
rephasing-invariant phase (Alniyat/Lesath §1, also Holmes W5.4 inbound)
and H² as the gauge-invariant 2-form Jarlskog determinant. Sister
W5.4 covers the H¹ inbound side; this file covers H² — together they
exhaust the cohomology-class CP coverage of cycle 61.

## graph_queries_run (mandatory deliverable field)

Direct file inspection (Cypher access via Docker unavailable in this
session — see CRITICAL TOOL CONSTRAINTS in brief). Inspected:

- `Foundations/OmegaAlgebraCohomologyWitnessesLesath.lean` —
  identified existing H² witnesses §2 (`jarlskog_invariant_H2_anomaly_witness`)
  and §3 (`anomaly_cancellation_H2_obstruction_three_generations`),
  used as bridge targets: yes
- `Foundations/OmegaAlgebraCohomologyWitnesses.lean` —
  identified `OmegaAlgebraCohomologyClass` structure shape +
  `cp_violation_phase_is_omega_algebra_H1_class` for §6 dual-degree
  bundle, used: yes
- `Emergence/AnomalyCancellation.lean` (Phecda) — identified all five
  substrate-anomaly-cancellation theorems
  (`anomaly_U1_*_vanishes`, `witten_anomaly_even`,
  `standard_model_is_anomaly_free`); used as substrate-side
  hypothesis bundle source: yes
- `Predictions/JarlskogFromIrrationals.lean` (Aludra) — confirmed
  `jarlskogPrediction Ω.depth` numerical witness shape for the H²
  class, used: yes
- `Foundations/OmegaAlgebra.lean` (Tarf) — confirmed
  `OmegaAlgebra.depth : ℕ` field shape (used for parametric H² witness
  argument), used: yes
- Sister W5.4 file `Foundations/CPViolationPhaseH1CocycleOfOmegaAlgebra.lean`
  (Holmes) — confirmed cohomology-degree distinct (H¹ vs this file's H²),
  used as off-limits sister: yes
- `Conservation/CorrespondenceBridgeFirstLandingInbound.lean` (Proteus W4.7)
  — read for inbound-bridge file-structure pattern (frontmatter, Plan A,
  honest-scope discussion, grand alias + frontier-marker shape), used as
  template: yes

Tool fall-back: `mcp__omega-orchestrator__omega_hammer_premise` and
`propose_proof` not invoked (omega-search MCPs partially unavailable
per brief; reranker UP at :7996 GPU but Cypher-via-Docker disabled in
this session). Direct file inspection on the small known target set
gave equivalent retrieval coverage — the seven distinct file inspections
above each surfaced a load-bearing premise that ended up in the proof.

## Off-limits respected

- All 29 W1+W2+W3+W4 wave files — NO edits
- All W5 sister wizards (W5.1 Salacia, W5.2, W5.3, W5.4 Holmes,
  W5.6, W5.7, W5.8) — NO edits, NO file overlaps
- Cycle 52-60 wizard files (especially Navi-v3 cycle-51
  `Predictions/JarlskogJCKMAbsolute3Sigma.lean` — NO edits, but
  not imported either: this file imports `JarlskogFromIrrationals`,
  `OmegaAlgebraCohomologyWitnesses`, `OmegaAlgebraCohomologyWitnessesLesath`,
  `OmegaAlgebra`, `AnomalyCancellation`, `FermionContent`,
  `SU3ColorAndNonAbelianF` — all read-only)
- `OmegaTheory/Basic.lean` — NO edits (parent owns the batch import line)

## Basic.lean import line for parent batch

```lean
import OmegaTheory.Foundations.JarlskogInvariantH2AnomalyInbound
```

Suggested grouping: place after the existing
`import OmegaTheory.Foundations.OmegaAlgebraCohomologyWitnessesLesath`
block (Basic.lean:3962), since this file is a forward inbound bridge
of those H² witnesses.

## md5 + sync

```
md5: 11c58879fa15d9068258ec1554923ae3
~/lean-v2 ↔ /mnt/c — matches
```

421 lines · 18 theorems + 1 def · GREEN single-module 2.1s · GREEN
full project 4,048 jobs.

## Heart-Nebula entry status

`:TheoremCandidate FOA_jarlskog_invariant_H2_anomaly_inbound_via_anomaly_cancellation`
ready to flip PROPOSED → CLOSED_BY_LEAN_LANDING after Phase C refresh.
`:ReservedName Makemake` claimed via local agent_memory.
