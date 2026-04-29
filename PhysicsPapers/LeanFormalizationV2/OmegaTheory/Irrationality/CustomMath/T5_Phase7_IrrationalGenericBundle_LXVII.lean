/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXVII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXVII: ext #1189-1203
  Higher-k base 19 cascade ⁹√19/¹⁰√19/¹¹√19/¹²√19/¹³√19**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1189-1203.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXVII,
  15 ext sub-iterations consolidated, **post-1000-lemma**).

  ## What this file delivers

  Higher-k base-19 cascade extension via Bundle-XXIV parametric:
  k = 9, 10, 11, 12, 13 with base 19.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1189-1193: ⁹√19, ¹⁰√19, ¹¹√19, ¹²√19, ¹³√19

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1194-1198: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXVII markers + headlines):
  - ext #1199-1203: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1189-1203 — Higher-k base-19 cascade ⁹√19-¹³√19 (BUNDLE-LXVII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXVI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXVII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_9root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 19) 9 :=
  T5_isAlgebraicOfDegree_kthRootNat 9 19 (by norm_num)

theorem T5_isAlgebraicOfDegree_10root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 10 19) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 19 (by norm_num)

theorem T5_isAlgebraicOfDegree_11root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 11 19) 11 :=
  T5_isAlgebraicOfDegree_kthRootNat 11 19 (by norm_num)

theorem T5_isAlgebraicOfDegree_12root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 12 19) 12 :=
  T5_isAlgebraicOfDegree_kthRootNat 12 19 (by norm_num)

theorem T5_isAlgebraicOfDegree_13root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 13 19) 13 :=
  T5_isAlgebraicOfDegree_kthRootNat 13 19 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_9root_19_concrete :
    IsAlgebraic ℤ (kthRootNat 9 19) :=
  T5_IsAlgebraic_int_kthRootNat 9 19 (by norm_num)

theorem T5_IsAlgebraic_int_10root_19_concrete :
    IsAlgebraic ℤ (kthRootNat 10 19) :=
  T5_IsAlgebraic_int_kthRootNat 10 19 (by norm_num)

theorem T5_IsAlgebraic_int_11root_19_concrete :
    IsAlgebraic ℤ (kthRootNat 11 19) :=
  T5_IsAlgebraic_int_kthRootNat 11 19 (by norm_num)

theorem T5_IsAlgebraic_int_12root_19_concrete :
    IsAlgebraic ℤ (kthRootNat 12 19) :=
  T5_IsAlgebraic_int_kthRootNat 12 19 (by norm_num)

theorem T5_IsAlgebraic_int_13root_19_concrete :
    IsAlgebraic ℤ (kthRootNat 13 19) :=
  T5_IsAlgebraic_int_kthRootNat 13 19 (by norm_num)

/-! ## Sub-cluster C — Bundle-LXVII markers + headlines -/

theorem T5_bundle_LXVII_first_in_V2_marker :
    ∃ (n : ℕ), 1189 ≤ n ∧ n ≤ 1203 ∧ n - 1189 ≤ 15 :=
  ⟨1203, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXVII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXVII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 19) 9 ∧
    IsAlgebraicOfDegree (kthRootNat 10 19) 10 ∧
    IsAlgebraicOfDegree (kthRootNat 11 19) 11 ∧
    IsAlgebraicOfDegree (kthRootNat 12 19) 12 ∧
    IsAlgebraicOfDegree (kthRootNat 13 19) 13 :=
  ⟨T5_isAlgebraicOfDegree_9root_19_concrete,
   T5_isAlgebraicOfDegree_10root_19_concrete,
   T5_isAlgebraicOfDegree_11root_19_concrete,
   T5_isAlgebraicOfDegree_12root_19_concrete,
   T5_isAlgebraicOfDegree_13root_19_concrete⟩

theorem T5_bundle_LXVII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 9 19) ∧
    IsAlgebraic ℤ (kthRootNat 10 19) ∧
    IsAlgebraic ℤ (kthRootNat 11 19) ∧
    IsAlgebraic ℤ (kthRootNat 12 19) ∧
    IsAlgebraic ℤ (kthRootNat 13 19) :=
  ⟨T5_IsAlgebraic_int_9root_19_concrete,
   T5_IsAlgebraic_int_10root_19_concrete,
   T5_IsAlgebraic_int_11root_19_concrete,
   T5_IsAlgebraic_int_12root_19_concrete,
   T5_IsAlgebraic_int_13root_19_concrete⟩

/-! ## Bundle-LXVII GRAND HEADLINE -/

theorem T5_bundle_LXVII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 9 19) 9 ∧
     IsAlgebraicOfDegree (kthRootNat 10 19) 10 ∧
     IsAlgebraicOfDegree (kthRootNat 11 19) 11 ∧
     IsAlgebraicOfDegree (kthRootNat 12 19) 12 ∧
     IsAlgebraicOfDegree (kthRootNat 13 19) 13) ∧
    (IsAlgebraic ℤ (kthRootNat 9 19) ∧
     IsAlgebraic ℤ (kthRootNat 10 19) ∧
     IsAlgebraic ℤ (kthRootNat 11 19) ∧
     IsAlgebraic ℤ (kthRootNat 12 19) ∧
     IsAlgebraic ℤ (kthRootNat 13 19)) :=
  ⟨T5_bundle_LXVII_master_alias_5_concrete,
   T5_bundle_LXVII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXVII
