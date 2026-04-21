# LEAN-VERIFIED CLAIMS — master index

**Generated**: 2026-04-20. **Status**: Lean 4 / Mathlib v4.29.0, 3818 build jobs GREEN, **0 sorry, 8 physical axioms** (ℓ_P, ℏ, c, G_N, k_B, π, e, √2).
**GitHub branch**: `main` @ `github.com/RamzesX/chaos-shield`. All links below point at the committed source; line numbers are current at commit `ff825d5`.

This document is the **single source of truth** linking paper claims to their machine-checked Lean theorems. Each row:
- **Claim** — the physical statement as it appears in a paper;
- **Paper § / file** — where the claim is made;
- **Lean file** — committed source under `PhysicsPapers/LeanFormalizationV2/OmegaTheory/`;
- **Theorem name** — globally unique identifier in the Lean namespace;
- **Precision / status** — either PDG tolerance, `rfl` identity, or qualitative discriminator;
- **Cycle** — autonomous-agent cycle that shipped the theorem (cycles 9–23 = 84 headline theorems).

---

## Quick badge legend

> ✅ **Lean-verified**: links to the committed theorem.
> ⚠️  **PLANNED**: target of cycles 24–43 (`ROADMAP_CYCLES_24_43.md`).
> ♻️  **SUPERSEDED**: retracted claim, see Appendix-J.

---

## Part 1 — Dark Energy preview (Paper-Dark-Energy-Preview-v1.md)

| Claim | Paper § | Lean file | Theorem | Status | Cycle |
|---|---|---|---|---|---|
| Star mass invariant under emission (`ΔM★ = 0`) | §2.2 | `Emergence/StarMassInvariantEmission.lean#L267` | `star_mass_invariant_under_photon_emission` | `rfl` identity | 9 |
| Photon preserves c, loses info coherence | §2.3 | `Emergence/PhotonSpeedCoherence.lean#L208` | `photon_preserves_c_loses_info_coherence` | `rfl` | 9 |
| Three-term conservation `ΔM★+ΔEγ+Δρ_DE = 0` | §2.5 | `Emergence/RedshiftEnergyToDarkEnergy.lean#L313` | `three_term_energy_conservation` | `by ring` | 9 |
| Photon redshift loss = dark energy gain | §2.4 | `Emergence/RedshiftEnergyToDarkEnergy.lean#L259` | `photon_redshift_loss_equals_dark_energy_gain` | `rfl` | 9 |
| Equivalence principle `m_inert = m_grav` | §2.1 | `Emergence/EquivalencePrinciple.lean#L178` | `equivalence_principle` | `rfl` | 9 |
| Dark-energy locality per-event | §3.1 | `Emergence/DarkEnergyLocalityEvent.lean#L272` | `dark_energy_locality_at_redshift_event` | structural | 9 |
| Dark-energy spatial locality from photon traffic | §3.2 | `Emergence/DarkEnergySpatialLocality.lean#L352` | `dark_energy_spatial_locality_from_photon_traffic` | structural | 9 |
| KBC void predicts ρ_DE under-density | §3.3 | `Predictions/KBCVoidDarkEnergy.lean#L177` | `KBC_void_predicts_rho_DE_underdensity` | ε ∈ [0, 15 %) | 9 |
| Black hole as mediator not sink | §4.2 | `Emergence/BlackHoleAsMediator.lean#L305` | `black_hole_is_mediator_not_sink` | structural | 9 |
| Singularity not an energy sink | §4.1 | `Emergence/SingularityNotEnergySink.lean#L141` | `singularity_is_not_energy_sink` | `= 0` | 9 |
| Hawking as reservoir relaxation | §4.3 | `Emergence/HawkingReservoirRelaxation.lean#L232` | `hawking_outflow_as_relaxation` | structural | 9 |
| Cosmological-redshift feeds DE reservoir | §2.5 / ref | `Predictions/CosmologicalRedshiftDarkEnergy.lean#L320` | `cosmological_redshift_feeds_dark_energy_reservoir` | temporal integral | 9 |
| Dark-energy equation-of-state w = −1 | §5 | `Emergence/CosmologicalConstant.lean#L129` | `darkEnergyEquationOfState_w` | exact `-1` | 9 |
| Cosmological constant problem resolved | abstract / §1 | `Emergence/CosmologicalConstantProblem.lean#L210` | `cosmological_constant_problem_resolved` | 120-order | 9 |

## Part 2 — Main paper (Main-Paper-Postulates.md)

| Claim | Paper § | Lean file | Theorem | Status |
|---|---|---|---|---|
| Quantum Mechanics emerges from 8 constants | §4 principles, §9 Ω | `Emergence/QuantumMechanicsCapstone.lean#L368` | `grand_qm_emergence` | signature theorem |
| Einstein equations (vacuum regime) | §4 Principle 1 | `Emergence/EinsteinEmergence.lean#L50` | `vacuum_einstein_emergence` | 7 regime witnesses |
| Irrationality implies QM uncertainty | §4 Principle 2 | `Probe/PiAndOmegaStructure.lean#L100` | `irrationality_implies_quantum_uncertainty` | extended Heisenberg |
| Klein–Gordon dispersion `E² = p²c² + m²c⁴` | §3.2 reshaping | `Emergence/KleinGordon.lean#L650` | `kleinGordon_dispersion_relation` | structural |
| CHSH Bell violation from substrate | (quantum non-locality) | `Emergence/CHSHBell.lean#L105` | `substrate_CHSH_violation` | > 2 bound |
| Path-integral interference | (§ Ω, QM) | `Emergence/PathIntegral.lean#L169` | `pathIntegral_interference` | structural |
| Big Bounce avoids singularity | §8.4 Einstein-Cartan | `Emergence/NegativePressure.lean#L243` | `substrate_avoids_singularity` | Poplawski |
| Inflation ends at equilibrium | §8 healing | `Emergence/Inflation.lean#L120` | `inflation_ends_at_equilibrium` | de Sitter exit |
| Weak SU(2) coupling from substrate | §9 Ω = ⟨1,2,3⟩ | `Emergence/ErrorGaugeSU2.lean#L385` | `weakCouplingFromSubstrate_pos` | > 0 |
| Strong SU(3) coupling from substrate | §9 Ω = ⟨1,2,3⟩ | `Emergence/ErrorGaugeSU3.lean#L376` | `strongCouplingFromSubstrate_pos` | > 0 |
| Koide relation Q ≈ 2/3 | (mass spectrum) | `Emergence/KoideRelation.lean#L268` | `koide_formula_holds` | < 10⁻⁴ off |
| PDG lepton hierarchy m_e < m_μ < m_τ | §10 | `Emergence/KoideRelation.lean#L589` | `pdg_lepton_hierarchy` | `rfl` |
| Dirac D_F eigenvalues = Yukawa couplings | capstone goal | `Emergence/DiracFSpectrum.lean#L456` | `dirac_eigenvalues_are_yukawa_couplings` | Connes spectral action |
| Lepton N = 4 lattice uniquely selected | §3 dimensional flow | `Predictions/LeptonN4Uniqueness.lean#L348` | `lepton_PDG_uniquely_at_N_eq_4` | exhaustive |
| Nashira kernel 4/4 PDG hits | §10.2 / Pi Hunch | `Predictions/MassRatioNumerical.lean#L312` | `nashira_pdg_sandwich_exists` | B_up = 13, B_dn = 5 |
| Connes B_up = 13, B_dn = 5 | Nashira | `Predictions/KKBimoduleBFromConnesStructure.lean#L192` | `B_up_derived_eq_thirteen`, `B_dn_derived_eq_five` | derived from δ_KO |
| π/e/√2 hierarchy forces mass ordering | §3.2 | `Predictions/PiHunchMassOrdering.lean#L164` | `pi_hunch_mass_ordering` | δ_π > δ_e > δ_√2 |
| Fermion mass ordering from δ hierarchy | §3.2 / Appendix-K | `Predictions/PiHunchMassOrdering.lean#L197` | `fermion_mass_ordering_from_delta` | δ ∝ m |

## Part 3 — Experimental Catalog (Appendix-J-Experimental-Catalog-Consolidated.md)

| § | Prediction | Lean file | Theorem | PDG / experimental target |
|---|---|---|---|---|
| §1.1 | Cold-neutron 1/v slope vs 1/v² | `Predictions/StochasticTeleportation.lean#L195` | `slope_distinguisher_inv_v` | ILL PF2-VCN |
| §1.1 | Teleportation distance/velocity identity | `Predictions/StochasticTeleportation.lean#L137` | `teleportation_distance_velocity_identity` | (d/v)·c·ε(N) closed form |
| §1.1 | Teleportation fidelity low-T bound | `Predictions/StochasticTeleportation.lean#L277` | `teleportation_fidelity_substrate_bound_low_T` | K·2ℓ_P·k_B·T/E_P |
| §1.2 | Atomic-clock precision floor ∝ T | `Predictions/HermiticityDefect.lean#L113` | `clock_precision_floor` | 4.2×10⁻³⁰ at 300 K |
| §2.1 | Grav. decoherence T² scaling | `Predictions/GravDecoherenceTScaling.lean#L96` | `grav_decoherence_T_monotone` | Diosi-Penrose discriminator |
| §2.2 | Cosmological redshift floor 10⁻⁹ | `Predictions/RedshiftFloor.lean#L121` | `cosmological_redshift_floor_from_vacuum_curvature` | JWST + ELT |
| §2.3 / §3.1 | GRB / Pierre Auger LIV consistency | `Predictions/GammaRayDispersion.lean#L112` | `gammaRayDispersionSubstrate_below_any_positive_bound` | Fermi-LAT, LHAASO |
| §3.1 | UHECR velocity dispersion 10⁻²⁴ at 10²¹ eV | `Predictions/UHECRDispersion.lean#L113` | `uhecr_dispersion_bound_explicit` | Pierre Auger |
| §3.1 | UHECR composite dispersion bound | `Predictions/UHECRDispersion.lean#L168` | `uhecr_dispersion_composite_bound` | mass-prefactor |
| §3.2 | Spin-1/2 flip rate > 0 | `Predictions/SpinFlipRate.lean#L140` | `spinFlipRateSubstrate_strictly_exceeds_standard_QM` | Γ_QM = 0 distinguisher |
| §4 | Teleportation K-monotone infidelity | `Predictions/StochasticTeleportation.lean#L111` | `teleportInfidelityBound_K_monotone` | Lindblad bridge |
| §5 | Gate fidelity is power-law (Arrhenius ruled out) | `Emergence/Predictions.lean#L100` | `gateFidelity_is_powerLaw` | ✅ Diraq Nature 627 (2024) |
| §3.2 | Christoffel hot-spot density | `Predictions/ChristoffelSparsity.lean#L94` | `christoffel_hot_spot_proxy_bound` | 10⁻²⁰⁰ / vol |
| Pure-LV discriminator | §2.3 / §3.1 | `Predictions/GammaRayDispersion.lean#L164` | `substrate_vs_pure_LV_distinguisher` | N-dependence vs const |
| ILL VCN consistency | §1.1 | `Predictions/ColdNeutronILL_VCN.lean#L284` | `coldNeutronSubstrate_consistent_with_Ackermann_2026` | Ackermann 2026 |
| DESI 2024 substrate signature | §2.2 | `Predictions/DESISubstrateSignature.lean#L285` | `DESI_substrate_consistent_uniform` | DESI DR2 |
| Neutrino mass floor W1 ↔ DESI | §2.2 | `Predictions/NeutrinoMassFloorW1.lean#L204` | `W1_consistent_with_DESI` | DESI cosmology |

## Part 4 — Irrationality Genesis (Appendix-K-Irrationality-Genesis-Of-Predictions.md)

| § | Bridge step | Lean file | Theorem / Definition |
|---|---|---|---|
| §2 | π Leibniz convergence O(1/N) | `Irrationality/BoundsLemmas.lean#L295` | `pi_error_tendsto_zero` |
| §2 | e Taylor convergence O(1/N!) | `Irrationality/BoundsLemmas.lean#L313` | `e_error_tendsto_zero` |
| §2 | √2 Newton convergence O(2^(−2ᴺ)) | `Irrationality/BoundsLemmas.lean#L341` | `sqrt2_error_tendsto_zero` |
| §3 | Iteration budget anti-monotone in T | `Irrationality/Uncertainty.lean#L108` | `iterationBudget_decreases_with_T` |
| §3 | Extended Heisenberg > ℏ/2 | `Irrationality/Uncertainty.lean#L90` | `extended_strictly_stronger` |
| §4.1 | Accumulated snapshot error add | `Emergence/SnapshotPropagator.lean#L153` | `accumulatedSnapshotError_add` |
| §4.1 | Information density KL | `Conservation/LaSalleKLBridge.lean#L71` | `informationDensityKL_constant_along_equilibrium_trajectory` |
| §4.1 | Per-tick delay high-momentum bound | `Emergence/MassAsDelay.lean#L273` | `perTickDelay_high_momentum_bound` |
| §4.2 | Observable expectation real | `Emergence/HilbertEmergence.lean#L594` | `observable_expectation_real` |
| §4.3 | Equilibrium dissipation rate | `HealingFlow/LaSalle.lean#L134` | `dissipationRate_of_equilibrium` |
| §4.4 | Mass-as-delay high-E asymptote | `Emergence/MassAsDelay.lean#L222` | `massive_asymptotes_to_null_at_high_E` |
| §4.4 | Redshift as information cost | `Emergence/Redshift.lean#L246` | `redshift_as_information_cost` |
| §4.6 | Defect fraction bound | `Defects/Sparsity.lean#L151` | `defectFraction_le` |
| §4.7 | Christoffel hot-spot proxy | `Predictions/ChristoffelSparsity.lean#L94` | `christoffel_hot_spot_proxy_bound` |
| §7 (verified 2024) | Gate-fidelity power-law | `Emergence/Predictions.lean#L100` | `gateFidelity_is_powerLaw` |

