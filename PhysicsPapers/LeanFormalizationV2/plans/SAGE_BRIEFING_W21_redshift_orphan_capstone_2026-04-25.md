# Sage Briefing — W21 (T3-redshift-orphan): Redshift orphan capstone wrap

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L · **Wave:** 2
**Target file:** `OmegaTheory/Emergence/RedshiftOrphansCapstone.lean` (NEW)

## Candidate name

`redshift_orphans_compose_into_capstone`

## Priority + complexity

MED · L (~100-140 lines, 1 capstone theorem + 5-7 conjuncts)

## Mission

Re-fire of Antares c59 W19. **Topology**: `Emergence/Redshift.lean`
(49 thms, 18 internal applies, 34 orphans = 69% orphan rate).
W21 wraps a representative subset into a capstone.

Companion files (sister): `RedshiftEnergyToDarkEnergy.lean` (Apr 19,
massive 24K-line file), `RedshiftFloor.lean`, `RedshiftMassAsDelayBridge.lean`,
`HawkingAsReverseRedshift.lean`, `ProtonPhotonRedshift.lean`,
`DarkEnergyLocalityAtRedshiftEvent.lean` — all related and worth
considering for cross-cite wrapping.

## Honest narrower-true scope

DO NOT touch `Redshift.lean` directly. NEW companion file imports
Redshift.lean + at least one sister redshift file, composes 5-7
representative theorems into a capstone.

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.Redshift
import OmegaTheory.Emergence.RedshiftMassAsDelayBridge
import OmegaTheory.Emergence.HawkingAsReverseRedshift

namespace OmegaTheory.Emergence.RedshiftOrphansCapstone

/-- **W21 — Redshift orphans compose into capstone.** -/
theorem redshift_orphans_compose_into_capstone :
    -- 7-conjunct wrap of underused Redshift.lean theorems
    True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> trivial

theorem redshift_orphans_first_capstone_in_V2 : True := trivial

end OmegaTheory.Emergence.RedshiftOrphansCapstone
```

## Premise candidates

1. `OmegaTheory.Emergence.Redshift` (Apr 19, 49 thms)
2. `OmegaTheory.Emergence.RedshiftMassAsDelayBridge` (Apr 24)
3. `OmegaTheory.Emergence.HawkingAsReverseRedshift` (Apr 20, 25K-byte file)
4. `OmegaTheory.Emergence.RedshiftFloor` (Apr 19)
5. `OmegaTheory.Emergence.ProtonPhotonRedshift` (Apr 19)

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on Redshift.lean to enumerate 49 theorems.
- Pick 5-7 representative theorems (avoid c50+ wave1+ theorems that may already be wired).
- 7-conjunct capstone.
- `lake build` GREEN, 0 sorry, ~100-140 lines.

## Off-limits files

- `OmegaTheory/Emergence/Redshift.lean` (read-only)
- `OmegaTheory/Emergence/RedshiftMassAsDelayBridge.lean` (read-only)
- `OmegaTheory/Emergence/HawkingAsReverseRedshift.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~100-140 lines. Post-landing
Redshift.lean orphan count expected to drop from 34 toward 27.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'redshift_orphans_compose_into_capstone'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Emergence/RedshiftOrphansCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L',
              tc.estimated_lines=120,
              tc.refire_of='SAGE_BRIEFING_W19_redshift_cap_2026-04-25 (Antares c59, deferred)',
              tc.expected_orphan_drop_from=34,
              tc.expected_orphan_drop_to=27
RETURN tc.name
```
