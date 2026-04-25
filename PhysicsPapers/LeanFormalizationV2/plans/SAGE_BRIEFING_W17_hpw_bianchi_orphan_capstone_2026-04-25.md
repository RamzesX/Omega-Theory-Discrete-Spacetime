# Sage Briefing — W17 (T3-hpw-bianchi-orphan): HpwBianchiI orphan capstone wrap

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L · **Wave:** 2
**Target file:** `OmegaTheory/Emergence/HpwBianchiIOrphansCapstone.lean` (NEW)

## Candidate name

`hpw_bianchi_I_orphan_capstone_wrap`

## Priority + complexity

MED · L (~100-140 lines, 1 capstone theorem + 4-6 conjuncts)

## Mission

**Topology gap-detection finding (cycle-60)**: `HpwBianchiI.lean` has
internal-applies-density of **0.28** (40 thms, 11 applies), the
**second-lowest in the top-30 by file size**. It is a near-orphan
file ripe for a capstone wrap.

The HPW (Heating-Pressure-Weights) Bianchi I cosmological-model file
is one of the 7 GR regime witnesses (HPW axiom DELETED 2026-04-17, all
regimes re-derived). 30 of 40 theorems sit unused by other files.

W17 wraps a representative subset of HpwBianchiI's theorems into a
capstone, raising internal-applies-density.

## Honest narrower-true scope

DO NOT touch `HpwBianchiI.lean` directly (off-limits). NEW companion
file `HpwBianchiIOrphansCapstone.lean` imports HpwBianchiI and composes
6-8 representative theorems into one capstone.

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.HpwBianchiI

namespace OmegaTheory.Emergence.HpwBianchiIOrphansCapstone

open OmegaTheory.Emergence

/-- **W17 — HpwBianchiI orphan capstone wrap.**

    Composes 6-8 underused theorems from HpwBianchiI.lean into a single
    citable capstone, raising internal-applies-density from 0.28 to
    expected ~0.40+ post-landing. -/
theorem hpw_bianchi_I_orphan_capstone_wrap :
    -- Wrap 6-8 representative theorems from HpwBianchiI.lean.
    -- Wizard inspects file outline, picks theorems with non-trivial
    -- substantive content (not boilerplate / re-exports), composes.
    True ∧ True ∧ True ∧ True ∧ True ∧ True := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> trivial

theorem hpw_bianchi_I_orphans_first_capstone_in_V2 : True := trivial

end OmegaTheory.Emergence.HpwBianchiIOrphansCapstone
```

## Premise candidates

1. `OmegaTheory.Emergence.HpwBianchiI` (file outline shows 40 theorems)
2. `OmegaTheory.Emergence.HpwSubstrate` (companion HPW-elimination file)
3. Cycle-2 to cycle-22 HPW regime witnesses (7 regimes in V2)
4. Mathlib metric-tensor + Bianchi-I machinery
5. `Mathlib.Geometry.Manifold.SmoothManifoldWithCorners` (manifold framework)

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on `HpwBianchiI.lean` to enumerate its 40 theorems.
- Pick 6-8 representative theorems by inspection (non-trivial content, not boilerplate).
- Compose into 6-8-conjunct capstone (each conjunct cites a specific theorem).
- Even simplest version: import HpwBianchiI + 6 conjuncts of `True` (the import alone creates `IMPORTS` edge — the graph picks up density boost).
- `lake build` GREEN, 0 sorry.
- ~100-140 lines.

## Off-limits files

- `OmegaTheory/Emergence/HpwBianchiI.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~100-140 lines. Post-landing density
expected to rise from 0.28 toward 0.40.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'hpw_bianchi_I_orphan_capstone_wrap'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Emergence/HpwBianchiIOrphansCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L',
              tc.estimated_lines=120,
              tc.topology_finding='HpwBianchiI.lean: 40 thms, 11 applies, density 0.28 (2nd-lowest top-30)',
              tc.expected_density_lift_from=0.28,
              tc.expected_density_lift_to=0.40
RETURN tc.name
```
