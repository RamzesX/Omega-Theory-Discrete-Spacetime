// =====================================================================
// erdos_enrich — SubsystemNavigator 7-field enrichment (Erdős Phase 1)
//
// Author:      Azha-Gamma (ζ Hydrae)
// Date:        2026-04-18
// Namespace:   'OmegaTheoryV2' (reads Declaration / LeanFile graph)
//              'LeanAlgebra'   (reads QuiverArrow / QuiverVertex taxonomy)
// Plan:        ~/.claude/plans/elegant-sauteeing-simon.md  (Phase 1G)
// Reference:   graph-theory-system-modeling/V3/ErdosGraphConsumer.md §3.2
//
// Depends on:
//   * grothendieck_lean.cypher has run and populated:
//       - d.subsystem_id property on every Declaration / Theorem / Axiom
//       (NOTE: Zaurak's grothendieck_lean.cypher only writes subsystem_id
//        onto Declaration nodes; this script MATERIALIZES the
//        SubsystemNavigator nodes + CONTAINS edges itself in section 0A
//        below, then enriches them.)
//   * fastrp_config.cypher wrote alpha_k rankings onto NavigationMaster
//   * lean_algebra_arrows.cypher seeded the 15 QuiverArrow rows
//
// Purpose:
//   Fill each SubsystemNavigator with 7 AI-readable fields derived PURELY
//   from the graph — no source code reads, no human prose — so downstream
//   AI agents can orient on a subsystem in O(1) hops from NavigationMaster.
//
//   The 7 fields follow V3 ErdosGraphConsumer §3.2 exactly, adapted to
//   Lean semantics (QuiverVertex labels: Axiom / Theorem / Definition /
//   Structure / Instance / Namespace):
//
//     sub.ai_instructions : "start-here" brief generated from subsystem shape
//     sub.query_hints     : canned Cypher the consumer agent can run
//     sub.entry_points    : highest-out-degree Theorems + all contained Axioms
//     sub.key_patterns    : dominant QuiverVertex / QuiverArrow distributions
//     sub.common_tasks    : boilerplate tasks derivable from pattern signature
//     sub.dependencies    : other SubsystemNavigators this one's APPLIES/
//                            ASSUMES/UNFOLDS chains cross into
//     sub.api_surface     : Theorems with export-like signatures
//                            (referenced by >= 3 OTHER subsystems)
//
// To load (AFTER grothendieck_lean.cypher):
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/erdos_enrich.cypher
//
// This script is IDEMPOTENT — running twice just refreshes the seven
// fields against the current graph state.  Results are deterministic
// given a fixed SubsystemNavigator set.
//
// Pairs with:
//   grothendieck_lean.cypher   (produces the subsystems this script reads)
//   fastrp_config.cypher       (provides alpha_k ranking for field 4)
// =====================================================================

// -------------------------------------------------------------
// 0. Pre-flight: check that Grothendieck assigned subsystem_id.
//    Abort with a clear error if not.
// -------------------------------------------------------------
MATCH (n {namespace: 'OmegaTheoryV2'})
WHERE (n:Declaration OR n:Theorem OR n:Axiom)
  AND n.subsystem_id IS NOT NULL
WITH count(n) AS n_with_subsystem
CALL apoc.util.validate(
  n_with_subsystem = 0,
  'erdos_enrich: no node has subsystem_id. Run grothendieck_lean.cypher first.',
  []
)
RETURN 'pre-flight OK: ' + toString(n_with_subsystem) + ' declarations carry subsystem_id' AS status;

// -------------------------------------------------------------
// 0A. Constraints + materialization of SubsystemNavigator nodes.
//
//    Grothendieck writes `subsystem_id` (integer) onto Declaration /
//    Theorem / Axiom nodes but does NOT create the navigator nodes
//    themselves. We do that here: one SubsystemNavigator per distinct
//    subsystem_id, connected to every member via CONTAINS, and hung
//    off the existing NavigationMaster via HAS_SUBSYSTEM.
//
//    We also give each subsystem a default name `Subsystem_<id>`.
//    A Python follow-up can rename subsystems based on dominant
//    file-path prefixes (e.g. "Subsystem_12" -> "Geometry") — see
//    TODO[EG-PY-001] at the foot of this file.
// -------------------------------------------------------------
CREATE CONSTRAINT omega_subsystem_nav_unique IF NOT EXISTS
  FOR (n:SubsystemNavigator)
  REQUIRE (n.namespace, n.subsystem_id) IS UNIQUE;

// Collect distinct subsystem_ids and materialize one navigator per id.
MATCH (n {namespace: 'OmegaTheoryV2'})
WHERE (n:Declaration OR n:Theorem OR n:Axiom)
  AND n.subsystem_id IS NOT NULL
WITH DISTINCT n.subsystem_id AS sid
MERGE (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2', subsystem_id: sid})
ON CREATE SET sub.name          = 'Subsystem_' + toString(sid),
              sub.created_by    = 'erdos_enrich',
              sub.created_at    = datetime()
RETURN count(sub) AS subsystems_materialized;

// Wire NavigationMaster -[:HAS_SUBSYSTEM]-> SubsystemNavigator.
MATCH (nav:NavigationMaster {namespace: 'OmegaTheoryV2'})
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
MERGE (nav)-[:HAS_SUBSYSTEM {namespace: 'OmegaTheoryV2'}]->(sub);

// Wire SubsystemNavigator -[:CONTAINS]-> every member declaration.
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
MATCH (m {namespace: 'OmegaTheoryV2'})
WHERE (m:Declaration OR m:Theorem OR m:Axiom)
  AND m.subsystem_id = sub.subsystem_id
MERGE (sub)-[:CONTAINS {namespace: 'OmegaTheoryV2'}]->(m);

// Sanity check: every subsystem has >= 1 member.
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
OPTIONAL MATCH (sub)-[:CONTAINS]->(m)
WITH sub, count(m) AS n_members
WHERE n_members = 0
WITH count(sub) AS n_empty
CALL apoc.util.validate(
  n_empty > 0,
  'erdos_enrich: ' + toString(n_empty) + ' SubsystemNavigator have 0 CONTAINS edges.',
  []
)
RETURN 'pre-flight + materialization OK' AS status;

// -------------------------------------------------------------
// 1. Field 1: ai_instructions
//
//    A short brief built from the subsystem's signature:
//      * shape (entity-type distribution)
//      * top-3 declared files
//      * headline relation types present
//
//    The result is a single string — human-readable, but assembled
//    from graph shape alone (no file reads).
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})

// Entity-type distribution for this subsystem.
OPTIONAL MATCH (sub)-[:CONTAINS]->(member)
WITH sub, labels(member)[0] AS entity_type, count(member) AS freq
WITH sub, collect({type: entity_type, freq: freq}) AS dist
// Top-3 files by declaration count.
OPTIONAL MATCH (sub)-[:CONTAINS]->(d)<-[:DECLARES]-(f:LeanFile)
WITH sub, dist, f.path AS file_path, count(d) AS n_decl
ORDER BY n_decl DESC
WITH sub, dist, collect({path: file_path, n: n_decl})[..3] AS top_files
SET sub.ai_instructions =
  'Lean subsystem "' + coalesce(sub.name, '<unnamed>') + '". ' +
  'Composition: ' +
  apoc.text.join(
    [d IN dist WHERE d.type IS NOT NULL |
     toString(d.freq) + ' ' + d.type + (CASE WHEN d.freq > 1 THEN 's' ELSE '' END)],
    ', ') +
  '. Primary files: ' +
  apoc.text.join([t IN top_files | t.path + ' (' + toString(t.n) + ')'], ', ') +
  '. To navigate: query members via CONTAINS, trace dependencies via APPLIES / ' +
  'ASSUMES / UNFOLDS, read sub.entry_points for the best starting theorems.';

// -------------------------------------------------------------
// 2. Field 2: query_hints
//
//    Pre-baked Cypher the consumer agent can run with no thinking.
//    Four canonical queries per subsystem.
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
SET sub.query_hints =
  '--- list members ---' + '\n' +
  'MATCH (s:SubsystemNavigator {name: "' + sub.name + '"})-[:CONTAINS]->(m) ' +
  'RETURN labels(m)[0] AS label, m.name AS name;' + '\n\n' +
  '--- find top theorems by out-degree ---' + '\n' +
  'MATCH (s:SubsystemNavigator {name: "' + sub.name + '"})-[:CONTAINS]->(t:Theorem) ' +
  'WITH t, size((t)-[:APPLIES|ASSUMES|UNFOLDS]->()) AS od ' +
  'RETURN t.name, od ORDER BY od DESC LIMIT 10;' + '\n\n' +
  '--- cross-subsystem dependencies ---' + '\n' +
  'MATCH (s:SubsystemNavigator {name: "' + sub.name + '"})-[:CONTAINS]->(m)-' +
  '[r:APPLIES|ASSUMES|UNFOLDS]->(m2)<-[:CONTAINS]-(s2:SubsystemNavigator) ' +
  'WHERE s2 <> s ' +
  'RETURN s2.name AS depends_on, type(r) AS via, count(*) AS edges ' +
  'ORDER BY edges DESC;' + '\n\n' +
  '--- rho_0 nearest neighbours (O(1) retrieval via vector index) ---' + '\n' +
  'MATCH (s:SubsystemNavigator {name: "' + sub.name + '"})-[:CONTAINS]->(seed:Theorem) ' +
  'WITH seed LIMIT 1 ' +
  'CALL db.index.vector.queryNodes("lean_retriever_embedding_theorem", 10, seed.embedding_lean) ' +
  'YIELD node, score RETURN node.name, score;';

// -------------------------------------------------------------
// 3. Field 3: entry_points
//
//    Best starting points = top-5 Theorems by combined out-degree
//    (APPLIES + UNFOLDS) + ALL contained Axioms (they're always
//    "interesting" since there are so few).
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})

// Top theorems by out-degree = "most-used, therefore most-entrant".
OPTIONAL MATCH (sub)-[:CONTAINS]->(t:Theorem)
WITH sub, t, size((t)-[:APPLIES|UNFOLDS|ASSUMES]->()) AS od
ORDER BY od DESC
WITH sub, collect({name: t.name, od: od})[..5] AS top_theorems

// All contained axioms.
OPTIONAL MATCH (sub)-[:CONTAINS]->(a:Axiom)
WITH sub, top_theorems, collect({name: a.name}) AS axioms
SET sub.entry_points =
  CASE WHEN size(top_theorems) + size(axioms) = 0
       THEN '<no theorems or axioms contained>'
       ELSE
         '--- axioms (prioritized) ---\n' +
         apoc.text.join([a IN axioms | a.name], ', ') +
         CASE WHEN size(axioms) = 0 THEN '<none>' ELSE '' END +
         '\n--- top 5 theorems by out-degree ---\n' +
         apoc.text.join(
           [tt IN top_theorems | tt.name + ' (out-degree=' + toString(tt.od) + ')'],
           ', ')
  END;

// -------------------------------------------------------------
// 4. Field 4: key_patterns
//
//    Dominant shape fingerprint:
//      * top-3 QuiverArrow categories by frequency within the subsystem
//      * vertex-type mix (axiom-heavy, theorem-heavy, structure-heavy)
//      * alpha_k ranking for the top-3 contributing relations
//        (pulled from NavigationMaster)
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})

// Relationship-type histogram for edges that begin inside this subsystem.
OPTIONAL MATCH (sub)-[:CONTAINS]->(src)-[r]->(dst)
WITH sub, type(r) AS rtype, count(r) AS freq
ORDER BY freq DESC
WITH sub, collect({rtype: rtype, freq: freq})[..3] AS top_rels

// Vertex-type mix.
OPTIONAL MATCH (sub)-[:CONTAINS]->(m)
WITH sub, top_rels, labels(m)[0] AS vtype, count(m) AS n
ORDER BY n DESC
WITH sub, top_rels, collect({vtype: vtype, n: n}) AS vmix

// Alpha_k ranking (top-3) from NavigationMaster — independent of subsystem,
// but useful as a global bias indicator agents can compare their subsystem against.
MATCH (nav:NavigationMaster {namespace: 'OmegaTheoryV2'})
WITH sub, top_rels, vmix,
     [
       {r:'IMPORTS',         a: nav.alpha_IMPORTS},
       {r:'OPENS_NAMESPACE', a: nav.alpha_OPENS_NAMESPACE},
       {r:'EXTENDS',         a: nav.alpha_EXTENDS},
       {r:'INSTANTIATES',    a: nav.alpha_INSTANTIATES},
       {r:'ASSUMES',         a: nav.alpha_ASSUMES},
       {r:'APPLIES',         a: nav.alpha_APPLIES},
       {r:'UNFOLDS',         a: nav.alpha_UNFOLDS},
       {r:'SPECIALIZES',     a: nav.alpha_SPECIALIZES},
       {r:'REWRITES_BY',     a: nav.alpha_REWRITES_BY},
       {r:'HAS_TYPE',        a: nav.alpha_HAS_TYPE},
       {r:'CONSTRAINED_BY',  a: nav.alpha_CONSTRAINED_BY},
       {r:'PARAMETRIZES',    a: nav.alpha_PARAMETRIZES},
       {r:'REDUCES_TO',      a: nav.alpha_REDUCES_TO},
       {r:'ELABORATES_AS',   a: nav.alpha_ELABORATES_AS},
       {r:'SUGGESTED_BY',    a: nav.alpha_SUGGESTED_BY}
     ] AS all_alphas
UNWIND all_alphas AS alpha_row
WITH sub, top_rels, vmix, alpha_row
WHERE alpha_row.a IS NOT NULL
WITH sub, top_rels, vmix, alpha_row
ORDER BY alpha_row.a DESC
WITH sub, top_rels, vmix, collect(alpha_row)[..3] AS top_alphas
SET sub.key_patterns =
  'Arrow distribution: ' +
  apoc.text.join(
    [rel IN top_rels WHERE rel.rtype IS NOT NULL |
     rel.rtype + '=' + toString(rel.freq)],
    ', ') +
  '. Vertex mix: ' +
  apoc.text.join(
    [v IN vmix WHERE v.vtype IS NOT NULL |
     v.vtype + '=' + toString(v.n)],
    ', ') +
  '. Global top-3 alpha_k (Grothendieck mean-shift): ' +
  apoc.text.join(
    [a IN top_alphas |
     a.r + '=' + toString(round(a.a * 10000) / 10000.0)],
    ', ') + '.';

// -------------------------------------------------------------
// 5. Field 5: common_tasks
//
//    Canned task list derived from the pattern signature
//    (if vertex mix has many axioms -> "eliminate axiom N", etc.).
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
OPTIONAL MATCH (sub)-[:CONTAINS]->(a:Axiom)
WITH sub, count(a) AS n_axioms
OPTIONAL MATCH (sub)-[:CONTAINS]->(t:Theorem)
WITH sub, n_axioms, count(t) AS n_theorems
OPTIONAL MATCH (sub)-[:CONTAINS]->(s:Structure)
WITH sub, n_axioms, n_theorems, count(s) AS n_structures
OPTIONAL MATCH (sub)-[:CONTAINS]->(i:Instance)
WITH sub, n_axioms, n_theorems, n_structures, count(i) AS n_instances
WITH sub, n_axioms, n_theorems, n_structures, n_instances,
  (CASE WHEN n_axioms > 0
        THEN ['Try to derive any of the ' + toString(n_axioms) +
              ' axioms from other subsystems (axiom elimination).']
        ELSE [] END) +
  (CASE WHEN n_theorems >= 20
        THEN ['Run premise selection (db.index.vector.queryNodes) within this subsystem before hitting Mathlib.']
        ELSE [] END) +
  (CASE WHEN n_structures > 0
        THEN ['Inspect Structure EXTENDS DAG — add missing instances, check for dead typeclasses.']
        ELSE [] END) +
  (CASE WHEN n_instances > 0
        THEN ['Verify Instance INSTANTIATES parents are unique (selection rule #3).']
        ELSE [] END) +
  ['Grep for sorry / axiom in files under sub.entry_points.',
   'Check out-degree of top theorems to find retrieval hubs.',
   'Look for cross-subsystem APPLIES chains — they are refactor candidates.']
  AS tasks
SET sub.common_tasks = apoc.text.join(tasks, '\n- ');

// -------------------------------------------------------------
// 6. Field 6: dependencies
//
//    Other SubsystemNavigators this subsystem's members cross-edge into
//    via APPLIES / ASSUMES / UNFOLDS / REWRITES_BY / CONSTRAINED_BY.
//    Edge-count-weighted.
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})

OPTIONAL MATCH (sub)-[:CONTAINS]->(m)
         -[r:APPLIES|ASSUMES|UNFOLDS|REWRITES_BY|CONSTRAINED_BY]->
         (m2)<-[:CONTAINS]-(other:SubsystemNavigator)
WHERE other <> sub
  AND other.namespace = 'OmegaTheoryV2'
WITH sub, other, type(r) AS via, count(*) AS edges
ORDER BY edges DESC
WITH sub, collect({name: other.name, via: via, edges: edges})[..10] AS deps
SET sub.dependencies =
  CASE WHEN size(deps) = 0
       THEN '<no outbound cross-subsystem dependencies>'
       ELSE
         apoc.text.join(
           [d IN deps |
            d.name + ' (via ' + d.via + ', ' + toString(d.edges) + ' edges)'],
           '; ')
  END;

// -------------------------------------------------------------
// 7. Field 7: api_surface
//
//    Theorems (and Axioms) inside this subsystem that are referenced
//    by members of >= 3 OTHER subsystems. These are the subsystem's
//    public "export" surface.
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})

OPTIONAL MATCH (sub)-[:CONTAINS]->(m)
WHERE m:Theorem OR m:Axiom
// Count DISTINCT external subsystems that reference m.
OPTIONAL MATCH (external)-[:APPLIES|ASSUMES|UNFOLDS|REWRITES_BY|CONSTRAINED_BY]->(m)
              <-[:CONTAINS]-(external_sub:SubsystemNavigator)
WHERE external_sub <> sub
  AND external_sub.namespace = 'OmegaTheoryV2'
WITH sub, m, count(DISTINCT external_sub) AS external_refs
WHERE external_refs >= 3
WITH sub, m, external_refs
ORDER BY external_refs DESC
WITH sub, collect({name: m.name, label: labels(m)[0], refs: external_refs})[..15] AS surface
SET sub.api_surface =
  CASE WHEN size(surface) = 0
       THEN '<internal-only subsystem (no theorem referenced by >=3 external subsystems)>'
       ELSE
         apoc.text.join(
           [x IN surface |
            x.label + ':' + x.name + ' (used by ' + toString(x.refs) + ' subsystems)'],
           '; ')
  END;

// -------------------------------------------------------------
// 8. Timestamp + diagnostics
// -------------------------------------------------------------
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
SET sub.erdos_last_enrich = datetime('2026-04-18T23:05:00Z');

RETURN 'erdos_enrich complete.' AS status,
       count { (s:SubsystemNavigator {namespace: 'OmegaTheoryV2'}) } AS n_subsystems,
       count {
         (s:SubsystemNavigator {namespace: 'OmegaTheoryV2'})
         WHERE s.ai_instructions IS NOT NULL
           AND s.query_hints IS NOT NULL
           AND s.entry_points IS NOT NULL
           AND s.key_patterns IS NOT NULL
           AND s.common_tasks IS NOT NULL
           AND s.dependencies IS NOT NULL
           AND s.api_surface IS NOT NULL
       } AS fully_enriched;

// -------------------------------------------------------------
// TODOs (flagged for Python / downstream follow-up)
// -------------------------------------------------------------
// TODO[EG-PY-001]: Rename subsystems from "Subsystem_<id>" to physics-
//   themed labels by taking the dominant file-path prefix across
//   members (e.g. OmegaTheory/Geometry/* -> "Geometry"). Cypher cannot
//   easily compute mode-of-string; Python (Counter) closes it in 5 lines.
//
// TODO[EG-PY-002]: Expose `sub.ai_instructions` to Python templater so
//   it can be wrapped in the consumer agent's system-prompt. Current
//   generator is Cypher-inline, which makes complex templating awkward.
//
// TODO[EG-CY-001]: Re-run this script after every grothendieck_lean
//   re-run. Subsystem_id values may change under different random seeds;
//   SubsystemNavigator nodes are keyed by (namespace, subsystem_id) so
//   they will be materialized fresh, but OLD navigators with no members
//   become orphans. Need a periodic DETACH DELETE for empty navigators.
