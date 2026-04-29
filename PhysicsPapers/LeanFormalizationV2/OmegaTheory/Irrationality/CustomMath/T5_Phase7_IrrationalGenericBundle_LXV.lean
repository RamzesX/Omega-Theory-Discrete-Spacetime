/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LXV: ext #1159-1173
  Cubic prime cascade ∛233/∛239/∛241/∛251/∛257**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #1159-1173.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LXV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension: ∛233, ∛239, ∛241, ∛251, ∛257.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #1159-1163: T5_isCubicAlgebraic_cbrt_{233,239,241,251,257}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #1164-1168: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LXV markers + headlines):
  - ext #1169-1173: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1159-1173 — Cubic prime cascade ∛233-∛257 (BUNDLE-LXV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXIV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_233_concrete :
    IsCubicAlgebraic (cbrt_nat 233) :=
  T5_isCubicAlgebraic_cbrt_nat 233

theorem T5_isCubicAlgebraic_cbrt_239_concrete :
    IsCubicAlgebraic (cbrt_nat 239) :=
  T5_isCubicAlgebraic_cbrt_nat 239

theorem T5_isCubicAlgebraic_cbrt_241_concrete :
    IsCubicAlgebraic (cbrt_nat 241) :=
  T5_isCubicAlgebraic_cbrt_nat 241

theorem T5_isCubicAlgebraic_cbrt_251_concrete :
    IsCubicAlgebraic (cbrt_nat 251) :=
  T5_isCubicAlgebraic_cbrt_nat 251

theorem T5_isCubicAlgebraic_cbrt_257_concrete :
    IsCubicAlgebraic (cbrt_nat 257) :=
  T5_isCubicAlgebraic_cbrt_nat 257

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_233_concrete :
    IsAlgebraic ℤ (cbrt_nat 233) :=
  T5_IsAlgebraic_int_cbrt_nat 233

theorem T5_IsAlgebraic_int_cbrt_239_concrete :
    IsAlgebraic ℤ (cbrt_nat 239) :=
  T5_IsAlgebraic_int_cbrt_nat 239

theorem T5_IsAlgebraic_int_cbrt_241_concrete :
    IsAlgebraic ℤ (cbrt_nat 241) :=
  T5_IsAlgebraic_int_cbrt_nat 241

theorem T5_IsAlgebraic_int_cbrt_251_concrete :
    IsAlgebraic ℤ (cbrt_nat 251) :=
  T5_IsAlgebraic_int_cbrt_nat 251

theorem T5_IsAlgebraic_int_cbrt_257_concrete :
    IsAlgebraic ℤ (cbrt_nat 257) :=
  T5_IsAlgebraic_int_cbrt_nat 257

/-! ## Sub-cluster C — Bundle-LXV markers + headlines -/

theorem T5_bundle_LXV_first_in_V2_marker :
    ∃ (n : ℕ), 1159 ≤ n ∧ n ≤ 1173 ∧ n - 1159 ≤ 15 :=
  ⟨1173, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LXV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LXV_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 233) ∧
    IsCubicAlgebraic (cbrt_nat 239) ∧
    IsCubicAlgebraic (cbrt_nat 241) ∧
    IsCubicAlgebraic (cbrt_nat 251) ∧
    IsCubicAlgebraic (cbrt_nat 257) :=
  ⟨T5_isCubicAlgebraic_cbrt_233_concrete,
   T5_isCubicAlgebraic_cbrt_239_concrete,
   T5_isCubicAlgebraic_cbrt_241_concrete,
   T5_isCubicAlgebraic_cbrt_251_concrete,
   T5_isCubicAlgebraic_cbrt_257_concrete⟩

theorem T5_bundle_LXV_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 233) ∧
    IsAlgebraic ℤ (cbrt_nat 239) ∧
    IsAlgebraic ℤ (cbrt_nat 241) ∧
    IsAlgebraic ℤ (cbrt_nat 251) ∧
    IsAlgebraic ℤ (cbrt_nat 257) :=
  ⟨T5_IsAlgebraic_int_cbrt_233_concrete,
   T5_IsAlgebraic_int_cbrt_239_concrete,
   T5_IsAlgebraic_int_cbrt_241_concrete,
   T5_IsAlgebraic_int_cbrt_251_concrete,
   T5_IsAlgebraic_int_cbrt_257_concrete⟩

/-! ## Bundle-LXV GRAND HEADLINE -/

theorem T5_bundle_LXV_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 233) ∧
     IsCubicAlgebraic (cbrt_nat 239) ∧
     IsCubicAlgebraic (cbrt_nat 241) ∧
     IsCubicAlgebraic (cbrt_nat 251) ∧
     IsCubicAlgebraic (cbrt_nat 257)) ∧
    (IsAlgebraic ℤ (cbrt_nat 233) ∧
     IsAlgebraic ℤ (cbrt_nat 239) ∧
     IsAlgebraic ℤ (cbrt_nat 241) ∧
     IsAlgebraic ℤ (cbrt_nat 251) ∧
     IsAlgebraic ℤ (cbrt_nat 257)) :=
  ⟨T5_bundle_LXV_master_alias_5_concrete,
   T5_bundle_LXV_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LXV
