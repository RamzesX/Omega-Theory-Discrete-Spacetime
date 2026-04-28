/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenScaleBound

  T-5 (Roth's theorem) — **Phase 7 ext #155: q.den scale bound
  `0 < C · q.den^e ≤ q.den^e` (cubic+ chain bookkeeping)**, sub
  session 559ccccccccc — STRICT critical-path #316 (T-5)
  Phase 7 ext #155.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #154 (positive scale bound) + ext #144 (q.den^e > 0):

  For C ∈ (0, 1], q : ℚ, e : ℝ:
    `0 < C · q.den^e ≤ q.den^e`

  Single derivation:
  1. `T5_qden_scale_bound`: applies positive scale bound to q.den^e.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #155 — q.den scale bound `0 < C · q.den^e ≤ q.den^e`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PositiveScaleBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenScaleBound

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PositiveScaleBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

/-! ## q.den scale bound -/

/-- **🚨 Wave T5 session 559ccccccccc — `0 < C · q.den^e ≤ q.den^e` for C ∈ (0,1]**. -/
theorem T5_qden_scale_bound (C : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1) (q : ℚ) (e : ℝ) :
    0 < C * ((q.den : ℝ)) ^ e ∧ C * ((q.den : ℝ)) ^ e ≤ ((q.den : ℝ)) ^ e :=
  T5_positive_scale_bound C (((q.den : ℝ)) ^ e) hC_pos hC_le (T5_qden_rpow_pos q e)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ccccccccc — T-5 Phase 7 ext #155**.

    🏆 BOOKKEEPING — q.den scale bound for C ∈ (0,1].

    Sub-lemma 328/N. Lean-core only. -/
theorem session_559ccccccccc_T5_phase7_qden_scale_bound_headline
    (C : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1) (q : ℚ) (e : ℝ) :
    0 < C * ((q.den : ℝ)) ^ e ∧ C * ((q.den : ℝ)) ^ e ≤ ((q.den : ℝ)) ^ e :=
  T5_qden_scale_bound C hC_pos hC_le q e

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenScaleBound
