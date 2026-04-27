/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMul

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 18 session 96.
  BoundedDegree closure under products.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  1. **`BoundedDegree.mul_add`** : if `BoundedDegree d₁ p` and
     `BoundedDegree d₂ q`, then `BoundedDegree (d₁ + d₂) (p * q)`.

  2. **`BoundedDegree.pow`** : if `BoundedDegree d p`, then
     `BoundedDegree (n * d) (p^n)`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMul

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

variable {R : Type*} [CommSemiring R]

/-! ## Product closure with degree-sum -/

/-- **Wave T4b session 96 — BoundedDegree under product**.

    If `p` has BoundedDegree d₁ and `q` has BoundedDegree d₂, then
    `p * q` has BoundedDegree (d₁ + d₂).

    Proof: `(p*q).totalDegree ≤ p.totalDegree + q.totalDegree ≤ d₁ + d₂`. -/
theorem BoundedDegree.mul_add {n d₁ d₂ : ℕ} {p q : MvPolynomial (Fin n) R}
    (hp : BoundedDegree n d₁ p) (hq : BoundedDegree n d₂ q) :
    BoundedDegree n (d₁ + d₂) (p * q) := by
  unfold BoundedDegree at *
  calc (p * q).totalDegree ≤ p.totalDegree + q.totalDegree :=
          MvPolynomial.totalDegree_mul p q
    _ ≤ d₁ + d₂ := Nat.add_le_add hp hq

/-! ## Power closure -/

/-- **Wave T4b session 96 — BoundedDegree under power**.

    If `p` has BoundedDegree d, then `p^k` has BoundedDegree (k * d).

    Proof: `(p^k).totalDegree ≤ k * p.totalDegree ≤ k * d`. -/
theorem BoundedDegree.pow {n d : ℕ} {p : MvPolynomial (Fin n) R}
    (hp : BoundedDegree n d p) (k : ℕ) :
    BoundedDegree n (k * d) (p ^ k) := by
  unfold BoundedDegree at *
  calc (p ^ k).totalDegree ≤ k * p.totalDegree :=
          MvPolynomial.totalDegree_pow p k
    _ ≤ k * d := Nat.mul_le_mul_left k hp

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 96 — BoundedDegree mul/pow closure**.

    Two foundational closures:
    1. Product: BoundedDegree d₁ p × BoundedDegree d₂ q → BoundedDegree (d₁+d₂) (p*q)
    2. Power: BoundedDegree d p → BoundedDegree (k*d) (p^k)

    Sub-lemma 18 in T-5 Phase 2 (extension). Lean-core only. -/
theorem session_96_bounded_degree_mul_headline
    {R : Type*} [CommSemiring R] :
    -- (1) Product
    (∀ n d₁ d₂ : ℕ, ∀ p q : MvPolynomial (Fin n) R,
        BoundedDegree n d₁ p → BoundedDegree n d₂ q →
        BoundedDegree n (d₁ + d₂) (p * q))
    -- (2) Power
    ∧ (∀ n d : ℕ, ∀ p : MvPolynomial (Fin n) R, ∀ k : ℕ,
        BoundedDegree n d p → BoundedDegree n (k * d) (p ^ k)) := by
  refine ⟨?_, ?_⟩
  · intros n d₁ d₂ p q hp hq; exact BoundedDegree.mul_add hp hq
  · intros n d p k hp; exact BoundedDegree.pow hp k

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMul
