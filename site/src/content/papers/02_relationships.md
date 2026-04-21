---
title: "02 — Typed Arrows (15 relationships)"
description: "4 structural + 5 dependency + 3 type-theoretic + 3 computational typed arrows. IMPORTS, OPENS_NAMESPACE, EXTENDS, INSTANTIATES, ASSUMES, APPLIES, UNFOLDS, SPECIALIZES, ..."
category: "Graph Research · Neo4j"
order: 111
---

<!-- orig-frontmatter: name: 02_relationships -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra -->
<!-- orig-frontmatter: phase: 0 -->
<!-- orig-frontmatter: author: Sarin-Alpha (γ Sgr) -->
<!-- orig-frontmatter: date: 2026-04-18 -->
# 02 — The 15 Typed Relationships

**TL;DR.** V3's 22-arrow quiver is replaced with 15 Lean-specific typed relationships in four categories: **4 structural**, **5 dependency**, **3 type-theoretic**, **3 computational**. Seven of V3's 22 arrows (PERFORMS, CALLS, USES, MODIFIES, CREATES, TRIGGERS, INITIATES) do not map cleanly to Lean because theorem proving has no mutable state, no side-effects, and no event loop — instead Lean has proof-term composition, type-class resolution, and definitional unfolding, which V3's software-centric ontology lacks vocabulary for. The new 15 relationships are mostly *monotonic* and *deterministic* (proving is pure): this is why, compared to V3, we gain the `UNFOLDS` / `REDUCES_TO` / `ELABORATES_AS` axis that has no software analogue.

## 1. Taxonomy overview

```
Structural      (4) — lexical / kernel-level structure
Dependency      (5) — proof-content consumption
Type-theoretic  (3) — type & parameter machinery
Computational   (3) — evaluation & elaboration
                ─────
                15
```

Each row below gives:
- **Signature** — entity types at tail and head
- **Cypher edge name** — ALL_CAPS_UNDERSCORE, SAFE_FOR_NEO4J
- **Semantic definition** — one sentence
- **OmegaTheory example** — file + line number
- **V3 delta** — how it relates to or differs from a V3 arrow

---

## 2. Structural relationships (4)

These mirror V3 Category I (type-agnostic structural arrows: IMPORTS, EXTENDS, IMPLEMENTS, INJECTS, TESTED_BY). We keep the most important three and add one Lean-specific one (OPENS_NAMESPACE).

### 2.1 `IMPORTS`

- **Signature:** `Namespace → Namespace` (or Module → Module — same graph in Lean 4)
- **Cypher:** `IMPORTS`
- **Definition:** A Lean module declares at top `import Mathlib.Topology.MetricSpace.Basic` or `import OmegaTheory.Spacetime.Constants` — the importing module has access to every declaration in the imported module.
- **Example:** `Irrationality/Uncertainty.lean` imports `OmegaTheory.Spacetime.Constants` (used for `l_P`), `Mathlib.Data.Real.Basic`, etc.
- **V3 delta:** Kept as-is from V3 (which used IMPORTS the same way). Unchanged.

### 2.2 `OPENS_NAMESPACE`

- **Signature:** `Namespace → Namespace`
- **Cypher:** `OPENS_NAMESPACE`
- **Definition:** `open OmegaTheory.Irrationality` inside another namespace makes the inner namespace's short names visible. Distinct from `IMPORTS` because it is a *scoping* operation, not a *transitive-dependency* operation.
- **Example:** Most files in `Emergence/` open `OmegaTheory.Spacetime` to use `l_P`, `c`, `hbar` without qualification.
- **V3 delta:** No analogue. V3 has no namespace-opening semantics; Java/Spring has `import static` but the CheckItOut graph did not model it. Lean's namespace/open duality is first-class.

### 2.3 `EXTENDS`

- **Signature:** `Structure → Structure` (or `Class → Class`)
- **Cypher:** `EXTENDS`
- **Definition:** `structure B extends A` declares B as a structure containing all fields of A plus new ones. Lean records this as a parent pointer.
- **Example:** Any record in OmegaTheory that inherits from a base structure — e.g., a particle sector structure extending a generic `GaugeField` structure.
- **V3 delta:** Direct translation of V3 EXTENDS (type-agnostic structural). Restricted here to Structure↔Structure — EXTENDS Definition or EXTENDS Theorem would be type-incorrect in Lean.

### 2.4 `INSTANTIATES`

- **Signature:** `Instance → Class`
- **Cypher:** `INSTANTIATES`
- **Definition:** An instance declaration commits a specific type to a class (`instance : DecidableEq (Fin n) := ...`). Elaborator uses this to resolve class constraints.
- **Example:** Countless `instance : Nonempty ...`, `instance : Decidable ...` throughout OmegaTheory — each links a specific witness to a class.
- **V3 delta:** Close to V3 IMPLEMENTS but narrower. IMPLEMENTS in Java/Spring means "this class implements an interface *and inherits its contract*"; INSTANTIATES is narrower — just "this named instance witnesses class X for type Y." Java's multi-inheritance-via-interfaces is closer to EXTENDS in Lean.

---

## 3. Dependency relationships (5)

These carry proof content. They replace V3's behavioral arrows (PERFORMS, CALLS, USES, MODIFIES, TRIGGERS, INITIATES) because proving has no behavior, only consumption of previously proved facts.

### 3.1 `ASSUMES`

- **Signature:** `Theorem → Axiom`
- **Cypher:** `ASSUMES`
- **Definition:** The proof of `T` expands (possibly transitively) to a term that references the constant introduced by an `axiom`. Formally: the axiom appears in the set returned by `lean_verify` on `T`'s name.
- **Example:** Most predictions in `OmegaTheory/Predictions/` eventually depend on `c_pos`, `hbar_pos`, `G_N_pos`. `einstein_tensor_emergence` at `Emergence/EinsteinEmergence.lean:327` `ASSUMES` `c_pos`, `hbar_pos`, `G_N_pos`, `k_B_pos` (the four fundamental axioms).
- **V3 delta:** V3 has no `ASSUMES`. In software, "depends on an axiom" has no natural counterpart — axioms are mathematical primitives. This is the single most load-bearing new arrow: it is how we count axiom debt for a theorem. **The "gold standard" query for OmegaTheory quality control is:** "which theorems ASSUMES more than the 8 physical constants + 1 pi_transcendental?" The 15 HermitePade axioms should each have an ASSUMES fan-out only into `Irrationality/HermitePade/`.

### 3.2 `APPLIES`

- **Signature:** `Theorem → Theorem` (or `Theorem → Lemma`)
- **Cypher:** `APPLIES`
- **Definition:** The proof term of T₁ mentions T₂. This is the proof-content-level consumption — T₁ uses T₂ as a step.
- **Example:** `einstein_tensor_emergence_regime` at `Emergence/EinsteinEmergence.lean:559` APPLIES `einstein_tensor_emergence` at `:327` to specialize to a regime.
- **V3 delta:** Closest to V3 CALLS (Process→Process). Different in that APPLIES is referentially transparent (no side effects, no temporal order) while CALLS is imperative.

### 3.3 `UNFOLDS`

- **Signature:** `Theorem → Definition` (or `→ Abbrev`)
- **Cypher:** `UNFOLDS`
- **Definition:** The proof of T uses `unfold` / `show` / `simp only [def]` / `rfl`-up-to-def on the body of D. T's proof-content *expects* the reader to know D's expansion.
- **Example:** Any theorem in `Irrationality/Uncertainty.lean` that rewrites `computationalUncertainty N` in terms of `ℓ_P · 4 / (2N+3)` — e.g., `computationalUncertainty_decreasing` at `:47` UNFOLDS `computationalUncertainty`. Similarly theorems about `l_P` UNFOLDS `l_P = Real.sqrt (hbar * G_N / c^3)`.
- **V3 delta:** No V3 analogue. Software has `USES` (Process→Resource, read-only access) but USES is *runtime* — Lean's UNFOLDS is *static*, at elaboration time. No side effect, no mutability.

### 3.4 `SPECIALIZES`

- **Signature:** `Theorem → Theorem` (where T₂ is a strictly more general form of T₁, with fewer implicit arguments fixed)
- **Cypher:** `SPECIALIZES`
- **Definition:** T₁ is derivable from T₂ by specialization of parameters; T₁'s statement is a consequence of T₂'s universally-quantified statement at a fixed value.
- **Example:** `computationalUncertainty_pos N` (for all N) at `Irrationality/Uncertainty.lean:42` is SPECIALIZES of a hypothetical `computationalUncertainty_pos_forall` — when a specialized bound is proved separately for clarity, we tag the edge. More concretely, regime-specific witnesses in `Emergence/` SPECIALIZES the generic `HealingParams`-parameterized theorems.
- **V3 delta:** V3 has `APPLIES_IN` (Rule→Context) for conditional rules. SPECIALIZES is mathematical (universal → particular), not conditional. Distinct semantics: a specialization is a logical consequence, not a scoping condition.

### 3.5 `REWRITES_BY`

- **Signature:** `Theorem → Theorem` (where the rewriting theorem is an equation)
- **Cypher:** `REWRITES_BY`
- **Definition:** The proof of T uses `rw [eq]` or `simp [eq]` where `eq` is an equation-typed theorem. T's proof is not just citing eq — it is **syntactically replacing** a subterm of the goal.
- **Example:** Proofs in `Spacetime/Operators.lean` that rewrite `(a + b) + c` using `add_assoc`; proofs in `Irrationality/BoundsLemmas.lean` that `rw` using `Real.sqrt_sq_eq_abs`; any proof using `push_cast`.
- **V3 delta:** No V3 analogue. Rewriting is a Lean-specific elaboration tactic; software graphs have no concept of "textual substitution at kernel level." This distinction matters because **premise selection for a rewrite goal has different retrieval statistics than for an apply goal** — Lean-Finder embeddings should weight REWRITES_BY differently (probably higher recall, lower precision, since simp lemmas are smaller units).

---

## 4. Type-theoretic relationships (3)

These capture Lean's dependent type system. No V3 analogues — the software ontology has no type-level structure of this kind.

### 4.1 `HAS_TYPE`

- **Signature:** `Definition → Structure` (or `→ Class`, `→ Namespace-level type constant`)
- **Cypher:** `HAS_TYPE`
- **Definition:** A definition's declared type is a structure or class — `def foo : MyStructure := ...`. The structure is the ambient container for the field.
- **Example:** `computationalUncertaintyBound` at `Irrationality/Uncertainty.lean:53` has type `ErrorBound` — a structure HAS_TYPE arrow `computationalUncertaintyBound → ErrorBound`.
- **V3 delta:** No V3 analogue. Software has `EXTENDS` (inheritance) but not "this variable's declared type is X" as a graph edge. For Lean this edge is how we know which structures are actually used.

### 4.2 `CONSTRAINED_BY`

- **Signature:** `Theorem → Class` (or `Definition → Class`)
- **Cypher:** `CONSTRAINED_BY`
- **Definition:** The declaration's signature has a type-class constraint, e.g., `theorem foo [Field α] (x : α) : ...`. The proof uses instance search on α to discharge the constraint.
- **Example:** Any theorem `[Fintype α] → ...` in OmegaTheory's ergodic machinery; `[LinearOrder α]` constraints in `Spacetime/CausalLattice.lean`.
- **V3 delta:** Closest to V3 CONSTRAINS (Rule→Process), but reversed in direction and different in mechanism. V3 CONSTRAINS is "a rule restricts a process"; CONSTRAINED_BY in Lean is "a declaration depends on a class witness being findable." Direction: V3 Rule→Process; Lean Theorem→Class.

### 4.3 `PARAMETRIZES`

- **Signature:** `Definition → Structure` (or `Theorem → Structure`, `Definition → Definition`)
- **Cypher:** `PARAMETRIZES`
- **Definition:** A declaration takes another declaration as a parameter in its signature — `def foo (p : HealingParams) : ℝ := ...`. The structure itself is a parameter, not a constraint.
- **Example:** `einstein_tensor_emergence (params : HealingParams)` at `Emergence/EinsteinEmergence.lean:327` — `einstein_tensor_emergence PARAMETRIZES HealingParams`.
- **V3 delta:** Partial overlap with V3 CONFIGURED_BY (Process→Context), but CONFIGURED_BY is runtime configuration pull; PARAMETRIZES is compile-time argument. Different mechanics, different cost to the elaborator.

---

## 5. Computational relationships (3)

These capture the elaboration pipeline, unique to Lean.

### 5.1 `REDUCES_TO`

- **Signature:** `Definition → Definition` (or `Definition → Theorem` in `Decidable` instances)
- **Cypher:** `REDUCES_TO`
- **Definition:** Kernel-level `whnf` (weak-head normal form) of D₁ unfolds to a term referencing D₂. Stronger than UNFOLDS (which is tactical): REDUCES_TO is the kernel's own reduction.
- **Example:** `l_P REDUCES_TO Real.sqrt (hbar * G_N / c^3)`; any `abbrev` reduces to its body at `whnf`. `computationalUncertaintyBound REDUCES_TO ⟨computationalUncertainty N, computationalUncertainty_nonneg N⟩`.
- **V3 delta:** No analogue. Kernel reduction is Lean-specific.

### 5.2 `ELABORATES_AS`

- **Signature:** `Definition → Theorem` (or `Theorem → Theorem` for tactic proof-term expansion)
- **Cypher:** `ELABORATES_AS`
- **Definition:** An anonymous constructor, `show` block, or tactic proof produces under the hood a term that invokes a named theorem. The surface syntax hides it; elaboration exposes it.
- **Example:** Uses of `positivity` in proofs elaborate into applications of `pos_of_mul_pos_left` and similar; these edges are recovered post-elaboration by reading the proof term via `pp.all`.
- **V3 delta:** No analogue. Elaboration is a macro-expansion process unique to Lean's surface-syntax ↔ core-expression split.

### 5.3 `SUGGESTED_BY`

- **Signature:** `Theorem → Theorem`
- **Cypher:** `SUGGESTED_BY`
- **Definition:** An automated tactic (`exact?`, `apply?`, `aesop`, `hammer`) finds the target theorem as a candidate for closing a goal. This is a *retrieval* edge, not a proof-content edge — it captures which theorems are suggested to a user by tooling. Weight reflects the tactic's confidence.
- **Example:** For any theorem in `Predictions/`, running `exact?` inside the proof sketch would yield a SUGGESTED_BY fan-in set of Mathlib lemmas. This edge is what **Lean-Finder's retrieval pipeline populates** — it is the graph-augmented premise-selection signal.
- **V3 delta:** No analogue. Software has no equivalent of "the IDE guessed this for you." In Lean, this is a first-class edge type because Lean-Finder's whole purpose is to populate it with high-quality candidates.

---

## 6. Arrow count & comparison with V3

| Category | V3 count | Lean count | Kept / adapted / dropped |
|---|:---:|:---:|---|
| Structural | 5 | 4 | IMPORTS, EXTENDS kept; IMPLEMENTS→INSTANTIATES; OPENS_NAMESPACE added; INJECTS + TESTED_BY dropped |
| Behavioral | 8 | 2 | APPLIES ~ CALLS; UNFOLDS ~ USES; dropped: PERFORMS, MODIFIES, CREATES, TRIGGERS, INITIATES, CONFIGURED_BY |
| Governance | 4 | 3 | CONSTRAINED_BY ~ CONSTRAINS; ASSUMES (new); dropped: VALIDATES, GOVERNS, APPLIES_IN |
| Additional 6-Entity | 5 | 2 | PARAMETRIZES, HAS_TYPE (new); dropped: ACCESSES, SUBSCRIBES_TO, AFFECTS, OCCURS_IN, SCOPES |
| (New to Lean) | 0 | 4 | REDUCES_TO, ELABORATES_AS, SPECIALIZES, REWRITES_BY, SUGGESTED_BY |
| **Total** | **22** | **15** | |

## 7. What was dropped — and why

The V3 arrows we drop fall into three classes:

**(a) Runtime-imperative arrows.** PERFORMS, CALLS-as-side-effect, MODIFIES, CREATES, TRIGGERS, INITIATES, AFFECTS assume mutable state, event dispatch, or side-effectful IO. Lean has none of these — a proof is a pure function-term, not a runtime program. Shoehorning them would give us edges that never fire (INITIATES across a Lean corpus would be ≈ 0).

**(b) Software-architecture arrows.** INJECTS (dependency injection), TESTED_BY (JUnit test linkage), SUBSCRIBES_TO (event bus), OCCURS_IN (temporal context) are patterns of the Spring Boot / microservice world. Lean has no DI container, no runtime event bus, and tests are themselves ordinary theorems (`example : 1 + 1 = 2 := rfl`) that would be edges like any other APPLIES.

**(c) Governance arrows.** VALIDATES, GOVERNS, APPLIES_IN, SCOPES are how a Rule modulates a Process at runtime (validator beans, `@Transactional`, profile annotations). In Lean, these collapse either to `CONSTRAINED_BY` (type-class-driven discipline) or to `PARAMETRIZES` (explicit parameter). The fine-grained distinctions do not survive the runtime→compile-time projection.

## 8. Why **15** specifically

V3 has 17 typed relationships plus 5 structural = 22. We have 11 typed plus 4 structural = 15. Two observations:

1. **The typed:structural ratio stays >2:1** (V3: 17:5 = 3.4; Lean: 11:4 = 2.75). This is what HypatiaBasis §7 identifies as the "non-triviality condition" for the graph to be non-abelian: enough typed arrows that there exist non-commuting compositions.
2. **Preserves 6×6 = 36 block structure with occupancy ≥ 40%.** V3 reports 14/36 = 38.9% block density. Our naïve count (preliminary, to be verified in file 08 empirically) is 6×6 → 14–18 occupied blocks based on the 15 relations. This keeps the algebra in the "rich but sparse" regime where the commutator subalgebra is non-trivial but not everything-composes-with-everything.

## 9. Direction polarity — by category

| Category | Typical direction | Exceptions |
|---|---|---|
| Structural | Namespace→Namespace (lexical) | EXTENDS, INSTANTIATES are directed by inheritance |
| Dependency | Theorem → {anything downstream in the proof DAG} | ASSUMES is strictly Theorem→Axiom |
| Type-theoretic | Declaration → Type-bearer | HAS_TYPE and CONSTRAINED_BY both point *at* the type |
| Computational | Original → elaborated-or-reduced form | REDUCES_TO is asymmetric; ELABORATES_AS is asymmetric |

All 15 relations have a **defined polarity** (no symmetric relationships without bidirectional reverse). V3 had two bidirectional pairs (TRIGGERS/INITIATES and APPLIES_IN/SCOPES). We hypothesize two for Lean: **SPECIALIZES / GENERALIZES** and **UNFOLDS / FOLDS** — but these are Sarin-Beta's concern (file 05) and Merak's to verify empirically.

## 10. Edge properties

Each edge in Neo4j should carry:
- `weight: Float` — per-instance strength (default 1.0; `APPLIES` from a 172-line proof might weight higher than a 2-line lemma's single APPLIES)
- `position: Int` — line number of the reference in the tail's source
- `extracted_by: String` — `"kernel"` (via `lean_verify`), `"tactic_trace"`, `"syntax_parse"`, or `"lean_finder_reranker"`
- `confidence: Float ∈ [0,1]` — for SUGGESTED_BY only, from the reranker score

Kernel-extracted edges (weight ≥ 1.0, confidence = 1.0) are *the ground truth*. Tactic-trace and LSP-extracted edges are inspectable but sometimes miss macro expansions. Lean-Finder-populated edges (SUGGESTED_BY only) are explicitly probabilistic.

---

## Amended 2026-04-18 evening — Level B + C extensions (15 → 20 arrows)

The **15-arrow set in §1–§10 is the *core* algebra**. Level B + C add 5 more arrows, for a live total of **20 typed relationships**:

```
Structural              (I)    4   (IMPORTS, OPENS_NAMESPACE, EXTENDS, INSTANTIATES)
Dependency              (II)   5   (ASSUMES, APPLIES, UNFOLDS, SPECIALIZES, REWRITES_BY)
Type-theoretic          (III)  3   (HAS_TYPE, CONSTRAINED_BY, PARAMETRIZES)
Computational           (IV)   3   (REDUCES_TO, ELABORATES_AS, SUGGESTED_BY)
Behavioral              (V)    2   (USES_TACTIC, TAGGED_AS)                     -- Level B
Symmetric-pair witness  (VI)   3   (MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR)    -- Level C
                        ─────
                        20
```

Both new categories are **live edges on the declaration graph**; they do NOT require new `QuiverArrow` schema nodes in `LeanAlgebra` (per 2026-04-18 evening verification: `MATCH (a:QuiverArrow {namespace:'LeanAlgebra', name:'USES_TACTIC'|'TAGGED_AS'|'MUTUALLY_IMPLIES'|'DUAL_OF'|'ADDITIVE_PAIR'}) RETURN count(*)` returns 0 across all five). The reason: Level B/C arrows connect to meta-entities (Tactic, Attribute) that are themselves extension-level; introducing them as QuiverArrow schema rows would imply core-ontology participation, which §9 of memo 01 explicitly avoids.

### 11. Level B — behavioral arrows (2)

Category **V. Behavioral** — arrows from kernel-level declarations (Theorem/Definition/Structure/Instance/Axiom) to the meta-layer (Tactic or Attribute).

#### 11.1 `USES_TACTIC`

- **Signature:** `Theorem | Definition → Tactic`
- **Cypher:** `USES_TACTIC`
- **Live edge count (2026-04-18):** 285,581
- **Definition:** A declaration's proof body or definition body contains a tactic invocation. Extracted by parsing `by <tac>` blocks at Phobos-Iota's arrow extractor. Weight = number of invocations in that body; default 1.
- **Example:** `einstein_tensor_emergence` uses `linarith`, `positivity`, `ring` in multiple blocks — one `USES_TACTIC` edge per unique tactic, weighted by count.
- **Level:** B (behavioral). No QuiverArrow schema node — Tactic is the target and is itself Level-B.
- **Why added:** Premise selection conditioned on "close this goal with `ring`" needs the tactic corpus as a retrievable graph layer. Not expressible in 15 core arrows.

#### 11.2 `TAGGED_AS`

- **Signature:** `Theorem | Definition | Structure | Instance | Axiom → Attribute`
- **Cypher:** `TAGGED_AS`
- **Live edge count (2026-04-18):** 12,872
- **Definition:** A declaration carries a Lean attribute. Extracted from `@[<attr>]` source prefixes. One `TAGGED_AS` edge per attribute per declaration.
- **Example:** `Nat.add_comm` is `TAGGED_AS` `@[simp]`, `@[to_additive]`. Each generates one edge.
- **Level:** B (behavioral). No QuiverArrow schema node — Attribute is the target and is Level-B.
- **Why added:** The simp-set retrieval, `@[to_additive]` pair discovery (which drives Level C's ADDITIVE_PAIR), and deprecation scanning all depend on TAGGED_AS being a first-class edge.

### 12. Level C — symmetric-pair witnesses (3)

Category **VI. Symmetric-pair witnesses** — bidirectional arrows that encode **explicit 𝔰𝔲(2) cycles**. Memo 05 §5.4 predicts these emerge *spectrally* from `T^(g) = exp(i · 2π · g · D)` at `g = 1/4` on the core 15 arrows. Level C materializes the *empirical witnesses* of those cycles as live edges, giving the Magnetic Laplacian explicit 𝔰𝔲(2) generators to match the spectral hypothesis.

#### 12.1 `MUTUALLY_IMPLIES`

- **Signature:** `Theorem ↔ Theorem` (bidirectional — extractor emits both directions)
- **Cypher:** `MUTUALLY_IMPLIES`
- **Live edge count (2026-04-18):** 2,082
- **Definition:** Extracted from name pattern `foo_iff_bar`. The Mathlib convention `_iff_` separates the LHS of an `↔` from the RHS; both halves of the biconditional are available as single theorems (`foo_iff_bar` and `foo_iff_bar.mp` / `.mpr`). The MUTUALLY_IMPLIES edge records that the two sides are logically equivalent *at the theorem level* (not just tactically).
- **Example:** `div_lt_iff₀` with sides `a/b < c` and `a < c*b` — the edge materializes as `div_lt_iff_lhs MUTUALLY_IMPLIES div_lt_iff_rhs` (both directions).
- **Level:** C. Symmetric by construction — extractor emits `A → B` and `B → A` together.

#### 12.2 `DUAL_OF`

- **Signature:** `Theorem ↔ Theorem` or `Definition ↔ Definition` (bidirectional)
- **Cypher:** `DUAL_OF`
- **Live edge count (2026-04-18):** 7,786
- **Definition:** Extracted from name suffix pair. A pair `(X_left, X_right)` or `(X_pos, X_nonneg)` on otherwise identical names yields a `DUAL_OF` edge between them. Suffix patterns covered: `_left/_right`, `_pos/_nonneg`, `_lt/_le`, `_fst/_snd`, `_min/_max`, `_succ/_pred`, `_mem/_not_mem`, `_eq/_ne`, `_top/_bot`, `_inf/_sup`, `_zero/_one`, `_head/_tail`, `_first/_last`, `_in/_out`.
- **Example:** `And.left DUAL_OF And.right`; `lt_of_le_of_ne DUAL_OF lt_of_ne_of_le`; `Finset.min_le DUAL_OF Finset.le_max`.
- **Level:** C. Symmetric by construction.

#### 12.3 `ADDITIVE_PAIR`

- **Signature:** `Theorem ↔ Theorem` (bidirectional)
- **Cypher:** `ADDITIVE_PAIR`
- **Live edge count (2026-04-18):** 3,788
- **Definition:** Extracted from Mathlib's `@[to_additive]` machinery plus name substitution table: `mul/add`, `Mul/Add`, `prod/sum`, `smul/vadd`, `pow/nsmul`, `one/zero`, `Monoid/AddMonoid`, `Group/AddGroup`, `CommMonoid/AddCommMonoid`, `CommGroup/AddCommGroup`, etc. Produces an edge between the multiplicative form and its additive dual.
- **Example:** `mul_comm ADDITIVE_PAIR add_comm`; `Monoid.pow_succ ADDITIVE_PAIR AddMonoid.nsmul_succ`; `prod_congr ADDITIVE_PAIR sum_congr`.
- **Level:** C. Symmetric by construction — extractor emits both directions after applying the substitution.

### 13. Why these 5 — and why as edges, not schema nodes

The three Level C arrows (MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR) are **the explicit 𝔰𝔲(2) witnesses** Sarin-Beta's memo 05 §5.4 predicted emerge spectrally. Importantly:

- Memo 04 §5.4 predicted that raising/lowering ±i cycles would arise from the phase factor `T^(g) = exp(i · 2π · g · D)` at `g = 1/4` applied to the 15 core arrows.
- Level C adds **explicit, extractor-harvested edges** encoding the same cycles where they can be detected from name patterns.
- The expected empirical effect is that the Magnetic Laplacian's off-diagonal ±i entries **sharpen** — instead of being diffused over the full core 15-arrow spectrum, the 𝔰𝔲(2) pair contribution is concentrated on the 13,656 Level C edges.

The 5 arrows are stored as live edges with cypher labels `USES_TACTIC`, `TAGGED_AS`, `MUTUALLY_IMPLIES`, `DUAL_OF`, `ADDITIVE_PAIR`, **not** as new `QuiverArrow` schema rows. The 15 core `QuiverArrow` nodes in the `LeanAlgebra` namespace are intentionally preserved — Level B/C arrows live **on the data graph**, not on the schema graph. This separation mirrors the vertex-type separation: 6 core `QuiverVertex` nodes + 2 Level B meta-vertices, 15 core `QuiverArrow` rows + 5 data-level Level B/C edge-types.

### 14. Updated category inventory table

| Category | V3 count | Core-only | Level B + C | Total |
|---|:---:|:---:|:---:|:---:|
| I. Structural | 5 | 4 | — | 4 |
| II. Dependency | 8 | 5 | — | 5 |
| III. Type-theoretic | 4 | 3 | — | 3 |
| IV. Computational | 0 | 3 | — | 3 |
| V. Behavioral (Level B) | — | — | 2 | 2 |
| VI. Symmetric-pair witness (Level C) | — | — | 3 | 3 |
| **Total** | **22** | **15** | **5** | **20** |

### 15. Polarity of the 5 new arrows

| Arrow | Directionality | Extraction polarity |
|---|---|---|
| `USES_TACTIC` | uni-directional: decl → Tactic | one edge per (decl, tactic) pair |
| `TAGGED_AS` | uni-directional: decl → Attribute | one edge per (decl, attribute) pair |
| `MUTUALLY_IMPLIES` | **bidirectional** (extractor emits both) | semantic equivalence |
| `DUAL_OF` | **bidirectional** (extractor emits both) | suffix duality |
| `ADDITIVE_PAIR` | **bidirectional** (extractor emits both) | mul↔add substitution |

Category V arrows are hub-oriented (meta-vertex sinks). Category VI arrows are explicitly symmetric — the extractor writes `A → B` and `B → A` together, unlike core arrows where the direction encodes an asymmetric proof-time consumption.
