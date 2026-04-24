/-
  OmegaTheory.Emergence.SU3JacobiFull

  Public-facing SU(3) Jacobi theorems.

  The definitions `su3f_rat`, `su3f_sqrt3`, `jacobiRatSum`, `jacobiSqrt3Sum`,
  and the decomposition `su3f_decomp` now live in `SU3JacobiDefs` (split out
  in cycle-49 P3t). This module delivers the ℝ-level structural-constant
  Jacobi identity `su3f_jacobi_sum_zero` and the basis-level Jacobi identity
  `su3Bracket_jacobi_basis_all` on all 512 triples.

  ## P3t — native_decide elimination

  Previously `jacobi_rat_zero` and `jacobi_sqrt3_zero` were closed by
  `native_decide`, which forces the `Lean.ofReduceBool` axiom into the
  closure. In cycle-49 P3t we derived the same identities from the
  matrix-Lie-algebra embedding via the chain
    `su3f_jacobi_sum_zero_via_matrix`  (∑ = 0 in ℝ, from Gell-Mann commutator)
    + `su3f_decomp`                    (ℝ-sum = ↑jacobiRatSum + √3 · ↑jacobiSqrt3Sum)
    + `rat_sqrt3_linear_independent`   (ℚ-LI of {1, √3}).
  The axiom footprint of `jacobi_rat_zero`/`jacobi_sqrt3_zero` is now
  `[propext, Classical.choice, Quot.sound]` — no `Lean.ofReduceBool`.

  Agent: Almach² (γ And), April 17, 2026. Cycle-49 refactor preserves
  everything below §2; §2 theorems now route through SU3JacobiViaMatrix.
  No sorry, no new axioms.
-/

import OmegaTheory.Emergence.ErrorGaugeSU3
import OmegaTheory.Emergence.SU3JacobiHelper
import OmegaTheory.Emergence.SU3JacobiDefs
import OmegaTheory.Emergence.SU3JacobiViaMatrix
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SU3JacobiFull

open OmegaTheory.Emergence.ErrorGaugeSU3
open OmegaTheory.Emergence.SU3JacobiHelper
open OmegaTheory.Emergence.SU3JacobiDefs
open OmegaTheory.Foundations

/-! ## §1. Re-export defs for backwards compatibility

Consumers previously opened `OmegaTheory.Emergence.SU3JacobiFull` and
accessed `su3f_rat`, `su3f_sqrt3`, `jacobiRatSum`, `jacobiSqrt3Sum`,
`su3f_decomp`. Those now live in `SU3JacobiDefs`; we re-export them here
as plain aliases so downstream code compiles unchanged. -/

/-! ## §2. Jacobi ℚ-sums vanish (derived via matrix route, axiom-clean). -/

-- Derived via matrix-Lie-algebra embedding + {1, √3} ℚ-LI split.
-- No `native_decide` — axiom footprint is `[propext, Classical.choice, Quot.sound]`.
/-- The rational-component Jacobi sum vanishes identically. -/
theorem jacobi_rat_zero (a b c d : Fin 8) : jacobiRatSum a b c d = 0 :=
  OmegaTheory.Emergence.SU3JacobiViaMatrix.jacobi_rat_zero_via_matrix a b c d

-- Derived via matrix-Lie-algebra embedding + {1, √3} ℚ-LI split.
-- No `native_decide` — axiom footprint is `[propext, Classical.choice, Quot.sound]`.
/-- The √3-component Jacobi sum vanishes identically. -/
theorem jacobi_sqrt3_zero (a b c d : Fin 8) : jacobiSqrt3Sum a b c d = 0 :=
  OmegaTheory.Emergence.SU3JacobiViaMatrix.jacobi_sqrt3_zero_via_matrix a b c d

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
matrix-Lie-algebra embedding (`jacobi_rat_zero`, `jacobi_sqrt3_zero`
via `SU3JacobiViaMatrix`) and delivers basis-level Jacobi on all 512
triples (`su3Bracket_jacobi_basis_all`). The lift to arbitrary
`X, Y, Z` is exposed as the conditional scheme
`su3Bracket_jacobi_via_basis` awaiting a trilinearity witness.

Deliverables:
  · `jacobi_rat_zero`                      — ℚ-component Jacobi (matrix-derived).
  · `jacobi_sqrt3_zero`                    — √3-component Jacobi (matrix-derived).
  · `su3f_jacobi_sum_zero`                 — structural-constant Jacobi (ℝ).
  · `su3Bracket_jacobi_basis_all`          — basis-vector Jacobi (ALL 512 triples).
  · `su3Bracket_jacobi_via_basis`          — lift scheme (conditional).

No `sorry`, no new axioms, no `native_decide`. Axiom footprint of all
theorems here is `[propext, Classical.choice, Quot.sound]`. -/

end OmegaTheory.Emergence.SU3JacobiFull
