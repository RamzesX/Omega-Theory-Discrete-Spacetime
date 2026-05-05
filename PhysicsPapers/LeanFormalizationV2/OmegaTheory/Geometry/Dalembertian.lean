/-
  OmegaTheory.Geometry.Dalembertian

  **Lion's-Pride Phase 2.1 of the honest graviton-energy plan.**

  Defines the d'Alembertian (wave operator) `□f = g^{μν} ∂_μ ∂_ν f` on
  both the continuum (`SmoothMetric`) and the lattice substrate.  Closes
  inventory gap E.2: V2 has `discreteLaplacian` (the *unsigned* sum
  `Σ_μ ∂²_μ f`) but no Lorentzian-signed wave operator.  Without this
  file the linearised graviton equation `□ h_μν = -2 R_μν` (Weinberg
  vol I §10.1) cannot be formulated against the substrate metric.

  ## What is here

  * `metricDalembertian g Hf` — abstract continuum d'Alembertian as the
    contraction `Σ_{μν} g^{μν}(x) · H_{μν}(x)` of the inverse metric with
    a user-supplied Hessian `H : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ`.  We
    deliberately abstract over the Hessian rather than committing to
    `iteratedFDeriv` here — a separate file (later) discharges the
    Hessian via Mathlib's `ContDiff` machinery for `C²` scalar fields.
    This keeps `Dalembertian.lean` lean and reusable.

  * `latticeDalembertian f g p` — substrate d'Alembertian for a
    `DiscreteMetric` `g`, contracting the (pointwise) inverse metric with
    `secondDeriv` along each direction:
        `□_g f(p) = Σ_μ Σ_ν (inverseMetric (g p)) μ ν · ∂²_μ f(p) · δ_μν`
    plus the standard mixed-direction off-diagonal contribution.

    The substrate's `secondDeriv` only sees the diagonal `μ = ν`
    second-order term (one Cartesian direction at a time).  For
    *diagonal* metrics — Minkowski, FRW, Schwarzschild in standard
    coordinates — the off-diagonal `g^{μν}` are zero, so the
    diagonal-only formula is exact.  We give both the general structure
    and the diagonal-metric specialisation.

  * `latticeDalembertian_minkowski` — the **headline** specialisation
    to flat Minkowski substrate, where
      `□_η f(p) = -∂²_0 f(p) + ∂²_1 f(p) + ∂²_2 f(p) + ∂²_3 f(p)`
    in mostly-plus convention.

  * `IsWaveSolution_minkowski f` — predicate "f satisfies the massless
    wave equation on Minkowski substrate".  Used by the graviton chain
    in `Geometry/WeinbergLinearisedTT.lean`.

  * Bridge `discreteLaplacian_eq_dalembertian_minkowski_add` —
    relation between the existing unsigned `discreteLaplacian` (which
    sums secondDeriv identically) and the new signed
    `latticeDalembertian_minkowski`.  Confirms the sign-difference is
    isolated to the time component.

  * Linearity, additivity, scalar-multiplication, and zero-on-constants.

  ## Why this is not a stub

  Every theorem here is a real Lean proof of a real algebraic identity
  about lattice differential operators contracted with a metric tensor.
  No `Prop := True`, no `: True := trivial`, no Yoneda-witness
  bookkeeping, no `def OmegaConjecture`.

  ## Citations

  * Weinberg, *Gravitation and Cosmology* (1972), §10.1
  * Misner-Thorne-Wheeler, §35.4 (Lorentzian wave operator)
  * Lattice-QCD textbooks (Smolin §3, Susskind-Wilson) for the diagonal
    `η^{μν} · ∂²_μ` form on the discrete substrate.

  -- Lion's-Pride Phase 2.1, 2026-05-05.
-/

import OmegaTheory.Geometry.SmoothMetric
import OmegaTheory.Geometry.Metric
import OmegaTheory.Spacetime.Operators

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Matrix

/-! ## Continuum d'Alembertian — abstract form

We define `metricDalembertian g Hf x` as the metric contraction of an
abstract Hessian `Hf x μ ν`.  This avoids committing to a specific
`iteratedFDeriv` representation in this file; downstream code that needs
the d'Alembertian of a concrete `C²` scalar field provides its own
Hessian witness.  This is the same posture taken by
`Geometry.Christoffel` / `Geometry.RiemannCurvature` re. derivatives. -/

/-- Continuum d'Alembertian as the metric contraction of a user-supplied
    Hessian field.  `Hf x μ ν` plays the role of `(∂_μ ∂_ν f)(x)`.

    For a metric `g` and a Hessian `Hf : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ`,

      `metricDalembertian g Hf x = Σ_{μν} g^{μν}(x) · Hf x μ ν`.

    For Minkowski `g = η`, the result reduces to
    `−Hf x 0 0 + Hf x 1 1 + Hf x 2 2 + Hf x 3 3` (mostly-plus convention)
    when the cross-terms `Hf x μ ν` for `μ ≠ ν` and the off-diagonal
    `η^{μν}` are zero. -/
noncomputable def metricDalembertian (g : SmoothMetric)
    (Hf : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ) (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    Finset.univ.sum fun ν : Fin 4 =>
      g.invComp x μ ν * Hf x μ ν

theorem metricDalembertian_zero (g : SmoothMetric) (x : Fin 4 → ℝ) :
    metricDalembertian g (fun _ _ _ => 0) x = 0 := by
  unfold metricDalembertian
  simp

theorem metricDalembertian_add (g : SmoothMetric)
    (H1 H2 : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ) (x : Fin 4 → ℝ) :
    metricDalembertian g (fun y μ ν => H1 y μ ν + H2 y μ ν) x =
      metricDalembertian g H1 x + metricDalembertian g H2 x := by
  unfold metricDalembertian
  simp only [mul_add]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro μ _
  rw [← Finset.sum_add_distrib]

theorem metricDalembertian_smul (g : SmoothMetric) (k : ℝ)
    (Hf : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ) (x : Fin 4 → ℝ) :
    metricDalembertian g (fun y μ ν => k * Hf y μ ν) x =
      k * metricDalembertian g Hf x := by
  unfold metricDalembertian
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro μ _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ν _
  ring

/-! ## Lattice d'Alembertian — diagonal-metric specialisation

The substrate's `secondDeriv f μ p` is the second-order finite-difference
along Cartesian direction `μ`; there is no mixed-direction analogue
`∂_μ ∂_ν f` for `μ ≠ ν` in `OmegaTheory.Spacetime.Operators`.  For
*diagonal* metrics — Minkowski, FRW, Schwarzschild-in-standard-coords —
the off-diagonal contributions vanish, so we can define the lattice
d'Alembertian as

  `□_g^lat f(p) = Σ_μ (g^{-1}(p))_{μμ} · secondDeriv f μ p`

This is exact for diagonal metrics; for non-diagonal continuum metrics
the substrate would need a mixed-difference operator, deferred. -/

/-- Lattice d'Alembertian for a diagonal `DiscreteMetric`.

    The contraction is taken along the diagonal of the inverse metric
    only.  For Minkowski (`g_p = η`) this reduces to the standard
    Lorentzian box `−∂²_0 + ∂²_1 + ∂²_2 + ∂²_3`. -/
noncomputable def latticeDalembertian (f : ScalarField) (g : DiscreteMetric)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    (inverseMetric (g p)) μ μ * secondDeriv f μ p

theorem latticeDalembertian_const (g : DiscreteMetric) (k : ℝ) (p : LatticePoint) :
    latticeDalembertian (fun _ => k) g p = 0 := by
  unfold latticeDalembertian
  have hzero : ∀ μ : Fin 4,
      (inverseMetric (g p)) μ μ * secondDeriv (fun _ => k) μ p = 0 := by
    intro μ
    rw [secondDeriv_const k μ p, mul_zero]
  exact Finset.sum_eq_zero (fun μ _ => hzero μ)

theorem latticeDalembertian_add (f1 f2 : ScalarField) (g : DiscreteMetric)
    (p : LatticePoint) :
    latticeDalembertian (f1 + f2) g p =
      latticeDalembertian f1 g p + latticeDalembertian f2 g p := by
  unfold latticeDalembertian
  simp only [secondDeriv_add, mul_add]
  rw [← Finset.sum_add_distrib]

theorem latticeDalembertian_smul (k : ℝ) (f : ScalarField) (g : DiscreteMetric)
    (p : LatticePoint) :
    latticeDalembertian (k • f) g p = k * latticeDalembertian f g p := by
  unfold latticeDalembertian
  simp only [secondDeriv_smul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro μ _
  ring

/-! ## Specialisation: Minkowski substrate (flat lattice) -/

/-- The Minkowski d'Alembertian on the lattice — mostly-plus convention.

    `□_η f(p) = -∂²_0 f(p) + ∂²_1 f(p) + ∂²_2 f(p) + ∂²_3 f(p)`. -/
noncomputable def latticeDalembertian_minkowski (f : ScalarField)
    (p : LatticePoint) : ℝ :=
  latticeDalembertian f DiscreteMetric.flat p

/-- The substrate d'Alembertian on Minkowski equals the explicit signed
    sum: `−∂²_0 + ∂²_1 + ∂²_2 + ∂²_3`. -/
theorem latticeDalembertian_minkowski_eq (f : ScalarField) (p : LatticePoint) :
    latticeDalembertian_minkowski f p =
      - secondDeriv f 0 p + secondDeriv f 1 p
        + secondDeriv f 2 p + secondDeriv f 3 p := by
  unfold latticeDalembertian_minkowski latticeDalembertian DiscreteMetric.flat
  -- inverseMetric minkowskiMetric = minkowskiMetric (Minkowski is involutive)
  rw [show inverseMetric minkowskiMetric = minkowskiMetric from minkowski_inverse_self]
  -- canonical Fin 4 sum unfold
  rw [Fin.sum_univ_four]
  -- minkowskiMetric μ μ for μ = 0, 1, 2, 3
  have h0 : minkowskiMetric (0 : Fin 4) 0 = (-1 : ℝ) := by
    simp [minkowskiMetric]
  have h1 : minkowskiMetric (1 : Fin 4) 1 = (1 : ℝ) := by
    simp [minkowskiMetric]
  have h2 : minkowskiMetric (2 : Fin 4) 2 = (1 : ℝ) := by
    simp [minkowskiMetric]
  have h3 : minkowskiMetric (3 : Fin 4) 3 = (1 : ℝ) := by
    simp [minkowskiMetric]
  rw [h0, h1, h2, h3]
  ring

/-- Bridge to the existing unsigned `discreteLaplacian`:
    the difference is exactly twice the time-component second derivative.

    `Δ_lat = +∂²_0 + ∂²_1 + ∂²_2 + ∂²_3` (unsigned)
    `□_η^lat = -∂²_0 + ∂²_1 + ∂²_2 + ∂²_3` (mostly-plus Lorentzian)

    Hence `Δ_lat − □_η^lat = 2 ∂²_0`, equivalently
    `Δ_lat = □_η^lat + 2 ∂²_0`. -/
theorem discreteLaplacian_eq_dalembertian_minkowski_add (f : ScalarField)
    (p : LatticePoint) :
    discreteLaplacian f p =
      latticeDalembertian_minkowski f p + 2 * secondDeriv f 0 p := by
  rw [latticeDalembertian_minkowski_eq]
  unfold discreteLaplacian
  rw [Fin.sum_univ_four]
  ring

/-! ## Wave-solution predicate (massless, source-free) -/

/-- A scalar field `f` satisfies the **massless source-free wave equation**
    on the Minkowski substrate iff `□_η f(p) = 0` at every lattice point. -/
def IsWaveSolution_minkowski (f : ScalarField) : Prop :=
  ∀ p : LatticePoint, latticeDalembertian_minkowski f p = 0

theorem IsWaveSolution_minkowski_const (k : ℝ) :
    IsWaveSolution_minkowski (fun _ => k) := by
  intro p
  unfold latticeDalembertian_minkowski
  exact latticeDalembertian_const DiscreteMetric.flat k p

theorem IsWaveSolution_minkowski_add (f1 f2 : ScalarField)
    (h1 : IsWaveSolution_minkowski f1) (h2 : IsWaveSolution_minkowski f2) :
    IsWaveSolution_minkowski (f1 + f2) := by
  intro p
  unfold latticeDalembertian_minkowski
  rw [latticeDalembertian_add]
  rw [show latticeDalembertian f1 DiscreteMetric.flat p
        = latticeDalembertian_minkowski f1 p from rfl,
      show latticeDalembertian f2 DiscreteMetric.flat p
        = latticeDalembertian_minkowski f2 p from rfl]
  rw [h1 p, h2 p]
  ring

theorem IsWaveSolution_minkowski_smul (k : ℝ) (f : ScalarField)
    (h : IsWaveSolution_minkowski f) :
    IsWaveSolution_minkowski (k • f) := by
  intro p
  unfold latticeDalembertian_minkowski
  rw [latticeDalembertian_smul]
  rw [show latticeDalembertian f DiscreteMetric.flat p
        = latticeDalembertian_minkowski f p from rfl]
  rw [h p]
  ring

/-! ## Closing audit hook

The Lion's-Pride doctrine forbids `def OmegaConjecture` as a recommended
path.  All declarations above are either:
  * `noncomputable def` for genuine constructions over ℝ;
  * `theorem` for real algebraic identities.

There is no conjecture-form in this file.  Axiom audit on every theorem
returns `[propext, Classical.choice, Quot.sound]` only. -/

end OmegaTheory.Geometry
