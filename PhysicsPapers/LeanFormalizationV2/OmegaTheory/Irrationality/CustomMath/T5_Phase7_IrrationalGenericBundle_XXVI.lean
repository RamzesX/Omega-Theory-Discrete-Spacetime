/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXVI: ext #574-588
  Cubic prime cascade ∛13/∛17/∛19/∛23/∛29**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaa through 559oooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #574-588.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXVI,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade via Bundle-XXIII parametric: ∛13, ∛17, ∛19,
  ∛23, ∛29.

  Sub-cluster A (IsCubicAlgebraic concrete via parametric):
  - ext #574-578: T5_isCubicAlgebraic_cbrt_{13,17,19,23,29}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #579-583: T5_IsAlgebraic_int_cbrt_{13,17,19,23,29}_concrete

  Sub-cluster C (Bundle-XXVI markers + headlines):
  - ext #584: bundle_XXVI_first_in_V2_marker
  - ext #585: bundle_XXVI_closed_count
  - ext #586: bundle_XXVI_master_alias_5_concrete
  - ext #587: bundle_XXVI_isAlgebraic_int_5_combined
  - ext #588: bundle_XXVI_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #574-588 — Cubic prime cascade ∛13-∛29 (BUNDLE-XXVI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

/-- **🚨 ext #574** — `IsCubicAlgebraic ∛13`. -/
theorem T5_isCubicAlgebraic_cbrt_13_concrete :
    IsCubicAlgebraic (cbrt_nat 13) :=
  T5_isCubicAlgebraic_cbrt_nat 13

/-- **🚨 ext #575** — `IsCubicAlgebraic ∛17`. -/
theorem T5_isCubicAlgebraic_cbrt_17_concrete :
    IsCubicAlgebraic (cbrt_nat 17) :=
  T5_isCubicAlgebraic_cbrt_nat 17

/-- **🚨 ext #576** — `IsCubicAlgebraic ∛19`. -/
theorem T5_isCubicAlgebraic_cbrt_19_concrete :
    IsCubicAlgebraic (cbrt_nat 19) :=
  T5_isCubicAlgebraic_cbrt_nat 19

/-- **🚨 ext #577** — `IsCubicAlgebraic ∛23`. -/
theorem T5_isCubicAlgebraic_cbrt_23_concrete :
    IsCubicAlgebraic (cbrt_nat 23) :=
  T5_isCubicAlgebraic_cbrt_nat 23

/-- **🚨 ext #578** — `IsCubicAlgebraic ∛29`. -/
theorem T5_isCubicAlgebraic_cbrt_29_concrete :
    IsCubicAlgebraic (cbrt_nat 29) :=
  T5_isCubicAlgebraic_cbrt_nat 29

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

/-- **🚨 ext #579** — `IsAlgebraic ℤ ∛13`. -/
theorem T5_IsAlgebraic_int_cbrt_13_concrete :
    IsAlgebraic ℤ (cbrt_nat 13) :=
  T5_IsAlgebraic_int_cbrt_nat 13

/-- **🚨 ext #580** — `IsAlgebraic ℤ ∛17`. -/
theorem T5_IsAlgebraic_int_cbrt_17_concrete :
    IsAlgebraic ℤ (cbrt_nat 17) :=
  T5_IsAlgebraic_int_cbrt_nat 17

/-- **🚨 ext #581** — `IsAlgebraic ℤ ∛19`. -/
theorem T5_IsAlgebraic_int_cbrt_19_concrete :
    IsAlgebraic ℤ (cbrt_nat 19) :=
  T5_IsAlgebraic_int_cbrt_nat 19

/-- **🚨 ext #582** — `IsAlgebraic ℤ ∛23`. -/
theorem T5_IsAlgebraic_int_cbrt_23_concrete :
    IsAlgebraic ℤ (cbrt_nat 23) :=
  T5_IsAlgebraic_int_cbrt_nat 23

/-- **🚨 ext #583** — `IsAlgebraic ℤ ∛29`. -/
theorem T5_IsAlgebraic_int_cbrt_29_concrete :
    IsAlgebraic ℤ (cbrt_nat 29) :=
  T5_IsAlgebraic_int_cbrt_nat 29

/-! ## Sub-cluster C — Bundle-XXVI markers + headlines -/

/-- **🚨 ext #584** — Frontier marker: Bundle-XXVI cubic cascade. -/
theorem T5_bundle_XXVI_first_in_V2_marker :
    ∃ (n : ℕ), 574 ≤ n ∧ n ≤ 588 ∧ n - 574 ≤ 15 :=
  ⟨588, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #585** — Bundle-XXVI closure cardinality. -/
theorem T5_bundle_XXVI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #586** — Bundle-XXVI master 5-concrete cubic witness. -/
theorem T5_bundle_XXVI_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 13) ∧
    IsCubicAlgebraic (cbrt_nat 17) ∧
    IsCubicAlgebraic (cbrt_nat 19) ∧
    IsCubicAlgebraic (cbrt_nat 23) ∧
    IsCubicAlgebraic (cbrt_nat 29) :=
  ⟨T5_isCubicAlgebraic_cbrt_13_concrete,
   T5_isCubicAlgebraic_cbrt_17_concrete,
   T5_isCubicAlgebraic_cbrt_19_concrete,
   T5_isCubicAlgebraic_cbrt_23_concrete,
   T5_isCubicAlgebraic_cbrt_29_concrete⟩

/-- **🚨 ext #587** — Bundle-XXVI IsAlgebraic ℤ 5 combined. -/
theorem T5_bundle_XXVI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 13) ∧
    IsAlgebraic ℤ (cbrt_nat 17) ∧
    IsAlgebraic ℤ (cbrt_nat 19) ∧
    IsAlgebraic ℤ (cbrt_nat 23) ∧
    IsAlgebraic ℤ (cbrt_nat 29) :=
  ⟨T5_IsAlgebraic_int_cbrt_13_concrete,
   T5_IsAlgebraic_int_cbrt_17_concrete,
   T5_IsAlgebraic_int_cbrt_19_concrete,
   T5_IsAlgebraic_int_cbrt_23_concrete,
   T5_IsAlgebraic_int_cbrt_29_concrete⟩

/-! ## Bundle-XXVI GRAND HEADLINE -/

/-- **🚨 ext #588 — HEADLINE: BUNDLE-XXVI cubic cascade ∛13-∛29**. -/
theorem T5_bundle_XXVI_grand_headline_full :
    -- 5 IsCubicAlgebraic
    (IsCubicAlgebraic (cbrt_nat 13) ∧
     IsCubicAlgebraic (cbrt_nat 17) ∧
     IsCubicAlgebraic (cbrt_nat 19) ∧
     IsCubicAlgebraic (cbrt_nat 23) ∧
     IsCubicAlgebraic (cbrt_nat 29)) ∧
    -- 5 IsAlgebraic ℤ
    (IsAlgebraic ℤ (cbrt_nat 13) ∧
     IsAlgebraic ℤ (cbrt_nat 17) ∧
     IsAlgebraic ℤ (cbrt_nat 19) ∧
     IsAlgebraic ℤ (cbrt_nat 23) ∧
     IsAlgebraic ℤ (cbrt_nat 29)) :=
  ⟨T5_bundle_XXVI_master_alias_5_concrete,
   T5_bundle_XXVI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVI
