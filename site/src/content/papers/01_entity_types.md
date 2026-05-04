---
title: "01 — The 6 Lean Entity Types"
description: "V3's 6-entity model (Actor, Process, Resource, Rule, Event, Context) re-mapped for Lean 4: Axiom, Theorem/Lemma, Definition/Abbrev, Structure/Class, Instance, Namespace."
category: "Graph Research · Neo4j"
order: 110
---

<!-- orig-frontmatter: name: 01_entity_types -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra -->
<!-- orig-frontmatter: phase: 0 -->
<!-- orig-frontmatter: author: Sarin-Alpha (γ Sgr) -->
<!-- orig-frontmatter: date: 2026-04-18 -->
# 01 — The 6 Lean Entity Types

**TL;DR.** V3's 6-entity model (Actor, Process, Resource, Rule, Event, Context) is re-mapped for Lean 4. The new types are **Axiom, Theorem/Lemma, Definition/Abbrev, Structure/Class, Instance, Namespace/Module**. This choice preserves the Ramsey R(3,3)=6 guarantee that underlies V3's pure-source/pure-sink symmetry (HypatiaBasis §2.1), while respecting Lean's native declaration kinds. Theorems and lemmas collapse to one type because Lean elaboration treats them identically (`theorem` vs `lemma` is a syntactic convention, not a kind distinction). Definitions and abbreviations collapse because `abbrev` is a reducible `def` (same elaboration, different unfolding hint). Structure and class collapse because `class` is a `structure` with instance synthesis attached.

## 1. The table

| # | Type | Height `h` | Role in graph | V3 analogue | OmegaTheory example |
|---|------|:---:|---|---|---|
| 1 | **Axiom** | 3 | Pure source — no in-edges, not reducible | Actor (A) | `c` at `Spacetime/Constants.lean:23`; `hbar` at `:27`; `G_N` at `:31`; `k_B` at `:35`; `Real.pi_transcendental` at `Irrationality/HermitePade/PiStratum.lean:45` |
| 2 | **Theorem / Lemma** | 1 | Active hub — max in+out degree | Process (P) | `einstein_tensor_emergence` at `Emergence/EinsteinEmergence.lean:327`; `computationalUncertainty_pos` at `Irrationality/Uncertainty.lean:42`; `grand_qm_emergence` at `Emergence/QuantumMechanicsCapstone.lean` |
| 3 | **Definition / Abbrev** | 2 | Semantic data — unfolded on demand | Resource (R) | `computationalUncertainty` at `Irrationality/Uncertainty.lean:33`; `l_P` at `Spacetime/Constants.lean:43`; `computationalUncertaintyBound` at `Irrationality/Uncertainty.lean:53` |
| 4 | **Structure / Class** | 2 | Framework / record / type-class | Rule (Ru) | `SatisfiesExtendedUncertainty` at `Irrationality/Uncertainty.lean:85`; `HealingParams`; `ErrorBound` (record structures binding invariants to fields) |
| 5 | **Instance** | 1 | Pure sink — consumes a class | Event (E) | various `instance : DecidableEq _`; `Field ℝ` instance usages |
| 6 | **Namespace / Module** | 0 | Environmental container | Context (C) | `namespace OmegaTheory.Irrationality`; `namespace OmegaTheory.Emergence`; Lean module = file-level container |

## 2. Why these six (and not more, not fewer)

Lean 4's declaration grammar has roughly ten top-level productions: `axiom`, `theorem`, `lemma`, `def`, `abbrev`, `structure`, `class`, `instance`, `opaque`, `noncomputable def`, plus `namespace` / `section` / `import`. A naïve one-per-production ontology would give us 11 vertex types, shattering R(3,3)=6. The collapse rules are:

1. **`theorem` ≡ `lemma`.** Identical elaboration in the kernel; `lemma` is a Mathlib stylistic macro. Both produce a `Prop`-typed constant with a proof term.
2. **`def` ≡ `abbrev` ≡ `noncomputable def` ≡ `opaque`.** All produce a constant with a body. Reducibility differs but graph-role does not — each is a named value referenced by theorems and other definitions.
3. **`structure` ≡ `class`.** Lean's `class` desugars to a `structure` plus `@[instance]` resolution hooks. The graph role (parameterizable framework) is identical.
4. **`namespace` ≡ module/file.** Both are lexical containers without computational content. Imports target modules; `open` targets namespaces; for graph purposes they are one role.

Collapsing these gets us from ~11 back to 6, preserving the R(3,3)=6 Ramsey guarantee (Marchewka, *Chromatic Numbers in System Modeling*) that any 2-coloring of a 6-vertex complete graph contains a monochromatic triangle — i.e., the system cannot be decomposed into two independent halves.

## 3. Heights — why the specific values

The height function `h: Q₀ → ℤ` (V3 HypatiaBasis, Def. 2.3) orders types by **how close they are to the foundations**. V3 uses h=3 for Actor (pure source) and h=0 for Resource (pure sink). We keep this polarity but flip the Lean-specific mapping:

- **Axiom, h=3.** An axiom is the *causally earliest* object in a Lean development. In OmegaTheory every chain ultimately lands at one of the 8 physical constants (`c`, `hbar`, `G_N`, `k_B` and their positivity lemmas) or at one of the 15 HermitePade research axioms (`motivicU`, `Nesterenko_1996`, etc.). An axiom has **no prerequisites** and no Lean object can rewrite it. It is the "Actor" of the Lean world: everything acts on its downstream consequences, nothing acts on the axiom itself.
- **Definition / Abbrev, h=2.** A definition expresses pure data — `computationalUncertainty N := ℓ_P · 4 / (2N + 3)` is a computation recipe. It depends on axioms (Planck length depends on `c`, `hbar`, `G_N`) but it is not yet asserting a proposition. Semantic weight, no truth value. Middle of the DAG.
- **Structure / Class, h=2.** A structure bundles fields plus field-level propositions (`SatisfiesExtendedUncertainty Δx Δp N` has one field requiring `ℏ/2 + computationalUncertainty N ≤ Δx · Δp`). It is framework-level: parameterizable by every user who wants to witness the pattern. Same height as Definition because both are "data producers" the theorems consume.
- **Theorem / Lemma, h=1.** A theorem is an active hub: it takes axioms + definitions + structures in, and emits a proposition + proof. It has the richest in/out degree in practice. The Grothendieck (GrothendieckAlgebraicTopologies §4.2) observation — that subsystems are detectable because hub nodes have anti-correlated sub-topologies across relations — applies here. `einstein_tensor_emergence` (172 lines) is a hub; it imports from Geometry/, Conservation/, and HealingFlow/ simultaneously.
- **Instance, h=1.** An instance is a pure sink: it consumes a class declaration (`class Field`) and commits this specific type (`ℝ`) to the class. It does not emit a new proposition available to other theorems in the graph-theoretic sense — instances are resolved by instance search, not by explicit citation. Symmetric to V3 Event (h=1): both are side-effects of other machinery firing.
- **Namespace / Module, h=0.** Lowest tier. A namespace has no computational content; it organizes names. Opening a namespace (`open OmegaTheory.Irrationality`) is a lexical operation that changes name resolution, not a data or proof operation.

## 4. The Axiom-as-source polarity (why h=3 matters)

In V3, Actor being a pure source (in-degree 0 on behavioral arrows, Proposition 2.1(ii) in HypatiaBasis) is what makes the quiver non-trivial: it means the algebra has a non-empty set of "prime causes." For Lean, Axiom being a pure source has the same role but with **stronger justification**: in Lean 4, an axiom is genuinely the only way to introduce a constant without a definition body. Every other declaration kind must eventually reduce to data + axioms. A Theorem can APPLY a Theorem, UNFOLD a Definition, or ASSUME an Axiom — but nothing can be APPLIED to an Axiom (that would amount to proving it, which by definition we did not do).

OmegaTheory V2 has exactly **6 axiom declarations** (post cycle 65, 2026-05-04: 4 sealed Hermite-Padé research axioms + 2 citation axioms — Zudilin Catalan-G, Witten Chern-Simons; π-transcendence retired cycle 64, all 8 physical constants now `noncomputable opaque {x : ℝ // 0 < x}` Subtype bundles via `Classical.choice`, not `axiom`). All 6 are leaves of every backward traversal of the theorem DAG. This is exactly the "pure behavioral source" property V3 proves for Actor.

## 5. The Namespace-as-context polarity (why h=0 matters)

V3 Context is h=1 in HypatiaBasis but behaves as a near-sink: the only typed arrows into Context are CONFIGURED_BY (P→C) and OCCURS_IN (E→C), and the only arrow out is APPLIES_IN (Ru→C), SCOPES (C→Ru). We push Lean Namespace to h=0 (strict sink) because:

1. Namespace is **purely organizational** in Lean — it never carries behavior or data; `namespace Foo` is erased at kernel time.
2. No typed dependency arrow in our 15-arrow set has a Namespace as target *as a consequence* — CONTAINS (Namespace→Theorem) is the single outbound relation, and it is structural, not computational.
3. Preserving R(3,3)=6 forces one of the types to be the strict sink. Resource played that role in V3 because passive data never acts; Namespace plays it in Lean because lexical containers never compute.

The small distinction matters empirically: when we run FastRP per relation (file 06), the Namespace nodes should have the lowest activity across all 15 per-relation topologies. If they don't, something is wrong with the ingestion.

## 6. Collapses we did **not** do — and why

We considered but rejected three further collapses:

- **Axiom + Theorem into "Assertion."** Rejected. Axioms have no proof term; theorems do. The graph must distinguish them because `ASSUMES` (Theorem→Axiom) is a meaningfully different arrow from `APPLIES` (Theorem→Theorem). Collapsing would lose the semantic edge that matters most to downstream consumers: "how many axioms does this proof depend on?" is a first-class question.
- **Structure + Definition into "Data."** Rejected. A structure is *parameterizable by future users* — any `instance` can commit a new witness. A definition is closed. The outgoing edge `INSTANTIATES` (Instance→Class) has no analogue for Definition, so collapsing would drop real information.
- **Instance + Theorem into "Sink-of-Class."** Rejected. Instances are resolved by the elaborator (instance search), theorems are cited by name. Different retrieval mechanics, different premise-selection cost. Separating them lets Lean-Finder weight instance-lookup chains differently from explicit-citation chains.

## 7. Inventory check against OmegaTheory

From the fresh catalogue (plan §Context):

- **2,612 theorems/lemmas** → type 2, the active hub. Matches the prediction that Theorem is the highest-degree type.
- **~1,057 definitions** → type 3. Roughly 2.5x fewer than theorems, consistent with V3 Resource:Process ratio on CheckItOut (≈3:5).
- **~250 structures** → type 4. Low count expected; structures are schemas, not instances.
- **282 namespaces** → type 6. Roughly 1 per file (211 files + module-internal subnamespaces).
- **6 axiom declarations** (post cycle 65) → type 1. Strict sources, match pure-source expectation. Legacy paper reads "24 axioms" — that count was 2026-04-21 (8 physical + 1 π-trans + 15 HermitePade conjectures); cycle 64 retired π-trans, the 8 physical were converted to opaque-Subtype bundles, and Hermite-Padé was scoped down to 4 sealed.
- **Instances** — not individually catalogued yet (ingestion task for Team Azha), but expected in the hundreds given Mathlib usage.

The 6-type partition covers **all** top-level declarations in OmegaTheory with no "other" bucket required. This is the sanity check V3 asks for (HypatiaBasis §2.3, Proposition 2.1(iv)): 38.9% block density = 14 of 36 blocks occupied. File 02 computes the Lean counterpart.

## 8. What this fixes compared to V3

V3's 6 entities are semantically heterogeneous — Actor is an executor, Resource is data, Event is a message. Their common denominator is "some notion of behavioral role." For Lean the common denominator is **declaration kind in the kernel**, which is a much cleaner invariant: every `.olean` file records exactly this partition, so ingestion is deterministic, not interpretive. A file analyzer does not need to guess what a Lean declaration "does" — the kernel already said. This eliminates the V1/V2 problem where different raters would classify the same file differently.

---

## Amended 2026-04-18 evening — Level B extension (Tactic + Attribute)

The original §1–§8 stands as-is for the **core** ontology. Two additional entity types have been added at **`extension_level = B`** to cover Lean's behavioral / meta layer that the 6-core ontology deliberately kept out of scope:

### 9. Level B entities (non-core, behavioral / meta)

| # | Type | Height `h` | Role in graph | Marker | Lean trigger | Live INSTANCE_OF children |
|---|------|:---:|---|---|---|:---:|
| 7 | **Tactic** | 1 | Behavioral action — consumed by Theorem/Definition at proof-time | `extension_level='B'`, `role='behavioral_action'` | `by <tac>`, `by simp only [...]`, `tac0; tac1` sequencing | 68 |
| 8 | **Attribute** | 0 | Behavioral marker — annotation on a declaration | `extension_level='B'`, `role='behavioral_marker'` | `@[simp]`, `@[ext]`, `@[to_additive]`, `@[reducible]`, `@[deprecated]` | 37 |

Verified live (`MATCH (v:QuiverVertex {namespace:'LeanAlgebra'}) RETURN v.name, v.extension_level`):

```
Attribute  B
Axiom      NULL
Definition NULL
Instance   NULL
Namespace  NULL
Structure  NULL
Tactic     B
Theorem    NULL
```

Two-level class / instance split. Unlike the 6 core types, which are taxonomically atomic, **Tactic and Attribute are meta-types**: each has a layer of concrete sub-tokens stored as `INSTANCE_OF`-linked children.

- **Tactic (68 children live):** `simp`, `ring`, `linarith`, `omega`, `aesop`, `nlinarith`, `polyrith`, `field_simp`, `norm_num`, `decide`, `exact`, `apply`, `rfl`, `rw`, `unfold`, `show`, `refine`, ... Each is a `:Tactic:LeanTactic` child linked `child -[:INSTANCE_OF]-> (parent:QuiverVertex {name:'Tactic'})`.
- **Attribute (37 children live):** `@[simp]`, `@[ext]`, `@[to_additive]`, `@[reducible]`, `@[deprecated]`, `@[class]`, `@[instance]`, `@[inline]`, `@[specialize]`, `@[irreducible]`, ... Same INSTANCE_OF pattern.

Both layers are behavioral / meta rather than declarational: they do not ship a type or a proof, but they modulate how declarations are used. `@[simp]` makes a theorem participate in `simp` rewrites; `simp` itself is a tactic that consumes `@[simp]`-tagged theorems. The two are duals at the behavioral layer.

### 9.1 Why Level B is needed

The 6-core ontology captures *what declarations are* (kernel-determined kinds). It does NOT capture *how declarations interact at proof-time*. Two load-bearing observations force Level B:

1. **Premise selection uses tactics.** When `exact?` or `hammer` picks a premise, the relevant edge is not "T₁ APPLIES T₂" but "T₁'s proof of form `by ring_nf; linarith` uses `ring_nf` + `linarith` tactics." Without a `Tactic` vertex, the retrieval graph cannot represent tactic-conditioned premise selection ("premises that typically close with linarith").

2. **Attribute-driven simp sets.** The `simp` lemma corpus on Mathlib is the single richest retrieval signal for rewriting. Without an `Attribute` vertex, we cannot represent "this theorem is a simp lemma" as a first-class graph property — we'd have to parse the attribute every time from source.

Both concerns are meta to the kernel (axioms are not affected), so Level B is an **orthogonal extension** of the core.

### 9.2 R(3,3) = 6 preservation

The R(3,3) = 6 Ramsey guarantee (§2) constrains the **core** ontology to 6 vertex types. Level B extensions are explicitly **outside** that guarantee:

- Core (6 types): Axiom, Theorem, Definition, Structure, Instance, Namespace — the Ramsey guarantee holds over these 6.
- Level B (2 additional meta-types): Tactic, Attribute — these are meta-extensions; no Ramsey property is claimed over the full 8 types.

Rationale: Tactic and Attribute are not first-class *kernel* declarations. They are either (a) tactic macros (syntax extensions, elaborated away at parse time) or (b) attributes (metadata on kernel declarations, not declarations themselves). The kernel partitioning argument in §2 — "every `.olean` file records exactly this partition" — applies to the 6 core types only. For Tactic and Attribute, ingestion reads Lean's environment extensions and attribute registries, which are a separate data source.

**Practical consequence:** the 6×6 block structure of the Magnetic Laplacian (memo 04) was computed on core types only. The revised 8×8 matrix (memo 04 amended) extends this to include Tactic and Attribute rows/columns, but the core 6×6 sub-block retains the original interpretation. The spectral decomposition of 𝔄 can still be read as "core algebra ⊕ behavioral extension."

### 9.3 Heights — why h=1 for Tactic and h=0 for Attribute

- **Tactic, h=1.** Same as Theorem and Instance: Tactics are *active consumers* — they read goals + hypotheses + Mathlib lemmas, and emit proof terms. From the graph's perspective, a Tactic node is consumed by a Theorem (via `USES_TACTIC`), same active-consumer role a Theorem has.
- **Attribute, h=0.** Same as Namespace: Attributes are *organizational metadata*. They do not ship type or proof; they tag declarations for later retrieval (by `simp`, by `to_additive`, by deprecation warnings). Kernel-erased post-elaboration, much like `namespace`.

Note the **asymmetry** with the core: Instance is h=1 because it is a pure sink in the INSTANTIATES sense. Tactic is h=1 because it is a pure sink in the USES_TACTIC sense (Theorems point at it, it never points back at a Theorem). Analogous roles, different arrows.

### 9.4 Inventory check

Live Neo4j (`math` container, 2026-04-18 evening):

```cypher
MATCH (v:QuiverVertex {namespace:'LeanAlgebra'})
WHERE v.extension_level = 'B'
RETURN v.name, v.role, v.height
// returns: Tactic/behavioral_action/1, Attribute/behavioral_marker/0

MATCH (t)-[:INSTANCE_OF]->(p:QuiverVertex {name:'Tactic'})
RETURN count(t) // => 68

MATCH (a)-[:INSTANCE_OF]->(p:QuiverVertex {name:'Attribute'})
RETURN count(a) // => 37
```

The total entity inventory is now **6 core + 2 Level B = 8 meta-types** + their INSTANCE_OF children (68 + 37 = 105 concrete tactics/attributes). The **Ramsey R(3,3) = 6 guarantee holds over the 6 core**, not the 8. Downstream consumers that rely on the Ramsey property (premise-selection's pure-source axiom, file 03's selection rules SR_L1 and SR_L2) restrict attention to the core.
