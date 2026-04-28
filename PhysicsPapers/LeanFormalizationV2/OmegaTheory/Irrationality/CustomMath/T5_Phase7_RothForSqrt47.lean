/-
  T-5 Phase 7 ext — Roth for √47 (s559ttttt).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt47

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_fortyseven :
    RothBoundExists (Real.sqrt 47) := by
  have h_prime : Nat.Prime 47 := by decide
  have h_eq : Real.sqrt 47 = Real.sqrt ((47 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 47 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt47
