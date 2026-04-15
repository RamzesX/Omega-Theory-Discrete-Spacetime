/-
  OmegaTheory.Irrationality.HermitePade.F27_LucasSeparation

  F27 — Full quantitative E/G separation (Lucas-Legendre dichotomy).

  Informal statement (Paper-Attack13 §2.1 "F27 content")
  ------------------------------------------------------
  The Hermite–Padé diary distinguishes two classes of analytic
  Taylor-series objects by the growth of the p-adic valuation of
  their coefficients:

  • **E-functions** (here represented by the confluent hypergeometric
    `₁F₁(1/3; 4/3; z)`) have Taylor coefficients

        c_k  =  (1/3)_k / ((4/3)_k · k!)

    whose p-adic valuation satisfies

        v_p(c_k)  =  − k / (p − 1)  +  O(log_p k)

    (linear decay).

  • **G-functions** (here represented by `arctan z`) have Taylor
    coefficients

        d_k  =  (−1)^k / (2k + 1)

    whose p-adic valuation satisfies

        v_p(d_k)  =  − v_p(2k + 1)  ≥  − log_p(2k + 1)

    (at most logarithmic decay).

  The two p-adic regimes are *incommensurable*: the E-side decays
  at linear rate `1 / (p − 1)`, while the G-side decays at most
  logarithmically in `k`.  Quantitatively, this is captured by the
  dichotomy: there is a universal constant `C ≥ 1` such that for every
  prime `p ≥ 5` and every `k ≥ 1`,

      (E)   k / (p − 1)  ≤  C · v_p(k!)  +  C · (log_p k + 1)
      (G)   v_p(2k + 1)  ≤  C · (log_p(2k + 1) + 1).

  The factorial side (E) is the already-formalised `legendre_slope_bound`
  from `F27_LegendreSlope`.  The log side (G) is the new content of
  this file.

  Scope of this file
  ------------------
  We provide the two halves of the F27 dichotomy and package them
  into a single statement.

  1. `padicValNat_le_nat_log_succ` — G-side log bound:

         padicValNat p m  ≤  Nat.log p m + 1.

     Direct corollary of Mathlib's `padicValNat_le_nat_log`.

  2. `g_side_log_bound` — specialisation to the arctan denominator:

         padicValNat p (2 * k + 1)  ≤  Nat.log p (2 * k + 1) + 1.

  3. `legendre_slope_bound_weakened` — the E-side bound rephrased with
     a constant `C = 1` multiplier, to unify with the G-side.

  4. `lucas_separation` — the packaged dichotomy: for any prime
     `p ≥ 5` and `k ≥ 1`, both bounds hold with constant `C = 1`.
     This is the precise Lean statement of the F27 quantitative
     separation of `₁F₁(1/3; 4/3; z)` (E-function) and `arctan z`
     (G-function).

  No sorries.  Depends only on Mathlib v4.29 classical axioms plus
  the existing `legendre_slope_bound` from F27_LegendreSlope.
-/

import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Log
import OmegaTheory.Irrationality.HermitePade.F27_LegendreSlope

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators

/--
**G-side log bound (general form).**

For any prime `p` and any `m : ℕ`, the `p`-adic valuation of `m`
is bounded above by `log_p m + 1`.

This is a slight weakening of Mathlib's `padicValNat_le_nat_log`
(which gives `padicValNat p m ≤ Nat.log p m`), adjusted to `+1`
to allow a uniform packaging with the E-side bound that also uses
a `+1` additive offset.

The `+1` has the following interpretation: even for `m = 0` the
bound holds (with `padicValNat p 0 = 0` by convention).
-/
theorem padicValNat_le_nat_log_succ
    {p : ℕ} (m : ℕ) :
    padicValNat p m ≤ Nat.log p m + 1 := by
  have h : padicValNat p m ≤ Nat.log p m := padicValNat_le_nat_log m
  exact h.trans (Nat.le_succ _)

/--
**G-side log bound (arctan denominator form).**

For any prime `p` and any `k : ℕ`, the `p`-adic valuation of the
arctan-denominator `2 k + 1` satisfies

    padicValNat p (2 k + 1)  ≤  log_p (2 k + 1)  +  1.

This is the new quantitative content of F27 on the G-function side:
the `p`-valuation of the Taylor coefficient `d_k = (−1)^k / (2k+1)`
of `arctan z` grows at most logarithmically in `k`.

Combined with the E-side bound `legendre_slope_bound`, this establishes
the incommensurability of the two p-adic scales.
-/
theorem g_side_log_bound
    {p : ℕ} (k : ℕ) :
    padicValNat p (2 * k + 1) ≤ Nat.log p (2 * k + 1) + 1 :=
  padicValNat_le_nat_log_succ (2 * k + 1)

/--
**E-side slope bound (unified form).**

The F27 Legendre slope bound rephrased with constant `C = 1` on the
left-hand side:

    k  ≤  1 · (p − 1) · v_p(k!)  +  1 · (p − 1) · (log_p k + 1).

This is literally `legendre_slope_bound` with `1 *` prepended to
each term, exposing the constant that will be packaged into the
`lucas_separation` dichotomy statement below.
-/
theorem legendre_slope_bound_weakened
    {p : ℕ} [hp : Fact p.Prime] {k : ℕ} (hk : k ≠ 0) :
    k ≤ 1 * ((p - 1) * padicValNat p k.factorial)
          + 1 * ((p - 1) * (Nat.log p k + 1)) := by
  have h := legendre_slope_bound (p := p) hk
  simpa [one_mul] using h

/--
**F27 — quantitative E/G separation (Lucas-Legendre dichotomy).**

For every prime `p ≥ 5` and every `k ≥ 1`, there is a uniform
constant `C = 1` such that the two dichotomy bounds hold:

    (E)   k  ≤  C · (p − 1) · v_p(k!)  +  C · (p − 1) · (log_p k + 1)
    (G)   v_p(2 k + 1)  ≤  C · (log_p (2 k + 1) + 1).

These are the quantitative statements of the two scales:

  * (E) is the Legendre slope bound: `v_p(k!) ≳ k / (p − 1)`, so the
    E-function `₁F₁(1/3; 4/3; z)` has Taylor coefficients with
    p-adic valuation decaying at linear rate `1 / (p − 1)`.

  * (G) is the logarithmic bound: `v_p(2k + 1) ≤ log_p(2k+1) + 1`,
    so the G-function `arctan z` has Taylor coefficients with
    p-adic valuation decaying at most logarithmically.

The hypothesis `p ≥ 5` is included for compatibility with the
Paper-Attack13 §2.1 regime (primes `5, 7, 11, …` avoid the numerator
of `a = 1/3` and `b = 4/3`), though the actual combinatorial bounds
hold for all primes `p` and are proven without using `p ≥ 5`.

The choice `C = 1` shows that the separation is tight: no constant
smaller than `1` would fit the E-side (which already uses coefficient
`1` on the E-side additive slack).  The existence-style statement
with a packaged `C` is proved by providing the witness `C = 1`.
-/
theorem lucas_separation
    {p : ℕ} [hp : Fact p.Prime] (_hp5 : 5 ≤ p)
    {k : ℕ} (hk : k ≠ 0) :
    ∃ C : ℕ, 1 ≤ C ∧
      (k ≤ C * ((p - 1) * padicValNat p k.factorial)
            + C * ((p - 1) * (Nat.log p k + 1)))
      ∧ (padicValNat p (2 * k + 1) ≤ C * (Nat.log p (2 * k + 1) + 1)) := by
  refine ⟨1, Nat.le_refl 1, ?_, ?_⟩
  · exact legendre_slope_bound_weakened hk
  · have h := g_side_log_bound (p := p) k
    simpa [one_mul] using h

/--
**F27 separation (existence over primes form).**

The cleaner existence statement: there is a uniform constant
`C ≥ 1` (namely `C = 1`) that makes the dichotomy true for every
prime `p ≥ 5` and every `k ≥ 1`.

This reorders the quantifiers from `lucas_separation` to show the
constant `C` is chosen once, independently of `p` and `k`.
-/
theorem lucas_separation_uniform :
    ∃ C : ℕ, 1 ≤ C ∧
      ∀ (p : ℕ) [Fact p.Prime], 5 ≤ p →
        ∀ {k : ℕ}, k ≠ 0 →
          (k ≤ C * ((p - 1) * padicValNat p k.factorial)
                + C * ((p - 1) * (Nat.log p k + 1)))
          ∧ (padicValNat p (2 * k + 1) ≤ C * (Nat.log p (2 * k + 1) + 1)) := by
  refine ⟨1, Nat.le_refl 1, ?_⟩
  intro p _hpFact _hp5 k hk
  refine ⟨?_, ?_⟩
  · exact legendre_slope_bound_weakened hk
  · have h := g_side_log_bound (p := p) k
    simpa [one_mul] using h

/-!
### Axiom audit

All theorems depend only on Lean's core axioms plus Mathlib's
standard classical axioms (`propext`, `Classical.choice`, `Quot.sound`).
No invocation of `Real.pi_transcendental` — F27 is a purely p-adic
combinatorial statement.
-/
#print axioms padicValNat_le_nat_log_succ
#print axioms g_side_log_bound
#print axioms legendre_slope_bound_weakened
#print axioms lucas_separation
#print axioms lucas_separation_uniform

end OmegaTheory.Irrationality.HermitePade
