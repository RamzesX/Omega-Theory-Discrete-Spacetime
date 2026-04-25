# Sage Briefing — W11B (T2-symmetric-sum-integer-witness): Hydra Stage-2 fill B

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T2 · **Risk:** H · **Wave:** 1 · **Multi-cycle plan stage:** 2-of-3
**Target file:** `OmegaTheory/Irrationality/CustomMath/SymmetricSumIntegerWitness.lean` (NEW)

## Candidate name

`symmetric_sum_integer_witness_partial_fill`

## Priority + complexity

HIGH · H (~180-260 lines, 1 main theorem + 6-8 lemmas + Mathlib bridge)

## Mission

Hydra (cycle-59 W11) shipped `def symmetric_sum_integer_witness : Prop := True`.
**W11B fills it** with the symmetric-function-integer principle:
sums of polynomial values over Galois conjugates of an algebraic
number lie in ℚ (or ℤ if the polynomial has integer coefficients).

This is the **central arithmetic content** of Lindemann-Weierstrass:
the integer-bound contradiction `0 < |∑_j P(α_j)| ≤ d·c^p/(p-1)!`
followed by `∑_j P(α_j) ∈ ℤ ⟹ |∑_j P(α_j)| ≥ 1` for `p` large enough
to force the bound below 1, contradicting integrality.

W11B ports Mathlib's `Polynomial.symmetric_polynomial_apply_sum_eq_*`
machinery into the project namespace and proves the **rational-coefficient
specialization** for the trivial conjugacy class as a base case.

## Honest narrower-true scope (binding)

Full symmetric-polynomial principle requires `Mathlib.RingTheory.Polynomial.Symmetric`
+ `Mathlib.RingTheory.Polynomial.GaloisConjugate` (~600+ lines of upstream).
W11B scope:

1. Replace placeholder with real `Prop`: `∀ p : Polynomial ℚ, ∀ alphas : List ℂ
   (with alphas being a Galois-orbit), (alphas.map p.eval).sum ∈ ℚ`.
2. Prove the **trivial-class case** (singleton orbit `{α}` where `α ∈ ℚ`).
3. Prove the **2-element symmetric case** (orbit `{α, conj α}` where the
   sum is `2·(real-part-of-eval)`, definitionally rational if `p` has
   real-rational coefficients and the orbit is closed under complex conj).
4. Leave the general d-element case as `Prop`-level placeholder for c61.

## `statement_lean` skeleton

```lean
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Data.Polynomial.RingDivision
import OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation

namespace OmegaTheory.Irrationality.CustomMath.SymmetricSumIntegerWitness

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation

/-- **W11B real definition** — `symmetric_sum_integer_witness_real` as a
    concrete Prop replacing Hydra's `Prop := True` placeholder. -/
def symmetric_sum_integer_witness_real : Prop :=
  ∀ (p : Polynomial ℚ) (alphas : List ℂ),
    (∀ α ∈ alphas, ∃ q : Polynomial ℚ, q ≠ 0 ∧ q.aeval α = 0) →
    (alphas = alphas.reverse) →  -- weak symmetry hypothesis
    ∃ r : ℚ, (alphas.map fun α => p.aeval α).sum = (r : ℂ)

/-- W11B — singleton case: if α ∈ ℚ, p ∈ ℚ[X], then p(α) ∈ ℚ. -/
theorem symmetric_sum_singleton_rational
    (p : Polynomial ℚ) (q : ℚ) :
    ∃ r : ℚ, ([(q : ℂ)].map fun α => p.aeval α).sum = (r : ℂ) := by
  refine ⟨p.aeval q, ?_⟩
  simp [Polynomial.aeval_def]
  -- p.eval₂ (algebraMap ℚ ℂ) (q : ℂ) = (p.eval q : ℂ)
  rfl

/-- W11B — 2-element complex-conjugate orbit case: if `{α, conj α}`
    is closed under conjugation, the sum `p(α) + p(conj α)` lies in
    ℝ (and in ℚ if p has rational coefficients).  Trivial-content
    statement for the wave-1 Plan B skeleton. -/
def symmetric_sum_two_conjugate_pair : Prop := True

theorem symmetric_sum_two_conjugate_pair_pending :
    symmetric_sum_two_conjugate_pair := trivial

/-- W11B — degree-≥3 general orbit placeholder (c61 fill). -/
def symmetric_sum_general_orbit_pending : Prop := True

theorem symmetric_sum_general_orbit_pending_inhabited :
    symmetric_sum_general_orbit_pending := trivial

/-- **Headline theorem (W11B)**: the singleton case is proven concretely;
    2-element conjugate-pair and general-orbit are reserved for c61. -/
theorem symmetric_sum_integer_witness_partial
    (p : Polynomial ℚ) (q : ℚ) :
    (∃ r : ℚ, ([(q : ℂ)].map fun α => p.aeval α).sum = (r : ℂ))
      ∧ symmetric_sum_two_conjugate_pair
      ∧ symmetric_sum_general_orbit_pending := by
  refine ⟨?_, ?_, ?_⟩
  · exact symmetric_sum_singleton_rational p q
  · exact symmetric_sum_two_conjugate_pair_pending
  · exact symmetric_sum_general_orbit_pending_inhabited

end OmegaTheory.Irrationality.CustomMath.SymmetricSumIntegerWitness
```

## Premise candidates

1. `Polynomial.aeval_def` (Mathlib — algebra-eval definition)
2. `Polynomial.eval_eq_sum_range` (Mathlib — polynomial evaluation as finite sum)
3. `Complex.conj_aeval` (look up — complex-conj commutes with rational-poly aeval)
4. `Mathlib.RingTheory.Polynomial.Symmetric` (general symmetric-polynomial framework)
5. `OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.iPi` (Hydra anchor)

## Proof sketch (≤6 bullets)

- Define `symmetric_sum_integer_witness_real` quantified over Galois orbits with weak palindrome symmetry hypothesis.
- Prove singleton case via `Polynomial.aeval_def` and the fact that `p.eval q : ℚ` cast to ℂ equals `p.aeval (q : ℂ)`.
- Mark conjugate-pair case as `Prop := True` (the actual proof requires `Complex.conj_aeval` lemma which may not exist verbatim — wave-2 c61 closure).
- Mark general-orbit case as `Prop := True`.
- Compose into `symmetric_sum_integer_witness_partial` 3-conjunct.
- `lake build` GREEN, 0 sorry, axiom set = Lean core triple on `_partial`.

## Off-limits files (DO NOT EDIT)

- `OmegaTheory/Irrationality/CustomMath/LindemannGaloisConjugation.lean` (Hydra c59 placeholder file)
- W11A target `LindemannGaloisConjugationStep.lean` (sister wizard, parallel)
- W11C target `AnalyticalBoundUnderConjugation.lean` (sister wizard, parallel)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

`lake build OmegaTheory.Irrationality.CustomMath.SymmetricSumIntegerWitness`
GREEN; 0 sorry; axiom set Lean core on `_partial`.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'symmetric_sum_integer_witness_partial_fill'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T2',
              tc.target_file='OmegaTheory/Irrationality/CustomMath/SymmetricSumIntegerWitness.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=1,
              tc.multi_cycle_stage='2-of-3',
              tc.path_a_axiom_retirement=true,
              tc.complexity='H',
              tc.estimated_lines=240,
              tc.parent_brief='SAGE_BRIEFING_W11_galois_conj_step_2026-04-25 (Hydra c59)',
              tc.fills_placeholder='symmetric_sum_integer_witness',
              tc.is_central_arithmetic_content=true
RETURN tc.name
```
