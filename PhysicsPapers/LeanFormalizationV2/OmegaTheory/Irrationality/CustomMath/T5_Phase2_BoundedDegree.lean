/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 7/15 session 85.
  Degree-bounded MvPolynomial subspace.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  `BoundedDegree n d R` predicate + closure properties.

  1. **`BoundedDegree n d R`** : `MvPolynomial (Fin n) R → Prop`,
     true iff totalDegree ≤ d.

  2. **`BoundedDegree.add`** : closure under sum.

  3. **`BoundedDegree.smul`** : closure under scalar.

  4. **`BoundedDegree.zero`** : zero is bounded by any d.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

open MvPolynomial

variable {R : Type*} [CommSemiring R]

/-! ## Bounded-degree predicate -/

/-- **Wave T4b session 85 — bounded-degree predicate**.

    `BoundedDegree n d R p` holds iff `p : MvPolynomial (Fin n) R` has
    total degree ≤ d. -/
def BoundedDegree (n d : ℕ) {R : Type*} [CommSemiring R]
    (p : MvPolynomial (Fin n) R) : Prop :=
  p.totalDegree ≤ d

/-! ## Closure properties -/

/-- Sum closure. -/
theorem BoundedDegree.add {n d : ℕ} {p q : MvPolynomial (Fin n) R}
    (hp : BoundedDegree n d p) (hq : BoundedDegree n d q) :
    BoundedDegree n d (p + q) := by
  unfold BoundedDegree at *
  calc (p + q).totalDegree ≤ max p.totalDegree q.totalDegree :=
          MvPolynomial.totalDegree_add p q
    _ ≤ d := max_le hp hq

/-- Scalar closure. -/
theorem BoundedDegree.smul {n d : ℕ} (c : R) {p : MvPolynomial (Fin n) R}
    (hp : BoundedDegree n d p) :
    BoundedDegree n d (c • p) := by
  unfold BoundedDegree at *
  calc (c • p).totalDegree ≤ p.totalDegree :=
          MvPolynomial.totalDegree_smul_le c p
    _ ≤ d := hp

/-- Zero is bounded by any d. -/
theorem BoundedDegree.zero (n d : ℕ) :
    BoundedDegree n d (0 : MvPolynomial (Fin n) R) := by
  unfold BoundedDegree
  simp [MvPolynomial.totalDegree_zero]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 85 — bounded-degree subspace**.

    Provides:
    1. `BoundedDegree n d` predicate.
    2. Sum closure.
    3. Scalar closure.
    4. Zero is bounded.

    Sub-lemma 7/15 in T-5 Phase 2. Lean-core only. -/
theorem session_85_bounded_degree_headline
    {R : Type*} [CommSemiring R] :
    -- (1) Sum closure
    (∀ n d : ℕ, ∀ p q : MvPolynomial (Fin n) R,
        BoundedDegree n d p → BoundedDegree n d q →
        BoundedDegree n d (p + q))
    -- (2) Scalar closure
    ∧ (∀ n d : ℕ, ∀ c : R, ∀ p : MvPolynomial (Fin n) R,
        BoundedDegree n d p → BoundedDegree n d (c • p))
    -- (3) Zero
    ∧ (∀ n d : ℕ, BoundedDegree n d (0 : MvPolynomial (Fin n) R)) := by
  refine ⟨?_, ?_, ?_⟩
  · intros n d p q hp hq; exact BoundedDegree.add hp hq
  · intros n d c p hp; exact BoundedDegree.smul c hp
  · exact BoundedDegree.zero

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree
