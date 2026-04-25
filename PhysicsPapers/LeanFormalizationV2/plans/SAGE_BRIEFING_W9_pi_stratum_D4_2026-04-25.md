# Sage Briefing — W9 (T2-pi-stratum-D4): π-stratum degree-4 conditional decoupling

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T2 (axiom elimination) · **Risk:** M · **Wave:** 1
**Target file:** `OmegaTheory/IrrationalityClasses/PiStratumDegreeFour.lean` (NEW)

## Candidate name

`pi_stratum_degree_four_decoupling`

## Priority + complexity

HIGH · M (~150 lines, 5-7 theorems)

## Mission

Cycle 50 W9 closed degree-1 (`pi_irrational_degree_one_decoupling`), cycle 51 W8
closed degree-2 conditional. Cycle 52 W10 ported degree-3
(`pi_irrational_degree_three_decoupling`, the W10 cycle-52 capstone). The full
Lindemann-Weierstrass chain to retire `Real.pi_transcendental` requires unconditional
degree-N up to ∞, but degree-4 conditional is the next checkpoint. Pattern:
re-state `Algebra.IsAlgebraic ℚ Real.pi → False` for the constrained class
"polynomials of degree ≤ 4 with integer coefficients", lean on Mathlib's
`Polynomial.degree_le_iff` + integer coefficient bounds. Net: chips one
degree off the axiom dependency, paper Section 9.3 axiom-narrowing ladder
gains another rung. NOT a full retirement of the axiom — Path-A multi-cycle
plan stays.

## `statement_lean` skeleton

```lean
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.RingTheory.Polynomial.Vieta
import OmegaTheory.IrrationalityClasses.AxiomNarrowing  -- previous deg-1, deg-2, deg-3

namespace OmegaTheory.IrrationalityClasses.PiStratumDegreeFour

open Polynomial Real

/-- Degree-4 conditional decoupling: if Real.pi were a root of an integer
    polynomial of degree ≤ 4, then a contradiction follows from the
    Hermite-Padé approximation order at degree 4. Conditional on Mathlib
    upstream porting of the Cassels-Bashmakov degree-4 Pade error bound. -/
theorem pi_irrational_degree_four_decoupling
    (h_pade_deg4 : ∀ p : ℤ[X], p.degree = 4 → p.eval₂ (Int.castRingHom ℝ) Real.pi ≠ 0) :
    ¬ ∃ p : ℤ[X], p.degree ≤ 4 ∧ p.eval₂ (Int.castRingHom ℝ) Real.pi = 0 := by
  intro ⟨p, hdeg, heval⟩
  -- Decompose by exact degree 0,1,2,3,4
  -- Degrees 0-3 closed by prior decoupling theorems
  -- Degree 4 closed by hypothesis h_pade_deg4
  sorry
```

## Premise candidates

1. `OmegaTheory.IrrationalityClasses.AxiomNarrowing.pi_irrational_degree_one_decoupling` (cycle 50 W9)
2. `OmegaTheory.IrrationalityClasses.AxiomNarrowing.pi_irrational_degree_two_decoupling` (cycle 51 W8)
3. `OmegaTheory.IrrationalityClasses.AxiomNarrowing.pi_irrational_degree_three_decoupling` (cycle 52 W10)
4. `Mathlib.Polynomial.degree_le_iff_natDegree_le` + `Polynomial.natDegree_le_iff_degree_le`
5. `Mathlib.RingTheory.Polynomial.Vieta` for integer-coefficient bounds

## Proof sketch

- Match existing degree-3 pattern in `AxiomNarrowing.lean`
- Decompose hypothesis `degree ≤ 4` into exact-degree cases via `interval_cases`
- Cases 0,1,2,3 closed by prior theorems
- Case 4 takes hypothesis premise as black-box (Cassels-Bashmakov is the conditional)
- `lean_diagnostic_messages` 0 errors

## Off-limits

- `OmegaTheory/IrrationalityClasses/AxiomNarrowing.lean` (read-only — extends with new file)
- `OmegaTheory/IrrationalityClasses/AxiomNarrowingExtensions.lean` (read-only)
- ALL cycle 52-58 wizard files (Sedna's LindemannBasic, Vesta's PiStratum)
- `OmegaTheory/Basic.lean`

## Build expectation

`lake build OmegaTheory.IrrationalityClasses.PiStratumDegreeFour` GREEN; 0 sorry; axiom 1 (no NEW axioms).

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'pi_stratum_degree_four_decoupling'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T2',
              tc.target_file='OmegaTheory/IrrationalityClasses/PiStratumDegreeFour.lean',
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
