# Handoff — OmegaTheory V2 / Chaos Shield

**Written 2026-04-23 for the next session (or a fresh agent with no prior context).**

This document captures where the project is, what runs, and exactly what to do next. If you've never touched this repo, read this top-to-bottom once, then jump to "Immediate next actions".

---

## 1. What this project is

OmegaTheory V2 derives quantum mechanics + general relativity + the Standard Model from **8 physical constants** on a ℤ⁴ Planck lattice, formalized in Lean 4. Central thesis ("Pi Hunch"): **the irrationality of π, e, √2, and Catalan-G produces quantum uncertainty** — the four irrationals map to 3 SM generations + 1 sterile/DM channel.

**4 pillars** that every active workstream traces back to:

1. **Irrationality classes** — π / e / √2 / Catalan-G occupy 4 distinct `TruncOrigin` classes (NOT Mahler A/S/T/U). 31 sub-theorems target.
2. **Standard Model algebra** — Connes `A_F = ℂ ⊕ ℍ ⊕ M₃(ℂ)` + `D_F` eigenvalues → Yukawa masses.
3. **4-channel fibration** — NOT a partition; Leiden-fibered over 14 subsystems.
4. **Pi Hunch frontier** — `Δx·Δp ≥ ℏ/2 + δ_comp(N)`; strictness proved, saturation/tightness/uniqueness/stability landed today.

**Full context** in `PhysicsPapers/LeanFormalizationV2/plans/GROTHENDIECK_MATH_PUZZLE.md` (969 lines, Navi cycle 43).

---

## 2. Current state (2026-04-23)

**Build health:**
- **3,870 jobs GREEN** in Lean 4 v4.29.0 + Mathlib v4.29.0
- **0 sorry**
- **9 paper-story axioms** (down from 24 — Acrab wave-C reduced 15)
- **11 env axioms** total (8 physical + 1 `Real.pi_transcendental` + 2 `native_decide` auto-gen)

**Corpus:**
- **9,361 theorems** in OmegaTheoryV2 namespace
- **175,137 theorems** in Mathlib namespace (co-ingested)
- **~4M edges** across 12 V3-for-Lean arrow types (APPLIES, UNFOLDS, IMPORTS, HAS_TYPE, ...)
- **100% embedded** — Qwen3-Embedding-8B, dim 4096, vector index `lean_retriever_embedding_theorem`

**Today's waves (landed):**
- **Wave A (Homam, Irrationality)** — 3 theorems: `canonicalDFSpectrum_lambda_catalan_via_catalanKernel`, `extendedBound_uniqueness_nontrivial_characterization`, `pi_hunch_saturating_state_is_gaussian`
- **Wave B (Alkalurops, StandardModel)** — 3 theorems: `yukawa_spectral_action_recovers_fermion_masses_bridge`, `right_handed_lepton_doublet_CP_dual_completion`, `dixmier_trace_placeholder_interface_for_spectral_action`
- **Wave C (Acrab, axiom elimination)** — 8 research axioms eliminated via opaque-conversion + theorem-derivation
- **Kornephoros top-20 proposals** + **Alphecca Wave D+E follow-up brief** persisted in Neo4j

**Services up** (check with `nc -z localhost <port>`):
- **`:7687`** — Neo4j `math` container (bolt://localhost:7687, auth `neo4j/omegatheory2026`). Custom 16GB heap + 32GB pagecache. APOC + GDS + GenAI plugins.
- **`:7999`** — Qwen3-Embedding-8B Q8_0 GGUF, GPU (RX 9060 XT via ROCm 7.2), supervised by `supervise_llama.py embed_gpu`. **43 emb/s @ batch=50.**
- **`:7996`** — Qwen3-Reranker-8B Q6_K GGUF, CPU (Ryzen 9950X AVX-512 VNNI), 16 threads pinned to physical cores. **~1s/pair** — use on demand for precision.

Restart protocol:
```bash
setsid ~/genai_env/bin/python ~/services/supervise_llama.py embed_gpu > /tmp/sup_emb.log 2>&1 < /dev/null & disown
setsid ~/genai_env/bin/python ~/services/supervise_llama.py reranker_cpu > /tmp/sup_rer.log 2>&1 < /dev/null & disown
```

---

## 3. Immediate next actions (do these first)

### Step 1 — Dispatch Wave D + Wave E (6 more theorems, 122 unblocks)

Alphecca's brief at `PhysicsPapers/LeanFormalizationV2/plans/GROTHENDIECK_WAVE_D_E_2026-04-22.md`. Two parallel wizard waves:

**Wave D (75-90% close rate, 58 unblocks):**
| # | Theorem | Unblocks | Why |
|---|---|---|---|
| D-1 | `Z_sterile_yield_per_BH_from_connes_DF_via_catalanKernel` | 24 | Kaskada Homam'owego Catalan kernel w DM/baby-universe |
| D-2 | `mass_ratio_e_mu_from_sqrt2_e_channel_ratio_numerical_at_N4` | 16 | First closed-form Koide ratio at N=4 |
| D-3 | `dixmier_trace_vanishes_on_trace_class_strictly` | 18 | Repair dla Alkalurops' axiom (ii) weakness |

**Wave E (60-80% close rate, 64 unblocks):**
| # | Theorem | Unblocks | Why |
|---|---|---|---|
| **E-1** ⭐ | `fibration_connectivity_c18_c22_via_delta_comp_wave_E` | **25** | **THE biggest paper closure — repairs last zero-edge structural defect. After landing, paper can claim "all 3 defects repaired"** |
| E-2 | `four_channel_magnetic_laplacian_spectral_gap_proof` | 22 | Test 4-band gap on SPECTRAL level |
| E-3 | `seeley_dewitt_a4_closed_form_Higgs_substrate_derived` | 17 | Gives Dixmier interface a substantive consumer |

**How to dispatch (template for each wave):**

```python
Agent(
  subagent_type="lean-proof-wizard",
  model="opus",
  run_in_background=True,
  description="Wave D — D-1 D-2 D-3 batch",
  prompt="""
  **Wave D — follow-up to wave A+B, batch_id: wave_D_E_2026-04-22**

  Close these 3 theorems. Query their full context:
    MATCH (tc:TheoremCandidate {batch_id: 'wave_D_E_2026-04-22', name: <name>})
    RETURN tc.proposed_signature, tc.rationale, tc.proof_pathway_sketch,
           tc.premise_availability, tc.downstream_unblocks

  <paste the 3 rows from Alphecca's brief>

  Working tree: ~/lean-v2/. After green, rsync to /mnt/c/... and update
    MATCH (tc:TheoremCandidate {name: $name}) SET tc.status='CLOSED_BY_LEAN_LANDING',
      tc.closed_by=$star_name, tc.file_landed=$file, tc.line_landed=$line,
      tc.wave_id='wave_D_theorems_2026-04-23'

  Gates: 3,870+ jobs GREEN, 0 sorry, 9 paper axioms unchanged.
  Never sorry. Never add physical axiom. Star-name from :ReservedName-free.
  """
)
```

Launch both waves in a **single message** (parallel). Each takes ~20-25 minutes real time.

### Step 2 — After waves land, refresh graph

```bash
cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error
~/.elan/bin/lake exe dump_decls --out .neo4j/declarations_from_env_v2.jsonl
~/.elan/bin/lake exe dump_arrows --out .neo4j/arrows_from_env_cycle45.jsonl --include-mathlib
cd .neo4j
~/genai_env/bin/python load_declarations_env_v2.py
~/genai_env/bin/python load_arrows_parallel.py arrows_from_env_cycle45.jsonl --workers 16 --batch 1000
~/genai_env/bin/python reembed_qwen3_delta.py
```

Typical timings: build ~4min · dump_decls ~30s · dump_arrows ~2min · load_decls ~3s · load_arrows ~8s · reembed ~20min (for ~100 new theorems, 1 rec/s single-thread — can be parallelized via `reembed_qwen3_parallel_3way.py`).

### Step 3 — Dispatch next grothendieck discovery wave

After waves D+E land, Kornephoros/Alphecca should re-rank remaining candidates. The cascade (top-3 picks unlocked 122 downstream) validated the leverage-scoring method. Send:

```
SendMessage(to="aaad6d46d270f8dd0",
  message="Wave D+E status: <N> landed. Re-rank next 6 candidates from #7-20 backlog
  accounting for new unlocks. Deliver Wave F+G brief.")
```

---

## 4. Pending theorem pool (beyond Wave D+E)

Query current OPEN candidates:

```cypher
MATCH (tc:TheoremCandidate {status: 'OPEN'})
RETURN tc.batch_id, tc.pillar, tc.tag, tc.priority, tc.name, tc.downstream_unblocks
ORDER BY coalesce(tc.downstream_unblocks, 0) DESC
```

**Kornephoros top-20 (`batch_id: top20_leverage_2026-04-22`)** — 17 remaining after A+B landed 3 of them. Alphecca's Wave D+E covers next 6. Remaining 14 after that:
- `qm_community_fiber_has_all_four_channels` (22 unblocks)
- 13 others — query Neo4j for full list

**13 BLOCKED_ON_MATHLIB (`ic_*`)** — require Mathlib upstream work:
- `ic_Lindemann_Weierstrass_to_Mathlib` — deep, would retire `Real.pi_transcendental` axiom
- `ic_Roth_theorem_port` — Roth 1955
- `ic_Mahler_classification_framework` — A/S/T/U classes
- `ic_rivoal_zudilin_2003_port` — ζ(2k+1) irrationality
- `ic_Shidlovsky_theorem_port` — Siegel-Shidlovsky
- `ic_sqrt2_Mahler_A_class` — **OPEN_EASY** (still achievable, algebraic class trivial)
- plus 7 more — see Acrab's brief `plans/PI_FORMALIZER_AXIOM_ELIMINATION_2026-04-22.md`

---

## 5. How to think about what to attack next

**Grothendieck-sage** (graph discovery agent, model: opus) is the right tool for deciding **WHAT** to prove. Do not decide this yourself by grep.

Spawn pattern:
```python
Agent(
  subagent_type="grothendieck-sage",
  model="opus",
  run_in_background=True,
  prompt="Mission: re-rank the remaining top-20 candidates + 14 newly newly-ripe candidates from recent cascade.
  Full SOTA stack: kNN via :7999, rerank via :7996, graph via :7687.
  Deliver next wave brief at plans/GROTHENDIECK_WAVE_F_G_<date>.md."
)
```

**Lean-proof-wizard** (proof agent, model: opus) is the right tool for **CLOSING** theorems. They actually edit `.lean` files, run `lake build`, and update `:TheoremCandidate` status.

Never mix roles. Grothendieck proposes, wizard closes. Wizard cannot propose; grothendieck cannot prove.

---

## 6. Key file locations

**Lean source:**
- `~/lean-v2/` — native ext4 working tree (fast builds, 115× faster than /mnt/c)
- `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/` — committed tree, rsync target

**Agent definitions:**
- `PhysicsPapers/LeanFormalizationV2/.claude/agents/grothendieck-sage.md` — discovery agent (750 lines, recently updated 2026-04-22 to forbid proof writing)
- `PhysicsPapers/LeanFormalizationV2/.claude/agents/lean-proof-wizard.md` — proof agent
- `PhysicsPapers/LeanFormalizationV2/.claude/agents/pi-formalizer.md` — axiom elimination specialist

**Active wave briefs:**
- `plans/GROTHENDIECK_TOP20_LEVERAGE_2026-04-22.md` — Kornephoros top-20, 290 unblocks
- `plans/GROTHENDIECK_WAVE_D_E_2026-04-22.md` — Alphecca next 6, 122 unblocks
- `plans/PI_FORMALIZER_AXIOM_ELIMINATION_2026-04-22.md` — Acrab wave-C full report

**Services:**
- `~/services/llama_embed_gpu.sh` — GPU embedder launcher
- `~/services/llama_reranker_cpu.sh` — CPU reranker launcher
- `~/services/supervise_llama.py` — supervisor with auto-restart + health check
- `~/services/omega_search_mcp.py` — MCP bridge (6 tools: retrieve_premises, rerank_documents, find_similar, neighbors, explain_theorem, subsystem_of)

**Neo4j pipeline:**
- `~/lean-v2/.neo4j/load_declarations_env_v2.py`
- `~/lean-v2/.neo4j/load_arrows_parallel.py`
- `~/lean-v2/.neo4j/reembed_qwen3_delta.py`

**Lean metaprogram dumpers:**
- `~/lean-v2/OmegaTheory/Meta/DumpDeclarations.lean` (Schedar)
- `~/lean-v2/OmegaTheory/Meta/DumpArrows.lean` (Sheratan)

---

## 7. Critical rules (hard gates — never violate)

1. **0 sorry** in Lean. Ever.
2. **0 new axioms** beyond the 9 paper-story. 8 physical + `Real.pi_transcendental` = hard cap.
3. **Must compile GREEN** before claiming "done". 3,870+ jobs is the post-Wave-ABC baseline.
4. **Never commit without explicit user approval** in auto mode.
5. **Grothendieck does NOT prove** — escalate via SendMessage to parent, parent dispatches wizard.
6. **Native ext4 for iteration** — `~/lean-v2/` for `lake build`; rsync to `/mnt/c/...` only when ready for commit.

---

## 8. Quick-check commands

```bash
# Service health
curl -s http://localhost:7999/health  # embedding GPU
curl -s http://localhost:7996/health  # reranker CPU
nc -z localhost 7687                  # Neo4j bolt

# Build health
cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error
grep -rc '\bsorry\b' ~/lean-v2/OmegaTheory/   # must be 0

# Graph health
~/genai_env/bin/python -c "
from neo4j import GraphDatabase
d = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j','omegatheory2026'))
with d.session() as s:
    r = s.run('MATCH (t:Theorem {namespace:\"OmegaTheoryV2\"}) RETURN count(t) AS n, count(t.embedding_lean) AS e').single()
    print(f'{r[\"n\"]} theorems / {r[\"e\"]} embedded')
"

# Open TheoremCandidate count
~/genai_env/bin/python -c "
from neo4j import GraphDatabase
d = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j','omegatheory2026'))
with d.session() as s:
    r = s.run('MATCH (tc:TheoremCandidate {status:\"OPEN\"}) RETURN count(tc) AS n, sum(coalesce(tc.downstream_unblocks,0)) AS total_unblocks').single()
    print(f'{r[\"n\"]} OPEN candidates, {r[\"total_unblocks\"]} total unblocks potential')
"
```

---

## 9. Where to look when confused

- **What is the Pi Hunch?** `PhysicsPapers/CLAUDE.md` section "The Pi Hunch (central thesis)"
- **Why 4 pillars?** `plans/GROTHENDIECK_MATH_PUZZLE.md` (Navi cycle 43, 969 lines, authoritative)
- **What's in the paper?** `PhysicsPapers/Main-Paper-Postulates.md`
- **Why axiom count matters?** `Complete-Omega-Theory-Unified-Framework.md`
- **Recent cycle logs** — `PhysicsPapers/LeanFormalizationV2/notes/NOTES_CYCLE24..43_*.md` (14 files)

---

## 10. If you are a fresh agent

**Read these in order** before doing anything:
1. This file (handoff.md)
2. `.claude/CLAUDE.md` (project-level rules)
3. `PhysicsPapers/CLAUDE.md` (Lean/Neo4j pipeline)
4. `PhysicsPapers/LeanFormalizationV2/CLAUDE.md` (V2 agent onboarding)

**Check that services are running** (§3 Step 1 restart commands if not).

**Then dispatch Wave D + Wave E** (§3 Step 1) and wait for them to land. Do NOT attempt proofs yourself — use lean-proof-wizard agent.

**When in doubt**, query Neo4j for the current state rather than reading stale docs. The graph is the authoritative source of truth for what's OPEN / CLOSED / PROPOSED.

---

**End of handoff.**

Today's progress: 14 theorems landed (6 wizard + 8 opaque conversions), 15 axioms retired (24→9), disk reclaimed 213G, full retrieval stack (kNN + rerank) production-ready. Next: Wave D + E dispatch, then grothendieck re-rank, then cycle 45 continues.
