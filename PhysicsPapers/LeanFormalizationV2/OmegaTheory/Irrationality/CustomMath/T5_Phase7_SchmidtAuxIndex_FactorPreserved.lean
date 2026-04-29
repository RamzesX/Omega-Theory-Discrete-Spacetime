/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_FactorPreserved

  T-5 (Roth's theorem) — **Discharge of factor preservation NAMED via
  factor-form decomposition**.

  Key structural lemma: if P : MvPolynomial (Fin m) ℝ has the form
  `(X k - C α) * Q` where Q doesn't depend on X k, AND `j k = 0`,
  then `multiIteratedPDeriv j P` retains the (X k - C α) factor (as
  the first factor of a product).  This is proved by induction on the
  foldr structure of multiIteratedPDeriv.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_FactorPreserved

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general

/-! ## pderiv preserves factor (X k - C α) when applied at i ≠ k -/

theorem T5_pderiv_preserves_X_factor {n : ℕ} (α : ℝ) (k i : Fin n) (h : i ≠ k)
    (Q : MvPolynomial (Fin n) ℝ) :
    (pderiv i) ((X k - C α) * Q) = (X k - C α) * (pderiv i) Q := by
  rw [Derivation.leibniz]
  -- pderiv i (X k - C α) = 0 when i ≠ k
  have h_factor_zero : (pderiv i) (X k - C α : MvPolynomial (Fin n) ℝ) = 0 := by
    rw [map_sub, MvPolynomial.pderiv_X, MvPolynomial.pderiv_C, sub_zero]
    simp [Pi.single_eq_of_ne (Ne.symm h)]
  rw [h_factor_zero]
  simp [smul_eq_mul]

/-! ## (pderiv i)^[n] preserves factor (X k - C α) when i ≠ k -/

theorem T5_pderiv_iter_preserves_X_factor {n : ℕ} (α : ℝ) (k i : Fin n)
    (h : i ≠ k) (n_iter : ℕ) (Q : MvPolynomial (Fin n) ℝ) :
    ((pderiv i)^[n_iter]) ((X k - C α) * Q) =
      (X k - C α) * ((pderiv i)^[n_iter]) Q := by
  induction n_iter generalizing Q with
  | zero => simp
  | succ p ih =>
    rw [Function.iterate_succ_apply', Function.iterate_succ_apply']
    rw [ih, T5_pderiv_preserves_X_factor α k i h]

/-! ## Lemma: (pderiv k)^[0] = id, so factor preserved -/

theorem T5_pderiv_iter_zero_preserves_X_factor {n : ℕ} (α : ℝ) (k : Fin n)
    (Q : MvPolynomial (Fin n) ℝ) :
    ((pderiv k)^[0]) ((X k - C α) * Q) = (X k - C α) * Q := by
  simp

/-! ## Foldr step preserves factor when j k = 0 -/

theorem T5_foldr_preserves_X_factor {n : ℕ} (α : ℝ) (k : Fin n) (j : Fin n → ℕ)
    (h_jk : j k = 0) (l : List (Fin n)) (Q : MvPolynomial (Fin n) ℝ) :
    l.foldr (fun i q => (pderiv i)^[j i] q) ((X k - C α) * Q) =
      (X k - C α) * l.foldr (fun i q => (pderiv i)^[j i] q) Q := by
  induction l generalizing Q with
  | nil => simp
  | cons head tail ih =>
    rw [List.foldr_cons, List.foldr_cons]
    rw [ih]
    -- Now: (pderiv head)^[j head] ((X k - C α) * (foldr ... Q)) = (X k - C α) * (pderiv head)^[j head] (foldr ... Q)
    by_cases h_eq : head = k
    · -- head = k: j head = j k = 0, so (pderiv k)^[0] = id; factor preserved trivially
      subst h_eq
      rw [h_jk]
      simp
    · -- head ≠ k: use the iter preservation lemma
      exact T5_pderiv_iter_preserves_X_factor α k head h_eq (j head) _

/-! ## Main lemma: multiIteratedPDeriv j ((X k - C α) * Q) = (X k - C α) * multiIteratedPDeriv j Q
       when j k = 0 -/

theorem T5_multiIteratedPDeriv_preserves_X_factor {n : ℕ} (α : ℝ) (k : Fin n)
    (j : Fin n → ℕ) (h_jk : j k = 0) (Q : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv j ((X k - C α) * Q) =
      (X k - C α) * multiIteratedPDeriv j Q := by
  unfold multiIteratedPDeriv
  exact T5_foldr_preserves_X_factor α k j h_jk (List.finRange n) Q

/-! ## P_m factorization: ∏ i, (X i - C α) = (X k - C α) * ∏_{i ≠ k} (X i - C α) -/

theorem T5_schmidtAuxPoly_factor_at_k {m : ℕ} (α : ℝ) (k : Fin m) :
    T5_schmidtAuxPoly_general m α =
      (X k - C α) * ∏ i ∈ Finset.univ.erase k, (X i - C α : MvPolynomial (Fin m) ℝ) := by
  unfold T5_schmidtAuxPoly_general
  exact (Finset.mul_prod_erase _ (fun i => X i - C α) (Finset.mem_univ k)).symm

/-! ## Main theorem: factor preservation for P_m -/

theorem T5_SchmidtAuxIndex_factor_preserved_unconditional :
    T5_SchmidtAuxIndex_factor_preserved_NAMED := by
  intros m α j h_exists
  obtain ⟨k, hk⟩ := h_exists
  -- Decompose P_m = (X k - C α) * Q where Q = ∏_{i ≠ k} (X i - C α)
  rw [T5_schmidtAuxPoly_factor_at_k α k]
  -- multiIteratedPDeriv j ((X k - C α) * Q) = (X k - C α) * multiIteratedPDeriv j Q
  rw [T5_multiIteratedPDeriv_preserves_X_factor α k j hk]
  -- aeval ((X k - C α) * something) at α-vector = 0
  rw [map_mul]
  -- aeval (X k - C α) at α-vector = α - α = 0
  have h_zero : (aeval (fun _ : Fin m => α)) (X k - C α : MvPolynomial (Fin m) ℝ) = 0 := by
    simp
  rw [h_zero]
  ring

/-! ## Headline -/

/-- **🚨 HEADLINE — factor preservation NAMED FULLY DISCHARGED**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 m≥3 closure step.

    Proves `T5_SchmidtAuxIndex_factor_preserved_NAMED` UNCONDITIONALLY
    via the structural decomposition:
    1. P_m = (X k - C α) * (∏ i ≠ k, (X i - C α))
    2. For j k = 0, multiIteratedPDeriv preserves the (X k - C α) factor
       (induction on foldr structure + Leibniz product rule + (pderiv k)^[0] = id)
    3. aeval at (α,...,α) of (X k - C α) factor gives 0.

    This handles ALL m simultaneously — m=3, m=4, m=5, ...!

    Sub-lemma 299/N in T-5 Phase 7.  Lean-core only.  NO STUBS. -/
theorem session_W2_phase_2_4_factor_preserved_headline :
    T5_SchmidtAuxIndex_factor_preserved_NAMED :=
  T5_SchmidtAuxIndex_factor_preserved_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_FactorPreserved
