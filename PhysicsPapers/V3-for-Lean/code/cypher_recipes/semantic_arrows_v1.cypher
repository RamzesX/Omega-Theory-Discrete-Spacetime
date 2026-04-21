// ============================================================================
// semantic_arrows_v1.cypher
//
// Author:    Sirius (grothendieck-sage)
// Date:      2026-04-19
// Recipe:    :GrothendieckRecipe { name: 'semantic_arrows_v1' }
// Script:    :MetaprogramScript { name: 'SemanticArrows_V1' }
// Namespace: OmegaTheoryV2
//
// MISSION
// -------
// Extract SPECIALIZES / GENERALIZES / REWRITES_BY arrows which the Lean
// elaboration environment does NOT expose (they are semantic relations,
// not definitional). Pure Cypher + GDS + APOC — no Python.
//
// METHOD
// ------
// (1) SPECIALIZES: gds.knn on Theorem.embedding_lean with cos >= 0.85,
//     require size(a.signature) > size(b.signature), tokenize b.signature
//     on [^A-Za-z0-9_]+ keep tokens size >= 4 minus stopwords, require
//     EVERY such token appear as substring of a.signature.
// (2) GENERALIZES: reverse of each SPECIALIZES edge.
// (3) REWRITES_BY: regex (rw|rewrite|simp|simp_rw|simp only|rw!|erw)\s*\[(.*?)\]
//     on proof_body, split on ',', strip arrow prefixes, resolve each
//     token to a Theorem by exact-name match.
//
// GROUND TRUTH CHECK
// ------------------
// Alphard Finding #8 (cross-corpus analogies from darkEnergyEquationOfState_w
// to Mathlib setIntegral_condVar / centralMoment_two_eq_variance) are
// correctly NOT caught as SPECIALIZES — they share 0 identifier tokens, so
// they are analogies, not specializations. This is the right separation.
//
// RESULTS (2026-04-19)
// --------------------
// SPECIALIZES semantic_v1     : 74
// GENERALIZES semantic_v1     : 74
// REWRITES_BY semantic_v1     : 2193 (1525 net new, 668 duplicate of prior unmethod edges)
// Overlap with APPLIES        : 46%  (paper_* aliases: both apply and specialize)
// ============================================================================


// ----------------------------------------------------------------------------
// STEP 0 — drop any prior candidate projection
// ----------------------------------------------------------------------------
CALL gds.graph.drop('semArrowKnn', false) YIELD graphName
RETURN graphName;


// ----------------------------------------------------------------------------
// STEP 1 — project OmegaTheoryV2 Theorems (nodes only, no edges yet)
// ----------------------------------------------------------------------------
CALL gds.graph.project.cypher(
  'semArrowKnn',
  'MATCH (t:Theorem {namespace: "OmegaTheoryV2"}) WHERE t.embedding_lean IS NOT NULL
   RETURN id(t) AS id, t.embedding_lean AS embedding_lean',
  'MATCH (a:Theorem {namespace: "OmegaTheoryV2"})-[r]->(b:Theorem {namespace: "OmegaTheoryV2"})
   RETURN id(a) AS source, id(b) AS target LIMIT 0'
)
YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount;


// ----------------------------------------------------------------------------
// STEP 2 — kNN, materialise candidates as :SEM_CANDIDATE{cosine}
// (concurrency limited to 4 for unlicensed GDS)
// ----------------------------------------------------------------------------
CALL gds.knn.write('semArrowKnn', {
  nodeProperties: ['embedding_lean'],
  topK: 20,
  similarityCutoff: 0.85,
  sampleRate: 0.8,
  deltaThreshold: 0.001,
  concurrency: 4,
  writeRelationshipType: 'SEM_CANDIDATE',
  writeProperty: 'cosine'
})
YIELD relationshipsWritten, nodesCompared
RETURN relationshipsWritten, nodesCompared;


// ----------------------------------------------------------------------------
// STEP 3 — SPECIALIZES via signature-token containment
// ----------------------------------------------------------------------------
MATCH (a:Theorem {namespace: 'OmegaTheoryV2'})-[r:SEM_CANDIDATE]->(b:Theorem {namespace: 'OmegaTheoryV2'})
WHERE a <> b AND size(a.signature) > size(b.signature)
WITH a, b, r.cosine AS sim,
     [w IN apoc.text.split(b.signature, '[^A-Za-z0-9_]+')
        WHERE size(w) >= 4
          AND NOT w IN ['theorem','def','lemma','Type','Prop','True','False',
                        'Nat','Int','Real','Fin','fun','let','where','with',
                        'forall','have','show','exact','apply','intro','rintro',
                        'rfl','simp','ring','this']
     ] AS ids_b
WHERE size(ids_b) >= 2
WITH a, b, sim, ids_b,
     [w IN ids_b WHERE a.signature CONTAINS w] AS matched
WHERE size(matched) = size(ids_b)
MERGE (a)-[s:SPECIALIZES {method: 'semantic_v1'}]->(b)
  ON CREATE SET s.confidence  = sim,
                s.token_count = size(ids_b),
                s.inferred_at = datetime(),
                s.inferred_by = 'Sirius'
  ON MATCH  SET s.confidence  = sim,
                s.last_seen   = datetime()
RETURN count(s) AS specializes_written;


// ----------------------------------------------------------------------------
// STEP 4 — GENERALIZES = reverse of SPECIALIZES semantic_v1
// ----------------------------------------------------------------------------
MATCH (a:Theorem)-[s:SPECIALIZES {method: 'semantic_v1'}]->(b:Theorem)
MERGE (b)-[g:GENERALIZES {method: 'semantic_v1'}]->(a)
  ON CREATE SET g.confidence  = s.confidence,
                g.token_count = s.token_count,
                g.inferred_at = datetime(),
                g.inferred_by = 'Sirius'
RETURN count(g) AS generalizes_written;


// ----------------------------------------------------------------------------
// STEP 5 — REWRITES_BY via proof_body regex extraction
// ----------------------------------------------------------------------------
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.proof_body IS NOT NULL
WITH t, apoc.text.regexGroups(t.proof_body,
        '(?:rw|rewrite|simp|simp_rw|simp only|rw!|erw)\\s*\\[([^\\]]*)\\]') AS groups
UNWIND groups AS grp
WITH t, grp[1] AS inner
UNWIND split(inner, ',') AS raw_name
WITH t, trim(raw_name) AS raw2
WITH t, replace(replace(replace(raw2, '←', ''), '<-', ''), '↑', '') AS cleaned
WITH t, trim(cleaned) AS cite
WHERE cite <> '' AND size(cite) >= 3
WITH DISTINCT t, cite
MATCH (b:Theorem {name: cite})
WHERE b <> t
MERGE (t)-[r:REWRITES_BY {method: 'semantic_v1'}]->(b)
  ON CREATE SET r.inferred_at = datetime(),
                r.inferred_by = 'Sirius',
                r.extraction  = 'proof_body_rw_simp_regex'
RETURN count(r) AS rewrites_by_written;


// ----------------------------------------------------------------------------
// STEP 6 — tear down candidate projection (optional; keep if you want to
// inspect SEM_CANDIDATE edges post-hoc)
// ----------------------------------------------------------------------------
// CALL gds.graph.drop('semArrowKnn', false) YIELD graphName RETURN graphName;
// MATCH ()-[r:SEM_CANDIDATE]->() DELETE r;


// ----------------------------------------------------------------------------
// VALIDATION QUERIES
// ----------------------------------------------------------------------------

// Top-10 SPECIALIZES pairs with cos > 0.9 (manual sanity)
// MATCH (a:Theorem)-[s:SPECIALIZES {method:'semantic_v1'}]->(b:Theorem)
// WHERE s.confidence > 0.9
// RETURN a.name, b.name, round(s.confidence*10000)/10000.0 AS cos, s.token_count
// ORDER BY s.confidence DESC LIMIT 10;

// Alphard Finding #8 ground-truth cross-check
// MATCH (a:Theorem {name:'darkEnergyEquationOfState_w'})
// CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', 20, a.embedding_lean)
// YIELD node, score
// WHERE node.namespace = 'Mathlib' AND score >= 0.75
// RETURN node.name, score;
// Expected: setIntegral_condVar @0.800, centralMoment_two_eq_variance @0.796 —
// these are NOT captured as SPECIALIZES (0 shared identifier tokens),
// correctly classified as cross-corpus analogies only.

// APPLIES vs SPECIALIZES overlap audit
// MATCH (a:Theorem)-[s:SPECIALIZES {method:'semantic_v1'}]->(b:Theorem)
// OPTIONAL MATCH (a)-[ap:APPLIES]->(b)
// RETURN count(s) AS total, count(ap) AS overlap;
// Expected: ~46% overlap (paper_* aliases apply AND specialize their core).
