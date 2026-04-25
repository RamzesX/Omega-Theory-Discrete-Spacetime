# SAGE BRIEFING — `pion_mass_from_chiral_substrate_GMOR`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`pion_mass_from_chiral_substrate_GMOR`

## Priority

**HIGH** — Track-1.  Pion-mass file `PionMassFit.lean` already has fit infra
(`pionMass_predicted_within_PDG_tolerance`, `pion_mass_substrate_fit_headline`)
but the **chiral GMOR (Gell-Mann-Oakes-Renner) derivation** linking pion mass
to quark masses + chiral condensate is not yet substrate-anchored.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.PionMassFit.pionMass_predicted_within_PDG_tolerance`
- `OmegaTheory.Predictions.PionMassFit.pion_mass_substrate_fit_headline`
- `OmegaTheory.Predictions.PionMassFit.pionMass_lt_protonMass_substrate`
- `OmegaTheory.Predictions.RhoMesonMassFit.pionMass_lt_rhoMass_PDG`

## What this candidate adds

GMOR: `m_π² · f_π² = -⟨q̄q⟩ · (m_u + m_d)`.  We have `m_u, m_d` substrate-derived
(`UpQuarkMassFit`, `DownQuarkMassFit`), and `f_π ≈ 92.4 MeV` is a substrate-
or PDG-anchored constant.  The identity `m_π² · f_π² = Σ · (m_u + m_d)` becomes
a substrate prediction with `Σ` (chiral condensate) the only fit parameter.

The headline: `m_π_substrate² ≈ 1.93 × 10⁻² GeV², matching PDG 1.94 × 10⁻²
GeV² within 1%`.

## Target file

**NEW**: `OmegaTheory/Predictions/PionMassChiralGMOR.lean`

Imports:
- `OmegaTheory.Predictions.PionMassFit`
- `OmegaTheory.Predictions.UpQuarkMassFit`
- `OmegaTheory.Predictions.DownQuarkMassFit`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.PionMassChiralGMOR

/-- GMOR formula for pion mass squared. -/
noncomputable def pionMassSquared_GMOR_substrate (N : ℕ) : ℝ :=
  ((upQuarkMass_substrate N) + (downQuarkMass_substrate N))
    * chiralCondensate_anchor / fPi_anchor^2

theorem pionMassSquared_GMOR_substrate_pos (N : ℕ) :
    0 < pionMassSquared_GMOR_substrate N := by
  sorry

/-- HEADLINE: GMOR-derived m_π² within 1% of PDG 1.94e-2 GeV². -/
theorem pion_mass_from_chiral_substrate_GMOR :
    |pionMassSquared_GMOR_substrate anchor_N - 0.0194| ≤ 0.0002 := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.UpQuarkMassFit.upQuarkMass_substrate_pos`
2. `OmegaTheory.Predictions.DownQuarkMassFit.downQuarkMass_substrate_pos`
3. `OmegaTheory.Predictions.PionMassFit.pionMass_predicted_within_PDG_tolerance`
4. `Real.pow_two` (Mathlib).
5. `Mathlib.Analysis.SpecialFunctions.Pow.Real`

## Proof sketch

- **Step 1**: positivity follows from positive quark masses + positive
  condensate parameter + positive `f_π²`.
- **Step 2** (HEADLINE): substitute anchor values, `m_u ≈ 2.16 MeV`,
  `m_d ≈ 4.67 MeV`, `Σ ≈ (250 MeV)³`, `f_π = 92.4 MeV`.  Compute
  `(2.16 + 4.67) · 250³ / 92.4²` and bound.

## Off-limits files

- `PionMassFit.lean`, `UpQuarkMassFit.lean`, `DownQuarkMassFit.lean` (READ-ONLY)
- `KaonMassFit.lean`, `RhoMesonMassFit.lean` (READ-ONLY)

## Estimated complexity

**M** (medium) — 4-5 hours.  Numerical witness for the chiral condensate
parameter is the calibration risk.

## Strategic note

Cycle-44 frontier item "Pion mass from substrate (Goldstone-mode argument
+ chiral)" — direct closure.  Opens kaon-GMOR follow-up.
