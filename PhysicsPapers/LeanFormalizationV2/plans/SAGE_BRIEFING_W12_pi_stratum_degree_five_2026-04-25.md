# Sage Briefing — W12 (T2-pi-stratum-D5): Degree-5 axiom-narrowing ladder

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T2 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/IrrationalityClasses/PiStratumDegreeFive.lean` (NEW)

## Candidate name

`pi_irrational_degree_five_decoupling`

## Priority + complexity

MED · L-M (~120-160 lines, 2 main theorems + 1 bridge lemma)

## Mission

Borisov (cycle-59 W9) shipped `PiStratumDegreeFour.lean` with `hpi_indep₄`
hypothesis. The W9/W8/W10/W9 axiom-narrowing ladder is **degree-1 →
degree-2 → degree-3 → degree-4** (cycles 50/51/52/59). **W12 extends to
degree 5** to continue the ladder.

The mathematical claim:

> For any rationals `a, b, c, d, e, f`, if
> `a + b·π + c·π² + d·π³ + e·π⁴ + f·π⁵ = 0` in ℝ under the hypothesis
> `hpi_indep₅ : ∀ r₀ r₁ r₂ r₃ r₄ : ℚ, (r₀:ℝ) + r₁·π + r₂·π² + r₃·π³ + r₄·π⁴ ≠ π⁵`,
> then `a = b = c = d = e = f = 0`.

Hypothesis `hpi_indep₅` is **strictly weaker than `Real.pi_transcendental`**
(transcendence ⟹ algebraicity-of-any-degree-fails; `hpi_indep₅` says only
"π is not algebraic of degree ≤ 5 over ℚ"). Bridge: `hpi_indep_four_of_five`
mirrors the W10 W8-bridge pattern.

## Honest narrower-true scope

Mirror the **exact pattern** of `PiStratumDegreeFour.lean` (Borisov c59) and
`PiStratumDegreeThree.lean` (cycle 52 W10). Same proof tactic structure:
case-split on `e = 0` (or analogous coefficient), reduce to W9 (D=4) via
the bridge lemma; if e ≠ 0, solve for `π⁵` in terms of lower powers and
contradict `hpi_indep₅`.

## `statement_lean` skeleton

```lean
import OmegaTheory.IrrationalityClasses.PiStratumDegreeFour
import OmegaTheory.Irrationality.HermitePade.PiStratumDegreeThree
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

namespace OmegaTheory.IrrationalityClasses

/-- The hypothesis "π is not algebraic of degree ≤ 5 over ℚ". -/
def PiFifthNotInQAffineSpanOfLowerPowers : Prop :=
  ∀ r₀ r₁ r₂ r₃ r₄ : ℚ,
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
      + (r₃ : ℝ) * Real.pi ^ 3 + (r₄ : ℝ) * Real.pi ^ 4 : ℝ) ≠ Real.pi ^ 5

/-- W12 bridge: `hpi_indep₅` implies W9's `PiFourthNotInQAffineSpanOfOnePiPiSqPiCubed`. -/
theorem hpi_indep_four_of_five
    (hpi_indep₅ : PiFifthNotInQAffineSpanOfLowerPowers) :
    OmegaTheory.IrrationalityClasses.PiFourthNotInQAffineSpanOfOnePiPiSqPiCubed := by
  intro r₀ r₁ r₂ r₃
  intro hp4  -- hp4 : … = π^4
  -- π^5 = π · π^4 = π · (r₀ + r₁·π + r₂·π² + r₃·π³)
  --     = r₀·π + r₁·π² + r₂·π³ + r₃·π^4
  -- substitute π^4 back via hp4: r₃·π^4 = r₃·(r₀ + r₁·π + r₂·π² + r₃·π³)
  -- yields π^5 in ℚ-affine span of {1,π,π²,π³,π^4}
  apply hpi_indep₅ (r₃ * r₀) (r₀ + r₃ * r₁) (r₁ + r₃ * r₂)
                  (r₂ + r₃ ^ 2) 0
  push_cast
  have hp4_eq : Real.pi ^ 4 = (r₀ : ℝ) + (r₁ : ℝ) * Real.pi
                  + (r₂ : ℝ) * Real.pi ^ 2 + (r₃ : ℝ) * Real.pi ^ 3 := hp4.symm
  linear_combination -((Real.pi : ℝ) + (r₃ : ℝ)) * hp4_eq

/-- **W12 main — degree-5 decoupling.** -/
theorem pi_irrational_degree_five_decoupling
    (a b c d e f : ℚ)
    (hpi_indep₅ : PiFifthNotInQAffineSpanOfLowerPowers)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4
          + (f : ℝ) * Real.pi ^ 5 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 ∧ f = 0 := by
  by_cases hf : f = 0
  · -- f = 0: reduce to W9 D=4 decoupling.
    subst hf
    push_cast at h
    have h4 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
              + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0 := by linarith
    have hpi_indep₄ : OmegaTheory.IrrationalityClasses.PiFourthNotInQAffineSpanOfOnePiPiSqPiCubed :=
      hpi_indep_four_of_five hpi_indep₅
    have := OmegaTheory.IrrationalityClasses.pi_irrational_degree_four_decoupling
              a b c d e hpi_indep₄ h4
    exact ⟨this.1, this.2.1, this.2.2.1, this.2.2.2.1, this.2.2.2.2, rfl⟩
  · -- f ≠ 0: derive π^5 from h, contradict hpi_indep₅.
    exfalso
    have hfR : (f : ℝ) ≠ 0 := by exact_mod_cast hf
    have hpi_fifth :
        Real.pi ^ 5 = ((-a / f : ℚ) : ℝ) + ((-b / f : ℚ) : ℝ) * Real.pi
                        + ((-c / f : ℚ) : ℝ) * Real.pi ^ 2
                        + ((-d / f : ℚ) : ℝ) * Real.pi ^ 3
                        + ((-e / f : ℚ) : ℝ) * Real.pi ^ 4 := by
      push_cast; field_simp; linarith
    exact hpi_indep₅ (-a / f) (-b / f) (-c / f) (-d / f) (-e / f) hpi_fifth.symm

end OmegaTheory.IrrationalityClasses
```

## Premise candidates

1. `OmegaTheory.IrrationalityClasses.pi_irrational_degree_four_decoupling` (Borisov c59 W9)
2. `OmegaTheory.IrrationalityClasses.PiFourthNotInQAffineSpanOfOnePiPiSqPiCubed` (Borisov c59)
3. `linear_combination` tactic (Mathlib)
4. `field_simp`, `push_cast`, `linarith` (standard Mathlib tactics)
5. `Real.pi`, `Real.pi_pos` (Mathlib)

## Proof sketch (≤6 bullets)

- Mirror `PiStratumDegreeFour.lean` line-by-line, increment one degree.
- Define `PiFifthNotInQAffineSpanOfLowerPowers` Prop.
- Prove bridge `hpi_indep_four_of_five` via `linear_combination` on the substitution `π^5 = π·π^4`.
- Prove main theorem `pi_irrational_degree_five_decoupling`: case-split on `f = 0` (reduce to D=4 via bridge) vs `f ≠ 0` (solve for `π^5`, contradict `hpi_indep₅`).
- `lake build` GREEN, 0 sorry, axiom = Lean core only (`Real.pi_transcendental` NOT used).
- Estimated 120-160 lines, lower than Borisov's c59 W9 (140 lines) due to mature pattern.

## Off-limits files (DO NOT EDIT)

- `OmegaTheory/IrrationalityClasses/PiStratumDegreeFour.lean` (Borisov c59 — read-only)
- `OmegaTheory/Irrationality/HermitePade/PiStratumDegreeThree.lean` (cycle 52 W10 — read-only)
- `OmegaTheory/Irrationality/HermitePade/PiStratumDegreeTwo.lean` (cycle 51 W8 — read-only)
- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` (axiom site — read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

`lake build OmegaTheory.IrrationalityClasses.PiStratumDegreeFive` GREEN;
0 sorry; axiom set = Lean core triple. **No use of `Real.pi_transcendental`**.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'pi_irrational_degree_five_decoupling'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='MED', tc.track='T2',
              tc.target_file='OmegaTheory/IrrationalityClasses/PiStratumDegreeFive.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.path_a_axiom_retirement=true,
              tc.complexity='L-M',
              tc.ladder_degree=5,
              tc.predecessor_file='PiStratumDegreeFour (Borisov c59 W9)',
              tc.estimated_lines=140
RETURN tc.name
```
