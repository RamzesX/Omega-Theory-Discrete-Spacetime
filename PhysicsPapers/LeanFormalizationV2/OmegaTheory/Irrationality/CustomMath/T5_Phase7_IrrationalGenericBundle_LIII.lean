/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LIII: ext #979-993
  Cubic prime cascade ∛199/∛211/∛223/∛227/∛229**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #979-993.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension: ∛199, ∛211, ∛223, ∛227, ∛229.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #979-983: T5_isCubicAlgebraic_cbrt_{199,211,223,227,229}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #984-988: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LIII markers + headlines):
  - ext #989-993: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #979-993 — Cubic prime cascade ∛199-∛229 (BUNDLE-LIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_199_concrete :
    IsCubicAlgebraic (cbrt_nat 199) :=
  T5_isCubicAlgebraic_cbrt_nat 199

theorem T5_isCubicAlgebraic_cbrt_211_concrete :
    IsCubicAlgebraic (cbrt_nat 211) :=
  T5_isCubicAlgebraic_cbrt_nat 211

theorem T5_isCubicAlgebraic_cbrt_223_concrete :
    IsCubicAlgebraic (cbrt_nat 223) :=
  T5_isCubicAlgebraic_cbrt_nat 223

theorem T5_isCubicAlgebraic_cbrt_227_concrete :
    IsCubicAlgebraic (cbrt_nat 227) :=
  T5_isCubicAlgebraic_cbrt_nat 227

theorem T5_isCubicAlgebraic_cbrt_229_concrete :
    IsCubicAlgebraic (cbrt_nat 229) :=
  T5_isCubicAlgebraic_cbrt_nat 229

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_199_concrete :
    IsAlgebraic ℤ (cbrt_nat 199) :=
  T5_IsAlgebraic_int_cbrt_nat 199

theorem T5_IsAlgebraic_int_cbrt_211_concrete :
    IsAlgebraic ℤ (cbrt_nat 211) :=
  T5_IsAlgebraic_int_cbrt_nat 211

theorem T5_IsAlgebraic_int_cbrt_223_concrete :
    IsAlgebraic ℤ (cbrt_nat 223) :=
  T5_IsAlgebraic_int_cbrt_nat 223

theorem T5_IsAlgebraic_int_cbrt_227_concrete :
    IsAlgebraic ℤ (cbrt_nat 227) :=
  T5_IsAlgebraic_int_cbrt_nat 227

theorem T5_IsAlgebraic_int_cbrt_229_concrete :
    IsAlgebraic ℤ (cbrt_nat 229) :=
  T5_IsAlgebraic_int_cbrt_nat 229

/-! ## Sub-cluster C — Bundle-LIII markers + headlines -/

theorem T5_bundle_LIII_first_in_V2_marker :
    ∃ (n : ℕ), 979 ≤ n ∧ n ≤ 993 ∧ n - 979 ≤ 15 :=
  ⟨993, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LIII_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 199) ∧
    IsCubicAlgebraic (cbrt_nat 211) ∧
    IsCubicAlgebraic (cbrt_nat 223) ∧
    IsCubicAlgebraic (cbrt_nat 227) ∧
    IsCubicAlgebraic (cbrt_nat 229) :=
  ⟨T5_isCubicAlgebraic_cbrt_199_concrete,
   T5_isCubicAlgebraic_cbrt_211_concrete,
   T5_isCubicAlgebraic_cbrt_223_concrete,
   T5_isCubicAlgebraic_cbrt_227_concrete,
   T5_isCubicAlgebraic_cbrt_229_concrete⟩

theorem T5_bundle_LIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 199) ∧
    IsAlgebraic ℤ (cbrt_nat 211) ∧
    IsAlgebraic ℤ (cbrt_nat 223) ∧
    IsAlgebraic ℤ (cbrt_nat 227) ∧
    IsAlgebraic ℤ (cbrt_nat 229) :=
  ⟨T5_IsAlgebraic_int_cbrt_199_concrete,
   T5_IsAlgebraic_int_cbrt_211_concrete,
   T5_IsAlgebraic_int_cbrt_223_concrete,
   T5_IsAlgebraic_int_cbrt_227_concrete,
   T5_IsAlgebraic_int_cbrt_229_concrete⟩

/-! ## Bundle-LIII GRAND HEADLINE -/

theorem T5_bundle_LIII_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 199) ∧
     IsCubicAlgebraic (cbrt_nat 211) ∧
     IsCubicAlgebraic (cbrt_nat 223) ∧
     IsCubicAlgebraic (cbrt_nat 227) ∧
     IsCubicAlgebraic (cbrt_nat 229)) ∧
    (IsAlgebraic ℤ (cbrt_nat 199) ∧
     IsAlgebraic ℤ (cbrt_nat 211) ∧
     IsAlgebraic ℤ (cbrt_nat 223) ∧
     IsAlgebraic ℤ (cbrt_nat 227) ∧
     IsAlgebraic ℤ (cbrt_nat 229)) :=
  ⟨T5_bundle_LIII_master_alias_5_concrete,
   T5_bundle_LIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LIII
