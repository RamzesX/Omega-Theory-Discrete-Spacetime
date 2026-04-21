# 03 — Method: the `LeanAlgebra` Schema and the Magnetic-Laplacian Lens

This section defines the algebraic backbone of V3-for-Lean. It is
deliberately *data-free*: the schema below describes the **shape of Lean
as a typed multigraph** and the algebraic laws that any valid proof chain
respects. Declarations enter in $\S 4$ (embeddings) and $\S 5$ (consumer
enrichment).

## 3.1 Six entity types

We partition every Lean 4 declaration into exactly one of six entity
types, ordered alphabetically so that the Magnetic-Laplacian matrix
$\mathfrak{A}$ has a canonical basis.

| # | Entity type | Lean surface | Role |
|---|---|---|---|
| 1 | `Axiom` | `axiom` | Irreducible postulates (OmegaTheory V2: $8$ physical) |
| 2 | `Definition` | `def`, `abbrev`, `notation` | Named constructors |
| 3 | `Instance` | `instance` | Typeclass witnesses |
| 4 | `Namespace` | `namespace $X$ ... end $X$` | Scoping containers |
| 5 | `Structure` | `structure`, `class`, `inductive` | Types and typeclasses |
| 6 | `Theorem` | `theorem`, `lemma`, `example` | Propositions with proof term |

**Design rationale.** The six-entity cut is the smallest partition that
(a) is recoverable from Lean's elaboration environment without regex,
(b) respects the distinction between proof-carrying data (`Theorem`) and
type-carrying data (`Structure`), and (c) separates typeclass witnesses
(`Instance`) from the class declaration (`Structure`) because their
downstream behaviour in a proof chain is very different. The
`Namespace` node is introduced to carry import structure at a coarser
grain than per-file.

## 3.2 Fifteen typed arrows

Arrows are grouped into four semantic categories.

### 3.2.1 Structural (4)

| Arrow | Source → Target | Meaning |
|---|---|---|
| `IMPORTS` | `Namespace` → `Namespace` | `import $A$.$B$` |
| `OPENS_NAMESPACE` | `Theorem`/`Definition`/... → `Namespace` | `open $X$` scope |
| `EXTENDS` | `Structure` → `Structure` | `extends` clause |
| `INSTANTIATES` | `Instance` → `Structure` | class witness for |

### 3.2.2 Dependency (5)

| Arrow | Source → Target | Meaning |
|---|---|---|
| `ASSUMES` | `Theorem` → `Axiom` | transitive axiom dependency |
| `APPLIES` | `Theorem` → `Theorem`/`Definition` | term-level application (`f $x$`) |
| `UNFOLDS` | `Theorem` → `Definition` | `unfold $d$` or reducibility |
| `SPECIALIZES` | `Theorem` → `Theorem` | instance of a more general theorem (semantic) |
| `REWRITES_BY` | `Theorem` → `Theorem` | used in `rw [...]`, `simp only [...]`, etc. |

### 3.2.3 Type-theoretic (3)

| Arrow | Source → Target | Meaning |
|---|---|---|
| `HAS_TYPE` | any declaration → `Structure`/`Definition` | head of the type constructor |
| `CONSTRAINED_BY` | `Theorem`/`Definition` → `Structure` | typeclass constraint |
| `PARAMETRIZES` | `Theorem`/`Definition` → `Structure` | binder type of parameter |

### 3.2.4 Computational (3)

| Arrow | Source → Target | Meaning |
|---|---|---|
| `REDUCES_TO` | `Theorem` → `Theorem` | $\beta\delta\iota$-reduces to |
| `ELABORATES_AS` | `Definition` → `Definition` | `@[reducible]` or `abbrev` chain |
| `SUGGESTED_BY` | `Theorem` → `Theorem` | co-occurrence in `simp` / `aesop` call-graph |

## 3.3 Selection rules

Seven `HARD_BLOCK` selection rules encode compositions that a valid proof
chain **cannot** perform. They are listed in `LeanAlgebra.SelectionRule`:

1. `REWRITES_BY` $\circ$ `HAS_TYPE` is forbidden (cannot rewrite along a type projection).
2. `INSTANTIATES` $\circ$ `INSTANTIATES` is forbidden (instance search is not chainable).
3. `OPENS_NAMESPACE` $\circ$ `APPLIES` is forbidden (opening a namespace is lexical, not semantic).
4. `IMPORTS` $\circ$ {any dependency arrow} is forbidden (imports close under composition only via namespaces).
5. `ASSUMES` $\circ$ {any outgoing arrow from `Axiom`} is forbidden (axioms have no proof term to follow).
6. `UNFOLDS` $\circ$ `REDUCES_TO` forbidden in `UNFOLDS`-direction (reduction is one-way).
7. `SUGGESTED_BY` $\circ$ `SPECIALIZES` forbidden (suggestion is a co-occurrence heuristic, not a specialisation chain).

These rules live as `:SelectionRule` nodes in Neo4j with a `forbids`
property naming the two arrow types whose composition is blocked, an
`enforcement` field (`HARD_BLOCK`), and a `rationale` docstring. They are
consulted by the gap hunter before any bridge candidate is emitted (cf.
memo `proof_hunter_design_v2.md` §7).

## 3.4 Twelve depth-two canonical compositions

At depth $2$, twelve compositions are declared **canonical** — they carry
a human-readable `category_label` and may be used as provenance paths by
the `:GrothendieckRecipe` bookkeeping layer. Example:

$$
(\text{APPLIES})\circ(\text{UNFOLDS}) \;\in\; \text{"expansion-then-application"}
$$

The full table lives in `OmegaTheoryAlgebra/03_selection_rules.md`; it is
reproduced as a `:QuiverComposition` bundle in the Neo4j graph.

## 3.5 The Magnetic Laplacian $\mathfrak{A}$

On the vertex basis $V = \{\text{Axiom}, \text{Definition}, \text{Instance},
\text{Namespace}, \text{Structure}, \text{Theorem}\}$ (alphabetical) we
construct a $6 \times 6$ Hermitian matrix

$$
\mathfrak{A} \;=\; D - W \odot e^{i g \Theta}
$$

where $W$ is the symmetric weighted adjacency (sum of arrow counts with
ontology weights), $\Theta$ is the asymmetric *phase* matrix encoding
directionality of the fifteen arrow types, $g = 1/4$ is the magnetic
coupling, and $D = \mathrm{diag}(W \cdot \mathbf{1})$ is the degree matrix.
The choice $g = 1/4$ is motivated in $\S 3.7$; briefly, it is the smallest
non-trivial phase for which all fifteen arrows contribute non-degenerately
to the principal spectrum.

**Hermiticity audit.** The live Cypher verification is:

```cypher
MATCH (l:MagneticLaplacian {namespace:'LeanAlgebra', name:'MagneticLaplacian_Lean'})
WITH l,
     [i IN range(0,5), j IN range(0,5) WHERE i < j |
        [l.imag_part[6*i + j], -l.imag_part[6*j + i]]] AS pairs,
     [i IN range(0,5) | l.imag_part[6*i + i]] AS diag
RETURN
  all(p IN pairs WHERE abs(p[0] - p[1]) < 1e-9) AS anti_sym_off_diag,
  all(d IN diag  WHERE abs(d) < 1e-9)          AS zero_diag
```

both of which return `true` on the current snapshot.

## 3.6 Rank-two per-relation decomposition

Each arrow type $k \in \{1, \ldots, 15\}$ contributes a rank-$2$ block

$$
\mathfrak{A}_k \;=\; u_k v_k^\dagger + v_k u_k^\dagger
$$

where $u_k, v_k$ are indicator vectors of the arrow's source and target
entity types, respectively. The global Laplacian is the sum

$$
\mathfrak{A} \;=\; \sum_{k=1}^{15} w_k \,\mathfrak{A}_k
$$

with per-relation weights $w_k$ proportional to observed arrow count
(normalised so that $\sum_k w_k = 1$). This decomposition is the bridge
between the *abstract* algebra ($\S 3.2$ arrows) and the *empirical*
weighting ($\S 4$).

**Non-commutativity measure.** For arrows $k, l$ the anti-commutator
excess

$$
\mathrm{nc}(k, l) \;=\; \frac{\|[\mathfrak{A}_k, \mathfrak{A}_l]\|_F}{\|\{\mathfrak{A}_k, \mathfrak{A}_l\}\|_F}
$$

measures how far the pair is from commuting. Summed over pairs, this
yields the global non-commutativity rate (reported as $73.3\%$ in the
cycle-43 snapshot — see the abstract and $\S 6$).

## 3.7 FastRP coupling via $\alpha_k$

The FastRP random-projection embedding (dimension $m = 64$ per relation,
seed $42$) is parametrised by per-relation propagation weights
$\alpha_k$ derived from the Magnetic-Laplacian residual:

$$
\alpha_k \;=\; \frac{\mathrm{tr}(\mathfrak{A}_k \mathfrak{A}^\dagger)}{\mathrm{tr}(\mathfrak{A} \mathfrak{A}^\dagger)} \cdot \alpha_{\text{base}}
$$

with $\alpha_{\text{base}} = 1.0$ and a propertyRatio of $0.5$. The top
coefficient on the current corpus is $\alpha_{\text{UNFOLDS}} = 2.20$,
which identifies `UNFOLDS` as the most *structurally informative* arrow
for the corpus-level embedding — consistent with the observation that
every Lean proof that invokes a definition must first unfold it, making
`UNFOLDS` the spine of the dependency graph.

## 3.8 Leiden on the shared projection

Leiden (Traag, Waltman, van Eck 2019) is run at resolution
$\gamma = 0.5$, random seed $42$, on the symmetric projection

$$
G_{\text{proj}} \;=\; \left( V_{\text{Theorem} \cup \text{Definition}},\ E_{\text{APPLIES}} \cup E_{\text{UNFOLDS}} \right)
$$

restricted to the OmegaTheory V2 namespace (plus imports from Mathlib). On
the cycle-$43$ snapshot this produces

| Statistic | Value |
|---|---|
| nodes | $11{,}921$ |
| communities | $116$ |
| modularity $Q$ | $0.89$ |
| levels run | $5$ |
| top-$10$ community sizes | $[1648, 1362, 1034, 843, 775, 678, 664, 614, 506, 371]$ |
| gap at rank $4$ vs $5$ | $1.09$ (*no* sharp four-band gap) |
| gap at rank $14$ vs $15$ | $1.48$ (dominant break — suggests $\approx 14$ macro-subsystems) |

The rank-$14$ break is the Leiden equivalent of a phase transition: below
rank $14$ the community size decays gently, above it drops off sharply.
We therefore treat the top-$14$ communities as *macro-subsystems* and
materialise them as `:SubsystemNavigator` nodes for the Erdős-tier
enrichment described in $\S 5$.

## 3.9 Fibered four-channel structure

We now state the paper's single most important empirical claim.

**Claim.** The four-irrational channel
$\mathcal{I} = \{\pi, e, \sqrt{2}, G\}$ does not *partition* the
OmegaTheory V2 corpus. It *fibers* over the Leiden base:

$$
\Omega \;\cong\; \mathrm{Subsystem} \;\times_\sim\; \mathrm{IrrationalChannel}
$$

with Subsystem ($\approx 14$ macro-subsystems from $\S 3.8$) as base and
IrrationalChannel ($|\mathcal{I}| = 4$) as fiber.

**Evidence.**

*(i) Community-size distribution has no four-band gap.* The rank-$4$
versus rank-$5$ gap ratio is $1.09$ (close to unity); the dominant gap
is at rank $14$. If the four-channel hypothesis were partitional it
should produce a dominant gap at rank $4$.

*(ii) Channel-wise FastRP norm ordering is crisp.* Averaging
$\|v_t\|_2^2$ of the FastRP embedding over theorems whose name hits a
channel keyword:

| Channel | $n$ (theorems) | $\langle \|v\|^2 \rangle$ |
|---|---|---|
| $\pi$ | $242$ | $3.099$ |
| Catalan-$G$ | $29$ | $2.363$ |
| $\sqrt{2}$ | $51$ | $1.694$ |
| other | $6{,}912$ | $3.255$ |

The ordering $\|v_\pi\|^2 > \|v_G\|^2 > \|v_{\sqrt{2}}\|^2$ matches the
theoretical residual-$\delta$ ordering of the Pi Hunch.

*(iii) Channel membership is distributed across multiple Leiden
communities.* If the partition were rigid, each channel would sit in a
distinct community. Instead, channel-keyword theorems are distributed
across at least eight Leiden communities each.

**Physical interpretation.** The fibered structure is evidence that the
four irrationals are not primitive partitions of physics but rather
*section-giving functors* out of a common base — each irrational defines
a way to section the theorem corpus that runs orthogonal to the
subsystem axis. The statement formalised in
`four_channel_fibration_over_subsystem` (see Navi's Grothendieck Math
Puzzle, MP-5) is exactly this.

## 3.10 Summary

The algebraic backbone of V3-for-Lean is

- six entity types,
- fifteen typed arrows in four semantic categories,
- seven HARD-BLOCK selection rules,
- twelve depth-two canonical compositions,
- a $6\times 6$ Hermitian Magnetic-Laplacian with $g = 1/4$,
- a rank-$2$ per-relation decomposition with explicit non-commutativity measure,
- FastRP propagation weights $\alpha_k$ derived from the Laplacian residual,
- Leiden at $\gamma = 0.5$ with $116$ communities and $Q = 0.89$,
- a *fibered* four-irrational channel structure over a $\approx 14$-community base.

All subsequent sections ($\S 4$ embeddings, $\S 5$ consumer enrichment,
$\S 6$ experiments) operate on top of this backbone; none of them
requires re-deriving any of it.
