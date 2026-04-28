/-
  T-5 Phase 7 ext — Roth for √107.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt107

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_onehundredseven :
    RothBoundExists (Real.sqrt 107) := by
  have h_prime : Nat.Prime 107 := by decide
  have h_eq : Real.sqrt 107 = Real.sqrt ((107 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 107 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt107
