/-
  OmegaTheory.Emergence.WhitneyMollifier

  **HPW ingredient E1 — concrete MollifierData witness.**

  Provides `standardMollifier : MollifierData` by tensor-producing a 1-D
  `ContDiffBump (0 : ℝ)` with `rIn = 1/2`, `rOut = 1`.  The resulting 4-D
  bump is supported in the unit cube (sup-norm), C^∞, nonneg, and strictly
  positive at the origin — matching the five analytic fields of
  `MollifierData`.

  The `phi_integral_one` field is carried as a plain `Prop` by the parent
  structure; we instantiate it with `True`.  The full Fourier/Whitney
  apparatus needed to replace that `True` with an actual integral identity
  is tracked as E2 in `NOTES_HPW_ELIMINATION.md`.

  0 sorry, 0 new axioms.

  — Claude + user, 2026-04-19
-/

import Mathlib.Analysis.Calculus.BumpFunction.Basic
import Mathlib.Analysis.Calculus.BumpFunction.InnerProduct
import Mathlib.Analysis.Calculus.ContDiff.Basic
import OmegaTheory.Emergence.WhitneyInterpolant

namespace OmegaTheory.Emergence

open Finset

/-- The 1-D bump centered at `0 : ℝ` with inner radius `1/2` and outer radius `1`.
Uses Mathlib's `ContDiffBump`, which via the inner-product-space instance is
available on `ℝ`. -/
noncomputable def stdBump1D : ContDiffBump (0 : ℝ) :=
  ⟨1 / 2, 1, by norm_num, by norm_num⟩

/-- Positivity of the 1-D bump at the origin (the closed ball of radius `rIn = 1/2`
contains `0`). -/
theorem stdBump1D_apply_zero : stdBump1D (0 : ℝ) = 1 :=
  stdBump1D.one_of_mem_closedBall (by
    simp [Metric.mem_closedBall, stdBump1D])

/-- Zero outside the outer radius: `1 ≤ |t| ⟹ stdBump1D t = 0`.
We use `≤` instead of `<` because the underlying `zero_of_le_dist` tolerates
equality — matching the Mathlib convention for `ContDiffBump` support. -/
theorem stdBump1D_zero_of_one_le_abs {t : ℝ} (ht : 1 ≤ |t|) :
    stdBump1D t = 0 := by
  apply stdBump1D.zero_of_le_dist
  -- `dist t 0 = |t|`, and `stdBump1D.rOut = 1`
  rw [Real.dist_eq, sub_zero]
  exact ht

/-- Nonnegativity of the 1-D bump. -/
theorem stdBump1D_nonneg (t : ℝ) : 0 ≤ stdBump1D t := stdBump1D.nonneg

/-- Smoothness of the 1-D bump: `C^∞` (coerced top of `ℕ∞` inside `WithTop ℕ∞`).
Matches the relaxed `MollifierData.phi_smooth` spec. -/
theorem stdBump1D_contDiff :
    ContDiff ℝ (↑(⊤ : ℕ∞) : WithTop ℕ∞) stdBump1D :=
  stdBump1D.contDiff

/-- The 4-D standard mollifier `phi : (Fin 4 → ℝ) → ℝ` is the tensor product of
four copies of `stdBump1D`:
    `phi(x) = ∏_{i ∈ Fin 4} stdBump1D (x i)`.

This yields support in the unit *cube* (sup-norm ≤ 1), which contains the
unit ball in the default norm on `Fin 4 → ℝ` (that norm is sup). -/
noncomputable def standardMollifierPhi (x : Fin 4 → ℝ) : ℝ :=
  ∏ i : Fin 4, stdBump1D (x i)

/-- The standard mollifier evaluated at the origin equals `1`. -/
theorem standardMollifierPhi_zero : standardMollifierPhi 0 = 1 := by
  unfold standardMollifierPhi
  simp [stdBump1D_apply_zero]

/-- Strict positivity of the standard mollifier at the origin: `phi 0 = 1 > 0`. -/
theorem standardMollifierPhi_origin_pos : 0 < standardMollifierPhi 0 := by
  rw [standardMollifierPhi_zero]; exact one_pos

/-- Pointwise nonnegativity of the standard mollifier. -/
theorem standardMollifierPhi_nonneg (x : Fin 4 → ℝ) :
    0 ≤ standardMollifierPhi x := by
  unfold standardMollifierPhi
  exact Finset.prod_nonneg (fun i _ => stdBump1D_nonneg (x i))

/-- Smoothness of the standard mollifier: it is `C^∞` on `Fin 4 → ℝ`.
The proof uses that each factor `x ↦ stdBump1D (x i)` is `C^∞` (composition of
the 1-D bump with the coordinate projection) and `Finset.prod` of `C^∞` functions
is `C^∞`. -/
theorem standardMollifierPhi_contDiff :
    ContDiff ℝ (↑(⊤ : ℕ∞) : WithTop ℕ∞) standardMollifierPhi := by
  -- Rewrite the product in `∏ i ∈ t, ...` form to use `contDiff_prod`.
  have hrw : standardMollifierPhi =
      (fun x : Fin 4 → ℝ => ∏ i ∈ (Finset.univ : Finset (Fin 4)), stdBump1D (x i)) := by
    funext x
    unfold standardMollifierPhi
    rfl
  rw [hrw]
  -- `contDiff_prod` : ∀ i ∈ t, ContDiff 𝕜 n (f i) → ContDiff 𝕜 n (fun y => ∏ i ∈ t, f i y)
  exact contDiff_prod (fun i _ =>
    stdBump1D_contDiff.comp (contDiff_apply ℝ ℝ i))

/-- Support lemma: if the sup-norm of `x` exceeds `1`, then at least one coordinate
has absolute value `≥ 1`, hence the corresponding bump factor is zero, hence the
whole product is zero.

Proof via contrapositive of `pi_norm_lt_iff`: `1 < ‖x‖ ⇒ ¬(‖x‖ < 1)`, which by
`pi_norm_lt_iff 0 < 1` and `push_neg` yields `∃ i, 1 ≤ ‖x i‖ = |x i|`. -/
theorem standardMollifierPhi_support_sup {x : Fin 4 → ℝ}
    (hx : 1 < ‖x‖) : standardMollifierPhi x = 0 := by
  unfold standardMollifierPhi
  -- Extract an index i such that 1 ≤ ‖x i‖.
  have h_not_lt : ¬ (‖x‖ < 1) := not_lt_of_gt hx
  rw [pi_norm_lt_iff (by norm_num : (0:ℝ) < 1)] at h_not_lt
  -- `push_neg` is deprecated in Lean 4.29; use the direct push-negation form.
  push Not at h_not_lt
  obtain ⟨i, hi⟩ := h_not_lt
  -- Rewrite ‖x i‖ = |x i| (real normed group).
  have hi' : (1 : ℝ) ≤ |x i| := by
    simpa [Real.norm_eq_abs] using hi
  -- The i-th factor of the product vanishes.
  have hzero : stdBump1D (x i) = 0 := stdBump1D_zero_of_one_le_abs hi'
  exact Finset.prod_eq_zero (Finset.mem_univ i) hzero

/-- Final witness: a fully-populated `MollifierData` using the tensor-product
4-D standard bump. -/
noncomputable def standardMollifier : MollifierData where
  phi              := standardMollifierPhi
  phi_smooth       := standardMollifierPhi_contDiff
  phi_support      := fun x hx => standardMollifierPhi_support_sup hx
  phi_nonneg       := standardMollifierPhi_nonneg
  phi_origin_pos   := standardMollifierPhi_origin_pos
  phi_integral_one := True

/-! ## E2 — lattice-exact witness

The standard tensor-product bump is **lattice-exact**: at the origin it
equals `1`, and at every nonzero integer lattice point it equals `0`.
This is "cheap" (does **not** require Poisson summation / Fourier analysis)
because the open-ball support `‖t‖ < 1 = rOut` already excludes every
nonzero integer (since `|n| ≥ 1` for `n ∈ ℤ \ {0}`). -/

/-- Each 1-D bump vanishes at every nonzero integer: if `n ∈ ℤ` and `n ≠ 0`,
then `|n| ≥ 1`, which lands outside the open unit ball, hence the bump is `0`. -/
theorem stdBump1D_zero_of_ne_zero_int {n : ℤ} (hn : n ≠ 0) :
    stdBump1D ((n : ℝ)) = 0 := by
  apply stdBump1D_zero_of_one_le_abs
  -- `|(n : ℝ)| = (|n| : ℝ) ≥ 1` from `n ≠ 0 : ℤ` ⇒ `|n| ≥ 1`.
  have : (1 : ℤ) ≤ |n| := Int.one_le_abs hn
  have h_cast : |((n : ℝ))| = ((|n| : ℤ) : ℝ) := by
    rw [← Int.cast_abs]
  rw [h_cast]
  exact_mod_cast this

/-- The 4-D tensor-product bump at a nonzero integer lattice point is `0`. -/
theorem standardMollifierPhi_zero_at_nonzero_int
    {n : Fin 4 → ℤ} (hn : n ≠ 0) :
    standardMollifierPhi (fun i => (n i : ℝ)) = 0 := by
  unfold standardMollifierPhi
  -- `n ≠ 0` ⇒ `∃ i, n i ≠ 0`.
  obtain ⟨i, hi⟩ : ∃ i, n i ≠ 0 := by
    by_contra h
    push Not at h
    exact hn (funext fun i => h i)
  -- The i-th factor is `0`; the whole product is `0`.
  exact Finset.prod_eq_zero (Finset.mem_univ i)
    (stdBump1D_zero_of_ne_zero_int hi)

/-- **`standardMollifier` is lattice-exact.**  The tensor-product standard bump
satisfies the Strang-Fix-style interpolation condition `φ(n) = δ_{n,0}` for
integer lattice points, which is what the convolution interpolant at lattice
points needs to collapse to a single term `g(p) · φ(0) = g(p)`. -/
theorem standardMollifier_isLatticeExact :
    MollifierData.IsLatticeExact standardMollifier where
  phi_zero_eq_one           := standardMollifierPhi_zero
  phi_zero_at_nonzero_int   := fun n hn =>
    standardMollifierPhi_zero_at_nonzero_int hn

end OmegaTheory.Emergence
