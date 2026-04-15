/-
  OmegaTheory.Irrationality.HermitePade.F26_MahlerEquation_convergent

  F26 — Mahler functional equation for the Frobenius product — **convergent
  infinite-product form**.

  Informal statement
  ------------------
  Let `q : ℕ` with `q ≥ 2` and `z : ℂ` with `|z| < 1`.  Define the Frobenius
  product

      Φ_q(z)  =  ∏_{k ≥ 0} (1 - z^(q^k))
             =  (1 - z) · (1 - z^q) · (1 - z^(q^2)) · …

  In this file we prove:

  1. **Absolute convergence (`Multipliable`).**  The family
     `k ↦ 1 - z^(q^k)` is `Multipliable` on `ℕ`.  The argument is the
     standard one: `Complex.multipliable_one_add_of_summable` reduces the
     problem to summability of the sequence `k ↦ -z^(q^k)`, which is
     absolutely summable because `‖z‖^(q^k) ≤ ‖z‖^k` (for `‖z‖ < 1` and
     `q ≥ 2`, using `k < q^k`) and `k ↦ ‖z‖^k` is geometrically summable.

  2. **Mahler functional equation (`tprod` form).**
         Φ_q(z)  =  (1 - z) · Φ_q(z^q)
     i.e.
         ∏' k, (1 - z^(q^k))  =  (1 - z) · ∏' k, (1 - (z^q)^(q^k)).

     The proof uses `Multipliable.tprod_eq_zero_mul` (peel off `k = 0`)
     and the power-tower identity `(z^q)^(q^k) = z^(q^(k+1))` from the
     sibling file `F26_MahlerEquation`.

  Dependencies
  ------------
  • `OmegaTheory.Irrationality.HermitePade.F26_MahlerEquation` — finite-
    truncation identity and power-tower shift (`pow_qk_qshift`).
  • Mathlib v4.29:
      - `Complex.multipliable_one_add_of_summable`
      - `Multipliable.tprod_eq_zero_mul` (via `tprod_eq_zero_mul'`)
      - `summable_geometric_of_lt_one`
      - `Summable.of_nonneg_of_le`
      - `pow_le_pow_of_le_one`
      - `Nat.lt_pow_self`

  No `sorry`, no new axioms beyond Mathlib's standard classical axioms.
-/

import Mathlib.Analysis.SpecialFunctions.Log.Summable
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import OmegaTheory.Irrationality.HermitePade.F26_MahlerEquation

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset Complex

/-!
## Summability of the tail sequence `z^(q^k)` for `|z| < 1`, `q ≥ 2`.

We first show that `k ↦ ‖z^(q^k)‖` is summable on `ℕ` (hence the
complex-valued sequence itself is summable).  The bound is elementary:
`‖z^(q^k)‖ = ‖z‖^(q^k) ≤ ‖z‖^k` for `‖z‖ ≤ 1` and `k ≤ q^k`, and
`k ↦ ‖z‖^k` is summable by geometric series for `‖z‖ < 1`.
-/

/--
Elementary bound: for `0 ≤ r ≤ 1` and `q ≥ 2`, `r^(q^k) ≤ r^k` for all `k`.

This uses the fact that `k < q^k` when `q ≥ 2` (so `k ≤ q^k`), combined
with `pow_le_pow_of_le_one` which flips the direction of the inequality
when `0 ≤ r ≤ 1`.
-/
lemma pow_qk_le_pow_k
    {r : ℝ} (hr0 : 0 ≤ r) (hr1 : r ≤ 1) {q : ℕ} (hq : 2 ≤ q) (k : ℕ) :
    r ^ (q ^ k) ≤ r ^ k := by
  -- Step 1: `k ≤ q^k`.
  have hk_le_qk : k ≤ q ^ k := (Nat.lt_pow_self hq).le
  -- Step 2: apply `pow_le_pow_of_le_one` (for `r ≤ 1`, larger exponent = smaller value).
  exact pow_le_pow_of_le_one hr0 hr1 hk_le_qk

