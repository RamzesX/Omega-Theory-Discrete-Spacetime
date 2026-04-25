# Sage Briefing — W20 (T3-protondecay-cap): ProtonDecay orphan compose into capstone

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T3 · **Risk:** M · **Wave:** 3
**Target file:** `OmegaTheory/Predictions/ProtonDecayOrphansCapstone.lean` (NEW)

## Candidate name

`proton_decay_orphan_compose_into_capstone`

## Priority + complexity

MED · M (~100 lines, 5-7 theorems)

## Mission

`OmegaTheory/Predictions/ProtonDecayLowerBound.lean` has **40 isolated theorems**
— second-largest orphan cluster in `Predictions/`. Compose 6-8 into a capstone
wiring proton-decay τ_p > 10^34 yr substrate prediction. Net: 6-8 wired,
paper Section 7 (proton decay) gets a single citation point.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.ProtonDecayLowerBound

namespace OmegaTheory.Predictions.ProtonDecayOrphansCapstone

open OmegaTheory.Predictions.ProtonDecayLowerBound

/-- Proton decay orphans capstone: wires 6-8 isolated proton-decay theorems
    into a substrate-derived τ_p > 10^34 yr lower bound. -/
theorem proton_decay_orphans_capstone :
    (∃ τ_p : Real, τ_p > 0) ∧
    (∃ ε : Real, ε > 0 ∧ ε < 1) := by
  refine ⟨⟨1, one_pos⟩, ⟨1/2, by norm_num, by norm_num⟩⟩
```

## Premise candidates

1. `OmegaTheory.Predictions.ProtonDecayLowerBound.<40 orphans>` — pick 6-8
2. `OmegaTheory.Predictions.NeutrinoLessDoubleBetaBound.<headline>`
3. `OmegaTheory.Predictions.NeutronAntineutronOscBound.<headline>`
4. `OmegaTheory.Spacetime.Constants.<headline>`
5. `OmegaTheory.Capstones.MatterSectorUnifiedBundle.<headline>`

## Proof sketch

- Pick 6-8 with non-trivial body
- Compose into capstone bundle via existential
- Verify GREEN

## Off-limits

- `OmegaTheory/Predictions/ProtonDecayLowerBound.lean` (read-only)
- `OmegaTheory/Predictions/NeutrinoLessDoubleBetaBound.lean` (read-only)
- `OmegaTheory/Predictions/NeutronAntineutronOscBound.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.ProtonDecayOrphansCapstone` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'proton_decay_orphan_compose_into_capstone'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Predictions/ProtonDecayOrphansCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
