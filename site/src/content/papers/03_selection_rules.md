---
title: "03 — Selection Rules (Forbidden Compositions)"
description: "13 design rules pruning the 6×15 product space. 7 ship as HARD_BLOCK :SelectionRule nodes in live Neo4j."
category: "Graph Research · Neo4j"
order: 112
---

<!-- orig-frontmatter: name: 03_selection_rules -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra -->
<!-- orig-frontmatter: phase: 0 -->
<!-- orig-frontmatter: author: Sarin-Alpha (γ Sgr) -->
<!-- orig-frontmatter: date: 2026-04-18 -->
# 03 — Selection Rules (Forbidden Compositions)

**TL;DR.** The 6×15 product space of (entity-type, relationship-type) pairs has 90 slots per side, 8100 combinatorial edges. Most are forbidden by Lean's type system or by the ontology we fixed in files 01 & 02. This memo enumerates the selection rules that prune the space to the legal subset, as Cypher `CREATE CONSTRAINT` sketches. V3 reports 11 selection rules producing 22 forbidden blocks of a 36-block matrix. We write out **13 design rules** here; of these, **7 ship as HARD_BLOCK `SelectionRule` nodes** in live Neo4j (`lean_algebra_ontology.cypher:184-243`), and the remaining 6 are derivable from the 7 plus Lean's type discipline and the ontology of memo 02. Derivations appear in §6.

> **Cross-ref (2026-04-18).** We do NOT emit `GENERALIZES` or `FOLDS` as separate edges — see memo 05 §5.4 for how these arise spectrally from `T^(g) = exp(i · 2π · g · D)` at `g = 1/4` without additional ontology. Selection rules that would have constrained hypothetical `GENERALIZES`/`FOLDS` edges are therefore moot.

## 1. The 13 selection rules

Rules are numbered SR_L1..SR_L13 (`L` = Lean, to distinguish from V3 SR1..SR11).

### SR_L1 — Axiom is a pure source

**Statement.** `∀ X ∈ {Theorem, Definition, Structure, Instance, Namespace}, ∀ relation r ∈ R_15 : (X, r, Axiom) is forbidden`, except `ASSUMES` which is the *one* incoming edge type Axioms accept.

Actually, the precise form: **Axiom accepts zero incoming edges of any relationship type, as target.** `ASSUMES` runs Theorem → Axiom (Axiom is target), which is allowed. What is forbidden is the *reverse*: no `APPLIES` from another Theorem into an Axiom (that would mean "T₁ uses T₂ to prove an axiom," which is nonsensical — axioms are asserted, not proved).

Wait — this is a direction subtlety. Let me restate cleanly:

**SR_L1a (absolute):** No edge lands *at* an Axiom where the source is another Axiom or a Namespace. Formally:
- `(Axiom) →[any]→ Axiom` is forbidden (axioms do not depend on each other; each is a separate primitive assertion)
- `(Namespace) →[any]→ Axiom` is forbidden (namespace is lexical, cannot be a source of a dependency edge)

**SR_L1b (the critical polarity rule):** The only inbound edge type an Axiom accepts is `ASSUMES` from a `Theorem`. All other inbound are forbidden:
- `(Theorem) →[APPLIES]→ Axiom` is forbidden — an axiom is *not* a theorem, so APPLIES is mis-typed; use ASSUMES instead.
- `(Theorem) →[UNFOLDS]→ Axiom` is forbidden — axioms have no body to unfold.
- `(Theorem) →[REWRITES_BY]→ Axiom` is forbidden — axioms are not equations with direction.
- `(Definition) →[HAS_TYPE]→ Axiom` is forbidden — an axiom is a constant, not a type.

**Justification.** In Lean, an axiom is a raw assertion of a constant's existence or of a proposition's truth. The kernel accepts axioms into its context *without* requiring a body. No downstream operation can modify this: once an axiom is declared, it becomes a fixed point of every elaboration. The graph must reflect this: **exactly one inbound edge type (ASSUMES) and zero outbound edges**.

**What breaks if violated.** Suppose an ingestion pass emits `Theorem t →[APPLIES]→ Axiom a`. The premise selection pipeline would then believe that `a` is proved by `t`, causing the prover to attempt to apply `a` as a lemma derived from other work. But `a` is a primitive — trying to re-prove it would be an infinite regress, or in practice the prover would cycle on an unsound dependency.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT axiom_no_outbound IF NOT EXISTS
  FOR ()-[r]->() REQUIRE
    NOT (startNode(r):Axiom AND type(r) IN ['APPLIES','UNFOLDS','REWRITES_BY','REDUCES_TO',
                                             'ELABORATES_AS','SUGGESTED_BY','HAS_TYPE',
                                             'CONSTRAINED_BY','PARAMETRIZES','SPECIALIZES']);

CREATE CONSTRAINT axiom_inbound_is_assumes_only IF NOT EXISTS
  FOR ()-[r]->(a:Axiom) REQUIRE type(r) = 'ASSUMES';
```

### SR_L2 — Namespace is a container only

**Statement.** A Namespace participates in four edge types and four only: inbound `IMPORTS`, inbound `OPENS_NAMESPACE`, outbound `CONTAINS` (to member declarations), and outbound `IMPORTS` / `OPENS_NAMESPACE` (to other namespaces). Any dependency or type-theoretic edge into or out of a Namespace is forbidden.

Specifically forbidden:
- `(Namespace) →[APPLIES|UNFOLDS|ASSUMES|...]→ anything` (namespaces cannot prove, apply, or assume)
- `anything →[APPLIES|UNFOLDS|ASSUMES|...]→ (Namespace)` (namespaces cannot be proved, applied, or assumed)
- `(Namespace) →[HAS_TYPE|CONSTRAINED_BY|PARAMETRIZES]→ anything` (lexical container has no type or parameters)

**Justification.** In Lean, `namespace Foo` is a lexical annotation; it becomes part of the fully-qualified name prefix. It has no kernel representation as a first-class declaration. Every theorem/definition "inside" a namespace is actually stored at the kernel level with its fully-qualified name; the namespace is an organizational fiction. Treating it as a participant in dependency edges would break the premise-selection index — retrieving `OmegaTheory.Irrationality` yields 100+ children, none of which are the intended premise.

**What breaks if violated.** The retrieval step would collapse: a Lean-Finder query for "the bound on δ_comp" might hit the Namespace node `OmegaTheory.Irrationality` (high centrality!) instead of the actual `BoundsLemmas.deltaComp_bound_is_tight` theorem. Latency rises and recall drops.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT namespace_only_structural IF NOT EXISTS
  FOR ()-[r]->(n:Namespace) REQUIRE
    type(r) IN ['IMPORTS','OPENS_NAMESPACE','CONTAINS'];

CREATE CONSTRAINT namespace_out_only_structural IF NOT EXISTS
  FOR (n:Namespace)-[r]->() REQUIRE
    type(r) IN ['IMPORTS','OPENS_NAMESPACE','CONTAINS'];
```

### SR_L3 — Instance is a pure sink with a unique parent

**Statement.** An Instance `i : C` has exactly one outbound `INSTANTIATES` edge to the Class `C`. No other outbound edges from an Instance are permitted.

Forbidden:
- `(Instance) →[APPLIES]→ anything` — an instance has no proof body that cites theorems (the instance *is* the witness).
- `(Instance) →[UNFOLDS]→ anything` — instances are not unfolded by users.
- `(Instance) →[INSTANTIATES]→ (Instance)` — must target a Class, not another Instance.

**Justification.** An `instance` declaration in Lean 4 produces a term whose type is a class application. Kernel-level, it *is* a definition, but for the premise-selection graph it behaves as a sink — users cite the Class, and instance search selects the Instance. The Instance itself is rarely cited by name; it is found automatically. Giving it outbound edges would pollute the graph with duplicate proof-content links already carried by the Class's ambient theorems.

**1:1 uniqueness.** Each Instance has one parent Class. This is enforced by Lean's grammar (an instance declaration is of the form `instance name : Class args := body`). We encode it as:

**Cypher sketch:**
```cypher
CREATE CONSTRAINT instance_one_parent IF NOT EXISTS
  FOR (i:Instance) REQUIRE
    size([(i)-[:INSTANTIATES]->(:Class) | 1]) = 1;

CREATE CONSTRAINT instance_no_other_outbound IF NOT EXISTS
  FOR (i:Instance)-[r]->() REQUIRE
    type(r) = 'INSTANTIATES';
```

### SR_L4 — Class/Structure `EXTENDS` must be acyclic

**Statement.** The sub-graph induced by `EXTENDS` edges (Structure → Structure) is a DAG. `class B extends A` and `class A extends B` cannot both hold.

**Justification.** Lean's elaborator rejects cyclic structure inheritance at kernel time — the projection functions would be circularly defined. If the ingestion layer produces a cycle, something is wrong (either a parsing bug or a duplicated definition read from two branches of the repo).

**What breaks if violated.** Instance resolution would loop: to synthesize `B`, the elaborator needs an instance of `A`, which needs an instance of `B`, ad infinitum.

**Cypher sketch:**
```cypher
// Acyclicity is not a first-class Neo4j constraint; enforce at ingestion:
// For each EXTENDS chain, compute reachability, fail on back-edge.
CALL apoc.periodic.iterate(
  "MATCH path = (s:Structure)-[:EXTENDS*]->(s) RETURN path",
  "CALL apoc.util.validate(true, 'Cyclic EXTENDS chain: %s', [path]) RETURN 0",
  {batchSize:100}
);
```

### SR_L5 — `ASSUMES` inverses are forbidden

**Statement.** `(Axiom) →[ASSUMES]→ anything` is forbidden — ASSUMES only flows Theorem → Axiom.

**Justification.** An axiom does not "assume" anything — it *is* an assumption. Reversing the arrow would invert causality. This is the direct Lean analogue of V3's SR2 "Actor is a pure behavioral source."

**Cypher sketch:**
```cypher
CREATE CONSTRAINT assumes_direction IF NOT EXISTS
  FOR ()-[r:ASSUMES]->(tgt) REQUIRE tgt:Axiom;
CREATE CONSTRAINT assumes_source_is_theorem IF NOT EXISTS
  FOR (src)-[r:ASSUMES]->() REQUIRE src:Theorem OR src:Lemma;
```

### SR_L6 — `APPLIES` reverse from Instance is forbidden

**Statement.** `(Instance) →[APPLIES]→ Theorem` is forbidden. An instance does not prove; it witnesses.

**Justification.** Follows from SR_L3. Separate rule because the error pattern is specific: ingestion might incorrectly attribute a theorem APPLIES to the *instance* that discharged a class constraint, when it should be attributed to the *theorem* that the instance transitively provides.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT instance_no_applies IF NOT EXISTS
  FOR (i:Instance)-[r:APPLIES]->() REQUIRE false;  // forbidden
```

### SR_L7 — `OPENS_NAMESPACE` and namespace-target rules

**Statement.**
- `(Namespace) →[OPENS_NAMESPACE]→ (Theorem|Axiom|Definition|Structure|Class|Instance)` is forbidden.
- Only `(Namespace) →[OPENS_NAMESPACE]→ (Namespace)` is legal.

**Justification.** `open` in Lean targets a namespace, not a specific declaration. Opening a theorem makes no kernel-level sense.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT open_targets_namespace_only IF NOT EXISTS
  FOR ()-[r:OPENS_NAMESPACE]->(tgt) REQUIRE tgt:Namespace;
```

### SR_L8 — `UNFOLDS` cannot target a Structure or Namespace

**Statement.** `(Theorem) →[UNFOLDS]→ (Structure|Class|Namespace|Axiom|Instance)` is forbidden. Only `(Theorem) →[UNFOLDS]→ (Definition|Abbrev)` is legal.

**Justification.** Only definitions have reducible bodies. Structures have fields (accessed by projection, not by unfolding); namespaces are lexical; axioms have no body; instances have a body but are handled by instance search, not by `unfold`.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT unfolds_targets_definition_only IF NOT EXISTS
  FOR ()-[r:UNFOLDS]->(tgt) REQUIRE tgt:Definition;
```

### SR_L9 — `REWRITES_BY` requires an equation-typed theorem

**Statement.** `(Theorem) →[REWRITES_BY]→ (target)` requires that `target` is a Theorem/Lemma whose statement is an equation `a = b` or `a ↔ b`.

**Justification.** `rw` and `simp` require a rewrite lemma. A non-equation theorem cannot syntactically rewrite.

**Implementation.** This is a *semantic* constraint; Neo4j does not natively know what an equation is. Enforce at ingestion by parsing the target's type signature:

```cypher
// At ingestion time:
// WHERE NOT (target.signature CONTAINS ' = ' OR target.signature CONTAINS ' ↔ ') DROP edge
```

### SR_L10 — Cycles between `SPECIALIZES` and `APPLIES` are forbidden

**Statement.** `T₁ SPECIALIZES T₂` and `T₂ APPLIES T₁` cannot both hold. This would mean T₁ is a specialization of T₂, and T₂ is proved using T₁ — circular.

**Justification.** Lean accepts circular reasoning only at the kernel's termination checker boundary. If our graph shows a SPECIALIZES/APPLIES cycle, ingestion likely conflated a proof pattern (auxiliary lemma used before the general theorem is stated) with a logical dependency.

**Cypher sketch:** Check absence of `(T1)-[:SPECIALIZES]->(T2)-[:APPLIES]->(T1)` in a post-ingestion validation scan.

### SR_L11 — `HAS_TYPE` and `CONSTRAINED_BY` target only Structure/Class

**Statement.**
- `(Definition|Theorem) →[HAS_TYPE]→ (target)` requires `target:Structure OR target:Class`.
- `(Definition|Theorem) →[CONSTRAINED_BY]→ (target)` requires `target:Class`.

**Justification.** A type annotation points at a type — a structure or class. A class constraint needs instance search, which requires a class. Neither can point at a theorem, axiom, or namespace.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT has_type_target IF NOT EXISTS
  FOR ()-[r:HAS_TYPE]->(tgt) REQUIRE tgt:Structure OR tgt:Class;
CREATE CONSTRAINT constrained_by_target IF NOT EXISTS
  FOR ()-[r:CONSTRAINED_BY]->(tgt) REQUIRE tgt:Class;
```

### SR_L12 — `REDUCES_TO` is acyclic within a module

**Statement.** The `REDUCES_TO` subgraph, restricted to a single module, is a DAG.

**Justification.** The kernel's reduction is a partial order on closed terms. A cycle at reduction time would mean non-termination of `whnf`, which Lean would reject. If we see a cycle in REDUCES_TO edges, it is an ingestion error.

**Cypher sketch:** Similar to SR_L4; cycle-check post-ingestion.

### SR_L13 — `SUGGESTED_BY` confidence must be in [0, 1]

**Statement.** Every `SUGGESTED_BY` edge carries a `confidence` property in the closed interval [0, 1]. Edges with confidence = 0 should be pruned at ingestion; confidence = 1 is reserved for kernel-verified edges (not reranker output).

**Justification.** SUGGESTED_BY is the one probabilistic edge type. Without a well-defined range, the retrieval pipeline can't weight candidates.

**Cypher sketch:**
```cypher
CREATE CONSTRAINT suggested_by_confidence IF NOT EXISTS
  FOR ()-[r:SUGGESTED_BY]->() REQUIRE r.confidence >= 0.0 AND r.confidence <= 1.0;
```

---

**Design note (2026-04-18, team-lead reconciliation with Izar/Docs-Nu).**
Live Neo4j ontology (`LeanFormalizationV2/.neo4j/lean_algebra_ontology.cypher:184-243`) materializes **7 HARD_BLOCK SelectionRule nodes** as the ingestion-enforced kernel. These correspond to SR_L1–SR_L7 above, renamed to match Cypher field names:

| Memo | Live Neo4j `name` | Rank | Enforcement |
|---|---|:---:|---|
| SR_L1 | `axiom_is_pure_source` | 1 | HARD_BLOCK |
| SR_L2 | `namespace_is_container_only` | 2 | HARD_BLOCK |
| SR_L3 | `instance_unique_parent` | 3 | HARD_BLOCK |
| SR_L4 | `acyclic_extends_dag` | 4 | HARD_BLOCK |
| SR_L5 | `reverse_causality_axiom_assumes` | 5 | HARD_BLOCK |
| SR_L6 | `sink_instance_no_applies` | 6 | HARD_BLOCK |
| SR_L7 | `namespace_not_opening_theorem` | 7 | HARD_BLOCK |

**Status of SR_L8 through SR_L13.** Rules 8–13 above are **not emitted as SelectionRule nodes** in live Neo4j. They are derivable from the 7 base rules plus Lean's type discipline, and therefore do not require independent ingestion guards. The derivations are explicit below (§6 gains this section).

Don't emit GENERALIZES / FOLDS / etc. as separate edges — per memo 05 §5.4, these arise spectrally from `T^(g) = exp(i · 2π · g · D)` at `g = 1/4` without needing new ontology. Selection rules that would have constrained such edges are therefore moot.

## 2. Forbidden block count

Taking the 6 entity types as a row/column pair and each of the 15 relationships as a layer, we have a 6×6×15 occupancy tensor `occ[X][Y][r] ∈ {0,1}`. Entries forbidden by the SRs above:

| Entity type as sink | Relationships permitted (count) | Forbidden (count) |
|---|:---:|:---:|
| Axiom | 1 (ASSUMES) | 14 |
| Theorem/Lemma | ≤ 7 (APPLIES, SPECIALIZES, REWRITES_BY, SUGGESTED_BY, ELABORATES_AS, CONTAINS-inbound, ... ) | 8 |
| Definition/Abbrev | ≤ 5 (UNFOLDS, REDUCES_TO, ELABORATES_AS, CONTAINS-inbound, HAS_TYPE-inbound-sometimes) | 10 |
| Structure/Class | ≤ 6 (HAS_TYPE, EXTENDS, INSTANTIATES, CONSTRAINED_BY, PARAMETRIZES-inbound, CONTAINS-inbound) | 9 |
| Instance | 0 (instances are pure sinks) | 15 |
| Namespace | 3 (IMPORTS, OPENS_NAMESPACE, CONTAINS-inbound) | 12 |
| **Total** | **≤ 22** | **68** |

So roughly **68 of 90 sink-type × relationship combinations are forbidden** (≈ 75% prune rate). V3 has 22 of 36 blocks forbidden ≈ 61%. Lean is *more* constrained than software architecture because dependent types tighten what can legally reference what.

The corresponding *source-type × relationship* table is roughly symmetric and prunes another ~60 combinations. Net: out of 6×6×15 = 540 slots in the occupancy tensor, we expect **≤ 80 legal slots**. File 04 makes this precise for the 6×6 Magnetic Laplacian.

## 3. Summary count vs V3

| Metric | V3 | Lean |
|---|:---:|:---:|
| Selection rules | 11 | 13 |
| Block density | 14/36 = 38.9% | to be computed in file 04, expected ≈ 30–40% |
| "Pure source" type | Actor (SR2) | Axiom (SR_L1) |
| "Pure sink" type | Resource (SR1) | Instance (SR_L3) |
| "Container" type | Context (soft) | Namespace (strict, SR_L2) |
| Additional Lean-specific rules | — | SR_L4 (acyclic EXTENDS), SR_L9 (eq-typed rewrite), SR_L12 (acyclic reduces-to) |
| Rules dropped from V3 | — | 4 runtime-behavioral rules (no Event/Process event loop), 2 Rule-vs-Process rules (subsumed by CONSTRAINED_BY) |

## 4. Enforcement strategy

The 13 rules split by who enforces them:

- **Kernel-enforced (free).** SR_L1 direction, SR_L4 acyclicity, SR_L8 target, SR_L12 acyclicity — Lean's own elaborator rejects violations. Ingestion simply parses `.olean` outputs.
- **Neo4j constraint-enforced.** SR_L2, SR_L3 uniqueness, SR_L5–SR_L8 direction, SR_L11 target, SR_L13 range. Schema constraints; violations reject WRITE.
- **Ingestion-validation enforced.** SR_L9 (semantic — requires parsing signatures), SR_L10 cycle check, post-write scans.

Team Azha writes the Cypher constraint definitions; Team Merak writes the validation scan scripts. Every successful ingestion run ends with `CALL apoc.custom.validateSchema()` emitting zero violations.

## 6. Why only 7 rules ship as SelectionRule nodes — derivations of SR_L8..SR_L13

SR_L1 through SR_L7 ship as `SelectionRule` nodes in `lean_algebra_ontology.cypher` because each of them encodes a kernel-level or ontology-level invariant that would need to be re-checked at ingestion if violated. SR_L8 through SR_L13 are **derivable** from the 7 base rules plus Lean's own type discipline or from the arrow ontology in memo 02. We write the derivations here so the memo stays exhaustive even though the Neo4j schema does not separately enforce them.

### SR_L8 — `UNFOLDS` target must be `Definition`

Derivable from **memo 02 §3.3** directly: the arrow `UNFOLDS` is defined with signature `Theorem → Definition/Abbrev`. Any edge of type `UNFOLDS` reaching a target of type `Axiom`, `Structure`, `Class`, `Instance`, or `Namespace` is mis-typed at the graph schema level — the ingestion loader will never create such an edge because the arrow signature itself rejects it. No SelectionRule node needed; the arrow definition carries the constraint. Plus SR_L1 already forbids any inbound non-ASSUMES edge on Axioms, and SR_L2 forbids any dependency edge on Namespaces, so half the forbidden targets are ruled out for free.

### SR_L9 — `REWRITES_BY` requires an equation-typed theorem

Not a structural ingestion rule; it is a **semantic well-formedness check** performed at edge-creation time by the Lean extractor. The extractor only emits a `REWRITES_BY` edge when it parses a `rw [t]` or `simp [t]` tactic invocation where `t` has declared type `_ = _` or `_ ↔ _`. If the edge exists in the graph, it is by construction well-formed. There is no Neo4j schema constraint because we never reach the stage where an ill-typed `REWRITES_BY` would be inserted — the extractor filters upstream.

### SR_L10 — No `SPECIALIZES` / `APPLIES` cycle

Derivable from **Lean's proof DAG termination** plus the `APPLIES` semantics (memo 02 §3.2). A Lean theorem can only be proved using previously-elaborated theorems — `T₂ APPLIES T₁` means T₁ was elaborated before T₂. `T₁ SPECIALIZES T₂` means T₂ was elaborated before T₁ (we can't specialize what hasn't been stated yet). A cycle would require T₁ and T₂ to each be elaborated before the other, which Lean's kernel rejects. Post-ingestion scanning would find at most transient artifacts from mixed-namespace parsing; these are ingestion bugs, not algebra violations. No independent rule needed — SR_L4 (acyclic EXTENDS) is the pattern and it generalizes automatically.

### SR_L11 — `HAS_TYPE` / `CONSTRAINED_BY` target

Derivable from **memo 02 §4.1 and §4.2** by the same argument as SR_L8. The arrows `HAS_TYPE` and `CONSTRAINED_BY` are typed `→ Structure/Class`; targeting any other entity type produces an edge that doesn't match any arrow in the 15-arrow set and is therefore never emitted. The arrow signature carries the constraint.

### SR_L12 — `REDUCES_TO` acyclic

Derivable from **Lean's kernel `whnf` termination**. If `D₁ REDUCES_TO D₂` and `D₂ REDUCES_TO D₁`, then computing `whnf(D₁)` would loop — Lean rejects this at definition time. The DAG property holds by elaboration invariant; no post-hoc check needed.

### SR_L13 — `SUGGESTED_BY` confidence in [0, 1]

Derivable from the **Lean-Finder / BGE-reranker output specification**. The reranker emits scores normalized to [0, 1]; confidence outside that range would indicate a bug in the retrieval pipeline, not an ingestion issue that Neo4j's schema should police. The loader normalizes upstream, so by the time edges land in Neo4j, the range property is guaranteed.

### Why derivations matter — honest schema minimalism

We could ship 13 SelectionRule nodes instead of 7, but it would be cargo-cult: rules that either (a) duplicate ontology-arrow signatures, (b) duplicate Lean kernel invariants the `.olean` format already guarantees, or (c) duplicate upstream-normalized properties from the retrieval pipeline. Shipping only the 7 that are **not** derivable keeps the `SelectionRule` node set as the *minimum independent invariants* — each one rejects a distinct class of would-be graphs.

A later Team Merak verification script can re-check SR_L8..SR_L13 as optional audits (`run_derived_invariants_audit.py`); but these are audits against derivation correctness, not ingestion guards.

---

## Amended 2026-04-18 evening — Level B + C selection rules (SR_L14..SR_L18)

The 13 design rules above are defined on the **6 core entity types** + **15 core arrows**. Memo 01 §9 added 2 Level B entity types (`Tactic`, `Attribute`), and memo 02 §11–§13 added 5 Level B + C arrows (`USES_TACTIC`, `TAGGED_AS`, `MUTUALLY_IMPLIES`, `DUAL_OF`, `ADDITIVE_PAIR`). These force five new selection rules, SR_L14..SR_L18.

Like SR_L8..SR_L13, these rules are **not** expected to ship as separate `SelectionRule` HARD_BLOCK nodes in Neo4j — they are enforced by arrow-signature typing plus extractor discipline. They are written here for completeness and auditability.

### SR_L14 — Tactic as pure target in `USES_TACTIC`

**Statement.** A `Tactic` vertex never originates an edge; it is strictly the target of `USES_TACTIC`.

- `(Tactic) →[any]→` anything is forbidden.
- `(Theorem | Definition) →[USES_TACTIC]→ (Tactic)` is the only legal form.
- `(Axiom | Structure | Instance | Namespace) →[USES_TACTIC]→ (Tactic)` is forbidden (axioms have no proof body; structures/instances/namespaces are non-active).

**Justification.** A Tactic is a behavioral consumer, not a source. The meta-ontology deliberately encodes Tactic as *what a proof uses*, not *what a tactic produces* — the "output" of a tactic is a proof term, which flows back into a Theorem, not into a new Tactic node. This keeps the Tactic sub-graph a bipartite sink between `{Theorem, Definition}` and `Tactic`.

**Analogue.** Structurally identical to SR_L3 (Instance as pure sink under INSTANTIATES), lifted to the Level B layer.

**Cypher sketch (derivable via arrow signature, no separate HARD_BLOCK node needed):**

```cypher
CREATE CONSTRAINT uses_tactic_source IF NOT EXISTS
  FOR (src)-[r:USES_TACTIC]->() REQUIRE
    src:Theorem OR src:Definition;
CREATE CONSTRAINT uses_tactic_target IF NOT EXISTS
  FOR ()-[r:USES_TACTIC]->(tgt) REQUIRE tgt:Tactic;
```

### SR_L15 — Attribute as pure target in `TAGGED_AS`

**Statement.** An `Attribute` vertex never originates an edge; it is strictly the target of `TAGGED_AS`.

- `(Attribute) →[any]→` anything is forbidden.
- `(Theorem | Definition | Structure | Instance | Axiom) →[TAGGED_AS]→ (Attribute)` is the only legal form.
- `(Namespace | Tactic) →[TAGGED_AS]→ (Attribute)` is forbidden (Namespace is purely lexical; Tactic is itself meta-behavioral and does not carry attributes in the kernel).

**Justification.** Attributes are kernel-registered metadata on *declarations*. `namespace` and `tactic` do not receive attributes in Lean 4 — the `@[simp]` prefix on a `namespace` block is a syntactic error. The target-only polarity mirrors the ontology: Attribute is a behavioral marker, consumed by downstream retrieval (simp-set selection, `@[to_additive]` pair discovery), never itself a source.

**Analogue.** Structurally mirrors SR_L2 (Namespace as container only), lifted to the Level B layer.

### SR_L16 — `MUTUALLY_IMPLIES` symmetric (emits both directions)

**Statement.** Every emitted `MUTUALLY_IMPLIES` edge has its reverse-direction counterpart. Formally:

- `(T₁) →[MUTUALLY_IMPLIES]→ (T₂)` implies `(T₂) →[MUTUALLY_IMPLIES]→ (T₁)` must also exist.

**Justification.** Mutual implication is a commutative semantic relation (`↔`). If the extractor emits only one direction, the graph loses the 𝔰𝔲(2) raising/lowering symmetry that is the whole point of Level C (memo 02 §12.1, memo 04 §5.4 revised). A half-directional MUTUALLY_IMPLIES edge is a bug, not a partial result.

**Enforcement.** Extractor-time. Phobos-Iota's emitter pushes both directions within the same transaction, guaranteeing atomic symmetric writes.

**Cypher audit (post-ingestion):**

```cypher
MATCH (a:Theorem)-[:MUTUALLY_IMPLIES]->(b:Theorem)
WHERE NOT (b)-[:MUTUALLY_IMPLIES]->(a)
RETURN a.name, b.name
// should return 0 rows
```

### SR_L17 — `DUAL_OF` symmetric

**Statement.** Every emitted `DUAL_OF` edge has its reverse-direction counterpart.

- `(T₁) →[DUAL_OF]→ (T₂)` implies `(T₂) →[DUAL_OF]→ (T₁)` must also exist.
- Same for `(D₁) →[DUAL_OF]→ (D₂)` between Definitions.

**Justification.** Duality suffixes `_left/_right`, `_pos/_nonneg`, etc. are symmetric relations by construction: if `X_left` is dual to `X_right`, then `X_right` is dual to `X_left`. Half-directional edges would break spectral symmetry (memo 04 §5.4).

**Enforcement.** Extractor-time. Same mechanism as SR_L16.

### SR_L18 — `ADDITIVE_PAIR` symmetric

**Statement.** Every emitted `ADDITIVE_PAIR` edge has its reverse-direction counterpart.

- `(mul_comm) →[ADDITIVE_PAIR]→ (add_comm)` implies `(add_comm) →[ADDITIVE_PAIR]→ (mul_comm)` must also exist.

**Justification.** The `@[to_additive]` attribute establishes an equivalence between the multiplicative and additive versions of a statement. The equivalence is bidirectional: applying the substitution table in reverse (`add → mul`, etc.) on the additive version must return the multiplicative one. Halving the edge direction would break this invariant.

**Enforcement.** Extractor-time.

### Enforcement posture for SR_L14..SR_L18

| Rule | Emit as `SelectionRule` HARD_BLOCK? | Enforced by |
|---|:---:|---|
| SR_L14 (Tactic pure target) | No | Arrow signature at extraction (USES_TACTIC defined with `source_type ∈ {Theorem, Definition}`, `target_type = Tactic`) |
| SR_L15 (Attribute pure target) | No | Arrow signature (TAGGED_AS, `target_type = Attribute`) |
| SR_L16 (MUTUALLY_IMPLIES symmetric) | No | Extractor atomicity — emits both directions in one transaction |
| SR_L17 (DUAL_OF symmetric) | No | Extractor atomicity |
| SR_L18 (ADDITIVE_PAIR symmetric) | No | Extractor atomicity |

The "7 base HARD_BLOCK + derived" framing from §6 stands: SR_L8..SR_L18 together are the derived complement (11 rules derivable from the 7 base, the arrow ontology, and Lean's kernel discipline).

### Updated block-count summary

Adding Level B + C to the block-count accounting of §2 above:

- **Tactic as sink** — accepts 1 relationship (USES_TACTIC) from 2 source types (Theorem, Definition) = 2 legal slots; forbidden slots = 8 × 5 − 2 = 38 in the source × rel product for the sink Tactic row.
- **Attribute as sink** — accepts 1 relationship (TAGGED_AS) from 5 source types (Theorem, Definition, Structure, Instance, Axiom) = 5 legal slots; forbidden 8 × 5 − 5 = 35.
- **MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR** restricted to Theorem↔Theorem (MUTUALLY_IMPLIES, ADDITIVE_PAIR) or Theorem/Definition ↔ same type (DUAL_OF). These are symmetric; they occupy two block cells each (one per direction).

Net effect on the 8 × 8 × 20 occupancy tensor: the overall prune rate stays ≈75% (Level B+C arrows are more restrictive than core because meta-targets only accept specific source types); exact count appears in the amended §2 of memo 04.
