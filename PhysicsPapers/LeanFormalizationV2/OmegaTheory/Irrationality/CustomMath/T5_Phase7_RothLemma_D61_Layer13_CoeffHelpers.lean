/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer13_CoeffHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 13: coefficient evaluation helpers**.

  Foundational sub-lemmas for polynomial coefficient evaluations in
  the Hindry-Silverman D.6.1 chain:

  - C-1..3: coeff zero/X foundational identities.
  - C-4..6: coeff at X^n.
  - C-7..9: coeff in product/sum.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer13_CoeffHelpers

open Polynomial

/-! ## CF-1 — Coeff of zero polynomial -/

/-- **CF-1 — `T5_coeff_zero`**: `(0 : ℝ[X]).coeff k = 0`. -/
theorem T5_coeff_zero (k : ℕ) :
    (0 : Polynomial ℝ).coeff k = 0 :=
  Polynomial.coeff_zero k

/-! ## CF-2 — Coeff of one polynomial -/

/-- **CF-2 — `T5_coeff_one_zero`**: `(1 : ℝ[X]).coeff 0 = 1`. -/
theorem T5_coeff_one_zero :
    (1 : Polynomial ℝ).coeff 0 = 1 :=
  Polynomial.coeff_one_zero

/-! ## CF-3 — Coeff of constant -/

/-- **CF-3 — `T5_coeff_C_zero`**: `(C c).coeff 0 = c`. -/
theorem T5_coeff_C_zero (c : ℝ) :
    (Polynomial.C c).coeff 0 = c :=
  Polynomial.coeff_C_zero

/-! ## CF-4 — Coeff of X -/

/-- **CF-4 — `T5_coeff_X_one`**: `Polynomial.X.coeff 1 = 1`. -/
theorem T5_coeff_X_one :
    (Polynomial.X : Polynomial ℝ).coeff 1 = 1 :=
  Polynomial.coeff_X_one

/-! ## CF-5 — Coeff of X at zero -/

/-- **CF-5 — `T5_coeff_X_zero`**: `Polynomial.X.coeff 0 = 0`. -/
theorem T5_coeff_X_zero :
    (Polynomial.X : Polynomial ℝ).coeff 0 = 0 :=
  Polynomial.coeff_X_zero

/-! ## CF-6 — Coeff of (X - α) at 1 -/

/-- **CF-6 — `T5_coeff_X_sub_C_one`**: `(X - C α).coeff 1 = 1`. -/
theorem T5_coeff_X_sub_C_one (α : ℝ) :
    (Polynomial.X - Polynomial.C α).coeff 1 = 1 := by
  rw [Polynomial.coeff_sub]
  rw [T5_coeff_X_one, Polynomial.coeff_C]
  simp

/-! ## CF-7 — Coeff of (X - α) at 0 -/

/-- **CF-7 — `T5_coeff_X_sub_C_zero`**: `(X - C α).coeff 0 = -α`. -/
theorem T5_coeff_X_sub_C_zero (α : ℝ) :
    (Polynomial.X - Polynomial.C α).coeff 0 = -α := by
  rw [Polynomial.coeff_sub]
  rw [T5_coeff_X_zero, Polynomial.coeff_C_zero]
  ring

/-! ## CF-8 — Coeff is additive -/

/-- **CF-8 — `T5_coeff_add`**: `(P + Q).coeff k = P.coeff k + Q.coeff k`. -/
theorem T5_coeff_add (P Q : Polynomial ℝ) (k : ℕ) :
    (P + Q).coeff k = P.coeff k + Q.coeff k :=
  Polynomial.coeff_add P Q k

/-! ## CF-9 — Coeff is subtractive -/

/-- **CF-9 — `T5_coeff_sub`**: `(P - Q).coeff k = P.coeff k - Q.coeff k`. -/
theorem T5_coeff_sub (P Q : Polynomial ℝ) (k : ℕ) :
    (P - Q).coeff k = P.coeff k - Q.coeff k :=
  Polynomial.coeff_sub P Q k

/-! ## CF-10 — Layer 13 foundational marker -/

/-- **CF-10 — `T5_D61_Layer13_completed_marker`**: 5-conjunct marker for
    Layer 13 completion (coefficient helpers). -/
theorem T5_D61_Layer13_completed_marker :
    (∀ (k : ℕ), (0 : Polynomial ℝ).coeff k = 0) ∧
    ((Polynomial.X : Polynomial ℝ).coeff 1 = 1) ∧
    ((Polynomial.X : Polynomial ℝ).coeff 0 = 0) ∧
    (∀ (α : ℝ), (Polynomial.X - Polynomial.C α).coeff 0 = -α) ∧
    (∀ (P Q : Polynomial ℝ) (k : ℕ),
      (P + Q).coeff k = P.coeff k + Q.coeff k) :=
  ⟨T5_coeff_zero,
   T5_coeff_X_one,
   T5_coeff_X_zero,
   T5_coeff_X_sub_C_zero,
   T5_coeff_add⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer13_CoeffHelpers
