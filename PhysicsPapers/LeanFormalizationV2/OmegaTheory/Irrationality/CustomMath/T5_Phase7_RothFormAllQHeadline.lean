/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline

  T-5 (Roth's theorem) — **Phase 7 ext #159: Roth-form ALL q with
  eval₂ ≠ 0 — paper-headline form**, sub session 559ggggggggg —
  STRICT critical-path #316 (T-5) Phase 7 ext #159.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Cleaner re-statement of ext #158 in standard Roth signature:

  For α : ℝ Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C > 0, ∃ p ≠ 0 (annihilating α), ∀ q ∈ ℚ with eval₂(p, q) ≠ 0:
      `|q - α| ≥ C / q.den^(2+ε)`

  Same as ext #158 but with the standard `1/q.den^(2+ε)` form (instead
  of `q.den^(-(2+ε))`). Cosmetic but matches Roth 1955 paper convention.

  Single derivation:
  1. `T5_roth_form_all_q_paper`: composes ext #158 + rpow_neg.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #159 — Roth-form ALL q paper-headline form.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero

/-! ## Roth-form ALL q paper-headline form -/

/-- **🚨 Wave T5 session 559ggggggggg — Roth-form ALL q paper-headline form**.

    For α Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C > 0, p ≠ 0 (annihilating α), ∀ q : ℚ with eval₂ ≠ 0:
      `C / (q.den : ℝ)^(2+ε) ≤ |q - α|`. -/
theorem T5_roth_form_all_q_paper
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, _hC_le, hp_ne, hp_root, h_bound⟩ :=
    T5_quadratic_roth_all_q_eval_nonzero α hα h_quad ε hε
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  -- C · q.den^(-(2+ε)) = C / q.den^(2+ε)
  have h_eq : C * ((q.den : ℝ)) ^ (-(2 + ε)) = C / ((q.den : ℝ)) ^ (2 + ε) := by
    rw [Real.rpow_neg (by positivity : (0:ℝ) ≤ (q.den : ℝ))]
    exact (div_eq_mul_inv _ _).symm
  rw [← h_eq]
  exact h_bound q h_nonzero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ggggggggg — T-5 Phase 7 ext #159**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #159.

    🏆 ROTH-FORM PAPER HEADLINE — `|q-α| ≥ C / q.den^(2+ε)` standard form.

    Sub-lemma 332/N. Lean-core only. -/
theorem session_559ggggggggg_T5_phase7_roth_form_all_q_paper_headline
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_form_all_q_paper α hα h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline
