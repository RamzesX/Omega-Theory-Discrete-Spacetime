/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_WLOG_eps_le_1

  T-5 (Roth's theorem) — **WLOG ε ≤ 1 monotonicity reduction**.

  ## Architectural rationale

  RothTheorem is monotone in ε — for ε' ≥ ε (with the same C₁), the
  bound `C₁/h(q)^(2+ε)` is WEAKER (larger RHS, easier to satisfy).
  Specifically, if RothTheorem holds for ε, it holds for any ε' ≥ ε
  with the SAME constant.

  This means we can WLOG assume ε ≤ 1 in any RothTheorem proof.
  Combined with Schmidt aux poly choosing m ≥ 3, we get
    ε ≤ 1 ≤ 27/16 ≤ m³/16
  so the small-ε constraint ε ≤ m³/16 is automatically satisfied
  WITHOUT needing the literal-false universal small-eps axis.

  This file:
    1. Defines `T5_NAMED_RothTheorem_eps_le_1` — RothTheorem restricted
       to ε ≤ 1.
    2. Proves the bridge `T5_NAMED_RothTheorem_eps_le_1 → RothTheorem`
       UNCONDITIONALLY via monotonicity.

  Strategic significance: provides architectural path to drop the
  small-eps axis NAMED leaf from V8R7 (use V8R6 with internal WLOG
  instead).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
import OmegaTheory.Irrationality.CustomMath.T5_Heights

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_WLOG_eps_le_1

open Real
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open OmegaTheory.Irrationality.CustomMath.T5_Heights

/-! ## RW-1 — RothTheorem-restricted-to-ε≤1 NAMED Prop -/

/-- **RW-1 — `T5_NAMED_RothTheorem_eps_le_1`**: RothTheorem restricted to
    the regime ε ≤ 1.

    Strategically: V8 closure path can produce this restricted form
    directly (since Schmidt aux poly + ε ≤ 1 ≤ m³/16 satisfies the
    small-ε constraint automatically with m ≥ 3). -/
def T5_NAMED_RothTheorem_eps_le_1 : Prop :=
  ∀ α : ℝ, Irrational α → IsAlgebraic ℤ α →
    ∀ ε : ℝ, 0 < ε → ε ≤ 1 →
      ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
        C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|

/-! ## RW-2 — Mononicity helper: h^(2+ε') ≥ h^(2+ε) for h ≥ 1, ε' ≥ ε -/

/-- For real `h ≥ 1` and `ε ≤ ε'`, we have `h^(2+ε) ≤ h^(2+ε')`. -/
theorem rpow_mono_in_exp
    (h : ℝ) (h_ge : (1 : ℝ) ≤ h) (ε ε' : ℝ) (h_eps : ε ≤ ε') :
    h ^ (2 + ε) ≤ h ^ (2 + ε') := by
  apply Real.rpow_le_rpow_of_exponent_le h_ge
  linarith

/-! ## RW-3 — Bridge: RothTheorem-for-ε≤1 ⇒ RothTheorem-for-all-ε -/

/-- **🚨🚨🚨 RW-3 — `T5_RothTheorem_via_eps_le_1`**: UNCONDITIONAL bridge
    from RothTheorem-restricted-to-ε≤1 to full RothTheorem.

    Proof: case split on ε ≤ 1 vs ε > 1.
    - ε ≤ 1: apply directly.
    - ε > 1: apply with ε' := 1, get C such that C/h^3 ≤ |α-q|. For
      ε > 1, h^(2+ε) ≥ h^3 (when h ≥ 1, which holds for h(q) for nonzero
      rational q), so C/h^(2+ε) ≤ C/h^3 ≤ |α-q|. -/
theorem T5_RothTheorem_via_eps_le_1
    (h_restricted : T5_NAMED_RothTheorem_eps_le_1) :
    RothTheorem := by
  intros α hα h_alg ε hε_pos
  by_cases h_eps_le : ε ≤ 1
  · -- Case ε ≤ 1: apply h_restricted directly
    exact h_restricted α hα h_alg ε hε_pos h_eps_le
  · -- Case ε > 1: apply h_restricted at ε' := 1, then convert via monotonicity
    push_neg at h_eps_le
    obtain ⟨C, hC_pos, h_bound⟩ := h_restricted α hα h_alg 1 zero_lt_one (le_refl _)
    refine ⟨C, hC_pos, ?_⟩
    intros q hq hα_q
    have h_at_1 := h_bound q hq hα_q
    -- h_at_1 : C / ((Rat.naiveHeight q : ℝ) ^ (2 + 1)) ≤ |α - (q : ℝ)|
    -- Want: C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|
    -- Use: (2+ε) ≥ (2+1) and naiveHeight ≥ 1 ⇒ rpow monotone in exp
    have h_height_ge_1 : (1 : ℝ) ≤ (Rat.naiveHeight q : ℝ) := by
      have h_ge : 1 ≤ Rat.naiveHeight q := by
        -- naiveHeight q ≥ 1 for q ≠ 0
        unfold Rat.naiveHeight
        -- naiveHeight = max(|num|, denom)
        have h_den : 1 ≤ q.den := q.pos
        omega
      exact_mod_cast h_ge
    have h_exp : (1 : ℝ) ≤ ε := le_of_lt h_eps_le
    have h_rpow_mono : (Rat.naiveHeight q : ℝ) ^ (2 + 1 : ℝ) ≤
        (Rat.naiveHeight q : ℝ) ^ (2 + ε) :=
      rpow_mono_in_exp _ h_height_ge_1 1 ε h_exp
    have h_rpow_pos : 0 < (Rat.naiveHeight q : ℝ) ^ (2 + ε) := by
      apply Real.rpow_pos_of_pos
      linarith
    have h_C_div_le : C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤
        C / ((Rat.naiveHeight q : ℝ) ^ (2 + 1 : ℝ)) := by
      apply div_le_div_of_nonneg_left (le_of_lt hC_pos) _ h_rpow_mono
      apply Real.rpow_pos_of_pos
      linarith
    linarith [h_at_1, h_C_div_le]

/-! ## RW-4 — Headline -/

/-- **🚨🚨🚨🚨 RW-4 — `T5_ROTH_THEOREM_WLOG_EPS_LE_1_HEADLINE`**:
    paper-citable architectural reduction.

    Strategic significance:
    - V8 closure path can produce only RothTheorem-for-ε≤1 directly.
    - This file's RW-3 bridge UNCONDITIONALLY extends to all ε.
    - Combined with SchmidtAuxPolyExistsAtM≥3, the small-ε constraint
      ε ≤ m³/16 is automatic when ε ≤ 1 and m ≥ 3.
    - Eliminates the need for the literal-false universal small-eps axis
      NAMED leaf. -/
theorem T5_ROTH_THEOREM_WLOG_EPS_LE_1_HEADLINE :
    T5_NAMED_RothTheorem_eps_le_1 → RothTheorem :=
  T5_RothTheorem_via_eps_le_1

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_WLOG_eps_le_1
