/-
  T-5 Phase 7 ext — Roth for √59 (s559vvvvv).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt59

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_fiftynine :
    RothBoundExists (Real.sqrt 59) := by
  have h_prime : Nat.Prime 59 := by decide
  have h_eq : Real.sqrt 59 = Real.sqrt ((59 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 59 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt59
