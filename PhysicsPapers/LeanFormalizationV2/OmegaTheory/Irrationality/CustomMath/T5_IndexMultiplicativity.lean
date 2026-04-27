/-
  OmegaTheory.Irrationality.CustomMath.T5_IndexMultiplicativity

  T-5 (Roth's theorem axiom retirement) — sub-lemma 6/10 session 74.
  Multiplicativity of polynomial index over products.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  **`Polynomial.indexAtPoint_mul`**: for p, q ≠ 0 in R[X] (R commutative
  integral domain):

      `indexAtPoint (p * q) a = indexAtPoint p a + indexAtPoint q a`

  Re-export of Mathlib's `Polynomial.rootMultiplicity_mul` in the
  T-5-attack vocabulary.

  This is the foundation for index calculus on polynomial products,
  used in Roth's auxiliary polynomial construction.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_IndexMultiplicativity

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex

variable {R : Type*} [CommRing R] [IsDomain R]

/-! ## Multiplicativity -/

/-- **Wave T4b session 74 — index multiplicativity over products**.

    For nonzero polynomials p, q ∈ R[X] (R integral domain), the index
    at any point a is additive over the product:

      `indexAtPoint (p * q) a = indexAtPoint p a + indexAtPoint q a`

    Re-exports Mathlib's `Polynomial.rootMultiplicity_mul`. -/
theorem Polynomial.indexAtPoint_mul {p q : R[X]} {a : R} (hpq : p * q ≠ 0) :
    Polynomial.indexAtPoint (p * q) a =
      Polynomial.indexAtPoint p a + Polynomial.indexAtPoint q a := by
  unfold Polynomial.indexAtPoint
  exact rootMultiplicity_mul hpq

/-! ## Power form -/

/-- **Wave T4b session 74 — index of polynomial power**.

    For nonzero p ∈ R[X] and n : ℕ:

      `indexAtPoint (p^n) a = n * indexAtPoint p a`

    Proven by induction on n + multiplicativity. -/
theorem Polynomial.indexAtPoint_pow {p : R[X]} {a : R} {n : ℕ} (hp : p ≠ 0) :
    Polynomial.indexAtPoint (p ^ n) a = n * Polynomial.indexAtPoint p a := by
  induction n with
  | zero =>
    simp [Polynomial.indexAtPoint]
  | succ k ih =>
    have hpn : p ^ k ≠ 0 := pow_ne_zero k hp
    have hpn1 : p ^ (k + 1) ≠ 0 := pow_ne_zero (k + 1) hp
    rw [pow_succ]
    rw [Polynomial.indexAtPoint_mul (mul_ne_zero hpn hp)]
    rw [ih]
    ring

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 74 — index multiplicativity**.

    Two key facts about polynomial index over products:
    1. Multiplicativity: `index(p * q) = index p + index q`
    2. Power: `index(p^n) = n * index p`

    Sub-lemma 6/10 in T-5 Phase 1. Lean-core only. -/
theorem session_74_index_multiplicativity_headline
    {R : Type*} [CommRing R] [IsDomain R] :
    -- (1) Multiplicativity
    (∀ p q : R[X], ∀ a : R, p * q ≠ 0 →
        Polynomial.indexAtPoint (p * q) a =
          Polynomial.indexAtPoint p a + Polynomial.indexAtPoint q a)
    -- (2) Power form
    ∧ (∀ p : R[X], ∀ a : R, ∀ n : ℕ, p ≠ 0 →
        Polynomial.indexAtPoint (p ^ n) a = n * Polynomial.indexAtPoint p a) := by
  refine ⟨?_, ?_⟩
  · intros p q a hpq
    exact Polynomial.indexAtPoint_mul hpq
  · intros p a n hp
    exact Polynomial.indexAtPoint_pow hp

end OmegaTheory.Irrationality.CustomMath.T5_IndexMultiplicativity
