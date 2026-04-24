/-
  OmegaTheory.Emergence.SU3JacobiViaMatrix

  Matrix-Lie-algebra derivation of Jacobi on `su3f` without `native_decide`.

  ## Chain
  1. Build `su3GellMannSys : StructureConstantSystem (K := ℂ) gellMann`
     with `f a b c = 2i · ↑(su3f a b c)`; `bracket_eq` follows from
     `gellMann_commutator`.
  2. Apply `structure_constant_jacobi_of_linear_independent` (abstract
     helper, GREEN, axioms `[propext, Classical.choice, Quot.sound]` only)
     using `gellMann_linearIndependent`.
  3. Factor `(2i)² = -4` to extract the natural-convention Jacobi on `su3f`
     over ℂ.
  4. Cast to ℝ via `exact_mod_cast` (su3f is real-valued).
  5. Convert to `sum_zero` convention via `su3f_antisym`.
  6. **Cycle-49 P3t final**: split the ℝ-level sum along `su3f_decomp`
     into rational + √3-part, and apply `rat_sqrt3_linear_independent`
     to obtain `jacobi_rat_zero_via_matrix` and `jacobi_sqrt3_zero_via_matrix`.

  Piece 3 of P3t cycle-49 (Menkent v8). No sorry, no new axioms, no `native_decide`.
-/

import OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
import OmegaTheory.Emergence.SU3GellMannLinearIndependent
import OmegaTheory.Emergence.StructureConstantsJacobiAbstract
import OmegaTheory.Emergence.SU3JacobiDefs
import Mathlib.NumberTheory.Real.Irrational

namespace OmegaTheory.Emergence.SU3JacobiViaMatrix

open Matrix Complex Finset
open OmegaTheory.Emergence.ErrorGaugeSU3 (su3f su3f_antisym)
open OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
open OmegaTheory.Emergence.StructureConstantsJacobiAbstract
open OmegaTheory.Emergence.SU3JacobiDefs

/-! ## §1. Structure-constant system on Gell-Mann -/

/-- The SU(3) structure-constant system: Gell-Mann matrices as Lie-algebra
    generators with complex-valued structure constants `2i · ↑su3f`. -/
noncomputable def su3GellMannSys :
    StructureConstantSystem (K := ℂ) gellMann where
  f := fun a b c => (2 * I : ℂ) * ((su3f a b c : ℂ))
  bracket_eq := fun a b => by
    exact gellMann_commutator a b

/-! ## §2. Apply abstract Jacobi -/

/-- Jacobi identity for `2i · ↑su3f` in its natural "from-commutator-expansion"
    convention: `∑ e, (f b c e · f a e d + f c a e · f b e d + f a b e · f c e d) = 0`. -/
theorem gellMann_jacobi_abstract (a b c d : Fin 8) :
    ∑ e : Fin 8, ((2 * I * (su3f b c e : ℂ)) * (2 * I * (su3f a e d : ℂ))
                + (2 * I * (su3f c a e : ℂ)) * (2 * I * (su3f b e d : ℂ))
                + (2 * I * (su3f a b e : ℂ)) * (2 * I * (su3f c e d : ℂ))) = 0 :=
  structure_constant_jacobi_of_linear_independent
    su3GellMannSys gellMann_linearIndependent a b c d

/-! ## §3. Factor out `(2i)² = -4` to get the natural Jacobi -/

