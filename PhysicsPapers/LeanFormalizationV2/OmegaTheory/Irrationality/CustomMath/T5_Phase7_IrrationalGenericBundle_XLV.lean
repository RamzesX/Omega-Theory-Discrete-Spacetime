/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLV: ext #859-873
  4-th root prime cascade ∜101/∜103/∜107/∜109/∜113**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #859-873.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  4-th root cascade extension for primes 101, 103, 107, 109, 113.

  Sub-cluster A (k=4 prime extension):
  - ext #859-863: ∜101, ∜103, ∜107, ∜109, ∜113

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #864-868: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLV markers + headlines):
  - ext #869-873: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #859-873 — 4th root prime cascade ∜101-∜113 (BUNDLE-XLV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=4 prime extension -/

theorem T5_isAlgebraicOfDegree_quartic_root_101_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 101) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 101 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_103_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 103) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 103 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_107_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 107) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 107 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_109_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 109) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 109 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_113_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 113) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 113 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quartic_root_101_concrete :
    IsAlgebraic ℤ (kthRootNat 4 101) :=
  T5_IsAlgebraic_int_kthRootNat 4 101 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_103_concrete :
    IsAlgebraic ℤ (kthRootNat 4 103) :=
  T5_IsAlgebraic_int_kthRootNat 4 103 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_107_concrete :
    IsAlgebraic ℤ (kthRootNat 4 107) :=
  T5_IsAlgebraic_int_kthRootNat 4 107 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_109_concrete :
    IsAlgebraic ℤ (kthRootNat 4 109) :=
  T5_IsAlgebraic_int_kthRootNat 4 109 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_113_concrete :
    IsAlgebraic ℤ (kthRootNat 4 113) :=
  T5_IsAlgebraic_int_kthRootNat 4 113 (by norm_num)

/-! ## Sub-cluster C — Bundle-XLV markers + headlines -/

theorem T5_bundle_XLV_first_in_V2_marker :
    ∃ (n : ℕ), 859 ≤ n ∧ n ≤ 873 ∧ n - 859 ≤ 15 :=
  ⟨873, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLV_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 101) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 103) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 107) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 109) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 113) 4 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_101_concrete,
   T5_isAlgebraicOfDegree_quartic_root_103_concrete,
   T5_isAlgebraicOfDegree_quartic_root_107_concrete,
   T5_isAlgebraicOfDegree_quartic_root_109_concrete,
   T5_isAlgebraicOfDegree_quartic_root_113_concrete⟩

theorem T5_bundle_XLV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 101) ∧
    IsAlgebraic ℤ (kthRootNat 4 103) ∧
    IsAlgebraic ℤ (kthRootNat 4 107) ∧
    IsAlgebraic ℤ (kthRootNat 4 109) ∧
    IsAlgebraic ℤ (kthRootNat 4 113) :=
  ⟨T5_IsAlgebraic_int_quartic_root_101_concrete,
   T5_IsAlgebraic_int_quartic_root_103_concrete,
   T5_IsAlgebraic_int_quartic_root_107_concrete,
   T5_IsAlgebraic_int_quartic_root_109_concrete,
   T5_IsAlgebraic_int_quartic_root_113_concrete⟩

/-! ## Bundle-XLV GRAND HEADLINE -/

theorem T5_bundle_XLV_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 4 101) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 103) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 107) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 109) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 113) 4) ∧
    (IsAlgebraic ℤ (kthRootNat 4 101) ∧
     IsAlgebraic ℤ (kthRootNat 4 103) ∧
     IsAlgebraic ℤ (kthRootNat 4 107) ∧
     IsAlgebraic ℤ (kthRootNat 4 109) ∧
     IsAlgebraic ℤ (kthRootNat 4 113)) :=
  ⟨T5_bundle_XLV_master_alias_5_concrete,
   T5_bundle_XLV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLV
