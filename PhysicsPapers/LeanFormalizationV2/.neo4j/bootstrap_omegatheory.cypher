// OmegaTheoryV2 graph bootstrap
//
// Follows the NavigationMaster 3-level architecture from
// graph-theory-system-modeling: NavigationMaster → EntityNavigator →
// ConcreteImpl.  Namespace: 'OmegaTheoryV2'.
//
// To (re)run:
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/bootstrap_omegatheory.cypher

// -------------------------------------------------------------
// Uniqueness constraints
// -------------------------------------------------------------
CREATE CONSTRAINT omega_nav_unique IF NOT EXISTS
  FOR (n:NavigationMaster)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT omega_ent_unique IF NOT EXISTS
  FOR (n:EntityNavigator)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT omega_impl_unique IF NOT EXISTS
  FOR (n:ConcreteImpl)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT omega_axiom_unique IF NOT EXISTS
  FOR (n:Axiom)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT omega_theorem_unique IF NOT EXISTS
  FOR (n:Theorem)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT omega_file_unique IF NOT EXISTS
  FOR (n:LeanFile)
  REQUIRE (n.namespace, n.path) IS UNIQUE;

// -------------------------------------------------------------
// Level 1: NavigationMaster
// -------------------------------------------------------------
MERGE (nav:NavigationMaster {namespace: 'OmegaTheoryV2', name: 'OmegaTheoryV2'})
SET nav.ai_description =
      'OmegaTheory V2 Lean 4 formalisation of discrete quantum gravity. ' ||
      'Einstein field equations emerge from a Planck-scale Z^4 lattice ' ||
      'with computational truncation errors and self-healing dynamics, ' ||
      'at equilibrium and modulo the HPW axiom (Laplacian-Ricci correspondence).',
    nav.base_package = 'OmegaTheory',
    nav.repo_root    = '/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2',
    nav.lean_version = 'v4.29.0',
    nav.mathlib_version = 'v4.29.0',
    nav.files_count  = 58,
    nav.theorems_count = 1180,
    nav.sorry_count  = 0,
    nav.axioms_count = 9,
    nav.build_command = '~/.elan/bin/lake build --log-level=error',
    nav.last_updated = datetime('2026-04-14T18:00:00Z');

// -------------------------------------------------------------
// Level 2: EntityNavigators (one per architectural layer)
// -------------------------------------------------------------
WITH [
  {name:'Foundations',  layer: 0, desc:'Error algebra — how computational errors compose.'},
  {name:'Spacetime',    layer: 1, desc:'Z^4 lattice, Planck constants, discrete operators, causal structure.'},
  {name:'Tensor',       layer: 2, desc:'Error-propagating tensor operations, valued geometry.'},
  {name:'Geometry',     layer: 3, desc:'Discrete metric, connection, curvature, Weyl, Hodge, Poincare lemma H^0..H^3=0.'},
  {name:'Defects',      layer: 5, desc:'Defect tensor, SemiSmoothMetric, sparsity bounds.'},
  {name:'Conservation', layer: 6, desc:'Noether laws, stress-energy, information KL, correspondence.'},
  {name:'HealingFlow',  layer: 7, desc:'Lyapunov monotonicity, convergence to equilibrium.'},
  {name:'Emergence',    layer: 8, desc:'Einstein field equations emergence, dimensional flow, SR, Predictions.'},
  {name:'Torsion',      layer:10, desc:'Einstein-Cartan torsion, spin-torsion coupling, Poplawski bounce.'},
  {name:'Irrationality',layer:11, desc:'Concrete error sources (pi, e, sqrt2), uncertainty principle.'},
  {name:'Variational',  layer:12, desc:'Graph action, discrete Noether, information geodesics.'},
  {name:'QM_Bridge',    layer:99, desc:'PLANNED: coarse-graining lattice snapshots to wavefunction psi(x,t). See NOTES_QM_AS_DISCRETE_GRAVITY.md and task #17.'}
] AS layers
UNWIND layers AS l
MATCH (nav:NavigationMaster {namespace: 'OmegaTheoryV2'})
MERGE (e:EntityNavigator {namespace: 'OmegaTheoryV2', name: l.name})
SET e.layer = l.layer,
    e.ai_description = l.desc
MERGE (nav)-[:GUIDES]->(e);

// -------------------------------------------------------------
// The 9 axioms — 8 physical constants + 1 HPW
// -------------------------------------------------------------

// Physical-constant axioms
WITH [
  {name:'c',       desc:'Speed of light (positive real).', category:'physical_constant'},
  {name:'c_pos',   desc:'0 < c.',                          category:'physical_constant'},
  {name:'hbar',    desc:'Reduced Planck constant (positive real).', category:'physical_constant'},
  {name:'hbar_pos',desc:'0 < hbar.',                       category:'physical_constant'},
  {name:'G_N',     desc:'Gravitational constant (positive real).', category:'physical_constant'},
  {name:'G_N_pos', desc:'0 < G_N.',                        category:'physical_constant'},
  {name:'k_B',     desc:'Boltzmann constant (positive real).', category:'physical_constant'},
  {name:'k_B_pos', desc:'0 < k_B.',                        category:'physical_constant'},
  {name:'hpw_laplacian_ricci_convergence',
   desc:'Discrete Laplacian of g_munu approximates -2 R_munu within l_P/2. Encapsulates HPW 2006 (graph Laplacian -> Laplace-Beltrami) + Weinberg harmonic-gauge identity.',
   category:'external_mathematics',
   paper:'HPW 2006 (Hoch-Pflaum-Weinrebe), Geometriae Dedicata 123:89-112',
   eliminable:'research_grade',
   status:'AXIOMATIC'}
] AS axioms
UNWIND axioms AS a
MATCH (spacetime:EntityNavigator {namespace: 'OmegaTheoryV2', name: 'Spacetime'})
MATCH (emergence:EntityNavigator {namespace: 'OmegaTheoryV2', name: 'Emergence'})
MERGE (ax:Axiom {namespace: 'OmegaTheoryV2', name: a.name})
SET ax.description = a.desc,
    ax.category = a.category,
    ax.paper = CASE WHEN a.paper IS NOT NULL THEN a.paper ELSE null END,
    ax.eliminable = CASE WHEN a.eliminable IS NOT NULL THEN a.eliminable ELSE null END,
    ax.status = 'AXIOMATIC'
