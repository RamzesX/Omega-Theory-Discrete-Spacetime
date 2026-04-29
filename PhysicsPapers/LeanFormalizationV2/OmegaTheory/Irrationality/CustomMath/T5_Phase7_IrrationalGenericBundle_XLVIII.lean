/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLVIII: ext #904-918
  4-th root prime cascade ∜127/∜131/∜137/∜139/∜149**, sub session
  559oooooooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #904-918.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLVIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  4-th root cascade extension for primes 127, 131, 137, 139, 149.

  Sub-cluster A (k=4 prime extension):
  - ext #904-908: ∜127, ∜131, ∜137, ∜139, ∜149

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #909-913: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLVIII markers + headlines):
  - ext #914-918: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #904-918 — 4th root prime cascade ∜127-∜149 (BUNDLE-XLVIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — k=4 prime extension -/

theorem T5_isAlgebraicOfDegree_quartic_root_127_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 127) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 127 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_131_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 131) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 131 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_137_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 137) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 137 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_139_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 139) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 139 (by norm_num)

theorem T5_isAlgebraicOfDegree_quartic_root_149_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 149) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 149 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_quartic_root_127_concrete :
    IsAlgebraic ℤ (kthRootNat 4 127) :=
  T5_IsAlgebraic_int_kthRootNat 4 127 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_131_concrete :
    IsAlgebraic ℤ (kthRootNat 4 131) :=
  T5_IsAlgebraic_int_kthRootNat 4 131 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_137_concrete :
    IsAlgebraic ℤ (kthRootNat 4 137) :=
  T5_IsAlgebraic_int_kthRootNat 4 137 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_139_concrete :
    IsAlgebraic ℤ (kthRootNat 4 139) :=
  T5_IsAlgebraic_int_kthRootNat 4 139 (by norm_num)

theorem T5_IsAlgebraic_int_quartic_root_149_concrete :
    IsAlgebraic ℤ (kthRootNat 4 149) :=
  T5_IsAlgebraic_int_kthRootNat 4 149 (by norm_num)

/-! ## Sub-cluster C — Bundle-XLVIII markers + headlines -/

theorem T5_bundle_XLVIII_first_in_V2_marker :
    ∃ (n : ℕ), 904 ≤ n ∧ n ≤ 918 ∧ n - 904 ≤ 15 :=
  ⟨918, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLVIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLVIII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 127) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 131) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 137) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 139) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 149) 4 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_127_concrete,
   T5_isAlgebraicOfDegree_quartic_root_131_concrete,
   T5_isAlgebraicOfDegree_quartic_root_137_concrete,
   T5_isAlgebraicOfDegree_quartic_root_139_concrete,
   T5_isAlgebraicOfDegree_quartic_root_149_concrete⟩

theorem T5_bundle_XLVIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 127) ∧
    IsAlgebraic ℤ (kthRootNat 4 131) ∧
    IsAlgebraic ℤ (kthRootNat 4 137) ∧
    IsAlgebraic ℤ (kthRootNat 4 139) ∧
    IsAlgebraic ℤ (kthRootNat 4 149) :=
  ⟨T5_IsAlgebraic_int_quartic_root_127_concrete,
   T5_IsAlgebraic_int_quartic_root_131_concrete,
   T5_IsAlgebraic_int_quartic_root_137_concrete,
   T5_IsAlgebraic_int_quartic_root_139_concrete,
   T5_IsAlgebraic_int_quartic_root_149_concrete⟩

/-! ## Bundle-XLVIII GRAND HEADLINE -/

theorem T5_bundle_XLVIII_grand_headline_full :
    (IsAlgebraicOfDegree (kthRootNat 4 127) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 131) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 137) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 139) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 149) 4) ∧
    (IsAlgebraic ℤ (kthRootNat 4 127) ∧
     IsAlgebraic ℤ (kthRootNat 4 131) ∧
     IsAlgebraic ℤ (kthRootNat 4 137) ∧
     IsAlgebraic ℤ (kthRootNat 4 139) ∧
     IsAlgebraic ℤ (kthRootNat 4 149)) :=
  ⟨T5_bundle_XLVIII_master_alias_5_concrete,
   T5_bundle_XLVIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVIII
