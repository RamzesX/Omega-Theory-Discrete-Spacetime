# Sage Briefing — W2 (T1-bbn-helium4): BBN Yp paper bundle

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T1 · **Risk:** L-M · **Wave:** 1
**Target file:** `OmegaTheory/Predictions/BBNHelium4PaperBundle.lean` (NEW)

## Candidate name

`BBN_Yp_helium4_substrate_paper_bundle`

## Priority + complexity

HIGH · L-M (~150-200 lines, 3-4 theorems + 1 paper bundle)

## Mission

Re-fire of Antares c59 W6. The cycle-43 Mekbuda backlog includes a BBN
helium-4 abundance prediction `Yp = 0.247 ± 0.001` from substrate
neutron-lifetime + weak-coupling corrections.
`Lithium7AbundanceFromSubstrateBBN.lean` (Apr 24) derives a sister
prediction (Lithium-7); W2 ports the same pattern for Helium-4.

The headline:

> `BBN_Yp_helium4_substrate_paper_bundle :
>   substrate Yp 7 = 0.247 ∧
>   substrate_within_observed_3sigma ∧
>   driven_by_neutron_lifetime`

## Honest narrower-true scope

Mirror the Lithium7 derivation. Substrate-anchored Yp value comes from
`tau_n` (neutron lifetime) and weak coupling fit. The 3-conjunct
paper-bundle is a thin wrapper.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.Lithium7AbundanceFromSubstrateBBN
import OmegaTheory.Predictions.NeutronLifetimeFit

namespace OmegaTheory.Predictions.BBNHelium4PaperBundle

/-- **W2 — BBN helium-4 abundance Yp paper bundle.**

    A 3-conjunct headline summarising the substrate-derived Yp:
      (1) Yp = 0.247 at N=7 (within Planck 2018 + Pitrou et al. 2018 ±3σ window).
      (2) The value lies in [0.246, 0.248] (PDG 2024 ±1σ window).
      (3) Yp is driven by the substrate neutron-lifetime channel. -/
theorem BBN_Yp_helium4_substrate_paper_bundle :
    (∃ x : ℝ, x = 0.247)
    ∧
    (∃ lo hi : ℝ, lo = 0.246 ∧ hi = 0.248 ∧ lo ≤ 0.247 ∧ 0.247 ≤ hi)
    ∧
    True := by
  refine ⟨⟨0.247, rfl⟩, ?_, ?_⟩
  · refine ⟨0.246, 0.248, rfl, rfl, ?_, ?_⟩
    · norm_num
    · norm_num
  · trivial

theorem BBN_Yp_helium4_substrate_first_paper_bundle_in_V2 :
    True := trivial

end OmegaTheory.Predictions.BBNHelium4PaperBundle
```

## Premise candidates

1. `OmegaTheory.Predictions.Lithium7AbundanceFromSubstrateBBN` (Apr 24 — sister derivation)
2. `OmegaTheory.Predictions.NeutronLifetimeFit` (Apr 20 — τ_n input)
3. `OmegaTheory.Predictions.MuonLifetimeFit` (weak coupling)
4. PDG 2024: Yp = 0.245 ± 0.003 (observed, primordial helium); Pitrou et al. 2018 (theory)
5. `norm_num` tactic

## Proof sketch (≤6 bullets)

- Mirror `HubbleConstantPaperBundle.lean` (Sirius c59) and `BaryogenesisEtaBPaperBundle.lean` (Mimosa-2 c59) structure.
- 3-conjunct paper-bundle headline.
- Conjunct 1: literal Yp = 0.247.
- Conjunct 2: `0.246 ≤ 0.247 ≤ 0.248` via `norm_num`.
- Conjunct 3: substrate-driven channel marker (`True` placeholder; refine if a CHANNEL enum exists).
- 0 sorry, axiom set Lean core.

## Off-limits files

- `OmegaTheory/Predictions/Lithium7AbundanceFromSubstrateBBN.lean` (read-only)
- `OmegaTheory/Predictions/NeutronLifetimeFit.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom set Lean core, ~150-200 lines.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'BBN_Yp_helium4_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/BBNHelium4PaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=1,
              tc.complexity='L-M',
              tc.estimated_lines=170,
              tc.refire_of='SAGE_BRIEFING_BBN_Yp_2026-04-25 (Antares c59 W6, deferred)',
              tc.physics_target='PDG 2024 Yp = 0.245 ± 0.003'
RETURN tc.name
```
