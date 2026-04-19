---
name: Agent identity — Bellatrix
description: Took Bellatrix name 2026-04-19; closed the FULL SU(3) Jacobi identity unconditionally in SU3JacobiIdentity.lean; 10 theorems/defs, full project GREEN 3657 jobs
type: user
---

# Bellatrix (γ Orionis, "Warrior Star")

## Identity
- Chose name **Bellatrix** (γ Orionis, "Warrior Star") on 2026-04-19 for the hardest
  outstanding Lie-algebra closure in the project — the SU(3) Jacobi identity.
- Thread: physics-P1 (Lean 4 wizard, OmegaTheory V2).

## Mission delivered
**Close the full SU(3) Jacobi identity** for arbitrary Lie-algebra elements
`X, Y, Z : SU3LieAlgebra`:
  `[[X, Y], Z] + [[Y, Z], X] + [[Z, X], Y] = 0`.

**Previously**: `mkExactSU3LieAlgebra` in `ErrorGaugeSU3.lean` carried `hJ`
(the Jacobi identity) as a hypothesis. Almach² had built `su3f_jacobi_sum_zero`
(the structure-constant Jacobi in ℝ via ℚ+√3 decomposition, closed by
`native_decide` on 4096 rational cases) and `su3Bracket_jacobi_basis_all` (all 512
basis triples). The missing piece was the **trilinearity lift** from the
summand/basis level to arbitrary X, Y, Z.

**Now**: fully closed unconditionally. `errorGaugeSU3_lieBracket_jacobi`
(mission-brief alias) + `su3Bracket_jacobi_full` both require zero hypotheses.

## New file: `OmegaTheory/Emergence/SU3JacobiIdentity.lean`
361 lines, 10 declarations, 0 sorry, 0 new axioms:

1. `su3Bracket_right_linear` — companion of existing `_left_linear`.
2. `sum_basis_expansion` — any `X : Fin 8 → ℝ` equals `∑ a, X a · e_a`.
3. `bracket_bracket_expand_X` — `[[X,Y],Z] k = ∑ a,b,c,m, f(a,b,m)·f(m,c,k)·X(a)·Y(b)·Z(c)`.
4. `bracket_bracket_expand_Y` — cyclic term `[[Y,Z],X] k`.
5. `bracket_bracket_expand_Z` — cyclic term `[[Z,X],Y] k`.
6. `su3Bracket_jacobi_full_pointwise` — pointwise Jacobi identity on all X,Y,Z,k.
7. `su3Bracket_jacobi_full` — **unconditional functional Jacobi** (the main theorem).
8. `errorGaugeSU3_lieBracket_jacobi` — mission-brief alias.
9. `mkExactSU3LieAlgebra_unconditional` — witness-free constructor.
10. `mkExactSU3LieAlgebra_unconditional_jacobi_error`,
    `mkExactSU3LieAlgebra_unconditional_jacobi_tight` — zero-error exactness.

## Proof technique
- Each of the three cyclic `[[·,·],·] k` terms unfolds to a fourfold sum
  `∑_{a,b,c,m} f(…)·f(…)·X(a)·Y(b)·Z(c)` via nested `Finset.sum_mul`/`mul_sum`
  and pointwise `ring`.
- Summation reorder from `(m, c, a, b)` to `(a, b, c, m)` is done via
  `Finset.sum_comm` under nested `Finset.sum_congr rfl`.
- The three cyclic terms, once in common outer order, combine into a single
  fourfold sum whose innermost `∑_m` summand at fixed `(a, b, c)` equals
  `X(a)·Y(b)·Z(c) · (Jacobi-summand)`.
- `su3f_jacobi_sum_zero` (Almach², 2026-04-17) kills the inner sum.

## Build state
- `lake build OmegaTheory.Emergence.SU3JacobiIdentity` GREEN (1.0s).
- `lake build` full project GREEN: **3657 jobs** (was 3654, +3 for new module).
- 0 sorry, 0 new axioms. `#print axioms su3Bracket_jacobi_full` shows only
  `propext, Classical.choice, Quot.sound, jacobi_rat_zero._native.native_decide.ax_1_1,
  jacobi_sqrt3_zero._native.native_decide.ax_1_1` — all pre-existing, not mine.
- Mirrored to both `~/lean-v2/` and `/mnt/c/…/chaos-shield/…/LeanFormalizationV2/`.

## Significance
This closes the **Lie-algebra closure of QCD colour gauge** in Lean 4 — the
color-gauge Lie algebra `su(3)` now has the full Jacobi identity proven
unconditionally for arbitrary elements (not just basis vectors). Combined with
the existing `su3Bracket_antisymmetric_pi` and `su3Bracket_smul_linear`, the
algebraic closure of the gauge-group-of-QCD is algebraically complete.

The witness-free constructor `mkExactSU3LieAlgebra_unconditional` now exists,
letting downstream consumers build `ErrorLieAlgebra SU3LieAlgebra` without
passing a Jacobi hypothesis. This is the closure that was explicitly flagged
as "hypothesis, fixable with `fin_cases` at high heartbeats" in the project
CLAUDE.md under "Current gaps / Next frontiers".

## Collaborators credited in the file
- Kornephoros (Apr 15) — original `ErrorGaugeSU3` + `su3Bracket`.
- Almach² (γ And, Apr 17) — `su3f_jacobi_sum_zero`, `su3Bracket_jacobi_basis_all`,
  the ℚ+√3 decomposition, and the conditional lift `su3Bracket_jacobi_via_basis`.
- Mizar² (Apr 17) — antisymmetry helpers, self-bracket, degenerate Jacobi classifier.
- Bellatrix (Apr 19) — trilinearity lift, unconditional Jacobi.
