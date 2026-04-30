/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity

  T-5 (Roth's theorem) — **V7-N2 sub-foundation: multivariate denominator
  product positivity (DPP-1..DPP-6)**.

  Foundational positivity lemmas for V7-N2 multivariate integer
  non-vanishing lower bound.  The product `∏ q_i.den^{R_i}` is the
  central quantity in the V7-N2 conclusion — these sub-lemmas establish
  its basic positivity / lower-bound / rpow-form properties.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real Prop content, complete proofs.
-/

import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity

/-! ## DPP-1 — Per-index denominator positivity (ℕ ≥ 1) -/

/-- **DPP-1 — `T5_qden_ge_one`**: every rational has `q.den ≥ 1`.

    Trivial Mathlib fact (`q.pos`), but exposing it in this namespace
    for direct use. -/
theorem T5_qden_ge_one (q : ℚ) : 1 ≤ q.den := q.pos

/-! ## DPP-2 — Per-index denominator cast positivity (ℝ > 0) -/

/-- **DPP-2 — `T5_qden_real_pos`**: `(q.den : ℝ) > 0`.

    Cast-up of DPP-1.  Foundational for div_pos / pow_pos arguments. -/
theorem T5_qden_real_pos (q : ℚ) : (0 : ℝ) < (q.den : ℝ) := by
  exact_mod_cast q.pos

/-! ## DPP-3 — Per-index pow positivity -/

/-- **DPP-3 — `T5_qden_pow_pos`**: `(q.den : ℝ)^R > 0` for any `R : ℕ`.

    Combines DPP-2 + `pow_pos`.  Required for div_le_iff arguments. -/
theorem T5_qden_pow_pos (q : ℚ) (R : ℕ) : (0 : ℝ) < (q.den : ℝ) ^ R :=
  pow_pos (T5_qden_real_pos q) R

/-! ## DPP-4 — Tuple product positivity -/

/-- **DPP-4 — `T5_tuple_qden_pow_prod_pos`**: `∏ i, (q_i.den : ℝ)^{R_i} > 0`.

    Per-factor positivity (DPP-3) lifted to Finset product via
    `Finset.prod_pos`.  Required for the V7-N2 conclusion's
    `1 / ∏ ... > 0`. -/
theorem T5_tuple_qden_pow_prod_pos
    {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ) :
    (0 : ℝ) < ∏ i, ((q i).den : ℝ) ^ (R i) := by
  induction m with
  | zero => simp
  | succ n ih =>
    rw [Fin.prod_univ_succ]
    exact mul_pos (T5_qden_pow_pos (q 0) (R 0))
      (ih (fun i => q i.succ) (fun i => R i.succ))

/-! ## DPP-5 — Tuple product ≥ 1 -/

/-- **DPP-5 — `T5_tuple_qden_pow_prod_ge_one`**: `∏ i, (q_i.den : ℝ)^{R_i} ≥ 1`.

    Per-factor `q_i.den ≥ 1 ⇒ q_i.den^{R_i} ≥ 1` lifted to product
    via `Finset.one_le_prod'` (requires nonneg + ≥ 1 per factor).

    Useful upper bound: `1 / ∏ ... ≤ 1`. -/
theorem T5_tuple_qden_pow_prod_ge_one
    {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ) :
    (1 : ℝ) ≤ ∏ i, ((q i).den : ℝ) ^ (R i) := by
  have h_one : (1 : ℝ) = ∏ _ : Fin m, (1 : ℝ) := by simp
  rw [h_one]
  apply Finset.prod_le_prod
  · intros i _; norm_num
  · intros i _
    apply one_le_pow₀
    exact_mod_cast T5_qden_ge_one (q i)

/-! ## DPP-6 — Inverse positivity -/

/-- **DPP-6 — `T5_tuple_qden_pow_prod_inv_pos`**: `0 < 1 / (∏ i, q_i.den^{R_i})`.

    Inverse of DPP-4 via `one_div_pos`.  Required form for the V7-N2
    conclusion's LHS. -/
theorem T5_tuple_qden_pow_prod_inv_pos
    {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ) :
    (0 : ℝ) < 1 / ∏ i, ((q i).den : ℝ) ^ (R i) := by
  exact one_div_pos.mpr (T5_tuple_qden_pow_prod_pos q R)

/-! ## DPP-7 — Inverse ≤ 1 -/

/-- **DPP-7 — `T5_tuple_qden_pow_prod_inv_le_one`**: `1 / (∏ i, q_i.den^{R_i}) ≤ 1`.

    Combination of DPP-5 + DPP-4.  When `∏ ≥ 1`, then `1/∏ ≤ 1`.
    Sanity lemma for V7-N2 conclusion bounds. -/
theorem T5_tuple_qden_pow_prod_inv_le_one
    {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ) :
    1 / ∏ i, ((q i).den : ℝ) ^ (R i) ≤ (1 : ℝ) := by
  rw [div_le_iff₀ (T5_tuple_qden_pow_prod_pos q R)]
  rw [one_mul]
  exact T5_tuple_qden_pow_prod_ge_one q R

/-! ## DPP-8 — Headline: product positivity bundle -/

/-- **🚨 DPP-8 — `T5_DPP_BLOCK_D_PRODUCT_POSITIVITY_HEADLINE`**:
    paper-citable bundle of the 7 product-positivity sub-lemmas.

    Foundational tier-99 sub-foundation for V7-N2 (multivariate integer
    non-vanishing lower bound).  The product `∏ q_i.den^{R_i}` central
    to the V7-N2 conclusion has its basic positivity / boundedness /
    inverse properties established here.

    Per project rule §7.0: real Prop content, no `sorry`. -/
theorem T5_DPP_BLOCK_D_PRODUCT_POSITIVITY_HEADLINE :
    -- (a) DPP-1: q.den ≥ 1
    (∀ (q : ℚ), 1 ≤ q.den) ∧
    -- (b) DPP-2: (q.den : ℝ) > 0
    (∀ (q : ℚ), (0 : ℝ) < (q.den : ℝ)) ∧
    -- (c) DPP-3: (q.den : ℝ)^R > 0
    (∀ (q : ℚ) (R : ℕ), (0 : ℝ) < (q.den : ℝ) ^ R) ∧
    -- (d) DPP-4: ∏ pos
    (∀ {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ),
      (0 : ℝ) < ∏ i, ((q i).den : ℝ) ^ (R i)) ∧
    -- (e) DPP-5: ∏ ≥ 1
    (∀ {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ),
      (1 : ℝ) ≤ ∏ i, ((q i).den : ℝ) ^ (R i)) ∧
    -- (f) DPP-6: 1/∏ > 0
    (∀ {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ),
      (0 : ℝ) < 1 / ∏ i, ((q i).den : ℝ) ^ (R i)) ∧
    -- (g) DPP-7: 1/∏ ≤ 1
    (∀ {m : ℕ} (q : Fin m → ℚ) (R : Fin m → ℕ),
      1 / ∏ i, ((q i).den : ℝ) ^ (R i) ≤ (1 : ℝ)) :=
  ⟨T5_qden_ge_one,
   T5_qden_real_pos,
   T5_qden_pow_pos,
   fun {m} q R => T5_tuple_qden_pow_prod_pos q R,
   fun {m} q R => T5_tuple_qden_pow_prod_ge_one q R,
   fun {m} q R => T5_tuple_qden_pow_prod_inv_pos q R,
   fun {m} q R => T5_tuple_qden_pow_prod_inv_le_one q R⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity
