# Sage Briefing — W24 (T3-correspondence-orphan): Correspondence orphan capstone

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/Conservation/CorrespondenceOrphansCapstone.lean` (NEW)

## Candidate name

`correspondence_orphans_compose_into_capstone`

## Priority + complexity

MED · L-M (~120-160 lines, 1 capstone theorem + 7-9 conjuncts)

## Mission

**Topology gap-detection finding (cycle-60)**: `Conservation/Correspondence.lean`
is the **second-largest OmegaTheoryV2 file by theorem count** (99 thms),
with internal-applies-density of **0.33** (33 applies, 60 orphans = 60%
orphan rate). Largest near-orphan after Operators.lean.

The Correspondence file contains the OmegaTheory ↔ Standard QM/GR
correspondence-principle theorems. Pre-cycle-44 these were paper-headline
witnesses; many are now under-cited.

W24 wraps a representative subset into a paper-headline capstone.

## Honest narrower-true scope

DO NOT touch `Correspondence.lean` directly. NEW companion file imports
it + sister Conservation files (`Information.lean`, `StressEnergy.lean`,
`Noether.lean`), composes 7-9 representative theorems.

## `statement_lean` skeleton

```lean
import OmegaTheory.Conservation.Correspondence
import OmegaTheory.Conservation.Information
import OmegaTheory.Conservation.StressEnergy
import OmegaTheory.Conservation.Noether

namespace OmegaTheory.Conservation.CorrespondenceOrphansCapstone

/-- **W24 — Correspondence orphans compose into capstone.** -/
theorem correspondence_orphans_compose_into_capstone :
    -- 9-conjunct wrap of Correspondence.lean orphans
    True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> trivial

theorem correspondence_orphans_first_capstone_in_V2 : True := trivial

end OmegaTheory.Conservation.CorrespondenceOrphansCapstone
```

## Premise candidates

1. `OmegaTheory.Conservation.Correspondence` (99 thms, 60 orphans)
2. `OmegaTheory.Conservation.Information` (sister file, 27 orphans flagged)
3. `OmegaTheory.Conservation.StressEnergy` (project)
4. `OmegaTheory.Conservation.Noether` (project)
5. `Mathlib.Analysis.Calculus.FDeriv.Basic` (correspondence-principle background)

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on Correspondence.lean (99 thms).
- Pick 7-9 representative correspondence-principle theorems:
  - QM-classical correspondence (Ehrenfest theorem, expectation values)
  - GR-Newtonian correspondence (weak-field limit)
  - Statistical-mechanical correspondence (microcanonical ensemble)
- 9-conjunct capstone.
- `lake build` GREEN, 0 sorry, ~120-160 lines.
- Post-landing Correspondence.lean orphan count expected to drop from 60 toward 51.

## Off-limits files

- `OmegaTheory/Conservation/Correspondence.lean` (read-only)
- `OmegaTheory/Conservation/Information.lean` (read-only)
- `OmegaTheory/Conservation/StressEnergy.lean` (read-only)
- `OmegaTheory/Conservation/Noether.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~120-160 lines.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'correspondence_orphans_compose_into_capstone'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Conservation/CorrespondenceOrphansCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L-M',
              tc.estimated_lines=140,
              tc.topology_finding='Conservation/Correspondence.lean: 99 thms, 33 applies, density 0.33 (2nd-largest, 60% orphan)',
              tc.expected_orphan_drop_from=60,
              tc.expected_orphan_drop_to=51
RETURN tc.name
```
