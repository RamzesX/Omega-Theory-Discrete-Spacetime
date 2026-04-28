/-
  T-5 Phase 7 ext — Roth for √53 (s559uuuuu).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt53

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_fiftythree :
    RothBoundExists (Real.sqrt 53) := by
  have h_prime : Nat.Prime 53 := by decide
  have h_eq : Real.sqrt 53 = Real.sqrt ((53 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 53 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt53
