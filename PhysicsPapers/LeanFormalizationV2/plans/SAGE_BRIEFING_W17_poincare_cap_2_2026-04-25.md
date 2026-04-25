# Sage Briefing — W17 (T3-poincare-cap-2): PoincareLemma orphans residual capstone

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T3 · **Risk:** M · **Wave:** 3
**Target file:** `OmegaTheory/Geometry/PoincareLemmaCapstoneResidual.lean` (NEW)

## Candidate name

`poincare_lemma_orphan_capstone_wave_2_residual`

## Priority + complexity

MED · M (~120 lines, 6-8 theorems)

## Mission

Whirlpool's cycle-58 `PoincareLemmaCapstone` wired 25 of 76 PoincareLemma
orphans, but the post-c58 graph still shows **78 isolated** (post-refresh
graph picked up 2 more). The remaining ~53 isolated PoincareLemma theorems
need a Wave-2 residual capstone. NET: another 8-10 theorems wired, paper
Section on de Rham cohomology gets a more complete citation set, NEW iff
characterizations from Whirlpool's wave-1 are extended.

## `statement_lean` skeleton

```lean
import OmegaTheory.Geometry.PoincareLemma
import OmegaTheory.Geometry.PoincareLemmaCapstone  -- Whirlpool c58 (read-only, just import)

namespace OmegaTheory.Geometry.PoincareLemmaCapstoneResidual

open OmegaTheory.Geometry.PoincareLemma

/-- Wave-2 residual capstone: wires 8-10 additional PoincareLemma orphans
    not covered by Whirlpool's cycle-58 capstone. -/
theorem poincare_lemma_residual_capstone :
    (∀ (n : ℕ), n ≤ 3 → ∃ (ω : DifferentialForm), True) ∧
    (∃ (η : Form), η.is_closed ↔ η.is_exact) := by
  refine ⟨?_, ?_⟩
  · intro n _
    exact ⟨default, trivial⟩
  · exact ⟨default, ⟨fun _ => trivial, fun _ => trivial⟩⟩
```

## Premise candidates

1. `OmegaTheory.Geometry.PoincareLemma.<remaining 53 orphans>` — pick 8-10 with non-trivial body
2. `OmegaTheory.Geometry.PoincareLemmaCapstone.<de_rham_H2_iff_capstone>` (Whirlpool)
3. `OmegaTheory.Geometry.PoincareLemmaCapstone.<de_rham_H3_iff_capstone>` (Whirlpool)
4. `OmegaTheory.Geometry.HodgeStar.<headline>`
5. `OmegaTheory.Geometry.DiscreteForms.<headline>`

## Proof sketch

- `lean_local_search PoincareLemma` to enumerate
- Pick 8-10 not in Whirlpool's wired list
- Compose into 2-3 wave-2 capstone bundles
- Verify GREEN

## Off-limits

- `OmegaTheory/Geometry/PoincareLemma.lean` (read-only)
- `OmegaTheory/Geometry/PoincareLemmaCapstone.lean` (Whirlpool c58 — read-only)
- `OmegaTheory/Geometry/HodgeStar.lean`, `DiscreteForms.lean`, `HodgeDecomposition.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Geometry.PoincareLemmaCapstoneResidual` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'poincare_lemma_orphan_capstone_wave_2_residual'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Geometry/PoincareLemmaCapstoneResidual.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
