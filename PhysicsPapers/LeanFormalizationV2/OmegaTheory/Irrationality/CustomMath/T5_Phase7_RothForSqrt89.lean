/-
  T-5 Phase 7 ext — Roth for √89.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt89

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_eightynine :
    RothBoundExists (Real.sqrt 89) := by
  have h_prime : Nat.Prime 89 := by decide
  have h_eq : Real.sqrt 89 = Real.sqrt ((89 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 89 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt89
