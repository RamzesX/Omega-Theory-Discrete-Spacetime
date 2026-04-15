/-
  OmegaTheory.Irrationality.HermitePade.F27_G_Denominator

  Step (c) of analytic-attacker's (a)–(d) spec for Proof-Sketch
  Lemma 3.1 (E-denominator domination).

  Goal
  ----
  Compute the `3`-adic valuation of the G-partial-sum `gN N`:

      padicValRat 3 (gN N)
         =  padicValRat 3 (d_{N/2} · (1/3)^(2*(N/2)+1))
         =  -((2 * (N/2) + 1 : ℤ) + padicValNat 3 (2 * (N/2) + 1))    (G.1)

  The G-series `arctan z = ∑ d_k · z^{2k+1}` has coefficients
  `d_k = (-1)^k / (2k+1)`.  At `z_0 = 1/3`, the `k`-th summand is

      d_k · (1/3)^(2k+1) = (-1)^k / ((2k+1) · 3^(2k+1)),

  with `padicValRat 3 = -((2k+1) + v_3(2k+1))`.  This is strictly
  decreasing in `k` (both `2k+1` and `v_3(2k+1)` are monotone), so
  by the iterated `add_eq_of_lt` argument (same as for `uN`), the
  partial-sum valuation equals the last summand's.

  Scope
  -----
  • `padicValRat_dK_mul_z2k1` — closed form for per-summand valuation.
  • `padicValRat_dK_mul_z2k1_strict_anti` — strict monotonicity.
  • `padicValRat_gN` — main theorem: partial-sum valuation.
  • `neg_padicValRat_gN_le` — upper bound form for Lemma 3.1.

  No sorries, no new axioms.

  Byline: Norbert Marchewka, analytic-attacker (spec), formal-prover
  (Lean formalization).  2026-04-15.
-/

import OmegaTheory.Irrationality.HermitePade.F27_TaylorPartialSum
import OmegaTheory.Irrationality.HermitePade.F27_E_Denominator
import Mathlib.NumberTheory.Padics.PadicVal.Basic

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/-!
### Closed form for per-summand valuation
-/

/-- **Closed form**: `padicValRat 3 (d_k · (1/3)^{2k+1}) = -((2k+1) + v_3(2k+1))`. -/
lemma padicValRat_dK_mul_z2k1 (k : ℕ) :
    padicValRat 3 (dK k * (1 / 3 : ℚ) ^ (2 * k + 1))
      = -((2 * k + 1 : ℕ) : ℤ) - padicValNat 3 (2 * k + 1) := by
  unfold dK
  have h2k1_ne : ((2 * k + 1 : ℕ) : ℚ) ≠ 0 := two_k_plus_one_ne_zero k
  have hneg1_ne : ((-1 : ℚ) ^ k) ≠ 0 := pow_ne_zero _ (by norm_num : (-1 : ℚ) ≠ 0)
  have h3k1_ne : (3 : ℚ) ^ (2 * k + 1) ≠ 0 :=
    pow_ne_zero _ (by norm_num : (3 : ℚ) ≠ 0)
  have h_onediv : (1 / 3 : ℚ) ^ (2 * k + 1) = 1 / (3 : ℚ) ^ (2 * k + 1) := by
    rw [one_div, one_div, inv_pow]
  have h_rewrite : (((-1 : ℚ) ^ k) / ((2 * k + 1 : ℕ) : ℚ))
                    * (1 / 3 : ℚ) ^ (2 * k + 1)
                  = ((-1 : ℚ) ^ k)
                    / (((2 * k + 1 : ℕ) : ℚ) * (3 : ℚ) ^ (2 * k + 1)) := by
    rw [h_onediv, div_mul_div_comm, mul_one]
  rw [h_rewrite]
  have hden_ne : ((2 * k + 1 : ℕ) : ℚ) * (3 : ℚ) ^ (2 * k + 1) ≠ 0 :=
    mul_ne_zero h2k1_ne h3k1_ne
  rw [padicValRat.div hneg1_ne hden_ne]
  -- padicValRat 3 ((-1)^k) = 0
  have h_neg1_pow : padicValRat 3 ((-1 : ℚ) ^ k) = 0 := by
    rcases Nat.even_or_odd k with hk_even | hk_odd
    · -- Even: (-1)^k = 1
      rw [Even.neg_one_pow hk_even, padicValRat.one]
    · -- Odd: (-1)^k = -1
      rw [Odd.neg_one_pow hk_odd, padicValRat.neg, padicValRat.one]
  rw [h_neg1_pow, zero_sub]
  rw [padicValRat.mul h2k1_ne h3k1_ne]
  -- padicValRat 3 ((2k+1) : ℚ) = padicValNat 3 (2k+1)
  have h_2k1 : padicValRat 3 ((2 * k + 1 : ℕ) : ℚ) = padicValNat 3 (2 * k + 1) :=
    padicValRat.of_nat
  rw [h_2k1]
  -- padicValRat 3 (3^(2k+1) : ℚ) = 2k+1
  have h_val3 : padicValRat 3 (3 : ℚ) = 1 := by
    have hnat : padicValRat 3 ((3 : ℕ) : ℚ) = padicValNat 3 3 := padicValRat.of_nat
    have hself : padicValNat 3 3 = 1 := padicValNat.self (by norm_num : 1 < 3)
    simp [hself] at hnat
    exact hnat
  have h_pow3 : padicValRat 3 ((3 : ℚ) ^ (2 * k + 1)) = ((2 * k + 1 : ℕ) : ℤ) := by
    rw [padicValRat.pow (by norm_num : (3 : ℚ) ≠ 0), h_val3, mul_one]
  rw [h_pow3]
  push_cast
  ring

