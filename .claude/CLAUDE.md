# Claude Code Project Instructions — Chaos Shield / OmegaTheory V2

## Orchestrator MCP
`omega-orchestrator` MCP exposes 22 tools across 6 buckets: **servers** (lifecycle),
**graph** (ingest), **embed**, **inspect** (`cycle_state`/`build_status`/`axiom_audit`),
**jobs** (async), **wizard** (`propose_proof`/`omega_hammer_premise`). Prefer MCP
over raw shell+Cypher. Hammers use composite scoring only — `rerank` parameter
removed 2026-04-25.

## System Specifications

```
Machine: AMD Ryzen 9 9950X (16 cores / 32 threads), 192 GB RAM
WSL2:    160 GB RAM, 32 processors, 32 GB swap
GPU:     AMD RX 9060 XT 16 GB (gfx1200, ROCm 7.2.1 + PyTorch 2.9.1)
```

## Lean 4 Build — WSL-native, NO `wsl.exe` wrapper

This session is already inside WSL; run `lake` and `bash` directly.
Elan / Lake installed at `~/.elan/bin/`. Toolchain: Lean v4.29.0 + Mathlib v4.29.0.

### Build commands
```bash
# /mnt/c committed tree (slow — mountpoint overhead; use for diffs + commits)
cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2
~/.elan/bin/lake build --log-level=error
~/.elan/bin/lake build OmegaTheory.Module --log-level=error   # one module
~/.elan/bin/lake exe cache get                                # Mathlib cache

# ~/lean-v2 native ext4 (115× faster single-file build — use for iteration)
cd ~/lean-v2
~/.elan/bin/lake build --log-level=error
```

### `lake update` vs `lake build`
- `lake update` — only when changing Mathlib version or adding a dependency
  in `lakefile.toml`. After `lake update`, always `lake exe cache get`.
- `lake build` — everything else (new imports from existing Mathlib, edits,
  fixing proofs). Mathlib is already installed; `lake build` just links.

## Server hygiene rule (2026-04-24 — IMPORTANT)

**Kill embedding + reranker servers when no retrieval-using agent is active.**
User's explicit concern: computer heat/power over long sessions. Servers:
- `:7999` — Qwen3-Embedding-8B GPU (llama.cpp HIP on RX 9060 XT)
- `:7996` — Qwen3-Reranker-8B CPU (llama.cpp AVX-512 on Ryzen 9950X)

Use `mcp__omega-orchestrator__servers_control(action='start'|'stop'|'status')`
to manage both servers atomically (multi-pass kill, port-centric status, boot
grace). The MCP enforces the hygiene rule.

Full memory: `feedback_kill_servers_when_idle_2026-04-24.md`.

## HARD RULES
1. **0 sorry** in Lean — absolutely never.
2. **0 new axioms / primitive assumptions.** Honest accounting post-2026-04-24
   Lesath opaque-bundle refactor:
   - **0 `axiom` declarations for physical constants** — c, ℏ, G_N, k_B are
     `noncomputable opaque X_bundle : {x : ℝ // 0 < x}`, Classical.choice from
     Lean core (NOT `axiom` keyword).
   - **MATHEMATICALLY still 4 physical existence postulates** (no specific
     numeric value fixed; derivations parametric).
   - **+ 1 transcendence axiom** `Real.pi_transcendental` (upstream Mathlib
     Lindemann–Weierstrass) = **5 primitive assumptions** paper-total.
   - **+ 4 HermitePadé research axioms** (Siegel-Shidlovskii, Nesterenko 1996,
     Roth 1955, Mahler framework) = **9 total including research**, sealed in
     `Irrationality/HermitePade/`.
   - Three-way split: `0 axiom-declarations · 5 primitive-assumptions · 9 total`.
3. **Must compile GREEN** before reporting done. **3,901 jobs / 0 sorry** is the
   cycle-44-extension baseline (up from 3,835 post-cycle-43 / 3,870 post-wave-E).
   Do not regress.
4. **Quality over speed** — iterate on errors until clean.
5. **Narrower true theorem > false dressed-up claim.**
6. **Do not write outside chaos-shield** unless the task explicitly targets
   `~/papers/` or `~/services/` (V3-for-Lean adaptation work).

## Proof Automation — USE BEFORE manual proof
```lean
-- SEARCH
exact?          -- search Mathlib + local (30 s, most powerful)
apply?          -- find applicable lemmas
rw?             -- find rewrite targets
simp?           -- show closing simp lemmas

-- AUTOMATED SOLVERS
aesop           -- white-box best-first proof search
grind           -- SMT-style (Gröbner + cutsat, Lean 4.22+)
omega           -- Presburger arithmetic (ℤ/ℕ)
norm_num        -- numeric normalization
linarith / nlinarith / polyrith   -- linear / nonlinear / polynomial
positivity      -- 0 < x or 0 ≤ x
ring / field_simp   -- ring equalities / clear denominators
decide / native_decide   -- exhaustive finite check

-- DOMAIN-SPECIFIC
fun_prop        -- continuity / differentiability
gcongr          -- generalized congruence (monotonicity)
push_cast       -- push coercions through
fin_cases       -- case split on Fin n
```

### Strategy
1. `exact?` first (30 s search over 210 K+ lemmas + ~9,500 OmegaTheory theorems).
2. `aesop` or `grind` for multi-step.
3. `simp [lemmas]` or `positivity`.
4. `ring` / `field_simp; ring` for algebraic identities.
5. `linarith` / `nlinarith` for inequalities.
6. `decide` for finite enumeration.
7. Manual only when all above fail.

## Mathlib v4.29.0 name changes (CRITICAL)
- `div_le_iff₀` / `div_lt_iff₀` — note ₀ suffix
- `mul_div_cancel₀` — needs `ne_zero`
- `Finset.not_mem_empty` — not `Finset.mem_empty`
- `Mathlib.Algebra.BigOperators.Group.Finset` (not `.Basic`)
- `Mathlib.Data.Nat.Cast.Order.Basic`
- `Mathlib.Data.Int.Basic` removed (Int is in Lean core)

Use `lean_loogle` or `lean_leansearch` to find renamed modules.

## Project Structure

```
chaos-shield/
├── PhysicsPapers/
│   ├── CLAUDE.md                 ← Lean + Neo4j pipeline + post-cycle-43 state
│   ├── LeanFormalizationV2/      ← Lean 4 source tree (294 .lean files committed)
│   │   ├── CLAUDE.md             ← V2-specific agent onboarding
│   │   ├── STYLE_GUIDE.md
│   │   ├── OmegaTheory/          ← 16 subdirs; largest: Emergence/132, Predictions/40
│   │   ├── notes/                ← 20 post-triage files
│   │   ├── plans/                ← active backlog + Grothendieck reports
│   │   └── .neo4j/               ← Cypher ingest pipeline (V3-for-Lean)
│   ├── papers/                   ← public papers (QM-From-Discrete-Gravity, DE preview)
│   ├── submissions/              ← LaTeX submission bundles
│   └── research/                 ← STRATEGIC_FORMALIZATION_PLAN + recipes
└── .claude/
    └── CLAUDE.md                 ← this file
```

Native ext4 mirror at `~/lean-v2/` (428 .lean files incl. Meta/ dump executables
+ uncommitted dev files). Use `~/lean-v2` for fast iteration, sync back to
`/mnt/c` only when ready to commit.

## Status — 2026-04-24 (cycle-44-extension, post Lesath opaque-bundle refactor)

- **3,901 build jobs GREEN**, 0 sorry
- **Primitive assumptions (honest accounting):** `0 axiom-declarations · 5
  primitive-assumptions · 9 total-including-research`
  - **0 `axiom` declarations for physical constants** — c, ℏ, G_N, k_B realised
    as `noncomputable opaque X_bundle : {x : ℝ // 0 < x}` via `Classical.choice`
    (Lean core, NOT `axiom` keyword).
  - MATHEMATICALLY these 4 opaque bundles remain **existence postulates** for
    positive reals — no specific numeric value fixed, all derivations parametric.
  - **+ 1 transcendence axiom** `Real.pi_transcendental` (pending Mathlib
    Lindemann–Weierstrass) = **5 primitive assumptions** paper-total.
  - **+ 4 HermitePadé research axioms** (Siegel-Shidlovskii, Nesterenko 1996,
    Roth 1955, Mahler framework) = **9 total** including research track.
- **~9,500 OmegaTheoryV2 own theorems** (9,794 declarations in graph post-session)
  on top of **~175,127 Mathlib** = **~184,627 total**
- **Cycles 2–43 all shipped** + cycle-44 extension (14 theorems landed,
  axioms 24→9 via Acrab opaque-conversion pattern, then 9→1 paper-headline via
  Lesath opaque-bundle refactor on physical constants).
- **Grand Capstone V2** locked by Polaris (`omega_theory_v2_final_meta_capstone`)
- **HPW axiom DELETED** 2026-04-17 — all 7 regime witnesses re-derived.

### Historical baseline (2026-04-21, post-cycle-43)
- 3,835 build jobs GREEN, 0 sorry, 8 physical axioms (+ 15 HermitePadé + 1
  π-transcendental = 24 total). 8,996 OmegaTheoryV2 own + 175,137 Mathlib =
  184,133 total.

## Neo4j Knowledge Graph

Container `math`, bolt://localhost:7687, neo4j/omegatheory2026. APOC + GDS +
GenAI plugins loaded. See `PhysicsPapers/CLAUDE.md` for query recipes.

Key namespaces in the graph:
- `OmegaTheoryV2` — declarations + FastRP embeddings (~9,500 own theorems;
  9,794 declarations post-session 2026-04-24; 8,996 historical Apr-21 baseline)
- `Mathlib` — integrated Mathlib v4.29.0 corpus (~175,127 theorems)
- `LeanAlgebra` — V3 schema scaffold (6 vertex types × 15 arrows)

Graph state (live 2026-04-21): 88 `:GraphFinding` (44 paper_worthy) + 166
`:TheoremCandidate` (52 closed / 113 open / 1 blocked) + 677 `:SubsystemNavigator`.

## Custom agents (`PhysicsPapers/LeanFormalizationV2/.claude/agents/`)

- `omega-team-lead` — coordinates wizard + creative pairs in cycles
- `lean-proof-wizard` — Lean 4 specialist, all tactics + build commands
- `quantum-physics-creative` — physics ideas + literature search
- `grothendieck-sage` — graph synthesis over 184K-theorem Lean + Mathlib graph
- `pi-irrationality-hunter` — Pi-Hunch specialist (π-truncation, generations)
- `pi-formalizer` — Lean formalization of π + Hermite–Padé
- `pi-physics-bridge` — π math → physical predictions

Agents choose their own names from a star catalog (Rigel, Saiph, Alnilam, Vega,
Polaris, Navi, Mekbuda, Dubhe, Naos, Schedar, Sheratan, etc.) and log identity
under `.claude/agent-memory/`.

## MCP tools

### `omega-orchestrator` (22 tools, 6 buckets — the project's primary MCP)

**Servers (lifecycle):** `servers_control(action=start|stop|status|restart)` ·
`swap_profile(target_profile)`.

**Graph (ingest):** `ingest_graph(run_dump, run_load, dry_run) → job_id` (async) ·
`precompute_signals` (sync, ~3s) · `refresh_graph(dry_run) → job_id` (async,
returns job_id; poll `job_status(id)` for live `progress` field — step name +
status + elapsed_s — and `job_tail(id, n)` for stdout. Avoid `sync_mode=True`
unless dry-run; sync blocks the MCP stdio loop and risks disconnect).

**Embed:** `embed_nodes(names, fields)` · `embed_delta(fields, namespace, since)` ·
`embed_candidates(statuses)`.

**Inspect (read-only):** `candidate_status(filter)` · `build_status()` ·
`graph_health()` · `cycle_state(running_wizard_count, landings_since_last_refresh)` ·
`axiom_audit(targets)` · `cache_stats()` · `phase_detect(...)`.

**Jobs (async control):** `job_status(id)` · `job_tail(id, n)` · `job_cancel(id)` · `job_list()`.

**Wizard (retrieval):** `propose_proof(goal, wizard_name, k, namespace)` →
tactic stub + 5 cited premises + graph_rationale · `omega_hammer_premise(goal, top_k, mix_mathlib)` →
top-K ranked premises · `upsert_theorem_candidate(...)`.

Both hammers use composite-only scoring (cosine + pagerank + indegree +
subsys_match); `rerank` parameter removed 2026-04-25 (was ~1s/pair, blocked
concurrent agents).

### Other MCPs
- `lean-lsp` — `lean_leansearch`, `lean_loogle`, `lean_local_search`,
  `lean_goal`, `lean_diagnostic_messages`, `lean_multi_attempt`, etc.
- `neo4j-math` — `read_neo4j_cypher`, `write_neo4j_cypher`, `get_neo4j_schema`
- Embedding servers: Qwen3-8B on `:7999` (GPU), reranker on `:7996` (CPU) —
  managed by `servers_control`.

## Where to look next

- `PhysicsPapers/CLAUDE.md` — Lean + Neo4j pipeline + cycle 24–43 bundle
- `PhysicsPapers/LeanFormalizationV2/CLAUDE.md` — V2 agent onboarding + HARD RULES
- `PhysicsPapers/LeanFormalizationV2/.neo4j/CLAUDE.md` — ingest pipeline
- `PhysicsPapers/LeanFormalizationV2/STYLE_GUIDE.md` — naming + proof governance
- `PhysicsPapers/LeanFormalizationV2/plans/` — live backlog + Grothendieck puzzle
- `PhysicsPapers/LeanFormalizationV2/notes/` — 14 cycle memos + 5 design memos
