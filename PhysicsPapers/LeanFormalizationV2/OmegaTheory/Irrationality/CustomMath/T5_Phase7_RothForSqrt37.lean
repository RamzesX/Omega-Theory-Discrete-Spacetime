/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt37

  T-5 Phase 7 ext #76 — Roth for √37 (s559qqqqq).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt37

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_thirtyseven :
    RothBoundExists (Real.sqrt 37) := by
  have h_prime : Nat.Prime 37 := by decide
  have h_eq : Real.sqrt 37 = Real.sqrt ((37 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 37 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt37
