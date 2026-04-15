/-
  OmegaTheory.Irrationality.HermitePade.F27_TaylorPartialSum

  Step (a) of analytic-attacker's (a)–(d) spec for Proof-Sketch
  Lemma 3.1 (E-denominator domination).

  Defines the rational Taylor-coefficient and partial-sum machinery for
  the confluent hypergeometric slice `(a, b, z₀) = (1/3, 4/3, 1/3)` and
  for the G-function `arctan z` at the same `z₀`.

  We start directly from the *closed form* `c_k = 1 / ((3 k + 1) · k!)`
  (equivalent to `(1/3)_k / ((4/3)_k · k!)` after Pochhammer telescoping;
  see `Paper-Attack13-Proof-Sketch.md` §1 and §3).  This choice sidesteps
  the intricate product-of-Pochhammers algebra at the `ℚ`-level while
  still formalizing the content Lemma 3.1 requires.

  Scope (definitions only)
  ------------------------
  • `cK k` — E-side Taylor coefficient `c_k = 1 / ((3 k + 1) · k!)`.
  • `dK k` — G-side Taylor coefficient `d_k = (-1)^k / (2 k + 1)`.
  • `uN N` — E-partial sum `∑_{k ≤ N} c_k · (1/3)^k`.
  • `gN N` — G-partial sum `∑_{k ≤ N/2} d_k · (1/3)^(2k+1)`.
  • `rN P₀ P₁ P₂ N` — truncation residual
     `(P₀ : ℚ) + P₁ · u_N + P₂ · g_N`.

  Scope (basic arithmetic)
  ------------------------
  Basic positivity / nonzero-ness facts needed for downstream
  `padicValRat` manipulations.  No transcendence assumptions, no new
  axioms.

  Dependencies: Mathlib v4.29 (Rat, Finset, padicValNat already in
  scope via `F27_LegendreSlope`).

  Byline: Norbert Marchewka, analytic-attacker (spec), formal-prover
  (Lean formalization).  2026-04-15.
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Rat.Cast.Defs
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/-!
### E-side Taylor coefficient (closed form)

For the slice `(a, b) = (1/3, 4/3)`, the Pochhammer identity
`(1/3)_k / (4/3)_k = 1/(3k+1)` gives the closed form

    c_k  =  (1/3)_k / ((4/3)_k · k!)  =  1 / ((3 k + 1) · k!)

used throughout Proof-Sketch §1 and §3.  We adopt this as the
starting definition; the Pochhammer equivalence is available via
`F54_SlicePrime.pochhammer_num_coprime` at the structural level.
-/

/-- E-side Taylor coefficient `c_k = 1 / ((3 k + 1) · k!)` for the
slice `(1/3, 4/3, 1/3)`. -/
def cK (k : ℕ) : ℚ :=
  1 / ((3 * k + 1 : ℕ) * k.factorial : ℚ)

/-- G-side Taylor coefficient `d_k = (-1)^k / (2 k + 1)` for `arctan`. -/
def dK (k : ℕ) : ℚ :=
  (-1 : ℚ) ^ k / ((2 * k + 1 : ℕ) : ℚ)

/-!
### Basic nonzero-ness facts for `cK` and `dK`

Both `3 k + 1` and `2 k + 1` are positive nonzero naturals, so the
rational values `cK k` and `dK k` are never zero.  This allows downstream
`padicValRat` arguments to assume nonzero hypotheses cleanly.
-/

/-- `3 k + 1` is positive for every `k : ℕ`. -/
lemma three_k_plus_one_pos (k : ℕ) : 0 < (3 * k + 1 : ℕ) := by
  omega

/-- `3 k + 1` cast to `ℚ` is nonzero for every `k : ℕ`. -/
lemma three_k_plus_one_ne_zero (k : ℕ) : ((3 * k + 1 : ℕ) : ℚ) ≠ 0 := by
  have h := three_k_plus_one_pos k
  exact_mod_cast h.ne'

/-- `k!` cast to `ℚ` is nonzero. -/
lemma factorial_ne_zero (k : ℕ) : (k.factorial : ℚ) ≠ 0 := by
  have h : k.factorial ≠ 0 := k.factorial_ne_zero
  exact_mod_cast h

/-- `(3 k + 1) · k!` cast to `ℚ` is nonzero. -/
lemma three_k_plus_one_mul_factorial_ne_zero (k : ℕ) :
    ((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) ≠ 0 :=
  mul_ne_zero (three_k_plus_one_ne_zero k) (factorial_ne_zero k)

/-- E-side coefficient `cK k` is always nonzero. -/
lemma cK_ne_zero (k : ℕ) : cK k ≠ 0 := by
  unfold cK
  have hnz : ((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) ≠ 0 :=
    three_k_plus_one_mul_factorial_ne_zero k
  exact one_div_ne_zero hnz

/-- `2 k + 1` is positive. -/
lemma two_k_plus_one_pos (k : ℕ) : 0 < (2 * k + 1 : ℕ) := by
  omega

/-- `2 k + 1` cast to `ℚ` is nonzero. -/
lemma two_k_plus_one_ne_zero (k : ℕ) : ((2 * k + 1 : ℕ) : ℚ) ≠ 0 := by
  have h := two_k_plus_one_pos k
  exact_mod_cast h.ne'

/-- G-side coefficient `dK k` is nonzero. -/
lemma dK_ne_zero (k : ℕ) : dK k ≠ 0 := by
  unfold dK
  apply div_ne_zero
  · exact pow_ne_zero _ (by norm_num : (-1 : ℚ) ≠ 0)
  · exact two_k_plus_one_ne_zero k

/-!
### Partial sums

The E-partial-sum `u_N = ∑_{k ≤ N} c_k · (1/3)^k` and the G-partial-sum
`g_N = ∑_{k ≤ N/2} d_k · (1/3)^(2k+1)`.  Both are honest rationals
defined via `Finset.sum`.

The summation index for `u_N` runs `0 ≤ k ≤ N` (so `N + 1` terms), and
for `g_N` runs `0 ≤ k ≤ ⌊(N-1)/2⌋ = N/2 - 1` if `N ≥ 1` (Nat floor);
the sketch uses `M = N/2` slightly differently but the shape of the
computation is the same.  We use `Finset.range (N + 1)` throughout for
simplicity — i.e. `g_N` sums `k = 0 … N` of `d_k · (1/3)^(2k+1)`.
This is a superset of the sketch's truncation and is equivalent for
the asymptotics.
-/

/-- E-side partial sum `u_N = ∑_{k = 0}^{N} c_k · (1/3)^k`. -/
def uN (N : ℕ) : ℚ :=
  ∑ k ∈ Finset.range (N + 1), cK k * (1 / 3 : ℚ) ^ k

/-- G-side partial sum `g_N = ∑_{k = 0}^{N/2} d_k · (1/3)^(2k+1)`.

The upper index `N/2` (natural floor division) matches the sketch's
truncation: the G-series `arctan z = ∑ d_k · z^{2k+1}` has only odd
powers of `z`, so truncating at total-degree `N` keeps indices `k`
with `2k + 1 ≤ N`, i.e. `k ≤ (N-1)/2`, which in `ℕ` is `k ≤ N/2` for
N ≥ 1 and `k = 0` (empty sum behaves correctly) for `N = 0`.

For `N = 0` the sum `Finset.range (0/2 + 1) = Finset.range 1 = {0}`
has the single term `d_0 · (1/3) = 1/3`; this matches the sketch's
convention that `g_0` is the constant term of the truncation. -/
def gN (N : ℕ) : ℚ :=
  ∑ k ∈ Finset.range (N / 2 + 1), dK k * (1 / 3 : ℚ) ^ (2 * k + 1)

/-- Truncation residual `r_N = P₀ + P₁ · u_N + P₂ · g_N`. -/
def rN (P₀ P₁ P₂ : ℤ) (N : ℕ) : ℚ :=
  (P₀ : ℚ) + (P₁ : ℚ) * uN N + (P₂ : ℚ) * gN N

/-!
### Explicit form of an individual E-summand

The `k`-th summand of `u_N` is `cK k * (1/3)^k = 1 / ((3k+1) · k! · 3^k)`.
We expose this closed form as a lemma; it is the key algebraic
identity used in the `ord_3` computation of `F27_E_Denominator.lean`.
-/

/-- The `k`-th summand `c_k · z₀^k` in closed rational form. -/
lemma cK_mul_zk (k : ℕ) :
    cK k * (1 / 3 : ℚ) ^ k
      = 1 / (((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) * 3 ^ k) := by
  unfold cK
  have hmul_ne : ((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) ≠ 0 :=
    three_k_plus_one_mul_factorial_ne_zero k
  have h3_ne : (3 : ℚ) ^ k ≠ 0 := pow_ne_zero _ (by norm_num : (3 : ℚ) ≠ 0)
  rw [one_div_pow]
  field_simp

/-- Nonzero-ness of the denominator of the `k`-th E-summand. -/
lemma cK_mul_zk_denom_ne_zero (k : ℕ) :
    ((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) * (3 : ℚ) ^ k ≠ 0 := by
  refine mul_ne_zero (mul_ne_zero ?_ ?_) ?_
  · exact three_k_plus_one_ne_zero k
  · exact factorial_ne_zero k
  · exact pow_ne_zero _ (by norm_num : (3 : ℚ) ≠ 0)

/-- The `k`-th summand `c_k · (1/3)^k` is nonzero. -/
lemma cK_mul_zk_ne_zero (k : ℕ) : cK k * (1 / 3 : ℚ) ^ k ≠ 0 := by
  rw [cK_mul_zk]
  apply one_div_ne_zero
  have := cK_mul_zk_denom_ne_zero k
  push_cast at this ⊢
  exact this

/-- Nonzero-ness of the `k`-th G-summand `d_k · (1/3)^(2k+1)`. -/
lemma dK_mul_zk_ne_zero (k : ℕ) :
    dK k * (1 / 3 : ℚ) ^ (2 * k + 1) ≠ 0 :=
  mul_ne_zero (dK_ne_zero k)
    (pow_ne_zero _ (by norm_num : (1 / 3 : ℚ) ≠ 0))

/-!
### Axiom audit

All definitions and lemmas depend only on Lean's core axioms plus
Mathlib's standard classical axioms (`propext`, `Classical.choice`,
`Quot.sound`).  No transcendence input.
-/

#print axioms cK
#print axioms dK
#print axioms uN
#print axioms gN
#print axioms rN
#print axioms cK_mul_zk
#print axioms cK_mul_zk_ne_zero

end OmegaTheory.Irrationality.HermitePade
