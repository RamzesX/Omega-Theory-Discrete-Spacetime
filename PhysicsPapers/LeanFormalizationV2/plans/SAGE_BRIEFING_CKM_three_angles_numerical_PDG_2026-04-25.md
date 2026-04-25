# SAGE BRIEFING — `CKM_three_angles_numerical_PDG_simultaneous`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`CKM_three_angles_numerical_PDG_simultaneous`

## Priority

**MEDIUM** — Track-1.  Sister of PMNS-bundle, but CKM is the quark-sector
mixing.  Angles and matrix elements are scattered across `CKMVcbFit`,
`CKMVtdFit`, `CKMVtsFit`, `MixingAnglesFromIrrationals.lean`. PDG values
2024:

- θ_12 (Cabibbo) = 13.04°  (sin θ_12 ≈ 0.225)
- θ_13           ≈  0.20°  (V_ub ≈ 3.6e-3)
- θ_23           ≈  2.38°  (V_cb ≈ 4.15e-2)

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.MixingAnglesFromIrrationals.CKM_theta12_PDG_pos`
- `OmegaTheory.Predictions.CKMVcbFit.substrateVcb_at_anchor_eq_PDG`
- `OmegaTheory.Predictions.CKMVtdFit.substrateVtd_at_anchor_eq_PDG`
- `OmegaTheory.Predictions.CKMVtsFit.Vus_PDG_eq`
- `OmegaTheory.Predictions.PMNSTheta12Solar.theta12_PMNS_larger_than_CKM`

## What this candidate adds

Single 3-conjunct headline matching the PMNS structure:

```lean
theorem CKM_three_angles_numerical_PDG_simultaneous :
    |substrateThetaCKM12 anchor_N - 13.04| ≤ 0.5
    ∧ |substrateThetaCKM13 anchor_N - 0.20| ≤ 0.05
    ∧ |substrateThetaCKM23 anchor_N - 2.38| ≤ 0.1
```

## Target file

**NEW**: `OmegaTheory/Predictions/CKMAllThreeAnglesPDGSimultaneous.lean`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.CKMAllThreeAnglesPDGSimultaneous

theorem CKM_three_angles_numerical_PDG_simultaneous :
    |substrateThetaCKM12 anchor_N - 13.04| ≤ 0.5
    ∧ |substrateThetaCKM13 anchor_N - 0.20| ≤ 0.05
    ∧ |substrateThetaCKM23 anchor_N - 2.38| ≤ 0.1 := by
  refine ⟨?_, ?_, ?_⟩
  all_goals sorry  -- wizard fills via existing fits + norm_num

/-- Cabibbo > θ_13 > θ_23 (CKM hierarchy ordering). -/
theorem CKM_hierarchy_ordering :
    substrateThetaCKM12 anchor_N
    > substrateThetaCKM23 anchor_N
    ∧ substrateThetaCKM23 anchor_N > substrateThetaCKM13 anchor_N := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.MixingAnglesFromIrrationals.CKM_theta12_PDG_pos`
2. `OmegaTheory.Predictions.CKMVcbFit.substrateVcb_at_anchor_eq_PDG`
3. `OmegaTheory.Predictions.CKMVtdFit.substrateVtd_at_anchor_eq_PDG`
4. `OmegaTheory.Predictions.CKMVtsFit.Vus_PDG_eq`
5. `OmegaTheory.Predictions.PMNSTheta12Solar.theta12_PMNS_larger_than_CKM`

## Proof sketch

- Convert V_ij matrix elements to angles via `arcsin V_ij` (small-angle
  approximation for θ_13).
- `And.intro` chain.

## Off-limits files

- `CKM*Fit.lean`, `MixingAnglesFromIrrationals.lean` (READ-ONLY).
- All cycle-53 in-flight files.

## Estimated complexity

**M-** (medium-low) — 3-5 hours.  Wizard handles `arcsin`-vs-degrees.

## Strategic note

Cycle-44 frontier item "CKM mixing angles θ_12, θ_13, θ_23 numerical" —
direct closure.  Plus the hierarchy ordering as a falsifiability witness.
