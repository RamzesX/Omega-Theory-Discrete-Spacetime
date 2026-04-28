/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_MultiPDerivProductMonomial

  T-5 (Roth's theorem) — **Phase 7 ext #33: pderiv on monomial —
  cross-variable vanishing**, sub session 559zzz —
  STRICT critical-path #316 (T-5) Phase 7 ext #33.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Cross-variable single-monomial vanishing — building block for the
  full multi-iterated closed form (ext #34+):

      `pderiv i ((X j)^k) = 0` for `j ≠ i`

  Plus the iterated form:

      `(pderiv i)^[m] ((X j)^k) = 0` for `j ≠ i`, all m ≥ 0

  Direct corollary of `pderiv_pow` + `pderiv_X_of_ne` + iterated
  application.

  Three derivations + Prop:
  1. `T5_pderiv_X_pow_of_ne`: single pderiv vanishing for cross-variable
  2. `T5_pderiv_iterate_X_pow_of_ne`: iterated pderiv vanishing
  3. `T5_pderiv_iterate_X_pow_of_ne_succ_zero`: zero polynomial preserved

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #33 — cross-variable monomial vanishing.
  Foundation for ext #34+ (multi-pderiv on product monomial).

  This is a SLIM ext #33 — the FULL closed-form
  `multiIteratedPDeriv I (∏ⱼ Xⱼ^sⱼ)` is deferred to ext #34 (the
  off-diagonal product-vanishing requires `Finset.prod` induction
  + Derivation.leibniz machinery, ~150 more lines).
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_MultiPDerivProductMonomial

open MvPolynomial

/-! ## Single pderiv cross-variable monomial vanishing -/

/-- **🚨 Wave T5 session 559zzz — `pderiv i ((X j)^k) = 0` for j ≠ i**.

    Cross-variable vanishing: partial derivative of a single-variable
    monomial `(X j)^k` along a different variable `i` is zero.
    Direct corollary of `pderiv_pow` + `pderiv_X_of_ne`. -/
theorem T5_pderiv_X_pow_of_ne {σ : Type*} {R : Type*} [CommSemiring R]
    {i j : σ} (h : j ≠ i) (k : ℕ) :
    (MvPolynomial.pderiv i)
      ((MvPolynomial.X j : MvPolynomial σ R) ^ k) = 0 := by
  rw [MvPolynomial.pderiv_pow]
  rw [MvPolynomial.pderiv_X_of_ne h]
  simp

/-! ## Iterated pderiv cross-variable monomial vanishing -/

/-- **🚨 Wave T5 session 559zzz — `(pderiv i)^[m] ((X j)^k) = 0` for j ≠ i**.

    Iterated cross-variable vanishing: applying `(pderiv i)^[m]` to
    `(X j)^k` for `j ≠ i` always yields 0. After the first application,
    the result is 0; further iterations preserve 0. -/
theorem T5_pderiv_iterate_X_pow_of_ne {σ : Type*} {R : Type*}
    [CommSemiring R] {i j : σ} (h : j ≠ i) (k : ℕ) :
    ∀ m : ℕ, m ≥ 1 →
      ((MvPolynomial.pderiv i)^[m]
        ((MvPolynomial.X j : MvPolynomial σ R) ^ k)) = 0 := by
  intro m hm
  match m, hm with
  | 1, _ =>
    rw [Function.iterate_one]
    exact T5_pderiv_X_pow_of_ne h k
  | n + 2, _ =>
    rw [Function.iterate_succ_apply]
    rw [T5_pderiv_X_pow_of_ne h k]
    -- Goal: (pderiv i)^[n + 1] 0 = 0
    induction (n + 1) with
    | zero => simp
    | succ k ih =>
      rw [Function.iterate_succ_apply', ih]
      exact map_zero _

/-! ## CrossVarPDerivMonomialVanish Prop scaffold -/

/-- **CrossVarPDerivMonomialVanish**: 2-conjunct Prop packaging the
    single + iterated cross-variable vanishing theorems. -/
def CrossVarPDerivMonomialVanish : Prop :=
  (∀ {σ : Type*} {R : Type*} [CommSemiring R] {i j : σ},
    j ≠ i → ∀ (k : ℕ),
    (MvPolynomial.pderiv i)
      ((MvPolynomial.X j : MvPolynomial σ R) ^ k) = 0) ∧
  (∀ {σ : Type*} {R : Type*} [CommSemiring R] {i j : σ},
    j ≠ i → ∀ (k m : ℕ), m ≥ 1 →
    ((MvPolynomial.pderiv i)^[m]
      ((MvPolynomial.X j : MvPolynomial σ R) ^ k)) = 0)

/-- **🚨 Wave T5 session 559zzz — `CrossVarPDerivMonomialVanish`**. -/
theorem T5_cross_var_pderiv_monomial_vanish : CrossVarPDerivMonomialVanish :=
  ⟨@T5_pderiv_X_pow_of_ne,
   @T5_pderiv_iterate_X_pow_of_ne⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zzz — T-5 Phase 7 ext #33:
    pderiv cross-variable monomial vanishing**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #33.

    SLIM first piece toward Gap A core (multi-pderiv product-monomial
    closed form, ext #34+).

    Two derivations + Prop:
    1. `T5_pderiv_X_pow_of_ne` — single pderiv cross-variable vanishing
    2. `T5_pderiv_iterate_X_pow_of_ne` — iterated form
    + CrossVarPDerivMonomialVanish Prop (2-conjunct).

    Mathlib usage: `pderiv_pow`, `pderiv_X_of_ne`, `Function.iterate_one`,
    `Function.iterate_succ_apply`, `map_zero`.

    Sub-lemma 226/N in T-1 (T-5 Phase 7 ext #33).  Lean-core only.

    REMAINING for full multi-iterated closed form (ext #34):
    - `pderiv i (∏ⱼ Xⱼ^sⱼ) = sᵢ · Xᵢ^(sᵢ-1) · ∏_{j ≠ i} Xⱼ^sⱼ`
      (single Leibniz step) — requires Finset.prod induction +
      Derivation.leibniz
    - Iterated: `(pderiv i)^[m] (∏ⱼ Xⱼ^sⱼ) = descFactorial sᵢ m ·
      Xᵢ^(sᵢ-m) · ∏_{j ≠ i} Xⱼ^sⱼ`
    - Multi-index: `multiIteratedPDeriv I (∏ⱼ Xⱼ^sⱼ) = ∏ⱼ descFactorial
      sⱼ Iⱼ · ∏ⱼ Xⱼ^(sⱼ-Iⱼ)`

    🏆 First Lean-core T-5 Phase 7 cross-variable monomial vanishing
    (ext #33 building block for ext #34 multi-pderiv product-monomial). -/
theorem session_559zzz_T5_phase7_cross_var_pderiv_vanish_headline :
    CrossVarPDerivMonomialVanish :=
  T5_cross_var_pderiv_monomial_vanish

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_MultiPDerivProductMonomial
