# SAGE BRIEFING — `kaon_mass_chiral_GMOR_substrate`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`kaon_mass_chiral_GMOR_substrate`

## Priority

**MEDIUM** — Track-1 (sister of pion-GMOR).  Kaon GMOR:
`m_K² · f_K² = -⟨q̄q⟩ · (m_q + m_s)` where `m_q ≈ (m_u + m_d)/2`. With
`m_u, m_d, m_s` all substrate-derived (`UpQuarkMassFit`, `DownQuarkMassFit`,
`StrangeQuarkMassFit`), this is a direct closure analogous to pion-GMOR.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.KaonMassFit.kaon_mass_substrate_fit_headline`
- `OmegaTheory.Predictions.KaonMassFit.substrateKaonMass_at_anchor_eq_PDG`
- `OmegaTheory.Predictions.KaonMassFit.kaonFit_is_middle_generation`

## What this candidate adds

Independent **chiral** route to the kaon mass (vs the existing fit route),
giving cross-validation: PDG `m_K = 493.677 MeV` from m_q + m_s + Σ + f_K.

## Target file

**NEW**: `OmegaTheory/Predictions/KaonMassChiralGMOR.lean`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.KaonMassChiralGMOR

noncomputable def kaonMassSquared_GMOR_substrate (N : ℕ) : ℝ :=
  ((upQuarkMass_substrate N + downQuarkMass_substrate N) / 2
    + strangeQuarkMass_substrate N) * chiralCondensate_anchor / fK_anchor^2

theorem kaonMassSquared_GMOR_substrate_pos (N : ℕ) :
    0 < kaonMassSquared_GMOR_substrate N := by
  sorry

theorem kaon_mass_chiral_GMOR_substrate :
    |kaonMassSquared_GMOR_substrate anchor_N - 0.2437| ≤ 0.005 := by
  sorry

theorem kaon_GMOR_consistent_with_fit :
    kaonMassSquared_GMOR_substrate anchor_N
      = (substrateKaonMass anchor_N)^2 := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.KaonMassFit.substrateKaonMass_at_anchor_eq_PDG`
2. `OmegaTheory.Predictions.UpQuarkMassFit.upQuarkMass_substrate_pos`
3. `OmegaTheory.Predictions.DownQuarkMassFit.downQuarkMass_substrate_pos`
4. `OmegaTheory.Predictions.StrangeQuarkMassFit.strangeQuarkMass_substrate_pos` (verify)
5. `OmegaTheory.Predictions.PionMassChiralGMOR.*` (sister briefing).

## Proof sketch

- Mirror the pion-GMOR briefing's `norm_num` strategy with kaon parameters.
- `f_K ≈ 110 MeV` (vs `f_π ≈ 92.4 MeV`).
- Chiral condensate Σ same as pion case.

## Off-limits files

- `KaonMassFit.lean`, `UpQuarkMassFit.lean`, `DownQuarkMassFit.lean`,
  `StrangeQuarkMassFit.lean` (READ-ONLY).
- All cycle-53 in-flight files.
- `PionMassChiralGMOR.lean` (sister briefing — wave coordination).

## Estimated complexity

**M-** (medium-low) — 3-4 hours.  Same template as pion-GMOR.

## Strategic note

Strengthens chiral-physics paper bundle.  If pion-GMOR + kaon-GMOR both
land in same wave, paper section "Chiral physics from substrate" becomes
a clean self-contained chapter.
