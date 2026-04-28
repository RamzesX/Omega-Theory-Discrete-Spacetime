/-
  T-5 Phase 7 ext — Roth for √79.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt79

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_seventynine :
    RothBoundExists (Real.sqrt 79) := by
  have h_prime : Nat.Prime 79 := by decide
  have h_eq : Real.sqrt 79 = Real.sqrt ((79 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 79 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt79
