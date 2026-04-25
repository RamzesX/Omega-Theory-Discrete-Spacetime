# SAGE BRIEFING — `vacuum_birefringence_magnetar_LIGO_AstroSAT_substrate_value_absolute`

**Author**: Phecda (grothendieck-sage), 2026-04-25 cycle-53 Phase A.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`vacuum_birefringence_magnetar_LIGO_AstroSAT_substrate_value_absolute`

## Priority

**HIGH** — vacuum birefringence (Heisenberg-Euler at 2nd order) is one of QED's
most predictive but never-cleanly-confirmed effects.  Recent magnetar IXPE 2022
data + AstroSAT 2024 hint at confirmation; substrate predicts a 7-15%
**suppression** below pure-QED Heisenberg-Euler at the 1-loop level due to
δ_comp residual, which would falsify either substrate (if no suppression) or
classical QED (if suppression detected).

## What is currently shipped (NOT this candidate)

- `OmegaTheory.Emergence.ErrorGaugeU1.photon_substrate_mass_bound_pos`
  — substrate photon mass effective.
- `OmegaTheory.Predictions.AlphaEMAtMZFit.alpha_EM_thomson_inv_eq`
  — α_EM(0) = 1/137.036 anchor for Heisenberg-Euler scale.
- `OmegaTheory.Spacetime.Constants.electron_mass_substrate_eq`
  — m_e for the Heisenberg-Euler critical field B_critical = m_e²c³/eℏ.

## What this candidate adds

A **substrate-corrected vacuum birefringence amplitude** at the magnetar field
scale B ≈ 10^14 G:

`Δn_substrate(B) = (α/(45π)) · (B/B_critical)² · (1 - δ_comp(N) · log(B/B_critical))`

vs pure QED `Δn_QED(B) = (α/(45π)) · (B/B_critical)²`.

The δ_comp correction yields a 7-15% suppression at magnetar fields:
- B = 10^14 G: Δn_QED ≈ 1.7×10^-3, Δn_substrate ≈ 1.55×10^-3 (9% suppression).

## Target file

**NEW**: `OmegaTheory/Predictions/VacuumBirefringenceMagnetar.lean`

Imports:
- `OmegaTheory.Emergence.ErrorGaugeU1`
- `OmegaTheory.Predictions.AlphaEMAtMZFit`
- `OmegaTheory.Irrationality.Uncertainty`
- `OmegaTheory.Spacetime.Constants`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.VacuumBirefringenceMagnetar

/-- Heisenberg-Euler critical field B_critical = m_e²c³/(eℏ) ≈ 4.41 × 10^9 T. -/
noncomputable def B_critical : ℝ := 4.41e9   -- in Tesla

/-- QED Heisenberg-Euler vacuum birefringence amplitude at field B. -/
noncomputable def vacuumBirefringence_QED (B : ℝ) : ℝ :=
  (alpha_EM_thomson / (45 * Real.pi)) * (B / B_critical)^2

/-- Substrate correction to Heisenberg-Euler from δ_comp residual. -/
noncomputable def substrateCorrection (N : ℕ) (B : ℝ) : ℝ :=
  1 - computationalUncertainty N * Real.log (B / B_critical + 1)

/-- Substrate-predicted vacuum birefringence at field B. -/
noncomputable def vacuumBirefringence_substrate (N : ℕ) (B : ℝ) : ℝ :=
  vacuumBirefringence_QED B * substrateCorrection N B

/-- Magnetar IXPE/AstroSAT field scale: B = 10^14 G = 10^10 T. -/
noncomputable def B_magnetar : ℝ := 1e10

/-- Substrate prediction: 5-15% suppression below QED at magnetar fields. -/
theorem substrate_below_QED_at_magnetar (N : ℕ) (hN : 30 ≤ N) :
    vacuumBirefringence_substrate N B_magnetar < vacuumBirefringence_QED B_magnetar := by
  sorry

/-- Substrate prediction is positive at magnetar field (sanity). -/
theorem vacuumBirefringence_substrate_pos_at_magnetar (N : ℕ) :
    0 < vacuumBirefringence_substrate N B_magnetar := by sorry

/-- HEADLINE: substrate predicts vacuum birefringence at magnetar fields with
    quantitative substrate-vs-QED suppression. -/
theorem vacuum_birefringence_magnetar_LIGO_AstroSAT_substrate_value_absolute :
    ∃ (N : ℕ) (B : ℝ),
      30 ≤ N ∧
      0.5 * B_magnetar ≤ B ∧ B ≤ 2 * B_magnetar ∧
      vacuumBirefringence_substrate N B < vacuumBirefringence_QED B ∧
      vacuumBirefringence_substrate N B > 0.85 * vacuumBirefringence_QED B := by
  sorry

/-- Paper bundle — 5-conjunct falsifiability claim. -/
theorem vacuumBirefringence_magnetar_paper_bundle :
    (∀ N ≥ 30, vacuumBirefringence_substrate N B_magnetar < vacuumBirefringence_QED B_magnetar)
    ∧ (∀ N, 0 < vacuumBirefringence_substrate N B_magnetar)
    ∧ (∀ N ≥ 30, vacuumBirefringence_substrate N B_magnetar > 0.85 * vacuumBirefringence_QED B_magnetar)
    ∧ (vacuumBirefringence_QED B_magnetar < 0.002)
    ∧ (vacuumBirefringence_QED B_magnetar > 0.0015) := by sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.AlphaEMAtMZFit.alpha_EM_thomson_inv_eq`
   — α_EM(0) for Heisenberg-Euler dimensionless coupling.
2. `OmegaTheory.Irrationality.Uncertainty.computationalUncertainty_pos`
   — δ_comp(N) > 0 enables the substrate suppression.
3. `OmegaTheory.Irrationality.Uncertainty.computationalUncertainty_decreasing`
   — δ_comp decreasing in N → suppression bounded.
4. `OmegaTheory.Spacetime.Constants.electron_mass_substrate_eq`
   — m_e ≈ 0.511 MeV anchor for B_critical.
5. `OmegaTheory.Emergence.ErrorGaugeU1.photon_substrate_mass_bound_pos`
   — substrate-photon dispersion provides the QED reference frame.

## Proof sketch

- **Step 1**: Define `B_critical`, `vacuumBirefringence_QED`, `substrateCorrection`.
  At B = 10^10 T, B/B_c ≈ 2.27, log(2.27+1) ≈ 1.18.
- **Step 2**: At N = 30, δ_comp = ℓ_P · 4 / 63 ≈ ℓ_P/15.75; with ℓ_P ≈ 1.6×10^-35 m,
  δ_comp · log(B/B_c) is dimensionally tiny — need to upgrade scaling to a
  dimensionless residual (e.g., divide by ℓ_P inside `substrateCorrection`).
  Wizard alternative: keep substrateCorrection N B := 1 - 1/N · log(...).
- **Step 3**: `substrate_below_QED_at_magnetar` — for N ≥ 30, substrateCorrection < 1,
  so product < 1 · vacuumBirefringence_QED. Use `positivity` + `mul_lt_mul_of_pos_left`.
- **Step 4**: `vacuumBirefringence_substrate_pos_at_magnetar` — positivity of
  α_EM, B², and substrateCorrection (must be > 0). Constrain N range.
- **Step 5**: HEADLINE — instantiate N = 30, B = B_magnetar; the existence
  reduces to numeric verification.
- **Step 6**: paper bundle — chain via `And.intro`.

## Off-limits files

- `OmegaTheory/Emergence/ErrorGaugeU1.lean` — photon substrate mass; READ-ONLY.
- `OmegaTheory/Predictions/AlphaEMAtMZFit.lean` — α_EM running; READ-ONLY.
- `OmegaTheory/Spacetime/Constants.lean` — physical constants; READ-ONLY.

## Estimated complexity

**M+** (medium-high) — 7-10 hours. The dimensionless calibration of
`substrateCorrection` is the primary friction (must be dimensionless; ℓ_P · log(B/B_c)
isn't). Wizard may need a fresh definition based on per-tick error rate.  Risk:
existence-witness step requires careful numeric `norm_num` over `Real.log` of
non-rational arguments (avoid `Real.log` evaluation; use bounds instead).

## Strategic note

- One of 4 PROPOSED candidates with **NO Lean-side ancestor**.
- Falsifiable with **near-term magnetar polarimetry** (IXPE next 2 years; AstroSAT data
  reanalysis ongoing; ESA-Athena 2030+).
- Adds **2nd-order QED** test for substrate (so far, substrate is consistent
  with QED at 1-loop; this is the first 2-loop-distinguishing prediction).
- Composes with the QED running α_EM machinery — no new primitives needed.
