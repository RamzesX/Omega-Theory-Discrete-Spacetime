/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer11_DegreeHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 11: degree-bound helpers**.

  Foundational sub-lemmas for polynomial degree manipulations in
  the Hindry-Silverman D.6.1 chain:

  - DG-1..3: natDegree of basic polynomials.
  - DG-4..6: natDegree of products + sums.
  - DG-7..9: degree bounds for derivative.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.Degree.Definitions
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Polynomial.RingDivision

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer11_DegreeHelpers

open Polynomial

/-! ## DG-1 — natDegree zero -/

/-- **DG-1 — `T5_natDegree_zero`**: `(0 : ℝ[X]).natDegree = 0`. -/
theorem T5_natDegree_zero :
    (0 : Polynomial ℝ).natDegree = 0 :=
  Polynomial.natDegree_zero

/-! ## DG-2 — natDegree one -/

/-- **DG-2 — `T5_natDegree_one`**: `(1 : ℝ[X]).natDegree = 0`. -/
theorem T5_natDegree_one :
    (1 : Polynomial ℝ).natDegree = 0 :=
  Polynomial.natDegree_one

/-! ## DG-3 — natDegree of constant -/

/-- **DG-3 — `T5_natDegree_C`**: `(C c : ℝ[X]).natDegree = 0`. -/
theorem T5_natDegree_C (c : ℝ) :
    (Polynomial.C c).natDegree = 0 :=
  Polynomial.natDegree_C c

/-! ## DG-4 — natDegree X -/

/-- **DG-4 — `T5_natDegree_X`**: `Polynomial.X.natDegree = 1`. -/
theorem T5_natDegree_X :
    (Polynomial.X : Polynomial ℝ).natDegree = 1 :=
  Polynomial.natDegree_X

/-! ## DG-5 — natDegree X - C α -/

/-- **DG-5 — `T5_natDegree_X_sub_C`**: `(X - C α).natDegree = 1`. -/
theorem T5_natDegree_X_sub_C (α : ℝ) :
    (Polynomial.X - Polynomial.C α).natDegree = 1 :=
  Polynomial.natDegree_X_sub_C α

/-! ## DG-6 — natDegree (X - α)^t = t -/

/-- **DG-6 — `T5_natDegree_X_sub_C_pow`**: `((X - C α)^t).natDegree = t`. -/
theorem T5_natDegree_X_sub_C_pow (α : ℝ) (t : ℕ) :
    ((Polynomial.X - Polynomial.C α)^t).natDegree = t := by
  rw [Polynomial.natDegree_pow, T5_natDegree_X_sub_C]
  ring

/-! ## DG-7 — natDegree of product (over a domain) -/

/-- **DG-7 — `T5_natDegree_mul`**: for non-zero `P`, `Q`,
    `(P · Q).natDegree = P.natDegree + Q.natDegree`. -/
theorem T5_natDegree_mul (P Q : Polynomial ℝ) (hP : P ≠ 0) (hQ : Q ≠ 0) :
    (P * Q).natDegree = P.natDegree + Q.natDegree :=
  Polynomial.natDegree_mul hP hQ

/-! ## DG-8 — derivative reduces natDegree -/

/-- **DG-8 — `T5_natDegree_derivative_lt`**: for `P` with `natDegree ≥ 1`,
    `P.derivative.natDegree < P.natDegree`. -/
theorem T5_natDegree_derivative_lt (P : Polynomial ℝ) (hP : 1 ≤ P.natDegree) :
    P.derivative.natDegree < P.natDegree := by
  exact Polynomial.natDegree_derivative_lt (by omega : P.natDegree ≠ 0)

/-! ## DG-9 — derivative degree bound -/

/-- **DG-9 — `T5_natDegree_derivative_le`**: `P.derivative.natDegree + 1 ≤ P.natDegree`
    for `P.natDegree ≥ 1`. -/
theorem T5_natDegree_derivative_le (P : Polynomial ℝ) (hP : 1 ≤ P.natDegree) :
    P.derivative.natDegree + 1 ≤ P.natDegree := by
  have h := T5_natDegree_derivative_lt P hP
  omega

/-! ## DG-10 — Layer 11 foundational marker -/

/-- **DG-10 — `T5_D61_Layer11_completed_marker`**: 5-conjunct marker for
    Layer 11 completion (degree-bound helpers). -/
theorem T5_D61_Layer11_completed_marker :
    (Polynomial.X : Polynomial ℝ).natDegree = 1 ∧
    (∀ (α : ℝ), (Polynomial.X - Polynomial.C α).natDegree = 1) ∧
    (∀ (α : ℝ) (t : ℕ),
      ((Polynomial.X - Polynomial.C α)^t).natDegree = t) ∧
    (∀ (P Q : Polynomial ℝ), P ≠ 0 → Q ≠ 0 →
      (P * Q).natDegree = P.natDegree + Q.natDegree) ∧
    (∀ (P : Polynomial ℝ), 1 ≤ P.natDegree →
      P.derivative.natDegree < P.natDegree) :=
  ⟨T5_natDegree_X,
   T5_natDegree_X_sub_C,
   T5_natDegree_X_sub_C_pow,
   T5_natDegree_mul,
   T5_natDegree_derivative_lt⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer11_DegreeHelpers
