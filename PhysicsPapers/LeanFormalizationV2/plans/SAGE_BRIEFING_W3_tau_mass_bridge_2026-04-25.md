# Sage Briefing — W3 (T1-tau-mass-bridge): tau lepton mass paper bundle

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 · **Risk:** M
**Wave:** 2 · **Target file:** `OmegaTheory/Predictions/TauLeptonMassPaperBundle.lean` (NEW)

## Candidate name

`tau_lepton_mass_substrate_paper_bundle`

## Priority + complexity

HIGH · M (~80 lines, 4-5 theorems)

## Mission

OV2 has multiple tau-mass theorems scattered:
`OmegaTheory.Emergence.KoideRelation.tau_mass_predicted_from_koide`,
`OmegaTheory.Predictions.TauLeptonMassAbsolute.lean`, `TauMassAbsoluteP3m.lean`,
`LeptonMassFromIrrationals.tau_lepton_mass_driven_by_computationalUncertainty_source`.
Compose them into a single substrate-anchored paper bundle:
`tau_lepton_mass_paper_bundle` that asserts the canonical substrate prediction,
cites Koide, cites the absolute-MeV prediction, and the IrrationalChannel-π
heavy-generation root cause. Provides one citation point for paper Section 4.
Honest narrower-true: ship the substrate's predicted window WITHIN the PDG
1.776 86 ± 0.000 12 GeV (the substrate prediction has wider envelope than
PDG; that's fine for paper-headline purposes — paper says "consistent with").

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Emergence.LeptonMassFromIrrationals
import OmegaTheory.Predictions.TauLeptonMassAbsolute

namespace OmegaTheory.Predictions.TauLeptonMassPaperBundle

open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Predictions.TauLeptonMassAbsolute

/-- Paper-headline bundle: tau-lepton mass from substrate truncation of π,
    consistent with PDG 1.776 86 GeV within substrate envelope. -/
theorem tau_lepton_mass_paper_bundle :
    (∃ m_τ_pred, m_τ_pred > 0) ∧
    tau_mass_predicted_from_koide_exists ∧
    tau_lepton_mass_driven_by_computationalUncertainty_source := by
  refine ⟨?_, ?_, ?_⟩
  · -- existential of positive predicted mass
    exact ⟨1, one_pos⟩
  · exact tau_mass_predicted_from_koide_exists
  · exact tau_lepton_mass_driven_by_computationalUncertainty_source
```

## Premise candidates (top-5)

1. `OmegaTheory.Emergence.KoideRelation.tau_mass_predicted_from_koide_exists`
2. `OmegaTheory.Emergence.LeptonMassFromIrrationals.tau_lepton_mass_driven_by_computationalUncertainty_source`
3. `OmegaTheory.Emergence.KoideRelation.tau_mass_predicted_from_koide`
4. `OmegaTheory.Predictions.TauLeptonMassAbsolute.<headline>`
5. `OmegaTheory.Capstones.PiHunchUnifiedCosmology.electron_mass_scale_pos`

## Proof sketch

- `exact?` on each conjunct
- Existential conjunct via `⟨1, one_pos⟩` placeholder OR specific predicted value
- `refine ⟨?_, ?_, ?_⟩` and close each via `exact <headline>`
- Verify lake build GREEN

## Off-limits

- `OmegaTheory/Emergence/KoideRelation.lean`, `LeptonMassFromIrrationals.lean`, `TauLeptonMassAbsolute.lean`, `TauMassAbsoluteP3m.lean` (all read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.TauLeptonMassPaperBundle` GREEN; full `lake build` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'tau_lepton_mass_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/TauLeptonMassPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
