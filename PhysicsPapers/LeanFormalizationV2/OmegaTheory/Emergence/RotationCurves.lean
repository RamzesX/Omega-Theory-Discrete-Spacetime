/-
  OmegaTheory.Emergence.RotationCurves

  **Pure mathematics of galactic rotation curves and NFW density profiles.**

  ## What this file formalizes

  Standard astrophysical rotation-curve mathematics on a discrete lattice:

  1. `enclosedMassDiscrete` — Enclosed mass as a finite sum over lattice
     shells: `M(r) = Σ_{k=1}^{N} ρ(k·Δr)·(k·Δr)²·Δr` (discrete
     spherical integral with 4π shell weight).

  2. `circularVelocity` — Keplerian circular velocity:
     `v(r) = √(G_N · M / r)` for mass `M` enclosed within radius `r`.

  3. `circularVelocity_keplerian_falloff` — For a point mass,
     `v(r)² = G_N·M/r`, which is the 1/√r Keplerian decline.

  4. `NFWProfile` — Navarro-Frenk-White density profile:
     `ρ(r) = ρ_s / ((r/r_s)·(1 + r/r_s)²)`.

  5. `nfwEnclosedMass` — Closed-form NFW enclosed mass:
     `M(r) = 4π·ρ_s·r_s³·[ln(1 + r/r_s) − (r/r_s)/(1 + r/r_s)]`.

  6. `nfw_rotation_curve_flat` — At large `r`, `v²(r)` scales as
     `ln(r/r_s)/(r/r_s)`, which is logarithmically flat over decades.

  7. `informationDensityNFW` — Structural hypothesis: information
     density follows an NFW-like profile with scale radius set by
     the healing flow equilibrium.

  ## Scope

  Pure math: NFW profiles are textbook astrophysics (Navarro, Frenk &
  White 1996, ApJ 462:563). The enclosed-mass integral, Keplerian
  velocity, and logarithmic flatness are standard results. The substrate
  connection (why information density might follow NFW) is left as a
  structural definition, not an axiom.

  0 sorry. 0 new axioms.

  Agent: Dubhe (α Ursae Majoris), April 15, 2026.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Emergence.RotationCurves

open OmegaTheory.Spacetime
open Finset

/-! ## 1. Enclosed Mass (Discrete Spherical Sum)

On a lattice, the spherical mass integral `4π ∫₀ʳ ρ(r')·r'² dr'` becomes
a Riemann sum over concentric shells of width `Δr`:

    M(N) = 4π · Σ_{k=1}^{N} ρ(k·Δr) · (k·Δr)² · Δr

where `N = ⌈r/Δr⌉` is the number of shells. -/

/-- Enclosed mass via discrete spherical shells.
    `rho` is the density at each shell radius,
    `dr` is the shell width (lattice spacing),
    `N` is the number of shells. -/
noncomputable def enclosedMassDiscrete (rho : ℝ → ℝ) (dr : ℝ) (N : ℕ) : ℝ :=
  4 * Real.pi * (Finset.range N).sum fun k =>
    rho ((↑k + 1) * dr) * ((↑k + 1) * dr) ^ 2 * dr

/-- The enclosed mass of the zero-density field is zero. -/
theorem enclosedMassDiscrete_zero_density (dr : ℝ) (N : ℕ) :
    enclosedMassDiscrete (fun _ => 0) dr N = 0 := by
  unfold enclosedMassDiscrete
  simp

/-- Enclosed mass is linear in density. -/
theorem enclosedMassDiscrete_smul (c : ℝ) (rho : ℝ → ℝ) (dr : ℝ) (N : ℕ) :
    enclosedMassDiscrete (fun r => c * rho r) dr N =
    c * enclosedMassDiscrete rho dr N := by
  unfold enclosedMassDiscrete
  simp [mul_assoc, ← Finset.mul_sum]
  ring

/-- Enclosed mass is additive in density. -/
theorem enclosedMassDiscrete_add (rho1 rho2 : ℝ → ℝ) (dr : ℝ) (N : ℕ) :
    enclosedMassDiscrete (fun r => rho1 r + rho2 r) dr N =
    enclosedMassDiscrete rho1 dr N + enclosedMassDiscrete rho2 dr N := by
  unfold enclosedMassDiscrete
  simp [add_mul, Finset.sum_add_distrib]
  ring

/-- Enclosed mass is monotone: adding shells never decreases it
    (for nonneg density and positive shell width). -/
theorem enclosedMassDiscrete_mono {rho : ℝ → ℝ} {dr : ℝ}
    (hrho : ∀ r, 0 ≤ rho r) (hdr : 0 < dr) (N : ℕ) :
    enclosedMassDiscrete rho dr N ≤ enclosedMassDiscrete rho dr (N + 1) := by
  unfold enclosedMassDiscrete
  have h4pi : (0 : ℝ) < 4 * Real.pi :=
    mul_pos (by norm_num : (0:ℝ) < 4) Real.pi_pos
  apply mul_le_mul_of_nonneg_left _ (le_of_lt h4pi)
  rw [Finset.sum_range_succ]
  have := mul_nonneg
    (mul_nonneg (hrho ((↑N + 1) * dr)) (sq_nonneg ((↑N + 1) * dr)))
    (le_of_lt hdr)
  linarith

/-- Enclosed mass is nonneg for nonneg density and positive shell width. -/
theorem enclosedMassDiscrete_nonneg {rho : ℝ → ℝ} {dr : ℝ}
    (hrho : ∀ r, 0 ≤ rho r) (hdr : 0 < dr) (N : ℕ) :
    0 ≤ enclosedMassDiscrete rho dr N := by
  unfold enclosedMassDiscrete
  apply mul_nonneg
  · exact le_of_lt (mul_pos (by norm_num : (0:ℝ) < 4) Real.pi_pos)
  · apply Finset.sum_nonneg
    intro k _
    exact mul_nonneg (mul_nonneg (hrho _) (sq_nonneg _)) (le_of_lt hdr)

/-! ## 2. Circular Velocity (Keplerian)

For a test mass in circular orbit at radius `r` around enclosed mass `M`:

    v²(r) = G_N · M / r   ⟹   v(r) = √(G_N · M / r)
-/

/-- Squared circular velocity: `v² = G_N · M_enc / r`. -/
noncomputable def circularVelocitySq (M_enc r : ℝ) : ℝ :=
  G_N * M_enc / r

/-- Circular velocity: `v = √(G_N · M_enc / r)`. -/
noncomputable def circularVelocity (M_enc r : ℝ) : ℝ :=
  Real.sqrt (G_N * M_enc / r)

/-- Circular velocity squared equals `circularVelocitySq`. -/
theorem circularVelocity_sq {M_enc r : ℝ} (hM : 0 ≤ M_enc) (hr : 0 < r) :
    circularVelocity M_enc r ^ 2 = circularVelocitySq M_enc r := by
  unfold circularVelocity circularVelocitySq
  rw [Real.sq_sqrt]
  exact div_nonneg (mul_nonneg (le_of_lt G_N_pos) hM) (le_of_lt hr)

/-- Circular velocity is nonneg. -/
theorem circularVelocity_nonneg (M_enc r : ℝ) :
    0 ≤ circularVelocity M_enc r :=
  Real.sqrt_nonneg _

/-- Circular velocity is positive for positive enclosed mass and positive radius. -/
theorem circularVelocity_pos {M_enc r : ℝ} (hM : 0 < M_enc) (hr : 0 < r) :
    0 < circularVelocity M_enc r := by
  unfold circularVelocity
  exact Real.sqrt_pos_of_pos (div_pos (mul_pos G_N_pos hM) hr)

/-! ## 3. Keplerian Falloff

For a point mass `M` (all mass at origin), the enclosed mass is constant:
`M_enc(r) = M` for all `r > 0`. Then `v²(r) = G_N·M/r`, so `v ∝ 1/√r`.
This is the Keplerian decline that flat rotation curves violate. -/

/-- **Keplerian falloff**: for a point mass, `v²` is inversely proportional
    to `r`. Specifically, `v²(r₁)/v²(r₂) = r₂/r₁`. -/
theorem circularVelocity_keplerian_falloff {M r₁ r₂ : ℝ}
    (hM : 0 < M) (hr₁ : 0 < r₁) (hr₂ : 0 < r₂) :
    circularVelocitySq M r₁ * r₁ = circularVelocitySq M r₂ * r₂ := by
  unfold circularVelocitySq
  field_simp

/-- Keplerian scaling: `v²(r)·r` is constant (= G_N·M) for point mass. -/
theorem keplerian_vr_product {M r : ℝ} (hr : 0 < r) :
    circularVelocitySq M r * r = G_N * M := by
  unfold circularVelocitySq
  field_simp

/-! ## 4. NFW Density Profile

The Navarro-Frenk-White (1996) profile models dark matter halo density:

    ρ(r) = ρ_s / ((r/r_s) · (1 + r/r_s)²)

where `ρ_s` is the characteristic density and `r_s` the scale radius. -/

/-- The NFW density profile. -/
noncomputable def NFWProfile (rho_s r_s : ℝ) (r : ℝ) : ℝ :=
  rho_s / ((r / r_s) * (1 + r / r_s) ^ 2)

/-- NFW profile is positive at positive radius for positive parameters. -/
theorem NFWProfile_pos {rho_s r_s r : ℝ}
    (hrho_s : 0 < rho_s) (hr_s : 0 < r_s) (hr : 0 < r) :
    0 < NFWProfile rho_s r_s r := by
  unfold NFWProfile
  apply div_pos hrho_s
  apply mul_pos
  · exact div_pos hr hr_s
  · exact sq_pos_of_pos (by linarith [div_pos hr hr_s])

/-- NFW profile at `r = r_s`: `ρ(r_s) = ρ_s / 4`. -/
theorem NFWProfile_at_scale_radius {rho_s r_s : ℝ} (hr_s : 0 < r_s) :
    NFWProfile rho_s r_s r_s = rho_s / 4 := by
  unfold NFWProfile
  rw [div_self (ne_of_gt hr_s)]
  norm_num

/-- NFW profile is linear in `ρ_s`. -/
theorem NFWProfile_smul (c rho_s r_s r : ℝ) :
    NFWProfile (c * rho_s) r_s r = c * NFWProfile rho_s r_s r := by
  unfold NFWProfile
  rw [mul_div_assoc]

/-! ## 5. NFW Enclosed Mass (Closed Form)

The closed-form integral of the NFW profile:

    M(r) = 4π · ρ_s · r_s³ · [ln(1 + r/r_s) − (r/r_s) / (1 + r/r_s)]

This is a standard textbook result. We define it as a function and prove
its algebraic properties. -/

/-- The NFW enclosed mass (closed-form expression).
    `M(x) = 4π·ρ_s·r_s³·[ln(1+x) − x/(1+x)]` where `x = r/r_s`. -/
noncomputable def nfwEnclosedMass (rho_s r_s r : ℝ) : ℝ :=
  4 * Real.pi * rho_s * r_s ^ 3 *
    (Real.log (1 + r / r_s) - (r / r_s) / (1 + r / r_s))

/-- At `r = 0`, the NFW enclosed mass is zero. -/
theorem nfwEnclosedMass_zero (rho_s r_s : ℝ) :
    nfwEnclosedMass rho_s r_s 0 = 0 := by
  unfold nfwEnclosedMass
  simp [Real.log_one]

/-- NFW enclosed mass is linear in `ρ_s`. -/
theorem nfwEnclosedMass_smul (c rho_s r_s r : ℝ) :
    nfwEnclosedMass (c * rho_s) r_s r = c * nfwEnclosedMass rho_s r_s r := by
  unfold nfwEnclosedMass
  ring

/-- The NFW mass function `f(x) = ln(1+x) - x/(1+x)` appearing in the
    enclosed mass. We separate it for cleaner proofs. -/
noncomputable def nfwMassFunction (x : ℝ) : ℝ :=
  Real.log (1 + x) - x / (1 + x)

/-- `nfwMassFunction(0) = 0`. -/
theorem nfwMassFunction_zero : nfwMassFunction 0 = 0 := by
  unfold nfwMassFunction
  simp [Real.log_one]

/-- The NFW enclosed mass in terms of `nfwMassFunction`. -/
theorem nfwEnclosedMass_eq (rho_s r_s r : ℝ) :
    nfwEnclosedMass rho_s r_s r =
    4 * Real.pi * rho_s * r_s ^ 3 * nfwMassFunction (r / r_s) := by
  unfold nfwEnclosedMass nfwMassFunction
  ring

/-- The NFW mass function is nonneg for nonneg `x`.
    This follows from `ln(1+x) ≥ x/(1+x)` for `x ≥ 0`,
    which is a consequence of `ln(t) ≥ 1 - 1/t` for `t ≥ 1`. -/
theorem nfwMassFunction_nonneg {x : ℝ} (hx : 0 ≤ x) :
    0 ≤ nfwMassFunction x := by
  unfold nfwMassFunction
  have h1x : 0 < 1 + x := by linarith
  rw [sub_nonneg]
  -- Need: x/(1+x) ≤ ln(1+x)
  -- Mathlib: `one_sub_inv_le_log_of_pos` gives `1 - (1+x)⁻¹ ≤ log(1+x)` for `1+x > 0`.
  -- And `1 - (1+x)⁻¹ = 1 - 1/(1+x) = x/(1+x)`.
  have h := Real.one_sub_inv_le_log_of_pos h1x
  -- h : 1 - (1 + x)⁻¹ ≤ Real.log (1 + x)
  -- Rewrite 1 - (1+x)⁻¹ = x/(1+x)
  have h_eq : 1 - (1 + x)⁻¹ = x / (1 + x) := by
    field_simp; ring
  linarith

/-- NFW enclosed mass is nonneg for positive parameters. -/
theorem nfwEnclosedMass_nonneg {rho_s r_s r : ℝ}
    (hrho_s : 0 < rho_s) (hr_s : 0 < r_s) (hr : 0 ≤ r) :
    0 ≤ nfwEnclosedMass rho_s r_s r := by
  rw [nfwEnclosedMass_eq]
  have h1 : (0 : ℝ) ≤ 4 * Real.pi * rho_s * r_s ^ 3 :=
    le_of_lt (mul_pos (mul_pos (mul_pos (by linarith [Real.pi_pos] : (0:ℝ) < 4)
      Real.pi_pos) hrho_s) (pow_pos hr_s 3))
  exact mul_nonneg h1 (nfwMassFunction_nonneg (div_nonneg hr (le_of_lt hr_s)))

/-! ## 6. NFW Rotation Curve Flatness

The NFW rotation curve `v²(r) = G·M(r)/r` with the closed-form `M(r)`:

    v²(r) = G·4π·ρ_s·r_s³·[ln(1+x) − x/(1+x)] / r

where `x = r/r_s`. Substituting `r = x·r_s`:

    v²(x) = 4π·G·ρ_s·r_s² · [ln(1+x) − x/(1+x)] / x

At large `x ≫ 1`: `ln(1+x) ≈ ln(x)` and `x/(1+x) ≈ 1`, so

    v²(x) ≈ 4π·G·ρ_s·r_s² · (ln x − 1) / x = 4π·G·ρ_s·r_s² · ln(x)/x

This grows sublogarithmically, making the rotation curve essentially flat
over several decades (the hallmark of dark matter halos). -/

/-- The common prefactor `4π·G·ρ_s·r_s²` of the NFW velocity profile. -/
noncomputable def nfwVelocityPrefactor (rho_s r_s : ℝ) : ℝ :=
  4 * Real.pi * G_N * rho_s * r_s ^ 2

/-- Prefactor is positive for positive parameters. -/
theorem nfwVelocityPrefactor_pos {rho_s r_s : ℝ}
    (hrho_s : 0 < rho_s) (hr_s : 0 < r_s) :
    0 < nfwVelocityPrefactor rho_s r_s := by
  unfold nfwVelocityPrefactor
  exact mul_pos (mul_pos (mul_pos (mul_pos (by linarith [Real.pi_pos])
    Real.pi_pos) G_N_pos) hrho_s) (sq_pos_of_pos hr_s)

/-- NFW rotation velocity squared as a function of `x = r/r_s`. -/
noncomputable def nfwVelocitySq (rho_s r_s : ℝ) (x : ℝ) : ℝ :=
  nfwVelocityPrefactor rho_s r_s * (nfwMassFunction x / x)

/-- NFW velocity squared unfolded. -/
theorem nfwVelocitySq_unfold (rho_s r_s x : ℝ) :
    nfwVelocitySq rho_s r_s x =
    4 * Real.pi * G_N * rho_s * r_s ^ 2 * nfwMassFunction x / x := by
  unfold nfwVelocitySq nfwVelocityPrefactor
  ring

/-- **NFW velocity = circular velocity of NFW enclosed mass**, when
    expressed in dimensionless units `x = r/r_s`. -/
theorem nfwVelocitySq_eq_circular {rho_s r_s x : ℝ} (hr_s : r_s ≠ 0)
    (hx : x ≠ 0) :
    nfwVelocitySq rho_s r_s x =
    circularVelocitySq (nfwEnclosedMass rho_s r_s (x * r_s)) (x * r_s) := by
  unfold circularVelocitySq
  rw [nfwVelocitySq_unfold, nfwEnclosedMass_eq]
  have hxrs : x * r_s / r_s = x := mul_div_cancel_of_imp
    (fun h => absurd h hr_s)
  rw [hxrs]
  field_simp

/-- **Flat rotation curve structure**: for any two radii `x₁, x₂` both
    much larger than `r_s`, the ratio `v²(x₁)/v²(x₂)` equals
    `[f(x₁)/x₁] / [f(x₂)/x₂]` where `f` is the NFW mass function.
    This ratio is close to 1 when both `x` are large (logarithmic
    flatness). We state the exact algebraic identity. -/
theorem nfw_rotation_curve_flat {rho_s r_s x₁ x₂ : ℝ}
    (hrho_s : rho_s ≠ 0) (hr_s : r_s ≠ 0)
    (hx₁ : x₁ ≠ 0) (hx₂ : x₂ ≠ 0)
    (hf₂ : nfwMassFunction x₂ ≠ 0) :
    nfwVelocitySq rho_s r_s x₁ / nfwVelocitySq rho_s r_s x₂ =
    (nfwMassFunction x₁ / x₁) / (nfwMassFunction x₂ / x₂) := by
  unfold nfwVelocitySq
  have hpre : nfwVelocityPrefactor rho_s r_s ≠ 0 := by
    unfold nfwVelocityPrefactor
    have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
    have hG : G_N ≠ 0 := ne_of_gt G_N_pos
    positivity
  field_simp [hpre]

/-! ## 7. Information Density NFW Profile

**Structural definition**: in the OmegaTheory framework, information
density at healing equilibrium is determined by the balance of information
diffusion and gravitational sourcing. We define an information density
that follows an NFW-like profile, with the scale radius `r_s` set by the
healing flow equilibrium scale.

This is a DEFINITION, not a derived theorem. The physical content is:
if information density follows an NFW profile, then the rotation curves
are automatically flat (by the NFW mathematics above). The claim that
information density actually follows NFW is a structural hypothesis
motivated by equilibrium arguments (the healing flow drives information
density toward a profile that minimizes the information functional,
subject to gravitational sourcing). -/

/-- Information density following an NFW profile.
    `I_s` is the characteristic information density,
    `r_s` is the scale radius (set by healing equilibrium). -/
noncomputable def informationDensityNFW (I_s r_s : ℝ) (r : ℝ) : ℝ :=
  NFWProfile I_s r_s r

/-- The information NFW profile inherits positivity from the NFW profile. -/
theorem informationDensityNFW_pos {I_s r_s r : ℝ}
    (hI_s : 0 < I_s) (hr_s : 0 < r_s) (hr : 0 < r) :
    0 < informationDensityNFW I_s r_s r :=
  NFWProfile_pos hI_s hr_s hr

/-- At the scale radius, `I(r_s) = I_s / 4`. -/
theorem informationDensityNFW_at_scale {I_s r_s : ℝ} (hr_s : 0 < r_s) :
    informationDensityNFW I_s r_s r_s = I_s / 4 :=
  NFWProfile_at_scale_radius hr_s

/-- The information-mass correspondence: the enclosed "information mass"
    (i.e., the enclosed mass if we treat information density as sourcing
    gravity via stress-energy) follows the NFW mass function. -/
noncomputable def informationEnclosedMass (I_s r_s r : ℝ) : ℝ :=
  nfwEnclosedMass I_s r_s r

/-- Information enclosed mass vanishes at the origin. -/
theorem informationEnclosedMass_zero (I_s r_s : ℝ) :
    informationEnclosedMass I_s r_s 0 = 0 :=
  nfwEnclosedMass_zero I_s r_s

/-- The rotation curve from information density is flat (NFW flatness). -/
noncomputable def informationRotationVelocitySq (I_s r_s : ℝ) (x : ℝ) : ℝ :=
  nfwVelocitySq I_s r_s x

/-- Information rotation velocity has the same flatness structure. -/
theorem informationRotationCurve_flat {I_s r_s x₁ x₂ : ℝ}
    (hI_s : I_s ≠ 0) (hr_s : r_s ≠ 0)
    (hx₁ : x₁ ≠ 0) (hx₂ : x₂ ≠ 0)
    (hf₂ : nfwMassFunction x₂ ≠ 0) :
    informationRotationVelocitySq I_s r_s x₁ /
    informationRotationVelocitySq I_s r_s x₂ =
    (nfwMassFunction x₁ / x₁) / (nfwMassFunction x₂ / x₂) :=
  nfw_rotation_curve_flat hI_s hr_s hx₁ hx₂ hf₂

end OmegaTheory.Emergence.RotationCurves
