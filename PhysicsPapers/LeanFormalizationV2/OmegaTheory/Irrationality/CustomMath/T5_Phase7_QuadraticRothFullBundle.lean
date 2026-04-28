/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFullBundle

  T-5 (Roth's theorem) — **Phase 7 ext #151: Full quadratic Roth bundle
  with comparison + non-vacuous + tight C**, sub session 559yyyyyyyy —
  STRICT critical-path #316 (T-5) Phase 7 ext #151.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Comprehensive 4-conjunct Roth bound for Irrational + IsQuadraticAlgebraic α:

  For α : ℝ Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C, p, `0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0` ∧
    ∀ q close to α with eval₂ ≠ 0:
      1. `0 < C · q.den^(-(2+ε))` (LHS positive)
      2. `C · q.den^(-(2+ε)) ≤ |q-α|` (Roth-form bound)
      3. `0 < |q-α|` (non-vacuous, α irrational)
      4. `C · q.den^(-(2+ε)) ≤ q.den^(-(2+ε))` (C ≤ 1 implies LHS ≤ unscaled)

  Single derivation:
  1. `T5_quadratic_roth_full_bundle`: composes s149 + s150.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #151 — full quadratic Roth bundle (4-conjunct).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormUpperBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFullBundle

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormUpperBound

/-! ## Full quadratic Roth bundle -/

/-- **🚨 Wave T5 session 559yyyyyyyy — Full quadratic Roth 4-conjunct bundle**.

    For α Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C, p, 0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0 ∧
    ∀ q close to α with eval₂ ≠ 0:
      `0 < C · q.den^(-(2+ε))` ∧
      `C · q.den^(-(2+ε)) ≤ |q-α|` ∧
      `0 < |q-α|` ∧
      `C · q.den^(-(2+ε)) ≤ q.den^(-(2+ε))`. -/
theorem T5_quadratic_roth_full_bundle
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ ((q.den : ℝ)) ^ (-(2 + ε)) := by
  obtain ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_quadratic_roth_bound α hα h_quad ε hε
  refine ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  obtain ⟨h_lhs_pos, h_le_dist, h_dist_pos⟩ := h_bound q h_close h_nonzero
  refine ⟨h_lhs_pos, h_le_dist, h_dist_pos, ?_⟩
  -- C · q.den^e ≤ q.den^e (from C ≤ 1)
  exact T5_roth_form_upper_bound C (le_of_lt hC_pos) hC_le_one q (-(2 + ε))

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559yyyyyyyy — T-5 Phase 7 ext #151**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #151.

    🏆 FULL ROTH BUNDLE — 4-conjunct comprehensive bound.

    Sub-lemma 324/N. Lean-core only. -/
theorem session_559yyyyyyyy_T5_phase7_quadratic_roth_full_bundle_headline
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ ((q.den : ℝ)) ^ (-(2 + ε)) :=
  T5_quadratic_roth_full_bundle α hα h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFullBundle
