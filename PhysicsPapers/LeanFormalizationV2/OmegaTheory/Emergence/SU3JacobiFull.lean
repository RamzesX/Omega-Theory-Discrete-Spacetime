/-
  OmegaTheory.Emergence.SU3JacobiFull

  Rational + √3 decomposition of the Gell-Mann structure constants,
  closing the Jacobi identity at both the structural-constant and
  basis-vector levels.

  The structure constants `su3f` contain both rational entries (±1, ±1/2)
  and √3-scaled entries (±√3/2 at the two triples involving λ₈).
  We decompose `su3f = ↑(su3f_rat) + √3 · ↑(su3f_sqrt3)` with both
  components ℚ-valued; since {1, √3} is ℚ-linearly independent, the
  vanishing of the Jacobi sum splits into TWO independent ℚ-identities
  (the rational side absorbs the `3·(√3)² = 3` cross-term). Each of
  the 4096 basis-quadruple cases is closed via `native_decide` on ℚ.

  This yields:

  · `su3f_jacobi_sum_zero` — the structural-constant Jacobi identity
    over `ℝ`, the hard numerical heart of the argument.

  · `su3Bracket_jacobi_basis_all` — basis-vector Jacobi on all 512
    triples `(a, b, c) : (Fin 8)³`.

  The lift from basis-vector Jacobi to general `(X, Y, Z)` is a
  standard trilinearity argument; we expose it as
  `su3Bracket_jacobi_via_basis` in conditional form, allowing any
  consumer that has a trilinearity witness to immediately discharge
  the `hJ` hypothesis of `mkExactSU3LieAlgebra`.

  Agent: Almach² (γ And), April 17, 2026. No sorry, no new axioms.
-/

import OmegaTheory.Emergence.ErrorGaugeSU3
import OmegaTheory.Emergence.SU3JacobiHelper
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SU3JacobiFull

open OmegaTheory.Emergence.ErrorGaugeSU3
open OmegaTheory.Emergence.SU3JacobiHelper
open OmegaTheory.Foundations

/-! ## §1. Rational + √3 decomposition of `su3f` -/

/-- Rational part of the Gell-Mann structure constants. -/
def su3f_rat : Fin 8 → Fin 8 → Fin 8 → ℚ :=
  fun i j k =>
    if i = 0 ∧ j = 1 ∧ k = 2 then 1
    else if i = 1 ∧ j = 2 ∧ k = 0 then 1
    else if i = 2 ∧ j = 0 ∧ k = 1 then 1
    else if i = 1 ∧ j = 0 ∧ k = 2 then -1
    else if i = 0 ∧ j = 2 ∧ k = 1 then -1
    else if i = 2 ∧ j = 1 ∧ k = 0 then -1
    else if i = 0 ∧ j = 3 ∧ k = 6 then 1/2
    else if i = 3 ∧ j = 6 ∧ k = 0 then 1/2
    else if i = 6 ∧ j = 0 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 0 ∧ k = 6 then -(1/2)
    else if i = 0 ∧ j = 6 ∧ k = 3 then -(1/2)
    else if i = 6 ∧ j = 3 ∧ k = 0 then -(1/2)
    else if i = 0 ∧ j = 4 ∧ k = 5 then -(1/2)
    else if i = 4 ∧ j = 5 ∧ k = 0 then -(1/2)
    else if i = 5 ∧ j = 0 ∧ k = 4 then -(1/2)
    else if i = 4 ∧ j = 0 ∧ k = 5 then 1/2
    else if i = 0 ∧ j = 5 ∧ k = 4 then 1/2
    else if i = 5 ∧ j = 4 ∧ k = 0 then 1/2
    else if i = 1 ∧ j = 3 ∧ k = 5 then 1/2
    else if i = 3 ∧ j = 5 ∧ k = 1 then 1/2
    else if i = 5 ∧ j = 1 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 1 ∧ k = 5 then -(1/2)
    else if i = 1 ∧ j = 5 ∧ k = 3 then -(1/2)
    else if i = 5 ∧ j = 3 ∧ k = 1 then -(1/2)
    else if i = 1 ∧ j = 4 ∧ k = 6 then 1/2
    else if i = 4 ∧ j = 6 ∧ k = 1 then 1/2
    else if i = 6 ∧ j = 1 ∧ k = 4 then 1/2
    else if i = 4 ∧ j = 1 ∧ k = 6 then -(1/2)
    else if i = 1 ∧ j = 6 ∧ k = 4 then -(1/2)
    else if i = 6 ∧ j = 4 ∧ k = 1 then -(1/2)
    else if i = 2 ∧ j = 3 ∧ k = 4 then 1/2
    else if i = 3 ∧ j = 4 ∧ k = 2 then 1/2
    else if i = 4 ∧ j = 2 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 2 ∧ k = 4 then -(1/2)
    else if i = 2 ∧ j = 4 ∧ k = 3 then -(1/2)
    else if i = 4 ∧ j = 3 ∧ k = 2 then -(1/2)
    else if i = 2 ∧ j = 5 ∧ k = 6 then -(1/2)
    else if i = 5 ∧ j = 6 ∧ k = 2 then -(1/2)
    else if i = 6 ∧ j = 2 ∧ k = 5 then -(1/2)
    else if i = 5 ∧ j = 2 ∧ k = 6 then 1/2
    else if i = 2 ∧ j = 6 ∧ k = 5 then 1/2
    else if i = 6 ∧ j = 5 ∧ k = 2 then 1/2
    else 0

/-- √3-coefficient part of the Gell-Mann structure constants.
    Nonzero exactly on permutations of {3,4,7} and {5,6,7} (the λ₈
    mixings), with value ±1/2. -/
def su3f_sqrt3 : Fin 8 → Fin 8 → Fin 8 → ℚ :=
  fun i j k =>
    if i = 3 ∧ j = 4 ∧ k = 7 then 1/2
    else if i = 4 ∧ j = 7 ∧ k = 3 then 1/2
    else if i = 7 ∧ j = 3 ∧ k = 4 then 1/2
    else if i = 4 ∧ j = 3 ∧ k = 7 then -(1/2)
    else if i = 3 ∧ j = 7 ∧ k = 4 then -(1/2)
    else if i = 7 ∧ j = 4 ∧ k = 3 then -(1/2)
    else if i = 5 ∧ j = 6 ∧ k = 7 then 1/2
    else if i = 6 ∧ j = 7 ∧ k = 5 then 1/2
    else if i = 7 ∧ j = 5 ∧ k = 6 then 1/2
    else if i = 6 ∧ j = 5 ∧ k = 7 then -(1/2)
    else if i = 5 ∧ j = 7 ∧ k = 6 then -(1/2)
    else if i = 7 ∧ j = 6 ∧ k = 5 then -(1/2)
    else 0

-- 512 cases (8^3) at depth-3 ifs; ring normalisation adds overhead.
set_option maxHeartbeats 1000000 in
/-- `su3f = ↑su3f_rat + √3 · ↑su3f_sqrt3` pointwise in `ℝ`. -/
theorem su3f_decomp (i j k : Fin 8) :
    su3f i j k = (↑(su3f_rat i j k) : ℝ) +
                 Real.sqrt 3 * (↑(su3f_sqrt3 i j k) : ℝ) := by
  unfold su3f su3f_rat su3f_sqrt3
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    simp_all <;> push_cast <;> ring

/-! ## §2. Jacobi sums over ℚ (decidable). -/

/-- Rational-component Jacobi sum; absorbs the `3·(√3)² = 3` cross-term. -/
def jacobiRatSum (a b c d : Fin 8) : ℚ :=
  ∑ e : Fin 8, (su3f_rat a b e * su3f_rat e c d +
                su3f_rat b c e * su3f_rat e a d +
                su3f_rat c a e * su3f_rat e b d +
                3 * (su3f_sqrt3 a b e * su3f_sqrt3 e c d +
                     su3f_sqrt3 b c e * su3f_sqrt3 e a d +
                     su3f_sqrt3 c a e * su3f_sqrt3 e b d))

/-- √3-component Jacobi sum. -/
def jacobiSqrt3Sum (a b c d : Fin 8) : ℚ :=
  ∑ e : Fin 8, (su3f_rat a b e * su3f_sqrt3 e c d +
                su3f_sqrt3 a b e * su3f_rat e c d +
                su3f_rat b c e * su3f_sqrt3 e a d +
                su3f_sqrt3 b c e * su3f_rat e a d +
                su3f_rat c a e * su3f_sqrt3 e b d +
                su3f_sqrt3 c a e * su3f_rat e b d)

-- 4096 rational cases; native-compiled decide.
/-- The rational-component Jacobi sum vanishes identically. -/
theorem jacobi_rat_zero (a b c d : Fin 8) : jacobiRatSum a b c d = 0 := by
  revert a b c d
  native_decide

-- 4096 rational cases; native-compiled decide.
/-- The √3-component Jacobi sum vanishes identically. -/
theorem jacobi_sqrt3_zero (a b c d : Fin 8) : jacobiSqrt3Sum a b c d = 0 := by
  revert a b c d
  native_decide

/-! ## §3. Kernel-level Jacobi sum vanishes in `ℝ`. -/

-- Summand-level `linear_combination` + `(√3)²=3` + Rat→ℝ casts.
set_option maxHeartbeats 4000000 in
/-- **Core kernel lemma**: for any `a, b, c, k : Fin 8`,
    `∑ e, [f(a,b,e)·f(e,c,k) + f(b,c,e)·f(e,a,k) + f(c,a,e)·f(e,b,k)] = 0`
    in `ℝ`. This is the structural-constant Jacobi identity. -/
theorem su3f_jacobi_sum_zero (a b c k : Fin 8) :
    ∑ e : Fin 8, (su3f a b e * su3f e c k +
                  su3f b c e * su3f e a k +
                  su3f c a e * su3f e b k) = 0 := by
  have hsq : Real.sqrt 3 * Real.sqrt 3 = 3 :=
    Real.mul_self_sqrt (by norm_num : (3 : ℝ) ≥ 0)
  have key : ∀ e : Fin 8,
      su3f a b e * su3f e c k +
      su3f b c e * su3f e a k +
      su3f c a e * su3f e b k =
      (((su3f_rat a b e * su3f_rat e c k +
         su3f_rat b c e * su3f_rat e a k +
         su3f_rat c a e * su3f_rat e b k +
         3 * (su3f_sqrt3 a b e * su3f_sqrt3 e c k +
              su3f_sqrt3 b c e * su3f_sqrt3 e a k +
              su3f_sqrt3 c a e * su3f_sqrt3 e b k)) : ℚ) : ℝ) +
      Real.sqrt 3 *
        (((su3f_rat a b e * su3f_sqrt3 e c k +
           su3f_sqrt3 a b e * su3f_rat e c k +
           su3f_rat b c e * su3f_sqrt3 e a k +
           su3f_sqrt3 b c e * su3f_rat e a k +
           su3f_rat c a e * su3f_sqrt3 e b k +
           su3f_sqrt3 c a e * su3f_rat e b k) : ℚ) : ℝ) := by
    intro e
    rw [su3f_decomp a b e, su3f_decomp e c k,
        su3f_decomp b c e, su3f_decomp e a k,
        su3f_decomp c a e, su3f_decomp e b k]
    push_cast
    linear_combination
      ((su3f_sqrt3 a b e : ℝ) * (su3f_sqrt3 e c k : ℝ) +
       (su3f_sqrt3 b c e : ℝ) * (su3f_sqrt3 e a k : ℝ) +
       (su3f_sqrt3 c a e : ℝ) * (su3f_sqrt3 e b k : ℝ)) * hsq
  rw [Finset.sum_congr rfl (fun e _ => key e)]
  rw [Finset.sum_add_distrib, ← Finset.mul_sum]
  have hR :
      ∑ e : Fin 8,
        (((su3f_rat a b e * su3f_rat e c k +
           su3f_rat b c e * su3f_rat e a k +
           su3f_rat c a e * su3f_rat e b k +
           3 * (su3f_sqrt3 a b e * su3f_sqrt3 e c k +
                su3f_sqrt3 b c e * su3f_sqrt3 e a k +
                su3f_sqrt3 c a e * su3f_sqrt3 e b k)) : ℚ) : ℝ)
      = ((jacobiRatSum a b c k : ℚ) : ℝ) := by
    unfold jacobiRatSum; push_cast; rfl
  have hS :
      ∑ e : Fin 8,
        (((su3f_rat a b e * su3f_sqrt3 e c k +
           su3f_sqrt3 a b e * su3f_rat e c k +
           su3f_rat b c e * su3f_sqrt3 e a k +
           su3f_sqrt3 b c e * su3f_rat e a k +
           su3f_rat c a e * su3f_sqrt3 e b k +
           su3f_sqrt3 c a e * su3f_rat e b k) : ℚ) : ℝ)
      = ((jacobiSqrt3Sum a b c k : ℚ) : ℝ) := by
    unfold jacobiSqrt3Sum; push_cast; rfl
  rw [hR, hS, jacobi_rat_zero, jacobi_sqrt3_zero]
  push_cast; ring

/-! ## §4. Basis-level Jacobi identity. -/

/-- `[[e_a, e_b], e_c] k = ∑ e, f(a,b,e) · f(e,c,k)`. -/
theorem su3Bracket_bracket_basis_at (a b c k : Fin 8) :
    su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) k =
    ∑ e : Fin 8, su3f a b e * su3f e c k := by
  have hInner : su3Bracket (su3Basis a) (su3Basis b) = (fun e => su3f a b e) := by
    funext e; exact su3Bracket_basis a b e
  show (∑ e : Fin 8, ∑ j : Fin 8,
          su3f e j k * su3Bracket (su3Basis a) (su3Basis b) e *
          su3Basis c j) = _
  conv_lhs =>
    arg 2; ext e
    rw [hInner]
  apply Finset.sum_congr rfl; intros e _
  rw [Finset.sum_eq_single c]
  · show su3f e c k * su3f a b e * su3Basis c c = su3f a b e * su3f e c k
    unfold su3Basis; simp; ring
  · intros j _ hjc
    show su3f e j k * su3f a b e * su3Basis c j = 0
    unfold su3Basis; rw [if_neg hjc]; ring
  · intro h; exact absurd (Finset.mem_univ c) h

/-- **Basis Jacobi identity** on ALL triples `(a, b, c) : Fin 8³`. -/
theorem su3Bracket_jacobi_basis_all (a b c : Fin 8) :
    (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
     su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
      SU3LieAlgebra) = 0 := by
  ext k
  simp only [Pi.add_apply, Pi.zero_apply]
  rw [su3Bracket_bracket_basis_at a b c k,
      su3Bracket_bracket_basis_at b c a k,
      su3Bracket_bracket_basis_at c a b k]
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  exact su3f_jacobi_sum_zero a b c k

/-! ## §5. Consumer-facing trilinear-lift scheme.

The standard trilinearity lift promotes basis-level Jacobi
(`su3Bracket_jacobi_basis_all`, proven above) to the full bracket-level
Jacobi `[[X, Y], Z] + [[Y, Z], X] + [[Z, X], Y] = 0`. Any consumer with
a trilinearity-of-`su3Bracket` witness can discharge the full Jacobi
hypothesis `hJ` of `mkExactSU3LieAlgebra` by supplying that witness as
`hLift`; we package the implication here. -/

/-- **Conditional reduction to basis Jacobi**: given a trilinearity
    witness, the full bracket-level Jacobi on arbitrary `X, Y, Z`
    follows from basis-Jacobi (which we already prove).  Consumers
    with a trilinearity proof for `su3Bracket` obtain the full
    Jacobi identity by plugging `su3Bracket_jacobi_basis_all` into
    their trilinearity witness. -/
theorem su3Bracket_jacobi_via_basis
    (hLift : (∀ a b c : Fin 8,
      (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
       su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
       su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
        SU3LieAlgebra) = 0) →
      ∀ (X Y Z : SU3LieAlgebra),
        (su3Bracket (su3Bracket X Y) Z +
         su3Bracket (su3Bracket Y Z) X +
         su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0) :
    ∀ (X Y Z : SU3LieAlgebra),
      (su3Bracket (su3Bracket X Y) Z +
       su3Bracket (su3Bracket Y Z) X +
       su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0 :=
  hLift su3Bracket_jacobi_basis_all

/-! ## §6. Summary

This file closes the hard numerical heart of SU(3) Jacobi via
ℚ-decomposition (`su3f_jacobi_sum_zero`) and delivers basis-level
Jacobi on all 512 triples (`su3Bracket_jacobi_basis_all`). The lift
to arbitrary `X, Y, Z` is exposed as the conditional scheme
`su3Bracket_jacobi_via_basis` awaiting a trilinearity witness.

Deliverables:
  · `su3f_jacobi_sum_zero`                 — structural-constant Jacobi (ℝ).
  · `su3Bracket_jacobi_basis_all`          — basis-vector Jacobi (ALL 512 triples).
  · `su3Bracket_jacobi_via_basis`          — lift scheme (conditional).

No `sorry`, no new axioms. -/

end OmegaTheory.Emergence.SU3JacobiFull
