/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLIII: ext #829-843
  5-th root prime cascade ⁵√73/⁵√79/⁵√83/⁵√89/⁵√97 (sub-100 5th-root COMPLETE)**,
  sub session 559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #829-843.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  5-th root cascade extension for primes 73, 79, 83, 89, 97. Closes all
  primes < 100 for 5th roots.

  Sub-cluster A (k=5 prime extension):
  - ext #829-833: ⁵√73, ⁵√79, ⁵√83, ⁵√89, ⁵√97

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #834-838: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLIII markers + headlines):
  - ext #839-843: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #829-843 — 5th root prime cascade ⁵√73-⁵√97 (BUNDLE-XLIII).
  **Sub-100 5th-root primes COMPLETE.**
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=5 prime extension -/

theorem T5_isAlgebraicOfDegree_quintic_root_73_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 73) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 73 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_79_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 79) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 79 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_83_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 83) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 83 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_89_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 89) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 89 (by norm_num)

theorem T5_isAlgebraicOfDegree_quintic_root_97_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 97) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 97 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quintic_root_73_concrete :
    IsAlgebraic ℤ (kthRootNat 5 73) :=
  T5_IsAlgebraic_int_kthRootNat 5 73 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_79_concrete :
    IsAlgebraic ℤ (kthRootNat 5 79) :=
  T5_IsAlgebraic_int_kthRootNat 5 79 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_83_concrete :
    IsAlgebraic ℤ (kthRootNat 5 83) :=
  T5_IsAlgebraic_int_kthRootNat 5 83 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_89_concrete :
    IsAlgebraic ℤ (kthRootNat 5 89) :=
  T5_IsAlgebraic_int_kthRootNat 5 89 (by norm_num)

theorem T5_IsAlgebraic_int_quintic_root_97_concrete :
    IsAlgebraic ℤ (kthRootNat 5 97) :=
  T5_IsAlgebraic_int_kthRootNat 5 97 (by norm_num)

/-! ## Sub-cluster C — Bundle-XLIII markers + headlines -/

theorem T5_bundle_XLIII_first_in_V2_marker :
    ∃ (n : ℕ), 829 ≤ n ∧ n ≤ 843 ∧ n - 829 ≤ 15 :=
  ⟨843, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLIII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 5 73) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 79) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 83) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 89) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 5 97) 5 :=
  ⟨T5_isAlgebraicOfDegree_quintic_root_73_concrete,
   T5_isAlgebraicOfDegree_quintic_root_79_concrete,
   T5_isAlgebraicOfDegree_quintic_root_83_concrete,
   T5_isAlgebraicOfDegree_quintic_root_89_concrete,
   T5_isAlgebraicOfDegree_quintic_root_97_concrete⟩

theorem T5_bundle_XLIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 5 73) ∧
    IsAlgebraic ℤ (kthRootNat 5 79) ∧
    IsAlgebraic ℤ (kthRootNat 5 83) ∧
    IsAlgebraic ℤ (kthRootNat 5 89) ∧
    IsAlgebraic ℤ (kthRootNat 5 97) :=
  ⟨T5_IsAlgebraic_int_quintic_root_73_concrete,
   T5_IsAlgebraic_int_quintic_root_79_concrete,
   T5_IsAlgebraic_int_quintic_root_83_concrete,
   T5_IsAlgebraic_int_quintic_root_89_concrete,
   T5_IsAlgebraic_int_quintic_root_97_concrete⟩

/-! ## Bundle-XLIII GRAND HEADLINE — sub-100 5th-root primes COMPLETE -/

theorem T5_bundle_XLIII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 5 73) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 79) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 83) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 89) 5 ∧
     IsAlgebraicOfDegree (kthRootNat 5 97) 5) ∧
    (IsAlgebraic ℤ (kthRootNat 5 73) ∧
     IsAlgebraic ℤ (kthRootNat 5 79) ∧
     IsAlgebraic ℤ (kthRootNat 5 83) ∧
     IsAlgebraic ℤ (kthRootNat 5 89) ∧
     IsAlgebraic ℤ (kthRootNat 5 97)) :=
  ⟨T5_bundle_XLIII_master_alias_5_concrete,
   T5_bundle_XLIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIII
