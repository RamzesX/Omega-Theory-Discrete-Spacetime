# `:TheoremCandidate` — live export from Neo4j

*Auto-generated snapshot. The authoritative list is the Neo4j `math` container; this file is a denormalized view for browsing. Re-generate with the Cypher at the bottom.*

↑ [chaos-shield root](../../README.md) · [OmegaTheoryAlgebra](README.md)

---

## Query used

```cypher
MATCH (c:TheoremCandidate)
RETURN coalesce(c.status, 'NULL') AS status,
       coalesce(c.name, '(no name)') AS name,
       coalesce(c.namespace, '—') AS ns,
       coalesce(c.source_wave, c.wave, c.cycle, '—') AS origin,
       coalesce(c.description, c.claim, c.note, '') AS claim
ORDER BY status, name;
```

Run inside the `math` Docker container via `cypher-shell -u neo4j -p omegatheory2026 -d neo4j --format plain ...`. Live reproduction:

```bash
docker exec math cypher-shell -u neo4j -p omegatheory2026 -d neo4j --format plain '<above query>' > CANDIDATES_EXPORT.md.tsv
```

---

## Status summary (2026-04-22, post wave 3)

| Status | Count | Meaning |
|---|--:|---|
| `PROVEN` | 47 | Lean proof exists, landed pre-wave-1 |
| `NULL` | 24 | legacy / pre-MP (post-wave-3 triage reduced 84 → 24) |
| `PROPOSED` | 16 | open — not yet written in Lean (post-wave-3 triage reduced 46 → 16) |
| `BLOCKED_ON_MATHLIB` | 13 | waiting on upstream Mathlib (e.g. Connes reconstruction, CMB observation types) |
| `SUPERSEDED_BY_WAVE3` | 12 | deprecated in favor of wave-3 canonical forms, `:SUPERSEDES` edge in graph |
| `CANDIDATE` | 6 | alt label for proposed, retained for back-compat |
| `CLOSED` | 6 | landed in Lean (legacy tag pre-`CLOSED_BY_LEAN_LANDING` edge) |
| `GREEN` / `PROVED_GREEN` | 4 + 1 | landed + build green |
| `BLOCKED_ON_FRAMEWORK` | 3 | waiting on framework gap (distinct from Mathlib) |
| `CONJECTURAL` | 2 | research conjecture, no clear approach |
| `OPEN` | 2 | actively being worked on |
| `OPEN_PROBLEM` | 1 | hard research problem, no known approach |
| `STATEMENT_READY` | 1 | statement Lean-parseable, proof pending |
| `PROVABLE_TODAY` | 1 | agent-tagged as trivial, not yet written |
| `FRONTIER_SCAFFOLDED` | 1 | scaffold present, awaiting flesh |
| `ALREADY_CLOSED` | 1 | landed under a different name |
| `BLOCKED_STATEMENT` | 1 | statement blocked on a missing definition |
| `DELIVERED` / `DONE` | 1 + 1 | landed + paper deliverable |

**Total: 310 `:TheoremCandidate` nodes** (was 259 pre-wave-3; +51 from 18 wave-3 landings + new candidates generated + 33 external audit triage).

**Edges `[:CLOSED_BY_LEAN_LANDING]`: 42 distinct candidates closed via explicit edge** (wave-1 ×6 + wave-2 ×21 + wave-3 ×18 minus overlap).

### Wave-by-wave delta

| | Wave-2 (pre-Aludra) | Wave-3 (post-Spica) | **Wave-4 (post-parallel team)** | Δ total |
|---|--:|--:|--:|--:|
| Total `:TheoremCandidate` | 259 | 310 | **310+** | +51+ |
| PROPOSED | 46 | 16 | 16 (stable — wave-4 worked cycle list, not MP puzzle) | **-30** |
| NULL | 84 | 24 | 24 (stable) | **-60** |
| CLOSED_BY_LEAN_LANDING (edge) | 21 | 42 | **117** | **+96** |
| SUPERSEDED_BY_WAVE3 | 0 | 12 | 12 | +12 |
| BLOCKED_ON_MATHLIB | — | 13 | 13 | +13 |

**Wave-4 (2026-04-22, 5-wizard parallel team)** landed 30 headline theorems in 5 new files (`CosmologyWave4Fits.lean`, `ParticleWave4Fits.lean`, `IrrationalityClasses/Wave4Landings.lean`, `GaugeDualsWave4.lean`, `FrontierWave4.lean`) — bucket B's alias-based approach surfaced ~45 extra pre-wave-1 fits into CLOSED_BY_LEAN_LANDING edges, hence the 42→117 jump. Full-tree `lake build` GREEN at **3,862 jobs**, 0 sorry, 24 axioms unchanged.

---

## Full dump (status, name, namespace, origin, claim)

```tsv
status, name, ns, origin, claim
"ALREADY_CLOSED", "su3_jacobi_full_4093_cases_closed", "—", "—", ""
"BLOCKED_ON_FRAMEWORK", "ic_e_is_E_function_value", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_FRAMEWORK", "ic_e_vs_pi_E_function_separation", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_FRAMEWORK", "ic_pi_is_not_E_function_value", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "LeanAlgebraLaplacian_spectrum_card_eq_six", "OmegaTheoryV2", "—", "The 6x6 Magnetic Laplacian has 6 real eigenvalues (Hermitian matrices over C have real spectrum with multiplicity = dim). Requires Mathlib Matrix.IsHermitian.eigenvalues + RCLike/InnerProductSpace machinery to materialize the Fin 6 -> R eigenvalue function. Base IsHermitian proof LeanAlgebraLaplacian_isHermitian already shipped in cycle 44 by Alrischa."
"BLOCKED_ON_MATHLIB", "ic_EFunction_structure_def", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_Hermite_1873_port_to_Mathlib", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_Lindemann_Weierstrass_to_Mathlib", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_Mahler_classification_framework", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_Roth_theorem_port", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_Shidlovsky_theorem_port", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_e_Mahler_S_with_omega_eq_1", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_exp_one_transcendental", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_irrationality_measure_framework", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_pi_transcendental_wrap", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_rivoal_zudilin_2003_port", "OmegaTheoryV2", "—", ""
"BLOCKED_ON_MATHLIB", "ic_sqrt2_Mahler_A_class", "OmegaTheoryV2", "—", ""
"BLOCKED_STATEMENT", "photon_info_cost_diverges_at_horizon", "OmegaTheoryV2", "—", ""
"CANDIDATE", "CKMVubFit", "OmegaTheoryV2", 13, ""
"CANDIDATE", "DownQuarkMassFit", "OmegaTheoryV2", 13, ""
"CANDIDATE", "NeutrinoMassSumBound", "OmegaTheoryV2", 13, ""
"CANDIDATE", "StrongCPThetaBound", "OmegaTheoryV2", 13, ""
"CANDIDATE", "TopQuarkWidthFit", "OmegaTheoryV2", 13, ""
"CANDIDATE", "UpQuarkMassFit", "OmegaTheoryV2", 13, ""
"CLOSED", "channel_norm_ordering_matches_residual_ordering", "OmegaTheoryV2", "—", ""
"CLOSED", "extendedBound_stability", "OmegaTheoryV2", "—", "Perturbing pi by epsilon < truncationMargin preserves the bound."
"CLOSED", "extendedBound_tightness", "OmegaTheoryV2", "—", "No strengthening of hbar/2 + delta_comp(N) is derivable from OmegaTheoryAxioms."
"CLOSED", "four_channel_fibration_over_subsystem", "OmegaTheoryV2", "—", ""
"CLOSED", "omega_base_site_has_four_generators", "OmegaTheoryV2", "—", ""
"CLOSED", "spectralTriple_OmegaSubstrate", "OmegaTheoryV2", "—", ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.absorbPhoton_exists", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.applies_subgraph_is_DAG_witness", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.descent_for_LatticePoint_cover", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.extendedBound_finiteN_strict_excess", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.extendedBound_gap_eq_computationalUncertainty", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.extendedBound_uniqueness", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.fin0_pure_DAG_minimal", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.finN_pure_DAG", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.four_channel_residual_ordering_N4", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.grothendieck_wave2_extras_grand_closure", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.grothendieck_wave2_grand_closure", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.irrationalChannel4_cardinality", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.irreducible_cycle_HiggsYukawa", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.kempf_2025_curvature_corrected_bandlimit", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.lean_entity_effective_rank_3_witness", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.leiden_modularity_monotone_over_gamma", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.no_sharp_4_band_gap_in_leiden", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.omega_theory_is_fibered_category", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.pi_hunch_pagerank_dominance_witness", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.primitivity_of_computationalUncertainty", "—", 2, ""
"CLOSED_BY_LEAN_LANDING", "OmegaTheory.Predictions.subsystem_navigator_homotopy_limit", "—", 2, ""
"CONJECTURAL", "ic_catalanG_Mahler_S_conditional", "OmegaTheoryV2", "—", ""
"CONJECTURAL", "ic_pi_Mahler_S_conditional", "OmegaTheoryV2", "—", ""
"DELIVERED", "substrate_cherenkov_threshold", "OmegaTheoryV2", "—", ""
"DONE", "zeno_measurement_pays_delta_comp", "OmegaTheoryV2", "—", ""
"FORMALIZED", "KBC_void_predicts_rho_DE_underdensity", "OmegaTheoryV2", "—", ""
"FORMALIZED", "W1_neutrino_mass_floor_from_sqrt2_delta", "OmegaTheoryV2", "—", ""
"FORMALIZED", "bh_mediator_consistent_with_poplawski_bounce", "OmegaTheoryV2", "—", ""
"FORMALIZED", "black_hole_is_mediator_not_sink", "OmegaTheoryV2", "—", ""
"FORMALIZED", "black_hole_mass_monotonic_in_substrate", "OmegaTheoryV2", 2, ""
"FORMALIZED", "cosmological_redshift_feeds_dark_energy_reservoir", "OmegaTheoryV2", "—", ""
"FORMALIZED", "dark_energy_locality_at_redshift_event", "OmegaTheoryV2", 3, ""
"FORMALIZED", "dark_energy_spatial_locality_from_photon_traffic", "OmegaTheoryV2", "—", ""
"FORMALIZED", "dark_energy_spatial_locality_quantitative_amplitude", "OmegaTheoryV2", 3, ""
"FORMALIZED", "deBroglie_equals_compton_iff_equipartition", "OmegaTheoryV2", "—", ""
"FORMALIZED", "dirac_spectrum_hermitian_spectral_real", "OmegaTheoryV2", 2, ""
"FORMALIZED", "electron_capture_critical_density_gravity", "OmegaTheoryV2", "—", ""
"FORMALIZED", "electron_phase_transition_critical_field", "OmegaTheoryV2", 3, ""
"FORMALIZED", "electron_rest_mass_shift_in_strong_gravity", "OmegaTheoryV2", "—", ""
"FORMALIZED", "gzk_cutoff_substrate_gravity_cosmological", "OmegaTheoryV2", "—", ""
"FORMALIZED", "hawking_as_dark_energy_reservoir_relaxation", "OmegaTheoryV2", "—", ""
"FORMALIZED", "hawking_as_dark_energy_reservoir_relaxation", "—", "—", ""
"FORMALIZED", "hawking_radiation_as_reverse_redshift_info_cost", "OmegaTheoryV2", "—", ""
"FORMALIZED", "healing_flow_mu_drives_inflation_rate", "OmegaTheoryV2", 2, ""
"FORMALIZED", "healing_flow_mu_drives_inflation_rate", "OmegaTheoryV2", 2, ""
"FORMALIZED", "healing_mu_drives_inflation_rate_capstone_unified_summary", "OmegaTheoryV2", 4, ""
"FORMALIZED", "magnetar_critical_B_field_proton_landau_gravity", "OmegaTheoryV2", "—", ""
"FORMALIZED", "mass_dependent_decoherence_scaling", "OmegaTheoryV2", "—", "Rate of decoherence scales as (m/m_e)^2 · Gamma_e at matched energy"
"FORMALIZED", "non_abelian_DF_zero_bianchi", "—", "—", ""
"FORMALIZED", "particle_regime_from_action_density_and_iterations", "OmegaTheoryV2", "—", ""
"FORMALIZED", "perTickDelay_compton_threshold", "OmegaTheoryV2", "—", ""
"FORMALIZED", "photon_bent_path_info_arrival_delay", "OmegaTheoryV2", "—", ""
"FORMALIZED", "photon_electron_positron_closed_info_loop", "OmegaTheoryV2", "—", ""
"FORMALIZED", "photon_energy_transfer_to_gravitational_field", "OmegaTheoryV2", 3, ""
"FORMALIZED", "photon_is_zero_rho_maxN_limit", "OmegaTheoryV2", "—", ""
"FORMALIZED", "photon_preserves_c_loses_info_coherence", "OmegaTheoryV2", "—", ""
"FORMALIZED", "photon_redshift_loss_equals_dark_energy_gain", "OmegaTheoryV2", "—", ""
"FORMALIZED", "pi_error_drives_electron_generation_mass", "OmegaTheoryV2", 2, "There exists c > 0 (c = l_P) such that for every truncation level N, fermionMass(yukawaElectron gen1) N >= c * pi_error_val N. Equivalently, electron gen1 mass equals l_P * pi_error_val N exactly."
"FORMALIZED", "proton_deconfinement_threshold_substrate_gravity", "OmegaTheoryV2", "—", ""
"FORMALIZED", "proton_mass_gravity_drift", "OmegaTheoryV2", "—", ""
"FORMALIZED", "proton_radius_gravity_modified", "OmegaTheoryV2", "—", ""
"FORMALIZED", "proton_stability_hawking_sink", "OmegaTheoryV2", "—", ""
"FORMALIZED", "proton_substrate_criticality_unified_capstone", "OmegaTheoryV2", 3, "Unified CAPSTONE: for every ProtonCriticalityRegime r, protonSubstrateStability(r) >= substrateCriticalBound. Bundles 4 proton-criticality phenomena under a single non-negativity floor."
"FORMALIZED", "relativistic_energy_spectrum_bridge_schrodinger", "—", 2, ""
"FORMALIZED", "schwinger_pair_production_from_substrate_uncertainty_overflow", "OmegaTheoryV2", "—", ""
"FORMALIZED", "schwinger_suppression_rate_formalization", "OmegaTheoryV2", "—", ""
"FORMALIZED", "singularity_is_not_energy_sink", "OmegaTheoryV2", "—", ""
"FORMALIZED", "singularity_is_not_energy_sink", "—", "—", ""
"FORMALIZED", "star_mass_invariant_under_photon_emission", "OmegaTheoryV2", "—", ""
"FORMALIZED", "substrate_info_cost_is_force_universal", "OmegaTheoryV2", "—", ""
"FORMALIZED", "synchrotron_analog_of_gravitational_redshift", "OmegaTheoryV2", "—", ""
"FORMALIZED", "three_irrationals_three_generations_ordering", "—", 2, ""
"FORMALIZED", "vacuum_birefringence_from_errorforms", "OmegaTheoryV2", "—", "Δn(B) = C · (B / B_Schwinger)² · computationalUncertainty N — weak-field Euler-Heisenberg/Adler quadratic scaling of vacuum birefringence sourced by substrate δ_comp"
"FORMALIZED", "yukawa_from_DF_eigenvalues_capstone", "—", "—", ""
"FRONTIER_SCAFFOLDED", "weinberg_ricci_general_conformal", "—", "—", ""
"GREEN", "graviton_ensemble_bound_from_ligo_network", "OmegaTheoryV2", 5, ""
"GREEN", "information_second_law_substrate_synthesis", "OmegaTheoryV2", "—", "Landauer k_B·T·ln2 + Bekenstein 2π·R·E/(ℏ·c·ln2) + substrate correction δ_comp(N)/(k_B·T·ln2) all strictly positive for T,R,E > 0, finite N"
"GREEN", "jarlskog_from_three_irrationals_geometric_mean", "OmegaTheoryV2", "—", ""
"GREEN", "logarithmic_generation_map_3_irrationals", "OmegaTheoryV2", "—", ""
"NULL", "CKM_hierarchy_from_pi_e_sqrt2_ordering", "OmegaTheoryV2", 30, ""
"NULL", "DE_not_cuaseal_to_local_DM", "OmegaTheoryV2", 28, ""
"NULL", "DE_to_DM_bridge_via_bounce", "OmegaTheoryV2", 28, ""
"NULL", "DM_abundance_from_parent_universe_BH_count", "OmegaTheoryV2", 28, ""
"NULL", "EM_to_Weak_bridge_via_charge_repair", "OmegaTheoryV2", 28, ""
"NULL", "PMNS_fourth_column_from_catalan_G", "OmegaTheoryV2", 27, ""
"NULL", "SU2_jacobi_via_fin_cases", "OmegaTheoryV2", 29, ""
"NULL", "SU3_color_from_three_irrationals", "OmegaTheoryV2", 29, ""
"NULL", "U1_Y_from_photon_repair", "OmegaTheoryV2", 24, ""
"NULL", "Z_sterile_from_connes_DF_eigenvalue", "OmegaTheoryV2", 27, ""
"NULL", "baby_universe_gravitons_survive_bounce", "OmegaTheoryV2", 26, ""
"NULL", "baby_universe_sterile_nu_spectrum", "OmegaTheoryV2", 26, ""
"NULL", "baryogenesis_from_sakharov_plus_catalanG", "OmegaTheoryV2", 33, ""
"NULL", "black_hole_information_paradox_fully_resolved", "OmegaTheoryV2", 37, ""
"NULL", "catalan_G_series_convergence_rate", "OmegaTheoryV2", 27, ""
"NULL", "connes_DF_four_eigenvalues_exist", "OmegaTheoryV2", 30, ""
"NULL", "de_reservoir_flows_through_bounce_to_baby_universe", "OmegaTheoryV2", 26, ""
"NULL", "dirac_vs_majorana_from_bounce_topology", "OmegaTheoryV2", 35, ""
"NULL", "electromagnetic_interaction_photon_propagator_from_subsystem_pair", "OmegaTheoryV2", 32, ""
"NULL", "elim_Nesterenko_1996", "OmegaTheoryV2", "—", ""
"NULL", "elim_Nesterenko_1996_transcendence", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Emergence.SU3JacobiFull.jacobi_rat_zero._native.native_decide.ax_1_1", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Emergence.SU3JacobiFull.jacobi_sqrt3_zero._native.native_decide.ax_1_1", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.G_N", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.G_N_pos", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.c", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.c_pos", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.hbar", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.hbar_pos", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.k_B", "OmegaTheoryV2", "—", ""
"NULL", "elim_OmegaTheory.Spacetime.k_B_pos", "OmegaTheoryV2", "—", ""
"NULL", "elim_Real.pi_transcendental", "OmegaTheoryV2", "—", ""
"NULL", "elim_hermiteLindemann_arctan_one_third_irrational", "OmegaTheoryV2", "—", ""
"NULL", "elim_hpw_laplacian_ricci_convergence", "OmegaTheoryV2", "—", ""
"NULL", "elim_hypDeriv", "OmegaTheoryV2", "—", ""
"NULL", "elim_hypValue", "OmegaTheoryV2", "—", ""
"NULL", "elim_motivicU", "OmegaTheoryV2", "—", ""
"NULL", "elim_motivicV", "OmegaTheoryV2", "—", ""
"NULL", "elim_motivic_trdeg_three", "OmegaTheoryV2", "—", ""
"NULL", "elim_motivic_trdeg_three_transcendence", "OmegaTheoryV2", "—", ""
"NULL", "elim_siegel_shidlovskii", "OmegaTheoryV2", "—", ""
"NULL", "elim_u_hyp", "OmegaTheoryV2", "—", ""
"NULL", "elim_v_hyp", "OmegaTheoryV2", "—", ""
"NULL", "fermion_mass_hierarchy_spans_12_orders", "OmegaTheoryV2", 35, ""
"NULL", "flatness_forced_by_substrate_topology", "OmegaTheoryV2", 25, ""
"NULL", "four_channels_three_active_one_sterile_surjective", "OmegaTheoryV2", 27, ""
"NULL", "four_irrationals_necessary_and_sufficient", "OmegaTheoryV2", 43, ""
"NULL", "gauge_boson_is_boundary_flux", "OmegaTheoryV2", 32, ""
"NULL", "grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE", "OmegaTheoryV2", 43, ""
"NULL", "gravitational_wave_relic_from_parent_bounce", "OmegaTheoryV2", 34, ""
"NULL", "higgs_mass_from_self_coupling_derived", "OmegaTheoryV2", 35, ""
"NULL", "higgs_vev_from_substrate_scale", "OmegaTheoryV2", 35, ""
"NULL", "holographic_principle_from_substrate_lattice_count", "OmegaTheoryV2", 38, ""
"NULL", "horizon_and_flatness_and_DM_jointly_resolved_by_bounce", "OmegaTheoryV2", 34, ""
"NULL", "inflation_driver_inherited_from_parent_de_reservoir", "OmegaTheoryV2", 34, ""
"NULL", "inflaton_decays_produce_active_fermions_only", "OmegaTheoryV2", 34, ""
"NULL", "inherited_information_upper_bound_by_parent_mass", "OmegaTheoryV2", 26, ""
"NULL", "interaction_as_subsystem_boundary_crossing_formal", "OmegaTheoryV2", 32, ""
"NULL", "leptogenesis_sterile_nu_decays_asymmetric", "OmegaTheoryV2", 33, ""
"NULL", "lepton_mass_ordering_from_pi_hunch", "OmegaTheoryV2", 31, ""
"NULL", "mW_over_mZ_eq_cos_thetaW", "OmegaTheoryV2", 24, ""
"NULL", "mass_ratio_e_mu_from_sqrt2_e_channel_ratio", "OmegaTheoryV2", 30, ""
"NULL", "matter_antimatter_asymmetry_bounded_by_PMNS_CP_phase", "OmegaTheoryV2", 41, ""
"NULL", "no_new_physics_below_KATRIN_scale", "OmegaTheoryV2", 42, ""
"NULL", "non_abelian_F_mu_nu_assembled", "OmegaTheoryV2", 29, ""
"NULL", "nu_mass_sum_matches_cosmological_bound", "OmegaTheoryV2", 40, ""
"NULL", "omega_DM_sterile_bound_from_catalan_G", "OmegaTheoryV2", 25, ""
"NULL", "omega_M_and_lambda_consistent_with_planck", "OmegaTheoryV2", 25, ""
"NULL", "omega_theory_falsifiability_witness_panel", "OmegaTheoryV2", 43, ""
"NULL", "omega_theory_minimal_constants_are_exactly_eight", "OmegaTheoryV2", 43, ""
"NULL", "omega_total_equals_one", "OmegaTheoryV2", 25, ""
"NULL", "parent_universe_observability_via_GW_echo", "OmegaTheoryV2", 40, ""
"NULL", "quantum_gravity_finite_corrections_from_truncation", "OmegaTheoryV2", 37, ""
"NULL", "quark_mass_ordering_from_pi_hunch", "OmegaTheoryV2", 31, ""
"NULL", "second_law_generalized_via_info_entropy_on_substrate", "OmegaTheoryV2", 38, ""
"NULL", "sterile_colorless_from_topology", "OmegaTheoryV2", 31, ""
"NULL", "sterile_nu_decay_into_photon_plus_light_nu", "OmegaTheoryV2", 33, ""
"NULL", "strong_coupling_running_from_pi_channel", "OmegaTheoryV2", 29, ""
"NULL", "substrate_electroweak_unification_theorem", "OmegaTheoryV2", 24, ""
"NULL", "three_generations_necessary_from_gauge_anomaly_cancellation", "OmegaTheoryV2", 33, ""
"NULL", "three_generations_necessary_from_three_active_channels", "OmegaTheoryV2", 31, ""
"NULL", "weak_interaction_as_high_ricci_crossing", "OmegaTheoryV2", 32, ""
"NULL", "weinberg_angle_from_substrate_ratio", "OmegaTheoryV2", 24, ""
"NULL", "yukawa_coupling_from_DF_eigenvalue_ratio", "OmegaTheoryV2", 30, ""
"OPEN", "extendedBound_saturation_hilbert", "OmegaTheoryV2", 44, ""
"OPEN", "singleton_theorems_bridge_mp2", "OmegaTheoryV2", 44, ""
"OPEN_PROBLEM", "ic_catalanG_irrationality_conjecture", "OmegaTheoryV2", "—", ""
"PROPOSED", "BaryonDensityOmegaBh2Fit", "OmegaTheoryV2", 15, "BBN + CMB double-check of Alioth-2 cycle 14"
"PROPOSED", "BottomQuarkMassFit", "OmegaTheoryV2", "—", ""
"PROPOSED", "CosmologicalConstantFit", "OmegaTheoryV2", 15, "Smallest observable in physics; sqrt2 channel natural choice"
"PROPOSED", "CosmologicalConstantScale", "OmegaTheoryV2", 14, ""
"PROPOSED", "HiggsMassReconciliation", "OmegaTheoryV2", 14, ""
"PROPOSED", "HiggsSelfCoupling", "OmegaTheoryV2", 14, ""
"PROPOSED", "HiggsWidthFit", "OmegaTheoryV2", "—", ""
"PROPOSED", "HubbleConstantH0Fit", "OmegaTheoryV2", 15, "Hubble tension CMB vs SH0ES; substrate predicts CMB value by geometry, tension is local-Universe void"
"PROPOSED", "HubbleTension", "OmegaTheoryV2", 14, ""
"PROPOSED", "JarlskogFit", "OmegaTheoryV2", "—", ""
"PROPOSED", "MuonLifetimeFit", "OmegaTheoryV2", "—", ""
"PROPOSED", "OmegaMatterDensityFit", "OmegaTheoryV2", 15, "Matter density budget; pi channel (heavy component)"
"PROPOSED", "PMNSDeltaCPFit", "OmegaTheoryV2", "—", ""
"PROPOSED", "ProtonLifetimeBound", "OmegaTheoryV2", 14, ""
"PROPOSED", "ProtonMagneticMoment", "OmegaTheoryV2", 14, ""
"PROPOSED", "RightHandedDoublet_structure", "OmegaTheoryV2", "—", ""
"PROPOSED", "ScalarSpectralIndexFit", "OmegaTheoryV2", 15, "Falsifies exact scale invariance; e channel intermediate"
"PROPOSED", "StrangeQuarkMassFit", "OmegaTheoryV2", "—", ""
"PROPOSED", "TensorToScalarRatioBound", "OmegaTheoryV2", 15, "BICEP/Keck constraint; ratio of tensor to scalar primordial perturbations"
"PROPOSED", "absorbPhoton_CPT_dual", "OmegaTheoryV2", "—", ""
"PROPOSED", "backwardFraction_time_reverse_dual", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c04_c18", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c04_c30", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c04_c34", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c18_c22", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c18_c30", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c18_c34", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c18_c47", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c18_c62", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c18_c64", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c30_c96", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c34_c96", "OmegaTheoryV2", "—", ""
"PROPOSED", "bridge_c64_c96", "OmegaTheoryV2", "—", ""
"PROPOSED", "charm_quark_mass_substrate_fit", "OmegaTheoryV2", 11, ""
"PROPOSED", "dirac_spectrum_hermitian_spectral_real", "—", 1, ""
"PROPOSED", "extendedBound_saturation", "OmegaTheoryV2", "—", "Explicit minimum-uncertainty Gaussian state saturating hbar/2 + delta_comp(N)."
"PROPOSED", "extendedBound_uniqueness", "OmegaTheoryV2", "—", "delta_comp is the unique non-negative continuous extension making the bound converge at infty."
"PROPOSED", "fermi_constant_extraction_substrate_fit", "OmegaTheoryV2", 11, ""
"PROPOSED", "neutron_lifetime_substrate_fit", "OmegaTheoryV2", 11, ""
"PROPOSED", "pion_charged_decay_rate_substrate_fit", "OmegaTheoryV2", 11, ""
"PROPOSED", "pmns_theta_12_solar_substrate_fit", "OmegaTheoryV2", 11, ""
"PROPOSED", "rightAction_C_parity_dual", "OmegaTheoryV2", "—", ""
"PROPOSED", "rightAction_M3_parity_dual", "OmegaTheoryV2", "—", ""
"PROPOSED", "rightLeptonDoubletY_parity_dual", "OmegaTheoryV2", "—", ""
"PROPOSED", "rightQuarkDoubletY_parity_dual", "OmegaTheoryV2", "—", ""
"PROPOSED", "z_boson_width_substrate_fit", "OmegaTheoryV2", 11, ""
"PROVABLE_TODAY", "ic_e_irrational_via_Euler", "OmegaTheoryV2", "—", ""
"PROVED_GREEN", "anomalous_g2_substrate_correction", "OmegaTheoryV2", "—", ""
"PROVEN", "graviton_detection_impossibility", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanAbsTerm_summable", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanAlternating_summable", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_definition_summability", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_ge_eight_ninths", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_gt_pi_over_4", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_hasSum", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_le_209_over_225", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_lt_e", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_lt_one", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_lt_one_lt_pi", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_pos", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_tendsto", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanG_vs_sqrt2", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanPartial_three", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanPartial_two", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_antitone", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_nonneg", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_one", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_pos", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_summable", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_tendsto_zero", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_two", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_catalanTerm_zero", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_e_lt_pi_numeric", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_e_ne_catalanG", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_e_ne_sqrt2", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_four_irrationals_four_distinct_truncOrigins", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_four_irrationals_pairwise_distinct", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_four_truncOrigin_tags_pairwise_distinct", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_omega_four_origin_separation", "OmegaTheoryV2", "B", "Unconditional after Wave-A (Ruchba) landed Catalan-vs-active inequalities"
"PROVEN", "ic_origin_of_catalanG_is_conjectural", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_origin_of_e_is_E_function", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_origin_of_pi_is_G_function_transcendental", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_origin_of_sqrt2_is_algebraic", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_pi_gt_three_numeric", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_pi_ne_catalanG", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_pi_ne_e", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_pi_ne_sqrt2", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_separation_theorem_headline", "OmegaTheoryV2", "B", ""
"PROVEN", "ic_sqrt2_is_algebraic", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_sqrt2_lt_e_numeric", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_sqrt2_ne_catalanG", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_summable_one_div_nat_succ_sq", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_three_irrationals_pairwise_distinct", "OmegaTheoryV2", "—", ""
"PROVEN", "ic_trunc_origin_inductive", "OmegaTheoryV2", "B", ""
"PROVEN", "perTickDelay_tendsto_photon_cost_massless_limit", "OmegaTheoryV2", "—", ""
"STATEMENT_READY", "ic_three_constants_transcendental", "OmegaTheoryV2", "—", ""
```

---

## Narrower views (one-liners — run in cypher-shell)

### Only open candidates (PROPOSED + OPEN + OPEN_PROBLEM — the wave-3+ worklist)

```cypher
MATCH (c:TheoremCandidate)
WHERE c.status IN ['PROPOSED', 'OPEN', 'OPEN_PROBLEM']
RETURN c.name, c.status, coalesce(c.description, c.claim, '')
ORDER BY c.status, c.name;
```

### Blocked on framework / Mathlib upstream

```cypher
MATCH (c:TheoremCandidate {status: 'BLOCKED_ON_FRAMEWORK'})
RETURN c.name, coalesce(c.description, c.claim, ''), c.blocker_issue;
```

### Recently closed (wave-2 landings)

```cypher
MATCH (c:TheoremCandidate)-[r:CLOSED_BY_LEAN_LANDING]->(t:Theorem)
RETURN c.name, r.iter, t.file, t.source_span
ORDER BY r.iter DESC
LIMIT 50;
```

### Duplicates in candidate-space (same claim, different node)

```cypher
MATCH (a:TheoremCandidate), (b:TheoremCandidate)
WHERE id(a) < id(b) AND a.name = b.name
RETURN a.name, collect(id(a)+'/'+id(b))[..5] AS duplicate_ids LIMIT 20;
```

---

*Last refresh: 2026-04-22 (end of wave 2). Wave 3 (in flight, agent `a3cba3023d5f57b3a`) is triaging + creatively extending this pile — expect this snapshot to evolve.*
