# Sage Briefing — W14 (T2-pi-blast-radius-lean): Lean-side audit registry

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T2 · **Risk:** L · **Wave:** 2
**Target file:** `OmegaTheory/Irrationality/HermitePade/PiTranscendentalBlastRadiusAudit.lean` (NEW)

## Candidate name

`pi_transcendental_blast_radius_audit_dump_csv_v2`

## Priority + complexity

LOW-MED · L (~80-130 lines, 4-5 theorems + auditing CSV constants)

## Mission

Re-fire of Antares c59 W14 (was deferred). Programmatically register the
direct-consumer set + transitive-1-hop descent of `Real.pi_transcendental`
as Lean `def directConsumers : List String` constants, with `decide`-style
axiom-footprint audits. Provides the cycles 60-62 Path-A wizards a single
import-path entry point: "this is the exact axiom-blast-radius the next
narrowing wave must close."

## Honest narrower-true scope

Brief is structurally simple — most content is `def name : List String := […]`
plus `decide`-style decidability tags. Hardest part: get the consumer list
RIGHT (cross-reference `axiom_audit` MCP output + manual greps). Falls into
the "Lean-as-data-registry" pattern.

## `statement_lean` skeleton

```lean
import Mathlib.Data.Real.Pi.Irrational
import OmegaTheory.Irrationality.HermitePade.PiStratum

namespace OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAudit

/-- Audit registry: direct APPLIES consumers of `Real.pi_transcendental`
    as of cycle-60 (Sagittarius). Source: graph query
    `MATCH (t:Theorem)-[:APPLIES]->(:Axiom {name:'Real.pi_transcendental'})`. -/
def directConsumers : List String := [
  "OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional",
  "OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental",
  "OmegaTheory.Irrationality.HermitePade.PiStratum.pi_stratum_integer"
]

/-- Audit registry: transitive consumers (depth ≤ 2 from direct). -/
def transitiveConsumers : List String := [
  "OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline.<3-conjunct>",
  "OmegaTheory.IrrationalityClasses.<ic-three-constants-transcendental>",
  "OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed.<bundle>"
]

/-- Audit claim: direct blast radius is exactly 3. -/
theorem pi_transcendental_direct_consumer_count :
    directConsumers.length = 3 := by decide

/-- Audit claim: transitive blast radius is bounded ≤ 5. -/
theorem pi_transcendental_transitive_count_bounded :
    transitiveConsumers.length ≤ 5 := by decide

/-- Audit claim: blast radius is non-empty (the axiom IS used somewhere). -/
theorem pi_transcendental_blast_radius_nonempty :
    directConsumers.length ≥ 1 := by decide

/-- **Headline** — Real.pi_transcendental blast-radius audit certified
    at cycle-60 (Sagittarius). Three direct consumers + bounded transitive
    descent. The axiom-narrowing ladder (cycle-50 W9 D=1, c51 W8 D=2, c52
    W10 D=3, c59 W9 D=4, c60 W12 D=5) progressively replaces these
    direct call sites with hypothesis-conditional theorems. -/
theorem pi_transcendental_blast_radius_audit_v2 :
    directConsumers.length = 3
      ∧ transitiveConsumers.length ≤ 5
      ∧ directConsumers.length ≥ 1 := by
  exact ⟨pi_transcendental_direct_consumer_count,
         pi_transcendental_transitive_count_bounded,
         pi_transcendental_blast_radius_nonempty⟩

end OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAudit
```

## Premise candidates

1. `Mathlib.Data.Real.Pi.Irrational` (transitive Mathlib import)
2. `OmegaTheory.Irrationality.HermitePade.PiStratum` (axiom site)
3. `decide` tactic (for `List.length = 3` style claims)
4. Neo4j `:Axiom`/:APPLIES query (sage runs at brief-write time, not part of Lean)
5. `mcp__omega-orchestrator__axiom_audit(targets=['Real.pi_transcendental'])` for ground-truth

## Proof sketch (≤6 bullets)

- Define `directConsumers` and `transitiveConsumers` as `List String` constants.
- Prove three count-bound theorems via `decide`.
- Compose into headline `_audit_v2` 3-conjunct.
- `lake build` GREEN, 0 sorry, axiom set = Lean core only.
- Sage cross-checks counts via `MATCH (t:Theorem)-[:APPLIES]->(:Axiom {name:'Real.pi_transcendental'}) RETURN t.name`.
- File is **data registry**, not a proof file — useful for cycles 61-62 Path-A wizards as single-source-of-truth.

## Off-limits files

- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` (axiom site — read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, ~80-130 lines, axiom set Lean core.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'pi_transcendental_blast_radius_audit_dump_csv_v2'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='LOW-MED', tc.track='T2',
              tc.target_file='OmegaTheory/Irrationality/HermitePade/PiTranscendentalBlastRadiusAudit.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L',
              tc.estimated_lines=110,
              tc.refire_of='SAGE_BRIEFING_W14_pi_blast_radius_2026-04-25 (Antares c59, deferred)'
RETURN tc.name
```
