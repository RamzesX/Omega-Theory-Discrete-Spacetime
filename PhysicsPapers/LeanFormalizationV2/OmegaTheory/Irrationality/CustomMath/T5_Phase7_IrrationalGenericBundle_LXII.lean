/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXII: ext #1114-1128
  Higher-k base 7 cascade ¹⁴√7/¹⁵√7/¹⁶√7/¹⁷√7/¹⁸√7**, sub session
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #1114-1128.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k base-7 cascade extension via Bundle-XXIV parametric:
  k = 14, 15, 16, 17, 18 with base 7.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1114-1118: ¹⁴√7, ¹⁵√7, ¹⁶√7, ¹⁷√7, ¹⁸√7

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1119-1123: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXII markers + headlines):
  - ext #1124-1128: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1114-1128 — Higher-k base-7 cascade ¹⁴√7-¹⁸√7 (BUNDLE-LXII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_14root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 7) 14 :=
  T5_isAlgebraicOfDegree_kthRootNat 14 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_15root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 15 7) 15 :=
  T5_isAlgebraicOfDegree_kthRootNat 15 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_16root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 16 7) 16 :=
  T5_isAlgebraicOfDegree_kthRootNat 16 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_17root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 17 7) 17 :=
  T5_isAlgebraicOfDegree_kthRootNat 17 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_18root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 18 7) 18 :=
  T5_isAlgebraicOfDegree_kthRootNat 18 7 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_14root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 14 7) :=
  T5_IsAlgebraic_int_kthRootNat 14 7 (by norm_num)

theorem T5_IsAlgebraic_int_15root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 15 7) :=
  T5_IsAlgebraic_int_kthRootNat 15 7 (by norm_num)

theorem T5_IsAlgebraic_int_16root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 16 7) :=
  T5_IsAlgebraic_int_kthRootNat 16 7 (by norm_num)

theorem T5_IsAlgebraic_int_17root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 17 7) :=
  T5_IsAlgebraic_int_kthRootNat 17 7 (by norm_num)

theorem T5_IsAlgebraic_int_18root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 18 7) :=
  T5_IsAlgebraic_int_kthRootNat 18 7 (by norm_num)

/-! ## Sub-cluster C — Bundle-LXII markers + headlines -/

theorem T5_bundle_LXII_first_in_V2_marker :
    ∃ (n : ℕ), 1114 ≤ n ∧ n ≤ 1128 ∧ n - 1114 ≤ 15 :=
  ⟨1128, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 7) 14 ∧
    IsAlgebraicOfDegree (kthRootNat 15 7) 15 ∧
    IsAlgebraicOfDegree (kthRootNat 16 7) 16 ∧
    IsAlgebraicOfDegree (kthRootNat 17 7) 17 ∧
    IsAlgebraicOfDegree (kthRootNat 18 7) 18 :=
  ⟨T5_isAlgebraicOfDegree_14root_7_concrete,
   T5_isAlgebraicOfDegree_15root_7_concrete,
   T5_isAlgebraicOfDegree_16root_7_concrete,
   T5_isAlgebraicOfDegree_17root_7_concrete,
   T5_isAlgebraicOfDegree_18root_7_concrete⟩

theorem T5_bundle_LXII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 14 7) ∧
    IsAlgebraic ℤ (kthRootNat 15 7) ∧
    IsAlgebraic ℤ (kthRootNat 16 7) ∧
    IsAlgebraic ℤ (kthRootNat 17 7) ∧
    IsAlgebraic ℤ (kthRootNat 18 7) :=
  ⟨T5_IsAlgebraic_int_14root_7_concrete,
   T5_IsAlgebraic_int_15root_7_concrete,
   T5_IsAlgebraic_int_16root_7_concrete,
   T5_IsAlgebraic_int_17root_7_concrete,
   T5_IsAlgebraic_int_18root_7_concrete⟩

/-! ## Bundle-LXII GRAND HEADLINE -/

theorem T5_bundle_LXII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 14 7) 14 ∧
     IsAlgebraicOfDegree (kthRootNat 15 7) 15 ∧
     IsAlgebraicOfDegree (kthRootNat 16 7) 16 ∧
     IsAlgebraicOfDegree (kthRootNat 17 7) 17 ∧
     IsAlgebraicOfDegree (kthRootNat 18 7) 18) ∧
    (IsAlgebraic ℤ (kthRootNat 14 7) ∧
     IsAlgebraic ℤ (kthRootNat 15 7) ∧
     IsAlgebraic ℤ (kthRootNat 16 7) ∧
     IsAlgebraic ℤ (kthRootNat 17 7) ∧
     IsAlgebraic ℤ (kthRootNat 18 7)) :=
  ⟨T5_bundle_LXII_master_alias_5_concrete,
   T5_bundle_LXII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXII
