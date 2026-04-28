/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial

  T-5 (Roth's theorem) — **Phase 7 ext #7: coefficient vector → polynomial
  in restrictDegree submodule**, sub session 559zz — STRICT
  critical-path #316 (T-5) Phase 7 ext #7.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Forward map from coefficient vectors to bounded-degree polynomials:

      `coeffsToPoly : (BoundedMI n d → ℤ) → MvPolynomial (Fin n) ℤ`
      `coeffsToPoly c := ∑ k : BoundedMI n d, monomial (toFinsupp k) (c k)`

  Plus the membership theorem:

      `coeffsToPoly c ∈ MvPolynomial.restrictDegree (Fin n) ℤ d`

  This is the assembly bridge: the abstract `BoundedMI n d → ℤ`
  coefficient solution from Siegel's lemma (s559xx) becomes a concrete
  polynomial in the bounded-degree submodule of `MvPolynomial (Fin n) ℤ`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #7 — coefficient → polynomial assembly.  Composes:
  - s559uu (`T5_monomial_mem_restrictDegree`): each monomial summand
    in `restrictDegree` because its support multi-index is bounded.
  - s559vv (`BoundedMI Fintype`): valid index for the finite sum.
  - s559ww (`T5_boundedMItoFinsupp_le`): bound preservation lifts
    each multi-index k into the support requirement of restrictDegree.

  Combined with s559xx (`T5_auxiliary_poly_abstract_exists`), the
  output `p : BoundedMI n d → ℤ` becomes
  `coeffsToPoly p ∈ restrictDegree (Fin n) ℤ d` — the input form
  expected by Roth-Schmidt-Wirsing analytical-side arguments.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeMonomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeMonomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp

/-! ## Coefficient vector → polynomial assembly -/

/-- **🚨 Wave T5 session 559zz — `coeffsToPoly` assembly map**.

    Build a `MvPolynomial (Fin n) ℤ` from a `BoundedMI n d → ℤ`
    coefficient vector by summing monomials over the bounded
    multi-index Fintype. -/
noncomputable def coeffsToPoly {n d : ℕ} (c : BoundedMI n d → ℤ) :
    MvPolynomial (Fin n) ℤ :=
  ∑ k : BoundedMI n d, MvPolynomial.monomial (T5_boundedMItoFinsupp k) (c k)

/-! ## Membership in restrictDegree submodule -/

/-- **🚨 Wave T5 session 559zz — `coeffsToPoly c ∈ restrictDegree`**.

    For any coefficient vector `c : BoundedMI n d → ℤ`, the assembled
    polynomial lies in `MvPolynomial.restrictDegree (Fin n) ℤ d`. -/
theorem T5_coeffsToPoly_mem_restrictDegree {n d : ℕ}
    (c : BoundedMI n d → ℤ) :
    coeffsToPoly c ∈ MvPolynomial.restrictDegree (Fin n) ℤ d := by
  unfold coeffsToPoly
  apply Submodule.sum_mem
  intro k _
  rw [T5_monomial_mem_restrictDegree]
  right
  intro i
  exact T5_boundedMItoFinsupp_le k i

/-! ## Zero coefficient → zero polynomial -/

/-- **🚨 Wave T5 session 559zz — `coeffsToPoly 0 = 0`**.

    The zero coefficient vector assembles to the zero polynomial. -/
theorem T5_coeffsToPoly_zero {n d : ℕ} :
    coeffsToPoly (fun _ : BoundedMI n d => (0 : ℤ)) = 0 := by
  unfold coeffsToPoly
  simp

/-! ## Linearity in coefficient vector -/

/-- **🚨 Wave T5 session 559zz — `coeffsToPoly (c + c') = coeffsToPoly c + coeffsToPoly c'`**.

    The assembly map is additive in the coefficient vector. -/
theorem T5_coeffsToPoly_add {n d : ℕ} (c c' : BoundedMI n d → ℤ) :
    coeffsToPoly (c + c') = coeffsToPoly c + coeffsToPoly c' := by
  unfold coeffsToPoly
  rw [← Finset.sum_add_distrib]
  congr 1
  funext k
  rw [Pi.add_apply]
  rw [← (MvPolynomial.monomial (T5_boundedMItoFinsupp k)).map_add]

/-! ## CoeffsToPolynomial Prop scaffold -/

/-- **CoeffsToPolynomial**: 3-conjunct Prop packaging the assembly
    map + restrictDegree membership + zero-preservation + additivity. -/
def CoeffsToPolynomial : Prop :=
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ),
    coeffsToPoly c ∈ MvPolynomial.restrictDegree (Fin n) ℤ d) ∧
  (∀ {n d : ℕ},
    coeffsToPoly (fun _ : BoundedMI n d => (0 : ℤ)) = 0) ∧
  (∀ {n d : ℕ} (c c' : BoundedMI n d → ℤ),
    coeffsToPoly (c + c') = coeffsToPoly c + coeffsToPoly c')

/-- **🚨 Wave T5 session 559zz — `CoeffsToPolynomial`**. -/
theorem T5_coeffs_to_polynomial : CoeffsToPolynomial :=
  ⟨@T5_coeffsToPoly_mem_restrictDegree,
   @T5_coeffsToPoly_zero,
   @T5_coeffsToPoly_add⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zz — T-5 Phase 7 ext #7: coefficient vector → polynomial**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #7.

    Forward assembly map from `BoundedMI n d → ℤ` coefficient vectors
    (output form of Siegel's lemma in s559xx) to bounded-degree
    polynomials in `MvPolynomial.restrictDegree (Fin n) ℤ d`.

    Three derivations + Prop:
    1. `T5_coeffsToPoly_mem_restrictDegree` — membership
    2. `T5_coeffsToPoly_zero` — zero preservation
    3. `T5_coeffsToPoly_add` — additivity (linearity in coefficients)
    + CoeffsToPolynomial Prop (3-conjunct).

    Composes Mathlib's `Submodule.sum_mem` with our s559uu
    (`T5_monomial_mem_restrictDegree`) and s559ww
    (`T5_boundedMItoFinsupp_le`) to get each summand in the submodule.

    Mathlib usage: `Submodule.sum_mem`, `MvPolynomial.monomial`,
    `MvPolynomial.restrictDegree`, `Finset.sum_add_distrib`,
    `LinearMap.map_add` (via monomial as additive-monoid hom on
    coefficient).

    Sub-lemma 200/N in T-1 (T-5 Phase 7 ext #7).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 coefficient → polynomial
    assembly bridge. -/
theorem session_559zz_T5_phase7_coeffs_to_polynomial_headline :
    CoeffsToPolynomial :=
  T5_coeffs_to_polynomial

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
