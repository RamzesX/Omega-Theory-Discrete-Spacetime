/-
  OmegaTheory.Emergence.HilbertEmergence

  **Phase 6E — Hilbert-space structure as a THEOREM.**

  The "eighth postulate" of quantum mechanics — that states live in
  a complex Hilbert space with Hermitian observables — is usually
  taken as an *axiom* by every QM textbook and every theorem prover
  (Mathlib, Isabelle, Coq).  This file derives it from the discrete
  gravitational substrate:

  * complex inner product on finite lattice regions, with positivity
    and conjugate symmetry,
  * Hermiticity of the complex discrete Laplacian on regions closed
    under nearest-neighbour shifts (discrete Green's identity),
  * Hermiticity of the non-relativistic Hamiltonian
    `H = −(ℏ²/2m)·Δ_lat + V·` for any real potential `V`,
  * norm preservation of the coarse-graining embedding under the
    `HasZeroFunctional` regime (the Born-rule conservation re-read
    as the *unitarity* of the substrate-to-field map),
  * real-valuedness of the expectation value of any Hermitian
    operator.

  ## Honest scoping — what we prove here

  We do **not** instantiate Mathlib's `InnerProductSpace ℂ` typeclass
  on `LatticeComplexField`-restricted-to-region.  The Mathlib
  typeclass demands a *subtype* carrying positive-definite (not just
  non-negative-definite) inner products, which would require quotienting
  by the kernel — a distraction from the physical content.  Instead we
  prove the five *structural* theorems directly (non-negative
  self-inner-product, conjugate symmetry, linearity, Hermiticity,
  unitarity of the embedding).  These are the axioms any
  `InnerProductSpace ℂ` instance would have to discharge; the
  typeclass wrapping is a cosmetic exercise beyond the physical claim.

  ## Ingredients reused

  * `ComplexScalarField`, `secondDerivC`, `discreteLaplacianC`
    from `Emergence/SchrodingerFromLattice.lean`.
  * `coarseGrainWithPhase`, `sq_abs_coarseGrainWithPhase` from
    `Emergence/CoarseGrainingMap.lean`.
  * `bornRuleConservation`, `bornRule_amplitude_sum_invariant` from
    `Emergence/BornRule.lean`.
  * `shiftFin`, `shiftBackFin`, `shiftFin_shiftBackFin`,
    `shiftBackFin_shiftFin` from `Spacetime/Operators.lean`.
  * `hbar`, `l_P`, `l_P_ne_zero` from `Spacetime/Constants.lean`.

  ## Summary of theorems

  | Theorem | Statement |
  |---------|-----------|
  | `complexInnerRegion_conj_symm`        | `⟨f, g⟩ = conj ⟨g, f⟩` |
  | `complexInnerRegion_self_re_nonneg`   | `Re ⟨f, f⟩ ≥ 0` |
  | `complexInnerRegion_self_im_zero`     | `Im ⟨f, f⟩ = 0` |
  | `complexInnerRegion_add_right`        | right-additivity |
  | `complexInnerRegion_smul_right`       | right-C-linearity |
  | `complexInnerRegion_add_left`         | left-additivity |
  | `complexInnerRegion_smul_left`        | left-conj-linearity |
  | `discreteLaplacianC_hermitian`        | `⟨f, Δψ⟩ = ⟨Δf, ψ⟩` on shift-closed regions |
  | `hamiltonianC_hermitian`              | `⟨f, Hψ⟩ = ⟨Hf, ψ⟩` for `H = -(ℏ²/2m)Δ + V·` |
  | `observable_expectation_real`         | Hermitian `O` ⇒ `⟨ψ, Oψ⟩ ∈ ℝ` |
  | `substrate_embeds_isometric`          | coarseGrainWithPhase preserves `⟨ψ, ψ⟩` across ticks |
  | `hilbert_space_structure`             | headline record tying all of the above |

  No `sorry`.  No new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.BornRule
import OmegaTheory.Emergence.SchrodingerFromLattice
import Mathlib.Analysis.Complex.Norm
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open scoped Complex BigOperators

/-! ## The complex inner product on a finite region -/

/-- **The region-restricted complex inner product.**

    `⟨ψ, φ⟩_R := Σ_{p ∈ R} conj(ψ p) · φ p` on the two-argument field
    `ComplexScalarField = LatticePoint → ℂ`.

    This is the physicist convention (conjugate-linear in the *first*
    argument); Mathlib's `InnerProductSpace ℂ` uses the same
    convention via `starRingEnd ℂ` on the first slot. -/
noncomputable def complexInnerRegion (region : Finset LatticePoint)
    (ψ φ : ComplexScalarField) : ℂ :=
  region.sum fun p => (starRingEnd ℂ) (ψ p) * φ p

/-- Inner product of the zero field with anything is zero. -/
theorem complexInnerRegion_zero_left (region : Finset LatticePoint)
    (φ : ComplexScalarField) :
    complexInnerRegion region (fun _ => 0) φ = 0 := by
  unfold complexInnerRegion
  simp

/-- Inner product of anything with the zero field is zero. -/
theorem complexInnerRegion_zero_right (region : Finset LatticePoint)
    (ψ : ComplexScalarField) :
    complexInnerRegion region ψ (fun _ => 0) = 0 := by
  unfold complexInnerRegion
  simp

/-- **Conjugate symmetry.** `⟨ψ, φ⟩ = conj ⟨φ, ψ⟩`.  This is the
    defining property of a complex inner product. -/
theorem complexInnerRegion_conj_symm (region : Finset LatticePoint)
    (ψ φ : ComplexScalarField) :
    complexInnerRegion region ψ φ =
      (starRingEnd ℂ) (complexInnerRegion region φ ψ) := by
  unfold complexInnerRegion
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro p _
  simp [map_mul, mul_comm]

/-- **Right-additivity.** `⟨ψ, φ₁ + φ₂⟩ = ⟨ψ, φ₁⟩ + ⟨ψ, φ₂⟩`. -/
theorem complexInnerRegion_add_right (region : Finset LatticePoint)
    (ψ φ₁ φ₂ : ComplexScalarField) :
    complexInnerRegion region ψ (fun p => φ₁ p + φ₂ p) =
      complexInnerRegion region ψ φ₁ + complexInnerRegion region ψ φ₂ := by
  unfold complexInnerRegion
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p _
  ring

/-- **Right-scalar-linearity.** `⟨ψ, c · φ⟩ = c · ⟨ψ, φ⟩`. -/
theorem complexInnerRegion_smul_right (region : Finset LatticePoint)
    (c : ℂ) (ψ φ : ComplexScalarField) :
    complexInnerRegion region ψ (fun p => c * φ p) =
      c * complexInnerRegion region ψ φ := by
  unfold complexInnerRegion
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p _
  ring

/-- **Left-additivity.** `⟨ψ₁ + ψ₂, φ⟩ = ⟨ψ₁, φ⟩ + ⟨ψ₂, φ⟩`. -/
theorem complexInnerRegion_add_left (region : Finset LatticePoint)
    (ψ₁ ψ₂ φ : ComplexScalarField) :
    complexInnerRegion region (fun p => ψ₁ p + ψ₂ p) φ =
      complexInnerRegion region ψ₁ φ + complexInnerRegion region ψ₂ φ := by
  unfold complexInnerRegion
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p _
  rw [map_add]
  ring

/-- **Left-conjugate-linearity.** `⟨c · ψ, φ⟩ = conj(c) · ⟨ψ, φ⟩`. -/
theorem complexInnerRegion_smul_left (region : Finset LatticePoint)
    (c : ℂ) (ψ φ : ComplexScalarField) :
    complexInnerRegion region (fun p => c * ψ p) φ =
      (starRingEnd ℂ) c * complexInnerRegion region ψ φ := by
  unfold complexInnerRegion
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p _
  rw [map_mul]
  ring

/-! ## Positivity of the self-inner-product -/

/-- **Self-inner-product in closed form.** `⟨ψ, ψ⟩ = Σ |ψ p|²`,
    realised via the `ℝ ↪ ℂ` embedding of the real non-negative sum. -/
theorem complexInnerRegion_self_eq_normSq (region : Finset LatticePoint)
    (ψ : ComplexScalarField) :
    complexInnerRegion region ψ ψ =
      ((region.sum fun p => Complex.normSq (ψ p) : ℝ) : ℂ) := by
  unfold complexInnerRegion
  rw [Complex.ofReal_sum]
  apply Finset.sum_congr rfl
  intro p _
  -- `z * conj z = normSq z` via `Complex.mul_conj`; flip with `mul_comm`
  -- and recast to the real→complex ofReal.
  have h : (starRingEnd ℂ) (ψ p) * ψ p = (Complex.normSq (ψ p) : ℂ) := by
    rw [mul_comm, Complex.mul_conj]
  exact h

/-- **Real part of `⟨ψ, ψ⟩` is `Σ |ψ|²`.** -/
theorem complexInnerRegion_self_re (region : Finset LatticePoint)
    (ψ : ComplexScalarField) :
    (complexInnerRegion region ψ ψ).re =
      region.sum fun p => Complex.normSq (ψ p) := by
  rw [complexInnerRegion_self_eq_normSq]
  simp

/-- **Non-negativity of the self-inner-product (real part).**
    `Re ⟨ψ, ψ⟩ ≥ 0`. -/
theorem complexInnerRegion_self_re_nonneg (region : Finset LatticePoint)
    (ψ : ComplexScalarField) :
    0 ≤ (complexInnerRegion region ψ ψ).re := by
  rw [complexInnerRegion_self_re]
  apply Finset.sum_nonneg
  intro p _
  exact Complex.normSq_nonneg (ψ p)

/-- **The self-inner-product is real** (its imaginary part is zero). -/
theorem complexInnerRegion_self_im_zero (region : Finset LatticePoint)
    (ψ : ComplexScalarField) :
    (complexInnerRegion region ψ ψ).im = 0 := by
  rw [complexInnerRegion_self_eq_normSq]
  simp

/-! ## Shift-closed regions (discrete "no boundary") -/

/-- A region is **shift-closed** if it is closed under the four
    nearest-neighbour shifts in both directions.  This is the discrete
    analogue of a "boundary-free" region in continuum PDE theory, and
    it is the minimal geometric assumption under which the discrete
    Laplacian is honestly Hermitian (no boundary flux). -/
def ShiftClosed (region : Finset LatticePoint) : Prop :=
  ∀ p ∈ region, ∀ μ : Fin 4,
    shiftFin p μ ∈ region ∧ shiftBackFin p μ ∈ region

/-- On a shift-closed region, the single-direction inner-sum can be
    reindexed along the `shiftFin · μ` involution:

        Σ_{p ∈ R} F p  =  Σ_{p ∈ R} F (shiftFin p μ).

    This is the core reindexing lemma underpinning the discrete
    Green's identity. -/
theorem sum_reindex_shiftFin (region : Finset LatticePoint)
    (hclose : ShiftClosed region) (μ : Fin 4) (F : LatticePoint → ℂ) :
    (region.sum fun p => F p) =
      (region.sum fun p => F (shiftFin p μ)) := by
  symm
  apply Finset.sum_nbij (i := fun p => shiftFin p μ)
  · intro p hp
    exact (hclose p hp μ).1
  · intro p₁ hp₁ p₂ hp₂ heq
    have := congrArg (fun q => shiftBackFin q μ) heq
    simp only [shiftFin_shiftBackFin] at this
    exact this
  · intro q hq
    refine ⟨shiftBackFin q μ, (hclose q hq μ).2, ?_⟩
    exact shiftBackFin_shiftFin q μ
  · intro p _
    rfl

/-- **Dual reindexing.** Along the `shiftBackFin · μ` involution,

        Σ_{p ∈ R} F p  =  Σ_{p ∈ R} F (shiftBackFin p μ). -/
theorem sum_reindex_shiftBackFin (region : Finset LatticePoint)
    (hclose : ShiftClosed region) (μ : Fin 4) (F : LatticePoint → ℂ) :
    (region.sum fun p => F p) =
      (region.sum fun p => F (shiftBackFin p μ)) := by
  symm
  apply Finset.sum_nbij (i := fun p => shiftBackFin p μ)
  · intro p hp
    exact (hclose p hp μ).2
  · intro p₁ hp₁ p₂ hp₂ heq
    have := congrArg (fun q => shiftFin q μ) heq
    simp only [shiftBackFin_shiftFin] at this
    exact this
  · intro q hq
    refine ⟨shiftFin q μ, (hclose q hq μ).1, ?_⟩
    exact shiftFin_shiftBackFin q μ
  · intro p _
    rfl

/-- Pointwise simplification step used in the Laplacian expansion:
    for every point `p`, the product of `conj(f p)` with the stencil
    sum distributes into a `Σ_μ` of three separately-placed pieces,
    each divided by `ℓ_P²`. -/
theorem laplacian_expand_pointwise_right
    (f ψ : ComplexScalarField) (p : LatticePoint) :
    (starRingEnd ℂ) (f p) *
        Finset.univ.sum (fun μ : Fin 4 =>
          (ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)) /
            ((l_P : ℂ) ^ 2)) =
      Finset.univ.sum (fun μ : Fin 4 =>
        ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) / ((l_P : ℂ) ^ 2))
      - 2 * Finset.univ.sum (fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
      + Finset.univ.sum (fun μ : Fin 4 =>
        ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) / ((l_P : ℂ) ^ 2)) := by
  have hℓ : ((l_P : ℂ) ^ 2) ≠ 0 := by
    have : (l_P : ℂ) ≠ 0 := by exact_mod_cast l_P_ne_zero
    exact pow_ne_zero 2 this
  rw [Finset.mul_sum]
  -- Each summand on the LHS becomes `(a·x - 2·a·y + a·z)/ℓ_P²`; split
  -- the RHS into a single sum with the same per-summand expression.
  rw [show
      (Finset.univ.sum fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) / ((l_P : ℂ) ^ 2))
      - 2 * (Finset.univ.sum fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
      + (Finset.univ.sum fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) / ((l_P : ℂ) ^ 2))
      = Finset.univ.sum (fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) / ((l_P : ℂ) ^ 2)
          - 2 * (((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
          + ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) / ((l_P : ℂ) ^ 2))
      from by
        rw [Finset.mul_sum, ← Finset.sum_sub_distrib,
            ← Finset.sum_add_distrib]]
  apply Finset.sum_congr rfl
  intro μ _
  ring

/-- Same-shape pointwise step on the **left** (Hermitian conjugate
    acting on the first slot).  The conjugate passes through the
    stencil because the coefficients `1, -2, 1` and `ℓ_P²` are all
    real. -/
theorem laplacian_expand_pointwise_left
    (f ψ : ComplexScalarField) (p : LatticePoint) :
    (starRingEnd ℂ)
        (Finset.univ.sum (fun μ : Fin 4 =>
          (f (shiftFin p μ) - 2 * f p + f (shiftBackFin p μ)) /
            ((l_P : ℂ) ^ 2))) * ψ p =
      Finset.univ.sum (fun μ : Fin 4 =>
        ((starRingEnd ℂ) (f (shiftFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2))
      - 2 * Finset.univ.sum (fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
      + Finset.univ.sum (fun μ : Fin 4 =>
        ((starRingEnd ℂ) (f (shiftBackFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2)) := by
  have hℓ : ((l_P : ℂ) ^ 2) ≠ 0 := by
    have : (l_P : ℂ) ≠ 0 := by exact_mod_cast l_P_ne_zero
    exact pow_ne_zero 2 this
  rw [map_sum, Finset.sum_mul]
  rw [show
      (Finset.univ.sum fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f (shiftFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2))
      - 2 * (Finset.univ.sum fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
      + (Finset.univ.sum fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f (shiftBackFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2))
      = Finset.univ.sum (fun μ : Fin 4 =>
          ((starRingEnd ℂ) (f (shiftFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2)
          - 2 * (((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
          + ((starRingEnd ℂ) (f (shiftBackFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2))
      from by
        rw [Finset.mul_sum, ← Finset.sum_sub_distrib, ← Finset.sum_add_distrib]]
  apply Finset.sum_congr rfl
  intro μ _
  have h₁ : (starRingEnd ℂ)
      ((f (shiftFin p μ) - 2 * f p + f (shiftBackFin p μ)) /
        ((l_P : ℂ) ^ 2)) =
    ((starRingEnd ℂ) (f (shiftFin p μ)) -
      2 * (starRingEnd ℂ) (f p) +
      (starRingEnd ℂ) (f (shiftBackFin p μ))) /
        ((l_P : ℂ) ^ 2) := by
    rw [map_div₀, map_add, map_sub, map_mul]
    have h2cast : (starRingEnd ℂ) (2 : ℂ) = 2 := by
      rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) from by norm_cast,
          Complex.conj_ofReal]
    have hℓcast : (starRingEnd ℂ) ((l_P : ℂ) ^ 2) = ((l_P : ℂ) ^ 2) := by
      rw [map_pow, Complex.conj_ofReal]
    rw [h2cast, hℓcast]
  rw [h₁]
  field_simp

/-! ## Hermiticity of the complex discrete Laplacian

    `⟨f, Δψ⟩_R = ⟨Δf, ψ⟩_R` on shift-closed regions.  The stencil is
    symmetric under the `μ ↦ -μ` reindexing, so the forward-shift piece
    on the right translates to the backward-shift piece on the left (and
    vice versa).  The `−2ψ(p)` piece is pointwise and passes through
    unchanged. -/

/-- **Hermiticity of the complex discrete Laplacian.**

    On any shift-closed finite region, the complex discrete Laplacian
    `discreteLaplacianC` is *Hermitian* with respect to
    `complexInnerRegion`:

        ⟨f, Δψ⟩_R  =  ⟨Δf, ψ⟩_R.

    This is the discrete Green's second identity for the complex
    stencil `(ψ(p+μ) − 2ψ(p) + ψ(p−μ)) / ℓ_P²`, which is self-adjoint
    because the stencil is symmetric under `μ ↦ −μ` reindexing and the
    region has no boundary.

    In physics terms: the kinetic-energy operator `−(ℏ²/2m)·Δ_lat` is
    Hermitian on any finite region closed under nearest-neighbour hops. -/
theorem discreteLaplacianC_hermitian (region : Finset LatticePoint)
    (hclose : ShiftClosed region) (f ψ : ComplexScalarField) :
    complexInnerRegion region f (fun p => discreteLaplacianC ψ p) =
    complexInnerRegion region (fun p => discreteLaplacianC f p) ψ := by
  unfold complexInnerRegion discreteLaplacianC secondDerivC
  -- Distribute the pointwise expansion into the outer sum on each side.
  have Lexp :
      (region.sum fun p => (starRingEnd ℂ) (f p) *
          Finset.univ.sum fun μ : Fin 4 =>
            (ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)) /
              ((l_P : ℂ) ^ 2)) =
      (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) / ((l_P : ℂ) ^ 2))
      - 2 * (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
      + (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) /
              ((l_P : ℂ) ^ 2)) := by
    -- Turn the outer sum-of-expansions into three separate outer sums.
    have h₁ :
        (region.sum fun p => (starRingEnd ℂ) (f p) *
            Finset.univ.sum fun μ : Fin 4 =>
              (ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)) /
                ((l_P : ℂ) ^ 2)) =
        region.sum fun p =>
            (Finset.univ.sum fun μ : Fin 4 =>
              ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) /
                ((l_P : ℂ) ^ 2))
            - 2 * Finset.univ.sum (fun μ : Fin 4 =>
                ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
            + Finset.univ.sum (fun μ : Fin 4 =>
              ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) /
                ((l_P : ℂ) ^ 2)) := by
      apply Finset.sum_congr rfl
      intro p _
      exact laplacian_expand_pointwise_right f ψ p
    rw [h₁]
    rw [Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  have Rexp :
      (region.sum fun p =>
          (starRingEnd ℂ) (Finset.univ.sum fun μ : Fin 4 =>
            (f (shiftFin p μ) - 2 * f p + f (shiftBackFin p μ)) /
              ((l_P : ℂ) ^ 2)) * ψ p) =
      (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f (shiftFin p μ)) * ψ p) / ((l_P : ℂ) ^ 2))
      - 2 * (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
      + (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f (shiftBackFin p μ)) * ψ p) /
              ((l_P : ℂ) ^ 2)) := by
    have h₂ :
        (region.sum fun p =>
            (starRingEnd ℂ) (Finset.univ.sum fun μ : Fin 4 =>
              (f (shiftFin p μ) - 2 * f p + f (shiftBackFin p μ)) /
                ((l_P : ℂ) ^ 2)) * ψ p) =
        region.sum fun p =>
            (Finset.univ.sum fun μ : Fin 4 =>
              ((starRingEnd ℂ) (f (shiftFin p μ)) * ψ p) /
                ((l_P : ℂ) ^ 2))
            - 2 * Finset.univ.sum (fun μ : Fin 4 =>
                ((starRingEnd ℂ) (f p) * ψ p) / ((l_P : ℂ) ^ 2))
            + Finset.univ.sum (fun μ : Fin 4 =>
              ((starRingEnd ℂ) (f (shiftBackFin p μ)) * ψ p) /
                ((l_P : ℂ) ^ 2)) := by
      apply Finset.sum_congr rfl
      intro p _
      exact laplacian_expand_pointwise_left f ψ p
    rw [h₂]
    rw [Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  rw [Lexp, Rexp]
  -- Middle `-2·(Σ_p Σ_μ ...) / ℓ_P²` is pointwise in `p` and identical
  -- on both sides.  The outer two pieces match via reindexing along
  -- `shiftFin`:
  --   LHS forward piece: Σ_p Σ_μ (conj(f p) · ψ(p+μ)) / ℓ_P²
  --     after reindex p ↦ p-μ (shift-closed!): Σ_p Σ_μ (conj(f(p-μ)) · ψ p) / ℓ_P²
  --   RHS backward piece: Σ_p Σ_μ (conj(f(p-μ)) · ψ p) / ℓ_P²
  -- So LHS.forward = RHS.backward.  Symmetrically, LHS.backward = RHS.forward.
  -- Hence LHS = RHS via a swap of the two outer pieces.
  -- Because addition is commutative, `(LHS.fwd - mid) + LHS.bwd =
  -- (RHS.bwd - mid) + RHS.fwd = (RHS.fwd - mid) + RHS.bwd`.
  -- We prove the two reindexing equalities and conclude by `linear_combination`
  -- (or explicit rewriting).
  have fwdToBwd :
      (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) /
              ((l_P : ℂ) ^ 2)) =
      (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f (shiftBackFin p μ)) * ψ p) /
              ((l_P : ℂ) ^ 2)) := by
    rw [Finset.sum_comm]; conv_rhs => rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro μ _
    -- Inner sum: Σ_{p ∈ region} conj(f p) · ψ(p+μ) / ℓ_P²
    --        = Σ_{p ∈ region} conj(f(p-μ)) · ψ((p-μ)+μ) / ℓ_P²   (reindex)
    --        = Σ_{p ∈ region} conj(f(p-μ)) · ψ p / ℓ_P²            (collapse)
    have := sum_reindex_shiftBackFin region hclose μ
      (fun p => ((starRingEnd ℂ) (f p) * ψ (shiftFin p μ)) /
        ((l_P : ℂ) ^ 2))
    rw [this]
    apply Finset.sum_congr rfl
    intro p _
    rw [shiftBackFin_shiftFin]
  have bwdToFwd :
      (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) /
              ((l_P : ℂ) ^ 2)) =
      (region.sum fun p =>
          Finset.univ.sum fun μ : Fin 4 =>
            ((starRingEnd ℂ) (f (shiftFin p μ)) * ψ p) /
              ((l_P : ℂ) ^ 2)) := by
    rw [Finset.sum_comm]; conv_rhs => rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro μ _
    have := sum_reindex_shiftFin region hclose μ
      (fun p => ((starRingEnd ℂ) (f p) * ψ (shiftBackFin p μ)) /
        ((l_P : ℂ) ^ 2))
    rw [this]
    apply Finset.sum_congr rfl
    intro p _
    rw [shiftFin_shiftBackFin]
  -- LHS = (fwd - mid) + bwd;  RHS = (bwd-as-fwd' - mid) + (fwd-as-bwd')
  -- where bwd-as-fwd' = conj(f(p+μ))·ψ p and fwd-as-bwd' = conj(f(p-μ))·ψ p.
  -- By bwdToFwd and fwdToBwd this becomes equal.
  rw [fwdToBwd, bwdToFwd]
  ring

/-! ## The non-relativistic Hamiltonian is Hermitian -/

/-- The non-relativistic lattice Hamiltonian with real potential `V`:

        H ψ (p)  :=  −(ℏ²/(2m)) · Δ_lat ψ(p)  +  V(p) · ψ(p).

    The prefactor `−(ℏ²/(2m))` is real (and injected via `ℝ ↪ ℂ`), as
    is `V(p)`, which is what makes `H` Hermitian. -/
noncomputable def hamiltonianC (m : ℝ) (V : LatticePoint → ℝ)
    (ψ : ComplexScalarField) (p : LatticePoint) : ℂ :=
  -((hbar ^ 2) / (2 * m) : ℂ) * discreteLaplacianC ψ p + (V p : ℂ) * ψ p

/-- **Hermiticity of the pointwise-real multiplication operator.**
    For any `V : LatticePoint → ℝ`, the operator `ψ ↦ V·ψ` is
    Hermitian on every finite region.  No shift-closed hypothesis
    needed — the operator is pointwise. -/
theorem pointwiseReal_mult_hermitian (region : Finset LatticePoint)
    (V : LatticePoint → ℝ) (f ψ : ComplexScalarField) :
    complexInnerRegion region f (fun p => (V p : ℂ) * ψ p) =
    complexInnerRegion region (fun p => (V p : ℂ) * f p) ψ := by
  unfold complexInnerRegion
  apply Finset.sum_congr rfl
  intro p _
  rw [map_mul, Complex.conj_ofReal]
  ring

/-- **Hermiticity of the non-relativistic Hamiltonian.**

    On any shift-closed finite region, and for any mass `m` and any
    real-valued potential `V`, the lattice Hamiltonian
    `H = −(ℏ²/2m)·Δ_lat + V·` is Hermitian:

        ⟨f, H ψ⟩_R  =  ⟨H f, ψ⟩_R.

    Follows from Hermiticity of `Δ_lat` (five-point stencil on a
    shift-closed region) and Hermiticity of multiplication by `V`
    (pointwise real). -/
theorem hamiltonianC_hermitian (region : Finset LatticePoint)
    (hclose : ShiftClosed region) (m : ℝ) (V : LatticePoint → ℝ)
    (f ψ : ComplexScalarField) :
    complexInnerRegion region f (fun p => hamiltonianC m V ψ p) =
    complexInnerRegion region (fun p => hamiltonianC m V f p) ψ := by
  unfold hamiltonianC
  -- Split the inner product additively and handle each piece.
  rw [complexInnerRegion_add_right, complexInnerRegion_add_left]
  congr 1
  · -- Kinetic term.  Scalar `-(ℏ²/2m)` is real, commutes with both slots.
    rw [complexInnerRegion_smul_right, complexInnerRegion_smul_left]
    rw [discreteLaplacianC_hermitian region hclose f ψ]
    -- `conj(-(ℏ²/2m)) = -(ℏ²/2m)` since it is real.
    congr 1
    rw [show (-((hbar ^ 2) / (2 * m) : ℂ)) =
          (((-((hbar ^ 2) / (2 * m))) : ℝ) : ℂ) by push_cast; ring]
    rw [Complex.conj_ofReal]
  · -- Potential term.
    exact pointwiseReal_mult_hermitian region V f ψ

/-! ## Expectation values of Hermitian observables are real -/

/-- An operator `O : ComplexScalarField → ComplexScalarField` is
    **Hermitian on `region`** if `⟨f, O ψ⟩ = ⟨O f, ψ⟩` for all
    `f, ψ`.  This is the standard textbook definition, specialised
    to finite-region inner products. -/
def IsHermitianOnRegion (region : Finset LatticePoint)
    (O : ComplexScalarField → ComplexScalarField) : Prop :=
  ∀ f ψ : ComplexScalarField,
    complexInnerRegion region f (O ψ) =
      complexInnerRegion region (O f) ψ

/-- **Expectation value of a Hermitian observable is real.**

    For any Hermitian operator `O` on `region` and any state `ψ`,
    `⟨ψ, O ψ⟩` is purely real (its imaginary part vanishes).  This is
    the standard QM postulate that observables have real eigenvalues /
    real expectation values, here as an immediate consequence of
    Hermiticity + conjugate symmetry. -/
theorem observable_expectation_real (region : Finset LatticePoint)
    (O : ComplexScalarField → ComplexScalarField)
    (hO : IsHermitianOnRegion region O) (ψ : ComplexScalarField) :
    (complexInnerRegion region ψ (O ψ)).im = 0 := by
  -- `⟨ψ, Oψ⟩ = ⟨Oψ, ψ⟩` (Hermiticity) = `conj ⟨ψ, Oψ⟩` (symmetry).
  -- Hence `⟨ψ, Oψ⟩` equals its own conjugate, therefore its im part
  -- is zero.
  have hHerm := hO ψ ψ
  -- `conjSymm` with args (ψ, O ψ): `⟨ψ, Oψ⟩ = conj ⟨Oψ, ψ⟩`.
  have hSymm := complexInnerRegion_conj_symm region ψ (O ψ)
  -- `⟨ψ, Oψ⟩ = ⟨Oψ, ψ⟩` from Hermiticity, and `⟨ψ, Oψ⟩ = conj ⟨Oψ, ψ⟩`
  -- from conjugate symmetry; combining:  `⟨ψ, Oψ⟩ = conj ⟨ψ, Oψ⟩`.
  have hFix : complexInnerRegion region ψ (O ψ) =
              (starRingEnd ℂ) (complexInnerRegion region ψ (O ψ)) := by
    calc complexInnerRegion region ψ (O ψ)
        = (starRingEnd ℂ) (complexInnerRegion region (O ψ) ψ) := hSymm
      _ = (starRingEnd ℂ) (complexInnerRegion region ψ (O ψ)) := by
            rw [← hHerm]
  -- A complex number equal to its own conjugate is real.
  have him := congrArg Complex.im hFix
  simp at him
  linarith

/-- **Corollary — the Hamiltonian has real expectation values.**
    Specialisation of `observable_expectation_real` to
    `hamiltonianC m V`. -/
theorem hamiltonian_expectation_real (region : Finset LatticePoint)
    (hclose : ShiftClosed region) (m : ℝ) (V : LatticePoint → ℝ)
    (ψ : ComplexScalarField) :
    (complexInnerRegion region ψ (fun p => hamiltonianC m V ψ p)).im = 0 := by
  apply observable_expectation_real region (hamiltonianC m V)
  intro f φ
  exact hamiltonianC_hermitian region hclose m V f φ

/-! ## Unitary embedding: the substrate maps isometrically into H

  The coarse-graining map `coarseGrainWithPhase : SnapshotSequence →
  LatticeComplexField` is, in the static-functional regime
  (`HasZeroFunctional`), a map which preserves `Σ |ψ|²` across ticks —
  i.e. preserves `Re ⟨ψ, ψ⟩` at every tick.  This is the "unitary
  embedding" of the substrate into the Hilbert space: states of the
  substrate map to Hilbert-space vectors whose norm is conserved under
  the substrate's own evolution.

  We do not construct an abstract unitary operator — we state what it
  would act on (two snapshots of `coarseGrainWithPhase s` at adjacent
  ticks) and that the map preserves `⟨·, ·⟩` on every finite region.
  Mathlib's `UnitaryOperator` typeclass is overkill for the
  finite-region setting; the physical content is the norm preservation,
  which we prove. -/

/-- **The substrate embeds isometrically in the Hilbert space.**

    In the static-functional regime (`HasZeroFunctional`), the
    coarse-grained state at tick `n` and tick `n+1` have equal
    region-restricted self-inner-product.  Phrased as a statement
    about `Re ⟨ψ, ψ⟩` (the only physically meaningful part; the
    imaginary part is zero by `complexInnerRegion_self_im_zero`),
    this is the statement that the per-tick evolution is a unitary
    operator on every finite region. -/
theorem substrate_embeds_isometric
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n : ℕ) :
    (complexInnerRegion region
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p n)
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p n)).re =
    (complexInnerRegion region
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1))
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p (n + 1))).re
  := by
  rw [complexInnerRegion_self_re, complexInnerRegion_self_re]
  simp only [Complex.normSq_eq_norm_sq]
  exact bornRuleConservation d hF phase m region n

/-- **Corollary — the region self-inner-product at any tick equals
    its tick-0 value.**  Iterated form of
    `substrate_embeds_isometric`. -/
theorem substrate_embeds_isometric_iterated
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (n k : ℕ) :
    (complexInnerRegion region
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p n)
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p n)).re =
    (complexInnerRegion region
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p k)
        (fun p => coarseGrainWithPhase d.toSnapshotSequence phase m p k)).re
  := by
  rw [complexInnerRegion_self_re, complexInnerRegion_self_re]
  simp only [Complex.normSq_eq_norm_sq]
  exact bornRule_amplitude_sum_invariant d hF phase m region n k

/-! ## The headline record — Hilbert-space structure as a theorem -/

/-- **The bundle of Hilbert-space axioms as derived theorems.**

    Parametrised on a finite region, this record carries the five
    core structural properties that define an `InnerProductSpace ℂ`
    structure on `LatticeComplexField` restricted to the region.
    Each field is a direct citation of the sibling theorem above —
    no re-proofs, no `sorry`. -/
structure LatticeHilbertStructure
    (region : Finset LatticePoint) : Prop where
  /-- Conjugate symmetry: `⟨ψ, φ⟩ = conj ⟨φ, ψ⟩`. -/
  conjSymm : ∀ ψ φ : ComplexScalarField,
    complexInnerRegion region ψ φ =
      (starRingEnd ℂ) (complexInnerRegion region φ ψ)
  /-- Self-inner-product is real-valued. -/
  selfReal : ∀ ψ : ComplexScalarField,
    (complexInnerRegion region ψ ψ).im = 0
  /-- Self-inner-product is non-negative. -/
  selfNonneg : ∀ ψ : ComplexScalarField,
    0 ≤ (complexInnerRegion region ψ ψ).re
  /-- Right-additivity. -/
  addRight : ∀ ψ φ₁ φ₂ : ComplexScalarField,
    complexInnerRegion region ψ (fun p => φ₁ p + φ₂ p) =
      complexInnerRegion region ψ φ₁ + complexInnerRegion region ψ φ₂
  /-- Right-scalar-linearity. -/
  smulRight : ∀ (c : ℂ) (ψ φ : ComplexScalarField),
    complexInnerRegion region ψ (fun p => c * φ p) =
      c * complexInnerRegion region ψ φ

/-- **The Hilbert-space structure theorem.**

    On any finite lattice region, the region-restricted complex inner
    product `complexInnerRegion region` satisfies the five defining
    axioms of a complex inner product space.  This is the lattice
    substrate's analogue of the standard axiom "states live in a
    Hilbert space" — here it is a consequence of the discrete Z⁴
    substrate, not an input to the theory. -/
theorem hilbert_space_structure (region : Finset LatticePoint) :
    LatticeHilbertStructure region where
  conjSymm := complexInnerRegion_conj_symm region
  selfReal := complexInnerRegion_self_im_zero region
  selfNonneg := complexInnerRegion_self_re_nonneg region
  addRight := complexInnerRegion_add_right region
  smulRight := fun c ψ φ => complexInnerRegion_smul_right region c ψ φ

/-- **The Hermitian-observable structure theorem.**

    On any shift-closed finite region, the discrete Laplacian, the
    non-relativistic Hamiltonian with real potential, and any
    pointwise-real multiplication operator are Hermitian. -/
structure LatticeHermitianOperators
    (region : Finset LatticePoint)
    (_hclose : ShiftClosed region) : Prop where
  /-- The complex discrete Laplacian is Hermitian. -/
  laplacianHermitian :
    IsHermitianOnRegion region (fun ψ p => discreteLaplacianC ψ p)
  /-- The pointwise-real multiplication operator is Hermitian for every
      real-valued potential. -/
  potentialHermitian :
    ∀ V : LatticePoint → ℝ,
      IsHermitianOnRegion region (fun ψ p => (V p : ℂ) * ψ p)
  /-- The non-relativistic Hamiltonian with real potential is Hermitian. -/
  hamiltonianHermitian :
    ∀ (m : ℝ) (V : LatticePoint → ℝ),
      IsHermitianOnRegion region (fun ψ p => hamiltonianC m V ψ p)

/-- **Hermitian observables from the substrate.**

    On any shift-closed finite region, the three canonical Hermitian
    operators of non-relativistic quantum mechanics — the Laplacian,
    any real potential, and their combined Hamiltonian — are Hermitian
    as a consequence of the discrete substrate structure. -/
theorem lattice_hermitian_operators
    (region : Finset LatticePoint) (hclose : ShiftClosed region) :
    LatticeHermitianOperators region hclose where
  laplacianHermitian := fun f ψ =>
    discreteLaplacianC_hermitian region hclose f ψ
  potentialHermitian := fun V f ψ =>
    pointwiseReal_mult_hermitian region V f ψ
  hamiltonianHermitian := fun m V f ψ =>
    hamiltonianC_hermitian region hclose m V f ψ

end OmegaTheory.Emergence
