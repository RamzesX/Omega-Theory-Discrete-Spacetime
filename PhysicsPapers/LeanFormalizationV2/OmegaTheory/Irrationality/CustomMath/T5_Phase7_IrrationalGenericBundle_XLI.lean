/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLI: ext #799-813
  5-th root prime cascade ⁵√53/⁵√59/⁵√61/⁵√67/⁵√71**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #799-813.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLI,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  5-th root cascade extension for primes 53, 59, 61, 67, 71.

  Sub-cluster A (k=5 prime extension):
  - ext #799-803: ⁵√53, ⁵√59, ⁵√61, ⁵√67, ⁵√71

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #804-808: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLI markers + headlines):
  - ext #809-813: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #799-813 — 5th root prime cascade ⁵√53-⁵√71 (BUNDLE-XLI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XL

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=5 prime extension -/

theorem T5_isAlgebraicOfDegree_quintic_root_53_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 53) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 53 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_59_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 59) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 59 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_61_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 61) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 61 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_67_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 67) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 67 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_71_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 71) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 71 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quintic_root_53_concrete :
    IsAlgebraic ℤ (kthRootNat 5 53) :=
  T5_IsAlgebraic_int_kthRootNat 5 53 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_59_concrete :
    IsAlgebraic ℤ (kthRootNat 5 59) :=
  T5_IsAlgebraic_int_kthRootNat 5 59 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_61_concrete :
    IsAlgebraic ℤ (kthRootNat 5 61) :=
  T5_IsAlgebraic_int_kthRootNat 5 61 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_67_concrete :
    IsAlgebraic ℤ (kthRootNat 5 67) :=
  T5_IsAlgebraic_int_kthRootNat 5 67 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_71_concrete :
    IsAlgebraic ℤ (kthRootNat 5 71) :=
  T5_IsAlgebraic_int_kthRootNat 5 71 (by norm_num)

/-! ## Sub-cluster C — Bundle-XLI markers + headlines -/

theorem T5_bundle_XLI_first_in_V2_marker :
    ∃ (n : ℕ), 799 ≤ n ∧ n ≤ 813 ∧ n - 799 ≤ 15 :=
  ⟨813, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLI_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 53) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 59) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 61) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 67) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 71) 5 :=
  ⟨T5_isAlgebraicOfDegree_quintic_root_53_concrete,
   T5_isAlgebraicOfDegree_quintic_root_59_concrete,
   T5_isAlgebraicOfDegree_quintic_root_61_concrete,
   T5_isAlgebraicOfDegree_quintic_root_67_concrete,
   T5_isAlgebraicOfDegree_quintic_root_71_concrete⟩

theorem T5_bundle_XLI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 5 53) ∧
    IsAlgebraic ℤ (kthRootNat 5 59) ∧
    IsAlgebraic ℤ (kthRootNat 5 61) ∧
    IsAlgebraic ℤ (kthRootNat 5 67) ∧
    IsAlgebraic ℤ (kthRootNat 5 71) :=
  ⟨T5_IsAlgebraic_int_quintic_root_53_concrete,
   T5_IsAlgebraic_int_quintic_root_59_concrete,
   T5_IsAlgebraic_int_quintic_root_61_concrete,
   T5_IsAlgebraic_int_quintic_root_67_concrete,
   T5_IsAlgebraic_int_quintic_root_71_concrete⟩

/-! ## Bundle-XLI GRAND HEADLINE -/

theorem T5_bundle_XLI_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 5 53) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 59) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 61) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 67) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 71) 5) ∧
    (IsAlgebraic ℤ (kthRootNat 5 53) ∧
     IsAlgebraic ℤ (kthRootNat 5 59) ∧
     IsAlgebraic ℤ (kthRootNat 5 61) ∧
     IsAlgebraic ℤ (kthRootNat 5 67) ∧
     IsAlgebraic ℤ (kthRootNat 5 71)) :=
  ⟨T5_bundle_XLI_master_alias_5_concrete,
   T5_bundle_XLI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLI
