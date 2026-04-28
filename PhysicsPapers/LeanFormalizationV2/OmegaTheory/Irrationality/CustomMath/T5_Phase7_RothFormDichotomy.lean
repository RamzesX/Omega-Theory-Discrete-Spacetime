/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormDichotomy

  T-5 (Roth's theorem) — **Phase 7 ext #157: Roth-form dichotomy
  close-or-far (cubic+ chain pigeonhole)**, sub session 559eeeeeeeee
  — STRICT critical-path #316 (T-5) Phase 7 ext #157.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Dichotomy lemma for ANY q : ℚ:
  - Either `|q - α| ≤ 1` (close case — needs Roth bound from existing chain)
  - Or `|q - α| > 1` (far case — trivially bounded via ext #156)

  Combined: for q in the FAR case, the Roth-form bound holds
  unconditionally (without needing eval₂ ≠ 0 hypothesis).

  Single derivation:
  1. `T5_roth_form_dichotomy_far_case`: full handling of far q.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #157 — Roth-form dichotomy close-or-far.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormDichotomy

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound

/-! ## Roth-form dichotomy -/

/-- **🚨 Wave T5 session 559eeeeeeeee — Roth-form dichotomy**.

    For any q : ℚ:
    - If `|q - α| > 1`: Roth-form bound holds unconditionally
    - Else (close case): need additional infrastructure (existing chain)

    This file ships the FAR case (close case is in s149/s151). -/
theorem T5_roth_form_dichotomy_far_case
    (C : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1)
    (q : ℚ) (α : ℝ) (h_far : 1 < |((q : ℚ) : ℝ) - α|)
    (ε : ℝ) (hε : 0 < ε) :
    C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_form_far_bound C hC_pos hC_le q α h_far ε hε

/-- Trichotomy via classical case analysis: `|q - α| > 1 ∨ |q - α| ≤ 1`. -/
theorem T5_roth_form_dichotomy_split (q : ℚ) (α : ℝ) :
    (1 < |((q : ℚ) : ℝ) - α|) ∨ (|((q : ℚ) : ℝ) - α| ≤ 1) := by
  by_cases h : |((q : ℚ) : ℝ) - α| ≤ 1
  · exact Or.inr h
  · exact Or.inl (lt_of_not_ge h)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559eeeeeeeee — T-5 Phase 7 ext #157**.

    🏆 BOOKKEEPING — Roth-form dichotomy close-or-far.

    Two derivations:
    1. `T5_roth_form_dichotomy_far_case` — far case handled.
    2. `T5_roth_form_dichotomy_split` — classical case split.

    Used to extend Roth-form bound from "q close to α" cases to ALL q : ℚ.
    For q far from α, bound is trivial; for q close, existing chain applies.

    Sub-lemma 330/N. Lean-core only. -/
theorem session_559eeeeeeeee_T5_phase7_roth_form_dichotomy_headline
    (C : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1)
    (q : ℚ) (α : ℝ) (h_far : 1 < |((q : ℚ) : ℝ) - α|)
    (ε : ℝ) (hε : 0 < ε) :
    C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_form_dichotomy_far_case C hC_pos hC_le q α h_far ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormDichotomy
