/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRealPos

  T-5 (Roth's theorem) — **Phase 7 ext #120: q.den real-positivity
  helpers `(1 : ℝ) ≤ (q.den : ℝ)` (cubic+ chain bookkeeping)**, sub
  session 559ttttttt — STRICT critical-path #316 (T-5) Phase 7 ext #120.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real-cast positivity bookkeeping for q.den:

  For q : ℚ:
    `(1 : ℝ) ≤ (q.den : ℝ)`
    `(0 : ℝ) < (q.den : ℝ)`
    `(0 : ℝ) ≤ (q.den : ℝ)`

  Cast bookkeeping for repeated use throughout cubic+ chain.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #120 — q.den real-positivity bookkeeping.
-/

import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRealPos

/-! ## q.den real-positivity helpers -/

/-- **🚨 Wave T5 session 559ttttttt — `(1 : ℝ) ≤ (q.den : ℝ)`**.

    For q : ℚ. Direct from `q.pos`. -/
theorem T5_qden_real_one_le (q : ℚ) :
    (1 : ℝ) ≤ (q.den : ℝ) := by
  exact_mod_cast q.pos

/-- Companion: `(0 : ℝ) < (q.den : ℝ)`. -/
theorem T5_qden_real_pos (q : ℚ) :
    (0 : ℝ) < (q.den : ℝ) := by
  exact_mod_cast q.pos

/-- Companion: `(0 : ℝ) ≤ (q.den : ℝ)`. -/
theorem T5_qden_real_nn (q : ℚ) :
    (0 : ℝ) ≤ (q.den : ℝ) :=
  le_of_lt (T5_qden_real_pos q)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ttttttt — T-5 Phase 7 ext #120**.

    🏆 BOOKKEEPING — q.den real-positivity (3-conjunct).

    Sub-lemma 293/N. Lean-core only. -/
theorem session_559ttttttt_T5_phase7_qden_real_pos_headline (q : ℚ) :
    (1 : ℝ) ≤ (q.den : ℝ) ∧
    (0 : ℝ) < (q.den : ℝ) ∧
    (0 : ℝ) ≤ (q.den : ℝ) :=
  ⟨T5_qden_real_one_le q, T5_qden_real_pos q, T5_qden_real_nn q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRealPos
