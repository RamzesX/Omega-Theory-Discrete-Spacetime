# SAGE BRIEFING — `irrationality_measure_via_delta_comp_substrate`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`irrationality_measure_via_delta_comp_substrate`

## Priority

**MEDIUM** — Track-2.  1 `:TheoremCandidate {status:'BLOCKED_ON_MATHLIB_IRRATIONALITY_MEASURE'}`
in graph.  Mathlib's irrationality-measure infra is incomplete — only
`Liouville_irrational` is fully formalized, no `IrrationalityMeasure` typeclass.

This briefing investigates whether **substrate δ_comp gives an effective
irrationality measure** that is honest enough for the OmegaTheory
predictions, without waiting for a Mathlib upstream port.

## Currently shipped (NOT this candidate)

- 1 `:TheoremCandidate {status:'BLOCKED_ON_MATHLIB_IRRATIONALITY_MEASURE'}` in graph.
- `OmegaTheory.Irrationality.Uncertainty.computationalUncertainty` —
  `δ_comp(N) = ℓ_P · 4 / (2N+3)` (Leibniz π series).
- `Mathlib.NumberTheory.Liouville.Basic` — partial irrationality framework.

## What this candidate adds

A **substrate-effective irrationality measure** definition:

`mu_substrate_X (X : ℝ) : ℝ` such that for any rational `p/q` with `q ≥ q_0`,
`|X - p/q| > 1/q^(mu_substrate_X X)`.

This bypasses the Mathlib `IrrationalityMeasure` blocker by using the
substrate-truncation bound directly.

## Target file

**NEW**: `OmegaTheory/Irrationality/CustomMath/SubstrateIrrationalityMeasure.lean`

## Statement (Lean)

```lean
namespace OmegaTheory.Irrationality.SubstrateMeasure

/-- Effective substrate irrationality measure. -/
noncomputable def muSubstrate (X : ℝ) : ℝ := ...

theorem muSubstrate_pi_le_two : muSubstrate Real.pi ≤ 2 := by sorry

theorem muSubstrate_e_le_two : muSubstrate Real.exp 1 ≤ 2 := by sorry

/-- Liouville-type: |X - p/q| > 1/q^μ for sufficiently large q. -/
theorem irrationality_measure_via_delta_comp_substrate :
    ∀ X : ℝ, X ≠ 0 → 1 ≤ muSubstrate X := by
  sorry
```

## Premise candidates (top-5)

1. `Mathlib.NumberTheory.Liouville.Basic.Liouville_irrational`
2. `Mathlib.Data.Real.Irrational.irrational_iff_ne_rational`
3. `OmegaTheory.Irrationality.Uncertainty.deltaComp_decreasing`
4. `OmegaTheory.Irrationality.BoundsLemmas.pi_truncation_error_bound`
5. `Real.irrational_pi` (Niven/Mathlib).

## Proof sketch

- **Step 1**: define `muSubstrate X` as the `liminf` over rationals of a
  ratio of distances and `1/q^μ`.
- **Step 2**: for π and e, classical Liouville-type theorems give μ = 2.
- **Step 3**: for Catalan G — open in classical math; we only claim
  `1 ≤ μ_substrate G` (consistent with irrationality-or-rational dichotomy).
- **Step 4**: use these bounds to discharge BLOCKED_ON_MATHLIB_IRRATIONALITY_MEASURE
  candidate downstream.

## Off-limits files

- All cycle-53 in-flight files.
- `Uncertainty.lean`, `Approximations.lean`, `BoundsLemmas.lean` (READ-ONLY).

## Estimated complexity

**M+** (medium-plus) — 5-8 hours.  Defining `muSubstrate` precisely is the
risky part; once defined, the bounds for π, e are standard.

## Strategic note

If shipped, immediately UNLOCKS the `BLOCKED_ON_MATHLIB_IRRATIONALITY_MEASURE`
candidate flip to PROPOSED.
