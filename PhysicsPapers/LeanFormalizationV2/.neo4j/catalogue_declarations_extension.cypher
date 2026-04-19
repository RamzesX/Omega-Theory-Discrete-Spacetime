// =====================================================================
// catalogue_declarations_extension — add LeanDojo retriever embedding slot
//
// Namespace:   'OmegaTheory' / 'OmegaTheoryV2' (touches actual Declaration nodes)
// Depends on:  catalogue_declarations.cypher (Axiom / Theorem / Declaration nodes present)
//
// Purpose:
//   Companion to catalogue_declarations.cypher -- DOES NOT EDIT that file.
//   Adds `embedding_lean` vector property (initialized null) and
//   a native vector index so premise-selection can do sub-100ms kNN
//   over ~2.6K OmegaTheory theorems + Mathlib 4.29 (~250K) future rows.
//
// To load (AFTER catalogue_declarations.cypher):
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/catalogue_declarations_extension.cypher
//
// Populated later by:
//   catalogue_load_patch.py :: enrich_with_embedding(...)
//
// Embedder:
//   LeanDojo-Lean4-Retriever -- `kaiyuy/leandojo-lean4-retriever-byt5-small`
//   ByT5-small, 82M params, OPEN weights.  Substituted for Lean-Finder
//   (delta-lab-ai) because the latter turned out to be a hosted-only HF
//   Space with no downloadable checkpoint.
//
// Embedding dimension:
//   1472  -- verified from HF config.json (d_model = 1472).  ByT5-small
//           is a character-level T5 variant whose hidden size is wider
//           than the 768 of BERT-base encoders.
//   If the operational encoder is later swapped for another model with
//   a different dim, drop + recreate the three vector indexes:
//     DROP   INDEX lean_retriever_embedding_theorem     IF EXISTS;
//     DROP   INDEX lean_retriever_embedding_axiom       IF EXISTS;
//     DROP   INDEX lean_retriever_embedding_declaration IF EXISTS;
//   and change the three `vector.dimensions: 1472` lines below.
// =====================================================================

// -------------------------------------------------------------
// 1. Initialize embedding_lean property on existing Declaration nodes
//
//    Neo4j stores null properties as "property absent", so this set
//    is a no-op at the storage layer but documents intent.  It also
//    allows us to count nodes-without-embedding later:
//      MATCH (d:Declaration) WHERE d.embedding_lean IS NULL RETURN count(d)
//
//    NOTE: Declaration is a label we may or may not already use.  The
//    existing catalogue_declarations.cypher materializes Axiom / Theorem
//    nodes directly, so we target all three labels defensively.
// -------------------------------------------------------------

// Touch every Theorem in OmegaTheory(V2) so it gains the property slot.
MATCH (t:Theorem)
WHERE t.namespace IN ['OmegaTheory', 'OmegaTheoryV2']
  AND t.embedding_lean IS NULL
SET t.embedding_lean = null;

// Same for Axioms (needed for premise selection: axioms are often top-k results).
MATCH (a:Axiom)
WHERE a.namespace IN ['OmegaTheory', 'OmegaTheoryV2']
  AND a.embedding_lean IS NULL
SET a.embedding_lean = null;

// And for any generic Declaration nodes, if the catalogue loader ever emits them.
MATCH (d:Declaration)
WHERE d.namespace IN ['OmegaTheory', 'OmegaTheoryV2']
  AND d.embedding_lean IS NULL
SET d.embedding_lean = null;

// -------------------------------------------------------------
// 2. Native vector indexes (Neo4j 2025.x+ supports VECTOR<FLOAT32>)
//
//    We build THREE parallel indexes, one per label, because Neo4j 5/2025
//    vector indexes are per-label.  The loader patch (catalogue_load_patch.py)
//    writes to the appropriate label depending on the declaration_type
//    field of the scanned Lean entry.
//
//    Dimension 1472 matches LeanDojo-Lean4-Retriever (ByT5-small, d_model=1472).
//    Similarity: cosine (standard for normalized retrieval embeddings).
// -------------------------------------------------------------

CREATE VECTOR INDEX lean_retriever_embedding_theorem IF NOT EXISTS
  FOR (t:Theorem) ON (t.embedding_lean)
  OPTIONS {
    indexConfig: {
      `vector.dimensions`: 1472,
      `vector.similarity_function`: 'cosine'
    }
  };

CREATE VECTOR INDEX lean_retriever_embedding_axiom IF NOT EXISTS
  FOR (a:Axiom) ON (a.embedding_lean)
  OPTIONS {
    indexConfig: {
      `vector.dimensions`: 1472,
      `vector.similarity_function`: 'cosine'
    }
  };

CREATE VECTOR INDEX lean_retriever_embedding_declaration IF NOT EXISTS
  FOR (d:Declaration) ON (d.embedding_lean)
  OPTIONS {
    indexConfig: {
      `vector.dimensions`: 1472,
      `vector.similarity_function`: 'cosine'
    }
  };

// -------------------------------------------------------------
// 3. Embedding-audit view: how many declarations still need embedding?
//    (Left as a documented query; do not execute automatically.)
//
//    MATCH (n) WHERE n.namespace IN ['OmegaTheory', 'OmegaTheoryV2']
//      AND (n:Theorem OR n:Axiom OR n:Declaration)
//    RETURN
//      labels(n)[0] AS label,
//      count(CASE WHEN n.embedding_lean IS NULL THEN 1 END) AS pending,
//      count(CASE WHEN n.embedding_lean IS NOT NULL THEN 1 END) AS embedded
// -------------------------------------------------------------

// -------------------------------------------------------------
// 4. Diagnostics
// -------------------------------------------------------------
RETURN 'catalogue_declarations_extension complete (dim=1472, LeanDojo retriever).' AS status,
       count { (t:Theorem     {namespace: 'OmegaTheory'}) } AS theorems_omega,
       count { (t:Theorem     {namespace: 'OmegaTheoryV2'}) } AS theorems_omega_v2,
       count { (a:Axiom       {namespace: 'OmegaTheory'}) } AS axioms_omega,
       count { (a:Axiom       {namespace: 'OmegaTheoryV2'}) } AS axioms_omega_v2,
       count { (d:Declaration {namespace: 'OmegaTheory'}) } AS declarations_omega,
       count { (d:Declaration {namespace: 'OmegaTheoryV2'}) } AS declarations_omega_v2;
