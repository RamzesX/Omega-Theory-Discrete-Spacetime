/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexSetWitness

  T-5 (Roth's theorem) — **Phase 5 ext #4: rothIndexSet contains
  k/d_i for X i^k at α with α_i = 0**, sub session 559ll —
  STRICT critical-path #316 (T-5) Phase 5 ext #4.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  The (⊇) direction of the singleton-set characterization for the
  Roth-index polynomial of `X i^k`:

      `(k : ℝ) / (d i : ℝ) ∈ rothIndexSet (X i^k) α d`

  Proven via the explicit witness multi-index `j₀ : Fin n → ℕ`
  defined by `j₀ l := if l = i then k else 0`.

  Proof chain:
  1. `multiIteratedPDeriv j₀ (X i^k) = (k.factorial : _)`
     (via s559kk positive case + s559jj diagonal case).
  2. `aeval α (k.factorial : _) = (k.factorial : ℝ) ≠ 0`
     (factorial-positivity).
  3. `∑ l, (j₀ l : ℝ) / (d l : ℝ) = k / d_i`
     (via `Finset.sum_ite_eq'`).
  4. So `k/d_i ∈ rothIndexSet`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ext #4 — explicit witness for the singleton-set
  characterization.  The (⊆) complement requires the multi-pderiv
  vanishing lemma (Phase 5 ext #5 next).  Together they give the
  singleton equality, hence `rothIndex (X i^k) α d = k / d_i` via
  `csInf_singleton`.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowDiagonal
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexSetWitness

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_PDerivIterateXPowDiagonal
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit

/-! ## Witness multi-index `j₀` -/

/-- The witness multi-index `j₀ : Fin n → ℕ` defined by
    `j₀ l := if l = i then k else 0`. -/
noncomputable def witnessJ {n : ℕ} (i : Fin n) (k : ℕ) : Fin n → ℕ :=
  fun l => if l = i then k else 0

/-- **🚨 Wave T5 session 559ll — `witnessJ i k l = if l = i then k else 0`**. -/
theorem T5_witnessJ_def {n : ℕ} (i : Fin n) (k : ℕ) (l : Fin n) :
    witnessJ i k l = if l = i then k else 0 := rfl

/-- **🚨 Wave T5 session 559ll — `witnessJ i k i = k`**. -/
theorem T5_witnessJ_at_i {n : ℕ} (i : Fin n) (k : ℕ) :
    witnessJ i k i = k := by
  unfold witnessJ; simp

/-- **🚨 Wave T5 session 559ll — `witnessJ i k l = 0` for `l ≠ i`**. -/
theorem T5_witnessJ_at_other {n : ℕ} (i : Fin n) (k : ℕ) (l : Fin n) (hli : l ≠ i) :
    witnessJ i k l = 0 := by
  unfold witnessJ; simp [hli]

/-! ## multiIteratedPDeriv at witness multi-index -/

/-- **🚨 Wave T5 session 559ll — `multiIteratedPDeriv (witnessJ i k) (X i^k) = k.factorial`**.

    Combines s559kk positive case (with `j l = 0 for l ≠ i`) +
    s559jj diagonal case (`(pderiv i)^[k] (X i^k) = k.factorial`). -/
theorem T5_multiIteratedPDeriv_witnessJ_X_pow {n : ℕ} (i : Fin n) (k : ℕ) :
    multiIteratedPDeriv (witnessJ i k) ((X i : MvPolynomial (Fin n) ℝ) ^ k) =
      (k.factorial : MvPolynomial (Fin n) ℝ) := by
  rw [T5_multiIteratedPDeriv_X_pow_self_only i k (witnessJ i k)
        (fun l hli => T5_witnessJ_at_other i k l hli)]
  rw [T5_witnessJ_at_i, Nat.descFactorial_self, Nat.sub_self, pow_zero, mul_one]

/-! ## aeval at α gives the factorial as ℝ -/

/-- **🚨 Wave T5 session 559ll — `aeval α (k.factorial : _) = k.factorial : ℝ`**. -/
theorem T5_aeval_natCast_factorial {n : ℕ} (α : Fin n → ℝ) (k : ℕ) :
    aeval α ((k.factorial : MvPolynomial (Fin n) ℝ)) = (k.factorial : ℝ) := by
  rw [map_natCast]

/-- **🚨 Wave T5 session 559ll — aeval at witnessJ-pderiv is non-zero**. -/
theorem T5_aeval_multiIteratedPDeriv_witnessJ_ne_zero {n : ℕ}
    (i : Fin n) (k : ℕ) (α : Fin n → ℝ) :
    aeval α (multiIteratedPDeriv (witnessJ i k)
      ((X i : MvPolynomial (Fin n) ℝ) ^ k)) ≠ 0 := by
  rw [T5_multiIteratedPDeriv_witnessJ_X_pow]
  rw [T5_aeval_natCast_factorial]
  exact_mod_cast Nat.factorial_pos k |>.ne'

/-! ## Sum at witnessJ collapses to k/d_i -/

/-- **🚨 Wave T5 session 559ll — `∑ l, (witnessJ i k l : ℝ) / (d l : ℝ) = k / d_i`**.

    Because `witnessJ i k l = 0` for all `l ≠ i`, only `l = i`
    contributes, giving `k / d_i`. -/
theorem T5_witnessJ_sum_collapse {n : ℕ} (i : Fin n) (k : ℕ) (d : Fin n → ℕ) :
    (∑ l : Fin n, ((witnessJ i k l : ℝ) / (d l : ℝ))) = (k : ℝ) / (d i : ℝ) := by
  have h : (∑ l : Fin n, ((witnessJ i k l : ℝ) / (d l : ℝ)))
      = ∑ l ∈ Finset.univ, if l = i then ((k : ℝ) / (d i : ℝ)) else 0 := by
    apply Finset.sum_congr rfl
    intro l _
    by_cases hli : l = i
    · subst hli
      rw [T5_witnessJ_at_i, if_pos rfl]
    · rw [T5_witnessJ_at_other i k l hli]
      rw [if_neg hli]
      simp
  rw [h]
  rw [Finset.sum_ite_eq' Finset.univ i (fun _ => ((k : ℝ) / (d i : ℝ)))]
  simp

/-! ## rothIndexSet membership -/

/-- **🚨 Wave T5 session 559ll — `k/d_i ∈ rothIndexSet (X i^k) α d`**.

    The Roth-index indexing set for `X i^k` at `α` with weight
    vector `d` contains `k / d_i`, witnessed by `j₀ := witnessJ i k`. -/
theorem T5_rothIndexSet_X_pow_contains_k_div_di {n : ℕ}
    (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    ((k : ℝ) / (d i : ℝ)) ∈
      { r : ℝ | ∃ j : Fin n → ℕ,
        aeval α (multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k)) ≠ 0 ∧
        r = ∑ l, (j l : ℝ) / (d l : ℝ) } := by
  refine ⟨witnessJ i k, ?_, ?_⟩
  · exact T5_aeval_multiIteratedPDeriv_witnessJ_ne_zero i k α
  · rw [T5_witnessJ_sum_collapse]

/-! ## RothIndexSetWitness Prop scaffold -/

/-- **RothIndexSetWitness**: 1-conjunct Prop packaging the
    explicit witness for rothIndexSet (X i^k) ⊇ {k/d_i}. -/
def RothIndexSetWitness : Prop :=
  ∀ {n : ℕ} (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    ((k : ℝ) / (d i : ℝ)) ∈
      { r : ℝ | ∃ j : Fin n → ℕ,
        aeval α (multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k)) ≠ 0 ∧
        r = ∑ l, (j l : ℝ) / (d l : ℝ) }

/-- **🚨 Wave T5 session 559ll — `RothIndexSetWitness`**. -/
theorem T5_roth_index_set_witness : RothIndexSetWitness :=
  @T5_rothIndexSet_X_pow_contains_k_div_di

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ll — T-5 Phase 5 ext #4: rothIndexSet (⊇) witness**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ext #4.

    Establishes (⊇) direction of singleton-set characterization for
    `rothIndex (X i^k) α d`:

      `(k : ℝ) / (d i : ℝ) ∈ rothIndexSet (X i^k) α d`

    Witness: explicit multi-index `witnessJ i k` defined as
    `fun l => if l = i then k else 0`.

    Proof chain (real, no stubs):
    1. `multiIteratedPDeriv witnessJ (X i^k) = k.factorial`
       (combine s559kk positive case + s559jj diagonal)
    2. `aeval α k.factorial = k.factorial : ℝ ≠ 0` (factorial pos)
    3. `∑ l, witnessJ l / d l = k / d_i` (Finset.sum_ite_eq')
    4. → membership.

    Mathlib usage: `MvPolynomial.aeval`, `map_natCast`,
    `Nat.descFactorial_self`, `Nat.factorial_pos`,
    `Finset.sum_ite_eq'`, `Finset.sum_congr`.

    Sub-lemma 186/N in T-1 (T-5 Phase 5 ext #4).  Lean-core only.

    🏆 First Lean-core T-5 Phase 5 explicit-witness (⊇)
    direction for the rothIndex(X^k) singleton characterization. -/
theorem session_559ll_T5_phase5_roth_index_set_witness_headline :
    RothIndexSetWitness :=
  T5_roth_index_set_witness

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexSetWitness
