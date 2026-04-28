/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero

  T-5 (Roth's theorem) — **Phase 7 ext #158: Quadratic Roth bound for
  ALL q with eval₂ ≠ 0 (cubic+ chain dichotomy composition)**, sub
  session 559fffffffff — STRICT critical-path #316 (T-5)
  Phase 7 ext #158.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Removes the `|q - α| ≤ 1` condition by composing close + far cases:

  For α : ℝ Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C, p, `0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0 ∧
    ∀ q : ℚ with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q - α|`

  Strategy: dichotomy on |q - α| ≤ 1 vs > 1. Close case via existing
  chain (s149); far case via trivial bound (s156).

  Single derivation:
  1. `T5_quadratic_roth_all_q_eval_nonzero`: composes s149 + s156.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #158 — Quadratic Roth ALL q with eval₂ ≠ 0.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound

/-! ## Quadratic Roth ALL q with eval₂ ≠ 0 -/

/-- **🚨 Wave T5 session 559fffffffff — Quadratic Roth ALL q with eval₂ ≠ 0**.

    For α Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C ∈ (0,1], p ≠ 0 (annihilating α), ∀ q : ℚ with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q - α|`.

    No `|q - α| ≤ 1` constraint — dichotomy split on |q - α| ≤ 1 vs > 1. -/
theorem T5_quadratic_roth_all_q_eval_nonzero
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, h_close_bound⟩ :=
    T5_irrational_quadratic_roth_bound α hα h_quad ε hε
  refine ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  -- Dichotomy: |q - α| ≤ 1 (close) vs > 1 (far)
  by_cases h_close : |((q : ℚ) : ℝ) - α| ≤ 1
  · -- Close case: apply h_close_bound
    obtain ⟨_, h_le, _⟩ := h_close_bound q h_close h_nonzero
    exact h_le
  · -- Far case: |q - α| > 1, apply T5_roth_form_far_bound
    have h_far : 1 < |((q : ℚ) : ℝ) - α| := lt_of_not_ge h_close
    exact T5_roth_form_far_bound C hC_pos hC_le_one q α h_far ε hε

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559fffffffff — T-5 Phase 7 ext #158**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #158.

    🏆 QUADRATIC ROTH ALL q (NO close-q hypothesis) — UNCONDITIONAL.

    Single derivation:
    1. `T5_quadratic_roth_all_q_eval_nonzero` — Roth bound for all q with
       eval₂ ≠ 0 (no |q-α| ≤ 1 hypothesis required).

    Strategy: dichotomy on |q - α| ≤ 1 vs > 1. Close case via ext #149;
    far case via ext #156 (trivial via `q.den^e ≤ 1 < |q - α|` chain).

    The remaining gap to FULL UNCONDITIONAL Roth (all q without eval₂ ≠ 0):
    handle q where eval₂ = 0 (finitely many ℚ-roots of p, each has |q - α| > 0
    by α irrational, take min). Existing s39 pigeonhole.

    Mathlib usage: composition of ext #149 + ext #156 + dichotomy.

    Sub-lemma 331/N. Lean-core only. -/
theorem session_559fffffffff_T5_phase7_quadratic_roth_all_q_eval_nonzero_headline
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_all_q_eval_nonzero α hα h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero
