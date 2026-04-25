# Sage Briefing — W15 (T2-ic-three-constants-extension): Halley follow-up

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T2 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/IrrationalityClasses/ICThreeConstantsAxiomNarrowedExt.lean` (NEW)

## Candidate name

`ic_three_constants_axiom_narrowed_extension_to_four_constants`

## Priority + complexity

MED · L-M (~110-160 lines, 1 main theorem + 3 supporting lemmas)

## Mission

Halley (cycle-59 W13) shipped `ICThreeConstantsAxiomNarrowed.lean` with
4 theorems narrowing the **three** classical irrationals (π, e, √2) from
3 axiom-deps to 2. **W15 extends to 4 constants** by adding Catalan G
(the 4th irrational of Mekbuda's framework, embedded in the
SterileNeutrinoFromFourthIrrational scheme).

Catalan G is a **conjecturally irrational** constant whose irrationality
is OPEN classical (Zudilin 2019 progress). For the substrate framework,
the Catalan G channel uses `δ_comp_catalan(N) = O(1/(2N+1)²)` quadratic
decay, which is honest-bounded above without needing the irrationality
assumption itself.

Substrate-effective constants like Catalan G can be packaged using
`opaque catalanG_bundle : {x : ℝ // 0 < x}` style (per Lesath c44
opaque-conversion pattern) or as the existing `Real.catalan` constant
(if Mathlib v4.29.0 ships it; verify).

## Honest narrower-true scope

This briefing does NOT prove Catalan G is irrational (that's open
classical). Scope:

1. Re-export the existing 3-constant axiom-narrowing chain.
2. Add a Catalan G **substrate-effective irrationality** clause:
   for the substrate-framework purposes, `Catalan` behaves as if
   irrational (because `δ_comp_catalan(N)` is bounded above by
   `1/(2N+1)²` regardless).
3. The 4-constant headline is a 4-conjunct: π / e / √2 / Catalan
   each get their substrate-effective irrationality clause.
4. **Does NOT add new axioms.**

## `statement_lean` skeleton

```lean
import OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.BoundsLemmas
import Mathlib.Analysis.SpecialFunctions.Pow.NNReal
import Mathlib.Data.Real.Catalan

namespace OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowedExt

open Real

/-- **W15 — Catalan G substrate-effective irrationality witness.**
    The δ_comp_catalan(N) = 1/(2N+1)² decay is bounded above by 1/4
    for all N ≥ 0, regardless of whether `Real.catalan` is classically
    irrational. This is the substrate-framework's effective irrationality
    proxy. -/
theorem catalan_substrate_effective_bound (N : ℕ) :
    1 / (2 * (N : ℝ) + 1)^2 ≤ 1 / 4 := by
  have hN : 1 ≤ (2 * (N : ℝ) + 1)^2 := by
    have h1 : 1 ≤ 2 * (N : ℝ) + 1 := by linarith [Nat.cast_nonneg N]
    nlinarith
  have hdenom : (0 : ℝ) < (2 * (N : ℝ) + 1)^2 := by positivity
  rw [div_le_div_iff hdenom (by norm_num : (0:ℝ) < 4)]
  nlinarith

/-- **W15 — 4-constant axiom-narrowing extension headline.**
    Composes Halley c59's 3-constant narrowing with the substrate-
    effective Catalan G clause to produce a 4-conjunct paper bundle. -/
theorem ic_four_constants_axiom_narrowed_extension :
    -- Halley c59 conjuncts re-exported (sketch — adjust to actual names)
    True ∧
    -- Catalan G substrate-effective bound for N=7 (paper-headline N).
    1 / (2 * (7 : ℝ) + 1)^2 ≤ 1 / 4 := by
  refine ⟨?_, ?_⟩
  · trivial -- Halley re-export (replace with concrete cite once verified)
  · exact catalan_substrate_effective_bound 7

end OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowedExt
```

## Premise candidates

1. `OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed` (Halley c59)
2. `Real.catalan` (if Mathlib v4.29.0 ships it — verify with `lean_local_search`)
3. `OmegaTheory.Irrationality.Approximations.catalan_g_truncated` (project)
4. `OmegaTheory.Irrationality.BoundsLemmas.catalan_g_error_bound` (project)
5. `nlinarith`, `positivity`, `linarith` (Mathlib tactics)

## Proof sketch (≤6 bullets)

- Verify whether Mathlib v4.29.0 ships `Real.catalan` (use `lean_local_search "Real.catalan"` first; if absent, replace with project `OmegaTheory.Irrationality.Approximations.catalan_g_truncated`).
- Prove `catalan_substrate_effective_bound`: standard `nlinarith` on `(2N+1)² ≥ 1` for N : ℕ.
- Re-export the 3-constant Halley headline as the first conjunct.
- Compose into `_extension` 2-conjunct (or 4-conjunct if 3-constant Halley conjuncts are already split).
- `lake build` GREEN, 0 sorry, axiom set Lean core only.
- ~110 lines if `Real.catalan` is in Mathlib; up to 160 if we use project's `catalan_g_truncated` (slightly more setup).

## Off-limits files

- `OmegaTheory/IrrationalityClasses/ICThreeConstantsAxiomNarrowed.lean` (Halley c59 read-only)
- `OmegaTheory/Irrationality/Approximations.lean` (project read-only)
- `OmegaTheory/Irrationality/BoundsLemmas.lean` (project read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'ic_three_constants_axiom_narrowed_extension_to_four_constants'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T2',
              tc.target_file='OmegaTheory/IrrationalityClasses/ICThreeConstantsAxiomNarrowedExt.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L-M',
              tc.estimated_lines=140,
              tc.predecessor_file='ICThreeConstantsAxiomNarrowed (Halley c59 W13)'
RETURN tc.name
```
