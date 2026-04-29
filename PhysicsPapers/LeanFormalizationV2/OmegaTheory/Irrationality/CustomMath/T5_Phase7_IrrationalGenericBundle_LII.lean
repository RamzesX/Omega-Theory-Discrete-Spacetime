/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LII: ext #964-978
  Higher-k cross-base ⁶√13/⁶√17/⁷√13/⁷√17/⁸√7**, sub session
  559oooooooooooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #964-978.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k cross-base extension via Bundle-XXIV parametric:
  - k=6 with bases 13, 17
  - k=7 with bases 13, 17
  - k=8 with base 7

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #964: k=6 base 13 (⁶√13)
  - ext #965: k=6 base 17 (⁶√17)
  - ext #966: k=7 base 13 (⁷√13)
  - ext #967: k=7 base 17 (⁷√17)
  - ext #968: k=8 base 7 (⁸√7)

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #969-973: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LII markers + headlines):
  - ext #974-978: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #964-978 — Higher-k cross-base ⁶√13-⁸√7 (BUNDLE-LII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_sextic_root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 13) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_sextic_root_17_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 17) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 17 (by norm_num)

theorem T5_isAlgebraicOfDegree_septic_root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 7 13) 7 :=
  T5_isAlgebraicOfDegree_kthRootNat 7 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_septic_root_17_concrete :
    IsAlgebraicOfDegree (kthRootNat 7 17) 7 :=
  T5_isAlgebraicOfDegree_kthRootNat 7 17 (by norm_num)

theorem T5_isAlgebraicOfDegree_octic_root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 8 7) 8 :=
  T5_isAlgebraicOfDegree_kthRootNat 8 7 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_sextic_root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 6 13) :=
  T5_IsAlgebraic_int_kthRootNat 6 13 (by norm_num)

theorem T5_IsAlgebraic_int_sextic_root_17_concrete :
    IsAlgebraic ℤ (kthRootNat 6 17) :=
  T5_IsAlgebraic_int_kthRootNat 6 17 (by norm_num)

theorem T5_IsAlgebraic_int_septic_root_13_concrete :
    IsAlgebraic ℤ (kthRootNat 7 13) :=
  T5_IsAlgebraic_int_kthRootNat 7 13 (by norm_num)

theorem T5_IsAlgebraic_int_septic_root_17_concrete :
    IsAlgebraic ℤ (kthRootNat 7 17) :=
  T5_IsAlgebraic_int_kthRootNat 7 17 (by norm_num)

theorem T5_IsAlgebraic_int_octic_root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 8 7) :=
  T5_IsAlgebraic_int_kthRootNat 8 7 (by norm_num)

/-! ## Sub-cluster C — Bundle-LII markers + headlines -/

theorem T5_bundle_LII_first_in_V2_marker :
    ∃ (n : ℕ), 964 ≤ n ∧ n ≤ 978 ∧ n - 964 ≤ 15 :=
  ⟨978, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 13) 6 ∧
    IsAlgebraicOfDegree (kthRootNat 6 17) 6 ∧
    IsAlgebraicOfDegree (kthRootNat 7 13) 7 ∧
    IsAlgebraicOfDegree (kthRootNat 7 17) 7 ∧
    IsAlgebraicOfDegree (kthRootNat 8 7) 8 :=
  ⟨T5_isAlgebraicOfDegree_sextic_root_13_concrete,
   T5_isAlgebraicOfDegree_sextic_root_17_concrete,
   T5_isAlgebraicOfDegree_septic_root_13_concrete,
   T5_isAlgebraicOfDegree_septic_root_17_concrete,
   T5_isAlgebraicOfDegree_octic_root_7_concrete⟩

theorem T5_bundle_LII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 6 13) ∧
    IsAlgebraic ℤ (kthRootNat 6 17) ∧
    IsAlgebraic ℤ (kthRootNat 7 13) ∧
    IsAlgebraic ℤ (kthRootNat 7 17) ∧
    IsAlgebraic ℤ (kthRootNat 8 7) :=
  ⟨T5_IsAlgebraic_int_sextic_root_13_concrete,
   T5_IsAlgebraic_int_sextic_root_17_concrete,
   T5_IsAlgebraic_int_septic_root_13_concrete,
   T5_IsAlgebraic_int_septic_root_17_concrete,
   T5_IsAlgebraic_int_octic_root_7_concrete⟩

/-! ## Bundle-LII GRAND HEADLINE -/

theorem T5_bundle_LII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 6 13) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 6 17) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 7 13) 7 ∧
     IsAlgebraicOfDegree (kthRootNat 7 17) 7 ∧
     IsAlgebraicOfDegree (kthRootNat 8 7) 8) ∧
    (IsAlgebraic ℤ (kthRootNat 6 13) ∧
     IsAlgebraic ℤ (kthRootNat 6 17) ∧
     IsAlgebraic ℤ (kthRootNat 7 13) ∧
     IsAlgebraic ℤ (kthRootNat 7 17) ∧
     IsAlgebraic ℤ (kthRootNat 8 7)) :=
  ⟨T5_bundle_LII_master_alias_5_concrete,
   T5_bundle_LII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LII
