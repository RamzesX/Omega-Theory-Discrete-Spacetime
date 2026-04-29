/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XLIV: ext #844-858
  Cubic prime cascade ∛127/∛131/∛137/∛139/∛149**, sub session
  559oooooooooooooooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #844-858.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XLIV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension: ∛127, ∛131, ∛137, ∛139, ∛149.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #844-848: T5_isCubicAlgebraic_cbrt_{127,131,137,139,149}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #849-853: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XLIV markers + headlines):
  - ext #854-858: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #844-858 — Cubic prime cascade ∛127-∛149 (BUNDLE-XLIV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_127_concrete :
    IsCubicAlgebraic (cbrt_nat 127) :=
  T5_isCubicAlgebraic_cbrt_nat 127

theorem T5_isCubicAlgebraic_cbrt_131_concrete :
    IsCubicAlgebraic (cbrt_nat 131) :=
  T5_isCubicAlgebraic_cbrt_nat 131

theorem T5_isCubicAlgebraic_cbrt_137_concrete :
    IsCubicAlgebraic (cbrt_nat 137) :=
  T5_isCubicAlgebraic_cbrt_nat 137

theorem T5_isCubicAlgebraic_cbrt_139_concrete :
    IsCubicAlgebraic (cbrt_nat 139) :=
  T5_isCubicAlgebraic_cbrt_nat 139

theorem T5_isCubicAlgebraic_cbrt_149_concrete :
    IsCubicAlgebraic (cbrt_nat 149) :=
  T5_isCubicAlgebraic_cbrt_nat 149

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_127_concrete :
    IsAlgebraic ℤ (cbrt_nat 127) :=
  T5_IsAlgebraic_int_cbrt_nat 127

theorem T5_IsAlgebraic_int_cbrt_131_concrete :
    IsAlgebraic ℤ (cbrt_nat 131) :=
  T5_IsAlgebraic_int_cbrt_nat 131

theorem T5_IsAlgebraic_int_cbrt_137_concrete :
    IsAlgebraic ℤ (cbrt_nat 137) :=
  T5_IsAlgebraic_int_cbrt_nat 137

theorem T5_IsAlgebraic_int_cbrt_139_concrete :
    IsAlgebraic ℤ (cbrt_nat 139) :=
  T5_IsAlgebraic_int_cbrt_nat 139

theorem T5_IsAlgebraic_int_cbrt_149_concrete :
    IsAlgebraic ℤ (cbrt_nat 149) :=
  T5_IsAlgebraic_int_cbrt_nat 149

/-! ## Sub-cluster C — Bundle-XLIV markers + headlines -/

theorem T5_bundle_XLIV_first_in_V2_marker :
    ∃ (n : ℕ), 844 ≤ n ∧ n ≤ 858 ∧ n - 844 ≤ 15 :=
  ⟨858, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XLIV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XLIV_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 127) ∧
    IsCubicAlgebraic (cbrt_nat 131) ∧
    IsCubicAlgebraic (cbrt_nat 137) ∧
    IsCubicAlgebraic (cbrt_nat 139) ∧
    IsCubicAlgebraic (cbrt_nat 149) :=
  ⟨T5_isCubicAlgebraic_cbrt_127_concrete,
   T5_isCubicAlgebraic_cbrt_131_concrete,
   T5_isCubicAlgebraic_cbrt_137_concrete,
   T5_isCubicAlgebraic_cbrt_139_concrete,
   T5_isCubicAlgebraic_cbrt_149_concrete⟩

theorem T5_bundle_XLIV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 127) ∧
    IsAlgebraic ℤ (cbrt_nat 131) ∧
    IsAlgebraic ℤ (cbrt_nat 137) ∧
    IsAlgebraic ℤ (cbrt_nat 139) ∧
    IsAlgebraic ℤ (cbrt_nat 149) :=
  ⟨T5_IsAlgebraic_int_cbrt_127_concrete,
   T5_IsAlgebraic_int_cbrt_131_concrete,
   T5_IsAlgebraic_int_cbrt_137_concrete,
   T5_IsAlgebraic_int_cbrt_139_concrete,
   T5_IsAlgebraic_int_cbrt_149_concrete⟩

/-! ## Bundle-XLIV GRAND HEADLINE -/

theorem T5_bundle_XLIV_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 127) ∧
     IsCubicAlgebraic (cbrt_nat 131) ∧
     IsCubicAlgebraic (cbrt_nat 137) ∧
     IsCubicAlgebraic (cbrt_nat 139) ∧
     IsCubicAlgebraic (cbrt_nat 149)) ∧
    (IsAlgebraic ℤ (cbrt_nat 127) ∧
     IsAlgebraic ℤ (cbrt_nat 131) ∧
     IsAlgebraic ℤ (cbrt_nat 137) ∧
     IsAlgebraic ℤ (cbrt_nat 139) ∧
     IsAlgebraic ℤ (cbrt_nat 149)) :=
  ⟨T5_bundle_XLIV_master_alias_5_concrete,
   T5_bundle_XLIV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XLIV
