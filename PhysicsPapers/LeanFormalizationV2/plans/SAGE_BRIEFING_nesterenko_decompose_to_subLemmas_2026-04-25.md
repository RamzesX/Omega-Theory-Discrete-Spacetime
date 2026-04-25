# SAGE BRIEFING — `nesterenko_1996_decompose_to_lean_sized_sublemmas`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`nesterenko_1996_decompose_to_lean_sized_sublemmas`

## Priority

**MEDIUM** — Track-2 (sister of Siegel-Shidlovskii decomposition).
1 `:TheoremCandidate {status:'BLOCKED_ON_MATHLIB_NESTERENKO_1996'}` in graph.
Nesterenko 1996 result: algebraic independence of `π, e^π, Γ(1/4)`.

## Currently shipped (NOT this candidate)

- 1 `:TheoremCandidate {status:'BLOCKED_ON_MATHLIB_NESTERENKO_1996'}`.
- `OmegaTheory/Irrationality/HermitePade/` sealed area.

## What this candidate adds

Roadmap document decomposing Nesterenko 1996 into 8-12 Lean-sized sub-lemmas:

| sub-lemma | content | difficulty |
|-----------|---------|------------|
| 1 | Γ(1/4) definition | EASY |
| 2 | Eisenstein series E₂, E₄, E₆ | MED |
| 3 | Nesterenko-style polynomial identity | MED |
| 4 | Modular form parametrization | MED |
| 5 | Algebraic indep degree 2 | HARD |
| 6 | Algebraic indep degree 3 | HARD |
| 7-9 | Auxiliary technical | HARD |
| 10 | Final transcendence | HARD |

## Target file

**NEW**: `plans/ROADMAP_nesterenko_1996_decomposition_2026-04-25.md`
**NEW**: `OmegaTheory/Irrationality/CustomMath/NesterenkoSubLemmas.lean` (skeleton)

## Statement (skeleton, no full proofs in this briefing)

```lean
namespace OmegaTheory.Irrationality.Nesterenko1996

/-- Stage 1 stub: Γ(1/4) value. -/
noncomputable def gammaQuarterValue : ℝ := Real.Gamma (1/4)

/-- Stage 2 stub: Eisenstein series. -/
def eisensteinE_k (k : ℕ) (q : ℂ) : ℂ := ...

-- Eventually:
theorem nesterenko_1996_alg_indep_pi_eToPi_gammaQuarter :
    AlgebraicallyIndependent ℚ ![Real.pi, Real.exp Real.pi, gammaQuarterValue] := by
  sorry
```

## Premise candidates (top-5)

1. `Mathlib.Analysis.SpecialFunctions.Gamma.Basic` — Γ function.
2. `Mathlib.NumberTheory.ModularForms.Basic`
3. `Mathlib.Algebra.Algebra.AlgebraicIndependence`
4. `Real.exp` analytic functions.
5. Nesterenko's 1996 paper (literature reference).

## Proof sketch

(Roadmap; no full proof.)

- Stage 1-2 EASY/MED in Mathlib.
- Stage 3-6 require introducing Hermite-Padé style auxiliary polynomials
  + Liouville bounds.
- Stage 7-10 HARD; each is a self-contained mini-paper.

## Off-limits files

- `HermitePade/Decoupling.lean` (READ-ONLY).
- All cycle-53 in-flight files.

## Estimated complexity

**M** (medium) — 4-6 hours for the roadmap.

## Strategic note

Each Nesterenko sub-lemma becomes a separate `:TheoremCandidate` for
multi-cycle attack.  Sister of Siegel-Shidlovskii decomp — together they
form the porting roadmap for the 9 HermitePadé research axioms.
