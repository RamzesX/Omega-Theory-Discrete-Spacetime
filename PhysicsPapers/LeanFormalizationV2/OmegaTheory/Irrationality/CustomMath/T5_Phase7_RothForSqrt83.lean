/-
  T-5 Phase 7 ext — Roth for √83.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt83

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_eightythree :
    RothBoundExists (Real.sqrt 83) := by
  have h_prime : Nat.Prime 83 := by decide
  have h_eq : Real.sqrt 83 = Real.sqrt ((83 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 83 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt83
