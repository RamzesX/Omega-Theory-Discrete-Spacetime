/-
  OmegaTheory.Irrationality.CustomMath.T5_DegreeProduct

  T-5 (Roth's theorem axiom retirement) — sub-lemma 8/10 session 76.
  Degree of polynomial product over a domain.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of Mathlib's degree-of-product lemmas for use in T-5
  Phase 2 auxiliary polynomial construction:

  1. **`Polynomial.natDegree_mul'`** — for non-zero p, q over a domain:
     `natDegree (p * q) = natDegree p + natDegree q`.

  2. **`Polynomial.natDegree_pow'`** — for non-zero p over a domain:
     `natDegree (p^n) = n * natDegree p`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.RingDivision

namespace OmegaTheory.Irrationality.CustomMath.T5_DegreeProduct

open Polynomial

variable {R : Type*} [CommRing R] [IsDomain R]

/-! ## Degree of product -/

/-- **Wave T4b session 76 — natDegree of polynomial product**.

    For nonzero p, q ∈ R[X] (R integral domain):

      `(p * q).natDegree = p.natDegree + q.natDegree`. -/
theorem T5_natDegree_mul {p q : R[X]} (hp : p ≠ 0) (hq : q ≠ 0) :
    (p * q).natDegree = p.natDegree + q.natDegree :=
  Polynomial.natDegree_mul hp hq

/-- **Wave T4b session 76 — natDegree of polynomial power**.

    For nonzero p ∈ R[X] and n : ℕ:

      `(p^n).natDegree = n * p.natDegree`. -/
theorem T5_natDegree_pow {p : R[X]} (n : ℕ) :
    (p ^ n).natDegree = n * p.natDegree :=
  Polynomial.natDegree_pow p n

/-! ## Degree bounds -/

/-- **Wave T4b session 76 — natDegree of sum upper bound**.

    `(p + q).natDegree ≤ max (p.natDegree) (q.natDegree)`. -/
theorem T5_natDegree_add_le (p q : R[X]) :
    (p + q).natDegree ≤ max p.natDegree q.natDegree :=
  Polynomial.natDegree_add_le p q

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 76 — polynomial degree calculus**.

    Three foundational facts for T-5:
    1. natDegree(p · q) = natDegree p + natDegree q  (for nonzero in domain)
    2. natDegree(p^n) = n · natDegree p
    3. natDegree(p + q) ≤ max(natDegree p, natDegree q)

    Sub-lemma 8/10 in T-5 Phase 1. Lean-core only. -/
theorem session_76_polynomial_degree_calculus_headline
    {R : Type*} [CommRing R] [IsDomain R] :
    -- (1) Multiplicative
    (∀ p q : R[X], p ≠ 0 → q ≠ 0 →
        (p * q).natDegree = p.natDegree + q.natDegree)
    -- (2) Power
    ∧ (∀ p : R[X], ∀ n : ℕ,
        (p ^ n).natDegree = n * p.natDegree)
    -- (3) Sum bound
    ∧ (∀ p q : R[X],
        (p + q).natDegree ≤ max p.natDegree q.natDegree) := by
  refine ⟨?_, ?_, ?_⟩
  · intros p q hp hq; exact T5_natDegree_mul hp hq
  · intros p n; exact T5_natDegree_pow n
  · intros p q; exact T5_natDegree_add_le p q

end OmegaTheory.Irrationality.CustomMath.T5_DegreeProduct
