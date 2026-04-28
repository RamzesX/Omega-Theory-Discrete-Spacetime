/-
  T-5 Phase 7 ext — Roth for √101.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt101

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_onehundredone :
    RothBoundExists (Real.sqrt 101) := by
  have h_prime : Nat.Prime 101 := by decide
  have h_eq : Real.sqrt 101 = Real.sqrt ((101 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 101 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt101
