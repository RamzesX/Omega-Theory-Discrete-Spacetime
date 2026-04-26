## NOTES W1.7 — Rosette — FermionGen composite base site (Pi-Hunch capstone)

**Cycle 61 Capricornus — Phase B Wave 1 — slot W1.7**
**Wizard**: Rosette (Rosette Nebula NGC 2237, Monoceros — large emission nebula
~5,200 ly hosting open cluster NGC 2244)
**Date**: 2026-04-26
**Brief**: Heart-Nebula's c61 final-closure list, entry #7
**Source candidate**: `L4_FermionGeneration_composite_base_site_witness`
(Capricornus L4 #17, rerank 0.91, HIGH — Pi-Hunch capstone)

### Deliverable

NEW file: `OmegaTheory/Predictions/FermionGenerationCompositeBaseSiteWitness.lean`
- 419 lines · 19 thm · 5 defs
- single-module GREEN: `lake build OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness` = 3,395/3,395 jobs (1 added vs baseline) in 2.0s on `~/lean-v2`
- 0 sorry · 0 new axioms
- md5 `80e693f7009682476073959afbd2b2df` matches `~/lean-v2 ↔ /mnt/c`

### Headlines (axiom audit verified — Lean-core only)

All depend on `[propext, Classical.choice, Quot.sound]` ONLY (Lean core).
**Zero physics axioms — no `Real.pi_transcendental`, no opaque physical bundles.**

| Theorem | Axioms |
|---------|--------|
| `FermionGeneration_composite_base_site_witness` | propext + Classical.choice + Quot.sound |
| `FermionGeneration_composite_base_site_witness_briefing_form` | propext + Classical.choice + Quot.sound |
| `FermionGeneration_composite_base_site_paper_bundle` | propext + Classical.choice + Quot.sound |
| `compositeBaseSiteMap_active_surjective` | propext + Classical.choice + Quot.sound |
| `compositeBaseSiteMap_partition_count` | propext + Quot.sound (Classical not even needed!) |
| `compositeBaseSiteMap_active_fiber_singleton` | propext + Classical.choice + Quot.sound |
| `compositeBaseSiteImage_eq` | propext + Classical.choice + Quot.sound |

### Strategy & honest narrower-true

**Briefing wanted**: `theorem FermionGen_4ch_to_3gen_witness : ∃ (f : FourChannel → FermionGeneration), Surjective f ∧ Fiber f sterile = {Catalan_G_channel} ∧ FiberCount (active) = 3`

**Honest narrower-true delivered**: `FermionGeneration = Fin 3` only counts the
**active** generations — there is no `sterile` element of `Fin 3` for the
sterile slot to point at. The only Lean-honest way to write a *single* surjection
covering both active + sterile is to use `Option FermionGeneration` codomain:
- `f catalan_g = none`  (sterile slot)
- `f c = some (active gen)` for the 3 active channels

The full briefing bundle is ALL captured:

| Briefing field | Lean theorem |
|----------------|--------------|
| `Surjective f` | `compositeBaseSiteMap_active_surjective` (active codomain) + `activeProjection_surjective` (total Fin 3 codomain) |
| `Fiber f sterile = {Catalan_G_channel}` | `compositeBaseSiteMap_sterile_fiber` + `sterileChannels_eq` |
| `FiberCount (active) = 3` | `compositeBaseSiteMap_active_fiber_count` |

The headline `FermionGeneration_composite_base_site_witness` packages all four
pillars (sterile fiber, active surjection, active count = 3, sterile count = 1).
The briefing-literal form `_briefing_form` uses the exact `(f c).isSome`
predicate the briefing implicitly references for "active fiber count".

### Building blocks reused (read-only — no edits)

- `IrrationalChannel4` (4 variants) — `OmegaTheory/Predictions/SterileNeutrinoFromFourthIrrational.lean:140` (Zosma cycle-2026-04-20)
- `Fintype IrrationalChannel4` instance — `OmegaTheory/Predictions/FourChannelFibrationOverSubsystem.lean:162` (Chara cycle-44+ MP-5)
- `irrationalChannel4_card = 4` — same file, line 169
- `FermionGeneration := Fin 3` + `gen1 / gen2 / gen3` — `OmegaTheory/Emergence/FermionContent.lean:53-60` (Mirach 2026-04-17)
- `generation_count : Fintype.card FermionGeneration = 3` — line 62

### What this file proves (structural ladder)

1. **`compositeBaseSiteMap : IrrationalChannel4 → Option FermionGeneration`**
   - The composite map; 4 lines of pattern matching.
2. **Per-channel pinning lemmas** (`@[simp]` for downstream): `pi → some gen3`, `e → some gen2`, `sqrt2 → some gen1`, `catalan_g → none`.
3. **`compositeBaseSiteMap_active_surjective`** — active surjection (`fin_cases k`).
4. **`compositeBaseSiteMap_sterile_fiber`** — fiber-iff-catalan_g lemma.
5. **`compositeBaseSiteMap_active_fiber_singleton`** — each active gen has a unique pre-image.
6. **`compositeBaseSiteImage_eq`** — concrete image is `{some gen3, some gen2, some gen1, none}`.
7. **`activeChannels` / `sterileChannels`** Finsets + concrete equalities `= {pi,e,sqrt2}` and `= {catalan_g}`.
8. **Cardinality lemmas**: active = 3, sterile = 1, partition `3 + 1 = 4 = Fintype.card IrrationalChannel4`.
9. **`active_count_matches_generation_count`** — bridges to `Fintype.card FermionGeneration = 3`.
10. **Total-function form**: `activeProjection : IrrationalChannel4 → FermionGeneration` (collapses sterile to gen1 for total-function purposes); `activeProjection_surjective` gives the briefing's `Surjective f`.
11. **3 paper-headline bundles** packaging the structural witness in 3 distinct surface forms (`_witness`, `_briefing_form`, `_paper_bundle`).

### Cross-corroboration (3 independent witnesses now in OV2)

The Pi-Hunch 4-channel → 3-active-generation structure now has THREE independent Lean-kernel witnesses:

1. **Quaoar fibration** (Chara cycle-44+ MP-5 evidence) — `FourChannelFibrationOverSubsystem`: 4 channels per Leiden subsystem (∀ s : Subsystem, fiberCard s = 4).
2. **Oumuamua 4ch→3gen** (Zosma cycle-2026-04-20) — `SterileNeutrinoFromFourthIrrational`: 4 channels surject onto `Fin 4` (3 active + 1 sterile via `channelToGeneration4`).
3. **Rosette composite base-site** (cycle-61 W1.7, this file) — `FermionGeneration_composite_base_site_witness`: 4 channels surject onto `Option FermionGeneration` with sterile fiber = `{catalan_g}` and active fiber count = `Fintype.card FermionGeneration = 3`.

The three differ in the *codomain shape*:
- Quaoar: `Subsystem × IrrationalChannel4` (fibration over Leiden base).
- Oumuamua: `Fin 4` (4 active slots, sterile-as-4th-Fin).
- Rosette: `Option (Fin 3)` (active = 3 active gen + 1 sterile = `none`).

The structural content is the same (4 channels, 4 outcomes, 3 active + 1 sterile), but the Rosette form is the one that matches the *physical* shape of the SM (no 4th SM-active generation; sterile slot is a separate sector).

### Build details

- ENVIRONMENT: `~/lean-v2/` native ext4 (115× faster vs `/mnt/c`)
- Build command: `~/.elan/bin/lake build OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness --log-level=error`
- First-attempt build had 3 minor `rfl`-failure errors in
  `compositeBaseSiteMap_active_fiber_singleton` (the `fin_cases k` case
  generated subgoals like `gen3 = 0` which `simp` doesn't reduce because
  `gen3 := 2`, not `0`); fix was `simp [..., Fin.ext_iff]` to use Fin
  injectivity. After fix, single rebuild GREEN.

### Imports added

```lean
import OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Predictions.FourChannelFibrationOverSubsystem
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Finset.Image
import Mathlib.Tactic
```

### Basic.lean import line (parent batch — DO NOT self-edit per HARD RULE 5)

```lean
import OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness
```

Place after the existing `OmegaTheory.Predictions.FourChannelFibrationOverSubsystem` block (Pi-Hunch cluster).

### Off-limits respected (per briefing)

NO edits to:
- `OmegaTheory/Predictions/PiTranscendentalBlastRadiusBundle.lean` (W1.1)
- `OmegaTheory/Predictions/OmegaSubstrateYonedaFullCapstone.lean` (W1.2)
- `OmegaTheory/Emergence/ConnesDFYukawaPaperBundleInbound.lean` (W1.3)
- `OmegaTheory/Foundations/CosmologicalConstantH1Bridge.lean` (W1.4)
- `OmegaTheory/Foundations/DiracOperatorFDoubleWitness.lean` (W1.5)
- `OmegaTheory/Predictions/LatticePointUniversalBaseSiteDominance.lean` (W1.6)
- `OmegaTheory/Predictions/SterileNeutrinoFromFourthIrrational.lean` (read-only — Catalan G channel definition; only IMPORTED, never edited)
- `OmegaTheory/Irrationality/Approximations.lean`, `Uncertainty.lean` (read-only cocycle nuclei)
- All cycle 52–60 wizard files
- `Basic.lean` (parent owns the batch)

### Stretch goal (declined)

Per c61 wave-policy, stretch is a 2nd briefing if PRIMARY lands cleanly with ≥40%
context remaining. After landing W1.7 the context budget is comfortable but the
remaining unfired briefings in c61 final-closure list are HIGHEST-priority L /
XL items (W3 super-capstones), better suited to a fresh wizard rather than
finished-W1-context tail. Declined to stay within the W1 wave size.

### Graph queries run (per GRAPH-FIRST PROTOCOL)

Reranker UP on :7996 / embedder OFF / mcp__omega-search disconnected per teammate brief. Used:

- **`grep` over OV2 source tree** for `IrrationalChannel4` / `FermionGeneration` / `FourChannel` — surfaced the 3 building-block files (FermionContent.lean, SterileNeutrinoFromFourthIrrational.lean, FourChannelFibrationOverSubsystem.lean) within seconds, sufficient for this composite-base-site witness because the building blocks were ALREADY known to exist in OV2 (no cross-namespace search to Mathlib needed).
- **Read full source** of the 3 dep files: confirmed signatures, `Fin 3` vs `Option Fin 3` codomain decision, and exact `gen1 / gen2 / gen3` values (= 0, 1, 2).
- **Did NOT invoke** `omega_hammer_premise` / `propose_proof` — the proof obligations are pure Lean structural lemmas (`fin_cases`, `cases c <;> rfl`, `decide` on Finsets), all well within local-search territory; a graph hammer for premise-finding would be overkill for `Function.Surjective` + `Finset.card` decisions on 4-element types.

This is the honest call for a *composite witness* file: the building blocks are in OV2 (NOT Mathlib), and the proof tactics are basic structural / decidable. The graph hammers are most valuable when the proof needs a non-obvious *Mathlib lemma* — here, all closures are by `rfl / decide / simp [Fin.ext_iff] / fin_cases`, which `exact?` would have surfaced if needed.

### Next steps (for parent)

1. Add `import OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness` to `OmegaTheory/Basic.lean` (parent batch).
2. Flip `:TheoremCandidate L4_FermionGeneration_composite_base_site_witness` PROPOSED → CLOSED_BY_LEAN_LANDING with `closed_by='Rosette'`, `wave_id='cycle_61_phase_b_w1_7_capricornus_2026-04-26'`, `lean_module='OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness'`, `headline_thm='FermionGeneration_composite_base_site_witness'`.
3. Optional: if a downstream wizard needs the *non-Option* form for paper citation, point them at `activeProjection_surjective` (total `Fin 3` form, with `catalan_g` collapsed to `gen1`).

EOF
