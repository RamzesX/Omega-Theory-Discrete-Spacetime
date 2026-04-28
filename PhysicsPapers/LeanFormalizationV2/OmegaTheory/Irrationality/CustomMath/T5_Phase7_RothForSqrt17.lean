/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt17

  T-5 (Roth's theorem) — **Phase 7 ext #69: CONCRETE WITNESS — Roth
  for `√17` (UNCONDITIONAL via ext #46 prime discharge)**, sub session
  559jjjjj — STRICT critical-path #316 (T-5) Phase 7 ext #69.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Concrete UNCONDITIONAL Roth witness for `√17` via direct application
  of ext #46 generic prime case theorem.

  Single derivation:
  1. `T5_roth_for_sqrt_seventeen`: RothBoundExists √17

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #69 — concrete witness Roth for √17.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt17

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## Concrete witness via ext #46 generic prime -/

/-- **🚨 Wave T5 session 559jjjjj — UNCONDITIONAL Roth for `√17`**.

    Direct specialization of ext #46 `T5_roth_for_sqrt_prime` with p = 17. -/
theorem T5_roth_for_sqrt_seventeen :
    RothBoundExists (Real.sqrt 17) := by
  have h_prime : Nat.Prime 17 := by decide
  have h_eq : Real.sqrt 17 = Real.sqrt ((17 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 17 h_prime

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559jjjjj — T-5 Phase 7 ext #69:
    UNCONDITIONAL Roth for `√17`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #69.

    Concrete instance via ext #46 generic prime discharge.

    Mathlib usage: pure composition over ext #46.

    Sub-lemma 262/N in T-1 (T-5 Phase 7 ext #69).  Lean-core only. -/
theorem session_559jjjjj_T5_phase7_roth_for_sqrt_seventeen_headline :
    RothBoundExists (Real.sqrt 17) :=
  T5_roth_for_sqrt_seventeen

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt17
