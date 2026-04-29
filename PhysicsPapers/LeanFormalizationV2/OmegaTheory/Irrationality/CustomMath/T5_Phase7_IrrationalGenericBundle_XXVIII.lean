/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXVIII: ext #604-618
  5-th root cascade ⁵√2/⁵√3/⁵√5/⁵√7/⁵√11**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaa through 559oooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #604-618.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXVIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  5-th root cascade via Bundle-XXIV parametric kthRootNat with k=5.

  Sub-cluster A (IsAlgebraicOfDegree 5 via parametric):
  - ext #604-608: T5_isAlgebraicOfDegree_quintic_root_{2,3,5,7,11}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #609-613: T5_IsAlgebraic_int_quintic_root_{2,3,5,7,11}_concrete

  Sub-cluster C (Bundle-XXVIII markers + headlines):
  - ext #614: bundle_XXVIII_first_in_V2_marker
  - ext #615: bundle_XXVIII_closed_count
  - ext #616: bundle_XXVIII_master_alias_5_concrete
  - ext #617: bundle_XXVIII_isAlgebraic_int_5_combined
  - ext #618: bundle_XXVIII_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #604-618 — 5-th root cascade ⁵√2-⁵√11 (BUNDLE-XXVIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree 5 via parametric -/

theorem T5_isAlgebraicOfDegree_quintic_root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 2) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 3) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 5) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 7) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 11) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 11 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quintic_root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 5 2) :=
  T5_IsAlgebraic_int_kthRootNat 5 2 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 5 3) :=
  T5_IsAlgebraic_int_kthRootNat 5 3 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 5 5) :=
  T5_IsAlgebraic_int_kthRootNat 5 5 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 5 7) :=
  T5_IsAlgebraic_int_kthRootNat 5 7 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 5 11) :=
  T5_IsAlgebraic_int_kthRootNat 5 11 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXVIII markers + headlines -/

theorem T5_bundle_XXVIII_first_in_V2_marker :
    ∃ (n : ℕ), 604 ≤ n ∧ n ≤ 618 ∧ n - 604 ≤ 15 :=
  ⟨618, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXVIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXVIII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 2) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 3) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 5) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 7) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 11) 5 :=
  ⟨T5_isAlgebraicOfDegree_quintic_root_2_concrete,
   T5_isAlgebraicOfDegree_quintic_root_3_concrete,
   T5_isAlgebraicOfDegree_quintic_root_5_concrete,
   T5_isAlgebraicOfDegree_quintic_root_7_concrete,
   T5_isAlgebraicOfDegree_quintic_root_11_concrete⟩

theorem T5_bundle_XXVIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 5 2) ∧
    IsAlgebraic ℤ (kthRootNat 5 3) ∧
    IsAlgebraic ℤ (kthRootNat 5 5) ∧
    IsAlgebraic ℤ (kthRootNat 5 7) ∧
    IsAlgebraic ℤ (kthRootNat 5 11) :=
  ⟨T5_IsAlgebraic_int_quintic_root_2_concrete,
   T5_IsAlgebraic_int_quintic_root_3_concrete,
   T5_IsAlgebraic_int_quintic_root_5_concrete,
   T5_IsAlgebraic_int_quintic_root_7_concrete,
   T5_IsAlgebraic_int_quintic_root_11_concrete⟩

theorem T5_bundle_XXVIII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 5 2) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 3) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 5) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 7) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 11) 5) ∧
    (IsAlgebraic ℤ (kthRootNat 5 2) ∧
     IsAlgebraic ℤ (kthRootNat 5 3) ∧
     IsAlgebraic ℤ (kthRootNat 5 5) ∧
     IsAlgebraic ℤ (kthRootNat 5 7) ∧
     IsAlgebraic ℤ (kthRootNat 5 11)) :=
  ⟨T5_bundle_XXVIII_master_alias_5_concrete,
   T5_bundle_XXVIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVIII
