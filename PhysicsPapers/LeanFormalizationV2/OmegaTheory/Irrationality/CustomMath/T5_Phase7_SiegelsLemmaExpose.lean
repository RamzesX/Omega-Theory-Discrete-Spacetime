/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SiegelsLemmaExpose

  T-5 (Roth's theorem) — **Phase 7 ENTRY: Mathlib SiegelsLemma
  exposed in T-5 namespace**, sub session 559rr — STRICT
  critical-path #316 (T-5) Phase 7 ENTRY.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).
  Per opus-code-crawler intel today: Mathlib has
  `Int.Matrix.exists_ne_zero_int_vec_norm_le` at
  `Mathlib/NumberTheory/SiegelsLemma.lean:181`.

  ## What this file delivers

  Phase 7 ENTRY foundation: re-exposes Mathlib's Siegel's Lemma
  (existence of small integer vector solutions to undetermined
  integer matrix equations) in the T-5 namespace, ready for
  downstream Roth-Schmidt-Wirsing auxiliary-polynomial construction.

  Two forms:
  1. **`T5_siegel_int_matrix_existence`**: the standard form
     `‖t‖ ≤ (n · max 1 ‖A‖)^(m/(n-m))`.
  2. **`T5_siegel_int_matrix_existence_nonzero_A`**: variant for
     non-zero matrix A, `‖t‖ ≤ (n · ‖A‖)^(m/(n-m))`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ENTRY foundation.  Used by future Phase 7 sub-sessions:
  - bounded-degree polynomial encoding (Box n d → MvPolynomial)
  - vanishing-system row matrix construction
  - Roth auxiliary polynomial existence assembly
  - eventual Roth main theorem proof.
-/

import Mathlib.NumberTheory.SiegelsLemma
import Mathlib.Analysis.Matrix.Normed
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SiegelsLemmaExpose

attribute [local instance] Matrix.seminormedAddCommGroup

open Matrix

/-! ## Standard Siegel form -/

/-- **🚨 Wave T5 session 559rr — Mathlib Siegel's Lemma exposed**.

    For undetermined integer matrix `A : Matrix α β ℤ` with
    `card α < card β`, there exists a non-zero integer vector
    `t : β → ℤ` with `A *ᵥ t = 0` and bounded sup-norm. -/
theorem T5_siegel_int_matrix_existence
    {α β : Type*} [Fintype α] [Fintype β] (A : Matrix α β ℤ)
    (hn : Fintype.card α < Fintype.card β) (hm : 0 < Fintype.card α) :
    ∃ t : β → ℤ, t ≠ 0 ∧ A *ᵥ t = 0 ∧
    ‖t‖ ≤ (Fintype.card β * max 1 ‖A‖) ^
          ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)) :=
  Int.Matrix.exists_ne_zero_int_vec_norm_le A hn hm

/-! ## Tighter form for non-zero A -/

/-- **🚨 Wave T5 session 559rr — Mathlib Siegel's Lemma (non-zero matrix variant)**.

    Same as above, with the slightly tighter bound dropping the
    `max 1` clause when `A ≠ 0`. -/
theorem T5_siegel_int_matrix_existence_nonzero_A
    {α β : Type*} [Fintype α] [Fintype β] (A : Matrix α β ℤ)
    (hn : Fintype.card α < Fintype.card β) (hm : 0 < Fintype.card α)
    (hA : A ≠ 0) :
    ∃ t : β → ℤ, t ≠ 0 ∧ A *ᵥ t = 0 ∧
    ‖t‖ ≤ (Fintype.card β * ‖A‖) ^
          ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)) :=
  Int.Matrix.exists_ne_zero_int_vec_norm_le' A hn hm hA

/-! ## SiegelsLemmaExpose Prop scaffold -/

/-- **SiegelsLemmaExpose**: 2-conjunct Prop packaging the
    re-exposed Mathlib Siegel's Lemma. -/
def SiegelsLemmaExpose : Prop :=
  (∀ {α β : Type*} [Fintype α] [Fintype β] (A : Matrix α β ℤ),
    Fintype.card α < Fintype.card β → 0 < Fintype.card α →
    ∃ t : β → ℤ, t ≠ 0 ∧ A *ᵥ t = 0 ∧
    ‖t‖ ≤ (Fintype.card β * max 1 ‖A‖) ^
          ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α))) ∧
  (∀ {α β : Type*} [Fintype α] [Fintype β] (A : Matrix α β ℤ),
    Fintype.card α < Fintype.card β → 0 < Fintype.card α → A ≠ 0 →
    ∃ t : β → ℤ, t ≠ 0 ∧ A *ᵥ t = 0 ∧
    ‖t‖ ≤ (Fintype.card β * ‖A‖) ^
          ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)))

/-- **🚨 Wave T5 session 559rr — `SiegelsLemmaExpose`**. -/
theorem T5_siegels_lemma_expose : SiegelsLemmaExpose :=
  ⟨@T5_siegel_int_matrix_existence,
   @T5_siegel_int_matrix_existence_nonzero_A⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559rr — T-5 Phase 7 ENTRY: SiegelsLemma**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ENTRY.

    Re-exposes Mathlib's `Int.Matrix.exists_ne_zero_int_vec_norm_le`
    (and the non-zero variant) in the OV2 T-5 namespace, ready for
    downstream Roth-Schmidt-Wirsing auxiliary-polynomial construction.

    Phase 7 status (cycle 65 day-of-record):
    - Phase 6 GRAND THEOREM ✓ (s559qq translation invariance)
    - **Phase 7 ENTRY (this file, s559rr): SiegelsLemma exposed**
    - Phase 7 sub-iterations ahead:
      * bounded-degree polynomial encoding (Box n d → MvPolynomial)
      * vanishing-system row matrix construction
      * Roth auxiliary polynomial existence assembly
      * Roth main theorem proper (analytical bound + integer
        contradiction)

    Mathlib usage: `Int.Matrix.exists_ne_zero_int_vec_norm_le` +
    `Int.Matrix.exists_ne_zero_int_vec_norm_le'`,
    `Matrix.seminormedAddCommGroup` (local instance for the
    sup-norm on integer matrices).

    Sub-lemma 192/N in T-1 (T-5 Phase 7 ENTRY).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 SiegelsLemma exposure. -/
theorem session_559rr_T5_phase7_siegels_lemma_expose_headline :
    SiegelsLemmaExpose :=
  T5_siegels_lemma_expose

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SiegelsLemmaExpose
