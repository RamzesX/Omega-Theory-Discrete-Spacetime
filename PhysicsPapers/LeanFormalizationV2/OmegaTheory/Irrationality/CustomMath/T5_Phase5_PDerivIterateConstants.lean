/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateConstants

  T-5 (Roth's theorem) — **Phase 5 ext #1: iterated pderiv vanishing
  on constants**, sub session 559ii — STRICT critical-path #316
  (T-5) Phase 5 ext #1.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Iterated partial derivative vanishes on constant polynomials when
  iteration count ≥ 1:

  1. **`T5_pderiv_iterate_one_pos`** : m ≥ 1 → (pderiv i)^[m] 1 = 0
  2. **`T5_pderiv_iterate_C_pos`**   : m ≥ 1 → (pderiv i)^[m] (C c) = 0

  Both via single application of `pderiv` to constant gives 0
  (Derivation property), then iteration on 0 stays 0.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ext #1 — foundational pderiv-vanishing-on-constants.  Used
  in conjunction with `T5_pderiv_iterate_X_pow_other` (s559hh) and
  Phase 3's `T5_pderiv_iterate_X_pow_self` to characterize
  `multiIteratedPDeriv j (X i^k)` exhaustively, en route to the
  FIRST non-trivial `rothIndex > 0` computation.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateConstants

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther

variable {σ R : Type*} [CommSemiring R]

/-! ## Iterated pderiv vanishes on `1` -/

/-- **🚨 Wave T5 session 559ii — `(pderiv i)^[m] 1 = 0` for `m ≥ 1`**.

    The first application gives `pderiv i 1 = 0` (constants vanish
    under derivation), then iteration on 0 stays 0. -/
theorem T5_pderiv_iterate_one_pos (i : σ) {m : ℕ} (hm : 1 ≤ m) :
    ((pderiv i)^[m] (1 : MvPolynomial σ R)) = 0 := by
  rcases Nat.exists_eq_succ_of_ne_zero (Nat.one_le_iff_ne_zero.mp hm) with ⟨m', rfl⟩
  rw [Function.iterate_succ_apply, pderiv_one]
  exact T5_pderiv_iterate_zero i m'

/-! ## Iterated pderiv vanishes on `C c` -/

/-- **🚨 Wave T5 session 559ii — `(pderiv i)^[m] (C c) = 0` for `m ≥ 1`**.

    Constants in `MvPolynomial` (image of `C : R → MvPolynomial σ R`)
    are killed by `pderiv`. -/
theorem T5_pderiv_iterate_C_pos (i : σ) (c : R) {m : ℕ} (hm : 1 ≤ m) :
    ((pderiv i)^[m] ((C c : MvPolynomial σ R))) = 0 := by
  rcases Nat.exists_eq_succ_of_ne_zero (Nat.one_le_iff_ne_zero.mp hm) with ⟨m', rfl⟩
  rw [Function.iterate_succ_apply, pderiv_C]
  exact T5_pderiv_iterate_zero i m'

/-! ## PDerivIterateConstants Prop scaffold -/

/-- **PDerivIterateConstants**: 2-conjunct Prop packaging the
    iterated pderiv vanishing on constants. -/
def PDerivIterateConstants : Prop :=
  (∀ {σ R : Type*} [CommSemiring R] (i : σ) {m : ℕ}, 1 ≤ m →
    ((pderiv i)^[m] (1 : MvPolynomial σ R)) = 0) ∧
  (∀ {σ R : Type*} [CommSemiring R] (i : σ) (c : R) {m : ℕ}, 1 ≤ m →
    ((pderiv i)^[m] ((C c : MvPolynomial σ R))) = 0)

/-- **🚨 Wave T5 session 559ii — `PDerivIterateConstants`**. -/
theorem T5_pderiv_iterate_constants : PDerivIterateConstants :=
  ⟨@T5_pderiv_iterate_one_pos,
   @T5_pderiv_iterate_C_pos⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ii — T-5 Phase 5 ext #1: pderiv-iterate on constants**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ext #1.

    Two derivations + Prop:
    1. `T5_pderiv_iterate_one_pos`: m ≥ 1 → (pderiv i)^[m] 1 = 0
    2. `T5_pderiv_iterate_C_pos`: m ≥ 1 → (pderiv i)^[m] (C c) = 0
    + PDerivIterateConstants Prop (2-conjunct).

    Both via direct unwrap: first iteration applies `pderiv i` to a
    constant (kills it), then iteration-on-0 preserves 0 (s559hh
    helper `T5_pderiv_iterate_zero`).

    Combined with s559hh (cross-variable case) and Phase 3's
    `T5_pderiv_iterate_X_pow_self` (same-variable case), this gives
    sufficient pderiv-vocabulary for the next major step:
    `T5_rothIndex_X_pow_at_zero` — the FIRST non-trivial positive-index
    computation.

    Mathlib usage: `MvPolynomial.pderiv_C`, `Derivation.map_one_eq_zero`
    (via `map_one`), `Function.iterate_succ_apply`.

    Sub-lemma 183/N in T-1 (T-5 Phase 5 ext #1).  Lean-core only.

    🏆 First Lean-core T-5 Phase 5 pderiv-iterate on constants. -/
theorem session_559ii_T5_phase5_pderiv_iterate_constants_headline :
    PDerivIterateConstants :=
  T5_pderiv_iterate_constants

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateConstants
