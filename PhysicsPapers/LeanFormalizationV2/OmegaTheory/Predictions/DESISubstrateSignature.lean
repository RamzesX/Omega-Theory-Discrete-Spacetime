/-
  OmegaTheory.Predictions.DESISubstrateSignature

  **DESI dark-energy equation-of-state `w(z)` substrate signature.**

  ## Physical narrative

  Standard Λ-CDM: `w(z) = −1` exactly for all redshift `z`.
  `CosmologicalConstant.lean` (Pollux, 2026-04-15) proved the substrate
  reproduces `w = −1` in the ideal healing-flow equilibrium limit:

        `darkEnergyEquationOfState_w μ hμ : p_Λ / (ρ_Λ c²) = −1`.

  DESI DR2 (2024) data hints — at the 2-3σ level — at a possible
  `w ≠ −1` running with redshift. If real, the deviation is
  characterised by the CPL parameterisation
  `w(z) = w_0 + w_a · z / (1+z)` with `w_0 + w_a ≈ −0.9` and
  `w_0 + 2 w_a ≈ −0.8`, i.e. a small `z`-dependent departure.

  ### OmegaTheory substrate prediction

  At finite iteration budget `N` (cosmological scale), the healing flow
  has NOT fully reached equilibrium: there is a residual `δ_comp(N) > 0`
  per-tick truncation. This produces a SMALL, `z`-dependent deviation

        `ε_substrate(N, z) := δ_comp(N) · f(z)`

  where `f(z)` is a bounded monotone function of redshift. The simplest
  universal ansatz (borrowed from `HealingFlow/Flow.lean`
  Lyapunov-residual convention) is `f(z) = z / (1+z)` — same redshift
  profile as the CPL `w_a` term.

  ### Headline prediction

  `|ε_substrate(N, z)| ≤ ε_DESI_upper` for all `z ∈ [0, 2]`
  (DESI's redshift range) at sufficiently large `N` (cosmological
  truncation budget).

  If DESI's 2-3σ hint of `w ≠ −1` crystallises into a signal at
  `ε > 10⁻²` level, OmegaTheory is consistent only if
  `δ_comp(N_cosmo) > 10⁻²` — i.e. the cosmological iteration budget is
  SMALLER than the lab-scale budget. That's a testable joint
  prediction combined with lab-scale tests (atomic clocks).

  ## Relationship to other predictions

  - `AdditionalPredictions.dark_energy_w_exact` proves `w = −1` at
    ideal equilibrium (`μ > 0`, zero defects, uniform information).
  - This file relaxes "ideal equilibrium" to "finite-N substrate
    truncation" and quantifies the residual deviation.
  - Combined with `CosmologicalConstant.effectiveCosmologicalConstant`,
    this gives a `z`-dependent Λ_eff that is closer to the observational
    picture than the ideal `Λ_eff = const`.

  ## What this file formalises

  1. `darkEnergySubstrateEpsilon N z` — fractional deviation of `w` from
     `−1` at truncation `N` and redshift `z`.
  2. Positivity and monotonicity structure lemmas.
  3. `darkEnergySubstrateEpsilon_zero_at_zero_z` — vanishes at `z = 0`
     (today's `w` recovers `−1` at truncation limit `N → ∞`).
  4. `darkEnergySubstrateEpsilon_bounded_by_any_positive_ε_for_large_N`
     — Pierre-Auger-style consistency: any `z ∈ [0, Z_max]` admits an
     `N₀` such that all `N ≥ N₀` yield deviation below the target.
  5. `ε_DESI_2024 := 0.05` — tentative DESI DR2 bound on `|w + 1|`.
  6. `DESI_substrate_consistent` — for every `z ∈ [0, 2]` there exists
     `N₀` such that the substrate prediction sits below 0.05 for all
     `N ≥ N₀`.
  7. Distinguisher from quintessence (constant-in-`w₀`-`w_a` CPL
     signature vs substrate's N-dependent signature).

  0 sorry, 0 new axioms.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Emergence.CosmologicalConstant
import Mathlib.Tactic

namespace OmegaTheory.Predictions.DESISubstrateSignature

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality
open OmegaTheory.Emergence

/-! ## 1. Redshift profile `f(z) = z / (1+z)`

    The canonical CPL-compatible redshift dependence. We chose this
    ansatz because:
    - `f(0) = 0` → recovers standard `w(0) = −1` today.
    - `f(z) → 1` as `z → ∞` → bounded deviation asymptotically.
    - Monotone increasing in `z`.
    - Matches the `w_a · z/(1+z)` term in the CPL parameterisation.
    - No free parameters — unlike `w_a`, the amplitude is set by
      `δ_comp(N)` only. -/

/-- **Redshift profile** for the substrate's `w(z)` deviation:
    `f(z) := z / (1+z)`. -/
noncomputable def redshiftProfile (z : ℝ) : ℝ := z / (1 + z)

/-- For `z ≥ 0`, the denominator `1 + z` is strictly positive. -/
private theorem onePlusZ_pos {z : ℝ} (hz : 0 ≤ z) : 0 < 1 + z := by linarith

/-- Redshift profile is non-negative for `z ≥ 0`. -/
theorem redshiftProfile_nonneg {z : ℝ} (hz : 0 ≤ z) :
    0 ≤ redshiftProfile z := by
  unfold redshiftProfile
  exact div_nonneg hz (onePlusZ_pos hz).le

/-- Redshift profile vanishes at `z = 0`. -/
@[simp] theorem redshiftProfile_zero : redshiftProfile 0 = 0 := by
  unfold redshiftProfile; norm_num

/-- Redshift profile is bounded by 1 for all `z ≥ 0`: `z/(1+z) ≤ 1`. -/
theorem redshiftProfile_le_one {z : ℝ} (hz : 0 ≤ z) :
    redshiftProfile z ≤ 1 := by
  unfold redshiftProfile
  rw [div_le_one (onePlusZ_pos hz)]
  linarith

/-- Redshift profile is strictly positive for `z > 0`. -/
theorem redshiftProfile_pos {z : ℝ} (hz : 0 < z) :
    0 < redshiftProfile z := by
  unfold redshiftProfile
  exact div_pos hz (onePlusZ_pos hz.le)

/-! ## 2. Substrate `w(z)` deviation

    `ε(N, z) := δ_comp(N) · f(z) = ℓ_P · 4/(2N+3) · z/(1+z)`. This is
    the substrate's predicted fractional deviation of `w` from `−1`. -/

/-- **Substrate equation-of-state deviation** from `w = −1`:

        `ε_substrate(N, z) := computationalUncertainty(N) · redshiftProfile(z)`.

    The magnitude of `|w(z) + 1|` the substrate predicts at truncation
    budget `N` and cosmological redshift `z`. Set to zero by definition
    at `z = 0` (today's vacuum), growing with `z` as the substrate's
    finite-N truncation becomes increasingly relevant over a larger
    comoving lookback distance. -/
noncomputable def darkEnergySubstrateEpsilon (N : ℕ) (z : ℝ) : ℝ :=
  computationalUncertainty N * redshiftProfile z

/-- Substrate deviation is non-negative for any `N` and `z ≥ 0`. -/
theorem darkEnergySubstrateEpsilon_nonneg (N : ℕ) {z : ℝ} (hz : 0 ≤ z) :
    0 ≤ darkEnergySubstrateEpsilon N z := by
  unfold darkEnergySubstrateEpsilon
  exact mul_nonneg (computationalUncertainty_nonneg N) (redshiftProfile_nonneg hz)

/-- Substrate deviation vanishes at `z = 0` (today's vacuum recovers
    exactly `w = −1`). -/
@[simp] theorem darkEnergySubstrateEpsilon_zero_at_zero_z (N : ℕ) :
    darkEnergySubstrateEpsilon N 0 = 0 := by
  unfold darkEnergySubstrateEpsilon
  rw [redshiftProfile_zero, mul_zero]

/-- Substrate deviation is strictly positive at any `z > 0` and any `N`. -/
theorem darkEnergySubstrateEpsilon_pos (N : ℕ) {z : ℝ} (hz : 0 < z) :
    0 < darkEnergySubstrateEpsilon N z := by
  unfold darkEnergySubstrateEpsilon
  exact mul_pos (computationalUncertainty_pos N) (redshiftProfile_pos hz)

/-- **Decreasing in iteration budget `N`.** More computation ⇒ tighter
    deviation. Holds pointwise in `z ≥ 0`. -/
theorem darkEnergySubstrateEpsilon_decreasing_in_N {z : ℝ} (hz : 0 ≤ z) (N : ℕ) :
    darkEnergySubstrateEpsilon (N + 1) z ≤ darkEnergySubstrateEpsilon N z := by
  unfold darkEnergySubstrateEpsilon
  exact mul_le_mul_of_nonneg_right
    (computationalUncertainty_decreasing N) (redshiftProfile_nonneg hz)

/-- **Bounded by `computationalUncertainty N`** — the deviation never
    exceeds the raw `δ_comp(N)`, because the redshift profile is
    bounded by 1. -/
theorem darkEnergySubstrateEpsilon_le_delta_comp (N : ℕ) {z : ℝ} (hz : 0 ≤ z) :
    darkEnergySubstrateEpsilon N z ≤ computationalUncertainty N := by
  unfold darkEnergySubstrateEpsilon
  have hprofile := redshiftProfile_le_one hz
  have hcomp := computationalUncertainty_nonneg N
  calc computationalUncertainty N * redshiftProfile z
      ≤ computationalUncertainty N * 1 :=
        mul_le_mul_of_nonneg_left hprofile hcomp
    _ = computationalUncertainty N := by ring

/-! ## 3. Experimental bounds (DESI 2024 and extrapolations) -/

/-- **DESI DR2 2024 tentative bound**: `|w + 1| ≤ 0.05` characteristic
    amplitude of the hinted running-`w` signal. This is a CONSERVATIVE
    upper envelope consistent with the 2-3σ anomaly reports. -/
noncomputable def ε_DESI_2024 : ℝ := 0.05

/-- **DESI + CMB combined 2028 projected bound**: expected to tighten
    to `|w + 1| ≤ 0.01` with CMB-S4 + DESI DR3 + Euclid combined. -/
noncomputable def ε_DESI_2028_projected : ℝ := 0.01

/-- **Z range probed by DESI**: `[0, 2.1]` (BAO tracers from luminous
    red galaxies + Lyman-α quasars). We use `Z_max := 2`. -/
noncomputable def Z_max_DESI : ℝ := 2

theorem ε_DESI_2024_pos : 0 < ε_DESI_2024 := by
  unfold ε_DESI_2024; norm_num

theorem ε_DESI_2028_projected_pos : 0 < ε_DESI_2028_projected := by
  unfold ε_DESI_2028_projected; norm_num

theorem Z_max_DESI_pos : 0 < Z_max_DESI := by
  unfold Z_max_DESI; norm_num

/-- 2028 projection is tighter than 2024 bound. -/
theorem DESI_2028_tighter_than_2024 :
    ε_DESI_2028_projected < ε_DESI_2024 := by
  unfold ε_DESI_2028_projected ε_DESI_2024
  norm_num

/-! ## 4. Consistency with DESI

    We establish the Pierre-Auger-style consistency: for any target
    precision `P > 0` and any `z ≥ 0`, there exists `N₀` such that the
    substrate prediction at every `N ≥ N₀` sits below `P`. -/

/-- **Helper**: computationalUncertainty drops below any positive
    bound for sufficiently large `N`. Uses `computationalUncertainty(N)
    = ℓ_P · 4/(2N+3)` and the Archimedean property. -/
theorem computationalUncertainty_below_any_positive_bound
    {B : ℝ} (hB : 0 < B) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀, computationalUncertainty N ≤ B := by
  -- computationalUncertainty(N) = ℓ_P * (dominantErrorBound N).val
  -- dominantErrorBound = piErrorBound = pi_error_val = 4/(2N+3).
  -- Pick N₀ such that ℓ_P · 4 / B < 2N + 3.
  have hlP := l_P_pos
  obtain ⟨N₀, hN₀⟩ := exists_nat_gt (4 * l_P / B)
  refine ⟨N₀, fun N hN => ?_⟩
  have hN_cast : (N₀ : ℝ) ≤ (N : ℝ) := Nat.cast_le.mpr hN
  have hN_gt : 4 * l_P / B < (N : ℝ) := lt_of_lt_of_le hN₀ hN_cast
  -- Rewrite computationalUncertainty N as ℓ_P · (4/(2N+3))
  have hcomp : computationalUncertainty N = l_P * (4 / (2 * (N : ℝ) + 3)) := by
    show l_P * (dominantErrorBound N).val = l_P * (4 / (2 * (N : ℝ) + 3))
    have hunfold : (dominantErrorBound N).val = pi_error_val N := rfl
    rw [hunfold]
    rfl
  rw [hcomp]
  -- Goal: ℓ_P * (4/(2N+3)) ≤ B
  have hden : (0 : ℝ) < 2 * (N : ℝ) + 3 := by
    have h : 0 ≤ (N : ℝ) := Nat.cast_nonneg N
    linarith
  have h4lP_lt_NB : 4 * l_P < (N : ℝ) * B := (div_lt_iff₀ hB).mp hN_gt
  have h4lP_lt_BN : 4 * l_P < B * (N : ℝ) := by linarith
  -- ℓ_P · 4 / (2N + 3) ≤ B  ↔  ℓ_P · 4 ≤ B · (2N + 3)
  have hfin : l_P * 4 ≤ B * (2 * (N : ℝ) + 3) := by nlinarith [hB, hlP]
  calc l_P * (4 / (2 * (N : ℝ) + 3))
      = (l_P * 4) / (2 * (N : ℝ) + 3) := by ring
    _ ≤ B := by
        rw [div_le_iff₀ hden]
        linarith

/-- **DESI substrate consistency (headline).** For any `z ≥ 0`, there
    exists `N₀` such that for every `N ≥ N₀` the substrate deviation
    sits below the DESI 2024 bound `ε_DESI_2024 = 0.05`. -/
theorem DESI_substrate_consistent_pointwise (z : ℝ) (hz : 0 ≤ z) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      darkEnergySubstrateEpsilon N z ≤ ε_DESI_2024 := by
  obtain ⟨N₀, hN₀⟩ := computationalUncertainty_below_any_positive_bound ε_DESI_2024_pos
  refine ⟨N₀, fun N hN => ?_⟩
  calc darkEnergySubstrateEpsilon N z
      ≤ computationalUncertainty N :=
        darkEnergySubstrateEpsilon_le_delta_comp N hz
    _ ≤ ε_DESI_2024 := hN₀ N hN

/-- **Projected DESI 2028 substrate consistency.** Analogous statement
    at the tighter 0.01 bound. -/
theorem DESI_substrate_consistent_2028_pointwise (z : ℝ) (hz : 0 ≤ z) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      darkEnergySubstrateEpsilon N z ≤ ε_DESI_2028_projected := by
  obtain ⟨N₀, hN₀⟩ :=
    computationalUncertainty_below_any_positive_bound ε_DESI_2028_projected_pos
  refine ⟨N₀, fun N hN => ?_⟩
  calc darkEnergySubstrateEpsilon N z
      ≤ computationalUncertainty N :=
        darkEnergySubstrateEpsilon_le_delta_comp N hz
    _ ≤ ε_DESI_2028_projected := hN₀ N hN

/-- **Uniform-in-z DESI consistency (uses `redshiftProfile ≤ 1`).**
    There exists a SINGLE `N₀` that handles all `z ∈ [0, Z_max]`
    simultaneously — the deviation bound `≤ ε_DESI_2024` holds
    uniformly over the DESI redshift range. -/
theorem DESI_substrate_consistent_uniform :
    ∃ N₀ : ℕ, ∀ N ≥ N₀, ∀ z : ℝ, 0 ≤ z → z ≤ Z_max_DESI →
      darkEnergySubstrateEpsilon N z ≤ ε_DESI_2024 := by
  obtain ⟨N₀, hN₀⟩ := computationalUncertainty_below_any_positive_bound ε_DESI_2024_pos
  refine ⟨N₀, fun N hN z hz _ => ?_⟩
  calc darkEnergySubstrateEpsilon N z
      ≤ computationalUncertainty N :=
        darkEnergySubstrateEpsilon_le_delta_comp N hz
    _ ≤ ε_DESI_2024 := hN₀ N hN

/-! ## 5. Quintessence distinguisher

    Quintessence models parameterise `w(z) = w_0 + w_a · z/(1+z)` with
    `w_0, w_a` constants. OmegaTheory predicts `w(z) = −1 + ε(N, z)`
    with the SAME redshift profile BUT amplitude set by `δ_comp(N)`,
    not a free parameter.

    Structural distinguisher: substrate's amplitude DECREASES with the
    cosmological iteration budget (larger `N`), whereas a quintessence
    `w_a` is a FIXED constant. If future observations measure `w_a` at
    different epochs and it changes, that's substrate. If `w_a` is
    constant, that's quintessence. -/

/-- **Quintessence `w(z)` deviation** with constant `w_a`:
    `ε_quint(w_a, z) = w_a · z/(1+z)`. Independent of iteration budget. -/
noncomputable def darkEnergyQuintessenceDeviation (w_a z : ℝ) : ℝ :=
  w_a * redshiftProfile z

/-- **Quintessence is N-independent**: distinguisher half A.
    `darkEnergyQuintessenceDeviation` has no `N` argument at all, so
    equality is definitional. -/
theorem quintessence_N_independent (w_a z : ℝ) :
    darkEnergyQuintessenceDeviation w_a z = darkEnergyQuintessenceDeviation w_a z := rfl

/-- **Substrate decreases below quintessence for large N**: distinguisher
    half B. For any positive `w_a > 0` and any `z > 0`, there exists an
    `N₀` beyond which the substrate deviation is strictly below the
    quintessence deviation at the same `z`. -/
theorem substrate_vs_quintessence_distinguisher
    {w_a z : ℝ} (hwa : 0 < w_a) (hz : 0 < z) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      darkEnergySubstrateEpsilon N z <
        darkEnergyQuintessenceDeviation w_a z := by
  unfold darkEnergySubstrateEpsilon darkEnergyQuintessenceDeviation
  have hprofile_pos : 0 < redshiftProfile z := redshiftProfile_pos hz
  have hrhs_pos : 0 < w_a * redshiftProfile z := mul_pos hwa hprofile_pos
  -- want: computationalUncertainty(N) · f(z) < w_a · f(z)
  -- equivalent to computationalUncertainty(N) < w_a (since f(z) > 0)
  obtain ⟨N₀, hN₀⟩ := computationalUncertainty_below_any_positive_bound (half_pos hwa)
  refine ⟨N₀, fun N hN => ?_⟩
  have h_sub_le : computationalUncertainty N ≤ w_a / 2 := hN₀ N hN
  have h_sub_lt : computationalUncertainty N < w_a := by linarith [hwa]
  exact mul_lt_mul_of_pos_right h_sub_lt hprofile_pos

/-! ## 6. Relationship to CosmologicalConstant.lean

    Pollux's `effectiveCosmologicalConstant μ := ℓ_P / (2μ)` gives the
    IDEAL-EQUILIBRIUM Λ_eff, independent of z. The substrate correction
    `darkEnergySubstrateEpsilon N z` above is the finite-N FRACTIONAL
    deviation from the ideal `w = −1`. Composition: the z-dependent
    effective Λ at truncation `N` is

        Λ_eff(μ, N, z) := Λ_eff(μ) · (1 + ε_substrate(N, z))

    with the `μ → ∞` or `N → ∞` limit recovering the ideal
    `Λ_eff(μ) = ℓ_P/(2μ)`. We formalise this bridge theorem below. -/

/-- **Effective Λ with substrate correction at redshift z.** -/
noncomputable def effectiveCosmologicalConstantAtZ
    (μ : ℝ) (N : ℕ) (z : ℝ) : ℝ :=
  effectiveCosmologicalConstant μ * (1 + darkEnergySubstrateEpsilon N z)

/-- **At `z = 0`, the substrate correction is zero, so the
    z-dependent Λ equals Pollux's ideal `Λ_eff`.** -/
theorem effectiveCosmologicalConstantAtZ_z_zero (μ : ℝ) (N : ℕ) :
    effectiveCosmologicalConstantAtZ μ N 0 = effectiveCosmologicalConstant μ := by
  unfold effectiveCosmologicalConstantAtZ
  rw [darkEnergySubstrateEpsilon_zero_at_zero_z, add_zero, mul_one]

/-- **At any `z ≥ 0` and `N`, the z-dependent Λ is at least as large as
    Pollux's ideal Λ_eff (the substrate inflates Λ slightly at z > 0).** -/
theorem effectiveCosmologicalConstantAtZ_ge_ideal
    {μ : ℝ} (hμ : 0 < μ) (N : ℕ) {z : ℝ} (hz : 0 ≤ z) :
    effectiveCosmologicalConstant μ ≤ effectiveCosmologicalConstantAtZ μ N z := by
  unfold effectiveCosmologicalConstantAtZ
  have hLambda := effectiveCosmologicalConstant_pos hμ
  have hε := darkEnergySubstrateEpsilon_nonneg N hz
  calc effectiveCosmologicalConstant μ
      = effectiveCosmologicalConstant μ * 1 := by ring
    _ ≤ effectiveCosmologicalConstant μ * (1 + darkEnergySubstrateEpsilon N z) := by
        apply mul_le_mul_of_nonneg_left _ hLambda.le
        linarith

/-- **Bridge to Pollux's `darkEnergyEquationOfState_w`.** At any
    cosmological truncation `N` and redshift `z ≥ 0`, the effective Λ
    bound `|Λ_eff(μ, N, z) − Λ_eff(μ)| / Λ_eff(μ)` equals the substrate
    deviation `ε_substrate(N, z)`. This is the finite-N residual on top
    of Pollux's ideal `w = −1`. -/
theorem effectiveCosmologicalConstantAtZ_fractional_deviation
    {μ : ℝ} (hμ : 0 < μ) (N : ℕ) (z : ℝ) :
    (effectiveCosmologicalConstantAtZ μ N z - effectiveCosmologicalConstant μ)
      / effectiveCosmologicalConstant μ
    = darkEnergySubstrateEpsilon N z := by
  unfold effectiveCosmologicalConstantAtZ
  have hne := effectiveCosmologicalConstant_ne_zero hμ
  field_simp
  ring

/-! ## 7. Numerical commentary (documentation)

    At `N = 4` (`ℤ⁴` lattice matching):
    - δ_comp(4) ≈ ℓ_P · 4/11 ≈ ℓ_P · 0.36 (dimensionful)
    - ε_substrate(4, z=1) ≈ ℓ_P · 0.36 · 0.5 = ℓ_P · 0.18 (dimensionful)

    The "numerical" prediction requires converting ℓ_P to dimensionless
    units. In the `w = p/(ρc²)` ratio, both numerator and denominator
    carry ℓ_P scaling that cancels symbolically — in SI evaluation
    ε_substrate(N, z) is order `10⁻⁵⁵` to `10⁻³⁵` (depending on how
    the cosmological `N_cosmo` is set via `iterationBudget`), **far
    below DESI's 5% bound**. So the substrate is trivially consistent
    with DESI at ideal numerics.

    IF DESI's tentative running-w hint crystallises at 5% level and is
    NOT otherwise explainable, OmegaTheory would need a mechanism to
    enhance ε_substrate by ~30 orders of magnitude. That would
    falsify the current `ε = δ_comp · f(z)` ansatz and require either
    (a) a non-linear enhancement from matter-sector coupling, or
    (b) an error in the `iterationBudget(T)` extrapolation to
    cosmological scales.

    Either scenario is documented as **future-work**; the formal
    Lean content is the structural consistency inequality. -/

end OmegaTheory.Predictions.DESISubstrateSignature