WITH ax, a, spacetime, emergence
FOREACH (_ IN CASE WHEN a.category = 'physical_constant' THEN [1] ELSE [] END |
  MERGE (spacetime)-[:DECLARES_AXIOM]->(ax))
FOREACH (_ IN CASE WHEN a.category = 'external_mathematics' THEN [1] ELSE [] END |
  MERGE (emergence)-[:DECLARES_AXIOM]->(ax));

// -------------------------------------------------------------
// Key files (partial seed — agents will expand)
// -------------------------------------------------------------
WITH [
  {path:'OmegaTheory/Spacetime/Constants.lean', layer:'Spacetime', role:'declares_physical_constants'},
  {path:'OmegaTheory/Emergence/LaplacianRicci.lean', layer:'Emergence',
   role:'declares_HPW_axiom',
   note:'Contains the ONLY non-physical axiom in the project. Also contains laplacian_ricci_correspondence, ricci_from_equilibrium_balance as theorems built on top.'},
  {path:'OmegaTheory/Emergence/EinsteinEmergence.lean', layer:'Emergence', role:'uses_HPW_indirectly',
   note:'Top of emergence chain. The prize theorem einstein_with_matter_emergence reduces in one line to ricci_from_equilibrium_balance.'},
  {path:'OmegaTheory/Geometry/PoincareLemma.lean', layer:'Geometry', role:'discrete_Poincare_lemma',
   note:'H^0=R, H^1=H^2=H^3=0 all proven. First complete discrete de Rham complex in any prover.'},
  {path:'OmegaTheory/Emergence/DimensionalFlow.lean', layer:'Emergence', role:'dimensional_flow_C1', note:'d_eff(E) = 4 - 2*E/E_P, Rigel Apr 14'},
  {path:'OmegaTheory/Emergence/SpecialRelativity.lean', layer:'Emergence', role:'emergent_SR_C2', note:'Lorentz factor from reshaping, Rigel Apr 14'},
  {path:'OmegaTheory/Defects/Sparsity.lean', layer:'Defects', role:'defect_sparsity_C3', note:'Chebyshev + exponential wrapper, Rigel Apr 14'}
] AS files
UNWIND files AS f
MATCH (ent:EntityNavigator {namespace: 'OmegaTheoryV2', name: f.layer})
MERGE (file:LeanFile {namespace: 'OmegaTheoryV2', path: f.path})
SET file.role = f.role,
    file.note = CASE WHEN f.note IS NOT NULL THEN f.note ELSE null END
MERGE (ent)-[:CONTAINS]->(file);

// -------------------------------------------------------------
// HPW consumer chain (hand-seeded — tracer agent will expand)
// -------------------------------------------------------------
MATCH (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MATCH (laplacian_ricci_file:LeanFile {namespace:'OmegaTheoryV2', path:'OmegaTheory/Emergence/LaplacianRicci.lean'})
MATCH (einstein_file:LeanFile {namespace:'OmegaTheoryV2', path:'OmegaTheory/Emergence/EinsteinEmergence.lean'})

// Theorems in LaplacianRicci.lean that directly consume the axiom
MERGE (t1:Theorem {namespace:'OmegaTheoryV2', name:'hpw_discrete_laplacian_convergence'})
SET t1.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t1.ai_description = 'Old split axiom, now theorem. Unfolds continuumBoxG = -2R and applies HPW axiom.',
    t1.depth_from_axiom = 1
MERGE (t1)-[:USES_AXIOM]->(hpw)
MERGE (laplacian_ricci_file)-[:DECLARES]->(t1)

MERGE (t2:Theorem {namespace:'OmegaTheoryV2', name:'laplacian_ricci_correspondence'})
SET t2.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t2.ai_description = 'Slightly weaker (l_P instead of l_P/2) form of HPW. Direct consequence.',
    t2.depth_from_axiom = 1
MERGE (t2)-[:USES_AXIOM]->(hpw)
MERGE (laplacian_ricci_file)-[:DECLARES]->(t2)

MERGE (t3:Theorem {namespace:'OmegaTheoryV2', name:'ricci_from_equilibrium_balance'})
SET t3.file = 'OmegaTheory/Emergence/LaplacianRicci.lean',
    t3.ai_description = 'At equilibrium, Ricci determined by defects + information up to O(l_P). Uses laplacian_ricci_correspondence, therefore HPW.',
    t3.depth_from_axiom = 2
MERGE (t3)-[:USES_THEOREM]->(t2)
MERGE (laplacian_ricci_file)-[:DECLARES]->(t3)

MERGE (t4:Theorem {namespace:'OmegaTheoryV2', name:'einstein_with_matter_emergence'})
SET t4.file = 'OmegaTheory/Emergence/EinsteinEmergence.lean',
    t4.ai_description = 'THE PRIZE. Reduces in one line to ricci_from_equilibrium_balance.',
    t4.depth_from_axiom = 3,
    t4.is_flagship = true
MERGE (t4)-[:USES_THEOREM]->(t3)
MERGE (einstein_file)-[:DECLARES]->(t4);

RETURN 'OmegaTheoryV2 graph bootstrap complete.' AS status;
