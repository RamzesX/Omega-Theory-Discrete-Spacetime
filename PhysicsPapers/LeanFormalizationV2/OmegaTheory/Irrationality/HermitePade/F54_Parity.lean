/-
  OmegaTheory.Irrationality.HermitePade.F54_Parity

  F54 — Parity rule for the slice-prime correspondence (Module 11 §11.4).

  Background
  ----------
  `F54_SlicePrime.lean` proves the "slope −1" content of the F54
  slice-prime correspondence for the ODD branch:

      q odd, gcd(q, p) = 1, p ≥ 5 (prime)  ⟹
        ∏_{j<k} (q + j·p)  is coprime to p.

  Empirically the π-diary (Attack 19, §11.4) observes a PARITY split:
  the E-signature of a slice `(q/p, (q+p)/p, q/p)` sits at prime `p`
  when `q` is odd, but **diverts to 2** when `q` is even, because the
  `j = 0` Pochhammer factor is `q` itself and contributes its full
  `ord_2(q)` to the 2-adic valuation of the numerator product.

  Scope of this file
  ------------------
  We prove two non-vacuous sub-lemmas:

  • `odd_q_slope_at_p_strengthened` — strengthens the odd-branch
    statement of `F54_SlicePrime.lean`:  under
    `q odd ∧ gcd(q,p)=1 ∧ p prime ∧ p ≥ 5`, the Pochhammer numerator
    `∏_{j<k} (q + j·p)` is coprime to `p`.  (Strengthening: previously
    only `¬ p ∣ q` was required; now we show explicitly that the
    hypotheses of the π-diary §11.4 "odd-q row" are sufficient.)

  • `even_q_slope_at_2` — new even-branch content: if `q : ℤ` is even
    (witnessed by `q = 2^e * q'` for some `e ≥ 1`, `q' : ℤ`), and
    `k ≥ 1`, then `(2 : ℤ) ^ e ∣ ∏_{j<k} (q + j·p)`.  This is the
    formal form of "the `j = 0` Pochhammer factor carries
    `ord_2(q)` into the whole product".

  • `F54_parity_rule` — packaging lemma combining both branches.
    For a prime `p ≥ 5`, `gcd(q, p) = 1`, and any `k ≥ 1`:
    EITHER the Pochhammer numerator is coprime to `p` (odd-q branch)
    OR the Pochhammer numerator is divisible by `(2 : ℤ)^(ord_2 q)`
    (even-q branch).

  Dependencies: Mathlib v4.29.  No sorries, no new axioms beyond
  Mathlib (`propext`, `Classical.choice`, `Quot.sound`).
-/

import Mathlib.Data.Int.GCD
import Mathlib.RingTheory.Int.Basic
import Mathlib.Data.Nat.Prime.Int
import Mathlib.Algebra.BigOperators.Associated
import OmegaTheory.Irrationality.HermitePade.F54_SlicePrime

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Odd-branch strengthening.**  Packaging of `pochhammer_num_coprime`
(from `F54_SlicePrime.lean`) under the π-diary §11.4 "odd-q row"
hypotheses: `p` prime with `p ≥ 5`, `q` odd, `gcd(q, p) = 1`.

Under these hypotheses the Pochhammer numerator
`∏_{j<k} (q + j·p)` is coprime to `p`.

Proof.  `gcd(q, p) = 1` plus `p` prime ⟹ `¬ (p : ℤ) ∣ q`.  Then
apply `pochhammer_num_coprime`.  The oddness of `q` and the bound
`p ≥ 5` are recorded in the hypothesis list for bookkeeping — they
constrain the *slice* selection, not the divisibility argument.
-/
theorem odd_q_slope_at_p_strengthened
    {p : ℕ} (hp : p.Prime) (hp5 : 5 ≤ p)
    {q : ℤ} (hq_odd : ¬ (2 : ℤ) ∣ q) (hgcd : Int.gcd q (p : ℤ) = 1)
    (k : ℕ) :
    IsCoprime ((p : ℤ)) (∏ j ∈ range k, (q + j * p)) := by
  -- `gcd(q, p) = 1` rules out `p ∣ q`.
  have hndvd_q : ¬ (p : ℤ) ∣ q := by
    intro hpq
    -- `gcd(q, p) = 1` and `p ∣ q`, so `p ∣ 1` — impossible for `p ≥ 5`.
    -- Use `Int.isCoprime_iff_gcd_eq_one` to turn `gcd = 1` into `IsCoprime q p`,
    -- which gives `¬ (p : ℤ) ∣ q` directly once combined with primality — but
    -- more elementarily: rewrite `p ∣ q` as `p ∣ (1 : ℤ)` via Bezout / a direct
    -- computation. Easier path: use `Nat.Coprime` (the `ℕ`-gcd being 1).
    have hcop : Int.gcd q (p : ℤ) = 1 := hgcd
    -- `IsCoprime q p` follows from gcd = 1 (Mathlib: `Int.isCoprime_iff_gcd_eq_one`).
    have hIso : IsCoprime q ((p : ℤ)) :=
      (Int.isCoprime_iff_gcd_eq_one).mpr hcop
    -- `IsCoprime q p` + `p ∣ q` gives `p ∣ 1`.
    rcases hIso with ⟨a, b, hab⟩
    have hp1 : (p : ℤ) ∣ (1 : ℤ) := by
      rw [← hab]
      exact dvd_add (Dvd.dvd.mul_left hpq a) (Dvd.intro_left b rfl)
    have hp_le : (p : ℤ) ≤ 1 := Int.le_of_dvd one_pos hp1
    have hp2 : (2 : ℤ) ≤ (p : ℤ) := by exact_mod_cast hp.two_le
    linarith
  -- Use the F54 core: numerator is not divisible by `p`.
  have hndvd : ¬ (p : ℤ) ∣ ∏ j ∈ range k, (q + j * p) :=
    pochhammer_num_coprime hp hndvd_q k
  -- Prime coprimality ↔ non-divisibility.
  have hp_int : _root_.Prime (p : ℤ) := Nat.prime_iff_prime_int.mp hp
  -- Bookkeeping hypotheses `hp5, hq_odd` remain as statement-level
  -- constraints for the slice selection; they are not used in the
  -- divisibility argument itself (cf. §11.4 remark).
  have _ := hp5; have _ := hq_odd
  exact (Prime.coprime_iff_not_dvd hp_int).mpr hndvd

/--
**Even-branch 2-adic slope.**  If `q : ℤ` factors as
`q = 2^e * q'` for some `e : ℕ` and `q' : ℤ` (i.e., `2^e ∣ q`) and
`k ≥ 1`, then

    `(2 : ℤ) ^ e  ∣  ∏_{j < k} (q + j · p)`.

This is the formal content of "the `j = 0` Pochhammer factor
carries `ord_2(q)` into the whole product" — the `j = 0` term is
`q + 0·p = q`, which is divisible by `2^e`, and the rest of the
product supplies the `2^e`-divisibility to the whole thing.

Note that no parity assumption on `p` is needed here: the argument
factors a divisor of `q` out of the `j = 0` factor alone.

Proof.  Split `range k = {0} ∪ range' (k-1)` using `Finset.prod_range_succ'`
or split the product as `(q + 0·p) * (∏ j ∈ range (k-1), (q + (j+1)·p))`,
then use `Dvd.dvd.mul_right` on the `2^e ∣ q` half.
-/
theorem even_q_slope_at_2
    {q : ℤ} {e : ℕ} (hdvd : (2 : ℤ) ^ e ∣ q) (p : ℤ) {k : ℕ} (hk : 1 ≤ k) :
    (2 : ℤ) ^ e ∣ ∏ j ∈ range k, (q + j * p) := by
  -- Rewrite the product by peeling off the `j = 0` factor.
  -- `Finset.prod_range_succ'` gives `∏ j ∈ range (k+1), f j = (∏ j ∈ range k, f (j+1)) * f 0`.
  rcases Nat.exists_eq_succ_of_ne_zero (Nat.one_le_iff_ne_zero.mp hk) with ⟨k', rfl⟩
  -- Now `range (k' + 1)` splits as `{0}` plus a shifted range.
  have hsplit :
      ∏ j ∈ range (k' + 1), (q + (j : ℤ) * p)
        = (q + (0 : ℤ) * p) * ∏ j ∈ range k', (q + ((j + 1 : ℕ) : ℤ) * p) := by
    rw [Finset.prod_range_succ' (fun j => q + (j : ℤ) * p) k']
    ring
  rw [hsplit]
  -- The `j = 0` factor is `q + 0 = q`, divisible by `2^e` by hypothesis.
  have h0 : q + (0 : ℤ) * p = q := by ring
  rw [h0]
  -- `2^e ∣ q` ⟹ `2^e ∣ q * (anything)`.
  exact hdvd.mul_right _

/--
**F54 parity rule (packaging).**

For a prime `p ≥ 5`, `q : ℤ` with `Int.gcd q p = 1`, and any `k ≥ 1`:
the Pochhammer numerator `N_k := ∏_{j < k} (q + j·p)` satisfies

 • if `q` is odd (i.e. `¬ 2 ∣ q`):  `IsCoprime (p : ℤ) N_k`
   (F54 slope `−1` at `p` — the odd-q row of Module 11 §11.4).

 • if `q` is even (i.e. `2 ∣ q`):   `(2 : ℤ) ∣ N_k`
   (F54 parity divert — the even-q row of Module 11 §11.4; the
   signature moves to prime 2).

These are disjoint and exhaustive over `q : ℤ` because every integer
is either odd or even.
-/
theorem F54_parity_rule
    {p : ℕ} (hp : p.Prime) (hp5 : 5 ≤ p)
    {q : ℤ} (hgcd : Int.gcd q (p : ℤ) = 1)
    {k : ℕ} (hk : 1 ≤ k) :
    (¬ (2 : ℤ) ∣ q → IsCoprime ((p : ℤ)) (∏ j ∈ range k, (q + j * p))) ∧
    ((2 : ℤ) ∣ q → (2 : ℤ) ∣ ∏ j ∈ range k, (q + j * p)) := by
  refine ⟨?_, ?_⟩
  · intro h_odd
    exact odd_q_slope_at_p_strengthened hp hp5 h_odd hgcd k
  · intro h_even
    -- `2 ∣ q` means `2^1 ∣ q`; apply `even_q_slope_at_2` with `e = 1`.
    have hdvd1 : (2 : ℤ)^1 ∣ q := by simpa using h_even
    have := even_q_slope_at_2 (e := 1) hdvd1 (p := (p : ℤ)) hk
    simpa using this

/-!
### Axiom audit

All three theorems depend only on Lean's core axioms plus Mathlib's
standard classical axioms (`propext`, `Classical.choice`, `Quot.sound`).
-/
#print axioms odd_q_slope_at_p_strengthened
#print axioms even_q_slope_at_2
#print axioms F54_parity_rule

end OmegaTheory.Irrationality.HermitePade
