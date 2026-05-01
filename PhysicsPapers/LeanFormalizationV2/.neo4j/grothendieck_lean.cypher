// =====================================================================
// grothendieck_lean — consensus clustering (Leiden + K-means + Strehl/Ghosh)
//                     + Berry-phase boundary probe
//
// Author:       Zaurak  (Azha-Delta, gamma-Eri)
// Date:         2026-04-18
// Namespace:    'OmegaTheoryV2'   (clusters live on Declaration nodes)
// Plan:         ~/.claude/plans/elegant-sauteeing-simon.md  (Phase 1.5)
// Design memos: ~/papers/OmegaTheoryAlgebra/05_cycle_hypotheses.md
//               ~/papers/OmegaTheoryAlgebra/06_fastrp_scaling.md
//
// Purpose:
//   After fastrp_config.cypher has written proj_<REL> (15 x 64-d) +
//   rho0 (64-d) + delta_<REL> (15 x 64-d) onto each Declaration, run
//   FIVE clustering + boundary steps:
//     A. concatenate per-relation projections => composite_proj (R^960)
//     B. K-means on composite_proj             => cluster_topo   (topology flavor)
//     C. Leiden on the 15-relation UNDIRECTED multi-graph
//                                              => cluster_graph  (graph flavor)
//     D. co-association (Strehl & Ghosh 2002) + Berry-phase probe
//                                              => subsystem_id + boundary_candidate
//     E. confidence                            => subsystem_confidence (HIGH/LOW)
//
// The Grothendieck analogy:
//   Two lenses (topology-of-embeddings vs. graph-cuts) agree up to an
//   isomorphism (the co-association relabelling). Where they DISAGREE,
//   we mark a boundary_candidate edge -- analogous to a Berry phase
//   obstruction between overlapping charts.
//
// Prerequisites:
//   * fastrp_config.cypher has run (rho0 + proj_<REL> + delta_<REL> populated)
//   * GDS 2.x with Leiden + K-means (both in 2.x Enterprise)
//   * APOC for apoc.coll.* + apoc.cypher.doIt
//
// To load:
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/grothendieck_lean.cypher
//
// Pairs with:
//   fastrp_config.cypher       (source of proj_* inputs)
//   erdos_enrich.cypher        (consumer of subsystem_id)
//   lean_magnetic_laplacian    (orthogonal per-type rank-2 decomposition)
// =====================================================================

// -------------------------------------------------------------
// 0. Pre-flight: drop any pre-existing projections so the file is idempotent.
// -------------------------------------------------------------
UNWIND ['lean-composite', 'lean-multi', 'lean-consensus'] AS g
CALL apoc.do.when(
  gds.graph.exists(g).exists,
  'CALL gds.graph.drop($g) YIELD graphName RETURN graphName',
  'RETURN $g AS graphName',
  {g: g}
) YIELD value
RETURN value.graphName AS dropped;

// =============================================================
// SECTION A: Composite projection in R^960
//
// Concatenate the 15 per-relation 64-d projections into a single
// 960-d vector `composite_proj`. Order matches lean_magnetic_laplacian's
// component-table enumeration so downstream code can slice by relation.
// =============================================================
MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.proj_IMPORTS IS NOT NULL
  AND d.proj_OPENS_NAMESPACE IS NOT NULL
  AND d.proj_EXTENDS IS NOT NULL
  AND d.proj_INSTANTIATES IS NOT NULL
  AND d.proj_ASSUMES IS NOT NULL
  AND d.proj_APPLIES IS NOT NULL
  AND d.proj_UNFOLDS IS NOT NULL
  AND d.proj_SPECIALIZES IS NOT NULL
  AND d.proj_REWRITES_BY IS NOT NULL
  AND d.proj_HAS_TYPE IS NOT NULL
  AND d.proj_CONSTRAINED_BY IS NOT NULL
  AND d.proj_PARAMETRIZES IS NOT NULL
  AND d.proj_REDUCES_TO IS NOT NULL
  AND d.proj_ELABORATES_AS IS NOT NULL
  AND d.proj_SUGGESTED_BY IS NOT NULL
SET d.composite_proj =
      d.proj_IMPORTS         + d.proj_OPENS_NAMESPACE + d.proj_EXTENDS
    + d.proj_INSTANTIATES    + d.proj_ASSUMES         + d.proj_APPLIES
    + d.proj_UNFOLDS         + d.proj_SPECIALIZES     + d.proj_REWRITES_BY
    + d.proj_HAS_TYPE        + d.proj_CONSTRAINED_BY  + d.proj_PARAMETRIZES
    + d.proj_REDUCES_TO      + d.proj_ELABORATES_AS   + d.proj_SUGGESTED_BY;

// Quick size check: composite_proj must be 960-dimensional.
MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.composite_proj IS NOT NULL AND size(d.composite_proj) <> 960
WITH count(d) AS malformed
CALL apoc.util.validate(
  malformed = 0,
  'composite_proj dimension check failed: ' + toString(malformed) + ' declarations are not 960-d',
  [malformed]
) RETURN malformed;

// =============================================================
// SECTION B: K-means on composite_proj
//
// Initial k = 15 (one-per-relation prior). Auto-tuning via silhouette
// is flagged as TODO (see file footer); silhouette is not a 2.x GDS
// procedure so Python must drive the k-sweep.
// =============================================================
CALL gds.graph.project(
  'lean-composite',
  {
    Declaration: {
      label: 'Declaration',
      properties: {
        composite_proj: { property: 'composite_proj', defaultValue: null }
      }
    }
  },
  '*',
  { nodeFilter: 'n.namespace = "OmegaTheoryV2" AND n.composite_proj IS NOT NULL' }
);

CALL gds.kmeans.mutate('lean-composite', {
  nodeProperty:       'composite_proj',
  k:                  15,
  randomSeed:         42,
  numberOfRestarts:   10,
  maxIterations:      50,
  deltaThreshold:     0.001,
  mutateProperty:     'cluster_topo'
});

CALL gds.graph.nodeProperties.write('lean-composite', ['cluster_topo']);
CALL gds.graph.drop('lean-composite') YIELD graphName RETURN graphName;

// =============================================================
// SECTION C: Leiden on the 15-relation UNDIRECTED multi-graph
//
// Second "lens": the bare graph structure, ignoring embedding content.
// =============================================================
CALL gds.graph.project(
  'lean-multi',
  { Declaration: { label: 'Declaration' } },
  {
    IMPORTS:         { orientation: 'UNDIRECTED' },
    OPENS_NAMESPACE: { orientation: 'UNDIRECTED' },
    EXTENDS:         { orientation: 'UNDIRECTED' },
    INSTANTIATES:    { orientation: 'UNDIRECTED' },
    ASSUMES:         { orientation: 'UNDIRECTED' },
    APPLIES:         { orientation: 'UNDIRECTED' },
    UNFOLDS:         { orientation: 'UNDIRECTED' },
    SPECIALIZES:     { orientation: 'UNDIRECTED' },
    REWRITES_BY:     { orientation: 'UNDIRECTED' },
    HAS_TYPE:        { orientation: 'UNDIRECTED' },
    CONSTRAINED_BY:  { orientation: 'UNDIRECTED' },
    PARAMETRIZES:    { orientation: 'UNDIRECTED' },
    REDUCES_TO:      { orientation: 'UNDIRECTED' },
    ELABORATES_AS:   { orientation: 'UNDIRECTED' },
    SUGGESTED_BY:    { orientation: 'UNDIRECTED' }
  },
  { nodeFilter: 'n.namespace = "OmegaTheoryV2"' }
);

CALL gds.leiden.mutate('lean-multi', {
  gamma:          1.0,
  theta:          0.01,
  maxLevels:      10,
  randomSeed:     42,
  mutateProperty: 'cluster_graph'
});

CALL gds.graph.nodeProperties.write('lean-multi', ['cluster_graph']);
CALL gds.graph.drop('lean-multi') YIELD graphName RETURN graphName;

// =============================================================
// SECTION D: Co-association (Strehl & Ghosh 2002) + Berry-phase probe
//
// Co-association builds a new weighted graph where two Declarations
// are connected with weight = (# clusterings in which they agree) / R.
// Here R = 2 (topo + graph lenses), so edge weight takes values in
// {0.0, 0.5, 1.0}.
//
// Then re-Leiden on the co-association graph to obtain the final
// `subsystem_id`.
//
// Berry-phase probe: for now we compute a CHEAP proxy -- flag
// declaration pairs where the SPECIALIZES and UNFOLDS projections
// ANTI-correlate (cos < -0.1). Exact Berry phase
// gamma_v(i,j,l) = -Im ln [<rho_v(i)|rho_v(j)> * <rho_v(j)|rho_v(l)> * <rho_v(l)|rho_v(i)>]
// needs complex arithmetic and triangle-loop enumeration; Python driver
// will do the exact version and write back `berry_phase` on boundary edges.
// =============================================================

// ----- D.1 : full-agreement edges (weight 1.0) ---------------
MATCH (d1:Declaration {namespace: 'OmegaTheoryV2'}),
      (d2:Declaration {namespace: 'OmegaTheoryV2'})
WHERE elementId(d1) < elementId(d2)             -- avoid self + duplicate pairs (Neo4j 2026 elementId, lex order)
  AND d1.cluster_topo  IS NOT NULL
  AND d2.cluster_topo  IS NOT NULL
  AND d1.cluster_graph IS NOT NULL
  AND d2.cluster_graph IS NOT NULL
  AND d1.cluster_topo  = d2.cluster_topo
  AND d1.cluster_graph = d2.cluster_graph
MERGE (d1)-[r:CONSENSUS_SIM]-(d2)
SET r.weight    = 1.0,
    r.namespace = 'OmegaTheoryV2';

// ----- D.2 : half-agreement edges (weight 0.5) ---------------
// Pairs where exactly ONE of the two clusterings groups them together.
MATCH (d1:Declaration {namespace: 'OmegaTheoryV2'}),
      (d2:Declaration {namespace: 'OmegaTheoryV2'})
WHERE elementId(d1) < elementId(d2)
  AND d1.cluster_topo  IS NOT NULL
  AND d2.cluster_topo  IS NOT NULL
  AND d1.cluster_graph IS NOT NULL
  AND d2.cluster_graph IS NOT NULL
  AND (d1.cluster_topo = d2.cluster_topo) <> (d1.cluster_graph = d2.cluster_graph)
MERGE (d1)-[r:CONSENSUS_SIM]-(d2)
SET r.weight    = 0.5,
    r.namespace = 'OmegaTheoryV2';

// ----- D.3 : Re-Leiden on CONSENSUS_SIM ---------------------
CALL gds.graph.project(
  'lean-consensus',
  { Declaration: { label: 'Declaration' } },
  {
    CONSENSUS_SIM: {
      orientation: 'UNDIRECTED',
      properties:  { weight: { property: 'weight', defaultValue: 0.5 } }
    }
  },
  { nodeFilter: 'n.namespace = "OmegaTheoryV2"' }
);

CALL gds.leiden.mutate('lean-consensus', {
  relationshipWeightProperty: 'weight',
  gamma:          1.0,
  theta:          0.01,
  maxLevels:      10,
  randomSeed:     42,
  mutateProperty: 'subsystem_id'
});

CALL gds.graph.nodeProperties.write('lean-consensus', ['subsystem_id']);
CALL gds.graph.drop('lean-consensus') YIELD graphName RETURN graphName;

// ----- D.3b : Materialize SubsystemNavigator nodes + CONTAINS edges
//
// Consumed by erdos_enrich.cypher, which expects:
//   (:SubsystemNavigator {namespace:'OmegaTheoryV2'})-[:CONTAINS]->(member)
//
// Uniqueness constraint is (re)declared here to keep this file
// self-contained; idempotent via MERGE.
CREATE CONSTRAINT subsystem_navigator_unique IF NOT EXISTS
  FOR (n:SubsystemNavigator)
  REQUIRE (n.namespace, n.subsystem_id) IS UNIQUE;

MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.subsystem_id IS NOT NULL
WITH d.subsystem_id AS sid, count(d) AS member_count
MERGE (s:SubsystemNavigator {namespace: 'OmegaTheoryV2', subsystem_id: sid})
ON CREATE SET s.created_at = datetime('2026-04-18T00:00:00Z')
SET s.name         = 'Subsystem_' + toString(sid),
    s.member_count = member_count,
    s.last_updated = datetime('2026-04-18T00:00:00Z');

// Link every Declaration (and its Theorem / Axiom labelled counterparts)
// to its SubsystemNavigator via CONTAINS.
MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.subsystem_id IS NOT NULL
MATCH (s:SubsystemNavigator {namespace: 'OmegaTheoryV2', subsystem_id: d.subsystem_id})
MERGE (s)-[:CONTAINS {namespace: 'OmegaTheoryV2'}]->(d);

// Catalogue also creates Theorem / Axiom as distinct labels. Propagate
// subsystem_id to the corresponding Theorem / Axiom node if one exists
// with the same (namespace, name) key, then wire CONTAINS from that label.
MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.subsystem_id IS NOT NULL
OPTIONAL MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: d.name})
  WHERE t.subsystem_id IS NULL OR t.subsystem_id <> d.subsystem_id
SET t.subsystem_id = d.subsystem_id;

MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.subsystem_id IS NOT NULL
MATCH (s:SubsystemNavigator {namespace: 'OmegaTheoryV2', subsystem_id: t.subsystem_id})
MERGE (s)-[:CONTAINS {namespace: 'OmegaTheoryV2'}]->(t);

MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.subsystem_id IS NOT NULL
OPTIONAL MATCH (a:Axiom {namespace: 'OmegaTheoryV2', name: d.name})
  WHERE a.subsystem_id IS NULL OR a.subsystem_id <> d.subsystem_id
SET a.subsystem_id = d.subsystem_id;

MATCH (a:Axiom {namespace: 'OmegaTheoryV2'})
WHERE a.subsystem_id IS NOT NULL
MATCH (s:SubsystemNavigator {namespace: 'OmegaTheoryV2', subsystem_id: a.subsystem_id})
MERGE (s)-[:CONTAINS {namespace: 'OmegaTheoryV2'}]->(a);

// ----- D.4 : Berry-phase boundary PROXY --------------------
// Cosine similarity between proj_SPECIALIZES and proj_UNFOLDS as a
// cheap proxy for the 2-loop Berry-phase sign. Negative cosine =>
// "sewing" disagreement => boundary candidate for the exact Python pass.
//
// cos(u,v) = <u,v> / (||u|| * ||v||)
MATCH (d1:Declaration {namespace: 'OmegaTheoryV2'})-[r:CONSENSUS_SIM]-(d2:Declaration {namespace: 'OmegaTheoryV2'})
WHERE r.weight = 0.5
  AND d1.proj_SPECIALIZES IS NOT NULL
  AND d2.proj_UNFOLDS     IS NOT NULL
WITH d1, d2, r,
     d1.proj_SPECIALIZES AS u,
     d2.proj_UNFOLDS     AS v
WITH d1, d2, r,
     reduce(s = 0.0, i IN range(0, size(u) - 1) | s + u[i] * v[i])                AS dot,
     sqrt(reduce(s = 0.0, i IN range(0, size(u) - 1) | s + u[i] * u[i]))          AS nu,
     sqrt(reduce(s = 0.0, i IN range(0, size(v) - 1) | s + v[i] * v[i]))          AS nv
WITH d1, d2, r,
     CASE WHEN nu > 1e-12 AND nv > 1e-12 THEN dot / (nu * nv) ELSE 0.0 END AS cos_uv
SET r.cos_specialize_unfold = cos_uv,
    r.boundary_candidate    = cos_uv < -0.1;

// =============================================================
// SECTION E: Confidence labelling
//
// HIGH  = both lenses agree on cluster membership
// LOW   = only one lens agreed (or both disagreed)
// ALONE = declaration has no neighbours in CONSENSUS_SIM (rare but possible)
// =============================================================
MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.cluster_topo IS NOT NULL AND d.cluster_graph IS NOT NULL
SET d.subsystem_confidence =
  CASE
    WHEN d.cluster_topo = d.cluster_graph THEN 'HIGH'
    ELSE 'LOW'
  END;

// Isolated declarations (no CONSENSUS_SIM edges at all).
MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
WHERE d.cluster_topo IS NOT NULL
  AND NOT EXISTS { MATCH (d)-[:CONSENSUS_SIM]-() }
SET d.subsystem_confidence = 'ALONE';

// =============================================================
// SECTION F: Diagnostics
// =============================================================
RETURN 'grothendieck_lean complete.' AS status,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.composite_proj IS NOT NULL }        AS composite_count,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.cluster_topo  IS NOT NULL }         AS topo_clusters,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.cluster_graph IS NOT NULL }         AS graph_clusters,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.subsystem_id  IS NOT NULL }         AS subsystem_assignments,
       count { (s:SubsystemNavigator {namespace: 'OmegaTheoryV2'}) }                                    AS subsystem_navigators,
       count { (:SubsystemNavigator {namespace: 'OmegaTheoryV2'})-[:CONTAINS]->() }                     AS contains_edges,
       count { ()-[r:CONSENSUS_SIM]-() WHERE r.namespace = 'OmegaTheoryV2' }                            AS consensus_edges,
       count { ()-[r:CONSENSUS_SIM]-() WHERE r.boundary_candidate = true }                              AS boundary_candidates,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.subsystem_confidence = 'HIGH' }     AS high_confidence,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.subsystem_confidence = 'LOW' }      AS low_confidence,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.subsystem_confidence = 'ALONE' }    AS alone;

// -------------------------------------------------------------
// TODOs (flagged for Python / downstream follow-up)
// -------------------------------------------------------------
// TODO[ZA-PY-002]: Silhouette-driven k selection for K-means.
//   Currently k = 15 (fixed). Sweep k = 3..20, compute silhouette
//   coefficient on the Euclidean distance in composite_proj, pick
//   k_* = argmax silhouette. Requires Python (scikit-learn) -- not
//   exposed in GDS 2.x Cypher.
//
// TODO[ZA-PY-003]: EXACT Berry phase on 3-cycles. For each triangle
//   (i, j, l) in the CONSENSUS_SIM graph, compute
//      gamma_v(i,j,l) = -Im ln [<rho_v(i)|rho_v(j)> *
//                                <rho_v(j)|rho_v(l)> *
//                                <rho_v(l)|rho_v(i)>]
//   where rho_v(i) is the complex eigenvector of the MagneticLaplacian
//   for vertex v at declaration i. Compare boundary_candidate (cheap
//   proxy) to exact gamma_v != 0. Requires numpy + complex linalg;
//   not expressible in pure Cypher.
//
// TODO[ZA-CY-002]: Hierarchical Leiden on CONSENSUS_SIM with
//   multilevel gamma sweep to expose sub-subsystems; currently we
//   use a single gamma = 1.0.
