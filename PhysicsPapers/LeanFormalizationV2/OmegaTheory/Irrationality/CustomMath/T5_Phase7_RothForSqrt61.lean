/-
  T-5 Phase 7 ext — Roth for √61 (s559wwwww).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt61

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_sixtyone :
    RothBoundExists (Real.sqrt 61) := by
  have h_prime : Nat.Prime 61 := by decide
  have h_eq : Real.sqrt 61 = Real.sqrt ((61 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 61 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt61
