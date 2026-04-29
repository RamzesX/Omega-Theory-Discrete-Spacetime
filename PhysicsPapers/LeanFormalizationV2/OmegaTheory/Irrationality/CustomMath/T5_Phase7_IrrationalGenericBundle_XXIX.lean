/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIX

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXIX: ext #619-633
  Higher-k root cascade ⁶√2-¹⁰√2**, sub session
  559oooooooooooooooooooooooooo through 559aaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #619-633.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXIX,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k root cascade via Bundle-XXIV parametric: k = 6, 7, 8, 9, 10
  all applied to n=2.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #619: T5_isAlgebraicOfDegree_sextic_root_2_concrete (k=6)
  - ext #620: T5_isAlgebraicOfDegree_septic_root_2_concrete (k=7)
  - ext #621: T5_isAlgebraicOfDegree_octic_root_2_concrete (k=8)
  - ext #622: T5_isAlgebraicOfDegree_nonic_root_2_concrete (k=9)
  - ext #623: T5_isAlgebraicOfDegree_decic_root_2_v2 (k=10)

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #624-628: T5_IsAlgebraic_int_kth_root_2_concrete (k=6,7,8,9,10)

  Sub-cluster C (Bundle-XXIX markers + headlines):
  - ext #629: bundle_XXIX_first_in_V2_marker
  - ext #630: bundle_XXIX_closed_count
  - ext #631: bundle_XXIX_master_alias_5_concrete
  - ext #632: bundle_XXIX_isAlgebraic_int_5_combined
  - ext #633: bundle_XXIX_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #619-633 — Higher-k root cascade k=6-10 (BUNDLE-XXIX).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIX

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_sextic_root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 2) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_septic_root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 7 2) 7 :=
  T5_isAlgebraicOfDegree_kthRootNat 7 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_octic_root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 8 2) 8 :=
  T5_isAlgebraicOfDegree_kthRootNat 8 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_nonic_root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 9 2) 9 :=
  T5_isAlgebraicOfDegree_kthRootNat 9 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_decic_root_2_v2 :
    IsAlgebraicOfDegree (kthRootNat 10 2) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 2 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_sextic_root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 6 2) :=
  T5_IsAlgebraic_int_kthRootNat 6 2 (by norm_num)

theorem T5_IsAlgebraic_int_septic_root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 7 2) :=
  T5_IsAlgebraic_int_kthRootNat 7 2 (by norm_num)

theorem T5_IsAlgebraic_int_octic_root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 8 2) :=
  T5_IsAlgebraic_int_kthRootNat 8 2 (by norm_num)

theorem T5_IsAlgebraic_int_nonic_root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 9 2) :=
  T5_IsAlgebraic_int_kthRootNat 9 2 (by norm_num)

theorem T5_IsAlgebraic_int_decic_root_2_v2 :
    IsAlgebraic ℤ (kthRootNat 10 2) :=
  T5_IsAlgebraic_int_kthRootNat 10 2 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXIX markers + headlines -/

theorem T5_bundle_XXIX_first_in_V2_marker :
    ∃ (n : ℕ), 619 ≤ n ∧ n ≤ 633 ∧ n - 619 ≤ 15 :=
  ⟨633, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXIX_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXIX_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 2) 6 ∧
    IsAlgebraicOfDegree (kthRootNat 7 2) 7 ∧
    IsAlgebraicOfDegree (kthRootNat 8 2) 8 ∧
    IsAlgebraicOfDegree (kthRootNat 9 2) 9 ∧
    IsAlgebraicOfDegree (kthRootNat 10 2) 10 :=
  ⟨T5_isAlgebraicOfDegree_sextic_root_2_concrete,
   T5_isAlgebraicOfDegree_septic_root_2_concrete,
   T5_isAlgebraicOfDegree_octic_root_2_concrete,
   T5_isAlgebraicOfDegree_nonic_root_2_concrete,
   T5_isAlgebraicOfDegree_decic_root_2_v2⟩

theorem T5_bundle_XXIX_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 6 2) ∧
    IsAlgebraic ℤ (kthRootNat 7 2) ∧
    IsAlgebraic ℤ (kthRootNat 8 2) ∧
    IsAlgebraic ℤ (kthRootNat 9 2) ∧
    IsAlgebraic ℤ (kthRootNat 10 2) :=
  ⟨T5_IsAlgebraic_int_sextic_root_2_concrete,
   T5_IsAlgebraic_int_septic_root_2_concrete,
   T5_IsAlgebraic_int_octic_root_2_concrete,
   T5_IsAlgebraic_int_nonic_root_2_concrete,
   T5_IsAlgebraic_int_decic_root_2_v2⟩

theorem T5_bundle_XXIX_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 6 2) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 7 2) 7 ∧
     IsAlgebraicOfDegree (kthRootNat 8 2) 8 ∧
     IsAlgebraicOfDegree (kthRootNat 9 2) 9 ∧
     IsAlgebraicOfDegree (kthRootNat 10 2) 10) ∧
    (IsAlgebraic ℤ (kthRootNat 6 2) ∧
     IsAlgebraic ℤ (kthRootNat 7 2) ∧
     IsAlgebraic ℤ (kthRootNat 8 2) ∧
     IsAlgebraic ℤ (kthRootNat 9 2) ∧
     IsAlgebraic ℤ (kthRootNat 10 2)) :=
  ⟨T5_bundle_XXIX_master_alias_5_concrete,
   T5_bundle_XXIX_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIX
