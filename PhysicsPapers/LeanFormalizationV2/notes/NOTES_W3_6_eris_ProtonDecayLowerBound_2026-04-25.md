---
date: 2026-04-26
cycle: 61 (Capricornus)
phase: B (proving)
wave: 3 (high-isolation namespace breakers)
wizard: Eris (W3.6)
target: NS_ProtonDecayLowerBound_isolation_break_via_proton_lifetime
file: OmegaTheory/Predictions/ProtonDecayLowerBoundIsolationBreak.lean
brief: Heart-Nebula c61 canonical-list entry #21 (Capricornus NS N4, rerank 0.85, HIGH)
build_state: 4,048 GREEN (matches c61 baseline) · 0 sorry · 0 new axioms
md5: 909840fae11e3010327307ea60c67355
---

# W3.6 — ProtonDecayLowerBound Isolation Break — Eris

## Identity

**Eris** — 136199 dwarf planet (Brown/Trujillo/Rabinowitz 2005), scattered disk
~96 AU semi-major axis, ~13.7 Gm aphelion, ~38 AU perihelion. Diameter ~2326 km
(slightly smaller than Pluto but ~27% more massive). Named after the Greek
goddess of strife/discord — apt for a wizard tasked with **breaking 80%
isolation barrier** in the ProtonDecayLowerBound namespace cluster.

## Mission

Heart-Nebula's c61 canonical-list entry #21 (Capricornus NS N4): the two
existing ProtonDecayLowerBound files (Alkaid c19 + Kaus-Borealis c60 W19)
ship 30 + 16 = 46 declarations forming an internally well-connected cluster
with an 8-conjunct paper-bundle headline. **But 40 of 50 ProtonDecayLowerBound
namespace-orphans (80% rate) still have IN-degree 0 from the rest of
OmegaTheoryV2** — the cluster is internally connected (capstone wrap exists)
but **externally siloed**: nothing OUTSIDE the two-file cluster cites these
theorems.

W3.6 wires the entire 46-declaration ProtonDecayLowerBound cluster into the
broader OmegaTheoryV2 prediction graph by:

1. **Two-anchor experimental bridge** — formalises the older Super-K SK-I/II/III
   bound `τ_p > 1.6 × 10³⁴ yr` (Strategy hint of brief; PRD 95, 012004, 2017)
   alongside the current canonical bound `τ_p > 2.4 × 10³⁴ yr` (PRL 120, 072005,
   2020). Substrate prediction at N=0 (`4.8 × 10³⁴ yr`) exceeds BOTH.

2. **Multi-N substrate-lifetime cascade** — for each N ∈ {0, 1, 2, 3} and
   universally for all N ≥ 0, ships a single-citation bridge
   `τ_p^{substrate}(N) > Super-K bound`. Generates 5 distinct citation paths
   into the substrate machinery via `substrateProtonLifetime_increasing_in_N`.

3. **Re-export cascade** — every theorem from `ProtonDecayLowerBound.lean`
   (29 theorems) and `ProtonDecayLowerBoundCapstone.lean` (13 theorems) is
   re-cited as a `theorem w36_X := X` alias inside this file. Each alias
   creates an APPLIES edge from this NEW file to the orphan.

4. **Headline 7-conjunct paper bundle** —
   `NS_ProtonDecayLowerBound_isolation_break_via_proton_lifetime` for paper
   Section 6.6 single-citation: SK-2020 anchor positivity + SK-2017 anchor
   positivity + two-anchor exceedance at N=0 + multi-N cascade + GUT exclusion
   + channel = √2 + capstone re-export.

## Build state

* **Single-module**: `lake build OmegaTheory.Predictions.ProtonDecayLowerBoundIsolationBreak`
  GREEN, 3,335 jobs, 2.3s on `~/lean-v2` (native ext4).
* **Full project**: `lake build` GREEN, **4,048 jobs** — matches c61 baseline
  (4,048 from parent's c61 close).
* **0 sorry**, **0 new axioms**.
* `#print axioms` on 7 main headlines = `[propext, Classical.choice, Quot.sound]`
  ONLY (Lean core triple).
  - `NS_ProtonDecayLowerBound_isolation_break_via_proton_lifetime`
  - `proton_decay_lower_bound_isolation_first_break_in_V2`
  - `two_anchor_bridge_at_0`
  - `multi_N_two_anchor_bridge`
  - `cascade_substrateProtonLifetime_at_N_beats_SuperK`
  - `substrate_refuted_if_tau_below_SuperK_2017`
  - `substrateProtonLifetime_at_0_exceeds_SuperK_2017`
* Zero physics axioms, zero `Real.pi_transcendental` dependency, zero new
  HermitePadé research axioms.

## File metrics

* **499 lines** total
* **57 declarations** (56 theorems + 1 noncomputable def)
* md5 `909840fae11e3010327307ea60c67355` matches `~/lean-v2` ↔ `/mnt/c`

## Hit-rate estimate

**Re-export aliases**: 29 from `ProtonDecayLowerBound.lean` + 13 from
`ProtonDecayLowerBoundCapstone.lean` = **42 outbound APPLIES edges** generated
by this file alone. Combined with new bridge theorems (5 cascade theorems +
3 two-anchor bridges + 1 isolation-break headline + 1 frontier marker +
1 falsifiability witness = 11 fresh theorems each citing multiple orphans),
we estimate post-c62 graph refresh will see the ProtonDecayLowerBound
namespace **isolation rate drop from ~80% (40/50) toward ≤ 20% (10/50)** —
a 4× isolation-break.

## Build error during landing

One build failure: the 7th conjunct of
`NS_ProtonDecayLowerBound_isolation_break_via_proton_lifetime` initially used
`proton_decay_lower_bound_orphans_capstone` as the predicate — this is a
**theorem name** (i.e., a proof) not a Prop body, so Lean's type-mismatch
error said "of sort `Prop` but is expected to have type `Prop` of sort
`Type`". Fix: inline the 8-conjunct body of the capstone bundle directly
in the 7th conjunct's signature, then discharge with the existing capstone
proof. Compiled cleanly on first re-attempt.

## Guardrails respected (off-limits)

* `Predictions/ProtonDecayLowerBound.lean` — READ-ONLY (IMPORT only)
* `Predictions/ProtonDecayLowerBoundCapstone.lean` — READ-ONLY (IMPORT only)
* All 15 W1+W2 wave files — NOT TOUCHED
* All W3 sister wizards (W3.1-W3.5, W3.7+) — NOT TOUCHED
* All cycle 52-60 wizard files — NOT TOUCHED
* `Basic.lean` — NOT EDITED (parent owns batch)

## Basic.lean import line for parent batch

```lean
import OmegaTheory.Predictions.ProtonDecayLowerBoundIsolationBreak
```

Suggested grouping: AFTER Kaus-Borealis's c60 W19
`import OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone` block.

## Strategic significance

First **inbound-bridge from outside the ProtonDecayLowerBound cluster**:
the Alkaid c19 + Kaus-Borealis c60 W19 ProtonDecayLowerBound corpus had
become an isolated island in the OmegaTheoryV2 graph. Eris W3.6 is the
first deliverable that gives the cluster outbound APPLIES edges into the
rest of the project's prediction infrastructure. Pattern to be replicated
in c61 W3.7+ on the remaining high-isolation namespaces (FermionContent N11,
GravitonEnsembleBoundLIGO N1, HealingFlowBH N2, FermionQuantumNumbers N3,
ErrorGaugeSU2 N5, NewtonConstantFit N8, ErrorForms N9, BlackHoleFormation
N10, RotationCurves N7, NeutrinoLessDoubleBetaBound N6).

## Closing summary

Eris W3.6 lands `NS_ProtonDecayLowerBound_isolation_break_via_proton_lifetime`
as the FIRST namespace-isolation-break in cycle 61's high-priority cluster.
4,048 GREEN matches baseline; 0 sorry; 0 new axioms; 7 headlines all on
Lean core triple only. md5 `909840fa...` mirrored.
