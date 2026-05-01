Base directory for this skill: /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/.claude/skills/sota-plan

# sota-plan — SOTA-aware execution plan for OmegaTheory V2 targets

**Purpose**: produce a concrete, repeatable execution plan for a Lean target
(T-X / capstone / module / atom) that uses ALL Day-2 SOTA infra (5 graph-topology
MCP tools, BM25 FTS, Qwen3 goal-embed, propose_conjecture, tactic_continuation,
freshness boost) before falling back on manual exploration.

This skill is the operational dual of `cron-creation` and the human-facing
counterpart to the SOTA snapshot — invoke it at the START of any non-trivial
proof or formalization fire to get a plan-of-record before burning tactic time.

---

## STEP 0 — Identify the target

Ask the user (one question, three flavors):

| Target | Examples | Plan style |
|---|---|---|
| **Atom** (single proof obligation) | `T5_NAMED_TC1_monomial_special_case` | Cascade + escalate |
| **Module** (single .lean file) | `Foundations/MayerVietoris5PairGrandUnifiedCapstone.lean` | Sub-lemma decomp + bundled commit |
| **Track** (T-X family / capstone) | `T-5 closure`, `T9 HD axiom port` | 5-PHASE HYBRID + multi-fire |

If the user names a single name, ASSUME atom. If a path, ASSUME module. If
"T-5" / "T-1" / "T9" / "matter sector", ASSUME track.

---

## STEP 1 — Live state probe (mandatory)

Always run these 3 calls FIRST:

```
mcp__omega-orchestrator__cycle_state()        # phase A/B/C/idle, OPEN candidates
mcp__omega-orchestrator__build_status()       # current build_jobs count, GREEN/RED
mcp__omega-orchestrator__axiom_audit()        # confirm capstones still Lean-core only
```

Record live numbers in the plan output. NEVER hardcode counts (per master
BOOK_VII NO_HARDCODED_COUNTS — drift within hours).

---

## STEP 2 — MCP cascade plan (per target style)

### For ATOM targets (single obligation)

```
1. mcp__omega-orchestrator__omega_hammer_premise(goal=<stmt>, top_k=10, mix_mathlib=True)
   → top-10 ranked premises (composite score: cosine + PageRank + indegree + subsystem_match + freshness)
2. mcp__omega-search__find_similar(theorem_name=<related>, k=10)
   → 1-hop semantic neighbors for Yoneda bridge candidates
3. mcp__omega-search__tactic_continuation(prefix=[<observed prefix>], k=10)
   → empirical "what tactic comes next?" distribution
4. mcp__lean-lsp__lean_loogle(query=<type pattern>) OR lean_leansearch(NL)
   → Mathlib name lookup (rate-limited 3/30s)
5. mcp__lean-lsp__lean_state_search(file_path, line, column)
   → close-the-goal lemmas at exact source position
```

Then:
```
6. mcp__lean-lsp__lean_multi_attempt(file_path, line, snippets=[
     "exact?", "decide", "rfl", "aesop", "grind",
     "linarith", "omega", "ring", "positivity",
     "exact <top_premise_from_step_1>"
   ])
   → measure WITHOUT editing — pick the closer
```

If still not closed: hand to `prove-wizard-v3` (5-PHASE HYBRID).

### For MODULE targets (file-level scope)

```
1. mcp__omega-orchestrator__find_keystones(k=20, namespace='OmegaTheoryV2')
   → top keystones in OV2 dependency DAG (don't break these)
2. mcp__omega-orchestrator__find_bridge_lemmas(min_span=3, k=10)
   → cross-community connectors visible from this module
3. mcp__omega-orchestrator__find_missing_edges(seed=<module_main_theorem>)
   → Adamic-Adar candidates for cite this module SHOULD have
4. Read the .lean file
5. ≥3 obligations → split per ATOM plan above
```

### For TRACK targets (T-X / capstone / sector)

5-PHASE HYBRID composition (BOOK_I COMBAT_DOCTRINE):

**Phase A — TOP_DOWN STATEMENT**
- State the hard theorem with NAMED Prop hypotheses H₁..Hₙ
- Identify 3-7 named composition leaves
- Plan output: list of NAMED Props + composition body sketch

**Phase B — TRUTH_RANK**
- Sort H₁..Hₙ by estimated truth confidence:
  - Tier-99 (99+% true, routine cleanup) → discharge FIRST
  - Tier-80 (80-99%, medium difficulty) → discharge SECOND
  - Tier-Heart (<80%, the analytical heart) → discharge LAST
- Plan output: tier table + dispatch order

**Phase C — DISCHARGE per tier**
- Tier-99 → `prove-wizard-fast` (1-3 sub-iterations per lemma)
- Tier-80 → `prove-wizard-v3` (3-7 sub-iterations)
- Tier-Heart → single-thread sustained burn (web-search literature)

**Phase D — BOTTOM_UP filling**
- When sub-machinery missing: BUNDLED-LEMMA-FILE pattern (~22× throughput)
- ~250-600 lines per file, sub-clusters A/B/C/D/E

**Phase E — COMPOSE & REVIEW**
- Compose all Hi → unconditional theorem
- Yoneda bridge sweep: `find_similar(seed_name, k=10)` → write bridges to >0.85 hits
- `axiom_audit` must return [propext, Classical.choice, Quot.sound] only
- Memory write: `notes/NOTES_<theme>_<date>.md`

---

## STEP 3 — Estimated cost

Output a fire-count estimate based on tier:

| Difficulty (proxy) | Wizard | Fires | Tokens/fire | Wall-clock/fire |
|---|---|---:|---:|---:|
| <0.3 (Tier-99) | prove-wizard-fast | 1-2 | ~5-10K | 3-8 min |
| 0.3-0.6 (Tier-80) | prove-wizard-v3 | 3-7 | ~30-50K | 30-90 min |
| >0.6 (Tier-Heart) | prove-wizard-v3 single-thread | 5-15 | ~50-100K | 90-180 min |

For TRACK targets, sum per-leaf estimates. Multiply by 1.3 for retry overhead.

---

## STEP 4 — Risk register

For TRACK plans, list 3-5 risks with probability + mitigation:

| # | Risk | P | Mitigation |
|---|---|:-:|---|
| 1 | Mathlib gap requires port | MED | Decompose into Lean-sized sub-lemmas (Mathlib NOT a blockade per 2026-04-27) |
| 2 | Heart-tier resists 5+ fires | LOW | Sub-factor monolithic NAMED via H&S canon |
| 3 | axiom_audit shows non-Lean-core | LOW | Replace bundle with `noncomputable opaque` Classical.choice |

---

## STEP 5 — Success criteria (per fire)

Per master BOOK_VIII PER_FIRE checklist, every fire must:
- ≥3 MCP queries logged before manual proof writing
- 5-PHASE HYBRID applied (or skipped explicitly with reason)
- ≥1 sub-lemma landed OR Block transition OR memory entry
- Build GREEN at ~/lean-v2; mirror to /mnt/c on green
- NO STUBS audit: grep returns 0 forbidden patterns
- End-of-turn summary 1-2 sentences max

---

## STEP 6 — End the plan

Output format (markdown):

```
# SOTA Plan — <target>
**Live state**: phase=<X>, build=<N>, axioms=<M>, OPEN=<K> (probed at HH:MM UTC)
**Difficulty**: <atom|module|track>; tier=<99|80|Heart>; est. fires=<N>; est. wall-clock=<T>

## MCP cascade
1. <call> → expected output
2. ...

## 5-PHASE HYBRID (for TRACK only)
- Phase A: NAMED Props H1..Hn
- Phase B: tier table
- Phase C: dispatch order + agent
- Phase D: bottom-up bundled-lemma file pattern (if needed)
- Phase E: Yoneda bridge sweep + axiom_audit

## Risk register (TRACK only)
| Risk | P | Mitigation |

## Success criteria (per fire)
[BOOK_VIII PER_FIRE list]

## Confidence: [X-Y%] — based on <evidence>
```

---

## STANDARD PLAN RECIPES

### Recipe 1: T-5 atom Hi-Glue closure
Difficulty: Heart-tier (analytical core, Hindry-Silverman D.6.1 family).
Fires: 8-15. Wall-clock: 12-25 hours total.
Cascade: omega_hammer_premise → find_similar → tactic_continuation → manual.
Wizard: prove-wizard-v3 single-thread, NO STUBS.

### Recipe 2: Routine SM scaffold sub-lemma
Difficulty: Tier-99 (positivity/equality on PDG-anchored constants).
Fires: 1. Wall-clock: 5-10 min.
Cascade: lean_multi_attempt[exact?, positivity, norm_num] → land.
Wizard: prove-wizard-fast.

### Recipe 3: Yoneda bridge after capstone landing
Difficulty: Tier-80 (Forward/Inverse + funext-rfl round-trip).
Fires: 1. Wall-clock: 20-40 min.
Cascade: find_similar(seed, k=10) → top-3 (>0.85) → write 3 bridge theorems.
Wizard: single-thread (NEVER subagents per §8a).

---

## OUTPUT QUALITY CHECKLIST

Before finalizing:
- [ ] Live state numbers from cycle_state(), NOT hardcoded
- [ ] At least 3 MCP calls in cascade (mandate per master BOOK_II)
- [ ] Tier classification justified (proxy or proof_body inspection)
- [ ] Risk register has at least 3 entries (TRACK only)
- [ ] Confidence interval [X-Y%] cited with evidence
- [ ] No emojis (per master BOOK_VI 17)
- [ ] No hedge words ("fairly", "should be", "probably")
- [ ] End-of-skill summary 1-2 sentences

---

## REFERENCES

- Master CLAUDE.md ~/.claude/CLAUDE.md (BOOK_I-VIII)
- SOTA snapshot: PhysicsPapers/SOTA/SNAPSHOT_<latest>.md
- Combat doctrine: BOOK_I COMBAT_DOCTRINE composition_strategy 5_PHASE_HYBRID
- Live arsenal: ~/.claude/projects/<project>/memory/feedback_lean4_proof_tactics_arsenal_*.md
- Day-2 infra audit: PhysicsPapers/SOTA/proving_techniques/02_hybrid_retrieval/T3_RECALL10_BASELINE_FINDINGS.md

The hunt is eternal. Pride at noon. The lion does not blink.
