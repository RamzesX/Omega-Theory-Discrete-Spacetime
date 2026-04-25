# Sage Briefing — W12 (T2-pi-niven-irr-only): Pi irrationality (Niven 1947) re-export layer

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T2 · **Risk:** S · **Wave:** 2
**Target file:** `OmegaTheory/Irrationality/CustomMath/PiIrrationalNivenLayer.lean` (NEW)

## Candidate name

`pi_irrational_only_via_niven_re_export_layer`

## Priority + complexity

MED · S (~50 lines, 3 theorems)

## Mission

Hyades's cycle-58 W4 paper-headline 3-conjunct used `irrational_pi` directly
in `Wave4LandingsHeadline.lean`. The Path-B substrate-thesis-sufficient form
needs a **single citation point** for irrationality (not transcendence), so
add a re-export wrapper layer that re-exports `irrational_pi`, `irrational_sqrt_two`,
and (conjecturally) `irrational_e` into the OV2 namespace under stable names.
Net: paper-headline footprint becomes locally citable, no NEW axioms (Niven
1947 is already in Mathlib).

## `statement_lean` skeleton

```lean
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Real.Irrational
import Mathlib.Analysis.SpecificLimits.Basic

namespace OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer

/-- Re-export: π is irrational (Niven 1947, in Mathlib as `irrational_pi`). -/
theorem pi_irrational_omega : Irrational Real.pi := irrational_pi

/-- Re-export: √2 is irrational (Mathlib `irrational_sqrt_two`). -/
theorem sqrt_two_irrational_omega : Irrational (Real.sqrt 2) := irrational_sqrt_two

/-- Re-export hypothesis hook: assumed irrational in Hyades's Wave-4 form. -/
def e_irrational_hypothesis : Prop := Irrational Real.exp 1

/-- Three-conjunct paper-headline: π/√2/e all irrational, NO `Real.pi_transcendental`. -/
theorem ic_three_constants_irrational_only_paper_headline
    (h_e_irr : e_irrational_hypothesis) :
    Irrational Real.pi ∧ Irrational (Real.sqrt 2) ∧ e_irrational_hypothesis := by
  exact ⟨pi_irrational_omega, sqrt_two_irrational_omega, h_e_irr⟩
```

## Premise candidates

1. `Mathlib.Data.Real.Irrational.irrational_pi` (Niven 1947)
2. `Mathlib.Data.Real.Sqrt.irrational_sqrt_two`
3. `Real.exp_one` (Mathlib base value)
4. `OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline` (Hyades c58 — read-only)
5. `Mathlib.Analysis.SpecificLimits.Basic`

## Proof sketch

- 3 trivial re-exports
- The 3-conjunct closes via `⟨pi_irrational_omega, sqrt_two_irrational_omega, h_e_irr⟩`
- `lake build` GREEN

## Off-limits

- `OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean` (Hyades c58 — read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer` GREEN; 0 sorry; axiom 1 (no NEW; uses Mathlib `irrational_pi`).

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'pi_irrational_only_via_niven_re_export_layer'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T2',
              tc.target_file='OmegaTheory/Irrationality/CustomMath/PiIrrationalNivenLayer.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
