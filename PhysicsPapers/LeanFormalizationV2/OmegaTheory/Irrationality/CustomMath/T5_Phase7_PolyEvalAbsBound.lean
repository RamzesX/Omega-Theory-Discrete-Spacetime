/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound

  T-5 (Roth's theorem) — **Phase 7 ext #19: explicit |p(α)| upper
  bound for coeffsToPoly polynomial evaluation**, sub session 559lll
  — STRICT critical-path #316 (T-5) Phase 7 ext #19.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Combines ext #18 (`T5_coeffsToPoly_eval_eq_sum`) + ext #14
  (`T5_vanishingMatrixEntry_abs_le_product`) into an explicit
  upper bound on the polynomial evaluation of `coeffsToPoly c` at
  any integer point α : Fin n → ℤ:

      |(eval α) (coeffsToPoly c)|
        ≤ (∑ k, |c k|) · ∏ i, 2^d · (max 1 |α i|)^d

  This is the **analytical-side bound** for Roth's main proof:
  combined with ext #16 (Schmidt aux poly with explicit Siegel
  norm `‖c‖_∞ ≤ ((d+1)^n · ‖M‖)^(card J / ((d+1)^n - card J))`),
  this gives the full upper-bound chain on `|p(α)|` in terms of
  (d, n, J, α) — the input to the integer-non-vanishing /
  contradiction step (ext #20+).

  Two derivations + Prop:
  1. `T5_finset_abs_sum_le`: helper triangle inequality on
     Finset sums (`|∑ f| ≤ ∑ |f|`)
  2. `T5_coeffsToPoly_eval_abs_bound`: main bound theorem

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #19 — explicit polynomial-evaluation abs bound.
-/

import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound

/-! ## Triangle inequality on Finset sum (re-export of Mathlib) -/

/-- Helper: triangle inequality on Finset sums (re-export from Mathlib's
    `Finset.abs_sum_le_sum_abs`). -/
private theorem abs_sum_le_int {ι : Type*} (s : Finset ι) (f : ι → ℤ) :
    |∑ i ∈ s, f i| ≤ ∑ i ∈ s, |f i| :=
  Finset.abs_sum_le_sum_abs f s

/-! ## Main bound: |p(α)| ≤ (∑ |c k|) · ∏ 2^d · (max 1 |α|)^d -/

/-- **🚨 Wave T5 session 559lll — explicit `|p(α)|` upper bound for `coeffsToPoly`**.

    Combines ext #18 (eval-as-sum) + triangle inequality + ext #14
    (entry abs bound) to give:

        |(eval α) (coeffsToPoly c)|
          ≤ (∑ k, |c k|) · ∏ i, 2^d · (max 1 |α i|)^d -/
theorem T5_coeffsToPoly_eval_abs_bound {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) :
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (∑ k : BoundedMI n d, |c k|) *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) := by
  rw [T5_coeffsToPoly_eval_eq_sum]
  -- Goal: |∑ k, c k * vanishingMatrixEntry 0 α k| ≤ (∑ |c k|) · ∏ bound
  apply (abs_sum_le_int _ _).trans
  -- Goal: ∑ k, |c k * entry| ≤ ...
  have h_summand : ∀ k : BoundedMI n d,
      |c k * vanishingMatrixEntry
        (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1))) α k|
      ≤ |c k| * ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d) := by
    intro k
    rw [abs_mul]
    apply mul_le_mul_of_nonneg_left
    · exact T5_vanishingMatrixEntry_abs_le_product _ α k
    · exact abs_nonneg _
  calc ∑ k : BoundedMI n d,
        |c k * vanishingMatrixEntry
          (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1))) α k|
      ≤ ∑ k : BoundedMI n d, |c k| *
          ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d) :=
        Finset.sum_le_sum (fun k _ => h_summand k)
    _ = (∑ k : BoundedMI n d, |c k|) *
        ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d) := by
        rw [← Finset.sum_mul]

/-! ## PolyEvalAbsBound Prop scaffold -/

/-- **PolyEvalAbsBound**: 1-conjunct Prop packaging the explicit
    polynomial evaluation abs bound. -/
def PolyEvalAbsBound : Prop :=
  ∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ),
    |(MvPolynomial.eval α) (coeffsToPoly c)|
      ≤ (∑ k : BoundedMI n d, |c k|) *
        (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d))

/-- **🚨 Wave T5 session 559lll — `PolyEvalAbsBound`**. -/
theorem T5_poly_eval_abs_bound : PolyEvalAbsBound :=
  @T5_coeffsToPoly_eval_abs_bound

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559lll — T-5 Phase 7 ext #19:
    explicit |p(α)| upper bound for coeffsToPoly polynomial**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #19.

    Combines ext #18 (`T5_coeffsToPoly_eval_eq_sum`) + ext #14
    (`T5_vanishingMatrixEntry_abs_le_product`) + triangle inequality
    on Finset sums into an explicit upper bound:

        |(eval α) (coeffsToPoly c)|
          ≤ (∑ k, |c k|) · ∏ i, 2^d · (max 1 |α i|)^d

    + PolyEvalAbsBound Prop (1-conjunct).

    This is the **analytical-side bound** for Roth's main proof:
    combined with ext #16 (Schmidt aux poly with explicit Siegel
    norm), gives the full upper-bound chain on `|p(α)|` in terms
    of (d, n, J, α) — input to ext #20+ integer non-vanishing /
    final contradiction step.

    Mathlib usage: `abs_add` (for triangle inequality induction),
    `abs_mul`, `mul_le_mul_of_nonneg_left`, `Finset.sum_le_sum`,
    `Finset.sum_mul`, `Finset.sum_insert`, `Finset.induction`.

    Sub-lemma 212/N in T-1 (T-5 Phase 7 ext #19).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 explicit polynomial evaluation
    upper bound for coeffsToPoly. -/
theorem session_559lll_T5_phase7_poly_eval_abs_bound_headline :
    PolyEvalAbsBound :=
  T5_poly_eval_abs_bound

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
