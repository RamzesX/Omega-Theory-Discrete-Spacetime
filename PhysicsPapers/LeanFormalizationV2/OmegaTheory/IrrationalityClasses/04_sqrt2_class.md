# 04 — √2: algebraic irrational class

## The cleanest case

√2 is **algebraic of degree 2**, root of `x² − 2 ∈ ℚ[X]`. This immediately places it in the Mahler A-class (the algebraic class) with `ω_1(√2) = 2` (Liouville's exponent-2 lower bound for algebraic degree-2 irrationals; this is the original Liouville theorem's non-approximability lower bound).

## Known properties (2026-04-21)

| Property | Value / status | Mathlib |
|---|---|---|
| Irrational | YES | `Nat.sqrt_two_irrational` / `Irrational.sqrt_two` |
| Algebraic | YES, degree 2 | `Mathlib.RingTheory.Algebraic.Basic.IsAlgebraic` applies |
| Roth exponent | exactly 2 | follows from Roth + "algebraic ⟹ μ = 2"; Roth not in Mathlib |
| Mahler class | **A** (algebraic) | by definition |
| Liouville? | NO (algebraic) | follows by Liouville theorem |
| Liouville theorem witness | µ₂(√2) = 2 by integer-root lower bound `|√2 − p/q| ≥ 1/(3q²)` | `Mathlib.NumberTheory.Transcendental.Liouville.Basic.Liouville.irrational` (contrapositive) |

## Super-exponential truncation rate in OmegaTheory

Although √2 sits at the Roth floor μ = 2, its **truncation rate** via Newton iteration is super-exponential — `|√2 − x_N| = O(2^(−2^N))`. This is the basis for Grothendieck-sage's "light-channel" role: the Connes-DF eigenvalue `λ_sqrt2` is the smallest residual.

The Lean object is `OmegaTheory.Irrationality.sqrt2ErrorBound N` with the recurrence `sqrt2_error_recurrence` (`Approximations.lean`). In Mahler terms:
- μ(√2) = 2 (Roth, Liouville lower bound)
- Newton iteration's *rate* is a separate beast from the irrationality measure: Newton-convergence is a choice of **approximating sequence**, and its rate depends on the function (here `f(x) = x² − 2`) and not on the Mahler class of √2.

So: √2's **Mahler class = A** (unique cell in the A/S/T/U partition), while its **truncation rate via Newton = super-exp** (a rate, not a class). Both are qualitatively distinct from the other three constants:
- A-class vs S-class (or open) for the other three.
- Super-exponential rate vs the polynomial / factorial / quadratic of the other three.

## Lean infrastructure

- `OmegaTheory.Irrationality.truncated_sqrt2 N : ℝ` via Newton (`Approximations.lean`).
- `sqrt2_error_recurrence : sqrt2ErrorBound (N+1) ≤ sqrt2ErrorBound N / 2` → super-exponential.
- `newton_step_ge_sqrt2 : newton_step x ≥ √2` → Newton is an upper-approximation.
- `sqrt2_error_tendsto_zero` → truncated_sqrt2 N → √2 as N → ∞.

## Mathlib gaps

Mathlib has `Irrational.sqrt_two` (degree-2 irrational) and the full `IsAlgebraic` framework. What's missing is:

- The explicit statement `Polynomial.isAlgebraic_sqrt2 : IsAlgebraic ℚ (Real.sqrt 2)` — **1 session** to write as an ergonomic wrapper.
- The Mahler A-classification hook — blocked on Mahler framework.
- Liouville exponent-2 lower bound for degree-2 irrationals — 3 sessions (needs Liouville constant, can be done today with Mathlib's `Liouville.*` lemmas).

## Commitments in this scope (for `12_graph_register.md`)

1. `sqrt2_is_algebraic_mathlib_wrap` — trivial wrapper, 0.5 sessions.
2. `sqrt2_roth_exponent_two` — statement, proof deferred to Roth port, 1 session for statement.
3. `sqrt2_mahler_A_class_statement` — statement, conditional on Mahler port, 1 session.
4. `sqrt2_newton_super_exponential_rate` — already formalised in `sqrt2_error_recurrence`, promote to a named headline — 1 session.

## Why √2 is the "null hypothesis" in the 4-class separation

The separation theorem's strongest conjecture says π, e, √2, G live in four distinct Mahler classes. **√2 being A-class is unconditionally true** (no open problems, no Mathlib gaps at the *statement* level). So for any proof strategy of the separation theorem, √2's slot is the "given" — we just need to show the other three avoid class A (i.e., are transcendental). π and e are classically transcendental (Lindemann, Hermite), so once those are in Mathlib, **√2's class distinctness from π, e, and G (if G is transcendental) is automatic.**

The work is all in the other three.