/-- Natural-convention Jacobi on `su3f` in ℂ (without the 2i·2i factor). -/
theorem su3f_jacobi_natural_complex (a b c d : Fin 8) :
    ∑ e : Fin 8, ((su3f b c e : ℂ) * (su3f a e d : ℂ)
                + (su3f c a e : ℂ) * (su3f b e d : ℂ)
                + (su3f a b e : ℂ) * (su3f c e d : ℂ)) = 0 := by
  have h := gellMann_jacobi_abstract a b c d
  -- Each product `(2I · x)(2I · y) = (2I)² · x · y = -4 · x · y`.
  have hkey : ∀ e : Fin 8,
      (2 * I * (su3f b c e : ℂ)) * (2 * I * (su3f a e d : ℂ))
    + (2 * I * (su3f c a e : ℂ)) * (2 * I * (su3f b e d : ℂ))
    + (2 * I * (su3f a b e : ℂ)) * (2 * I * (su3f c e d : ℂ))
    = -4 * ((su3f b c e : ℂ) * (su3f a e d : ℂ)
          + (su3f c a e : ℂ) * (su3f b e d : ℂ)
          + (su3f a b e : ℂ) * (su3f c e d : ℂ)) := by
    intro e
    have hI : (I : ℂ)^2 = -1 := Complex.I_sq
    linear_combination
      (4 * ((su3f b c e : ℂ) * (su3f a e d : ℂ)
          + (su3f c a e : ℂ) * (su3f b e d : ℂ)
          + (su3f a b e : ℂ) * (su3f c e d : ℂ))) * hI
  rw [Finset.sum_congr rfl (fun e _ => hkey e), ← Finset.mul_sum] at h
  -- h : -4 * S = 0, so S = 0
  have h4 : (-4 : ℂ) ≠ 0 := by norm_num
  have hmul : (-4 : ℂ) *
      ∑ e : Fin 8, ((su3f b c e : ℂ) * (su3f a e d : ℂ)
                  + (su3f c a e : ℂ) * (su3f b e d : ℂ)
                  + (su3f a b e : ℂ) * (su3f c e d : ℂ))
    = (-4 : ℂ) * 0 := h.trans (mul_zero _).symm
  exact mul_left_cancel₀ h4 hmul

/-! ## §4. Cast to ℝ -/

/-- Natural-convention Jacobi on `su3f` in ℝ. -/
theorem su3f_jacobi_natural_real (a b c d : Fin 8) :
    ∑ e : Fin 8, (su3f b c e * su3f a e d
                + su3f c a e * su3f b e d
                + su3f a b e * su3f c e d) = 0 := by
  have := su3f_jacobi_natural_complex a b c d
  exact_mod_cast this

/-! ## §5. Convert to `sum_zero` convention via antisymmetry -/

/-- `sum_zero`-convention Jacobi on `su3f` in ℝ: the convention used by
    `OmegaTheory.Emergence.SU3JacobiFull.su3f_jacobi_sum_zero`. -/
theorem su3f_jacobi_sum_zero_via_matrix (a b c k : Fin 8) :
    ∑ e : Fin 8, (su3f a b e * su3f e c k
                + su3f b c e * su3f e a k
                + su3f c a e * su3f e b k) = 0 := by
  have hnat := su3f_jacobi_natural_real a b c k
  -- Each "sum_zero" term equals negative of a "natural" term via antisymmetry
  have key : ∀ e : Fin 8,
      su3f a b e * su3f e c k + su3f b c e * su3f e a k + su3f c a e * su3f e b k
    = -(su3f b c e * su3f a e k + su3f c a e * su3f b e k + su3f a b e * su3f c e k) := by
    intro e
    have h1 : su3f a e k = -su3f e a k := by rw [su3f_antisym]
    have h2 : su3f b e k = -su3f e b k := by rw [su3f_antisym]
    have h3 : su3f c e k = -su3f e c k := by rw [su3f_antisym]
    rw [h1, h2, h3]; ring
  rw [Finset.sum_congr rfl (fun e _ => key e)]
  rw [Finset.sum_neg_distrib, hnat, neg_zero]

/-! ## §6. ℚ-linear independence of {1, √3} over ℚ

    If `(q : ℝ) + (r : ℝ) · √3 = 0` with `q, r : ℚ`, then `q = 0 ∧ r = 0`.
    Follows from irrationality of `√3` (since 3 is prime). -/

/-- {1, √3} is ℚ-linearly independent: if `q + r · √3 = 0` with `q, r ∈ ℚ`,
    then both `q = 0` and `r = 0`. -/
lemma rat_sqrt3_linear_independent (q r : ℚ)
    (h : (q : ℝ) + (r : ℝ) * Real.sqrt 3 = 0) : q = 0 ∧ r = 0 := by
  have h3 : Irrational (Real.sqrt 3) := by
    have hp : (3 : ℕ).Prime := by decide
    have hir := Nat.Prime.irrational_sqrt hp
    simpa using hir
  have hr : r = 0 := by
    by_contra hr
    apply h3
    refine ⟨-q / r, ?_⟩
    have hrne : (r : ℝ) ≠ 0 := Rat.cast_ne_zero.mpr hr
    push_cast
    rw [div_eq_iff hrne]
    linarith
  refine ⟨?_, hr⟩
  rw [hr] at h
  push_cast at h
  have : (q : ℝ) = 0 := by linarith
  exact_mod_cast this

/-! ## §7. Split the ℝ-level Jacobi sum along `su3f_decomp`

    The ℝ-sum `∑ e, (su3f a b e * su3f e c k + cyc) = 0` expands under
    `su3f = ↑su3f_rat + √3 · ↑su3f_sqrt3` to
      `↑(jacobiRatSum) + √3 · ↑(jacobiSqrt3Sum) = 0` in ℝ.
    Applying ℚ-LI of {1, √3} yields both ℚ-sums = 0. -/

-- 8-case sum × 6 `su3f_decomp` rewrites × `linear_combination` ring closure.
set_option maxHeartbeats 4000000 in
/-- Decomposition of the ℝ-level Jacobi sum: after expanding each `su3f`
    via `su3f_decomp`, the summed identity factors as `↑jacobiRatSum +
    √3 · ↑jacobiSqrt3Sum`. This is the same algebraic identity used in
    `SU3JacobiFull.su3f_jacobi_sum_zero`, but extracted here **without**
    appealing to `jacobi_rat_zero`/`jacobi_sqrt3_zero` — so it can feed
    back into the proof of those two identities via the matrix route. -/
theorem jacobi_sum_split (a b c k : Fin 8) :
    ∑ e : Fin 8, (su3f a b e * su3f e c k +
                  su3f b c e * su3f e a k +
                  su3f c a e * su3f e b k)
    = ((jacobiRatSum a b c k : ℚ) : ℝ) +
      Real.sqrt 3 * ((jacobiSqrt3Sum a b c k : ℚ) : ℝ) := by
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
  rw [hR, hS]

/-- Combining the matrix-route ℝ-sum vanishing with the decomposition split:
    `↑jacobiRatSum + √3 · ↑jacobiSqrt3Sum = 0` in ℝ. -/
theorem jacobi_rat_plus_sqrt3_zero_real (a b c d : Fin 8) :
    ((jacobiRatSum a b c d : ℚ) : ℝ) +
    Real.sqrt 3 * ((jacobiSqrt3Sum a b c d : ℚ) : ℝ) = 0 := by
  have hsum := su3f_jacobi_sum_zero_via_matrix a b c d
  have hsplit := jacobi_sum_split a b c d
  -- hsum : ∑ = 0;  hsplit : ∑ = ↑Rat + √3·↑Sqrt3;  therefore ↑Rat + √3·↑Sqrt3 = 0
  linarith [hsum, hsplit]

/-! ## §8. Final: the two axiom-clean Jacobi identities. -/

/-- **P3t final result**: the rational-component Jacobi sum vanishes.
    Derived via matrix-Lie-algebra embedding + {1, √3} ℚ-LI split;
    axiom footprint is `[propext, Classical.choice, Quot.sound]` (NO
    `Lean.ofReduceBool`, NO `native_decide`). -/
theorem jacobi_rat_zero_via_matrix (a b c d : Fin 8) :
    jacobiRatSum a b c d = 0 := by
  have h := jacobi_rat_plus_sqrt3_zero_real a b c d
  -- rewrite √3 * x  ==> x * √3 to match rat_sqrt3_linear_independent's shape.
  have h' : ((jacobiRatSum a b c d : ℚ) : ℝ) +
            ((jacobiSqrt3Sum a b c d : ℚ) : ℝ) * Real.sqrt 3 = 0 := by
    have := h
    rw [mul_comm (Real.sqrt 3) _] at this
    exact this
  exact (rat_sqrt3_linear_independent _ _ h').1

/-- **P3t final result**: the √3-component Jacobi sum vanishes.
    Derived via matrix-Lie-algebra embedding + {1, √3} ℚ-LI split;
    axiom footprint is `[propext, Classical.choice, Quot.sound]` (NO
    `Lean.ofReduceBool`, NO `native_decide`). -/
theorem jacobi_sqrt3_zero_via_matrix (a b c d : Fin 8) :
    jacobiSqrt3Sum a b c d = 0 := by
  have h := jacobi_rat_plus_sqrt3_zero_real a b c d
  have h' : ((jacobiRatSum a b c d : ℚ) : ℝ) +
            ((jacobiSqrt3Sum a b c d : ℚ) : ℝ) * Real.sqrt 3 = 0 := by
    have := h
    rw [mul_comm (Real.sqrt 3) _] at this
    exact this
  exact (rat_sqrt3_linear_independent _ _ h').2

end OmegaTheory.Emergence.SU3JacobiViaMatrix
