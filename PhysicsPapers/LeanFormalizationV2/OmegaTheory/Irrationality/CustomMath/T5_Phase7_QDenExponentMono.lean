/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

  T-5 (Roth's theorem) — **Phase 7 ext #111: q.den exponent monotonicity
  `q.den^a ≤ q.den^b` for a ≤ b (cubic+ chain Real.rpow monotonicity)**,
  sub session 559kkkkkkk — STRICT critical-path #316 (T-5) Phase 7 ext #111.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real-power monotonicity in the exponent for q.den ≥ 1:

  For q : ℚ (so q.den ≥ 1) and a, b : ℝ with a ≤ b:
    `(q.den : ℝ)^a ≤ (q.den : ℝ)^b`

  This is the bookkeeping step that converts `d/k ≤ 2+ε` (Roth budget)
  into the Roth-form inequality `q.den^(-(2+ε)) ≤ q.den^(-d/k)`.

  Single derivation:
  1. `T5_qden_rpow_mono`: `q.den^a ≤ q.den^b` for a ≤ b (q.den ≥ 1).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #111 — q.den exponent monotonicity.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

/-! ## q.den exponent monotonicity -/

/-- **🚨 Wave T5 session 559kkkkkkk — q.den^a ≤ q.den^b for a ≤ b**.

    For q : ℚ (so q.den ≥ 1) and a ≤ b in ℝ: `q.den^a ≤ q.den^b`. -/
theorem T5_qden_rpow_mono (q : ℚ) (a b : ℝ) (h : a ≤ b) :
    ((q.den : ℝ)) ^ a ≤ ((q.den : ℝ)) ^ b := by
  have hqden_one : (1 : ℝ) ≤ (q.den : ℝ) := by exact_mod_cast q.pos
  exact Real.rpow_le_rpow_of_exponent_le hqden_one h

/-- Companion: strict version. For q.den > 1 (e.g., q.den ≥ 2) and a < b:
    `q.den^a < q.den^b`. -/
theorem T5_qden_rpow_strictMono (q : ℚ) (hq : 1 < (q.den : ℝ)) (a b : ℝ) (h : a < b) :
    ((q.den : ℝ)) ^ a < ((q.den : ℝ)) ^ b :=
  Real.rpow_lt_rpow_of_exponent_lt hq h

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559kkkkkkk — T-5 Phase 7 ext #111:
    q.den exponent monotonicity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #111.

    🏆 BOOKKEEPING — Real.rpow monotonicity for q.den ≥ 1.

    Two derivations:
    1. `T5_qden_rpow_mono`        — `q.den^a ≤ q.den^b` for a ≤ b.
    2. `T5_qden_rpow_strictMono`  — strict version for q.den > 1.

    Strategy: `Real.rpow_le_rpow_of_exponent_le` requires base ≥ 1;
    `q.pos` gives `q.den ≥ 1` after cast.

    Used in cubic+ chain to convert `d/k ≤ 2+ε` (Roth budget) into
    `q.den^(-(2+ε)) ≤ q.den^(-d/k)`, the Roth-form denominator
    relation.

    Mathlib usage: `Real.rpow_le_rpow_of_exponent_le`,
    `Real.rpow_lt_rpow_of_exponent_lt`, `q.pos`.

    Sub-lemma 284/N in T-1 (T-5 Phase 7 ext #111).  Lean-core only. -/
theorem session_559kkkkkkk_T5_phase7_qden_rpow_mono_headline
    (q : ℚ) (a b : ℝ) (h : a ≤ b) :
    ((q.den : ℝ)) ^ a ≤ ((q.den : ℝ)) ^ b :=
  T5_qden_rpow_mono q a b h

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono
