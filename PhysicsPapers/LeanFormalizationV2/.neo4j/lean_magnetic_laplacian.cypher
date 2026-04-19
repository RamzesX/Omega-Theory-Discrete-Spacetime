// =====================================================================
// lean_magnetic_laplacian — populate the 6x6 Hermitian Magnetic Laplacian
//
// Author:       Zaurak  (Azha-Delta, gamma-Eri)
// Date:         2026-04-18
// Namespace:    'LeanAlgebra'         (ontology / laplacian / components)
//               'OmegaTheoryV2'        (source of empirical arrow counts)
// Plan:         ~/.claude/plans/elegant-sauteeing-simon.md  (Phase 1)
// Design memo:  ~/papers/OmegaTheoryAlgebra/04_magnetic_laplacian.md
//
// Purpose:
//   The MagneticLaplacian node (created by lean_algebra_ontology.cypher)
//   holds only its formula-level description. This file populates the
//   actual 6x6 complex Hermitian matrix by:
//     1. adding two real 6x6 matrices for REAL and IMAG parts;
//     2. registering an APOC-custom procedure `omega.laplacian.recompute()`
//        that aggregates QuiverArrow weights from the Declaration graph;
//     3. materializing 15 MagneticLaplacian_component nodes (one per
//        QuiverArrow generator) for the rank-2 per-relation decomposition;
//     4. exposing a verification query that checks Hermiticity.
//
// Row / column ordering (ALPHABETICAL, fixed):
//   0 = Axiom      (pure source)
//   1 = Definition (semantic data)
//   2 = Instance   (pure sink)
//   3 = Namespace  (environmental context)
//   4 = Structure  (framework)
//   5 = Theorem    (active hub)
//
//   NOTE: This differs from lean_algebra_ontology.cypher's listed
//         `vertex_order = ['Axiom','Theorem','Definition','Structure','Instance','Namespace']`.
//         We use ALPHABETICAL here as stated in the Azha-Delta task spec
//         so downstream Python consumers can zip to a sorted vertex list.
//         We rewrite the ontology node's vertex_order to match.
//
// Prerequisites:
//   * lean_algebra_ontology.cypher has run (MagneticLaplacian node exists,
//     6 QuiverVertex nodes in LeanAlgebra namespace).
//   * lean_algebra_arrows.cypher has run (15 QuiverArrow nodes).
//   * catalogue_declarations.cypher has run (Declaration/Theorem/Axiom
//     nodes populated with Mathlib + OmegaTheory content).
//   * APOC is available in the 'math' container (core + extended).
//
// To load:
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/lean_magnetic_laplacian.cypher
//
// Hermiticity contract (checked at end of file):
//     imag[i][j] == -imag[j][i]   for all i,j
//     imag[i][i] == 0             for all i  (real diagonal)
//
// Pairs with:
//   lean_algebra_ontology.cypher          (seeds the MagneticLaplacian node)
//   lean_algebra_arrows.cypher            (seeds the 15 QuiverArrow rows)
//   fastrp_config.cypher                  (consumes the 15 relations as graph projections)
// =====================================================================

// -------------------------------------------------------------
// 0. Uniqueness constraint for the per-relation components
// -------------------------------------------------------------
CREATE CONSTRAINT lean_magnetic_laplacian_component_unique IF NOT EXISTS
  FOR (c:MagneticLaplacian_component)
  REQUIRE (c.namespace, c.relation_name) IS UNIQUE;

// -------------------------------------------------------------
// 1. Align the ontology node to the alphabetical ordering used
//    by downstream code + persist the zero-initialized 6x6 matrices.
// -------------------------------------------------------------
MATCH (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
SET laplacian.vertex_order = ['Axiom','Definition','Instance','Namespace','Structure','Theorem'],
    laplacian.vertex_order_rationale = 'alphabetical -- matches numpy / Python-consumer canonical index',
    // Matrices stored as FLAT 36-element row-major lists (Neo4j forbids nested arrays).
    // Access cell (i,j) as real_part[6*i + j] where i,j are alphabetical indices.
    laplacian.matrix_layout = 'row_major_flat_36',
    laplacian.real_part = [
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,  // row 0 : Axiom
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,  // row 1 : Definition
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,  // row 2 : Instance
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,  // row 3 : Namespace
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,  // row 4 : Structure
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0   // row 5 : Theorem
    ],
    laplacian.imag_part = [
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    ],
    laplacian.populated     = false,
    laplacian.computed_at   = null,
    laplacian.last_updated  = datetime('2026-04-18T00:00:00Z');

// -------------------------------------------------------------
// 2. Seed 15 MagneticLaplacian_component nodes.
//
// Each component C_k stores:
//     relation_name      : QuiverArrow.name (e.g. 'ASSUMES')
//     source_idx / tgt_idx : alphabetical row indices of (src,tgt) vertex
//     raw_count          : B_{src,tgt} = empirical count of edges of this type
//     reverse_count      : B_{tgt,src} = empirical count of reverse edges
//     symmetric_weight   : W^(s) = (raw + reverse) / 2
//     direction_sign     : D = sign(raw - reverse)
//     phase_real         : cos(2*pi*g*D) * W^(s)         with g=1/4
//     phase_imag         : sin(2*pi*g*D) * W^(s)         with g=1/4
//     rank_contribution  : 2  (off-diagonal real + off-diagonal imag)
//
// On load, all empirical counts are 0 (the Declaration edges of these
// types are populated by catalogue_load_patch.py AFTER ingestion).
// omega.laplacian.recompute() refreshes them from the live graph.
// -------------------------------------------------------------
WITH [
  // alphabetical: Axiom=0 Definition=1 Instance=2 Namespace=3 Structure=4 Theorem=5
  { relation_name: 'IMPORTS',         source_idx: 3, target_idx: 3, category: 'I'   },  // Namespace -> Namespace
  { relation_name: 'OPENS_NAMESPACE', source_idx: 3, target_idx: 3, category: 'I'   },  // Namespace -> Namespace
  { relation_name: 'EXTENDS',         source_idx: 4, target_idx: 4, category: 'I'   },  // Structure -> Structure
  { relation_name: 'INSTANTIATES',    source_idx: 2, target_idx: 4, category: 'I'   },  // Instance  -> Structure
  { relation_name: 'ASSUMES',         source_idx: 5, target_idx: 0, category: 'II'  },  // Theorem   -> Axiom
  { relation_name: 'APPLIES',         source_idx: 5, target_idx: 5, category: 'II'  },  // Theorem   -> Theorem
  { relation_name: 'UNFOLDS',         source_idx: 5, target_idx: 1, category: 'II'  },  // Theorem   -> Definition
  { relation_name: 'SPECIALIZES',     source_idx: 5, target_idx: 5, category: 'II'  },  // Theorem   -> Theorem
  { relation_name: 'REWRITES_BY',     source_idx: 5, target_idx: 1, category: 'II'  },  // Theorem   -> Definition
  { relation_name: 'HAS_TYPE',        source_idx: 1, target_idx: 1, category: 'III' },  // Definition-> Definition
  { relation_name: 'CONSTRAINED_BY',  source_idx: 5, target_idx: 4, category: 'III' },  // Theorem   -> Structure
  { relation_name: 'PARAMETRIZES',    source_idx: 4, target_idx: 1, category: 'III' },  // Structure -> Definition
  { relation_name: 'REDUCES_TO',      source_idx: 5, target_idx: 5, category: 'IV'  },  // Theorem   -> Theorem
  { relation_name: 'ELABORATES_AS',   source_idx: 1, target_idx: 1, category: 'IV'  },  // Definition-> Definition
  { relation_name: 'SUGGESTED_BY',    source_idx: 5, target_idx: 5, category: 'IV'  }   // Theorem   -> Theorem
] AS components
UNWIND components AS c
MERGE (mc:MagneticLaplacian_component {namespace: 'LeanAlgebra', relation_name: c.relation_name})
SET mc.source_idx         = c.source_idx,
    mc.target_idx         = c.target_idx,
    mc.category           = c.category,
    mc.raw_count          = 0,
    mc.reverse_count      = 0,
    mc.symmetric_weight   = 0.0,
    mc.direction_sign     = 0,
    mc.phase_real         = 0.0,
    mc.phase_imag         = 0.0,
    mc.rank_contribution  = 2,
    mc.last_updated       = datetime('2026-04-18T00:00:00Z');

// Link each component to its parent MagneticLaplacian and its QuiverArrow
MATCH (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
MATCH (mc:MagneticLaplacian_component {namespace: 'LeanAlgebra'})
MERGE (laplacian)-[:HAS_COMPONENT {namespace: 'LeanAlgebra'}]->(mc);

MATCH (mc:MagneticLaplacian_component {namespace: 'LeanAlgebra'})
MATCH (arrow:QuiverArrow {namespace: 'LeanAlgebra', name: mc.relation_name})
MERGE (mc)-[:DECOMPOSES {namespace: 'LeanAlgebra'}]->(arrow);

// -------------------------------------------------------------
// 3. APOC-custom procedure : omega.laplacian.recompute()
//
// Reads the live Declaration graph, aggregates edge counts per
// relation type (using cypher_edge_name from each QuiverArrow),
// rebuilds the symmetric W^(s), direction D, phase T^(g), degree
// Delta and writes REAL/IMAG matrices back onto the MagneticLaplacian
// node. Targets the OmegaTheoryV2 namespace (the real ingestion target).
//
// g = 1/4 is read from the MagneticLaplacian's charge_parameter_g.
// -------------------------------------------------------------
CALL apoc.custom.declareProcedure(
  'omega.laplacian.recompute',
  "
  WITH $namespace AS ns
  MATCH (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
  WITH laplacian, laplacian.charge_parameter_g AS g, ns
  // Collect per-relation raw counts from the live declaration graph.
  MATCH (arrow:QuiverArrow {namespace: 'LeanAlgebra'})
  WITH laplacian, g, ns, collect(arrow) AS arrows
  UNWIND arrows AS arrow
    CALL apoc.cypher.run(
      'MATCH (:Declaration {namespace: $ns})-[r]->(:Declaration {namespace: $ns}) ' +
      'WHERE type(r) = $rel RETURN count(r) AS c',
      { ns: ns, rel: arrow.cypher_edge_name }
    ) YIELD value AS raw
    CALL apoc.cypher.run(
      'MATCH (:Declaration {namespace: $ns})<-[r]-(:Declaration {namespace: $ns}) ' +
      'WHERE type(r) = $rel RETURN count(r) AS c',
      { ns: ns, rel: arrow.cypher_edge_name }
    ) YIELD value AS rev
    WITH laplacian, g, arrow, toFloat(raw.c) AS raw_count, toFloat(rev.c) AS rev_count
    // symmetric, direction, phase
    WITH laplacian, g, arrow,
         raw_count, rev_count,
         (raw_count + rev_count) / 2.0 AS w_sym,
         CASE
           WHEN raw_count > rev_count THEN  1
           WHEN raw_count < rev_count THEN -1
           ELSE 0
         END AS d_sign
    WITH laplacian, arrow, raw_count, rev_count, w_sym, d_sign,
         cos(2.0 * 3.141592653589793 * g * d_sign) * w_sym AS p_real,
         sin(2.0 * 3.141592653589793 * g * d_sign) * w_sym AS p_imag
    MATCH (mc:MagneticLaplacian_component {namespace: 'LeanAlgebra', relation_name: arrow.name})
    SET mc.raw_count         = toInteger(raw_count),
        mc.reverse_count     = toInteger(rev_count),
        mc.symmetric_weight  = w_sym,
        mc.direction_sign    = d_sign,
        mc.phase_real        = p_real,
        mc.phase_imag        = p_imag,
        mc.last_updated      = datetime()
  RETURN 'components updated' AS status, count(arrow) AS relations_processed
  ",
  'WRITE',
  [['status','STRING'],['relations_processed','INTEGER']],
  [['namespace','STRING']],
  'Recompute MagneticLaplacian_component rows from live Declaration edges in the given namespace.'
);

// -------------------------------------------------------------
// 4. Matrix assembly : aggregate per-relation components into the 6x6
//
// This is a second procedure omega.laplacian.assemble() that:
//   (a) re-reads every MagneticLaplacian_component,
//   (b) folds phase_real / phase_imag into a pair of 6x6 nested lists,
//   (c) computes the real-valued degree diagonal Delta_XX,
//   (d) sets A = Delta - T^(g) * W^(s)  (off-diag subtracted, diag added)
//   (e) writes real_part + imag_part back to the MagneticLaplacian node.
// -------------------------------------------------------------
CALL apoc.custom.declareProcedure(
  'omega.laplacian.assemble',
  "
  MATCH (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
  WITH laplacian,
       [i IN range(0,5) | [j IN range(0,5) | 0.0]] AS real0,
       [i IN range(0,5) | [j IN range(0,5) | 0.0]] AS imag0,
       [i IN range(0,5) | 0.0]                    AS degree0
  // Fold component contributions into Python-style nested lists.
  CALL {
    WITH laplacian
    MATCH (mc:MagneticLaplacian_component {namespace: 'LeanAlgebra'})
    RETURN collect({
      i: mc.source_idx,
      j: mc.target_idx,
      w: mc.symmetric_weight,
      pr: mc.phase_real,
      pi: mc.phase_imag
    }) AS rows
  }
  WITH laplacian, real0, imag0, degree0, rows
  UNWIND rows AS row
    WITH laplacian, real0, imag0, degree0, row
    // Update off-diagonal entries in real_part and imag_part
    // A_{ij} = -T^(g)_{ij} * W^(s)_{ij}  for i != j
    WITH laplacian,
         apoc.coll.set(real0, row.i,
           apoc.coll.set(real0[row.i], row.j,
             real0[row.i][row.j] + CASE WHEN row.i = row.j THEN row.w ELSE -row.pr END)) AS real1,
         apoc.coll.set(imag0, row.i,
           apoc.coll.set(imag0[row.i], row.j,
             imag0[row.i][row.j] + CASE WHEN row.i = row.j THEN 0.0 ELSE -row.pi END)) AS imag1,
         apoc.coll.set(degree0, row.i, degree0[row.i] + row.w) AS degree1
    WITH laplacian, real1, imag1, degree1
    // Persist. Diagonal is already folded into real0[i][i] via the
    // row.i == row.j path above (self-loop arrows) AND via the degree
    // accumulator -- the final diagonal A_{ii} = Delta_{ii}.
    SET laplacian.real_part   = [i IN range(0,5) |
          [j IN range(0,5) |
            CASE WHEN i = j THEN degree1[i] ELSE real1[i][j] END]],
        laplacian.imag_part   = imag1,
        laplacian.populated   = true,
        laplacian.computed_at = datetime()
  RETURN 'matrix assembled' AS status
  ",
  'WRITE',
  [['status','STRING']],
  [],
  'Assemble real_part / imag_part 6x6 matrices on MagneticLaplacian from MagneticLaplacian_component rows.'
);

// -------------------------------------------------------------
// 5. Verification procedure : omega.laplacian.verify()
//
// Checks two Hermiticity invariants:
//   (a) imag[i][j] == -imag[j][i]        (strict)
//   (b) imag[i][i] == 0 for all i        (diagonal real)
// Returns a list of violating (i,j) pairs, or empty if clean.
// -------------------------------------------------------------
CALL apoc.custom.declareProcedure(
  'omega.laplacian.verify',
  "
  MATCH (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
  WITH laplacian.imag_part AS M
  WITH M,
       [i IN range(0,5), j IN range(0,5)
          WHERE abs(M[i][j] + M[j][i]) > 1e-9
        | {i: i, j: j, imag_ij: M[i][j], imag_ji: M[j][i]}
       ] AS antisym_violations,
       [i IN range(0,5)
          WHERE abs(M[i][i]) > 1e-9
        | {i: i, imag_ii: M[i][i]}
       ] AS diag_violations
  RETURN
    size(antisym_violations) = 0 AND size(diag_violations) = 0 AS hermitian,
    antisym_violations                                       AS antisym_violations,
    diag_violations                                          AS diag_violations
  ",
  'READ',
  [
    ['hermitian','BOOLEAN'],
    ['antisym_violations','LIST OF MAP'],
    ['diag_violations','LIST OF MAP']
  ],
  [],
  'Verify imag_part is antisymmetric and has zero diagonal (Hermiticity).'
);

// -------------------------------------------------------------
// 6. Indexes (lookup by relation_name already covered by uniqueness).
// -------------------------------------------------------------
CREATE INDEX lean_laplacian_component_category IF NOT EXISTS
  FOR (n:MagneticLaplacian_component) ON (n.category);

// -------------------------------------------------------------
// 7. Diagnostics
// -------------------------------------------------------------
RETURN 'lean_magnetic_laplacian seed complete.'                                 AS status,
       count { (l:MagneticLaplacian            {namespace: 'LeanAlgebra'}) }     AS laplacian_nodes,
       count { (c:MagneticLaplacian_component  {namespace: 'LeanAlgebra'}) }     AS component_nodes,
       count { (c:MagneticLaplacian_component  {namespace: 'LeanAlgebra'})
               -[:DECOMPOSES]->(:QuiverArrow {namespace: 'LeanAlgebra'}) }       AS component_to_arrow_edges;

// -------------------------------------------------------------
// 8. Hermiticity sanity check on the (zero-initialized) matrices
//    -- should pass trivially; rerun after omega.laplacian.assemble().
// -------------------------------------------------------------
CALL custom.omega.laplacian.verify()
YIELD hermitian, antisym_violations, diag_violations
RETURN hermitian, antisym_violations, diag_violations;
