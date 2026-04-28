/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowVanish

  T-5 (Roth's theorem) — **Phase 5 ext #5: multi-pderiv X^k vanishing
  complement (∃ l ≠ i, j l ≥ 1 → result = 0)**, sub session 559mm —
  STRICT critical-path #316 (T-5) Phase 5 ext #5.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).
  Per opus-code-crawler intel today: avoids the `vars_pderiv_subset`
  Mathlib-gap by using a DIFFERENT invariant — "is C c * X i^m form".

  ## What this file delivers

  Vanishing complement for the multi-pderiv on `X i^k`:

      `(∃ l, l ≠ i ∧ 1 ≤ j l) → multiIteratedPDeriv j (X i^k) = 0`

  Proof strategy: inductively, the foldr applied to X i^k preserves
  the form `C c * X i^m` for some c : ℝ and m : ℕ (including c = 0,
  i.e., 0 polynomial).  When the foldr reaches `l ≠ i` with `j l ≥ 1`,
  applying `(pderiv l)^[j l]` to a `C c * X i^m` form gives 0.
  Subsequent foldr steps preserve 0.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ext #5 — vanishing complement.  Together with s559kk
  positive case + s559ll witness, this completes the ingredients
  for the singleton-set characterization of `rothIndexSet (X i^k)`
  at α with α_i = 0.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowVanish

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowOther
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

/-! ## "Is C c * X i^m form" invariant -/

/-- A polynomial is in `IsXiMonomialForm i` if it equals `C c * X i^m`
    for some scalar `c : ℝ` and exponent `m : ℕ`. -/
private def IsXiMonomialForm {n : ℕ} (i : Fin n)
    (q : MvPolynomial (Fin n) ℝ) : Prop :=
  ∃ (c : ℝ) (m : ℕ), q = MvPolynomial.C c * (X i)^m

/-- The starting state `X i^k` is of the form. -/
private theorem isXiMonomialForm_X_pow {n : ℕ} (i : Fin n) (k : ℕ) :
    IsXiMonomialForm i ((X i : MvPolynomial (Fin n) ℝ) ^ k) := by
  exact ⟨1, k, by simp⟩

/-- Zero is of the form (with c = 0). -/
private theorem isXiMonomialForm_zero {n : ℕ} (i : Fin n) :
    IsXiMonomialForm i (0 : MvPolynomial (Fin n) ℝ) := by
  exact ⟨0, 0, by simp⟩

/-! ## pderiv preserves the form -/

/-- `pderiv b` of `C c * X i^m` for `b ≠ i` is 0 — preserves the form. -/
private theorem pderiv_other_of_xiMonomialForm {n : ℕ} (i : Fin n) (b : Fin n)
    (hbi : b ≠ i) (q : MvPolynomial (Fin n) ℝ) (hq : IsXiMonomialForm i q) :
    pderiv b q = 0 := by
  obtain ⟨c, m, rfl⟩ := hq
  rw [Derivation.leibniz, MvPolynomial.pderiv_C, smul_zero, add_zero,
      MvPolynomial.pderiv_pow, MvPolynomial.pderiv_X_of_ne hbi.symm]
  simp

/-- `pderiv i` of `C c * X i^m` is in the X_i-monomial form. -/
private theorem pderiv_i_of_xiMonomialForm {n : ℕ} (i : Fin n)
    (q : MvPolynomial (Fin n) ℝ) (hq : IsXiMonomialForm i q) :
    IsXiMonomialForm i (pderiv i q) := by
  obtain ⟨c, m, rfl⟩ := hq
  refine ⟨c * m, m - 1, ?_⟩
  rw [Derivation.leibniz, MvPolynomial.pderiv_C, smul_zero, add_zero,
      MvPolynomial.pderiv_pow, MvPolynomial.pderiv_X_self]
  simp only [mul_one, smul_eq_mul, map_mul, map_natCast]
  ring

/-- Iterated `pderiv b` for `b ≠ i, m ≥ 1` of `IsXiMonomialForm i` gives 0. -/
private theorem pderiv_iterate_other_of_xiMonomialForm {n : ℕ}
    (i : Fin n) (b : Fin n) (hbi : b ≠ i) {m : ℕ} (hm : 1 ≤ m)
    (q : MvPolynomial (Fin n) ℝ) (hq : IsXiMonomialForm i q) :
    (pderiv b)^[m] q = 0 := by
  rcases Nat.exists_eq_succ_of_ne_zero (Nat.one_le_iff_ne_zero.mp hm) with ⟨m', rfl⟩
  rw [Function.iterate_succ_apply, pderiv_other_of_xiMonomialForm i b hbi q hq]
  exact T5_pderiv_iterate_zero b m'

/-- Iterated `pderiv i` of `IsXiMonomialForm i` preserves the form. -/
private theorem pderiv_iterate_i_of_xiMonomialForm {n : ℕ}
    (i : Fin n) (m : ℕ) (q : MvPolynomial (Fin n) ℝ) (hq : IsXiMonomialForm i q) :
    IsXiMonomialForm i ((pderiv i)^[m] q) := by
  induction m with
  | zero => simpa using hq
  | succ k ih =>
    rw [Function.iterate_succ_apply']
    exact pderiv_i_of_xiMonomialForm i _ ih

/-- Iterated `pderiv b` of `IsXiMonomialForm i` preserves either the form or 0. -/
private theorem pderiv_iterate_of_xiMonomialForm {n : ℕ} (i : Fin n)
    (b : Fin n) (m : ℕ) (q : MvPolynomial (Fin n) ℝ) (hq : IsXiMonomialForm i q) :
    IsXiMonomialForm i ((pderiv b)^[m] q) := by
  by_cases hbi : b = i
  · rw [hbi]
    exact pderiv_iterate_i_of_xiMonomialForm i m q hq
  · by_cases hm : m = 0
    · rw [hm]; simpa using hq
    · rw [pderiv_iterate_other_of_xiMonomialForm i b hbi (Nat.one_le_iff_ne_zero.mpr hm) q hq]
      exact isXiMonomialForm_zero i

/-! ## foldr preserves the form -/

/-- The foldr of pderiv-iterates over a list, applied to `IsXiMonomialForm i`,
    preserves the form. -/
private theorem foldr_pderiv_preserves_xiMonomialForm {n : ℕ}
    (i : Fin n) (j : Fin n → ℕ) (l : List (Fin n))
    (q : MvPolynomial (Fin n) ℝ) (hq : IsXiMonomialForm i q) :
    IsXiMonomialForm i
      (l.foldr (fun a r => (pderiv a)^[j a] r) q) := by
  induction l with
  | nil => simpa using hq
  | cons a t ih =>
    rw [List.foldr_cons]
    exact pderiv_iterate_of_xiMonomialForm i a (j a) _ ih

/-- Foldr of pderiv-iterates applied to 0 is 0 (helper). -/
private theorem foldr_pderiv_iterate_on_zero {n : ℕ} (j : Fin n → ℕ) (l : List (Fin n)) :
    l.foldr (fun a r => (pderiv a)^[j a] r) (0 : MvPolynomial (Fin n) ℝ) = 0 := by
  induction l with
  | nil => rfl
  | cons head tail ih =>
    rw [List.foldr_cons, ih]
    exact T5_pderiv_iterate_zero head (j head)

/-! ## Vanishing complement — main theorem -/

/-- **🚨 Wave T5 session 559mm — multi-pderiv vanishing complement**.

    `(∃ l, l ≠ i ∧ 1 ≤ j l) → multiIteratedPDeriv j (X i^k) = 0`. -/
theorem T5_multiIteratedPDeriv_X_pow_vanish_other {n : ℕ}
    (i : Fin n) (k : ℕ) (j : Fin n → ℕ)
    (hother : ∃ l : Fin n, l ≠ i ∧ 1 ≤ j l) :
    multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k) = 0 := by
  obtain ⟨l, hli, hjl⟩ := hother
  unfold multiIteratedPDeriv
  -- l ∈ List.finRange n; split list at l
  have hl_mem : l ∈ List.finRange n := List.mem_finRange l
  obtain ⟨pre, post, hsplit⟩ := List.append_of_mem hl_mem
  rw [hsplit, List.foldr_append, List.foldr_cons]
  -- inner = foldr post _ (X i^k) is in IsXiMonomialForm i
  have hinner : IsXiMonomialForm i
      (post.foldr (fun a r => (pderiv a)^[j a] r) ((X i : MvPolynomial (Fin n) ℝ) ^ k)) :=
    foldr_pderiv_preserves_xiMonomialForm i j post _ (isXiMonomialForm_X_pow i k)
  -- (pderiv l)^[j l] of inner = 0 (by l ≠ i and j l ≥ 1)
  have h_inner_zero :
      (pderiv l)^[j l]
        (post.foldr (fun a r => (pderiv a)^[j a] r)
          ((X i : MvPolynomial (Fin n) ℝ) ^ k)) = 0 :=
    pderiv_iterate_other_of_xiMonomialForm i l hli hjl _ hinner
  rw [h_inner_zero]
  -- foldr pre _ 0 = 0 (helper)
  exact foldr_pderiv_iterate_on_zero j pre

/-! ## MultiPDerivXPowVanish Prop scaffold -/

/-- **MultiPDerivXPowVanish**: 1-conjunct Prop packaging the
    multi-pderiv vanishing complement. -/
def MultiPDerivXPowVanish : Prop :=
  ∀ {n : ℕ} (i : Fin n) (k : ℕ) (j : Fin n → ℕ),
    (∃ l : Fin n, l ≠ i ∧ 1 ≤ j l) →
    multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k) = 0

/-- **🚨 Wave T5 session 559mm — `MultiPDerivXPowVanish`**. -/
theorem T5_multi_pderiv_X_pow_vanish : MultiPDerivXPowVanish :=
  @T5_multiIteratedPDeriv_X_pow_vanish_other

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mm — T-5 Phase 5 ext #5: multi-pderiv vanishing complement**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ext #5.

    `T5_multiIteratedPDeriv_X_pow_vanish_other`: when there exists
    some `l ≠ i` with `j l ≥ 1`,

        `multiIteratedPDeriv j (X i^k) = 0`

    Proof uses an **`IsXiMonomialForm i` invariant** — the foldr
    applied to `X i^k` always produces something of form
    `C c * X i^m` (or 0), and `(pderiv l)^[j l]` for `l ≠ i, j l ≥ 1`
    of any such form gives 0.  Avoids the Mathlib `vars_pderiv_subset`
    gap entirely.

    Combined with s559kk (positive case) + s559ll (witness ⊇),
    this gives the full singleton-set characterization for
    `rothIndexSet (X i^k)` at `α` with `α i = 0`.

    Mathlib usage: `Derivation.leibniz`, `MvPolynomial.pderiv_C`,
    `MvPolynomial.pderiv_pow`, `MvPolynomial.pderiv_X_self`,
    `MvPolynomial.pderiv_X_of_ne`, `List.append_of_mem`,
    `List.mem_finRange`, `List.foldr_append`, `Function.iterate_succ_apply`.

    Sub-lemma 187/N in T-1 (T-5 Phase 5 ext #5).  Lean-core only.

    🏆 First Lean-core T-5 Phase 5 multi-pderiv vanishing complement
    via IsXiMonomialForm invariant. -/
theorem session_559mm_T5_phase5_multi_pderiv_X_pow_vanish_headline :
    MultiPDerivXPowVanish :=
  T5_multi_pderiv_X_pow_vanish

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowVanish
