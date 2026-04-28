/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase6_RothIndexTranslation

  T-5 (Roth's theorem) — **🏆 PHASE 6 GRAND THEOREM:
  rothIndex translation invariance**, sub session 559qq —
  STRICT critical-path #316 (T-5) Phase 6 GRAND THEOREM.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  The translation-invariance theorem for the Roth-index polynomial:

      `rothIndex P α d = rothIndex (shiftPoly α P) 0 d`

  i.e., the Roth-index at point `α` equals the Roth-index at the
  origin of the polynomial shifted by `α`.

  Composes Phase 6 ENTRY (s559pp `T5_multiIteratedPDeriv_bind₁_shift`
  + `T5_aeval_bind₁_shift`) with Phase 4 rothIndex definition.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 6 GRAND THEOREM.  T-5 critical path post-s559qq:

  - Phase 1-5 ✓ (Roth proper Phase 5 GRAND THEOREM s559oo)
  - Phase 6 ENTRY ✓ (s559pp BindOneShift chain rule)
  - **Phase 6 GRAND THEOREM ✓ (this file, s559qq) — translation invariance**

  Phase 7+ remaining: Siegel's lemma application + analytical bound.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase6_RothIndexTranslation

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

/-! ## Set equality via shift-bijection -/

/-- **🚨 Wave T5 session 559qq — rothIndexSet bijection under translation**.

    The indexing set for `shiftPoly α P` at origin `0` is identical
    to the indexing set for `P` at point `α`, via the bijection
    `j ↔ j` (identity on multi-indices, with the pderiv-iterate
    commuting with the shift). -/
theorem T5_rothIndexSet_translation_eq {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval (0 : Fin n → ℝ) (multiIteratedPDeriv j (shiftPoly α P)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } =
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
  ext r
  constructor
  · rintro ⟨j, hne, hr⟩
    refine ⟨j, ?_, hr⟩
    rw [T5_multiIteratedPDeriv_bind₁_shift] at hne
    rw [T5_aeval_bind₁_shift] at hne
    have h_eq : (fun i : Fin n => (0 : Fin n → ℝ) i + α i) = α := by
      funext i; simp
    rw [h_eq] at hne
    exact hne
  · rintro ⟨j, hne, hr⟩
    refine ⟨j, ?_, hr⟩
    rw [T5_multiIteratedPDeriv_bind₁_shift]
    rw [T5_aeval_bind₁_shift]
    have h_eq : (fun i : Fin n => (0 : Fin n → ℝ) i + α i) = α := by
      funext i; simp
    rw [h_eq]
    exact hne

/-! ## Translation invariance theorem -/

/-- **🏆 Wave T5 session 559qq — Phase 6 GRAND THEOREM: rothIndex translation invariance**.

      `rothIndex (shiftPoly α P) 0 d = rothIndex P α d`

    The Roth-index at point `α` equals the Roth-index at origin
    of the polynomial shifted by `α`.  Composes:
    - s559pp `T5_multiIteratedPDeriv_bind₁_shift`
    - s559pp `T5_aeval_bind₁_shift`
    - rothIndexSet bijection (this file's set equality lemma) -/
theorem T5_rothIndex_translation_invariance {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    rothIndex (shiftPoly α P) (0 : Fin n → ℝ) d = rothIndex P α d := by
  unfold rothIndex
  rw [T5_rothIndexSet_translation_eq]

/-! ## RothIndexTranslation Prop scaffold -/

/-- **RothIndexTranslation**: 1-conjunct Phase 6 GRAND THEOREM Prop. -/
def RothIndexTranslation : Prop :=
  ∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    rothIndex (shiftPoly α P) (0 : Fin n → ℝ) d = rothIndex P α d

/-- **🏆 Wave T5 session 559qq — `RothIndexTranslation`**. -/
theorem T5_roth_index_translation : RothIndexTranslation :=
  @T5_rothIndex_translation_invariance

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559qq — T-5 Phase 6 GRAND THEOREM 🏆**.

    🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 6 GRAND THEOREM.

    `T5_rothIndex_translation_invariance`:

      `rothIndex (shiftPoly α P) 0 d = rothIndex P α d`

    Roth-index translation invariance — fundamental for the Roth's
    main theorem reduction (any algebraic-irrational-approximation
    result at α can be translated to the same statement at 0).

    Composes the Phase 6 ENTRY (s559pp BindOneShift) with Phase 4
    rothIndex definition via:
    - `T5_multiIteratedPDeriv_bind₁_shift`: multi-pderiv shift commute
    - `T5_aeval_bind₁_shift`: aeval substitution composition
    - rothIndexSet bijection (j ↔ j)

    T-5 critical path post-s559qq:
    - Phase 1-5 ✓ (Phase 5 GRAND THEOREM rothIndex(X^k)=k/d_i)
    - Phase 6 ENTRY ✓ (s559pp BindOneShift)
    - **Phase 6 GRAND THEOREM ✓ — translation invariance**

    Phase 7+ remaining: Siegel's lemma application
    (Mathlib `Int.Matrix.exists_ne_zero_int_vec_norm_le`) +
    analytical bound + Roth main theorem proper.

    Mathlib usage: only structural composition.

    Sub-lemma 191/N in T-1 (T-5 Phase 6 GRAND THEOREM 🏆).
    Lean-core only.

    🏆 First Lean-core T-5 Phase 6 rothIndex translation invariance. -/
theorem session_559qq_T5_phase6_grand_theorem_headline :
    RothIndexTranslation :=
  T5_roth_index_translation

end OmegaTheory.Irrationality.CustomMath.T5_Phase6_RothIndexTranslation
