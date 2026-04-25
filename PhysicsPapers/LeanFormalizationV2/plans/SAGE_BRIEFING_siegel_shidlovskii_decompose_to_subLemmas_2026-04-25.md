# SAGE BRIEFING — `siegel_shidlovskii_decompose_to_lean_sized_sublemmas`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`siegel_shidlovskii_decompose_to_lean_sized_sublemmas`

## Priority

**MEDIUM** — Track-2 (axiom elimination roadmap).  The
`BLOCKED_ON_MATHLIB_SIEGEL_SHIDLOVSKII` candidates (2 in graph) are sealed
research-track placeholders.  This briefing **decomposes** the
Siegel-Shidlovskii theorem (transcendence of values of E-functions) into
10-15 Lean-sized sub-lemmas, each a candidate for in-house port.

## Currently shipped (NOT this candidate)

- 2 `:TheoremCandidate {status:'BLOCKED_ON_MATHLIB_SIEGEL_SHIDLOVSKII'}` in graph.
- `OmegaTheory/Irrationality/HermitePade/Decoupling.lean` — Theorem 4C.3 (0 sorry,
  proves the bridge from Siegel-Shidlovskii to substrate uncertainty).

## What this candidate adds

A **roadmap document** decomposing Siegel-Shidlovskii into:

| sub-lemma | mathematical content | difficulty |
|-----------|---------------------|------------|
| 1 | E-function definition (analytic) | EASY |
| 2 | Padé approximation existence | EASY |
| 3 | Hermite-Padé construction (small order) | MED |
| 4 | Determinantal identity for E-functions | MED |
| 5 | Algebraic independence at finite Q-rank | MED |
| 6 | Liouville-type bound | MED |
| 7 | Auxiliary polynomial construction | HARD |
| 8 | Shidlovskii's bound on Padé denominator | HARD |
| 9 | Reduction modulo prime | HARD |
| 10 | Final transcendence conclusion | HARD |

Each sub-lemma becomes a `:TheoremCandidate` to attack incrementally.

## Target file

**NEW**: `plans/ROADMAP_siegel_shidlovskii_decomposition_2026-04-25.md`
**NEW**: `OmegaTheory/Irrationality/CustomMath/SiegelShidlovskiiSubLemmas.lean`
        (initially imports + `axiom`-stub statements; wizard fills incrementally)

## Statement (skeleton)

```lean
namespace OmegaTheory.Irrationality.SiegelShidlovskii

/-- Stage 1: E-function with rational coefficients. -/
def IsEFunction (f : ℕ → ℚ) : Prop := ...

/-- Stage 2: Padé approximation existence. -/
theorem padeApproximation_exists
    (f : ℕ → ℚ) (hf : IsEFunction f) (n : ℕ) :
    ∃ p q : Polynomial ℚ, ... := by sorry  -- target sub-lemma 2

-- ... etc through stage 10
```

## Premise candidates (top-5)

1. `Mathlib.Analysis.Analytic.Basic` — analytic functions.
2. `Mathlib.RingTheory.Polynomial.Basic` — polynomial constructions.
3. `Mathlib.NumberTheory.Liouville.Basic` — irrationality measure.
4. `OmegaTheory.Irrationality.HermitePade.Decoupling` — existing bridge.
5. Nesterenko 1996 / Siegel original 1929 references.

## Proof sketch

(Roadmap; no full Lean proof.)

- **Stage 1**: define `IsEFunction` (Mathlib likely has parts).
- **Stage 2-3**: Padé existence + Hermite-Padé construction by induction
  on n. Estimated 50-100 lines each.
- **Stage 4-6**: determinantal identity, alg-indep via Liouville. Use
  Mathlib's Liouville framework.
- **Stage 7-10**: HARD; each may require its own multi-cycle subgoal tree.
  Roadmap recommends: ATTACK 1-3 in cycle-54+, defer 7-10 to next quarter.

## Off-limits files

- All cycle-53 in-flight files.
- `OmegaTheory/Irrationality/HermitePade/Decoupling.lean` (cycle-43 territory; READ-ONLY).

## Estimated complexity

**M** (medium) for the roadmap deliverable — 4-6 hours of literature audit
and decomposition.

**The roadmap UNLOCKS multi-cycle work**; subsequent cycles attack one
sub-lemma at a time.  This is the "spec" for the next 5-10 cycles of
Track-2 work.

## Strategic note

Sister briefings: same pattern for Nesterenko 1996, Roth 1955, Mahler
framework, Rivoal-Zudilin, André motivic.  Shipping the roadmap unlocks
parallel wizards for each transcendence-result decomposition.
