/-
  OmegaTheory.Emergence.SU3JacobiHelper

  Helper lemmas for the SU(3) Jacobi identity, using antisymmetry to
  collapse degenerate cases. Complementary (non-duplicative) to the
  direct 4096-case attempt in ErrorGaugeSU3.

  Approach: prove the basis-level Jacobi identity
    [[e_a, e_b], e_c] + [[e_b, e_c], e_a] + [[e_c, e_a], e_b] = 0
  in all *degenerate* cases (at least two of a, b, c coincide) using
  only the already-proven antisymmetry lemma `su3f_antisym`.

  These reductions rely on:
    · su3Bracket of a basis vector with itself = 0 (antisymm ⇒ [X,X]=0)
    · [e_a, e_a] = 0
    · cyclic swaps of identical brackets cancel by antisymmetry.

  We also provide the total antisymmetry of `su3f` in all three slots
  (needed for the partial-Jacobi classifier).

  Agent: Mizar², April 17, 2026. No sorry, no new axioms.
-/

import OmegaTheory.Emergence.ErrorGaugeSU3
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SU3JacobiHelper

open OmegaTheory.Emergence.ErrorGaugeSU3
open OmegaTheory.Foundations

/-! ## Total antisymmetry of `su3f`

The structure constants of su(3) are totally antisymmetric in all
three indices. The first-two-slot antisymmetry is the existing
`su3f_antisym`. We also need antisymmetry in positions (i,k) and
(j,k), which we obtain by exhaustive case analysis (512 cases). -/

-- 512-case exhaustive check over 8^3 index triples; matches the
-- existing `su3f_antisym` heartbeat bump in `ErrorGaugeSU3`.
set_option maxHeartbeats 1000000 in
theorem su3f_antisym_ik (i j k : Fin 8) :
    su3f k j i = -(su3f i j k) := by
  unfold su3f
  fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all

-- 512-case exhaustive check over 8^3 index triples; matches the
-- existing `su3f_antisym` heartbeat bump in `ErrorGaugeSU3`.
set_option maxHeartbeats 1000000 in
theorem su3f_antisym_jk (i j k : Fin 8) :
    su3f i k j = -(su3f i j k) := by
  unfold su3f
  fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all

/-! ## Diagonal vanishing — `su3f` is zero whenever two indices coincide. -/

theorem su3f_zero_of_ij_eq (i k : Fin 8) : su3f i i k = 0 := by
  have h := su3f_antisym i i k
  linarith

theorem su3f_zero_of_ik_eq (i j : Fin 8) : su3f i j i = 0 := by
  have h := su3f_antisym_ik i j i
  linarith

theorem su3f_zero_of_jk_eq (i j : Fin 8) : su3f i j j = 0 := by
  have h := su3f_antisym_jk i j j
  linarith

/-! ## Self-bracket vanishing (basis version) -/

/-- `[e_a, e_a] = 0` component-wise. -/
theorem su3Bracket_self_basis (a k : Fin 8) :
    su3Bracket (su3Basis a) (su3Basis a) k = 0 := by
  rw [su3Bracket_basis]
  exact su3f_zero_of_ij_eq a k

/-- `[e_a, e_a] = 0` as a function. -/
theorem su3Bracket_self_basis_fun (a : Fin 8) :
    su3Bracket (su3Basis a) (su3Basis a) = 0 := by
  funext k
  rw [su3Bracket_self_basis]
  rfl

/-! ## Basis-level Jacobi in degenerate cases

When at least two of (a,b,c) coincide, the basis Jacobi identity
  [[e_a, e_b], e_c] + [[e_b, e_c], e_a] + [[e_c, e_a], e_b] = 0
follows directly from antisymmetry without any numerical checks
involving `Real.sqrt 3`. These cases are what "Plan A" of the
helper strategy handles. -/

/-- Case `a = b`: `[[e_a, e_a], e_c] + [[e_a, e_c], e_a] + [[e_c, e_a], e_a] = 0`.
    The first term vanishes by self-bracket. The remaining two cancel
    by bracket-antisymmetry. -/
theorem su3Bracket_jacobi_basis_aa (a c : Fin 8) :
    (su3Bracket (su3Bracket (su3Basis a) (su3Basis a)) (su3Basis c) +
     su3Bracket (su3Bracket (su3Basis a) (su3Basis c)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis a) :
      SU3LieAlgebra) = 0 := by
  ext k
  simp only [Pi.add_apply, Pi.zero_apply]
  -- First term: [[e_a, e_a], e_c] k
  rw [show su3Bracket (su3Basis a) (su3Basis a) = (0 : SU3LieAlgebra)
      from su3Bracket_self_basis_fun a]
  -- Now second and third cancel: [X, e_a] + [-X, e_a] via antisymmetry
  -- Actually we need: [[e_a, e_c], e_a] + [[e_c, e_a], e_a] = 0
  -- By bracket antisymm: [e_c, e_a] = -[e_a, e_c], so [[e_c,e_a], e_a] = -[[e_a,e_c], e_a]
  have hCA : su3Bracket (su3Basis c) (su3Basis a) =
             (fun j => -(su3Bracket (su3Basis a) (su3Basis c) j)) := by
    funext j
    exact su3Bracket_neg (su3Basis a) (su3Basis c) j
  rw [hCA]
  -- [[e_a, e_c], e_a] + [-[e_a,e_c], e_a] = 0 using linearity of bracket
  -- su3Bracket (fun j => -(X j)) Y = -su3Bracket X Y
  have hNeg :
      su3Bracket (fun j => -(su3Bracket (su3Basis a) (su3Basis c) j))
                 (su3Basis a) k =
      -(su3Bracket (su3Bracket (su3Basis a) (su3Basis c)) (su3Basis a) k) := by
    unfold su3Bracket
    simp only [neg_mul, Finset.sum_neg_distrib, mul_neg]
  -- Simplify the first (zero) term
  have hZero : su3Bracket (0 : SU3LieAlgebra) (su3Basis c) k = 0 := by
    unfold su3Bracket
    apply Finset.sum_eq_zero
    intros i _
    apply Finset.sum_eq_zero
    intros j _
    show su3f i j k * (0 : SU3LieAlgebra) i * (su3Basis c) j = 0
    simp
  rw [hZero, hNeg]
  ring

/-- Case `a = c`: `[[e_a, e_b], e_a] + [[e_b, e_a], e_a] + [[e_a, e_a], e_b] = 0`.
    Symmetric to the a=b case. -/
theorem su3Bracket_jacobi_basis_ac (a b : Fin 8) :
    (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis b) (su3Basis a)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis a) (su3Basis a)) (su3Basis b) :
      SU3LieAlgebra) = 0 := by
  ext k
  simp only [Pi.add_apply, Pi.zero_apply]
  -- Third term has [e_a, e_a] = 0 → third bracket = 0
  rw [show su3Bracket (su3Basis a) (su3Basis a) = (0 : SU3LieAlgebra)
      from su3Bracket_self_basis_fun a]
  -- First + second: [[e_a,e_b],e_a] + [[e_b,e_a],e_a]
  -- By antisymm of inner: [e_b,e_a] = -[e_a,e_b]
  have hBA : su3Bracket (su3Basis b) (su3Basis a) =
             (fun j => -(su3Bracket (su3Basis a) (su3Basis b) j)) := by
    funext j
    exact su3Bracket_neg (su3Basis a) (su3Basis b) j
  rw [hBA]
  have hNeg :
      su3Bracket (fun j => -(su3Bracket (su3Basis a) (su3Basis b) j))
                 (su3Basis a) k =
      -(su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis a) k) := by
    unfold su3Bracket
    simp only [neg_mul, Finset.sum_neg_distrib, mul_neg]
  have hZero : su3Bracket (0 : SU3LieAlgebra) (su3Basis b) k = 0 := by
    unfold su3Bracket
    apply Finset.sum_eq_zero
    intros i _
    apply Finset.sum_eq_zero
    intros j _
    show su3f i j k * (0 : SU3LieAlgebra) i * (su3Basis b) j = 0
    simp
  rw [hZero, hNeg]
  ring

/-- Case `b = c`: `[[e_a, e_b], e_b] + [[e_b, e_b], e_a] + [[e_b, e_a], e_b] = 0`.
    The middle term vanishes by self-bracket. -/
theorem su3Bracket_jacobi_basis_bc (a b : Fin 8) :
    (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis b) +
     su3Bracket (su3Bracket (su3Basis b) (su3Basis b)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis b) (su3Basis a)) (su3Basis b) :
      SU3LieAlgebra) = 0 := by
  ext k
  simp only [Pi.add_apply, Pi.zero_apply]
  -- Middle: [e_b,e_b] = 0 → middle bracket = 0
  rw [show su3Bracket (su3Basis b) (su3Basis b) = (0 : SU3LieAlgebra)
      from su3Bracket_self_basis_fun b]
  have hBA : su3Bracket (su3Basis b) (su3Basis a) =
             (fun j => -(su3Bracket (su3Basis a) (su3Basis b) j)) := by
    funext j
    exact su3Bracket_neg (su3Basis a) (su3Basis b) j
  rw [hBA]
  have hNeg :
      su3Bracket (fun j => -(su3Bracket (su3Basis a) (su3Basis b) j))
                 (su3Basis b) k =
      -(su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis b) k) := by
    unfold su3Bracket
    simp only [neg_mul, Finset.sum_neg_distrib, mul_neg]
  have hZero : su3Bracket (0 : SU3LieAlgebra) (su3Basis a) k = 0 := by
    unfold su3Bracket
    apply Finset.sum_eq_zero
    intros i _
    apply Finset.sum_eq_zero
    intros j _
    show su3f i j k * (0 : SU3LieAlgebra) i * (su3Basis a) j = 0
    simp
  rw [hZero, hNeg]
  ring

/-- **Degenerate-basis-Jacobi classifier**: if at least two of
    (a, b, c) coincide, the basis-Jacobi sum at (a,b,c) is zero,
    by antisymmetry only. -/
theorem su3Bracket_jacobi_basis_degenerate (a b c : Fin 8)
    (hdeg : a = b ∨ a = c ∨ b = c) :
    (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
     su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
      SU3LieAlgebra) = 0 := by
  rcases hdeg with hab | hac | hbc
  · subst hab
    exact su3Bracket_jacobi_basis_aa a c
  · subst hac
    exact su3Bracket_jacobi_basis_ac a b
  · subst hbc
    exact su3Bracket_jacobi_basis_bc a b

/-! ## Conditional lift: Jacobi on all basis triples ⇒ Jacobi for general X,Y,Z

The abstract Jacobi identity is trilinear in (X, Y, Z). If we know it
holds on every basis triple `(e_a, e_b, e_c)`, then it extends to all
inputs by trilinearity. The next theorem packages this equivalence;
the forward direction (all triples ⇒ general) is the useful one for
eliminating `hJ` from `mkExactSU3LieAlgebra`.

Because full formalization of the trilinearity passage is large, we
ship only the statement that unifies degenerate + full distinct cases
as a single helper hypothesis. -/

/-- **Partition hypothesis**: If the basis Jacobi identity holds on
    all distinct triples (a, b, c), then it holds on *all* triples,
    combining with the degenerate classifier above. -/
theorem su3Bracket_jacobi_basis_all_of_distinct
    (hDist : ∀ a b c : Fin 8, a ≠ b → a ≠ c → b ≠ c →
      (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
       su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
       su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
        SU3LieAlgebra) = 0) :
    ∀ a b c : Fin 8,
      (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
       su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
       su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
        SU3LieAlgebra) = 0 := by
  intro a b c
  by_cases hab : a = b
  · exact su3Bracket_jacobi_basis_degenerate a b c (Or.inl hab)
  by_cases hac : a = c
  · exact su3Bracket_jacobi_basis_degenerate a b c (Or.inr (Or.inl hac))
  by_cases hbc : b = c
  · exact su3Bracket_jacobi_basis_degenerate a b c (Or.inr (Or.inr hbc))
  exact hDist a b c hab hac hbc

end OmegaTheory.Emergence.SU3JacobiHelper
