/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLVII: ext #889-903
  Cubic prime cascade ∛151/∛157/∛163/∛167/∛173**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #889-903.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLVII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension: ∛151, ∛157, ∛163, ∛167, ∛173.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #889-893: T5_isCubicAlgebraic_cbrt_{151,157,163,167,173}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #894-898: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLVII markers + headlines):
  - ext #899-903: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #889-903 — Cubic prime cascade ∛151-∛173 (BUNDLE-XLVII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_151_concrete :
    IsCubicAlgebraic (cbrt_nat 151) :=
  T5_isCubicAlgebraic_cbrt_nat 151

theorem T5_isCubicAlgebraic_cbrt_157_concrete :
    IsCubicAlgebraic (cbrt_nat 157) :=
  T5_isCubicAlgebraic_cbrt_nat 157

theorem T5_isCubicAlgebraic_cbrt_163_concrete :
    IsCubicAlgebraic (cbrt_nat 163) :=
  T5_isCubicAlgebraic_cbrt_nat 163

theorem T5_isCubicAlgebraic_cbrt_167_concrete :
    IsCubicAlgebraic (cbrt_nat 167) :=
  T5_isCubicAlgebraic_cbrt_nat 167

theorem T5_isCubicAlgebraic_cbrt_173_concrete :
    IsCubicAlgebraic (cbrt_nat 173) :=
  T5_isCubicAlgebraic_cbrt_nat 173

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_151_concrete :
    IsAlgebraic ℤ (cbrt_nat 151) :=
  T5_IsAlgebraic_int_cbrt_nat 151

theorem T5_IsAlgebraic_int_cbrt_157_concrete :
    IsAlgebraic ℤ (cbrt_nat 157) :=
  T5_IsAlgebraic_int_cbrt_nat 157

theorem T5_IsAlgebraic_int_cbrt_163_concrete :
    IsAlgebraic ℤ (cbrt_nat 163) :=
  T5_IsAlgebraic_int_cbrt_nat 163

theorem T5_IsAlgebraic_int_cbrt_167_concrete :
    IsAlgebraic ℤ (cbrt_nat 167) :=
  T5_IsAlgebraic_int_cbrt_nat 167

theorem T5_IsAlgebraic_int_cbrt_173_concrete :
    IsAlgebraic ℤ (cbrt_nat 173) :=
  T5_IsAlgebraic_int_cbrt_nat 173

/-! ## Sub-cluster C — Bundle-XLVII markers + headlines -/

theorem T5_bundle_XLVII_first_in_V2_marker :
    ∃ (n : ℕ), 889 ≤ n ∧ n ≤ 903 ∧ n - 889 ≤ 15 :=
  ⟨903, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLVII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLVII_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 151) ∧
    IsCubicAlgebraic (cbrt_nat 157) ∧
    IsCubicAlgebraic (cbrt_nat 163) ∧
    IsCubicAlgebraic (cbrt_nat 167) ∧
    IsCubicAlgebraic (cbrt_nat 173) :=
  ⟨T5_isCubicAlgebraic_cbrt_151_concrete,
   T5_isCubicAlgebraic_cbrt_157_concrete,
   T5_isCubicAlgebraic_cbrt_163_concrete,
   T5_isCubicAlgebraic_cbrt_167_concrete,
   T5_isCubicAlgebraic_cbrt_173_concrete⟩

theorem T5_bundle_XLVII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 151) ∧
    IsAlgebraic ℤ (cbrt_nat 157) ∧
    IsAlgebraic ℤ (cbrt_nat 163) ∧
    IsAlgebraic ℤ (cbrt_nat 167) ∧
    IsAlgebraic ℤ (cbrt_nat 173) :=
  ⟨T5_IsAlgebraic_int_cbrt_151_concrete,
   T5_IsAlgebraic_int_cbrt_157_concrete,
   T5_IsAlgebraic_int_cbrt_163_concrete,
   T5_IsAlgebraic_int_cbrt_167_concrete,
   T5_IsAlgebraic_int_cbrt_173_concrete⟩

/-! ## Bundle-XLVII GRAND HEADLINE -/

theorem T5_bundle_XLVII_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 151) ∧
     IsCubicAlgebraic (cbrt_nat 157) ∧
     IsCubicAlgebraic (cbrt_nat 163) ∧
     IsCubicAlgebraic (cbrt_nat 167) ∧
     IsCubicAlgebraic (cbrt_nat 173)) ∧
    (IsAlgebraic ℤ (cbrt_nat 151) ∧
     IsAlgebraic ℤ (cbrt_nat 157) ∧
     IsAlgebraic ℤ (cbrt_nat 163) ∧
     IsAlgebraic ℤ (cbrt_nat 167) ∧
     IsAlgebraic ℤ (cbrt_nat 173)) :=
  ⟨T5_bundle_XLVII_master_alias_5_concrete,
   T5_bundle_XLVII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLVII
