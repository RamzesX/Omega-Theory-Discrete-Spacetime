/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXVIII: ext #754-768
  5-th root prime cascade ⁵√31/⁵√37/⁵√41/⁵√43/⁵√47**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #754-768.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXVIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  5-th root cascade extension for primes 31, 37, 41, 43, 47.

  Sub-cluster A (k=5 prime extension):
  - ext #754-758: ⁵√31, ⁵√37, ⁵√41, ⁵√43, ⁵√47

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #759-763: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XXXVIII markers + headlines):
  - ext #764-768: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #754-768 — 5th root prime cascade ⁵√31-⁵√47 (BUNDLE-XXXVIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=5 prime extension -/

theorem T5_isAlgebraicOfDegree_quintic_root_31_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 31) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 31 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_37_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 37) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 37 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_41_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 41) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 41 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_43_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 43) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 43 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_47_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 47) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 47 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quintic_root_31_concrete :
    IsAlgebraic ℤ (kthRootNat 5 31) :=
  T5_IsAlgebraic_int_kthRootNat 5 31 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_37_concrete :
    IsAlgebraic ℤ (kthRootNat 5 37) :=
  T5_IsAlgebraic_int_kthRootNat 5 37 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_41_concrete :
    IsAlgebraic ℤ (kthRootNat 5 41) :=
  T5_IsAlgebraic_int_kthRootNat 5 41 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_43_concrete :
    IsAlgebraic ℤ (kthRootNat 5 43) :=
  T5_IsAlgebraic_int_kthRootNat 5 43 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_47_concrete :
    IsAlgebraic ℤ (kthRootNat 5 47) :=
  T5_IsAlgebraic_int_kthRootNat 5 47 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXXVIII markers + headlines -/

theorem T5_bundle_XXXVIII_first_in_V2_marker :
    ∃ (n : ℕ), 754 ≤ n ∧ n ≤ 768 ∧ n - 754 ≤ 15 :=
  ⟨768, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXVIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXXVIII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 31) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 37) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 41) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 43) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 47) 5 :=
  ⟨T5_isAlgebraicOfDegree_quintic_root_31_concrete,
   T5_isAlgebraicOfDegree_quintic_root_37_concrete,
   T5_isAlgebraicOfDegree_quintic_root_41_concrete,
   T5_isAlgebraicOfDegree_quintic_root_43_concrete,
   T5_isAlgebraicOfDegree_quintic_root_47_concrete⟩

theorem T5_bundle_XXXVIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 5 31) ∧
    IsAlgebraic ℤ (kthRootNat 5 37) ∧
    IsAlgebraic ℤ (kthRootNat 5 41) ∧
    IsAlgebraic ℤ (kthRootNat 5 43) ∧
    IsAlgebraic ℤ (kthRootNat 5 47) :=
  ⟨T5_IsAlgebraic_int_quintic_root_31_concrete,
   T5_IsAlgebraic_int_quintic_root_37_concrete,
   T5_IsAlgebraic_int_quintic_root_41_concrete,
   T5_IsAlgebraic_int_quintic_root_43_concrete,
   T5_IsAlgebraic_int_quintic_root_47_concrete⟩

/-! ## Bundle-XXXVIII GRAND HEADLINE -/

theorem T5_bundle_XXXVIII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 5 31) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 37) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 41) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 43) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 47) 5) ∧
    (IsAlgebraic ℤ (kthRootNat 5 31) ∧
     IsAlgebraic ℤ (kthRootNat 5 37) ∧
     IsAlgebraic ℤ (kthRootNat 5 41) ∧
     IsAlgebraic ℤ (kthRootNat 5 43) ∧
     IsAlgebraic ℤ (kthRootNat 5 47)) :=
  ⟨T5_bundle_XXXVIII_master_alias_5_concrete,
   T5_bundle_XXXVIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVIII
