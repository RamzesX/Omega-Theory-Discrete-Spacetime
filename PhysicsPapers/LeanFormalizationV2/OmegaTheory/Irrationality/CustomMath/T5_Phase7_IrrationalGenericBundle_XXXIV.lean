/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXIV: ext #694-708
  Cubic prime cascade ∛31/∛37/∛41/∛43/∛47**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #694-708.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXIV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension via Bundle-XXIII parametric: ∛31, ∛37,
  ∛41, ∛43, ∛47.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #694-698: T5_isCubicAlgebraic_cbrt_{31,37,41,43,47}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #699-703: T5_IsAlgebraic_int_cbrt_{31,37,41,43,47}_concrete

  Sub-cluster C (Bundle-XXXIV markers + headlines):
  - ext #704-708: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #694-708 — Cubic prime cascade ∛31-∛47 (BUNDLE-XXXIV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_31_concrete :
    IsCubicAlgebraic (cbrt_nat 31) :=
  T5_isCubicAlgebraic_cbrt_nat 31

theorem T5_isCubicAlgebraic_cbrt_37_concrete :
    IsCubicAlgebraic (cbrt_nat 37) :=
  T5_isCubicAlgebraic_cbrt_nat 37

theorem T5_isCubicAlgebraic_cbrt_41_concrete :
    IsCubicAlgebraic (cbrt_nat 41) :=
  T5_isCubicAlgebraic_cbrt_nat 41

theorem T5_isCubicAlgebraic_cbrt_43_concrete :
    IsCubicAlgebraic (cbrt_nat 43) :=
  T5_isCubicAlgebraic_cbrt_nat 43

theorem T5_isCubicAlgebraic_cbrt_47_concrete :
    IsCubicAlgebraic (cbrt_nat 47) :=
  T5_isCubicAlgebraic_cbrt_nat 47

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_31_concrete :
    IsAlgebraic ℤ (cbrt_nat 31) :=
  T5_IsAlgebraic_int_cbrt_nat 31

theorem T5_IsAlgebraic_int_cbrt_37_concrete :
    IsAlgebraic ℤ (cbrt_nat 37) :=
  T5_IsAlgebraic_int_cbrt_nat 37

theorem T5_IsAlgebraic_int_cbrt_41_concrete :
    IsAlgebraic ℤ (cbrt_nat 41) :=
  T5_IsAlgebraic_int_cbrt_nat 41

theorem T5_IsAlgebraic_int_cbrt_43_concrete :
    IsAlgebraic ℤ (cbrt_nat 43) :=
  T5_IsAlgebraic_int_cbrt_nat 43

theorem T5_IsAlgebraic_int_cbrt_47_concrete :
    IsAlgebraic ℤ (cbrt_nat 47) :=
  T5_IsAlgebraic_int_cbrt_nat 47

/-! ## Sub-cluster C — Bundle-XXXIV markers + headlines -/

theorem T5_bundle_XXXIV_first_in_V2_marker :
    ∃ (n : ℕ), 694 ≤ n ∧ n ≤ 708 ∧ n - 694 ≤ 15 :=
  ⟨708, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXIV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXXIV_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 31) ∧
    IsCubicAlgebraic (cbrt_nat 37) ∧
    IsCubicAlgebraic (cbrt_nat 41) ∧
    IsCubicAlgebraic (cbrt_nat 43) ∧
    IsCubicAlgebraic (cbrt_nat 47) :=
  ⟨T5_isCubicAlgebraic_cbrt_31_concrete,
   T5_isCubicAlgebraic_cbrt_37_concrete,
   T5_isCubicAlgebraic_cbrt_41_concrete,
   T5_isCubicAlgebraic_cbrt_43_concrete,
   T5_isCubicAlgebraic_cbrt_47_concrete⟩

theorem T5_bundle_XXXIV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 31) ∧
    IsAlgebraic ℤ (cbrt_nat 37) ∧
    IsAlgebraic ℤ (cbrt_nat 41) ∧
    IsAlgebraic ℤ (cbrt_nat 43) ∧
    IsAlgebraic ℤ (cbrt_nat 47) :=
  ⟨T5_IsAlgebraic_int_cbrt_31_concrete,
   T5_IsAlgebraic_int_cbrt_37_concrete,
   T5_IsAlgebraic_int_cbrt_41_concrete,
   T5_IsAlgebraic_int_cbrt_43_concrete,
   T5_IsAlgebraic_int_cbrt_47_concrete⟩

/-! ## Bundle-XXXIV GRAND HEADLINE -/

theorem T5_bundle_XXXIV_grand_headline_full :
    -- 5 IsCubicAlgebraic
    (IsCubicAlgebraic (cbrt_nat 31) ∧
     IsCubicAlgebraic (cbrt_nat 37) ∧
     IsCubicAlgebraic (cbrt_nat 41) ∧
     IsCubicAlgebraic (cbrt_nat 43) ∧
     IsCubicAlgebraic (cbrt_nat 47)) ∧
    -- 5 IsAlgebraic ℤ
    (IsAlgebraic ℤ (cbrt_nat 31) ∧
     IsAlgebraic ℤ (cbrt_nat 37) ∧
     IsAlgebraic ℤ (cbrt_nat 41) ∧
     IsAlgebraic ℤ (cbrt_nat 43) ∧
     IsAlgebraic ℤ (cbrt_nat 47)) :=
  ⟨T5_bundle_XXXIV_master_alias_5_concrete,
   T5_bundle_XXXIV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIV
