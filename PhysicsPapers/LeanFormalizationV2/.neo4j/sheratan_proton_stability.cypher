// ==========================================================================
// Neo4j update: proton_stability_hawking_sink formalized by Sheratan
// (β Arietis, 2026-04-19; hunter-proton-stability, proton_critical #2)
// ==========================================================================

// 1. Promote or create the TheoremCandidate node; set status='FORMALIZED'
MERGE (tc:TheoremCandidate {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
SET tc.status = 'FORMALIZED',
    tc.formalized_at = '2026-04-19',
    tc.formalized_by = 'Sheratan',
    tc.star = 'β Arietis',
    tc.mission = 'hunter-proton-stability',
    tc.difficulty = 'HARD',
    tc.budget_min = 120,
    tc.actual_min = 35,
    tc.file = 'OmegaTheory/Predictions/ProtonStabilityHawkingSink.lean',
    tc.theorem_name = 'OmegaTheory.Predictions.ProtonStabilityHawkingSink.proton_stability_hawking_sink',
    tc.empirical_anchor = 'Super-Kamiokande 2024, arXiv:2409.19633, tau_p >= 10^34 yr',
    tc.headline_statement = 'For mu > 0, L >= 0, N : Nat, tau_lab >= protonLifetimeMin: exists tau_local with (formula) and (tau_local <= tau_lab) and (overflow -> sub-SuperK -> decay_acceleration)',
    tc.composes_on = 'Bellatrix.gravRedshiftCost, Alnasl.black_hole_is_mediator_not_sink, ProtonMassFromLambdaQCD.protonMass_PDG, Irrationality.computationalUncertainty',
    tc.paper_significance = 'Proton-critical bundle #2: quantitative BH-horizon analogue of gravitational time dilation acting on decay rate',
    tc.build_jobs = 3685,
    tc.sorry_count = 0,
    tc.new_axioms = 0;

// 2. Create Theorem node for the headline proof
MERGE (t:Theorem {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
SET t.file = 'OmegaTheory/Predictions/ProtonStabilityHawkingSink.lean',
    t.signature = '{mu : ℝ} (hmu : 0 < mu) (L : ℝ) (hL : 0 ≤ L) (N : ℕ) {tau_lab : ℝ} (htau : tau_lab ≥ protonLifetimeMin) : ∃ tau_local : ℝ, tau_local = tau_lab * (1 - gravRedshiftCost L mu / protonRestEnergy) ∧ tau_local ≤ tau_lab ∧ (substrateDeltaCompOverflow N → tau_local < protonLifetimeMin → protonDecayAcceleration tau_local N)',
    t.docstring = 'HEADLINE THEOREM. Proton stability near BH horizon with substrate Hawking-channel sink. Three conjuncts: (1) explicit formula via Bellatrix gravRedshiftCost, (2) dilation ceiling tau_local <= tau_lab, (3) Hawking-channel trigger under delta_comp overflow.',
    t.author = 'Sheratan',
    t.date = '2026-04-19',
    t.source_span_start = 388,
    t.source_span_end = 413;

// 3. Connect TheoremCandidate to formalization
MERGE (tc)-[:FORMALIZED_AS]->(t);

// 4. Connect composition arrows (APPLIES) to dependency theorems
// gravRedshiftCost (Bellatrix 2026-04-19, ProtonPhotonRedshift.lean)
MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
MATCH (dep:Definition {namespace: 'OmegaTheoryV2', name: 'gravRedshiftCost'})
MERGE (t)-[:APPLIES {weight: 1.0, via: 'Bellatrix ProtonPhotonRedshift'}]->(dep);

// black_hole_is_mediator_not_sink (Alnasl 2026-04-19, BlackHoleAsMediator.lean)
MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
MATCH (dep:Theorem {namespace: 'OmegaTheoryV2', name: 'black_hole_is_mediator_not_sink'})
MERGE (t)-[:APPLIES {weight: 1.0, via: 'Alnasl BlackHoleAsMediator alnasl_bridge corollary'}]->(dep);

// protonMass_PDG (ProtonMassFromLambdaQCD.lean)
MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
MATCH (dep:Definition {namespace: 'OmegaTheoryV2', name: 'protonMass_PDG'})
MERGE (t)-[:APPLIES {weight: 1.0, via: 'PDG anchor in protonRestEnergy'}]->(dep);

// computationalUncertainty (Irrationality.Uncertainty)
MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
MATCH (dep:Definition {namespace: 'OmegaTheoryV2', name: 'computationalUncertainty'})
MERGE (t)-[:APPLIES {weight: 1.0, via: 'substrateDeltaCompOverflow predicate'}]->(dep);

// 5. Update NavigationMaster with new counts
MATCH (nav:NavigationMaster {namespace: 'OmegaTheoryV2'})
SET nav.build_jobs = 3685,
    nav.last_formalization = 'proton_stability_hawking_sink',
    nav.last_formalization_by = 'Sheratan',
    nav.last_formalization_date = '2026-04-19',
    nav.proton_critical_formalized = COALESCE(nav.proton_critical_formalized, 0) + 1;

// 6. Report
MATCH (tc:TheoremCandidate {namespace: 'OmegaTheoryV2', name: 'proton_stability_hawking_sink'})
OPTIONAL MATCH (tc)-[:FORMALIZED_AS]->(t:Theorem)
OPTIONAL MATCH (t)-[r:APPLIES]->(dep)
RETURN tc.name AS candidate,
       tc.status AS status,
       tc.formalized_by AS agent,
       tc.file AS file,
       count(DISTINCT dep) AS deps_count;
