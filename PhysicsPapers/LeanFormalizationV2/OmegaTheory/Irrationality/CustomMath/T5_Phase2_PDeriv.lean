/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDeriv

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 5/15 session 83.
  MvPolynomial partial derivatives.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of Mathlib's `MvPolynomial.pderiv` API for use in T-5
  multi-variable index theory:

  1. **`T5_pderiv_C`** : `pderiv i (C a) = 0`.
  2. **`T5_pderiv_X_self`** : `pderiv i (X i) = 1`.
  3. **`T5_pderiv_X_of_ne`** : `pderiv i (X j) = 0` for j ≠ i.
  4. **`T5_pderiv_zero`** : `pderiv i 0 = 0`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDeriv

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## pderiv on basic generators -/

/-- **Wave T4b session 83 — pderiv of `C a`**.

    Constants have zero partial derivative. -/
theorem T5_pderiv_C (i : σ) (a : R) :
    pderiv i (C a : MvPolynomial σ R) = 0 :=
  MvPolynomial.pderiv_C

/-- **Wave T4b session 83 — pderiv of `X i` w.r.t. `i`**.

    Self-derivative is 1. -/
theorem T5_pderiv_X_self (i : σ) :
    pderiv i (X i : MvPolynomial σ R) = 1 :=
  MvPolynomial.pderiv_X_self i

/-- **Wave T4b session 83 — pderiv of `X j` w.r.t. `i ≠ j`**.

    Cross-variable derivative is 0. -/
theorem T5_pderiv_X_of_ne {i j : σ} (h : j ≠ i) :
    pderiv i (X j : MvPolynomial σ R) = 0 :=
  MvPolynomial.pderiv_X_of_ne h

/-! ## Linearity -/

/-- **Wave T4b session 83 — pderiv of zero is zero**. -/
theorem T5_pderiv_zero (i : σ) :
    pderiv i (0 : MvPolynomial σ R) = 0 := by
  simp [pderiv]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 83 — pderiv on basic generators**.

    Four foundational facts:
    1. `pderiv i (C a) = 0`
    2. `pderiv i (X i) = 1`
    3. `pderiv i (X j) = 0` for j ≠ i
    4. `pderiv i 0 = 0`

    Sub-lemma 5/15 in T-5 Phase 2. Lean-core only. -/
theorem session_83_mvpoly_pderiv_basic_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) C
    (∀ i : σ, ∀ a : R, pderiv i (C a : MvPolynomial σ R) = 0)
    -- (2) X self
    ∧ (∀ i : σ, pderiv i (X i : MvPolynomial σ R) = 1)
    -- (3) X cross
    ∧ (∀ i j : σ, j ≠ i → pderiv i (X j : MvPolynomial σ R) = 0)
    -- (4) zero
    ∧ (∀ i : σ, pderiv i (0 : MvPolynomial σ R) = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact T5_pderiv_C
  · exact T5_pderiv_X_self
  · intros i j h; exact T5_pderiv_X_of_ne h
  · exact T5_pderiv_zero

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDeriv
