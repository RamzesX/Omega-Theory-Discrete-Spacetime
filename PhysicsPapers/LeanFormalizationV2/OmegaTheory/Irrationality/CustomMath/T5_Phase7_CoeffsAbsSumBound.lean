/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound

  T-5 (Roth's theorem) — **Phase 7 ext #20: coefficient sup-norm to
  abs-sum cast**, sub session 559mmm — STRICT critical-path #316
  (T-5) Phase 7 ext #20.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Cast bridge: for any coefficient vector `c : BoundedMI n d → ℤ`,
  the abs-sum is bounded by `card · sup-of-abs`:

      ∑ k : BoundedMI n d, |c k|
        ≤ ((d+1)^n : ℤ) · sup_k |c k|

  Combined with ext #19 (`T5_coeffsToPoly_eval_abs_bound`) and
  ext #16 (Siegel sup-norm bound on `‖c‖`), this completes the
  full upper-bound chain on `|p(α)|` in (d, n, J, α).

  Two derivations + Prop:
  1. `T5_finset_abs_sum_le_card_smul`: helper combining
     `Finset.sum_le_card_nsmul` with `Fintype.card`
  2. `T5_coeffs_abs_sum_le_card_sup`: main bound theorem

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #20 — coefficient abs-sum cast bound.

  Combined with ext #19 (poly-eval abs bound) and ext #16
  (Schmidt aux poly Siegel norm), gives the full
  `|p(α)| ≤ explicit(d, n, J, α)` upper-bound chain — input to
  ext #21+ integer non-vanishing argument toward final Roth.
-/

import Mathlib.Algebra.Order.BigOperators.Group.Finset
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

/-! ## Generic Finset abs-sum bound -/

/-- **🚨 Wave T5 session 559mmm — `∑ |c k| ≤ card · M` if all `|c k| ≤ M`**.

    Generic Finset bound via `Finset.sum_le_card_nsmul` instantiated
    on integer absolute values. -/
theorem T5_finset_abs_sum_le_card_smul {ι : Type*} (s : Finset ι)
    (c : ι → ℤ) (M : ℤ) (h : ∀ i ∈ s, |c i| ≤ M) :
    ∑ i ∈ s, |c i| ≤ s.card • M :=
  Finset.sum_le_card_nsmul s (fun i => |c i|) M h

/-! ## BoundedMI specialization with (d+1)^n cardinality -/

/-- **🚨 Wave T5 session 559mmm — `∑ |c k| ≤ (d+1)^n · M` for BoundedMI n d**.

    Specializes to BoundedMI's Fintype with cardinality `(d+1)^n`
    via `T5_boundedMI_card`. -/
theorem T5_coeffs_abs_sum_le_card_sup {n d : ℕ}
    (c : BoundedMI n d → ℤ) (M : ℤ)
    (h : ∀ k : BoundedMI n d, |c k| ≤ M) :
    ∑ k : BoundedMI n d, |c k| ≤ ((d + 1) ^ n : ℕ) • M := by
  have h_card : Fintype.card (BoundedMI n d) = (d + 1) ^ n :=
    T5_boundedMI_card n d
  have h_sum : ∑ k : BoundedMI n d, |c k|
      ≤ (Finset.univ : Finset (BoundedMI n d)).card • M := by
    apply Finset.sum_le_card_nsmul
    intro k _
    exact h k
  rw [Finset.card_univ, h_card] at h_sum
  exact h_sum

/-! ## CoeffsAbsSumBound Prop scaffold -/

/-- **CoeffsAbsSumBound**: 2-conjunct Prop packaging the generic
    + BoundedMI-specialized abs-sum bounds. -/
def CoeffsAbsSumBound : Prop :=
  (∀ {ι : Type*} (s : Finset ι) (c : ι → ℤ) (M : ℤ),
    (∀ i ∈ s, |c i| ≤ M) →
    ∑ i ∈ s, |c i| ≤ s.card • M) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (M : ℤ),
    (∀ k : BoundedMI n d, |c k| ≤ M) →
    ∑ k : BoundedMI n d, |c k| ≤ ((d + 1) ^ n : ℕ) • M)

/-- **🚨 Wave T5 session 559mmm — `CoeffsAbsSumBound`**. -/
theorem T5_coeffs_abs_sum_bound : CoeffsAbsSumBound :=
  ⟨@T5_finset_abs_sum_le_card_smul,
   @T5_coeffs_abs_sum_le_card_sup⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mmm — T-5 Phase 7 ext #20:
    coefficient abs-sum cast bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #20.

    Cast bridge for any coefficient vector `c : BoundedMI n d → ℤ`:

        ∑ k, |c k| ≤ (d+1)^n · sup_k |c k|

    Two derivations + Prop:
    1. `T5_finset_abs_sum_le_card_smul` — generic Finset bound via
       `Finset.sum_le_card_nsmul`
    2. `T5_coeffs_abs_sum_le_card_sup` — BoundedMI specialization
       via `T5_boundedMI_card` ((d+1)^n cardinality)
    + CoeffsAbsSumBound Prop (2-conjunct).

    Combined with ext #19 (`T5_coeffsToPoly_eval_abs_bound`) and
    ext #16 (Schmidt aux poly Siegel sup-norm), this completes the
    full upper-bound chain on `|p(α)|` in terms of (d, n, J, α) —
    input to ext #21+ integer non-vanishing argument toward
    final Roth contradiction.

    Mathlib usage: `Finset.sum_le_card_nsmul`, `Finset.card_univ`.

    Sub-lemma 213/N in T-1 (T-5 Phase 7 ext #20).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 coefficient abs-sum cast
    bound for BoundedMI Fintype. -/
theorem session_559mmm_T5_phase7_coeffs_abs_sum_bound_headline :
    CoeffsAbsSumBound :=
  T5_coeffs_abs_sum_bound

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound
