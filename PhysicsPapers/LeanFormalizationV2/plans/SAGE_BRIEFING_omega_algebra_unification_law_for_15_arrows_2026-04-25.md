# SAGE BRIEFING — `omega_algebra_unification_law_for_15_arrows`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`omega_algebra_unification_law_for_15_arrows`

## Priority

**HIGH** — Track-3 (graph-meta + algebra).  The 15 typed arrows
(IMPORTS, EXTENDS, INSTANTIATES, ASSUMES, APPLIES, UNFOLDS, HAS_TYPE,
CONSTRAINED_BY, PARAMETRIZES_TYPES, PARAMETRIZES_LEVELS, REDUCES_TO,
ELABORATES_AS, SPECIALIZES, GENERALIZES, REWRITES_BY) form Ω-algebra's
operad. This briefing produces a **Lean witness** of an algebraic
identity between two arrow compositions.

Specifically: `(SPECIALIZES ∘ APPLIES) = APPLIES`.  Specializing X then
applying Y is equivalent to just applying Y on the specialization. This
is operadically obvious but not yet Lean-witnessed.

## Currently shipped (NOT this candidate)

- 12 `:QuiverComposition` nodes in graph.
- 7 `:SelectionRule` nodes (forbidden compositions).
- No Lean-side identity theorems for any arrow composition.

## What this candidate adds

A Lean-side identity for (at least) one canonical composition. This
formalizes the algebra-of-arrows in Lean (versus only in graph).

## Target file

**NEW**: `OmegaTheory/Algebra/QuiverArrowIdentities.lean`

## Statement (Lean, mock — wizard refines)

```lean
namespace OmegaTheory.Algebra.QuiverArrowIdentities

/-- Quiver-arrow operadic identity: SPECIALIZES then APPLIES = APPLIES. -/
theorem quiver_arrow_identity_specializes_then_applies
    (T₁ T₂ T₃ : Theorem) (h_spec : Specializes T₁ T₂) (h_app : Applies T₂ T₃) :
    Applies T₁ T₃ := by
  -- proof: by transitivity of APPLIES through SPECIALIZES.
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.LeanAlgebra.QuiverArrow.applies_def`
2. `OmegaTheory.LeanAlgebra.QuiverArrow.specializes_def`
3. `OmegaTheory.LeanAlgebra.QuiverComposition.composition_def`
4. `Mathlib.CategoryTheory.Category.Basic.Functor.comp`
5. Operad-style lemmas in Mathlib.

## Proof sketch

- **Step 1**: define `Applies`, `Specializes` as predicates on (Theorem ×
  Theorem). They may already be classes.
- **Step 2**: prove transitivity-style lemma. Likely 5-10 lines once the
  predicates are unfolded.
- **Step 3**: register the identity as part of the LeanAlgebra schema.

## Off-limits files

- `OmegaTheory/LeanAlgebra/*` (existing schema, READ-ONLY).
- All cycle-53 in-flight files.

## Estimated complexity

**M** (medium) — 4-6 hours.  Risk: predicates `Applies`, `Specializes` may
be informal in current schema; wizard must elevate them to Lean predicates
first.

## Strategic note

The "OmegaAlgebra" research direction (Apr 2026 user mandate) lives or
dies on whether the 15 arrows admit Lean-side algebraic identities.
This is THE prototype proof. If it lands, ~5-10 sister identities become
candidates in next cycles.

Track-3 because it's a graph-meta theorem about the substrate's own
arrow algebra.
