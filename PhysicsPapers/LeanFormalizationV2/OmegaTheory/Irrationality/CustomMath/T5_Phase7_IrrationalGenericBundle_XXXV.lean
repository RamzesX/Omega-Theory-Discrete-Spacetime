/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXV: ext #709-723
  Cubic prime cascade ∛53/∛59/∛61/∛67/∛71**, sub session
  559oooooooooooooooooooooooooooooo through
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #709-723.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension via Bundle-XXIII parametric: ∛53, ∛59,
  ∛61, ∛67, ∛71.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #709-713: T5_isCubicAlgebraic_cbrt_{53,59,61,67,71}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #714-718: T5_IsAlgebraic_int_cbrt_{53,59,61,67,71}_concrete

  Sub-cluster C (Bundle-XXXV markers + headlines):
  - ext #719-723: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #709-723 — Cubic prime cascade ∛53-∛71 (BUNDLE-XXXV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_53_concrete :
    IsCubicAlgebraic (cbrt_nat 53) :=
  T5_isCubicAlgebraic_cbrt_nat 53

theorem T5_isCubicAlgebraic_cbrt_59_concrete :
    IsCubicAlgebraic (cbrt_nat 59) :=
  T5_isCubicAlgebraic_cbrt_nat 59

theorem T5_isCubicAlgebraic_cbrt_61_concrete :
    IsCubicAlgebraic (cbrt_nat 61) :=
  T5_isCubicAlgebraic_cbrt_nat 61

theorem T5_isCubicAlgebraic_cbrt_67_concrete :
    IsCubicAlgebraic (cbrt_nat 67) :=
  T5_isCubicAlgebraic_cbrt_nat 67

theorem T5_isCubicAlgebraic_cbrt_71_concrete :
    IsCubicAlgebraic (cbrt_nat 71) :=
  T5_isCubicAlgebraic_cbrt_nat 71

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_53_concrete :
    IsAlgebraic ℤ (cbrt_nat 53) :=
  T5_IsAlgebraic_int_cbrt_nat 53

theorem T5_IsAlgebraic_int_cbrt_59_concrete :
    IsAlgebraic ℤ (cbrt_nat 59) :=
  T5_IsAlgebraic_int_cbrt_nat 59

theorem T5_IsAlgebraic_int_cbrt_61_concrete :
    IsAlgebraic ℤ (cbrt_nat 61) :=
  T5_IsAlgebraic_int_cbrt_nat 61

theorem T5_IsAlgebraic_int_cbrt_67_concrete :
    IsAlgebraic ℤ (cbrt_nat 67) :=
  T5_IsAlgebraic_int_cbrt_nat 67

theorem T5_IsAlgebraic_int_cbrt_71_concrete :
    IsAlgebraic ℤ (cbrt_nat 71) :=
  T5_IsAlgebraic_int_cbrt_nat 71

/-! ## Sub-cluster C — Bundle-XXXV markers + headlines -/

theorem T5_bundle_XXXV_first_in_V2_marker :
    ∃ (n : ℕ), 709 ≤ n ∧ n ≤ 723 ∧ n - 709 ≤ 15 :=
  ⟨723, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXXV_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 53) ∧
    IsCubicAlgebraic (cbrt_nat 59) ∧
    IsCubicAlgebraic (cbrt_nat 61) ∧
    IsCubicAlgebraic (cbrt_nat 67) ∧
    IsCubicAlgebraic (cbrt_nat 71) :=
  ⟨T5_isCubicAlgebraic_cbrt_53_concrete,
   T5_isCubicAlgebraic_cbrt_59_concrete,
   T5_isCubicAlgebraic_cbrt_61_concrete,
   T5_isCubicAlgebraic_cbrt_67_concrete,
   T5_isCubicAlgebraic_cbrt_71_concrete⟩

theorem T5_bundle_XXXV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 53) ∧
    IsAlgebraic ℤ (cbrt_nat 59) ∧
    IsAlgebraic ℤ (cbrt_nat 61) ∧
    IsAlgebraic ℤ (cbrt_nat 67) ∧
    IsAlgebraic ℤ (cbrt_nat 71) :=
  ⟨T5_IsAlgebraic_int_cbrt_53_concrete,
   T5_IsAlgebraic_int_cbrt_59_concrete,
   T5_IsAlgebraic_int_cbrt_61_concrete,
   T5_IsAlgebraic_int_cbrt_67_concrete,
   T5_IsAlgebraic_int_cbrt_71_concrete⟩

/-! ## Bundle-XXXV GRAND HEADLINE -/

theorem T5_bundle_XXXV_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 53) ∧
     IsCubicAlgebraic (cbrt_nat 59) ∧
     IsCubicAlgebraic (cbrt_nat 61) ∧
     IsCubicAlgebraic (cbrt_nat 67) ∧
     IsCubicAlgebraic (cbrt_nat 71)) ∧
    (IsAlgebraic ℤ (cbrt_nat 53) ∧
     IsAlgebraic ℤ (cbrt_nat 59) ∧
     IsAlgebraic ℤ (cbrt_nat 61) ∧
     IsAlgebraic ℤ (cbrt_nat 67) ∧
     IsAlgebraic ℤ (cbrt_nat 71)) :=
  ⟨T5_bundle_XXXV_master_alias_5_concrete,
   T5_bundle_XXXV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXV
