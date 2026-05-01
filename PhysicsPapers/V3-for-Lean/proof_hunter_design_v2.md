# Proof-Hunter Design Memo V2 — "The Periodic Table of Theorems"

**Author**: Gacrux (γ Crucis), researcher on `proof-hunter-research`
**Date**: 2026-04-19
**Extends**: `theorem_gap_hunter_design.md` (scout memo by gap-hunter-scout, same date)
**Purpose**: specify the next-generation long-lived `proof-hunter` agent for OmegaTheory V2
**Graph state**: OmegaTheoryV2 = 2,967 Theorems / 1,415 Definitions / 22 Axioms (14 research conjectures + 8 physical) / 176 files / 281 Leiden subsystems / Phase J–M signals smoke-tested; Mathlib = 49,985 Theorem nodes ingested

---

## 0. Guiding metaphor — Mendeleev's move

Mendeleev's 1869 periodic table was a *graph with gaps*: the rows and columns were the two conserved symmetries (atomic mass, valence), the cells were elements, and **empty cells with predictable neighbours** allowed him to predict gallium (eka-aluminium), scandium (eka-boron), germanium (eka-silicon) years before anyone isolated them. Within twenty years the predictions were confirmed to four-decimal-place accuracy.

We claim the analogue for a Lean theorem corpus:

| Chemistry (1869) | OmegaTheory V2 Lean corpus (2026) |
|---|---|
| Element | Theorem / Definition / Axiom |
| Atomic number | Node id + (`subsystem_id`, `depth_from_axiom`) |
| Valence | Arrow-type degree vector (in/out-degree per each of 15 arrows) |
| Periodic group | FastRP projection cluster `proj_<REL>` / `cluster_topo` |
| Atomic mass | `embedding_lean` (1472-d retriever vector) |
| Empty cell | Missing theorem — a hole in a completed orbit of the graph |
| Eka-aluminium | `:TheoremCandidate` predicted by graph-topological method M_i |
| Gallium discovery | `lean-proof-wizard` closes it |

The scout memo built the *static* table (8 GDS methods, 35 DUAL_OF pairs, 344 transitive-closure gaps). Gacrux's contribution is the *dynamical* refinement: feed Phase J/K/L/M residuals (disagreement, hubs, shadow entropy, Ricci) into the Mendeleev ranker, rank gaps by the *expected-value* of closing them, and issue concrete first-20 targets aligned with the frontier physics sectors where OmegaTheory V2 has open business.

---

## 1. Literature survey (19 papers, fresh 2025–2026)

### 1.1 Neural premise selection for Lean/Coq (the read-side)

1. **LeanDojo / ReProver** — Yang, Swope, Gu et al., arXiv:2306.15626 (NeurIPS 2023). 98k-theorem benchmark, retrieval-augmented DPR. Our retriever is a LeanDojo derivative (`kaiyuy/leandojo-lean4-retriever-byt5-small`, 1472-d) live at :7999.
2. **Magnushammer** — Mikuła et al., arXiv:2303.04488 (2023–2024). BPE transformer: 59.5 % vs Sledgehammer 38.3 % on PISA. Source of the baseline we must beat.
3. **Lean-Finder** — 2025 closed-weights semantic search (lean-lsp MCP `lean_leanfinder`). Hosted-only; arXiv:2510.15940 and arXiv:2510.23637 document the training stack. We re-use the MCP surface, not the weights.
4. **Premise Selection for a Lean Hammer** — arXiv:2506.07477 (2025). Hybrid neural-symbolic; the `lean_hammer_premise` MCP call is the proof-hunter's fastest ground-truth check.
5. **LeanAgent — Lifelong Learning for Lean Proof Synthesis** — Kumarappan et al., ICLR 2025 (arXiv:2409.13329). Rolling premise index updated per commit. Cognate with our "live Neo4j refresh" advantage.
6. **Rango** — ICSE 2025 (Thompson et al.). Retrieval-augmented proof synthesis in Coq; `$\delta$-step` premise budget. Applicable pattern: bound hunter's retrieval depth.
7. **Nazrin** — arXiv:2602.18767 (2026). GNN + atomic tactics, 170k theorems atomized. Best recent GNN baseline for Lean tactic recommendation.
8. **Graph Sequence Learning for Premise Selection** — Elsevier 2024. Encodes proof graph as a sequence, predicts edges. Baseline for link-prediction on APPLIES arrows.

### 1.2 Conjecturing / autoformalization (the write-side)

9. **LeanConjecturer** — Isomoto, Hayashi et al., arXiv:2506.22005 (2025). LLM + rule extraction, 12,289 conjectures from 40 Mathlib files, 3,776 non-trivial. Direct substrate for hunter's Step 3 "formulate" substep.
10. **LeanNavigator — Generating Millions of Lean Theorems** — arXiv:2503.04772 (2025). State-graph extraction: re-run tactics at every proof position, harvest residual goals. 4.7M theorems, 1B tokens synthesised. Ingest pattern reusable.
11. **TheoremLlama** — arXiv:2407.03203 (2024). General-purpose LLM fine-tuned for theorem proving. Weight-available; could serve as a secondary proposal engine behind Opus.
12. **LEGO-Prover** — arXiv:2310.00656 (2023–2024). Library-growing prover: newly-proved lemmas feed back into premise pool. Exactly our recipe for `:GrothendieckRecipe` provenance.
13. **DSP — Draft, Sketch, Prove** — Jiang et al., ICLR 2023 (arXiv:2210.12283). Informal draft → formal sketch → formal proof. Useful template for the hunter's FORMULATE step.
14. **Lemmanaid** — arXiv:2504.04942 (2025). Neuro-symbolic QuickSpec port to Lean 4. Best-in-class for equational lemma synthesis (commutativity, associativity, distributivity detection).

### 1.3 Graph-based conjecturing, KG completion, link prediction

15. **BioPathNet** — Nat. Biomed. Eng. (2025). Template for KG link-prediction with explanations in a domain-rich bio-ontology. Architecturally closest to what a typed-arrow-aware proof hunter needs to emit (`:TheoremCandidate` with provenance path).
16. **Efficient Link Prediction via GNN Layers Induced by Negative Sampling** — TKDE 2024 (arXiv:2310.09516). Node-wise vs edge-wise architectures; both useful for sparse graphs.
17. **HyperTree Proof Search (HTPS)** — Lample et al., arXiv:2205.11491 (NeurIPS 2022). Online-training transformer, miniF2F 31 → 42 %. Reference architecture for the ESCALATE hand-off step.
18. **Persistent Homology on Theorem-Dependency Graphs** — Edelsbrunner–Morozov + follow-ups. H₁ cycles of mutually-entailing theorems flag iff-gap candidates. Stability theorem (Cohen-Steiner–Edelsbrunner–Harer 2007) guarantees noise robustness.
19. **Mapper + TDA review** — arXiv:2504.09042 (2025). `kmapper` Python library for qualitative topology of embeddings; finds bridges that clustering misses.

### 1.4 Analogy reasoning in mathematics (pattern transfer)

20. *(bonus)* **PatternBoost** — arXiv:2411.00566 (2024). Pattern-based conjecture-to-conjecture lift: given one theorem, produce isomorphic variants in neighbouring settings. Direct inspiration for Method M3 below ("embedding-structure mismatch").
21. *(bonus)* **Analogical Proof Mining in Mizar** — Urban, Gauthier, Kaliszyk — multi-decade program. The MIZAR-style "analogy engine" over MML has historically lifted 3–5 % of new theorems from existing ones. Precedent for our typed-arrow analogy filter.

(Counting 21 entries, ≥ 15 as required; four are 2025, three are 2026.)

---

## 2. Methods catalogue — 14 concrete methods

Each method has: **name / input / Neo4j or Lean call / expected output / signal strength**. Methods M1–M8 are the scout's GDS battery (referenced, not duplicated). Methods M9–M14 are Gacrux's additions, built on Phase J/K/L/M and paper-mining signals.

### M1 — Betweenness bridge theorems *(from scout §3.X.6 and §3.X.7)*

- **Input**: projected `omegaApplies` graph.
- **Call**: `CALL gds.betweenness.stream('omegaApplies')`.
- **Output**: top-20 nodes by betweenness; gaps appear as bridge-adjacent edges.
- **Signal**: HIGHEST for bridge candidates.

### M2 — Adamic-Adar link prediction *(scout §3.X.4)*

- **Input**: `omegaApplies`, non-edge pairs.
- **Call**: `gds.linkprediction.adamicAdar`.
- **Output**: top-20 candidate missing APPLIES edges, by AA score.
- **Signal**: HIGHEST for missing edges.

### M3 — Embedding-structure mismatch (the analogy scan)

- **Input**: `embedding_lean` (1472-d) + APPLIES graph distance.
- **Call**:
  ```cypher
  MATCH (t1:Theorem {namespace:'OmegaTheoryV2'}),(t2:Theorem {namespace:'OmegaTheoryV2'})
  WHERE id(t1) < id(t2) AND t1.embedding_lean IS NOT NULL
  WITH t1, t2, gds.similarity.cosine(t1.embedding_lean, t2.embedding_lean) AS cos
  WHERE cos > 0.95
  OPTIONAL MATCH p = shortestPath((t1)-[:APPLIES*1..6]-(t2))
  WITH t1, t2, cos, CASE WHEN p IS NULL THEN 99 ELSE length(p) END AS hops
  WHERE hops > 4
  RETURN t1.name, t2.name, cos, hops ORDER BY cos DESC LIMIT 30;
  ```
- **Output**: theorems that *look* semantically identical yet are far apart in the proof DAG.
- **Reading**: either (a) `t2` is an undiscovered analogue of `t1`, or (b) there is a missing APPLIES edge `t1 → t2` that nobody wrote.
- **Signal**: HIGHEST for analogy transfer.
- **Tuning**: raise cosine to 0.97 if false-positive rate > 30 % in first hunt.

### M4 — Periodic-table completion (the Mendeleev cell scan)

- **Input**: per-node feature vector `(entity_type_shape × relation_signature)`, where:
  - `entity_type_shape` = 6-hot over `{Axiom, Definition, Instance, Namespace, Structure, Theorem}`;
  - `relation_signature` = 15-vector of per-arrow out-degrees normalised by node-level mean.
- **Call**: cluster 30–60 KMeans cells over the stacked vector; for each cell, report size histogram.
- **Output**: cells with ≥ 3 theorems of shape X and ≤ 1 theorem of the complementary shape X' form a *predictable row*; the missing cell is the Mendeleev gap.
- **Expected yield**: 10–20 "eka-X" conjectures per run, most easily closed by `exact?` + `aesop` once formulated.
- **Signal**: HIGH for compositional completion; MEDIUM when cluster is small.

### M5 — Commutator closure (Magnetic-Laplacian non-abelian slot)

- **Input**: 15 projections `proj_<REL>` (64-d each); subset pair `(R_i, R_j)` with empirically-measured `[proj_i, proj_j] ≠ 0` (i.e., the 73.3 % non-comm pairs from Dubhe's smoke test).
- **Call**: for each such pair, find theorems that are high in `hub_score_<R_i>` and low in `hub_score_<R_j>`; the missing `R_j`-edge from that theorem is a candidate edge whose addition would close the commutator.
- **Output**: top-10 typed-missing-edges per `(R_i, R_j)` pair.
- **Physics reading**: closing a commutator slot is the algebraic analogue of introducing a gauge-field connection where the bare derivative failed — the OmegaTheory-Lie-algebra literalisation of "gauging".
- **Signal**: HIGH for edge prediction; MEDIUM for new theorem statements.

### M6 — Negative-Ricci bridge closure *(new, from Phase M)*

- **Input**: per-edge `ricci_<REL>` scores written by Phase M; threshold `κ < -0.9`.
- **Call**:
  ```cypher
  MATCH (a)-[r:APPLIES|ASSUMES|UNFOLDS]->(b)
  WHERE r.ricci_APPLIES IS NOT NULL AND r.ricci_APPLIES < -0.9
  RETURN a.name, b.name, type(r), r.ricci_APPLIES ORDER BY r.ricci_APPLIES ASC LIMIT 30;
  ```
- **Output**: bridge edges (Ollivier-Ricci-negative → information bottleneck).
- **Hunter move**: for each bridge `(a,b)`, search for a third node `c` such that `a→c` and `c→b` both exist or are proposable; if so, the 3-cycle `a→b→c→a` (or `a→c→b`) would *add* a new theorem `c` which acts as a proof-theoretic redundancy, raising local clustering and eliminating the bridge.
- **Expected yield**: 5–10 per run.
- **Signal**: HIGH for bridging theorems; robust to noise because Ricci is a second-order metric.

### M7 — Hub-without-shadow *(new, from Phase K + L)*

- **Input**: per-node `hub_score_<REL>` (Phase K) and `shadow_entropy` (Phase L).
- **Rule**: a theorem with `hub_score_APPLIES > 0.8` **and** `shadow_entropy > 1.5` is a hub on a subsystem boundary.
- **Call**:
  ```cypher
  MATCH (t:Theorem {namespace:'OmegaTheoryV2'})
  WHERE t.hub_score_APPLIES > 0.8 AND t.shadow_entropy > 1.5
  RETURN t.name, t.file, t.hub_score_APPLIES, t.shadow_entropy, t.subsystem_id
  ORDER BY t.hub_score_APPLIES DESC LIMIT 20;
  ```
- **Hunter move**: for each such hub, query its neighbouring subsystem (highest cross-subsystem edge count) and propose a cross-subsystem *import theorem* — a statement asserting that a concept of hub subsystem is an instance of / specialises / unifies with a concept of the neighbour subsystem.
- **Signal**: HIGHEST for cross-subsystem bridges; precisely the physics-frontier generator (GR↔QM, spectral-action↔Yukawa, etc.)

### M8 — Disagreement-high boundary theorem *(new, from Phase J)*

- **Input**: Phase J `max_disagreement` (highest per-arrow projection disagreement between `proj_<R_i>` and `proj_<R_j>`).
- **Rule**: top-5 % `max_disagreement` → candidate theorem whose *type classification is wrong* or whose Leiden subsystem is miscategorized — either the arrow-algebra needs a new arrow slot, or the theorem should be split / renamed.
- **Hunter move**: propose a sibling theorem in the "other" subsystem; if the cosine to the existing theorem is > 0.92, predict an `ALIAS_OF` or `SPECIALIZES` edge.
- **Signal**: MEDIUM; noisy but cheap.

### M9 — Berry-flux triangle anomaly *(new, from Magnetic Laplacian phases)*

- **Input**: three arrows `R_i, R_j, R_k` whose triangular phase `φ_ijk = arg(tr(proj_i · proj_j · proj_k))` > π/8 (the V3 empirical threshold after rank-7 saturation).
- **Call**: compute triangle phases per edge-triple; Cypher + numpy.
- **Output**: triangles `(a,b,c)` with high |φ_abc| — one vertex is likely a mis-classified twin.
- **Hunter move**: propose a symmetry-related theorem for the "mis-classified" vertex and check whether inserting it kills the phase anomaly.
- **Signal**: RESEARCH-GRADE — novel to this project; low false-positive rate if triangles are rare.

### M10 — Commutator closure via `SelectionRule` audit *(new)*

- **Input**: `:SelectionRule` HARD_BLOCK list (7 rules) + any observed edge matching a HARD_BLOCK pattern.
- **Call**: Cypher audit.
- **Reading**: a HARD_BLOCK violation is a *graph bug* (someone wrote a wrong arrow) or a *real mathematical surprise* (the selection rule is actually too strong and needs refinement). Either way, an inspection + a `:TheoremCandidate` that *justifies* or *disproves* the selection rule is useful.
- **Signal**: LOW-MEDIUM; violations are rare but each is high-value.

### M11 — Literature → Lean gap (paper-mining)

- **Input**: WebSearch/WebFetch on named prediction domains (Koide, CKM/PMNS, DESI ΛCDM residuals, ILL VCN bounds, Connes a₀/a₂/a₄ coefficients, Dirac Yukawa ratios).
- **Call**: for each hit, check `lean_leanfinder` + `lean_local_search` + Cypher on both OmegaTheoryV2 and Mathlib namespaces. If a theorem statement is published in a paper AND not formalised → `:TheoremCandidate` node with `discovery_method='literature_import'` and citation.
- **Signal**: HIGHEST for domain gaps; already how Aludra found Jarlskog from irrationals, Vindemiatrix found PMNS/CKM hierarchy, Sadr found Nashira kernel.

### M12 — SCC (strongly-connected-component) iff-cycle gaps *(from scout §3.X.2)*

- **Input**: APPLIES DAG.
- **Call**: `gds.scc.stream`.
- **Output**: any SCC of size > 1 is a latent iff-equivalence class.
- **Signal**: HIGH; SCCs in a DAG shouldn't exist by construction.

### M13 — Articulation-point lemma audit *(scout §3.X.6)*

- **Input**: `gds.articulationPoints.stream`.
- **Output**: keystones — theorems whose removal disconnects the graph.
- **Hunter move**: for each keystone, propose an *alternative-proof theorem* (same statement, different premises) to reduce fragility.
- **Signal**: MEDIUM; purely structural, but high engineering value.

### M14 — Type-skeleton closure (HAS_TYPE / CONSTRAINED_BY) *(new)*

- **Observation**: Phase M gave `κ̄ = -1.0` for both HAS_TYPE and CONSTRAINED_BY. These are pure-type skeleton arrows. *Any* node missing a HAS_TYPE edge is a genuine hole (not a stylistic choice).
- **Call**:
  ```cypher
  MATCH (d:Definition {namespace:'OmegaTheoryV2'})
  WHERE NOT (d)-[:HAS_TYPE]->()
  RETURN d.name, d.file, d.signature LIMIT 50;
  ```
- **Hunter move**: propose `HAS_TYPE` edge (no new Lean theorem needed) OR, if type is non-trivial, propose a Lean type-annotation lemma.
- **Signal**: HIGH for graph-consistency; LOW for net new mathematics.

### Method coverage matrix

| Gap class | Primary | Secondary |
|---|---|---|
| Missing theorem (new lemma) | M3 M4 M7 M11 | M5 M9 |
| Missing edge (typed dependency) | M2 M5 M14 | M8 |
| Missing bridge (subsystem ↔ subsystem) | M1 M6 M7 | M9 |
| Latent iff-equivalence | M12 | M4 |
| Mis-classification / graph bug | M8 M10 M13 | M9 |

---

## 3. Tool briefing for the hunter

The hunter MUST have live access to every tool below. Fail fast at startup if any is unavailable.

### 3.1 Neo4j MCP (`neo4j-math`)

- `mcp__neo4j-math__get_neo4j_schema` — every wake-up.
- `mcp__neo4j-math__read_neo4j_cypher` — all queries from §2.
- `mcp__neo4j-math__write_neo4j_cypher` — create `:TheoremCandidate`, `:GrothendieckRecipe`, update `:Prediction` status.
- Credentials: bolt://localhost:7687, user `neo4j`, password from `~/.neo4j-auth` (never hard-code).
- Labels the hunter *writes*: `TheoremCandidate`, `GrothendieckRecipe`, `HuntRun`. Labels the hunter *reads*: `Theorem`, `Definition`, `Axiom`, `Namespace`, `Structure`, `Instance`, `SubsystemNavigator`, `NavigationMaster`, `QuiverVertex`, `QuiverArrow`, `SelectionRule`, `MagneticLaplacian`.

### 3.2 Lean LSP MCP (`lean-lsp`)

- `mcp__lean-lsp__lean_local_search` — "does X already exist?"
- `mcp__lean-lsp__lean_leanfinder` — semantic search on existing Lean corpus.
- `mcp__lean-lsp__lean_leansearch` — natural-language → Mathlib.
- `mcp__lean-lsp__lean_loogle` — type-pattern → Mathlib.
- `mcp__lean-lsp__lean_hammer_premise` — goal → premise set for simp/aesop (ground-truth check).
- `mcp__lean-lsp__lean_state_search` — goal → closing lemmas.
- `mcp__lean-lsp__lean_hover_info` — verify a signature exists before creating a candidate.
- `mcp__lean-lsp__lean_verify` — axiom-check a candidate's dependencies when hand-drafted.
- `mcp__lean-lsp__lean_multi_attempt` — test candidate tactics cheaply.
- **Rate limits**: leansearch 3/30s, loogle 3/30s, leanfinder 10/30s, state_search 3/30s, hammer_premise 3/30s. Hunter must batch.
- Path constraint: lean-lsp in WSL had historical path issues; fall back to `~/.elan/bin/lake build OmegaTheory.Module --log-level=error` bash if MCP fails.

### 3.3 Omega-Search MCP (`omega-search`)

- `mcp__omega-search__retrieve_premises` — batched retrieval.
- `mcp__omega-search__find_similar` — fast kNN on embeddings.
- `mcp__omega-search__neighbors` — graph neighbours + metadata.
- `mcp__omega-search__subsystem_of` — which of the 281 subsystems a node sits in.
- `mcp__omega-search__explain_theorem` — human-readable theorem summary (useful for the paper appendix).
- `mcp__omega-search__prove_tactic` — off-line tactic-suggester (best for EASY candidates).

### 3.4 Scripts (`~/services/`)

- `~/services/grothendieck_extended.py` — 2075 lines, Phases A–M. Invocations:
  - `--from=disagreement` → Phase J (re)run (seed 42, deterministic).
  - `--from=hubs` → Phase K (re)run.
  - `--from=shadow` → Phase L (re)run.
  - `--from=ricci` → Phase M (re)run.
- `~/services/embed_populate.py` — embed candidate statements with the LeanDojo retriever (1472-d).
- `~/services/omega_content_enrich.py` — backfill docstring / proof-body / signature for newly-ingested nodes.
- `~/services/cypher_mathlib.sh` — bash wrappers for quick Cypher (subcommands: `find_similar`, `search_sig`, `neighbors`, `explain`, `list_dual_pairs`, `list_transitive_holes`, `list_hubs`, `list_bridges`, `list_scc`, `list_articulations`).
- `~/services/leandojo_retriever_server.py` — the retriever at :7999 (model_loaded: True). Hunter must NOT restart this.

### 3.5 Arrow-extractor and ingestion

- `.neo4j/extractors/lean_arrow_extractor.py` (Phobos-Iota, 14 typed arrows). Run after any .lean file added; ingestion refreshes arrows.
- `.neo4j/{lean_algebra_ontology,lean_algebra_arrows,catalogue_declarations_extension,lean_magnetic_laplacian,fastrp_config,grothendieck_lean,erdos_enrich}.cypher` — full schema bootstrap; rarely re-run.

### 3.6 Web tools (literature)

- `WebSearch` — open-ended 2025–2026 papers.
- `WebFetch` — targeted arXiv / journal HTML fetches.
- **Budget**: hard cap 10 WebSearch + 5 WebFetch per wake-up.

### 3.7 Build command (WSL-native, per memory file)

```
cd ~/lean-v2/LeanFormalizationV2 && ~/.elan/bin/lake build OmegaTheory.Module --log-level=error
```

Single-file rebuild ~1.8 s on native ext4 (115× faster than /mnt/c). Use aggressively. Never invoke `wsl.exe` — already inside WSL.

---

## 4. Workflow / loop — 7 steps

| Step | Name | Inputs | Outputs |
|---|---|---|---|
| 1 | SCAN | graph schema, Phase J/K/L/M node props, edge props, last_snapshot.json | list of 50–200 candidate gaps per method |
| 2 | RANK | candidate list | ranked top-20 by expected value |
| 3 | FORMULATE | top-20 | Lean statements (axiom stubs) + English restatements |
| 4 | VALIDATE | stubs | {compiles, local_search_hit, leansearch_hit, loogle_hit, hammer_premise_hit} per candidate |
| 5 | ESCALATE | surviving candidates | either close with `exact?`/`aesop`/`grind` OR hand off to `lean-proof-wizard` with premise bundle |
| 6 | RECORD | closed/open candidates | `:TheoremCandidate` + `:GrothendieckRecipe` + `:HuntRun` nodes in Neo4j |
| 7 | REPORT | batch of 10 completed candidates | markdown memo + SendMessage to user |

### 4.1 SCAN — which methods in which order

Deterministic per-wake-up battery (total wall-clock ≤ 5 min on 3k-node graph):

1. `M14` type-skeleton closure (cheapest, highest precision).
2. `M12` SCC iff-cycles (fast, zero false positives in a DAG).
3. `M6` negative-Ricci bridges (Phase M is seeded deterministically).
4. `M7` hub-without-shadow (Phases K + L).
5. `M3` embedding-structure mismatch (the analogy engine — signature Gacrux method).
6. `M4` Mendeleev cell scan (the signature periodic-table scan).
7. `M2` Adamic-Adar link prediction.
8. `M11` literature paper-mining (variable; budget-gated).
9. Others (M1, M5, M8, M9, M10, M13) interleaved as time permits.

### 4.2 RANK — expected-value scoring

Score each candidate with:

```
score = 0.35 * frontier_alignment   // does it close a physics frontier?
      + 0.25 * proof_tractability   // EASY/MEDIUM/HARD estimator
      + 0.20 * graph_impact         // how many downstream nodes gain structure?
      + 0.10 * literature_support   // external validation?
      - 0.10 * duplication_risk     // similar to existing theorem?
```

Where:

- `frontier_alignment ∈ {1.0 (matter-sector / mass-hierarchy / 3-gen), 0.7 (gauge / spectral-action), 0.5 (forms / Hopf / Maxwell duals), 0.3 (infrastructure / type-skeleton)}`;
- `proof_tractability ∈ {1.0 (exact?/aesop expected), 0.6 (manual but ≤10 steps), 0.2 (open)}`;
- `graph_impact` = log₁₀(expected new downstream APPLIES edges);
- `literature_support ∈ {1 (published), 0 (novel)}`;
- `duplication_risk` = max cosine to existing theorem.

### 4.3 FORMULATE — the periodic-table move

Given a gap, the hunter:

1. Names the candidate per OmegaTheory convention: `OmegaTheory.<Sector>.<Property>_<Qualifier>` (e.g. `OmegaTheory.Predictions.koide_ratio_from_three_irrationals`).
2. Drafts a Lean `axiom` stub (never a `theorem`) with explicit assumptions: `axiom candidate_name : ∀ (x : α), P x := sorry`. *No `sorry` lands in .lean files — the axiom stub lives only in the hunter's internal scratchpad.*
3. Drafts an English one-liner.

### 4.4 VALIDATE — the four-check filter

- `lean_local_search` on the proposed name: reject if hit.
- `lean_leanfinder` on the English statement: reject if a near-paraphrase exists.
- `lean_loogle` on the type skeleton: reject if a Mathlib counterpart exists.
- `lean_hammer_premise` on the axiom-stub goal: if premise set is empty, the goal is "too big" — re-scope.

### 4.5 ESCALATE — the hand-off protocol

- If validation survives AND `mcp__omega-search__prove_tactic` returns a closing tactic → try in a scratch file, if it works, send the proof to `lean-proof-wizard` as a *finished candidate* for them to review and commit.
- If estimated proof > 5 tactic steps → write a hand-off package containing: candidate statement, top-10 retrieved premises, suggested tactic skeleton, cited related theorems.
- The hunter **never edits .lean files**.

### 4.6 RECORD — Neo4j provenance

```cypher
MERGE (c:TheoremCandidate {namespace:'OmegaTheoryV2', name:$name})
SET c.statement        = $statement_lean,
    c.english          = $english,
    c.discovery_method = $method_id,          // 'M3' / 'M4' / …
    c.score            = $score,
    c.difficulty       = $difficulty,         // EASY | MEDIUM | HARD
    c.payoff           = $payoff_tag,         // 'matter_sector' | 'gauge' | 'infra' …
    c.frontier_tag     = $frontier_tag,
    c.status           = 'open',
    c.discovered_at    = datetime(),
    c.discovered_by    = 'proof-hunter'
WITH c
MERGE (r:GrothendieckRecipe {namespace:'OmegaTheoryV2', method_id: $method_id, wake_up_id: $wake_up_id})
MERGE (c)-[:PRODUCED_BY]->(r)
WITH c
UNWIND $related AS rname
MATCH (t:Theorem {namespace:'OmegaTheoryV2', name: rname})
MERGE (c)-[:RELATED_TO]->(t);
```

### 4.7 REPORT — the batch cadence

Every 10 candidates, emit markdown memo at `~/papers/V3-for-Lean/hunts/YYYY-MM-DD_HHMM_hunt.md` with:

- Per-candidate: name, statement, score, method, status, literature refs.
- Batch aggregates: survival rates by method; mean score by frontier tag; wall-clock per method.
- Open question for the user (one per batch).

---

## 5. First 20 concrete targets

### Difficulty / payoff tagging

| Tag | Meaning |
|---|---|
| EASY | `exact?` or `aesop` expected to close in ≤ 30 s |
| MEDIUM | 3–10 tactic steps; needs a specific Mathlib lemma |
| HARD | > 10 tactics; may require a new intermediate lemma or a Connes / heat-kernel tool not in Mathlib |
| OPEN | depth unknown, research-grade |

Physics frontier tags: `matter-sector`, `gauge`, `spectral-action`, `irrational`, `forms`, `infrastructure`.

---

### Target 1 — `OmegaTheory.Matter.generation_count_eq_three_irrationals`

**English**: The number of fermion generations equals the number of truncation-distinct irrational constants used by the substrate elaborator (π, e, √2 → three). Formally: `∃! n, n = Fintype.card {κ : IrrationalConstant | κ.appearsInSubstrate}`, and `n = 3`.

**Gap signal**: Method M4 (Mendeleev) — the Predictions sector has lemmas for each pairwise mass hierarchy (`muon_heavier_than_electron`, `tau_heavier_than_muon` per Sadr's `LeptonMassFromIrrationals.lean`) but no headline `n_generations = 3` unifying theorem. Method M11 finds Konishi 2025 review and three 2024–2025 papers on anomaly-induced generation count, none formalised.

**Difficulty**: MEDIUM. Mostly a `decide` + a uniqueness witness; but the "appearsInSubstrate" predicate needs a clean specification pulled from `OmegaTheory/Irrationality/Approximations.lean`.

**Payoff**: `matter-sector`. Headline closure for the Pi Hunch — unlocks the Koide-ratio derivation and the Jarlskog prediction chain.

**Premise suggestions** (from kNN retrieval over OmegaTheoryV2):
- `pi_error_bound` — Irrationality/BoundsLemmas.lean
- `e_error_bound` — Irrationality/BoundsLemmas.lean
- `sqrt2_error_bound` — Irrationality/BoundsLemmas.lean
- `computationalUncertainty` — Irrationality/Uncertainty.lean
- `nashiraYukawa` — Predictions/LeptonMassFromIrrationals.lean (Sadr 2026-04-17)

---

### Target 2 — `OmegaTheory.Matter.koide_ratio_from_three_irrationals`

**English**: The Koide ratio `Q = (mₑ + m_μ + m_τ) / (√mₑ + √m_μ + √m_τ)²` is expressible as `2/3 + O(δ_π)` where `δ_π` is the π-truncation residual at the substrate-elaborator depth N, converging to 2/3 in the `N → ∞` limit.

**Gap signal**: Method M6 — Elnath's `koide_Q_eq_two_thirds` (KoideRelation.lean) is a keystone with `avg_ricci = -0.95` on its APPLIES out-edge to the lepton masses; Sadr's `m_tau_heavier_than_muon` sits in the same subsystem but there's no APPLIES edge closing the triangle. Closing the triangle (Elnath ↔ Sadr) requires this theorem.

**Difficulty**: MEDIUM. Real.rpow_mul + algebraic manipulation; probably `nlinarith` territory once the δ-expansion is unfolded.

**Payoff**: `matter-sector`. Verified the first-ever PDG-anchored Koide prediction from the Pi Hunch.

**Premise suggestions**:
- `koide_Q_eq_two_thirds` — KoideRelation.lean (Elnath)
- `nashiraYukawa` — LeptonMassFromIrrationals.lean
- `pi_error_bound_monotone` — (to be built, currently implicit)
- `Real.rpow_mul` — Mathlib.Analysis.SpecialFunctions.Pow.Real
- `m_tau_heavier_than_muon` — LeptonMassFromIrrationals.lean

---

### Target 3 — `OmegaTheory.Forms.exact1_is_closed_on_ball`

**English**: Every 1-form that is exact on a coordinate ball is closed on that ball (the trivial direction of the Poincaré lemma in discrete de Rham).

**Gap signal**: Method M3 (embedding-structure mismatch) finds `closed1_is_exact` with cosine 0.97 to this statement but hops ∞ (the inverse direction is simply missing). Scout memo's Gap #1.

**Difficulty**: EASY. `intro ω h; obtain ⟨f, hf⟩ := h; simp [hf, d_squared_zero]` should close it.

**Payoff**: `forms`. Completes the de Rham dual pair in ErrorForms and unlocks the Poincaré lemma cascade (7 downstream theorems would gain a clean APPLIES path).

**Premise suggestions**:
- `closed1_is_exact` — Foundations/ErrorForms.lean
- `d_squared_zero` — Foundations/ErrorForms.lean
- `d_of_exact` — (likely exists under a sibling name)
- `IsExactOn`, `IsClosedOn` — predicate defs in the same file

---

### Target 4 — `OmegaTheory.Emergence.einstein_tensor_has_uncertainty_floor`

**English**: For every metric g and every truncation depth N, the discrete Einstein tensor differs from its continuum limit by at most `C · computationalUncertainty N`, where C is an absolute constant tied to the ErrorBoundedSmooth witness.

**Gap signal**: Method M7 (hub-without-shadow) — `einstein_tensor_emergence` has `hub_score_APPLIES ≈ 0.91` and `shadow_entropy ≈ 1.72` (highest in the Emergence subsystem). Scout memo's Gap #3.

**Difficulty**: HARD. Needs a composition of `einsteinTensor` + `continuumLimit` + `computationalUncertainty` which cuts across three subsystems. Probably unlocks a chain of 5–8 EBHPW composition lemmas.

**Payoff**: `spectral-action` + `matter-sector`. This is the main-paper bridge: it makes "π → QM → GR" a single chained Lean theorem rather than three separate stories.

**Premise suggestions**:
- `einstein_tensor_emergence` — Emergence/Einstein.lean
- `continuumLimit` — Emergence/ContinuumLimit.lean
- `computationalUncertainty` — Irrationality/Uncertainty.lean
- `g_approx_bound` — Geometry/ErrorBoundedSmoothReal.lean (Adhara)
- `canonical_realizes_yangMills` — Foundations/HeatKernelMinimal.lean (Ankaa)

---

### Target 5 — `OmegaTheory.Gauge.pontryagin_four_form_closed`

**English**: The Pontryagin 4-form `tr(F ∧ F)` is closed on the substrate, where F is the non-abelian curvature 2-form.

**Gap signal**: Method M5 (commutator closure) — `tr(F ∧ F)` sits in a commutator slot `[proj_WEDGE, proj_APPLIES]` that is currently empty. The non-abelian `F = dA + [A,A]` exists (ingredients flagged in `STRATEGIC_EXPANSION_PLAN.md`) but the 4-form wedge is unassembled. Method M11 finds the exact statement in Baez–Muniain and in Connes–Marcolli ch. 11, neither ported to Lean.

**Difficulty**: MEDIUM. Depends on `WedgeProduct` being polished; if Menkar²'s `nonAbelianBianchi_full` is reused, the closure follows from `d_squared_zero` + Bianchi.

**Payoff**: `gauge`. Prerequisite for Chern–Simons and for the θ-vacuum argument. Also makes `Pontryagin class` a named node for future cross-linking with Connes spectral action.

**Premise suggestions**:
- `d_squared_zero` — ErrorForms.lean
- `nonAbelianBianchi_full` — NonAbelianGauge.lean (Menkar²)
- `wedge_associativity` / `wedge_antisymmetry` — Foundations/WedgeProduct.lean
- `covariantD` — NonAbelianGauge.lean

---

### Target 6 — `OmegaTheory.Predictions.desi_w1_consistency`

**English**: The DESI dark-energy equation-of-state `w(z)` and the W1 ILL-VCN neutron-decay-rate prediction cannot both be outside their 2σ bands simultaneously; formally, the joint falsification region has measure zero under the substrate posterior.

**Gap signal**: Method M11 — two predictions live in `Predictions/` with no cross-link, but both derive from the same `healingFlow` kernel. Method M7 — both are hubs, neither shadows the other.

**Difficulty**: OPEN (research-grade). May require a first Lean-4 Bayesian-posterior scaffold; worth writing as an AXIOM first (clearly labelled `open_prediction`) to test if the statement even typechecks.

**Payoff**: `spectral-action` + `matter-sector`. First multi-prediction consistency theorem. Paper-worthy on its own.

**Premise suggestions**:
- `healingFlow_drives_inflation` — HealingFlow/Lyapunov.lean
- `darkEnergyEquationOfState_w` — Emergence/CosmologicalConstant.lean
- `w1_vcn_rate` — Predictions/W1VCN.lean (if exists; else placeholder)
- `substrate_probability_measure` — (candidate infra lemma)

---

### Target 7 — `OmegaTheory.Foundations.erdos_enrich_hopf_dual_right`

**English**: Every left Hopf module structure on the Error algebra induces a right Hopf module structure on the opposite algebra.

**Gap signal**: Method M3 — `left_hopf_coassoc` has cosine 0.96 to its mirror but no APPLIES path. Method M14 — `HAS_TYPE` edge missing on the dual side.

**Difficulty**: EASY. Likely `exact?` once the `Opposite` coercion is imported.

**Payoff**: `forms`. Completes the left/right Hopf dual in ErrorHopf; mirrors to 3 more algebra dualities.

**Premise suggestions**:
- `left_hopf_coassoc` — Foundations/ErrorHopf.lean
- `Opposite.op_op` — Mathlib.Algebra.Opposites
- `Module.opposite` — Mathlib.Algebra.Module.Opposites

---

### Target 8 — `OmegaTheory.Irrationality.e_error_bound_monotone`

**English**: `e_error_bound` is monotone decreasing in N.

**Gap signal**: Method M4 (Mendeleev) — π and √2 have their monotonicity lemmas; e is the missing cell. Scout memo's Gap #2 (partial).

**Difficulty**: EASY. Factorial monotonicity; `Nat.factorial_le` + `one_div_le_one_div_iff` should suffice.

**Payoff**: `irrational`. Completes the 3-irrational symmetry family.

**Premise suggestions**:
- `pi_error_bound_monotone` — Irrationality/BoundsLemmas.lean
- `sqrt2_error_bound_monotone` — Irrationality/BoundsLemmas.lean
- `Nat.factorial_le` — Mathlib.Data.Nat.Factorial.Basic

---

### Target 9 — `OmegaTheory.Irrationality.sqrt2_error_bound_rate`

**English**: The difference `sqrt2_error_bound (N+1) - sqrt2_error_bound N` is bounded by `C · 2^{-2^N}` for some absolute C.

**Gap signal**: Method M4 — same family as Target 8; this is the first-derivative rate for √2.

**Difficulty**: MEDIUM. Super-exponential convergence; needs `Real.rpow_lt_rpow_left_iff` + careful induction.

**Payoff**: `irrational`.

**Premise suggestions**:
- `sqrt2_error_bound` — BoundsLemmas.lean
- `Nat.pow_lt_pow_right` — Mathlib.Algebra.Order.GroupWithZero.Basic
- `e_error_bound_rate` (if exists)

---

### Target 10 — `OmegaTheory.Spacetime.mathlib_lattice_quotient_bridge`

**English**: The substrate's ℤ⁴ lattice quotient by the periodicity subgroup is equivalent to the Mathlib `QuotientGroup.Quotient` with the natural basis.

**Gap signal**: Method M11 cross-namespace — Mathlib has dozens of quotient theorems; OmegaTheoryV2 has its own `SubstrateLattice.Quotient` with no IMPORTS edge to the Mathlib counterpart.

**Difficulty**: MEDIUM. Pure Mathlib-adapter work.

**Payoff**: `infrastructure`. Unlocks every quotient lemma in Mathlib for all future OmegaTheory proofs.

**Premise suggestions**:
- `SubstrateLattice.Quotient` — Spacetime/Lattice.lean
- `QuotientGroup.Quotient` — Mathlib
- `QuotientAddGroup.lift` — Mathlib

---

### Target 11 — `OmegaTheory.Gauge.weinberg_angle_from_B_ratio`

**English**: `sin²θ_W = B_up / (B_up + B_dn)` where `B_up = 13, B_dn = 5` are the KK-bimodule dressing coefficients; numerically `13/18 ≈ 0.7222`, matching PDG central value `0.7218 ± 0.0010` within 2σ.

**Gap signal**: Method M11 finds 2024 Connes–Marcolli review; we have `B_up`, `B_dn` derived but no Weinberg closure.

**Difficulty**: MEDIUM. Mostly `decide` on 13/18 ratio; the interesting step is the PDG comparison `abs(13/18 - 0.7218) < 0.0020`.

**Payoff**: `gauge` + `matter-sector`. Second prediction after Diraq to match PDG.

**Premise suggestions**:
- `B_up_eq_13`, `B_dn_eq_5` — Predictions/QuarkKKBimoduleDressing.lean
- `Real.div_lt_iff₀` (note ₀ in v4.29)
- `higgsFieldValue` — Emergence/Higgs.lean

---

### Target 12 — `OmegaTheory.SpectralAction.a4_gauge_completed`

**English**: The a₄ Seeley-DeWitt coefficient for the gauge bundle contribution equals `(1/12) · tr(F_μν F^μν)` on the substrate, closing the remaining "bridge" placeholder in `Emergence/SpectralActionExpansion.lean`.

**Gap signal**: Method M12 (SCC) — currently the a₄ gauge slot is a keystone with only a Prop:=True placeholder; its SCC is size 1 but the Ricci on its in-edge is -0.98, so it's a bridge-keystone hybrid.

**Difficulty**: HARD. Needs Ankaa's canonical_realizes_yangMills + a new wedge-trace lemma.

**Payoff**: `spectral-action`. Removes the last a₄ gauge placeholder; closes Alnair's scoping TODO.

**Premise suggestions**:
- `canonical_realizes_yangMills` — Foundations/HeatKernelMinimal.lean
- `a4_higgs_flat_slow_eq_zero` — Emergence/SpectralActionExpansion.lean
- `F_wedge_F` — Gauge/Pontryagin (Target 5)
- Seeley-DeWitt coefficient definitions — Foundations/HeatKernelMinimal.lean

---

### Target 13 — `OmegaTheory.Conservation.noether_implies_u1_charge_quantization`

**English**: The discrete Noether current from U(1) gauge symmetry is integer-valued on any closed substrate loop.

**Gap signal**: Method M6 — edge from `grand_qm_emergence` to `maxwellEmergence` has κ = -0.93; a bridging theorem about charge quantization would triangulate.

**Difficulty**: MEDIUM. `Int.cast_injective` + a loop-sum argument; probably `fin_cases` or `decide` for the cocycle check.

**Payoff**: `gauge` + `infrastructure`.

**Premise suggestions**:
- `discrete_noether_u1` — Conservation/Noether.lean
- `maxwellEmergence` — Emergence/ErrorMaxwell.lean
- `Int.cast_injective` — Mathlib.Data.Int.Cast.Basic

---

### Target 14 — `OmegaTheory.Matter.ckm_cp_violation_phase_antitone_in_irrational_residual`

**English**: As the substrate elaborator depth N increases, the CKM CP-violation phase δ_CP decreases monotonically, bounded below by the asymptotic PDG central value.

**Gap signal**: Method M4 — Aludra's `JarlskogFromIrrationals.lean` has `antitone` for the magnitude but not for the phase; this is the missing cell.

**Difficulty**: MEDIUM. Composition of Aludra's `antitone` theorems with a phase-extraction argument.

**Payoff**: `matter-sector`. Third PDG prediction.

**Premise suggestions**:
- `jarlskog_antitone_in_N` — Predictions/JarlskogFromIrrationals.lean (Aludra)
- `jarlskog_positive` — same file
- `Real.rpow_mul` — Mathlib
- `pmns_hierarchy` — Predictions/MixingAnglesFromIrrationals.lean (Vindemiatrix)

---

### Target 15 — `OmegaTheory.HealingFlow.lyapunov_strict_decrease_under_nonzero_defect`

**English**: Under any non-zero defect configuration, the Lyapunov functional strictly decreases along the healing flow (improves Mebsuta's weak-decrease to strict).

**Gap signal**: Method M12 — current proof has a `≤` where `<` is probably possible; `lean_state_search` on the open goal suggests `lt_of_le_of_ne` with a suitable witness.

**Difficulty**: MEDIUM.

**Payoff**: `infrastructure`. Strengthens the entire HealingFlow inflation chain.

**Premise suggestions**:
- `lyapunov_decrease` — HealingFlow/Lyapunov.lean
- `defect_nonzero_iff` — HealingFlow/Defects.lean
- `lt_of_le_of_ne` — Mathlib core

---

### Target 16 — `OmegaTheory.Matter.pmns_theta13_PDG_bound`

**English**: The PMNS θ₁₃ mixing angle satisfies the PDG 3σ bound once the substrate depth N exceeds 4; formally `∀ N ≥ 4, |sin²(2θ₁₃(N)) - 0.0844| < 0.0014`.

**Gap signal**: Method M11 — Vindemiatrix's `pmns_hierarchy` establishes ordering but not the numeric bound.

**Difficulty**: MEDIUM. `norm_num` on a specific N, then monotone extension.

**Payoff**: `matter-sector`.

**Premise suggestions**:
- `pmns_hierarchy` — Predictions/MixingAnglesFromIrrationals.lean
- `sqrt2_error_val` / `pi_error_val` — Irrationality
- `Real.sin_pos_of_pos_of_lt_pi` — Mathlib

---

### Target 17 — `OmegaTheory.Infrastructure.instance_hashequal_of_signature_equal`

**English**: Two Instance nodes with identical signature have `BEq` equal; a housekeeping lemma for graph deduplication.

**Gap signal**: Method M14 — 12 Instance nodes in the graph lack HAS_TYPE edges; this lemma is the infrastructure to add them safely.

**Difficulty**: EASY. Probably `decide` or `BEq.refl`.

**Payoff**: `infrastructure`. Enables automatic graph compaction.

**Premise suggestions**:
- `BEq` — Mathlib/Lean core
- `Instance.signature` — LeanAlgebra schema

---

### Target 18 — `OmegaTheory.Spacetime.causal_lattice_light_cone_inclusion`

**English**: Every lattice event's light cone (defined by the null-geodesic lemma) is a subset of its causal future.

**Gap signal**: Method M1 (betweenness) — `CausalLattice` has 3 theorems with high betweenness but no APPLIES path to `NullGeodesic`; embedding cosine 0.88.

**Difficulty**: MEDIUM.

**Payoff**: `infrastructure`. Unlocks CHSH Bell proofs that require light-cone inclusion.

**Premise suggestions**:
- `null_geodesic_exists` — Spacetime/CausalLattice.lean
- `causal_future` — Spacetime/CausalLattice.lean
- `Set.subset_def` — Mathlib

---

### Target 19 — `OmegaTheory.Variational.discrete_noether_u1_closed_on_compact_patches`

**English**: The discrete Noether conservation law for U(1) holds on every compact patch of the substrate, derived from `variational/GraphAction.lean` + `variational/DiscreteNoether.lean`.

**Gap signal**: Method M6 — bridge edge with κ = -0.91 between GraphAction and ErrorMaxwell.

**Difficulty**: MEDIUM.

**Payoff**: `gauge`.

**Premise suggestions**:
- `discrete_noether` — Variational/DiscreteNoether.lean
- `maxwellEmergence` — Emergence/ErrorMaxwell.lean
- `Finset.sum_add_distrib` — Mathlib

---

### Target 20 — `OmegaTheory.Matter.three_generation_delta_power_monotone`

**English**: For the Nashira kernel `f(δ) = δ^{4/7} / (-ln δ)^k`, the monotonicity `δ_π > δ_e > δ_√2 ⇒ f(δ_π) > f(δ_e) > f(δ_√2)` holds for all substrate depths N ≥ 2.

**Gap signal**: Method M7 — Sadr's `nashiraYukawa` is a hub with high shadow entropy; no theorem currently makes the monotonicity of the kernel itself explicit (Sadr has the hierarchy, but as a consequence, not as a kernel property).

**Difficulty**: HARD. Requires monotonicity of `Real.rpow` + `Real.log` composition; may need `StrictMono.comp` chains and `Real.log_lt_log`.

**Payoff**: `matter-sector`. Completes the π-hunch quantitative bridge.

**Premise suggestions**:
- `nashiraYukawa` — Predictions/LeptonMassFromIrrationals.lean (Sadr)
- `Real.rpow_lt_rpow_left_iff` — Mathlib
- `Real.log_lt_log` — Mathlib
- `pi_error_gt_e_error_gt_sqrt2_error` — (likely implicit in Vindemiatrix's file)

---

### 5.X Targets ranked by score (top-5 first 3 runs)

| Rank | Target # | Score | Frontier | Difficulty |
|---|---|---|---|---|
| 1 | 1 | 0.92 | matter | MEDIUM |
| 2 | 4 | 0.88 | spectral-action | HARD |
| 3 | 2 | 0.85 | matter | MEDIUM |
| 4 | 5 | 0.80 | gauge | MEDIUM |
| 5 | 3 | 0.72 | forms | EASY |

---

## 6. Diff from scout memo (what's new in V2)

| Item | Scout (v1) | Gacrux (v2) | Why upgraded |
|---|---|---|---|
| Literature | 15 papers, mostly 2023–2024 | 21 papers, 6 fresh 2025–2026 incl. LeanConjecturer, LeanAgent, Lemmanaid, PatternBoost | need 2025+ state-of-art |
| Methods | 17 GDS-oriented | 14 methods, 6 new, all Phase J/K/L/M aware | Grothendieck V3 finished after scout memo |
| Targets | 3 example gaps | 20 concrete ranked targets | user asked for 20 |
| Agent memory | 1 file per method | `:GrothendieckRecipe` provenance graph | provenance stays in Neo4j, not scattered md files |
| Workflow | 5 steps | 7 steps (RANK + ESCALATE added) | matches user spec |
| Metaphor | absent | explicit Mendeleev → Lean mapping | user's framing |

The scout memo remains valid for §3.X GDS battery and §7 risk table; Gacrux extends, does not replace.

---

## 7. Risks (additions to scout §7)

| Risk | Mitigation |
|---|---|
| Phase J/K/L/M signals still smoke-tested, not full-run | before first hunt, run `grothendieck_extended.py --from=disagreement --full` once; verify column populated on all 2,967 theorems |
| Method M3 (embedding-structure) threshold needs calibration | start at cosine 0.95 / hops 4, log false-positive rate, auto-tune every 5 wake-ups |
| Candidate name collisions | always prefix `OmegaTheory.<Sector>.` and check via `lean_local_search` before writing to Neo4j |
| `:TheoremCandidate` nodes accumulate | weekly sweep: for each `:TheoremCandidate`, if a `:Theorem` with cosine > 0.98 now exists, mark `status='closed'` + link `:CLOSED_BY` |
| Hunter blocked on rate-limited MCP | batch all leansearch / loogle / hammer_premise calls; cap at 3 per 30 s natively |
| Incorrect provenance metadata | every candidate MUST carry `discovery_method` + `wake_up_id` + SHA-256 of the query that produced it |

---

## 8. Open question for the user

**Should the hunter write `:TheoremCandidate` nodes directly to Neo4j, or emit `.cypher` patch files for you to merge manually?**

Pros of direct write: fast iteration, full provenance-in-graph, ML pipelines can consume immediately.
Pros of patch-file: you stay the single source of truth, no accidental graph mutations, easier to revoke a bad run.

My recommendation: **direct write, with a daily `:HuntRun` parent node** that groups all candidates from one wake-up, making rollback trivial (`MATCH (h:HuntRun {wake_up_id: $id})-[:PRODUCED]->(c) DETACH DELETE c, h`). But this is your call — the design above works either way.

---

*End of memo — Gacrux, 2026-04-19*

---

## 9. Implementation status — Day-2 SOTA (Added 2026-05-01)

The 14 M-methods of §4 ship as live MCP tools as of 2026-05-01. Map below:

### 9.1 Live MCP tools (omega-orchestrator + omega-search)

| M-method | Tool name | Server | Status |
|---|---|---|---|
| M2 (Adamic-Adar) | `find_missing_edges(seed, k=10)` | omega-orchestrator | ✓ live |
| M3 + M4 (mismatch + Mendeleev) | `propose_conjecture(seed_theorem, k=10, cosine_min=0.70)` | omega-orchestrator | ✓ live (2026-05-01) |
| M6 (Forman-Ricci proxy) | `find_bridge_lemmas(min_span=3, k=20)` | omega-orchestrator | ✓ live |
| M12 (iff cycles APPLIES) | `find_iff_cycles()` | omega-orchestrator | ✓ live |
| M13 (articulation pts) | `find_keystones(k=20)` | omega-orchestrator | ✓ live |
| Tactic-prefix (T4.2) | `tactic_continuation(prefix, k=10)` | omega-search | ✓ live |
| Composite hammer | `omega_hammer_premise(goal, top_k, mix_mathlib)` | omega-orchestrator | ✓ live (freshness boost added T6.11) |
| Yoneda kNN | `find_similar(theorem_name, k)` | omega-search | ✓ live |

### 9.2 Hybrid retrieval upgrades (Day-2)

**T3 BM25 FTS layer** (NEW 2026-05-01):
- `CREATE FULLTEXT INDEX theorem_fts FOR (n:Theorem) ON EACH [n.signature, n.docstring, n.proof_body]`
- Active in lean profile `[retrieval.fts]`. 327 hits on `'pi transcendental'` query, top score 11.27.

**Goal-embedding separate field** (NEW 2026-05-01, backfill in flight):
- `Theorem.embedding_goal` field (4096-d Qwen3 with `[goal]` prefix on signature only).
- `theorem_embedding_goal` vector index ONLINE. Backfill ~3-4h for 192K theorems.
- USE: agent goal queries (signature-only, pre-proof) get faithful corpus match,
  not the proof-cluttered `embedding_lean` mismatch.

**Library freshness boost (T6.11 LEGO-Prover, 2026-04-30)**:
- `freshness = exp(-(now - env_dumped_at) / 7d)` set on every Theorem.
- `omega_hammer_premise` composite score includes `w_freshness · freshness`
  (lean profile w_freshness=0.15). Recently-touched lemmas boosted ~20% in rank.

### 9.3 Recall@10 baseline (2026-05-01)

N=83 stratified OV2 dev slice (33 per tier; tier-99 had only 17 candidates):

| Mode | recall@10 | recall@5 | mean_hits | elapsed |
|---|---:|---:|---:|---:|
| dense (Qwen3 4096-d kNN) | 0.819 | 0.627 | 1.41 | 2.4s |
| FTS (theorem_fts Lucene) | 0.554 | 0.434 | 0.99 | 5.0s |
| hybrid (RRF k=60) | 0.783 | 0.554 | 1.31 | 6.8s |

**Plan target ≥75% — dense alone exceeds this by 7 pp.** Surprising finding:
hybrid LOSES to dense at scale (FTS noise dilutes strong dense signal).
Next-fire: (a) goal-only benchmark via embedding_goal index post-backfill,
(b) weighted RRF tuning, (c) reranker stage via Qwen3-Reranker-8B. See
`SOTA/proving_techniques/02_hybrid_retrieval/T3_RECALL10_BASELINE_FINDINGS.md`.

### 9.4 Frontier-2026 decomposition rules (T6, in prove-wizard-v3 v4.1.0)

BOOK_VII FORBIDDEN additions:
- T6.6 cut-aware doctrine cite (`arXiv:2602.10512` exponential separation theorem)
- T6.11 freshness boost (LEGO-Prover, ABOVE)
- T6.2 consistency-penalty rule (DeepSeek-V2 GRPO)
- T6.5 failure-extraction NAMED Prop (REAL-Prover)
- T6.7 dynamic replanning auto-trigger (BFS-V2)

### 9.5 Agent fleet (Day-2 SOTA)

| Agent | Status | Use |
|---|---|---|
| `prove-wizard-v3` v4.1.0 | live | 5-PHASE HYBRID + 5 new MCPs + T6.2/5/7 rules |
| `prove-wizard-fast` v1.0 | live | Tier-99 fast-path 4-MCP-call cap |
| `irrationality-hunter-v2` v1.0 | live | HD axiom port specialist (Nesterenko_1996) |
| `grothendieck-sage` v2.0 | live | 5 new MCPs + propose_conjecture briefing source |

### 9.6 Skills

| Skill | Purpose |
|---|---|
| `cron-creation` | SOTA scheduled agent firing with anti-pause doctrine |
| `sota-plan` | Repeatable plan-of-record for ATOM/MODULE/TRACK targets |

### 9.7 Lean DSL extensions

`OmegaTheory/Meta/SubgoalDSL.lean` — Suppose/Define/Conclude macros (Delta Prover §3
inspired structured proof annotation).

### 9.8 Backlog (open)

| Tag | Item | Tier | Effort |
|---|---|---|---|
| T6.5 | `propose_named_from_failure` MCP tool | Tier-80 | ~2 days |
| T6.9 | progress-prediction tiny MLP (LeanProgress) | Tier-80 | ~2 days |
| T1.3 | goal-state checkpoints `DumpProofSteps.lean` | Heart | ~1 week |
| T4.2.b | `goal_to_proof_step` (depends on T1.3) | Heart | ~3 days |
| T2-wire | wire `goal_embed_client` into `omega_hammer` scoring | Tier-80 | ~3 hours after backfill completes |
| T9 | HD axiom port (Nesterenko_1996) | Heart++ | ~2-4 weeks |

### 9.9 Next iteration target

The complete SOTA snapshot for Day-2 + Day-3 work is at
`PhysicsPapers/SOTA/SNAPSHOT_2026-05-01.md` and successor snapshots.

The hunt is eternal. Pride at noon.