/--
For `z : ℂ` with `‖z‖ < 1` and `q : ℕ` with `q ≥ 2`, the non-negative
sequence `k ↦ ‖z‖^(q^k)` is summable.
-/
lemma summable_norm_pow_qk
    {z : ℂ} (hz : ‖z‖ < 1) {q : ℕ} (hq : 2 ≤ q) :
    Summable (fun k : ℕ => ‖z‖ ^ (q ^ k)) := by
  -- Compare to the geometric series `k ↦ ‖z‖^k`.
  refine Summable.of_nonneg_of_le
    (fun k => pow_nonneg (norm_nonneg z) _)
    (fun k => ?_)
    (summable_geometric_of_lt_one (norm_nonneg z) hz)
  -- Pointwise: `‖z‖^(q^k) ≤ ‖z‖^k` by `pow_qk_le_pow_k`.
  exact pow_qk_le_pow_k (norm_nonneg z) hz.le hq k

/--
For `z : ℂ` with `‖z‖ < 1` and `q : ℕ` with `q ≥ 2`, the complex
sequence `k ↦ -z^(q^k)` is absolutely summable (hence summable).
-/
lemma summable_neg_pow_qk
    {z : ℂ} (hz : ‖z‖ < 1) {q : ℕ} (hq : 2 ≤ q) :
    Summable (fun k : ℕ => -(z ^ (q ^ k))) := by
  -- Absolute convergence: bound by the summable norm-series.
  apply Summable.of_norm
  -- `‖ -(z^(q^k)) ‖ = ‖z‖^(q^k)`
  have hnorm : ∀ k : ℕ, ‖(-(z ^ (q ^ k)))‖ = ‖z‖ ^ (q ^ k) := by
    intro k
    rw [norm_neg, norm_pow]
  simpa [hnorm] using summable_norm_pow_qk hz hq

/-!
## `Multipliable` form of the Frobenius product.

Using `Complex.multipliable_one_add_of_summable` applied to the summable
sequence `k ↦ -z^(q^k)`, we obtain multipliability of
`k ↦ 1 - z^(q^k) = 1 + (-z^(q^k))`.
-/

/--
**Convergence of the Frobenius product.**

For `z : ℂ` with `‖z‖ < 1` and `q : ℕ` with `q ≥ 2`, the sequence
`k ↦ 1 - z^(q^k)` is `Multipliable` on `ℕ`.

This is the main analytic input for the Mahler functional equation on
the open unit disk.
-/
theorem F26_multipliable_frobenius
    {z : ℂ} (hz : ‖z‖ < 1) {q : ℕ} (hq : 2 ≤ q) :
    Multipliable (fun k : ℕ => (1 : ℂ) - z ^ (q ^ k)) := by
  -- Use `Multipliable.congr` to transport multipliability from the
  -- `1 + (-x)` form (which `Complex.multipliable_one_add_of_summable`
  -- gives us directly) to the `1 - x` form.
  have hkey : Multipliable (fun k : ℕ => (1 : ℂ) + (-(z ^ (q ^ k)))) :=
    Complex.multipliable_one_add_of_summable (summable_neg_pow_qk hz hq)
  refine hkey.congr (fun k => ?_)
  ring

/-!
## Mahler functional equation (convergent form).

Using `tprod_eq_zero_mul'` (peel off the `k = 0` factor) and the
power-tower identity `(z^q)^(q^k) = z^(q^(k+1))` from
`F26_MahlerEquation`, we obtain the Mahler equation for the infinite
product on `|z| < 1`.
-/

/--
**Multipliability of the tail.**  The shifted sequence
`k ↦ 1 - z^(q^(k+1))` is also `Multipliable`.

