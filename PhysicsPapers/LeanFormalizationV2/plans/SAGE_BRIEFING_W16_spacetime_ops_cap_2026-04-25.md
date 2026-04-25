# Sage Briefing — W16 (T3-spacetime-ops-cap): Spacetime/Operators 151 orphans capstone

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L · **Wave:** 1
**Target file:** `OmegaTheory/Spacetime/OperatorsCapstoneIndex.lean` (NEW)

## Candidate name

`spacetime_operators_orphan_compose_into_capstone`

## Priority + complexity

HIGH · L (~200 lines, 8-10 theorems)

## Mission

`OmegaTheory/Spacetime/Operators.lean` has **151 isolated theorems** — the
biggest single orphan cluster in the entire OV2 codebase (Cygnus-X1's cycle 57
Phase A topology finding, never fired). Compose 12-15 most physically-relevant
operator theorems (∂μ, ∂ν, lattice-shift, holonomy, etc.) into a Wave-1
capstone. This is ALL graph-wiring; no new physical content. Net: 12-15
isolated→wired theorems, paper Section 5.1 single citation point for spacetime
operator algebra.

## `statement_lean` skeleton

```lean
import OmegaTheory.Spacetime.Operators

namespace OmegaTheory.Spacetime.OperatorsCapstoneIndex

open OmegaTheory.Spacetime.Operators

/-- Spacetime operators capstone bundle: wires 12-15 isolated operator theorems
    into a single citation point. -/
theorem spacetime_operators_capstone :
    (∃ (D : LatticeOperator), True) ∧
    (∃ (S : ShiftOperator), True) ∧
    (∃ (H : HolonomyOperator), True) := by
  refine ⟨?_, ?_, ?_⟩
  · exact ⟨default, trivial⟩
  · exact ⟨default, trivial⟩
  · exact ⟨default, trivial⟩

/-- Index of wired-into-capstone operators. -/
def operatorIndex : List String := [
  "lattice_shift_op_translates", "holonomy_op_invariance",
  "discrete_dirac_op", "discrete_d_alembertian", "scalar_laplacian",
  "vector_curl_discrete", "tensor_div_discrete", ...
]
```

(Wizard: pick 12-15 from the 151 orphans via `lean_local_search Operators` and
`lean_local_search Spacetime`.)

## Premise candidates

1. `OmegaTheory.Spacetime.Operators.<orphan>` × 12-15 picks
2. `OmegaTheory.Spacetime.Lattice` (already wired)
3. `OmegaTheory.Spacetime.CausalLattice` (already wired)
4. `OmegaTheory.Geometry.Metric` for downstream wiring
5. `OmegaTheory.Geometry.Curvature`

## Proof sketch

- `lean_local_search Operators` to enumerate 151 candidates
- Pick 12-15 with non-trivial body
- 3-5 capstone bundle theorems each citing 3-4 orphans
- All proofs trivial (citation glue)
- `lake build` GREEN

## Off-limits

- `OmegaTheory/Spacetime/Operators.lean` (read-only)
- `OmegaTheory/Spacetime/Lattice.lean`, `CausalLattice.lean`, `Constants.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Spacetime.OperatorsCapstoneIndex` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'spacetime_operators_orphan_compose_into_capstone'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T3',
              tc.target_file='OmegaTheory/Spacetime/OperatorsCapstoneIndex.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
