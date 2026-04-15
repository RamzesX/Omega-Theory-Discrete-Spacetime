/-
  OmegaTheory.Irrationality.HermitePade.F27_E_Denominator

  Step (b) of analytic-attacker's (a)–(d) spec for Proof-Sketch
  Lemma 3.1 (E-denominator domination).

  Goal
  ----
  Compute the `3`-adic valuation of the E-partial-sum `u_N`, defined in
  `F27_TaylorPartialSum.lean`.  Specifically, we show

      padicValRat 3 (uN N)  =  padicValRat 3 (cK N · (1/3)^N)       (E.1)

  which gives the exact numerical formula

      padicValRat 3 (uN N)  =  - (N + padicValNat 3 N.factorial)    (E.2)
                            =  - (3 N − s_3(N)) / 2                 (E.3)

  via Legendre's formula (`F27_LegendreSlope.legendre_padicValNat_factorial`).

  Proof strategy
  --------------
  The `k`-th summand is `c_k · (1/3)^k = 1 / ((3k+1) · k! · 3^k)`.  At
  `p = 3`:
    * `3k + 1 ≡ 1 (mod 3)`, so `ord_3(3k + 1) = 0`.
    * `ord_3(k!) = (k - s_3(k)) / 2` by Legendre.
    * `ord_3(3^k) = k`.
  Hence `padicValRat 3 (c_k · z_0^k) = -(k + ord_3(k!))`.

  Strict monotonicity: for `0 ≤ k < N`, `padicValRat 3 (c_k z_0^k) >
  padicValRat 3 (c_N z_0^N)`.  The difference is `-((N - k) + (ord_3(N!)
  - ord_3(k!)))`, which is strictly negative because `ord_3(N!) ≥
  ord_3(k!)` and `N > k`.

  Given strict monotonicity and nonzero-ness of each summand, the
  Mathlib lemma `padicValRat.add_eq_of_lt` gives inductively

      padicValRat 3 (uN N)  =  padicValRat 3 (cK N · (1/3)^N).

  Scope
  -----
  • `padicValRat_three_k_plus_one_zero` — `ord_3(3k+1) = 0`.
  • `padicValRat_cK_mul_zk` — explicit formula for
     `padicValRat 3 (cK k · (1/3)^k)`.
  • `padicValRat_cK_mul_zk_strict_anti` — strict monotonicity across
     consecutive `k`.
  • `padicValRat_uN` — the main theorem: `padicValRat 3 (uN N) =
     padicValRat 3 (cK N · (1/3)^N)`.

  No sorries, no new axioms.

  Dependencies: `F27_TaylorPartialSum`, `F27_LegendreSlope`,
  Mathlib v4.29 (`padicValRat`, `padicValNat`).

  Byline: Norbert Marchewka, analytic-attacker (spec), formal-prover
  (Lean formalization).  2026-04-15.
-/

import OmegaTheory.Irrationality.HermitePade.F27_TaylorPartialSum
import OmegaTheory.Irrationality.HermitePade.F27_LegendreSlope
import Mathlib.NumberTheory.Padics.PadicVal.Basic

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/-- **`ord_3(3 k + 1) = 0`.** Because `3 k + 1 ≡ 1 (mod 3)`, the prime
`3` does not divide `3 k + 1`.  This is the F54 slope-`−1` content at
the prime `p = 3` (the Pochhammer numerator is coprime to `3`). -/
lemma padicValNat_three_k_plus_one_zero (k : ℕ) :
    padicValNat 3 (3 * k + 1) = 0 := by
  -- 3 ∤ 3 * k + 1 because 3 * k + 1 ≡ 1 (mod 3)
  rw [padicValNat.eq_zero_iff]
  right; right
  -- Show ¬ 3 ∣ 3 * k + 1
  intro hdvd
  omega

/-- Cast form: `padicValRat 3 (3 k + 1 : ℚ) = 0`. -/
lemma padicValRat_three_k_plus_one_zero (k : ℕ) :
    padicValRat 3 ((3 * k + 1 : ℕ) : ℚ) = 0 := by
  rw [padicValRat.of_nat, padicValNat_three_k_plus_one_zero]
  rfl

/-- **Key identity**: `padicValRat 3 (c_k · (1/3)^k) = -(k + v_3(k!))`. -/
lemma padicValRat_cK_mul_zk (k : ℕ) :
    padicValRat 3 (cK k * (1 / 3 : ℚ) ^ k)
      = -((k : ℤ) + padicValNat 3 k.factorial) := by
  -- cK k · (1/3)^k = 1 / ((3k+1) · k! · 3^k)
  rw [cK_mul_zk]
  have hA_ne : ((3 * k + 1 : ℕ) : ℚ) ≠ 0 := three_k_plus_one_ne_zero k
  have hB_ne : (k.factorial : ℚ) ≠ 0 := factorial_ne_zero k
  have hAB_ne : ((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) ≠ 0 :=
    three_k_plus_one_mul_factorial_ne_zero k
  have h3k_ne : (3 : ℚ) ^ k ≠ 0 := pow_ne_zero _ (by norm_num : (3 : ℚ) ≠ 0)
  have hdenom_ne : ((3 * k + 1 : ℕ) : ℚ) * (k.factorial : ℚ) * 3 ^ k ≠ 0 :=
    mul_ne_zero hAB_ne h3k_ne
  -- 1 / X = X⁻¹, and padicValRat of inv = -padicValRat
  rw [one_div, padicValRat.inv]
  -- padicValRat of product = sum of padicValRats
  rw [padicValRat.mul hAB_ne h3k_ne,
      padicValRat.mul hA_ne hB_ne,
      padicValRat_three_k_plus_one_zero,
      zero_add]
  -- Factorial part: padicValRat 3 (k.factorial : ℚ) = padicValNat 3 k.factorial
  have h_fact : padicValRat 3 ((k.factorial : ℕ) : ℚ) = padicValNat 3 k.factorial := by
    rw [padicValRat.of_nat]
  -- Power part: padicValRat 3 ((3 : ℚ)^k) = k
  have h_pow : padicValRat 3 ((3 : ℚ) ^ k) = k := by
    have h3_ne : (3 : ℚ) ≠ 0 := by norm_num
    rw [padicValRat.pow h3_ne]
    have h_val3 : padicValRat 3 (3 : ℚ) = 1 := by
      have hnat : padicValRat 3 ((3 : ℕ) : ℚ) = padicValNat 3 3 := padicValRat.of_nat
      have hself : padicValNat 3 3 = 1 := padicValNat.self (by norm_num : 1 < 3)
      simp [hself] at hnat
      exact hnat
    rw [h_val3, mul_one]
  -- Combine
  push_cast at h_fact ⊢
  rw [h_fact, h_pow]
  push_cast
  ring

/-- **Strict monotonicity**: `padicValRat 3 (c_k · z^k)` strictly decreases
in `k`.  Equivalently, each successive summand is `3`-adically "larger
in denominator" than all previous ones. -/
lemma padicValRat_cK_mul_zk_strict_anti {k : ℕ} :
    padicValRat 3 (cK (k + 1) * (1 / 3 : ℚ) ^ (k + 1))
      < padicValRat 3 (cK k * (1 / 3 : ℚ) ^ k) := by
  rw [padicValRat_cK_mul_zk, padicValRat_cK_mul_zk]
  -- (k+1)! = (k+1) · k!, so v_3((k+1)!) = v_3(k+1) + v_3(k!) ≥ v_3(k!)
  have hfact : padicValNat 3 k.factorial ≤ padicValNat 3 (k + 1).factorial := by
    rw [Nat.factorial_succ]
    have hk_ne : k.factorial ≠ 0 := k.factorial_ne_zero
    have hk1_ne : (k + 1 : ℕ) ≠ 0 := Nat.succ_ne_zero _
    rw [padicValNat.mul hk1_ne hk_ne]
    exact Nat.le_add_left _ _
  -- Coerce to ℤ
  have hfact_int : (padicValNat 3 k.factorial : ℤ)
                   ≤ (padicValNat 3 (k + 1).factorial : ℤ) := by
    exact_mod_cast hfact
  -- Goal: -((k+1 : ℤ) + v_3((k+1)!)) < -((k : ℤ) + v_3(k!))
  -- Equivalent to: (k : ℤ) + v_3(k!) < (k+1 : ℤ) + v_3((k+1)!)
  -- Since k < k + 1 and v_3(k!) ≤ v_3((k+1)!), sum strictly increases.
  have h_succ : ((k : ℤ) + 1) + (padicValNat 3 (k + 1).factorial : ℤ)
                  = (((k + 1 : ℕ) : ℤ)) + (padicValNat 3 (k + 1).factorial : ℤ) := by
    push_cast; ring
  linarith

/-!
### The main theorem: `padicValRat 3 (uN N) = padicValRat 3 (cK N · z^N)`

By induction on `N`.  The base case `N = 0` reduces to `uN 0 = cK 0`.

For the inductive step, `uN (N+1) = uN N + c_{N+1} · z^{N+1}`.  Each
summand of `uN N` has `padicValRat > padicValRat (c_{N+1} · z^{N+1})`
by strict monotonicity; hence `padicValRat (uN N) ≥ padicValRat (c_N ·
z^N) > padicValRat (c_{N+1} · z^{N+1})`.  Applying `add_eq_of_lt` with
the strict inequality swapped (so the smaller valuation is on the
right) gives the result.
-/

/-- Strict monotonicity lemma in the "k ≤ N" form, needed for the inductive step. -/
lemma padicValRat_cK_mul_zk_lt_of_le {k N : ℕ} (hk : k ≤ N) :
    padicValRat 3 (cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1))
      < padicValRat 3 (cK k * (1 / 3 : ℚ) ^ k) := by
  induction N, hk using Nat.le_induction with
  | base =>
    exact padicValRat_cK_mul_zk_strict_anti
  | succ N hkN ih =>
    exact lt_trans padicValRat_cK_mul_zk_strict_anti ih

/-- **Main theorem (E.1) for `uN`**: the `3`-adic valuation of the E-partial
sum equals the valuation of the largest-index summand. -/
theorem padicValRat_uN (N : ℕ) :
    padicValRat 3 (uN N) = padicValRat 3 (cK N * (1 / 3 : ℚ) ^ N) := by
  induction N with
  | zero =>
    -- uN 0 = cK 0 · (1/3)^0 (single summand)
    simp [uN, Finset.sum_range_one]
  | succ N ih =>
    -- uN (N+1) = uN N + cK (N+1) · (1/3)^(N+1)
    have h_unfold : uN (N + 1) = uN N + cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1) := by
      unfold uN
      rw [Finset.sum_range_succ]
    rw [h_unfold]
    -- Apply add_eq_of_lt with the smaller-valuation term second:
    -- padicValRat 3 (uN N + c_{N+1} · z^{N+1}) = padicValRat 3 (c_{N+1} · z^{N+1})
    -- because padicValRat (c_{N+1} · z^{N+1}) < padicValRat (uN N) = padicValRat (c_N · z^N).
    -- Step 1: uN N ≠ 0. We show this via `padicValRat 3 (uN N) = ... ≠ ⊤`-style arg;
    -- cleaner: uN N = cK 0 + ... nonzero summands; we instead show nonzero by the
    -- ih trick: padicValRat 3 (uN N) = padicValRat 3 (cK N · z^N), and the RHS is
    -- the valuation of a nonzero rational, hence well-defined.
    have h_cNz1_ne : cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1) ≠ 0 :=
      cK_mul_zk_ne_zero (N + 1)
    have h_uN_ne : uN N ≠ 0 := by
      -- If uN N = 0, then padicValRat 3 0 = 0 by convention, but
      -- `padicValRat 3 (cK N · z^N)` is negative (formula is -(N + v_3(N!))),
      -- so equality would force a contradiction for large enough N.  For N = 0,
      -- the sum has exactly one nonzero term.
      intro h0
      have hih := ih
      rw [h0, padicValRat.zero] at hih
      -- hih : 0 = padicValRat 3 (cK N · (1/3)^N)
      -- RHS = -((N : ℤ) + v_3(N!)) ≤ -(N : ℤ)
      rw [padicValRat_cK_mul_zk] at hih
      -- hih : 0 = -((N : ℤ) + padicValNat 3 N.factorial)
      -- This implies N + v_3(N!) = 0 as integers; in particular N = 0 and v_3(0!) = 0.
      -- But then uN 0 = cK 0 * (1/3)^0 = cK 0 = 1/(1 * 0!) = 1 ≠ 0, contradicting h0.
      have hN_zero : N = 0 := by
        have : (N : ℤ) + padicValNat 3 N.factorial = 0 := by omega
        have hpos_fact : (0 : ℤ) ≤ padicValNat 3 N.factorial := Int.natCast_nonneg _
        have hNZ : (N : ℤ) ≤ 0 := by omega
        have : N ≤ 0 := by exact_mod_cast hNZ
        omega
      subst hN_zero
      -- h0 : uN 0 = 0, but uN 0 = cK 0 · 1 = cK 0 ≠ 0
      have : uN 0 = cK 0 := by
        simp [uN, Finset.sum_range_one]
      rw [this] at h0
      exact cK_ne_zero 0 h0
    -- Sum is nonzero: if uN N + cN₊₁·z^{N+1} = 0 then uN N = -cN₊₁·z^{N+1},
    -- so padicValRat 3 (uN N) = padicValRat 3 (cN₊₁·z^{N+1}) (with negation),
    -- contradicting strict inequality.
    have h_sum_ne : uN N + cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1) ≠ 0 := by
      intro hsum
      have h_eq_neg : uN N = -(cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1)) := by linarith
      have hval_eq : padicValRat 3 (uN N)
                     = padicValRat 3 (-(cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1))) := by
        rw [h_eq_neg]
      rw [padicValRat.neg] at hval_eq
      rw [ih] at hval_eq
      -- hval_eq : padicValRat 3 (cK N · z^N) = padicValRat 3 (cK (N+1) · z^(N+1))
      -- But strict inequality says they differ.
      have hlt := padicValRat_cK_mul_zk_strict_anti (k := N)
      omega
    -- Now apply add_eq_of_lt with q = cK (N+1) · z^{N+1} (smaller val), r = uN N.
    have h_val_lt : padicValRat 3 (cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1))
                     < padicValRat 3 (uN N) := by
      rw [ih]
      exact padicValRat_cK_mul_zk_strict_anti
    -- Rewrite goal to have the smaller-val term first
    have h_sum_ne' : cK (N + 1) * (1 / 3 : ℚ) ^ (N + 1) + uN N ≠ 0 := by
      rw [add_comm]; exact h_sum_ne
    rw [add_comm]
    exact padicValRat.add_eq_of_lt h_sum_ne' h_cNz1_ne h_uN_ne h_val_lt

/-- **Corollary (E.3) — exact Legendre-form closed expression.**
Using F27_LegendreSlope's Legendre formula,

    padicValRat 3 (uN N) = -(N + (N − s_3(N)) / 2) = -(3 N − s_3(N))/2.

This is the formula cited in the proof sketch §1.2 as
"`ord_3(denom u_N) = (3 N − s_3(N))/2`".  Formalising the right-hand
side in terms of `Nat.digits` would add several lines without
additional mathematical content; we expose the intermediate form
`-(N + padicValNat 3 N.factorial)` which is directly consumed by
`F27_E_Dominates_G.lean`.
-/
theorem padicValRat_uN_explicit (N : ℕ) :
    padicValRat 3 (uN N) = -((N : ℤ) + padicValNat 3 N.factorial) := by
  rw [padicValRat_uN, padicValRat_cK_mul_zk]

/-!
### Axiom audit

All theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms.  No transcendence input.
-/

#print axioms padicValNat_three_k_plus_one_zero
#print axioms padicValRat_cK_mul_zk
#print axioms padicValRat_cK_mul_zk_strict_anti
#print axioms padicValRat_uN
#print axioms padicValRat_uN_explicit

end OmegaTheory.Irrationality.HermitePade
