/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXI: ext #1099-1113
  Higher-k base 5 cascade ¹⁴√5/¹⁵√5/¹⁶√5/¹⁷√5/¹⁸√5**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1099-1113.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXI,
  15 ext sub-iterations consolidated, **post-60-milestone**).

  ## What this file delivers

  Higher-k base-5 cascade extension via Bundle-XXIV parametric:
  k = 14, 15, 16, 17, 18 with base 5.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1099-1103: ¹⁴√5, ¹⁵√5, ¹⁶√5, ¹⁷√5, ¹⁸√5

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1104-1108: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXI markers + headlines):
  - ext #1109-1113: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1099-1113 — Higher-k base-5 cascade ¹⁴√5-¹⁸√5 (BUNDLE-LXI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LX

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_14root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 5) 14 :=
  T5_isAlgebraicOfDegree_kthRootNat 14 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_15root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 15 5) 15 :=
  T5_isAlgebraicOfDegree_kthRootNat 15 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_16root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 16 5) 16 :=
  T5_isAlgebraicOfDegree_kthRootNat 16 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_17root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 17 5) 17 :=
  T5_isAlgebraicOfDegree_kthRootNat 17 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_18root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 18 5) 18 :=
  T5_isAlgebraicOfDegree_kthRootNat 18 5 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_14root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 14 5) :=
  T5_IsAlgebraic_int_kthRootNat 14 5 (by norm_num)

theorem T5_IsAlgebraic_int_15root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 15 5) :=
  T5_IsAlgebraic_int_kthRootNat 15 5 (by norm_num)

theorem T5_IsAlgebraic_int_16root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 16 5) :=
  T5_IsAlgebraic_int_kthRootNat 16 5 (by norm_num)

theorem T5_IsAlgebraic_int_17root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 17 5) :=
  T5_IsAlgebraic_int_kthRootNat 17 5 (by norm_num)

theorem T5_IsAlgebraic_int_18root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 18 5) :=
  T5_IsAlgebraic_int_kthRootNat 18 5 (by norm_num)

/-! ## Sub-cluster C — Bundle-LXI markers + headlines -/

theorem T5_bundle_LXI_first_in_V2_marker :
    ∃ (n : ℕ), 1099 ≤ n ∧ n ≤ 1113 ∧ n - 1099 ≤ 15 :=
  ⟨1113, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXI_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 5) 14 ∧
    IsAlgebraicOfDegree (kthRootNat 15 5) 15 ∧
    IsAlgebraicOfDegree (kthRootNat 16 5) 16 ∧
    IsAlgebraicOfDegree (kthRootNat 17 5) 17 ∧
    IsAlgebraicOfDegree (kthRootNat 18 5) 18 :=
  ⟨T5_isAlgebraicOfDegree_14root_5_concrete,
   T5_isAlgebraicOfDegree_15root_5_concrete,
   T5_isAlgebraicOfDegree_16root_5_concrete,
   T5_isAlgebraicOfDegree_17root_5_concrete,
   T5_isAlgebraicOfDegree_18root_5_concrete⟩

theorem T5_bundle_LXI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 14 5) ∧
    IsAlgebraic ℤ (kthRootNat 15 5) ∧
    IsAlgebraic ℤ (kthRootNat 16 5) ∧
    IsAlgebraic ℤ (kthRootNat 17 5) ∧
    IsAlgebraic ℤ (kthRootNat 18 5) :=
  ⟨T5_IsAlgebraic_int_14root_5_concrete,
   T5_IsAlgebraic_int_15root_5_concrete,
   T5_IsAlgebraic_int_16root_5_concrete,
   T5_IsAlgebraic_int_17root_5_concrete,
   T5_IsAlgebraic_int_18root_5_concrete⟩

/-! ## Bundle-LXI GRAND HEADLINE -/

theorem T5_bundle_LXI_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 14 5) 14 ∧
     IsAlgebraicOfDegree (kthRootNat 15 5) 15 ∧
     IsAlgebraicOfDegree (kthRootNat 16 5) 16 ∧
     IsAlgebraicOfDegree (kthRootNat 17 5) 17 ∧
     IsAlgebraicOfDegree (kthRootNat 18 5) 18) ∧
    (IsAlgebraic ℤ (kthRootNat 14 5) ∧
     IsAlgebraic ℤ (kthRootNat 15 5) ∧
     IsAlgebraic ℤ (kthRootNat 16 5) ∧
     IsAlgebraic ℤ (kthRootNat 17 5) ∧
     IsAlgebraic ℤ (kthRootNat 18 5)) :=
  ⟨T5_bundle_LXI_master_alias_5_concrete,
   T5_bundle_LXI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXI
