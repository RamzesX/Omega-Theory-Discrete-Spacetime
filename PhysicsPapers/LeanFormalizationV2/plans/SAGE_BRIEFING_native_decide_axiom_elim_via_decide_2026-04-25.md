# SAGE BRIEFING — `native_decide_axiom_elim_via_pure_decide`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`native_decide_axiom_elim_via_pure_decide`

## Priority

**HIGH** — Track-2.  The graph contains 2 `:TheoremCandidate` with
`status=AUTO_GENERATED_NATIVE_DECIDE`.  These are leftover from the cycle-49
P3t closure's `native_decide` tactics — each `native_decide` use registers
an axiom `_native_decide_ax_*` in the kernel.

We replace `native_decide` with `decide` where the proposition is
genuinely decidable in fewer kernel reductions, OR factor through a
non-native_decide path.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Algebra.GellMann.LinearIndependence` — uses `native_decide` for
  the 64-pair commutator computation.
- `:TheoremCandidate {status:'AUTO_GENERATED_NATIVE_DECIDE'}` × 2 nodes in graph.
- Cycle-49 P3t Phase 2 has `gellMann_commutator` lemma.

## What this candidate adds

For each `native_decide` use:
1. Try replacing with `decide` and re-running build (timing).
2. If `decide` times out, factor the lemma through smaller Fin cases (e.g. 8
   sub-lemmas of 8-pair commutators each).
3. Once axiom-free, register in graph as `CLOSED_BY_NATIVE_DECIDE_ELIM`.

Expected reduction: 2 axioms removed from `axiom_audit` count (currently
2 `:TheoremCandidate` in `AUTO_GENERATED_NATIVE_DECIDE` state).

## Target file (READ-ONLY classification + ONE axiom-elim pull)

**TO MODIFY**: `OmegaTheory/Algebra/GellMann/LinearIndependence.lean`
(or wherever `gellMann_commutator` resides; wizard inspects).

**NEW** (audit deliverable): `plans/AUDIT_native_decide_axioms_2026-04-25.md`.

## Statement (Lean)

```lean
namespace OmegaTheory.Algebra.GellMann.LinearIndependence

-- Existing (for reference):
-- theorem gellMann_commutator_64_cases : ... := by native_decide

-- Replacement (target):
theorem gellMann_commutator_64_cases_decide_only : ... := by decide
-- or, if too slow:
theorem gellMann_commutator_via_8_subcases : ... := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals decide
```

## Premise candidates (top-5)

1. `decide` tactic (Lean core).
2. `OmegaTheory.Algebra.GellMann.GellMannMatrices.lean` — Fin-decomposition.
3. `Mathlib.Logic.Basic.Decidable` typeclass instances.
4. `omega` tactic for arithmetic-only bits.
5. `native_decide` — old usage to be replaced.

## Proof sketch

- **Step 1**: identify all `native_decide` invocations: grep
  `~/lean-v2/OmegaTheory -name '*.lean' -exec grep -l native_decide {} \;`.
- **Step 2**: for each, `lean_multi_attempt ["decide", "Decidable.decide", "native_decide"]`
  to test if `decide` succeeds in <5s (acceptable).  If succeeds → replace.
- **Step 3**: if `decide` times out, factor into Fin-cases (`fin_cases` +
  `decide` per case).
- **Step 4**: `lake build` clean → axiom_audit shows reduction.

## Off-limits files

- All cycle-53 in-flight files.
- `OmegaTheory/Predictions/P3t*.lean` (cycle-49 territory; READ-ONLY).

## Estimated complexity

**S** (small) — 2-4 hours per `native_decide` use. With 2-3 sites the wave
total is 4-8 hours.  Risk: `decide` blowup time on 64-pair commutators —
fall back to fin_cases factoring (well-understood).

## Strategic note

Track-2 quick win. Each axiom removed brings paper-headline count toward
the floor (1 → 0 if ALL native_decide axioms gone, but we'd still have
`Real.pi_transcendental`).  Closes 2 graph candidates in one wave.
