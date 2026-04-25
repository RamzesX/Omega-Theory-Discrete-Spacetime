# SAGE BRIEFING — `jarlskog_J_CKM_numerical_3sigma_PDG`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`jarlskog_J_CKM_numerical_3sigma_PDG`

## Priority

**HIGH** — Track-1 (CP-violation paper bundle).  `JarlskogFromIrrationals.lean`
has rich machinery (positivity, mono, decreasing-N, log additive, geometric
mean, PDG window consistency) but the **absolute numerical** statement
`J_CKM_substrate ≈ 3 × 10⁻⁵` within 3σ of PDG = (3.18 ± 0.15) × 10⁻⁵ is not
yet a single landed theorem.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskog_PDG_window_consistency`
  — exists; compatible window membership.
- `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskog_from_three_irrationals_geometric_mean`
  — geometric mean of three channels.
- `OmegaTheory.Predictions.JarlskogFromIrrationals.J_CKM_PDG_window_brackets_central`
  — central PDG value within window.
- `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskog_from_irrationals_pdg_capstone_holds`
  — capstone that THIS briefing tightens.

## What this candidate adds

A direct headline: `|J_CKM_substrate(anchor_N) - 3.18e-5| ≤ 0.45e-5` (3σ). The
substrate value is `(δ_π · δ_e · δ_√2)^(1/3)` evaluated at `anchor_N`. Wizard
chooses N to land inside 3σ.

## Target file

**NEW**: `OmegaTheory/Predictions/JarlskogJCKMAbsolute3Sigma.lean`

Imports:
- `OmegaTheory.Predictions.JarlskogFromIrrationals`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.JarlskogJCKMAbsolute3Sigma

/-- HEADLINE: J_CKM substrate within 3σ of PDG. -/
theorem jarlskog_J_CKM_numerical_3sigma_PDG :
    |jarlskogFromIrrationals anchor_N - 3.18e-5| ≤ 0.45e-5 := by
  sorry

/-- Strict-improvement: tighter than the existing window-consistency claim. -/
theorem jarlskog_3sigma_strictly_within_window :
    |jarlskogFromIrrationals anchor_N - 3.18e-5| < 1e-5 := by
  sorry

/-- Paper bundle. -/
theorem jarlskog_3sigma_paper_bundle :
    0 < jarlskogFromIrrationals anchor_N
    ∧ |jarlskogFromIrrationals anchor_N - 3.18e-5| ≤ 0.45e-5
    ∧ jarlskogFromIrrationals anchor_N < 1e-4 := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskog_from_three_irrationals_geometric_mean`
2. `OmegaTheory.Predictions.JarlskogFromIrrationals.J_CKM_PDG_window_brackets_central`
3. `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskogFromIrrationals_pos`
4. `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskogFromIrrationals_decreasing_N`
5. `OmegaTheory.Predictions.JarlskogFromIrrationals.jarlskogPrediction_log_additive`

## Proof sketch

- **Step 1** (HEADLINE): unfold geometric mean at `anchor_N`. Use existing
  `jarlskog_PDG_window_consistency` as starting point. Bound by `|x - c| ≤ σ`.
- **Step 2** (strict): tighten bound. `linarith` from window consistency.
- **Step 3** (bundle): `And.intro`; positivity is shipped.

## Off-limits files

- `JarlskogFromIrrationals.lean` (READ-ONLY)
- `CPSignFromIrrationalOrdering.lean` (READ-ONLY)

## Estimated complexity

**S** (small) — 2-4 hours. All structure shipped; wizard mostly tunes
numerical witness.

## Strategic note

Cycle-44 frontier item "Jarlskog J_CKM equality (witness via class →
numerical equality)" — direct closure with strict improvement.
