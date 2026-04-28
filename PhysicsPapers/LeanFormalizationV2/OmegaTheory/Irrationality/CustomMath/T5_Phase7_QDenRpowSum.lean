/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowSum

  T-5 (Roth's theorem) — **Phase 7 ext #160: q.den^(a+b) = q.den^a · q.den^b
  (cubic+ chain rpow algebra)**, sub session 559hhhhhhhhh —
  STRICT critical-path #316 (T-5) Phase 7 ext #160.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real.rpow exponent additivity for q.den:

  For q : ℚ and a, b : ℝ:
    `(q.den : ℝ)^(a + b) = (q.den : ℝ)^a * (q.den : ℝ)^b`

  Specialization for `q.den^(2 + ε) = q.den^2 · q.den^ε`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #160 — q.den^(a+b) factorization.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowSum

/-! ## q.den^(a+b) factorization -/

/-- **🚨 Wave T5 session 559hhhhhhhhh — `q.den^(a+b) = q.den^a · q.den^b`**. -/
theorem T5_qden_rpow_add (q : ℚ) (a b : ℝ) :
    ((q.den : ℝ)) ^ (a + b) = ((q.den : ℝ)) ^ a * ((q.den : ℝ)) ^ b := by
  have hq_pos : (0 : ℝ) < (q.den : ℝ) := by exact_mod_cast q.pos
  exact Real.rpow_add hq_pos a b

/-- Companion: specialization to `q.den^(2 + ε) = q.den^2 · q.den^ε`. -/
theorem T5_qden_rpow_two_plus_eps (q : ℚ) (ε : ℝ) :
    ((q.den : ℝ)) ^ (2 + ε) = ((q.den : ℝ)) ^ (2 : ℝ) * ((q.den : ℝ)) ^ ε :=
  T5_qden_rpow_add q 2 ε

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hhhhhhhhh — T-5 Phase 7 ext #160**.

    🏆 BOOKKEEPING — q.den^(a+b) = q.den^a · q.den^b (Real.rpow_add).

    Sub-lemma 333/N. Lean-core only. -/
theorem session_559hhhhhhhhh_T5_phase7_qden_rpow_sum_headline
    (q : ℚ) (a b : ℝ) :
    ((q.den : ℝ)) ^ (a + b) = ((q.den : ℝ)) ^ a * ((q.den : ℝ)) ^ b :=
  T5_qden_rpow_add q a b

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowSum
