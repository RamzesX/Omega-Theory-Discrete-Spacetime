/-
  OmegaTheory.Irrationality.CustomMath.T5_RothForSqrt2

  T-5 (Roth's theorem axiom retirement) — extension session 99.
  Roth's bound specialized to √2.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Conditional Roth bound for √2, demonstrating the strength of the
  Roth target Prop (T-5):

  Under `RothTheorem` (T-5 target), for √2 (which is irrational
  algebraic):

      ∀ ε > 0, ∃ C > 0, ∀ q ∈ ℚ \ {0, √2}: C / H(q)^(2+ε) ≤ |√2 - q|

  Combined with `Irrational.ne_rat` etc., this is THE statement Roth
  refines beyond Liouville.

  Once Roth proper lands (cycle 65+), this theorem becomes unconditional.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
import OmegaTheory.Capstones.PiSqrt2LinearIndependence

namespace OmegaTheory.Irrationality.CustomMath.T5_RothForSqrt2

open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open OmegaTheory.Capstones.PiSqrt2LinearIndependence

/-! ## Roth bound for √2 -/

/-- **Wave T4b session 99 — Roth bound for √2 (conditional)**.

    Under `RothTheorem`, for any ε > 0, there exists C > 0 such that
    for any rational q ≠ 0 with q ≠ √2:

      `C / H(q)^(2+ε) ≤ |Real.sqrt 2 - q|`.

    √2 is irrational (Mathlib `Nat.prime_two.irrational_sqrt`) and
    algebraic (s65 `sqrt2_isAlgebraic`).

    PROOF: directly apply RothTheorem to α = √2. -/
theorem roth_bound_for_sqrt2_conditional
    (h_roth : RothTheorem) (ε : ℝ) (h_ε : 0 < ε) :
    ∃ C : ℝ, 0 < C ∧
      ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ Real.sqrt 2 →
        C / ((OmegaTheory.Irrationality.CustomMath.T5_Heights.Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤
          |Real.sqrt 2 - (q : ℝ)| := by
  -- Apply RothTheorem to α = √2
  -- Need: Irrational √2 ∧ IsAlgebraic ℤ √2
  have h_irr : Irrational (Real.sqrt 2) :=
    Nat.prime_two.irrational_sqrt
  -- IsAlgebraic ℤ √2: √2 is a root of X² - 2 ∈ ℤ[X]
  have h_alg_Q : IsAlgebraic ℚ (Real.sqrt 2) := sqrt2_isAlgebraic
  -- Convert ℚ-algebraic → ℤ-algebraic via integer-poly construction
  have h_alg : IsAlgebraic ℤ (Real.sqrt 2) := by
    -- IsAlgebraic ℤ x ↔ IsAlgebraic ℚ x for x : ℝ (via ℚ being fraction field of ℤ)
    obtain ⟨p, hp_ne, hp_zero⟩ := h_alg_Q
    -- Use IsLocalization.integerNormalization to get an ℤ-poly
    refine ⟨IsLocalization.integerNormalization (nonZeroDivisors ℤ) p, ?_, ?_⟩
    · -- non-zero
      intro h_eq_zero
      have h_iff : IsLocalization.integerNormalization (nonZeroDivisors ℤ) p = 0 ↔ p = 0 :=
        IsLocalization.integerNormalization_eq_zero_iff (M := nonZeroDivisors ℤ) le_rfl _
      exact hp_ne (h_iff.mp h_eq_zero)
    · -- root
      apply IsLocalization.integerNormalization_aeval_eq_zero
      exact hp_zero
  exact h_roth (Real.sqrt 2) h_irr h_alg ε h_ε

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 99 — conditional Roth bound for √2**.

    Once cycle 65+ retires the Roth axiom, this becomes unconditional:
    a sharp Diophantine approximation bound for √2.

    Sub-lemma 24 in T-5 Phase 2 (extension). Lean-core only. -/
theorem session_99_roth_for_sqrt2_headline :
    -- (1) Roth → bound for √2
    (RothTheorem →
      ∀ ε : ℝ, 0 < ε →
        ∃ C : ℝ, 0 < C ∧
          ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ Real.sqrt 2 →
            C / ((OmegaTheory.Irrationality.CustomMath.T5_Heights.Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤
              |Real.sqrt 2 - (q : ℝ)|) := by
  exact roth_bound_for_sqrt2_conditional

end OmegaTheory.Irrationality.CustomMath.T5_RothForSqrt2
