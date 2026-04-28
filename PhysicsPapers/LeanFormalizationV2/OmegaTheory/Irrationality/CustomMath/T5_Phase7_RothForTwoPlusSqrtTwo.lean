/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPlusSqrtTwo

  T-5 (Roth's theorem) — **Phase 7 ext #68: CONCRETE WITNESS — Roth
  for `2 + √2` (UNCONDITIONAL via s57 generic n+√m discharge)**, sub
  session 559iiiii — STRICT critical-path #316 (T-5) Phase 7 ext #68.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Concrete UNCONDITIONAL Roth witness for α = 2 + √2 via direct
  application of ext #57 generic `n + √m` family theorem.

  Single derivation:
  1. `T5_roth_for_two_plus_sqrt_two`: RothBoundExists (2 + √2)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #68 — concrete witness Roth for `2 + √2`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntPlusSqrt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPlusSqrtTwo

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntPlusSqrt
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## Concrete witness via s57 generic -/

unseal Nat.sqrt.iter in
/-- **🚨 Wave T5 session 559iiiii — UNCONDITIONAL Roth for `2 + √2`**.

    Direct specialization of ext #57 `T5_roth_for_int_plus_sqrt_nonsquare`
    with n = 2, m = 2 (since 2 is non-square as a natural). -/
theorem T5_roth_for_two_plus_sqrt_two :
    RothBoundExists ((2 : ℝ) + Real.sqrt 2) := by
  have h2 : ¬IsSquare (2 : ℕ) := by decide
  have h_eq : ((2 : ℝ) + Real.sqrt 2) =
              ((2 : ℤ) : ℝ) + Real.sqrt ((2 : ℕ) : ℝ) := by
    push_cast; ring
  rw [h_eq]
  exact T5_roth_for_int_plus_sqrt_nonsquare 2 2 h2

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559iiiii — T-5 Phase 7 ext #68:
    UNCONDITIONAL Roth for `2 + √2`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #68.

    🏆 Concrete instance via ext #57 generic n+√m discharge.

    Mathlib usage: pure composition over ext #57.

    Sub-lemma 261/N in T-1 (T-5 Phase 7 ext #68).  Lean-core only. -/
theorem session_559iiiii_T5_phase7_roth_for_two_plus_sqrt_two_headline :
    RothBoundExists ((2 : ℝ) + Real.sqrt 2) :=
  T5_roth_for_two_plus_sqrt_two

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPlusSqrtTwo
