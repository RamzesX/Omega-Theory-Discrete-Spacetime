---
name: 07_single_lens_rationale
date: 2026-04-18
author: Sarin-Beta (Nunki, σ Sagittarii)
parent: OmegaTheoryAlgebra Phase 0
status: design decision memo
---

# 07. Why We Drop V3's 3-Lens Overlay and Use a Single Lean-Specialized Embedder

**TL;DR.** V3 runs three concurrent embeddings per file (structural / semantic / behavioral Information Lensing) because software files have genuinely distinct views: the same class is a type, a call target, and a config consumer all at once. Lean mathematics does not have that ambiguity — a theorem *is* its type, a definition *is* its term. One lens — Lean-Finder (delta-lab-ai, ICLR 2026, [arXiv:2510.15940](https://arxiv.org/abs/2510.15940)) — is enough, trained natively on 1.4M Lean Zulip query–code pairs with +30% retrieval improvement over ReProver. This memo states the rationale, the explicit fallback trigger, and what we give up.

## 1. Why V3 needs three lenses

V3's Information Lensing (Marchewka 2025, cited in HypatiaBasis §7.4) recognizes that a software file simultaneously plays three roles that point in different semantic directions:

- **Structural lens.** The file as a class/module/namespace — what it extends, where it lives, what it exports.
- **Semantic lens.** The file as meaning — what problem it solves, what the tokens say.
- **Behavioral lens.** The file as an acting object — what it calls, what it modifies, what events it triggers.

A `NotificationService.java` is, in practice, three objects: a DI target (structural), a text blob about notifications (semantic), and an async trigger source (behavioral). Those three roles can and do give anti-correlated positions in ℝ^4096 — which is precisely why V3 trains per-relation sub-topologies on top of a 3-lens input. The three lenses are not redundancy; they are three genuinely different projections of an ambiguous underlying object.

## 2. Why Lean does not need three lenses

In Lean 4, the same files carry a much tighter semantics:

- A `theorem` or `lemma` **is** its type (Curry–Howard: the type is the proposition, the term is the proof).
- A `def` or `abbrev` **is** its unfolded term (up to reducibility).
- There is no "behavioral" vs. "structural" split inside a single declaration: the theorem's namespace, its dependencies, and its statement are all reflected in one syntactic object whose tokenization is unambiguous.

The ambiguity V3 needs three lenses to unpack does not exist at declaration granularity. The typed quiver approach still matters — relations between declarations carry directionality, order, and selection rules (this is the whole premise of `02_relationships.md` and file `05`). But the per-node embedding can be a single vector without losing information.

One lens is enough, provided that lens is **Lean-aware** — trained on Lean-specific syntax, notation, and the Mathlib style of statement formulation.

## 3. Lean-Finder as the lens

Lean-Finder (delta-lab-ai, ICLR 2026, [arXiv:2510.15940](https://arxiv.org/abs/2510.15940)) is trained contrastively on 1.4M query–code pairs harvested from Lean Zulip and GitHub discussions. The training signal is "informal question → formal Lean statement" alignment, which is exactly the retrieval task premise-selection algorithms (Rango ICSE 2025, LeanAgent ICLR 2025) depend on. Reported relative improvement is +30% over prior Lean retrievers including ReProver and GPT-4o on real-world user queries.

Why this matters for us:
- **Native Lean tokenization.** Lean-Finder understands `∀ x ∈ Finset.range n, f x = 0`, `@[simp]`, `·.1`, `term ▸ proof`, tactic blocks, and the Mathlib deprecation convention. A general embedder (Qwen3-8B, BGE-M3, Qwen3-Embedding-8B) tokenizes these as adversarial whitespace-and-punctuation streams.
- **Intent alignment built in.** Zulip queries are messy natural language ("I want to prove something like…"); Lean-Finder was trained precisely to bridge that to Mathlib names. That is the consumer profile for both theorem discovery and premise selection in our graph.
- **Embedding cost drop of 3×.** One encoder pass per declaration instead of three. Over 243K nodes this is material — at ~100 ms per call, saving ~2/3 of ~7 hours of embedding compute.
- **Alignment complexity drop.** V3's 3-lens pipeline has to concatenate or average three per-lens vectors before FastRP can ingest them, introducing extra hyperparameters (lens weights, normalization convention). Single-lens FastRP has none of that.

## 4. What we give up

Two things, honestly:

- **The "structural vs. semantic" anti-correlation that V3 uses as a diagnostic.** In V3, when structural and semantic lenses anti-correlate, the file is a boundary artifact (e.g., a facade, an adapter). That diagnostic vanishes. We replace it with the per-relation anti-correlation signal from file 05 — which is strictly richer if the 𝔰𝔲(2) × 𝔰𝔲(2) hypothesis holds — but the one-shot "this file is confused" tag is gone.
- **Robustness to Lean-Finder distribution shift.** Lean-Finder was trained on current Mathlib + Zulip. OmegaTheory has its own idiomatic notation (δ_comp, ℏ, ℓ_P, 4-lattice operators). The embedder may underperform on this ~3,500-node subset compared to the ~240K Mathlib majority. Mitigation: the FastRP propagation on typed edges (file 06) pulls OmegaTheory nodes into the neighborhood of semantically close Mathlib nodes, so the ℝ^64 final vectors should not be starved of signal even where the raw Lean-Finder vector is weak.

## 5. Models considered and rejected

- **Qwen3-Embedding-8B (ℝ^4096).** Strong general-purpose embedder used by V3. Not trained on Lean. Tokenizes `⊢`, `▸`, `Finset.sum`, and similar as generic Unicode. Rejected because the Lean-specific signal matters more than the generality.
- **BGE-M3 (ℝ^1024).** Multilingual, multi-granularity (dense + sparse + multi-vector). Already supports long documents and near-synonym retrieval. Rejected because Lean-Finder is empirically +30% on the exact task we care about; adding BGE-M3 is either redundant (single-lens) or re-introduces the 3-lens complexity we want to avoid.
- **bge-reranker-v2-m3 + Qwen3-Embedding-8B two-stage.** A retrieval + re-rank pipeline is the default for many AI-for-math setups. Deferred rather than rejected: if single-lens recall on the proof-closing benchmark (§6) is marginal, we add bge-reranker-v2-m3 as a second stage on the top-100 candidates. That is one additional lens for *re-ranking only*, not for embedding — so the per-node storage and FastRP cost stays single-lens.

## 6. Explicit success criterion for keeping single-lens

We keep single-lens if, on a 200-query pilot drawn from OmegaTheory proof states:

- **recall@10 ≥ 70% for premise retrieval** against a held-out ground-truth set of premises actually used to close each proof in OmegaTheory's 2,541 theorems and lemmas.

If recall@10 is below 70% we add a second **type-level lens** (embedding only the declaration's type, ignoring its proof/term body), concatenate with Lean-Finder, and retrain FastRP. That gives us a 2-lens overlay: "what proves this?" (type lens) vs. "what does this prove?" (statement + proof lens). We stop short of V3's 3-lens structure because we have no Lean analogue of the behavioral lens — there is no "trigger side effect" dimension in theorem space.

The 70% threshold is set by precedent: graph-aug premise selection ([arXiv:2510.23637](https://arxiv.org/abs/2510.23637)) reports recall@10 in the high 60s as the useful-for-automation floor on a single-embedder pipeline. We want to match or beat that as our "no-second-lens-needed" trigger.

## 7. What we predict / what could kill this

**We predict:** Lean-Finder as a single lens over the 243K-node graph, combined with FastRP per-relation sub-topologies from file 06, yields recall@10 ≥ 70% on the OmegaTheory premise-retrieval pilot. Per-relation anti-correlations show up at strength comparable to V3 (|cos| ≥ 0.2 for at least one pair), proving that the richness V3 extracts from three lenses is recoverable from one lens plus the typed quiver.

**What kills this.** Pilot recall@10 below 60%, with no clear per-relation structure in the FastRP corrections Δ_k. That would mean we have neither the Lean-native embedding advantage nor the gauge-theoretic structure — and the whole stack reduces to "a mediocre text embedder on a knowledge graph," which is not novel enough to justify the complexity. Fallback path is the 2-lens type-vs-statement overlay described above.

---

*Related decisions:* file 06 (FastRP m = 64) assumes a single 768-dim text embedding as input — consistent with Lean-Finder's output dim. File 10 (Neo4j schema) will store `leanFinderEmbedding: float[768]` as the only per-node text property, replacing V3's `structuralEmbedding`, `semanticEmbedding`, `behavioralEmbedding` triple.

## Sources

- [Lean Finder: Semantic Search for Mathlib That Understands User Intents (arXiv 2510.15940)](https://arxiv.org/abs/2510.15940)
- [Published as a conference paper at ICLR 2026 (Lean Finder PDF)](https://arxiv.org/pdf/2510.15940)
- [Graph-Augmented Premise Selection (arXiv 2510.23637)](https://arxiv.org/abs/2510.23637)
- [DeLTA Lab at UW](https://delta-lab-ai.github.io/index.html)
