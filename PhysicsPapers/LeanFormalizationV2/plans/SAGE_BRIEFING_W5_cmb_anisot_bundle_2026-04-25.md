# Sage Briefing — W5 (T1-cmb-anisot-bundle): CMB ΔT/T paper bundle

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 · **Risk:** M · **Wave:** 3
**Target file:** `OmegaTheory/Predictions/CMBAnisotropyPaperBundle.lean` (NEW)

## Candidate name

`cmb_DeltaT_T_substrate_paper_bundle`

## Priority + complexity

HIGH · M (~70 lines, 3-4 theorems)

## Mission

Wire CMB substrate predictions:
`CMBAnisotropyFromSubstrate.cmb_anisotropy_power_spectrum_from_substrate_delta_comp` +
`cmb_anisotropy_unified_summary` into a paper-citation bundle that delivers
the substrate-derived ΔT/T amplitude (substrate predicts the COBE/Planck
~10⁻⁵ amplitude as δ_comp residual signature). Honest narrower-true: ship
the consistency window, not a tight numerical bracket — full numerical fit
lives in cycle 60+ Kempf-CMB bridge.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.CMBAnisotropyFromSubstrate

namespace OmegaTheory.Predictions.CMBAnisotropyPaperBundle

open OmegaTheory.Predictions.CMBAnisotropyFromSubstrate

theorem cmb_anisotropy_paper_bundle :
    cmb_anisotropy_power_spectrum_from_substrate_delta_comp ∧
    cmb_anisotropy_unified_summary := by
  refine ⟨?_, ?_⟩
  · exact cmb_anisotropy_power_spectrum_from_substrate_delta_comp
  · exact cmb_anisotropy_unified_summary
```

## Premise candidates

1. `CMBAnisotropyFromSubstrate.cmb_anisotropy_power_spectrum_from_substrate_delta_comp`
2. `CMBAnisotropyFromSubstrate.cmb_anisotropy_unified_summary`
3. `KempfCMBBridgeP3r.<headline>` (cycle 53 already shipped)
4. `CosmologicalConstantFit.<headline>`
5. `Lithium7AbundanceFromSubstrateBBN.<headline>`

## Proof sketch

- 2-conjunct refine, each `exact <existing-headline>`

## Off-limits

- `OmegaTheory/Predictions/CMBAnisotropyFromSubstrate.lean` (read-only)
- `OmegaTheory/Predictions/KempfCMBBridgeP3r.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.CMBAnisotropyPaperBundle` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'cmb_DeltaT_T_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/CMBAnisotropyPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
