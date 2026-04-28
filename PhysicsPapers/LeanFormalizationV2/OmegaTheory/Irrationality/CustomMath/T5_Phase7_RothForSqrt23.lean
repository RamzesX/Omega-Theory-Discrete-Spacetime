/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt23

  T-5 Phase 7 ext #73 — Roth for √23 (s559nnnnn).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt23

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_twentythree :
    RothBoundExists (Real.sqrt 23) := by
  have h_prime : Nat.Prime 23 := by decide
  have h_eq : Real.sqrt 23 = Real.sqrt ((23 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 23 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt23
