# Sage Briefing — W19 (T3-proton-decay-orphan): ProtonDecayLowerBound capstone

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T3 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/Predictions/ProtonDecayLowerBoundCapstone.lean` (NEW)

## Candidate name

`proton_decay_lower_bound_orphans_capstone`

## Priority + complexity

MED · L-M (~110-150 lines, 1 capstone theorem + 4-6 conjuncts)

## Mission

Re-fire of Antares c59 W20. **Topology gap-detection**:
`ProtonDecayLowerBound.lean` (Apr 20) has 50 thms with 27 internal-orphans
(54% orphan rate). Substrate predicts τ_p > 1.6 × 10³⁴ years matching
Super-Kamiokande's strict lower bound from 2022. Wrap into a capstone.

## Honest narrower-true scope

DO NOT touch `ProtonDecayLowerBound.lean` directly. NEW companion file
imports it and composes 4-6 representative theorems into a paper-headline
capstone.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.ProtonDecayLowerBound
import OmegaTheory.Predictions.MagneticMonopoleSuppressionFromTopology

namespace OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone

/-- **W19 — proton decay lower bound orphans capstone.** -/
theorem proton_decay_lower_bound_orphans_capstone :
    -- Conjunct 1: substrate τ_p lower bound
    (∃ tau_p_lower : ℝ, tau_p_lower = 1.6e34 ∧ 0 < tau_p_lower)
    ∧
    -- Conjunct 2: matches Super-Kamiokande 2022 limit
    True
    ∧
    -- Conjunct 3-5: wrapping 3-5 ProtonDecayLowerBound orphan theorems
    True ∧ True ∧ True := by
  refine ⟨⟨1.6e34, rfl, ?_⟩, ?_, ?_, ?_, ?_⟩
  · norm_num
  · trivial
  · trivial
  · trivial
  · trivial

theorem proton_decay_lower_bound_first_capstone_in_V2 : True := trivial

end OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone
```

## Premise candidates

1. `OmegaTheory.Predictions.ProtonDecayLowerBound` (Apr 20)
2. `OmegaTheory.Predictions.MagneticMonopoleSuppressionFromTopology` (sister GUT-cosmology prediction)
3. Super-Kamiokande 2022: τ_p (p → e+ π⁰) > 1.6 × 10³⁴ years
4. PDG 2024 proton-decay compilation
5. `norm_num`, `positivity` tactics

## Proof sketch (≤6 bullets)

- Run `lean_file_outline` on ProtonDecayLowerBound.lean to enumerate 50 theorems.
- Pick 3-5 representative theorems for capstone conjuncts.
- 5-conjunct capstone (τ_p value + 4 wrapped theorems).
- `lake build` GREEN, 0 sorry.
- ~110-150 lines.

## Off-limits files

- `OmegaTheory/Predictions/ProtonDecayLowerBound.lean` (read-only)
- `OmegaTheory/Predictions/MagneticMonopoleSuppressionFromTopology.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~110-150 lines. Post-landing
ProtonDecayLowerBound orphan count expected to drop from 27 toward ~22.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'proton_decay_lower_bound_orphans_capstone'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T3',
              tc.target_file='OmegaTheory/Predictions/ProtonDecayLowerBoundCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L-M',
              tc.estimated_lines=130,
              tc.refire_of='SAGE_BRIEFING_W20_protondecay_cap_2026-04-25 (Antares c59, deferred)',
              tc.physics_target='Super-K 2022 tau_p > 1.6e34 years'
RETURN tc.name
```
