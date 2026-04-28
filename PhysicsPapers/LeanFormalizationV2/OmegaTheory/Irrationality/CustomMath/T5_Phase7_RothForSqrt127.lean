/-
  T-5 Phase 7 ext — Roth for √127.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt127

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_onehundredtwentyseven :
    RothBoundExists (Real.sqrt 127) := by
  have h_prime : Nat.Prime 127 := by decide
  have h_eq : Real.sqrt 127 = Real.sqrt ((127 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 127 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt127
