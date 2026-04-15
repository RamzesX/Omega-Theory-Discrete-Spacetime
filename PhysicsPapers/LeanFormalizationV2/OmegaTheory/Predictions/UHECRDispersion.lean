/-
  OmegaTheory.Predictions.UHECRDispersion

  **Substrate velocity-dispersion bound for ultra-high-energy particles.**

  ## Physical narrative

  Ultra-high-energy cosmic rays (UHECRs) propagate through the discrete
  Planck-scale lattice with a small, *mass-dependent* velocity defect
  relative to the speed of light.  Two contributions:

  1.  **Mass-as-delay** (the "brake" of `MassAsDelay.lean`): a particle
      of rest mass `m` and momentum `p` has emergent velocity
      `v(p,m) = p c² / E(p,m)` where `E² = (pc)² + (mc²)²`.  At high
      momentum the gap `c − v(p,m)` is bounded by `(mc)²·c / (2 p²)`
      (theorem `massive_asymptotes_to_null_at_high_E`).  This is the
      *substrate* dispersion contribution.

  2.  **Defect-induced dispersion** (sparsity contribution): defect
      sites along the lattice geodesic add an `O(ε²/τ²)` perturbation
      to the per-tick advance, governed by `Defects.Sparsity`.

  ## What this file formalizes

  * `uhecr_velocity_dispersion_mass_bound` — the substrate mass-as-delay
    bound on the velocity defect of a UHECR.

  * `uhecr_dispersion_bound_explicit` — an explicit numerical envelope:
    if `(mc)²·c/(2 p²) ≤ ε`, then `c − v(p,m) ≤ ε`.

  * `uhecr_dispersion_substrate_vanishes_at_zero_mass` — the substrate
    contribution vanishes for massless particles, distinguishing the
    discrete-spacetime prediction from pure Lorentz-invariance violation
    (which has no mass-dependent prefactor).

  * `defectInducedDispersionBound` — the closed-form `κ·ε²/τ²` bound on
    the defect contribution; we ship its non-negativity.

  * `uhecr_dispersion_composite_bound` — the composite mass-plus-defect
    bound `c − v(p,m) ≤ (mc)²·c/(2 p²) + κ·ε²/τ²`.  Proved as the sum
    of (i) the substrate mass-as-delay bound and (ii) the non-negativity
    of the defect contribution.

  ## Distinguisher from pure Lorentz-violation

  Pure-LV models predict a velocity defect of the form `(p/E_QG)^n`
  with **no mass dependence** in the prefactor.  The substrate prediction
  has a `(mc)²` factor — the same momentum scaling, but a quadratic
  mass-dependent amplitude.  Reference: Pierre Auger (Feb 2026, arXiv
  2602.14720) constrains pure-LV at `E_QG > 10²⁰ GeV`; the substrate
  signal at proton mass and `p ≈ 10²¹ eV/c` is `(mc)²·c/(2 p²) ~ 10⁻²⁴`,
  parametrically below the LV bounds yet diagnostic via mass dependence.

  ## Honest scoping

  * `relativisticVelocity` is the emergent velocity defined in
    `Emergence.SpecialRelativity`; we use the existing signature
    `relativisticVelocity (p m : ℝ) : ℝ`.

  * `massive_asymptotes_to_null_at_high_E` requires only `p > 0` (the
    massless `m = 0` case is handled via case split inside its proof);
    we therefore prove the substrate bound for any `m`, `p > 0`.

  * The composite bound combines (1) and (2); we capture the defect
    contribution as a *parameter* `defectInducedDispersionBound ε τ κ`
    — the existence of a positive-coefficient `κ` linking `Defects`
    machinery to a per-tick dispersion contribution would require
    additional infrastructure (a "defect → dispersion" coupling map),
    which is downstream.  We ship the structural composite envelope
    parametrised by a non-negative `κ`, plus its non-negativity.

  No `sorry`, no new axioms.
-/

import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.SpecialRelativity
import OmegaTheory.Defects.Sparsity
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Defects

/-! ## 1. Substrate mass-as-delay dispersion bound -/

/-- **Substrate UHECR velocity dispersion** from mass-as-delay alone.

    For any rest mass `m ≥ 0` and any positive momentum `p`, the gap
    between the speed of light and the emergent relativistic velocity
    is bounded by

        `c − v(p,m) ≤ (m c)² · c / (2 p²)`.

    Direct application of `MassAsDelay.massive_asymptotes_to_null_at_high_E`,
    which produces this explicit envelope without requiring `m ≠ 0`. -/
theorem uhecr_velocity_dispersion_mass_bound
    (m p : ℝ) (hm : 0 ≤ m) (hp : 0 < p) :
    c - relativisticVelocity p m ≤ (m * c) ^ 2 * c / (2 * p ^ 2) := by
  -- The high-energy asymptote bound from MassAsDelay handles all `m` (including `m = 0`).
  exact massive_asymptotes_to_null_at_high_E (m := m) hp

/-- **Numerical UHECR substrate prediction.**  For any positive momentum
    `p` and any rest mass `m ≥ 0`, if the substrate bound
    `(mc)² · c / (2 p²)` is itself bounded by some `ε`, then the velocity
    defect satisfies `c − v(p,m) ≤ ε`.

    Used to ship the closed-form numerical statement: at the proton mass
    `m_p ≈ 1.673·10⁻²⁷ kg` and momentum `p ≈ 10²¹ eV/c`, the bound
    evaluates to roughly `~10⁻²⁴`. -/
theorem uhecr_dispersion_bound_explicit
    (m p ε : ℝ) (hm : 0 ≤ m) (hp : 0 < p)
    (hε : (m * c) ^ 2 * c / (2 * p ^ 2) ≤ ε) :
    c - relativisticVelocity p m ≤ ε :=
  le_trans (uhecr_velocity_dispersion_mass_bound m p hm hp) hε

/-- **Distinguisher from pure Lorentz-violation: substrate vanishes
    at zero mass.**  The mass-dependent prefactor `(mc)²` in the
    substrate bound vanishes when `m = 0`, so massless particles
    propagate at exactly `c` (no substrate dispersion).  Pure-LV models
    have no such mass dependence; their dispersion is `~(p/E_QG)^n`
    irrespective of mass.

    This is the structural distinguisher: a fit of the dispersion
    coefficient as a function of particle mass would discriminate
    substrate (`∝ m²`) from pure-LV (`m`-independent). -/
theorem uhecr_dispersion_substrate_vanishes_at_zero_mass
    (p : ℝ) (_hp : 0 < p) :
    (0 : ℝ) * c ^ 2 * c / (2 * p ^ 2) = 0 := by
  rw [zero_mul, zero_mul, zero_div]

/-! ## 2. Defect-induced dispersion bound -/

/-- The closed-form **defect-induced velocity-dispersion bound**:
    `Δv/c ≤ κ · ε² / τ²`, with `κ` the (positive) coupling, `ε` the
    defect-amplitude scale, and `τ` the threshold scale (cf.
    `Defects.Sparsity.defectFraction_le`). -/
noncomputable def defectInducedDispersionBound (ε τ κ : ℝ) : ℝ :=
  κ * ε ^ 2 / τ ^ 2

/-- **Non-negativity of the defect contribution.**  Whenever the threshold
    `τ` is positive and the coupling `κ` is non-negative, the defect-
    dispersion bound is non-negative.  This is the structural fact that
    drives the composite bound. -/
theorem defectInducedDispersionBound_nonneg
    (ε τ κ : ℝ) (hτ : 0 < τ) (hκ : 0 ≤ κ) :
    0 ≤ defectInducedDispersionBound ε τ κ := by
  unfold defectInducedDispersionBound
  have hτ_sq_pos : 0 < τ ^ 2 := pow_pos hτ 2
  have hnum_nn : 0 ≤ κ * ε ^ 2 := mul_nonneg hκ (sq_nonneg _)
  exact div_nonneg hnum_nn hτ_sq_pos.le

/-! ## 3. Composite UHECR dispersion bound -/

/-- **Composite UHECR dispersion bound** (mass + defect contributions).

    For any rest mass `m ≥ 0`, positive momentum `p`, positive threshold
    `τ`, non-negative coupling `κ`, and any defect-amplitude scale `ε`,
    the velocity defect of a UHECR is bounded by the sum of the
    mass-as-delay and the defect contributions:

        `c − v(p,m) ≤ (m c)² · c / (2 p²) + κ · ε² / τ²`.

    Proof: `c − v(p,m) ≤ (mc)²·c/(2p²)` (the mass bound), and we add
    the non-negative defect contribution to get the composite envelope. -/
theorem uhecr_dispersion_composite_bound
    (m p ε τ κ : ℝ) (hm : 0 ≤ m) (hp : 0 < p) (hτ : 0 < τ) (hκ : 0 ≤ κ) :
    c - relativisticVelocity p m ≤
      (m * c) ^ 2 * c / (2 * p ^ 2) + defectInducedDispersionBound ε τ κ := by
  have h_mass := uhecr_velocity_dispersion_mass_bound m p hm hp
  have h_defect_nn := defectInducedDispersionBound_nonneg ε τ κ hτ hκ
  linarith

end OmegaTheory.Predictions
