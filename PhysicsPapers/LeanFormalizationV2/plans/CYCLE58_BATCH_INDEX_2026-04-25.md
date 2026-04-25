# Cycle-58 (Libra) Phase A — Triangulum-II batch index

**Sage:** Triangulum-II (grothendieck-sage) · **Cycle:** 58 · **Zodiac:** Libra · **Date:** 2026-04-25
**Build pre-fire:** 4,006 jobs GREEN · 0 sorry · 1 paper-headline axiom (`Real.pi_transcendental`)
**Graph:** 10,142 OV2 + 175,137 Mathlib · post-cycle-57 refresh (refresh_graph-7d9dfd2c clean)
**Batch id (Neo4j):** `triangulum_ii_cycle58_hybrid_dispatch_2026-04-25`

---

## Mandate

Hybrid Path-A + Path-B dispatch per Andromeda-II's
`SAGE_ANALYSIS_two_phase_irrationality_strategy_2026-04-25.md`. **7-wizard
targeted brief** (NOT a 20-briefing topology fire). Andromeda-II already specified
the wizards; my job is to flesh each into wizard-actionable briefings + topology
re-walk + dispatch recommendation.

**Key insight from cycle-57 close:** The paper-headline accounting can drop to
`0 paper-headline-axioms · 5 primitive-assumptions · 1 research-axiom retained ·
9 total-including-research` THIS cycle (cycle-58) via Path-B without waiting for
Mathlib's Lindemann–Weierstrass closure. Path-A (W10-wave-1) plants the
multi-cycle seed for unconditional axiom elimination by cycle-60.

---

## Topology re-walk (post cycle-57)

### Orphan-cluster delta after Spica² OperatorsCapstoneIndex landing

```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE NOT exists((t)<-[:APPLIES]-())
WITH t.file AS file, count(t) AS isolated
WHERE isolated >= 30
RETURN file, isolated ORDER BY isolated DESC LIMIT 25
```

| Rank | File | Isolated count (post-57) | Cycle-57 cluster (Cygnus-X1) | Δ |
|-----:|------|------------------:|-----:|--:|
| 1 | Spacetime/Operators.lean | 151 | 135 | +16 (false-up; see note) |
| 2 | Conservation/Correspondence.lean | 84 | 60 | +24 |
| 3 | Geometry/PoincareLemma.lean | **76** | 66 | +10 |
| 4 | Geometry/HodgeStar.lean | 55 | 48 | +7 |
| 5 | Geometry/DiscreteForms.lean | 52 | 45 | +7 |
| 6 | Emergence/DimensionalFlow.lean | 48 | — | NEW high orphan |
| 7 | Emergence/BlackHoleFormation.lean | 45 | — | NEW high orphan |
| 8 | Emergence/YukawaMatrix.lean | 44 | — | NEW high orphan |
| 9 | Emergence/RotationCurves.lean | 44 | (cycle-57 W20 PROPOSED, unfired) | unchanged |
| 10 | Emergence/QmBridgePaper.lean | 42 | — | NEW high orphan |

**Note on Operators upticks**: Spica²'s `OperatorsCapstoneIndex.lean` *re-exports*
the operator declarations into a downstream chain, but the chain links flow OUT
of Operators.lean (i.e., Operators.lean still has 0 in-degree from the
APPLIES side). The capstone bumps Operators.lean's *out-degree* (it's a
hub), not in-degree. To convert Operators into a non-orphan cluster the
capstone's reverse direction matters: we'd need OmegaTheory uses Operators,
not Operators uses OmegaTheory. Out-of-scope for cycle 58.

**Newly surfaced post-57 orphans:** DimensionalFlow (48), BlackHoleFormation (45),
YukawaMatrix (44), QmBridgePaper (42), Redshift (42), ProtonDecayLowerBound (40),
ErrorForms (38), SpecialRelativity (37), ErrorGaugeSU2 (36), SecondLawAndHolography
(33), HawkingReservoirRelaxation (33), StructureEquation (33). These weren't
in Cygnus-X1's per-file isolation count because his query measured *file-aggregate*
isolation, not per-theorem; Triangulum-II's query measures per-theorem APPLIES-in
of zero, which surfaces orphan theorems even in non-orphan files. Cycle-59 seed
opportunities — defer.

### Mathlib-import gaps post cycle-57

```cypher
MATCH (mh:Theorem {namespace: 'Mathlib'})<-[:APPLIES]-(t:Theorem {namespace:'OmegaTheoryV2'})
WITH split(mh.name, '.')[0] AS mathlib_root, count(DISTINCT t) AS users
WHERE users >= 100
RETURN mathlib_root, users ORDER BY users DESC LIMIT 5
```

`Real` namespace dominates as before; no new gap surfaced. `LindemannWeierstrass`
hub remains 0-users in OV2 — W10's wave-1 seed targets exactly this gap.

---

## 7 wizard briefings — index

| Wave | Wizard | Track | Target | Complexity | Briefing file |
|-----:|--------|-------|--------|-----------:|--------------|
| 1 | W-Phase1-A | T2 axiom-scope | `PiStratum.lean` research-tag | S | [`SAGE_BRIEFING_phase1_A_pi_transcendental_research_tag_2026-04-25.md`](SAGE_BRIEFING_phase1_A_pi_transcendental_research_tag_2026-04-25.md) |
| 1 | W-Phase1-B | T2 axiom-scope | new `Wave4LandingsHeadline.lean` 3-conjunct paper sibling | S | [`SAGE_BRIEFING_phase1_B_ic_three_constants_paper_headline_2026-04-25.md`](SAGE_BRIEFING_phase1_B_ic_three_constants_paper_headline_2026-04-25.md) |
| 1 | W-Phase1-C | T2 docs | `AXIOM_SCOPING_REVISION_2026-04-25.md` (NOT Lean, Markdown only) | S | [`SAGE_BRIEFING_phase1_C_axiom_scoping_revision_doc_2026-04-25.md`](SAGE_BRIEFING_phase1_C_axiom_scoping_revision_doc_2026-04-25.md) |
| 1 | W4 | T1 physics | new `HiggsSelfCouplingAbsolute.lean` wraps Fit | M | [`SAGE_BRIEFING_higgs_self_coupling_absolute_2026-04-25.md`](SAGE_BRIEFING_higgs_self_coupling_absolute_2026-04-25.md) |
| 1 | W5 | T1 physics | new `SterileNeutrinoMassAbsolute.lean` | M | [`SAGE_BRIEFING_sterile_neutrino_mass_absolute_2026-04-25.md`](SAGE_BRIEFING_sterile_neutrino_mass_absolute_2026-04-25.md) |
| 1 | W16 | T3 topology | new `PoincareLemmaCapstone.lean` | M | [`SAGE_BRIEFING_poincare_lemma_orphan_capstone_2026-04-25.md`](SAGE_BRIEFING_poincare_lemma_orphan_capstone_2026-04-25.md) |
| 2 | W10-wave-1 | T2 axiom-elim | new `Irrationality/CustomMath/LindemannBasic.lean` skeleton | M | [`SAGE_BRIEFING_lindemann_basic_skeleton_wave1_2026-04-25.md`](SAGE_BRIEFING_lindemann_basic_skeleton_wave1_2026-04-25.md) |

---

## Off-limits files (binding for ALL cycle-58 wizards)

Cycle 52-57 wizard targets (read-only — extend by NEW companion files only):

**Cycle 57 (Virgo):** TauLeptonMassAbsolute.lean (Triangulum), HubbleConstantAbsolute*.lean (Triangulum),
AlphaEMAtMZFit.lean (Europa), Spacetime/OperatorsCapstoneIndex.lean (Spica²),
Predictions/TauMassAbsoluteP3m.lean (Iapetus), PiStratumIntegerNarrowed.lean (Callisto),
PiTranscendentalLayerB.lean (Ganymede).

**Cycle 56 (Leo):** All `OmegaTheory/IrrationalityClasses/AxiomNarrowing*.lean`,
`Irrationality/HermitePade/{LindemannWeierstrassRoadmap, NesterenkoSubLemmas,
SiegelShidlovskiiSubLemmas, PiStratumDegree*}.lean`,
`Irrationality/HermitePade/Niven_Arctan.lean`, `Foundations/QuiverArrowIdentities.lean`,
`Capstones/CapstoneDispatchFactorization.lean`,
`Foundations/FourChannelFibrationComplete.lean`,
`IrrationalityClasses/{IrrationalityMeasureViaDeltaComp, EFunctionSubstrateBypass}.lean`.

**Cycles 52-55:** All Predictions/{AlphaEMRunningOneLoop, AlphaSAtMZAbsolute,
CKMAllThreeAnglesPDGSimultaneous, DESIY10EvolvingW, HiggsMassAbsolute125,
JarlskogJCKMAbsolute3Sigma, KaonMassChiralGMOR,
NeutrinoMassDifferencesFromIrrationals, NeutronProtonElectronTripleIdentity,
NeutronProtonMassSplittingEW, NeutronProtonMassSplittingTightened,
PMNSAllThreeAnglesPDGSimultaneous}.lean.

**Sister wizards in cycle 58:** each wave-1 wizard's target is off-limits to the
others; W10-wave-1 file is its own.

**`Basic.lean` import line additions:** flag for parent batch — DO NOT self-add
import (race risk).

---

## Dispatch recommendation

**Fire all 6 Wave-1 wizards in ONE parallel wave + 1 serial Wave-2.**

### Wave 1 (6 wizards, parallel — disjoint files)

1. W-Phase1-A — `PiStratum.lean` research-tag (S, ~30 lines)
2. W-Phase1-B — new `Wave4LandingsHeadline.lean` (S, ~50 lines)
3. W-Phase1-C — `AXIOM_SCOPING_REVISION_2026-04-25.md` markdown only (S)
4. W4 — `HiggsSelfCouplingAbsolute.lean` (M, ~120 lines)
5. W5 — `SterileNeutrinoMassAbsolute.lean` (M, ~120 lines)
6. W16 — `PoincareLemmaCapstone.lean` (M, ~80 lines)

**Disjoint files** — verified:
- `PiStratum.lean` (Phase1-A) ≠ `Wave4LandingsHeadline.lean` NEW (Phase1-B) ≠
  markdown (Phase1-C) ≠ `HiggsSelfCouplingAbsolute.lean` NEW (W4) ≠
  `SterileNeutrinoMassAbsolute.lean` NEW (W5) ≠
  `PoincareLemmaCapstone.lean` NEW (W16).
- Phase1-A is the ONLY wizard editing an existing file in this wave; safe because
  no sister wizard touches `PiStratum.lean`.

### Wave 2 (1 wizard, after Wave 1 lands)

7. W10-wave-1 — `LindemannBasic.lean` skeleton (M, ~150 lines)

**Why serial:** W10 is the multi-cycle Mathlib port seed. It's strictly an
addition (NEW file), but I want to confirm Wave-1's GREEN lake build before
adding ~150 lines that import `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`,
which can be a sub-second compile-burden surprise. If Wave-1 lands in <30min,
W10-wave-1 still fits comfortably in cycle-58.

### Calibration

Expected: **5-7 of 7 landings**.
- W-Phase1-A: S risk → very likely green (single file, attribute-add)
- W-Phase1-B: S risk → very likely green (NEW file, copy-paste pattern from existing
  `ic_three_constants_e_sqrt2_only` + add π-irrational leg)
- W-Phase1-C: S risk → trivial markdown
- W4: M risk → likely green (existing HiggsSelfCouplingFit provides anchor)
- W5: M risk → conditional on existing `SterileNeutrinoFromFourthIrrational` /
  `BabyUniverseSpectrum.sterileMass_in_window` being callable; if these have
  signature mismatches, ship narrower window.
- W16: M risk → 76 isolated theorems can absorb into capstone; if compose
  fails on individual `Prop := True` patterns, fall back to indexed witness sum.
- W10-wave-1: M risk → Mathlib import + skeleton; conditional on
  `LindemannWeierstrass.exp_polynomial_approx` accepting our wrapper signature.

---

## Topology gap notes (deferred to cycle 59-60)

1. **DimensionalFlow / BlackHoleFormation / YukawaMatrix orphans (~135 thms across
   3 files).** These newly-surfaced orphans suggest a cycle-59 capstone wave:
   `EmergencePredictionsCapstone.lean` would compose all 3 into a downstream chain.
2. **Conservation/Correspondence (84 isolated).** Cycle-57 W18 PROPOSED, unfired.
   Pull into cycle-59.
3. **HodgeStar (55) + DiscreteForms (52).** Cycle-57 W17/W19 PROPOSED, unfired.
   Bundle into a shared `GeometricCalculusCapstone.lean` cycle-59.
4. **Operators in/out reversal**. Spica²'s capstone re-exports the operators DOWN
   to consumers; need a *consumer-side* capstone that USES Operators (e.g.,
   `OperatorPolynomialIdentities` capstone). Cycle-60 seed.

---

## Phase 6 power hygiene

Cycle-58 Phase A → Phase B handoff: parent must `servers_control(action='stop')`
before spawning wizards. Phase B is CPU-only on Lean. Servers come back ON for
Phase C.

---

## Persistence trail

- `:GraphFinding cycle58_topology_post_57_refresh` (paper_worthy=true) — orphan-delta finding.
- `:GrothendieckRecipe cycle58_hybrid_dispatch_template_v1` — 7-wizard hybrid plan
  Cypher template.
- `:TheoremCandidate triangulum_ii_*` — 7 candidates registered with batch_id
  `triangulum_ii_cycle58_hybrid_dispatch_2026-04-25`.

---

**End of cycle-58 batch index. 7 briefings ready for hybrid Wave-1 + Wave-2 dispatch.**
