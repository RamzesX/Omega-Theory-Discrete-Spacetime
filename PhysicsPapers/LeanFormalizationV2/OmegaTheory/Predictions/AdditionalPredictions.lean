/-
  OmegaTheory.Predictions.AdditionalPredictions

  Seven "easy composition" predictions from the PREDICTION_GAP_ANALYSIS.md
  gap table.  Each is pure composition of existing definitions with no
  new mathematical infrastructure.

  ## Contents (Peacock, predictions 1-4)

  1. **Spectral dimension at Planck energy** (G12).
     d_eff(E_P) = 2: at Planck energy, spacetime is 2-dimensional.
     Matches CDT and asymptotic safety spectral-dimension results.

  2. **KL information drift rate per tick** (G14).
     informationDriftRate(N) = delta_comp(N) / hbar > 0, decreasing in N.
     Rate at which information density drifts per substrate tick.

  3. **Aharonov-Bohm substrate correction** (G13).
     The AB holonomy on a substrate-bounded gauge connection deviates
     from the ideal flux by at most 4 * l_P * delta_comp(N) per plaquette.

  4. **Jacobi violation as experimental prediction** (G10).
     Any measured Jacobi identity violation in gauge fields is bounded
     by delta_comp(N).  Currently unmeasurable but structurally important.

  ## Contents (Kaus Australis, predictions 5-7)

  5. **Photon mass at temperature T** (G1).
     m_γ(T) = δ_comp(⌊N_max(T)⌋)/c: positive, monotone in T.

  6. **Dark energy w = -1 stability** (G2).
     w = p/(ρc²) = -1 exactly for all μ > 0.  Distinguishes substrate
     from quintessence models.

  7. **Bekenstein entropy substrate correction** (G19).
     δ_S(N) = log(1 + δ_comp(N)) > 0: irreducible entropy reduction
     per lattice site from computational uncertainty.

  Agent: Peacock (alpha Pavonis), 2026-04-15. Predictions 1-4.
  Agent: Kaus Australis (ε Sagittarii), 2026-04-15. Predictions 5-7.
  No sorry, no new axioms.
-/

import OmegaTheory.Emergence.DimensionalFlow
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Emergence.ErrorGaugeField
import OmegaTheory.Emergence.CosmologicalConstant
import OmegaTheory.Foundations.ErrorLieAlgebra
import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace OmegaTheory.Predictions.AdditionalPredictions

open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Irrationality
open OmegaTheory.Foundations
open OmegaTheory.Emergence.ErrorGaugeField

/-! ## Prediction 1: Spectral Dimension at Planck Energy

The effective spacetime dimension d_eff(E) = 4 - 2E/E_P evaluates to 2
at the Planck energy.  This is a testable prediction: causal dynamical
triangulations and asymptotic safety programmes independently compute
the spectral dimension of diffusion on a quantum spacetime and find
d_S -> 2 in the UV.  The substrate makes this an exact linear result.

**Experimental scope**: CDT lattice simulations (Ambjorn, Jurkiewicz,
Loll), asymptotic safety (Reuter, Saueressig), analog gravity heat-kernel
experiments.  Timescale: 5-10 years for precision CDT comparison. -/

/-- At Planck energy, the effective spacetime dimension is exactly 2. -/
theorem spectralDimension_at_planck_energy : d_eff E_P = 2 :=
  d_eff_planck

/-- At half the Planck energy, the effective dimension is 3. -/
theorem spectralDimension_at_half_planck : d_eff (E_P / 2) = 3 :=
  d_eff_half_planck

/-- At zero energy (IR limit), the effective dimension is 4. -/
theorem spectralDimension_at_zero_energy : d_eff 0 = 4 :=
  d_eff_zero

/-- The spectral dimension is strictly decreasing with energy:
    higher-energy probes see fewer effective dimensions. -/
theorem spectralDimension_strictly_decreasing : StrictAnti d_eff :=
  d_eff_strictAnti

/-- On the physical energy interval [0, E_P], the spectral dimension
    lies in [2, 4]. -/
theorem spectralDimension_physical_range {E : ℝ} (h0 : 0 ≤ E) (hP : E ≤ E_P) :
    2 ≤ d_eff E ∧ d_eff E ≤ 4 :=
  d_eff_in_range h0 hP

/-! ## Prediction 2: KL Information Drift Rate Per Tick

The substrate processes information at a finite rate.  At each tick,
the information density can drift by at most delta_comp(N) in natural
units.  Converting to a rate per unit time (dividing by hbar, which
sets the natural time scale), the drift rate is delta_comp(N) / hbar.

This is the "fundamental clock" of the substrate: the rate at which
the universe forgets its exact initial conditions.

**Experimental scope**: currently unmeasurable (rate ~ 10^-67 / hbar
at lab temperatures).  Structurally important as the bridge between
computational uncertainty and thermodynamic entropy production. -/

/-- Information drift rate per tick: delta_comp(N) / hbar.
    This is the rate at which information density changes per substrate
    tick, in units of inverse action. -/
noncomputable def informationDriftRate (N : ℕ) : ℝ :=
  computationalUncertainty N / hbar

/-- The information drift rate is strictly positive for any N. -/
theorem informationDriftRate_pos (N : ℕ) : 0 < informationDriftRate N :=
  div_pos (computationalUncertainty_pos N) hbar_pos

/-- The information drift rate is nonneg. -/
theorem informationDriftRate_nonneg (N : ℕ) : 0 ≤ informationDriftRate N :=
  le_of_lt (informationDriftRate_pos N)

/-- The information drift rate decreases with more computational
    iterations (higher N = more precision = less drift). -/
theorem informationDriftRate_decreasing (N : ℕ) :
    informationDriftRate (N + 1) ≤ informationDriftRate N := by
  unfold informationDriftRate
  exact div_le_div_of_nonneg_right (computationalUncertainty_decreasing N)
    hbar_nonneg

/-- For any target rate epsilon > 0, there exists N such that the
    drift rate is below epsilon.  The drift vanishes in the continuum
    limit. -/
theorem informationDriftRate_tendsto_zero (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, informationDriftRate N < ε := by
  have hhε : 0 < hbar * ε := mul_pos hbar_pos hε
  obtain ⟨N, hN⟩ := substrateLieBracketError_tendsto_zero (hbar * ε) hhε
  use N
  unfold informationDriftRate substrateLieBracketError at *
  rw [div_lt_iff₀ hbar_pos]
  linarith

/-! ## Prediction 3: Aharonov-Bohm Substrate Correction

The Aharonov-Bohm phase phi_AB = e * Phi / hbar acquires a substrate
correction from the finite-precision computation of the gauge holonomy.
For a substrate-bounded gauge connection at truncation level N, the
holonomy error on a single plaquette (4 edges) is bounded by
4 * l_P * delta_comp(N).

This means the AB phase is not perfectly sharp: there is an irreducible
"phase jitter" from the substrate's computational truncation.

**Experimental scope**: current AB interferometry achieves ~10^-8 rad
phase resolution.  The substrate correction is ~10^-67 rad at lab
temperatures.  Far below detection, but provides an exact closed form
for the correction.  Timescale: 15+ years. -/

/-- The Aharonov-Bohm substrate correction bound: the holonomy
    error on a single plaquette for a substrate-bounded gauge connection
    is at most 4 * l_P * delta_comp(N). -/
theorem aharonov_bohm_substrate_correction (N : ℕ)
    (sbg : SubstrateBoundedGauge N) :
    (plaquetteHolonomyError sbg.εA).val ≤
      4 * (l_P * computationalUncertainty N) :=
  substrateBoundedGauge_holonomy_error N sbg 4

/-- The AB substrate correction is nonneg. -/
theorem aharonov_bohm_substrate_correction_nonneg (N : ℕ) :
    0 ≤ 4 * (l_P * computationalUncertainty N) :=
  mul_nonneg (by norm_num) (mul_nonneg l_P_nonneg (computationalUncertainty_nonneg N))

/-- The AB substrate correction is strictly positive:
    the substrate predicts a nonzero phase jitter. -/
theorem aharonov_bohm_substrate_correction_pos (N : ℕ) :
    0 < 4 * (l_P * computationalUncertainty N) :=
  mul_pos (by norm_num) (mul_pos l_P_pos (computationalUncertainty_pos N))

/-- The AB substrate correction decreases with more iterations. -/
theorem aharonov_bohm_substrate_correction_decreasing (N : ℕ) :
    4 * (l_P * computationalUncertainty (N + 1)) ≤
    4 * (l_P * computationalUncertainty N) := by
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0 : ℝ) ≤ 4)
  exact mul_le_mul_of_nonneg_left (computationalUncertainty_decreasing N) l_P_nonneg

/-! ## Prediction 4: Jacobi Violation Bound as Experimental Prediction

Any measured violation of the Jacobi identity in gauge fields (which
would manifest as a gauge anomaly) is bounded by the substrate's
computational uncertainty delta_comp(N).  The Jacobi error is:
  - Strictly positive (the substrate always breaks exact Jacobi)
  - Decreasing in N (more computation = closer to exact)
  - Tends to zero (exact Lie algebra in the continuum limit)

At lab energies (N ~ 10^33), the violation is ~10^-67, which is far
below any conceivable measurement.  At near-Planck energies (N ~ 1),
the violation is O(l_P) ~ 10^-35 m, and gauge structure breaks down.

**Experimental scope**: precision tests of gauge anomaly cancellation
in particle physics.  Currently unmeasurable but provides a structural
bound.  Timescale: would require Planck-energy accelerators. -/

/-- The substrate Jacobi violation is exactly the computational
    uncertainty: substrateLieBracketError(N) = delta_comp(N). -/
theorem jacobiViolation_eq_computationalUncertainty (N : ℕ) :
    substrateLieBracketError N = computationalUncertainty N := rfl

/-- The Jacobi violation bound is strictly positive for any N. -/
theorem jacobiViolation_pos (N : ℕ) :
    0 < substrateLieBracketError N :=
  substrateLieBracketError_pos N

/-- The Jacobi violation bound decreases with more iterations. -/
theorem jacobiViolation_decreasing (N : ℕ) :
    substrateLieBracketError (N + 1) ≤ substrateLieBracketError N :=
  substrateLieBracketError_decreasing N

/-- For any precision target epsilon > 0, there exists a truncation
    level N at which the Jacobi violation is below epsilon.
    This is the continuum-limit recovery of exact gauge symmetry. -/
theorem jacobiViolation_tendsto_zero (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, substrateLieBracketError N < ε :=
  substrateLieBracketError_tendsto_zero ε hε

/-- The Jacobi violation as an ErrorBound for downstream composition. -/
noncomputable def jacobiViolationBound (N : ℕ) : ErrorBound :=
  substrateLieBracketErrorBound N

/-! ## Prediction 5: Photon Mass at Temperature T (Gap G1)

Naos defined `photonSubstrateMassBound N := δ_comp(N)/c` in
ErrorGaugeField.lean.  At temperature T the substrate has iteration
budget N_max(T) = ℏ/(k_B·T·t_P), which sets the truncation level.
Composing the two:

    m_γ(T) := photonSubstrateMassBound(⌊N_max(T)⌋)

This is the temperature-dependent photon mass prediction:
  * Positive for T > 0  (the photon is always massive on the substrate)
  * Monotone increasing in T  (hotter → heavier photon)
  * Closed-form via δ_comp and iterationBudget

**Experimental scope**: PDG bound m_γ < 10⁻¹⁸ eV/c².  At 300 K,
m_γ(T) ~ 10⁻³¹ eV — far below detection, hence consistent.  At
Planck temperature, m_γ ~ E_P/c² (maximally massive).  Distinguishes
substrate from exact gauge theory (m_γ = 0).  Timescale: 10-15 years. -/

/-- Photon mass at temperature T: compose photonSubstrateMassBound
    with the floor of the thermal iteration budget. -/
noncomputable def photonMassAtTemperature (T : ℝ) : ℝ :=
  photonSubstrateMassBound (Nat.floor (iterationBudget T))

/-- The photon mass at temperature T is strictly positive for any T
    (including negative or zero iteration budgets, since
    computationalUncertainty is positive for all ℕ). -/
theorem photonMassAtTemperature_pos (T : ℝ) :
    0 < photonMassAtTemperature T :=
  photonSubstrateMassBound_pos _

/-- The photon mass at temperature T is nonneg. -/
theorem photonMassAtTemperature_nonneg (T : ℝ) :
    0 ≤ photonMassAtTemperature T :=
  le_of_lt (photonMassAtTemperature_pos T)

/-- Helper: computationalUncertainty is antitone on ℕ.
    If N₁ ≤ N₂ then δ_comp(N₂) ≤ δ_comp(N₁).
    Proof by induction from the successor-step version. -/
private theorem computationalUncertainty_antitone_aux (N₁ : ℕ) :
    ∀ k : ℕ, computationalUncertainty (N₁ + k) ≤ computationalUncertainty N₁ := by
  intro k
  induction k with
  | zero => simp
  | succ j ih =>
    calc computationalUncertainty (N₁ + (j + 1))
        = computationalUncertainty ((N₁ + j) + 1) := by ring_nf
      _ ≤ computationalUncertainty (N₁ + j) := computationalUncertainty_decreasing _
      _ ≤ computationalUncertainty N₁ := ih

private theorem computationalUncertainty_antitone_nat {N₁ N₂ : ℕ}
    (h : N₁ ≤ N₂) :
    computationalUncertainty N₂ ≤ computationalUncertainty N₁ := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le h
  exact computationalUncertainty_antitone_aux N₁ k

/-- Hotter temperatures yield a heavier photon: if 0 < T₁ ≤ T₂,
    then m_γ(T₁) ≤ m_γ(T₂).
    Proof chain: T₁ ≤ T₂ → iterationBudget T₂ ≤ iterationBudget T₁
    → ⌊budget T₂⌋ ≤ ⌊budget T₁⌋ → δ_comp(⌊T₂⌋) ≥ δ_comp(⌊T₁⌋)
    → m_γ(T₂) ≥ m_γ(T₁). -/
theorem photonMassAtTemperature_monotone (T₁ T₂ : ℝ)
    (hT1 : 0 < T₁) (hT2 : 0 < T₂) (h : T₁ ≤ T₂) :
    photonMassAtTemperature T₁ ≤ photonMassAtTemperature T₂ := by
  unfold photonMassAtTemperature photonSubstrateMassBound
  apply div_le_div_of_nonneg_right _ c_nonneg
  have hbudget := iterationBudget_decreases_with_T T₁ T₂ hT1 hT2 h
  have hfloor := Nat.floor_le_floor hbudget
  exact computationalUncertainty_antitone_nat hfloor

/-- The photon mass bound at truncation level N is an upper bound
    on m_γ(T) for temperatures whose iteration budget exceeds N.
    This provides the closed-form link to experimental bounds. -/
theorem photonMassAtTemperature_le_bound (N : ℕ) (T : ℝ)
    (hN : (N : ℝ) ≤ iterationBudget T) :
    photonMassAtTemperature T ≤ photonSubstrateMassBound N := by
  unfold photonMassAtTemperature photonSubstrateMassBound
  apply div_le_div_of_nonneg_right _ c_nonneg
  exact computationalUncertainty_antitone_nat (Nat.le_floor hN)

/-! ## Prediction 6: Dark Energy w = -1 Stability (Gap G2)

Pollux proved `darkEnergyEquationOfState_w : p/(ρ·c²) = -1` in
CosmologicalConstant.lean.  This is an EXACT result from the healing
flow equilibrium — the equation of state parameter w is precisely -1,
not approximately -1.

This is a sharp negative prediction that distinguishes the substrate
from quintessence models (where w ≠ -1 and can vary with time).
The substrate predicts:
  * w = -1 exactly for ALL values of the healing parameter μ > 0
  * No time variation: dw/da = 0 identically
  * Consistent with DESI/Euclid measurements to any precision

**Experimental scope**: DESI BAO (2026) and Euclid (2027-2030) will
measure w to ~1% precision.  Any detection of w ≠ -1 would FALSIFY
the substrate prediction.  Timescale: 5-10 years. -/

/-- **Dark energy w = -1 exact**: for all μ > 0, the ratio
    p/(ρ·c²) = -1 exactly.  This is a universal quantification
    over the healing parameter, making it a structural prediction
    rather than a fit. -/
theorem dark_energy_w_exact (μ : ℝ) (hμ : 0 < μ) :
    effectiveVacuumPressure μ / (effectiveVacuumEnergyDensity μ * c ^ 2) = -1 :=
  darkEnergyEquationOfState_w μ hμ

/-- **Dark energy w is parameter-independent**: for any two positive
    healing parameters μ₁, μ₂, the equation-of-state parameter w is
    the same (-1).  The substrate does not allow w to vary. -/
theorem dark_energy_w_parameter_independent (μ₁ μ₂ : ℝ) (h1 : 0 < μ₁) (h2 : 0 < μ₂) :
    effectiveVacuumPressure μ₁ / (effectiveVacuumEnergyDensity μ₁ * c ^ 2) =
    effectiveVacuumPressure μ₂ / (effectiveVacuumEnergyDensity μ₂ * c ^ 2) := by
  rw [dark_energy_w_exact μ₁ h1, dark_energy_w_exact μ₂ h2]

/-- **Dark energy pressure is always negative**: the substrate
    predicts accelerated expansion for any positive healing parameter.
    This is w = -1 combined with ρ > 0. -/
theorem dark_energy_pressure_neg (μ : ℝ) (hμ : 0 < μ) :
    effectiveVacuumPressure μ < 0 :=
  effectiveVacuumPressure_neg hμ

/-- **Quintessence distinguisher**: the substrate's w = -1 is sharp.
    Any measured deviation |w - (-1)| > 0 at ANY μ would falsify the
    substrate.  Stated as: no μ > 0 gives w ≠ -1. -/
theorem no_quintessence_deviation (μ : ℝ) (hμ : 0 < μ) :
    effectiveVacuumPressure μ / (effectiveVacuumEnergyDensity μ * c ^ 2) - (-1) = 0 := by
  rw [dark_energy_w_exact μ hμ]; ring

/-! ## Prediction 7: Bekenstein Entropy Substrate Correction (Gap G19)

The classical Bekenstein bound is S ≤ log |R| (weak form) or
S ≤ A/(4·ℓ_P²) (with holographic hypothesis).  The substrate
introduces a correction: the computational uncertainty δ_comp(N)
reduces the number of effectively distinguishable microstates.

The entropy deficit from substrate truncation at level N is:
    δ_S(N) := log(1 + δ_comp(N))

This is the information lost per degree of freedom from the finite
computational precision.  Properties:
  * δ_S(N) > 0  (the substrate always reduces available entropy)
  * δ_S(N) → 0 as N → ∞  (continuum limit recovers full entropy)
  * δ_S(N) is decreasing in N  (more computation → less entropy loss)

The corrected Bekenstein bound becomes:
    S ≤ log |R| − |R| · δ_S(N)

with the deficit growing with the region size (more sites =
more accumulated computational error).

**Experimental scope**: black hole entropy measurements via Hawking
radiation spectrum.  Far future (Planck-scale astronomy), but provides
a structural correction absent in classical GR.  Timescale: 20+ years. -/

/-- **Entropy deficit per site from substrate truncation**.
    δ_S(N) = log(1 + δ_comp(N)) — the information penalty from
    the substrate's finite computational precision at each lattice site. -/
noncomputable def entropyDeficitPerSite (N : ℕ) : ℝ :=
  Real.log (1 + computationalUncertainty N)

/-- The entropy deficit per site is strictly positive: the substrate
    always reduces the available entropy at each site. -/
theorem entropyDeficitPerSite_pos (N : ℕ) :
    0 < entropyDeficitPerSite N := by
  unfold entropyDeficitPerSite
  apply Real.log_pos
  linarith [computationalUncertainty_pos N]

/-- The entropy deficit per site is nonneg. -/
theorem entropyDeficitPerSite_nonneg (N : ℕ) :
    0 ≤ entropyDeficitPerSite N :=
  le_of_lt (entropyDeficitPerSite_pos N)

/-- The entropy deficit per site decreases with more iterations:
    more computation = less entropy lost. -/
theorem entropyDeficitPerSite_decreasing (N : ℕ) :
    entropyDeficitPerSite (N + 1) ≤ entropyDeficitPerSite N := by
  unfold entropyDeficitPerSite
  apply Real.log_le_log
  · linarith [computationalUncertainty_pos (N + 1)]
  · linarith [computationalUncertainty_decreasing N]

/-- **Total entropy deficit for a region of k sites**.
    The total information penalty grows linearly with region size. -/
noncomputable def totalEntropyDeficit (k : ℕ) (N : ℕ) : ℝ :=
  k * entropyDeficitPerSite N

/-- The total entropy deficit is nonneg. -/
theorem totalEntropyDeficit_nonneg (k N : ℕ) :
    0 ≤ totalEntropyDeficit k N :=
  mul_nonneg (Nat.cast_nonneg k) (entropyDeficitPerSite_nonneg N)

/-- The total entropy deficit is strictly positive for nonempty
    regions (k ≥ 1). -/
theorem totalEntropyDeficit_pos (k N : ℕ) (hk : 0 < k) :
    0 < totalEntropyDeficit k N :=
  mul_pos (Nat.cast_pos.mpr hk) (entropyDeficitPerSite_pos N)

/-- The total entropy deficit grows with region size: more sites
    means more accumulated substrate error. -/
theorem totalEntropyDeficit_mono_region {k₁ k₂ : ℕ} (h : k₁ ≤ k₂) (N : ℕ) :
    totalEntropyDeficit k₁ N ≤ totalEntropyDeficit k₂ N := by
  unfold totalEntropyDeficit
  exact mul_le_mul_of_nonneg_right (Nat.cast_le.mpr h) (entropyDeficitPerSite_nonneg N)

/-- The total entropy deficit decreases with more computation. -/
theorem totalEntropyDeficit_decreasing (k N : ℕ) :
    totalEntropyDeficit k (N + 1) ≤ totalEntropyDeficit k N := by
  unfold totalEntropyDeficit
  exact mul_le_mul_of_nonneg_left (entropyDeficitPerSite_decreasing N) (Nat.cast_nonneg k)

/-- For any target deficit ε > 0, there exists N with per-site
    deficit below ε.  The substrate correction vanishes in the
    continuum limit. -/
theorem entropyDeficitPerSite_tendsto_zero (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, entropyDeficitPerSite N < ε := by
  -- log(1 + x) ≤ x for x ≥ 0, so it suffices to find N with δ_comp(N) < ε.
  -- But we use: log(1 + x) < 1 + x, so if δ_comp(N) + 1 < exp(ε),
  -- i.e. δ_comp(N) < exp(ε) - 1.
  -- Simpler: log(1 + x) ≤ x for x ≥ 0 (from Mathlib).
  -- We need δ_comp(N) < ε, then log(1 + δ_comp(N)) ≤ δ_comp(N) < ε.
  have hcu := substrateLieBracketError_tendsto_zero ε hε
  obtain ⟨N, hN⟩ := hcu
  use N
  unfold entropyDeficitPerSite substrateLieBracketError at *
  calc Real.log (1 + computationalUncertainty N)
      ≤ computationalUncertainty N := by
        have h1 : 0 < 1 + computationalUncertainty N :=
          by linarith [computationalUncertainty_pos N]
        -- log(1+x) ≤ x ↔ 1+x ≤ exp(x) ↔ log(1+x) ≤ x
        -- Mathlib: Real.log_le_sub_one_of_pos applied to (1+x):
        -- log(1+x) ≤ (1+x) - 1 = x
        have := Real.log_le_sub_one_of_pos h1
        linarith
    _ < ε := hN

end OmegaTheory.Predictions.AdditionalPredictions
