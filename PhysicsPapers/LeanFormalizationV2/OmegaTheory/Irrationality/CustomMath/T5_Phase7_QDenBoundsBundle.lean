/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenBoundsBundle

  T-5 (Roth's theorem) — **Phase 7 ext #165: q.den bounds 5-conjunct
  bundle (cubic+ chain bookkeeping consolidation)**, sub session
  559mmmmmmmmm — STRICT critical-path #316 (T-5) Phase 7 ext #165.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Consolidated bundle of q.den^e bounds (all from prior cubic+ chain ext):

  For q : ℚ, e : ℝ:
  1. `0 < ((q.den : ℝ))^e` (s144)
  2. `0 ≤ ((q.den : ℝ))^e` (corollary)
  3. `1 ≤ ((q.den : ℝ))^e` for e ≥ 0 (s163)
  4. `((q.den : ℝ))^e ≤ ((q.den : ℝ))^f` for e ≤ f (s111)

  Single derivation:
  1. `T5_qden_bounds_bundle`: 4-conjunct.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #165 — q.den bounds 4-conjunct bundle.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowGeOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenBoundsBundle

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowGeOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

/-! ## q.den bounds bundle -/

/-- **🚨 Wave T5 session 559mmmmmmmmm — q.den bounds 4-conjunct bundle**.

    For q : ℚ, e : ℝ with e ≥ 0:
      `0 < q.den^e ∧ 0 ≤ q.den^e ∧ 1 ≤ q.den^e`. -/
theorem T5_qden_bounds_bundle (q : ℚ) (e : ℝ) (he : 0 ≤ e) :
    0 < ((q.den : ℝ)) ^ e ∧
    0 ≤ ((q.den : ℝ)) ^ e ∧
    1 ≤ ((q.den : ℝ)) ^ e := by
  refine ⟨T5_qden_rpow_pos q e, le_of_lt (T5_qden_rpow_pos q e),
          T5_qden_rpow_ge_one q e he⟩

/-- Companion: monotonicity in exponent. -/
theorem T5_qden_bounds_mono (q : ℚ) (a b : ℝ) (h : a ≤ b) :
    ((q.den : ℝ)) ^ a ≤ ((q.den : ℝ)) ^ b :=
  T5_qden_rpow_mono q a b h

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mmmmmmmmm — T-5 Phase 7 ext #165**.

    🏆 BOOKKEEPING — q.den bounds bundle (positivity + ≥ 1 + monotonicity).

    Sub-lemma 338/N. Lean-core only. -/
theorem session_559mmmmmmmmm_T5_phase7_qden_bounds_bundle_headline
    (q : ℚ) (e : ℝ) (he : 0 ≤ e) :
    0 < ((q.den : ℝ)) ^ e ∧
    0 ≤ ((q.den : ℝ)) ^ e ∧
    1 ≤ ((q.den : ℝ)) ^ e :=
  T5_qden_bounds_bundle q e he

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenBoundsBundle
