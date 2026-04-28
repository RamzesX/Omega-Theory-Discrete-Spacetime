/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt19

  T-5 (Roth's theorem) — **Phase 7 ext #72: CONCRETE WITNESS — Roth
  for `√19` (UNCONDITIONAL via ext #46 prime discharge)**, sub session
  559mmmmm — STRICT critical-path #316 (T-5) Phase 7 ext #72.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #72 — concrete witness Roth for √19.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt19

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## Concrete witness via ext #46 generic prime -/

/-- **🚨 Wave T5 session 559mmmmm — UNCONDITIONAL Roth for `√19`**. -/
theorem T5_roth_for_sqrt_nineteen :
    RothBoundExists (Real.sqrt 19) := by
  have h_prime : Nat.Prime 19 := by decide
  have h_eq : Real.sqrt 19 = Real.sqrt ((19 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 19 h_prime

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mmmmm — T-5 Phase 7 ext #72:
    UNCONDITIONAL Roth for `√19`**. Lean-core only.

    Sub-lemma 265/N in T-1 (T-5 Phase 7 ext #72). -/
theorem session_559mmmmm_T5_phase7_roth_for_sqrt_nineteen_headline :
    RothBoundExists (Real.sqrt 19) :=
  T5_roth_for_sqrt_nineteen

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt19
