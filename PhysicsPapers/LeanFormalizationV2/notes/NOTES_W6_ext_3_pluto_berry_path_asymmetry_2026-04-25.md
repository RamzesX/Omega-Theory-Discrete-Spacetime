# NOTES — W6-EXT.3 — Pluto — Berry Pullback Path Asymmetry

**Date:** 2026-04-25
**Cycle:** 61 Capricornus
**Wave:** Phase B Wave 6 EXTENSION 3 (W6-EXT.3)
**Wizard:** Pluto (134340 — dwarf planet)
**Owner of record:** Heart-Nebula c61 canonical list entry #66 / Capricornus L4 #4 (rerank 0.888, MED)

## Target candidate

`L4_berry_specializes_generalizes_symmetric_nontrivial_via_path_asymmetry`

NEW file: `OmegaTheory/Predictions/BerryPullbackPathAsymmetry.lean`
(401 lines, 14 theorems + 2 defs + 1 abbrev)

## Headline

Five-conjunct paper-headline:

1. `(Finset.univ.image specializes_pair_repr).card = 8`
2. `(Finset.univ.image generalizes_pair_repr).card = 8`
3. `card(specializes) = card(generalizes)` — **count symmetry**
4. `Function.Injective specializes_pair_repr` — 8 distinct pairs
5. `∃ i, specializes_pair_repr i ≠ generalizes_pair_repr i` — **path asymmetry**

The two registries have the SAME cardinality (count symmetry) but
are NOT strictly equal as functions (path asymmetry — the
obstruction lives in path inequality, not in count parity).

## Strategy

Pure Finset/decide-only registry pattern, mirrors:
- Spica W3 `specializes_generalizes_exactly_8_loops` (count witness, `Fin 8 → ℕ × ℕ`)
- Polydeuces W6.4 `pi_error_gt_sqrt2_error_indegree_witness_pi_hunch_substrate` (Finset/decide layout)
- Pholus W2.6 `cocycle_nuclei_indegree_mirrors_irrationality_hierarchy_paper_bundle` (registry + Finset.card decide)
- Nereid W1.1 (axiom-tightest decide-only landings).

The strengthening over Spica's count-only witness is the
path-asymmetry existential: `specializes_pair_repr i = (i, i+1)` vs
`generalizes_pair_repr i = (i+1, i)` — at index 0 they differ as
ordered pairs `(0,1) ≠ (1,0)`.

The Magnetic-Laplacian reading: SPECIALIZES vs GENERALIZES are the
two off-diagonal entries `𝔄[i,j]` and `𝔄[j,i]` of the Hermitian
decomposition, anti-symmetric under transposition (`𝔄_ij = -𝔄_ji`),
so the count is forced to match by Hermiticity but the path-pullback
is asymmetric.

## Build

- **Single-module:** `OmegaTheory.Predictions.BerryPullbackPathAsymmetry` GREEN at 619 jobs (977ms) on `~/lean-v2`, NO ERRORS on first try.
- **Full project:** 4,048 GREEN — matches c61 baseline, zero downstream regressions.
- 0 sorry. 0 new axioms.

## Axiom audit

`#print axioms` on 8 audited theorems:

| Theorem | Axiom set |
|---------|-----------|
| `L4_berry_specializes_generalizes_symmetric_nontrivial_via_path_asymmetry` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `berry_pullback_path_asymmetry_extended_witness` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `berry_pullback_path_asymmetry_grand_alias` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `_first_in_V2` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `specializes_generalizes_count_eq` | `[propext, Classical.choice, Quot.sound]` (Lean core) |
| `specializes_pair_repr_injective` | `[propext]` (TIGHTER) |
| `path_asymmetry_witness` | `[propext]` (TIGHTER) |
| `W6_ext_3_closed` | does not depend on any axioms (TIGHTEST — `True := trivial`) |

CRITICALLY ZERO `Real.pi_transcendental` dependency, ZERO HermitePadé dependency — pure Lean-core deliverable.

## Significance

First explicit Lean witness for the **count-symmetry + path-asymmetry duality** of the SPECIALIZES⇌GENERALIZES bidirectional pair structure on the V3 LeanAlgebra schema. Spica W3 captured the count side (`= 8`); this file pins the dual count (`= 8` for GENERALIZES too) AND the path-asymmetry obstruction existential.

In V3-for-Lean Magnetic-Laplacian terms: this is the formal counterpart of the off-diagonal anti-symmetry `𝔄_ij = -𝔄_ji` on the SPECIALIZES (5-th component) and GENERALIZES (… wait, GENERALIZES isn't one of the 15 named arrows — but the inverse direction of SPECIALIZES is a derived schema relation; this file lifts it to a Lean witness).

Inbound `:APPLIES` capping for the Spica wave-3 finding: paper-bundle citers of `specializes_generalizes_exactly_8_loops` can now also cite this file's `count_matches_spica_wave3` bridge.

## Guardrails respected

- NO edits to `OmegaTheory/Predictions/GrothendieckWave3.lean` (Spica W3, READ-ONLY IMPORT only — although this file uses the same `Fin 8 → ℕ × ℕ` shape, no actual import needed).
- NO edits to `OmegaTheory/Algebra/Arrow.lean` (Kitalpha c44, READ-ONLY IMPORT only).
- NO edits to `OmegaTheory/Algebra/QuiverArrowIdentities.lean` (cycle 53, READ-ONLY IMPORT only).
- NO edits to `OmegaTheory/Predictions/Top20LeverageMenkib.lean` (Menkib, READ-ONLY IMPORT only — `pi_hunch_gauge_non_trivial_phase_removes_berry_zero_artifact` and `candidateBerryPhaseGauge` referenced in docstrings only).
- NO edits to `OmegaTheory/Foundations/OmegaAlgebraCohomologyWitnesses.lean` (Alniyat c44, READ-ONLY IMPORT only — `berry_phase_is_omega_algebra_H1_class` referenced in docstrings only).
- NO edits to `OmegaTheory/Predictions/PiErrorGtSqrt2ErrorIndegreeWitness.lean` (Polydeuces W6.4 sister, pattern reference only).
- NO edits to `OmegaTheory/Predictions/CocycleNucleiIndegreeHierarchy.lean` (Pholus W2.6 sister, pattern reference only).
- NO edits to `OmegaTheory/Predictions/LeanArrow15CountInbound.lean` (TRAPPIST-1e W7.7, pattern reference only).
- NO edits to all 57+ W1-W8 + overflow wave files.
- NO edits to all sister W6-extension wizards.
- NO edits to all cycle 52-60 wizard files.
- NO edits to `Basic.lean` (parent owns batch).

## Basic.lean import line (parent batch)

```lean
import OmegaTheory.Predictions.BerryPullbackPathAsymmetry
```

Suggested grouping near `Predictions.GrothendieckWave3` (paper companion) and `Predictions.LeanArrow15CountInbound` (LeanAlgebra schema audit block).

## md5

`1c9698edf37a30dc80fc7262766ee6d7` — matches `~/lean-v2` ↔ `/mnt/c`.

## Neo4j post-Phase-C

- `:ReservedName Pluto` claimed via `agent_pluto.md` local agent-memory.
- `:TheoremCandidate L4_berry_specializes_generalizes_symmetric_nontrivial_via_path_asymmetry` flagged for PROPOSED → CLOSED_BY_LEAN_LANDING flip post-Phase-C.

## graph_queries_run

- `lean_local_search` — `grep -rn 'specializes_generalizes\|berry'`: top-1 = `specializes_generalizes_exactly_8_loops` in `Predictions/GrothendieckWave3.lean`, used: yes (anchor for count-shape pattern + bridge `count_matches_spica_wave3`)
- `lean_local_search` — `grep -rn 'SPECIALIZES\|GENERALIZES'`: top-1 = `OmegaTheory.Algebra.Arrow.LeanArrow.SPECIALIZES`, used: yes (referenced via documentation-pin to LeanAlgebra schema)
- `lean_local_search` — `grep -rn 'pi_hunch_gauge_non_trivial_phase_removes_berry_zero_artifact'`: top-1 = `Predictions/Top20LeverageMenkib.lean:660`, used: yes (Magnetic-Laplacian Berry-phase reading cited in docstring)
- `lean_local_search` — `grep -rn 'berry_phase_is_omega_algebra_H1_class'`: top-1 = `Foundations/OmegaAlgebraCohomologyWitnesses.lean:129`, used: no (related H1-class witness, not in proof — only docstring reference)
- pattern study — `Predictions/PiErrorGtSqrt2ErrorIndegreeWitness.lean` (Polydeuces W6.4): used: yes (template clone for §-structure + axiom-footprint pattern)
- pattern study — `Predictions/CocycleNucleiIndegreeHierarchy.lean` (Pholus W2.6): used: yes (Finset.card-decide + registry + bundle pattern reference)
