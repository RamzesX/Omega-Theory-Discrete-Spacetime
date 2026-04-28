/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowDiagonal

  T-5 (Roth's theorem) — **Phase 5 ext #2: pderiv-iterate diagonal
  case `(pderiv i)^[k] (X i ^ k) = k.factorial`**, sub session 559jj —
  STRICT critical-path #316 (T-5) Phase 5 ext #2.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Direct concrete corollary of Phase 3's
  `T5_pderiv_iterate_X_pow_self` at n = k:

      `(pderiv i)^[k] (X i ^ k) = k.factorial`

  Plus the over-iterating case (m > k → result 0):

      `k < m → (pderiv i)^[m] (X i ^ k) = 0`

  Both via Phase 3 same-variable formula `(pderiv i)^[k] (X i^n) =
  n.descFactorial k * X i^(n-k)`:
  - At n = k: `descFactorial k k = k.factorial`, `X i^(k-k) = 1`,
    result = `k.factorial`.
  - For k < m: `descFactorial k m = 0` (over-shoot), so result = 0.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ext #2.  These are the concrete same-variable evaluations
  of the iterated pderiv operator on `X i ^ k` — used directly by
  the upcoming `T5_rothIndex_X_pow_at_zero` (FIRST non-trivial
  positive-index computation).
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Data.Nat.Factorial.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowDiagonal

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

variable {σ R : Type*} [CommSemiring R]

/-! ## Diagonal case: `(pderiv i)^[k] (X i^k) = k.factorial` -/

/-- **🚨 Wave T5 session 559jj — `(pderiv i)^[k] (X i^k) = k.factorial`**.

    Direct corollary of Phase 3's `T5_pderiv_iterate_X_pow_self`
    at n = k: `descFactorial k k = k.factorial`, `X i^(k-k) = 1`. -/
theorem T5_pderiv_iterate_X_pow_diagonal (i : σ) (k : ℕ) :
    ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ k)) =
      (k.factorial : MvPolynomial σ R) := by
  rw [T5_pderiv_iterate_X_pow_self i k k]
  rw [Nat.descFactorial_self, Nat.sub_self, pow_zero, mul_one]

/-! ## Over-iterating case: `k < m → result = 0` -/

/-- **🚨 Wave T5 session 559jj — `(pderiv i)^[m] (X i^k) = 0` for `k < m`**.

    Over-iterating past the polynomial degree gives zero, since
    `descFactorial k m = 0` when `m > k`. -/
theorem T5_pderiv_iterate_X_pow_overshoot (i : σ) (k : ℕ) {m : ℕ}
    (hm : k < m) :
    ((pderiv i)^[m] ((X i : MvPolynomial σ R) ^ k)) = 0 := by
  rw [T5_pderiv_iterate_X_pow_self i k m]
  -- Goal: (k.descFactorial m : _) * X i ^ (k - m) = 0
  rw [Nat.descFactorial_eq_zero_iff_lt.mpr hm]
  simp

/-! ## PDerivIterateXPowDiagonal Prop scaffold -/

/-- **PDerivIterateXPowDiagonal**: 2-conjunct Prop packaging the
    concrete pderiv-iterate evaluations on `X i ^ k`. -/
def PDerivIterateXPowDiagonal : Prop :=
  (∀ {σ R : Type*} [CommSemiring R] (i : σ) (k : ℕ),
    ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ k)) =
      (k.factorial : MvPolynomial σ R)) ∧
  (∀ {σ R : Type*} [CommSemiring R] (i : σ) (k : ℕ) {m : ℕ}, k < m →
    ((pderiv i)^[m] ((X i : MvPolynomial σ R) ^ k)) = 0)

/-- **🚨 Wave T5 session 559jj — `PDerivIterateXPowDiagonal`**. -/
theorem T5_pderiv_iterate_X_pow_diagonal_prop : PDerivIterateXPowDiagonal :=
  ⟨@T5_pderiv_iterate_X_pow_diagonal,
   @T5_pderiv_iterate_X_pow_overshoot⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559jj — T-5 Phase 5 ext #2: same-variable diagonal cases**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ext #2.

    Two derivations + Prop:
    1. `T5_pderiv_iterate_X_pow_diagonal`:
       `(pderiv i)^[k] (X i^k) = k.factorial`
       (the canonical "matched" case where iteration count equals power)
    2. `T5_pderiv_iterate_X_pow_overshoot`:
       `k < m → (pderiv i)^[m] (X i^k) = 0`
       (over-iterating past polynomial degree)
    + PDerivIterateXPowDiagonal Prop (2-conjunct).

    Both via Phase 3's `T5_pderiv_iterate_X_pow_self`:
    `(pderiv i)^[k] (X i^n) = n.descFactorial k * X i^(n-k)`.
    Specializations:
    - n = k: descFactorial k k = k.factorial, X i^0 = 1
    - n < m (i.e. k < m): descFactorial k m = 0

    With s559hh (cross-variable case, m ≥ 1 → 0) + s559ii
    (constants, m ≥ 1 → 0) + this file's diagonal case, we have the
    complete same-variable + cross-variable evaluation toolkit for
    `multiIteratedPDeriv j (X i^k)`.  Next: full multi-foldr
    characterization → rothIndex computation.

    Mathlib usage: `Nat.descFactorial_self`, `Nat.descFactorial_eq_zero_iff_lt`,
    `Nat.sub_self`, `pow_zero`, `mul_one`.

    Sub-lemma 184/N in T-1 (T-5 Phase 5 ext #2).  Lean-core only.

    🏆 First Lean-core T-5 Phase 5 same-variable diagonal cases. -/
theorem session_559jj_T5_phase5_pderiv_iterate_X_pow_diagonal_headline :
    PDerivIterateXPowDiagonal :=
  T5_pderiv_iterate_X_pow_diagonal_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowDiagonal
