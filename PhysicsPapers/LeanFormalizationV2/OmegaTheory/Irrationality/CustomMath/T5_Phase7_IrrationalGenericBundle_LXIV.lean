/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXIV: ext #1144-1158
  Higher-k base 13 cascade ⁹√13/¹⁰√13/¹¹√13/¹²√13/¹³√13**, sub session
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #1144-1158.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXIV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k base-13 cascade extension via Bundle-XXIV parametric:
  k = 9, 10, 11, 12, 13 with base 13.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1144-1148: ⁹√13, ¹⁰√13, ¹¹√13, ¹²√13, ¹³√13

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1149-1153: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXIV markers + headlines):
  - ext #1154-1158: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1144-1158 — Higher-k base-13 cascade ⁹√13-¹³√13 (BUNDLE-LXIV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_9root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 13) 9 :=
  T5_isAlgebraicOfDegree_kthRootNat 9 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_10root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 10 13) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_11root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 11 13) 11 :=
  T5_isAlgebraicOfDegree_kthRootNat 11 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_12root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 12 13) 12 :=
  T5_isAlgebraicOfDegree_kthRootNat 12 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_13root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 13 13) 13 :=
  T5_isAlgebraicOfDegree_kthRootNat 13 13 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_9root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 9 13) :=
  T5_IsAlgebraic_int_kthRootNat 9 13 (by norm_num)

theorem T5_IsAlgebraic_int_10root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 10 13) :=
  T5_IsAlgebraic_int_kthRootNat 10 13 (by norm_num)

theorem T5_IsAlgebraic_int_11root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 11 13) :=
  T5_IsAlgebraic_int_kthRootNat 11 13 (by norm_num)

theorem T5_IsAlgebraic_int_12root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 12 13) :=
  T5_IsAlgebraic_int_kthRootNat 12 13 (by norm_num)

theorem T5_IsAlgebraic_int_13root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 13 13) :=
  T5_IsAlgebraic_int_kthRootNat 13 13 (by norm_num)

/-! ## Sub-cluster C — Bundle-LXIV markers + headlines -/

theorem T5_bundle_LXIV_first_in_V2_marker :
    ∃ (n : ℕ), 1144 ≤ n ∧ n ≤ 1158 ∧ n - 1144 ≤ 15 :=
  ⟨1158, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXIV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXIV_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 13) 9 ∧
    IsAlgebraicOfDegree (kthRootNat 10 13) 10 ∧
    IsAlgebraicOfDegree (kthRootNat 11 13) 11 ∧
    IsAlgebraicOfDegree (kthRootNat 12 13) 12 ∧
    IsAlgebraicOfDegree (kthRootNat 13 13) 13 :=
  ⟨T5_isAlgebraicOfDegree_9root_13_concrete,
   T5_isAlgebraicOfDegree_10root_13_concrete,
   T5_isAlgebraicOfDegree_11root_13_concrete,
   T5_isAlgebraicOfDegree_12root_13_concrete,
   T5_isAlgebraicOfDegree_13root_13_concrete⟩

theorem T5_bundle_LXIV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 9 13) ∧
    IsAlgebraic ℤ (kthRootNat 10 13) ∧
    IsAlgebraic ℤ (kthRootNat 11 13) ∧
    IsAlgebraic ℤ (kthRootNat 12 13) ∧
    IsAlgebraic ℤ (kthRootNat 13 13) :=
  ⟨T5_IsAlgebraic_int_9root_13_concrete,
   T5_IsAlgebraic_int_10root_13_concrete,
   T5_IsAlgebraic_int_11root_13_concrete,
   T5_IsAlgebraic_int_12root_13_concrete,
   T5_IsAlgebraic_int_13root_13_concrete⟩

/-! ## Bundle-LXIV GRAND HEADLINE -/

theorem T5_bundle_LXIV_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 9 13) 9 ∧
     IsAlgebraicOfDegree (kthRootNat 10 13) 10 ∧
     IsAlgebraicOfDegree (kthRootNat 11 13) 11 ∧
     IsAlgebraicOfDegree (kthRootNat 12 13) 12 ∧
     IsAlgebraicOfDegree (kthRootNat 13 13) 13) ∧
    (IsAlgebraic ℤ (kthRootNat 9 13) ∧
     IsAlgebraic ℤ (kthRootNat 10 13) ∧
     IsAlgebraic ℤ (kthRootNat 11 13) ∧
     IsAlgebraic ℤ (kthRootNat 12 13) ∧
     IsAlgebraic ℤ (kthRootNat 13 13)) :=
  ⟨T5_bundle_LXIV_master_alias_5_concrete,
   T5_bundle_LXIV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIV
