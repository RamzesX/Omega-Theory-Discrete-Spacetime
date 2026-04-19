/-
  OmegaTheory.Geometry.LatticeShiftHolonomy

  **Graph-driven theorem set**: the abelian (trivial) core of the lattice
  shift-operator structure.

  This file is the first theorem set in OmegaTheoryV2 motivated *directly*
  by graph-analysis output (proof-of-concept for graph-driven theorem
  generation).  Spectral analysis of the OmegaTheoryV2 dependency graph
  (Grothendieck clusters + Berry-phase subtopology classification) assigns
  Berry-flux magnitudes

    shiftZ_one, shiftZ_zero : 13.25
    shiftZ_succ, shiftZ_pred : 8.75

  to the integer-shift theorems in `PoincareLemma.lean`, placing them among
  the top of the Berry-flux spectrum in the whole OmegaTheoryV2 corpus.
  High Berry flux = topologically-nontrivial triangle structure in the
  directed graph, suggestive of gauge-like holonomy.

  This file formalizes the *abelian core* of this observation:
    * Integer shifts compose as a group (`ℤ`, +).
    * Shift cycles `a + b + (-(a+b)) = 0` close to the identity on points.
    * Scalar-field pullbacks under commuting shifts commute, so the
      path-ordered triangle holonomy is trivial on scalars.

  > "This theorem set captures the abelian (trivial) core of the dependency
  >  structure that the graph analysis (Grothendieck clusters + Berry-phase
  >  subtopology classification) assigns Berry-flux magnitude ≥ 8.75 to —
  >  the third-highest in the whole OmegaTheoryV2 corpus.  The non-trivial
  >  (non-abelian) lift corresponds to the discrete gauge connection on the
  >  ErrorGaugeField stack and is open research."

  The non-abelian lift — the actual source of the observed Berry flux at
  the operator/commutator level — lives on `ErrorGaugeField` /
  `ErrorGaugeSU2` / `ErrorGaugeSU3`, where the discrete connection carries
  Lie-algebra-valued data and shift compositions around the triangle
  accumulate a Wilson-loop-style holonomy.  That is open research.

  Agent: shiftz-holonomy (2026-04-19).
-/

import OmegaTheory.Geometry.PoincareLemma
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime

/-! ## Functional form of the integer shift

  `shiftZ` in `PoincareLemma.lean` has signature
    `shiftZ : LatticePoint → Fin 4 → ℤ → LatticePoint`,
  i.e. it shifts the point first.  For holonomy statements we want to view
  the shift as an *operator* on `LatticePoint`, parameterized by direction
  and integer amount.  `shiftOp μ k` is the curried form. -/

/-- Shift as an operator on the lattice:
    `shiftOp μ k = fun p => shiftZ p μ k`. -/
def shiftOp (μ : Fin 4) (k : ℤ) : LatticePoint → LatticePoint :=
  fun p => shiftZ p μ k

@[simp] theorem shiftOp_apply (μ : Fin 4) (k : ℤ) (p : LatticePoint) :
    shiftOp μ k p = shiftZ p μ k := rfl

/-! ## Group law for same-direction shifts (the abelian core) -/

/-- `shiftOp μ 0 = id`.  Zero shift is the identity operator. -/
theorem shiftOp_zero (μ : Fin 4) : shiftOp μ (0 : ℤ) = id := by
  funext p; simp [shiftOp]

/-- **Group law**: `shiftOp μ (a+b) = shiftOp μ b ∘ shiftOp μ a`.
    Composition of same-direction shifts is addition of amounts. -/
theorem shiftOp_add (μ : Fin 4) (a b : ℤ) :
    shiftOp μ (a + b) = shiftOp μ b ∘ shiftOp μ a := by
  funext p
  simp only [shiftOp, Function.comp_apply]
  exact (shiftZ_add p μ a b).symm

/-- Symmetric variant: `shiftOp μ (a+b) = shiftOp μ a ∘ shiftOp μ b`
    (same-direction shifts commute). -/
theorem shiftOp_add_comm (μ : Fin 4) (a b : ℤ) :
    shiftOp μ (a + b) = shiftOp μ a ∘ shiftOp μ b := by
  rw [add_comm, shiftOp_add]

/-- Same-direction integer shifts commute as operators. -/
theorem shiftOp_same_commute (μ : Fin 4) (a b : ℤ) :
    shiftOp μ a ∘ shiftOp μ b = shiftOp μ b ∘ shiftOp μ a := by
  funext p
  simp only [shiftOp, Function.comp_apply]
  rw [shiftZ_add, shiftZ_add, add_comm]

/-- Negative shift cancels the positive one: `shiftOp μ (-k) ∘ shiftOp μ k = id`. -/
theorem shiftOp_neg_cancel (μ : Fin 4) (k : ℤ) :
    shiftOp μ (-k) ∘ shiftOp μ k = id := by
  rw [← shiftOp_add, add_neg_cancel, shiftOp_zero]

/-- Positive cancels negative: `shiftOp μ k ∘ shiftOp μ (-k) = id`. -/
theorem shiftOp_cancel_neg (μ : Fin 4) (k : ℤ) :
    shiftOp μ k ∘ shiftOp μ (-k) = id := by
  rw [← shiftOp_add, neg_add_cancel, shiftOp_zero]

/-! ## Triangle-closure theorem (the first holonomy claim)

  A closed triangle `a → b → -(a+b)` returns to the origin.
  This is the **classical Stokes-theorem statement** at the discrete level
  for abelian shift operators: the concatenation of three edges whose
  integer amounts sum to zero is the identity map. -/

/-- **Triangle closure of the same-direction integer shift.**
    The three-step cycle `(a, b, -(a+b))` closes: returns to the identity. -/
theorem shiftOp_triangle_closure (μ : Fin 4) (a b : ℤ) :
    shiftOp μ (-(a + b)) ∘ shiftOp μ b ∘ shiftOp μ a = id := by
  funext p
  simp only [shiftOp, Function.comp_apply]
  rw [shiftZ_add, shiftZ_add]
  have h : a + (b + -(a + b)) = 0 := by ring
  rw [h, shiftZ_zero]; rfl

/-- Alternate form: the sum `a + b + (-(a+b))` applied to a single shift
    returns to the origin.  Equivalent statement on points. -/
theorem shiftZ_triangle_point (p : LatticePoint) (μ : Fin 4) (a b : ℤ) :
    shiftZ (shiftZ (shiftZ p μ a) μ b) μ (-(a + b)) = p := by
  rw [shiftZ_add, shiftZ_add]
  have h : a + (b + -(a + b)) = 0 := by ring
  rw [h, shiftZ_zero]

/-! ## Cross-direction commutativity

  Shifts in *different* directions also commute as operators on lattice
  points, because distinct coordinates are independent.  This is what
  makes the abelian-holonomy claim on scalar fields work generally. -/

/-- Operator form of `shiftZ_comm`: cross-direction integer shifts commute. -/
theorem shiftOp_cross_commute (μ ν : Fin 4) (a b : ℤ) :
    shiftOp ν b ∘ shiftOp μ a = shiftOp μ a ∘ shiftOp ν b := by
  funext p
  simp only [shiftOp, Function.comp_apply]
  exact shiftZ_comm p μ ν a b

/-! ## Abelian triangle holonomy on scalar fields

  A scalar field `f : ScalarField = LatticePoint → ℝ` is pulled back along
  the triangle by composing with the point-level shift.  Since the triangle
  closes (on points), the pullback is the identity on `f`.  This is the
  **trivial abelian holonomy** statement: the Wilson-loop analog on scalar
  fields evaluates to `1`. -/

/-- **Main abelian claim**: for any scalar field `f` and any closed triangle
    `(a, b, -(a+b))` along a single direction `μ`, the triangle-pullback
    of `f` equals `f`.  Abelian holonomy is trivial on scalars. -/
theorem shiftZ_triangle_holonomy_abelian_is_trivial
    (f : ScalarField) (μ : Fin 4) (a b : ℤ) (p : LatticePoint) :
    f (shiftZ (shiftZ (shiftZ p μ a) μ b) μ (-(a + b))) = f p := by
  rw [shiftZ_triangle_point]

/-- Cross-direction variant: triangle `(a, b, -(a+b))` with directions
    `μ, ν, μ` still closes because the `μ`-shifts add and the `ν`-shift is
    undone by no direct inverse — but composed with the same-direction
    version the holonomy is trivial only for the same-direction triangle.

    This file captures only the **single-direction** triangle; the genuine
    two-direction holonomy at the scalar level is equivalent to the
    commutativity of cross-direction shifts, which is the next theorem. -/
theorem shiftZ_twoDir_swap_trivial
    (f : ScalarField) (μ ν : Fin 4) (a b : ℤ) (p : LatticePoint) :
    f (shiftZ (shiftZ p μ a) ν b) = f (shiftZ (shiftZ p ν b) μ a) := by
  rw [shiftZ_comm]

/-! ## Scalar commutativity of shift pullbacks

  The **shift pullback** on a scalar field is `f ↦ f ∘ shiftOp μ k`.
  Two such pullbacks commute as operators on `ScalarField` because the
  underlying point-shifts commute. -/

/-- Shift pullback on a scalar field. -/
def shiftPullback (μ : Fin 4) (k : ℤ) (f : ScalarField) : ScalarField :=
  fun p => f (shiftZ p μ k)

@[simp] theorem shiftPullback_apply (μ : Fin 4) (k : ℤ) (f : ScalarField)
    (p : LatticePoint) :
    shiftPullback μ k f p = f (shiftZ p μ k) := rfl

/-- **Shift-pullback commutativity on scalars** (abelian lift):
    for any two directions and amounts, the shift pullbacks commute on
    scalar fields.  This is the scalar-field analog of the shift
    commutator `[shiftOp μ a, shiftOp ν b] = 0` on point operators. -/
theorem shiftPullback_commute (μ ν : Fin 4) (a b : ℤ) (f : ScalarField) :
    shiftPullback μ a (shiftPullback ν b f) =
    shiftPullback ν b (shiftPullback μ a f) := by
  funext p
  simp only [shiftPullback]
  rw [shiftZ_comm]

/-- **Abelian Berry-phase vanishing**: three-shift pullback in a closed
    triangle `(a, b, -(a+b))` along direction `μ` equals the identity on
    scalar fields.  This is the precise statement that the abelian
    holonomy around the triangle is *one* (trivial phase). -/
theorem shiftPullback_triangle_trivial (μ : Fin 4) (a b : ℤ) (f : ScalarField) :
    shiftPullback μ (-(a + b)) (shiftPullback μ b (shiftPullback μ a f)) = f := by
  funext p
  simp only [shiftPullback]
  rw [shiftZ_add, shiftZ_add]
  have h : -(a + b) + (b + a) = 0 := by ring
  rw [h, shiftZ_zero]

/-! ## Summary of delivered named theorems

  * `shiftOp_zero`, `shiftOp_add`, `shiftOp_add_comm` — group law for
    same-direction integer shift operators.
  * `shiftOp_same_commute`, `shiftOp_cross_commute` — commutativity
    (same direction and cross direction).
  * `shiftOp_neg_cancel`, `shiftOp_cancel_neg` — inverses.
  * `shiftOp_triangle_closure` / `shiftZ_triangle_point` — closed-triangle
    identity on operators / points.
  * `shiftZ_triangle_holonomy_abelian_is_trivial` — main abelian holonomy
    claim on scalar fields.
  * `shiftZ_twoDir_swap_trivial` — two-direction commutativity at the
    scalar level.
  * `shiftPullback_commute` — scalar pullback commutator vanishes.
  * `shiftPullback_triangle_trivial` — the precise vanishing Wilson-loop
    statement on scalar fields.

  **Non-abelian lift (open research):** the Berry-flux = 13.25 / 8.75
  signal on `shiftZ_one`/`shiftZ_zero`/`shiftZ_succ`/`shiftZ_pred` lives
  in the *commutator* structure of the full ErrorGaugeField connection,
  not on scalar pullbacks.  The discrete Wilson-loop holonomy
  `U(γ) = P exp ∮ A` for the lattice gauge connection `A` valued in
  `ErrorGaugeSU2` / `ErrorGaugeSU3` does not simplify to the identity;
  that is the content of `ErrorGaugeField.lean` and `NonAbelianGauge.lean`.
  Formalizing the closed-triangle holonomy there will require the
  discrete connection `A_μ(p)` and the Baker-Campbell-Hausdorff expansion
  of its parallel transport, which are currently under construction. -/

end OmegaTheory.Geometry
