# Sage Briefing — W4 (T1-hubble-precision): Hubble constant 67.4 paper bundle

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 · **Risk:** M · **Wave:** 2
**Target file:** `OmegaTheory/Predictions/HubbleConstantPaperBundle.lean` (NEW)

## Candidate name

`hubble_constant_67_4_paper_bundle_within_PDG`

## Priority + complexity

HIGH · M (~80 lines, 4 theorems)

## Mission

Multiple Hubble-related theorems exist scattered:
`HubbleConstantAbsolute.lean`, `HubbleConstantAbsoluteP3f.lean`,
`HubbleConstantFit.lean` (3 headlines), `HubbleTensionFromSubstrateDEGain.lean`
(32 orphans!), `HubbleTensionBridge.lean`, `PrecisionPhysicsAbsoluteWaveP2.hubble_constant_headline_absolute_km_s_Mpc_within_local_PDG`.
Compose into ONE paper-citation bundle: `hubble_constant_paper_bundle` that
asserts the substrate-derived value 67.4 ± few km/s/Mpc, cites the existing
Wave-P2 headline, and provides the substrate→Hubble→DE-gain→tension chain
as a citable conjunct. Ships paper Section 6.2 single-citation point.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.HubbleConstantFit
import OmegaTheory.Predictions.HubbleTensionFromSubstrateDEGain
import OmegaTheory.Predictions.PrecisionPhysicsAbsoluteWaveP2

namespace OmegaTheory.Predictions.HubbleConstantPaperBundle

open OmegaTheory.Predictions

/-- Paper-headline bundle: substrate Hubble constant within local PDG window. -/
theorem hubble_constant_paper_bundle :
    HubbleConstantFit.hubble_constant_substrate_fit_exists ∧
    HubbleConstantFit.hubble_constant_headline ∧
    PrecisionPhysicsAbsoluteWaveP2.hubble_constant_headline_absolute_km_s_Mpc_within_local_PDG := by
  refine ⟨?_, ?_, ?_⟩
  · exact HubbleConstantFit.hubble_constant_substrate_fit_exists
  · exact HubbleConstantFit.hubble_constant_headline
  · exact PrecisionPhysicsAbsoluteWaveP2.hubble_constant_headline_absolute_km_s_Mpc_within_local_PDG
```

## Premise candidates

1. `PrecisionPhysicsAbsoluteWaveP2.hubble_constant_headline_absolute_km_s_Mpc_within_local_PDG`
2. `HubbleConstantFit.hubble_constant_substrate_fit_exists`
3. `HubbleConstantFit.hubble_constant_headline`
4. `HubbleTensionFromSubstrateDEGain.<32 orphans>` — pick 4-6 to wire into bundle
5. `HubbleTensionBridge.<headline>`

## Proof sketch

- 3-conjunct refine, each `exact <headline>`
- Optionally extend to 6-conjunct adding tension-bridge orphan headlines
- Verify with `lean_diagnostic_messages`

## Off-limits

- `OmegaTheory/Predictions/Hubble*.lean` (all 5 files read-only)
- `OmegaTheory/Predictions/PrecisionPhysicsAbsoluteWaveP2.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.HubbleConstantPaperBundle` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'hubble_constant_67_4_paper_bundle_within_PDG'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/HubbleConstantPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
