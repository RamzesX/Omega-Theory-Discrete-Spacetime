/-
  OmegaTheory.Emergence.SpecialRelativity

  Lorentz factor from reshaping of the lattice propagation
  probability.

  Physical narrative.  On the discrete Planck-scale lattice, an
  electron of rest mass `m` and momentum `p` has its update
  probability *reshaped*: a fraction of lattice ticks push the
  configuration forward, while the remainder feed transverse
  oscillation (zitterbewegung).  The forward drift per tick is
  `p·c² / E` where `E = √((pc)² + (mc²)²)` is the total relativistic
  energy.  Hence the emergent effective velocity is

      v_eff(p, m) = p·c² / √((pc)² + (mc²)²)
                  = c / √(1 + (mc / p)²)      (p > 0)

  giving `v → c` at high momentum (all ticks go forward, photon
  limit) and `v → 0` as `p → 0` (all ticks into oscillation).

  No new axioms — just the Planck-scale constants of
  `Spacetime.Constants` together with elementary real analysis.
-/

import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Relativistic energy and velocity -/

/-- Relativistic total energy of a particle of momentum `p` and
    rest mass `m`:  `E(p, m) = √((pc)² + (mc²)²)`. -/
noncomputable def relativisticEnergy (p m : ℝ) : ℝ :=
  Real.sqrt ((p * c) ^ 2 + (m * c ^ 2) ^ 2)

/-- Relativistic (emergent) velocity of a particle of momentum `p`
    and rest mass `m`:  `v(p, m) = p·c² / E(p, m)`. -/
noncomputable def relativisticVelocity (p m : ℝ) : ℝ :=
  p * c ^ 2 / relativisticEnergy p m

/-! ## Non-negativity of relativistic energy -/

/-- The squared energy is non-negative (sum of squares). -/
theorem relativisticEnergy_sq_nonneg (p m : ℝ) :
    0 ≤ (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
  add_nonneg (sq_nonneg _) (sq_nonneg _)

/-- The total energy is non-negative. -/
theorem relativisticEnergy_nonneg (p m : ℝ) : 0 ≤ relativisticEnergy p m :=
  Real.sqrt_nonneg _

/-- At zero momentum the energy is the rest energy `|m|·c²`. -/
theorem relativisticEnergy_zero_mom (m : ℝ) :
    relativisticEnergy 0 m = |m| * c ^ 2 := by
  unfold relativisticEnergy
  rw [zero_mul, zero_pow (by norm_num : (2 : ℕ) ≠ 0), zero_add]
  rw [show (m * c ^ 2) ^ 2 = (m * c ^ 2)^2 from rfl]
  rw [Real.sqrt_sq_eq_abs, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ c ^ 2)]

/-- At zero momentum and positive mass the emergent velocity is zero. -/
@[simp] theorem relativisticVelocity_zero_mom (m : ℝ) :
    relativisticVelocity 0 m = 0 := by
  unfold relativisticVelocity
  simp

/-! ## Energy positivity for non-trivial particles -/

/-- Energy is positive if rest mass is non-zero. -/
theorem relativisticEnergy_pos_of_mass {m : ℝ} (hm : m ≠ 0) (p : ℝ) :
    0 < relativisticEnergy p m := by
  unfold relativisticEnergy
  apply Real.sqrt_pos.mpr
  have h1 : 0 < (m * c ^ 2) ^ 2 := by
    apply sq_pos_of_ne_zero
    exact mul_ne_zero hm (pow_ne_zero _ c_pos.ne')
  linarith [sq_nonneg (p * c)]

/-- Energy is positive if momentum is non-zero. -/
theorem relativisticEnergy_pos_of_momentum {p : ℝ} (hp : p ≠ 0) (m : ℝ) :
    0 < relativisticEnergy p m := by
  unfold relativisticEnergy
  apply Real.sqrt_pos.mpr
  have h1 : 0 < (p * c) ^ 2 := by
    apply sq_pos_of_ne_zero
    exact mul_ne_zero hp c_pos.ne'
  linarith [sq_nonneg (m * c ^ 2)]

/-! ## Upper bound: `v ≤ c`

The emergent velocity never exceeds the speed of light; the "mass
term" `(mc²)²` in the denominator always slows the electron down. -/

/-- Pythagorean bound: `(pc)² ≤ E²`. -/
theorem sq_p_c_le_relativisticEnergy_sq (p m : ℝ) :
    (p * c) ^ 2 ≤ (relativisticEnergy p m) ^ 2 := by
  unfold relativisticEnergy
  rw [Real.sq_sqrt (relativisticEnergy_sq_nonneg p m)]
  linarith [sq_nonneg (m * c ^ 2)]

/-- Root form: `|pc| ≤ E`. -/
theorem abs_p_c_le_relativisticEnergy (p m : ℝ) :
    |p * c| ≤ relativisticEnergy p m := by
  rw [← Real.sqrt_sq_eq_abs,
      ← Real.sqrt_sq (relativisticEnergy_nonneg p m)]
  exact Real.sqrt_le_sqrt (sq_p_c_le_relativisticEnergy_sq p m)

/-- For non-negative momentum, `pc ≤ E`. -/
theorem p_c_le_relativisticEnergy {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    p * c ≤ relativisticEnergy p m := by
  have h := abs_p_c_le_relativisticEnergy p m
  rwa [abs_of_nonneg (mul_nonneg hp c_pos.le)] at h

/-- Upper speed-of-light bound for non-negative momentum. -/
theorem relativisticVelocity_le_c {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    relativisticVelocity p m ≤ c := by
  by_cases hE : relativisticEnergy p m = 0
  · unfold relativisticVelocity
    rw [hE, div_zero]
    exact c_pos.le
  have hEpos : 0 < relativisticEnergy p m :=
    lt_of_le_of_ne (relativisticEnergy_nonneg p m) (Ne.symm hE)
  unfold relativisticVelocity
  rw [div_le_iff₀ hEpos]
  have hpc : p * c ≤ relativisticEnergy p m := p_c_le_relativisticEnergy hp m
  nlinarith [hpc, c_pos, mul_le_mul_of_nonneg_right hpc c_pos.le]

/-! ## Strict sub-luminality for massive particles

Any particle with non-zero rest mass moves strictly slower than `c`.
The mass term `(mc²)²` in the denominator under the root is what
enforces the inequality. -/

/-- Strict Pythagorean inequality: `(pc)² < E²` when `m ≠ 0`. -/
theorem sq_p_c_lt_relativisticEnergy_sq {m : ℝ} (hm : m ≠ 0) (p : ℝ) :
    (p * c) ^ 2 < (relativisticEnergy p m) ^ 2 := by
  unfold relativisticEnergy
  rw [Real.sq_sqrt (relativisticEnergy_sq_nonneg p m)]
  have : 0 < (m * c ^ 2) ^ 2 :=
    sq_pos_of_ne_zero (mul_ne_zero hm (pow_ne_zero _ c_pos.ne'))
  linarith

/-- Strict root form: `|pc| < E` when `m ≠ 0`. -/
theorem abs_p_c_lt_relativisticEnergy {m : ℝ} (hm : m ≠ 0) (p : ℝ) :
    |p * c| < relativisticEnergy p m := by
  rw [← Real.sqrt_sq_eq_abs,
      ← Real.sqrt_sq (relativisticEnergy_nonneg p m)]
  exact Real.sqrt_lt_sqrt (sq_nonneg _) (sq_p_c_lt_relativisticEnergy_sq hm p)

/-- For positive momentum and non-zero mass, `pc < E` strictly. -/
theorem p_c_lt_relativisticEnergy {m : ℝ} (hm : m ≠ 0) {p : ℝ} (hp : 0 < p) :
    p * c < relativisticEnergy p m := by
  have h := abs_p_c_lt_relativisticEnergy hm p
  rwa [abs_of_pos (mul_pos hp c_pos)] at h

/-- Strict speed-of-light bound for massive particles at positive momentum. -/
theorem relativisticVelocity_lt_c {m : ℝ} (hm : m ≠ 0) {p : ℝ} (hp : 0 < p) :
    relativisticVelocity p m < c := by
  have hEpos : 0 < relativisticEnergy p m := relativisticEnergy_pos_of_mass hm p
  unfold relativisticVelocity
  rw [div_lt_iff₀ hEpos]
  have hpc : p * c < relativisticEnergy p m := p_c_lt_relativisticEnergy hm hp
  nlinarith [hpc, c_pos, mul_lt_mul_of_pos_right hpc c_pos]

/-! ## Photon limit: `v = c` when `m = 0`

In the massless case the inequality saturates — every lattice tick
contributes to forward motion. -/

/-- Total energy of a massless particle is `|p|·c`. -/
theorem relativisticEnergy_massless (p : ℝ) :
    relativisticEnergy p 0 = |p| * c := by
  unfold relativisticEnergy
  rw [zero_mul, zero_pow (by norm_num : (2 : ℕ) ≠ 0), add_zero,
      Real.sqrt_sq_eq_abs, abs_mul, abs_of_pos c_pos]

/-- A massless particle with positive momentum moves at exactly `c`. -/
theorem relativisticVelocity_massless {p : ℝ} (hp : 0 < p) :
    relativisticVelocity p 0 = c := by
  unfold relativisticVelocity
  rw [relativisticEnergy_massless, abs_of_pos hp]
  have hp_ne : p ≠ 0 := hp.ne'
  have hc_ne : c ≠ 0 := c_pos.ne'
  field_simp

/-! ## Equivalent inverse form  `v = c / √(1 + (mc/p)²)`

Factoring `(pc)²` out from under the root puts the Pythagorean
expression in the form that appears in textbook presentations of
special relativity.  The two forms are mathematically equivalent
for `p > 0`. -/

/-- Factorisation of the relativistic energy for positive momentum:
    `E = pc · √(1 + (mc/p)²)`. -/
theorem relativisticEnergy_factored {p : ℝ} (hp : 0 < p) (m : ℝ) :
    relativisticEnergy p m = p * c * Real.sqrt (1 + (m * c / p) ^ 2) := by
  unfold relativisticEnergy
  have hp_ne : p ≠ 0 := hp.ne'
  have hpc_pos : 0 < p * c := mul_pos hp c_pos
  have hfactor : (p * c) ^ 2 + (m * c ^ 2) ^ 2
      = (p * c) ^ 2 * (1 + (m * c / p) ^ 2) := by
    field_simp
  rw [hfactor, Real.sqrt_mul (sq_nonneg _), Real.sqrt_sq hpc_pos.le]

/-- Inverse form of the velocity: `v(p,m) = c / √(1 + (mc/p)²)` for `p > 0`. -/
theorem relativisticVelocity_inverse_form {p : ℝ} (hp : 0 < p) (m : ℝ) :
    relativisticVelocity p m = c / Real.sqrt (1 + (m * c / p) ^ 2) := by
  unfold relativisticVelocity
  rw [relativisticEnergy_factored hp]
  have hp_ne : p ≠ 0 := hp.ne'
  have hc_ne : c ≠ 0 := c_pos.ne'
  have hsqrt_pos : 0 < Real.sqrt (1 + (m * c / p) ^ 2) := by
    apply Real.sqrt_pos.mpr
    positivity
  have hsqrt_ne : Real.sqrt (1 + (m * c / p) ^ 2) ≠ 0 := hsqrt_pos.ne'
  field_simp

/-! ## Lorentz factor

Standard dimensionless amplification γ(v) = 1/√(1 − (v/c)²).  It is
defined for any real `v`; the physical regime is `|v| < c`, where
`γ ≥ 1` and `γ = 1` precisely at rest. -/

/-- Lorentz factor `γ(v) = 1 / √(1 − (v/c)²)`. -/
noncomputable def lorentzFactor (v : ℝ) : ℝ :=
  1 / Real.sqrt (1 - (v / c) ^ 2)

/-- At rest, `γ = 1`. -/
@[simp] theorem lorentzFactor_zero : lorentzFactor 0 = 1 := by
  unfold lorentzFactor
  rw [zero_div, zero_pow (by norm_num : (2 : ℕ) ≠ 0), sub_zero,
      Real.sqrt_one, div_one]

/-- For sub-luminal speeds, the Lorentz-factor denominator is positive. -/
theorem lorentzFactor_denom_pos {v : ℝ} (hv : |v| < c) :
    0 < 1 - (v / c) ^ 2 := by
  have hc_sq_pos : 0 < c ^ 2 := pow_pos c_pos 2
  have hv_sq : v ^ 2 < c ^ 2 :=
    sq_lt_sq' (neg_lt_of_abs_lt hv) (lt_of_abs_lt hv)
  have : (v / c) ^ 2 < 1 := by
    rw [div_pow]
    exact (div_lt_one hc_sq_pos).mpr hv_sq
  linarith

/-- The Lorentz factor is positive for sub-luminal speeds. -/
theorem lorentzFactor_pos {v : ℝ} (hv : |v| < c) : 0 < lorentzFactor v := by
  unfold lorentzFactor
  exact div_pos (by norm_num) (Real.sqrt_pos.mpr (lorentzFactor_denom_pos hv))

/-- The Lorentz factor is at least 1 for sub-luminal speeds. -/
theorem lorentzFactor_ge_one {v : ℝ} (hv : |v| < c) : 1 ≤ lorentzFactor v := by
  unfold lorentzFactor
  have h_denom : 0 < 1 - (v / c) ^ 2 := lorentzFactor_denom_pos hv
  have h_sqrt_pos : 0 < Real.sqrt (1 - (v / c) ^ 2) := Real.sqrt_pos.mpr h_denom
  have h_sqrt_le : Real.sqrt (1 - (v / c) ^ 2) ≤ 1 := by
    rw [show (1 : ℝ) = Real.sqrt 1 from Real.sqrt_one.symm]
    exact Real.sqrt_le_sqrt (by nlinarith [sq_nonneg (v / c)])
  calc (1 : ℝ) = 1 / 1 := (div_one 1).symm
    _ ≤ 1 / Real.sqrt (1 - (v / c) ^ 2) :=
        one_div_le_one_div_of_le h_sqrt_pos h_sqrt_le

/-! ## The Einstein identity `E · √(1 − (v/c)²) = mc²`

This is the core identity linking the relativistic energy, the
emergent velocity, and the rest energy.  Squared, it reduces to the
Pythagorean mass-shell relation `E² = (pc)² + (mc²)²`.  The form
stated here avoids dividing by `√(1 − (v/c)²)` and so works without
needing to establish `|v| < c` separately. -/

/-- Squared energy equals `(pc)² + (mc²)²` (mass-shell relation). -/
theorem relativisticEnergy_sq_eq (p m : ℝ) :
    (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 := by
  unfold relativisticEnergy
  rw [Real.sq_sqrt (relativisticEnergy_sq_nonneg p m)]

/-- Explicit formula for `(v/c)²`: `(v/c)² = (pc)² / E²`. -/
theorem v_over_c_sq_eq {m : ℝ} (hm : 0 < m) (p : ℝ) :
    (relativisticVelocity p m / c) ^ 2
      = (p * c) ^ 2 / (relativisticEnergy p m) ^ 2 := by
  have hm_ne : m ≠ 0 := hm.ne'
  have hc_ne : c ≠ 0 := c_pos.ne'
  have hE_ne : relativisticEnergy p m ≠ 0 :=
    (relativisticEnergy_pos_of_mass hm_ne p).ne'
  unfold relativisticVelocity
  field_simp

/-- Explicit formula for `1 − (v/c)²`: `(mc²)² / E²`. -/
theorem one_minus_vc_sq_eq {m : ℝ} (hm : 0 < m) (p : ℝ) :
    1 - (relativisticVelocity p m / c) ^ 2
      = (m * c ^ 2) ^ 2 / (relativisticEnergy p m) ^ 2 := by
  have hm_ne : m ≠ 0 := hm.ne'
  have hE_ne : relativisticEnergy p m ≠ 0 :=
    (relativisticEnergy_pos_of_mass hm_ne p).ne'
  have hE_sq : (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
    relativisticEnergy_sq_eq p m
  rw [v_over_c_sq_eq hm]
  rw [show (1 : ℝ) - (p * c) ^ 2 / (relativisticEnergy p m) ^ 2
        = ((relativisticEnergy p m) ^ 2 - (p * c) ^ 2) / (relativisticEnergy p m) ^ 2
        from by field_simp]
  congr 1
  linarith [hE_sq]

/-- `√(1 − (v/c)²) = mc² / E`. -/
theorem sqrt_one_minus_vc_sq_eq {m : ℝ} (hm : 0 < m) (p : ℝ) :
    Real.sqrt (1 - (relativisticVelocity p m / c) ^ 2)
      = m * c ^ 2 / relativisticEnergy p m := by
  have hmcsq_pos : 0 < m * c ^ 2 := mul_pos hm (pow_pos c_pos 2)
  have hm_ne : m ≠ 0 := hm.ne'
  have hE_pos : 0 < relativisticEnergy p m := relativisticEnergy_pos_of_mass hm_ne p
  rw [one_minus_vc_sq_eq hm,
      show ((m * c ^ 2) ^ 2 / (relativisticEnergy p m) ^ 2 : ℝ)
        = ((m * c ^ 2) / relativisticEnergy p m) ^ 2 from by rw [div_pow]]
  exact Real.sqrt_sq (div_nonneg hmcsq_pos.le hE_pos.le)

/-- Einstein identity (un-divided form): `E · √(1 − (v/c)²) = mc²`. -/
theorem einstein_energy_momentum {m : ℝ} (hm : 0 < m) (p : ℝ) :
    relativisticEnergy p m * Real.sqrt (1 - (relativisticVelocity p m / c) ^ 2)
      = m * c ^ 2 := by
  have hm_ne : m ≠ 0 := hm.ne'
  have hE_ne : relativisticEnergy p m ≠ 0 :=
    (relativisticEnergy_pos_of_mass hm_ne p).ne'
  rw [sqrt_one_minus_vc_sq_eq hm]
  field_simp

/-- Lorentz factor in terms of energy:  `γ(v) = E / (mc²)` for `m > 0`. -/
theorem lorentzFactor_of_relativisticVelocity {m : ℝ} (hm : 0 < m) (p : ℝ) :
    lorentzFactor (relativisticVelocity p m)
      = relativisticEnergy p m / (m * c ^ 2) := by
  unfold lorentzFactor
  rw [sqrt_one_minus_vc_sq_eq hm]
  rw [one_div_div]

end OmegaTheory.Emergence
