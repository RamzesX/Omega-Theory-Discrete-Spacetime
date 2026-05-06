/-
  OmegaTheory.Foundations.FiniteAFAlgebraIsUnitaryProductClosure

  **Lion's-Pride Phase 6.5s (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra IS-UNITARY PRODUCT CLOSURE
  at c_part — proves the modulus-multiplicativity law
  `cPartSquaredNorm (u * v) = cPartSquaredNorm u · cPartSquaredNorm v`
  (the standard `|zw|² = |z|²|w|²` identity for complex numbers,
  ported through the ℝ × ℝ ≅ ℂ representation), and uses it to derive
  the multiplicative closure of the unitary group at c_part:
  `cPartIsUnitary u → cPartIsUnitary v → cPartIsUnitary (u * v)`.
  Foundation step toward the unitary group U(A_F)|c whose modulo-
  center quotient gives the gauge group.*

  ## Why this file

  Phase 6.5o (iter 125) shipped the `cPartIsUnitary` predicate plus
  4 atomic closure properties (one, neg-one, adjoint preservation,
  real-scalar-unit characterisation). For a SUBGROUP-of-A_F structure
  on the unitary elements (the inner-automorphism group whose
  modulo-center quotient gives the gauge group of the spectral triple),
  we need: closed under 1, *, AND inverse.

  This file ships the missing PRODUCT closure — the multiplicative
  analog of Phase 6.5p `cPartIsSelfAdjoint_add_closure` for the
  additive Lie algebra. The inverse closure is downstream
  (a unitary u has u⁻¹ = adj u, but this needs the `mul_adj_eq_one`
  identity which we defer to a future phase).

  ## What this file ships

  | Property                                                  | Theorem                                              |
  |-----------------------------------------------------------|------------------------------------------------------|
  | `cPartSquaredNorm_mul`                                    | `‖u·v‖² = ‖u‖² · ‖v‖²` (modulus-multiplicativity)    |
  | `cPartIsUnitary_mul_closure`                              | unitary · unitary = unitary                          |
  | `cPartIsUnitary_pow2`                                     | unitary u → unitary (u·u)                            |
  | Headline (3-conjunct)                                     | `finite_AF_algebra_is_unitary_product_closure_report`|

  ## Author

  Lion's-Pride dynamic /loop iteration 129 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
import OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraIsUnitaryProductClosure

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
open OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary

/-! ## 1. Modulus-multiplicativity at c_part -/

/-- **Squared-norm multiplicativity at c_part**:
    `cPartSquaredNorm (u * v) = cPartSquaredNorm u · cPartSquaredNorm v`.

    This is the standard `|zw|² = |z|²|w|²` identity for complex
    numbers, ported through the ℝ × ℝ ≅ ℂ representation:

      |u·v|² = (u₁v₁ - u₂v₂)² + (u₁v₂ + u₂v₁)²
             = u₁²v₁² - 2u₁v₁u₂v₂ + u₂²v₂² + u₁²v₂² + 2u₁v₂u₂v₁ + u₂²v₁²
             = u₁²v₁² + u₂²v₂² + u₁²v₂² + u₂²v₁²    (cross terms cancel)
             = (u₁² + u₂²)(v₁² + v₂²)
             = |u|² · |v|²

    Provable by `ring` after unfolding the c_part multiplication. -/
theorem cPartSquaredNorm_mul (u v : FiniteAFAlgebra) :
    cPartSquaredNorm (u * v) = cPartSquaredNorm u * cPartSquaredNorm v := by
  -- Goal unfolded:
  --   (u.c_part.1 * v.c_part.1 - u.c_part.2 * v.c_part.2)²
  --   + (u.c_part.1 * v.c_part.2 + u.c_part.2 * v.c_part.1)²
  --   = (u.c_part.1² + u.c_part.2²) * (v.c_part.1² + v.c_part.2²)
  show (u.c_part.1 * v.c_part.1 - u.c_part.2 * v.c_part.2)^2
       + (u.c_part.1 * v.c_part.2 + u.c_part.2 * v.c_part.1)^2 =
       (u.c_part.1^2 + u.c_part.2^2) * (v.c_part.1^2 + v.c_part.2^2)
  ring

/-! ## 2. Unitary product closure at c_part -/

/-- **Unitary elements close under multiplication at c_part**:
    `cPartIsUnitary u → cPartIsUnitary v → cPartIsUnitary (u * v)`.

    Proof: from `‖u‖² = 1` and `‖v‖² = 1`, by modulus-multiplicativity
    `‖u·v‖² = ‖u‖² · ‖v‖² = 1 · 1 = 1`. -/
theorem cPartIsUnitary_mul_closure
    {u v : FiniteAFAlgebra}
    (hu : cPartIsUnitary u) (hv : cPartIsUnitary v) :
    cPartIsUnitary (u * v) := by
  show cPartSquaredNorm (u * v) = 1
  rw [cPartSquaredNorm_mul]
  -- Goal: cPartSquaredNorm u * cPartSquaredNorm v = 1
  have hu' : cPartSquaredNorm u = 1 := hu
  have hv' : cPartSquaredNorm v = 1 := hv
  rw [hu', hv']
  ring

/-! ## 3. Unitary squaring closure -/

/-- **Unitary elements close under squaring at c_part**:
    `cPartIsUnitary u → cPartIsUnitary (u * u)`.

    Special case of `cPartIsUnitary_mul_closure` with `v = u`. -/
theorem cPartIsUnitary_pow2
    {u : FiniteAFAlgebra} (hu : cPartIsUnitary u) :
    cPartIsUnitary (u * u) :=
  cPartIsUnitary_mul_closure hu hu

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6.5s headline — finite Chamseddine-Connes
    A_F algebra IsUnitary product-closure structural report at c_part.**

    For any elements `u v : FiniteAFAlgebra` (with hypotheses `hu`, `hv`):

    1. **Modulus-multiplicativity at c_part**:
       `cPartSquaredNorm (u * v) = cPartSquaredNorm u · cPartSquaredNorm v`.

    2. **Unitary product closure at c_part**:
       `cPartIsUnitary u → cPartIsUnitary v → cPartIsUnitary (u * v)`.

    3. **Unitary squaring closure at c_part**:
       `cPartIsUnitary u → cPartIsUnitary (u * u)`. -/
theorem finite_AF_algebra_is_unitary_product_closure_report
    (u v : FiniteAFAlgebra)
    (hu : cPartIsUnitary u) (hv : cPartIsUnitary v) :
    cPartSquaredNorm (u * v) = cPartSquaredNorm u * cPartSquaredNorm v ∧
    cPartIsUnitary (u * v) ∧
    cPartIsUnitary (u * u) := by
  refine ⟨?_, ?_, ?_⟩
  · exact cPartSquaredNorm_mul u v
  · exact cPartIsUnitary_mul_closure hu hv
  · exact cPartIsUnitary_pow2 hu

end OmegaTheory.Foundations.FiniteAFAlgebraIsUnitaryProductClosure
