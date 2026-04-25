# SAGE BRIEFING — `PMNS_three_angles_numerical_PDG_simultaneous`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`PMNS_three_angles_numerical_PDG_simultaneous`

## Priority

**MEDIUM** — Track-1.  Each PMNS mixing angle has its own substrate fit
file (`PMNSTheta12Solar`, `PMNSTheta13Reactor`, `PMNSTheta23MaximalMixing`)
but no SINGLE BUNDLE asserts all three within PDG simultaneously. This
briefing produces the bundled headline.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.PMNSTheta12Solar.pmns_theta_12_solar_substrate_fit`
- `OmegaTheory.Predictions.PMNSTheta12Solar.theta12_fit_within_one_sigma`
- `OmegaTheory.Predictions.PMNSTheta13Reactor.theta13_fit_exact_hit_at_anchor`
- `OmegaTheory.Predictions.PMNSTheta13Reactor.pmns_theta_13_reactor_substrate_fit`
- `OmegaTheory.Predictions.PMNSTheta23MaximalMixing.maximal_mixing_capstone`
- `OmegaTheory.Capstones.MatterSectorUnifiedBundle.MatterSectorUnified.pmns_two_large_angles`

## What this candidate adds

Single 4-conjunct (3 angles + simultaneous-PDG) headline:

```lean
theorem PMNS_three_angles_numerical_PDG_simultaneous :
    |substrateTheta12 anchor_N - 33.44| ≤ 0.5
    ∧ |substrateTheta13 anchor_N - 8.57| ≤ 0.2
    ∧ |substrateTheta23 anchor_N - 49.0| ≤ 1.0
    ∧ allThreePMNSAnglesWithinPDG anchor_N
```

PDG values (2024): θ_12 = 33.44°, θ_13 = 8.57°, θ_23 = 49.0°.

## Target file

**NEW**: `OmegaTheory/Predictions/PMNSAllThreeAnglesPDGSimultaneous.lean`

Imports: all 3 PMNSTheta*.lean files.

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.PMNSAllThreeAnglesPDGSimultaneous

theorem PMNS_three_angles_numerical_PDG_simultaneous :
    |substrateTheta12 anchor_N - 33.44| ≤ 0.5
    ∧ |substrateTheta13 anchor_N - 8.57| ≤ 0.2
    ∧ |substrateTheta23 anchor_N - 49.0| ≤ 1.0 := by
  refine ⟨?_, ?_, ?_⟩
  · exact theta12_fit_within_one_sigma_anchor
  · exact theta13_fit_exact_hit_at_anchor
  · exact theta23_maximal_mixing_within_one_sigma

theorem PMNS_paper_bundle :
    PMNS_three_angles_numerical_PDG_simultaneous
    ∧ pmns_two_large_angles
    ∧ delta_CP_PMNS_neg := by
  refine ⟨?_, ?_, ?_⟩
  · exact PMNS_three_angles_numerical_PDG_simultaneous
  · exact pmns_two_large_angles_proven
  · exact delta_CP_PMNS_neg_proven
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.PMNSTheta12Solar.theta12_fit_within_one_sigma`
2. `OmegaTheory.Predictions.PMNSTheta13Reactor.theta13_fit_exact_hit_at_anchor`
3. `OmegaTheory.Predictions.PMNSTheta23MaximalMixing.maximal_mixing_capstone`
4. `OmegaTheory.Capstones.MatterSectorUnifiedBundle.MatterSectorUnified.pmns_two_large_angles`
5. `OmegaTheory.Predictions.CPSignFromIrrationalOrdering.delta_CP_PMNS_neg`

## Proof sketch

- Pure `And.intro` chain.  Each conjunct is an existing landed theorem.
- Wizard checks angle units (degrees vs radians) — the PDG values are in
  degrees, substrate fits may be in radians; `norm_num` after conversion.

## Off-limits files

- All `PMNSTheta*.lean` (READ-ONLY).
- `MatterSectorUnifiedBundle.lean` (READ-ONLY).
- `CPSignFromIrrationalOrdering.lean` (READ-ONLY).
- All cycle-53 in-flight files.

## Estimated complexity

**S** (small) — 2-3 hours. Pure aggregation; main risk is unit conversion.

## Strategic note

Cycle-44 frontier item "PMNS mixing angles numerical" — direct closure.
Sister to a CKM bundle (could spawn next cycle).
