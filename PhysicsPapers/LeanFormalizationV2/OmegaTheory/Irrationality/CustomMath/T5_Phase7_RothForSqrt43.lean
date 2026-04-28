/-
  T-5 Phase 7 ext — Roth for √43 (s559sssss).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt43

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_fortythree :
    RothBoundExists (Real.sqrt 43) := by
  have h_prime : Nat.Prime 43 := by decide
  have h_eq : Real.sqrt 43 = Real.sqrt ((43 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 43 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt43
