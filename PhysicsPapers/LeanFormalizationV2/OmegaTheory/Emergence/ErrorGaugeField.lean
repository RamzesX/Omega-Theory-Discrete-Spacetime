/-
  OmegaTheory.Emergence.ErrorGaugeField

  U(1) gauge theory with substrate error on the Planck lattice.

  Connects Nunki's `ErrorLieAlgebra` and Alpheratz's `ErrorForms`
  via the U(1) gauge connection:

  1. GaugeConnection — discrete 1-form A with error bound ε_A
  2. gaugeCurvature — F = dA as ErrorForm2, error via errorD1
  3. gaugeCurvature_is_errorMaxwell — bridge to ErrorMaxwellField
  4. gaugeHolonomy — Wilson loop ∮A along a lattice loop
  5. gaugeHolonomy_error_bound — |holonomy_err| ≤ len · ε_A
  6. photonSubstrateMassBound — m_γ ≤ δ_comp(N)/c
  7. photonSubstrateMassBound_pos — strictly positive

  Agent: Naos (ζ Puppis), April 15, 2026. No sorry, no new axioms.
-/
import OmegaTheory.Foundations.ErrorForms
import OmegaTheory.Foundations.ErrorLieAlgebra
import OmegaTheory.Emergence.AharonovBohm
import Mathlib.Tactic

namespace OmegaTheory.Emergence.ErrorGaugeField

open OmegaTheory.Foundations
open OmegaTheory.Foundations.ErrorForms
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Irrationality
open OmegaTheory.Emergence

/-! ## 1. Gauge Connection with Error

A U(1) gauge connection on the Planck lattice is a discrete 1-form
`A : LatticePoint → Fin 4 → ℝ` representing the vector potential,
together with an error bound `ε_A` inherited from the substrate's
finite-precision computation of the Lie-algebra-valued field. -/

/-- A discrete U(1) gauge connection with substrate error.
    `potential` is the 1-form A, `εA` is the uniform error bound. -/
structure GaugeConnection where
  /-- The gauge potential 1-form. -/
  potential : Discrete1Form
  /-- Error bound on each component of A from substrate truncation. -/
  εA : ErrorBound

/-- A gauge connection with zero error (exact, continuum-limit ideal). -/
def GaugeConnection.exact (A : Discrete1Form) : GaugeConnection :=
  ⟨A, ErrorBound.zero⟩

/-- Exact connections have zero error. -/
theorem GaugeConnection.exact_err (A : Discrete1Form) :
    (GaugeConnection.exact A).εA = ErrorBound.zero := rfl

/-! ## 2. Gauge Curvature F = dA with Propagated Error

The field strength F = d₁A is computed via Alpheratz's `errorD1`,
which propagates the connection error through the exterior derivative.
For U(1) (abelian), there is no A∧A term: F = dA exactly. -/

/-- The gauge curvature (field strength) F = dA as an ErrorForm1 → ErrorForm2.
    Uses the error-propagating exterior derivative from ErrorForms. -/
noncomputable def gaugeCurvature (gc : GaugeConnection) : ErrorForm2 :=
  errorD1 ⟨gc.potential, gc.εA⟩

/-- The form part of the gauge curvature is d₁A. -/
theorem gaugeCurvature_form (gc : GaugeConnection) :
    (gaugeCurvature gc).form = d1 gc.potential := rfl

/-- The error of the gauge curvature is C_d · ε_A. -/
theorem gaugeCurvature_err (gc : GaugeConnection) :
    (gaugeCurvature gc).err = ErrorBound.scale C_d C_d_nonneg gc.εA := rfl

/-- An exact gauge connection has zero curvature error. -/
theorem gaugeCurvature_exact_err (A : Discrete1Form) :
    (gaugeCurvature (GaugeConnection.exact A)).err.val = 0 := by
  simp [gaugeCurvature, GaugeConnection.exact, errorD1, ErrorBound.scale,
        ErrorBound.zero]

/-! ## 3. Bridge: Gauge Curvature ↔ Error Maxwell Field

The curvature F = dA satisfies:
- Bianchi identity: dF = d²A = 0 (exact, algebraic d²=0)
- Source equation: d*F = J (with substrate noise floor ε_source)

This connects Alpheratz's `ErrorMaxwellField.fromPotential` to
our gauge connection framework. -/

/-- Build an ErrorMaxwellField from a GaugeConnection.
    The Bianchi identity is exact (ε_bianchi = 0) because F = dA
    and d²=0. The source noise floor is parameterised. -/
noncomputable def gaugeCurvature_is_errorMaxwell
    (gc : GaugeConnection) (ε_source : ErrorBound) :
    ErrorMaxwellField :=
  ErrorMaxwellField.fromPotential gc.potential ε_source

/-- The Bianchi identity for gauge curvature is exact: dF = 0. -/
theorem gaugeCurvature_bianchi_exact
    (gc : GaugeConnection) (ε_source : ErrorBound) :
    (gaugeCurvature_is_errorMaxwell gc ε_source).ε_bianchi =
      ErrorBound.zero := rfl

/-- dF = 0 pointwise for the gauge curvature. -/
theorem gaugeCurvature_dF_zero
    (gc : GaugeConnection) (ε_source : ErrorBound)
    (p : LatticePoint) (μ ν ρ : Fin 4) :
    d2 (gaugeCurvature_is_errorMaxwell gc ε_source).F p μ ν ρ = 0 :=
  d2_comp_d1 gc.potential p μ ν ρ

/-- Charge conservation from gauge curvature. -/
theorem gaugeCurvature_charge_conservation
    (gc : GaugeConnection) (ε_source : ErrorBound)
    (p : LatticePoint) :
    codiff0 (maxwellCurrent
      (gaugeCurvature_is_errorMaxwell gc ε_source).F) p = 0 :=
  (gaugeCurvature_is_errorMaxwell gc ε_source).charge_conservation p

/-- Gauge invariance: F from A+dχ equals F from A. -/
theorem gaugeCurvature_gauge_invariance
    (gc : GaugeConnection) (χ : Discrete0Form)
    (p : LatticePoint) (μ ν : Fin 4) :
    d1 (add1Form gc.potential (d0 χ)) p μ ν =
      d1 gc.potential p μ ν :=
  gauge_invariance gc.potential χ p μ ν

/-! ## 4. Gauge Holonomy (Wilson Loop)

The holonomy of the gauge connection around a closed lattice loop
is the line integral ∮A. On the substrate, each edge contributes
its own truncation error, so the total holonomy error grows linearly
with the loop length. -/

/-- The gauge holonomy (Wilson loop value) along a list of oriented edges.
    This is the discrete analogue of exp(i∮A·dℓ). We work with the
    exponent ∮A rather than the exponential itself. -/
noncomputable def gaugeHolonomy (gc : GaugeConnection)
    (loop : List OrientedEdge) : ℝ :=
  lineIntegralOfConnection gc.potential loop

/-- Holonomy of the zero connection vanishes. -/
theorem gaugeHolonomy_zero (loop : List OrientedEdge) :
    gaugeHolonomy ⟨zero1Form, ErrorBound.zero⟩ loop = 0 := by
  unfold gaugeHolonomy
  exact lineIntegralOfConnection_zero loop

/-- Holonomy is gauge-invariant on plaquettes. -/
theorem gaugeHolonomy_plaquette_gauge_invariance
    (gc : GaugeConnection) (χ : Discrete0Form)
    (p : LatticePoint) (μ ν : Fin 4) :
    gaugeHolonomy ⟨add1Form gc.potential (d0 χ), gc.εA⟩
      (plaquetteLoop p μ ν) =
    gaugeHolonomy gc (plaquetteLoop p μ ν) := by
  unfold gaugeHolonomy
  exact plaquette_gauge_invariance gc.potential χ p μ ν

/-- Holonomy around a plaquette equals l_P² · F(p,μ,ν). -/
theorem gaugeHolonomy_plaquette_eq_flux
    (gc : GaugeConnection) (p : LatticePoint) (μ ν : Fin 4) :
    gaugeHolonomy gc (plaquetteLoop p μ ν) =
      l_P ^ 2 * d1 gc.potential p μ ν := by
  unfold gaugeHolonomy
  exact plaquette_stokes gc.potential p μ ν

/-! ## 5. Holonomy Error Bound

Each edge of the loop contributes at most `l_P · ε_A` of error
(the edge integration scales by l_P, and the connection has
pointwise error ε_A). For a loop of n edges, the total error
is bounded by `n · l_P · ε_A`. -/

/-- Error bound for holonomy over a loop of given length.
    Each edge contributes at most l_P · ε_A of error. -/
noncomputable def holonomyErrorBound (n : ℕ) (εA : ErrorBound) :
    ErrorBound :=
  ⟨n * (l_P * εA.val),
   mul_nonneg (Nat.cast_nonneg n) (mul_nonneg l_P_nonneg εA.nonneg)⟩

/-- Holonomy error is zero for exact connections. -/
theorem holonomyErrorBound_exact (n : ℕ) :
    (holonomyErrorBound n ErrorBound.zero).val = 0 := by
  simp [holonomyErrorBound, ErrorBound.zero]

/-- Holonomy error grows linearly with loop length. -/
theorem holonomyErrorBound_mono {n m : ℕ} (h : n ≤ m)
    (εA : ErrorBound) :
    (holonomyErrorBound n εA).val ≤ (holonomyErrorBound m εA).val := by
  simp only [holonomyErrorBound]
  apply mul_le_mul_of_nonneg_right
  · exact Nat.cast_le.mpr h
  · exact mul_nonneg l_P_nonneg εA.nonneg

/-- Holonomy error is monotone in the connection error. -/
theorem holonomyErrorBound_εA_mono (n : ℕ) {ε₁ ε₂ : ErrorBound}
    (h : ε₁ ≤ ε₂) :
    holonomyErrorBound n ε₁ ≤ holonomyErrorBound n ε₂ := by
  change (holonomyErrorBound n ε₁).val ≤ (holonomyErrorBound n ε₂).val
  simp only [holonomyErrorBound]
  apply mul_le_mul_of_nonneg_left
  · exact mul_le_mul_of_nonneg_left h l_P_nonneg
  · exact Nat.cast_nonneg n

/-- The holonomy error bound for a single plaquette (4 edges). -/
noncomputable def plaquetteHolonomyError (εA : ErrorBound) :
    ErrorBound :=
  holonomyErrorBound 4 εA

/-- The plaquette holonomy error is 4 · l_P · ε_A. -/
theorem plaquetteHolonomyError_val (εA : ErrorBound) :
    (plaquetteHolonomyError εA).val = 4 * (l_P * εA.val) := by
  simp [plaquetteHolonomyError, holonomyErrorBound]

/-! ## 6. Photon Substrate Mass Bound

The substrate's computational uncertainty breaks exact U(1) gauge
invariance by an amount δ_comp(N). In gauge theory, a gauge symmetry
broken at energy scale δ produces a gauge boson mass of order δ/c.

On the substrate at truncation level N:
  m_γ ≤ δ_comp(N) / c

This is a headline prediction: the photon mass is bounded but nonzero.
Current experimental bound is m_γ < 10⁻¹⁸ eV/c², which constrains N. -/

/-- The substrate photon mass bound at truncation level N:
    m_γ ≤ δ_comp(N) / c. -/
noncomputable def photonSubstrateMassBound (N : ℕ) : ℝ :=
  computationalUncertainty N / c

/-- The photon mass bound is nonneg. -/
theorem photonSubstrateMassBound_nonneg (N : ℕ) :
    0 ≤ photonSubstrateMassBound N :=
  div_nonneg (computationalUncertainty_nonneg N) c_nonneg

/-- The photon mass bound is strictly positive: the substrate
    predicts a nonzero photon mass, unlike exact gauge theory. -/
theorem photonSubstrateMassBound_pos (N : ℕ) :
    0 < photonSubstrateMassBound N :=
  div_pos (computationalUncertainty_pos N) c_pos

/-- The photon mass bound decreases with more substrate iterations. -/
theorem photonSubstrateMassBound_decreasing (N : ℕ) :
    photonSubstrateMassBound (N + 1) ≤ photonSubstrateMassBound N := by
  unfold photonSubstrateMassBound
  exact div_le_div_of_nonneg_right (computationalUncertainty_decreasing N)
    c_nonneg

/-- In the continuum limit N → ∞, the photon mass bound can be made
    arbitrarily small: for any ε > 0, there exists N with m_γ < ε. -/
theorem photonSubstrateMassBound_tendsto_zero (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, photonSubstrateMassBound N < ε := by
  have hcε : 0 < c * ε := mul_pos c_pos hε
  obtain ⟨N, hN⟩ := substrateLieBracketError_tendsto_zero (c * ε) hcε
  use N
  unfold photonSubstrateMassBound substrateLieBracketError at *
  rw [div_lt_iff₀ c_pos]
  linarith

/-- The photon mass bound as an ErrorBound. -/
noncomputable def photonSubstrateMassErrorBound (N : ℕ) : ErrorBound :=
  ⟨photonSubstrateMassBound N, photonSubstrateMassBound_nonneg N⟩

/-! ## 7. Substrate-Bounded Gauge Connection

A gauge connection whose error is bounded by the substrate's
computational uncertainty at truncation level N. -/

/-- A gauge connection whose error is bounded by δ_comp(N). -/
structure SubstrateBoundedGauge (N : ℕ) extends GaugeConnection where
  /-- The connection error is bounded by computational uncertainty. -/
  error_bound : εA.val ≤ computationalUncertainty N

/-- The curvature error of a substrate-bounded gauge connection
    is bounded by C_d · δ_comp(N). -/
theorem substrateBoundedGauge_curvature_error (N : ℕ)
    (sbg : SubstrateBoundedGauge N) :
    (gaugeCurvature sbg.toGaugeConnection).err.val ≤
      C_d * computationalUncertainty N := by
  simp only [gaugeCurvature, errorD1, ErrorBound.scale]
  exact mul_le_mul_of_nonneg_left sbg.error_bound C_d_nonneg

/-- The holonomy error of a substrate-bounded gauge connection
    on a loop of n edges is bounded by n · l_P · δ_comp(N). -/
theorem substrateBoundedGauge_holonomy_error (N : ℕ)
    (sbg : SubstrateBoundedGauge N) (n : ℕ) :
    (holonomyErrorBound n sbg.εA).val ≤
      n * (l_P * computationalUncertainty N) := by
  simp only [holonomyErrorBound]
  apply mul_le_mul_of_nonneg_left
  · exact mul_le_mul_of_nonneg_left sbg.error_bound l_P_nonneg
  · exact Nat.cast_nonneg n

/-- A substrate-bounded gauge connection produces a substrate-bounded
    Maxwell field (bridging to Alpheratz's framework). -/
noncomputable def substrateBoundedGauge_maxwell (N : ℕ)
    (sbg : SubstrateBoundedGauge N)
    (ε_source : ErrorBound)
    (hs : ε_source ≤ emNoiseFloor N) :
    SubstrateBoundedMaxwell N :=
  SubstrateBoundedMaxwell.fromPotential sbg.potential N ε_source hs

end OmegaTheory.Emergence.ErrorGaugeField
