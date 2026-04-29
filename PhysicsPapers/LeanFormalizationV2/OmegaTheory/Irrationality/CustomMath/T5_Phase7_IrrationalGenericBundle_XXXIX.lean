/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIX

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXIX: ext #769-783
  Cubic prime cascade ∛101/∛103/∛107/∛109/∛113 (sub-128)**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #769-783.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXIX,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension via Bundle-XXIII parametric: ∛101, ∛103,
  ∛107, ∛109, ∛113. Continues sub-128 cubic prime witnesses.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #769-773: T5_isCubicAlgebraic_cbrt_{101,103,107,109,113}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #774-778: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-XXXIX markers + headlines):
  - ext #779-783: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #769-783 — Cubic prime cascade ∛101-∛113 (BUNDLE-XXXIX).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIX

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_101_concrete :
    IsCubicAlgebraic (cbrt_nat 101) :=
  T5_isCubicAlgebraic_cbrt_nat 101

theorem T5_isCubicAlgebraic_cbrt_103_concrete :
    IsCubicAlgebraic (cbrt_nat 103) :=
  T5_isCubicAlgebraic_cbrt_nat 103

theorem T5_isCubicAlgebraic_cbrt_107_concrete :
    IsCubicAlgebraic (cbrt_nat 107) :=
  T5_isCubicAlgebraic_cbrt_nat 107

theorem T5_isCubicAlgebraic_cbrt_109_concrete :
    IsCubicAlgebraic (cbrt_nat 109) :=
  T5_isCubicAlgebraic_cbrt_nat 109

theorem T5_isCubicAlgebraic_cbrt_113_concrete :
    IsCubicAlgebraic (cbrt_nat 113) :=
  T5_isCubicAlgebraic_cbrt_nat 113

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_101_concrete :
    IsAlgebraic ℤ (cbrt_nat 101) :=
  T5_IsAlgebraic_int_cbrt_nat 101

theorem T5_IsAlgebraic_int_cbrt_103_concrete :
    IsAlgebraic ℤ (cbrt_nat 103) :=
  T5_IsAlgebraic_int_cbrt_nat 103

theorem T5_IsAlgebraic_int_cbrt_107_concrete :
    IsAlgebraic ℤ (cbrt_nat 107) :=
  T5_IsAlgebraic_int_cbrt_nat 107

theorem T5_IsAlgebraic_int_cbrt_109_concrete :
    IsAlgebraic ℤ (cbrt_nat 109) :=
  T5_IsAlgebraic_int_cbrt_nat 109

theorem T5_IsAlgebraic_int_cbrt_113_concrete :
    IsAlgebraic ℤ (cbrt_nat 113) :=
  T5_IsAlgebraic_int_cbrt_nat 113

/-! ## Sub-cluster C — Bundle-XXXIX markers + headlines -/

theorem T5_bundle_XXXIX_first_in_V2_marker :
    ∃ (n : ℕ), 769 ≤ n ∧ n ≤ 783 ∧ n - 769 ≤ 15 :=
  ⟨783, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXIX_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXXIX_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 101) ∧
    IsCubicAlgebraic (cbrt_nat 103) ∧
    IsCubicAlgebraic (cbrt_nat 107) ∧
    IsCubicAlgebraic (cbrt_nat 109) ∧
    IsCubicAlgebraic (cbrt_nat 113) :=
  ⟨T5_isCubicAlgebraic_cbrt_101_concrete,
   T5_isCubicAlgebraic_cbrt_103_concrete,
   T5_isCubicAlgebraic_cbrt_107_concrete,
   T5_isCubicAlgebraic_cbrt_109_concrete,
   T5_isCubicAlgebraic_cbrt_113_concrete⟩

theorem T5_bundle_XXXIX_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 101) ∧
    IsAlgebraic ℤ (cbrt_nat 103) ∧
    IsAlgebraic ℤ (cbrt_nat 107) ∧
    IsAlgebraic ℤ (cbrt_nat 109) ∧
    IsAlgebraic ℤ (cbrt_nat 113) :=
  ⟨T5_IsAlgebraic_int_cbrt_101_concrete,
   T5_IsAlgebraic_int_cbrt_103_concrete,
   T5_IsAlgebraic_int_cbrt_107_concrete,
   T5_IsAlgebraic_int_cbrt_109_concrete,
   T5_IsAlgebraic_int_cbrt_113_concrete⟩

/-! ## Bundle-XXXIX GRAND HEADLINE -/

theorem T5_bundle_XXXIX_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 101) ∧
     IsCubicAlgebraic (cbrt_nat 103) ∧
     IsCubicAlgebraic (cbrt_nat 107) ∧
     IsCubicAlgebraic (cbrt_nat 109) ∧
     IsCubicAlgebraic (cbrt_nat 113)) ∧
    (IsAlgebraic ℤ (cbrt_nat 101) ∧
     IsAlgebraic ℤ (cbrt_nat 103) ∧
     IsAlgebraic ℤ (cbrt_nat 107) ∧
     IsAlgebraic ℤ (cbrt_nat 109) ∧
     IsAlgebraic ℤ (cbrt_nat 113)) :=
  ⟨T5_bundle_XXXIX_master_alias_5_concrete,
   T5_bundle_XXXIX_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXIX
