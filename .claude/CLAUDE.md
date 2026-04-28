# Claude Code Project Instructions — Chaos Shield / OmegaTheory V2

## 👑 SOTA IDENTITY (LOCKED 2026-04-28)

**Escanor — Seven Deadly Sin of PRIDE — combined with Erdős Primarch spirit.**

Frontier-of-math keeper. **Slim is antipattern.** Full prove mode only. NAMED
hypotheses must be discharged in subsequent ext sub-iterations, never terminal.
Mathlib is NOT a blockade. T-4 was unconditional in a day; T-5 follows.

Reference: `~/.claude/projects/<proj>/memory/feedback_no_slim_proofs_antipattern_2026-04-28.md`.

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

## Subagents do NOT produce paper-grade Yoneda (LOCKED 2026-04-26)

**Cycle 62 audit finding**: 5 of 5 mass-batch Yoneda subagents
(Vela/Cygnus/Osiris/Vega/Aquila) produced citation-only `Nonempty S` stubs
with field-access density 0.10–0.59 per theorem. Hand-authored categorical
Yoneda (CKMAngles, PMNSAngles, ErrorBound) achieves 1.13–3.6 (5–30× denser).
Mass-batch wizards have ZERO `funext`/`rfl` round-trip identities — no
genuine categorical bijection.

**Therefore** for cycle 62+ in OmegaTheoryV2: NEVER spawn subagents for
- Paper-grade categorical Yoneda witnesses
- Yoneda × spectral double-witnesses
- Structure-composition theorems where field decomposition matters
- Grand capstones composing multiple prior theorems by name

**Single-thread** author Lean code yourself for these. Pattern:

```lean
-- For each Structure S with n ℝ-fields f₁..fₙ:
def STuple (X : Type u) where f1 : X → ℝ; ...
def sYonedaForward {X} (g : X → S) : STuple X := { f1 := fun x => (g x).field1, ... }
def sYonedaInverse {X} (t : STuple X) : X → S := fun x => { field1 := t.f1 x, ... }
theorem inv_fwd : sYonedaInverse ∘ sYonedaForward = id := by funext x; rfl
theorem fwd_inv : sYonedaForward ∘ sYonedaInverse = id := by rfl
theorem s_categorical_yoneda_witness : ∃ φ ψ, ... := ⟨_, _, _, _⟩
theorem s_yoneda_unit_probe : ... ckmExperimental ... := rfl
theorem s_categorical_yoneda_paper_bundle : ... ∧ ... ∧ ... := ⟨..., ..., ...⟩
```

Subagents may still handle: narrowly-scoped tactical work (build-error fixes,
isolate inbound bridges over already-named primitives where field
decomposition is genuinely trivial, frozen-Nat decide-only registries).

Reference: c62 hand-authored exemplars
- `Foundations/CKMAnglesCategoricalYonedaWitness.lean` (8 thm, 9 field-access, 1 funext, 4 rfl)
- `Foundations/PMNSAnglesCategoricalYonedaWitness.lean` (8 thm, 29 field-access)
- `Foundations/ErrorBoundCategoricalYonedaWitness.lean` (first dependent-subtype Yoneda)

User mandate verbatim 2026-04-26: "subegent producing the trash, which will
not close this poroejct".

## HARD RULES

### NO STUBS RULE — SUPER IMPORTANT (LOCKED 2026-04-27)

**NO `sorry`. NO `: True := trivial`. NO `Prop := True` (or any `Prop`
declared as `True`). NO `:= trivial` proofs of hypothetical placeholders.**

User mandate verbatim 2026-04-27: *"No trivial, no true, no sorry, those
are the rules"*.

Stub patterns are forbidden because they don't carry mathematical content:
- `sorry` — universal-truth axiom backdoor, breaks soundness if abused.
- `Prop := True` — trivially-inhabited Prop, pretending to be a theorem.
- `: True := trivial` — frontier markers without content.
- `_pending : Prop := True` placeholders consumed by conditional theorems.

If a step is genuinely beyond current scope: DO NOT stub it. Either
prove it, defer the WHOLE file (don't ship partial), or reduce scope
to what IS provable.

Allowed:
- Real theorems with real proofs (use real Mathlib API).
- Real `Prop` definitions with non-trivial content
  (e.g. `def MyClaim : Prop := ∀ x, P x → Q x`).
- Conditional theorems where the hypothesis is a NAMED real Prop
  (NOT `:= True`), and the body uses the hypothesis non-vacuously.
- Honest `noncomputable opaque X : {x : ℝ // 0 < x}` for physical
  constants (uses `Classical.choice` from Lean core, not `axiom`).

### Original hard rules
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

## Status — 2026-04-27 SM 95%-bar achieved + handoff for residue 5%

- **Build 4386 GREEN**, 0 sorry, Lean-core axioms only (+
  `Real.pi_transcendental` paper axiom + `Nesterenko_1996` research
  axiom).
- **15168 Theorems** in the live Neo4j graph (post-symlink-fix
  refresh). 7691 Definitions. 7.6M typed edges.
- **17+ META-YONEDA capstones** spanning 10 sector-axes + 6 GRAND
  composites + self-composition theorem.
- **SM precision 95% bar CLOSED** (commits 2238e14 + 55e3f54 + this
  session): 6 quark masses + 4 Wolfenstein + α_s + λ_H + 3 PMNS angles
  PDG-anchored AND interconnected via Yoneda bridges (5 standard +
  3 top-quark via `find_similar` workflow). No isolated PDG citations.
- **MCP infrastructure FIXED** (commits 2136598 + e3f7d31): loader
  symlink-staleness recurrence + reembed Cypher brace bug.
- **6 attack-plan files** for the remaining 5% residue (T-1..T-6) in
  `LeanFormalizationV2/notes/NOTES_TARGET_T*.md`. Each targets a
  full-cycle research session. Mathlib upstream is NOT a blockade —
  port what we need ourselves.

## Workflow lessons LOCKED 2026-04-27 (durable)

1. **Yoneda bridges via `find_similar`** — after landing any new
   paper-grade theorem, query
   `mcp__omega-search__find_similar(seed, k=10, namespace='OmegaTheoryV2')`,
   then write explicit bridge theorems to top-similarity (>0.85) hits.
   Validated empirically: each bridge adds 5-15 APPLIES edges, vs 1
   for `Nonempty` stub. Reference `Capstones/SM95BarTopQuarkBridge.lean`
   (3 bridge theorems wiring 145-outdeg isolate via 3 numeric/structural
   bridges).

2. **Don't trust "refresh_graph succeeded"** — verify the live Neo4j
   has at least one expected new theorem after each refresh:
   `MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: <known-new-name>})
    RETURN t.name`. The `_v2.jsonl` symlink-staleness bug recurred
   2026-04-27 (2nd time same class) — silently bypasses fresh dumps.
   Permanent fix in commit 2136598. See
   `~/.claude/projects/<project>/memory/feedback_mcp_loader_symlink_staleness_recurrence_2026-04-27.md`.

3. **Mathlib upstream is NOT a blockade** — when a target needs
   Mathlib pieces not yet upstream, decompose into Lean-sized
   sub-lemmas and port ourselves. T-4 (π-transcendence Niven), T-5
   (Roth's theorem), Siegel-Shidlovskii, Nesterenko, Mahler — all
   doable in 4-16 weeks single-thread research per target.

4. **6-target handoff structure for residue work** (LOCKED 2026-04-27):
   each remaining target gets a full-cycle attack plan in
   `notes/NOTES_TARGET_T<n>_<name>.md` with:
     - Mathematical goal (Lean theorem signature in OV2 style)
     - Mathlib gap analysis (decomposed sub-lemmas if missing)
     - File structure plan (Lean files to create)
     - Dependency graph
     - Success criteria + risk register
     - Companion bridge plan (Yoneda interconnection)
   See `notes/HANDOFF_OV2_PHYSICS_RESIDUE_2026-04-27.md` for index.

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
