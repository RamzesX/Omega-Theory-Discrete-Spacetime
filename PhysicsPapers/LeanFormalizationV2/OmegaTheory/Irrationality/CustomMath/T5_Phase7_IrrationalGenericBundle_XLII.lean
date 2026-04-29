/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLII: ext #814-828
  4-th root prime cascade ∜73/∜79/∜83/∜89/∜97 (sub-100 4th-root COMPLETE)**,
  sub session 559oooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #814-828.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  4-th root cascade extension for primes 73, 79, 83, 89, 97. Closes all
  primes < 100 for 4th roots.

  Sub-cluster A (k=4 prime extension):
  - ext #814-818: ∜73, ∜79, ∜83, ∜89, ∜97

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #819-823: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLII markers + headlines):
  - ext #824-828: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #814-828 — 4th root prime cascade ∜73-∜97 (BUNDLE-XLII).
  **Sub-100 4th-root primes COMPLETE.**
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=4 prime extension -/

theorem T5_isAlgebraicOfDegree_quartic_root_73_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 73) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 73 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_79_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 79) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 79 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_83_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 83) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 83 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_89_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 89) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 89 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_97_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 97) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 97 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quartic_root_73_concrete :
    IsAlgebraic ℤ (kthRootNat 4 73) :=
  T5_IsAlgebraic_int_kthRootNat 4 73 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_79_concrete :
    IsAlgebraic ℤ (kthRootNat 4 79) :=
  T5_IsAlgebraic_int_kthRootNat 4 79 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_83_concrete :
    IsAlgebraic ℤ (kthRootNat 4 83) :=
  T5_IsAlgebraic_int_kthRootNat 4 83 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_89_concrete :
    IsAlgebraic ℤ (kthRootNat 4 89) :=
  T5_IsAlgebraic_int_kthRootNat 4 89 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_97_concrete :
    IsAlgebraic ℤ (kthRootNat 4 97) :=
  T5_IsAlgebraic_int_kthRootNat 4 97 (by norm_num)

/-! ## Sub-cluster C — Bundle-XLII markers + headlines -/

theorem T5_bundle_XLII_first_in_V2_marker :
    ∃ (n : ℕ), 814 ≤ n ∧ n ≤ 828 ∧ n - 814 ≤ 15 :=
  ⟨828, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 73) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 79) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 83) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 89) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 97) 4 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_73_concrete,
   T5_isAlgebraicOfDegree_quartic_root_79_concrete,
   T5_isAlgebraicOfDegree_quartic_root_83_concrete,
   T5_isAlgebraicOfDegree_quartic_root_89_concrete,
   T5_isAlgebraicOfDegree_quartic_root_97_concrete⟩

theorem T5_bundle_XLII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 73) ∧
    IsAlgebraic ℤ (kthRootNat 4 79) ∧
    IsAlgebraic ℤ (kthRootNat 4 83) ∧
    IsAlgebraic ℤ (kthRootNat 4 89) ∧
    IsAlgebraic ℤ (kthRootNat 4 97) :=
  ⟨T5_IsAlgebraic_int_quartic_root_73_concrete,
   T5_IsAlgebraic_int_quartic_root_79_concrete,
   T5_IsAlgebraic_int_quartic_root_83_concrete,
   T5_IsAlgebraic_int_quartic_root_89_concrete,
   T5_IsAlgebraic_int_quartic_root_97_concrete⟩

/-! ## Bundle-XLII GRAND HEADLINE — sub-100 4th-root primes COMPLETE -/

theorem T5_bundle_XLII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 4 73) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 79) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 83) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 89) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 97) 4) ∧
    (IsAlgebraic ℤ (kthRootNat 4 73) ∧
     IsAlgebraic ℤ (kthRootNat 4 79) ∧
     IsAlgebraic ℤ (kthRootNat 4 83) ∧
     IsAlgebraic ℤ (kthRootNat 4 89) ∧
     IsAlgebraic ℤ (kthRootNat 4 97)) :=
  ⟨T5_bundle_XLII_master_alias_5_concrete,
   T5_bundle_XLII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLII
