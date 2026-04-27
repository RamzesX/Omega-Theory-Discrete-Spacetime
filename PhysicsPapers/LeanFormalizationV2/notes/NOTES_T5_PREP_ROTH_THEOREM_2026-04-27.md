# T-5 Attack Plan — Roth's Theorem Axiom Retirement (Next-Cycle Seed)

**Status (2026-04-27)**: T-4 cycle 64 closed (`Real.pi_transcendental` retired).
This file documents the next research-track axiom retirement seed.

## Target axiom

`hermite_pade_family_closure` (Predictions/HermitePadeFamilyClosure.lean) cites
4 remaining HermitePadé research axioms:

- **RA-2: Roth's theorem** (1955)
- **RA-3: Siegel-Shidlovskii**
- **RA-4: Nesterenko 1996**
- **RA-5: Mahler framework**

T-5 targets RA-2 first as the most concrete & best-known.

## Roth's theorem

> For any algebraic irrational α ∈ ℝ and any ε > 0, there exists a
> constant C(α, ε) such that for any rational p/q with q > 0 in lowest
> terms: |α - p/q| > C(α, ε) / q^(2+ε).

Equivalently: algebraic irrationals can NOT be approximated by rationals
better than O(1/q²).

## Mathlib status (v4.29.0 audit, 2026-04-27)

- Diophantine approximation file `Mathlib.NumberTheory.Diophantine.*` —
  has `liouville` + `Liouville.transcendental` (Liouville's theorem,
  weaker exponent).
- Roth's theorem **not in Mathlib v4.29**.
- **Conclusion**: T-5 requires custom port (~3000-5000 lines, single
  research target like T-4 was).

## Decomposition strategy (analogous to T-4)

Following the template that succeeded for T-4:

### Phase 1: Foundational lemmas (~10 sub-lemmas)

1. Diophantine approximation basic theorems (some already in Mathlib).
2. Lower-bound for algebraic-irrational approximations via norm
   considerations.
3. Heights of algebraic numbers.

### Phase 2: Auxiliary polynomial construction (~15 sub-lemmas)

Roth's proof uses an "auxiliary polynomial" with multiple roots
matching the Diophantine approximations p_i/q_i.

4. Construct polynomial P(x_1, ..., x_n) of bounded degree with high
   multiplicity at (p_1/q_1, ..., p_n/q_n).
5. Index of P at an algebraic point.
6. Sieving / pigeonhole for index bounds.

### Phase 3: Index theorem + Roth's lemma (~10 sub-lemmas)

7. Roth's lemma: If the auxiliary polynomial vanishes to high index at
   (p_1/q_1, ..., p_n/q_n), then the index is bounded.
8. Index calculation via partial derivatives.
9. Wronskian non-vanishing.

### Phase 4: Final contradiction (~5 sub-lemmas)

10. Combine Phase 1-3: contradiction between high-index requirement from
    "many good rational approximations" and Roth's lemma upper bound.

### Phase 5: Project integration (~3 files)

11. New axiom-retiring theorem `roth_theorem`.
12. Update `HermitePadeFamilyClosure.lean` to remove RA-2 True marker.
13. Cycle memo + Yoneda bridges.

## Effort estimate

| Phase | Sub-lemmas | Lines | Days (single-thread) |
|-------|----------:|------:|--------------------:|
| 1 | 10 | 400 | 2 |
| 2 | 15 | 800 | 4 |
| 3 | 10 | 600 | 3 |
| 4 | 5 | 300 | 2 |
| 5 | 3 | 150 | 1 |
| **TOTAL** | **43** | **~2250** | **~12** |

Single-thread budget: **2-3 weeks** (1-2 sessions/day on calendar).

## Comparison with T-4

T-4 closure achieved in **~1 day** with 14 sessions / ~3000 lines.
T-5 estimated **~2-3 weeks** with 43 sub-lemmas / ~2250 lines.

T-5 is 2-3× longer than T-4 because Roth's proof has more layers
(auxiliary polynomial machinery + index theorem on top of Diophantine
basics). But same structure: decompose, port, integrate.

## Sources

- K. F. Roth, *Rational approximations to algebraic numbers*,
  Mathematika 2 (1955), 1-20.
- Vojta, *Diophantine Approximations and Value Distribution Theory*,
  Springer LNM 1239 (1987).
- Bombieri & Gubler, *Heights in Diophantine Geometry*, Cambridge UP
  (2006), Chapter 6.

## Key Mathlib API to study

- `Mathlib.NumberTheory.Diophantine.Liouville` — Liouville's theorem
  (weaker version, gives lower bound q^{-degree}).
- `Mathlib.NumberTheory.Padics.PadicNumbers` — p-adic completion of ℚ.
- `Mathlib.RingTheory.MvPolynomial.Symmetric.FundamentalTheorem` —
  fundamental theorem of symmetric polynomials (used in T-4).
- `Mathlib.Analysis.SpecialFunctions.Polynomials` — polynomial-derivative
  bounds.

## Next concrete step

When ready to start T-5: open a fresh cycle 65+ work-thread with this
plan as input. Single-thread hand-authored, NO STUBS, Lean-core only.

## Workflow rule confirmation

Per LOCKED 2026-04-27 rules:

- ✓ Mathlib upstream is NOT a blockade.
- ✓ Decompose into Lean-sized sub-lemmas.
- ✓ Single-thread, NO STUBS, NO FEAR.
- ✓ Treat as "decomposable" not "research blockade".

T-5 is a longer T-4. We've proved the workflow at scale; T-5 is just
more of the same.
