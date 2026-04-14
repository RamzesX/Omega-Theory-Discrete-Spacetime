/-
  OmegaTheory.Irrationality.HermitePade.Decoupling

  The Decoupling Theorem (Module 04C, Theorem 4C.3) formalized in Lean 4.

  Statement (informal).  Let θ ∈ K be transcendental over ℚ, and let
  { v_d : Fin T → ℚ }_{d = 0 … D} be a finite family of rational vectors.
  If the K-valued sum

      Σ_{d=0}^{D}  θ^d · (algebraMap ℚ K) ∘ v_d   =   0

  vanishes in K^T, then each v_d is zero as a map Fin T → ℚ.

  Why this is the "Decoupling Theorem" of the π-irrationality diary:
  ------------------------------------------------------------------
  Every Siegel-style attack on K₂-opacity of π constructs an integer
  vector c_d ∈ ℤ^N together with a rational auxiliary matrix S,
  and needs to conclude that the image vectors v_d := S *ᵥ c_d all
  vanish.  The hypothesis it has is a π-polynomial identity:

      Σ_d π^d · (S *ᵥ c_d)  =  0   in ℝ^T.

  Because π is transcendental, this theorem forces every v_d = 0,
  which is EXACTLY the "coefficient-at-each-power-of-π must vanish
  separately" step that the attack needs, but which (at the ℤ-lattice
  level, under a Siegel-style height bound) is precisely where the
  classical argument decouples and breaks: the π-free coefficient
  inherits no height bound from the π-bearing ones, so Siegel's lemma
  does not give the required non-vanishing witness.

  The role of this file:
  ---------------------
  This file formalizes the *structural* half of the Decoupling Theorem
  — that transcendence forces componentwise vanishing of rational
  combinations.  The "bad news" half (that this rules out Siegel-style
  existence arguments crossing ℚ → ℚ(π)) is a corollary stated below.

  It is **ring-agnostic**: the matrix S is not mentioned, because the
  theorem is about an arbitrary family of rational vectors v_d.  The
  Siegel application specializes to v_d = S *ᵥ c_d; no loss of
  generality.

  Dependencies: Mathlib v4.29 (Transcendental, Polynomial.aeval,
  algebraMap).  No sorries, no axioms beyond Mathlib.
-/

import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Algebra.BigOperators.Group.Finset
import Mathlib.Data.Rat.Cast.Defs
import Mathlib.Algebra.Algebra.Basic

namespace OmegaTheory.Irrationality.HermitePade

open Polynomial BigOperators Finset

/--
`Transcendental ℚ θ` is, by definition, the statement that θ satisfies
no nonzero polynomial relation over ℚ.  Equivalently, the evaluation
`aeval θ : ℚ[X] → K` has trivial kernel.

Mathlib stores this under `Transcendental` = `¬ IsAlgebraic`, and
`IsAlgebraic R x := ∃ p ≠ 0, aeval x p = 0`.  So:

  `Transcendental ℚ θ` ↔ `∀ p : ℚ[X], aeval θ p = 0 → p = 0`.

This is the precise form we need below.
-/
private lemma aeval_eq_zero_of_transcendental
    {K : Type*} [Field K] [Algebra ℚ K]
    {θ : K} (hθ : Transcendental ℚ θ)
    (p : ℚ[X]) (hp : aeval θ p = 0) : p = 0 := by
  by_contra hne
  exact hθ ⟨p, hne, hp⟩

/--
**Decoupling Theorem (scalar form).**  If θ is transcendental over ℚ
and `a : Fin (D+1) → ℚ` is a sequence of rationals with
    `∑ d, θ^(d:ℕ) * (a d : K) = 0`,
then every coefficient `a d` is zero.

Proof.  Assemble the polynomial `p := ∑ d, C(a d) · X^d`, show that
`aeval θ p = 0`, and apply `aeval_eq_zero_of_transcendental` to
conclude `p = 0`.  Extracting the `d`-th coefficient gives `a d = 0`.
-/
theorem decoupling_scalar
    {K : Type*} [Field K] [Algebra ℚ K]
    {θ : K} (hθ : Transcendental ℚ θ)
    {D : ℕ} (a : Fin (D + 1) → ℚ)
    (h : ∑ d : Fin (D + 1), θ ^ (d : ℕ) * algebraMap ℚ K (a d) = 0) :
    ∀ d, a d = 0 := by
  -- Assemble the associated polynomial of degree ≤ D.
  let p : ℚ[X] := ∑ d : Fin (D + 1), C (a d) * X ^ (d : ℕ)
  -- Show `aeval θ p = 0`.
  have hp_eval : aeval θ p = 0 := by
    simp only [p, map_sum, map_mul, map_pow, aeval_C, aeval_X,
               Algebra.smul_def]
    -- The resulting sum is `∑ d, algebraMap ℚ K (a d) * θ ^ d`,
    -- which equals `h` up to reordering.
    have : ∀ d : Fin (D + 1),
        (algebraMap ℚ K) (a d) * θ ^ (d : ℕ)
          = θ ^ (d : ℕ) * (algebraMap ℚ K) (a d) := fun d => by ring
    simp_rw [this]
    exact h
  -- Transcendence gives `p = 0`.
  have hp_zero : p = 0 := aeval_eq_zero_of_transcendental hθ p hp_eval
  -- Coefficients of the zero polynomial are all zero; for a fixed index
  -- `d : Fin (D+1)` the coefficient of `X^d` in `p` is `a d`.
  intro d
  have coeff_p : p.coeff (d : ℕ) = a d := by
    simp only [p, finset_sum_coeff, coeff_C_mul, coeff_X_pow]
    -- In the sum, only the term `k = d` survives.
    rw [Finset.sum_eq_single d]
    · simp
    · intro k _ hk
      have : (k : ℕ) ≠ (d : ℕ) := by
        intro heq; apply hk; exact Fin.ext heq
      simp [this]
    · intro hmem
      exact absurd (Finset.mem_univ d) hmem
  -- Use the fact that `p = 0` to conclude.
  have : p.coeff (d : ℕ) = 0 := by rw [hp_zero]; simp
  rw [coeff_p] at this
  exact this

/--
**Decoupling Theorem (vector form, Theorem 4C.3).**

  Let θ be transcendental over ℚ in K, and let
  `v : Fin (D+1) → Fin T → ℚ` be a family of rational vectors in ℚ^T.
  If
      `∑ d, θ^d · (algebraMap ℚ K) ∘ (v d) = 0`  in K^T,
  then `v d i = 0` for every d and every component i.

This is the precise form used by the Siegel-style applications.
The proof reduces component-by-component to `decoupling_scalar`.
-/
theorem decoupling
    {K : Type*} [Field K] [Algebra ℚ K]
    {θ : K} (hθ : Transcendental ℚ θ)
    {D T : ℕ} (v : Fin (D + 1) → Fin T → ℚ)
    (h : ∀ i : Fin T,
        ∑ d : Fin (D + 1), θ ^ (d : ℕ) * algebraMap ℚ K (v d i) = 0) :
    ∀ d i, v d i = 0 := by
  intro d i
  exact decoupling_scalar hθ (fun d' => v d' i) (h i) d

/--
**Corollary (Decoupling for rational matrices).**  Let S be a rational
matrix and let `c : Fin (D+1) → Fin N → ℤ` be a family of integer
vectors.  Write `Sc d := S *ᵥ (c d : Fin N → ℚ)`.  If

    `∑ d, θ^d · (Sc d, viewed in K^T) = 0`,

then every `Sc d` is zero as a vector in ℚ^T.

This is the form used to block Siegel-style existence arguments in
the π-diary (Modules 04C, 04F, 10).
-/
theorem decoupling_matrix
    {K : Type*} [Field K] [Algebra ℚ K]
    {θ : K} (hθ : Transcendental ℚ θ)
    {D N T : ℕ}
    (S : Fin T → Fin N → ℚ)
    (c : Fin (D + 1) → Fin N → ℤ)
    (h : ∀ i : Fin T,
        ∑ d : Fin (D + 1),
          θ ^ (d : ℕ) * algebraMap ℚ K
            (∑ j : Fin N, S i j * ((c d j : ℤ) : ℚ)) = 0) :
    ∀ d i, ∑ j : Fin N, S i j * ((c d j : ℤ) : ℚ) = 0 := by
  -- Define v_d i = (S *ᵥ c_d) i ∈ ℚ  and apply the vector form.
  let v : Fin (D + 1) → Fin T → ℚ :=
    fun d i => ∑ j : Fin N, S i j * ((c d j : ℤ) : ℚ)
  exact decoupling hθ v h

end OmegaTheory.Irrationality.HermitePade
