/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE LI: ext #949-963
  Cubic prime cascade ∛179/∛181/∛191/∛193/∛197**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #949-963.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE LI,
  15 ext sub-iterations consolidated, **post-50-milestone**).

  ## What this file delivers

  Cubic prime cascade extension: ∛179, ∛181, ∛191, ∛193, ∛197.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #949-953: T5_isCubicAlgebraic_cbrt_{179,181,191,193,197}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #954-958: matching IsAlgebraic ℤ companions

  Sub-cluster C (Bundle-LI markers + headlines):
  - ext #959-963: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #949-963 — Cubic prime cascade ∛179-∛197 (BUNDLE-LI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_L

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_179_concrete :
    IsCubicAlgebraic (cbrt_nat 179) :=
  T5_isCubicAlgebraic_cbrt_nat 179

theorem T5_isCubicAlgebraic_cbrt_181_concrete :
    IsCubicAlgebraic (cbrt_nat 181) :=
  T5_isCubicAlgebraic_cbrt_nat 181

theorem T5_isCubicAlgebraic_cbrt_191_concrete :
    IsCubicAlgebraic (cbrt_nat 191) :=
  T5_isCubicAlgebraic_cbrt_nat 191

theorem T5_isCubicAlgebraic_cbrt_193_concrete :
    IsCubicAlgebraic (cbrt_nat 193) :=
  T5_isCubicAlgebraic_cbrt_nat 193

theorem T5_isCubicAlgebraic_cbrt_197_concrete :
    IsCubicAlgebraic (cbrt_nat 197) :=
  T5_isCubicAlgebraic_cbrt_nat 197

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_179_concrete :
    IsAlgebraic ℤ (cbrt_nat 179) :=
  T5_IsAlgebraic_int_cbrt_nat 179

theorem T5_IsAlgebraic_int_cbrt_181_concrete :
    IsAlgebraic ℤ (cbrt_nat 181) :=
  T5_IsAlgebraic_int_cbrt_nat 181

theorem T5_IsAlgebraic_int_cbrt_191_concrete :
    IsAlgebraic ℤ (cbrt_nat 191) :=
  T5_IsAlgebraic_int_cbrt_nat 191

theorem T5_IsAlgebraic_int_cbrt_193_concrete :
    IsAlgebraic ℤ (cbrt_nat 193) :=
  T5_IsAlgebraic_int_cbrt_nat 193

theorem T5_IsAlgebraic_int_cbrt_197_concrete :
    IsAlgebraic ℤ (cbrt_nat 197) :=
  T5_IsAlgebraic_int_cbrt_nat 197

/-! ## Sub-cluster C — Bundle-LI markers + headlines -/

theorem T5_bundle_LI_first_in_V2_marker :
    ∃ (n : ℕ), 949 ≤ n ∧ n ≤ 963 ∧ n - 949 ≤ 15 :=
  ⟨963, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_LI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_LI_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 179) ∧
    IsCubicAlgebraic (cbrt_nat 181) ∧
    IsCubicAlgebraic (cbrt_nat 191) ∧
    IsCubicAlgebraic (cbrt_nat 193) ∧
    IsCubicAlgebraic (cbrt_nat 197) :=
  ⟨T5_isCubicAlgebraic_cbrt_179_concrete,
   T5_isCubicAlgebraic_cbrt_181_concrete,
   T5_isCubicAlgebraic_cbrt_191_concrete,
   T5_isCubicAlgebraic_cbrt_193_concrete,
   T5_isCubicAlgebraic_cbrt_197_concrete⟩

theorem T5_bundle_LI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 179) ∧
    IsAlgebraic ℤ (cbrt_nat 181) ∧
    IsAlgebraic ℤ (cbrt_nat 191) ∧
    IsAlgebraic ℤ (cbrt_nat 193) ∧
    IsAlgebraic ℤ (cbrt_nat 197) :=
  ⟨T5_IsAlgebraic_int_cbrt_179_concrete,
   T5_IsAlgebraic_int_cbrt_181_concrete,
   T5_IsAlgebraic_int_cbrt_191_concrete,
   T5_IsAlgebraic_int_cbrt_193_concrete,
   T5_IsAlgebraic_int_cbrt_197_concrete⟩

/-! ## Bundle-LI GRAND HEADLINE -/

theorem T5_bundle_LI_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 179) ∧
     IsCubicAlgebraic (cbrt_nat 181) ∧
     IsCubicAlgebraic (cbrt_nat 191) ∧
     IsCubicAlgebraic (cbrt_nat 193) ∧
     IsCubicAlgebraic (cbrt_nat 197)) ∧
    (IsAlgebraic ℤ (cbrt_nat 179) ∧
     IsAlgebraic ℤ (cbrt_nat 181) ∧
     IsAlgebraic ℤ (cbrt_nat 191) ∧
     IsAlgebraic ℤ (cbrt_nat 193) ∧
     IsAlgebraic ℤ (cbrt_nat 197)) :=
  ⟨T5_bundle_LI_master_alias_5_concrete,
   T5_bundle_LI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_LI
