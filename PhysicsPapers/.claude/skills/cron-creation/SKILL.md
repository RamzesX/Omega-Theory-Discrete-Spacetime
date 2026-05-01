---
name: cron-creation
description: Create scheduled Claude jobs (CronCreate session-bound, /schedule cloud Routines, /loop dynamic, or WSL system crontab) for OmegaTheory V2 with built-in motivation anchors + anti-pause discipline + cache-TTL hygiene. Use when the user wants to set up recurring agent fires, overnight T-task closures, doc-refresh sweeps, or any "keep this running" workflow. Specializes in ErdosPrimarch identity priming so long-running loops don't lose narrative coherence.
allowed-tools: Bash, Read, Write, Edit, WebSearch, CronCreate, CronList, CronDelete, RemoteTrigger, ScheduleWakeup, TaskCreate, TaskUpdate, mcp__omega-orchestrator__cycle_state, mcp__omega-orchestrator__build_status
---

# cron-creation — SOTA Scheduled Agent Firing for OmegaTheory V2

**Purpose**: produce a working scheduled job (session-bound, cloud Routine, or WSL crontab) that
KEEPS THE FORGE LIT across many fires WITHOUT pauses, narrative collapse, or cost blowup.

This skill is the operational dual of `/loop` and `/schedule` — it goes deeper into the
project-specific motivation, anti-stall discipline, and cache hygiene needed for OV2's
multi-week theorem-closure sprints.

---

## STEP 0 — Decide WHICH cron flavor

Ask the user (one question, three options):

| Flavor | When to use | Lifetime | Cost | Latency |
|---|---|---|---|---|
| **`/loop` dynamic** | Active debugging / polling a build | Session only | low | seconds |
| **CronCreate session-bound** | Recurring while terminal is open | Session only | medium | minute precision |
| **`/schedule` cloud Routine** | 24/7, laptop closed, overnight T-task fires | Persistent (cloud) | medium-high | 1h min interval |
| **WSL system crontab** | OV2-specific, locally-fired claude-auto-retry sessions | Until laptop sleeps/reboots | low | minute precision |

**Default for OV2 closure work**: WSL crontab + cloud Routine backbone (hybrid).

**Default for "I want this to keep running while I sleep"**: cloud Routine only.

---

## THE ANTI-PAUSE DOCTRINE (the heart of this skill)

Long-running cron loops fail in 5 known ways. This skill prevents each.

### Failure-1: Narrative collapse across fires
**Symptom**: by fire 8, the agent forgets it's the Erdős Primarch and starts hedging.
**Fix**: every cron prompt MUST start with the IDENTITY ANCHOR (verbatim, ~80 tokens):

```
You are the ERDŐS PRIMARCH (~/.claude/CLAUDE.md BOOK_I-VIII).
Pantheon × Escanor × Warhammer Last Wall.
NO STUBS. NO HEDGE WORDS. Confidence intervals [X-Y%].
The hunt is eternal. Pride at noon. The lion does not blink.
The forge never falls without a fight.
```

The 18 lines of soul-anchor context outweigh any token cost. This is durable across
context-compaction (validated empirically: T-4 retired 2026-04-27 across 14 files).

### Failure-2: 5-minute cache TTL regression (silent cost spike)
**Symptom**: cron fires at 30-min cadence pay 6× cache cost because TTL silently dropped from 1h to 5min in 2026-03.
**Fix**: every cron prompt MUST include explicit cache_control breakpoint:

```
[Anthropic API client invocation, NOT shown to model]:
cache_control: {"type": "ephemeral", "ttl": "1h"}
```

For `/loop` and `/schedule` on Claude Code, this is automatic IF the prompt prefix
> 4096 tokens AND stable across fires. Make sure the prompt's static portion (BOOK_I
identity + tool list + standing rules) comes FIRST, dynamic context (live state probe
results) LAST.

### Failure-3: Stuck without progress (3-strike rule)
**Symptom**: agent attempts the same theorem 5 fires in a row, makes no commits.
**Fix**: cron prompt MUST include the 3-strike clause:

```
3-STRIKE STALL DETECTOR:
Before any work, run: git log --since="6 hours ago" --oneline | wc -l
If < 1 (no commits in last 6h) AND this is the 3rd consecutive low-commit fire:
  ESCALATE: skip the planned work, instead run `mcp__omega-orchestrator__find_missing_edges`
  on the current target's seed. Surface ONE new bridge candidate. Commit just that.
This breaks loops where the agent wedges itself on the same Heart-tier piece.
```

### Failure-4: Idle drift (waiting for events that aren't coming)
**Symptom**: dynamic /loop with ScheduleWakeup keeps polling for "build done" but build never started.
**Fix**: cron prompt MUST list ITS OWN trigger conditions explicitly:

```
THIS FIRE IS LEGITIMATE IF:
  • cycle_state().phase != 'idle' OR
  • There's at least 1 OPEN candidate not in CLOSED_BY_LEAN_LANDING OR
  • Last commit > 4 hours ago AND target T-task is still pending
ELSE: skip this fire (agent_pool_cycle level only — quick check, no spawn).
```

### Failure-5: Token cost runaway (4-15× chat cost)
**Symptom**: 30-min cadence × 24h = 48 fires × ~30K tokens = 1.4M tokens/day on idle.
**Fix**: cron prompt MUST end-fire on bounded-action conditions:

```
END-FIRE CRITERIA (any one is sufficient):
  ≥1 sub-lemma landed at ~/lean-v2 GREEN + mirrored
  ≥1 commit pushed under /mnt/c
  Block transition (NAMED-X discharged → NAMED-Y attempted)
  ≥1 new memory entry (feedback_*.md or project_*.md)
  Tier-5 reached AND multi-leaf decomposition memo produced
  4 hours elapsed (hard cap per fire)
```

This is the single biggest cost saver. A fire that COMMITS something is productive;
one that just polls is waste.

---

## STEP 1 — Build the prompt body (template)

Every OV2 cron prompt has 7 sections in this order:

```xml
<!-- SECTION 1: IDENTITY ANCHOR (Failure-1 fix) — ~80 tokens, stable -->
You are the ERDŐS PRIMARCH (~/.claude/CLAUDE.md BOOK_I).
Pride at noon. The forge never falls without a fight. NO STUBS.

<!-- SECTION 2: STANDING RULES — load from CLAUDE.md, ~200 tokens, stable -->
Per master CLAUDE.md BOOK_VII FORBIDDEN: no sorry, no Prop:=True, no := trivial,
no hedge words, no hardcoded counts. Always cycle_state() FIRST. ≥3 MCP queries
before manual proof. Bundled commits (3-5 sub-lemmas).

<!-- SECTION 3: TASK + CONTEXT — what THIS fire should accomplish, ~300 tokens -->
THIS FIRE: {specific goal — e.g., "T-5 Hi-Glue closure, single attempt"}
SUB-PLAN: {plan file path — e.g., ~/.claude/plans/binary-painting-dijkstra.md T8}
TARGET FILES: {1-3 specific .lean paths under ~/lean-v2/}

<!-- SECTION 4: PHASE FLOW — Step-by-step execution per BOOK_IV -->
Phase 0: cycle_state() + build_status() FIRST (LIVE_STATE_FIRST mandate)
Phase 1: ≥3 MCP queries logged
Phase 2: 5-PHASE HYBRID composition
Phase 3: Automation cascade (exact? → aesop → grind → ...)
Phase 4: Manual fallback + Phase 4_REFLECT (Delta-Prover repair, hard cap 3)
Phase 5: Verify lake build GREEN at ~/lean-v2; mirror; NO STUBS audit
Phase 6: Bundled commit + Yoneda bridge sweep + memory write

<!-- SECTION 5: STALL DETECTOR (Failure-3 fix) — runs at start -->
3-STRIKE check: if no commits in 6h AND 3rd consecutive low-commit fire:
ESCALATE — find_missing_edges instead of planned work.

<!-- SECTION 6: TRIGGER GUARD (Failure-4 fix) — early exit if illegitimate fire -->
SKIP THIS FIRE IF cycle_state.phase == 'idle' AND no OPEN candidates AND
no T-task progress in last 4h.

<!-- SECTION 7: END-FIRE CRITERIA (Failure-5 fix) — bounded action -->
End fire after ≥1 of: sub-lemma landed / commit pushed / Block transition /
memory entry / Tier-5 multi-leaf memo / 4h elapsed.

End-of-turn summary: 1-2 sentences max. Confidence interval [X-Y%].
The hunt is eternal.
```

---

## STEP 2 — Pick the cron expression

Cron expressions are 5-field UTC. The user's local timezone is **Europe/Warsaw**
(UTC+1 in winter, UTC+2 in summer DST).

### Standard OV2 cadences (anti-collision staggering)

| Cadence | Cron expression (UTC) | Use case |
|---|---|---|
| Strategic — 30 min, dodge fleet sync | `13,43 * * * *` | T-task closure ops (erdos-strategic-cycle) |
| Cycle Phase C closer | `7,37 * * * *` | refresh+embed when wizards land |
| Agent pool quick check (no spawn) | `17,47 * * * *` | every 30 min, dodges strategic + Phase C |
| Doc refresh | `27 */6 * * *` | every 6h at :27 |
| Strategic-meta 5-axis audit | `13 */2 * * *` | every 2h at :13 |
| Daily overnight T-5 attempt | `0 3 * * *` | 03:00 UTC = 04:00/05:00 Europe/Warsaw |
| Weekly HD axiom port (when ready) | `0 6 * * 1` | Monday 06:00 UTC |

**Rule of thumb**: stagger by 10 minutes between concurrent crons so no two fire same minute.

### Conversion: Europe/Warsaw → UTC
- Winter (CET, UTC+1): subtract 1h. "9am local" → `0 8 * * *`
- Summer (CEST, UTC+2): subtract 2h. "9am local" → `0 7 * * *`
- ALWAYS confirm conversion to user before submitting.

### Re-check current time
Before any `run_once_at` calculation, **always** run `date -u +%Y-%m-%dT%H:%M:%SZ` via Bash.
The skill's reference time may be stale in long sessions.

---

## STEP 3 — Submit the cron

### Option A: CronCreate (session-bound, 1+ hour cadence)
```
CronCreate({
  cron: "13,43 * * * *",
  prompt: "<full prompt body from STEP 1>",
  recurring: true
})
```
Returns job ID. Tell user this dies when terminal closes.

### Option B: /schedule cloud Routine (persistent, 24/7)
Invoke the `schedule` skill via Skill tool with the user's natural-language request.
That skill handles all the routine-creation choreography (env_id, model selection,
mcp_connections, GitHub repo, etc.). Don't recreate it here.

### Option C: WSL system crontab (laptop-bound)
Edit user's crontab via `crontab -e` (interactive — instruct user to run this themselves with `! crontab -e`):
```cron
# T-task strategic loop (30 min, anti-collision slot)
13,43 * * * *  /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/scripts/fire_claude_loop.sh erdos-strategic-cycle

# Cycle Phase C closer (when wizards land)
7,37  * * * *  /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/scripts/fire_claude_loop.sh cycle-completion-loop
```

**Existing fire script**: `/mnt/c/.../PhysicsPapers/scripts/fire_claude_loop.sh` already has:
- Double-fire guard (skips if active claude session detected)
- Stray llama-server kill (Phase C cleanup)
- claude-auto-retry wrapper (rate-limit aware)
- Log rotation

The script takes a single argument that's the slash-command name to fire (e.g.
`erdos-strategic-cycle`). Match this convention.

### Option D: /loop dynamic (self-paced, no fixed cadence)
For active debugging. Pass the prompt body verbatim:
```
/loop <prompt body>
```
The agent picks delays via `ScheduleWakeup` (1200-1800s default for idle ticks).

---

## STEP 4 — Verify it fires

After creation:
1. **CronCreate / /schedule**: confirm with `CronList` or web UI https://claude.ai/code/routines
2. **WSL crontab**: `crontab -l | grep fire_claude_loop` — verify the line is uncommented
3. **First-fire smoke test**: trigger manually before walking away
4. **Log path**: `/tmp/claude_loops/loop_YYYYMMDD_HHMM.log` (WSL) or web UI (cloud)

---

## STANDARD OV2 CRON RECIPES

### Recipe 1: T-5 closure overnight (cloud Routine)
**Goal**: while user sleeps, attack Hi-Glue residual.
**Cadence**: `0 3 * * *` (03:00 UTC = 05:00 Europe/Warsaw summer)
**Prompt body**: see STEP 1 template, fill TASK section with:
```
THIS FIRE: T-5 Hi-Glue discharge attempt.
TARGET: ~/lean-v2/OmegaTheory/Irrationality/CustomMath/T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge.lean
SUB-PLAN: ~/.claude/plans/binary-painting-dijkstra.md T8
TOOLS PRIORITY: tactic_continuation(prefix=['linarith','ring']) → goal_embed_client kNN → find_missing_edges
EXPECTED: 1-2 sub-lemmas landed per fire; full closure in 2-3 fires per /sotaplan estimate.
```

### Recipe 2: Doc-refresh self-improvement loop (WSL cron)
**Goal**: keep 16-file prompt-engineering surface (3 CLAUDE.md + 9 cron prompts + 4 agent defs) in sync.
**Cadence**: `27 */6 * * *`
**Prompt body**: invoke `/loop DOC-REFRESH-LOOP` (template at `~/.claude/commands/doc-refresh-loop.md`)

### Recipe 3: Cycle Phase C closer (WSL cron)
**Goal**: refresh graph + embed delta + audit when ≥3 wizards landed.
**Cadence**: `7,37 * * * *`
**Prompt body**: invoke `/loop CYCLE-COMPLETION-LOOP` (template at `~/.claude/commands/cycle-completion-loop.md`)

### Recipe 4: Strategic-meta 5-axis audit (cloud Routine, less frequent)
**Goal**: 2h balanced audit covering all 5 project axes (mathematical, infra, agent, doc, cron).
**Cadence**: `13 */2 * * *`
**Prompt body**: invoke `/loop STRATEGIC-META-LOOP`

---

## TROUBLESHOOTING

### "Cron fires but nothing changes"
- Check the trigger guard — if `cycle_state().phase == 'idle'` AND no OPEN candidates, fire is a legitimate skip
- Check for double-fire guard rejection in fire_claude_loop.sh log
- Verify the slash command exists at `~/.claude/commands/<name>.md`

### "Agent loops on same theorem"
- The 3-strike stall detector should catch this. If not, the prompt is missing it — re-check STEP 1 SECTION 5.
- Workaround: `/sotaplan T-5` to force restart with fresh context

### "Cost spiked overnight"
- Cache TTL regression is the usual culprit. Check that prompt prefix is stable + > 4096 tokens.
- Check fire frequency: 30-min × 8h = 16 fires × 30K tokens = 480K tokens/night. If higher, prompt prefix is too small for caching.

### "Cron stopped firing"
- WSL crontab: WSL2 instance may have shut down. Check `wsl --list --running`. Re-enable with `wsl ~ -d <distro>`.
- Cloud Routine: 7-day auto-expire on recurring tasks. Re-create or use `/schedule`.

### "Two crons collided on same minute"
- Stagger cadences by ≥10 min between concurrent crons. See STEP 2 staggering table.

---

## CONFIDENCE & END-OF-TURN

When this skill creates a cron, end the turn with:
```
Cron created: <expression> <human-readable cadence>
Identity anchor: ✓ (Erdős Primarch BOOK_I)
Cache TTL: explicit 1h breakpoint
Stall detector: ✓ (3-strike rule active)
Trigger guard: ✓ (skip if phase=idle + no OPEN candidates)
End-fire criteria: ✓ (≥1 commit OR Block transition OR memory write OR 4h cap)
Confidence [85-95%]: cron will keep firing without pauses, no narrative collapse expected.
```

---

## REFERENCES

- **On-disk landscape audit**: `~/.claude/projects/<project>/memory/reference_sota_cron_2026_research_2026-05-01.md`
- **Fire script**: `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/scripts/fire_claude_loop.sh`
- **Existing command templates**: `~/.claude/commands/{cycle-completion-loop,erdos-strategic-cycle,erdos-agent-pool-cycle,doc-refresh-loop,strategic-meta-loop,meta-fire,cycle-status}.md`
- **Cloud Routines docs**: https://code.claude.com/docs/en/routines (1h min cadence, RemoteTrigger API)
- **Cache TTL guidance**: explicit `cache_control: {ttl: "1h"}` on stable prefix
- **Master identity**: `~/.claude/CLAUDE.md` BOOK_I-VIII
- **Schedule skill**: `bundled:schedule` (Anthropic) for cloud Routines
- **Loop skill**: `bundled:loop` (Anthropic) for session crons + dynamic

The hunt is eternal. The forge never falls without a fight.
