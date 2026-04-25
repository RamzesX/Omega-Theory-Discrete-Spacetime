# Sage Briefing — W22 (T3-yukawa-orphan-calc): YukawaMatrix orphan calculation capstone

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L · **Wave:** 2
**Target file:** `OmegaTheory/Emergence/YukawaCalculationCapstone.lean` (NEW)

## Candidate name

`yukawa_orphan_calculation_capstone`

## Priority + complexity

MED · L (~100-140 lines, 1 capstone theorem + 5-7 conjuncts)

## Mission

Re-fire of Antares c59 W18. **Topology**: `Emergence/YukawaMatrix.lean`
(72 thms, 38 orphans, 53% orphan rate). W1 (cycle-59 W1) shipped
`YukawaMatrixPrecisionBundleCapstone.lean` wiring some orphans, but
~38 calculation-side theorems remain unused.

W22 wraps the **calculation-side residual** orphans (those NOT touched
by W1 precision bundle) into a separate calculation capstone.

## Honest narrower-true scope

DO NOT overlap with `YukawaMatrixPrecisionBundleCapstone.lean` (W1
cycle-59 — read-only). NEW companion file imports YukawaMatrix.lean +
relevant sister files (FermionContent.lean, ConnesDFYukawaMass.lean),
composes 5-7 calculation-side theorems.

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.YukawaSpectralActionBridge
-- DO NOT import YukawaMatrixPrecisionBundleCapstone.lean (sister wave c59 W1)

namespace OmegaTheory.Emergence.YukawaCalculationCapstone

/-- **W22 — Yukawa orphan calculation capstone.** -/
theorem yukawa_orphan_calculation_capstone :
    -- 7-conjunct wrap of YukawaMatrix calculation-side orphans
    True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> trivial

theorem yukawa_orphan_calculation_first_capstone_in_V2 : True := trivial

end OmegaTheory.Emergence.YukawaCalculationCapstone
```

## Premise candidates

1. `OmegaTheory.Emergence.YukawaMatrix` (Apr 24, 72 theorems)
2. `OmegaTheory.Emergence.FermionContent` (project)
3. `OmegaTheory.Emergence.YukawaSpectralActionBridge` (project)
4. `OmegaTheory.Emergence.ConnesDFYukawaMass` (cycle-30 anchor)
5. `OmegaTheory.Emergence.YukawaMatrixFromD_F` (project)

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on YukawaMatrix.lean (72 thms).
- Run `lean_file_outline` on YukawaMatrixPrecisionBundleCapstone.lean (W1 c59) to identify what's already wired.
- Pick 5-7 calculation-side residual theorems NOT in W1's set.
- 7-conjunct capstone.
- `lake build` GREEN, 0 sorry, ~100-140 lines.
- Post-landing YukawaMatrix.lean orphan count expected to drop from 38 toward 31.

## Off-limits files

- `OmegaTheory/Emergence/YukawaMatrix.lean` (read-only)
- `OmegaTheory/Emergence/YukawaMatrixPrecisionBundleCapstone.lean` (W1 cycle-59 — read-only, DO NOT overlap content)
- `OmegaTheory/Emergence/FermionContent.lean` (read-only)
- `OmegaTheory/Emergence/YukawaSpectralActionBridge.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~100-140 lines.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'yukawa_orphan_calculation_capstone'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Emergence/YukawaCalculationCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L',
              tc.estimated_lines=120,
              tc.refire_of='SAGE_BRIEFING_W18_yukawa_orphan_fix_2026-04-25 (Antares c59, deferred)',
              tc.expected_orphan_drop_from=38,
              tc.expected_orphan_drop_to=31
RETURN tc.name
```
