/-
  T-5 Phase 7 ext — Roth for √97.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt97

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_ninetyseven :
    RothBoundExists (Real.sqrt 97) := by
  have h_prime : Nat.Prime 97 := by decide
  have h_eq : Real.sqrt 97 = Real.sqrt ((97 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 97 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt97
