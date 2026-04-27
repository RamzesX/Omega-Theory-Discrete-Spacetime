/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedHomClosure

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 113.
  Closure properties of `IsWeightedHomogeneous`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's closure properties for `IsWeightedHomogeneous`:

  1. **`T5_isWeightedHomogeneous_add`** : sum of two w-hom polys of the
     same degree `n` is w-hom of degree `n`.
  2. **`T5_isWeightedHomogeneous_mul`** : product of two w-hom polys of
     degrees `m, n` is w-hom of degree `m + n`.
  3. **`T5_isWeightedHomogeneous_C_mul`** : scaling preserves w-hom
     degree.
  4. **`T5_isWeightedHomogeneous_pow`** : `n`-th power of w-hom poly of
     degree `m` is w-hom of degree `n • m`.

  Used in T-5 polynomial-index calculus where we track how weighted
  homogeneity propagates through algebraic operations.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.RingTheory.MvPolynomial.WeightedHomogeneous

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedHomClosure

open MvPolynomial

variable {σ R M : Type*} [CommSemiring R] [AddCommMonoid M]
variable {φ ψ : MvPolynomial σ R} {m n : M}

/-! ## Closure under sum / product / scaling / power -/

/-- **Wave T5 session 113 — w-hom closure under +**.

    If φ and ψ are w-hom of degree `n`, so is φ + ψ. -/
theorem T5_isWeightedHomogeneous_add {w : σ → M}
    (hφ : IsWeightedHomogeneous w φ n)
    (hψ : IsWeightedHomogeneous w ψ n) :
    IsWeightedHomogeneous w (φ + ψ) n :=
  hφ.add hψ

/-- **Wave T5 session 113 — w-hom closure under ·**.

    If φ is w-hom of degree `m` and ψ is w-hom of degree `n`,
    then φ * ψ is w-hom of degree `m + n`. -/
theorem T5_isWeightedHomogeneous_mul {w : σ → M}
    (hφ : IsWeightedHomogeneous w φ m)
    (hψ : IsWeightedHomogeneous w ψ n) :
    IsWeightedHomogeneous w (φ * ψ) (m + n) :=
  hφ.mul hψ

/-- **Wave T5 session 113 — w-hom closure under C-scaling**.

    Scaling by `C r` preserves w-hom degree. -/
theorem T5_isWeightedHomogeneous_C_mul {w : σ → M}
    (hφ : IsWeightedHomogeneous w φ m) (r : R) :
    IsWeightedHomogeneous w (C r * φ) m :=
  hφ.C_mul r

/-- **Wave T5 session 113 — w-hom closure under power**.

    If φ is w-hom of degree `m`, then φ^n is w-hom of degree `n • m`. -/
theorem T5_isWeightedHomogeneous_pow {w : σ → M}
    (hφ : IsWeightedHomogeneous w φ m) (k : ℕ) :
    IsWeightedHomogeneous w (φ ^ k) (k • m) :=
  hφ.pow k

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 113 — w-hom closure under all operations**.

    Four fundamental closure properties:
    1. (φ + ψ) is w-hom of degree n if both are.
    2. (φ * ψ) is w-hom of degree m + n.
    3. (C r * φ) is w-hom of degree m.
    4. (φ ^ k) is w-hom of degree k • m.

    Lean-core only. Sub-lemma 4/N in T-5 Phase 3.

    Used to bootstrap Roth's polynomial-index calculus where we need
    to track how the weighted homogeneous structure propagates through
    sums, products, scalings, and powers. -/
theorem session_113_w_hom_closure_headline
    {σ R M : Type*} [CommSemiring R] [AddCommMonoid M] :
    -- (1) Add
    (∀ {w : σ → M} {φ ψ : MvPolynomial σ R} {n : M},
        IsWeightedHomogeneous w φ n →
        IsWeightedHomogeneous w ψ n →
        IsWeightedHomogeneous w (φ + ψ) n)
    -- (2) Mul
    ∧ (∀ {w : σ → M} {φ ψ : MvPolynomial σ R} {m n : M},
        IsWeightedHomogeneous w φ m →
        IsWeightedHomogeneous w ψ n →
        IsWeightedHomogeneous w (φ * ψ) (m + n))
    -- (3) C-mul
    ∧ (∀ {w : σ → M} {φ : MvPolynomial σ R} {m : M} (r : R),
        IsWeightedHomogeneous w φ m →
        IsWeightedHomogeneous w (C r * φ) m)
    -- (4) Pow
    ∧ (∀ {w : σ → M} {φ : MvPolynomial σ R} {m : M} (k : ℕ),
        IsWeightedHomogeneous w φ m →
        IsWeightedHomogeneous w (φ ^ k) (k • m)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intros _ _ _ _ hφ hψ; exact T5_isWeightedHomogeneous_add hφ hψ
  · intros _ _ _ _ _ hφ hψ; exact T5_isWeightedHomogeneous_mul hφ hψ
  · intros _ _ _ r hφ; exact T5_isWeightedHomogeneous_C_mul hφ r
  · intros _ _ _ k hφ; exact T5_isWeightedHomogeneous_pow hφ k

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedHomClosure
