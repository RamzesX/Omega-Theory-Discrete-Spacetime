# OmegaTheory V2 — Roadmap cykli 24-43

**Status po cycle 23:** 3818 jobs GREEN, 0 sorry, 8 physical axioms, ~11,000 declarations, 14 cycles (9-23) shipped, `omega_theory_grand_capstone` jako signature theorem.

**Źródła tej roadmapy:** Achird (`achird_Q4_omega_algebra_roadmap_20_waves`) + Algieba (`algieba_F1_omega_algebra_complete_generator_audit`, `algieba_F3_cross_sector_interaction_audit`). Raporty: `GROTHENDIECK_FULL_POWER_REPORT.md` (Achird, w grafie — REPORT.md nie został zapisany przez turn-limit) + `plans/GROTHENDIECK_FOLLOWUP_REPORT.md` (Algieba, na dysku).

**Build rules (IMMUTABLE):** 0 sorry, 0 new axioms, full project GREEN przed każdym merge.

---

## Top 3 "must-prove" bridge theorems

Te trzy definiują success jako OmegaTheoryV2 paper-complete Standard Model derivation.

| # | Theorem | Co zamyka | Target cycle |
|---|---|---|---|
| 1 | `sm_gauge_group_from_error_algebra_aut` | SU(3)×SU(2)×U(1) = Aut(Ω-error-algebra) — DERIVED zamiast axiomatized | **24** |
| 2 | `fourth_irrational_sterile_neutrino_dm_mass_derived` | DM mass z 4-tego irrational kanału (Catalan G kandydat) | **32** |
| 3 | `redshift_reservoir_equals_lambda_cc_identity` | `∫ gravRedshiftCost dt = Λ_CC` formalna identyfikacja | **33** |

## 2 wysokopriorytetowe bridge gaps (Algieba F3)

| Gap | Obecny stan grafu | Cel cycle |
|---|---|---|
| **EM ↔ Weak** | 2 APPLIES edges, tylko Weinberg angle — substrate-level EW unification BRAK | **24** |
| **DM ↔ DE** | 0 edges, brak `Ω_M + Ω_DM + Ω_Λ = 1` closure | **25** |

---

## 20 waves (cycles 24-43) = ~120 new theorems

### Phase A: SM gauge derivation (cycles 24-26)

**Cycle 24 — Substrate EW unification**
1. `U(1)_Y_from_photon_repair` — derivation of U(1)_Y from photon sector
2. `SU(2)_L_from_weak_repair` — derivation of SU(2)_L from weak sector
3. `electroweak_unification_from_omega_algebra` — SU(2)×U(1) → U(1)_EM
4. `weinberg_angle_derived_not_fitted` — sin²θ_W from algebra
5. `higgs_doublet_from_scalar_field_tensor_structure`
6. `spontaneous_symmetry_breaking_from_healing_flow`

**Cycle 25 — Ω_total closure + DM-DE bridge**
1. `omega_total_equals_one_substrate` — Ω_M + Ω_DM + Ω_Λ = 1
2. `sterile_neutrino_density_contribution` — Ω_DM from 4th irrational mass
3. `reservoir_density_evolution` — dΩ_Λ/dt z photon redshift
4. `matter_density_freeze_out` — Ω_M evolution z baryogenesis
5. `Ω_constraint_friedmann_consistency`
6. `cosmological_equation_state_w_equals_minus_one_closure`

**Cycle 26 — SU(3) derivation**
1. `SU(3)_C_from_color_repair` — derivation of strong gauge group
2. `QCD_confinement_from_error_algebra`
3. `asymptotic_freedom_derived` (strengthen cycle-14 substrate version)
4. `gluon_self_coupling_from_lie_algebra_structure`
5. `quark_color_assignment_from_algebra`
6. `jet_hadronization_substrate_mechanism`

### Phase B: Connes closure (cycles 27-28)

**Cycle 27 — Connes spectral action**
1. `spectral_action_equals_einstein_hilbert` — gravity from D_F
2. `spectral_action_includes_yang_mills` — gauge kinetic terms from D_F
3. `heat_kernel_a_0_coefficient_closed` (cosmological constant)
4. `heat_kernel_a_2_coefficient_closed` (Einstein-Hilbert)
5. `heat_kernel_a_4_coefficient_closed` (gauge + curvature²)
6. `connes_noncommutative_volume_bound`

**Cycle 28 — Connes algebra closure**
1. `omega_error_algebra_equals_connes_inner_algebra`
2. `inner_automorphisms_equal_SM_gauge`
3. `outer_automorphisms_equal_diffeomorphisms`
4. `spectral_triple_omega_satisfies_axioms`
5. `dixmier_trace_equals_substrate_integration`
6. `connes_to_omega_equivalence_categorical`

### Phase C: Full mass spectrum (cycles 29-31)

**Cycle 29 — Yukawa matrix full**
1. `yukawa_matrix_all_9_entries` (6 quarks + 3 leptons)
2. `fermion_mass_hierarchy_derived_not_fitted`
3. `koide_relation_from_irrationals` (strengthen existing)
4. `neutrino_yukawa_via_seesaw_mechanism`
5. `quark_up_down_mass_ratio_derived`
6. `lepton_universality_from_yukawa_structure`

**Cycle 30 — Higgs sector closure v2**
1. `higgs_mass_derived_from_potential_tree_level` (strengthen Zubeneschamali)
2. `higgs_self_coupling_at_planck_scale`
3. `vacuum_stability_up_to_planck`
4. `electroweak_vacuum_metastability_bound`
5. `higgs_portal_to_dark_sector_bounded`
6. `higgs_inflaton_identification_candidate`

**Cycle 31 — CP and flavor phases**
1. `ckm_dirac_phase_derived_from_substrate`
2. `jarlskog_invariant_derived_not_fitted`
3. `pmns_dirac_phase_derived`
4. `majorana_phases_from_4th_irrational`
5. `cp_violation_quark_lepton_ratio`
6. `strong_cp_theta_bar_zero_mechanism` (alternative to Peccei-Quinn)

### Phase D: Dark sector (cycles 32-33)

**Cycle 32 — Sterile neutrino mass derivation**
1. `fourth_irrational_identification_catalan_or_zeta3`
2. `sterile_neutrino_mass_formula_from_4th_irrational`
3. `sterile_production_mechanism_freeze_in`
4. `sterile_relic_abundance_matches_omega_dm`
5. `sterile_galactic_halo_formation_consistency`
6. `sterile_substrate_first_dm_particle_derivation_in_v2`

**Cycle 33 — DE reservoir identity**
1. `redshift_reservoir_accumulator_definition`
2. `reservoir_time_integration_equals_lambda`
3. `photon_coherence_loss_rate_formula`
4. `lambda_cc_derived_from_cosmic_age` (~14 Gyr × coherence_loss_rate)
5. `de_not_particle_theorem` (formal no-quanta statement)
6. `omega_theory_dark_sector_unification`

### Phase E: Flavor mixing completion (cycles 34-35)

**Cycle 34 — CKM full derivation**
1. `ckm_matrix_9_entries_all_derived` (not fitted)
2. `ckm_unitarity_triangle_angles_derived`
3. `wolfenstein_lambda_A_rho_eta_from_irrationals`
4. `ckm_anomaly_free_from_gauge_automorphism`
5. `b_physics_observables_from_substrate`
6. `rare_kaon_decay_predictions`

**Cycle 35 — PMNS full derivation**
1. `pmns_matrix_full_derivation`
2. `neutrino_mass_ordering_normal_vs_inverted_predicted`
3. `dirac_vs_majorana_nature_discriminated`
4. `leptogenesis_asymmetry_formula`
5. `neutrino_dispersion_relation`
6. `cosmic_neutrino_background_temperature`

### Phase F: Baryogenesis + cosmology (cycles 36-38)

**Cycle 36 — Baryogenesis complete**
1. `sakharov_first_condition_promoted_theorem` (B violation via 4th-irrational)
2. `sakharov_second_condition_promoted_theorem` (CP from mixing + δ_CP)
3. `sakharov_third_condition_promoted_theorem` (out-of-equilibrium via inflation exit)
4. `baryon_asymmetry_magnitude_derived` (η ≈ 6.1e-10)
5. `leptogenesis_vs_electroweak_baryogenesis_discrimination`
6. `substrate_baryogenesis_existence_theorem_v2`

**Cycle 37 — Inflation + early universe**
1. `inflaton_potential_from_substrate_scalar_field`
2. `slow_roll_parameters_derived`
3. `spectral_index_n_s_derived` (strengthen Ras Algethi)
4. `tensor_to_scalar_ratio_r_derived` (strengthen Alshain)
5. `reheating_temperature_from_coupling_to_matter`
6. `inflation_horizon_exit_e_folds_mechanism`

**Cycle 38 — Late-time cosmology**
1. `friedmann_equation_from_substrate`
2. `hubble_constant_time_evolution`
3. `de_sitter_asymptotic_state_attractor`
4. `cosmological_coincidence_resolution`
5. `hubble_tension_resolution_via_local_reservoir`
6. `future_horizon_paradox_discussion`

### Phase G: Nuclear + proton (cycles 39-41)

**Cycle 39 — Proton decay**
1. `proton_decay_rate_from_gut_matrix_algebra`
2. `proton_lifetime_prediction_specific` (strengthen Alkaid)
3. `minimal_su5_excluded_formally`
4. `flipped_su5_consistent_test`
5. `so10_embedding_candidate`
6. `matter_stability_implication_for_substrate`

**Cycle 40 — Nuclear sector (chiral PT)**
1. `chiral_perturbation_theory_from_substrate`
2. `pion_nucleon_form_factors_substrate`
3. `nucleon_axial_radius_prediction`
4. `nucleon_electromagnetic_form_factors`
5. `nuclear_binding_large_nuclei_bound`
6. `nuclear_matter_equation_of_state`

**Cycle 41 — Meson spectroscopy extended**
1. `meson_mass_spectrum_all_octet`
2. `meson_decay_constants_all`
3. `quark_antiquark_potential_from_substrate`
4. `glueballs_mass_prediction`
5. `exotic_mesons_tetraquark_pentaquark_substrate`
6. `flavor_su3_breaking_quantified`

### Phase H: Capstone v2 (cycles 42-43)

**Cycle 42 — Unified algebraic presentation**
1. `omega_algebra_50_generators_theorem` — the full 26+24 structure
2. `omega_algebra_presentation_complete`
3. `sm_forces_as_autOmega_theorem`
4. `three_channel_partition_theorem_strong_form`
5. `irrationality_implies_qm_gr_sm_unified`
6. `falsifiability_test_experimental_predictions_list`

**Cycle 43 — Grand Capstone v2**
1. `omega_theory_grand_capstone_v2` — zamienia all "fit"-based headlines na DERIVED-based
2. `pi_hunch_fully_derived_theorem` (not hypothesis)
3. `substrate_is_sufficient_theorem` (no BSM needed beyond sterile ν + axion-optional)
4. `omega_theory_signature_proposition`
5. `paper_v2_abstract_lean_verified`
6. `final_capstone_builds_green_zero_sorry` (meta-theorem about project integrity)

---

## 33 missing generators (Algieba F1)

Do dodania do OmegaAlgebra dla paper-complete presentation:

### Tier 0 (spacetime primitives)
- `gravRedshiftCost` — DE carrier (!)
- `Event` — spacetime event primitive
- `SnapshotSequence` — time-evolution sequence
- `BlackHole` — BH as algebraic object

### Tier 1 (metric variants)
- `SmoothMetric`
- `MetricTensor`
- `SemiSmoothMetric`
- `ErrorBoundedSmoothMetric`

### Tier 2 (channel types)
- `IrrationalChannel` — abstract channel type (π/e/√2/4th)
- `relativisticEnergy`
- `LorentzFactor`

### Tier 3-5 (other derived primitives)
- ~20 more listed in `algieba_F1_omega_algebra_complete_generator_audit` GraphFinding

Query via Cypher:
```cypher
MATCH (gf:GraphFinding {name: 'algieba_F1_omega_algebra_complete_generator_audit'})
RETURN gf.missing_generators, gf.full_tier_breakdown
```

---

## Canonical naming scheme (Algieba F2)

55-row table persisted at:
```cypher
MATCH (gf:GraphFinding {name: 'algieba_F2_omega_algebra_canonical_names'})
RETURN gf.name_map
```

Highlights:
- `𝔏 = LatticePoint` (fraktur L)
- `g, d = metrics`
- `c, ℏ, G, k_B` (constants)
- `ε = computationalUncertainty`
- `δ_π, δ_e, δ_√2 = channel residuals`
- `Φ = ScalarField` (Higgs)
- `Ψ = LatticeComplexField` (wave fn)
- `F = FermionGeneration`
- `Γ_φ = PhotonCoherenceWorldline`

---

## Completion metric

After 20 waves complete (cycle 43):
- ~120 new theorems on top of current 11,000
- Leiden modularity ≥ 0.90 (from current ~0.45)
- Subsystem count converges to ~30 (from current 82)
- `omega_theory_grand_capstone_v2` cytuje all 3 SM gauge factors as **DERIVED** not axiomatized
- Paper-ready abstract for arXiv hep-ph submission
- All cycle-9-to-43 fit-based cycle headlines promoted to DERIVED
- Dark sector (DM sterile ν + DE reservoir) fully derived

**No sorry, no new axioms, full build GREEN at every cycle.**

---

## Spawn protocol for cycle 24

When ready to start cycle 24 (substrate EW unification), the 6 hunter prompt pattern:

```
Cycle 24, target X/6: [theorem name]
USE GRAPH FIRST: query via mcp__omega-search__retrieve_premises for:
  - [relevant existing theorems per cycle 24 target]
  - Mathlib lemmas via mcp__lean-lsp__lean_leansearch
Compose, do not re-derive.

Physics: [description]
Signature: [Lean statement]
Rules: 0 sorry, 0 new axioms, GREEN, register in Basic.lean, reserve star name, save identity.
45 min budget.
```

Cycle 24 targets (6):
1. `U(1)_Y_from_photon_repair`
2. `SU(2)_L_from_weak_repair`
3. `electroweak_unification_from_omega_algebra`
4. `weinberg_angle_derived_not_fitted`
5. `higgs_doublet_from_scalar_field_tensor_structure`
6. `spontaneous_symmetry_breaking_from_healing_flow`