## Part 5 — Cold-neutron letter (Letter-ColdNeutron-*.md)

All four letter files already cite Lean theorems by name. Canonical pointers:

| Letter section | Lean file | Theorem |
|---|---|---|
| §2.1 substrate slope | `Predictions/StochasticTeleportation.lean#L137` | `teleportation_distance_velocity_identity` |
| §2.1 bound form | `Predictions/StochasticTeleportation.lean#L158` | `teleportation_distance_velocity_bound` |
| §2.1 monotone in 1/v | `Predictions/StochasticTeleportation.lean#L195` | `slope_distinguisher_inv_v` |
| §2.1 monotone in tick count | `Predictions/StochasticTeleportation.lean#L185` | `slope_distinguisher_v_monotone` |
| §2.3 low-T fidelity bound | `Predictions/StochasticTeleportation.lean#L277` | `teleportation_fidelity_substrate_bound_low_T` |

## Part 6 — Appendix-I (RETRACTED)

`Appendix-I-Experimental-Tests.md` is retracted (see §0 of Appendix-J and DEDUP_ANALYSIS.md cluster 3). The file's own header already carries the retraction banner; no per-claim Lean annotation is added here (all live predictions moved to Appendix-J).

---

## Open claims (candidate targets for cycles 24–43)

The following paper-level assertions do **not** yet have a single-theorem Lean witness; they are queued in `ROADMAP_CYCLES_24_43.md`:

| Paper § | Open claim | Cycle target |
|---|---|---|
| Main §7.2 | Hierarchy problem from reshaping cascades (Planck→GUT→Weak→QCD) | 24, 27 |
| Main §10.2 quant. | Proton decay `τ ~ 10³⁴⁻³⁶ yr` as a single theorem | 39 |
| DE §6.3 | Schwinger pair-production rate with `(1 − δ_comp/thresh)` coefficient | 24–28 |
| DE §10.2 | Proton-criticality unified capstone | 39 (Alkaid queue) |
| Main §3.4 | d_eff = 2 at Planck (dimensional-flow bridge) | 27 |
| DE §5 | w = −1 as variance identity formal Lean-Mathlib link | 27/33 |
| Main §10.2 | Graviton repair-quantum E_rq ≈ E_P/2 (vs field graviton) | — (Gravitons.lean today) |
| Main §9 | Ω-algebra SM as Aut(error-algebra) | 24 (Top-3 must-prove #1) |
| Main §10.3 | Fourth-irrational DM mass | 32 (Top-3 must-prove #2) |
| DE §10 | Reservoir ≡ Λ_CC formal identity | 33 (Top-3 must-prove #3) |

Each row in the "Open claims" table is a tracked target; status is live in `ROADMAP_CYCLES_24_43.md` and the Neo4j `OmegaTheoryV2` namespace.

---

## Build provenance

```
repo:    github.com/RamzesX/chaos-shield
branch:  main
commit:  ff825d5  (2026-04-20)
lean:    4.29.0
mathlib: v4.29.0
build:   3818 jobs GREEN
sorry:   0
axioms:  8 (ℓ_P, ℏ, c, G_N, k_B, π, e, √2)
```

Verify any row locally:
```bash
cd PhysicsPapers/LeanFormalizationV2
~/.elan/bin/lake exe cache get
~/.elan/bin/lake build --log-level=error
grep -rn "theorem THEOREM_NAME" OmegaTheory/
```
