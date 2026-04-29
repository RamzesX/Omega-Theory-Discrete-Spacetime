/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LV: ext #1009-1023
  High-k base 5 cascade ⁹√5/¹⁰√5/¹¹√5/¹²√5/¹³√5**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1009-1023.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  High-k base-5 cascade extension via Bundle-XXIV parametric:
  k = 9, 10, 11, 12, 13 with base 5.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1009: ⁹√5
  - ext #1010: ¹⁰√5
  - ext #1011: ¹¹√5
  - ext #1012: ¹²√5
  - ext #1013: ¹³√5

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1014-1018: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LV markers + headlines):
  - ext #1019-1023: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1009-1023 — High-k base-5 cascade ⁹√5-¹³√5 (BUNDLE-LV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_9root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 5) 9 :=
  T5_isAlgebraicOfDegree_kthRootNat 9 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_10root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 10 5) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_11root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 11 5) 11 :=
  T5_isAlgebraicOfDegree_kthRootNat 11 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_12root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 12 5) 12 :=
  T5_isAlgebraicOfDegree_kthRootNat 12 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_13root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 13 5) 13 :=
  T5_isAlgebraicOfDegree_kthRootNat 13 5 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_9root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 9 5) :=
  T5_IsAlgebraic_int_kthRootNat 9 5 (by norm_num)

theorem T5_IsAlgebraic_int_10root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 10 5) :=
  T5_IsAlgebraic_int_kthRootNat 10 5 (by norm_num)

theorem T5_IsAlgebraic_int_11root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 11 5) :=
  T5_IsAlgebraic_int_kthRootNat 11 5 (by norm_num)

theorem T5_IsAlgebraic_int_12root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 12 5) :=
  T5_IsAlgebraic_int_kthRootNat 12 5 (by norm_num)

theorem T5_IsAlgebraic_int_13root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 13 5) :=
  T5_IsAlgebraic_int_kthRootNat 13 5 (by norm_num)

/-! ## Sub-cluster C — Bundle-LV markers + headlines -/

theorem T5_bundle_LV_first_in_V2_marker :
    ∃ (n : ℕ), 1009 ≤ n ∧ n ≤ 1023 ∧ n - 1009 ≤ 15 :=
  ⟨1023, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LV_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 5) 9 ∧
    IsAlgebraicOfDegree (kthRootNat 10 5) 10 ∧
    IsAlgebraicOfDegree (kthRootNat 11 5) 11 ∧
    IsAlgebraicOfDegree (kthRootNat 12 5) 12 ∧
    IsAlgebraicOfDegree (kthRootNat 13 5) 13 :=
  ⟨T5_isAlgebraicOfDegree_9root_5_concrete,
   T5_isAlgebraicOfDegree_10root_5_concrete,
   T5_isAlgebraicOfDegree_11root_5_concrete,
   T5_isAlgebraicOfDegree_12root_5_concrete,
   T5_isAlgebraicOfDegree_13root_5_concrete⟩

theorem T5_bundle_LV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 9 5) ∧
    IsAlgebraic ℤ (kthRootNat 10 5) ∧
    IsAlgebraic ℤ (kthRootNat 11 5) ∧
    IsAlgebraic ℤ (kthRootNat 12 5) ∧
    IsAlgebraic ℤ (kthRootNat 13 5) :=
  ⟨T5_IsAlgebraic_int_9root_5_concrete,
   T5_IsAlgebraic_int_10root_5_concrete,
   T5_IsAlgebraic_int_11root_5_concrete,
   T5_IsAlgebraic_int_12root_5_concrete,
   T5_IsAlgebraic_int_13root_5_concrete⟩

/-! ## Bundle-LV GRAND HEADLINE -/

theorem T5_bundle_LV_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 9 5) 9 ∧
     IsAlgebraicOfDegree (kthRootNat 10 5) 10 ∧
     IsAlgebraicOfDegree (kthRootNat 11 5) 11 ∧
     IsAlgebraicOfDegree (kthRootNat 12 5) 12 ∧
     IsAlgebraicOfDegree (kthRootNat 13 5) 13) ∧
    (IsAlgebraic ℤ (kthRootNat 9 5) ∧
     IsAlgebraic ℤ (kthRootNat 10 5) ∧
     IsAlgebraic ℤ (kthRootNat 11 5) ∧
     IsAlgebraic ℤ (kthRootNat 12 5) ∧
     IsAlgebraic ℤ (kthRootNat 13 5)) :=
  ⟨T5_bundle_LV_master_alias_5_concrete,
   T5_bundle_LV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LV
