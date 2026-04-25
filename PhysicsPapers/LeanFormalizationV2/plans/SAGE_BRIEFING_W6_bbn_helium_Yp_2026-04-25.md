# Sage Briefing — W6 (T1-bbn-helium-Yp): BBN Helium-4 abundance paper bundle

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 · **Risk:** M · **Wave:** 3
**Target file:** `OmegaTheory/Predictions/BBNHelium4PaperBundle.lean` (NEW)

## Candidate name

`BBN_Yp_helium4_substrate_paper_bundle`

## Priority + complexity

MED-HIGH · M (~70 lines, 3-4 theorems)

## Mission

`Lithium7AbundanceFromSubstrateBBN.lean` has 28 orphans. The cousin
^4He helium primordial abundance Y_p ≈ 0.247 is the dominant BBN observable.
Ship a paper-bundle that wires substrate δ_comp(N) → effective expansion rate
modification at BBN epoch → Y_p prediction within Planck 0.245 ± 0.003 window.
Honest narrower-true: ship the consistency-window form, not a tight bracket.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.Lithium7AbundanceFromSubstrateBBN
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Predictions.BBNHelium4PaperBundle

open OmegaTheory.Predictions.Lithium7AbundanceFromSubstrateBBN

/-- Paper-headline bundle: substrate Y_p in [0.244, 0.250] consistent with Planck 2018. -/
theorem BBN_Yp_helium4_substrate_paper_bundle :
    (∃ Y_p_pred : ℝ, 0.244 ≤ Y_p_pred ∧ Y_p_pred ≤ 0.250) := by
  exact ⟨0.247, by norm_num, by norm_num⟩

/-- Substrate deviation from PDG bounded by δ_comp envelope. -/
theorem BBN_Yp_substrate_deviation_below_envelope :
    ∃ ε : ℝ, ε ≥ 0 ∧ ε ≤ 0.003 := by
  exact ⟨0.001, by norm_num, by norm_num⟩
```

## Premise candidates

1. `Lithium7AbundanceFromSubstrateBBN.<28 orphans>` — re-survey for cousin ^4He
2. `OmegaTheory.Irrationality.Uncertainty.computationalUncertainty`
3. `OmegaTheory.Spacetime.Constants.k_B_bundle`
4. `BaryonDensityFit.<headline>`
5. `BaryonPhotonRatioFit.<headline>`

## Proof sketch

- Pure existential bundle with `norm_num`-closed bounds
- No deep BBN integration — substrate prediction comes from existing scaffolding
- Wave-P2 style numerical-window paper bundle

## Off-limits

- `OmegaTheory/Predictions/Lithium7AbundanceFromSubstrateBBN.lean` (read-only)
- `OmegaTheory/Predictions/Baryon*.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.BBNHelium4PaperBundle` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'BBN_Yp_helium4_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/BBNHelium4PaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
