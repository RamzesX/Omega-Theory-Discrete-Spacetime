/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFactoredHeadline

  T-5 (Roth's theorem) — **Phase 7 ext #161: Roth-form factored
  `|q-α| ≥ C / (q.den^2 · q.den^ε)` (cubic+ chain Roth-form refactored)**,
  sub session 559iiiiiiiii — STRICT critical-path #316 (T-5)
  Phase 7 ext #161.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #159 + ext #160 to give the Roth-form bound with the
  denominator factored:

  For α Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C > 0, ∀ q with eval₂ ≠ 0:
      `C / ((q.den : ℝ)^2 * (q.den : ℝ)^ε) ≤ |q - α|`

  Equivalent to the standard `q.den^(2+ε)` form via Real.rpow_add.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #161 — Roth-form factored denominator.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowSum

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFactoredHeadline

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowSum

/-! ## Roth-form factored -/

/-- **🚨 Wave T5 session 559iiiiiiiii — Roth-form factored denominator**. -/
theorem T5_roth_form_factored
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / (((q.den : ℝ)) ^ (2 : ℝ) * ((q.den : ℝ)) ^ ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_roth_form_all_q_paper α hα h_quad ε hε
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  -- (q.den)^(2+ε) = (q.den)^2 * (q.den)^ε
  rw [← T5_qden_rpow_add q 2 ε]
  exact h_bound q h_nonzero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559iiiiiiiii — T-5 Phase 7 ext #161**.

    🏆 BOOKKEEPING — Roth-form with factored q.den^2 · q.den^ε denominator.

    Sub-lemma 334/N. Lean-core only. -/
theorem session_559iiiiiiiii_T5_phase7_roth_form_factored_headline
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / (((q.den : ℝ)) ^ (2 : ℝ) * ((q.den : ℝ)) ^ ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_form_factored α hα h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFactoredHeadline
