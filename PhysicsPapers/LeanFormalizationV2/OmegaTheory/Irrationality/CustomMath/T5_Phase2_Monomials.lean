/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_Monomials

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 3/15 session 81.
  MvPolynomial monomial total degrees.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of MvPolynomial total-degree facts for monomials/X i:

  1. **`T5_mvpoly_totalDegree_C`** : `C a` has totalDegree 0.
  2. **`T5_mvpoly_totalDegree_X`** : `X i` has totalDegree 1 (Nontrivial R).
  3. **`T5_mvpoly_totalDegree_X_pow`** : `(X i)^n` has totalDegree n.
  4. **`T5_mvpoly_totalDegree_pow_le`** : `p^n` has totalDegree ≤ n · totalDeg p.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_Monomials

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Total-degree of basic generators -/

/-- **Wave T4b session 81 — totalDegree of `C a`**.

    Constants have total degree 0. -/
theorem T5_mvpoly_totalDegree_C (a : R) :
    (C a : MvPolynomial σ R).totalDegree = 0 :=
  MvPolynomial.totalDegree_C a

/-- **Wave T4b session 81 — totalDegree of `X i`**.

    Variables have total degree 1 (when R is Nontrivial). -/
theorem T5_mvpoly_totalDegree_X [Nontrivial R] (i : σ) :
    (X i : MvPolynomial σ R).totalDegree = 1 :=
  MvPolynomial.totalDegree_X i

/-- **Wave T4b session 81 — totalDegree of `(X i)^n`**.

    Powers of variables have total degree = exponent. -/
theorem T5_mvpoly_totalDegree_X_pow [Nontrivial R] (i : σ) (n : ℕ) :
    ((X i : MvPolynomial σ R) ^ n).totalDegree = n :=
  MvPolynomial.totalDegree_X_pow i n

/-! ## Power bounds -/

/-- **Wave T4b session 81 — totalDegree of `p^n`**.

    `(p^n).totalDegree ≤ n · p.totalDegree` for any `p`. -/
theorem T5_mvpoly_totalDegree_pow_le (p : MvPolynomial σ R) (n : ℕ) :
    (p ^ n).totalDegree ≤ n * p.totalDegree :=
  MvPolynomial.totalDegree_pow p n

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 81 — MvPolynomial monomial degrees**.

    Four foundational facts:
    1. `C a` has totalDegree 0.
    2. `X i` has totalDegree 1 (over Nontrivial R).
    3. `(X i)^n` has totalDegree n.
    4. `p^n` has totalDegree ≤ n · totalDegree p.

    Sub-lemma 3/15 in T-5 Phase 2. Lean-core only. -/
theorem session_81_mvpoly_monomial_degrees_headline
    {σ R : Type*} [CommSemiring R] [Nontrivial R] :
    -- (1) C a has totalDegree 0
    (∀ a : R, (C a : MvPolynomial σ R).totalDegree = 0)
    -- (2) X i has totalDegree 1
    ∧ (∀ i : σ, (X i : MvPolynomial σ R).totalDegree = 1)
    -- (3) (X i)^n has totalDegree n
    ∧ (∀ i : σ, ∀ n : ℕ, ((X i : MvPolynomial σ R) ^ n).totalDegree = n)
    -- (4) p^n bound
    ∧ (∀ p : MvPolynomial σ R, ∀ n : ℕ,
        (p ^ n).totalDegree ≤ n * p.totalDegree) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact T5_mvpoly_totalDegree_C
  · exact T5_mvpoly_totalDegree_X
  · exact T5_mvpoly_totalDegree_X_pow
  · exact T5_mvpoly_totalDegree_pow_le

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_Monomials
