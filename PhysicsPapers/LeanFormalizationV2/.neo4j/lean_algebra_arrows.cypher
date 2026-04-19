// =====================================================================
// LeanAlgebra arrows — 15 typed relationship generators + composition rules
//
// Namespace:   'LeanAlgebra'
// Depends on:  lean_algebra_ontology.cypher (6 QuiverVertex nodes)
//
// Seeds:
//   * 15 QuiverArrow nodes organized in 4 categories:
//       I.  Structural    : 4 arrows  (IMPORTS, OPENS_NAMESPACE, EXTENDS, INSTANTIATES)
//       II. Dependency    : 5 arrows  (ASSUMES, APPLIES, UNFOLDS, SPECIALIZES, REWRITES_BY)
//       III.Type-theoretic: 3 arrows  (HAS_TYPE, CONSTRAINED_BY, PARAMETRIZES)
//       IV. Computational : 3 arrows  (REDUCES_TO, ELABORATES_AS, SUGGESTED_BY)
//   * EDGE_OF wiring      : each arrow knows its source and target QuiverVertex
//   * QuiverComposition   : legal depth-2 compositions (analogue of V3's 43)
//
// To load (after ontology):
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/lean_algebra_arrows.cypher
//
// Pairs with:
//   lean_algebra_ontology.cypher     (vertices, Laplacian, selection rules)
//   catalogue_declarations_extension.cypher (embedding property + vector index)
// =====================================================================

// -------------------------------------------------------------
// 1. Uniqueness constraints
// -------------------------------------------------------------
CREATE CONSTRAINT lean_quiver_arrow_unique IF NOT EXISTS
  FOR (n:QuiverArrow)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT lean_quiver_composition_unique IF NOT EXISTS
  FOR (n:QuiverComposition)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

// -------------------------------------------------------------
// 2. The 15 QuiverArrow generators
//
// Each arrow records:
//   * name               : uppercase snake_case, also the cypher_edge_name
//   * category           : I (structural) | II (dependency) | III (type) | IV (computational)
//   * category_label     : human-readable category name
//   * source_type / target_type : QuiverVertex endpoints
//   * directed           : bool, always true for typed arrows
//   * description        : what the edge means in Lean semantics
//   * cypher_edge_name   : literal Neo4j relationship label used in the declaration graph
//   * lean_surface       : Lean syntax that induces this edge
//   * bidirectional_pair : null, OR name of the paired reverse arrow (for su(2) cycles)
//   * type_agnostic      : bool, true iff the arrow can connect any pair of QuiverVertex
// -------------------------------------------------------------

// -- Category I: Structural (4) ---------------------------------------
WITH [
  { name: 'IMPORTS',
    category: 'I',
    category_label: 'Structural',
    source_type: 'Namespace',
    target_type: 'Namespace',
    directed: true,
    description: 'Lean `import X.Y` -- Namespace A imports Namespace B, pulling all public declarations into scope.',
    cypher_edge_name: 'IMPORTS',
    lean_surface: 'import Mathlib.Algebra.Group.Basic',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'OPENS_NAMESPACE',
    category: 'I',
    category_label: 'Structural',
    source_type: 'Namespace',
    target_type: 'Namespace',
    directed: true,
    description: 'Lean `open X` -- makes B\'s declarations visible without prefix in A. Distinct from IMPORTS: scoping, not dependency.',
    cypher_edge_name: 'OPENS_NAMESPACE',
    lean_surface: 'open Mathlib.Topology',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'EXTENDS',
    category: 'I',
    category_label: 'Structural',
    source_type: 'Structure',
    target_type: 'Structure',
    directed: true,
    description: 'Structure inheritance. `structure A extends B` -- A inherits all fields from B. Must form a DAG (selection rule #4).',
    cypher_edge_name: 'EXTENDS',
    lean_surface: 'class CommGroup (G : Type*) extends Group G, CommMonoid G',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'INSTANTIATES',
    category: 'I',
    category_label: 'Structural',
    source_type: 'Instance',
    target_type: 'Structure',
    directed: true,
    description: 'Typeclass instance witness. `instance : Structure T := ...` -- unique parent Structure per Instance (selection rule #3).',
    cypher_edge_name: 'INSTANTIATES',
    lean_surface: 'instance : CommGroup Int := { ... }',
    bidirectional_pair: null,
    type_agnostic: false
  }
] AS arrows
UNWIND arrows AS a
MERGE (q:QuiverArrow {namespace: 'LeanAlgebra', name: a.name})
SET q.category           = a.category,
    q.category_label     = a.category_label,
    q.source_type        = a.source_type,
    q.target_type        = a.target_type,
    q.directed           = a.directed,
    q.description        = a.description,
    q.cypher_edge_name   = a.cypher_edge_name,
    q.lean_surface       = a.lean_surface,
    q.bidirectional_pair = a.bidirectional_pair,
    q.type_agnostic      = a.type_agnostic,
    q.last_updated       = datetime('2026-04-18T00:00:00Z');

// -- Category II: Dependency (5) --------------------------------------
WITH [
  { name: 'ASSUMES',
    category: 'II',
    category_label: 'Dependency',
    source_type: 'Theorem',
    target_type: 'Axiom',
    directed: true,
    description: 'Theorem invokes an Axiom in its proof. `theorem t := by exact axiom_name` -- the strongest possible dependency.',
    cypher_edge_name: 'ASSUMES',
    lean_surface: 'theorem t := by apply Real.pi_transcendental',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'APPLIES',
    category: 'II',
    category_label: 'Dependency',
    source_type: 'Theorem',
    target_type: 'Theorem',
    directed: true,
    description: 'Theorem uses another Theorem as a premise. `by apply prev_thm` / `by exact prev_thm`. The active hub edge of the algebra.',
    cypher_edge_name: 'APPLIES',
    lean_surface: 'by apply add_comm',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'UNFOLDS',
    category: 'II',
    category_label: 'Dependency',
    source_type: 'Theorem',
    target_type: 'Definition',
    directed: true,
    description: 'Theorem unfolds a Definition during elaboration. `unfold foo` / `simp only [foo]`. Bridges symbolic term and semantic content.',
    cypher_edge_name: 'UNFOLDS',
    lean_surface: 'by unfold computationalUncertainty',
    bidirectional_pair: 'REWRITES_BY',
    type_agnostic: false
  },
  { name: 'SPECIALIZES',
    category: 'II',
    category_label: 'Dependency',
    source_type: 'Theorem',
    target_type: 'Theorem',
    directed: true,
    description: 'Theorem is a restricted instance of another (generalization). A specializes B if A\'s type is beta-reducible to an instance of B\'s type.',
    cypher_edge_name: 'SPECIALIZES',
    lean_surface: '-- pi_pos is a special case of Real.pi_pos_of_gt_three',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'REWRITES_BY',
    category: 'II',
    category_label: 'Dependency',
    source_type: 'Theorem',
    target_type: 'Definition',
    directed: true,
    description: 'Rewrite tactic consumes a Definition\'s unfolding as an equation. `rw [foo]`. Dual of UNFOLDS at the tactic-use site.',
    cypher_edge_name: 'REWRITES_BY',
    lean_surface: 'by rw [Nat.succ_eq_add_one]',
    bidirectional_pair: 'UNFOLDS',
    type_agnostic: false
  }
] AS arrows
UNWIND arrows AS a
MERGE (q:QuiverArrow {namespace: 'LeanAlgebra', name: a.name})
SET q.category           = a.category,
    q.category_label     = a.category_label,
    q.source_type        = a.source_type,
    q.target_type        = a.target_type,
    q.directed           = a.directed,
    q.description        = a.description,
    q.cypher_edge_name   = a.cypher_edge_name,
    q.lean_surface       = a.lean_surface,
    q.bidirectional_pair = a.bidirectional_pair,
    q.type_agnostic      = a.type_agnostic,
    q.last_updated       = datetime('2026-04-18T00:00:00Z');

// -- Category III: Type-theoretic (3) ---------------------------------
WITH [
  { name: 'HAS_TYPE',
    category: 'III',
    category_label: 'TypeTheoretic',
    source_type: 'Definition',
    target_type: 'Definition',
    directed: true,
    description: 'Definition has another Definition as its declared type. `def f : Ty := ...` -- dependent-type backbone.',
    cypher_edge_name: 'HAS_TYPE',
    lean_surface: 'def psi : Wavefunction := ...',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'CONSTRAINED_BY',
    category: 'III',
    category_label: 'TypeTheoretic',
    source_type: 'Theorem',
    target_type: 'Structure',
    directed: true,
    description: 'Theorem\'s hypotheses include a Structure (typeclass) requirement. `theorem t [CommGroup G] (x : G) : ...`.',
    cypher_edge_name: 'CONSTRAINED_BY',
    lean_surface: 'theorem add_comm [CommGroup G] (x y : G) : x + y = y + x',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'PARAMETRIZES',
    category: 'III',
    category_label: 'TypeTheoretic',
    source_type: 'Structure',
    target_type: 'Definition',
    directed: true,
    description: 'Structure takes a Definition as a type parameter. `structure Group (G : Type*) ...` -- Definition (G) parameterizes the Structure.',
    cypher_edge_name: 'PARAMETRIZES',
    lean_surface: 'structure Group (G : Type*) where ...',
    bidirectional_pair: null,
    type_agnostic: false
  }
] AS arrows
UNWIND arrows AS a
MERGE (q:QuiverArrow {namespace: 'LeanAlgebra', name: a.name})
SET q.category           = a.category,
    q.category_label     = a.category_label,
    q.source_type        = a.source_type,
    q.target_type        = a.target_type,
    q.directed           = a.directed,
    q.description        = a.description,
    q.cypher_edge_name   = a.cypher_edge_name,
    q.lean_surface       = a.lean_surface,
    q.bidirectional_pair = a.bidirectional_pair,
    q.type_agnostic      = a.type_agnostic,
    q.last_updated       = datetime('2026-04-18T00:00:00Z');

// -- Category IV: Computational (3) -----------------------------------
WITH [
  { name: 'REDUCES_TO',
    category: 'IV',
    category_label: 'Computational',
    source_type: 'Theorem',
    target_type: 'Theorem',
    directed: true,
    description: 'Definitional equality / rfl-reducibility. `theorem a : X = Y := rfl` -- the kernel normal-form direction. Distinct from APPLIES (which invokes proof).',
    cypher_edge_name: 'REDUCES_TO',
    lean_surface: 'theorem foo_eq_bar : foo = bar := rfl',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'ELABORATES_AS',
    category: 'IV',
    category_label: 'Computational',
    source_type: 'Definition',
    target_type: 'Definition',
    directed: true,
    description: 'Elaborator-provided canonical form. notation / abbreviations / coercions. A elaborates to B when Lean\'s elaborator replaces A with B during type-checking.',
    cypher_edge_name: 'ELABORATES_AS',
    lean_surface: 'notation "pi" => Real.pi',
    bidirectional_pair: null,
    type_agnostic: false
  },
  { name: 'SUGGESTED_BY',
    category: 'IV',
    category_label: 'Computational',
    source_type: 'Theorem',
    target_type: 'Theorem',
    directed: true,
    description: 'Retrieval / hint edge. Theorem T is suggested as a premise for Goal T\' by exact? / hammer / graph-nearest-neighbour. Distinct from APPLIES (which is a realized proof step).',
    cypher_edge_name: 'SUGGESTED_BY',
    lean_surface: '-- populated by premise-selector output',
    bidirectional_pair: null,
    type_agnostic: false
  }
] AS arrows
UNWIND arrows AS a
MERGE (q:QuiverArrow {namespace: 'LeanAlgebra', name: a.name})
SET q.category           = a.category,
    q.category_label     = a.category_label,
    q.source_type        = a.source_type,
    q.target_type        = a.target_type,
    q.directed           = a.directed,
    q.description        = a.description,
    q.cypher_edge_name   = a.cypher_edge_name,
    q.lean_surface       = a.lean_surface,
    q.bidirectional_pair = a.bidirectional_pair,
    q.type_agnostic      = a.type_agnostic,
    q.last_updated       = datetime('2026-04-18T00:00:00Z');

// -------------------------------------------------------------
// 3. EDGE_OF wiring : QuiverArrow -[SOURCE|TARGET]-> QuiverVertex
//
// Makes the arrow-to-vertex incidence explicit as first-class
// graph edges (so Cypher traversals can ask "all arrows into Theorem").
// -------------------------------------------------------------
MATCH (a:QuiverArrow  {namespace: 'LeanAlgebra'})
MATCH (s:QuiverVertex {namespace: 'LeanAlgebra', name: a.source_type})
MERGE (a)-[:SOURCE {namespace: 'LeanAlgebra'}]->(s);

MATCH (a:QuiverArrow  {namespace: 'LeanAlgebra'})
MATCH (t:QuiverVertex {namespace: 'LeanAlgebra', name: a.target_type})
MERGE (a)-[:TARGET {namespace: 'LeanAlgebra'}]->(t);

// -------------------------------------------------------------
// 4. Legal depth-2 compositions (QuiverComposition)
//
// A depth-2 composition R2 o R1 is legal iff target(R1) = source(R2).
// Below we seed the compositions most heavily used by agents / retrieval:
// not an exhaustive enumeration (analogous to V3's 43) -- downstream
// scripts (e.g. measure_non_commutativity.py) may materialize the rest.
//
// Name convention: "R1_then_R2" reading left-to-right along the Lean term.
// -------------------------------------------------------------
WITH [
  // Canonical proof shape : UNFOLDS then APPLIES (rewrite + invoke)
  { name: 'UNFOLDS_then_APPLIES',
    depth: 2,
    first: 'UNFOLDS',
    second: 'APPLIES',
    source_type: 'Theorem',
    target_type: 'Theorem',
    description: 'Unfold a Definition, then apply a Theorem to the resulting form. Classic `unfold foo; apply bar` cadence.',
    commutes_with_reverse: false
  },
  // Typeclass-driven proof : CONSTRAINED_BY then APPLIES (class instance pull)
  { name: 'CONSTRAINED_BY_then_APPLIES',
    depth: 2,
    first: 'CONSTRAINED_BY',
    second: 'APPLIES',
    source_type: 'Theorem',
    target_type: 'Theorem',
    description: 'Pull in a Structure (typeclass) and then apply a generic Theorem over that Structure.',
    commutes_with_reverse: false
  },
  // Axiom-reducing proof : APPLIES then ASSUMES (reduce to axiom)
  { name: 'APPLIES_then_ASSUMES',
    depth: 2,
    first: 'APPLIES',
    second: 'ASSUMES',
    source_type: 'Theorem',
    target_type: 'Axiom',
    description: 'Proof chain terminating on an Axiom. Critical for tracing every Theorem back to its axiomatic roots.',
    commutes_with_reverse: false
  },
  // Specialization : SPECIALIZES then APPLIES
  { name: 'SPECIALIZES_then_APPLIES',
    depth: 2,
    first: 'SPECIALIZES',
    second: 'APPLIES',
    source_type: 'Theorem',
    target_type: 'Theorem',
    description: 'Specialize a generic Theorem, then apply the specialization to the goal.',
    commutes_with_reverse: false
  },
  // Bidirectional-cycle pair #1 : UNFOLDS then REWRITES_BY (the su(2) Cartan candidate)
  { name: 'UNFOLDS_then_REWRITES_BY',
    depth: 2,
    first: 'UNFOLDS',
    second: 'REWRITES_BY',
    source_type: 'Theorem',
    target_type: 'Definition',
    description: 'Unfold a Definition and rewrite back by a related Definition. Candidate for an su(2)_{UnfoldRewrite} factor -- to verify empirically (Phase 0.4).',
    commutes_with_reverse: false
  },
  // Bidirectional-cycle pair #2 : SPECIALIZES reverse (generalization)
  { name: 'SPECIALIZES_commutator_probe',
    depth: 2,
    first: 'SPECIALIZES',
    second: 'SPECIALIZES',
    source_type: 'Theorem',
    target_type: 'Theorem',
    description: 'Probe for an su(2)_{SpecializeGeneralize} factor: measure [SPECIALIZES, GENERALIZES] where GENERALIZES = SPECIALIZES^T. Run measure_non_commutativity.py post-ingestion.',
    commutes_with_reverse: true
  },
  // Inheritance chain : EXTENDS then CONSTRAINED_BY
  { name: 'EXTENDS_then_CONSTRAINED_BY',
    depth: 2,
    first: 'EXTENDS',
    second: 'CONSTRAINED_BY',
    source_type: 'Structure',
    target_type: 'Theorem',
    description: 'A Structure extends another; a Theorem constrained by the child is implicitly constrained by the parent. Lifts hypothesis along the EXTENDS DAG.',
    commutes_with_reverse: false
  },
  // Import-open chain : IMPORTS then OPENS_NAMESPACE
  { name: 'IMPORTS_then_OPENS_NAMESPACE',
    depth: 2,
    first: 'IMPORTS',
    second: 'OPENS_NAMESPACE',
    source_type: 'Namespace',
    target_type: 'Namespace',
    description: 'Canonical Lean header: `import X` then `open X`. Encodes the physical-then-scoping pattern.',
    commutes_with_reverse: false
  },
  // Parametrization : PARAMETRIZES then INSTANTIATES
  { name: 'PARAMETRIZES_then_INSTANTIATES',
    depth: 2,
    first: 'PARAMETRIZES',
    second: 'INSTANTIATES',
    source_type: 'Structure',
    target_type: 'Structure',
    description: 'Structure is parameterized by a Definition; an Instance then fills that parameter. Triangulates three vertex types in one chain.',
    commutes_with_reverse: false
  },
  // Retrieval-to-application path : SUGGESTED_BY then APPLIES
  { name: 'SUGGESTED_BY_then_APPLIES',
    depth: 2,
    first: 'SUGGESTED_BY',
    second: 'APPLIES',
    source_type: 'Theorem',
    target_type: 'Theorem',
    description: 'Retrieval pipeline: a candidate is SUGGESTED_BY the graph, then (if it closes the goal) becomes APPLIES. Core edge for measuring retrieval precision.',
    commutes_with_reverse: false
  },
  // Elaboration round-trip : HAS_TYPE then ELABORATES_AS
  { name: 'HAS_TYPE_then_ELABORATES_AS',
    depth: 2,
    first: 'HAS_TYPE',
    second: 'ELABORATES_AS',
    source_type: 'Definition',
    target_type: 'Definition',
    description: 'Follow the declared type, then the elaborator\'s normalization. Used to prune equivalent Definitions in retrieval.',
    commutes_with_reverse: false
  },
  // Reduction chain : REDUCES_TO then APPLIES
  { name: 'REDUCES_TO_then_APPLIES',
    depth: 2,
    first: 'REDUCES_TO',
    second: 'APPLIES',
    source_type: 'Theorem',
    target_type: 'Theorem',
    description: 'Theorem reduces definitionally to a simpler form; then apply the simpler form. Captures rfl-chains.',
    commutes_with_reverse: false
  }
] AS comps
UNWIND comps AS c
MERGE (comp:QuiverComposition {namespace: 'LeanAlgebra', name: c.name})
SET comp.depth                 = c.depth,
    comp.first                 = c.first,
    comp.second                = c.second,
    comp.source_type           = c.source_type,
    comp.target_type           = c.target_type,
    comp.description           = c.description,
    comp.commutes_with_reverse = c.commutes_with_reverse,
    comp.last_updated          = datetime('2026-04-18T00:00:00Z');

// Wire compositions to their constituent arrows
MATCH (comp:QuiverComposition {namespace: 'LeanAlgebra'})
MATCH (a1:QuiverArrow {namespace: 'LeanAlgebra', name: comp.first})
MATCH (a2:QuiverArrow {namespace: 'LeanAlgebra', name: comp.second})
MERGE (comp)-[:FIRST_ARROW  {namespace: 'LeanAlgebra'}]->(a1)
MERGE (comp)-[:SECOND_ARROW {namespace: 'LeanAlgebra'}]->(a2);

// -------------------------------------------------------------
// 5. Indexes
// -------------------------------------------------------------
CREATE INDEX lean_quiver_arrow_category IF NOT EXISTS
  FOR (n:QuiverArrow) ON (n.category);

CREATE INDEX lean_quiver_arrow_source_type IF NOT EXISTS
  FOR (n:QuiverArrow) ON (n.source_type);

CREATE INDEX lean_quiver_arrow_target_type IF NOT EXISTS
  FOR (n:QuiverArrow) ON (n.target_type);

CREATE INDEX lean_quiver_composition_depth IF NOT EXISTS
  FOR (n:QuiverComposition) ON (n.depth);

// -------------------------------------------------------------
// 6. Diagnostics
// -------------------------------------------------------------
RETURN 'LeanAlgebra arrows seed complete.' AS status,
       count { (a:QuiverArrow       {namespace: 'LeanAlgebra'}) } AS arrows,
       count { (c:QuiverComposition {namespace: 'LeanAlgebra'}) } AS compositions,
       count { (a:QuiverArrow {namespace: 'LeanAlgebra'})-[:SOURCE]->() } AS source_edges,
       count { (a:QuiverArrow {namespace: 'LeanAlgebra'})-[:TARGET]->() } AS target_edges;
