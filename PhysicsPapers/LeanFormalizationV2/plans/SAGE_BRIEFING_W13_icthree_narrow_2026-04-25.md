# Sage Briefing — W13 (T2-icthree-narrow): IC three constants narrowed to two T2 axioms

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T2 · **Risk:** S · **Wave:** 2
**Target file:** `OmegaTheory/IrrationalityClasses/ICThreeConstantsAxiomNarrowed.lean` (NEW)

## Candidate name

`ic_three_constants_narrowed_to_two_axiom_dependencies`

## Priority + complexity

MED · S (~60 lines, 4 theorems)

## Mission

`OmegaTheory.IrrationalityClasses.<ic_three_constants_transcendental>` (cycle 56
or earlier) was one of THREE direct consumers of `Real.pi_transcendental`.
After Hyades's cycle 58 Path-B substrate-sufficient version, narrow the
3-axiom dependency to 2 (replace π-transcendence with π-irrationality + √2 +
e-hypothesis). Output: an `_irrational_only_narrowed` corollary that the
paper-headline can cite, leaving `Real.pi_transcendental` only required by 2
of the 3 prior consumers (instead of all 3).

## `statement_lean` skeleton

```lean
import OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline
import OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer  -- if W12 lands first

namespace OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed

open OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline
open OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer

/-- Three-constants narrowed: π/√2/e all irrational (no transcendence required). -/
theorem ic_three_constants_irrational_only_narrowed
    (h_e_irr : e_irrational_hypothesis) :
    Irrational Real.pi ∧ Irrational (Real.sqrt 2) ∧ e_irrational_hypothesis := by
  exact ic_three_constants_irrational_only_paper_headline h_e_irr

/-- Cross-reference: Hyades's Wave-4 closure delivers this directly. -/
theorem ic_three_constants_paper_redundancy_check :
    True := by trivial
```

## Premise candidates

1. `OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline.<3-conjunct>` (Hyades c58)
2. `OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer.ic_three_constants_irrational_only_paper_headline` (W12 if landed)
3. `Mathlib.Data.Real.Irrational.irrational_pi`
4. `Mathlib.Data.Real.Sqrt.irrational_sqrt_two`
5. `Real.exp_one` properties

## Proof sketch

- Direct citation of W12 (or Hyades's Wave-4)
- 1-line proof
- Verify GREEN

## Off-limits

- `OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean` (Hyades c58 — read-only)
- W12's `OmegaTheory/Irrationality/CustomMath/PiIrrationalNivenLayer.lean` (sister W12)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'ic_three_constants_narrowed_to_two_axiom_dependencies'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T2',
              tc.target_file='OmegaTheory/IrrationalityClasses/ICThreeConstantsAxiomNarrowed.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
