// =====================================================================
// fastrp_config — 16 FastRP runs (1 full + 15 per-relation) for V3-for-Lean
//
// Author:       Zaurak  (Azha-Delta, gamma-Eri)
// Date:         2026-04-18
// Namespace:    'OmegaTheoryV2'   (touches Declaration nodes)
//               'LeanAlgebra'     (alpha_k scratch on NavigationMaster)
// Plan:         ~/.claude/plans/elegant-sauteeing-simon.md  (Phase 1)
// Design memo:  ~/papers/OmegaTheoryAlgebra/06_fastrp_scaling.md
// GDS:          2.x (bundled in container `math`)
//
// Purpose:
//   Compute per-relation diffused projections rho_k on Declaration nodes:
//     rho_0      = full projection across all 15 relations   (undirected)
//     rho_k      = projection on the k-th relation subgraph  (k = 1..15)
//     delta_k    = rho_k - rho_0                              (64-dim residual)
//     alpha_k    = mean_{decl} || delta_k ||_2                (scalar)
//
// Parameters (from design memo 06):
//   embedding_dim         : 64   (per relation; 15 relations => composite 960)
//   iterationWeights      : [0.0, 1.0, 1.0, 0.5]
//   randomSeed            : 42
//   propertyRatio         : 0.5
//   featureProperties     : ['embedding_lean']      (ByT5-small 1472-d seed)
//   orientation           : UNDIRECTED              (symmetric for rho_0)
//
// Prerequisites:
//   * catalogue_declarations.cypher has run (Declaration nodes present).
//   * catalogue_load_patch.py has written embedding_lean (1472-d ByT5).
//   * catalogue_declarations_extension.cypher ran (embedding_lean slot exists).
//   * lean_algebra_arrows.cypher ran (15 QuiverArrow rows and names).
//
// To load:
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/fastrp_config.cypher
//
// GDS 2.x notes:
//   * `gds.graph.filter` was removed in 2.4+; we reconstruct per-relation
//     graphs via `gds.graph.project` with the single relationship type.
//     This keeps the file compatible with both 2.x and 2.4+.
//   * `gds.util.l2Norm` is NOT an official GDS procedure; we implement
//     an L2 norm via pure Cypher + apoc.coll.sum.
//   * FastRP consumes `featureProperties` of the given `embeddingDimension`
//     or PADS / TRUNCS the feature to the target dim. Feeding a 1472-d
//     seed into a 64-d projection with propertyRatio = 0.5 means 32 dims
//     come from a random-projection-of-the-seed and 32 dims from the
//     graph iteration (2nd + 3rd hop neighbourhoods).
//
// Pairs with:
//   lean_magnetic_laplacian.cypher   (same 15-relation enumeration)
//   grothendieck_lean.cypher         (concatenates proj_* into composite_proj)
//   erdos_enrich.cypher              (reads alpha_k on NavigationMaster)
// =====================================================================

// -------------------------------------------------------------
// 0. Pre-flight: drop any pre-existing graph projections so that
//    `gds.graph.project` calls below are idempotent.
// -------------------------------------------------------------
CALL {
  UNWIND [
    'lean-full',
    'lean-IMPORTS', 'lean-OPENS_NAMESPACE', 'lean-EXTENDS', 'lean-INSTANTIATES',
    'lean-ASSUMES', 'lean-APPLIES', 'lean-UNFOLDS', 'lean-SPECIALIZES', 'lean-REWRITES_BY',
    'lean-HAS_TYPE', 'lean-CONSTRAINED_BY', 'lean-PARAMETRIZES',
    'lean-REDUCES_TO', 'lean-ELABORATES_AS', 'lean-SUGGESTED_BY'
  ] AS g
  CALL apoc.do.when(
    gds.graph.exists(g).exists,
    'CALL gds.graph.drop($g) YIELD graphName RETURN graphName',
    'RETURN $g AS graphName',
    {g: g}
  ) YIELD value
  RETURN value.graphName AS dropped
};

// -------------------------------------------------------------
// 1. Full projection (rho_0)
//
//    All 15 relations, UNDIRECTED, Declaration nodes only.
//    Seed feature: `embedding_lean` (1472-d ByT5 retriever output).
// -------------------------------------------------------------
CALL gds.graph.project(
  'lean-full',
  {
    Declaration: {
      label: 'Declaration',
      properties: {
        embedding_lean: { property: 'embedding_lean', defaultValue: null }
      }
    }
  },
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

CALL gds.fastRP.mutate('lean-full', {
  embeddingDimension: 64,
  iterationWeights:   [0.0, 1.0, 1.0, 0.5],
  randomSeed:         42,
  propertyRatio:      0.5,
  featureProperties:  ['embedding_lean'],
  mutateProperty:     'rho0'
});

// Write rho0 back to the Neo4j store so downstream files see it.
CALL gds.graph.nodeProperties.write('lean-full', ['rho0']);

// -------------------------------------------------------------
// 2. Per-relation projections (15 runs)
//
//    Each run projects Declaration nodes with exactly one relation type
//    as UNDIRECTED, then runs FastRP and writes `proj_<RELATION>` back.
// -------------------------------------------------------------
UNWIND [
  { rel: 'IMPORTS',         prop: 'proj_IMPORTS',         graph: 'lean-IMPORTS'         },
  { rel: 'OPENS_NAMESPACE', prop: 'proj_OPENS_NAMESPACE', graph: 'lean-OPENS_NAMESPACE' },
  { rel: 'EXTENDS',         prop: 'proj_EXTENDS',         graph: 'lean-EXTENDS'         },
  { rel: 'INSTANTIATES',    prop: 'proj_INSTANTIATES',    graph: 'lean-INSTANTIATES'    },
  { rel: 'ASSUMES',         prop: 'proj_ASSUMES',         graph: 'lean-ASSUMES'         },
  { rel: 'APPLIES',         prop: 'proj_APPLIES',         graph: 'lean-APPLIES'         },
  { rel: 'UNFOLDS',         prop: 'proj_UNFOLDS',         graph: 'lean-UNFOLDS'         },
  { rel: 'SPECIALIZES',     prop: 'proj_SPECIALIZES',     graph: 'lean-SPECIALIZES'     },
  { rel: 'REWRITES_BY',     prop: 'proj_REWRITES_BY',     graph: 'lean-REWRITES_BY'     },
  { rel: 'HAS_TYPE',        prop: 'proj_HAS_TYPE',        graph: 'lean-HAS_TYPE'        },
  { rel: 'CONSTRAINED_BY',  prop: 'proj_CONSTRAINED_BY',  graph: 'lean-CONSTRAINED_BY'  },
  { rel: 'PARAMETRIZES',    prop: 'proj_PARAMETRIZES',    graph: 'lean-PARAMETRIZES'    },
  { rel: 'REDUCES_TO',      prop: 'proj_REDUCES_TO',      graph: 'lean-REDUCES_TO'      },
  { rel: 'ELABORATES_AS',   prop: 'proj_ELABORATES_AS',   graph: 'lean-ELABORATES_AS'   },
  { rel: 'SUGGESTED_BY',    prop: 'proj_SUGGESTED_BY',    graph: 'lean-SUGGESTED_BY'    }
] AS r
CALL {
  WITH r
  // Build the per-relation projection (single relationship type, undirected).
  CALL apoc.cypher.doIt(
    'CALL gds.graph.project($graph, ' +
      '{Declaration: {label: "Declaration", properties: {embedding_lean: {property: "embedding_lean", defaultValue: null}}}}, ' +
      '{`' + r.rel + '`: {orientation: "UNDIRECTED"}}, ' +
      '{nodeFilter: "n.namespace = \"OmegaTheoryV2\""}) YIELD graphName RETURN graphName',
    { graph: r.graph }
  ) YIELD value AS projected
  // Run FastRP on that projection, writing proj_<REL> as a mutation.
  CALL gds.fastRP.mutate(r.graph, {
    embeddingDimension: 64,
    iterationWeights:   [0.0, 1.0, 1.0, 0.5],
    randomSeed:         42,
    propertyRatio:      0.5,
    featureProperties:  ['embedding_lean'],
    mutateProperty:     r.prop
  }) YIELD nodePropertiesWritten
  // Persist to the store, then drop the ephemeral projection.
  CALL gds.graph.nodeProperties.write(r.graph, [r.prop]) YIELD propertiesWritten
  CALL gds.graph.drop(r.graph) YIELD graphName
  RETURN nodePropertiesWritten, propertiesWritten, graphName
}
RETURN r.rel AS relation, nodePropertiesWritten, propertiesWritten;

// Drop the full projection now that rho0 is persisted.
CALL gds.graph.drop('lean-full') YIELD graphName RETURN graphName;

// -------------------------------------------------------------
// 3. Residual computation: delta_k = proj_k - rho_0
//
//    Stored as `delta_<REL>` on each Declaration. Pure Cypher, no GDS.
// -------------------------------------------------------------
WITH ['IMPORTS','OPENS_NAMESPACE','EXTENDS','INSTANTIATES',
      'ASSUMES','APPLIES','UNFOLDS','SPECIALIZES','REWRITES_BY',
      'HAS_TYPE','CONSTRAINED_BY','PARAMETRIZES',
      'REDUCES_TO','ELABORATES_AS','SUGGESTED_BY'] AS rels
UNWIND rels AS rel
  CALL apoc.cypher.doIt(
    'MATCH (d:Declaration {namespace: "OmegaTheoryV2"}) ' +
    'WHERE d.rho0 IS NOT NULL AND d[$projProp] IS NOT NULL ' +
    'WITH d, $deltaProp AS dp, [i IN range(0,63) | d[$projProp][i] - d.rho0[i]] AS residual ' +
    'CALL apoc.create.setProperty(d, dp, residual) YIELD node ' +
    'RETURN count(node) AS updated',
    { projProp: 'proj_' + rel, deltaProp: 'delta_' + rel }
  ) YIELD value
  RETURN rel, value.updated;

// -------------------------------------------------------------
// 4. Scalar blast-radius metric: alpha_k = mean || delta_k ||_2
//
//    L2 norm via plain Cypher:  sqrt(sum(delta_i^2))
//    Mean via avg() over OmegaTheoryV2 Declarations.
//    Written to the NavigationMaster node in the OmegaTheoryV2 namespace
//    (consumed directly by erdos_enrich.cypher Field 4, which reads
//    nav.alpha_* off (NavigationMaster {namespace: 'OmegaTheoryV2'})).
// -------------------------------------------------------------
// Ensure the NavigationMaster node exists (idempotent).
MERGE (nm:NavigationMaster {namespace: 'OmegaTheoryV2'})
ON CREATE SET nm.name = 'OmegaTheoryV2',
              nm.created_at = datetime('2026-04-18T00:00:00Z'),
              nm.description = 'OmegaTheoryV2 root NavigationMaster. Carries FastRP residual-norm aggregates (alpha_k) per QuiverArrow relation, populated by fastrp_config.cypher.';

WITH ['IMPORTS','OPENS_NAMESPACE','EXTENDS','INSTANTIATES',
      'ASSUMES','APPLIES','UNFOLDS','SPECIALIZES','REWRITES_BY',
      'HAS_TYPE','CONSTRAINED_BY','PARAMETRIZES',
      'REDUCES_TO','ELABORATES_AS','SUGGESTED_BY'] AS rels
UNWIND rels AS rel
  CALL {
    WITH rel
    MATCH (d:Declaration {namespace: 'OmegaTheoryV2'})
    WHERE d['delta_' + rel] IS NOT NULL
    WITH rel,
         sqrt(reduce(s = 0.0, x IN d['delta_' + rel] | s + x * x)) AS l2
    RETURN rel AS relation, avg(l2) AS alpha
  }
  MATCH (nm:NavigationMaster {namespace: 'OmegaTheoryV2'})
  CALL apoc.create.setProperty(nm, 'alpha_' + relation, alpha) YIELD node
  RETURN relation, alpha;

// Touch the NavigationMaster with a computed_at timestamp.
MATCH (nm:NavigationMaster {namespace: 'OmegaTheoryV2'})
SET nm.fastrp_computed_at = datetime(),
    nm.fastrp_last_updated = datetime('2026-04-18T00:00:00Z');

// -------------------------------------------------------------
// 5. Diagnostics
// -------------------------------------------------------------
RETURN 'fastrp_config complete.' AS status,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.rho0 IS NOT NULL }           AS rho0_count,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.proj_APPLIES IS NOT NULL }   AS proj_APPLIES_count,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) WHERE d.delta_APPLIES IS NOT NULL }  AS delta_APPLIES_count,
       [ key IN keys((:NavigationMaster {namespace: 'OmegaTheoryV2'}))
         WHERE key STARTS WITH 'alpha_' ]                                                       AS alpha_keys;

// -------------------------------------------------------------
// 6. TODOs (flagged for follow-up work)
// -------------------------------------------------------------
// TODO[ZA-PY-001]: Python companion script to iterate FastRP over
//   multiple random seeds (e.g. 10 seeds) and report alpha_k stability.
//   Current file uses a single seed (42); a mean + variance gives a
//   more honest blast-radius estimate.
//
// TODO[ZA-PY-002]: Silhouette-based auto-tuning of k (K-means cluster
//   count) in grothendieck_lean.cypher currently defaults to 15. A
//   Python driver should compute silhouette coefficient for k in 3..20
//   and set the final cluster_topo accordingly. Cypher alone cannot
//   do this without a native GDS call that does not exist in 2.x.
//
// TODO[ZA-CY-001]: If GDS 2.4+ restores `gds.graph.filter`, the 15
//   per-relation projections can be replaced by a single full-graph
//   projection + filter (saves projection overhead).
