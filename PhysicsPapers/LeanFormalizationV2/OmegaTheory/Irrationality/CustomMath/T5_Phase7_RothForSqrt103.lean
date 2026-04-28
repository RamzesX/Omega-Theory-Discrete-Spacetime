/-
  T-5 Phase 7 ext — Roth for √103.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt103

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_onehundredthree :
    RothBoundExists (Real.sqrt 103) := by
  have h_prime : Nat.Prime 103 := by decide
  have h_eq : Real.sqrt 103 = Real.sqrt ((103 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 103 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt103
