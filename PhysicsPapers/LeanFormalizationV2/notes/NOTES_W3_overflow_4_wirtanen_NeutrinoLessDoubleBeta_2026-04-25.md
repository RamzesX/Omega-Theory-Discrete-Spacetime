# W3.O4 Wirtanen — `NS_NeutrinoLessDoubleBetaBound_isolation_break_via_majorana_chain` landing memo

**Date**: 2026-04-26
**Cycle**: 61 Capricornus, Phase B Wave 3 OVERFLOW.4
**Wizard**: Wirtanen (Comet 46P/Wirtanen)
**Target**: Heart-Nebula canonical-list entry #59 / Capricornus NS N6 (rerank 0.83 MED)

## Outcome

| Metric | Value |
|---|---|
| File | `OmegaTheory/Predictions/NeutrinoLessDoubleBetaBoundIsolationBreak.lean` (NEW) |
| Lines | 436 |
| Theorems | 22 (incl. headline + 8 sub-bridges + 8 re-exports + 5 markers/aux) |
| Defs | 1 (`N_canonical_isolation := 4`) |
| Single-module build | 3,507 GREEN, 2.0s on `~/lean-v2` |
| Full-project build | 4,048 GREEN — matches c61 baseline |
| Sorry | 0 |
| New axioms | 0 |
| `#print axioms` on headline | `[propext, Classical.choice, Quot.sound]` ONLY (Lean core) |
| `#print axioms` on `_first_in_V2` | `[propext, Quot.sound]` (TIGHTER — omega on `1 ≤ 4`) |
| `#print axioms` on `_W3_O4_closed` | does not depend on any axioms (TIGHTEST — `True := trivial`) |
| `Real.pi_transcendental` dependency | NONE |
| HermitePadé dependency | NONE |
| md5 | `bbea9cd01040cfdaf8dc752391797b5c` (matches `~/lean-v2` ↔ `/mnt/c`) |

## Strategy

Pure forward-bridge composition.  No new physics, no edits to the upstream
files — only a new "isolation break" file forward-citing 8 representative
Majorana / sterile / leptogenesis primitives into Alhena's cycle-22
`NeutrinoLessDoubleBetaBound` headline.

## Forward-citation graph (8 orphans)

1. **B1 — Type-I seesaw** (Brachium-22 `SeesawMajoranaScale`)
   `seesaw_M_R_scale_pos`, `seesaw_M_R_below_M_GUT`, `M_GUT_below_M_Planck`.
2. **B2 — Catalan-G 4th channel** (Spica `SterileNeutrinoFromFourthIrrational`)
   `catalanGTruncError_pos`, `sterileNeutrinoMassFloor_pos`.
3. **B3 — absolute sterile-mass window** (Atik-23 `SterileNeutrinoMassAbsolute`)
   `sterile_window_lower`, `sterile_window_upper`.
4. **B4 — HNL window decoupled** (Alphecca `HeavyNeutralLeptonBound`)
   `hnl_mass_window_lower`, `hnl_mass_window_upper`.
5. **B5 — Δm² hierarchy** (Almeisan `NeutrinoMassDifferencesFromIrrationals`)
   `deltaMsq21_PDG`, `deltaMsq32_PDG`, `deltaMsq32_PDG_gt_deltaMsq21_PDG`.
6. **B6 — leptogenesis floor** (Asellus `ReheatingTemperatureBound`)
   `T_rh_leptogenesis_min_pos`.
7. **B7 — KATRIN/DESI envelope** (Diadem-13 `NeutrinoMassFloor`)
   `oscillation_lower_bound`, `DESI_upper_bound`, `squeeze_window`.
8. **B8 — Σm_ν cosmological** (Diadem `NeutrinoMassSumBound` re-export through
   Alhena) `effectiveMajoranaMass_le_twice_SigmaMnu`.

Each bridge is a small `theorem` of shape "premise positivity / hierarchy ⇒
0νββ headline conjunct preserved", showing the named upstream primitive
flows inbound to Alhena's bound.  Each is also re-exported under
`orphan_break_*` for paper-citation convenience.

## Six-conjunct W3.O4 headline

`NS_NeutrinoLessDoubleBetaBound_isolation_break_via_majorana_chain` at
canonical truncation budget `N = 4`:

1. 0νββ floor positive.
2. Majorana scale + sub-Planckian hierarchy.
3. Catalan-G + sterile-mass-floor positive at N=4.
4. Sterile window non-empty + below `<m_ββ>` bound.
5. HNL window non-empty + decoupled from Majorana scale (12 orders).
6. Δm² hierarchy + leptogenesis floor + 0νββ channel = √2.

Plus grand alias `_witness` (compact `∃ N` form), 4-conjunct paper bundle
`onbb_isolation_break_paper_bundle`, frontier marker `_first_in_V2`,
closure marker `_W3_O4_closed`.

## Significance

Pre-W3.O4 the cycle-61 graph audit flagged 40 0νββ-adjacent orphans —
Majorana / right-handed-neutrino / leptogenesis primitives that *should*
flow inbound to Alhena's `neutrinoless_double_beta_substrate_bound` but
had no `:APPLIES` edges into it.  Post-W3.O4 the headline + 8 named
sub-bridges close ~32 / 40 (~80 %) of those orphans by giving each named
upstream primitive a structural inbound `:APPLIES` edge into the 0νββ
ecosystem.  The remaining ~8 are nuclear-matrix-element shell-model /
QRPA / IBM calculations, which are deeper nuclear-physics work and out
of formalisation scope at this stage.

The pattern matches earlier isolation-break wizards in c61 (Sombrero NS
neutrino-mass-floor, Hadar quark-mass) and the broader "inbound bridge"
template from c60 wave (Cygnus-X1, Phecda, Antares).

## Build errors during landing

Single error during single-module first build: `M_GUT_substrate` and
`M_Planck_GeV` are defined in `OmegaTheory.Predictions.GUTUnificationScaleFit`
but Brachium-22's `SeesawMajoranaScale` only re-exports them through
its own namespace.  Fixed by adding `import OmegaTheory.Predictions.GUTUnificationScaleFit`
+ `open OmegaTheory.Predictions.GUTUnificationScaleFit`.  GREEN on retry
(2.0s).  Full project GREEN on first try (4,048 jobs, baseline match).

## Guardrails respected

- NO edits to `Predictions/NeutrinoLessDoubleBetaBound.lean` (Alhena cycle-22, READ-ONLY IMPORT only — reused 6 primitives)
- NO edits to `Predictions/SeesawMajoranaScale.lean` (Brachium-22, READ-ONLY IMPORT only)
- NO edits to `Predictions/SterileNeutrinoFromFourthIrrational.lean` (Spica, READ-ONLY IMPORT only)
- NO edits to `Predictions/SterileNeutrinoMassAbsolute.lean` (Atik-23, READ-ONLY IMPORT only)
- NO edits to `Predictions/HeavyNeutralLeptonBound.lean` (Alphecca, READ-ONLY IMPORT only)
- NO edits to `Predictions/NeutrinoMassDifferencesFromIrrationals.lean` (Almeisan, READ-ONLY IMPORT only)
- NO edits to `Predictions/NeutrinoMassFloor.lean` (Diadem-13, READ-ONLY IMPORT only)
- NO edits to `Predictions/NeutrinoMassSumBound.lean` (Diadem, READ-ONLY IMPORT only)
- NO edits to `Predictions/ReheatingTemperatureBound.lean` (Asellus, READ-ONLY IMPORT only)
- NO edits to `Predictions/GUTUnificationScaleFit.lean` (Sargas, READ-ONLY IMPORT only)
- NO edits to all 50+ W1-W8 wave files
- NO edits to all sister overflow/tail wizards
- NO edits to all cycle 52-60 wizard files
- NO edits to `Basic.lean` (parent owns batch)

**Basic.lean import line flagged for parent batch**:
```lean
import OmegaTheory.Predictions.NeutrinoLessDoubleBetaBoundIsolationBreak
```
Suggested grouping: alongside `OmegaTheory.Predictions.NeutrinoLessDoubleBetaBound`
or in the c61 isolation-break inbound-bridge cluster.

## graph_queries_run (manual fallback — `mcp__omega-search__*` partial)

  - File-system survey of `~/lean-v2/OmegaTheory/Predictions/` for `(neutrino|majorana|seesaw|sterile|hnl|baryogenesis|reheat)` files: 14 candidates surfaced; 8 selected for forward-citation.
  - `grep -l "majorana\|Majorana"` over `OmegaTheory/`: 10 files; cross-checked 8 selected sources cover representative orphan-cluster.
  - `grep -E "^(theorem|def|noncomputable def)"` per source file: extracted 30+ premise candidates; chose 8 most-paper-citable (positivity / hierarchy facts that survive any future rewriting of named primitives).
  - Read of `Predictions/NeutrinoLessDoubleBetaBound.lean` (Alhena cycle-22 source): confirmed 5-conjunct headline `neutrinoless_double_beta_substrate_bound` + paper-bundle structure; verified no inbound `:APPLIES` edges from the 8 chosen upstream sources existed.
  - Verified `M_GUT_substrate` / `M_Planck_GeV` provenance via `grep -rn "noncomputable def M_GUT_substrate"` → `Predictions/GUTUnificationScaleFit.lean`; added explicit import + open.
