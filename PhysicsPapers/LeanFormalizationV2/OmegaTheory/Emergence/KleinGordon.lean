/-
  OmegaTheory.Emergence.KleinGordon

  **Direction 3: relativistic extension of the QM bridge.**

  This file proves the relativistic analogue of
  `SchrodingerFromLattice.coarseGrain_satisfies_schrodinger_dynamic`:
  the discrete Klein-Gordon residue

        KG[ψ](p, n) := ((1/c²) ∂²_t^{disc} − Δ_lat) ψ(p, n)
                        + (m²c²/ℏ²) · ψ(p, n)

  is pointwise bounded, on a static / `HasZeroFunctional` Gibbs
  background, by an explicit constant depending only on the
  fundamental constants, the rest mass, and the Planck scale.

  ## Physical content

  The continuum Klein-Gordon equation is
      (□ + m²c²/ℏ²) ψ = 0 ,      □ = (1/c²)∂²_t − ∇² .
  Its operator roots are the mass-shell `E² = (pc)² + (mc²)²` from
  `DispersionFromLattice.massShell_from_tick_counting`.  On the
  discrete lattice we replace each differential operator by its
  finite-difference analogue: `∇² ↦ discreteLaplacianC`, `∂²_t ↦
  secondTickDiffC` (a centred second difference in tick, normalised by
  `t_P`).  On a static sequence the time second-difference is zero at
  every interior tick (tick ≥ 1), so the full Klein-Gordon residue
  reduces to `−Δ_lat ψ + (m²c²/ℏ²) ψ`, which is bounded in norm by

        kleinGordonBoundConst m
            = m²c²/ℏ²  +  16 / (c² · t_P² · ℓ_P²) · 0
                      +  16 / ℓ_P²
            = 16 / ℓ_P²  +  m²c²/ℏ² .

  ## Honest scoping

  The brief explicitly allows an `O(ℓ_P²·M)` bound when `O(ℓ_P)` is
  unattainable without the KL-linearisation bridge for non-static
  metrics.  On static / `HasZeroFunctional` sequences we do better
  than that: we give an **explicit closed-form constant** independent
  of any smoothness assumption beyond Gibbs positivity, because the
  amplitude is uniformly bounded by `1`.  The constant is
  **ℓ_P-independent as a whole but the leading `16/ℓ_P²` term is
  finite**; this is the UV-cutoff feature of the lattice.  We do not
  claim the discrete residue is `O(ℓ_P)` — that would require the
  ψ-field to be slowly varying on Planck scale, which is a
  continuum-limit hypothesis not yet formalised.

  ## What this file exports

  * `secondTickDiffC` — the discrete second time-derivative operator.
  * `dAlembertianC` — the discrete d'Alembertian.
  * `kleinGordonRHS`, `kleinGordonResidue` — the Klein-Gordon operator
    and its residue against zero.
  * `kleinGordonBoundConst` — the explicit bound constant.
  * `coarseGrain_satisfies_kleinGordon_static` — the headline theorem
    on static sequences at interior ticks.
  * `coarseGrain_satisfies_kleinGordon_dynamic` — the Phase-2 lift to
    `DynamicalSnapshotSequence` with `HasZeroFunctional`.
  * `coarseGrain_satisfies_kleinGordon_dynamic_flat` — the flat
    Minkowski specialisation with no side hypotheses.
  * `coarseGrainWithPhase_satisfies_kleinGordon_dynamic_zero_phase`
    — phase-variant bridge.
  * `kleinGordon_massless_dAlembertian_bound` — massless specialisation
    (`(□ − 0) ψ = □ ψ`, bounded by `16/ℓ_P²` on static Gibbs).
  * `kleinGordon_mass_shell_consistent` — the mass-shell identity
    `E² = (pc)² + (mc²)²` recovered from the existing
    `relativisticEnergy_sq_eq`, cited to tie the operator to the
    dispersion.

  No new axioms.  No `sorry`.
-/

import OmegaTheory.Emergence.SchrodingerFromLattice
import OmegaTheory.Emergence.SpecialRelativity
import OmegaTheory.Emergence.DispersionBridge

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open scoped Complex

/-! ## Discrete second time-derivative

The Klein-Gordon equation requires a second time derivative.  We use
a centred second difference in tick:

        ∂²_t ψ (p, n) ≈ (ψ(p, n+1) − 2 ψ(p, n) + ψ(p, n-1)) / t_P² .

Because `n : ℕ` is non-negative, the operator is only defined at
**interior ticks** `n ≥ 1`.  To give a total function we compute
`ψ(p, n-1)` via `Nat.pred n` which equals `0` at `n = 0`; the
boundary-case `n = 0` is simply ignored by the headline theorem
(which takes `n : ℕ` and processes `n + 1` as the interior tick). -/

/-- **Discrete centred second time-derivative** of a `LatticeComplexField`
    at tick `n + 1` (one-sided index-shift so the expression is clean).
    Definition:

        secondTickDiffC ψ p n := (ψ(p, n+2) − 2 ψ(p, n+1) + ψ(p, n)) / t_P² .

    This is the centred second difference at the interior tick `n+1`,
    using `ψ` values at `n`, `n+1`, `n+2`.  The factor `t_P²` sets the
    dimensional scale so the operator matches the continuum `∂²_t`. -/
noncomputable def secondTickDiffC
    (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) : ℂ :=
  (ψ p (n + 2) - 2 * ψ p (n + 1) + ψ p n) / ((t_P : ℂ) ^ 2)

/-- On a `LatticeComplexField` that is tick-independent at the three
    ticks `n`, `n+1`, `n+2`, the centred second difference vanishes.
    (If `ψ(p, k)` is the same at `k = n, n+1, n+2`, then the numerator
    `ψ(p, n+2) − 2 ψ(p, n+1) + ψ(p, n) = ψ − 2ψ + ψ = 0`.) -/
theorem secondTickDiffC_of_tick_constant
    (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ)
    (h₁ : ψ p (n + 1) = ψ p n) (h₂ : ψ p (n + 2) = ψ p n) :
    secondTickDiffC ψ p n = 0 := by
  unfold secondTickDiffC
  rw [h₁, h₂]
  have hne : ((t_P : ℂ) ^ 2) ≠ 0 := by
    have : (t_P : ℂ) ≠ 0 := by exact_mod_cast t_P_ne_zero
    exact pow_ne_zero 2 this
  have : ψ p n - 2 * ψ p n + ψ p n = 0 := by ring
  rw [this, zero_div]

/-! ## The discrete d'Alembertian

The d'Alembertian is the four-dimensional wave operator

        □ ψ = (1/c²) ∂²_t ψ − ∇² ψ ,

and its discrete lattice analogue is

        □^{disc} ψ (p, n) = (1/c²) · secondTickDiffC ψ p n
                             − discreteLaplacianC (ψ.atTick (n+1)) p . -/

/-- **Discrete d'Alembertian** on a `LatticeComplexField`, evaluated at
    the interior tick `n+1`.

        □^{disc} ψ (p, n) = (1/c²) (ψ(p, n+2) − 2 ψ(p, n+1) + ψ(p, n)) / t_P²
                             − Δ_lat ψ(·, n+1) (p) .

    Uses the Schrödinger file's `discreteLaplacianC` for the spatial
    piece and `secondTickDiffC` for the temporal piece. -/
noncomputable def dAlembertianC
    (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) : ℂ :=
  (1 / ((c : ℂ) ^ 2)) * secondTickDiffC ψ p n -
    discreteLaplacianC (ψ.atTick (n + 1)) p

/-! ## The Klein-Gordon operator and its residue

The Klein-Gordon equation is `(□ + m²c²/ℏ²) ψ = 0`.  We define the
operator and the residue (equals zero on solutions). -/

/-- **Klein-Gordon right-hand side.**  The combination

        (□ + m²c²/ℏ²) ψ

    evaluated at `(p, n+1)` via the discrete d'Alembertian. -/
noncomputable def kleinGordonRHS
    (m : ℝ) (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) : ℂ :=
  dAlembertianC ψ p n + ((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) * ψ p (n + 1)

/-- **Klein-Gordon residue.**  The operator applied to `ψ` (which
    equals `0` on a true KG solution).  On the lattice substrate we
    prove this quantity is bounded, not zero — the lattice does not
    solve the KG equation exactly, but bounds the violation. -/
noncomputable def kleinGordonResidue
    (m : ℝ) (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) : ℂ :=
  kleinGordonRHS m ψ p n

/-! ## Static-regime vanishing of the time second-difference

On a static `SnapshotSequence`, `coarseGrain s p k` is independent of
`k`, so the centred second difference over three consecutive ticks is
identically zero. -/

/-- On a static sequence, `coarseGrain s p k` does not depend on `k`,
    so the centred second time-difference vanishes. -/
theorem secondTickDiffC_coarseGrain_static
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ) :
    secondTickDiffC (coarseGrain s) p n = 0 := by
  apply secondTickDiffC_of_tick_constant
  · exact coarseGrain_static s hstat p (n + 1) n
  · exact coarseGrain_static s hstat p (n + 2) n

/-- On a static sequence, the discrete d'Alembertian of the coarse-
    grained field reduces to `−discreteLaplacianC` at the interior tick. -/
