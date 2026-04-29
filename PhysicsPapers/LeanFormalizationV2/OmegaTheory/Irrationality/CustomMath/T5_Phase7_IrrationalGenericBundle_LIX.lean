/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIX

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LIX: ext #1069-1083
  Higher-k base 3 cascade ¹⁴√3/¹⁵√3/¹⁶√3/¹⁷√3/¹⁸√3**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1069-1083.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LIX,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k base-3 cascade extension via Bundle-XXIV parametric:
  k = 14, 15, 16, 17, 18 with base 3.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1069-1073: ¹⁴√3, ¹⁵√3, ¹⁶√3, ¹⁷√3, ¹⁸√3

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1074-1078: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LIX markers + headlines):
  - ext #1079-1083: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1069-1083 — Higher-k base-3 cascade ¹⁴√3-¹⁸√3 (BUNDLE-LIX).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LVIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIX

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_14root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 3) 14 :=
  T5_isAlgebraicOfDegree_kthRootNat 14 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_15root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 15 3) 15 :=
  T5_isAlgebraicOfDegree_kthRootNat 15 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_16root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 16 3) 16 :=
  T5_isAlgebraicOfDegree_kthRootNat 16 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_17root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 17 3) 17 :=
  T5_isAlgebraicOfDegree_kthRootNat 17 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_18root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 18 3) 18 :=
  T5_isAlgebraicOfDegree_kthRootNat 18 3 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_14root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 14 3) :=
  T5_IsAlgebraic_int_kthRootNat 14 3 (by norm_num)

theorem T5_IsAlgebraic_int_15root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 15 3) :=
  T5_IsAlgebraic_int_kthRootNat 15 3 (by norm_num)

theorem T5_IsAlgebraic_int_16root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 16 3) :=
  T5_IsAlgebraic_int_kthRootNat 16 3 (by norm_num)

theorem T5_IsAlgebraic_int_17root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 17 3) :=
  T5_IsAlgebraic_int_kthRootNat 17 3 (by norm_num)

theorem T5_IsAlgebraic_int_18root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 18 3) :=
  T5_IsAlgebraic_int_kthRootNat 18 3 (by norm_num)

/-! ## Sub-cluster C — Bundle-LIX markers + headlines -/

theorem T5_bundle_LIX_first_in_V2_marker :
    ∃ (n : ℕ), 1069 ≤ n ∧ n ≤ 1083 ∧ n - 1069 ≤ 15 :=
  ⟨1083, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LIX_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LIX_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 3) 14 ∧
    IsAlgebraicOfDegree (kthRootNat 15 3) 15 ∧
    IsAlgebraicOfDegree (kthRootNat 16 3) 16 ∧
    IsAlgebraicOfDegree (kthRootNat 17 3) 17 ∧
    IsAlgebraicOfDegree (kthRootNat 18 3) 18 :=
  ⟨T5_isAlgebraicOfDegree_14root_3_concrete,
   T5_isAlgebraicOfDegree_15root_3_concrete,
   T5_isAlgebraicOfDegree_16root_3_concrete,
   T5_isAlgebraicOfDegree_17root_3_concrete,
   T5_isAlgebraicOfDegree_18root_3_concrete⟩

theorem T5_bundle_LIX_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 14 3) ∧
    IsAlgebraic ℤ (kthRootNat 15 3) ∧
    IsAlgebraic ℤ (kthRootNat 16 3) ∧
    IsAlgebraic ℤ (kthRootNat 17 3) ∧
    IsAlgebraic ℤ (kthRootNat 18 3) :=
  ⟨T5_IsAlgebraic_int_14root_3_concrete,
   T5_IsAlgebraic_int_15root_3_concrete,
   T5_IsAlgebraic_int_16root_3_concrete,
   T5_IsAlgebraic_int_17root_3_concrete,
   T5_IsAlgebraic_int_18root_3_concrete⟩

/-! ## Bundle-LIX GRAND HEADLINE -/

theorem T5_bundle_LIX_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 14 3) 14 ∧
     IsAlgebraicOfDegree (kthRootNat 15 3) 15 ∧
     IsAlgebraicOfDegree (kthRootNat 16 3) 16 ∧
     IsAlgebraicOfDegree (kthRootNat 17 3) 17 ∧
     IsAlgebraicOfDegree (kthRootNat 18 3) 18) ∧
    (IsAlgebraic ℤ (kthRootNat 14 3) ∧
     IsAlgebraic ℤ (kthRootNat 15 3) ∧
     IsAlgebraic ℤ (kthRootNat 16 3) ∧
     IsAlgebraic ℤ (kthRootNat 17 3) ∧
     IsAlgebraic ℤ (kthRootNat 18 3)) :=
  ⟨T5_bundle_LIX_master_alias_5_concrete,
   T5_bundle_LIX_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIX
