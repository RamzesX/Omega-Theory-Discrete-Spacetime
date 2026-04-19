// =====================================================================
// LeanAlgebra — V3-for-Lean ontology seed
//
// Namespace:    'LeanAlgebra'  (schema / algebraic law — NOT 'OmegaTheory')
// Target graph: OmegaTheory V2 + Mathlib 4.29 declaration catalogue
// Source plan:  ~/.claude/plans/elegant-sauteeing-simon.md  (Phase 0)
// V3 template:  graph-theory-system-modeling/V3/HypatiaBasis.md
//
// Seeds:
//   * 6 QuiverVertex nodes     — Axiom / Theorem / Definition /
//                                Structure / Instance / Namespace
//   * 1 MagneticLaplacian node — 6x6 Hermitian spec, g = 1/4
//   * 7 SelectionRule nodes    — forbidden-block laws (axiom pure-source,
//                                namespace container, unique-parent instance,
//                                acyclic EXTENDS, reverse-causality,
//                                sink-instance-no-applies, ns-not-opening-thm)
//
// Prerequisites:
//   * Neo4j container `math` at bolt://localhost:7687 (user neo4j / omegatheory2026)
//   * bootstrap_omegatheory.cypher must have run (for namespace / constraint patterns)
//
// To load:
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/lean_algebra_ontology.cypher
//
// Order of execution (top-to-bottom, idempotent via MERGE):
//   1. Uniqueness constraints
//   2. 6 QuiverVertex nodes with height / role / v3_analogue
//   3. MagneticLaplacian node (matrix spec + g = 1/4 phase)
//   4. 7 SelectionRule nodes
//   5. Indexes for name / category lookups
//
// Pairs with:
//   lean_algebra_arrows.cypher     — 15 QuiverArrow edges + compositions
//   catalogue_declarations_extension.cypher — Declaration.embedding_lean + vector index
// =====================================================================

// -------------------------------------------------------------
// 1. Uniqueness constraints
// -------------------------------------------------------------
CREATE CONSTRAINT lean_quiver_vertex_unique IF NOT EXISTS
  FOR (n:QuiverVertex)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT lean_selection_rule_unique IF NOT EXISTS
  FOR (n:SelectionRule)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

CREATE CONSTRAINT lean_magnetic_laplacian_unique IF NOT EXISTS
  FOR (n:MagneticLaplacian)
  REQUIRE (n.namespace, n.name) IS UNIQUE;

// -------------------------------------------------------------
// 2. The 6 QuiverVertex nodes (Lean ontology)
//
// Preserves V3 R(3,3)=6 guarantee; pure-source/sink symmetry keeps
// spectral theorem on MagneticLaplacian nontrivial.
//
// Height reflects dependency depth (purely source at top of stack):
//     3 : Axiom      (pure source, no in-edges)
//     2 : Definition / Structure (semantic data / framework)
//     1 : Theorem    (active hub) / Instance (sink)
//     0 : Namespace  (environmental context)
// -------------------------------------------------------------
WITH [
  { name: 'Axiom',
    height: 3,
    role: 'pure_source',
    description: 'Pure source -- no in-edges, never reduced. Physical constants, research conjectures, Real.pi_transcendental.',
    v3_analogue: 'Actor (A)',
    lean_tokens: ['axiom', 'constant'],
    in_degree_rule: 'forbidden (no arrow INTO an Axiom)',
    out_degree_rule: 'consumed by Theorem via ASSUMES'
  },
  { name: 'Theorem',
    height: 1,
    role: 'active_hub',
    description: 'Active hub -- most in+out edges. theorem / lemma / @[simp] tagged facts. Can APPLY other Theorems, ASSUME Axioms, UNFOLD Definitions.',
    v3_analogue: 'Process (P)',
    lean_tokens: ['theorem', 'lemma', 'example', 'proposition'],
    in_degree_rule: 'from Theorem (APPLIES), Definition (UNFOLDS), Structure (CONSTRAINED_BY)',
    out_degree_rule: 'to Axiom (ASSUMES), Theorem (APPLIES), Definition (UNFOLDS)'
  },
  { name: 'Definition',
    height: 2,
    role: 'semantic_data',
    description: 'Semantic data -- def / abbrev / notation. Unfolded by Theorems, can PARAMETRIZE Structures, ELABORATES_AS computational form.',
    v3_analogue: 'Resource (R)',
    lean_tokens: ['def', 'abbrev', 'notation', 'variable'],
    in_degree_rule: 'from Theorem (UNFOLDS), Definition (HAS_TYPE), Structure (PARAMETRIZES)',
    out_degree_rule: 'to Definition (HAS_TYPE), Structure (INSTANTIATES)'
  },
  { name: 'Structure',
    height: 2,
    role: 'framework',
    description: 'Framework -- structure / class. EXTENDS other Structures (DAG), PARAMETRIZED by Definitions, INSTANTIATED by Instances.',
    v3_analogue: 'Rule (Ru)',
    lean_tokens: ['structure', 'class', 'inductive'],
    in_degree_rule: 'from Instance (INSTANTIATES), Theorem (CONSTRAINED_BY), Structure (EXTENDS)',
    out_degree_rule: 'to Structure (EXTENDS), Definition (PARAMETRIZES)'
  },
  { name: 'Instance',
    height: 1,
    role: 'pure_sink',
    description: 'Pure sink -- instance / @[instance]. Consumes Structure one-to-one. Never APPLIES Theorem (is consumed by typeclass resolution, not active).',
    v3_analogue: 'Event (E)',
    lean_tokens: ['instance', '@[instance]'],
    in_degree_rule: 'forbidden to APPLIES Theorem (pure sink semantics)',
    out_degree_rule: 'to Structure (INSTANTIATES) ONLY, unique-parent'
  },
  { name: 'Namespace',
    height: 0,
    role: 'environmental_context',
    description: 'Environmental context -- namespace / section / module / file. Container only; never APPLIES nor opens a Theorem as a scope.',
    v3_analogue: 'Context (C)',
    lean_tokens: ['namespace', 'section', 'end', 'import'],
    in_degree_rule: 'contained entities reference via OPENS_NAMESPACE',
    out_degree_rule: 'to other Namespace via OPENS_NAMESPACE ONLY (never APPLIES / ASSUMES)'
  }
] AS vertices
UNWIND vertices AS v
MERGE (q:QuiverVertex {namespace: 'LeanAlgebra', name: v.name})
SET q.height          = v.height,
    q.role            = v.role,
    q.description     = v.description,
    q.v3_analogue     = v.v3_analogue,
    q.lean_tokens     = v.lean_tokens,
    q.in_degree_rule  = v.in_degree_rule,
    q.out_degree_rule = v.out_degree_rule,
    q.last_updated    = datetime('2026-04-18T00:00:00Z');

// -------------------------------------------------------------
// 3. MagneticLaplacian (6x6 Hermitian, g = 1/4)
//
// Construction mirrors HypatiaAlgebra/V3 exactly:
//     W^(s)_XY = (B_XY + B_YX) / 2          (symmetrized weight)
//     D_XY     = sign(B_XY - B_YX)          (direction)
//     T^(g)_XY = exp(i * 2*pi * g * D_XY)   (phase, g = 1/4 => 90 deg)
//     Delta_XX = sum_Y W^(s)_XY             (degree)
//     A = Delta - T^(g) * W^(s)             (Hermitian, real spectrum)
//
// Row / column order for this matrix (used by downstream code):
//     [Axiom, Theorem, Definition, Structure, Instance, Namespace]
//
// Phase matrix at g = 1/4 uses 90 deg imaginary phases:
//     D = +1  -->  +i      D = -1  -->  -i      D = 0  -->  1
//
// B is the block-adjacency count of the 15 arrow generators
// (see lean_algebra_arrows.cypher) restricted to typed arrows.
// Forbidden blocks (from SelectionRule nodes) are zero entries.
// -------------------------------------------------------------
MERGE (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
SET laplacian.dimension               = 6,
    laplacian.hermitian               = true,
    laplacian.vertex_order             = ['Axiom', 'Theorem', 'Definition', 'Structure', 'Instance', 'Namespace'],
    laplacian.charge_parameter_g       = 0.25,
    laplacian.charge_rationale         = 'g = 1/4 gives 90-degree phase shift per DiGraphs MagNet (arXiv 2102.11391); optimal directedness signal on arrow-heavy DAGs',
    laplacian.symmetrization_formula   = 'W^(s)_XY = (B_XY + B_YX) / 2',
    laplacian.direction_formula        = 'D_XY = sign(B_XY - B_YX)',
    laplacian.phase_formula            = 'T^(g)_XY = exp(i * 2*pi * g * D_XY)',
    laplacian.degree_formula           = 'Delta_XX = sum_Y W^(s)_XY',
    laplacian.laplacian_formula        = 'A = Delta - T^(g) * W^(s)  (Hadamard product)',
    laplacian.hermiticity_proof        = 'W^(s) symmetric real; D antisymmetric => T^(g)_YX = conj(T^(g)_XY); Delta real diagonal; hence A* = A',
    laplacian.expected_real_spectrum   = true,
    laplacian.expected_eigenvectors    = 'complex, phase encodes flow direction per eigenstate',
    laplacian.reference                = 'V3 HypatiaBasis 7.1; Fanuel 2017 (PRE 95.2); Furutani 2020 (ECML PKDD)',
    laplacian.computed_at              = null,
    laplacian.last_updated             = datetime('2026-04-18T00:00:00Z');

// Link the MagneticLaplacian to every QuiverVertex via DEFINES_SPECTRUM_OF
WITH 1 AS dummy
MATCH (laplacian:MagneticLaplacian {namespace: 'LeanAlgebra', name: 'MagneticLaplacian_Lean'})
MATCH (q:QuiverVertex {namespace: 'LeanAlgebra'})
MERGE (laplacian)-[:DEFINES_SPECTRUM_OF {namespace: 'LeanAlgebra'}]->(q);

// -------------------------------------------------------------
// 4. Selection rules (forbidden-block laws)
//
// Each rule is a first-order forbidden pattern that enforces the
// algebra by construction: violating edges are rejected at ingestion.
// Numbering mirrors the order in which they appear in the plan.
// -------------------------------------------------------------
WITH [
  { name: 'axiom_is_pure_source',
    rank: 1,
    law: 'forall X, Axiom <- X = 0',
    description: 'No arrow may terminate on an Axiom. Axioms are taken as given; anything that depends on them appears as ASSUMES (Theorem -> Axiom), never the reverse.',
    forbids: 'ANY -> Axiom',
    rationale: 'Preserves R(3,3)=6 via pure-source guarantee; enables top-of-stack pivot for premise retrieval.',
    enforcement: 'HARD_BLOCK'
  },
  { name: 'namespace_is_container_only',
    rank: 2,
    law: 'Namespace -> {Theorem, Definition, Structure, Instance, Namespace}: only via OPENS_NAMESPACE',
    description: 'Namespace never APPLIES a Theorem and never ASSUMES an Axiom. It is a pure container; its relationships with contents are via CONTAINS (physical) or OPENS_NAMESPACE (logical import).',
    forbids: 'Namespace -APPLIES-> Theorem  /  Namespace -ASSUMES-> Axiom',
    rationale: 'Containers have no semantics of their own; they are addresses.',
    enforcement: 'HARD_BLOCK'
  },
  { name: 'instance_unique_parent',
    rank: 3,
    law: 'Instance -INSTANTIATES-> Structure, multiplicity = 1 (one Structure per Instance)',
    description: 'Each Instance has exactly one parent Structure. Multi-parent instances would break typeclass resolution invariants.',
    forbids: 'Instance -INSTANTIATES-> S1 AND Instance -INSTANTIATES-> S2 with S1 != S2',
    rationale: 'Mirrors Lean typeclass resolution: one instance declares one type-class witness.',
    enforcement: 'HARD_BLOCK'
  },
  { name: 'acyclic_extends_dag',
    rank: 4,
    law: 'Structure -EXTENDS-> Structure : DAG (no cycles)',
    description: 'The EXTENDS relation on Structures is a directed acyclic graph. Enforcing this at ingestion prevents typeclass inheritance loops that would make elaboration diverge.',
    forbids: 'cycle in EXTENDS subgraph',
    rationale: 'Typeclass inheritance must terminate; cycles crash Lean elaboration.',
    enforcement: 'HARD_BLOCK'
  },
  { name: 'reverse_causality_axiom_assumes',
    rank: 5,
    law: 'Axiom -ASSUMES-> Theorem = 0',
    description: 'An Axiom cannot ASSUME anything. If a putative Axiom depends on a Theorem, it is either (i) a derivable Theorem mislabelled, or (ii) a circular reasoning error.',
    forbids: 'Axiom -ASSUMES-> Theorem',
    rationale: 'Complements rule 1 (pure source). Catches mistyped theorems and circular reasoning.',
    enforcement: 'HARD_BLOCK'
  },
  { name: 'sink_instance_no_applies',
    rank: 6,
    law: 'Instance -APPLIES-> Theorem = 0',
    description: 'Instances are sinks consumed by typeclass resolution, not active reasoners. They may PARAMETRIZE or INSTANTIATE, never APPLIES.',
    forbids: 'Instance -APPLIES-> Theorem',
    rationale: 'Mirrors V3 Resource pure-sink rule; prevents mislabelling of helper lemmas as instances.',
    enforcement: 'HARD_BLOCK'
  },
  { name: 'namespace_not_opening_theorem',
    rank: 7,
    law: 'Namespace -OPENS_NAMESPACE-> X, X in {Theorem, Definition, Structure, Instance, Axiom} = 0',
    description: 'OPENS_NAMESPACE targets another Namespace (namespace N.M opens N). It never directly points at a Theorem, Definition, Axiom, Structure or Instance.',
    forbids: 'Namespace -OPENS_NAMESPACE-> {Theorem | Definition | Structure | Instance | Axiom}',
    rationale: 'Preserves the categorical meaning of import / open: namespace-to-namespace morphism, not namespace-to-declaration shortcut.',
    enforcement: 'HARD_BLOCK'
  }
] AS rules
UNWIND rules AS r
MERGE (rule:SelectionRule {namespace: 'LeanAlgebra', name: r.name})
SET rule.rank         = r.rank,
    rule.law          = r.law,
    rule.description  = r.description,
    rule.forbids      = r.forbids,
    rule.rationale    = r.rationale,
    rule.enforcement  = r.enforcement,
    rule.last_updated = datetime('2026-04-18T00:00:00Z');

// -------------------------------------------------------------
// 5. Indexes (non-unique lookups used by agents + ingestion)
// -------------------------------------------------------------
CREATE INDEX lean_quiver_vertex_role IF NOT EXISTS
  FOR (n:QuiverVertex) ON (n.role);

CREATE INDEX lean_quiver_vertex_height IF NOT EXISTS
  FOR (n:QuiverVertex) ON (n.height);

CREATE INDEX lean_selection_rule_enforcement IF NOT EXISTS
  FOR (n:SelectionRule) ON (n.enforcement);

// -------------------------------------------------------------
// 6. Final diagnostics (optional; can be commented out in batch runs)
// -------------------------------------------------------------
RETURN 'LeanAlgebra ontology seed complete.'                 AS status,
       count { (v:QuiverVertex   {namespace: 'LeanAlgebra'}) } AS vertices,
       count { (r:SelectionRule  {namespace: 'LeanAlgebra'}) } AS rules,
       count { (m:MagneticLaplacian {namespace: 'LeanAlgebra'}) } AS laplacian_nodes;
