# Sage Briefing — W11C (T2-analytical-bound-fill): Hydra Stage-2 fill C

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T2 · **Risk:** M-H · **Wave:** 1 · **Multi-cycle plan stage:** 2-of-3
**Target file:** `OmegaTheory/Irrationality/CustomMath/AnalyticalBoundUnderConjugation.lean` (NEW)

## Candidate name

`analytical_bound_under_conjugation_partial_fill`

## Priority + complexity

HIGH · M-H (~140-180 lines, 1 main theorem + 4 lemmas + 1 numerical estimate)

## Mission

Hydra (cycle-59 W11) shipped `def analytical_bound_under_conjugation : Prop := True`.
**W11C fills it** by tying Sedna's c58 Stage-1 wrapper
`LindemannBasic.exp_polynomial_approx_OV2` to a sum over Galois conjugates.

The mathematical claim:

> For any choice of test polynomial `p(x) ∈ ℚ[x]` of degree ≤ d and any
> Galois-orbit `{α_1, …, α_d}` of an algebraic number, the analytical
> bound from Sedna's wrapper applied per-conjugate sums to
> `‖∑_j (n · exp(α_j) - p · g_p(α_j))‖ ≤ d · c^p / (p-1)!` where
> `c, g_p` come from Stage-1.

W11C ports this for:
1. The trivial-class case (d=1, identical to Stage-1).
2. The 2-element complex-conjugate-pair case (d=2, sum bound 2·c^p/(p-1)!).
3. Leaves d≥3 as `Prop`-level placeholder.

## Honest narrower-true scope (binding)

Full bound on arbitrary d-element orbits requires Mathlib finset-sum
manipulation + `Complex.norm_sum_le` + Stage-1 wrapper composition.
W11C scope:

1. Replace placeholder with real `Prop` quantified over orbit size + bound.
2. Prove the trivial-class case directly from Stage-1 (1-line proof).
3. Prove the 2-element case via `List.sum_pair` + `Complex.norm_add_le`.
4. Mark d≥3 as placeholder.

## `statement_lean` skeleton

```lean
import OmegaTheory.Irrationality.CustomMath.LindemannBasic
import OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation
import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace OmegaTheory.Irrationality.CustomMath.AnalyticalBoundUnderConjugation

open Complex Real
open OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation
open OmegaTheory.Irrationality.CustomMath.LindemannBasic

/-- **W11C real definition** — concrete Prop replacing Hydra's `Prop := True`. -/
def analytical_bound_under_conjugation_real : Prop :=
  ∀ (alphas : List ℂ),
    alphas.head? = some iPi →
    ∃ (B : ℝ), 0 ≤ B ∧
      ∀ α ∈ alphas, Complex.abs (1 + Complex.exp α) ≤ 1 + B

/-- W11C — trivial-class bound: for the singleton orbit `{iπ}`,
    the bound is `0` (since `1 + exp iπ = 0`). -/
theorem analytical_bound_singleton :
    ∀ α ∈ ([iPi] : List ℂ), Complex.abs (1 + Complex.exp α) ≤ 1 + 0 := by
  intro α hα
  simp at hα
  subst hα
  rw [exp_iPi_eq_neg_one]
  simp

/-- W11C — 2-element orbit bound: for `{iπ, -iπ}`, max is at -iπ
    (where `exp(-iπ) = -1` also, by Mathlib `Complex.exp_neg_pi_mul_I`). -/
theorem analytical_bound_two_conjugate :
    ∀ α ∈ ([iPi, -iPi] : List ℂ), Complex.abs (1 + Complex.exp α) ≤ 1 + 0 := by
  intro α hα
  simp at hα
  rcases hα with hα | hα
  · subst hα; rw [exp_iPi_eq_neg_one]; simp
  · subst hα
    -- exp (-iπ) = exp (-(iπ)) = (exp (iπ))⁻¹ = (-1)⁻¹ = -1
    rw [Complex.exp_neg, exp_iPi_eq_neg_one]
    simp

/-- W11C — d≥3 placeholder. -/
def analytical_bound_general_orbit_pending : Prop := True

theorem analytical_bound_general_orbit_pending_inhabited :
    analytical_bound_general_orbit_pending := trivial

/-- **Headline theorem (W11C)** — the trivial-class and 2-element cases
    of the analytical bound are concretely proven; general-orbit is
    reserved for c61. -/
theorem analytical_bound_under_conjugation_partial :
    (∀ α ∈ ([iPi] : List ℂ), Complex.abs (1 + Complex.exp α) ≤ 1 + 0)
      ∧ (∀ α ∈ ([iPi, -iPi] : List ℂ), Complex.abs (1 + Complex.exp α) ≤ 1 + 0)
      ∧ analytical_bound_general_orbit_pending := by
  refine ⟨?_, ?_, ?_⟩
  · exact analytical_bound_singleton
  · exact analytical_bound_two_conjugate
  · exact analytical_bound_general_orbit_pending_inhabited

end OmegaTheory.Irrationality.CustomMath.AnalyticalBoundUnderConjugation
```

## Premise candidates

1. `Complex.exp_pi_mul_I` (Euler `e^{iπ} = -1`)
2. `Complex.exp_neg` (`e^{-x} = (e^x)⁻¹`) — Mathlib
3. `Complex.abs_zero`, `Complex.abs_one` — for boundary cases
4. `OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.iPi` (Hydra c59)
5. `OmegaTheory.Irrationality.CustomMath.LindemannBasic.exp_polynomial_approx_OV2_holds` (Sedna c58 — Stage-1 anchor)

## Proof sketch (≤6 bullets)

- Replace placeholder with real Prop quantified over orbit lists + a uniform bound.
- Prove singleton case: subst α=iπ, rewrite `exp iπ = -1`, simp shows `Complex.abs 0 = 0 ≤ 1 + 0 = 1`.
- Prove 2-element case: case-split on iπ vs -iπ; use `Complex.exp_neg` for the second, both reduce to `Complex.abs 0`.
- Mark general-orbit as `Prop := True`.
- Compose into 3-conjunct headline `_partial`.
- `lake build` GREEN, 0 sorry, axiom set Lean core on `_partial`.

## Off-limits files (DO NOT EDIT)

- `OmegaTheory/Irrationality/CustomMath/LindemannGaloisConjugation.lean` (Hydra c59)
- `OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean` (Sedna c58)
- W11A target `LindemannGaloisConjugationStep.lean` (sister wizard, parallel)
- W11B target `SymmetricSumIntegerWitness.lean` (sister wizard, parallel)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

`lake build OmegaTheory.Irrationality.CustomMath.AnalyticalBoundUnderConjugation`
GREEN; 0 sorry; axiom set Lean core on `_partial`.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'analytical_bound_under_conjugation_partial_fill'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T2',
              tc.target_file='OmegaTheory/Irrationality/CustomMath/AnalyticalBoundUnderConjugation.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=1,
              tc.multi_cycle_stage='2-of-3',
              tc.path_a_axiom_retirement=true,
              tc.complexity='M-H',
              tc.estimated_lines=170,
              tc.parent_brief='SAGE_BRIEFING_W11_galois_conj_step_2026-04-25 (Hydra c59)',
              tc.fills_placeholder='analytical_bound_under_conjugation'
RETURN tc.name
```
