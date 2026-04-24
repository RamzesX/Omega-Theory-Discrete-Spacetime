/-
  OmegaTheory.Emergence.StructureConstantsJacobiAbstract

  **ABSTRACT JACOBI-FROM-COMMUTATOR** — the generic algebraic backbone
  for eliminating `native_decide` from `SU3JacobiFull.lean`.

  ## Mathematical content

  Given a family `T : ι → L` in a `LieRing L` with `LieAlgebra K L`
  (where `K` is a commutative scalar ring), and a structure-constant
  function `f : ι → ι → ι → K` satisfying

      `⁅T a, T b⁆ = ∑ c, f a b c • T c`,

  AND **linear independence** of `T` over `K`, the structure constants
  `f` satisfy the **Jacobi identity** at the level of coefficients.

  ## Natural form of the identity

  The natural form produced by expanding `lie_jacobi (T a) (T b) (T c)`
  via the structure-constant identity is: for every `a, b, c, d`,

      ∑ e, (f b c e * f a e d + f c a e * f b e d + f a b e * f c e d) = 0.

  (Indexing: inner bracket `⁅T b, T c⁆ = ∑ e, f b c e • T e`, then
  outer `⁅T a, T e⁆ = ∑ d, f a e d • T d`, so the coefficient on `T d`
  is `∑ e, f b c e * f a e d`.)

  Consumers that prefer the "standard" form
      `∑ e, (f a b e * f e c d + f b c e * f e a d + f c a e * f e b d) = 0`
  can derive it from the natural form plus antisymmetry of `f`.

  ## This file ships

    * `StructureConstantSystem` — the data bundle `(f, bracket_eq)`.
    * `ring_commutator_jacobi` — re-export of `lie_jacobi`.
    * `lie_T_sum` — bracket distributes over finite sums.
    * `lie_smul_T` — `⁅T a, c • T b⁆ = c • ⁅T a, T b⁆`.
    * `lie_T_lie_T_expand` — triple bracket as `T`-linear combination.
    * `structure_constant_jacobi_of_linear_independent` — MAIN THEOREM.

  ## HARD RULES

    * 0 sorry
    * 0 NEW axioms
    * Builds GREEN
-/

import Mathlib.Algebra.Lie.OfAssociative
import Mathlib.Algebra.Lie.Basic
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Emergence.StructureConstantsJacobiAbstract

open Finset

/-! ## §1. Setup — structure-constant system -/

variable {ι : Type*} [Fintype ι]
variable {K : Type*} [CommRing K]
variable {L : Type*} [LieRing L] [LieAlgebra K L]

/-- A **structure-constant system** on a finite-index family `T : ι → L`
    is data `f : ι → ι → ι → K` such that `⁅T a, T b⁆` equals the
    `T`-linear combination with scalar coefficients `f a b c : K`. -/
structure StructureConstantSystem (T : ι → L) where
  /-- The structure-constant function (scalar-valued in `K`). -/
  f : ι → ι → ι → K
  /-- Commutator identity: `⁅T a, T b⁆ = ∑ c, f a b c • T c`. -/
  bracket_eq : ∀ a b : ι, ⁅T a, T b⁆ = ∑ c, f a b c • T c

/-! ## §2. Free gifts from `LieRing` / `LieAlgebra` -/

/-- **Lie Jacobi** — for any three elements of a `LieRing`, the
    cyclic sum of triple-brackets vanishes.  Free from `LieRing L`. -/
theorem ring_commutator_jacobi (x y z : L) :
    ⁅x, ⁅y, z⁆⁆ + ⁅y, ⁅z, x⁆⁆ + ⁅z, ⁅x, y⁆⁆ = 0 :=
  lie_jacobi x y z

/-- `⁅T a, ∑ e, x e⁆ = ∑ e, ⁅T a, x e⁆` — bracket distributes over
    finite sums.  Free from `LieRing L`. -/
theorem lie_T_sum {T : ι → L} (a : ι) (x : ι → L) :
    ⁅T a, ∑ e, x e⁆ = ∑ e, ⁅T a, x e⁆ :=
  lie_sum Finset.univ x (T a)

/-- `⁅T a, c • T b⁆ = c • ⁅T a, T b⁆` — bracket commutes with scalar
    multiplication.  Needs `LieAlgebra K L` with `K` commutative. -/
theorem lie_smul_T (a : ι) (c : K) (y : L) (T : ι → L) :
    ⁅T a, c • y⁆ = c • ⁅T a, y⁆ :=
  LieAlgebra.lie_smul c (T a) y

/-! ## §3. Core expansion — `⁅T a, ⁅T b, T c⁆⁆` as a `T`-linear combo -/

variable {T : ι → L} (sys : StructureConstantSystem (K := K) T)

/-- **Expansion of the triple bracket**: substitute the commutator
    identity into `⁅T a, ⁅T b, T c⁆⁆`, distribute the outer bracket
    over the inner sum, pull scalars out, and substitute again.
    The coefficient of `T d` is `∑ e, sys.f b c e * sys.f a e d`. -/
theorem lie_T_lie_T_expand (a b c : ι) :
    ⁅T a, ⁅T b, T c⁆⁆ =
      ∑ d, (∑ e, sys.f b c e * sys.f a e d) • T d := by
  -- Step 1: substitute the inner bracket.
  rw [sys.bracket_eq b c]
  -- Step 2: distribute bracket over the sum.
  rw [lie_sum]
  -- Step 3: pull each `sys.f b c e` scalar out of `⁅T a, _ • T e⁆`.
  simp_rw [LieAlgebra.lie_smul]
  -- Step 4: substitute inner bracket `⁅T a, T e⁆`.
  simp_rw [sys.bracket_eq a]
  -- Step 5: push scalar through the sum over d,
  --         i.e., `c • (∑ d, g d • T d) = ∑ d, (c * g d) • T d`.
  simp_rw [Finset.smul_sum, smul_smul]
  -- Step 6: swap the outer `∑ e` with the inner `∑ d`.
  rw [Finset.sum_comm]
  -- Step 7: factor `T d` out using `sum_smul`.
  refine Finset.sum_congr rfl (fun d _ => ?_)
  rw [← Finset.sum_smul]

/-! ## §4. Main theorem — Jacobi at the coefficient level -/

/-- **Jacobi identity for structure constants** (natural form).

    Given a structure-constant system `sys` on a `K`-linearly
    independent family `T : ι → L`, the structure constants satisfy
      `∑ e, (f b c e * f a e d + f c a e * f b e d + f a b e * f c e d) = 0`
    for every `a b c d : ι`.

    Indexing: the "natural" form produced by `lie_jacobi` +
    structure-constant expansion; each cyclic piece contributes
    `f (inner-pair) e * f (outer-pair) e d` to the coefficient of `T d`. -/
theorem structure_constant_jacobi_of_linear_independent
    (hLI : LinearIndependent K T) (a b c d : ι) :
    ∑ e, (sys.f b c e * sys.f a e d
        + sys.f c a e * sys.f b e d
        + sys.f a b e * sys.f c e d) = 0 := by
  -- Start from Lie Jacobi on `(T a, T b, T c)`.
  have hJacobi : ⁅T a, ⁅T b, T c⁆⁆ + ⁅T b, ⁅T c, T a⁆⁆ + ⁅T c, ⁅T a, T b⁆⁆ = 0 :=
    ring_commutator_jacobi (T a) (T b) (T c)
  -- Expand each triple bracket.
  rw [lie_T_lie_T_expand sys a b c,
      lie_T_lie_T_expand sys b c a,
      lie_T_lie_T_expand sys c a b] at hJacobi
  -- Combine the three outer sums into one by `Finset.sum_add_distrib`.
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib] at hJacobi
  -- Fold the three `• T d'` terms into a single scalar times `T d'` via `add_smul`.
  have hJacobi' :
      ∑ d',
        ((∑ e, sys.f b c e * sys.f a e d')
       + (∑ e, sys.f c a e * sys.f b e d')
       + (∑ e, sys.f a b e * sys.f c e d')) • T d' = 0 := by
    rw [← hJacobi]
    refine Finset.sum_congr rfl (fun d' _ => ?_)
    rw [add_smul, add_smul]
  -- Fold the three inner sums into one `∑ e` via `Finset.sum_add_distrib`.
  have hJacobi'' :
      ∑ d',
        (∑ e, (sys.f b c e * sys.f a e d'
              + sys.f c a e * sys.f b e d'
              + sys.f a b e * sys.f c e d')) • T d' = 0 := by
    rw [← hJacobi']
    refine Finset.sum_congr rfl (fun d' _ => ?_)
    congr 1
    rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  -- Apply linear independence to extract coefficient at `d`.
  exact Fintype.linearIndependent_iff.mp hLI _ hJacobi'' d

end OmegaTheory.Emergence.StructureConstantsJacobiAbstract