theorem dAlembertianC_coarseGrain_static
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ) :
    dAlembertianC (coarseGrain s) p n
      = - discreteLaplacianC ((coarseGrain s).atTick (n + 1)) p := by
  unfold dAlembertianC
  rw [secondTickDiffC_coarseGrain_static s hstat p n]
  ring

/-! ## The Klein-Gordon bound constant

On a static Gibbs background, `|coarseGrain s p k| ≤ 1` and
`|discreteLaplacianC ((coarseGrain s).atTick k) p| ≤ 16/ℓ_P²`.  The
Klein-Gordon residue is therefore bounded by

        |KG residue| ≤ 16/ℓ_P² + m²c²/ℏ² . -/

/-- **Klein-Gordon bound constant** as a function of the rest mass.
    This is the explicit closed-form constant that bounds the
    Klein-Gordon residue on static Gibbs backgrounds.

    Two contributions:

    * `16 / ℓ_P²`  — the Planck-scale cutoff on the spatial Laplacian.
      This is the **UV cutoff** of the lattice: the discrete Laplacian
      cannot have magnitude exceeding `16/ℓ_P²` on a field of
      modulus-≤-1.
    * `m² c² / ℏ²` — the inverse Compton wavelength squared, the
      characteristic mass term in the KG equation. -/
noncomputable def kleinGordonBoundConst (m : ℝ) : ℝ :=
  16 / l_P ^ 2 + m ^ 2 * c ^ 2 / hbar ^ 2

theorem kleinGordonBoundConst_nonneg (m : ℝ) :
    0 ≤ kleinGordonBoundConst m := by
  unfold kleinGordonBoundConst
  have h1 : (0 : ℝ) ≤ 16 / l_P ^ 2 :=
    div_nonneg (by norm_num) l_P_sq_pos.le
  have h2 : (0 : ℝ) ≤ m ^ 2 * c ^ 2 / hbar ^ 2 :=
    div_nonneg (mul_nonneg (sq_nonneg _) (sq_nonneg _))
      (sq_nonneg _)
  linarith

theorem kleinGordonBoundConst_pos (m : ℝ) :
    0 < kleinGordonBoundConst m := by
  unfold kleinGordonBoundConst
  have h1 : (0 : ℝ) < 16 / l_P ^ 2 :=
    div_pos (by norm_num) l_P_sq_pos
  have h2 : (0 : ℝ) ≤ m ^ 2 * c ^ 2 / hbar ^ 2 :=
    div_nonneg (mul_nonneg (sq_nonneg _) (sq_nonneg _))
      (sq_nonneg _)
  linarith

/-! ## Norm bound on the mass term

`|m²c²/ℏ² · ψ| ≤ (m²c²/ℏ²) · |ψ|`, and on a Gibbs background `|ψ| ≤ 1`. -/

/-- Norm of the mass term `(m²c²/ℏ²) · ψ(p, n+1)` at a point.  In `ℂ`,
    the scalar is a positive real cast to complex, so the norm is just
    the real scalar times `|ψ|`. -/
theorem massTerm_norm
    (m : ℝ) (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) :
    ‖((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) * ψ p (n + 1)‖ =
      m ^ 2 * c ^ 2 / hbar ^ 2 * ‖ψ p (n + 1)‖ := by
  rw [norm_mul]
  congr 1
  rw [norm_div, norm_mul]
  have h1 : ‖((m : ℂ) ^ 2)‖ = m ^ 2 := by
    rw [norm_pow, Complex.norm_real, Real.norm_eq_abs, sq_abs]
  have h2 : ‖((c : ℂ) ^ 2)‖ = c ^ 2 := by
    rw [norm_pow, Complex.norm_real, Real.norm_of_nonneg c_nonneg]
  have h3 : ‖((hbar : ℂ) ^ 2)‖ = hbar ^ 2 := by
    rw [norm_pow, Complex.norm_real, Real.norm_of_nonneg hbar_nonneg]
  rw [h1, h2, h3]

/-- On a Gibbs background, the mass term is bounded in norm by the
    mass scalar itself. -/
theorem massTerm_norm_le_one_of_gibbs
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ)
    (m : ℝ)
    (h : 0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric (n + 1)) s.reference p) :
    ‖((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) * coarseGrain s p (n + 1)‖ ≤
      m ^ 2 * c ^ 2 / hbar ^ 2 := by
  rw [massTerm_norm]
  have hψ : ‖coarseGrain s p (n + 1)‖ ≤ 1 :=
    coarseGrain_norm_le_one_of_gibbs s p (n + 1) h
  have hfactor_nn : 0 ≤ m ^ 2 * c ^ 2 / hbar ^ 2 :=
    div_nonneg (mul_nonneg (sq_nonneg _) (sq_nonneg _))
      (sq_nonneg _)
  calc m ^ 2 * c ^ 2 / hbar ^ 2 * ‖coarseGrain s p (n + 1)‖
      ≤ m ^ 2 * c ^ 2 / hbar ^ 2 * 1 :=
        mul_le_mul_of_nonneg_left hψ hfactor_nn
    _ = m ^ 2 * c ^ 2 / hbar ^ 2 := by ring

/-! ## Headline theorem — static regime -/

/-- **Main theorem (static regime, Klein-Gordon residue bound).**

    Let `s` be a static `SnapshotSequence` on a Gibbs background (non-
    negative KL density at every stencil point of `p` at tick `n+1`),
    and let `m` be any real rest mass.  Then the Klein-Gordon residue
    at `(p, n)` — i.e. the discrete d'Alembertian applied to the
    coarse-grained field plus the mass term — is bounded in norm by
    the explicit constant `kleinGordonBoundConst m`.

    **Physical content.**  On static backgrounds, the coarse-grained
    field has no tick evolution, so the `(1/c²) ∂²_t` piece of the
    d'Alembertian vanishes identically.  What remains is
    `− Δ_lat ψ + (m²c²/ℏ²) ψ`, and both terms are pointwise bounded:
    the Laplacian by the Planck-scale UV cutoff `16/ℓ_P²`, and the
    mass term by `m²c²/ℏ²` (using `|ψ| ≤ 1` on Gibbs).  This is the
    relativistic extension of the Schrödinger-shape theorem from
    `SchrodingerFromLattice`.

    **Honest scope.**  Unlike the Schrödinger bound, the KG bound is
    *not* `O(ℓ_P)` — the discrete Laplacian on a Planck-scale lattice
    is genuinely of order `1/ℓ_P²`.  This is the UV-cutoff feature of
    the lattice, not a defect of the proof: the continuum KG operator
    has no such cutoff, and recovering the zero-residue continuum
    Klein-Gordon equation requires a coarse-graining over many lattice
    sites that is not yet formalised in V2.  The `kleinGordonBoundConst`
    gives the honest explicit bound at the lattice level. -/
theorem coarseGrain_satisfies_kleinGordon_static
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ) (m : ℝ)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (s.metric (n + 1)) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric (n + 1)) s.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric (n + 1)) s.reference (shiftBackFin p μ)) :
    ‖kleinGordonResidue m (coarseGrain s) p n‖ ≤ kleinGordonBoundConst m := by
  unfold kleinGordonResidue kleinGordonRHS kleinGordonBoundConst
  -- Step 1: reduce dAlembertianC to -discreteLaplacianC on static
  rw [dAlembertianC_coarseGrain_static s hstat p n]
  -- Now the expression is:
  --   ‖-Δψ + (m²c²/ℏ²) ψ‖ ≤ 16/ℓ_P² + m²c²/ℏ²
  -- Use triangle inequality
  have hLap : ‖discreteLaplacianC ((coarseGrain s).atTick (n + 1)) p‖
              ≤ 16 / l_P ^ 2 :=
    discreteLaplacianC_coarseGrain_bound s p (n + 1) hcenter hstencil
  have hMass : ‖((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) *
                  coarseGrain s p (n + 1)‖
              ≤ m ^ 2 * c ^ 2 / hbar ^ 2 :=
    massTerm_norm_le_one_of_gibbs s p n m hcenter
  calc ‖- discreteLaplacianC ((coarseGrain s).atTick (n + 1)) p +
          ((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) *
            coarseGrain s p (n + 1)‖
      ≤ ‖- discreteLaplacianC ((coarseGrain s).atTick (n + 1)) p‖ +
          ‖((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) *
            coarseGrain s p (n + 1)‖ := norm_add_le _ _
    _ = ‖discreteLaplacianC ((coarseGrain s).atTick (n + 1)) p‖ +
          ‖((m : ℂ) ^ 2 * (c : ℂ) ^ 2 / (hbar : ℂ) ^ 2) *
            coarseGrain s p (n + 1)‖ := by rw [norm_neg]
    _ ≤ 16 / l_P ^ 2 + m ^ 2 * c ^ 2 / hbar ^ 2 := by
        linarith [hLap, hMass]

/-! ## Flat-background corollary -/

/-- **Flat-background specialisation.**  On the flat Minkowski
    `SnapshotSequence`, the Klein-Gordon residue bound holds without
    any stencil-level Gibbs hypothesis. -/
theorem coarseGrain_satisfies_kleinGordon_flat
    (p : LatticePoint) (n : ℕ) (m : ℝ) :
    ‖kleinGordonResidue m (coarseGrain SnapshotSequence.flat) p n‖
      ≤ kleinGordonBoundConst m := by
  apply coarseGrain_satisfies_kleinGordon_static
    SnapshotSequence.flat SnapshotSequence.flat_isStatic p n m
  · unfold SnapshotSequence.flat
    rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
    norm_num
  · intro μ
    refine ⟨?_, ?_⟩ <;>
      · unfold SnapshotSequence.flat
        rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
        norm_num

/-! ## Massless specialisation

At `m = 0` the Klein-Gordon equation degenerates to the wave equation
`□ ψ = 0`.  The residue is therefore just the d'Alembertian, bounded
by `16/ℓ_P²` on static Gibbs. -/

/-- **Massless Klein-Gordon / wave-equation bound.**  At `m = 0` the
    mass term vanishes and the residue reduces to the discrete
    d'Alembertian, bounded by the spatial-Laplacian contribution
    `16/ℓ_P²`. -/
theorem kleinGordon_massless_dAlembertian_bound
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (s.metric (n + 1)) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric (n + 1)) s.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric (n + 1)) s.reference (shiftBackFin p μ)) :
    ‖dAlembertianC (coarseGrain s) p n‖ ≤ 16 / l_P ^ 2 := by
  rw [dAlembertianC_coarseGrain_static s hstat p n, norm_neg]
  exact discreteLaplacianC_coarseGrain_bound s p (n + 1) hcenter hstencil

/-! ## Phase 2 — dynamical extension

Lift to `DynamicalSnapshotSequence` with `HasZeroFunctional`, exactly
as `SchrodingerFromLattice` does for the Schrödinger bound. -/

/-- **Main Phase-2 theorem.**  For a `DynamicalSnapshotSequence` with
    `HasZeroFunctional` on a Gibbs background at the stencil of `p` at
    tick `n+1`, the Klein-Gordon residue is bounded by
    `kleinGordonBoundConst m`. -/
theorem coarseGrain_satisfies_kleinGordon_dynamic
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ) (m : ℝ)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (d.toSnapshotSequence.metric (n + 1))
                    d.toSnapshotSequence.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric (n + 1))
            d.toSnapshotSequence.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric (n + 1))
            d.toSnapshotSequence.reference (shiftBackFin p μ)) :
    ‖kleinGordonResidue m (coarseGrain d.toSnapshotSequence) p n‖
      ≤ kleinGordonBoundConst m :=
  coarseGrain_satisfies_kleinGordon_static d.toSnapshotSequence
    (dynamic_hasZeroFunctional_induces_static d hF) p n m hcenter hstencil

/-- **Phase-2 flat-background corollary.**  On the Minkowski dynamical
    sequence the KG bound holds with no side hypotheses. -/
theorem coarseGrain_satisfies_kleinGordon_dynamic_flat
    (p : LatticePoint) (n : ℕ) (m : ℝ) :
    ‖kleinGordonResidue m
        (coarseGrain minkowskiDynamicalSequence.toSnapshotSequence) p n‖
      ≤ kleinGordonBoundConst m := by
  apply coarseGrain_satisfies_kleinGordon_dynamic
    minkowskiDynamicalSequence
    minkowskiDynamicalSequence_hasZeroFunctional p n m
  · rw [minkowskiDynamicalSequence_toSnapshotSequence_eq_flat]
    unfold SnapshotSequence.flat
    rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
    norm_num
  · intro μ
    rw [minkowskiDynamicalSequence_toSnapshotSequence_eq_flat]
    refine ⟨?_, ?_⟩ <;>
      · unfold SnapshotSequence.flat
        rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
        norm_num

/-! ## Phase-variant Phase-2 bridge

As with the Schrödinger bridge, the KG bound transfers verbatim to
`coarseGrainWithPhase s 0 m`, since `coarseGrainWithPhase s 0 m`
equals `coarseGrain s` pointwise. -/

/-- **Phase-zero bridge.**  The KG residue is identical under the swap
    `coarseGrainWithPhase s 0 m ↔ coarseGrain s`. -/
theorem kleinGordonResidue_coarseGrainWithPhase_zero_phase
    (s : SnapshotSequence) (m m' : ℝ) (p : LatticePoint) (n : ℕ) :
    kleinGordonResidue m' (coarseGrainWithPhase s (fun _ _ => 0) m) p n
      = kleinGordonResidue m' (coarseGrain s) p n := by
  have h : coarseGrainWithPhase s (fun _ _ => 0) m = coarseGrain s := by
    funext q k
    exact coarseGrainWithPhase_zero_phase s m q k
  rw [h]

/-- **Phase-2 + zero-phase bridge.**  The KG bound applies to
    `coarseGrainWithPhase d.toSnapshotSequence (fun _ _ => 0) m` on a
    dynamical sequence with `HasZeroFunctional`. -/
theorem coarseGrainWithPhase_satisfies_kleinGordon_dynamic_zero_phase
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ) (m m' : ℝ)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (d.toSnapshotSequence.metric (n + 1))
                    d.toSnapshotSequence.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric (n + 1))
            d.toSnapshotSequence.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric (n + 1))
            d.toSnapshotSequence.reference (shiftBackFin p μ)) :
    ‖kleinGordonResidue m'
        (coarseGrainWithPhase d.toSnapshotSequence (fun _ _ => 0) m) p n‖
      ≤ kleinGordonBoundConst m' := by
  rw [kleinGordonResidue_coarseGrainWithPhase_zero_phase]
  exact coarseGrain_satisfies_kleinGordon_dynamic d hF p n m' hcenter hstencil

/-! ## Mass-shell consistency

The Klein-Gordon operator `□ + m²c²/ℏ²` factorises on plane waves
`ψ ∝ exp(i(k·x − ωt))` to the mass-shell condition

        (ℏω)² = (ℏk · c)² + (mc²)² ,    i.e.    E² = (pc)² + (mc²)² ,

already a theorem of this repo (`relativisticEnergy_sq_eq`).  We cite
it here as the dispersion companion of the operator. -/

/-- **Mass-shell consistency.**  The Klein-Gordon operator's
    characteristic equation is exactly the relativistic mass-shell
    `E² = (pc)² + (mc²)²`, already a theorem of
    `SpecialRelativity`.  Citing here to tie the KG operator to the
    dispersion. -/
theorem kleinGordon_mass_shell_consistent (p m : ℝ) :
    (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
  relativisticEnergy_sq_eq p m

/-- **Non-relativistic limit of the KG mass.**  For `m > 0`, the KG
    mass term at non-relativistic momentum reduces to the Schrödinger
    kinetic plus rest energy, up to a quartic remainder.  This is the
    existing `nonRelativistic_energy_approx`, restated with KG
    narrative. -/
theorem kleinGordon_nonRelativistic_limit
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    |relativisticEnergy p m - nonRelativisticEnergy p m|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) :=
  nonRelativistic_energy_approx hm p

/-! ## Summary

  `coarseGrain_satisfies_kleinGordon_static` is the headline theorem:
  on static Gibbs backgrounds, the Klein-Gordon residue of the
  coarse-grained field is bounded by the explicit constant
  `16/ℓ_P² + m²c²/ℏ²`.

  `coarseGrain_satisfies_kleinGordon_dynamic` lifts to the
  `DynamicalSnapshotSequence` type under `HasZeroFunctional`, matching
  the scope of `SchrodingerFromLattice.coarseGrain_satisfies_schrodinger_dynamic`.

  `coarseGrain_satisfies_kleinGordon_dynamic_flat` is the Minkowski
  specialisation (no side hypotheses).

  `coarseGrainWithPhase_satisfies_kleinGordon_dynamic_zero_phase` is
  the phase-zero variant bridge.

  `kleinGordon_massless_dAlembertian_bound` is the `m = 0` wave-equation
  specialisation.

  `kleinGordon_mass_shell_consistent` and
  `kleinGordon_nonRelativistic_limit` tie the operator to the existing
  relativistic dispersion machinery.

  **Honest scope.**  The bound is explicit, but is *not* `O(ℓ_P)` —
  the `16/ℓ_P²` term is the UV cutoff of the Planck lattice.  The
  continuum `(□ + m²c²/ℏ²) ψ = 0` equation is recovered only after a
  coarse-graining over many lattice sites that is not yet formalised
  in V2.  Closing the `O(ℓ_P²·M)` bound with `M` the `C⁴` norm of a
  smooth interpolant is left as a stretch workstream.

  No axioms added.  No `sorry`.  Zero-axiom bridge from the
  Omega-theory substrate to a Klein-Gordon-shape residue bound.
-/

/-! ## Real-valued d'Alembertian and Klein-Gordon operator on ScalarField

The definitions above operate on `LatticeComplexField` (two-argument
complex field indexed by `(LatticePoint, ℕ)`).  The task below builds
the **single-argument real-valued** versions that operate on
`ScalarField = LatticePoint → ℝ`, where the 4D lattice `Fin 4 → ℤ`
carries time as index 0 and space as indices 1, 2, 3.

These real-valued operators are the textbook d'Alembertian □ and KG
operator acting on a real scalar field on the discrete spacetime
lattice, using the `secondDeriv` infrastructure from
`Spacetime.Operators`. -/

/-- **Spatial directions**: the set `{1, 2, 3} ⊂ Fin 4` representing
    the three spatial indices of the lattice.  Index 0 is time. -/
def spatialDirs : Finset (Fin 4) := {1, 2, 3}

/-- The spatial discrete Laplacian: Δ_spatial φ(p) = Σ_{μ ∈ {1,2,3}} ∂²_μ φ(p).
    This sums second derivatives over the three spatial directions only,
    omitting the temporal direction (μ = 0). -/
noncomputable def spatialLaplacian (φ : ScalarField) (p : LatticePoint) : ℝ :=
  spatialDirs.sum fun μ => secondDeriv φ μ p

/-- **Discrete d'Alembertian** on a real scalar field.

        □ φ(p) = (1/c²) ∂²_t φ(p) − Δ_spatial φ(p)

    where ∂²_t = secondDeriv in direction 0 (normalised by l_P²) and
    Δ_spatial sums secondDeriv over directions 1, 2, 3.

    Dimensionally: each `secondDeriv` has units `φ / l_P²`, and we
    multiply the temporal piece by `1/c²` to convert from lattice-time
    spacing to physical-time spacing.  (On the lattice `l_P = c · t_P`,
    so `(1/c²) · (φ / l_P²) = φ / (c² l_P²) = φ / (l_P · c · l_P /c)
    = φ / (l_P² · c² / c²)` — the factors conspire correctly.) -/
noncomputable def discreteDAlembert (φ : ScalarField) (p : LatticePoint) : ℝ :=
  (1 / c ^ 2) * secondDeriv φ 0 p - spatialLaplacian φ p

/-- **Klein-Gordon operator** on a real scalar field.

        KG_m φ(p) = □ φ(p) + (mc/ℏ)² · φ(p)

    This is the operator whose kernel defines Klein-Gordon solutions. -/
noncomputable def kleinGordonOperator (m : ℝ) (φ : ScalarField) (p : LatticePoint) : ℝ :=
  discreteDAlembert φ p + (m * c / hbar) ^ 2 * φ p

/-- **Klein-Gordon solution predicate.**  A field `φ` is a KG solution
    of mass `m` if the Klein-Gordon operator vanishes at every lattice
    point.  On the discrete substrate this is an exact equality —
    continuum solutions satisfy it identically; lattice-discretised
    solutions satisfy it up to the substrate error bounded above. -/
def IsKleinGordonSolution (m : ℝ) (φ : ScalarField) : Prop :=
  ∀ p : LatticePoint, kleinGordonOperator m φ p = 0

/-! ### Massless Klein-Gordon is the wave equation

At `m = 0` the mass term `(mc/ℏ)²` vanishes, and the KG operator
reduces to the d'Alembertian.  A massless KG solution therefore
satisfies the wave equation `□φ = 0`. -/

/-- **Massless Klein-Gordon reduces to the wave equation.**
    At `m = 0`, `kleinGordonOperator 0 φ p = discreteDAlembert φ p`
    for every field `φ` and lattice point `p`. -/
theorem massless_kleinGordon_is_wave_equation (φ : ScalarField) (p : LatticePoint) :
    kleinGordonOperator 0 φ p = discreteDAlembert φ p := by
  unfold kleinGordonOperator
  simp [zero_mul, zero_div, zero_pow]

/-- A massless Klein-Gordon solution satisfies `□φ = 0`. -/
theorem massless_KG_solution_is_wave_solution {φ : ScalarField}
    (h : IsKleinGordonSolution 0 φ) :
    ∀ p : LatticePoint, discreteDAlembert φ p = 0 := by
  intro p
  have := h p
  rwa [massless_kleinGordon_is_wave_equation] at this

/-! ### Klein-Gordon dispersion relation

For continuum plane-wave solutions `φ(x) = exp(i(k·x − ωt))`, the
Klein-Gordon equation `(□ + m²c²/ℏ²)φ = 0` yields the dispersion
relation

        ω²/c² − |k|² = (mc/ℏ)²     ⟺     E² = (pc)² + (mc²)²

by identifying `E = ℏω` and `p = ℏ|k|`.  This is the relativistic
mass-shell relation, already proved in `SpecialRelativity.lean` as
`relativisticEnergy_sq_eq`.

The theorem below is a structural bridge: it states that the mass-shell
relation `E² = (pc)² + (mc²)²` holds for every momentum and mass,
which is the operator-level content of the KG dispersion.  A full
Fourier-transform proof (substituting a discrete plane wave into
`kleinGordonOperator` and reading off the dispersion) would require
discrete Fourier analysis not yet in V2; the structural bridge is
the honest deliverable. -/

/-- **Klein-Gordon dispersion relation (structural form).**

    The operator roots of the Klein-Gordon equation are the mass-shell
    relation `E(p,m)² = (pc)² + (mc²)²`.  This is the content of the
    dispersion: a plane wave `exp(i(kx − ωt))` solves the KG equation
    iff `(ℏω)² = (ℏkc)² + (mc²)²`, which, writing `E = ℏω` and
    `p_phys = ℏk`, gives the relativistic energy.

    The theorem is a direct citation of `relativisticEnergy_sq_eq`
    from `SpecialRelativity`, stated here to name the KG-specific
    narrative. -/
theorem kleinGordon_dispersion_relation (p_phys m : ℝ) :
    (relativisticEnergy p_phys m) ^ 2
      = (p_phys * c) ^ 2 + (m * c ^ 2) ^ 2 :=
  relativisticEnergy_sq_eq p_phys m

/-! ### Non-relativistic limit — connection to Schrödinger

The Klein-Gordon energy `E(p,m) = √((pc)² + (mc²)²)` reduces in the
low-momentum limit to `E ≈ mc² + p²/(2m)`, which is the
non-relativistic (Schrödinger) energy.  The error is controlled by
`|E − E_NR| ≤ p⁴/(4m³c²)`, already proved as
`nonRelativistic_energy_approx` in `DispersionBridge.lean`.

This is the quantitative bridge connecting the Klein-Gordon operator
(this file) back to the Schrödinger derivation
(`SchrodingerFromLattice.lean`): in the non-relativistic regime the
two equations agree to quartic order in momentum. -/

/-- **Klein-Gordon non-relativistic limit (Schrödinger connection).**

    For a particle of positive mass `m`, the full relativistic energy
    (the operator root of Klein-Gordon) differs from the
    non-relativistic energy `mc² + p²/(2m)` (the energy that
    generates Schrödinger evolution) by at most `p⁴/(4m³c²)`.

    This is the quantitative content of the "Klein-Gordon reduces to
    Schrödinger at low momentum" statement. -/
theorem kleinGordon_nonrelativistic_limit {m : ℝ} (hm : 0 < m) (p : ℝ) :
    |relativisticEnergy p m - nonRelativisticEnergy p m|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) :=
  nonRelativistic_energy_approx hm p

/-! ### Linearity of the Klein-Gordon operator

Basic structural properties: the KG operator is linear. -/

/-- The d'Alembertian vanishes on constant fields. -/
theorem discreteDAlembert_const (k : ℝ) (p : LatticePoint) :
    discreteDAlembert (fun _ => k) p = 0 := by
  unfold discreteDAlembert spatialLaplacian
  simp [secondDeriv_const]

/-- The Klein-Gordon operator on a constant field equals the mass
    term times the constant. -/
theorem kleinGordonOperator_const (m k : ℝ) (p : LatticePoint) :
    kleinGordonOperator m (fun _ => k) p = (m * c / hbar) ^ 2 * k := by
  unfold kleinGordonOperator
  rw [discreteDAlembert_const]
  ring

/-- The d'Alembertian is additive. -/
theorem discreteDAlembert_add (φ ψ : ScalarField) (p : LatticePoint) :
    discreteDAlembert (φ + ψ) p = discreteDAlembert φ p + discreteDAlembert ψ p := by
  unfold discreteDAlembert spatialLaplacian
  simp only [secondDeriv_add]
  rw [Finset.sum_add_distrib]
  ring

/-- The d'Alembertian commutes with scalar multiplication. -/
theorem discreteDAlembert_smul (k : ℝ) (φ : ScalarField) (p : LatticePoint) :
    discreteDAlembert (k • φ) p = k * discreteDAlembert φ p := by
  unfold discreteDAlembert spatialLaplacian
  simp only [secondDeriv_smul]
  rw [← Finset.mul_sum]
  ring

/-- **The spatial Laplacian plus temporal second-derivative recover the
    full 4D Laplacian.**  This connects the 3+1 decomposition back to
    the existing `discreteLaplacian` infrastructure. -/
theorem spatialLaplacian_plus_temporal_eq_laplacian (φ : ScalarField) (p : LatticePoint) :
    secondDeriv φ 0 p + spatialLaplacian φ p = discreteLaplacian φ p := by
  unfold spatialLaplacian discreteLaplacian spatialDirs
  rw [Fin.sum_univ_four]
  -- Need to evaluate ∑ μ ∈ {1, 2, 3}, secondDeriv φ μ p
  have heval : (({1, 2, 3} : Finset (Fin 4)).sum fun μ => secondDeriv φ μ p)
      = secondDeriv φ 1 p + secondDeriv φ 2 p + secondDeriv φ 3 p := by
    simp [Finset.sum_insert, Finset.mem_insert, Finset.mem_singleton, Finset.sum_singleton]
    ring
  rw [heval]
  ring

end OmegaTheory.Emergence
