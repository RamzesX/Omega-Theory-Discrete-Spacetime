/-
  OmegaTheory.Irrationality.HermitePade.F54_SlicePrime

  F54 — Slice-prime correspondence (Module 11 §11.4).

  Informal statement
  ------------------
  Let `a = q / p` be a rational with `gcd(q, p) = 1`, and consider the
  rising Pochhammer symbol

      (a)_k  =  a · (a + 1) · (a + 2) · … · (a + k - 1).

  Rewriting each factor `a + j = (q + j·p) / p` gives

      (q/p)_k  =  (∏_{j=0}^{k-1} (q + j·p))  /  p^k.

  Claim (slope −1 in `k`):  the integer numerator
  `P_k(q, p) := ∏_{j=0}^{k-1} (q + j·p)` is **coprime to `p`** whenever
  `p` is prime and `p ∤ q`.  Consequently, the `p`-adic valuation of
  `(q/p)_k`, written in lowest terms, is exactly `-k`.

  In the π-irrationality diary, this "slope −1" behaviour is what forces
  each additional `k`-step in a slice argument to cost exactly one extra
  factor of `p`, giving the tight denominator growth that the
  Hermite–Padé attack on K₂-opacity needs (see Attack 19, §11.4 F54).

  Scope of this file
  ------------------
  Per task description, we provide the **clean algebraic lemma** that
  is the "slope −1" core of F54:

  • `pochhammer_num_coprime` — for a prime `p` and integer `q` with
    `(p : ℤ) ∤ q`, the integer Pochhammer numerator
    `∏_{j=0}^{k-1} (q + j·p)` is not divisible by `p`.

  • `F54_slope_minus_one` — corollary packaging the same fact in the
    form directly matching the §11.4 statement: the combinatorial
    numerator is coprime to `p`, so the `p`-adic denominator contribution
    is exactly `p^k` (slope `−1`).

  The Legendre / `padicValNat`-based formulation is orthogonal; we use
  a direct `Nat.Prime` / `∣` argument because it builds over any Mathlib
  ≥ v4.13 without depending on the `Padics` hierarchy.

  Dependencies: Mathlib v4.29 (`Nat.Prime`, `Int.Prime`, `Finset.prod`,
  `Prime.dvd_finset_prod_iff`).  No sorries, no axioms beyond Mathlib.
-/

import Mathlib.Data.Int.GCD
import Mathlib.RingTheory.Int.Basic
import Mathlib.Data.Nat.Prime.Int
import Mathlib.Algebra.BigOperators.Associated

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Helper.**  For `p : ℕ` prime and `q : ℤ` not divisible by `p`, each
factor `q + j · p` of the Pochhammer numerator is itself not divisible
by `p`.

Reason: `q + j · p ≡ q (mod p)`, and by hypothesis `q ≢ 0 (mod p)`.
-/
private lemma factor_not_dvd
    {p : ℕ} {q : ℤ} (hq : ¬ (p : ℤ) ∣ q) (j : ℕ) :
    ¬ (p : ℤ) ∣ (q + j * p) := by
  intro hdvd
  apply hq
  -- From (p : ℤ) ∣ (q + j*p) and (p : ℤ) ∣ (j*p), deduce (p : ℤ) ∣ q.
  have hjp : (p : ℤ) ∣ ((j : ℤ) * p) := ⟨j, by ring⟩
  have : (p : ℤ) ∣ ((q + j * p) - j * p) := dvd_sub hdvd hjp
  simpa using this

/--
**F54 core — Pochhammer numerator is coprime to the prime `p`.**

Let `p : ℕ` be prime and `q : ℤ` with `(p : ℤ) ∤ q`.  Then for every
`k : ℕ`, the integer product

    `∏_{j ∈ range k} (q + j · p)`

is **not divisible by `p`**.

Proof.  A prime `p` divides a finite product iff it divides one of the
factors.  By `factor_not_dvd`, no factor is divisible by `p`; hence the
product is not either.
-/
theorem pochhammer_num_coprime
    {p : ℕ} (hp : p.Prime) {q : ℤ} (hq : ¬ (p : ℤ) ∣ q) (k : ℕ) :
    ¬ (p : ℤ) ∣ ∏ j ∈ range k, (q + j * p) := by
  -- Primality of `p` in `ℤ`.
  have hp_int : _root_.Prime (p : ℤ) := Nat.prime_iff_prime_int.mp hp
  -- A prime divides a finite product iff it divides some factor.
  intro hdvd
  rcases (hp_int.dvd_finset_prod_iff (g := fun j : ℕ => q + j * p)).mp hdvd
    with ⟨j, _hjmem, hjdvd⟩
  exact factor_not_dvd hq j hjdvd

/--
**F54 — slope `−1` form (Module 11 §11.4).**

Packaging `pochhammer_num_coprime` as a "slope `−1`" statement.

Concretely: for a prime denominator `p`, the Pochhammer numerator
attached to `q/p` with `p ∤ q` is coprime to `p` for every `k`.  In
`p`-adic-valuation language this says

    `v_p( ∏_{j<k} (q + j·p) )  =  0`,

so when the full Pochhammer `(q/p)_k = (numerator) / p^k` is considered,
its `p`-adic valuation is exactly `−k`.  That is the **slope `−1` in `k`**
asserted by F54.
-/
theorem F54_slope_minus_one
    {p : ℕ} (hp : p.Prime) {q : ℤ} (hq : ¬ (p : ℤ) ∣ q) :
    ∀ k : ℕ, IsCoprime ((p : ℤ)) (∏ j ∈ range k, (q + j * p)) := by
  intro k
  -- A prime is coprime to an element iff it does not divide it.
  have hp_int : _root_.Prime (p : ℤ) := Nat.prime_iff_prime_int.mp hp
  have hndvd : ¬ (p : ℤ) ∣ ∏ j ∈ range k, (q + j * p) :=
    pochhammer_num_coprime hp hq k
  exact (Prime.coprime_iff_not_dvd hp_int).mpr hndvd

/-!
### Axiom audit

Both theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms (`propext`, `Classical.choice`, `Quot.sound`) — no
invocation of `Real.pi_transcendental` (this file is purely number-
theoretic).
-/
-- #print axioms pochhammer_num_coprime
-- #print axioms F54_slope_minus_one

end OmegaTheory.Irrationality.HermitePade
