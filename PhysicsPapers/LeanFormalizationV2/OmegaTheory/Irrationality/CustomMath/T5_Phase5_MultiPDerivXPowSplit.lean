/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit

  T-5 (Roth's theorem) — **Phase 5 ext #3: multi-pderiv on `X i^k`
  positive case — same-variable-only multi-index**, sub session 559kk
  — STRICT critical-path #316 (T-5) Phase 5 ext #3.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).
  Per opus-code-crawler intel today: this is the POSITIVE case of
  the multi-pderiv split for `multiIteratedPDeriv j (X i^k)` —
  recommended split into two theorems (positive + vanishing) to
  avoid `Decidable` ceremony on the `if`-form.

  ## What this file delivers

  When `j l = 0` for all `l ≠ i` (only same-variable iteration applied),
  the multi-iterated pderiv on `X i^k` reduces to the same-variable
  Phase 3 formula:

      `multiIteratedPDeriv j (X i^k) = k.descFactorial (j i) · X i^(k - j i)`

  Proof strategy: walk `List.finRange n` via foldr induction,
  collapsing `(pderiv l)^[0] = id` for `l ≠ i` and applying Phase 3
  `T5_pderiv_iterate_X_pow_self` at the unique `l = i` step.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ext #3 — **positive-case characterization**, the first half
  of the multi-pderiv split.  Used by `T5_rothIndex_X_pow_at_zero`
  (the FIRST non-trivial positive-index computation).
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

/-! ## Foldr-collapse helper: when `i ∉ l`, foldr is identity on `X i^k` -/

/-- **🚨 Wave T5 session 559kk — foldr collapse to identity when `i ∉ l`**.

    For a list `l` not containing `i`, the foldr of pderiv-iterates
    on `X i^k` (with all involved `j l = 0`) reduces to `X i^k`
    itself, because each step applies `(pderiv l)^[0] = id`. -/
private theorem foldr_id_when_i_not_mem {n : ℕ} (i : Fin n) (k : ℕ)
    (j : Fin n → ℕ) (hself : ∀ l, l ≠ i → j l = 0)
    (l : List (Fin n)) (hi : i ∉ l) :
    l.foldr (fun a q => (pderiv a)^[j a] q) ((X i : MvPolynomial (Fin n) ℝ) ^ k)
      = (X i)^k := by
  induction l with
  | nil => rfl
  | cons a t ih =>
    rw [List.foldr_cons]
    have hai : a ≠ i := fun heq => hi (heq ▸ List.mem_cons_self)
    have htnoi : i ∉ t := fun hmem => hi (List.mem_cons_of_mem _ hmem)
    rw [ih htnoi, hself a hai, Function.iterate_zero, id_eq]

/-! ## Foldr-walk over List.finRange n hitting `i` exactly once -/

/-- **🚨 Wave T5 session 559kk — foldr walk under `hself` and `i ∈ l, l.Nodup`**.

    For a list `l` containing `i` (no duplicates), the foldr applies
    only `(pderiv i)^[j i]` non-trivially (other `(pderiv l)^[j l]`
    being `id` since `j l = 0`).  The result is the same-variable
    Phase 3 formula. -/
private theorem foldr_self_only_eq {n : ℕ} (i : Fin n) (k : ℕ)
    (j : Fin n → ℕ) (hself : ∀ l, l ≠ i → j l = 0)
    (l : List (Fin n)) (hi : i ∈ l) (hnd : l.Nodup) :
    l.foldr (fun a q => (pderiv a)^[j a] q) ((X i : MvPolynomial (Fin n) ℝ) ^ k)
      = (k.descFactorial (j i) : MvPolynomial (Fin n) ℝ) * (X i) ^ (k - j i) := by
  induction l with
  | nil => simp at hi
  | cons a t ih =>
    rw [List.foldr_cons]
    by_cases hai : a = i
    · rw [hai] at hnd ⊢
      have htnoi : i ∉ t := (List.nodup_cons.mp hnd).1
      rw [foldr_id_when_i_not_mem i k j hself t htnoi]
      exact T5_pderiv_iterate_X_pow_self i k (j i)
    · have hit : i ∈ t := by
        rcases List.mem_cons.mp hi with h | h
        · exact absurd h.symm hai
        · exact h
      rw [hself a hai, Function.iterate_zero, id_eq]
      exact ih hit (List.nodup_cons.mp hnd).2

/-! ## Multi-pderiv split — positive case -/

/-- **🚨 Wave T5 session 559kk — multi-pderiv on `X i^k` (same-var-only multi-index)**.

    When `j l = 0` for all `l ≠ i`, the multi-iterated pderiv
    `multiIteratedPDeriv j (X i^k)` reduces to the same-variable
    Phase 3 formula `k.descFactorial (j i) · X i^(k - j i)`. -/
theorem T5_multiIteratedPDeriv_X_pow_self_only {n : ℕ} (i : Fin n) (k : ℕ)
    (j : Fin n → ℕ) (hself : ∀ l, l ≠ i → j l = 0) :
    multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k) =
      (k.descFactorial (j i) : MvPolynomial (Fin n) ℝ) * (X i) ^ (k - j i) := by
  unfold multiIteratedPDeriv
  exact foldr_self_only_eq i k j hself (List.finRange n)
    (List.mem_finRange i) (List.nodup_finRange n)

/-! ## MultiPDerivXPowSplit Prop scaffold -/

/-- **MultiPDerivXPowSplit**: 1-conjunct Prop packaging the
    multi-pderiv positive case on `X i^k`. -/
def MultiPDerivXPowSplit : Prop :=
  ∀ {n : ℕ} (i : Fin n) (k : ℕ) (j : Fin n → ℕ),
    (∀ l, l ≠ i → j l = 0) →
    multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k) =
      (k.descFactorial (j i) : MvPolynomial (Fin n) ℝ) * (X i) ^ (k - j i)

/-- **🚨 Wave T5 session 559kk — `MultiPDerivXPowSplit`**. -/
theorem T5_multi_pderiv_X_pow_split : MultiPDerivXPowSplit :=
  @T5_multiIteratedPDeriv_X_pow_self_only

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559kk — T-5 Phase 5 ext #3: multi-pderiv positive case**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ext #3.

    First file of the recommended TWO-theorem split for
    `multiIteratedPDeriv j (X i^k)`.

    `T5_multiIteratedPDeriv_X_pow_self_only`: under `hself : ∀ l ≠ i, j l = 0`,

        `multiIteratedPDeriv j (X i^k) = k.descFactorial (j i) · X i^(k - j i)`

    Proof via foldr induction over `List.finRange n`, with two
    helper lemmas:
    - `foldr_id_when_i_not_mem`: foldr is identity on `X i^k` when
      `i ∉ l` (all iterates are 0-fold).
    - `foldr_self_only_eq`: when `i ∈ l` (which `List.finRange n`
      satisfies), the unique non-id step is `(pderiv i)^[j i]`,
      giving the Phase 3 formula.

    Mathlib usage: `List.finRange`, `List.mem_finRange`,
    `List.nodup_finRange`, `List.mem_cons`, `List.foldr_cons`,
    `List.nodup_cons`, `Function.iterate_zero`, `id_eq`, +
    `T5_pderiv_iterate_X_pow_self` (Phase 3 s118).

    Sub-lemma 185/N in T-1 (T-5 Phase 5 ext #3).  Lean-core only.

    🏆 First Lean-core T-5 Phase 5 multi-pderiv positive-case
    characterization. -/
theorem session_559kk_T5_phase5_multi_pderiv_X_pow_split_headline :
    MultiPDerivXPowSplit :=
  T5_multi_pderiv_X_pow_split

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit
