/-
  OmegaTheory.Irrationality.HermitePade.F49_Existence

  The **existence** half of Fact F49 (Type II simultaneous Padé approximant)
  from the pi-irrationality diary, Attack 19 (Pre-Siegel Hermite–Padé).

  Informal statement
  ------------------
  For any `n ≥ 1`, a Type II `[n; n, n]` simultaneous Padé approximant
  to the triple `(1, f, g)` — i.e., polynomials `A, B, C` of degree ≤ `n`
  with `A·1 + B·f + C·g` vanishing to order ≥ `3n+2` at `z = 0` —
  **exists as a nonzero tuple**.

  Elementary reason: unknowns live in a `3(n+1)`-dimensional `K`-vector
  space, and the vanishing conditions are `3n+2` linear equations.
  Since `3n+2 < 3(n+1)`, rank–nullity gives a nonzero kernel element.

  This file proves a completely general field-theoretic fact that
  subsumes the Padé application: any rectangular matrix over a field
  with strictly more columns than rows has a nontrivial kernel.
  The Padé specialisation is a one-line corollary.

  **Scope.**  Existence only.  The uniqueness half of F49
  (kernel dimension = 1) is a deeper holonomic-rank statement and is
  explicitly out of scope for this file.

  Dependencies: Mathlib v4.29 (Matrix.mulVecLin, LinearMap.ker,
  ker_ne_bot_of_finrank_lt, Module.finrank_fintype_fun_eq_card).
  No sorries, no axioms beyond Mathlib.
-/

import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Irrationality.HermitePade

open Matrix LinearMap Module

/--
**F49, existence half (general field-matrix form).**

Let `K` be a field and `M : Matrix (Fin r) (Fin c) K` a rectangular
matrix with strictly fewer rows than columns, `r < c`.  Then there is
a nonzero vector `v : Fin c → K` in the kernel of `M`, i.e.,
`M.mulVec v = 0`.

Proof.  The associated linear map `M.mulVecLin : (Fin c → K) →ₗ[K]
(Fin r → K)` has source of dimension `c` and target of dimension `r`.
Since `r < c`, rank–nullity (`ker_ne_bot_of_finrank_lt`) gives
`ker M.mulVecLin ≠ ⊥`, and `Submodule.exists_mem_ne_zero_of_ne_bot`
extracts a nonzero witness.
-/
theorem F49_existence_matrix
    {K : Type*} [Field K] {r c : ℕ} (hrc : r < c)
    (M : Matrix (Fin r) (Fin c) K) :
    ∃ v : Fin c → K, v ≠ 0 ∧ M *ᵥ v = 0 := by
  -- Translate to the associated linear map and use rank–nullity.
  have h_src : finrank K (Fin c → K) = c := by
    simp [Module.finrank_fintype_fun_eq_card]
  have h_tgt : finrank K (Fin r → K) = r := by
    simp [Module.finrank_fintype_fun_eq_card]
  have h_dim : finrank K (Fin r → K) < finrank K (Fin c → K) := by
    rw [h_src, h_tgt]; exact hrc
  have h_ker : LinearMap.ker (M.mulVecLin) ≠ ⊥ :=
    ker_ne_bot_of_finrank_lt h_dim
  obtain ⟨v, hv_mem, hv_ne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot h_ker
  refine ⟨v, hv_ne, ?_⟩
  -- `hv_mem : v ∈ ker M.mulVecLin` unfolds to `M.mulVecLin v = 0`,
  -- which is definitionally `M *ᵥ v = 0`.
  have : M.mulVecLin v = 0 := hv_mem
  simpa [Matrix.mulVecLin_apply] using this

/--
**F49, existence half — Padé specialisation.**

The Padé matrix for a Type II `[n; n, n]` simultaneous approximant
to `(1, f, g)` has `3n + 2` rows (vanishing equations) and
`3(n + 1) = 3n + 3` columns (coefficients of `A, B, C`).  Since
`3n + 2 < 3n + 3`, the general theorem above gives a nonzero kernel
element — i.e., a nonzero coefficient tuple `(A, B, C)` satisfying
the required vanishing.

Note: this statement is purely linear-algebraic.  It does NOT assert
uniqueness (which would require the holonomic-rank argument).
-/
theorem F49_existence_pade
    {K : Type*} [Field K] (n : ℕ)
    (M : Matrix (Fin (3 * n + 2)) (Fin (3 * (n + 1))) K) :
    ∃ v : Fin (3 * (n + 1)) → K, v ≠ 0 ∧ M *ᵥ v = 0 := by
  refine F49_existence_matrix ?_ M
  -- `3*n + 2 < 3*(n+1) = 3*n + 3`
  omega

/-!
### Axiom audit

Both theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms (`propext`, `Classical.choice`, `Quot.sound`).
Verified with `#print axioms` — uncomment locally to inspect.
-/
-- #print axioms F49_existence_matrix
-- #print axioms F49_existence_pade

end OmegaTheory.Irrationality.HermitePade
