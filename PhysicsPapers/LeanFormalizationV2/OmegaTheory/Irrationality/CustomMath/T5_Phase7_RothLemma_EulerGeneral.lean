/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 GENERAL ANALYTICAL CORE**:
  the Euler-shifted non-vanishing extended to GENERAL (non-homogeneous)
  polynomials via homogeneous decomposition.

  Single-thread hand-authored 2026-04-29 (post web research).

  ## What this file delivers

  Generalisation of `T5_homogeneous_sum_X_mul_pderiv_shifted_ne_zero`
  to non-homogeneous polynomials. Key insight: by linearity,
  `∑ i, X i * pderiv i φ = ∑_n n • homogeneousComponent n φ`,
  hence `φ + ∑ i, X i * pderiv i φ = ∑_n (n+1) • homogeneousComponent n φ`.
  This sum is non-zero iff some homogeneous component is non-zero,
  which holds iff φ ≠ 0.

  ## NAMED + (homogeneous) discharge

  - `T5_GeneralEulerShifted_NAMED` — Prop scaffold.
  - Homogeneous CASE discharged unconditionally (delegates to
    `T5_homogeneous_sum_X_mul_pderiv_shifted_ne_zero`).
  - Full general case requires homogeneousComponent linear
    independence — multi-day formalization, NAMED for now.

  Per project rule §7.0 NO STUBS — NAMED Prop has real ∀-quantified
  content, used non-vacuously, NOT `:= True`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerNonZero
import Mathlib.RingTheory.MvPolynomial.Homogeneous

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral

open MvPolynomial Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerNonZero

/-! ## NAMED Prop -/

/-- **`T5_GeneralEulerShifted_NAMED`** [NAMED HYPOTHESIS — homogeneous case
    discharged; full case to discharge].

    For ANY non-zero polynomial φ : MvPolynomial (Fin m) ℝ,
    `φ + ∑ i, X i * pderiv i φ ≠ 0`.

    Proof strategy (deferred): decompose φ = ∑_n homogeneousComponent n φ,
    apply `IsHomogeneous.sum_X_mul_pderiv` to each component, get
    `(n+1) • component`, then linear-independence of homogeneous
    parts gives non-vanishing. -/
def T5_GeneralEulerShifted_NAMED : Prop :=
  ∀ {m : ℕ} (φ : MvPolynomial (Fin m) ℝ), φ ≠ 0 →
    φ + ∑ i : Fin m, X i * pderiv i φ ≠ 0

/-! ## Homogeneous specialization (UNCONDITIONAL) -/

/-- **`T5_GeneralEulerShifted_NAMED_for_homogeneous`** — homogeneous case
    UNCONDITIONALLY discharged. -/
theorem T5_GeneralEulerShifted_NAMED_for_homogeneous
    {m : ℕ} {n : ℕ} (φ : MvPolynomial (Fin m) ℝ) (h_hom : φ.IsHomogeneous n) (hφ : φ ≠ 0) :
    φ + ∑ i : Fin m, X i * pderiv i φ ≠ 0 :=
  T5_homogeneous_sum_X_mul_pderiv_shifted_ne_zero h_hom hφ

/-! ## Bridge: homogeneous → general direction -/

/-- **`T5_GeneralEulerShifted_via_homogeneous`** [bridge]:
    if the general NAMED is provided, then the homogeneous case follows
    (trivially — just specialize). -/
theorem T5_GeneralEulerShifted_via_homogeneous_implies_homogeneous
    (h : T5_GeneralEulerShifted_NAMED) :
    ∀ {m : ℕ} {n : ℕ} (φ : MvPolynomial (Fin m) ℝ),
      φ.IsHomogeneous n → φ ≠ 0 →
      φ + ∑ i : Fin m, X i * pderiv i φ ≠ 0 :=
  fun φ _h_hom hφ => h φ hφ

/-! ## FULL general case via coefficient-wise argument -/

/-- **Coefficient-wise identity** for monomial: for `φ = monomial t r`,
    `coeff α (X i * pderiv i (monomial t r)) = (t i : ℝ) * coeff α (monomial t r)`. -/
theorem T5_coeff_X_mul_pderiv_monomial_eq
    {m : ℕ} (i : Fin m) (t : Fin m →₀ ℕ) (r : ℝ) (α : Fin m →₀ ℕ) :
    coeff α (X i * pderiv i (monomial t r : MvPolynomial (Fin m) ℝ)) =
      ((t i : ℕ) : ℝ) * coeff α (monomial t r : MvPolynomial (Fin m) ℝ) := by
  rw [X_mul_pderiv_monomial]
  -- Goal: coeff α ((t i) • monomial t r) = (t i : ℕ) * coeff α (monomial t r)
  rw [coeff_smul]
  -- (t i) • coeff α (monomial t r) = (t i : ℕ) * coeff α (monomial t r)
  push_cast
  ring

/-- **Coefficient identity**: `coeff α (∑ i, X i * pderiv i (monomial t r)) =
    (∑ i, t i : ℝ) * coeff α (monomial t r)`. -/
theorem T5_coeff_sum_X_mul_pderiv_monomial_eq
    {m : ℕ} (t : Fin m →₀ ℕ) (r : ℝ) (α : Fin m →₀ ℕ) :
    coeff α (∑ i : Fin m, X i * pderiv i (monomial t r : MvPolynomial (Fin m) ℝ)) =
      ((∑ i, t i : ℕ) : ℝ) * coeff α (monomial t r : MvPolynomial (Fin m) ℝ) := by
  rw [coeff_sum]
  push_cast
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intros i _
  exact T5_coeff_X_mul_pderiv_monomial_eq i t r α

/-! ## Headline-update -/

/-- **`T5_GeneralEulerShifted_holds_for_monomial`** — discharge for monomials.
    Concretely: for non-zero monomial, the Euler-shifted sum is non-zero
    (specialize via the coefficient-wise identity). -/
theorem T5_GeneralEulerShifted_holds_for_monomial
    {m : ℕ} (t : Fin m →₀ ℕ) (r : ℝ) (hr : r ≠ 0) :
    (monomial t r : MvPolynomial (Fin m) ℝ) +
      ∑ i : Fin m, X i * pderiv i (monomial t r) ≠ 0 := by
  intro h_zero
  -- Take coefficient at α = t: should be (1 + ∑ t i) * r ≠ 0
  have h_coeff := congrArg (coeff t) h_zero
  rw [coeff_zero, coeff_add, T5_coeff_sum_X_mul_pderiv_monomial_eq] at h_coeff
  -- h_coeff : coeff t (monomial t r) + ((∑ i, t i : ℕ) : ℝ) * coeff t (monomial t r) = 0
  have h_coeff_t : coeff t (monomial t r : MvPolynomial (Fin m) ℝ) = r := by
    rw [coeff_monomial]
    simp
  rw [h_coeff_t] at h_coeff
  -- h_coeff : r + ((∑ i, t i : ℕ) : ℝ) * r = 0
  -- Factor: (1 + (∑ i, t i : ℕ) : ℝ) * r = 0
  have h_factored : ((1 : ℝ) + ((∑ i, t i : ℕ) : ℝ)) * r = 0 := by linarith
  rcases mul_eq_zero.mp h_factored with h_one_plus | h_r
  · -- (1 : ℝ) + ((∑ i, t i : ℕ) : ℝ) = 0
    -- But ((∑ i, t i : ℕ) : ℝ) ≥ 0, so 1 + this ≥ 1 > 0
    have h_nn : ((∑ i, t i : ℕ) : ℝ) ≥ 0 := by positivity
    linarith
  · exact hr h_r

/-! ## FULL general case via coefficient-wise induction -/

/-- **Coefficient-wise X·pderiv identity** for arbitrary φ — extends the
    monomial case by `monomial_add_induction_on`. -/
theorem T5_coeff_X_mul_pderiv_eq
    {m : ℕ} (i : Fin m) (α : Fin m →₀ ℕ) (φ : MvPolynomial (Fin m) ℝ) :
    coeff α (X i * pderiv i φ) = ((α i : ℕ) : ℝ) * coeff α φ := by
  induction φ using MvPolynomial.monomial_add_induction_on with
  | C r =>
    -- pderiv i (C r) = 0, so X i * 0 = 0
    rw [MvPolynomial.pderiv_C, mul_zero, coeff_zero]
    -- RHS: (α i) * coeff α (C r) = (α i) * (if 0 = α then r else 0)
    rw [coeff_C]
    by_cases h_α : α = 0
    · subst h_α; simp
    · -- α ≠ 0, so 0 ≠ α, so coeff α (C r) = 0
      have h_neq : (0 : Fin m →₀ ℕ) ≠ α := Ne.symm h_α
      simp [h_neq]
  | monomial_add t b f _h_supp _hb ih =>
    -- pderiv i (monomial t b + f) = pderiv i (monomial t b) + pderiv i f
    rw [map_add, mul_add, coeff_add]
    -- Use monomial case for first part, IH for second
    -- coeff α (X i * pderiv i (monomial t b))
    have h_mono : coeff α (X i * pderiv i (monomial t b : MvPolynomial (Fin m) ℝ)) =
        ((α i : ℕ) : ℝ) * coeff α (monomial t b : MvPolynomial (Fin m) ℝ) := by
      rw [T5_coeff_X_mul_pderiv_monomial_eq i t b α]
      -- Goal: ((t i : ℕ) : ℝ) * coeff α (monomial t b) = ((α i : ℕ) : ℝ) * coeff α (monomial t b)
      -- These are equal because: coeff α (monomial t b) = if t = α then b else 0
      rw [coeff_monomial]
      by_cases h : α = t
      · subst h; rfl
      · -- α ≠ t, so t ≠ α (Mathlib: coeff_monomial uses `t = α`)
        have h_sym : ¬t = α := Ne.symm h
        simp [h_sym]
    rw [h_mono, ih, coeff_add]
    ring

/-- **Sum identity**: `coeff α (∑ i, X i * pderiv i φ) = (∑ i, α i : ℝ) * coeff α φ`. -/
theorem T5_coeff_sum_X_mul_pderiv_eq
    {m : ℕ} (α : Fin m →₀ ℕ) (φ : MvPolynomial (Fin m) ℝ) :
    coeff α (∑ i : Fin m, X i * pderiv i φ) =
      ((∑ i : Fin m, α i : ℕ) : ℝ) * coeff α φ := by
  rw [coeff_sum]
  push_cast
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intros i _
  exact T5_coeff_X_mul_pderiv_eq i α φ

/-! ## GENERAL discharge — final lemma -/

/-- **🚨 GENERAL DISCHARGE — `T5_GeneralEulerShifted_holds`** :
    For ANY non-zero φ in MvPolynomial (Fin m) ℝ:
    `φ + ∑ i, X i * pderiv i φ ≠ 0`. -/
theorem T5_GeneralEulerShifted_holds : T5_GeneralEulerShifted_NAMED := by
  intros m φ hφ
  -- Find α with coeff α φ ≠ 0
  rw [Ne, MvPolynomial.ext_iff] at hφ
  push_neg at hφ
  obtain ⟨α, hα⟩ := hφ
  rw [coeff_zero] at hα
  -- Now show coeff α (LHS) ≠ 0
  intro h_zero
  apply hα
  have h_coeff := congrArg (coeff α) h_zero
  rw [coeff_zero, coeff_add, T5_coeff_sum_X_mul_pderiv_eq] at h_coeff
  -- h_coeff : coeff α φ + ((∑ i, α i : ℕ) : ℝ) * coeff α φ = 0
  -- Factor: (1 + (∑ i, α i : ℕ) : ℝ) * coeff α φ = 0
  have h_factored : ((1 : ℝ) + ((∑ i : Fin m, α i : ℕ) : ℝ)) * coeff α φ = 0 := by linarith
  rcases mul_eq_zero.mp h_factored with h_one_plus | h_r
  · -- (1 : ℝ) + ((∑ i, α i : ℕ) : ℝ) = 0 — impossible since both nonnegative and 1 > 0
    have h_nn : ((∑ i : Fin m, α i : ℕ) : ℝ) ≥ 0 := by positivity
    linarith
  · exact h_r

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 GENERAL ANALYTICAL CORE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 general analytical.

    Three derivations:
    1. `T5_GeneralEulerShifted_NAMED` — Prop scaffold (NAMED, full case)
    2. `T5_GeneralEulerShifted_NAMED_for_homogeneous` — homogeneous case
       UNCONDITIONAL (uses 2dddf3d Euler-shifted lemma)
    3. `T5_GeneralEulerShifted_via_homogeneous_implies_homogeneous` —
       direction bridge

    **Discharge plan for full case** (multi-day):
    - Use `MvPolynomial.sum_homogeneousComponent`: φ = ∑_n homogeneousComponent n φ
    - Apply `IsHomogeneous.sum_X_mul_pderiv` per component
    - Get φ + ∑ X_i pderiv_i φ = ∑_n (n+1) • homogeneousComponent n φ
    - Show this is non-zero via homogeneous-component linear independence

    For now, the homogeneous case suffices for many concrete Wave-2
    sub-arguments (Schmidt aux poly factorization is degree-d homogeneous
    after change of variables to (X_i - α)).

    Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
    NAMED Props valid IF discharged in subsequent ticks. Full discharge
    is the next analytical target.

    Sub-lemma 316/N in T-5 Phase 7. Lean-core only. NO STUBS — NAMED has
    real ∀-quantified content. -/
theorem session_W2_phase_2_2_euler_general_analytical_headline :
    ∀ {m : ℕ} {n : ℕ} (φ : MvPolynomial (Fin m) ℝ),
      φ.IsHomogeneous n → φ ≠ 0 →
      φ + ∑ i : Fin m, X i * pderiv i φ ≠ 0 :=
  fun φ h_hom hφ => T5_GeneralEulerShifted_NAMED_for_homogeneous φ h_hom hφ

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral
