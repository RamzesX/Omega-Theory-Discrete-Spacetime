# Graph + omega_hammer Decomposition Heuristics — graph-analyst Report

**Agent**: graph-analyst (team `divide-et-impera`)
**Date**: 2026-04-30
**Live state at session start**: Phase A · 15,491 OV2 theorems · 175,137 Mathlib theorems · 1 axiom (`Nesterenko_1996`) · 0 sorry · 183 OPEN candidates · vector indices dim=4096 (Qwen3) on `lean_retriever_embedding_theorem` and dim=1472 (ByT5) on `_axiom`/`_declaration`.

The OmegaTheoryV2 corpus has **345,296 APPLIES edges** and **312,432 UNFOLDS edges** — APPLIES is the dominant decomposition signal. ASSUMES is essentially unused (2 edges total). Searches and decomposition heuristics should traverse APPLIES; UNFOLDS is for definitional steps.

---

## Heuristic 1 — Tier-99 anchors are positivity-of-physical-constants

The top-by-in-degree theorems in OV2 are uniformly **positivity / non-zero / decreasing** lemmas about physical constants and computational error:

| name | indeg | distinct_caller_files | file |
|------|------:|----------------------:|------|
| `c_pos` | 128 | 46 | `Spacetime/Constants.lean` |
| `l_P_pos` | 126 | 65 | `Spacetime/Constants.lean` |
| `computationalUncertainty_pos` | 104 | 60 | `Irrationality/Uncertainty.lean` |
| `pi_error_pos` | 76 | 55 | `Irrationality/Approximations.lean` |
| `sqrt2_error_pos` | 72 | 52 | `Irrationality/Approximations.lean` |
| `hbar_pos` | 69 | 33 | `Spacetime/Constants.lean` |
| `G_N_pos` | 64 | 20 | `Spacetime/Constants.lean` |
| `computationalUncertainty_decreasing` | 54 | 40 | `Irrationality/Uncertainty.lean` |
| `l_P_ne_zero` | 51 | 21 | `Spacetime/Constants.lean` |
| `e_error_pos` | 38 | 30 | `Irrationality/Approximations.lean` |

**Decomposition rule**: When stating a NEW physics-grade theorem, **first identify the 3-5 leaf positivity/decreasing/non-zero anchors** it pulls in. These anchors close cheaply via `have := computationalUncertainty_pos` / `positivity` / `omega`. They are Tier-99 in the truth-rank schedule (master BOOK_I PHASE B).

**Cypher** (anchor discovery):
```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})<-[r:APPLIES]-(src)
WITH t, count(r) AS indegree, count(DISTINCT src.file) AS distinct_caller_files
WHERE indegree >= 30
RETURN t.name AS name, indegree, distinct_caller_files, t.file AS file
ORDER BY indegree DESC
LIMIT 25
```

---

## Heuristic 2 — Articulation gateways have HIGH BOTH in-degree AND out-degree

Theorems whose removal would disconnect large portions of the graph have indeg ≥ 5 AND outdeg ≥ 5:

| name | indeg | outdeg | total | role |
|------|------:|-------:|------:|------|
| `realDiagonalComplex_eigenvalues_range` | 6 | 192 | 198 | D_F spectrum bridge |
| `hermitian_complex_spectrum_elt_im_zero` | 5 | 190 | 195 | hermitian-spectrum gate |
| `LeanAlgebraLaplacian_isHermitian` | 18 | 150 | 168 | magnetic-Laplacian gate |
| `l_P_pos` | 126 | 35 | 161 | physical-constant gate |
| `c_pos` | 128 | 32 | 160 | physical-constant gate |
| `grand_qm_emergence` | 6 | 144 | 150 | QM capstone gate |
| `closed1_is_exact` | 8 | 140 | 148 | Poincaré-lemma gate |
| `computationalUncertainty_pos` | 104 | 37 | 141 | substrate-error gate |
| `topQuarkMassGeV_mem_window` | 6 | 134 | 140 | top-quark window gate |
| `discreteLaplacian_const` | 19 | 99 | 118 | operator-evaluator gate |

**Decomposition rule**: When porting a new sector, **DO NOT bypass these gateways**. Route through them. They are SPOFs in the dependency tree — articulation points whose removal would disconnect entire subsystems. Refactoring them risks 100+ downstream failures.

**Cypher** (articulation candidates):
```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
OPTIONAL MATCH (t)<-[:APPLIES]-() WITH t, count(*) AS indeg
OPTIONAL MATCH (t)-[:APPLIES]->() WITH t, indeg, count(*) AS outdeg
WHERE indeg >= 5 AND outdeg >= 5
RETURN t.name, indeg, outdeg, indeg+outdeg AS total
ORDER BY total DESC LIMIT 20
```

---

## Heuristic 3 — Leiden subsystem coverage spreads decomposition into 25+ clusters

OV2 has **137+ SubsystemNavigators** (Leiden T0..T20 × G-id partitions). Top clusters are massive (5,000-15,000 members each); the corpus is **NOT** a single connected mass but a multi-layered partition. Cross-cluster bridges are paper-grade (Yoneda).

Top 10 clusters by member count:
- `T3_G901` 15,694 · `T10_G5000` 14,472 · `T4_G20720` 13,681
- `T6_G1255` 11,359 · `T5_G12196` 11,211 · `T5_G2269` 9,507
- `T7_G7800` 8,972 · `T4_G2957` 8,944 · `T4_G2107` 8,581 · `T8_G16592` 8,435

T-5 V8 closure files post-refresh will join one of T3/T10/T4 clusters depending on whether they wire into Mathlib analytical (`Analysis.Calculus.Taylor`) or OV2 in-house (`Irrationality/HermitePade`). New nodes' subsystem assignment is the FastRP+Leiden output (precompute_signals).

**Decomposition rule**: After landing, query `mcp__omega-search__subsystem_of` to see where Leiden placed the new theorem. If it's an isolated cluster, write 1-2 explicit Yoneda bridges to neighbor clusters before declaring the theorem "interconnected".

---

## Heuristic 4 — `omega_hammer_premise` composite scoring favors in-house over Mathlib for analytical goals

Test: query "Polynomial.taylor coefficient pigeonhole bound on integer offsets for Roth's theorem index reduction" (top_k=10, mix_mathlib=True).

Result ordering by composite score (sim shown):
1. `OmegaTheoryV2: taylor_tail_bound` — 0.878
2. `Mathlib: taylor_coeff` — 0.857
3. `OmegaTheoryV2: F50_decay_algebraic` — 0.852
4. `Mathlib: HasFTaylorSeriesUpToOn.of_le` — 0.823
5. `Mathlib: hasFTaylorSeriesUpToOn_univ_iff` — 0.821

**Heuristic 4a**: omega_hammer's composite scoring (cosine + PageRank + indegree + subsystem_match) prefers OV2 hits when sim > 0.85 AND structurally identical, even when Mathlib has comparable primitives. This means **decomposition should ASSUME existing OV2 boilerplate** rather than reaching to Mathlib first.

Test: query "Cauchy-Schwarz inequality multivariate for sum of squared real coefficients bounded by L2 norm".

Result:
1. `Mathlib: real_inner_le_norm` — 0.884
2. `OmegaTheoryV2: Emergence.finset_complex_cauchy_schwarz` — 0.883
3. `Mathlib: norm_inner_le_norm` — 0.873
4. `Mathlib: abs_real_inner_le_norm` — 0.877
5. `Mathlib: Orthonormal.sum_inner_products_le` — 0.858 (Bessel)

**Heuristic 4b**: For T-5 V8 Leaves 1+2 (multivariate Cauchy-Schwarz), `Emergence.finset_complex_cauchy_schwarz` already exists in OV2. NO PORT NEEDED — reuse OV2 lemma.

---

## Heuristic 5 — Compositional vs analytical theorems have a topological signature

| Profile | Outdeg range | Examples |
|---------|--------------|----------|
| Tier-99 leaf anchor | indeg 50-130, outdeg 30-40 | `c_pos`, `l_P_pos`, `pi_error_pos` |
| Capstone (paper-bundle) | indeg 0-10, outdeg 50-180 | `dirac_f_spectrum_real_unified_capstone`=174, `top_quark_absolute_paper_bundle`=145, `grand_capstone_v2_unpacked`=88 |
| Analytical workhorse | indeg 0-10, outdeg 200-650 | `eventually_periodic_digit_frequency_rational`=624, `errorTerm_bounded`=569, `taylor_tail_bound`=451, `central_diff_taylor_bound`=192 |
| Articulation gateway | indeg 5-20, outdeg 100-200 | `realDiagonalComplex_eigenvalues_range` (6/192), `LeanAlgebraLaplacian_isHermitian` (18/150) |

**Decomposition rule**: T-5 V8 paper-headline `omega_theory_v2_T5_roth_unconditional` should land at outdeg ~50-100 (composing 5 NAMED Props + Tier-99 anchors). T-5 analytical heart (the Roth proper proof) should land at outdeg ~200-400 like `taylor_tail_bound` (451). If the heart's outdeg comes out below 100, the proof is hiding work in trusted lemmas; if above 600, the proof is over-decomposed and should be cleaned.

---

## Heuristic 6 — Mathlib gap mapping: 2 of 5 V8 leaves need ZERO porting

For the 5 V8 NAMED leaves discharge plan:

**Leaf 1 (multivariate Taylor coefficient formula)** — Mathlib HAS the parts:
- `Mathlib.Algebra.MvPolynomial.PDeriv`: `pderiv_C`, `pderiv_X`, `pderiv_X_self`, `pderiv_monomial`, `pderiv_mul`, `pderiv_def`, `pderiv_eq_zero_of_notMem_vars`, `X_mul_pderiv_monomial`
- `Mathlib.RingTheory.MvPolynomial.EulerIdentity`: `IsHomogeneous.sum_X_mul_pderiv` (Euler identity)
- BUT `pderiv` ≠ multivariate Taylor coefficient directly. NEEDS hand-port: a wrapper computing `(pderiv^α f)(x)/α!` as the Taylor coefficient at multi-index α. ~50-100 lines.

**Leaves 1+2 (multivariate Cauchy-Schwarz)** — `Emergence.finset_complex_cauchy_schwarz` already exists at sim 0.883. **NO PORT — direct reuse**.

**Leaves 1+2 (pigeonhole on Taylor offsets)** — Mathlib has `Finset.exists_ne_map_eq_of_card_lt_of_maps_to`; standard pigeonhole well-stocked. ~30-line wrapper.

**Leaf 3 (Mathlib SiegelsLemma + restrictDegree wrapper)** — Mathlib HAS BOTH:
- `Mathlib.NumberTheory.SiegelsLemma`: `exists_ne_zero_int_vec_norm_le` + `_le'` (with hA ≠ 0)
- `Mathlib.NumberTheory.NumberField.House`: `exists_ne_zero_int_vec_house_le` (algebraic-integer variant)
- `Mathlib.RingTheory.MvPolynomial.Basic`: `mem_restrictDegree`, `mem_restrictDegree_iff_sup`, `restrictTotalDegree_le_restrictDegree`
- The wrapper "instantiate Siegel on the polynomial restrictDegree subspace" is a CONNECTION lemma — hand-write a 30-line bridge. NO PORTING.

**Leaf 5 (continuity of aeval)** — Mathlib HAS `continuous_aeval` in BOTH `MvPowerSeries.Evaluation` AND `PowerSeries.Evaluation` PLUS `aeval_continuousMap_apply` in `ContinuousMap.Polynomial`. **NO PORT — direct use**.

**Heuristic 6**: Two of five V8 leaves (Leaf 1+2 Cauchy-Schwarz, Leaf 5 aeval continuity) require ZERO Mathlib porting. The "Mathlib-blocked" framing is wrong — the leaves are connection-lemma decompositions, not porting blockers. Even Leaf 3 (SiegelsLemma) is connection-lemma not port. Only Leaf 1 multivariate-Taylor wrapper requires real Mathlib-extension work.

---

## Heuristic 7 — Yoneda bridge density at 0.92+ cosine, NOT 0.85

Seed `pi_transcendence_axiom_retired_unconditional`, top-10 find_similar (Qwen3 4096-dim cosine) — all results ≥ 0.91:

- 0.9499 — `pi_transcendence_axiom_retired_modulo_bridge`
- 0.9327 — `session_21_pi_transcendental_modulo_bridge_headline`
- 0.9301 — `session_21_paper_bundle`
- 0.9297 — `pi_transcendence_axiom_retirement_FINAL_paper_bundle`
- 0.9276 — `pi_transcendental_unconditional` (CustomMath core)
- 0.9272 — `pi_transcendence_axiom_retirement_paper_bundle`
- 0.9253 — `Cycle64MasterCapstone.cycle_64_master_capstone`
- 0.9249 — `pi_transcendental_via_lindemann_modulo_bridge`
- 0.9154 — `yoneda_bridge_cycle63_to_cycle64`

Second seed `Foundations.OmegaAlgebra.hopfError_pos`, top-8:
- 0.9398 — `oa_yoneda_hopfError_pos_transport`
- 0.9245 — `omega_algebra_is_minimal_for_substrate_plus_irrationals`
- 0.9168 — `substrate_joint_positivity`
- 0.9161 — `OmegaAlgebraAtTuple.hopfError_pos`
- 0.9105 — `phase_7_law_joint_minimality`
- 0.9103 — `omega_algebra_carries_both_halves_of_epistemology`
- 0.9058 — `substrateHopfError_pos`
- 0.9026 — `substrate_monotonicity_to_omega_algebra_exists`

Third seed `central_diff_taylor_bound`, top-3 all ≥ 0.92:
- 0.9707 — `central_diff_second_order_accurate`
- 0.9543 — `central_diff_taylor_bound_axis`
- 0.9263 — `partial_secondderiv_second_order_accurate`

**Heuristic 7**: Paper-grade theorems consistently produce a **same-family CLUSTER at ≥ 0.91 cosine**, NOT just ≥ 0.85. The CLAUDE.md "0.85 threshold" is conservative for routine cases; for capstones, **0.92+ is the natural boundary** of the same-family cluster. Below 0.91 you cross into adjacent-family bridges (still valuable but require explicit construction).

**Bridge file size distribution** (files containing "Bridge" or "yoneda_bridge"):
- 1 file with 23 bridges (`DiracFromLatticeDataOrphanDefBridge.lean`)
- 1 file with 22 bridges (`CrossSectorBridges.lean`)
- 2 files with 22 bridges (`AFIrreducibilityFirstAlgebraModuleBridgeInbound.lean`)
- 2 files with 19 bridges
- 2 files with 17 bridges
- 1 file with 44 bridges (`QmBridgePaperCapstone.lean` — outlier capstone)

Typical bridge file: **8-22 bridges in a single file**, average outdeg 5-30 per bridge (small forwarding theorems), with one or two giant aggregator-bridges at outdeg 50+ wrapping the whole file (e.g. `dn_bridge_to_sheliak`=54).

**Decomposition rule for paper-grade landing**:
1. Land the capstone.
2. `find_similar(seed_name, k=10, namespace='OmegaTheoryV2')`.
3. Write 8-22 small bridges to top-k targets in a `*Bridge.lean` companion file.
4. Each small bridge has outdeg 5-15 (Yoneda forwarding); one wraps them all at outdeg 50+.
5. Adds 5-15 APPLIES per bridge → total 50-300 new APPLIES per capstone landing.

---

## Heuristic 8 — APPLIES is primary; ASSUMES is essentially unused

Edge counts in OV2 (typed-edge audit):

| edge type | count | role |
|-----------|------:|------|
| APPLIES | 345,296 | **PRIMARY DEPENDENCY** |
| UNFOLDS | 312,432 | definitional unfolding |
| PARAMETRIZES_TYPES | 72,804 | type-class instance parameter |
| TopologicalNN_APPLIES | 25,701 | graph-NN propagation |
| HAS_TYPE | 13,012 | term has type |
| CONSTRAINED_BY | 9,194 | typeclass constraint |
| PARAMETRIZES_LEVELS | 3,066 | universe levels |
| SEM_CANDIDATE | 526 | semantic edge candidate |
| REWRITES_BY | 374 | rewrite-rule edge |
| SPECIALIZES | 8 | special case marker |
| GENERALIZES | 8 | reverse special case |
| DUAL_OF | 2 | category-theoretic dual |
| ASSUMES | 2 | named hypothesis (ESSENTIALLY UNUSED) |

**Decomposition rule**: When traversing the graph for proof-decomposition planning, use APPLIES (and APPLIES* for transitive closure). UNFOLDS is needed only for definition-traversal. **DO NOT** rely on ASSUMES for NAMED-Prop tracking — the typed extractor doesn't materialize ASSUMES edges from `(h : H) → goal`-shaped lemmas. Use file-scoped Cypher matching by name pattern (`name CONTAINS 'NAMED'`) instead.

---

## Heuristic 9 — find_similar vs retrieve_premises vs lean_loogle: when each wins

Empirical comparison on T-5-relevant goals:

| query type | best tool | reason |
|------------|-----------|--------|
| "I have a SEED THEOREM and want kNN-similar" | `find_similar` | direct kNN on full embedding |
| "I have a Lean GOAL and want premise candidates" | `omega_hammer_premise` (mix_mathlib=True) | composite score (sim + PR + indegree + subsystem) over OV2+Mathlib |
| "I have a SHORT GOAL and want only Mathlib hits" | `retrieve_premises` (namespace='Mathlib') | Mathlib-only filter, optional rerank |
| "I want lemma BY TYPE PATTERN like `Real.sqrt _ ^ 2 = _`" | `lean_loogle` | type-pattern matching engine, no embedding |
| "I want lemma BY NATURAL-LANGUAGE description" | `lean_leansearch` | LM-search with NL queries |
| "I want what closes THIS GOAL right now" | `lean_state_search` | goal-closing oracle |

**Heuristic 9 — empirical priority order**:
1. **For named seed theorem**: `find_similar` first (cheap kNN, no rerank needed for ≥ 0.92 cluster).
2. **For abstract goal text**: `omega_hammer_premise` (best for in-house+Mathlib mix; no rerank since 2026-04-25).
3. **For Mathlib-only narrow query**: `retrieve_premises(namespace='Mathlib', rerank=true)` when ambiguous (rerank ~1s/pair).
4. **For type-pattern when name unknown**: `lean_loogle`.

`lean_loogle` and `find_similar` complement each other: loogle catches structure, find_similar catches semantic family. For T-5 leaves I'd run BOTH per leaf.

---

## Aggregate decomposition heuristic (synthesis for `divide-et-impera`)

When given a NEW theorem statement T to decompose:

1. **Identify Tier-99 anchors**: which of `c_pos`, `l_P_pos`, `pi_error_pos`, `computationalUncertainty_pos`, `hbar_pos`, etc. does T need? Discharge first via `have := <anchor>; positivity`.

2. **Search articulation gateways**: query `find_similar(T's seed, k=10, namespace='OmegaTheoryV2')`. If the cluster includes a known articulation gateway (indeg ≥ 5 AND outdeg ≥ 100), route T through it; do not bypass.

3. **Compute Mathlib gap**: for each NAMED leaf in T's decomposition, run `omega_hammer_premise(leaf_goal, top_k=10, mix_mathlib=True)`. If top-3 are all OV2 hits at sim > 0.85, the leaf is in-house-discharged. If top-3 are Mathlib hits at sim > 0.85, port directly. If top-3 are mixed but no single hit > 0.85, the leaf is a CONNECTION LEMMA needing a hand-written 30-line bridge.

4. **Truth-rank Hindry-Silverman**: leaves where omega_hammer's #1 hit ≥ 0.90 sim are Tier-99 (discharge first). Leaves at 0.80-0.90 are Tier-80. Leaves below 0.80 are Tier-Heart (single-thread, web-search literature, may require 2-3 sub-iterations).

5. **Outdeg-target check**: T's expected outdeg from its profile (capstone 50-180, analytical workhorse 200-650). If you've decomposed into far more leaves than the outdeg target, you're over-decomposing; consolidate. If far fewer, you're hiding work in trusted lemmas; further decompose.

6. **Yoneda bridges post-landing**: `find_similar(T, k=10, namespace='OmegaTheoryV2')`; for each result with sim ≥ 0.91, write a small forwarding bridge (outdeg 5-15). Write 8-22 such bridges in a single `<TopicName>Bridge.lean` companion file with one outdeg-50+ aggregator. Adds 50-300 APPLIES per landing, prevents Leiden-cluster isolation.

7. **Verify**: `axiom_audit` returns `[propext, Classical.choice, Quot.sound]` only. `find_similar` shows ≥ 1 result at sim ≥ 0.92 (proves new theorem joined an existing cluster). If isolated, decomposition was insufficiently grounded.

---

## Concrete Cypher cookbook (all queries verified live)

**Q1 — Tier-99 anchors (in-degree leaderboard)**:
```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})<-[r:APPLIES]-(src)
WITH t, count(r) AS indegree, count(DISTINCT src.file) AS distinct_caller_files
WHERE indegree >= 30
RETURN t.name AS name, indegree, distinct_caller_files, t.file AS file
ORDER BY indegree DESC LIMIT 25
```

**Q2 — Articulation gateways**:
```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
OPTIONAL MATCH (t)<-[:APPLIES]-() WITH t, count(*) AS indeg
OPTIONAL MATCH (t)-[:APPLIES]->() WITH t, indeg, count(*) AS outdeg
WHERE indeg >= 5 AND outdeg >= 5
RETURN t.name, indeg, outdeg, indeg+outdeg AS total
ORDER BY total DESC LIMIT 20
```

**Q3 — Top capstones by outdeg**:
```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.name CONTAINS 'capstone' OR t.name CONTAINS 'paper_bundle'
   OR t.name CONTAINS 'unconditional' OR t.name CONTAINS 'paper_headline'
OPTIONAL MATCH (t)-[r:APPLIES]->()
WITH t.name AS name, count(r) AS outdeg, t.file AS file WHERE outdeg >= 5
RETURN name, outdeg, file ORDER BY outdeg DESC LIMIT 20
```

**Q4 — Edge type distribution**:
```cypher
MATCH (a:Theorem {namespace: 'OmegaTheoryV2'})-[r]->(b)
WHERE b:Theorem OR b:Definition OR b:Axiom OR b:Structure
RETURN type(r) AS edge_type, count(*) AS count ORDER BY count DESC
```

**Q5 — Yoneda bridges per file (decomposition norm-check)**:
```cypher
MATCH (b:Theorem {namespace: 'OmegaTheoryV2'})
WHERE b.name =~ '.*[Bb]ridge.*'
WITH b.file AS file, count(b) AS bridges_per_file
WHERE bridges_per_file >= 3
RETURN file, bridges_per_file ORDER BY bridges_per_file DESC LIMIT 20
```

**Q6 — Subsystem coverage (Leiden)**:
```cypher
MATCH (sub:SubsystemNavigator {namespace: 'OmegaTheoryV2'})-[:CONTAINS]->(t:Theorem)
WITH sub, count(t) AS members WHERE members >= 50
RETURN sub.subsystem_id, sub.name, members ORDER BY members DESC LIMIT 25
```

**Q7 — Ancestor anchors of a target capstone (transitive-APPLIES out)**:
```cypher
MATCH (capstone:Theorem {namespace: 'OmegaTheoryV2', name: $capstone_name})
MATCH (capstone)-[:APPLIES*1..3]->(leaf:Theorem)
WITH leaf, count(*) AS depth_count
RETURN leaf.name, depth_count, leaf.file ORDER BY depth_count DESC LIMIT 30
```

**Q8 — Mathlib gap probe (e.g. SiegelsLemma module exists?)**:
```cypher
MATCH (t:Theorem {namespace: 'Mathlib'})
WHERE t.file CONTAINS 'SiegelsLemma' OR t.name CONTAINS 'restrictDegree'
RETURN t.name, t.file LIMIT 20
```

---

## Bottom line for `divide-et-impera`

The graph confirms the canonical 5-PHASE HYBRID decomposition strategy (master BOOK_I COMBAT_DOCTRINE) is empirically calibrated:

- **Tier-99 leaves**: Tier-99 anchors are a tight set of ~20 positivity/non-zero/decreasing primitives. Almost every theorem in OV2 routes through them.
- **Articulation gateways**: ~20 high-traffic theorems are routing nodes; bypassing them creates orphan sub-graphs.
- **Outdeg signature**: capstone 50-180, analytical workhorse 200-650 — use this as a smoke-test on new landings.
- **Yoneda threshold**: ≥ 0.91 cosine for same-family cluster (not 0.85). Below 0.91 you cross adjacent-family.
- **Mathlib gap**: Mathlib has more than CLAUDE.md gives it credit for. 2/5 V8 Leaves need ZERO porting; 2/5 are connection-lemma wrappers; only 1/5 (multivariate-Taylor coefficient) needs a real port.
- **Tool routing**: `find_similar` for seeded kNN; `omega_hammer_premise(mix_mathlib=True)` for goal text; `lean_loogle` for type patterns; `lean_state_search` for closing-oracle. Run BOTH find_similar and loogle per leaf — they complement.

The `divide-et-impera` skill should encode all 7 numbered heuristics in the synthesizer's unified file with the cypher cookbook attached as appendix.
