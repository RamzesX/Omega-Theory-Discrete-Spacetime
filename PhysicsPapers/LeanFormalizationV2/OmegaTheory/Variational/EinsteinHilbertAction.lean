/-
  OmegaTheory.Variational.EinsteinHilbertAction

  **Lion's-Pride Phase 5.1 (2026-05-06)**:
  *Einstein-Hilbert action `S_EH = (1/16π G) ∫ √(−g) R d⁴x`* on
  the substrate ℤ⁴ lattice.

  ## The action

  Continuum:
      `S_EH[g]  =  (1/(16π G_N)) ∫_M √(−det g) · R(g) · d⁴x`.

  Substrate (discrete on lattice):
      `S_EH[g, region]  =  (1/(16π G_N)) · Σ_{p ∈ region}
                                √(−det g_p) · R(g, p) · ℓ_P⁴`.

  The factor `ℓ_P⁴` plays the role of the volume measure `d⁴x`
  on the discrete ℤ⁴ lattice (each cell has 4-volume `ℓ_P⁴`).

  ## What this file ships

  1. `detMetric g p` — `Matrix.det (g p)`, the metric determinant
     at lattice point `p`.

  2. `sqrtNegDetMetric g p` — `√(−det g_p)`, the volume-element
     prefactor.  For Lorentzian metric (signature −+++) the
     determinant is negative, so `−det > 0` and the square root
     is real.

  3. `einsteinHilbertDensity g p` — `√(−det g_p) · R(g, p)`, the
     EH Lagrangian density.

  4. `einsteinHilbertAction g region` — `(1/16π G_N) · Σ_p
     density · ℓ_P⁴`, the Riemann sum over a finite region.

  5. **Headlines**:
     * `detMetric_flat`: at flat metric, `det = -1`.
     * `sqrtNegDetMetric_flat`: at flat metric, `√(−det) = 1`.
     * `einsteinHilbertDensity_at_flat_eq_zero`: at flat,
       density vanishes (since `R_flat = 0` from
       `Geometry/Curvature.scalar_flat`).
     * `einsteinHilbertAction_at_flat_eq_zero`: at flat,
       the full EH action vanishes.
     * `einstein_hilbert_action_substrate_report`: 4-conjunct
       composite headline.

  ## Connection to Phase 4 G-SM coupling

  The EH action is the SOURCE of the linearised Einstein equation
  Phase 4.1 derived: `δS_EH/δg^{μν} = 0` ⟺ `R_μν = 0` (vacuum)
  or `R_μν − ½g_μν R = 8π G T_μν` (sourced).  Phase 4.1 ships the
  LINEARISED form `□ h_μν = -16π G T_μν^I`.  This file ships the
  ACTION whose variational derivative is that field equation.

  ## Connection to Phase 5 G-G self-interaction

  Phase 5.2 (`Variational/RicciScalarPerturbative.lean` upcoming)
  expands `R(g)` in powers of metric perturbation `h_μν` to
  fourth order:

      R(η + h)  =  R_lin(h)  +  R_quad(h, h)  +  R_cubic(h, h, h) + R_quartic(h, h, h, h) + O(h^5).

  Substituted into `S_EH`, this gives the cubic and quartic
  graviton vertices (Phase 5.3, 5.4).

  ## Honest scope

  This file does NOT yet:
  * Prove the Euler-Lagrange `δS_EH = 0 ⟹ R_μν = 0` (continuum
    variational principle; substrate discretisation requires
    careful handling of boundary terms — Phase 5.2).
  * Compute concrete `R(g)` for non-flat substrate metrics
    (requires inverse-metric machinery; Phase 5.2 perturbative
    expansion).
  * Give a positivity bound on `S_EH` (the action is not
    positive-definite even classically — its sign depends on
    signature conventions and gauge choice).

  ## Author

  Lion's-Pride dynamic /loop iteration 13 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Geometry.Metric
import OmegaTheory.Spacetime.Constants
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic

set_option linter.unusedSimpArgs false

namespace OmegaTheory.Variational.EinsteinHilbertAction

open OmegaTheory.Geometry
open OmegaTheory.Spacetime
open Matrix

/-! ## 1. Metric determinant

`det g_p` for `g_p : Matrix (Fin 4) (Fin 4) ℝ` (4×4 metric tensor
at lattice point `p`).  For Lorentzian metric (signature −+++)
the determinant is negative. -/

/-- **Metric determinant at a lattice point**. -/
noncomputable def detMetric (g : DiscreteMetric) (p : LatticePoint) : ℝ :=
  Matrix.det (g p)

/-- **Determinant of the flat (Minkowski) metric is `−1`**. -/
theorem detMetric_flat (p : LatticePoint) :
    detMetric DiscreteMetric.flat p = -1 := by
  unfold detMetric DiscreteMetric.flat minkowskiMetric
  rw [Matrix.det_diagonal, Fin.prod_univ_four]
  -- Each `![(-1 : ℝ), 1, 1, 1] i` for `i ∈ {0, 1, 2, 3}` reduces by `rfl`
  -- because Fin numerals expand to concrete `Nat → Fin 4` constructors.
  have h0 : (![(-1 : ℝ), 1, 1, 1] : Fin 4 → ℝ) 0 = -1 := by rfl
  have h1 : (![(-1 : ℝ), 1, 1, 1] : Fin 4 → ℝ) 1 = 1 := by rfl
  have h2 : (![(-1 : ℝ), 1, 1, 1] : Fin 4 → ℝ) 2 = 1 := by rfl
  have h3 : (![(-1 : ℝ), 1, 1, 1] : Fin 4 → ℝ) 3 = 1 := by rfl
  rw [h0, h1, h2, h3]
  norm_num

/-- **For flat metric, `−det` is `1` (positive)**. -/
theorem neg_detMetric_flat (p : LatticePoint) :
    -detMetric DiscreteMetric.flat p = 1 := by
  rw [detMetric_flat]
  ring

/-- **For flat metric, `−det` is non-negative**. -/
theorem neg_detMetric_flat_nonneg (p : LatticePoint) :
    0 ≤ -detMetric DiscreteMetric.flat p := by
  rw [neg_detMetric_flat]
  norm_num

/-! ## 2. Volume-element prefactor `√(−det g_p)`

The volume form `√(−det g) d⁴x` enters the EH action.  For
Lorentzian signature, `det < 0` so `−det > 0` and the square
root is real-valued. -/

/-- **Volume-element prefactor `√(−det g_p)`**. -/
noncomputable def sqrtNegDetMetric (g : DiscreteMetric) (p : LatticePoint) : ℝ :=
  Real.sqrt (-detMetric g p)

/-- **`√(−det g)` is non-negative** (it's a square root). -/
theorem sqrtNegDetMetric_nonneg (g : DiscreteMetric) (p : LatticePoint) :
    0 ≤ sqrtNegDetMetric g p := by
  unfold sqrtNegDetMetric
  exact Real.sqrt_nonneg _

/-- **At flat metric, `√(−det g) = 1`** (since `−det g = 1`). -/
theorem sqrtNegDetMetric_flat (p : LatticePoint) :
    sqrtNegDetMetric DiscreteMetric.flat p = 1 := by
  unfold sqrtNegDetMetric
  rw [neg_detMetric_flat]
  exact Real.sqrt_one

/-! ## 3. Einstein-Hilbert Lagrangian density `√(−g) R`

Pointwise: `density(g, p) := √(−det g_p) · R(g, p)`. -/

/-- **Einstein-Hilbert Lagrangian density**:
    `density(g, p) := √(−det g_p) · R(g, p)`. -/
noncomputable def einsteinHilbertDensity (g : DiscreteMetric)
    (p : LatticePoint) : ℝ :=
  sqrtNegDetMetric g p * scalarCurvature g p

/-- **At flat metric, the EH density vanishes**.

    Proof: `R_flat = 0` (Curvature.scalar_flat), so `density = 1 · 0 = 0`. -/
theorem einsteinHilbertDensity_at_flat_eq_zero (p : LatticePoint) :
    einsteinHilbertDensity DiscreteMetric.flat p = 0 := by
  unfold einsteinHilbertDensity
  rw [scalar_flat]
  ring

/-! ## 4. Einstein-Hilbert action: discrete Riemann sum

`S_EH[g, region] := (1/16π G_N) · Σ_{p ∈ region} density · ℓ_P⁴`. -/

/-- **Einstein-Hilbert action over a finite lattice region**:
    `S_EH[g, region] := (1/16π G_N) · Σ_p density · ℓ_P⁴`. -/
noncomputable def einsteinHilbertAction
    (g : DiscreteMetric) (region : Finset LatticePoint) : ℝ :=
  (1 / (16 * Real.pi * G_N)) *
    region.sum (fun p => einsteinHilbertDensity g p * l_P^4)

/-- **At flat metric, the EH action over any region vanishes**.

    Proof: each density term is zero (`einsteinHilbertDensity_at_flat_eq_zero`),
    so the sum is zero. -/
theorem einsteinHilbertAction_at_flat_eq_zero
    (region : Finset LatticePoint) :
    einsteinHilbertAction DiscreteMetric.flat region = 0 := by
  unfold einsteinHilbertAction
  have hzero : ∀ p ∈ region,
      einsteinHilbertDensity DiscreteMetric.flat p * l_P^4 = 0 := by
    intro p _
    rw [einsteinHilbertDensity_at_flat_eq_zero]
    ring
  rw [Finset.sum_congr rfl hzero, Finset.sum_const_zero]
  ring

/-! ## 5. Prefactor positivity: `1/(16π G_N) > 0` -/

/-- **The Einstein-Hilbert prefactor `1/(16π G_N)` is strictly
    positive**. -/
theorem einsteinHilbert_prefactor_pos :
    0 < 1 / (16 * Real.pi * G_N) := by
  apply one_div_pos.mpr
  have hπ_pos : 0 < Real.pi := Real.pi_pos
  have h16_pos : (0 : ℝ) < 16 := by norm_num
  have h16π_pos : 0 < 16 * Real.pi := mul_pos h16_pos hπ_pos
  exact mul_pos h16π_pos G_N_pos

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 5.1 headline — Einstein-Hilbert action
    on the substrate**.

    For any lattice point `p` and finite region `region`:

    1. `detMetric flat p = -1` (Minkowski determinant).

    2. `sqrtNegDetMetric flat p = 1` (volume prefactor at flat).

    3. `einsteinHilbertDensity flat p = 0` (since `R_flat = 0`).

    4. `einsteinHilbertAction flat region = 0` (vacuum action
       vanishes on flat background).

    5. `1/(16π G_N) > 0` (EH prefactor strictly positive). -/
theorem einstein_hilbert_action_substrate_report
    (p : LatticePoint) (region : Finset LatticePoint) :
    detMetric DiscreteMetric.flat p = -1 ∧
    sqrtNegDetMetric DiscreteMetric.flat p = 1 ∧
    einsteinHilbertDensity DiscreteMetric.flat p = 0 ∧
    einsteinHilbertAction DiscreteMetric.flat region = 0 ∧
    0 < 1 / (16 * Real.pi * G_N) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact detMetric_flat p
  · exact sqrtNegDetMetric_flat p
  · exact einsteinHilbertDensity_at_flat_eq_zero p
  · exact einsteinHilbertAction_at_flat_eq_zero region
  · exact einsteinHilbert_prefactor_pos

/-! ## 7. Substrate equilibrium = vacuum solution

A trivial but conceptually important corollary: when the substrate
is at equilibrium (`g = ḡ = flat` everywhere), the Einstein-Hilbert
action over any finite region equals zero — the substrate's
gravitational sector is in its zero-energy ground state.

This is the action-level version of "flat space is the vacuum
solution of GR". -/

/-- **Substrate equilibrium = EH action vacuum**:
    when `g` equals the flat reference everywhere, the EH action
    on any region is zero. -/
theorem substrate_equilibrium_einstein_hilbert_zero
    (g : DiscreteMetric)
    (h_flat : ∀ p, g p = DiscreteMetric.flat p)
    (region : Finset LatticePoint) :
    einsteinHilbertAction g region = 0 := by
  -- From h_flat, the metric IS the flat metric (pointwise).
  -- We can rewrite `g` to `DiscreteMetric.flat`.
  have hfun : g = DiscreteMetric.flat := by
    funext p
    exact h_flat p
  rw [hfun]
  exact einsteinHilbertAction_at_flat_eq_zero region

end OmegaTheory.Variational.EinsteinHilbertAction
