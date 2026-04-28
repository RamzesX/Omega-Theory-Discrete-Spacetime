/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt41

  T-5 Phase 7 ext #77 — Roth for √41 (s559rrrrr).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt41

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_fortyone :
    RothBoundExists (Real.sqrt 41) := by
  have h_prime : Nat.Prime 41 := by decide
  have h_eq : Real.sqrt 41 = Real.sqrt ((41 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 41 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt41