Proof: apply `F26_multipliable_frobenius` with the replaced variable
`z^q` and use the power-tower identity `(z^q)^(q^k) = z^(q^(k+1))`.
-/
theorem F26_multipliable_tail
    {z : ℂ} (hz : ‖z‖ < 1) {q : ℕ} (hq : 2 ≤ q) :
    Multipliable (fun k : ℕ => (1 : ℂ) - z ^ (q ^ (k + 1))) := by
  -- `‖z^q‖ = ‖z‖^q ≤ ‖z‖^1 < 1` (for q ≥ 1).
  have hzq : ‖z ^ q‖ < 1 := by
    rw [norm_pow]
    calc ‖z‖ ^ q
        ≤ ‖z‖ ^ 1 := by
          apply pow_le_pow_of_le_one (norm_nonneg _) hz.le
          linarith
      _ = ‖z‖ := pow_one _
      _ < 1 := hz
  -- Apply the base multipliability at `z^q`.
  have hbase : Multipliable (fun k : ℕ => (1 : ℂ) - (z ^ q) ^ (q ^ k)) :=
    F26_multipliable_frobenius hzq hq
  -- Rewrite `(z^q)^(q^k) = z^(q^(k+1))` pointwise.
  refine hbase.congr (fun k => ?_)
  rw [pow_qk_qshift]

/--
**F26 — Mahler functional equation (convergent form).**

For any `z : ℂ` with `‖z‖ < 1` and any integer `q ≥ 2`,

    ∏' k, (1 - z^(q^k))  =  (1 - z) · ∏' k, (1 - (z^q)^(q^k)).

Equivalently, `Φ_q(z) = (1 - z) · Φ_q(z^q)` on the open unit disk.

The proof works by peeling off the `k = 0` factor using
`tprod_eq_zero_mul'` (which only requires multipliability of the tail,
not of the full sequence) and then reindexing the tail via
`pow_qk_qshift`.
-/
theorem F26_mahler_convergent
    {z : ℂ} (hz : ‖z‖ < 1) {q : ℕ} (hq : 2 ≤ q) :
    (∏' k : ℕ, ((1 : ℂ) - z ^ (q ^ k)))
      = ((1 : ℂ) - z) * (∏' k : ℕ, ((1 : ℂ) - (z ^ q) ^ (q ^ k))) := by
  -- Tail multipliability: `fun k => 1 - z^(q^(k+1))` is multipliable.
  have h_tail : Multipliable (fun k : ℕ => (1 : ℂ) - z ^ (q ^ (k + 1))) :=
    F26_multipliable_tail hz hq
  -- `tprod_eq_zero_mul'` : only needs the *tail* to be multipliable.
  have h0 := tprod_eq_zero_mul' (f := fun k : ℕ => (1 : ℂ) - z ^ (q ^ k)) h_tail
  -- `h0 : ∏' b, (1 - z^(q^b)) = (1 - z^(q^0)) * ∏' b, (1 - z^(q^(b+1)))`.
  -- (After beta-reducing the lambda body at `0` and at `b+1`.)
  -- Simplify head `z^(q^0) = z^1 = z`.
  simp only [pow_zero, pow_one] at h0
  -- Reindex the tail: 1 - z^(q^(k+1)) = 1 - (z^q)^(q^k).
  have htail : (∏' k : ℕ, ((1 : ℂ) - z ^ (q ^ (k + 1))))
              = ∏' k : ℕ, ((1 : ℂ) - (z ^ q) ^ (q ^ k)) :=
    tprod_congr (fun k => by rw [pow_qk_qshift])
  rw [htail] at h0
  exact h0

/-!
### Axiom audit

All theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms (`propext`, `Classical.choice`, `Quot.sound`) — no
`sorry`, no `axiom` beyond Mathlib.
-/
#print axioms pow_qk_le_pow_k
#print axioms summable_norm_pow_qk
#print axioms summable_neg_pow_qk
#print axioms F26_multipliable_frobenius
#print axioms F26_multipliable_tail
#print axioms F26_mahler_convergent

end OmegaTheory.Irrationality.HermitePade
