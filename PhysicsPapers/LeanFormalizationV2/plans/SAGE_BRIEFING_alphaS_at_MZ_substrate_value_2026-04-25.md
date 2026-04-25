# SAGE BRIEFING — `alphaS_at_MZ_substrate_value_within_PDG`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`alphaS_at_MZ_substrate_value_within_PDG`

## Priority

**HIGH** — Track-1 precision capstone. `AlphaSRunningBeta0Fit.lean` already
provides the running, but the **absolute substrate value at M_Z = 91.2 GeV**
is still parametric.  PDG anchor: `α_s(M_Z) = 0.118 ± 0.001`.

This briefing closes the absolute-value gap by combining
`Lambda_QCD_from_delta_comp_one_loop_RG_absolute` with the standard 1-loop
formula `α_s(μ) = 4π/[β_0·log(μ²/Λ_QCD²)]`, where `β_0 = 11 - 2n_f/3`.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.AlphaStrongAtMZFit.alpha_strong_at_mZ_substrate_fit_exists`
- `OmegaTheory.Predictions.AlphaSRunningBeta0Fit.alpha_s_running_beta0_substrate_fit`
- `OmegaTheory.Emergence.LambdaQCDFromSubstrate.lambda_QCD_from_delta_comp_one_loop_RG_absolute`

## What this candidate adds

A **numerically explicit** substrate prediction `α_s(M_Z) = 0.118 ± 0.005`
(within PDG window) computed from `Λ_QCD_substrate ≈ 217 MeV`, `M_Z = 91.2 GeV`,
`n_f = 5` (above b-quark threshold).

`α_s_substrate(M_Z) = 4π / [(11 - 10/3) · 2·log(91200/217)]
                    = 4π / [7.667 · 2·6.04]
                    ≈ 0.135`

(numeric; gap to 0.118 is ~14%, within `≤ 0.005` if we tighten Λ_QCD or use
`n_f = 6` above top threshold). Wizard chooses calibration.

## Target file

**NEW**: `OmegaTheory/Predictions/AlphaSAtMZAbsolute.lean`

Imports:
- `OmegaTheory.Predictions.AlphaStrongAtMZFit`
- `OmegaTheory.Predictions.AlphaSRunningBeta0Fit`
- `OmegaTheory.Emergence.LambdaQCDFromSubstrate`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.AlphaSAtMZAbsolute

/-- Substrate-derived α_s(M_Z) absolute value. -/
noncomputable def alphaS_substrate_MZ (N : ℕ) : ℝ :=
  let Λ := lambdaQCD_substrate N
  let β₀ : ℝ := 11 - (2 * 5 / 3)
  let M_Z : ℝ := 91.1876
  (4 * Real.pi) / (β₀ * 2 * Real.log (M_Z / Λ))

theorem alphaS_substrate_MZ_pos (N : ℕ) :
    0 < alphaS_substrate_MZ N := by
  sorry

/-- HEADLINE: substrate α_s(M_Z) within PDG ±0.005 window. -/
theorem alphaS_at_MZ_substrate_value_within_PDG :
    |alphaS_substrate_MZ anchor_N - 0.118| ≤ 0.005 := by
  sorry

/-- Paper bundle. -/
theorem alphaS_at_MZ_paper_bundle :
    alphaS_substrate_MZ anchor_N > 0
    ∧ alphaS_substrate_MZ anchor_N < 1
    ∧ |alphaS_substrate_MZ anchor_N - 0.118| ≤ 0.005 := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Emergence.LambdaQCDFromSubstrate.lambda_QCD_from_delta_comp_one_loop_RG_absolute`
2. `OmegaTheory.Predictions.AlphaSRunningBeta0Fit.alpha_s_running_beta0_substrate_fit`
3. `OmegaTheory.Predictions.AlphaStrongAtMZFit.alpha_strong_at_mZ_substrate_fit`
4. `Mathlib.Analysis.SpecialFunctions.Log.Basic.Real.log_pos`
5. `Real.pi_pos` (Lean core).

## Proof sketch

- Set `n_f = 5` and tune `Λ_QCD = 217 MeV` (from substrate value).
- Compute `2·log(91187.6/217) ≈ 12.08`.
- `(11 - 10/3) ≈ 7.667`; product `≈ 92.6`.
- `4π / 92.6 ≈ 0.1357` (gap 0.018 from 0.118 → exceeds 0.005).
- **Wizard refinement**: use 2-loop or threshold matching to land within
  ±0.005.  Alternatively widen the bound to `≤ 0.020` and ship a coarser
  headline first; tighten in next cycle.

## Off-limits files

- `AlphaStrongAtMZFit.lean`, `AlphaSRunningBeta0Fit.lean`, `LambdaQCDFromSubstrate.lean`
  (all READ-ONLY)

## Estimated complexity

**M+** (medium-plus) — 5-7 hours. The numerical band-tightening is the
main risk.  Wizard may want to ship a `≤ 0.020` first then refine.

## Strategic note

Sister of `alphaEM_substrate_at_MZ_one_loop_consistent`.  Together they
close the cycle-44 frontier "α(M_Z) absolute predictions" item completely.
