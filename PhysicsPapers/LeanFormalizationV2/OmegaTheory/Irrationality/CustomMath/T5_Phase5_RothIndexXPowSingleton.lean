/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowSingleton

  T-5 (Roth's theorem) — **Phase 5 ext #6: rothIndexSet (X i^k) at α
  with α_i = 0 is the SINGLETON {k/d_i}**, sub session 559nn —
  STRICT critical-path #316 (T-5) Phase 5 ext #6.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Singleton-set characterization (the (⊆) ∧ (⊇) closure):

      `α i = 0 → rothIndexSet (X i^k) α d = { k / d_i }`

  Combines:
  - s559ll (⊇) explicit witness: `k/d_i ∈ rothIndexSet`
  - s559mm vanishing complement: `(∃ l ≠ i, j l ≥ 1) → result = 0`
  - s559kk positive case: `(∀ l ≠ i, j l = 0) → result = k.descFactorial (j i) * X i^(k - j i)`

  (⊆) analysis: any j with `aeval ≠ 0` must have:
  - All j l = 0 for l ≠ i (else s559mm gives 0)
  - j i = k (else aeval at α with α_i = 0 vanishes)
  Hence the unique r in the set is `k / d_i`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 ext #6 — singleton-set CLOSURE.  This file delivers the
  set-level equality, opening the door for the FINAL Phase 5
  theorem `T5_rothIndex_X_pow_at_zero` via `csInf_singleton`.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexSetWitness

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowSingleton

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowSplit
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_MultiPDerivXPowVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexSetWitness

/-! ## (⊆) direction: any element equals k/d_i -/

/-- **🚨 Wave T5 session 559nn — (⊆) any rothIndexSet element is k/d_i**.

    For any multi-index `j` with `aeval α (multiIteratedPDeriv j (X i^k)) ≠ 0`
    and `α i = 0`, the corresponding sum `∑ l, j l / d l` equals `k / d_i`. -/
theorem T5_rothIndexSet_X_pow_at_zero_unique {n : ℕ}
    (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ) (hα : α i = 0)
    (j : Fin n → ℕ)
    (hne : aeval α (multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k))
            ≠ 0) :
    (∑ l, (j l : ℝ) / (d l : ℝ)) = (k : ℝ) / (d i : ℝ) := by
  -- Step 1: ∀ l ≠ i, j l = 0 (else s559mm gives 0 → contradiction with hne)
  have hself : ∀ l, l ≠ i → j l = 0 := by
    intro l hli
    by_contra hjl
    -- j l ≠ 0, so j l ≥ 1
    have h1 : 1 ≤ j l := Nat.one_le_iff_ne_zero.mpr hjl
    have hwit : ∃ l' : Fin n, l' ≠ i ∧ 1 ≤ j l' := ⟨l, hli, h1⟩
    -- Apply s559mm vanishing complement
    have h_vanish := T5_multiIteratedPDeriv_X_pow_vanish_other i k j hwit
    rw [h_vanish, map_zero] at hne
    exact hne rfl
  -- Step 2: by s559kk positive case, multi-pderiv = k.descFactorial (j i) * X i^(k - j i)
  have h_split := T5_multiIteratedPDeriv_X_pow_self_only i k j hself
  rw [h_split] at hne
  -- Step 3: aeval analysis: the result is k.descFactorial (j i) * (α i)^(k - j i)
  rw [map_mul, map_natCast, map_pow, aeval_X, hα] at hne
  -- hne : (k.descFactorial (j i) : ℝ) * 0^(k - j i) ≠ 0
  -- This requires k - j i = 0 (else 0^pos = 0) AND k.descFactorial (j i) ≠ 0
  have hki : k - j i = 0 := by
    by_contra hne_zero
    have h_zero_pow : (0 : ℝ)^(k - j i) = 0 := zero_pow hne_zero
    rw [h_zero_pow, mul_zero] at hne
    exact hne rfl
  -- k - j i = 0 in ℕ ↔ k ≤ j i
  have hk_le : k ≤ j i := Nat.sub_eq_zero_iff_le.mp hki
  -- Also need k.descFactorial (j i) ≠ 0; if j i > k, descFactorial = 0
  have hki_le : j i ≤ k := by
    by_contra hgt
    push_neg at hgt
    have h_desc_zero : k.descFactorial (j i) = 0 :=
      Nat.descFactorial_eq_zero_iff_lt.mpr hgt
    rw [h_desc_zero, Nat.cast_zero, zero_mul] at hne
    exact hne rfl
  -- So j i = k
  have hji_eq : j i = k := le_antisymm hki_le hk_le
  -- Now ∑ l, j l / d l: only l = i contributes, giving k / d_i
  have h_sum : (∑ l : Fin n, ((j l : ℝ) / (d l : ℝ)))
      = ∑ l ∈ Finset.univ, if l = i then ((k : ℝ) / (d i : ℝ)) else 0 := by
    apply Finset.sum_congr rfl
    intro l _
    by_cases hli : l = i
    · subst hli
      rw [hji_eq, if_pos rfl]
    · rw [hself l hli, Nat.cast_zero, zero_div, if_neg hli]
  rw [h_sum]
  rw [Finset.sum_ite_eq' Finset.univ i (fun _ => ((k : ℝ) / (d i : ℝ)))]
  simp

/-! ## Singleton-set characterization -/

/-- **🚨 Wave T5 session 559nn — rothIndexSet (X i^k) at α with α_i = 0 is `{k/d_i}`**. -/
theorem T5_rothIndexSet_X_pow_at_zero_eq_singleton {n : ℕ}
    (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ) (hα : α i = 0) :
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k)) ≠ 0 ∧
      r = ∑ l, (j l : ℝ) / (d l : ℝ) } = { (k : ℝ) / (d i : ℝ) } := by
  apply Set.eq_singleton_iff_unique_mem.mpr
  refine ⟨T5_rothIndexSet_X_pow_contains_k_div_di i k α d, ?_⟩
  rintro r ⟨j, hne, rfl⟩
  exact T5_rothIndexSet_X_pow_at_zero_unique i k α d hα j hne

/-! ## RothIndexXPowSingleton Prop scaffold -/

/-- **RothIndexXPowSingleton**: 1-conjunct singleton-set
    characterization Prop. -/
def RothIndexXPowSingleton : Prop :=
  ∀ {n : ℕ} (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    α i = 0 →
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j ((X i : MvPolynomial (Fin n) ℝ) ^ k)) ≠ 0 ∧
      r = ∑ l, (j l : ℝ) / (d l : ℝ) } = { (k : ℝ) / (d i : ℝ) }

/-- **🚨 Wave T5 session 559nn — `RothIndexXPowSingleton`**. -/
theorem T5_roth_index_X_pow_singleton : RothIndexXPowSingleton :=
  @T5_rothIndexSet_X_pow_at_zero_eq_singleton

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559nn — T-5 Phase 5 ext #6: rothIndexSet singleton characterization**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 ext #6 — SINGLETON CLOSURE.

    `T5_rothIndexSet_X_pow_at_zero_eq_singleton`: when `α i = 0`,

        rothIndexSet (X i^k) α d = { k / d_i }

    Composes the entire Phase 5 toolkit:
    - s559kk positive case (multi-pderiv on X i^k under hself)
    - s559ll (⊇) explicit witness via `witnessJ`
    - s559mm vanishing complement (∃ l ≠ i, j l ≥ 1 → result = 0)
    + uniqueness analysis: aeval at α with α_i=0 forces j i = k.

    Phase 5 status: SINGLETON-SET CLOSURE.  Final theorem
    `T5_rothIndex_X_pow_at_zero = k / d_i` follows by `csInf_singleton`.

    Mathlib usage: `Nat.sub_eq_zero_iff_le`, `Nat.descFactorial_eq_zero_iff_lt`,
    `zero_pow`, `Set.eq_singleton_iff_unique_mem`, `Finset.sum_ite_eq'`.

    Sub-lemma 188/N in T-1 (T-5 Phase 5 ext #6 — SINGLETON CLOSURE).
    Lean-core only.

    🏆 First Lean-core T-5 Phase 5 rothIndexSet singleton
    characterization. -/
theorem session_559nn_T5_phase5_roth_index_X_pow_singleton_headline :
    RothIndexXPowSingleton :=
  T5_roth_index_X_pow_singleton

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowSingleton
