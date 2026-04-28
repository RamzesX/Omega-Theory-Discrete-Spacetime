/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound

  T-5 (Roth's theorem) — **Phase 7 ext #149: Irrational + Quadratic
  Roth bound (non-vacuous)**, sub session 559wwwwwwww — STRICT
  critical-path #316 (T-5) Phase 7 ext #149.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Strengthens ext #146 with the Irrational α hypothesis to give
  NON-VACUOUS Roth-form bound:

  For α : ℝ Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C, p, `0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0` ∧
    ∀ q close to α with eval₂ ≠ 0:
      `0 < C · q.den^(-(2+ε)) ≤ |q-α|` AND `0 < |q-α|`

  The new piece: `0 < |q-α|` from Irrational α (ext #148).

  Single derivation:
  1. `T5_irrational_quadratic_roth_bound`: composes s146 + s148.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #149 — Irrational + Quadratic Roth NON-VACUOUS bound.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos

/-! ## Irrational + Quadratic Roth NON-VACUOUS bound -/

/-- **🚨 Wave T5 session 559wwwwwwww — Irrational + Quadratic Roth NON-VACUOUS**.

    For α Irrational + IsQuadraticAlgebraic α + ε > 0:
    ∃ C, p, 0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0 ∧
    ∀ q close to α with eval₂ ≠ 0:
      `0 < C · q.den^(-(2+ε)) ≤ |q-α|` AND `0 < |q-α|`. -/
theorem T5_irrational_quadratic_roth_bound
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, h_bound⟩ :=
    T5_quadratic_roth_positive_tight α h_quad ε hε
  refine ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  obtain ⟨h_lhs_pos, h_le⟩ := h_bound q h_close h_nonzero
  refine ⟨h_lhs_pos, h_le, ?_⟩
  exact T5_irrational_q_dist_pos α hα q

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559wwwwwwww — T-5 Phase 7 ext #149**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #149.

    🏆 NON-VACUOUS ROTH BOUND — Irrational + IsQuadraticAlgebraic.

    Single derivation:
    1. `T5_irrational_quadratic_roth_bound` — non-vacuous form.

    Strategy: composes ext #146 (positive tight) + ext #148 (irrational
    gives |q - α| > 0).

    The Roth-form bound `0 < C · q.den^(-(2+ε)) ≤ |q-α|` is now PROVABLY
    non-vacuous (RHS strictly positive).

    Sub-lemma 322/N. Lean-core only. -/
theorem session_559wwwwwwww_T5_phase7_irrational_quadratic_roth_bound_headline
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quadratic_roth_bound α hα h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQuadraticRothBound
