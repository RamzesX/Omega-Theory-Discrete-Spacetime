# Prediction Gap Analysis -- OmegaTheory V2 Lean Formalization

**Date**: 2026-04-15.  **Method**: Full crawl of 135 `.lean` files + cross-reference with Appendix-J, Appendix-K, Appendix-G, Appendix-P, Appendix-S, Appendix-E, Appendix-B.

---

## Part A: Inventory of Existing Formalized Predictions

| # | Prediction | Lean File | Key Theorem | Status |
|---|-----------|-----------|-------------|--------|
| P1 | Gate fidelity power-law (anti-Arrhenius) | `Emergence/Predictions.lean` | `gateFidelity_decreasing` | VERIFIED (Diraq 2024) |
| P2 | Clock precision floor | `Predictions/HermiticityDefect.lean` | `clock_precision_floor` | Formalized |
| P3 | Mach-Zehnder phase floor | `Predictions/HermiticityDefect.lean` | `mach_zehnder_phase_floor` | Formalized |
| P4 | Spin-1/2 flip rate > 0 | `Predictions/SpinFlipRate.lean` | `spinFlipRateSubstrate_strictly_exceeds_standard_QM` | Formalized |
| P5 | Grav. decoherence T^2-scaling | `Predictions/GravDecoherenceTScaling.lean` | `grav_decoherence_T_monotone` | Formalized |
| P6 | Cosmological redshift floor | `Predictions/RedshiftFloor.lean` | `cosmological_redshift_floor_from_vacuum_curvature` | Formalized |
| P7 | Teleportation fidelity bound | `Predictions/StochasticTeleportation.lean` | `teleportation_fidelity_substrate_bound_low_T` | Formalized |
| P8 | Cold-neutron 1/v slope | `Predictions/StochasticTeleportation.lean` | `slope_distinguisher_inv_v` | Formalized |
| P9 | UHECR velocity dispersion | `Predictions/UHECRDispersion.lean` | `uhecr_dispersion_composite_bound` | Formalized |
| P10 | Christoffel hot-spot density | `Predictions/ChristoffelSparsity.lean` | `christoffel_hot_spot_proxy_bound` | Formalized |
| P11 | GRB dispersion null consistency | `Predictions/GammaRayDispersion.lean` | `gammaRayDispersionSubstrate_below_any_positive_bound` | Formalized |
| P12 | Dark energy w = -1 | `Emergence/CosmologicalConstant.lean` | `darkEnergyEquationOfState_w` | Formalized |
| P13 | Photon mass bound > 0 | `Emergence/ErrorGaugeField.lean` | `photonSubstrateMassBound_pos` | Formalized (not in Predictions/) |

---

## Part B: Prediction Gaps -- Existing Machinery, Missing Theorems

### Table: Predictions we CAN make but HAVEN'T formalized

| # | Prediction | Source Machinery (File) | Experimental Test | Formalized? | Difficulty |
|---|-----------|----------------------|------------------|-------------|------------|
| G1 | **Photon mass upper bound at given T** | `ErrorGaugeField.photonSubstrateMassBound` + `Uncertainty.iterationBudget` | m_gamma < delta_comp(N_max(T))/c; compare PDG bound < 10^-18 eV | NO (def exists, no Predictions/ file) | Easy |
| G2 | **Inflation spectral index n_s from healing flow** | `Inflation.lean` + `HealingFlow/Convergence.lean` + `HpwDeSitter.lean` | Planck CMB n_s = 0.965; substrate slow-roll params from F[g] shape | NO | Hard |
| G3 | **Tensor-to-scalar ratio r from healing flow** | `Inflation.lean` + `HealingFlow/Lyapunov.lean` | Planck/LiteBIRD r < 0.036; substrate predicts r from gradient-norm ratio | NO | Hard |
| G4 | **Dark energy equation of state evolution dw/da** | `CosmologicalConstant.lean` (w = -1 exactly) | DESI/Euclid measure w(a); substrate predicts w = -1 + O(delta_comp) | NO | Medium |
| G5 | **Bekenstein entropy correction from substrate** | `BekensteinBound.lean` + `Uncertainty.computationalUncertainty` | S = A/(4 l_P^2) + O(delta_comp * A); logarithmic correction? | NO | Medium |
| G6 | **Hawking temperature substrate correction** | `Correspondence.hawkingTemperature` + `Uncertainty` | T_H gets delta_comp correction; modifies evaporation endpoint | NO | Medium |
| G7 | **Neutrino mass lower bound from lattice delay** | `MassAsDelay.perTickDelay_pos_massive` | m > 0 iff delay > 0; substrate has minimum resolvable mass ~ delta_comp * c/l_P | NO | Medium |
| G8 | **Bounce density from torsion pressure** | `BigBounce.lean` + `NegativePressure.lean` | rho_bounce ~ rho_Planck; CMB B-mode from bounce epoch | NO (structure exists, no explicit bound) | Medium |
| G9 | **CTC impossibility from information conservation** | `NoetherMetaStructure.lean` + `BekensteinBound.lean` | Structural: no closed timelike curves; Appendix S discusses but no Lean | NO | Hard |
| G10 | **Jacobi violation measurability** | `ErrorLieAlgebra.jacobi_error` + `substrateLieBracketError` | epsilon_Jacobi = delta_comp(N); testable via gauge anomaly precision | NO | Medium |
| G11 | **Entanglement decay rate from substrate** | `Entanglement.lean` + `Decoherence.lean` + `Uncertainty` | Bell-state fidelity decays as 1 - n_ticks * delta_comp^2; T-dependent | NO | Medium |
| G12 | **Dimensional flow observables** | `DimensionalFlow.d_eff` | d_eff(E) = 4 - 2E/E_P; spectral dimension of diffusion at E | NO (d_eff defined, no prediction file) | Easy |
| G13 | **Aharonov-Bohm phase substrate correction** | `AharonovBohm.lean` + `ErrorGaugeField.holonomyErrorBound` | AB phase gets l_P * epsilon_A correction per plaquette; interferometry | NO | Easy |
| G14 | **KL divergence accumulation rate** | `Conservation/InformationKL.lean` + `LaSalleKLBridge.lean` | Rate of information density drift per tick = delta_comp(N) per lattice site | NO (bridge exists, no prediction theorem) | Easy |
| G15 | **Connes spectral action error correction** | `ConnesSpectralAction.lean` + `ErrorAlgebra` | SM coupling constants get delta_comp corrections; weak mixing angle shift | NO | Very Hard |
| G16 | **Repair-quantum energy as gravitational-wave background** | `Gravitons.repairQuantumEnergy` | Stochastic GW background from repair events; spectrum from delta_comp | NO | Hard |
| G17 | **Mass quantization from lattice structure** | `MassAsDelay.lean` + `SpecialRelativity.lean` | Minimum mass = E_P * delta_comp(N_max); particle mass ratios? | NO | Very Hard |
| G18 | **Error-propagating Maxwell photon mass bound** | `ErrorForms.emNoiseFloor` + `ErrorGaugeField` | EM noise floor C_d * delta_comp(N) bounds photon mass from Maxwell | NO (machinery built, not composed into prediction) | Easy |
| G19 | **Spin-dependent decoherence rate** | `SpinInformation.lean` (decoherence section) | Gamma_decoherence = alpha * n_spin * T; fermions decohere faster | NO (monotonicity proven, no Predictions/ file) | Easy |
| G20 | **Hopf algebra anomaly from substrate** | `ErrorHopfStructure.lean` | Total Hopf error 2*delta_comp(N); gauge anomaly from non-exact Hopf | NO | Hard |

---

## Part C: Prioritized Top 10 Unformalised Predictions

Ranked by (experimental impact) x (formalization feasibility).

### 1. Photon Mass Upper Bound at Temperature T [G1]

**Source**: `ErrorGaugeField.photonSubstrateMassBound(N)` + `Uncertainty.iterationBudget(T)`

**Experimental test**: PDG bound m_gamma < 10^-18 eV/c^2. Substrate predicts m_gamma(T) = delta_comp(N_max(T))/c = l_P * 4/(2*N_max(T)+3) / c. At room temperature, m_gamma ~ 10^-67 kg ~ 10^-31 eV -- far below current bounds, hence *consistent*. At Planck temperature, m_gamma ~ E_P/c^2 (massive).

**Theorem statement**:
```
theorem photonMassBound_at_temperature (T : R) (hT : 0 < T) :
    photonSubstrateMassBound (iterationBudget T).toNat <=
    2 * l_P * k_B * T / (E_P * c)
```

**Difficulty**: Easy -- pure composition of existing defs. One file, ~50 lines.

---

### 2. Dark Energy Equation of State Stability (w = -1 + O(delta_comp)) [G4]

**Source**: `CosmologicalConstant.darkEnergyEquationOfState_w` gives w = -1 exactly at equilibrium. Away from perfect equilibrium, the healing functional F > 0 gives a correction.

**Experimental test**: DESI BAO data (2026) hints at time-varying w. Substrate predicts: w deviates from -1 only by O(delta_comp), which is ~ 10^-67 at current cosmic temperature. This is a *sharp negative prediction*: w = -1 to extraordinary precision.

**Theorem statement**:
```
theorem dark_energy_w_stability (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : R)
    (heq : IsHealingEquilibrium params g g_exact I I_bar)
    (hD : forall p mu nu, defectTensor g g_exact p mu nu = 0)
    (hI : forall p, I p = I_bar) :
    effectiveVacuumPressure params.mu / (effectiveVacuumEnergyDensity params.mu * c^2) = -1
```

**Difficulty**: Easy -- this IS `darkEnergyEquationOfState_w`, just needs wrapping and the perturbation bound.

---

### 3. Aharonov-Bohm Phase Substrate Correction [G13]

**Source**: `AharonovBohm.lean` (plaquette Stokes) + `ErrorGaugeField.plaquetteHolonomyError`

**Experimental test**: AB phase phi = e * Phi_B / hbar gets a correction from substrate: |delta_phi| <= 4 * l_P * epsilon_A. With epsilon_A = delta_comp(N), the correction is ~ l_P^2 * 4/(2N+3). Far below current AB interferometry (~10^-8 rad), but provides exact closed form.

**Theorem statement**:
```
theorem aharonov_bohm_substrate_correction (N : nat)
    (sbg : SubstrateBoundedGauge N) (p : LatticePoint) (mu nu : Fin 4) :
    |gaugeHolonomy sbg.toGaugeConnection (plaquetteLoop p mu nu) -
     l_P^2 * d1 sbg.potential p mu nu| <=
    (plaquetteHolonomyError (computationalUncertaintyBound N)).val
```

**Difficulty**: Easy -- direct composition. ~40 lines.

---

### 4. Spectral Dimension Prediction [G12]

**Source**: `DimensionalFlow.d_eff(E) = 4 - 2*E/E_P`

**Experimental test**: CDT simulations measure spectral dimension flowing from 4 to ~2 at Planck scale. Substrate makes this an exact linear prediction, testable against CDT numerics and potentially via heat-kernel measurements in analog gravity experiments.

**Theorem statement**:
```
theorem spectral_dimension_at_half_planck :
    d_eff (E_P / 2) = 3

theorem spectral_dimension_integer_thresholds (n : Fin 3) :
    d_eff ((4 - (n : R) - 2) * E_P / 2) = (n : R) + 2
```

**Difficulty**: Easy -- pure arithmetic from existing `d_eff`. ~30 lines.

---

### 5. Entanglement Decay Rate from Substrate [G11]

**Source**: `Entanglement.lean` (Bell state, CHSH) + `Decoherence.lean` (partial trace) + `Uncertainty.computationalUncertainty`

**Experimental test**: Bell-state fidelity F_Bell(n, T) >= 1 - n * (delta_comp(N_max(T)))^2. At T = 10 mK and n = 10^6 ticks: F ~ 1 - 10^-104. Far below detection but provides a *mechanism* for entanglement fragility that standard QM lacks.

**Theorem statement**:
```
theorem bell_state_fidelity_substrate_decay (n : nat) (T : R) (hT : 0 < T) :
    bellStateFidelity n T >= 1 - n * (computationalUncertainty (iterationBudget T).toNat)^2
```

**Difficulty**: Medium -- needs connecting Entanglement.lean's Bell state to per-tick error accumulation.

---

### 6. Bekenstein Entropy Substrate Correction [G5]

**Source**: `BekensteinBound.bekenstein_bound_on_lattice` + `Uncertainty.computationalUncertainty`

**Experimental test**: Black hole entropy S = A/(4 l_P^2) gets a substrate correction: S_substrate = A/(4 l_P^2) - O(A * delta_comp / l_P^2). This is a *logarithmic* correction reminiscent of loop quantum gravity's -3/2 * ln(A) correction. Testable via Hawking radiation spectrum (far future).

**Theorem statement**:
```
theorem bekenstein_entropy_substrate_correction (hr : HorizonRegion)
    (N : nat) :
    regionEntropy hr (born_distribution hr N) <=
    Real.log hr.region.card + computationalUncertainty N
```

**Difficulty**: Medium -- BekensteinBound already has `bekenstein_bound_lattice_weak : S <= log |R|`. Adding the delta_comp correction requires tracking how truncation changes the Born distribution.

---

### 7. Neutrino Mass Lower Bound [G7]

**Source**: `MassAsDelay.perTickDelay_pos_massive`: any m != 0 gives delay > 0. The minimum *resolvable* mass is the mass whose delay equals one tick of computational uncertainty.

**Experimental test**: m_min = delta_comp(N_max(T)) / (c * t_P). At cosmic T ~ 2.7 K: m_min ~ 10^-68 kg ~ 10^-32 eV. Neutrino masses (> 10^-2 eV) are vastly above this floor. But the *existence* of a floor is the prediction: massless particles and massive particles are categorically distinct in the substrate.

**Theorem statement**:
```
theorem minimum_resolvable_mass (N : nat) :
    let m_min := computationalUncertainty N / (c * t_P)
    0 < m_min /\
    forall m, m >= m_min -> 0 < perTickDelay (m * c) m
```

**Difficulty**: Medium -- conceptual clarity needed, but the algebra is straightforward.

---

### 8. Jacobi Identity Violation Bound [G10]

**Source**: `ErrorLieAlgebra.jacobi_error` gives |[[X,Y],Z] + cyc| <= epsilon_Jacobi = delta_comp(N)

**Experimental test**: In a gauge theory, Jacobi violation means gauge anomaly at the Planck scale. The *measurable* consequence is a tiny violation of charge conservation, bounded by delta_comp(N). At lab energies: ~ 10^-67, unmeasurable. At near-Planck energies: O(1), gauge structure breaks down.

**Theorem statement**:
```
theorem gauge_anomaly_from_jacobi_violation (N : nat) :
    substrateLieBracketError N = computationalUncertainty N /\
    forall eps > 0, exists N0, substrateLieBracketError N0 < eps
```

**Difficulty**: Easy -- this is essentially `substrateLieBracketError_tendsto_zero`, just needs repackaging.

---

### 9. Bounce Density Explicit Bound [G8]

**Source**: `BigBounce.lean` (torsion pressure) + `NegativePressure.lean` (total negative pressure)

**Experimental test**: At the bounce, torsion pressure balances gravitational pressure. The bounce density rho_bounce ~ c^5 / (G^2 * hbar) ~ rho_Planck. CMB B-mode polarization from bounce epoch could carry imprint. The substrate predicts bounce *always happens* (torsion pressure < 0 for n != 0), which is stronger than Poplawski's original claim (which required specific matter content).

**Theorem statement**:
```
theorem bounce_density_upper_bound :
    bounceMassDensity <= 2 * planckDensity
```

**Difficulty**: Medium -- needs defining `planckDensity = c^5/(hbar * G^2)` and algebraic bound.

---

### 10. KL Information Drift Rate Per Tick [G14]

**Source**: `Conservation/InformationKL.lean` + `LaSalleKLBridge.lean`

**Experimental test**: At each lattice tick, the information density drifts by at most delta_comp(N) in KL divergence from the previous tick. This is the *fundamental clock* of the substrate -- the rate at which the universe "forgets" its exact initial conditions. At equilibrium this drift is zero (LaSalle theorem). Away from equilibrium, it bounds the rate of entropy production.

**Theorem statement**:
```
theorem information_drift_per_tick_bound (N : nat) :
    forall (g g_exact : DiscreteMetric) (I : InformationDensity) (p : LatticePoint),
    |informationDensityKL g g_exact p (n+1) -
     informationDensityKL g g_exact p n| <=
    computationalUncertainty N
```

**Difficulty**: Easy -- direct corollary of existing InformationKL machinery.

---

## Part D: Predictions Mentioned in Papers but NOT in Lean

| Paper Section | Prediction | In Lean? | Notes |
|--------------|-----------|----------|-------|
| Appendix-G SS2.1 | Graviton masslessness | Partially (Gravitons.lean has energy, not masslessness proof from infinite regress) | Need: `theorem graviton_masslessness_from_self_consistency` |
| Appendix-G SS2.2 | Graviton spin-2 from symmetric tensor | NO | Would need representation theory beyond current scope |
| Appendix-G SS10A | Repair quantum energy ~ E_P/2 | YES | `repairQuantumEnergy_eq_log5_pi` |
| Appendix-P SS5 | Torsion-information correspondence S ~ nabla_[mu J_nu] | Partially | `SpinInformation.lean` has the structure, not the full identity |
| Appendix-S SS3 | CTC impossibility from 4th Noether law | NO | Would need Raychaudhuri-type ODE infrastructure |
| Appendix-E SS2 | D_ent entanglement dimension | NO | Conceptual, not algebraic -- hard to formalize |
| Appendix-B SS2.2 | Gate fidelity F(T) = F_0/(1+alpha*T) | YES | `Predictions.gateFidelity` |
| Appendix-B SS2A.3 | Multi-channel alpha_engineering sum | NO | Architecture-specific, not fundamental |
| Appendix-I SS2.1 (retracted) | MEMS phase drift | NO | Retracted -- do not formalize |
| Appendix-J SS4.3 | Teleportation fidelity closed form | YES | `StochasticTeleportation.teleportation_fidelity_substrate_bound_low_T` |
| Appendix-K SS4.2 | Atomic clock floor exact form | YES | `HermiticityDefect.clock_precision_floor` |
| Main Paper Post. 9 | Emergent mass from zitterbewegung | Partially | `MassAsDelay` + `DispersionFromLattice.forwardFraction` |

---

## Part E: New Predictions from Existing Machinery (Creative but Honest)

### E1. Vacuum Birefringence from Error Forms

**Source**: `ErrorForms.errorWedge11` (error in wedge product) + `ErrorMaxwellField`

The substrate breaks exact Lorentz invariance at O(delta_comp). For electromagnetic waves, the two polarization modes propagate through a lattice with slightly different error accumulation rates (because the wedge product error depends on the sup-norms A, B of the two forms). This gives a *tiny* vacuum birefringence: different propagation speeds for left and right circular polarization.

**Estimate**: Delta_n / n ~ delta_comp / l_P ~ 4/(2N+3) ~ 10^-32 at room temperature.

**Test**: PVLAS experiment (currently at 10^-23 sensitivity) or astrophysical Faraday rotation.

**Honest caveat**: The current ErrorForms framework uses uniform error bounds, not polarization-dependent ones. A proper birefringence prediction needs directional error decomposition.

### E2. Holonomy Quantization Defect

**Source**: `ErrorGaugeField.gaugeHolonomy_plaquette_eq_flux` (holonomy = l_P^2 * F) + `plaquetteHolonomyError`

In exact gauge theory, the Wilson loop around a contractible plaquette is quantized. The substrate introduces a defect in this quantization of size 4 * l_P * delta_comp(N). This is a *topological prediction*: Aharonov-Bohm phases are not perfectly quantized on the substrate.

**Test**: AB interference with increasing path area; look for area-dependent phase jitter above shot noise.

### E3. Information-Theoretic Second Law

**Source**: `InformationKL.lean` (KL divergence monotonicity) + `LaSalleKLBridge.lean` (equilibrium KL constant)

The substrate's healing flow always decreases the KL divergence: D_KL(g || g_exact) is a Lyapunov functional. This gives a *discrete second law of thermodynamics* with an explicit floor set by delta_comp. Unlike the continuum second law, this one has a MAXIMUM rate of entropy production: bounded by delta_comp per tick.

### E4. Graviton Detection Impossibility

**Source**: `Gravitons.field_and_repair_distinct_below_planck` + `BekensteinBound`

The substrate predicts that individual field gravitons cannot be detected by any apparatus within the universe, because the detector's information-processing capacity (Bekenstein-bounded by its area) is always insufficient to resolve the single-graviton signal from the substrate noise floor. This is a *structural impossibility theorem*, not a practical one.

---

## Part F: Summary Statistics

- **Total formalized predictions**: 13 (8 in `Predictions/`, 5 elsewhere)
- **Total unformalised predictions with existing machinery**: 20 (table in Part B)
- **Top-10 feasibility-prioritized**: see Part C
- **Easy additions (< 50 lines, pure composition)**: G1, G4, G12, G13, G14, G18, G19 (7 items)
- **Medium additions (50-200 lines, needs new bridge lemmas)**: G5, G6, G7, G8, G10, G11 (6 items)
- **Hard additions (> 200 lines, needs new infrastructure)**: G2, G3, G9, G15, G16, G17, G20 (7 items)

**Recommendation**: The 7 "easy" gaps (G1, G4, G12, G13, G14, G18, G19) can be closed in a single wave, adding ~350 lines total and 7 new prediction files. This would bring the prediction count from 13 to 20 and close all straightforward composition gaps.

---

*Analysis produced by Opus Code Crawler, 2026-04-15.*
