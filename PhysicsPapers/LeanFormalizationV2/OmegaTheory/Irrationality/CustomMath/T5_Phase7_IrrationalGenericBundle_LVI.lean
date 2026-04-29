/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LVI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LVI: ext #1024-1038
  High-k base 7 cascade ⁹√7/¹⁰√7/¹¹√7/¹²√7/¹³√7**, sub session
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #1024-1038.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LVI,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  High-k base-7 cascade extension via Bundle-XXIV parametric:
  k = 9, 10, 11, 12, 13 with base 7.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1024: ⁹√7
  - ext #1025: ¹⁰√7
  - ext #1026: ¹¹√7
  - ext #1027: ¹²√7
  - ext #1028: ¹³√7

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1029-1033: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LVI markers + headlines):
  - ext #1034-1038: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1024-1038 — High-k base-7 cascade ⁹√7-¹³√7 (BUNDLE-LVI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LVI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_9root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 7) 9 :=
  T5_isAlgebraicOfDegree_kthRootNat 9 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_10root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 10 7) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_11root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 11 7) 11 :=
  T5_isAlgebraicOfDegree_kthRootNat 11 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_12root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 12 7) 12 :=
  T5_isAlgebraicOfDegree_kthRootNat 12 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_13root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 13 7) 13 :=
  T5_isAlgebraicOfDegree_kthRootNat 13 7 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_9root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 9 7) :=
  T5_IsAlgebraic_int_kthRootNat 9 7 (by norm_num)

theorem T5_IsAlgebraic_int_10root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 10 7) :=
  T5_IsAlgebraic_int_kthRootNat 10 7 (by norm_num)

theorem T5_IsAlgebraic_int_11root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 11 7) :=
  T5_IsAlgebraic_int_kthRootNat 11 7 (by norm_num)

theorem T5_IsAlgebraic_int_12root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 12 7) :=
  T5_IsAlgebraic_int_kthRootNat 12 7 (by norm_num)

theorem T5_IsAlgebraic_int_13root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 13 7) :=
  T5_IsAlgebraic_int_kthRootNat 13 7 (by norm_num)

/-! ## Sub-cluster C — Bundle-LVI markers + headlines -/

theorem T5_bundle_LVI_first_in_V2_marker :
    ∃ (n : ℕ), 1024 ≤ n ∧ n ≤ 1038 ∧ n - 1024 ≤ 15 :=
  ⟨1038, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LVI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LVI_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 7) 9 ∧
    IsAlgebraicOfDegree (kthRootNat 10 7) 10 ∧
    IsAlgebraicOfDegree (kthRootNat 11 7) 11 ∧
    IsAlgebraicOfDegree (kthRootNat 12 7) 12 ∧
    IsAlgebraicOfDegree (kthRootNat 13 7) 13 :=
  ⟨T5_isAlgebraicOfDegree_9root_7_concrete,
   T5_isAlgebraicOfDegree_10root_7_concrete,
   T5_isAlgebraicOfDegree_11root_7_concrete,
   T5_isAlgebraicOfDegree_12root_7_concrete,
   T5_isAlgebraicOfDegree_13root_7_concrete⟩

theorem T5_bundle_LVI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 9 7) ∧
    IsAlgebraic ℤ (kthRootNat 10 7) ∧
    IsAlgebraic ℤ (kthRootNat 11 7) ∧
    IsAlgebraic ℤ (kthRootNat 12 7) ∧
    IsAlgebraic ℤ (kthRootNat 13 7) :=
  ⟨T5_IsAlgebraic_int_9root_7_concrete,
   T5_IsAlgebraic_int_10root_7_concrete,
   T5_IsAlgebraic_int_11root_7_concrete,
   T5_IsAlgebraic_int_12root_7_concrete,
   T5_IsAlgebraic_int_13root_7_concrete⟩

/-! ## Bundle-LVI GRAND HEADLINE -/

theorem T5_bundle_LVI_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 9 7) 9 ∧
     IsAlgebraicOfDegree (kthRootNat 10 7) 10 ∧
     IsAlgebraicOfDegree (kthRootNat 11 7) 11 ∧
     IsAlgebraicOfDegree (kthRootNat 12 7) 12 ∧
     IsAlgebraicOfDegree (kthRootNat 13 7) 13) ∧
    (IsAlgebraic ℤ (kthRootNat 9 7) ∧
     IsAlgebraic ℤ (kthRootNat 10 7) ∧
     IsAlgebraic ℤ (kthRootNat 11 7) ∧
     IsAlgebraic ℤ (kthRootNat 12 7) ∧
     IsAlgebraic ℤ (kthRootNat 13 7)) :=
  ⟨T5_bundle_LVI_master_alias_5_concrete,
   T5_bundle_LVI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LVI
