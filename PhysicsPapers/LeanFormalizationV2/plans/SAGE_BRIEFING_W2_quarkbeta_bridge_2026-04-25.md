# Sage Briefing — W2 (T1-quarkbeta-bridge): QuarkBetaFromConnesD_F orphans capstone

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 · **Risk:** M
**Wave:** 1 · **Target file:** `OmegaTheory/Predictions/QuarkBetaConnesD_FCapstone.lean` (NEW)

## Candidate name & graph node

`quark_beta_from_connesD_F_orphan_compose_capstone`
Neo4j: `:TheoremCandidate {batch_id: 'scorpius_antares_cycle59_topology_fire_2026-04-25', status: 'PROPOSED', priority: 'HIGH'}`

## Priority + complexity

HIGH · M (~100 lines, 5-6 theorems)

## Mission

`OmegaTheory/Predictions/QuarkBetaFromConnesD_F.lean` has 27 theorems with 20
of them graph-isolated (no APPLIES-in). This is one of the highest-impact
Connes D_F → quark mass theorems in V2. Compose isolated `quark_beta_*`
theorems into a single bundle that downstream `OmegaTheoryGrandUnifiedCapstone`
or `MatterSectorUnifiedBundle` can cite directly. Net: 6-8 wired theorems,
one quark-mass paper-bundle citation point.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.QuarkBetaFromConnesD_F
import OmegaTheory.Capstones.MatterSectorUnifiedBundle

namespace OmegaTheory.Predictions.QuarkBetaConnesD_FCapstone

open OmegaTheory.Predictions.QuarkBetaFromConnesD_F
open OmegaTheory.Capstones.MatterSectorUnifiedBundle

theorem quark_beta_from_connesD_F_capstone
    (h_DF : ∃ DF, valid_DF_eigenvalues DF) :
    ∃ (Y_q : QuarkYukawaPattern), connes_D_F_implies_quark_yukawa Y_q := by
  -- Wire 6-8 orphan quark_beta_* theorems via existential composition.
  sorry

theorem quark_beta_paper_bundle :
    MatterSectorUnified.yukawa_electron_mass := by
  exact MatterSectorUnified.yukawa_electron_mass.proof
```

## Premise candidates (top-5)

1. `OmegaTheory.Capstones.MatterSectorUnifiedBundle.MatterSectorUnified.yukawa_electron_mass`
2. `OmegaTheory.Predictions.QuarkBetaFromConnesD_F.<orphan>` × 6-8 picks
3. `OmegaTheory.Emergence.ConnesDFYukawaMass.channel_mass_ratio_eq_lambda_ratio`
4. `OmegaTheory.Emergence.QuarkMassFromIrrationals.<headline>`
5. `OmegaTheory.Capstones.MatterSectorUnifiedBundle.MatterSectorUnified.electron_mass_eq_bound`

## Proof sketch

- `lean_local_search quark_beta` → list 27 theorems, identify 6-8 orphan with non-trivial body
- Compose into `bundle` theorem with existential premises
- Add `paper_bundle` wrapper citing MatterSectorUnified
- `lean_diagnostic_messages` 0 errors
- `lake build` GREEN

## Off-limits files

- `OmegaTheory/Predictions/QuarkBetaFromConnesD_F.lean` (read-only)
- `OmegaTheory/Capstones/MatterSectorUnifiedBundle.lean` (read-only)
- ALL cycle 52-58 wizard files
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.Predictions.QuarkBetaConnesD_FCapstone` GREEN; full `lake build` GREEN; 0 sorry; axiom 1.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'quark_beta_from_connesD_F_orphan_compose_capstone'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/QuarkBetaConnesD_FCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
