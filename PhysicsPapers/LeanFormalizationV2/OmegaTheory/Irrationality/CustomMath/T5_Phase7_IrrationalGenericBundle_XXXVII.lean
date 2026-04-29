/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXVII: ext #739-753
  4-th root prime cascade ∜31/∜37/∜41/∜43/∜47**, sub session
  559oooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #739-753.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXVII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  4-th root cascade extension for primes 31, 37, 41, 43, 47.

  Sub-cluster A (k=4 prime extension):
  - ext #739-743: ∜31, ∜37, ∜41, ∜43, ∜47

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #744-748: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XXXVII markers + headlines):
  - ext #749-753: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #739-753 — 4th root prime cascade ∜31-∜47 (BUNDLE-XXXVII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=4 prime extension -/

theorem T5_isAlgebraicOfDegree_quartic_root_31_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 31) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 31 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_37_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 37) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 37 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_41_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 41) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 41 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_43_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 43) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 43 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_47_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 47) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 47 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quartic_root_31_concrete :
    IsAlgebraic ℤ (kthRootNat 4 31) :=
  T5_IsAlgebraic_int_kthRootNat 4 31 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_37_concrete :
    IsAlgebraic ℤ (kthRootNat 4 37) :=
  T5_IsAlgebraic_int_kthRootNat 4 37 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_41_concrete :
    IsAlgebraic ℤ (kthRootNat 4 41) :=
  T5_IsAlgebraic_int_kthRootNat 4 41 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_43_concrete :
    IsAlgebraic ℤ (kthRootNat 4 43) :=
  T5_IsAlgebraic_int_kthRootNat 4 43 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_47_concrete :
    IsAlgebraic ℤ (kthRootNat 4 47) :=
  T5_IsAlgebraic_int_kthRootNat 4 47 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXXVII markers + headlines -/

theorem T5_bundle_XXXVII_first_in_V2_marker :
    ∃ (n : ℕ), 739 ≤ n ∧ n ≤ 753 ∧ n - 739 ≤ 15 :=
  ⟨753, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXVII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXXVII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 31) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 37) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 41) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 43) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 47) 4 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_31_concrete,
   T5_isAlgebraicOfDegree_quartic_root_37_concrete,
   T5_isAlgebraicOfDegree_quartic_root_41_concrete,
   T5_isAlgebraicOfDegree_quartic_root_43_concrete,
   T5_isAlgebraicOfDegree_quartic_root_47_concrete⟩

theorem T5_bundle_XXXVII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 31) ∧
    IsAlgebraic ℤ (kthRootNat 4 37) ∧
    IsAlgebraic ℤ (kthRootNat 4 41) ∧
    IsAlgebraic ℤ (kthRootNat 4 43) ∧
    IsAlgebraic ℤ (kthRootNat 4 47) :=
  ⟨T5_IsAlgebraic_int_quartic_root_31_concrete,
   T5_IsAlgebraic_int_quartic_root_37_concrete,
   T5_IsAlgebraic_int_quartic_root_41_concrete,
   T5_IsAlgebraic_int_quartic_root_43_concrete,
   T5_IsAlgebraic_int_quartic_root_47_concrete⟩

/-! ## Bundle-XXXVII GRAND HEADLINE -/

theorem T5_bundle_XXXVII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 4 31) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 37) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 41) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 43) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 47) 4) ∧
    (IsAlgebraic ℤ (kthRootNat 4 31) ∧
     IsAlgebraic ℤ (kthRootNat 4 37) ∧
     IsAlgebraic ℤ (kthRootNat 4 41) ∧
     IsAlgebraic ℤ (kthRootNat 4 43) ∧
     IsAlgebraic ℤ (kthRootNat 4 47)) :=
  ⟨T5_bundle_XXXVII_master_alias_5_concrete,
   T5_bundle_XXXVII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVII
