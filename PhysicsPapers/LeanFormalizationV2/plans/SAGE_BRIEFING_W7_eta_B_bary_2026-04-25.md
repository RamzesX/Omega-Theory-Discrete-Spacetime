# Sage Briefing — W7 (T1-eta-B-bary): Baryogenesis η_B paper bundle

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 · **Risk:** M · **Wave:** 2
**Target file:** `OmegaTheory/Predictions/BaryogenesisEtaBPaperBundle.lean` (NEW)

## Candidate name

`baryogenesis_eta_B_paper_bundle_window`

## Priority + complexity

HIGH · M (~70 lines, 3-4 theorems)

## Mission

Multiple baryogenesis theorems exist:
`Emergence.BaryogenesisLeptogenesis.eta_B_substrate_pos`,
`eta_B_substrate_upper_bound`,
`MatterAsymmetryAndNoNewPhysics.eta_B_substrate_deviation_bounded_by_envelope` and
`BaryogenesisSubstrate.lean`. Compose into a paper-citation η_B bundle:
substrate-predicted baryon-to-photon ratio η_B = (n_B - n_B̄)/n_γ ∈ [5×10⁻¹⁰, 7×10⁻¹⁰]
consistent with Planck 6.13×10⁻¹⁰. The PMNS CP-phase bridge already exists; this
W7 wires it to a paper-citable conjunction.

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.BaryogenesisLeptogenesis
import OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics

namespace OmegaTheory.Predictions.BaryogenesisEtaBPaperBundle

open OmegaTheory.Emergence.BaryogenesisLeptogenesis
open OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics

theorem baryogenesis_eta_B_paper_bundle_window :
    eta_B_substrate_pos ∧
    eta_B_substrate_upper_bound ∧
    eta_B_substrate_deviation_bounded_by_envelope := by
  refine ⟨?_, ?_, ?_⟩
  · exact eta_B_substrate_pos
  · exact eta_B_substrate_upper_bound
  · exact eta_B_substrate_deviation_bounded_by_envelope
```

## Premise candidates

1. `OmegaTheory.Emergence.BaryogenesisLeptogenesis.eta_B_substrate_pos`
2. `OmegaTheory.Emergence.BaryogenesisLeptogenesis.eta_B_substrate_upper_bound`
3. `OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics.eta_B_substrate_deviation_bounded_by_envelope`
4. `OmegaTheory.Predictions.BaryogenesisSubstrate.<headline>`
5. `OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics.matter_antimatter_asymmetry_bounded_by_PMNS_CP_phase`

## Proof sketch

- 3-conjunct refine, each `exact <existing>`
- Verify GREEN

## Off-limits

- `OmegaTheory/Emergence/BaryogenesisLeptogenesis.lean` (read-only)
- `OmegaTheory/Emergence/MatterAsymmetryAndNoNewPhysics.lean` (read-only)
- `OmegaTheory/Predictions/BaryogenesisSubstrate.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.BaryogenesisEtaBPaperBundle` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'baryogenesis_eta_B_paper_bundle_window'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/BaryogenesisEtaBPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
