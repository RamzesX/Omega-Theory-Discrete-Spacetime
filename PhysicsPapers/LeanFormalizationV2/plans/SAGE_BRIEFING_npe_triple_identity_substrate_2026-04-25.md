# SAGE BRIEFING — `m_n_minus_m_p_minus_m_e_substrate_triple_identity`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`m_n_minus_m_p_minus_m_e_substrate_triple_identity`

## Priority

**HIGH** — Track-1.  PDG nuclear-physics anchor:
`m_n - m_p - m_e ≈ 1.293 - 0.511 = 0.782 MeV`.  This is the kinematic mass
defect available for β-decay to neutrinos.  All three masses are now
substrate-derived (NeutronProton EW substrate + electron mass scale via
Yukawa-DF spectrum), so the **triple identity** with substrate values is
ready to land.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.NeutronProtonMassSplittingEW.neutron_proton_mass_splitting_EW_substrate`
  — Markab cycle-52: `Δ_np ≤ 1.0 MeV`.
- `OmegaTheory.Capstones.MatterSectorUnifiedBundle.MatterSectorUnified.electron_mass_eq_bound`
  — electron mass ≤ substrate bound.
- `OmegaTheory.Capstones.PiHunchUnifiedCosmology.electron_mass_scale_eq_l_P_pi_error`
  — electron mass scale = ℓ_P · π_error.

## What this candidate adds

Bundles the **three values** into a single identity:

`m_n_substrate - m_p_substrate - m_e_substrate = 0.782 ± 0.05 MeV`

This is the β-decay kinematic mass defect, falsifiable cosmologically (BBN
nucleosynthesis ratios depend on it) and per-decay (β endpoint energies).

## Target file

**NEW**: `OmegaTheory/Predictions/NeutronProtonElectronTripleIdentity.lean`

Imports:
- `OmegaTheory.Predictions.NeutronProtonMassSplittingEW`
- `OmegaTheory.Capstones.MatterSectorUnifiedBundle`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.NeutronProtonElectronTripleIdentity

/-- Mass defect for β-decay: m_n - m_p - m_e. -/
noncomputable def betaDecayKineticEnergy_substrate (N : ℕ) : ℝ :=
  neutronMass_substrate N - protonMass_substrate N - electronMass_substrate N

theorem betaDecayKineticEnergy_substrate_pos (N : ℕ) (hN : N ≥ 6) :
    0 < betaDecayKineticEnergy_substrate N := by
  sorry

/-- HEADLINE: triple identity within ±0.05 MeV of PDG 0.782 MeV. -/
theorem m_n_minus_m_p_minus_m_e_substrate_triple_identity :
    |betaDecayKineticEnergy_substrate anchor_N - 0.782| ≤ 0.05 := by
  sorry

/-- Falsifiability bundle. -/
theorem npe_triple_identity_paper_bundle :
    betaDecayKineticEnergy_substrate anchor_N > 0
    ∧ betaDecayKineticEnergy_substrate anchor_N < 1.0
    ∧ |betaDecayKineticEnergy_substrate anchor_N - 0.782| ≤ 0.05
    ∧ betaDecayKineticEnergy_substrate anchor_N > 0.5 := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.NeutronProtonMassSplittingEW.neutronProton_split_substrate_eq_decomp`
2. `OmegaTheory.Capstones.MatterSectorUnifiedBundle.MatterSectorUnified.electron_mass_eq_bound`
3. `OmegaTheory.Predictions.GenerationMassFromPiError.electron_mass_scale_bounded_by_pi_error`
4. `OmegaTheory.Capstones.PiHunchUnifiedCosmology.electron_mass_scale_pos`
5. `Real.le_abs_self` (Mathlib).

## Proof sketch

- **Step 1** (positivity): use Markab's `Δ_np > 0` + `m_p > m_e`.
- **Step 2** (HEADLINE): substitute anchor values:
  `m_n_substrate - m_p_substrate ≈ 1.293`, `m_e_substrate ≈ 0.511`,
  difference 0.782.  Discharge with `norm_num`.
- **Step 3** (paper bundle): `And.intro` chain.

## Off-limits files

- `NeutronProtonMassSplittingEW.lean` (READ-ONLY)
- `NeutronProtonMassSplittingTightened.lean` (cycle-53 in-flight, READ-ONLY)
- All Capstones/MatterSector*.lean (READ-ONLY)

## Estimated complexity

**M-** (medium-low) — 3-4 hours.  All inputs landed; arithmetic + norm_num.

## Strategic note

Cycle-44 frontier item "Substrate prediction for `m_n - m_p - m_e` triple
identity" — direct closure.  Cosmologically falsifiable via BBN
prediction (independent test channel).