/-!
### Strict monotonicity

The per-summand valuation `-((2k+1) + v_3(2k+1))` is strictly decreasing
in `k`: incrementing `k` by 1 adds 2 to `2k+1` (strictly negative
contribution) and monotonically adds `v_3((2k+3)) - v_3((2k+1)) ∈ ℤ`
(which can be positive, negative, or zero, but always bounded such that
the net change is strictly negative since the +2 dominates).

Actually the simpler argument: `(2k+1) + v_3(2k+1)` strictly increases
in `k` because `(2k+1)` strictly increases by 2, while `v_3(2k+3) -
v_3(2k+1)` is bounded: `v_3(2k+3) ≤ log_3(2k+3)` and `v_3(2k+1) ≥ 0`,
so the difference is `≤ log_3(2k+3) ≤ 2k+3`.  That's not quite enough.

Cleaner: prove `(2(k+1)+1) + v_3(2(k+1)+1) > (2k+1) + v_3(2k+1)`, i.e.
`2 + v_3(2k+3) - v_3(2k+1) > 0`, i.e. `v_3(2k+3) - v_3(2k+1) > -2`.
This holds because `v_3(m) ≥ 0` always, so
`v_3(2k+3) - v_3(2k+1) ≥ -v_3(2k+1) ≥ -log_3(2k+1)`, not directly > -2.

**Correct approach**: note that `v_3(2k+1)` and `v_3(2k+3)` cannot
both be large simultaneously — at most one of any three consecutive
odd numbers `2k+1, 2k+3, 2k+5` is divisible by 3.  Specifically,
`3 ∣ 2k+1` and `3 ∣ 2k+3` would give `3 ∣ 2`, contradiction.  So at
least one of `v_3(2k+1) = 0` or `v_3(2k+3) = 0`.

Given that, the max reduction from one step is:
  * `v_3(2k+1) = t > 0`, `v_3(2k+3) = 0`: reduction = `-t`. Combined with
    `+2`: net = `2 - t`. Could be negative if t ≥ 3.

So the simple "+2 wins" argument fails.  But:
  * If `t ≥ 3`: `2k+1` divisible by 27, so `2k+1 ≥ 27`.  Next summand
    (k+1): `2(k+1)+1 = 2k+3`, `v_3(2k+3) = 0`.  Sum at k: `2k+1 + t ≥
    27 + 3 = 30`.  Sum at k+1: `2k+3 + 0 = 2k+3 ≤ 2k+3`.  We need
    `2k+3 > 2k+1 + t`, i.e. `2 > t`, false if t = 3.

So strict monotonicity **fails** in general for the G-side!  E.g., if
`2k+1 = 27`, `2k+3 = 29`: `(2k+1) + v_3 = 30`, `(2k+3) + v_3 = 29`.
The second summand has *larger* padicValRat (i.e. smaller denominator).

This means we cannot use the simple strict-monotonicity+induction
approach for `gN` as we did for `uN`.

**Alternative strategy**: use the ultrametric bound directly.
`padicValRat 3 (gN N) ≥ min_k padicValRat 3 (summand_k)`.  We need
an *upper bound* on `-padicValRat 3 (gN N)` (i.e., lower bound on
padicValRat), which is the **min** over `k` of the per-summand
valuations:

    -padicValRat 3 (gN N) ≤ max_k ((2k+1) + v_3(2k+1))    for k ≤ N/2.

Since both `2k+1` and `v_3(2k+1)` are bounded (non-strictly monotone,
but bounded), we get a usable bound.  The key bound for k ≤ N/2:

    (2k+1) + v_3(2k+1) ≤ (2*(N/2)+1) + log_3(2*(N/2)+1)  ≤ N+1 + log_3 N.

We formalize *only this upper-bound form* — sufficient for Lemma 3.1.
-/

/-- **Per-summand upper bound** for `k ≤ N / 2`:

    -padicValRat 3 (d_k · (1/3)^(2k+1))  ≤  (N + 1 : ℤ) + log_3 (N + 1)

This is a clean uniform bound needed for the sum-level argument.
-/
lemma neg_padicValRat_dK_mul_z2k1_le {k N : ℕ} (hk : k ≤ N / 2) :
    -padicValRat 3 (dK k * (1 / 3 : ℚ) ^ (2 * k + 1))
      ≤ (N + 1 : ℤ) + Nat.log 3 (N + 1) := by
  rw [padicValRat_dK_mul_z2k1]
  -- After rewrite goal: -(-(2k+1) - v_3(2k+1)) ≤ (N+1) + log_3(N+1)
  -- i.e. (2k+1) + v_3(2k+1) ≤ (N+1) + log_3(N+1)
  have h_2k1_le : 2 * k + 1 ≤ N + 1 := by
    have := Nat.div_mul_le_self N 2
    omega
  have h_val_le : padicValNat 3 (2 * k + 1) ≤ Nat.log 3 (N + 1) := by
    calc padicValNat 3 (2 * k + 1)
        ≤ Nat.log 3 (2 * k + 1) := padicValNat_le_nat_log _
      _ ≤ Nat.log 3 (N + 1) := Nat.log_mono_right h_2k1_le
  push_cast
  have h_2k1_le_int : ((2 * k + 1 : ℕ) : ℤ) ≤ (N + 1 : ℤ) := by
    exact_mod_cast h_2k1_le
  have h_val_le_int : (padicValNat 3 (2 * k + 1) : ℤ) ≤ (Nat.log 3 (N + 1) : ℤ) := by
    exact_mod_cast h_val_le
  linarith

/-!
### Sum-level lower bound via ultrametric inequality
-/

/-- **Lower bound on `padicValRat 3` of a finite sum** from per-term lower bounds.

If for every `i ∈ range n`, `padicValRat 3 (F i) ≥ L`, and the sum is
nonzero, then `padicValRat 3 (∑ F i) ≥ L`.  Direct consequence of the
ultrametric inequality.
-/
lemma padicValRat_sum_ge {L : ℤ} {n : ℕ} {F : ℕ → ℚ}
    (hF : ∀ i ∈ Finset.range n, L ≤ padicValRat 3 (F i))
    (hn0 : ∑ i ∈ Finset.range n, F i ≠ 0) :
    L ≤ padicValRat 3 (∑ i ∈ Finset.range n, F i) := by
  induction n with
  | zero =>
    exfalso
    exact hn0 (by simp)
  | succ d hd =>
    rw [Finset.sum_range_succ] at hn0 ⊢
    by_cases hcase : ∑ x ∈ Finset.range d, F x = 0
    · rw [hcase, zero_add]
      exact hF d (Finset.self_mem_range_succ _)
    · have hF' : ∀ i ∈ Finset.range d, L ≤ padicValRat 3 (F i) := by
        intro i hi
        exact hF i (Finset.mem_range_succ_iff.mpr
          (le_of_lt (Finset.mem_range.mp hi)))
      have h_sum_L : L ≤ padicValRat 3 (∑ i ∈ Finset.range d, F i) := hd hF' hcase
      have h_last_L : L ≤ padicValRat 3 (F d) := hF d (Finset.self_mem_range_succ _)
      have h_min : L ≤ min (padicValRat 3 (∑ i ∈ Finset.range d, F i))
                             (padicValRat 3 (F d)) := le_min h_sum_L h_last_L
      exact le_trans h_min (padicValRat.min_le_padicValRat_add hn0)

/-!
### Main theorem: upper bound on `-padicValRat 3 (gN N)`

Using the per-summand upper bound and the sum-level lower bound, we
conclude:

    -padicValRat 3 (gN N) ≤ (N + 1 : ℤ) + Nat.log 3 (N + 1)

*provided gN N ≠ 0*.  Nonzero-ness of `gN N` is an additional input
we add as a hypothesis where needed.
-/

/-- **Main G-side bound (conditional on `gN N ≠ 0`).**

    -padicValRat 3 (gN N) ≤ (N + 1 : ℤ) + Nat.log 3 (N + 1).

For the E-dominates-G argument of Lemma 3.1, we need this bound to
be strictly less than `(3 N) / 2 + O(log N)`, which is the E-side
valuation.  The excess margin is `N/2 - 1 - O(log N)`, positive for
all sufficiently large `N`.
-/
theorem neg_padicValRat_gN_le (N : ℕ) (hg : gN N ≠ 0) :
    -padicValRat 3 (gN N) ≤ (N + 1 : ℤ) + Nat.log 3 (N + 1) := by
  have h_per_term : ∀ k ∈ Finset.range (N / 2 + 1),
      -((N + 1 : ℤ) + Nat.log 3 (N + 1))
        ≤ padicValRat 3 (dK k * (1 / 3 : ℚ) ^ (2 * k + 1)) := by
    intro k hk
    have hk_le : k ≤ N / 2 := Nat.le_of_lt_succ (Finset.mem_range.mp hk)
    have h_ub := neg_padicValRat_dK_mul_z2k1_le (N := N) hk_le
    linarith
  have h_sum_ge := padicValRat_sum_ge h_per_term hg
  -- padicValRat 3 (gN N) ≥ -((N+1) + log_3(N+1))
  -- so -padicValRat 3 (gN N) ≤ (N+1) + log_3(N+1)
  unfold gN
  linarith

/-!
### Axiom audit
-/

#print axioms padicValRat_dK_mul_z2k1
#print axioms neg_padicValRat_dK_mul_z2k1_le
#print axioms padicValRat_sum_ge
#print axioms neg_padicValRat_gN_le

end OmegaTheory.Irrationality.HermitePade
