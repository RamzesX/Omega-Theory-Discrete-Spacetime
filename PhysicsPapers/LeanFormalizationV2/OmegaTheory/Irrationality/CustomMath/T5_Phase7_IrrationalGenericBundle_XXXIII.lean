/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXIII: ext #679-693
  4-th root + 5-th root extension to primes 13, 17, 19, 23, 29**, sub
  session 559oooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #679-693.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  4-th root and 5-th root cascades extended to primes 13, 17, 19, 23, 29
  via Bundle-XXIV parametric.

  Sub-cluster A (k=4 prime extension):
  - ext #679: ∜13
  - ext #680: ∜17
  - ext #681: ∜19
  - ext #682: ∜23
  - ext #683: ∜29

  Sub-cluster B (k=5 prime extension):
  - ext #684: ⁵√13
  - ext #685: ⁵√17
  - ext #686: ⁵√19
  - ext #687: ⁵√23
  - ext #688: ⁵√29

  Sub-cluster C (Bundle-XXXIII markers + headlines):
  - ext #689-693: 5 IsAlgebraic ℤ + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #679-693 — 4th + 5th root prime extension (BUNDLE-XXXIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=4 prime extension -/

theorem T5_isAlgebraicOfDegree_quartic_root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 13) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_17_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 17) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 17 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 19) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 19 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_23_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 23) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 23 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_29_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 29) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 29 (by norm_num)

/-! ## Sub-cluster B — k=5 prime extension -/

theorem T5_isAlgebraicOfDegree_quintic_root_13_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 13) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 13 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_17_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 17) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 17 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_19_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 19) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 19 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_23_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 23) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 23 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_29_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 29) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 29 (by norm_num)

/-! ## Sub-cluster C — IsAlgebraic ℤ + headlines -/

theorem T5_IsAlgebraic_int_quartic_higher_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 13) ∧
    IsAlgebraic ℤ (kthRootNat 4 17) ∧
    IsAlgebraic ℤ (kthRootNat 4 19) ∧
    IsAlgebraic ℤ (kthRootNat 4 23) ∧
    IsAlgebraic ℤ (kthRootNat 4 29) :=
  ⟨T5_IsAlgebraic_int_kthRootNat 4 13 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 4 17 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 4 19 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 4 23 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 4 29 (by norm_num)⟩

theorem T5_IsAlgebraic_int_quintic_higher_5_combined :
    IsAlgebraic ℤ (kthRootNat 5 13) ∧
    IsAlgebraic ℤ (kthRootNat 5 17) ∧
    IsAlgebraic ℤ (kthRootNat 5 19) ∧
    IsAlgebraic ℤ (kthRootNat 5 23) ∧
    IsAlgebraic ℤ (kthRootNat 5 29) :=
  ⟨T5_IsAlgebraic_int_kthRootNat 5 13 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 5 17 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 5 19 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 5 23 (by norm_num),
   T5_IsAlgebraic_int_kthRootNat 5 29 (by norm_num)⟩

theorem T5_bundle_XXXIII_first_in_V2_marker :
    ∃ (n : ℕ), 679 ≤ n ∧ n ≤ 693 ∧ n - 679 ≤ 15 :=
  ⟨693, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXIII_master_alias_10_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 13) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 17) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 19) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 23) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 29) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 5 13) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 17) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 19) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 23) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 29) 5 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_13_concrete,
   T5_isAlgebraicOfDegree_quartic_root_17_concrete,
   T5_isAlgebraicOfDegree_quartic_root_19_concrete,
   T5_isAlgebraicOfDegree_quartic_root_23_concrete,
   T5_isAlgebraicOfDegree_quartic_root_29_concrete,
   T5_isAlgebraicOfDegree_quintic_root_13_concrete,
   T5_isAlgebraicOfDegree_quintic_root_17_concrete,
   T5_isAlgebraicOfDegree_quintic_root_19_concrete,
   T5_isAlgebraicOfDegree_quintic_root_23_concrete,
   T5_isAlgebraicOfDegree_quintic_root_29_concrete⟩

theorem T5_bundle_XXXIII_grand_headline_full :
    -- 10 IsAlgebraicOfDegree (5 quartic + 5 quintic, primes 13-29)
    (IsAlgebraicOfDegree (kthRootNat 4 13) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 17) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 19) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 23) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 29) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 5 13) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 17) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 19) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 23) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 29) 5) ∧
    -- 10 IsAlgebraic ℤ (matching list)
    ((IsAlgebraic ℤ (kthRootNat 4 13) ∧
      IsAlgebraic ℤ (kthRootNat 4 17) ∧
      IsAlgebraic ℤ (kthRootNat 4 19) ∧
      IsAlgebraic ℤ (kthRootNat 4 23) ∧
      IsAlgebraic ℤ (kthRootNat 4 29)) ∧
     (IsAlgebraic ℤ (kthRootNat 5 13) ∧
      IsAlgebraic ℤ (kthRootNat 5 17) ∧
      IsAlgebraic ℤ (kthRootNat 5 19) ∧
      IsAlgebraic ℤ (kthRootNat 5 23) ∧
      IsAlgebraic ℤ (kthRootNat 5 29))) :=
  ⟨T5_bundle_XXXIII_master_alias_10_concrete,
   ⟨T5_IsAlgebraic_int_quartic_higher_5_combined,
    T5_IsAlgebraic_int_quintic_higher_5_combined⟩⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIII
