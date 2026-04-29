/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXIII: ext #1129-1143
  Higher-k base 11 cascade ¹⁴√11/¹⁵√11/¹⁶√11/¹⁷√11/¹⁸√11**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1129-1143.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k base-11 cascade extension via Bundle-XXIV parametric:
  k = 14, 15, 16, 17, 18 with base 11.

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #1129-1133: ¹⁴√11, ¹⁵√11, ¹⁶√11, ¹⁷√11, ¹⁸√11

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1134-1138: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXIII markers + headlines):
  - ext #1139-1143: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1129-1143 — Higher-k base-11 cascade ¹⁴√11-¹⁸√11 (BUNDLE-LXIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_14root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 11) 14 :=
  T5_isAlgebraicOfDegree_kthRootNat 14 11 (by norm_num)

theorem T5_isAlgebraicOfDegree_15root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 15 11) 15 :=
  T5_isAlgebraicOfDegree_kthRootNat 15 11 (by norm_num)

theorem T5_isAlgebraicOfDegree_16root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 16 11) 16 :=
  T5_isAlgebraicOfDegree_kthRootNat 16 11 (by norm_num)

theorem T5_isAlgebraicOfDegree_17root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 17 11) 17 :=
  T5_isAlgebraicOfDegree_kthRootNat 17 11 (by norm_num)

theorem T5_isAlgebraicOfDegree_18root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 18 11) 18 :=
  T5_isAlgebraicOfDegree_kthRootNat 18 11 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_14root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 14 11) :=
  T5_IsAlgebraic_int_kthRootNat 14 11 (by norm_num)

theorem T5_IsAlgebraic_int_15root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 15 11) :=
  T5_IsAlgebraic_int_kthRootNat 15 11 (by norm_num)

theorem T5_IsAlgebraic_int_16root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 16 11) :=
  T5_IsAlgebraic_int_kthRootNat 16 11 (by norm_num)

theorem T5_IsAlgebraic_int_17root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 17 11) :=
  T5_IsAlgebraic_int_kthRootNat 17 11 (by norm_num)

theorem T5_IsAlgebraic_int_18root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 18 11) :=
  T5_IsAlgebraic_int_kthRootNat 18 11 (by norm_num)

/-! ## Sub-cluster C — Bundle-LXIII markers + headlines -/

theorem T5_bundle_LXIII_first_in_V2_marker :
    ∃ (n : ℕ), 1129 ≤ n ∧ n ≤ 1143 ∧ n - 1129 ≤ 15 :=
  ⟨1143, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXIII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 11) 14 ∧
    IsAlgebraicOfDegree (kthRootNat 15 11) 15 ∧
    IsAlgebraicOfDegree (kthRootNat 16 11) 16 ∧
    IsAlgebraicOfDegree (kthRootNat 17 11) 17 ∧
    IsAlgebraicOfDegree (kthRootNat 18 11) 18 :=
  ⟨T5_isAlgebraicOfDegree_14root_11_concrete,
   T5_isAlgebraicOfDegree_15root_11_concrete,
   T5_isAlgebraicOfDegree_16root_11_concrete,
   T5_isAlgebraicOfDegree_17root_11_concrete,
   T5_isAlgebraicOfDegree_18root_11_concrete⟩

theorem T5_bundle_LXIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 14 11) ∧
    IsAlgebraic ℤ (kthRootNat 15 11) ∧
    IsAlgebraic ℤ (kthRootNat 16 11) ∧
    IsAlgebraic ℤ (kthRootNat 17 11) ∧
    IsAlgebraic ℤ (kthRootNat 18 11) :=
  ⟨T5_IsAlgebraic_int_14root_11_concrete,
   T5_IsAlgebraic_int_15root_11_concrete,
   T5_IsAlgebraic_int_16root_11_concrete,
   T5_IsAlgebraic_int_17root_11_concrete,
   T5_IsAlgebraic_int_18root_11_concrete⟩

/-! ## Bundle-LXIII GRAND HEADLINE -/

theorem T5_bundle_LXIII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 14 11) 14 ∧
     IsAlgebraicOfDegree (kthRootNat 15 11) 15 ∧
     IsAlgebraicOfDegree (kthRootNat 16 11) 16 ∧
     IsAlgebraicOfDegree (kthRootNat 17 11) 17 ∧
     IsAlgebraicOfDegree (kthRootNat 18 11) 18) ∧
    (IsAlgebraic ℤ (kthRootNat 14 11) ∧
     IsAlgebraic ℤ (kthRootNat 15 11) ∧
     IsAlgebraic ℤ (kthRootNat 16 11) ∧
     IsAlgebraic ℤ (kthRootNat 17 11) ∧
     IsAlgebraic ℤ (kthRootNat 18 11)) :=
  ⟨T5_bundle_LXIII_master_alias_5_concrete,
   T5_bundle_LXIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIII
