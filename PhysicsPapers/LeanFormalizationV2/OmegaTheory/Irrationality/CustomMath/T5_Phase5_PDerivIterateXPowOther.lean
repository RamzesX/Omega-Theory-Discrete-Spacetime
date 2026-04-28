/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther

  T-5 (Roth's theorem) — **Phase 5 ENTRY: cross-variable iterated
  pderiv vanishing on monomials**, sub session 559hh —
  STRICT critical-path #316 (T-5) Phase 5 ENTRY.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).
  Per opus-code-crawler intel today: this lemma is the FIRST
  prerequisite for the non-trivial `rothIndex > 0` computations of
  Phase 5.

  ## What this file delivers

  Cross-variable iterated partial derivative vanishing on monomials:

      `j ≠ i → 1 ≤ m → (pderiv j)^[m] (X i ^ n) = 0`

  Reason: `pderiv j (X i ^ n) = n · X i^(n-1) · pderiv j (X i) = 0`
  since `pderiv j (X i) = 0` for `j ≠ i`.  Then any further iteration
  preserves zero.

  This is the COMPLEMENT to `T5_Phase3_PDerivIterateXPow.lean`'s
  `T5_pderiv_iterate_X_pow_self` (same-variable case, where the
  result is `n.descFactorial m · (X i)^(n - m)`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ENTRY foundation #1.  Used directly by:
  - `T5_rothIndex_X_pow_at_zero` (the FIRST non-trivial positive-index
    computation: `α i = 0 → rothIndex (X i ^ k) α d = k / d i`)
  - downstream Roth-Schmidt-Wirsing auxiliary-polynomial analysis.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Cross-variable iterated pderiv vanishes on a single monomial -/

/-- **🚨 Wave T5 session 559hh — `pderiv j (X i ^ n) = 0` for `j ≠ i`**.

    Single-step cross-variable pderiv: peels via `pderiv_pow`, the
    result has factor `pderiv j (X i) = 0` when `j ≠ i`. -/
theorem T5_pderiv_X_pow_other {i j : σ} (h : j ≠ i) (n : ℕ) :
    pderiv j ((X i : MvPolynomial σ R) ^ n) = 0 := by
  rw [MvPolynomial.pderiv_pow]
  rw [pderiv_X_of_ne h.symm]
  ring

/-! ## Iterated pderiv on zero polynomial -/

/-- **🚨 Wave T5 session 559hh — `(pderiv j)^[k] 0 = 0`** (helper).

    Iterating any pderiv on the zero polynomial preserves zero. -/
theorem T5_pderiv_iterate_zero (j : σ) (k : ℕ) :
    ((pderiv j)^[k] (0 : MvPolynomial σ R)) = 0 := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Function.iterate_succ_apply', ih]
    exact map_zero _

/-! ## Iterated cross-variable pderiv vanishes on a single monomial -/

/-- **🚨 Wave T5 session 559hh — iterated cross-variable pderiv on monomials**.

    For `j ≠ i` and `m ≥ 1`, `(pderiv j)^[m] (X i ^ n) = 0`. -/
theorem T5_pderiv_iterate_X_pow_other {i j : σ} (h : j ≠ i) (n : ℕ)
    {m : ℕ} (hm : 1 ≤ m) :
    ((pderiv j)^[m] ((X i : MvPolynomial σ R) ^ n)) = 0 := by
  rcases Nat.exists_eq_succ_of_ne_zero (Nat.one_le_iff_ne_zero.mp hm) with ⟨m', rfl⟩
  rw [Function.iterate_succ_apply, T5_pderiv_X_pow_other h n]
  exact T5_pderiv_iterate_zero j m'

/-! ## PDerivIterateXPowOther Prop scaffold -/

/-- **PDerivIterateXPowOther**: 2-conjunct Prop packaging the
    cross-variable iterated pderiv vanishing. -/
def PDerivIterateXPowOther : Prop :=
  (∀ {σ R : Type*} [CommSemiring R] {i j : σ}, j ≠ i → ∀ (n : ℕ),
    pderiv j ((X i : MvPolynomial σ R) ^ n) = 0) ∧
  (∀ {σ R : Type*} [CommSemiring R] {i j : σ}, j ≠ i → ∀ (n : ℕ) {m : ℕ}, 1 ≤ m →
    ((pderiv j)^[m] ((X i : MvPolynomial σ R) ^ n)) = 0)

/-- **🚨 Wave T5 session 559hh — `PDerivIterateXPowOther`**. -/
theorem T5_pderiv_iterate_X_pow_other_prop : PDerivIterateXPowOther :=
  ⟨@T5_pderiv_X_pow_other,
   @T5_pderiv_iterate_X_pow_other⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hh — T-5 Phase 5 ENTRY: cross-variable pderiv vanishing**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ENTRY.

    Two derivations + Prop:
    1. `T5_pderiv_X_pow_other` (j ≠ i): single-step cross-variable
    2. `T5_pderiv_iterate_X_pow_other` (j ≠ i, m ≥ 1): iterated case
    + PDerivIterateXPowOther Prop (2-conjunct).

    First T-5 Phase 5 sub-lemma.  Per opus-code-crawler intel today:
    this lemma is the first prerequisite for the non-trivial
    `rothIndex > 0` computations.  Combined with the Phase 3
    `T5_pderiv_iterate_X_pow_self` (same-variable case), it gives
    the complete iterated-pderiv characterization on single
    monomials `X i ^ n`.

    Mathlib usage: `MvPolynomial.pderiv_pow`, `MvPolynomial.pderiv_X_of_ne`,
    `Function.iterate_succ_apply'`, `map_zero`.

    Sub-lemma 182/N in T-1 (T-5 Phase 5 ENTRY).  Lean-core only.

    🏆 First Lean-core T-5 Phase 5 cross-variable pderiv vanishing. -/
theorem session_559hh_T5_phase5_pderiv_iterate_X_pow_other_headline :
    PDerivIterateXPowOther :=
  T5_pderiv_iterate_X_pow_other_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther
