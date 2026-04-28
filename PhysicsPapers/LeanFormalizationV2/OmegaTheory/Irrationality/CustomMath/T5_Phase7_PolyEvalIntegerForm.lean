/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalIntegerForm

  T-5 (Roth's theorem) — **Phase 7 ext #27: explicit polynomial
  evaluation form `eval α (coeffsToPoly c) = ∑ k, c k · ∏ α^(k i)`**,
  sub session 559ttt — STRICT critical-path #316 (T-5) Phase 7 ext #27.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Composition of ext #18 (`T5_coeffsToPoly_eval_eq_sum`) + ext #12
  (`T5_vanishingMatrixEntry_I_zero`) into the explicit polynomial
  evaluation form:

      `(eval α) (coeffsToPoly c)
         = ∑ k : BoundedMI n d, c k · ∏ i : Fin n, (α i)^((k i).val)`

  This is the **canonical sum-product form** of polynomial evaluation
  for the assembled polynomial — the integer-arithmetic interface
  between the Schmidt-Wirsing-Roth coefficient vector and explicit
  numerical polynomial values.

  Single derivation + Prop:
  1. `T5_coeffsToPoly_eval_explicit`: explicit sum-product form

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #27 — explicit polynomial eval integer form.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalIntegerForm

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

/-! ## Explicit polynomial evaluation as sum-product -/

/-- **🚨 Wave T5 session 559ttt — explicit polynomial eval form**.

    Composes ext #18 (eval-as-matrix-sum at I=0) + ext #12
    (vanishingMatrixEntry I=0 closed form):

        (eval α) (coeffsToPoly c)
          = ∑ k : BoundedMI n d, c k · ∏ i : Fin n, (α i)^((k i).val) -/
theorem T5_coeffsToPoly_eval_explicit {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) :
    (MvPolynomial.eval α) (coeffsToPoly c)
      = ∑ k : BoundedMI n d, c k *
          (∏ i : Fin n, (α i) ^ ((k i).val)) := by
  rw [T5_coeffsToPoly_eval_eq_sum]
  apply Finset.sum_congr rfl
  intro k _
  congr 1
  exact T5_vanishingMatrixEntry_I_zero α k

/-! ## PolyEvalIntegerForm Prop scaffold -/

/-- **PolyEvalIntegerForm**: 1-conjunct Prop packaging the explicit
    polynomial evaluation form. -/
def PolyEvalIntegerForm : Prop :=
  ∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ),
    (MvPolynomial.eval α) (coeffsToPoly c)
      = ∑ k : BoundedMI n d, c k *
          (∏ i : Fin n, (α i) ^ ((k i).val))

/-- **🚨 Wave T5 session 559ttt — `PolyEvalIntegerForm`**. -/
theorem T5_poly_eval_integer_form : PolyEvalIntegerForm :=
  @T5_coeffsToPoly_eval_explicit

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ttt — T-5 Phase 7 ext #27:
    explicit polynomial evaluation integer form**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #27.

    Composition theorem: `(eval α) (coeffsToPoly c) = ∑ k, c k · ∏ α^(k i)`
    via ext #18 (eval-as-matrix-sum at I=0) + ext #12
    (vanishingMatrixEntry I=0 = `∏ α^k`).

    Single derivation + Prop:
    1. `T5_coeffsToPoly_eval_explicit` — explicit sum-product form
    + PolyEvalIntegerForm Prop (1-conjunct).

    Canonical integer-arithmetic interface between Schmidt-Wirsing-Roth
    coefficient vector and explicit numerical polynomial values.
    Foundation for the rational-evaluation form (ext #28+) where q : ℚ
    has bounded denominator and `c k · ∏ q^k_i = m / D^d` for integer m.

    Mathlib usage: `Finset.sum_congr` + `congr 1` to split the
    summand equality into coefficient × matrix-entry form.

    Sub-lemma 220/N in T-1 (T-5 Phase 7 ext #27).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 explicit polynomial evaluation
    integer-arithmetic form. -/
theorem session_559ttt_T5_phase7_poly_eval_integer_form_headline :
    PolyEvalIntegerForm :=
  T5_poly_eval_integer_form

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalIntegerForm
