// =====================================================================
// OmegaWizardLessons — :TopologyRecipe seed nodes
//
// 14 canned Cypher queries that wizards execute by NAME instead of
// re-deriving topology from scratch. Each recipe is a reified query
// the wizard fetches via:
//
//   MATCH (r:WizardLeaf:TopologyRecipe {name: $recipe_name})
//   RETURN r.cypher_template, r.example_params, r.expected_columns
//
// Then substitutes parameters and runs via mcp__neo4j-math__read_neo4j_cypher.
//
// Wizards are allowed to MERGE new :TopologyRecipe nodes when they
// discover a useful canned query. Sage's Phase D dedup pass folds
// near-duplicate recipes (cosine > 0.92).
//
// To (re)load — IDEMPOTENT (after bootstrap_wizard_lessons.cypher):
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/wizard_lessons_recipes.cypher
// =====================================================================

WITH [

  // ---- RETRIEVAL recipes ----------------------------------------------

  {name: 'FIND_LESSONS_FOR_GOAL',
   intent: 'Phase 0 entry: top-K lessons by Lucene fulltext over (name, summary, body). Bi-temporal filter to current canon. Pass goal-derived keywords (e.g. "Pottmeyer 3.4.7", "div_le_iff", "literal-false") in $query.',
   category: 'RETRIEVAL',
   complexity: 'sub-second',
   cypher_template:
     'CALL db.index.fulltext.queryNodes(\'wizard_leaf_fulltext\', $query) ' +
     'YIELD node AS leaf, score ' +
     'WHERE leaf.invalid_at IS NULL AND leaf.expired_at IS NULL ' +
     '  AND leaf.namespace = \'OmegaWizardLessons\' ' +
     'WITH leaf, score ' +
     'OPTIONAL MATCH (leaf)<-[:CONTAINS]-(cluster:LessonClusterNavigator) ' +
     'OPTIONAL MATCH (leaf)-[:CITES]->(cited:WizardLeaf) WHERE cited.invalid_at IS NULL ' +
     'WITH leaf, score, cluster, collect(cited.name)[..3] AS top_cited ' +
     'RETURN leaf.name AS lesson, leaf.summary AS summary, leaf.kind AS kind, ' +
     '       leaf.confidence_pct AS confidence, leaf.fire_success_count AS fire_wins, ' +
     '       cluster.name AS cluster_name, top_cited, score ' +
     'ORDER BY score DESC LIMIT $k',
   example_params: '{"k": 10, "query": "Pottmeyer 3.4.7 ultrametric rootMultiplicity"}',
   expected_columns: 'lesson, summary, kind, confidence, fire_wins, cluster_name, top_cited, score'
  },

  {name: 'FIND_LESSONS_BY_CLUSTER',
   intent: 'Phase 0 alternative: enumerate all leaves in a known cluster (e.g. \'MathlibAPI\', \'AnalyticBounds\'). Use when goal topic is known but keyword unclear.',
   category: 'RETRIEVAL',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (cluster:LessonClusterNavigator {namespace:\'OmegaWizardLessons\', name: $cluster_name}) ' +
     '      -[:CONTAINS]->(leaf:WizardLeaf) ' +
     'WHERE leaf.invalid_at IS NULL AND leaf.expired_at IS NULL ' +
     'RETURN leaf.name AS lesson, leaf.summary, leaf.kind, ' +
     '       leaf.confidence_pct AS confidence, leaf.fire_success_count AS wins, ' +
     '       leaf.last_referenced_at AS last_ref ' +
     'ORDER BY leaf.confidence_pct DESC, leaf.fire_success_count DESC, ' +
     '         leaf.last_referenced_at DESC LIMIT $k',
   example_params: '{"cluster_name": "MathlibAPI", "k": 20}',
   expected_columns: 'lesson, summary, kind, confidence, wins, last_ref'
  },

  {name: 'FIND_TARGET_NEIGHBORHOOD',
   intent: 'Phase 0 neighborhood: 2-hop APPLIES/ASSUMES/USES neighborhood of a target theorem. Bridges to OmegaTheoryV2 namespace.',
   category: 'RETRIEVAL',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (t:Theorem {namespace: \'OmegaTheoryV2\', name: $target_name}) ' +
     'OPTIONAL MATCH (t)-[r:APPLIES|ASSUMES|UNFOLDS|USES_AXIOM|USES_THEOREM*1..2]->(neighbor) ' +
     'RETURN neighbor.name AS name, neighbor.signature AS sig, ' +
     '       labels(neighbor)[0] AS kind, length(r) AS hops ' +
     'ORDER BY hops, name LIMIT 30',
   example_params: '{"target_name": "T5_PottmeyerRothLemma_sigma_form"}',
   expected_columns: 'name, sig, kind, hops'
  },

  {name: 'FIND_SIBLING_PROOFS',
   intent: 'Given a target theorem, return kNN-similar theorems (proofs that close similar-shape goals) via theorem_embedding_proof index.',
   category: 'RETRIEVAL',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (t:Theorem {namespace: \'OmegaTheoryV2\', name: $target_name}) ' +
     'WHERE t.embedding_proof IS NOT NULL ' +
     'CALL db.index.vector.queryNodes(\'theorem_embedding_proof\', $k, t.embedding_proof) ' +
     'YIELD node AS sibling, score ' +
     'WHERE sibling <> t ' +
     'RETURN sibling.name AS name, sibling.signature AS sig, ' +
     '       sibling.namespace AS ns, score ' +
     'ORDER BY score DESC LIMIT $k',
   example_params: '{"target_name": "T5_PottmeyerLemma_3_4_3", "k": 10}',
   expected_columns: 'name, sig, ns, score'
  },

  {name: 'FIND_MATHLIB_GAP_ALTERNATIVES',
   intent: 'Given a missing-API symptom (substring of error or signature), list candidate Mathlib lemmas. Substring + kNN hybrid.',
   category: 'RETRIEVAL',
   complexity: 'second',
   cypher_template:
     'MATCH (m:Theorem {namespace: \'Mathlib\'}) ' +
     'WHERE m.signature CONTAINS $signature_fragment ' +
     '   OR m.name CONTAINS $name_fragment ' +
     'RETURN m.name AS name, m.signature AS sig, m.file AS file LIMIT 20',
   example_params: '{"signature_fragment": "div_le_iff", "name_fragment": "div_le"}',
   expected_columns: 'name, sig, file'
  },

  {name: 'BUILD_PROOF_STEP_PREFIX_KNN',
   intent: 'Given a partial tactic prefix, return top-K next-tactic continuations from the 343K-node :ProofStep corpus.',
   category: 'RETRIEVAL',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (ps:ProofStep) ' +
     'WHERE ps.tactic_prefix STARTS WITH $prefix ' +
     '  AND ps.namespace = $namespace ' +
     'WITH ps.tactic AS next_tactic, count(*) AS freq, collect(ps.parent_thm)[..3] AS examples ' +
     'RETURN next_tactic, freq, examples ' +
     'ORDER BY freq DESC LIMIT $k',
   example_params: '{"prefix": "rcases", "namespace": "OmegaTheoryV2", "k": 10}',
   expected_columns: 'next_tactic, freq, examples'
  },

  // ---- AUDIT recipes ---------------------------------------------------

  {name: 'AXIOM_AUDIT_FORK_DETECT',
   intent: 'Given a target theorem, list ASSUMES dependencies that escape Lean-core axioms (propext / Classical.choice / Quot.sound).',
   category: 'AUDIT',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (t:Theorem {namespace: \'OmegaTheoryV2\', name: $target_name}) ' +
     'MATCH (t)-[:ASSUMES|USES_AXIOM*1..6]->(ax:Axiom) ' +
     'WHERE NOT ax.name IN [\'propext\',\'Classical.choice\',\'Quot.sound\'] ' +
     'RETURN DISTINCT ax.name AS axiom, ax.namespace AS ns, ax.category AS cat ' +
     'ORDER BY ax.name',
   example_params: '{"target_name": "T5_PottmeyerRothLemma_sigma_form"}',
   expected_columns: 'axiom, ns, cat'
  },

  {name: 'FIND_KEYSTONE_NEIGHBORS',
   intent: 'Given a graph-articulation hub theorem, list its incident theorems (PageRank top-K + APPLIES neighbors).',
   category: 'AUDIT',
   complexity: 'second',
   cypher_template:
     'MATCH (hub:Theorem {namespace: \'OmegaTheoryV2\', name: $hub_name}) ' +
     'MATCH (hub)<-[r:APPLIES|USES_THEOREM]-(consumer:Theorem) ' +
     'RETURN consumer.name AS name, consumer.file AS file, type(r) AS via ' +
     'ORDER BY consumer.name LIMIT 50',
   example_params: '{"hub_name": "T5_PottmeyerLemma_3_4_3"}',
   expected_columns: 'name, file, via'
  },

  {name: 'LIST_AVAILABLE_NAMED_PROPS',
   intent: 'Given a NAMED Prop family prefix (e.g. T5_*), list ungeneralized variants ready for discharge.',
   category: 'AUDIT',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (d:Definition {namespace: \'OmegaTheoryV2\'}) ' +
     'WHERE d.name STARTS WITH $family_prefix AND d.kind = \'Prop\' ' +
     'OPTIONAL MATCH (consumer)-[:ASSUMES]->(d) ' +
     'RETURN d.name AS prop_name, d.signature AS sig, d.file AS file, ' +
     '       count(consumer) AS consumer_count ' +
     'ORDER BY consumer_count DESC, prop_name LIMIT 30',
   example_params: '{"family_prefix": "T5_PottmeyerRothLemma_sigma_form_"}',
   expected_columns: 'prop_name, sig, file, consumer_count'
  },

  // ---- MEMORY (wizard-lesson) recipes ---------------------------------

  {name: 'FIND_PRIOR_WAVES_ON_TARGET',
   intent: 'Project-memory recall: which wizards landed on a given target? Return their :ProofPattern + :Incident leaves.',
   category: 'MEMORY',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (l:WizardLeaf {namespace: \'OmegaWizardLessons\'}) ' +
     'WHERE l.body CONTAINS $target_name ' +
     '  AND l.kind IN [\'ProofPattern\',\'Incident\',\'FailureMode\'] ' +
     '  AND l.invalid_at IS NULL ' +
     'RETURN l.name AS lesson, l.kind AS kind, l.wizard AS wizard, ' +
     '       l.wave AS wave, l.summary AS summary, l.created_at AS landed_at ' +
     'ORDER BY l.created_at DESC LIMIT 20',
   example_params: '{"target_name": "T5_PottmeyerRothLemma_sigma_form"}',
   expected_columns: 'lesson, kind, wizard, wave, summary, landed_at'
  },

  {name: 'FIND_SIMILAR_HEARTS',
   intent: 'Given a Heart-tier obligation textbook + section (e.g. "Pottmeyer 3.4.7"), fetch prior :ProofPattern leaves from the AnalyticBounds cluster that close similar-shape goals.',
   category: 'MEMORY',
   complexity: 'sub-second',
   cypher_template:
     'CALL db.index.fulltext.queryNodes(\'wizard_leaf_fulltext\', $query) ' +
     'YIELD node AS leaf, score ' +
     'WHERE leaf:ProofPattern ' +
     '  AND leaf.namespace = \'OmegaWizardLessons\' ' +
     '  AND leaf.invalid_at IS NULL ' +
     'OPTIONAL MATCH (leaf)<-[:CONTAINS]-(cluster:LessonClusterNavigator) ' +
     'WHERE cluster.name IN [\'AnalyticBounds\', \'PolynomialLemmas\', \'MvPolynomial\', \'ProofComposition\'] ' +
     'RETURN leaf.name AS pattern, leaf.summary AS summary, leaf.body AS body, ' +
     '       leaf.fire_success_count AS wins, leaf.confidence_pct AS conf, ' +
     '       cluster.name AS cluster, score ' +
     'ORDER BY score DESC LIMIT $k',
   example_params: '{"query": "Pottmeyer rootMultiplicity ultrametric", "k": 5}',
   expected_columns: 'pattern, summary, body, wins, conf, cluster, score'
  },

  {name: 'LITERAL_FALSE_AUDIT_CHECKLIST',
   intent: 'Retrieve the LiteralFalseAuditing cluster\'s full audit checklist before declaring a NAMED Prop discharged.',
   category: 'MEMORY',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (cluster:LessonClusterNavigator {namespace:\'OmegaWizardLessons\', name:\'LiteralFalseAuditing\'}) ' +
     '      -[:CONTAINS]->(leaf:WizardLeaf) ' +
     'WHERE leaf.invalid_at IS NULL ' +
     'RETURN leaf.name AS check, leaf.summary AS rule, leaf.body AS detail ' +
     'ORDER BY leaf.confidence_pct DESC, leaf.fire_success_count DESC',
   example_params: '{}',
   expected_columns: 'check, rule, detail'
  },

  {name: 'SUPERSEDES_CHAIN',
   intent: 'Given a lesson, walk the :SUPERSEDES chain forward to the current canonical version.',
   category: 'MEMORY',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (start:WizardLeaf {namespace:\'OmegaWizardLessons\', name: $lesson_name}) ' +
     'OPTIONAL MATCH path = (start)<-[:SUPERSEDES*0..]-(current:WizardLeaf) ' +
     'WHERE current.invalid_at IS NULL ' +
     'RETURN current.name AS canonical, current.summary AS summary, ' +
     '       length(path) AS depth ' +
     'ORDER BY depth DESC LIMIT 1',
   example_params: '{"lesson_name": "feedback_lean4_div_le_iff_pre_4_29"}',
   expected_columns: 'canonical, summary, depth'
  },

  // ---- DOCTRINE recipes ------------------------------------------------

  {name: 'FETCH_ACTIVE_DOCTRINE',
   intent: 'Phase 0 must-read: high-confidence DoctrineRule leaves. NO STUBS, BUILD MATHLIB, parent v4.5, etc.',
   category: 'DOCTRINE',
   complexity: 'sub-second',
   cypher_template:
     'MATCH (l:WizardLeaf:DoctrineRule {namespace:\'OmegaWizardLessons\'}) ' +
     'WHERE l.invalid_at IS NULL AND l.confidence_pct >= 95 ' +
     'RETURN l.name AS rule, l.summary AS summary, l.body AS body ' +
     'ORDER BY l.confidence_pct DESC, l.last_referenced_at DESC',
   example_params: '{}',
   expected_columns: 'rule, summary, body'
  },

  // ---- MIGRATION recipes (orchestrator/sage) ---------------------------

  {name: 'FIND_DUPLICATE_LESSONS',
   intent: 'Sage Phase D: find candidate duplicates within same cluster + same kind by name-prefix similarity + body Jaccard. Returns pairs for SUPERSEDES decision.',
   category: 'MIGRATION',
   complexity: 'multi-second',
   cypher_template:
     'MATCH (a:WizardLeaf)<-[:CONTAINS]-(c:LessonClusterNavigator)-[:CONTAINS]->(b:WizardLeaf) ' +
     'WHERE a.namespace = \'OmegaWizardLessons\' AND b.namespace = \'OmegaWizardLessons\' ' +
     '  AND a.invalid_at IS NULL AND b.invalid_at IS NULL ' +
     '  AND elementId(a) < elementId(b) ' +
     '  AND a.kind = b.kind ' +
     '  AND ( ' +
     '    apoc.text.sorensenDiceSimilarity(a.summary, b.summary) > $name_threshold ' +
     '    OR apoc.text.sorensenDiceSimilarity(a.name, b.name) > $name_threshold ' +
     '  ) ' +
     'WITH a, b, ' +
     '     apoc.text.sorensenDiceSimilarity(a.summary, b.summary) AS summary_sim, ' +
     '     apoc.text.sorensenDiceSimilarity(a.name, b.name) AS name_sim ' +
     'RETURN a.name AS leaf_a, b.name AS leaf_b, ' +
     '       a.confidence_pct AS conf_a, b.confidence_pct AS conf_b, ' +
     '       a.fire_success_count AS wins_a, b.fire_success_count AS wins_b, ' +
     '       round(summary_sim*1000)/1000 AS summary_sim, ' +
     '       round(name_sim*1000)/1000 AS name_sim ' +
     'ORDER BY summary_sim DESC LIMIT $limit',
   example_params: '{"name_threshold": 0.7, "limit": 50}',
   expected_columns: 'leaf_a, leaf_b, conf_a, conf_b, wins_a, wins_b, summary_sim, name_sim'
  }

] AS recipes

UNWIND recipes AS r
MATCH (cluster:LessonClusterNavigator {namespace: 'OmegaWizardLessons', name: 'Topology'})
MERGE (recipe:WizardLeaf:TopologyRecipe {namespace: 'OmegaWizardLessons', name: r.name})
SET recipe.kind             = 'TopologyRecipe',
    recipe.intent           = r.intent,
    recipe.summary          = r.intent,
    recipe.body             = r.cypher_template,
    recipe.cypher_template  = r.cypher_template,
    recipe.example_params   = r.example_params,
    recipe.expected_columns = r.expected_columns,
    recipe.category         = r.category,
    recipe.complexity       = r.complexity,
    recipe.confidence_pct   = 95,
    recipe.fire_count       = coalesce(recipe.fire_count, 0),
    recipe.fire_success_count = coalesce(recipe.fire_success_count, 0),
    recipe.created_at       = coalesce(recipe.created_at, datetime()),
    recipe.last_referenced_at = datetime(),
    recipe.valid_at         = coalesce(recipe.valid_at, datetime()),
    recipe.invalid_at       = NULL,
    recipe.expired_at       = NULL,
    recipe.wizard           = 'OrchestratorBootstrap',
    recipe.wave             = 'BOOTSTRAP'
MERGE (cluster)-[:CONTAINS]->(recipe);

// Refresh cluster member_count for Topology
MATCH (c:LessonClusterNavigator {namespace:'OmegaWizardLessons', name:'Topology'})
OPTIONAL MATCH (c)-[:CONTAINS]->(leaf:WizardLeaf) WHERE leaf.invalid_at IS NULL
WITH c, count(leaf) AS cnt
SET c.member_count = cnt;

CALL {
  MATCH (r:WizardLeaf:TopologyRecipe {namespace:'OmegaWizardLessons'})
  WHERE r.invalid_at IS NULL
  RETURN count(r) AS recipe_count
}
RETURN 'TopologyRecipe seed complete.' AS status, recipe_count;
