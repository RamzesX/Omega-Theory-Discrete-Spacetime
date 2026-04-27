/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeMulAdd

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 128.
  totalDegree of product / sum.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's totalDegree composition lemmas:

  1. **`T5_totalDegree_mul`** : `(p * q).totalDegree ≤ p.td + q.td`.
  2. **`T5_totalDegree_add`** : `(p + q).totalDegree ≤ max p.td q.td`.
  3. **`T5_totalDegree_pow`** (derived) : `(p^n).td ≤ n * p.td`.

  Found via `mcp__omega-orchestrator__omega_hammer_premise` on
  `totalDegree (p * q) ≤ p + q`.

  Used in T-5 polynomial-index calculus where we track degree growth
  through algebraic operations on the auxiliary polynomial.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeMulAdd

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## totalDegree of product / sum -/

/-- **Wave T5 session 128 — totalDegree of product is bounded by sum**. -/
theorem T5_totalDegree_mul (p q : MvPolynomial σ R) :
    (p * q).totalDegree ≤ p.totalDegree + q.totalDegree :=
  MvPolynomial.totalDegree_mul p q

/-- **Wave T5 session 128 — totalDegree of sum is bounded by max**. -/
theorem T5_totalDegree_add (p q : MvPolynomial σ R) :
    (p + q).totalDegree ≤ max p.totalDegree q.totalDegree :=
  MvPolynomial.totalDegree_add p q

/-- **Wave T5 session 128 — totalDegree of power is at most n × degree**.

    Derived from `totalDegree_mul` by induction. -/
theorem T5_totalDegree_pow (p : MvPolynomial σ R) (n : ℕ) :
    (p ^ n).totalDegree ≤ n * p.totalDegree := by
  induction n with
  | zero =>
    simp [pow_zero, MvPolynomial.totalDegree_C]
  | succ m ih =>
    rw [pow_succ, Nat.succ_mul]
    calc (p ^ m * p).totalDegree
        ≤ (p ^ m).totalDegree + p.totalDegree := T5_totalDegree_mul _ _
      _ ≤ m * p.totalDegree + p.totalDegree := by omega

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 128 — totalDegree of mul / add / pow**.

    Three composition rules:
    1. `(p * q).td ≤ p.td + q.td`.
    2. `(p + q).td ≤ max p.td q.td`.
    3. `(p^n).td ≤ n * p.td`.

    Sub-lemma 17/N in T-5 Phase 3.  Lean-core only.

    Found via `mcp__omega-orchestrator__omega_hammer_premise`.

    Used in Roth's polynomial-index calculus where we track degree
    growth through algebraic operations. -/
theorem session_128_total_degree_mul_add_pow_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Mul
    (∀ (p q : MvPolynomial σ R),
        (p * q).totalDegree ≤ p.totalDegree + q.totalDegree)
    -- (2) Add
    ∧ (∀ (p q : MvPolynomial σ R),
        (p + q).totalDegree ≤ max p.totalDegree q.totalDegree)
    -- (3) Pow
    ∧ (∀ (p : MvPolynomial σ R) (n : ℕ),
        (p ^ n).totalDegree ≤ n * p.totalDegree) :=
  ⟨T5_totalDegree_mul, T5_totalDegree_add, T5_totalDegree_pow⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeMulAdd
