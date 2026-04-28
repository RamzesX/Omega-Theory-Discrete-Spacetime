/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight

  T-5 (Roth's theorem) — **Phase 7 ext #146: Quadratic Roth UNCONDITIONAL
  with positive LHS + tight C ∈ (0, 1]**, sub session 559tttttttt —
  STRICT critical-path #316 (T-5) Phase 7 ext #146.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Combines ext #143 (TIGHT C ∈ (0, 1]) + ext #145 (LHS positivity)
  into a single composite:

  For α with `IsQuadraticAlgebraic α` + ε > 0:
    ∃ C, p, `0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0` ∧
    ∀ q close to α with eval₂ ≠ 0:
      `0 < C · q.den^(-(2+ε)) ≤ |q-α|`

  Single derivation:
  1. `T5_quadratic_roth_positive_tight`: composes s143 + s145.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #146 — quadratic Roth UNCONDITIONAL with positive LHS + tight C.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos

/-! ## Quadratic Roth positive + tight -/

/-- **🚨 Wave T5 session 559tttttttt — Quadratic Roth POSITIVE TIGHT bound**.

    For α with IsQuadraticAlgebraic α + ε > 0:
    ∃ C, p, 0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0 ∧
    ∀ q close to α with eval₂ ≠ 0:
      `0 < C · q.den^(-(2+ε))` AND `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_quadratic_roth_positive_tight
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, h_bound⟩ :=
    T5_quadratic_roth_tight_constant α h_quad ε hε
  refine ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  refine ⟨T5_roth_form_LHS_pos C hC_pos q (-(2 + ε)),
          h_bound q h_close h_nonzero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559tttttttt — T-5 Phase 7 ext #146**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #146.

    🏆 QUADRATIC ROTH POSITIVE TIGHT — combines ext #143 + ext #145.

    Strategy: composes tight constant (#143) + LHS positivity (#145).

    Sub-lemma 319/N. Lean-core only. -/
theorem session_559tttttttt_T5_phase7_quadratic_roth_positive_tight_headline
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_positive_tight α h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight
