/-
  OmegaTheory.Irrationality.HermitePade.F27_LegendreSlope

  F27 — Quantitative Legendre slope for factorial denominators
  (π-opacity diary, Attack 13 / Module 11 §11.5).

  Informal statement
  ------------------
  The Hermite–Padé attack on K₂-opacity controls the `p`-adic valuation
  of the Taylor coefficients

      c_k  =  (a)_k / ((b)_k · k!)

  of the confluent hypergeometric E-function `₁F₁(a; b; z)` at rational
  parameters.  F54 (`F54_SlicePrime.lean`) already gave the Pochhammer
  side: for `a = q / p` with `p ∤ q`, the numerator Pochhammer
  `(q/p)_k` contributes `p`-valuation exactly `−k`.

  To close the denominator side, one needs Legendre's formula for the
  `p`-adic valuation of `k!`:

      v_p(k!)  =  ∑_{i ≥ 1} ⌊k / p^i⌋       (finite sum; terms vanish for p^i > k)
              =  (k − s_p(k)) / (p − 1)

  where `s_p(k)` is the sum of base-`p` digits of `k`.  The key *slope*
  corollary is

      v_p(k!)  ≥  (k − (p−1)(log_p k + 1)) / (p − 1)       (slope 1/(p−1))

  which, combined with F54's slope `−1`, gives the overall asymptotic
  `ord_p(c_k)  ≈  −k · (1 + 1/(p−1))` for primes `p ≥ 5` not dividing
  the numerators of `a, b`.

  Scope of this file
  ------------------
  Mathlib v4.29 supplies `padicValNat_factorial` (Legendre's formula) and
  `sub_one_mul_padicValNat_factorial` (the `(p−1)·v_p(k!) = k − s_p(k)`
  form).  What Attack 13 needs is the **slope bound** as an inequality
  on `ℕ`.  We provide:

  • `legendre_padicValNat_factorial` — re-exported Legendre identity in
    the Ico form used by Mathlib.

  • `digitSum_le` — digit sum bound `s_p(k) ≤ (p−1) · length (digits p k)`.

  • `digitSum_le_pred_mul_log_succ` — packaging in terms of `Nat.log`:
    `s_p(k) ≤ (p−1) · (log p k + 1)` for `k ≠ 0`.

  • `legendre_slope_bound` — the main quantitative slope bound:

        (p − 1) · v_p(k!) + (p − 1) · (log p k + 1)  ≥  k

    rearranged as `(p−1) · v_p(k!) ≥ k − (p−1)(log p k + 1)`.  The
    shape `slope ≥ 1/(p−1)` is visible directly from this form.

  No sorries.  Depends only on Mathlib v4.29 classical axioms.
-/

import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Digits.Lemmas
import Mathlib.Data.Nat.Log

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Legendre's factorial valuation formula** (re-exported form).

For a prime `p` and any bound `b > log_p k`, the `p`-adic valuation of
`k!` equals the finite sum `∑_{i=1}^{b-1} ⌊k / p^i⌋`.

This is Mathlib's `padicValNat_factorial` reprinted here as the entry
point for the F27 slope argument (the sum of quotients is what the
Hermite–Padé diary calls "Legendre's formula").
-/
theorem legendre_padicValNat_factorial
    {p : ℕ} [hp : Fact p.Prime] {k b : ℕ} (hkb : Nat.log p k < b) :
    padicValNat p (k.factorial) = ∑ i ∈ Finset.Ico 1 b, k / p ^ i :=
  padicValNat_factorial hkb

/--
**Digit sum bound (general).**

For any base `p`, the sum of the base-`p` digits of `k` is bounded
above by `(p − 1) · (digits p k).length`, because every digit is strictly
less than `p`.

This is the combinatorial half of the slope estimate.  We reduce it to
a `List.sum_le_card_nsmul` argument: every element of `p.digits k` is
`< p`, hence `≤ p − 1`, so the sum is bounded by `(p − 1)` times the
length.
-/
theorem digitSum_le
    {p : ℕ} (hp : 1 < p) (k : ℕ) :
    (p.digits k).sum ≤ (p - 1) * (p.digits k).length := by
  -- Every digit `d ∈ p.digits k` satisfies `d ≤ p - 1`.
  have hbound : ∀ d ∈ p.digits k, d ≤ p - 1 := by
    intro d hd
    exact Nat.le_sub_one_of_lt (Nat.digits_lt_base hp hd)
  -- List.sum is bounded by card times sup.
  have hsum : (p.digits k).sum ≤ (p.digits k).length * (p - 1) :=
    List.sum_le_card_nsmul (p.digits k) (p - 1) hbound
  -- Multiplication is commutative.
  simpa [Nat.mul_comm] using hsum

/--
**Digit sum bound (log form).**

For `p > 1` and `k > 0`, the base-`p` digit sum of `k` is bounded by
`(p − 1) · (log p k + 1)`, since `(p.digits k).length = log p k + 1`
for nonzero `k`.
-/
theorem digitSum_le_pred_mul_log_succ
    {p : ℕ} (hp : 1 < p) {k : ℕ} (hk : k ≠ 0) :
    (p.digits k).sum ≤ (p - 1) * (Nat.log p k + 1) := by
  have hlen : (p.digits k).length = Nat.log p k + 1 :=
    Nat.length_digits p k hp hk
  have hbase := digitSum_le hp k
  rw [hlen] at hbase
  exact hbase

/--
**F27 — quantitative Legendre slope bound.**

For a prime `p` and `k > 0`,

    (p − 1) · padicValNat p (k!)  ≥  k  −  (p − 1) · (log p k + 1).

In slope form (informally), `padicValNat p (k!) ≥ k / (p − 1) − (log p k + 1)`,
so the slope in `k` is at least `1 / (p − 1)`.

Proof.  Mathlib's `sub_one_mul_padicValNat_factorial` gives
`(p − 1) · v_p(k!) = k − s_p(k)`.  Combining with
`s_p(k) ≤ (p − 1)(log p k + 1)` yields the claim.

We phrase the conclusion additively (no `Nat` subtraction on the RHS of
the `≥`), as

    k ≤ (p − 1) · padicValNat p (k!)  +  (p − 1) · (log p k + 1).
-/
theorem legendre_slope_bound
    {p : ℕ} [hp : Fact p.Prime] {k : ℕ} (hk : k ≠ 0) :
    k ≤ (p - 1) * padicValNat p k.factorial
          + (p - 1) * (Nat.log p k + 1) := by
  -- Mathlib's Legendre-digit form: (p-1) * v_p(k!) = k - s_p(k).
  have hlaw : (p - 1) * padicValNat p (k.factorial) = k - (p.digits k).sum :=
    sub_one_mul_padicValNat_factorial k
  -- Digit sum is ≤ k (Mathlib), so the subtraction is well-defined.
  have hsum_le_k : (p.digits k).sum ≤ k := Nat.digit_sum_le p k
  -- Digit sum is bounded by (p-1) * (log p k + 1).
  have hp1 : 1 < p := hp.out.one_lt
  have hdigit :=
    digitSum_le_pred_mul_log_succ hp1 hk
  -- Rewrite (p-1) * v_p(k!) = k - s_p(k), then add s_p(k) to both sides.
  -- Target: k ≤ (p-1) * v + (p-1) * (log p k + 1).
  -- Suffices: k ≤ (k - s_p(k)) + (p-1) * (log p k + 1).
  rw [hlaw]
  -- Since s_p(k) ≤ (p-1)(log p k + 1), we have:
  --   k = (k - s_p(k)) + s_p(k) ≤ (k - s_p(k)) + (p-1)(log p k + 1).
  have hk_eq : k = (k - (p.digits k).sum) + (p.digits k).sum :=
    (Nat.sub_add_cancel hsum_le_k).symm
  calc k = (k - (p.digits k).sum) + (p.digits k).sum := hk_eq
    _ ≤ (k - (p.digits k).sum) + (p - 1) * (Nat.log p k + 1) :=
        Nat.add_le_add_left hdigit _

/-!
### Axiom audit

All theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms (`propext`, `Classical.choice`, `Quot.sound`) — no
invocation of `Real.pi_transcendental`.  F27 is a purely `p`-adic /
combinatorial result.
-/
#print axioms legendre_padicValNat_factorial
#print axioms digitSum_le
#print axioms digitSum_le_pred_mul_log_succ
#print axioms legendre_slope_bound

end OmegaTheory.Irrationality.HermitePade
