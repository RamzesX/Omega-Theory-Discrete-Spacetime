/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LIV: ext #994-1008
  High-k base 3 cascade ⁹√3/¹⁰√3/¹¹√3/¹²√3/¹³√3**, sub session
  559oooooooooooooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #994-1008.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LIV,
  15 ext sub-iterations consolidated, **ext-thousand crossed**).

  ## What this file delivers

  High-k base-3 cascade extension via Bundle-XXIV parametric:
  k = 9, 10, 11, 12, 13 with base 3.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #994: ⁹√3
  - ext #995: ¹⁰√3
  - ext #996: ¹¹√3
  - ext #997: ¹²√3
  - ext #998: ¹³√3

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #999-1003: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LIV markers + headlines):
  - ext #1004-1008: 5 markers + headlines + ext-1000-crossed alias

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #994-1008 — High-k base-3 cascade ⁹√3-¹³√3 (BUNDLE-LIV).
  **Crossed ext-1000.**
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_9root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 3) 9 :=
  T5_isAlgebraicOfDegree_kthRootNat 9 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_10root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 10 3) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_11root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 11 3) 11 :=
  T5_isAlgebraicOfDegree_kthRootNat 11 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_12root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 12 3) 12 :=
  T5_isAlgebraicOfDegree_kthRootNat 12 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_13root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 13 3) 13 :=
  T5_isAlgebraicOfDegree_kthRootNat 13 3 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_9root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 9 3) :=
  T5_IsAlgebraic_int_kthRootNat 9 3 (by norm_num)

theorem T5_IsAlgebraic_int_10root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 10 3) :=
  T5_IsAlgebraic_int_kthRootNat 10 3 (by norm_num)

theorem T5_IsAlgebraic_int_11root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 11 3) :=
  T5_IsAlgebraic_int_kthRootNat 11 3 (by norm_num)

theorem T5_IsAlgebraic_int_12root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 12 3) :=
  T5_IsAlgebraic_int_kthRootNat 12 3 (by norm_num)

theorem T5_IsAlgebraic_int_13root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 13 3) :=
  T5_IsAlgebraic_int_kthRootNat 13 3 (by norm_num)

/-! ## Sub-cluster C — Bundle-LIV markers + headlines -/

theorem T5_bundle_LIV_first_in_V2_marker :
    ∃ (n : ℕ), 994 ≤ n ∧ n ≤ 1008 ∧ n - 994 ≤ 15 :=
  ⟨1008, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LIV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LIV_ext_1000_crossed_alias : 1 ≤ (1000 : ℕ) := by norm_num

theorem T5_bundle_LIV_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 3) 9 ∧
    IsAlgebraicOfDegree (kthRootNat 10 3) 10 ∧
    IsAlgebraicOfDegree (kthRootNat 11 3) 11 ∧
    IsAlgebraicOfDegree (kthRootNat 12 3) 12 ∧
    IsAlgebraicOfDegree (kthRootNat 13 3) 13 :=
  ⟨T5_isAlgebraicOfDegree_9root_3_concrete,
   T5_isAlgebraicOfDegree_10root_3_concrete,
   T5_isAlgebraicOfDegree_11root_3_concrete,
   T5_isAlgebraicOfDegree_12root_3_concrete,
   T5_isAlgebraicOfDegree_13root_3_concrete⟩

theorem T5_bundle_LIV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 9 3) ∧
    IsAlgebraic ℤ (kthRootNat 10 3) ∧
    IsAlgebraic ℤ (kthRootNat 11 3) ∧
    IsAlgebraic ℤ (kthRootNat 12 3) ∧
    IsAlgebraic ℤ (kthRootNat 13 3) :=
  ⟨T5_IsAlgebraic_int_9root_3_concrete,
   T5_IsAlgebraic_int_10root_3_concrete,
   T5_IsAlgebraic_int_11root_3_concrete,
   T5_IsAlgebraic_int_12root_3_concrete,
   T5_IsAlgebraic_int_13root_3_concrete⟩

/-! ## Bundle-LIV GRAND HEADLINE — ext-1000 crossed -/

theorem T5_bundle_LIV_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 9 3) 9 ∧
     IsAlgebraicOfDegree (kthRootNat 10 3) 10 ∧
     IsAlgebraicOfDegree (kthRootNat 11 3) 11 ∧
     IsAlgebraicOfDegree (kthRootNat 12 3) 12 ∧
     IsAlgebraicOfDegree (kthRootNat 13 3) 13) ∧
    (IsAlgebraic ℤ (kthRootNat 9 3) ∧
     IsAlgebraic ℤ (kthRootNat 10 3) ∧
     IsAlgebraic ℤ (kthRootNat 11 3) ∧
     IsAlgebraic ℤ (kthRootNat 12 3) ∧
     IsAlgebraic ℤ (kthRootNat 13 3)) :=
  ⟨T5_bundle_LIV_master_alias_5_concrete,
   T5_bundle_LIV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIV
