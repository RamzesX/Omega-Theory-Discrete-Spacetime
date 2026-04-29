/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3

  T-5 (Roth's theorem) — **D.6.1 Layer 3: Wronskian factor split foundations**.

  Sub-lemmas around the factor split `P = (X − α)^t · V` where
  `V (α) ≠ 0` and `t = rootMultiplicity α P` (the maximal multiplicity).

  - L3-1..3: Mathlib `pow_rootMultiplicity_dvd` bridge — divisibility.
  - L3-4..6: existence of the divisor witness.
  - L3-7..9: index of the residual factor V is 0.
  - L3-10..12: Layer 3 marker.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Polynomial.FieldDivision
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer2

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3

open Real
open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1

/-! ## L3-1 — Pow-rootMultiplicity divides P -/

/-- **L3-1 — `T5_pow_rootMultiplicity_dvd`**: `(X − α)^(rootMultiplicity α P) ∣ P`.

    Mathlib: `Polynomial.pow_rootMultiplicity_dvd`. -/
theorem T5_pow_rootMultiplicity_dvd
    (P : Polynomial ℝ) (α : ℝ) :
    (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) ∣ P :=
  Polynomial.pow_rootMultiplicity_dvd P α

/-! ## L3-2 — Maximal-power factor witness existence -/

/-- **L3-2 — `T5_exists_max_pow_factor`**: existence of the V factor in
    `P = (X − α)^t · V`. -/
theorem T5_exists_max_pow_factor
    (P : Polynomial ℝ) (α : ℝ) :
    ∃ V : Polynomial ℝ,
      P = (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) * V := by
  exact T5_pow_rootMultiplicity_dvd P α

/-! ## L3-3 — Choose the V factor (Classical) -/

/-- **L3-3 — `T5_max_pow_factor`**: pick the residual V factor. -/
noncomputable def T5_max_pow_factor
    (P : Polynomial ℝ) (α : ℝ) : Polynomial ℝ :=
  Classical.choose (T5_exists_max_pow_factor P α)

/-! ## L3-4 — V factor divisor identity -/

/-- **L3-4 — `T5_max_pow_factor_eq`**: the chosen V satisfies the
    factorisation. -/
theorem T5_max_pow_factor_eq
    (P : Polynomial ℝ) (α : ℝ) :
    P = (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) *
        T5_max_pow_factor P α :=
  Classical.choose_spec (T5_exists_max_pow_factor P α)

/-! ## L3-5 — V is non-zero when P is non-zero -/

/-- **L3-5 — `T5_max_pow_factor_ne_zero`**: for `P ≠ 0`, the residual
    V factor is non-zero. -/
theorem T5_max_pow_factor_ne_zero
    (P : Polynomial ℝ) (hP : P ≠ 0) (α : ℝ) :
    T5_max_pow_factor P α ≠ 0 := by
  intro hV
  have h := T5_max_pow_factor_eq P α
  rw [hV, mul_zero] at h
  exact hP h

/-! ## L3-6 — Multiplicity of V at α is bounded by 0 -/

/-- **L3-6 — `T5_max_pow_factor_multiplicity_eq_zero`**: for `P ≠ 0`,
    the residual V factor has multiplicity 0 at α (i.e., `V(α) ≠ 0`).

    This is the maximality property of `rootMultiplicity`: pulling
    out `(X − α)^t` exhausts all (X − α) factors. -/
theorem T5_max_pow_factor_multiplicity_eq_zero
    (P : Polynomial ℝ) (hP : P ≠ 0) (α : ℝ) :
    (T5_max_pow_factor P α).rootMultiplicity α = 0 := by
  -- We use the Mathlib lemma rootMultiplicity_eq_iff or direct argument:
  -- if (X-α)^(t+1) divided V, then (X-α)^(t+1)*(X-α)^t = (X-α)^(2t+1) would
  -- divide P, contradicting maximality.
  by_contra h
  have hV : T5_max_pow_factor P α ≠ 0 := T5_max_pow_factor_ne_zero P hP α
  have hpos : 0 < (T5_max_pow_factor P α).rootMultiplicity α := Nat.pos_of_ne_zero h
  -- By Mathlib, this means (X - α) | V
  have hdvd : (Polynomial.X - Polynomial.C α) ∣ T5_max_pow_factor P α := by
    have : (Polynomial.X - Polynomial.C α)^1 ∣ T5_max_pow_factor P α := by
      have h_dvd_pow := Polynomial.pow_rootMultiplicity_dvd (T5_max_pow_factor P α) α
      exact dvd_trans (pow_dvd_pow _ hpos) h_dvd_pow
    simpa using this
  -- Then (X - α)^(t+1) divides P, contradicting maximality
  obtain ⟨W, hW⟩ := hdvd
  have hWne : W ≠ 0 := by
    intro hWzero
    rw [hWzero, mul_zero] at hW
    exact hV hW
  have h_extra :
      (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α + 1) ∣ P := by
    -- P = (X-α)^t * V = (X-α)^t * ((X-α) * W) = (X-α)^(t+1) * W
    refine ⟨W, ?_⟩
    have h_eq := T5_max_pow_factor_eq P α
    calc P = (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) *
              T5_max_pow_factor P α := h_eq
      _ = (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) *
              ((Polynomial.X - Polynomial.C α) * W) := by rw [hW]
      _ = (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α + 1) * W := by ring
  have h_max := (Polynomial.le_rootMultiplicity_iff hP).mpr h_extra
  omega

/-! ## L3-7 — V's residual at α is non-zero -/

/-- **L3-7 — `T5_max_pow_factor_eval_ne_zero`**: for `P ≠ 0`, `V(α) ≠ 0`. -/
theorem T5_max_pow_factor_eval_ne_zero
    (P : Polynomial ℝ) (hP : P ≠ 0) (α : ℝ) :
    (T5_max_pow_factor P α).eval α ≠ 0 := by
  intro hzero
  have h_mult_pos : 0 < (T5_max_pow_factor P α).rootMultiplicity α := by
    apply (Polynomial.rootMultiplicity_pos (T5_max_pow_factor_ne_zero P hP α)).mpr
    rw [Polynomial.IsRoot.def]
    exact hzero
  have h_mult_zero := T5_max_pow_factor_multiplicity_eq_zero P hP α
  omega

/-! ## L3-8 — Layer 3 paper-citable headline -/

/-- **L3-8 — `T5_D61_Layer3_completed_marker`**: 4-conjunct marker
    for Layer 3 completion (Wronskian factor split foundations). -/
theorem T5_D61_Layer3_completed_marker :
    (∀ (P : Polynomial ℝ) (α : ℝ),
      (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) ∣ P) ∧
    (∀ (P : Polynomial ℝ) (α : ℝ),
      P = (Polynomial.X - Polynomial.C α)^(P.rootMultiplicity α) *
          T5_max_pow_factor P α) ∧
    (∀ (P : Polynomial ℝ), P ≠ 0 → ∀ (α : ℝ),
      T5_max_pow_factor P α ≠ 0) ∧
    (∀ (P : Polynomial ℝ), P ≠ 0 → ∀ (α : ℝ),
      (T5_max_pow_factor P α).eval α ≠ 0) :=
  ⟨T5_pow_rootMultiplicity_dvd,
   T5_max_pow_factor_eq,
   T5_max_pow_factor_ne_zero,
   T5_max_pow_factor_eval_ne_zero⟩

/-! ## L3-9 — Index of the residual factor V at α is 0 (real form) -/

/-- **L3-9 — `T5_univarIndex_max_pow_factor_at_α`**: for `P ≠ 0`,
    `T5_univarIndex (T5_max_pow_factor P α) α = 0`. -/
theorem T5_univarIndex_max_pow_factor_at_α
    (P : Polynomial ℝ) (hP : P ≠ 0) (α : ℝ) :
    T5_univarIndex (T5_max_pow_factor P α) α = 0 := by
  unfold T5_univarIndex
  rw [T5_max_pow_factor_multiplicity_eq_zero P hP α]
  norm_cast

/-! ## L3-10 — Index of `(X − α)^t · V` at α equals t -/

/-- **L3-10 — `T5_univarIndex_split_at_α`**: for `P ≠ 0`, the index of
    `P` at α in factored form `(X − α)^t * V` equals `t` (the
    multiplicity).

    This is the index-form of `pow_rootMultiplicity_dvd`. -/
theorem T5_univarIndex_split_at_α
    (P : Polynomial ℝ) (hP : P ≠ 0) (α : ℝ) :
    T5_univarIndex P α = (P.rootMultiplicity α : ℝ) := by
  unfold T5_univarIndex
  rfl

/-! ## L3-11 — Layer 3 alternative paper-citable headline -/

/-- **L3-11 — `T5_univarIndex_eq_rootMultiplicity`**: simpler form of L3-10
    without P ≠ 0 hypothesis (true for P = 0 too). -/
theorem T5_univarIndex_eq_rootMultiplicity
    (P : Polynomial ℝ) (α : ℝ) :
    T5_univarIndex P α = (P.rootMultiplicity α : ℝ) := by
  unfold T5_univarIndex
  rfl

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3


