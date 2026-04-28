/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

  T-5 (Roth's theorem) — **Phase 4 ENTRY: Roth-index polynomial
  definition**, sub session 559y — STRICT critical-path #316 (T-5)
  Phase 4 OPEN.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  The **Roth-index polynomial** definition — the fundamental object
  of the Roth-Schmidt-Wirsing index calculus:

      rothIndex P α d := inf { ⟨j, 1/d⟩ : ℝ | (∂^j P)(α) ≠ 0 }

  where:
  - `P : MvPolynomial (Fin n) ℝ` is the auxiliary polynomial
  - `α : Fin n → ℝ` is the target point (the algebraic-irrational
    we're approximating)
  - `d : Fin n → ℕ` is the weighted-degree vector
  - `j : Fin n → ℕ` is a multi-index of partial-derivative orders
  - `(∂^j P)(α) := aeval α (l.foldr (fun k q => (pderiv k)^[j k] q) P)`

  Together with the Phase 3 foundation master (s559v) + n-Wronskian
  non-vanishing CORE (s559u), this is the next vocabulary layer
  toward Roth's theorem main statement.

  This file ships the definition + two foundational identities:

  1. **`T5_rothIndex_zero_poly`** : the index of the zero polynomial
     is `0` (the indexing set is empty, `sInf ∅ = 0` on ℝ).
  2. **`T5_rothIndex_set_eq_empty_of_zero`** : the underlying set is
     literally empty when P = 0.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  This file opens **Phase 4** of the T-5 push. With the Phase 3
  foundation (bilinearity master s559s + Vandermonde wrapper s559t +
  n-Wronskian CORE s559u + foundation master s559v + n=3 witness
  s559w + monomial more s559x) all GREEN, the next step is to
  introduce the Roth-index polynomial vocabulary. With the index
  defined, future iterations can land:
  - rothIndex_translation_invariance
  - rothIndex_le_of_pderiv_eq_zero
  - 1-variable specialization bridging to `Polynomial.indexAtPoint`
  - the multivariable index calculus toward Roth proper.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecificLimits.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_IteratedPDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_IteratedPDeriv

/-! ## Iterated multi-pderiv shorthand -/

/-- The iterated multi-partial-derivative of a polynomial along the
    list of variables `Fin n` with multi-index `j`.

    `multiIteratedPDeriv j P := (List.finRange n).foldr (fun k q => (pderiv k)^[j k] q) P`. -/
noncomputable def multiIteratedPDeriv {n : ℕ}
    (j : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ) :
    MvPolynomial (Fin n) ℝ :=
  (List.finRange n).foldr (fun k q => (pderiv k)^[j k] q) P

/-! ## Roth-index polynomial definition -/

/-- **🚨 Wave T5 session 559y — Roth-index polynomial**.

    The **Roth-index polynomial** of `P` at point `α` with weight
    vector `d`:

        rothIndex P α d := inf { ∑ i, j_i / d_i : (∂^j P)(α) ≠ 0 }

    The index is the smallest weighted-norm of multi-indices `j`
    such that the iterated partial derivative of `P` does NOT
    vanish at the target point `α`.

    Empty-set convention: when no such `j` exists (e.g. P = 0),
    `sInf ∅ = 0` on ℝ. -/
noncomputable def rothIndex {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) : ℝ :=
  sInf { r : ℝ | ∃ j : Fin n → ℕ,
    aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
    r = ∑ i, (j i : ℝ) / (d i : ℝ) }

/-! ## Foundational identities -/

/-- **🚨 Wave T5 session 559y — multi-pderiv on zero polynomial via shorthand**.

    `multiIteratedPDeriv j 0 = 0` for any multi-index `j`. -/
theorem T5_multiIteratedPDeriv_zero_poly {n : ℕ} (j : Fin n → ℕ) :
    multiIteratedPDeriv j (0 : MvPolynomial (Fin n) ℝ) = 0 := by
  unfold multiIteratedPDeriv
  exact T5_multiIteratedPDeriv_zero j (List.finRange n)

/-- **🚨 Wave T5 session 559y — Roth-index indexing set is empty for P = 0**.

    For the zero polynomial, no multi-index `j` makes the iterated
    partial derivative non-vanishing at any point.  Hence the
    indexing set is the empty set on ℝ. -/
theorem T5_rothIndex_set_eq_empty_of_zero {n : ℕ}
    (α : Fin n → ℝ) (d : Fin n → ℕ) :
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j (0 : MvPolynomial (Fin n) ℝ)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } = ∅ := by
  ext r
  simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
  rintro ⟨j, hne, _⟩
  apply hne
  rw [T5_multiIteratedPDeriv_zero_poly]
  exact map_zero _

/-- **🚨 Wave T5 session 559y — `rothIndex 0 α d = 0`**.

    The Roth-index of the zero polynomial is 0 by the empty-sInf
    convention on ℝ.  Any non-zero polynomial that vanishes
    identically at `α` would have positive index. -/
theorem T5_rothIndex_zero_poly {n : ℕ}
    (α : Fin n → ℝ) (d : Fin n → ℕ) :
    rothIndex (0 : MvPolynomial (Fin n) ℝ) α d = 0 := by
  unfold rothIndex
  rw [T5_rothIndex_set_eq_empty_of_zero]
  exact Real.sInf_empty

/-! ## RothIndexEntry Prop scaffold -/

/-- **RothIndexEntry**: 2-conjunct entry-point Prop for the
    Roth-index polynomial vocabulary.

    Real Prop body — packages the empty-set lemma + `rothIndex 0 = 0`. -/
def RothIndexEntry : Prop :=
  (∀ {n : ℕ} (α : Fin n → ℝ) (d : Fin n → ℕ),
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j (0 : MvPolynomial (Fin n) ℝ)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } = ∅) ∧
  (∀ {n : ℕ} (α : Fin n → ℝ) (d : Fin n → ℕ),
    rothIndex (0 : MvPolynomial (Fin n) ℝ) α d = 0)

/-- **🚨 Wave T5 session 559y — `RothIndexEntry`**. -/
theorem T5_roth_index_entry : RothIndexEntry :=
  ⟨@T5_rothIndex_set_eq_empty_of_zero,
   @T5_rothIndex_zero_poly⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559y — T-5 Phase 4 ENTRY: Roth-index polynomial**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 ENTRY.

    Definition + 2 foundational identities + Prop scaffold:
    1. `rothIndex P α d` — the polynomial-index calculus invariant.
    2. `T5_rothIndex_set_eq_empty_of_zero` — the indexing set
       collapses to `∅` for P = 0.
    3. `T5_rothIndex_zero_poly` — `rothIndex 0 α d = 0` via
       `Real.sInf_empty`.
    4. `RothIndexEntry` Prop (2-conjunct).

    **Phase 4 ENTRY-POINT**: With this file landed, the Roth-index
    vocabulary is in OV2.  Future Phase 4 sub-iterations target:
    - `rothIndex_translation_invariance` (under `α → α + γ`)
    - `rothIndex_le_of_pderiv_eq_zero` (monotonicity)
    - 1-variable specialization to `Polynomial.indexAtPoint`
    - non-empty + bounded-below membership lemmas
    - the multivariable Roth-Schmidt-Wirsing calculus

    Mathlib usage: `MvPolynomial.aeval`, `MvPolynomial.pderiv`,
    `Real.sInf_empty`, `T5_multiIteratedPDeriv_zero` (s121,
    Phase 3 foundation).

    Sub-lemma 173/N in T-1 (T-5 Phase 4 ENTRY).  Lean-core only.

    🏆 First Lean-core T-5 Phase 4 Roth-index polynomial. -/
theorem session_559y_T5_phase4_roth_index_entry_headline :
    RothIndexEntry :=
  T5_roth_index_entry

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
