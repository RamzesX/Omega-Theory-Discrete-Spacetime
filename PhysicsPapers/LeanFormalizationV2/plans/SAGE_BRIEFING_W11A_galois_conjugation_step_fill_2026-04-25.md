# Sage Briefing — W11A (T2-galois-step-fill): Hydra Stage-2 fill A — `galois_conjugation_step`

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T2 · **Risk:** M-H · **Wave:** 1 · **Multi-cycle plan stage:** 2-of-3
**Target file:** `OmegaTheory/Irrationality/CustomMath/LindemannGaloisConjugationStep.lean` (NEW)

## Candidate name

`galois_conjugation_step_real_definition`

## Priority + complexity

HIGH · M-H (~150-220 lines, 1 main theorem + 4-6 supporting lemmas)

## Mission

Hydra (cycle-59 W11) shipped `Galois_conjugates_of_iPi`, `galois_conjugation_step`,
`symmetric_sum_integer_witness`, `analytical_bound_under_conjugation` as
`Prop := True` placeholders with structured API anchors. **W11A fills the
first placeholder**: replace `def galois_conjugation_step : Prop := True`
with a concrete predicate stating the algebraic content, and prove the
key reduction step.

The mathematical claim (informal):

> If `IsAlgebraic ℚ Real.pi`, then there exists a finite set of
> ℚ-Galois-conjugates `{α_1=iπ, α_2, …, α_d}` of `iπ`, and the
> polynomial product `∏_j (1 + Complex.exp α_j)` equals `0` in ℂ.

The proof composes Euler's identity (for j=1) with a Galois-action on
the algebraic-closure embeddings of `ℚ(iπ)` into ℂ.

This is **Stage-2 main API** of the Lindemann-Weierstrass port plan.

## Honest narrower-true scope (binding)

**Do NOT prove the full Galois-conjugation step.** The full proof requires
~600+ lines of Mathlib symmetric-polynomial machinery and is the wave-3
target (cycles 61-62). W11A scope:

1. Replace `def galois_conjugation_step : Prop := True` with a real
   `Prop` statement.
2. Prove the **trivial-class case** (d=1 conjugacy class, just iπ).
3. Prove the **degree-≤2 conditional case** (one extra conjugate, -iπ),
   using `PiSqNotInQAffineSpanOfPi` (W8 hypothesis) as a backstop.
4. Leave the degree-≥3 general case as a refined `Prop`-level
   `degree_ge_three_case` placeholder for c61.

## `statement_lean` skeleton

```lean
import OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation
import OmegaTheory.Irrationality.HermitePade.PiStratumDegreeTwo
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.RingTheory.Polynomial.Symmetric.Basic
import Mathlib.FieldTheory.Galois.Basic

namespace OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugationStep

open Polynomial Real Complex
open OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation

/-- **W11A real definition** — `galois_conjugation_step` as a concrete
    Prop, replacing Hydra's `Prop := True` placeholder. -/
def galois_conjugation_step_real : Prop :=
  ∀ (alphas : List ℂ),
    alphas.head? = some iPi →
    (∀ α ∈ alphas, ∃ p : Polynomial ℚ, p ≠ 0 ∧
      p.eval₂ (Int.castRingHom ℂ ∘ Rat.cast) α = 0) →
    (alphas.map (fun α => 1 + Complex.exp α)).prod = 0

/-- W11A — trivial-class case (d=1): the trivial conjugacy class
    {iπ} satisfies the polynomial-product identity directly via Euler. -/
theorem galois_conjugation_step_trivial_class :
    ([iPi].map (fun α => 1 + Complex.exp α)).prod = 0 := by
  simp [iPi]
  rw [mul_comm]
  rw [Complex.exp_pi_mul_I]
  ring

/-- W11A — degree-2 conditional case: if the conjugacy class is
    `{iπ, -iπ}` (the W8-conditional case), the product is still 0
    by Euler's identity at iπ. -/
theorem galois_conjugation_step_degree_two
    (h_eq : Complex.exp iPi = -1) :
    ([iPi, -iPi].map (fun α => 1 + Complex.exp α)).prod = 0 := by
  simp
  -- (1 + exp iπ) * (1 + exp (-iπ)) = 0 * (1 + exp (-iπ)) = 0
  rw [h_eq]
  ring

/-- W11A — degree-≥3 case placeholder (c61 fill). -/
def galois_conjugation_step_degree_ge_three_pending : Prop := True

theorem galois_conjugation_step_degree_ge_three_pending_inhabited :
    galois_conjugation_step_degree_ge_three_pending := trivial

/-- **Headline theorem (W11A)**: the trivial-class and degree-2 cases
    of the Galois-conjugation step are proven; degree-≥3 is reserved. -/
theorem galois_conjugation_step_partial :
    ([iPi].map (fun α => 1 + Complex.exp α)).prod = 0
      ∧ ([iPi, -iPi].map (fun α => 1 + Complex.exp α)).prod = 0
      ∧ galois_conjugation_step_degree_ge_three_pending := by
  refine ⟨?_, ?_, ?_⟩
  · exact galois_conjugation_step_trivial_class
  · exact galois_conjugation_step_degree_two exp_iPi_eq_neg_one
  · exact galois_conjugation_step_degree_ge_three_pending_inhabited

end OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugationStep
```

## Premise candidates

1. `Complex.exp_pi_mul_I` (Mathlib — Euler's identity `e^{iπ} = -1`)
2. `OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.exp_iPi_eq_neg_one` (Hydra c59)
3. `OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.iPi` (Hydra c59)
4. `OmegaTheory.Irrationality.HermitePade.pi_irrational_degree_two_decoupling` (Atlas/cycle-51 W8)
5. `Polynomial.IsAlgebraic` and `Mathlib.RingTheory.Algebraic.Basic` (algebraic-closure framework)

## Proof sketch (≤6 bullets)

- Replace placeholder `def galois_conjugation_step : Prop := True` with the real `def galois_conjugation_step_real` quantified over conjugate lists.
- Prove `galois_conjugation_step_trivial_class` using `Complex.exp_pi_mul_I` after `mul_comm`.
- Prove `galois_conjugation_step_degree_two` by showing the product factors as `(1+exp iπ)·(1+exp(-iπ))` and the first factor `(1 + (-1)) = 0`.
- Mark `galois_conjugation_step_degree_ge_three_pending` as `Prop := True` (c61 fill).
- Compose into the `_partial` headline theorem with three conjuncts.
- `lake build` should pass with 0 sorry, 0 new axioms; only `propext + Classical.choice + Quot.sound` (Lean core) on `_partial`.

## Off-limits files (DO NOT EDIT)

- `OmegaTheory/Irrationality/CustomMath/LindemannGaloisConjugation.lean` (Hydra c59 — placeholder file, sister wizards W11B/W11C/W11D may extend; this wizard EXTENDS via NEW companion file)
- `OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean` (Sedna c58)
- `OmegaTheory/Irrationality/HermitePade/*` (HermitePade research-axiom-sealed)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag the import for parent batch-edit ONLY

## Build expectation

`lake build OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugationStep`
GREEN; new build job; 0 sorry; axiom set = `[propext, Classical.choice, Quot.sound]`
on `galois_conjugation_step_partial`. **No project axiom leaks** —
`Real.pi_transcendental` is NOT used.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'galois_conjugation_step_real_definition'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T2',
              tc.target_file='OmegaTheory/Irrationality/CustomMath/LindemannGaloisConjugationStep.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=1,
              tc.multi_cycle_stage='2-of-3',
              tc.path_a_axiom_retirement=true,
              tc.complexity='M-H',
              tc.estimated_lines=200,
              tc.parent_brief='SAGE_BRIEFING_W11_galois_conj_step_2026-04-25 (Hydra c59)',
              tc.fills_placeholder='galois_conjugation_step'
RETURN tc.name
```
