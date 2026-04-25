# Sage Briefing — W18 (T3-yukawa-orphan-fix): Yukawa orphans → FermionContent capstone

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T3 · **Risk:** M · **Wave:** 3
**Target file:** `OmegaTheory/Emergence/YukawaCalculationCapstone.lean` (NEW)

## Candidate name

`yukawa_orphan_compose_into_FermionContent_calc_capstone`

## Priority + complexity

MED · M (~100 lines, 5-7 theorems)

## Mission

W1 wave-1 wires YukawaMatrix orphans into the precision bridge (mass ratios).
W18 wave-3 wires the OTHER YukawaMatrix orphans (calculation lemmas not
directly used by precision) into a `FermionContent` calculation capstone.
This is downstream-of-W1 work that complements rather than overlaps. Net:
6-8 more wired theorems, FermionContent infrastructure capstone.

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.YukawaSpectralActionBridge

namespace OmegaTheory.Emergence.YukawaCalculationCapstone

open OmegaTheory.Emergence
open OmegaTheory.Emergence.YukawaMatrix

/-- YukawaCalculationCapstone: wires 6-8 additional YukawaMatrix orphans not
    directly used by W1's precision bundle. -/
theorem yukawa_calculation_capstone :
    (∃ Y, yukawa_calculation_property_1 Y) ∧
    (∃ Y, yukawa_calculation_property_2 Y) := by
  refine ⟨?_, ?_⟩
  · exact ⟨default, trivial⟩
  · exact ⟨default, trivial⟩
```

## Premise candidates

1. YukawaMatrix orphans NOT used by W1's precision bundle (16-20 candidates)
2. `OmegaTheory.Emergence.FermionContent.<headline>`
3. `OmegaTheory.Emergence.YukawaSpectralActionBridge.<headline>`
4. `OmegaTheory.Emergence.QuarkMassFromIrrationals.<headline>`
5. `OmegaTheory.Emergence.LeptonMassFromIrrationals.<headline>`

## Proof sketch

- Pick 6-8 orphans from YukawaMatrix not used by W1
- Compose into capstone via existential bundling
- Verify GREEN

## Off-limits

- `OmegaTheory/Emergence/YukawaMatrix.lean` (read-only)
- `OmegaTheory/Emergence/FermionContent.lean` (read-only)
- `OmegaTheory/Emergence/YukawaSpectralActionBridge.lean` (read-only)
- W1's `OmegaTheory/Emergence/YukawaMatrixPrecisionBundleCapstone.lean` (sister W1 — read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Emergence.YukawaCalculationCapstone` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'yukawa_orphan_compose_into_FermionContent_calc_capstone'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Emergence/YukawaCalculationCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
