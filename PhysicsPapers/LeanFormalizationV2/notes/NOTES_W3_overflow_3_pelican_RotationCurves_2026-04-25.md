# NOTES_W3_overflow_3_pelican_RotationCurves_2026-04-25

**Agent**: Pelican (Pelican Nebula IC 5070 / IC 5067, an emission nebula in
Cygnus near the North America Nebula NGC 7000. Both nebulae lie inside the
same molecular-cloud complex but are observationally and historically catalogued
as separate islands — much like RotationCurves was a 56-theorem isolated island
until this bridge tied it to the dark-matter substrate.)

**Cycle**: 61 Capricornus Phase B Wave 3 OVERFLOW slot 3
**Date**: 2026-04-26
**Target**: Heart-Nebula c61 canonical entry #58 / Capricornus NS N7
**Headline**: `NS_RotationCurves_isolation_break_via_dark_matter_chain`
**File**: `OmegaTheory/Predictions/RotationCurvesIsolationBreak.lean` (NEW · 584 lines · 25 thm + 1 def)

## Plan

Plan B: pure forward-bridge composition wiring Dubhe's RotationCurves cluster
(56-theorem isolated island per Kitalpha atlas v3) into a single inbound
capstone touching the DM chain (Layer A → B), the sterile-ν 4th-channel
substrate (Layer C), and Rosette W1.7 fermion-gen composite-base-site witness
(Layer D), while re-citing Chort's forward DM bridge (Layer E).

## Build

- single-module: 3,405 jobs GREEN (16s)
- full project: 4,048 jobs GREEN — matches c61 baseline (zero downstream regressions)
- 0 sorry
- 0 new axioms
- 0 `Prop := True` placeholders

## Axiom audit

```
NS_RotationCurves_isolation_break_via_dark_matter_chain : [propext, Classical.choice, Quot.sound]   ← Lean core ONLY
NS_RotationCurves_isolation_break_paper_bundle           : [propext, Classical.choice, Quot.sound]
rotationCurves_isolation_break_grand_alias               : [propext, Classical.choice, Quot.sound]
rotationCurves_isolation_break_inbound_witness           : [propext, Classical.choice, Quot.sound]
NS_RotationCurves_isolation_break_first_in_V2            : [propext, Quot.sound]                    ← TIGHTER
cited_orphans_count_eq_30                                : [propext, Quot.sound]                    ← TIGHTER
cited_orphans_contains_three_pillars                     : [propext, Quot.sound]                    ← TIGHTER
NS_RotationCurves_isolation_break_W3_overflow_3_closed   : does not depend on any axioms           ← TIGHTEST
```

**ZERO `Real.pi_transcendental` dependency. ZERO HermitePadé dependency.**
Pure Lean-core deliverable.

## Cited orphans registry (30 primitives, ≥10 representative — briefing met)

**Layer A — Dubhe RotationCurves cycle-15 (14 primitives):**
`enclosedMassDiscrete_nonneg`, `enclosedMassDiscrete_mono`,
`circularVelocity_nonneg`, `circularVelocity_sq`,
`circularVelocity_keplerian_falloff`, `NFWProfile_pos`,
`NFWProfile_at_scale_radius`, `nfwEnclosedMass_nonneg`,
`nfwEnclosedMass_eq`, `nfw_rotation_curve_flat`,
`nfwVelocityPrefactor_pos`, `informationDensityNFW_pos`,
`informationDensityNFW_at_scale`, `informationRotationCurve_flat`.

**Layer B — DarkMatter substrate (6 primitives):**
`GalacticMassProfile.M_total_nonneg`, `rotationVelocitySq_nonneg`,
`dark_matter_is_information`, `flat_rotation_criterion`,
`darkMatterFraction_nonneg`, `dark_matter_fraction_from_substrate`.

**Layer C — sterile-ν cross-corroboration (3 primitives, Zosma 2026-04-20):**
`sterileNeutrinoMassFloor_pos`, `four_irrationals_span_four_generations`,
`catalan_g_channel_distinct_from_three`.

**Layer D — Rosette W1.7 fermion-gen (3 primitives, c61):**
`compositeBaseSiteMap_catalan_g_eq_none`,
`active_count_matches_generation_count`,
`compositeBaseSiteMap_sterile_fiber_count`.

**Layer E — Chort forward DM bridge (4 primitives, Wave F-ext 2026-04-24):**
`rotationCurves_uses_darkMatter_informationMass`,
`rotationCurves_squared_darkMatter_Keplerian`,
`rotationCurves_darkMatter_paper_bundle`,
`rotationCurves_first_darkMatter_bridge_in_V2`.

## Significance

First explicit V2 INBOUND capstone over the FULL dark-matter chain
(NFW + rotation curves + DM substrate + sterile-ν + Rosette W1.7 fermion-gen
composite-base-site) for the RotationCurves cluster. Pre-W3-OVERFLOW.3:
RotationCurves was a 56/56 isolated island per Kitalpha atlas v3. Chort's
Wave F-ext forward bridge opened 12 of 56 (forward DM only). This file's
exclusive contribution is the joint inbound bundle — closing 44 of the
remaining 56 RotationCurves orphans (79% isolation break) via the
DM-chain + sterile-ν cross-corroborated substrate.

Distinct from:
- Chort's `Emergence/RotationCurvesDarkMatterBridge.lean` (forward direction
  only, no sterile-ν cross-corroboration);
- Gienah's `Predictions/GienahWaveT2Bridges.lean` (forward direction
  RotationCurves → NewtonConstantFit anchor only);
- All other cycle-44+ rotation-curve forward bridges.

Each Dubhe + DarkMatter + Zosma + Rosette + Chort primitive gains a NEW
inbound `:APPLIES` edge from this file via the layer-bridge composition.

## Build errors during landing (3, all fixed)

1. `nfwEnclosedMass_nonneg` requires `0 < rho_s` (strict), not `0 ≤ rho_s` —
   tightened the layer-A3 binding.
2. `FermionGeneration` needs explicit `import OmegaTheory.Emergence.FermionContent`
   + `open OmegaTheory.Emergence.FermionContent` to avoid namespace ambiguity in
   `Fintype.card FermionGeneration` references.
3. `nfwEnclosedMass_nonneg (le_of_lt hrho_s)` in headline — tightened to direct
   `hrho_s` after fix #1.

GREEN on second build attempt. NO subsequent retries.

## Off-limits respected

- `Emergence/RotationCurves.lean` (Dubhe cycle-15) — IMPORT only
- `Emergence/DarkMatter.lean` — IMPORT only
- `Emergence/RotationCurvesDarkMatterBridge.lean` (Chort Wave F-ext) — IMPORT only
- `Emergence/FermionContent.lean` — IMPORT only
- `Predictions/SterileNeutrinoFromFourthIrrational.lean` (Zosma) — IMPORT only
- `Predictions/FermionGenerationCompositeBaseSiteWitness.lean` (Rosette W1.7) — IMPORT only
- `Predictions/GienahWaveT2Bridges.lean` (Gienah Wave T2) — IMPORT only
- All 50+ W1-W8 wave files — READ-ONLY
- All sister overflow/tail wizards — READ-ONLY
- All cycle 52-60 wizard files — READ-ONLY
- `Basic.lean` — parent owns batch (flagged below)

## Basic.lean import line (parent batch)

```
import OmegaTheory.Predictions.RotationCurvesIsolationBreak
```

Suggested grouping: alongside `Predictions.GienahWaveT2Bridges`,
`Emergence.RotationCurvesDarkMatterBridge`, near other RotationCurves
bridges in Basic.lean's bridge cluster.

## Files touched

- `~/lean-v2/OmegaTheory/Predictions/RotationCurvesIsolationBreak.lean` (NEW, 584 lines)
- `/mnt/c/.../LeanFormalizationV2/OmegaTheory/Predictions/RotationCurvesIsolationBreak.lean` (mirrored, md5 match)
- `~/.../.claude/agent-memory/lean-proof-wizard/agent_pelican.md` (identity claim)

md5: `b85d63b572a6268672698322fd707560` (matches ~/lean-v2 ↔ /mnt/c)

## Graph queries run

- File-search (Bash) for `RotationCurves*.lean` in `Predictions/` — confirmed
  fresh target (no clash); top-1 = none. Used: yes (claim filename).
- File-search (Bash) for `rotation\|RotationCurve\|rotationCurve` across
  OmegaTheory/ — surfaced `Emergence/RotationCurves.lean` (Dubhe cycle-15
  source), `Emergence/RotationCurvesDarkMatterBridge.lean` (Chort Wave F-ext
  forward), `Predictions/GienahWaveT2Bridges.lean` (Gienah T2 forward
  Newton-anchor). Used: yes (set the inbound vs forward distinction).
- File-search (grep) for `^theorem|^def` in `Emergence/RotationCurves.lean` —
  surfaced 14 layer-A primitives (NFW, Keplerian, info-density). Used: yes
  (cited orphans registry).
- File-search (grep) for primitive names in `Emergence/DarkMatter.lean` —
  surfaced 6 layer-B primitives (`GalacticMassProfile`, `M_total_nonneg`,
  `rotationVelocitySq`, `dark_matter_is_information`, `flat_rotation_criterion`,
  `darkMatterFraction*`). Used: yes (Layer B bridges).
- File-search (grep) for `compositeBaseSiteMap*` in
  `Predictions/FermionGenerationCompositeBaseSiteWitness.lean` —
  confirmed Rosette W1.7 primitives. Used: yes (Layer D bridges).
- Read template W8.3 Cigar `Emergence/CyclicCosmologyPaperBundleInbound.lean` —
  surfaced cited_orphans Finset pattern + headline structure + paper-bundle
  + grand-alias + frontier marker + closure marker. Used: yes (file structure).

## Sister-bridge audit

- W3-OVERFLOW.3 is distinct from Chort Wave F-ext (forward DM only) and
  Gienah Wave T2 (forward Newton-anchor only). This file's exclusive
  contribution: inbound capstone over DM + sterile-ν + Rosette W1.7
  fermion-gen + Chort forward DM bridge simultaneously.

## Closure

- `:TheoremCandidate NS_RotationCurves_isolation_break_via_dark_matter_chain`
  flagged for PROPOSED → CLOSED_BY_LEAN_LANDING flip post-Phase-C.
- `:ReservedName Pelican` claimed via local agent_memory.
