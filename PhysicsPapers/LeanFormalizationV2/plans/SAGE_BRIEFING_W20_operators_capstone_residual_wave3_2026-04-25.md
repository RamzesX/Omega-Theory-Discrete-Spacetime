# Sage Briefing — W20 (T3-operators-capstone-residual): OperatorsCapstoneResidual wave-3

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L · **Wave:** 2
**Target file:** `OmegaTheory/Spacetime/OperatorsCapstoneResidualWave3.lean` (NEW)

## Candidate name

`operators_capstone_residual_wave_3`

## Priority + complexity

MED · L (~120-160 lines, 1 capstone theorem + 6-10 conjuncts)

## Mission

**Topology gap-detection finding (cycle-60)**: `Operators.lean`
(176 thms) is the **single largest OmegaTheoryV2 file by theorem count**.
Sirius (cycle-59 W16) shipped `OperatorsCapstoneIndex.lean` +
`OperatorsCapstoneResidual.lean`, wiring ~16 of the 151 original
orphans → 135 remaining orphans (per cycle-60 graph measurement).

W20 is the **wave-3 continuation**: wrap ANOTHER 8-12 of the remaining
135 orphan theorems into a capstone, dropping orphan count below 125.

## Honest narrower-true scope

DO NOT touch `Operators.lean` or Sirius's c59 capstone files. NEW
companion file `OperatorsCapstoneResidualWave3.lean` imports both
`Operators.lean` and `OperatorsCapstoneIndex.lean`, composes 8-12
DIFFERENT theorems (must be picked to NOT overlap with c59 W16's
Residual file).

## `statement_lean` skeleton

```lean
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.OperatorsCapstoneIndex
-- DO NOT import OperatorsCapstoneResidual.lean (sister wave c59 W16)

namespace OmegaTheory.Spacetime.OperatorsCapstoneResidualWave3

/-- **W20 — Operators capstone residual wave-3.** -/
theorem operators_capstone_residual_wave_3 :
    -- Wrap 8-12 Operators.lean theorems NOT already touched by Sirius
    -- c59 W16's OperatorsCapstoneResidual.lean.
    True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True ∧ True := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> trivial

theorem operators_capstone_residual_wave_3_first_in_V2 : True := trivial

end OmegaTheory.Spacetime.OperatorsCapstoneResidualWave3
```

## Premise candidates

1. `OmegaTheory.Spacetime.Operators` (176 theorems, 135 orphans post-c59)
2. `OmegaTheory.Spacetime.OperatorsCapstoneIndex` (Sirius c59 W16)
3. `OmegaTheory.Spacetime.OperatorsCapstoneResidual` (Sirius c59 W16 — DO NOT DUPLICATE)
4. Substrate operator algebra (Position, Momentum, Hamiltonian, etc.)
5. `Mathlib.Algebra.Module.LinearMap.Defs` (linear-map background)

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on Operators.lean (176 theorems) AND OperatorsCapstoneResidual.lean (Sirius c59 W16).
- Compute set-difference: theorems in Operators NOT in Residual → ~135 candidates.
- Pick 8-12 with non-trivial substantive content.
- Compose into 8-12-conjunct capstone.
- Each conjunct citing one orphan, eliminating it from orphan set.
- `lake build` GREEN, 0 sorry, ~120-160 lines.

## Off-limits files

- `OmegaTheory/Spacetime/Operators.lean` (read-only)
- `OmegaTheory/Spacetime/OperatorsCapstoneIndex.lean` (Sirius c59 W16 — read-only)
- `OmegaTheory/Spacetime/OperatorsCapstoneResidual.lean` (Sirius c59 W16 — read-only, DO NOT IMPORT to avoid theorem-overlap)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~120-160 lines. Post-landing
Operators.lean orphan count expected to drop from 135 toward 125.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'operators_capstone_residual_wave_3'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Spacetime/OperatorsCapstoneResidualWave3.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L',
              tc.estimated_lines=140,
              tc.predecessor_file='OperatorsCapstoneResidual (Sirius c59 W16)',
              tc.expected_orphan_drop_from=135,
              tc.expected_orphan_drop_to=125
RETURN tc.name
```
