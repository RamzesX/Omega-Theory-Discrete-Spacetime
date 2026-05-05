// =====================================================================
// OmegaWizardLessons — NavigationMaster 3-Level Wizard-Lesson Knowledge Graph
//
// Replaces the 255-file .md memory corpus at
//   ~/.claude/projects/-mnt-c-Users-Norbert-IdeaProjects-chaos-shield/memory/
// with a Cypher-queryable lesson store. .md files become the audit log.
// The graph is the queryable index.
//
// Architecture (V3 NavigationMaster pattern, adapted for proof-wisdom):
//   Level 0: NavigationMaster {namespace:'OmegaWizardLessons'} — single root
//   Level 1: LessonClusterNavigator (10 seed clusters; Leiden-refined later)
//   Level 2: WizardLeaf — multi-label: :WizardLeaf:Lesson | :AntiPattern |
//                                       :MathlibFact | :ProofPattern |
//                                       :Incident | :FailureMode |
//                                       :DoctrineRule | :TopologyRecipe
//
// Bi-temporal validity (Graphiti / Zep / SSGM 2026 pattern):
//   Every leaf carries valid_at / invalid_at / created_at / expired_at.
//   Queries default to invalid_at IS NULL AND expired_at IS NULL.
//   Hard delete forbidden — set expired_at instead.
//
// Retrieval: structural Cypher (cluster + label + namespace filter) +
// FULLTEXT index on (summary, body) for keyword search. Vector embeddings
// are NOT used in this namespace per user directive 2026-05-02 — keeps the
// migration simple, the dedup deterministic, and the wisdom corpus
// human-auditable (no opaque cosine drift).
//
// To (re)load — IDEMPOTENT:
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/bootstrap_wizard_lessons.cypher
// =====================================================================

// ---------------------------------------------------------------------
// 0. CONSTRAINTS — namespace-aware uniqueness for every node kind
// ---------------------------------------------------------------------
//
// NavigationMaster / EntityNavigator / ConcreteImpl constraints already exist
// from bootstrap_omegatheory.cypher (namespace-agnostic). Re-declared with
// IF NOT EXISTS for safety on a fresh DB.

CREATE CONSTRAINT omega_nav_unique IF NOT EXISTS
  FOR (n:NavigationMaster)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT lesson_cluster_unique IF NOT EXISTS
  FOR (n:LessonClusterNavigator)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT wizard_leaf_unique IF NOT EXISTS
  FOR (n:WizardLeaf)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT wizard_provenance_unique IF NOT EXISTS
  FOR (n:Wizard)
  REQUIRE (n.namespace, n.star_name) IS UNIQUE;

// ---------------------------------------------------------------------
// 1. AUXILIARY RANGE INDEXES — INTENTIONALLY SKIPPED
// ---------------------------------------------------------------------
//
// Earlier draft created (kind, freshness, invalid_at, wave) range indexes.
// At expected corpus size <1000 leaves these are pure overhead — sequential
// scans are sub-second, label lookups already cover :Lesson/:AntiPattern
// filtering, and bi-temporal `invalid_at IS NULL` is fast on small sets.
// We use FULLTEXT (below) + label scans + unique constraints. That is all.

// ---------------------------------------------------------------------
// 2. FULLTEXT INDEX — keyword search across (summary, body, name)
// ---------------------------------------------------------------------
//
// Replaces vector retrieval (per user directive 2026-05-02). Fulltext gives
// us "Pottmeyer 3.4.7", "div_le_iff", "literal-false" lookups in sub-second
// without an embedding step. Combined with cluster + label filters, this
// covers all wizard Phase 0 retrieval needs.

CREATE FULLTEXT INDEX wizard_leaf_fulltext IF NOT EXISTS
  FOR (n:WizardLeaf) ON EACH [n.name, n.summary, n.body];

// ---------------------------------------------------------------------
// 3. NAVIGATION MASTER (Level 0) — single root for the namespace
// ---------------------------------------------------------------------

MERGE (nav:NavigationMaster {namespace: 'OmegaWizardLessons', name: 'WizardLessonsRoot'})
SET nav.ai_description =
      'OmegaWizardLessons — graph-native wizard knowledge corpus. Replaces the 255-file ' +
      '.md memory corpus with a queryable graph. Wizards read via Phase 0_GRAPH_READ ' +
      '(FIND_LESSONS_FOR_GOAL recipe), write via Phase 7_GRAPH_WRITE (PERSIST_LESSON). ' +
      'Bi-temporal: invalid_at IS NULL for current canon. Dedup runs weekly via sage Phase D.',
    nav.ai_entry_query =
      'CALL db.index.vector.queryNodes(\'wizard_lesson_embedding\', 20, $goal_embedding) ' +
      'YIELD node, score WHERE node.invalid_at IS NULL RETURN node.name, node.summary, score',
    nav.architecture_version = '1.0.0-2026-05-02',
    nav.cluster_count        = 10,
    nav.last_dedup_at        = datetime('2026-05-02T00:00:00Z'),
    nav.replaces             = '~/.claude/projects/-mnt-c-Users-Norbert-IdeaProjects-chaos-shield/memory/',
    nav.retrieval_mode       = 'fulltext+structural',
    nav.retrieval_note       = 'No vector embeddings in this namespace. Use wizard_leaf_fulltext + cluster + label filters.',
    nav.created_at           = datetime();

// ---------------------------------------------------------------------
// 4. LESSON CLUSTER NAVIGATORS (Level 1) — 10 seed clusters
// ---------------------------------------------------------------------
//
// Final names emerge from Leiden refinement after migration. These are seeds
// for K-means assignment in migrate_md_to_graph.py.

WITH [
  {name:'MathlibAPI', dominant_kind:'MathlibFact',
   ai_instruction:'API renames, signatures, missing modules in Mathlib v4.29.0. Consult when a tactic fails with unknown_identifier or signature mismatch.',
   query_hints:'MATCH (l:WizardLeaf:MathlibFact {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS $api_name RETURN l',
   examples:'div_le_iff -> div_le_iff_0; mul_div_cancel needs ne_zero; Mathlib.Data.Int.Basic removed'},
  {name:'LeanTactics', dominant_kind:'Lesson',
   ai_instruction:'Procedural tactics cascade: exact? -> aesop -> grind -> linarith -> ring -> manual. Consult when stuck on goal closure choice.',
   query_hints:'CALL db.index.vector.queryNodes(\'wizard_lesson_embedding\', 5, $goal_emb) YIELD node WHERE node.kind = \'Lesson\' RETURN node',
   examples:'simp [explicit args] beats bare simp on goldenRatio_sq; positivity for 0 < x; norm_cast push for nat-real bridges'},
  {name:'PolynomialLemmas', dominant_kind:'MathlibFact',
   ai_instruction:'Domain-specific Mathlib for univariate polynomials. Polynomial.taylor / mahlerMeasure / rootMultiplicity / coeff patterns.',
   query_hints:'MATCH (l:WizardLeaf {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS $polynomial_name RETURN l ORDER BY l.confidence_pct DESC',
   examples:'Polynomial.taylor for cubic Roth; mahlerMeasure_mul is EQUALITY (sharper than Pottmeyer stated); rootMultiplicity witness for ne-zero discharge'},
  {name:'MvPolynomial', dominant_kind:'MathlibFact',
   ai_instruction:'Multivariate polynomial Mathlib API. pderiv <-> derivative correspondence at m=1, multiIteratedPDeriv composition, Fin 1 isomorphism.',
   query_hints:'MATCH (l:WizardLeaf {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS \'MvPolynomial\' RETURN l',
   examples:'finSuccEquiv + mapAlgEquiv (isEmptyAlgEquiv) for Fin 1 -> Polynomial; Derivation.leibniz for pderiv induction; multiIteratedPDeriv_add via list-foldr'},
  {name:'AnalyticBounds', dominant_kind:'ProofPattern',
   ai_instruction:'Heart-tier analytical proofs. Pottmeyer ladder / Hindry-Silverman D.6.1 / Schmidt 1972 subspace. The genuine bottlenecks.',
   query_hints:'MATCH (l:WizardLeaf {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS $textbook RETURN l ORDER BY l.fire_success_count DESC',
   examples:'Pottmeyer 3.4.7 ultrametric via rootMultiplicity_add; Pottmeyer 3.4.3 univariate via div_le_iff_0; Mahler-height chain via mahlerMeasure_mul'},
  {name:'ProofComposition', dominant_kind:'DoctrineRule',
   ai_instruction:'Top-down composition strategy: 5-PHASE HYBRID, NAMED Props, truth-rank tier-99-first. Polya + Tao + Hindry-Silverman canon.',
   query_hints:'MATCH (l:WizardLeaf:DoctrineRule {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS \'composition\' RETURN l',
   examples:'5-PHASE HYBRID; Tier-99 sub-lemmas first; bundled-lemma-file pattern for ~22x throughput; cascade-bridge pivot on scope mismatch'},
  {name:'LiteralFalseAuditing', dominant_kind:'AntiPattern',
   ai_instruction:'Anti-pattern detection. P=1 / q.den->infinity / epsilon->infinity audit checklist. NEVER ship a NAMED Prop without verifying non-trivial witnesses exist.',
   query_hints:'MATCH (l:WizardLeaf:AntiPattern {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS \'literal-false\' RETURN l',
   examples:'P=1 escape (constant polynomial); q.den unbounded; epsilon->infinity vacuous; boundary-strict vs nonstrict trap'},
  {name:'BuildHygiene', dominant_kind:'Lesson',
   ai_instruction:'Tooling: ~/lean-v2 vs /mnt/c mirror, md5 check, lake build flags, wsl-vs-windows path conventions.',
   query_hints:'MATCH (l:WizardLeaf {namespace:\'OmegaWizardLessons\'}) WHERE l.body CONTAINS \'lake build\' OR l.body CONTAINS \'mirror\' RETURN l',
   examples:'~/lean-v2 is 115x faster than /mnt/c; md5sum mirror match before declaring done; lake build --log-level=error for noise reduction'},
  {name:'Doctrine', dominant_kind:'DoctrineRule',
   ai_instruction:'Meta-rules: NO STUBS, BUILD MATHLIB MACHINERY, parent v4.5 anti-anxiety, Anthropic auto-compact directive. Consult on EVERY fire start.',
   query_hints:'MATCH (l:WizardLeaf:DoctrineRule {namespace:\'OmegaWizardLessons\'}) WHERE l.confidence_pct >= 95 RETURN l',
   examples:'NO STUBS (no sorry, no Prop:=True, no :=trivial); BUILD MATHLIB MACHINERY when gap found; only A/B/C terminations; week-long single-thread permitted'},
  {name:'Topology', dominant_kind:'TopologyRecipe',
   ai_instruction:'Canned Cypher recipes for common wizard graph queries. Avoid re-deriving topology — execute by name.',
   query_hints:'MATCH (l:WizardLeaf:TopologyRecipe {namespace:\'OmegaWizardLessons\', name: $recipe_name}) RETURN l.cypher_template',
   examples:'FIND_TARGET_NEIGHBORHOOD; FIND_SIBLING_PROOFS; BUILD_PROOF_STEP_PREFIX_KNN; FIND_MATHLIB_GAP_ALTERNATIVES'}
] AS clusters

UNWIND clusters AS c
MATCH (nav:NavigationMaster {namespace: 'OmegaWizardLessons'})
MERGE (cluster:LessonClusterNavigator {namespace: 'OmegaWizardLessons', name: c.name})
SET cluster.dominant_kind   = c.dominant_kind,
    cluster.ai_instruction  = c.ai_instruction,
    cluster.query_hints     = c.query_hints,
    cluster.examples        = c.examples,
    cluster.member_count    = coalesce(cluster.member_count, 0),
    cluster.cluster_id      = c.name,
    cluster.created_at      = coalesce(cluster.created_at, datetime()),
    cluster.last_updated    = datetime()
MERGE (nav)-[:GUIDES]->(cluster);

// ---------------------------------------------------------------------
// 5. WIZARD PROVENANCE NODES — known star names so AUTHORED edges resolve
// ---------------------------------------------------------------------
//
// Wizards register themselves on first fire. Pre-seed the active stars from
// session_context_2026-05-02.md so existing .md files migrate cleanly.

WITH [
  'Schedar','Pherkad','Mira','Algol','Alnitak','Caph','Hadar','Mintaka','Procyon',
  'Tarazed','Phecda','Tania','Bellatrix','Denebola','Talitha','Capella','Saiph',
  'Mirfak','Sadalmelik','Mizar','Antares','Spica','Adhara','Wezen','Atria',
  'Alkaid','Acrux','Acrux-2','Caroli','Diphda','Markab','Achernar','Achird',
  'Algenib','Mimosa','Gacrux','Gacrux-2','Polaris','Vega','Sirius','Deneb',
  'Altair','Rigel','Betelgeuse','Pollux','Castor','Aldebaran','Arcturus',
  'Alnilam','Sadalsuud','Sadr','Mirzam','Alphard','Sadalmelik-2','Algorab',
  'Alphekka','Alpheratz','Almaaz','Naos','Sheratan'
] AS stars
UNWIND stars AS s
MERGE (w:Wizard {namespace: 'OmegaWizardLessons', star_name: s})
SET w.first_seen_at = coalesce(w.first_seen_at, datetime()),
    w.lesson_count  = coalesce(w.lesson_count, 0);

// ---------------------------------------------------------------------
// 6. RETURN STATUS
// ---------------------------------------------------------------------

CALL {
  MATCH (n {namespace: 'OmegaWizardLessons'})
  RETURN labels(n)[0] AS label, count(n) AS cnt
}
WITH collect({label: label, count: cnt}) AS counts
RETURN 'OmegaWizardLessons bootstrap complete.' AS status,
       counts AS node_counts;
