// Tracer agent (Apr 14 2026) — HPW consumer graph, complete map
//
// Populates:
//   - Theorem nodes for EVERY HPW consumer (direct or transitive)
//   - Definition nodes for HPW-adjacent defs (continuumBoxG, equilibriumSource,
//     sourceTrace, einsteinSource)
//   - LeanFile nodes for the two HPW-touching files (seeded also by Cataloguer)
//   - USES_AXIOM, USES_THEOREM edges
//   - REQUIRES_HPW_WITH {regime} edges from each consumer to the axiom
//   - hypothesis_pattern property on every Theorem
//   - depth_from_axiom property on every Theorem
//
// All writes use MERGE (three other agents may be writing concurrently).
// Each statement is self-contained (split by Python helper on statement terminators).

// LeanFile: LaplacianRicci.lean
MERGE (f1:LeanFile {namespace:'OmegaTheoryV2', path:'OmegaTheory/Emergence/LaplacianRicci.lean'})
SET f1.role = coalesce(f1.role, 'declares_HPW_axiom'),
    f1.note_tracer = 'Declares the single non-physical axiom. Exports 3 derived theorems and defines continuumBoxG := -2 * ricciTensor, which makes harmonic_gauge_box_eq_ricci trivially provable.';

// LeanFile: EinsteinEmergence.lean
MERGE (f2:LeanFile {namespace:'OmegaTheoryV2', path:'OmegaTheory/Emergence/EinsteinEmergence.lean'})
SET f2.role = coalesce(f2.role, 'uses_HPW_indirectly'),
    f2.note_tracer = 'All six top-level consumers of the HPW chain live here. Nothing else in the project imports EinsteinEmergence (terminal sink).';

// Annotate the HPW axiom with tightest-hypothesis finding
MATCH (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
SET ax.applied_regimes = 'Every consumer passes mu_coeff := params.mu (positive real from HealingParams) and g unconstrained (arbitrary DiscreteMetric). The axiom is NEVER invoked with stricter hypotheses.',
    ax.tightest_hypothesis = 'general_DiscreteMetric_any_positive_coeff',
    ax.weakening_opportunity = 'Consumers DO NOT depend on g being Lorentzian / semi-smooth / bounded-curvature. If downstream flagship theorems were re-stated for SemiSmoothMetric, the HPW axiom could be replaced with a SemiSmoothMetric-restricted version closer to what HPW 2006 actually proves.',
    ax.tracer_updated = datetime('2026-04-14T18:30:00Z');

// Depth 1: hpw_discrete_laplacian_convergence
MERGE (t1:Theorem {namespace:'OmegaTheoryV2', name:'hpw_discrete_laplacian_convergence'})
SET t1.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t1.depth_from_axiom = 1,
    t1.hypothesis_pattern = 'general_DiscreteMetric_any_positive_coeff',
    t1.ai_description = 'Old split axiom, now a theorem. Rewrites |mu*Laplacian - mu*continuumBoxG| by unfolding continuumBoxG := -2R, then applies the single HPW axiom verbatim.',
    t1.is_flagship = false,
    t1.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t1:Theorem {namespace:'OmegaTheoryV2', name:'hpw_discrete_laplacian_convergence'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t1)-[r1:REQUIRES_HPW_WITH]->(ax)
SET r1.regime = 'full_axiom_any_g_any_positive_mu';

// Depth 1: laplacian_ricci_correspondence (the THEOREM downstream actually calls)
MERGE (t2:Theorem {namespace:'OmegaTheoryV2', name:'laplacian_ricci_correspondence'})
SET t2.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t2.depth_from_axiom = 1,
    t2.hypothesis_pattern = 'general_DiscreteMetric_any_positive_coeff',
    t2.ai_description = 'Weakening of HPW from l_P/2 to l_P (via linarith). This is the THEOREM that every downstream consumer calls (not the axiom itself).',
    t2.is_flagship = false,
    t2.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t2:Theorem {namespace:'OmegaTheoryV2', name:'laplacian_ricci_correspondence'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t2)-[r2:REQUIRES_HPW_WITH]->(ax)
SET r2.regime = 'full_axiom_any_g_any_positive_mu';

// INDEPENDENT (depth 0): harmonic_gauge_box_eq_ricci
MERGE (t_harm:Theorem {namespace:'OmegaTheoryV2', name:'harmonic_gauge_box_eq_ricci'})
SET t_harm.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t_harm.depth_from_axiom = 0,
    t_harm.hypothesis_pattern = 'trivial_identity',
    t_harm.ai_description = 'Old axiom 11, now TRIVIALLY PROVABLE: |mu*continuumBoxG + 2*mu*R| = |0| <= l_P/2. Proved by ring + abs_zero + l_P_pos, NOT by HPW. Purpose is backward-compatibility naming.',
    t_harm.eliminable = true,
    t_harm.is_flagship = false,
    t_harm.tracer_updated = datetime('2026-04-14T18:30:00Z');

// Definition: continuumBoxG
MERGE (d_box:Definition {namespace:'OmegaTheoryV2', name:'continuumBoxG', file:'OmegaTheory/Emergence/LaplacianRicci.lean'})
SET d_box.ai_description = 'continuumBoxG g mu nu p := -2 * ricciTensor g mu nu p. Absorbs Gamma*Gamma remainder into the O(l_P) HPW error bound.',
    d_box.kind = 'def';

// Depth 2: ricci_from_equilibrium_balance
MERGE (t3:Theorem {namespace:'OmegaTheoryV2', name:'ricci_from_equilibrium_balance'})
SET t3.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t3.depth_from_axiom = 2,
    t3.hypothesis_pattern = 'any_g_any_positive_mu_plus_balance_equation',
    t3.ai_description = 'At healing-equilibrium, |-2*mu*R - (lambda*D + gamma*(I-Ibar))| <= l_P. Extra hypothesis: balance equation. Metric g is still arbitrary.',
    t3.is_flagship = false,
    t3.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t3:Theorem {namespace:'OmegaTheoryV2', name:'ricci_from_equilibrium_balance'}),
      (t2b:Theorem {namespace:'OmegaTheoryV2', name:'laplacian_ricci_correspondence'})
MERGE (t3)-[:USES_THEOREM]->(t2b);

MATCH (t3:Theorem {namespace:'OmegaTheoryV2', name:'ricci_from_equilibrium_balance'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t3)-[r3:REQUIRES_HPW_WITH]->(ax)
SET r3.regime = 'full_axiom_any_g_any_positive_mu';

// Depth 2: vacuum_einstein_emergence
MERGE (t4:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_emergence'})
SET t4.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t4.depth_from_axiom = 2,
    t4.hypothesis_pattern = 'equilibrium_plus_zero_defect_plus_uniform_info',
    t4.ai_description = '|R_munu| <= l_P/(2*mu) when: IsHealingEquilibrium + zero defects (D = 0) + uniform information (I = I_bar). These collapse the RHS to 0.',
    t4.is_flagship = false,
    t4.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t4:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_emergence'}),
      (t2b:Theorem {namespace:'OmegaTheoryV2', name:'laplacian_ricci_correspondence'})
MERGE (t4)-[:USES_THEOREM]->(t2b);

MATCH (t4:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_emergence'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t4)-[r4:REQUIRES_HPW_WITH]->(ax)
SET r4.regime = 'full_axiom_any_g_any_positive_mu';

// Depth 2: ricci_bounded_at_healed_equilibrium
MERGE (t5:Theorem {namespace:'OmegaTheoryV2', name:'ricci_bounded_at_healed_equilibrium'})
SET t5.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t5.depth_from_axiom = 2,
    t5.hypothesis_pattern = 'equilibrium_plus_zero_defect_plus_uniform_info',
    t5.ai_description = 'Equivalent repackaging of vacuum_einstein_emergence: |2*mu*R_munu| <= l_P directly.',
    t5.is_flagship = false,
    t5.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t5:Theorem {namespace:'OmegaTheoryV2', name:'ricci_bounded_at_healed_equilibrium'}),
      (t2b:Theorem {namespace:'OmegaTheoryV2', name:'laplacian_ricci_correspondence'})
MERGE (t5)-[:USES_THEOREM]->(t2b);

MATCH (t5:Theorem {namespace:'OmegaTheoryV2', name:'ricci_bounded_at_healed_equilibrium'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t5)-[r5:REQUIRES_HPW_WITH]->(ax)
SET r5.regime = 'full_axiom_any_g_any_positive_mu';

// Depth 3: einstein_with_matter_emergence (THE PRIZE)
MERGE (t6:Theorem {namespace:'OmegaTheoryV2', name:'einstein_with_matter_emergence'})
SET t6.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t6.depth_from_axiom = 3,
    t6.hypothesis_pattern = 'IsHealingEquilibrium_only',
    t6.ai_description = 'THE PRIZE. At equilibrium, |-2*mu*R - (lambda*D + gamma*(I-Ibar))| <= l_P. Reduces to ricci_from_equilibrium_balance in one line. WEAKEST hypothesis among family: just equilibrium.',
    t6.is_flagship = true,
    t6.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t6:Theorem {namespace:'OmegaTheoryV2', name:'einstein_with_matter_emergence'}),
      (t3b:Theorem {namespace:'OmegaTheoryV2', name:'ricci_from_equilibrium_balance'})
MERGE (t6)-[:USES_THEOREM]->(t3b);

MATCH (t6:Theorem {namespace:'OmegaTheoryV2', name:'einstein_with_matter_emergence'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t6)-[r6:REQUIRES_HPW_WITH]->(ax)
SET r6.regime = 'full_axiom_any_g_any_positive_mu';

// Depth 3: vacuum_einstein_tensor_bounded
MERGE (t7:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_tensor_bounded'})
SET t7.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t7.depth_from_axiom = 3,
    t7.hypothesis_pattern = 'vacuum_equilibrium_plus_bounded_metric_and_inverse',
    t7.ai_description = '|G_munu| <= (1 + 8*M_g*M_inv) * l_P/(2*mu) at vacuum equilibrium + |g_munu| <= M_g + |g^{munu}| <= M_inv. Upgrades vacuum_einstein_emergence via scalar_curvature_bounded + einsteinTensor_triangle_bound. M_g/M_inv NOT consumed by HPW.',
    t7.is_flagship = false,
    t7.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t7:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_tensor_bounded'}),
      (t4b:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_emergence'})
MERGE (t7)-[:USES_THEOREM]->(t4b);

MATCH (t7:Theorem {namespace:'OmegaTheoryV2', name:'vacuum_einstein_tensor_bounded'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t7)-[r7:REQUIRES_HPW_WITH]->(ax)
SET r7.regime = 'full_axiom_any_g_any_positive_mu';

// Depth 4: einstein_tensor_emergence (THE EINSTEIN FORM)
MERGE (t8:Theorem {namespace:'OmegaTheoryV2', name:'einstein_tensor_emergence'})
SET t8.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t8.depth_from_axiom = 4,
    t8.hypothesis_pattern = 'equilibrium_plus_bounded_metric_and_inverse',
    t8.ai_description = 'THE EINSTEIN FORM. |G_munu - einsteinSource| <= (1+8*M_g*M_inv) * l_P/(2*mu). Assembles 16 Finset-summed instances of einstein_with_matter_emergence (one per pair (a,b)) via triangle + trace reversal.',
    t8.is_flagship = true,
    t8.tracer_updated = datetime('2026-04-14T18:30:00Z');

MATCH (t8:Theorem {namespace:'OmegaTheoryV2', name:'einstein_tensor_emergence'}),
      (t6b:Theorem {namespace:'OmegaTheoryV2', name:'einstein_with_matter_emergence'})
MERGE (t8)-[:USES_THEOREM]->(t6b);

MATCH (t8:Theorem {namespace:'OmegaTheoryV2', name:'einstein_tensor_emergence'}),
      (ax:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (t8)-[r8:REQUIRES_HPW_WITH]->(ax)
SET r8.regime = 'full_axiom_any_g_any_positive_mu_applied_16_times_per_proof';

// Depth 4: mkEinsteinEmergence (definition/constructor)
MERGE (d_mk:Definition {namespace:'OmegaTheoryV2', name:'mkEinsteinEmergence', file:'OmegaTheory/Emergence/EinsteinEmergence.lean'})
SET d_mk.ai_description = 'Constructor for EinsteinEmergenceResult. Consumes einstein_with_matter_emergence pointwise to populate ricci_sourced.',
    d_mk.kind = 'def',
    d_mk.depth_from_axiom = 4;

MATCH (d_mk:Definition {namespace:'OmegaTheoryV2', name:'mkEinsteinEmergence'}),
      (t6b:Theorem {namespace:'OmegaTheoryV2', name:'einstein_with_matter_emergence'})
MERGE (d_mk)-[:USES_THEOREM]->(t6b);

// Auxiliary definitions
MERGE (d_emres:Definition {namespace:'OmegaTheoryV2', name:'EinsteinEmergenceResult', file:'OmegaTheory/Emergence/EinsteinEmergence.lean'})
SET d_emres.kind = 'structure',
    d_emres.ai_description = 'Bundle of (params, g, g_exact, I, I_bar, equilibrium, defect_bound, ricci_sourced).';

MERGE (d_equilsrc:Definition {namespace:'OmegaTheoryV2', name:'equilibriumSource', file:'OmegaTheory/Emergence/EinsteinEmergence.lean'})
SET d_equilsrc.kind = 'def',
    d_equilsrc.ai_description = 'lambda*defectTensor + gamma*(I - Ibar). RHS of balance equation.';

MERGE (d_sourcetrace:Definition {namespace:'OmegaTheoryV2', name:'sourceTrace', file:'OmegaTheory/Emergence/EinsteinEmergence.lean'})
SET d_sourcetrace.kind = 'def',
    d_sourcetrace.ai_description = 'Tr(S) = sum over mu nu of g^(mu nu) * equilibriumSource.';

MERGE (d_einsrc:Definition {namespace:'OmegaTheoryV2', name:'einsteinSource', file:'OmegaTheory/Emergence/EinsteinEmergence.lean'})
SET d_einsrc.kind = 'def',
    d_einsrc.ai_description = 'Trace-reversed Einstein source: -(1/(2*mu)) * (equilibriumSource - (1/2)*g_munu*Tr(S)).';

// Algebraic lemmas (NOT HPW consumers, but co-located)
MERGE (t_scb:Theorem {namespace:'OmegaTheoryV2', name:'scalar_curvature_bounded'})
SET t_scb.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t_scb.depth_from_axiom = 0,
    t_scb.hypothesis_pattern = 'bounded_inverse_and_bounded_ricci',
    t_scb.ai_description = 'Purely algebraic: |R| <= 16*M_inv*K. Does NOT touch HPW.',
    t_scb.is_flagship = false;

MERGE (t_etb:Theorem {namespace:'OmegaTheoryV2', name:'einsteinTensor_triangle_bound'})
SET t_etb.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t_etb.depth_from_axiom = 0,
    t_etb.hypothesis_pattern = 'triangle_inequality_algebraic',
    t_etb.ai_description = 'Purely algebraic triangle inequality on einsteinTensor := R - (1/2)gR.';

RETURN 'tracer_hpw_graph.cypher: HPW consumer graph written' AS status;
