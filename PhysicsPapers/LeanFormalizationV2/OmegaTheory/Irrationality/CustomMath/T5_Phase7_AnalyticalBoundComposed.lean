/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalBoundComposed

  T-5 (Roth's theorem) — **Phase 7 ext #21: full analytical bound
  composed (|p(α)| ≤ (d+1)^n · ‖c‖∞ · ∏ 2^d · max α^d)**, sub
  session 559nnn — STRICT critical-path #316 (T-5) Phase 7 ext #21.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Composes ext #19 (`T5_coeffsToPoly_eval_abs_bound`) + ext #20
  (`T5_coeffs_abs_sum_le_card_sup`) into the FULL analytical bound:

      |eval α (coeffsToPoly c)|
        ≤ ((d+1)^n : ℤ) · M · ∏ i, 2^d · (max 1 |α_i|)^d

  where `M : ℤ` is any uniform bound on `|c k|`.

  This is the **CLOSED-FORM analytical bound** for Roth's main proof:
  given the Schmidt aux poly with explicit Siegel `‖c‖∞`-bound from
  ext #16, plug in `M = Siegel-bound` to get explicit `|p(α)|` upper
  bound in terms of (d, n, J, α, ‖vanishing-matrix‖).

  Two derivations + Prop:
  1. `T5_coeffsToPoly_eval_abs_le_card_sup`: composition theorem
  2. `T5_coeffsToPoly_eval_abs_le_card_sup_natcast`: variant using
     ℤ-cast form for downstream composition with Siegel bound

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #21 — full analytical bound composed.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalBoundComposed

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound

/-! ## Full analytical bound composition -/

/-- **🚨 Wave T5 session 559nnn — full analytical bound composed**.

    Composition of ext #19 (poly-eval abs bound) + ext #20
    (coeffs abs-sum cast):

        |eval α (coeffsToPoly c)|
          ≤ ((d+1)^n : ℤ) · M · ∏ i, 2^d · (max 1 |α_i|)^d

    where `M : ℤ` is a uniform upper bound on `|c k|`. -/
theorem T5_coeffsToPoly_eval_abs_le_card_sup {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) (M : ℤ)
    (h_M : ∀ k : BoundedMI n d, |c k| ≤ M) :
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ ((d + 1) ^ n : ℕ) • M *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) := by
  have h1 := T5_coeffsToPoly_eval_abs_bound c α
  have h2 := T5_coeffs_abs_sum_le_card_sup c M h_M
  have h_prod_nn : (0 : ℤ) ≤
      ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d) :=
    Finset.prod_nonneg (fun i _ => by positivity)
  calc |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (∑ k : BoundedMI n d, |c k|) *
          (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) := h1
    _ ≤ (((d + 1) ^ n : ℕ) • M) *
          (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) :=
          mul_le_mul_of_nonneg_right h2 h_prod_nn

/-- **🚨 Wave T5 session 559nnn — full analytical bound (ℤ-cast form)**.

    Same as above but with explicit ℤ-cast on `(d+1)^n` for downstream
    composition with Siegel norm bound (which uses ℝ casts). -/
theorem T5_coeffsToPoly_eval_abs_le_card_sup_natcast {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) (M : ℤ)
    (h_M : ∀ k : BoundedMI n d, |c k| ≤ M) :
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (((d + 1) ^ n : ℕ) : ℤ) * M *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) := by
  have h := T5_coeffsToPoly_eval_abs_le_card_sup c α M h_M
  rw [nsmul_eq_mul] at h
  exact h

/-! ## AnalyticalBoundComposed Prop scaffold -/

/-- **AnalyticalBoundComposed**: 2-conjunct Prop packaging the
    nsmul-form + ℤ-cast-form composition theorems. -/
def AnalyticalBoundComposed : Prop :=
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) (M : ℤ),
    (∀ k : BoundedMI n d, |c k| ≤ M) →
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ ((d + 1) ^ n : ℕ) • M *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d))) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) (M : ℤ),
    (∀ k : BoundedMI n d, |c k| ≤ M) →
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (((d + 1) ^ n : ℕ) : ℤ) * M *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)))

/-- **🚨 Wave T5 session 559nnn — `AnalyticalBoundComposed`**. -/
theorem T5_analytical_bound_composed : AnalyticalBoundComposed :=
  ⟨@T5_coeffsToPoly_eval_abs_le_card_sup,
   @T5_coeffsToPoly_eval_abs_le_card_sup_natcast⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559nnn — T-5 Phase 7 ext #21:
    full analytical bound composed**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #21.

    Composition of ext #19 (`T5_coeffsToPoly_eval_abs_bound`) +
    ext #20 (`T5_coeffs_abs_sum_le_card_sup`) into the full
    closed-form analytical bound:

        |eval α (coeffsToPoly c)|
          ≤ ((d+1)^n : ℤ) · M · ∏ i, 2^d · (max 1 |α_i|)^d

    where `M : ℤ` is any uniform upper bound on `|c k|`.

    Two derivations + Prop:
    1. `T5_coeffsToPoly_eval_abs_le_card_sup` — nsmul form
    2. `T5_coeffsToPoly_eval_abs_le_card_sup_natcast` — ℤ-cast form
    + AnalyticalBoundComposed Prop (2-conjunct).

    Combined with ext #16 (Schmidt aux poly with Siegel `‖c‖∞`-bound),
    plugging `M = Siegel-bound` yields explicit `|p(α)|` upper bound
    in (d, n, J, α, ‖vanishing-matrix‖) — the CLOSED-FORM analytical
    bound for Roth's main proof.

    Mathlib usage: `mul_le_mul_of_nonneg_right`, `Finset.prod_nonneg`,
    `nsmul_eq_mul`, `positivity`.

    Sub-lemma 214/N in T-1 (T-5 Phase 7 ext #21).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 full analytical bound composed
    (ext #19 + ext #20 → closed-form |p(α)| upper bound). -/
theorem session_559nnn_T5_phase7_analytical_bound_composed_headline :
    AnalyticalBoundComposed :=
  T5_analytical_bound_composed

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalBoundComposed
