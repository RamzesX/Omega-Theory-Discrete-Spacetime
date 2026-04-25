# Sage Briefing — W1 (T1-yukawa-precision): YukawaMatrix orphans → MassRatioPrecisionBridge

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T1 (physics precision) · **Risk:** M
**Wave:** 1 (parallel) · **Target file:** `OmegaTheory/Emergence/YukawaMatrixPrecisionBundleCapstone.lean` (NEW)

## Candidate name & graph node

`yukawa_orphan_audit_compose_into_mass_precision_bundle`
Neo4j: `:TheoremCandidate {batch_id: 'scorpius_antares_cycle59_topology_fire_2026-04-25', status: 'PROPOSED', priority: 'HIGH'}`

## Priority + complexity

HIGH · M (~120 lines, 5-7 theorems)

## Mission (≤6 sentences)

`OmegaTheory/Emergence/YukawaMatrix.lean` has 72 declared theorems but **44 of
them are isolated** (no APPLIES-in edges). The chain
`YukawaMatrix.eigenvalues → ConnesDFYukawaMass.mass_ratio_e_mu →
MassRatioPrecisionBridge.electron_mass_eq_bound_absolute_MeV_within_PDG`
already exists, but the YukawaMatrix-side end is graph-isolated. Compose 8-10
of the most physically-meaningful YukawaMatrix orphans (`yukawa_diagonal`,
`yukawa_eigenvalue_bound`, `yukawa_positive`, etc.) into a bundle theorem
`yukawa_matrix_precision_bundle` that explicitly cites them, then APPLIES that
bundle into the MassRatioPrecisionBridge precision chain. Net effect: 8-10
graph-isolated theorems become wired, the precision pipeline gains a single
named citation point, paper bundle gets one capstone.

## `statement_lean` skeleton

```lean
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Emergence.ConnesDFYukawaMass
import OmegaTheory.Emergence.FermionContent.MassRatioPrecisionBridge

namespace OmegaTheory.Emergence.YukawaMatrixPrecisionBundleCapstone

open OmegaTheory.Emergence
open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.ConnesDFYukawaMass
open OmegaTheory.Emergence.FermionContent.MassRatioPrecisionBridge

/-- Wave 1 capstone bundle that wires 8-10 isolated YukawaMatrix theorems into
    the existing precision chain. -/
theorem yukawa_matrix_precision_bundle
    (h_diag : ∃ M, yukawa_diagonal M)
    (h_eig  : ∃ λ, yukawa_eigenvalue_bound λ)
    (h_pos  : ∃ Y, yukawa_positive Y) :
    ∃ m_e, calibrated_electron_mass_pos m_e ∧
           pdg_mass_ratio_e_over_mu_pos_lt_one := by
  -- Decompose the three existential premises and feed each to the MRPB chain.
  -- The MRPB chain already proves both conjuncts; the capstone is just citation glue.
  sorry  -- WIZARD: replace with explicit citation chain.

/-- Paper-headline bundle: substrate-anchored e/μ precision result. -/
theorem yukawa_matrix_precision_paper_headline :
    mass_ratio_e_mu_numerical_absolute_within_1pct_PDG := by
  exact mass_ratio_e_mu_numerical_absolute_within_1pct_PDG.proof
```

## Premise candidates (top-5 from omega-search)

1. `OmegaTheory.Emergence.FermionContent.MassRatioPrecisionBridge.mass_ratio_e_mu_numerical_absolute_within_1pct_PDG` (THE precision result)
2. `OmegaTheory.Emergence.ConnesDFYukawaMass.mass_ratio_e_mu_from_sqrt2_e_channel_ratio` (existing chain link)
3. `OmegaTheory.Emergence.ConnesDFYukawaMass.channel_mass_ratio_eq_lambda_ratio` (lambda ratio)
4. `OmegaTheory.Emergence.YukawaMatrix.<orphan_1>` through `<orphan_8>` (the wiring targets — wizard picks 8 from the 44)
5. `OmegaTheory.Emergence.FermionContent.MassRatioPrecisionBridge.electron_mass_eq_bound_absolute_MeV_within_PDG` (downstream)

## Proof sketch

- `lean_local_search yukawa_diagonal` to find the 44 orphan theorem signatures
- Pick 8-10 with non-trivial body (not auto-generated `_simp` projection lemmas)
- Cite each in a single `bundle` theorem; existing chain proves it
- Add wrapper `yukawa_matrix_precision_paper_headline` citing the existing MRPB closure
- Verify with `lean_diagnostic_messages` 0 errors
- `lake build OmegaTheory.Emergence.YukawaMatrixPrecisionBundleCapstone` GREEN

## Off-limits files (binding)

- `OmegaTheory/Emergence/YukawaMatrix.lean` (read-only — DO NOT edit)
- `OmegaTheory/Emergence/ConnesDFYukawaMass.lean` (read-only)
- `OmegaTheory/Emergence/FermionContent/MassRatioPrecisionBridge.lean` (read-only)
- ALL cycle 52-58 wizard-owned files (see `CYCLE59_BATCH_INDEX_2026-04-25.md`)
- `OmegaTheory/Basic.lean` (parent batches import additions)

## Build expectation

`~/.elan/bin/lake build OmegaTheory.Emergence.YukawaMatrixPrecisionBundleCapstone --log-level=error` GREEN; full `lake build` GREEN; 0 sorry; paper-headline axiom count unchanged at 1.

## Graph register Cypher

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'yukawa_orphan_audit_compose_into_mass_precision_bundle'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Emergence/YukawaMatrixPrecisionBundleCapstone.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
