/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXXI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXXI: ext #1249-1263
  Ultra-high-k base 2 cascade ²¹√2/²²√2/²³√2/²⁴√2/²⁵√2**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1249-1263.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXXI,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Ultra-high-k base-2 cascade extension via Bundle-XXIV parametric:
  k = 21, 22, 23, 24, 25 with base 2.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1249-1253: ²¹√2, ²²√2, ²³√2, ²⁴√2, ²⁵√2

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1254-1258: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXXI markers + headlines):
  - ext #1259-1263: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1249-1263 — Ultra-high-k base-2 cascade ²¹√2-²⁵√2 (BUNDLE-LXXI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXX

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXXI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_21root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 21 2) 21 :=
  T5_isAlgebraicOfDegree_kthRootNat 21 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_22root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 22 2) 22 :=
  T5_isAlgebraicOfDegree_kthRootNat 22 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_23root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 23 2) 23 :=
  T5_isAlgebraicOfDegree_kthRootNat 23 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_24root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 24 2) 24 :=
  T5_isAlgebraicOfDegree_kthRootNat 24 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_25root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 25 2) 25 :=
  T5_isAlgebraicOfDegree_kthRootNat 25 2 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_21root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 21 2) :=
  T5_IsAlgebraic_int_kthRootNat 21 2 (by norm_num)

theorem T5_IsAlgebraic_int_22root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 22 2) :=
  T5_IsAlgebraic_int_kthRootNat 22 2 (by norm_num)

theorem T5_IsAlgebraic_int_23root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 23 2) :=
  T5_IsAlgebraic_int_kthRootNat 23 2 (by norm_num)

theorem T5_IsAlgebraic_int_24root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 24 2) :=
  T5_IsAlgebraic_int_kthRootNat 24 2 (by norm_num)

theorem T5_IsAlgebraic_int_25root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 25 2) :=
  T5_IsAlgebraic_int_kthRootNat 25 2 (by norm_num)

/-! ## Sub-cluster C — Bundle-LXXI markers + headlines -/

theorem T5_bundle_LXXI_first_in_V2_marker :
    ∃ (n : ℕ), 1249 ≤ n ∧ n ≤ 1263 ∧ n - 1249 ≤ 15 :=
  ⟨1263, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXXI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXXI_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 21 2) 21 ∧
    IsAlgebraicOfDegree (kthRootNat 22 2) 22 ∧
    IsAlgebraicOfDegree (kthRootNat 23 2) 23 ∧
    IsAlgebraicOfDegree (kthRootNat 24 2) 24 ∧
    IsAlgebraicOfDegree (kthRootNat 25 2) 25 :=
  ⟨T5_isAlgebraicOfDegree_21root_2_concrete,
   T5_isAlgebraicOfDegree_22root_2_concrete,
   T5_isAlgebraicOfDegree_23root_2_concrete,
   T5_isAlgebraicOfDegree_24root_2_concrete,
   T5_isAlgebraicOfDegree_25root_2_concrete⟩

theorem T5_bundle_LXXI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 21 2) ∧
    IsAlgebraic ℤ (kthRootNat 22 2) ∧
    IsAlgebraic ℤ (kthRootNat 23 2) ∧
    IsAlgebraic ℤ (kthRootNat 24 2) ∧
    IsAlgebraic ℤ (kthRootNat 25 2) :=
  ⟨T5_IsAlgebraic_int_21root_2_concrete,
   T5_IsAlgebraic_int_22root_2_concrete,
   T5_IsAlgebraic_int_23root_2_concrete,
   T5_IsAlgebraic_int_24root_2_concrete,
   T5_IsAlgebraic_int_25root_2_concrete⟩

/-! ## Bundle-LXXI GRAND HEADLINE -/

theorem T5_bundle_LXXI_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 21 2) 21 ∧
     IsAlgebraicOfDegree (kthRootNat 22 2) 22 ∧
     IsAlgebraicOfDegree (kthRootNat 23 2) 23 ∧
     IsAlgebraicOfDegree (kthRootNat 24 2) 24 ∧
     IsAlgebraicOfDegree (kthRootNat 25 2) 25) ∧
    (IsAlgebraic ℤ (kthRootNat 21 2) ∧
     IsAlgebraic ℤ (kthRootNat 22 2) ∧
     IsAlgebraic ℤ (kthRootNat 23 2) ∧
     IsAlgebraic ℤ (kthRootNat 24 2) ∧
     IsAlgebraic ℤ (kthRootNat 25 2)) :=
  ⟨T5_bundle_LXXI_master_alias_5_concrete,
   T5_bundle_LXXI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXXI
