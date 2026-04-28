/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexSMul

  T-5 (Roth's theorem) — **Phase 4 ext #5: rothIndex scalar
  invariance under non-zero ℝ-scalar multiplication**, sub session
  559ff — STRICT critical-path #316 (T-5) Phase 4 ext #5.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Scalar-multiplication invariance of the Roth-index polynomial:

      `c ≠ 0 → rothIndex (c • P) α d = rothIndex P α d`

  Proof: by establishing the multi-iterated-pderiv ℝ-linearity:
  - `(pderiv k)^[m] (c • P) = c • (pderiv k)^[m] P` (induction on m)
  - List-foldr commutes with smul (induction on list)
  - `multiIteratedPDeriv j (c • P) = c • multiIteratedPDeriv j P`
  - `aeval α (c • Q) = c * aeval α Q` (algebra-map smul)
  - for `c ≠ 0`, `c * x ≠ 0 ↔ x ≠ 0`
  - so the indexing set for `c • P` equals the set for `P`,
    hence sInf equal.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 4 ext #5 — non-zero scalar invariance.  Combined with the
  negation invariance (s559ee, special case `c = -1`), this gives
  full invariance under the multiplicative group `ℝ \ {0}`.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexSMul

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## Iterate-pderiv-smul -/

/-- **🚨 Wave T5 session 559ff — `(pderiv k)^[m] (c • P) = c • (pderiv k)^[m] P`**.

    Iterated partial derivative commutes with ℝ-scalar mul, by induction
    on the iteration count `m`. -/
theorem T5_iterate_pderiv_smul {n : ℕ} (k : Fin n) (m : ℕ) (c : ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    (pderiv k)^[m] (c • P) = c • (pderiv k)^[m] P := by
  induction m with
  | zero => simp
  | succ m ih =>
    simp only [Function.iterate_succ_apply', ih]
    rw [(pderiv k).map_smul]

/-! ## List-foldr commutes with smul -/

/-- **🚨 Wave T5 session 559ff — list-foldr of iterated pderivs commutes with smul**. -/
theorem T5_foldr_pderiv_smul {n : ℕ} (l : List (Fin n)) (j : Fin n → ℕ)
    (c : ℝ) (P : MvPolynomial (Fin n) ℝ) :
    l.foldr (fun k q => (pderiv k)^[j k] q) (c • P) =
    c • (l.foldr (fun k q => (pderiv k)^[j k] q) P) := by
  induction l with
  | nil => simp
  | cons k l ih =>
    rw [List.foldr_cons, List.foldr_cons, ih]
    exact T5_iterate_pderiv_smul k (j k) c _

/-! ## multiIteratedPDeriv-smul -/

/-- **🚨 Wave T5 session 559ff — `multiIteratedPDeriv j (c • P) = c • multiIteratedPDeriv j P`**. -/
theorem T5_multiIteratedPDeriv_smul {n : ℕ} (j : Fin n → ℕ)
    (c : ℝ) (P : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv j (c • P) = c • multiIteratedPDeriv j P := by
  unfold multiIteratedPDeriv
  exact T5_foldr_pderiv_smul (List.finRange n) j c P

/-! ## rothIndex set equality under non-zero scalar multiplication -/

/-- **🚨 Wave T5 session 559ff — Roth-index indexing sets equal for `P` and `c • P` (`c ≠ 0`)**. -/
theorem T5_rothIndex_set_smul {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (c : ℝ) (hc : c ≠ 0) :
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j (c • P)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } =
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
  ext r
  constructor
  · rintro ⟨j, hne, hreq⟩
    refine ⟨j, ?_, hreq⟩
    rw [T5_multiIteratedPDeriv_smul, map_smul] at hne
    intro heq
    apply hne
    rw [heq]
    simp
  · rintro ⟨j, hne, hreq⟩
    refine ⟨j, ?_, hreq⟩
    rw [T5_multiIteratedPDeriv_smul, map_smul]
    intro heq
    apply hne
    rw [smul_eq_mul, mul_eq_zero] at heq
    cases heq with
    | inl h => exact absurd h hc
    | inr h => exact h

/-! ## rothIndex non-zero scalar invariance -/

/-- **🚨 Wave T5 session 559ff — `c ≠ 0 → rothIndex (c • P) α d = rothIndex P α d`**.

    The Roth-index is invariant under non-zero ℝ-scalar
    multiplication, since the indexing set is identical when
    the scalar is non-zero. -/
theorem T5_rothIndex_smul {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (c : ℝ) (hc : c ≠ 0) :
    rothIndex (c • P) α d = rothIndex P α d := by
  unfold rothIndex
  rw [T5_rothIndex_set_smul P α d c hc]

/-! ## RothIndexSMul Prop scaffold -/

/-- **RothIndexSMul**: 1-conjunct Prop packaging the rothIndex
    non-zero scalar invariance. -/
def RothIndexSMul : Prop :=
  ∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (c : ℝ), c ≠ 0 → rothIndex (c • P) α d = rothIndex P α d

/-- **🚨 Wave T5 session 559ff — `RothIndexSMul`**. -/
theorem T5_roth_index_smul : RothIndexSMul :=
  @T5_rothIndex_smul

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ff — T-5 Phase 4 ext #5: rothIndex non-zero scalar invariance**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 ext #5.

    Establishes `c ≠ 0 → rothIndex (c • P) α d = rothIndex P α d`:
    1. `T5_iterate_pderiv_smul`: iterated pderiv preserves smul
    2. `T5_foldr_pderiv_smul`: list-foldr preserves smul
    3. `T5_multiIteratedPDeriv_smul`: multi-pderiv preserves smul
    4. `T5_rothIndex_set_smul`: indexing sets equal under smul (c≠0)
    5. `T5_rothIndex_smul`: **the master invariance theorem**
    + RothIndexSMul Prop (1-conjunct).

    Combined with the negation invariance (s559ee), this gives
    rothIndex full invariance under multiplication by any non-zero
    scalar in ℝ — i.e., rothIndex is well-defined on equivalence
    classes of MvPolynomial under non-zero scalar multiplication.

    Mathlib usage: `Function.iterate_succ_apply'`, `map_smul`
    (Derivation/LinearMap), `mul_eq_zero`, `smul_eq_mul`.

    Sub-lemma 180/N in T-1 (T-5 Phase 4 ext #5).  Lean-core only.

    🏆 First Lean-core T-5 Phase 4 rothIndex non-zero scalar
    invariance. -/
theorem session_559ff_T5_phase4_roth_index_smul_headline :
    RothIndexSMul :=
  T5_roth_index_smul

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexSMul
