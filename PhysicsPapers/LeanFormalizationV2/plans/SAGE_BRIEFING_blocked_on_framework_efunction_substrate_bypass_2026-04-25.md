# SAGE BRIEFING — `BLOCKED_ON_FRAMEWORK_efunction_substrate_bypass`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`BLOCKED_ON_FRAMEWORK_efunction_substrate_bypass`

## Priority

**MEDIUM** — Track-2.  3 `:TheoremCandidate {status:'BLOCKED_ON_FRAMEWORK'}`
nodes in graph.  These were originally framed in terms of E-function theory
(generic transcendence framework). This briefing examines whether a
**substrate-only formulation** bypasses the E-function machinery entirely.

## Currently shipped (NOT this candidate)

- 3 `:TheoremCandidate {status:'BLOCKED_ON_FRAMEWORK'}` in graph.
- 1 `:TheoremCandidate {status:'BLOCKED_ON_MATHLIB_EFUNCTION_STRUCTURE'}`.
- `OmegaTheory/Irrationality/HermitePade/Decoupling.lean` — bridges
  E-function formalism through to substrate δ_comp uncertainty.

## What this candidate adds

For each of the 3 framework-blocked candidates: examine whether the
*physical content* (the prediction) can be re-stated as a **substrate-only
inequality** about `δ_comp(N)`, completely avoiding the E-function /
Hermite-Padé framework.

The standard recipe:
- Original blocked: `irrationality_class_of_X_is_S_via_efunction_theory`
- Substrate bypass: `δ_comp_X(N) > 0 for all N ≥ N_0` (concrete inequality)

## Target file

**NEW**: `plans/AUDIT_blocked_on_framework_substrate_bypass_2026-04-25.md`

For each of 3 graph nodes, produce a row:

| candidate | original framework dep | substrate bypass | viability |
|-----------|------------------------|------------------|-----------|
| ... | ... | δ_comp_X(N) > 0 ... | LIKELY/UNLIKELY |

## Statement (Lean — varies per candidate)

```lean
-- Example bypass pattern:
theorem irrationality_class_X_substrate_bypass (N : ℕ) (hN : N ≥ N0) :
    0 < deltaComp_X N := by
  -- proof uses substrate truncation positivity ONLY
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Irrationality.Uncertainty.deltaComp_pos`
2. `OmegaTheory.Irrationality.Approximations.*_truncation_pos`
3. `OmegaTheory.Irrationality.BoundsLemmas.*_error_bound`
4. `OmegaTheory.Irrationality.PredictionsBridge.*` (the existing bridges).
5. `OmegaTheory.Probe.PiAndOmegaStructure.irrationality_implies_quantum_uncertainty`

## Proof sketch

- **Step 1**: list the 3 BLOCKED_ON_FRAMEWORK candidate names + statement
  shapes.
- **Step 2**: for each, draft a substrate-only restatement.
- **Step 3**: check whether the restatement actually closes the *physical*
  prediction (vs the *transcendence-theory* framing).
- **Step 4**: write `AUDIT_*.md` + register `:GraphFinding` paper_worthy
  if at least 1 of 3 admits a clean bypass.

## Off-limits files

- All cycle-53 in-flight files.
- `Decoupling.lean` (READ-ONLY).

## Estimated complexity

**M-** (medium-low) — 3-5 hours, mostly graph + classification.

## Strategic note

If even 1 of 3 admits substrate bypass, that's a `:TheoremCandidate` flip
from BLOCKED to PROPOSED (and immediately wizard-actionable).  High
expected value.
