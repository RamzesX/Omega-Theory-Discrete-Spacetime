/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm

  T-5 (Roth's theorem) — **V7-N1-uniform STRENGTHENED D2** — multivariate
  Taylor sum form at real α, UNCONDITIONALLY DISCHARGED.

  The original V7N1U-D2 NAMED Prop in
  `T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition.lean:62-69`
  is WEAK (just states `∃ val, aeval γ P = val` — trivially true).
  The actual composition into V7-N1-uniform requires the **Taylor SUM
  form**:

      aeval γ P = ∑ J ∈ (shiftPoly α P).support,
                    (shiftPoly α P).coeff J · ∏ i, (γ i - α i)^{J i}

  Using Phase 6's `T5_aeval_bind₁_shift`:
    `aeval β (shiftPoly γ P) = aeval (β + γ) P`
  Setting β := γ' - α and γ := α gives `aeval (γ' - α) (shiftPoly α P) = aeval γ' P`.
  Combined with `MvPolynomial.eval₂_eq` (sum-over-support), produces the
  Taylor sum form.

  This file:
    1. Defines the STRONGER D2': `T5_NAMED_mvTaylor_at_real_alpha_strong`
    2. Proves it UNCONDITIONALLY using `T5_aeval_bind₁_shift` + `aeval_def + eval₂_eq`
    3. Provides the bridge from D2' to the original (weak) D2

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — strengthened NAMED Prop with genuine
  analytical content + unconditional discharge.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition

/-! ## V7N1U-D2-strong — Multivariate Taylor SUM form at real α -/

/-- **V7N1U-D2-strong — `T5_NAMED_mvTaylor_at_real_alpha_strong`**: the
    GENUINE Taylor sum form at real α via `shiftPoly`.

    For any α : Fin m → ℝ, P : MvPolynomial (Fin m) ℝ, and γ : Fin m → ℝ,

        aeval γ P = ∑ J ∈ (shiftPoly α P).support,
                      (shiftPoly α P).coeff J · ∏ i, (γ i - α i) ^ (J i)

    The "Taylor coefficients" are `(shiftPoly α P).coeff J` = exactly
    the multinomial coefficients at the J-th term of `P(X + α)`. -/
def T5_NAMED_mvTaylor_at_real_alpha_strong : Prop :=
  ∀ {m : ℕ} (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ) (γ : Fin m → ℝ),
    aeval γ P =
      ∑ J ∈ (shiftPoly α P).support,
        (shiftPoly α P).coeff J *
        ∏ i ∈ J.support, (γ i - α i) ^ (J i)

/-! ## V7N1U-D2-strong-discharge — Unconditional proof -/

/-- **🚨🚨 V7N1U-D2-strong-discharge —
    `T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional`**:
    UNCONDITIONAL discharge of the strengthened D2.

    Proof outline:
    1. Apply `T5_aeval_bind₁_shift α (γ - α) P`:
       `aeval (γ - α) (shiftPoly α P) = aeval ((γ - α) + α) P = aeval γ P`.
    2. Apply Mathlib `MvPolynomial.aeval_def` + `MvPolynomial.eval₂_eq`
       to expand the LHS as `∑ J ∈ Q.support, Q.coeff J · ∏ i ∈ J.support, ((γ-α) i)^{J i}`. -/
theorem T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional :
    T5_NAMED_mvTaylor_at_real_alpha_strong := by
  intros m α P γ
  -- Step 1: Substitute via T5_aeval_bind₁_shift to express aeval γ P
  -- as aeval (γ - α) (shiftPoly α P)
  have h_shift :
      aeval γ P = aeval (fun i => γ i - α i) (shiftPoly α P) := by
    rw [T5_aeval_bind₁_shift]
    -- aeval (fun i => (γ i - α i) + α i) P = aeval γ P
    have h_eq : (fun i => (γ i - α i) + α i) = γ := by
      funext i; ring
    rw [h_eq]
  rw [h_shift]
  -- Step 2: Expand aeval Q in monomial sum form
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq]
  -- Goal: ∑ J ∈ Q.support, (algebraMap ℝ ℝ) (Q.coeff J) * ∏ i ∈ J.support, ((γ-α) i)^{J i}
  --       = ∑ J ∈ Q.support, Q.coeff J * ∏ i ∈ J.support, (γ i - α i)^{J i}
  apply Finset.sum_congr rfl
  intros J _
  -- algebraMap ℝ ℝ is identity, and ((γ-α) i) = (γ i - α i) is rfl
  simp

/-! ## V7N1U-D2-strong-bridge — Strong implies original weak D2 -/

/-- **V7N1U-D2-strong-bridge — `T5_strong_implies_weak_D2`**: strong
    Taylor sum form trivially implies the weak existential D2. -/
theorem T5_strong_implies_weak_D2
    (_h : T5_NAMED_mvTaylor_at_real_alpha_strong) :
    T5_NAMED_mvTaylor_at_real_alpha := by
  intros m α P γ
  exact ⟨aeval γ P, rfl⟩

/-! ## V7N1U-D2-strong-headline -/

/-- **🚨🚨🚨 V7N1U-D2-strong-headline — `T5_V7N1U_D2_STRONG_HEADLINE`**:
    paper-citable strengthened D2 bundle.

    Documents the upgrade from weak `∃ val, aeval γ P = val` to genuine
    Taylor sum form, with unconditional discharge using existing Phase 6
    `T5_aeval_bind₁_shift` + Mathlib `MvPolynomial.eval₂_eq`. -/
theorem T5_V7N1U_D2_STRONG_HEADLINE :
    -- (a) Strong D2 unconditional
    T5_NAMED_mvTaylor_at_real_alpha_strong ∧
    -- (b) Strong implies original weak D2
    (T5_NAMED_mvTaylor_at_real_alpha_strong →
      T5_NAMED_mvTaylor_at_real_alpha) ∧
    -- (c) Original weak D2 unconditional (via composition)
    T5_NAMED_mvTaylor_at_real_alpha :=
  ⟨T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional,
   T5_strong_implies_weak_D2,
   T5_strong_implies_weak_D2 T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm
