/-
  T-5 Phase 7 ext — Roth for √73.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt73

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_seventythree :
    RothBoundExists (Real.sqrt 73) := by
  have h_prime : Nat.Prime 73 := by decide
  have h_eq : Real.sqrt 73 = Real.sqrt ((73 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 73 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt73
