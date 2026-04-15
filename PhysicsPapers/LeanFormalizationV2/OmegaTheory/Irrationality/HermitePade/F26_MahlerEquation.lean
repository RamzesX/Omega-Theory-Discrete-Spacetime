/-
  OmegaTheory.Irrationality.HermitePade.F26_MahlerEquation

  F26 — Mahler functional equation for the Frobenius product (Attack 12).

  Informal statement
  ------------------
  Let `q ≥ 2` be an integer and consider the formal Frobenius product

      Φ_q(z)  =  ∏_{k ≥ 0} (1 - z^(q^k))
             =  (1 - z) · (1 - z^q) · (1 - z^(q^2)) · (1 - z^(q^3)) · …

  A direct index shift `k ↦ k - 1` in the tail gives the **Mahler
  functional equation**

      Φ_q(z)  =  (1 - z) · Φ_q(z^q)          (|z| < 1).

  In the π K₂-opacity diary (Attack 12 / Module 26) this is the structural
  identity that drives the `q`-Mahler part of the irrationality argument:
  it converts a conjectural `q`-transcendence over ℚ(z) into an infinite
  tower of algebraic obstructions at `z = 1/q^n`.

  Scope of this file
  ------------------
  Per task description, we prove the **finite-truncation** core of the
  Mahler equation, which captures all the structural content without
  needing convergence / `Multipliable` infrastructure.  Specifically, for
  any commutative (semi)ring `R`, any `q : ℕ` with `q ≥ 1`, any `z : R`,
  and any `N : ℕ`, we show the polynomial identity

      ∏_{k ∈ range (N+1)} (1 - z^(q^k))
        =  (1 - z) · ∏_{k ∈ range N} (1 - (z^q)^(q^k)).

  This is a pure `Finset.prod` index-shift identity — no analytic input is
  needed.  The full tprod form (under `Multipliable` for |z| < 1) is an
  immediate corollary once convergence is established, and is orthogonal
  to the algebraic core.

  Main theorems
  -------------
  • `frobenius_prod_split` — split off the `k = 0` factor:
      ∏_{k ∈ range (N+1)} (1 - z^(q^k))
        = (1 - z) · ∏_{k ∈ range N} (1 - z^(q^(k+1))).

  • `pow_qk_qshift` — algebraic identity `(z^q)^(q^k) = z^(q^(k+1))`.

  • `F26_mahler_finite` — the Mahler functional equation at finite
    truncation:
      ∏_{k ∈ range (N+1)} (1 - z^(q^k))
        = (1 - z) · ∏_{k ∈ range N} (1 - (z^q)^(q^k)).

  Dependencies: Mathlib v4.29 (`Finset.prod_range_succ'`, `pow_mul`,
  `pow_succ`).  No sorries, no axioms beyond Mathlib.
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Ring.Basic
import Mathlib.Tactic.Ring

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Split-off lemma.**  Peel off the `k = 0` factor from the finite
Frobenius-type product.  Over any commutative monoid with `1`,

    `∏_{k ∈ range (N+1)} (1 - z^(q^k))
        = (1 - z) · ∏_{k ∈ range N} (1 - z^(q^(k+1)))`.

At `k = 0` the factor is `1 - z^(q^0) = 1 - z^1 = 1 - z`, which is why
the identity collapses to a clean product with a `(1 - z)` prefactor.

Proof.  `Finset.prod_range_succ'` shifts the index by `+1` and peels off
the `k = 0` term.  The `k = 0` factor then simplifies via `pow_zero` and
`pow_one`.
-/
theorem frobenius_prod_split
    {R : Type*} [CommRing R] (z : R) (q N : ℕ) :
    ∏ k ∈ range (N + 1), (1 - z ^ (q ^ k))
      = (1 - z) * ∏ k ∈ range N, (1 - z ^ (q ^ (k + 1))) := by
  -- Apply the index-shift / split identity for `range (N+1)`.
  rw [Finset.prod_range_succ' (fun k => (1 - z ^ (q ^ k))) N]
  -- Now the goal carries a `1 - z ^ (q ^ 0)` at the end; simplify to `1 - z`.
  simp [pow_zero, pow_one, mul_comm]

/--
**Power-tower shift identity.**

For any commutative monoid `R`, `z : R`, and `q k : ℕ`, we have

    `(z^q)^(q^k)  =  z^(q^(k+1))`.

This is just `pow_mul` + the fact that `q * q^k = q^(k+1)` (which is
`pow_succ` in the multiplicative-nat side).
-/
theorem pow_qk_qshift
    {R : Type*} [CommMonoid R] (z : R) (q k : ℕ) :
    (z ^ q) ^ (q ^ k) = z ^ (q ^ (k + 1)) := by
  -- `(z^q)^(q^k) = z^(q * q^k) = z^(q^(k+1))`.
  rw [← pow_mul]
  congr 1
  -- `q * q^k = q^(k+1)` — `pow_succ` gives `q^(k+1) = q^k * q`; rearrange.
  rw [pow_succ]
  ring

/--
**F26 — Mahler functional equation (finite-truncation form).**

For any commutative ring `R`, any `z : R`, any `q N : ℕ`, the following
polynomial identity holds:

    `∏_{k ∈ range (N+1)} (1 - z^(q^k))
        = (1 - z) · ∏_{k ∈ range N} (1 - (z^q)^(q^k))`.

This is the finite-truncation analogue of the Mahler functional equation

    `Φ_q(z) = (1 - z) · Φ_q(z^q)`,

where `Φ_q(z) = ∏_{k ≥ 0} (1 - z^(q^k))`.  Taking the limit `N → ∞`
under the convergence hypothesis `|z| < 1` (which is available once
`Multipliable (1 - z^(q^k))` is in scope) yields the full functional
equation on the open unit disk.

Proof.  Combine `frobenius_prod_split` with `pow_qk_qshift` applied
under the product.
-/
theorem F26_mahler_finite
    {R : Type*} [CommRing R] (z : R) (q N : ℕ) :
    ∏ k ∈ range (N + 1), (1 - z ^ (q ^ k))
      = (1 - z) * ∏ k ∈ range N, (1 - (z ^ q) ^ (q ^ k)) := by
  -- Split off the k = 0 factor.
  rw [frobenius_prod_split z q N]
  -- Reindex the RHS product via the tower identity.
  congr 1
  apply Finset.prod_congr rfl
  intro k _hk
  rw [pow_qk_qshift z q k]

/-!
### Axiom audit

Both main theorems depend only on Lean's core axioms plus Mathlib's
standard classical axioms (`propext`, `Classical.choice`, `Quot.sound`) —
no `sorry`, no `axiom` beyond Mathlib.
-/
#print axioms frobenius_prod_split
#print axioms pow_qk_qshift
#print axioms F26_mahler_finite

end OmegaTheory.Irrationality.HermitePade
