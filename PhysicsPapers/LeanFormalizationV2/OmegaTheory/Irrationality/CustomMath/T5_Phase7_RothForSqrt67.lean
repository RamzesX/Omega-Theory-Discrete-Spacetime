/-
  T-5 Phase 7 ext — Roth for √67.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt67

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_sixtyseven :
    RothBoundExists (Real.sqrt 67) := by
  have h_prime : Nat.Prime 67 := by decide
  have h_eq : Real.sqrt 67 = Real.sqrt ((67 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 67 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt67
