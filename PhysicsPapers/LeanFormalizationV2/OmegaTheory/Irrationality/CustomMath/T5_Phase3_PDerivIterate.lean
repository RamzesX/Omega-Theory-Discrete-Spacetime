/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterate

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 114.
  Iterated `pderiv` annihilates constants.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Foundational identities for high-order partial derivatives:

  1. **`T5_pderiv_iterate_C_succ`** : `(pderiv i)^(k+1) (C r) = 0`
     for any `k : ℕ`.
  2. **`T5_pderiv_iterate_zero`** : `(pderiv i)^k (0 : MvPolynomial σ R) = 0`.
  3. **`T5_pderiv_iterate_succ_zero`** : if `pderiv i p = 0`, then for any
     `k ≥ 1`, `(pderiv i)^k p = 0`.

  Used in Roth's polynomial-index calculus, where the index measures how
  many partial derivatives can be applied before the constant term
  vanishes.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterate

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Iterated pderiv kills constants -/

/-- **Wave T5 session 114 — pderiv kills 0**. -/
theorem T5_pderiv_zero (i : σ) :
    pderiv i (0 : MvPolynomial σ R) = 0 :=
  map_zero (pderiv i)

/-- **Wave T5 session 114 — `(pderiv i)^k (0) = 0`**.

    Iterated pderiv of zero polynomial is zero. -/
theorem T5_pderiv_iterate_zero (i : σ) (k : ℕ) :
    ((pderiv i)^[k] (0 : MvPolynomial σ R)) = 0 := by
  induction k with
  | zero => simp
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih]
    exact T5_pderiv_zero i

/-- **Wave T5 session 114 — `(pderiv i)^(k+1) (C r) = 0`**.

    The k+1-fold partial derivative of a constant vanishes. -/
theorem T5_pderiv_iterate_C_succ (i : σ) (r : R) (k : ℕ) :
    ((pderiv i)^[k + 1] (C r : MvPolynomial σ R)) = 0 := by
  rw [Function.iterate_succ_apply, pderiv_C]
  exact T5_pderiv_iterate_zero i k

/-- **Wave T5 session 114 — `(pderiv i)^(k+1) (1) = 0`**. -/
theorem T5_pderiv_iterate_one_succ (i : σ) (k : ℕ) :
    ((pderiv i)^[k + 1] (1 : MvPolynomial σ R)) = 0 := by
  rw [show (1 : MvPolynomial σ R) = C 1 from (C_1).symm]
  exact T5_pderiv_iterate_C_succ i 1 k

/-- **Wave T5 session 114 — once at zero, stays at zero**.

    If `pderiv i p = 0`, then `(pderiv i)^(k+1) p = 0` for all k. -/
theorem T5_pderiv_iterate_succ_zero (i : σ) {p : MvPolynomial σ R}
    (h : pderiv i p = 0) (k : ℕ) :
    ((pderiv i)^[k + 1] p) = 0 := by
  rw [Function.iterate_succ_apply, h]
  exact T5_pderiv_iterate_zero i k

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 114 — Iterated pderiv kills constants**.

    Four facts establishing how high-order partial derivatives kill
    low-degree polynomials:
    1. `(pderiv i)^k (0) = 0`.
    2. `(pderiv i)^(k+1) (C r) = 0`.
    3. `(pderiv i)^(k+1) (1) = 0`.
    4. Once `pderiv i p = 0`, all higher iterates are 0.

    Used in T-5 polynomial-index calculus: the index measures the
    minimal pderiv-iterate count before a polynomial vanishes at a
    point. Constants vanish at depth 1; X-i vanishes at depth 2; etc.

    Sub-lemma 5/N in T-5 Phase 3.  Lean-core only. -/
theorem session_114_pderiv_iterate_kills_constants_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) iterate of zero
    (∀ (i : σ) (k : ℕ),
        ((pderiv i)^[k] (0 : MvPolynomial σ R)) = 0)
    -- (2) iterate of C r at depth k+1
    ∧ (∀ (i : σ) (r : R) (k : ℕ),
        ((pderiv i)^[k + 1] (C r : MvPolynomial σ R)) = 0)
    -- (3) iterate of 1 at depth k+1
    ∧ (∀ (i : σ) (k : ℕ),
        ((pderiv i)^[k + 1] (1 : MvPolynomial σ R)) = 0)
    -- (4) propagation from zero
    ∧ (∀ (i : σ) (p : MvPolynomial σ R) (h : pderiv i p = 0) (k : ℕ),
        ((pderiv i)^[k + 1] p) = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact T5_pderiv_iterate_zero
  · exact T5_pderiv_iterate_C_succ
  · exact T5_pderiv_iterate_one_succ
  · intros i p h k; exact T5_pderiv_iterate_succ_zero i h k

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterate
