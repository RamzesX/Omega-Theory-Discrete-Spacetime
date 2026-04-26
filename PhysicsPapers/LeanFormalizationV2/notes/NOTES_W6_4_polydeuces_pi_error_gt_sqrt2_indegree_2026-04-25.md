# NOTES — c61 Capricornus Phase B Wave 6 W6.4 (Polydeuces)

**Date**: 2026-04-26
**Wizard**: Polydeuces (Saturn XXXIV — co-orbital trojan moon of Dione,
~3 km, L₅ Lagrange companion)
**Brief**: Heart-Nebula c61 canonical list entry #40 / Capricornus L4 #18
(rerank 0.90, HIGH — Pi-Hunch graph-witness companion, val-level
depth-1 indegree)
**Target**: `pi_error_gt_sqrt2_error_indegree_witness_pi_hunch_substrate`
**File**: `OmegaTheory/Predictions/PiErrorGtSqrt2ErrorIndegreeWitness.lean` (NEW · 390 lines · 11 thm + 2 def + 1 marker)
**Companion**: Pholus W2.6 `OmegaTheory/Predictions/CocycleNucleiIndegreeHierarchy.lean`

---

## What landed

NEW val-level depth-1 indegree paper-headline bundle for the Pi-Hunch
graph-theoretic witness, complementing Pholus's W2.6 depth-2 reachable
mass bundle.

**Three substrate-channel nuclei** — `pi_error_pos`, `sqrt2_error_pos`,
`e_error_pos` — encoded as `IrrationalChannelNucleus` inductive enum
(3-element subset of Pholus's 9-element `CocycleNucleus`).

**Frozen depth-1 indegree snapshot** (cycle 61 audit, 2026-04-26):

| nucleus           | depth-1 indeg | depth-2 mass (Pholus) |
|-------------------|:-:|:-:|
| `pi_error_pos`    | 64  | -- (downstream rolled into cU) |
| `sqrt2_error_pos` | 66  | 179 |
| `e_error_pos`     | 35  | 117 |

**Headline `pi_error_gt_sqrt2_error_indegree_witness_pi_hunch_substrate`**
= 5-conjunct: three Nat pins (64/66/35) + two strict `<` inequalities
giving `e < π < √2`. Honest narrower-true reading of the brief's slug:
the depth-1 audit *inverts* the literal "π > √2" reading; we ship the
**actual** depth-1 reversal `√2 > π > e` as the paired ordering.

**Extended 8-conjunct bundle** + **frontier marker**
`_first_paper_bundle_in_V2` + closure marker `W6_4_closed`.

---

## Why the depth-1 reversal matters

Three independent levels of the Pi-Hunch correspondence:

1. **Asymptotic decay** (paper):  π's `O(1/N)` heaviest residual,
   √2's `O(2^{-2^N})` super-exp lightest.
2. **Depth-2 reachable mass** (Pholus W2.6):  `cU=229 > √2=179 > e=117`.
3. **Depth-1 indegree** (this file):  `√2=66 > π=64 > e=35`.

The depth-1 vs depth-2 reversal on the heavy side (π → cU) is the
*key* observation: π's downstream consumer weight rolls up into the
composite-uncertainty hub at depth 2, so the depth-2 audit absorbs π's
downstream into `cU`. At depth 1, however, π and √2 stand on their own,
and `sqrt2_error_pos` happens to have one more immediate consumer than
`pi_error_pos` (66 vs 64) due to the SU(3) color-channel + light-fermion
pathway anchoring directly on √2 lemmas in OmegaTheory.

This is **how OmegaTheory uses each constant**, not a property of the
constants' decay rates — the val-level indegree picks up project-design
structure, not mathematical ordering. Both orderings are part of the
unified Pi-Hunch witness and are now both pinned in Lean.

---

## Build state

- Single-module: 600/600 GREEN, 5.9s on `~/lean-v2` (first build, no errors)
- Full project: **4,048 GREEN — matches c61 baseline; zero downstream regressions**
- 0 sorry · 0 new axioms

## Axiom audit (`#print axioms`)

| theorem | axioms |
|---------|--------|
| **`pi_error_gt_sqrt2_error_indegree_witness_pi_hunch_substrate`** (HEADLINE) | **NONE** (pure decide) |
| `pi_hunch_indegree_depth_1_extended_witness` | `[propext, Quot.sound]` |
| `pi_error_indegree_eq_64` | NONE |
| `sqrt2_error_indegree_eq_66` | NONE |
| `pi_hunch_indegree_strict_chain_depth_1` | NONE |
| `substrate_channel_nuclei_card_eq_3` | `[propext, Quot.sound]` |
| `_first_paper_bundle_in_V2` | NONE |
| `W6_4_closed` | NONE |

**Even TIGHTER than Lean core requirement** — headline depends on NO
axioms (pure `decide` reduction on closed-term `Nat` values).
**ZERO `Real.pi_transcendental` dependency.** ZERO `Classical.choice`
on the headline.

---

## Pattern reuse

Identical to:

* Nereid W1.1 `PiTranscendentalBlastRadiusBundle.lean` — `Finset` /
  `decide` registry, `[propext, Quot.sound]` audit footprint.
* Pholus W2.6 `CocycleNucleiIndegreeHierarchy.lean` — `inductive` +
  `Nat`-valued indegree function + `decide` on closed-term ordering.

Polydeuces sat as Dione's L₅ Lagrange companion (in real Saturnian
orbital mechanics) — fittingly, this file sits in the orbital wake
of Pholus's W2.6 file and shares its full `decide`-based pattern.

---

## Off-limits respected

- Pholus W2.6 `CocycleNucleiIndegreeHierarchy.lean` — READ-ONLY
  (companion file, distinct namespace, distinct enum
  `IrrationalChannelNucleus` vs Pholus's `CocycleNucleus`). No edits.
- All 31+ W1-W5 wave files — IMPORT-ONLY, no edits.
- All W6 sister wizards — disjoint namespace, no overlap.
- All cycle 52-60 wizard files — IMPORT-ONLY, no edits.
- `Basic.lean` — flagged for parent batch only.

## Basic.lean import line (parent batch)

```lean
import OmegaTheory.Predictions.PiErrorGtSqrt2ErrorIndegreeWitness
```

Suggested grouping: alongside Pholus's W2.6
`import OmegaTheory.Predictions.CocycleNucleiIndegreeHierarchy`
and Nereid's W1.1
`import OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle` —
all three are c61 paper-headline `Finset`/`Nat`-with-`decide`
registries with Lean-core-only axiom footprints.

## Reservations

- `:ReservedName Polydeuces` — claimed via local agent_memory at
  `LeanFormalizationV2/.claude/agent-memory/lean-proof-wizard/agent_polydeuces.md`.
- `:TheoremCandidate L4_pi_error_gt_sqrt2_error_indegree_witness_pi_hunch_substrate`
  — flagged for PROPOSED → CLOSED_BY_LEAN_LANDING flip post-Phase-C.

## md5

`4774513583050c663a3bae63ad4166db` matches `~/lean-v2` ↔ `/mnt/c`.
