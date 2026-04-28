/-
  T-5 Phase 7 ext — Roth for √109.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt109

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_onehundrednine :
    RothBoundExists (Real.sqrt 109) := by
  have h_prime : Nat.Prime 109 := by decide
  have h_eq : Real.sqrt 109 = Real.sqrt ((109 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 109 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt109
