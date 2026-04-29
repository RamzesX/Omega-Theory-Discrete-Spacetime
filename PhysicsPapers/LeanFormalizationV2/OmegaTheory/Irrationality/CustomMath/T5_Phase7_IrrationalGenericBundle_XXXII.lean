/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXII: ext #664-678
  Higher-k extension k=11,12,13,14,15 with base 2** + base 11 cascade,
  sub session 559aaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #664-678.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k extension via Bundle-XXIV parametric:
  - k = 11, 12, 13, 14, 15 (base 2)
  - k = 6 (base 11)
  - k = 7 (base 11)

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #664-668: T5_isAlgebraicOfDegree k=11..15 root_2
  - ext #669: k=6 base 11
  - ext #670: k=7 base 11

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #671-677: 7 IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XXXII markers + headlines):
  - ext #678: bundle_XXXII_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #664-678 — Higher-k extension k=11-15 + base 11 (BUNDLE-XXXII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_11root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 11 2) 11 :=
  T5_isAlgebraicOfDegree_kthRootNat 11 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_12root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 12 2) 12 :=
  T5_isAlgebraicOfDegree_kthRootNat 12 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_13root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 13 2) 13 :=
  T5_isAlgebraicOfDegree_kthRootNat 13 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_14root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 14 2) 14 :=
  T5_isAlgebraicOfDegree_kthRootNat 14 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_15root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 15 2) 15 :=
  T5_isAlgebraicOfDegree_kthRootNat 15 2 (by norm_num)

theorem T5_isAlgebraicOfDegree_sextic_root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 11) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 11 (by norm_num)

theorem T5_isAlgebraicOfDegree_septic_root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 7 11) 7 :=
  T5_isAlgebraicOfDegree_kthRootNat 7 11 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_11root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 11 2) :=
  T5_IsAlgebraic_int_kthRootNat 11 2 (by norm_num)

theorem T5_IsAlgebraic_int_12root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 12 2) :=
  T5_IsAlgebraic_int_kthRootNat 12 2 (by norm_num)

theorem T5_IsAlgebraic_int_13root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 13 2) :=
  T5_IsAlgebraic_int_kthRootNat 13 2 (by norm_num)

theorem T5_IsAlgebraic_int_14root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 14 2) :=
  T5_IsAlgebraic_int_kthRootNat 14 2 (by norm_num)

theorem T5_IsAlgebraic_int_15root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 15 2) :=
  T5_IsAlgebraic_int_kthRootNat 15 2 (by norm_num)

theorem T5_IsAlgebraic_int_sextic_root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 6 11) :=
  T5_IsAlgebraic_int_kthRootNat 6 11 (by norm_num)

theorem T5_IsAlgebraic_int_septic_root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 7 11) :=
  T5_IsAlgebraic_int_kthRootNat 7 11 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXXII grand headline -/

theorem T5_bundle_XXXII_grand_headline_full :
    -- 7 IsAlgebraicOfDegree
    (IsAlgebraicOfDegree (kthRootNat 11 2) 11 ∧
     IsAlgebraicOfDegree (kthRootNat 12 2) 12 ∧
     IsAlgebraicOfDegree (kthRootNat 13 2) 13 ∧
     IsAlgebraicOfDegree (kthRootNat 14 2) 14 ∧
     IsAlgebraicOfDegree (kthRootNat 15 2) 15 ∧
     IsAlgebraicOfDegree (kthRootNat 6 11) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 7 11) 7) ∧
    -- 7 IsAlgebraic ℤ
    (IsAlgebraic ℤ (kthRootNat 11 2) ∧
     IsAlgebraic ℤ (kthRootNat 12 2) ∧
     IsAlgebraic ℤ (kthRootNat 13 2) ∧
     IsAlgebraic ℤ (kthRootNat 14 2) ∧
     IsAlgebraic ℤ (kthRootNat 15 2) ∧
     IsAlgebraic ℤ (kthRootNat 6 11) ∧
     IsAlgebraic ℤ (kthRootNat 7 11)) :=
  ⟨⟨T5_isAlgebraicOfDegree_11root_2_concrete,
    T5_isAlgebraicOfDegree_12root_2_concrete,
    T5_isAlgebraicOfDegree_13root_2_concrete,
    T5_isAlgebraicOfDegree_14root_2_concrete,
    T5_isAlgebraicOfDegree_15root_2_concrete,
    T5_isAlgebraicOfDegree_sextic_root_11_concrete,
    T5_isAlgebraicOfDegree_septic_root_11_concrete⟩,
   ⟨T5_IsAlgebraic_int_11root_2_concrete,
    T5_IsAlgebraic_int_12root_2_concrete,
    T5_IsAlgebraic_int_13root_2_concrete,
    T5_IsAlgebraic_int_14root_2_concrete,
    T5_IsAlgebraic_int_15root_2_concrete,
    T5_IsAlgebraic_int_sextic_root_11_concrete,
    T5_IsAlgebraic_int_septic_root_11_concrete⟩⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXII
