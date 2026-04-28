/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt31

  T-5 Phase 7 ext #75 — Roth for √31 (s559ppppp).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt31

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_thirtyone :
    RothBoundExists (Real.sqrt 31) := by
  have h_prime : Nat.Prime 31 := by decide
  have h_eq : Real.sqrt 31 = Real.sqrt ((31 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 31 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt31
