/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalBasics

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 120.
  `MvPolynomial.aeval` foundational identities.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's core `MvPolynomial.aeval` identities:

  1. **`T5_aeval_X`** : `aeval f (X s) = f s`.
  2. **`T5_aeval_C`** : `aeval f (C r) = algebraMap R S r`.
  3. **`T5_aeval_X_left`** : `aeval X = AlgHom.id`.
  4. **`T5_aeval_X_left_apply`** : `aeval X p = p` (substituting X
     with X is identity).
  5. **`T5_aeval_monomial`** : evaluation of a monomial.

  These bootstrap the substitution machinery for Roth's polynomial
  index calculus, where we need to track aeval over composed renames
  + monomial substitutions.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Eval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalBasics

open MvPolynomial

variable {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]

/-! ## aeval on basic generators -/

/-- **Wave T5 session 120 — aeval of `X s`**.

    `aeval f (X s) = f s`. -/
theorem T5_aeval_X (f : σ → S) (s : σ) :
    (aeval f : MvPolynomial σ R →ₐ[R] S) (X s) = f s :=
  MvPolynomial.aeval_X f s

/-- **Wave T5 session 120 — aeval of `C r`**.

    `aeval f (C r) = algebraMap R S r`. -/
theorem T5_aeval_C (f : σ → S) (r : R) :
    (aeval f : MvPolynomial σ R →ₐ[R] S) (C r) = algebraMap R S r :=
  MvPolynomial.aeval_C f r

/-- **Wave T5 session 120 — aeval at X is identity (functional)**.

    `aeval X = AlgHom.id`. -/
theorem T5_aeval_X_left :
    (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) =
      AlgHom.id R (MvPolynomial σ R) :=
  MvPolynomial.aeval_X_left

/-- **Wave T5 session 120 — aeval at X is identity (pointwise)**.

    `aeval X p = p`. -/
theorem T5_aeval_X_left_apply (p : MvPolynomial σ R) :
    (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) p = p :=
  MvPolynomial.aeval_X_left_apply p

/-- **Wave T5 session 120 — aeval of a monomial**.

    `aeval f (monomial d r) = algebraMap R S r * ∏ i, (f i)^(d i)`. -/
theorem T5_aeval_monomial (f : σ → S) (d : σ →₀ ℕ) (r : R) :
    (aeval f : MvPolynomial σ R →ₐ[R] S) (monomial d r) =
      algebraMap R S r * d.prod fun i k => f i ^ k :=
  MvPolynomial.aeval_monomial f d r

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 120 — aeval foundational identities**.

    Five core facts about `aeval f`:
    1. `aeval f (X s) = f s` (substitute generator).
    2. `aeval f (C r) = algebraMap R S r` (constants).
    3. `aeval X = AlgHom.id` (identity substitution).
    4. `aeval X p = p` (pointwise).
    5. `aeval f (monomial d r) = (algMap r) * ∏ (f i)^(d i)` (monomial).

    Sub-lemma 10/N in T-5 Phase 3.  Lean-core only.

    Used throughout T-5 polynomial-index calculus where we evaluate
    polynomials at specific tuples (rational approximations of
    algebraic numbers). -/
theorem session_120_aeval_basics_headline
    {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S] :
    -- (1) X s
    (∀ (f : σ → S) (s : σ),
        (aeval f : MvPolynomial σ R →ₐ[R] S) (X s) = f s)
    -- (2) C r
    ∧ (∀ (f : σ → S) (r : R),
        (aeval f : MvPolynomial σ R →ₐ[R] S) (C r) = algebraMap R S r)
    -- (3) Identity functional
    ∧ ((aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) =
        AlgHom.id R (MvPolynomial σ R))
    -- (4) Identity pointwise
    ∧ (∀ (p : MvPolynomial σ R),
        (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) p = p)
    -- (5) Monomial
    ∧ (∀ (f : σ → S) (d : σ →₀ ℕ) (r : R),
        (aeval f : MvPolynomial σ R →ₐ[R] S) (monomial d r) =
          algebraMap R S r * d.prod fun i k => f i ^ k) :=
  ⟨T5_aeval_X, T5_aeval_C, T5_aeval_X_left, T5_aeval_X_left_apply,
   T5_aeval_monomial⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalBasics
