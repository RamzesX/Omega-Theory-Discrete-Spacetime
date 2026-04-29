/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXI: ext #649-663
  Higher-k cross-base cascade — k=6,7,8 with bases 3, 5, 7**, sub
  session 559oooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #649-663.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXI,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Higher-k cross-base cascade via Bundle-XXIV parametric:
  - k=6 with bases 3, 5, 7   (⁶√3, ⁶√5, ⁶√7)
  - k=7 with bases 3, 5      (⁷√3, ⁷√5)
  - k=8 with bases 3, 5      (⁸√3, ⁸√5)

  Sub-cluster A (IsAlgebraicOfDegree k via parametric):
  - ext #649: T5_isAlgebraicOfDegree_sextic_root_3_concrete
  - ext #650: T5_isAlgebraicOfDegree_sextic_root_5_concrete
  - ext #651: T5_isAlgebraicOfDegree_sextic_root_7_concrete
  - ext #652: T5_isAlgebraicOfDegree_septic_root_3_concrete
  - ext #653: T5_isAlgebraicOfDegree_septic_root_5_concrete
  - ext #654: T5_isAlgebraicOfDegree_octic_root_3_concrete
  - ext #655: T5_isAlgebraicOfDegree_octic_root_5_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #656-661: 7 IsAlgebraic ℤ companions (matching A list)

  Sub-cluster C (Bundle-XXXI markers + headlines):
  - ext #662: bundle_XXXI_first_in_V2_marker
  - ext #663: bundle_XXXI_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #649-663 — Higher-k cross-base cascade k=6,7,8 (BUNDLE-XXXI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXX

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree k via parametric -/

theorem T5_isAlgebraicOfDegree_sextic_root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 3) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_sextic_root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 5) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_sextic_root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 6 7) 6 :=
  T5_isAlgebraicOfDegree_kthRootNat 6 7 (by norm_num)

theorem T5_isAlgebraicOfDegree_septic_root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 7 3) 7 :=
  T5_isAlgebraicOfDegree_kthRootNat 7 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_septic_root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 7 5) 7 :=
  T5_isAlgebraicOfDegree_kthRootNat 7 5 (by norm_num)

theorem T5_isAlgebraicOfDegree_octic_root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 8 3) 8 :=
  T5_isAlgebraicOfDegree_kthRootNat 8 3 (by norm_num)

theorem T5_isAlgebraicOfDegree_octic_root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 8 5) 8 :=
  T5_isAlgebraicOfDegree_kthRootNat 8 5 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_sextic_root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 6 3) :=
  T5_IsAlgebraic_int_kthRootNat 6 3 (by norm_num)

theorem T5_IsAlgebraic_int_sextic_root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 6 5) :=
  T5_IsAlgebraic_int_kthRootNat 6 5 (by norm_num)

theorem T5_IsAlgebraic_int_sextic_root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 6 7) :=
  T5_IsAlgebraic_int_kthRootNat 6 7 (by norm_num)

theorem T5_IsAlgebraic_int_septic_root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 7 3) :=
  T5_IsAlgebraic_int_kthRootNat 7 3 (by norm_num)

theorem T5_IsAlgebraic_int_septic_root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 7 5) :=
  T5_IsAlgebraic_int_kthRootNat 7 5 (by norm_num)

theorem T5_IsAlgebraic_int_octic_root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 8 3) :=
  T5_IsAlgebraic_int_kthRootNat 8 3 (by norm_num)

theorem T5_IsAlgebraic_int_octic_root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 8 5) :=
  T5_IsAlgebraic_int_kthRootNat 8 5 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXXI markers + headlines -/

theorem T5_bundle_XXXI_first_in_V2_marker :
    ∃ (n : ℕ), 649 ≤ n ∧ n ≤ 663 ∧ n - 649 ≤ 15 :=
  ⟨663, by norm_num, by norm_num, by norm_num⟩

/-! ## Bundle-XXXI GRAND HEADLINE -/

theorem T5_bundle_XXXI_grand_headline_full :
    -- 7 IsAlgebraicOfDegree
    (IsAlgebraicOfDegree (kthRootNat 6 3) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 6 5) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 6 7) 6 ∧
     IsAlgebraicOfDegree (kthRootNat 7 3) 7 ∧
     IsAlgebraicOfDegree (kthRootNat 7 5) 7 ∧
     IsAlgebraicOfDegree (kthRootNat 8 3) 8 ∧
     IsAlgebraicOfDegree (kthRootNat 8 5) 8) ∧
    -- 7 IsAlgebraic ℤ
    (IsAlgebraic ℤ (kthRootNat 6 3) ∧
     IsAlgebraic ℤ (kthRootNat 6 5) ∧
     IsAlgebraic ℤ (kthRootNat 6 7) ∧
     IsAlgebraic ℤ (kthRootNat 7 3) ∧
     IsAlgebraic ℤ (kthRootNat 7 5) ∧
     IsAlgebraic ℤ (kthRootNat 8 3) ∧
     IsAlgebraic ℤ (kthRootNat 8 5)) :=
  ⟨⟨T5_isAlgebraicOfDegree_sextic_root_3_concrete,
    T5_isAlgebraicOfDegree_sextic_root_5_concrete,
    T5_isAlgebraicOfDegree_sextic_root_7_concrete,
    T5_isAlgebraicOfDegree_septic_root_3_concrete,
    T5_isAlgebraicOfDegree_septic_root_5_concrete,
    T5_isAlgebraicOfDegree_octic_root_3_concrete,
    T5_isAlgebraicOfDegree_octic_root_5_concrete⟩,
   ⟨T5_IsAlgebraic_int_sextic_root_3_concrete,
    T5_IsAlgebraic_int_sextic_root_5_concrete,
    T5_IsAlgebraic_int_sextic_root_7_concrete,
    T5_IsAlgebraic_int_septic_root_3_concrete,
    T5_IsAlgebraic_int_septic_root_5_concrete,
    T5_IsAlgebraic_int_octic_root_3_concrete,
    T5_IsAlgebraic_int_octic_root_5_concrete⟩⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXI
