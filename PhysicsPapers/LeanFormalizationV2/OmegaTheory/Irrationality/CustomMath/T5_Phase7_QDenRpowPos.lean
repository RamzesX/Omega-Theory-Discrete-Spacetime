/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

  T-5 (Roth's theorem) — **Phase 7 ext #144: q.den^e > 0 for any real e
  (cubic+ chain Real.rpow positivity)**, sub session 559rrrrrrrr —
  STRICT critical-path #316 (T-5) Phase 7 ext #144.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real.rpow positivity for q.den:

  For q : ℚ and e : ℝ:
    `0 < ((q.den : ℝ))^e`

  Used in cubic+ chain when q.den is raised to negative real exponent
  (e.g., `q.den^(-(2+ε))`) — must be strictly positive.

  Single derivation:
  1. `T5_qden_rpow_pos`: `0 < (q.den : ℝ)^e`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #144 — q.den^e positive.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

/-! ## q.den^e positive -/

/-- **🚨 Wave T5 session 559rrrrrrrr — `0 < (q.den : ℝ)^e`**. -/
theorem T5_qden_rpow_pos (q : ℚ) (e : ℝ) : (0 : ℝ) < ((q.den : ℝ)) ^ e := by
  have hq : (0 : ℝ) < (q.den : ℝ) := by exact_mod_cast q.pos
  exact Real.rpow_pos_of_pos hq e

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559rrrrrrrr — T-5 Phase 7 ext #144**.

    🏆 BOOKKEEPING — q.den^e positive (Real.rpow_pos_of_pos).

    Sub-lemma 317/N. Lean-core only. -/
theorem session_559rrrrrrrr_T5_phase7_qden_rpow_pos_headline
    (q : ℚ) (e : ℝ) : (0 : ℝ) < ((q.den : ℝ)) ^ e :=
  T5_qden_rpow_pos q e

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos
