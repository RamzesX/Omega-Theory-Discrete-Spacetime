/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

  T-5 (Roth's theorem) — **Phase 7 ext #118: Roth constant positivity
  `M > 0 → M^e > 0` (cubic+ chain bookkeeping)**, sub session
  559rrrrrrr — STRICT critical-path #316 (T-5) Phase 7 ext #118.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real.rpow positivity bookkeeping:

  For M > 0 and any real exponent e: `M^e > 0`.

  Used in cubic+ chain to show the Roth constant `C = M^(-1/k)` is
  strictly positive, allowing it to be packaged as the existential
  `∃ C > 0, …`.

  Single derivation:
  1. `T5_roth_constant_positivity`: `M^e > 0` for M > 0.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #118 — Roth constant positivity.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

/-! ## Roth constant positivity -/

/-- **🚨 Wave T5 session 559rrrrrrr — Roth constant `M^e > 0` for M > 0**.

    For M > 0 and any real exponent e: `M^e > 0`. Mathlib direct. -/
theorem T5_roth_constant_positivity (M : ℝ) (hM : 0 < M) (e : ℝ) :
    0 < M ^ e :=
  Real.rpow_pos_of_pos hM e

/-- Companion: explicit form `0 < M^(-(1/(k:ℝ)))` for the Roth constant
    `C = M^(-1/k)`. -/
theorem T5_roth_constant_neg_inv_k_pos (M : ℝ) (hM : 0 < M) (k : ℕ) :
    0 < M ^ (-(1 / (k : ℝ))) :=
  Real.rpow_pos_of_pos hM _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559rrrrrrr — T-5 Phase 7 ext #118:
    Roth constant positivity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #118.

    🏆 BOOKKEEPING — Real.rpow positivity for Roth constant.

    Two derivations:
    1. `T5_roth_constant_positivity`        — generic `M^e > 0`.
    2. `T5_roth_constant_neg_inv_k_pos`     — specialized for `M^(-1/k)`.

    Strategy: `Real.rpow_pos_of_pos` is direct.

    Used in cubic+ chain to package the Roth constant `C = M^(-1/k)`
    as a strictly-positive existential `∃ C > 0, …`.

    Mathlib usage: `Real.rpow_pos_of_pos`.

    Sub-lemma 291/N in T-1 (T-5 Phase 7 ext #118).  Lean-core only. -/
theorem session_559rrrrrrr_T5_phase7_roth_constant_positivity_headline
    (M : ℝ) (hM : 0 < M) (e : ℝ) :
    0 < M ^ e :=
  T5_roth_constant_positivity M hM e

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity
