/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos

  T-5 (Roth's theorem) — **Phase 7 ext #148: Irrational α gives
  `|q - α| > 0` for any q : ℚ (cubic+ chain bookkeeping)**, sub session
  559vvvvvvvv — STRICT critical-path #316 (T-5) Phase 7 ext #148.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Strict positivity of |q - α| for irrational α:

  For α : ℝ irrational, q : ℚ:
    `|((q : ℚ) : ℝ) - α| > 0`

  Used to ensure the Roth-form bound is non-vacuous: the LHS
  `C · q.den^(-(2+ε))` is bounded above by a strictly positive
  quantity `|q - α|`.

  Strategy: `Irrational α := ¬∃ q : ℚ, ↑q = α`, so for any q : ℚ,
  `(q : ℝ) ≠ α`, hence `|q - α| > 0`.

  Single derivation:
  1. `T5_irrational_q_dist_pos`: `|q - α| > 0` for irrational α.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #148 — Irrational α gives strict |q - α| > 0.
-/

import Mathlib.NumberTheory.Real.Irrational

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos

/-! ## |q - α| > 0 for irrational α -/

/-- **🚨 Wave T5 session 559vvvvvvvv — `|q - α| > 0` for irrational α**.

    For α : ℝ irrational, q : ℚ. -/
theorem T5_irrational_q_dist_pos (α : ℝ) (hα : Irrational α) (q : ℚ) :
    (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have h_ne : ((q : ℚ) : ℝ) ≠ α := by
    intro h_eq
    apply hα
    exact ⟨q, h_eq⟩
  rw [abs_pos]
  exact sub_ne_zero.mpr h_ne

/-- Companion: same with reversed sign — `|α - q| > 0`. -/
theorem T5_irrational_alpha_q_dist_pos (α : ℝ) (hα : Irrational α) (q : ℚ) :
    (0 : ℝ) < |α - ((q : ℚ) : ℝ)| := by
  rw [abs_sub_comm]
  exact T5_irrational_q_dist_pos α hα q

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559vvvvvvvv — T-5 Phase 7 ext #148**.

    🏆 BOOKKEEPING — `|q - α| > 0` for irrational α (NEVER vacuous).

    Two derivations:
    1. `T5_irrational_q_dist_pos` — `|q - α| > 0`.
    2. `T5_irrational_alpha_q_dist_pos` — `|α - q| > 0`.

    Strategy: Irrational α → (q : ℝ) ≠ α → q - α ≠ 0 → |q - α| > 0.

    Used in cubic+ chain to ensure Roth-form bound `|q - α| ≥ C · q.den^e`
    has a strictly positive RHS (the bound is non-vacuous).

    Sub-lemma 321/N. Lean-core only. -/
theorem session_559vvvvvvvv_T5_phase7_irrational_q_dist_pos_headline
    (α : ℝ) (hα : Irrational α) (q : ℚ) :
    (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧ (0 : ℝ) < |α - ((q : ℚ) : ℝ)| :=
  ⟨T5_irrational_q_dist_pos α hα q, T5_irrational_alpha_q_dist_pos α hα q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
