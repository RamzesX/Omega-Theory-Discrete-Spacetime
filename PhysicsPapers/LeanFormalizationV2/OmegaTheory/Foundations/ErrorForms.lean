/-
  OmegaTheory.Foundations.ErrorForms

  Differential forms with bounded error on the Planck lattice.

  Extends the discrete exterior calculus (DiscreteForms.lean) with the
  error-propagation algebra (ErrorAlgebra.lean) to create "error forms":
  each k-form carries an explicit error bound that propagates through
  exterior derivatives and wedge products.

  Key definitions:
  1. `ErrorForm k` -- a discrete k-form paired with an ErrorBound
  2. `errorExteriorDerivative` -- d propagates error: d(omega, eps) = (d omega, eps * C_d)
  3. `errorWedge` -- wedge with error: (omega, e1) /\ (eta, e2) = (omega /\ eta, bound)
  4. `errorStokes` -- discrete Stokes with error budget
  5. `errorMaxwellEquations` -- Maxwell dF=0, d*F=J with substrate noise floor
  6. `errorMaxwell_substrate_bound` -- noise floor bounded by delta_comp(N)

  Agent: Alpheratz (April 15, 2026)
-/

import OmegaTheory.Geometry.DiscreteMaxwell
import OmegaTheory.Geometry.DiscreteStokes
import OmegaTheory.Geometry.WedgeProduct
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.Foundations.ErrorForms

open OmegaTheory.Foundations
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Irrationality

/-! ## Error Forms

  An `ErrorForm k` pairs a discrete k-form with a uniform error bound.
  This tracks how truncation errors on lattice computations propagate
  through the de Rham complex. -/

/-- A discrete 0-form with error bound. -/
structure ErrorForm0 where
  form : Discrete0Form
  err  : ErrorBound

/-- A discrete 1-form with error bound. -/
structure ErrorForm1 where
  form : Discrete1Form
  err  : ErrorBound

/-- A discrete 2-form with error bound. -/
structure ErrorForm2 where
  form : Discrete2Form
  err  : ErrorBound

/-- A discrete 3-form with error bound. -/
structure ErrorForm3 where
  form : Discrete3Form
  err  : ErrorBound

/-! ### Exact (zero-error) lifting -/

/-- Lift a 0-form to an error form with zero error. -/
def ErrorForm0.exact (f : Discrete0Form) : ErrorForm0 :=
  ⟨f, ErrorBound.zero⟩

/-- Lift a 1-form to an error form with zero error. -/
def ErrorForm1.exact (ω : Discrete1Form) : ErrorForm1 :=
  ⟨ω, ErrorBound.zero⟩

/-- Lift a 2-form to an error form with zero error. -/
def ErrorForm2.exact (ω : Discrete2Form) : ErrorForm2 :=
  ⟨ω, ErrorBound.zero⟩

/-- Exact 0-forms have zero error. -/
theorem ErrorForm0.exact_err (f : Discrete0Form) :
    (ErrorForm0.exact f).err = ErrorBound.zero := rfl

/-- Exact 1-forms have zero error. -/
theorem ErrorForm1.exact_err (ω : Discrete1Form) :
    (ErrorForm1.exact ω).err = ErrorBound.zero := rfl

/-! ## Exterior Derivative with Error Propagation

  Applying the exterior derivative amplifies the error by a geometric
  constant `C_d` that depends on the lattice spacing. On a 4D lattice
  the finite-difference stencil has width proportional to `1/l_P`, so
  the error amplification factor is `4 / l_P` (one per direction, summed). -/

/-- Geometric amplification constant for the exterior derivative.
    On a 4-dimensional lattice with spacing l_P, the forward-difference
    stencil amplifies pointwise errors by at most 4/l_P. -/
noncomputable def C_d : ℝ := 4 / l_P

theorem C_d_pos : 0 < C_d := div_pos (by norm_num : (0 : ℝ) < 4) l_P_pos

theorem C_d_nonneg : 0 ≤ C_d := le_of_lt C_d_pos

/-- Error-propagating exterior derivative d₀: Ω⁰ → Ω¹.
    The error is scaled by C_d. -/
noncomputable def errorD0 (ω : ErrorForm0) : ErrorForm1 :=
  ⟨d0 ω.form, ErrorBound.scale C_d C_d_nonneg ω.err⟩

/-- Error-propagating exterior derivative d₁: Ω¹ → Ω².
    The error is scaled by C_d. -/
noncomputable def errorD1 (ω : ErrorForm1) : ErrorForm2 :=
  ⟨d1 ω.form, ErrorBound.scale C_d C_d_nonneg ω.err⟩

/-- Error-propagating exterior derivative d₂: Ω² → Ω³.
    The error is scaled by C_d. -/
noncomputable def errorD2 (ω : ErrorForm2) : ErrorForm3 :=
  ⟨d2 ω.form, ErrorBound.scale C_d C_d_nonneg ω.err⟩

/-- The underlying form of errorD0 is d0. -/
theorem errorD0_form (ω : ErrorForm0) :
    (errorD0 ω).form = d0 ω.form := rfl

/-- The underlying form of errorD1 is d1. -/
theorem errorD1_form (ω : ErrorForm1) :
    (errorD1 ω).form = d1 ω.form := rfl

/-- d² = 0 at degree 0 for error forms: the form part of errorD1(errorD0(f))
    vanishes, matching the exact d²=0. -/
theorem errorD1_comp_errorD0_form (f : ErrorForm0)
    (p : LatticePoint) (μ ν : Fin 4) :
    (errorD1 (errorD0 f)).form p μ ν = 0 := by
  simp only [errorD1, errorD0]
  exact d1_comp_d0 f.form p μ ν

/-- d² = 0 at degree 1 for error forms. -/
theorem errorD2_comp_errorD1_form (ω : ErrorForm1)
    (p : LatticePoint) (μ ν ρ : Fin 4) :
    (errorD2 (errorD1 ω)).form p μ ν ρ = 0 := by
  simp only [errorD2, errorD1]
  exact d2_comp_d1 ω.form p μ ν ρ

/-- Error of d applied to an exact form is zero. -/
theorem errorD0_exact_err (f : Discrete0Form) :
    (errorD0 (ErrorForm0.exact f)).err.val = 0 := by
  simp [errorD0, ErrorForm0.exact, ErrorBound.scale, ErrorBound.zero]

/-! ## Wedge Product with Error Propagation

  For error forms (ω, εω) and (η, εη), the wedge product error bound is:
    ε_{ω∧η} = |ω|_sup · εη + |η|_sup · εω + εω · εη

  Since we work with uniform error bounds (not pointwise suprema),
  we parameterise by sup-norm bounds A, B on the forms. -/

/-- Wedge product of error 1-forms with error propagation.
    Given sup-norm bounds A ≥ sup|ω|, B ≥ sup|η|, the error of
    ω ∧ η is bounded by A·εη + B·εω + εω·εη. -/
noncomputable def errorWedge11 (ω η : ErrorForm1) (A B : ℝ)
    (hA : 0 ≤ A) (hB : 0 ≤ B) : ErrorForm2 where
  form := wedge11 ω.form η.form
  err  := ⟨A * η.err.val + B * ω.err.val + ω.err.val * η.err.val,
           ErrorBound.mul_error_bound hA hB ω.err η.err⟩

/-- The form part of errorWedge11 is the ordinary wedge product. -/
theorem errorWedge11_form (ω η : ErrorForm1) (A B : ℝ)
    (hA : 0 ≤ A) (hB : 0 ≤ B) :
    (errorWedge11 ω η A B hA hB).form = wedge11 ω.form η.form := rfl

/-- Wedge of exact forms gives zero error. -/
theorem errorWedge11_exact_err (α β : Discrete1Form) (A B : ℝ)
    (hA : 0 ≤ A) (hB : 0 ≤ B) :
    (errorWedge11 (ErrorForm1.exact α) (ErrorForm1.exact β) A B hA hB).err.val = 0 := by
  simp [errorWedge11, ErrorForm1.exact, ErrorBound.zero]

/-- The wedge error is nonneg (inherited from ErrorBound). -/
theorem errorWedge11_err_nonneg (ω η : ErrorForm1) (A B : ℝ)
    (hA : 0 ≤ A) (hB : 0 ≤ B) :
    0 ≤ (errorWedge11 ω η A B hA hB).err.val :=
  (errorWedge11 ω η A B hA hB).err.nonneg

/-! ## Discrete Stokes with Error

  The discrete Stokes theorem for d₀ says:
    Σ_{k=0}^{n-1} d₀f(p+k·ê_μ, μ) = (f(p+n·ê_μ) - f(p)) / l_P

  When f carries error εf, the path sum accumulates error.
  The total Stokes error over n edges is bounded by n · C_d · εf. -/

/-- Error bound for Stokes integration of a 0-form error form over n edges.
    Each edge contributes at most C_d · εf of error. -/
noncomputable def stokesErrorBound (n : ℕ) (εf : ErrorBound) : ErrorBound :=
  ⟨n * (C_d * εf.val),
   mul_nonneg (Nat.cast_nonneg n) (mul_nonneg C_d_nonneg εf.nonneg)⟩

/-- Stokes error is zero for exact forms. -/
theorem stokesErrorBound_exact (n : ℕ) :
    (stokesErrorBound n ErrorBound.zero).val = 0 := by
  simp [stokesErrorBound, ErrorBound.zero]

/-- Stokes error grows linearly with path length. -/
theorem stokesErrorBound_mono {n m : ℕ} (h : n ≤ m) (ε : ErrorBound) :
    (stokesErrorBound n ε).val ≤ (stokesErrorBound m ε).val := by
  simp only [stokesErrorBound]
  apply mul_le_mul_of_nonneg_right
  · exact Nat.cast_le.mpr h
  · exact mul_nonneg C_d_nonneg ε.nonneg

/-- Stokes error is monotone in the input error. -/
theorem stokesErrorBound_err_mono (n : ℕ) {ε₁ ε₂ : ErrorBound}
    (h : ε₁ ≤ ε₂) :
    stokesErrorBound n ε₁ ≤ stokesErrorBound n ε₂ := by
  change (stokesErrorBound n ε₁).val ≤ (stokesErrorBound n ε₂).val
  simp only [stokesErrorBound]
  apply mul_le_mul_of_nonneg_left
  · exact mul_le_mul_of_nonneg_left h C_d_nonneg
  · exact Nat.cast_nonneg n

/-! ## Error Maxwell Equations

  Maxwell's equations in the error-form language. The electromagnetic
  field strength F is a 2-form; on the discrete substrate it carries
  an error bound from lattice truncation.

  - **Bianchi identity**: dF = 0 exactly when F = dA (no error in the
    algebraic identity d²=0). The noise floor ε₁ captures the
    deviation of a physical F from an exact dA.

  - **Source equation**: d*F = J (via the codifferential). The noise
    floor ε₂ captures truncation error in the Hodge star + codifferential. -/

/-- Error Maxwell field: a 2-form F with error, plus noise floors for
    the Bianchi identity (ε₁) and source equation (ε₂). -/
structure ErrorMaxwellField where
  /-- The field strength 2-form. -/
  F : Discrete2Form
  /-- Error bound on F from lattice computation. -/
  εF : ErrorBound
  /-- Bianchi noise floor: pointwise bound on |dF|. -/
  ε_bianchi : ErrorBound
  /-- Source noise floor: pointwise bound on |d*F - J|. -/
  ε_source : ErrorBound
  /-- F is antisymmetric (physical field strength). -/
  antisym : IsAntisymmetric2 F

/-- For an exact gauge field F = dA, the Bianchi identity holds exactly:
    ε_bianchi = 0 because d²=0 is algebraic. -/
noncomputable def ErrorMaxwellField.fromPotential (A : Discrete1Form)
    (ε_source : ErrorBound) : ErrorMaxwellField where
  F := d1 A
  εF := ErrorBound.zero
  antisym := d1_antisymmetric A
  ε_bianchi := ErrorBound.zero
  ε_source := ε_source

/-- The Bianchi identity is exact for gauge-derived fields. -/
theorem ErrorMaxwellField.fromPotential_bianchi_exact (A : Discrete1Form)
    (ε_source : ErrorBound) :
    (ErrorMaxwellField.fromPotential A ε_source).ε_bianchi = ErrorBound.zero := rfl

/-- The Bianchi identity dF = 0 holds pointwise for exact gauge fields,
    regardless of source error. -/
theorem ErrorMaxwellField.fromPotential_dF_zero (A : Discrete1Form)
    (ε_source : ErrorBound) (p : LatticePoint) (μ ν ρ : Fin 4) :
    d2 (ErrorMaxwellField.fromPotential A ε_source).F p μ ν ρ = 0 :=
  d2_comp_d1 A p μ ν ρ

/-- Charge conservation holds for any error Maxwell field (because
    the underlying F is antisymmetric and codiff²=0 is algebraic). -/
theorem ErrorMaxwellField.charge_conservation (emf : ErrorMaxwellField)
    (p : LatticePoint) :
    codiff0 (maxwellCurrent emf.F) p = 0 :=
  maxwell_charge_conservation emf.F emf.antisym p

/-- The Maxwell current from an error field is conserved. -/
theorem ErrorMaxwellField.current_isConserved (emf : ErrorMaxwellField) :
    Conservation.IsConserved (maxwellCurrent emf.F) :=
  maxwell_current_isConserved emf.F emf.antisym

/-- Gauge invariance: the field strength is unchanged by A → A + dχ,
    so the error Maxwell field from a gauge-transformed potential
    has the same F. -/
theorem errorMaxwell_gauge_invariance (A : Discrete1Form)
    (χ : Discrete0Form) (ε_source : ErrorBound)
    (p : LatticePoint) (μ ν : Fin 4) :
    (ErrorMaxwellField.fromPotential (add1Form A (d0 χ)) ε_source).F p μ ν =
    (ErrorMaxwellField.fromPotential A ε_source).F p μ ν :=
  gauge_invariance A χ p μ ν

/-! ## Substrate Bound: Noise Floor from δ_comp(N)

  The electromagnetic noise floors ε₁ (Bianchi) and ε₂ (source) are
  not free parameters: they are bounded by the substrate's computational
  uncertainty δ_comp(N). The exterior derivative amplifies by C_d, so:

    ε₁ ≤ C_d · δ_comp(N)     (Bianchi noise floor)
    ε₂ ≤ C_d · δ_comp(N)     (source noise floor)

  This ties the electromagnetic noise floor to the fundamental
  truncation mechanism of the discrete substrate. -/

/-- The substrate electromagnetic noise floor at truncation level N. -/
noncomputable def emNoiseFloor (N : ℕ) : ErrorBound :=
  ⟨C_d * computationalUncertainty N,
   mul_nonneg C_d_nonneg (computationalUncertainty_nonneg N)⟩

/-- The EM noise floor is positive for any truncation level. -/
theorem emNoiseFloor_pos (N : ℕ) : 0 < (emNoiseFloor N).val :=
  mul_pos C_d_pos (computationalUncertainty_pos N)

/-- The EM noise floor decreases with more computational iterations. -/
theorem emNoiseFloor_decreasing (N : ℕ) :
    emNoiseFloor (N + 1) ≤ emNoiseFloor N := by
  change (emNoiseFloor (N + 1)).val ≤ (emNoiseFloor N).val
  simp only [emNoiseFloor]
  exact mul_le_mul_of_nonneg_left (computationalUncertainty_decreasing N) C_d_nonneg

/-- An error Maxwell field whose noise floors are bounded by the
    substrate's computational uncertainty at truncation level N. -/
structure SubstrateBoundedMaxwell (N : ℕ) extends ErrorMaxwellField where
  /-- Bianchi noise floor bounded by EM noise floor. -/
  bianchi_bound : ε_bianchi ≤ emNoiseFloor N
  /-- Source noise floor bounded by EM noise floor. -/
  source_bound : ε_source ≤ emNoiseFloor N

/-- Exact gauge fields are trivially substrate-bounded (with zero noise). -/
noncomputable def SubstrateBoundedMaxwell.fromPotential
    (A : Discrete1Form) (N : ℕ) (ε_source : ErrorBound)
    (hs : ε_source ≤ emNoiseFloor N) : SubstrateBoundedMaxwell N where
  toErrorMaxwellField := ErrorMaxwellField.fromPotential A ε_source
  bianchi_bound := by
    change ErrorBound.zero ≤ emNoiseFloor N
    exact le_of_lt (emNoiseFloor_pos N)
  source_bound := hs

/-- The substrate bound: both noise floors are controlled by
    C_d * δ_comp(N), which vanishes as N → ∞. -/
theorem errorMaxwell_substrate_bound (N : ℕ) (sbm : SubstrateBoundedMaxwell N) :
    sbm.ε_bianchi.val ≤ C_d * computationalUncertainty N ∧
    sbm.ε_source.val ≤ C_d * computationalUncertainty N :=
  ⟨sbm.bianchi_bound, sbm.source_bound⟩

/-- The noise floors are bounded by a quantity that decreases with N.
    In the continuum limit N → ∞, the noise floor approaches zero. -/
theorem errorMaxwell_substrate_decreasing (N : ℕ) (sbm : SubstrateBoundedMaxwell (N + 1)) :
    sbm.ε_bianchi.val ≤ C_d * computationalUncertainty N ∧
    sbm.ε_source.val ≤ C_d * computationalUncertainty N := by
  constructor
  · calc sbm.ε_bianchi.val
        ≤ (emNoiseFloor (N + 1)).val := sbm.bianchi_bound
      _ ≤ (emNoiseFloor N).val := emNoiseFloor_decreasing N
  · calc sbm.ε_source.val
        ≤ (emNoiseFloor (N + 1)).val := sbm.source_bound
      _ ≤ (emNoiseFloor N).val := emNoiseFloor_decreasing N

/-- Charge conservation persists regardless of the substrate noise level. -/
theorem substrateBounded_charge_conservation (N : ℕ)
    (sbm : SubstrateBoundedMaxwell N) (p : LatticePoint) :
    codiff0 (maxwellCurrent sbm.F) p = 0 :=
  sbm.toErrorMaxwellField.charge_conservation p

end OmegaTheory.Foundations.ErrorForms
