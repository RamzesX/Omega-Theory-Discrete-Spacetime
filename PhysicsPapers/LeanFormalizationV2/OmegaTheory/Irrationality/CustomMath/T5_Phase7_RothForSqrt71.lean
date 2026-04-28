/-
  T-5 Phase 7 ext — Roth for √71.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt71

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_seventyone :
    RothBoundExists (Real.sqrt 71) := by
  have h_prime : Nat.Prime 71 := by decide
  have h_eq : Real.sqrt 71 = Real.sqrt ((71 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 71 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt71
