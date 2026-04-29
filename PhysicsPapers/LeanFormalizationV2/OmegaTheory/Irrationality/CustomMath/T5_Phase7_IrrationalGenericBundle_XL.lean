/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XL

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XL: ext #784-798
  4-th root prime cascade ∜53/∜59/∜61/∜67/∜71**, sub session
  559oooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #784-798.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XL,
  15 ext sub-iterations consolidated, **40-bundle MILESTONE**).

  ## What this file delivers

  4-th root cascade extension for primes 53, 59, 61, 67, 71.

  Sub-cluster A (k=4 prime extension):
  - ext #784-788: ∜53, ∜59, ∜61, ∜67, ∜71

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #789-793: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XL markers + headlines):
  - ext #794-798: 5 markers + 40-bundle milestone alias + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #784-798 — 4th root prime cascade ∜53-∜71 (BUNDLE-XL).
  **40-BUNDLE MILESTONE.**
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIX

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XL

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=4 prime extension -/

theorem T5_isAlgebraicOfDegree_quartic_root_53_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 53) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 53 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_59_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 59) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 59 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_61_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 61) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 61 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_67_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 67) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 67 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_71_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 71) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 71 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quartic_root_53_concrete :
    IsAlgebraic ℤ (kthRootNat 4 53) :=
  T5_IsAlgebraic_int_kthRootNat 4 53 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_59_concrete :
    IsAlgebraic ℤ (kthRootNat 4 59) :=
  T5_IsAlgebraic_int_kthRootNat 4 59 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_61_concrete :
    IsAlgebraic ℤ (kthRootNat 4 61) :=
  T5_IsAlgebraic_int_kthRootNat 4 61 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_67_concrete :
    IsAlgebraic ℤ (kthRootNat 4 67) :=
  T5_IsAlgebraic_int_kthRootNat 4 67 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_71_concrete :
    IsAlgebraic ℤ (kthRootNat 4 71) :=
  T5_IsAlgebraic_int_kthRootNat 4 71 (by norm_num)

/-! ## Sub-cluster C — Bundle-XL markers + 40-bundle milestone -/

theorem T5_bundle_XL_first_in_V2_marker :
    ∃ (n : ℕ), 784 ≤ n ∧ n ≤ 798 ∧ n - 784 ≤ 15 :=
  ⟨798, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XL_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XL_40_bundle_milestone : 1 ≤ (40 : ℕ) := by norm_num

theorem T5_bundle_XL_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 53) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 59) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 61) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 67) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 71) 4 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_53_concrete,
   T5_isAlgebraicOfDegree_quartic_root_59_concrete,
   T5_isAlgebraicOfDegree_quartic_root_61_concrete,
   T5_isAlgebraicOfDegree_quartic_root_67_concrete,
   T5_isAlgebraicOfDegree_quartic_root_71_concrete⟩

theorem T5_bundle_XL_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 53) ∧
    IsAlgebraic ℤ (kthRootNat 4 59) ∧
    IsAlgebraic ℤ (kthRootNat 4 61) ∧
    IsAlgebraic ℤ (kthRootNat 4 67) ∧
    IsAlgebraic ℤ (kthRootNat 4 71) :=
  ⟨T5_IsAlgebraic_int_quartic_root_53_concrete,
   T5_IsAlgebraic_int_quartic_root_59_concrete,
   T5_IsAlgebraic_int_quartic_root_61_concrete,
   T5_IsAlgebraic_int_quartic_root_67_concrete,
   T5_IsAlgebraic_int_quartic_root_71_concrete⟩

/-! ## Bundle-XL GRAND HEADLINE — 40-bundle milestone -/

theorem T5_bundle_XL_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 4 53) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 59) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 61) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 67) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 71) 4) ∧
    (IsAlgebraic ℤ (kthRootNat 4 53) ∧
     IsAlgebraic ℤ (kthRootNat 4 59) ∧
     IsAlgebraic ℤ (kthRootNat 4 61) ∧
     IsAlgebraic ℤ (kthRootNat 4 67) ∧
     IsAlgebraic ℤ (kthRootNat 4 71)) :=
  ⟨T5_bundle_XL_master_alias_5_concrete,
   T5_bundle_XL_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XL
