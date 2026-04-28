/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt29

  T-5 Phase 7 ext #74 — Roth for √29 (s559ooooo).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt29

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

theorem T5_roth_for_sqrt_twentynine :
    RothBoundExists (Real.sqrt 29) := by
  have h_prime : Nat.Prime 29 := by decide
  have h_eq : Real.sqrt 29 = Real.sqrt ((29 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_prime 29 h_prime

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt29
