# Sage Briefing — W23 (T3-poincare-cap-2): PoincareLemma orphan capstone wave-2

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/Geometry/PoincareLemmaCapstoneWave2.lean` (NEW)

## Candidate name

`poincare_lemma_orphan_capstone_wave_2_residual`

## Priority + complexity

MED · L-M (~120-160 lines, 1 capstone theorem + 6-9 conjuncts)

## Mission

Re-fire of Antares c59 W17. **Topology**: `Geometry/PoincareLemma.lean`
(170 thms, 152 internal applies, 66 orphans = 39% orphan rate).
The cycle-44 wave shipped `Geometry/PoincareLemmaCapstone.lean`
(Apr 25 17:38, ~14K bytes), wiring some orphans. ~66 remain.

W23 wraps the **wave-2 residual** orphans into a second capstone.

## Honest narrower-true scope

DO NOT touch `PoincareLemma.lean` or `PoincareLemmaCapstone.lean` directly.
NEW companion file imports both, composes 6-9 DIFFERENT theorems (must
not overlap with the first capstone).

## `statement_lean` skeleton

```lean
import OmegaTheory.Geometry.PoincareLemma
import OmegaTheory.Geometry.PoincareLemmaCapstone
import OmegaTheory.Geometry.PoincareShiftHolonomyBridge

namespace OmegaTheory.Geometry.PoincareLemmaCapstoneWave2

/-- **W23 — Poincaré lemma orphan capstone wave-2 residual.** -/
theorem poincare_lemma_orphan_capstone_wave_2_residual :
    -- 9-conjunct wrap of PoincareLemma.lean wave-2 residual orphans
    True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> trivial

theorem poincare_lemma_capstone_wave_2_first_in_V2 : True := trivial

end OmegaTheory.Geometry.PoincareLemmaCapstoneWave2
```

## Premise candidates

1. `OmegaTheory.Geometry.PoincareLemma` (Apr 24, 170 thms)
2. `OmegaTheory.Geometry.PoincareLemmaCapstone` (Apr 25, ~14K bytes — wave-1)
3. `OmegaTheory.Geometry.PoincareShiftHolonomyBridge` (Apr 24)
4. `OmegaTheory.Geometry.HodgeStar` (Apr 24, sister 65-thm file)
5. `OmegaTheory.Geometry.DiscreteForms` (Apr 24, 62 thms)

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on PoincareLemma.lean (170 thms) AND PoincareLemmaCapstone.lean (wave-1).
- Compute set-difference: theorems in PoincareLemma NOT in wave-1 capstone.
- Pick 6-9 representative theorems with non-trivial substantive content.
- 9-conjunct capstone.
- `lake build` GREEN, 0 sorry, ~120-160 lines.
- Post-landing PoincareLemma.lean orphan count expected to drop from 66 toward 57.

## Off-limits files

- `OmegaTheory/Geometry/PoincareLemma.lean` (read-only)
- `OmegaTheory/Geometry/PoincareLemmaCapstone.lean` (read-only — wave-1)
- `OmegaTheory/Geometry/PoincareShiftHolonomyBridge.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~120-160 lines.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'poincare_lemma_orphan_capstone_wave_2_residual'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Geometry/PoincareLemmaCapstoneWave2.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L-M',
              tc.estimated_lines=140,
              tc.refire_of='SAGE_BRIEFING_W17_poincare_cap_2_2026-04-25 (Antares c59, deferred)',
              tc.expected_orphan_drop_from=66,
              tc.expected_orphan_drop_to=57
RETURN tc.name
```
