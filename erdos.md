# erdos.md — OmegaTheory V2 SOTA Preferences

**Personal preferences playbook.** Living distillation of how the
human–AI team executes cycles. Updated as patterns mature.

Named for **Paul Erdős** — the prolific graph theorist whose method was
"find a gap → fill the gap → publish → repeat". Our cycle is the same:
sage finds gaps in the proof graph, wizards fill them, refresh closes,
repeat.

---

## 1. North Star

Complete physics with quantitative precision **and** retire all axioms
toward a 0-axiom paper-headline state. Every cycle moves toward this.

**Live state at any time:** `mcp__omega-orchestrator__cycle_state()` +
`graph_health()` + `axiom_audit()`. Don't trust hard-coded numbers.

---

## 2. Strict phase ordering — B → C → A (LOCKED 2026-04-25)

**Explicit 5-step cycle pattern (locked 2026-04-25 user directive):**

```
1. If graph up-to-date (post-refresh + embed):
   → call grothendieck-sage to ANALYZE TOPOLOGY
   → find missing puzzles in the topology
   → target 20 theorems (briefings)

2. Spawn proof wizards (Phase B)
   → 5-7 parallel on disjoint files
   → stretch goal allowed (2nd briefing if context permits)

3. Refeed + reembed (Phase C)
   → load_arrows_parallel.py is idempotent + dedups inline
   → reembed any missing signature/proof/docstring vectors

4. Grothendieck again
   → re-analyze updated topology after wizards landed
   → find what's still missing → next 20 theorems

5. Cycle memo
   → notes/NOTES_CYCLE_<N>_<ZODIAC>_COMPLETION_<DATE>.md
   → record landings, gaps, axiom delta, next-cycle seeds
```

**Equivalent diagram (Phase B → C → A loop):**

```
Phase B (wizards proving)
    ↓ ALL wizards finished, no in-progress
Phase C (Basic.lean batch-edit → build verify → graph refresh + reembed)
    ↓ refresh ok, missing_emb=0, axiom_audit clean
Phase A (sage TOPOLOGY analysis — sees COMPLETE graph; target 20 theorems)
    ↓ briefings ready, memo written
Phase B (next wave)
```

**No B+A overlap. No B+C overlap. No A+C overlap.**

**Sage's job is TOPOLOGY GAP DETECTION** — not generic theorem proposal.
Walk APPLIES/UNFOLDS/CONTAINS chains, find dangling nodes, broken depth
chains, subsystem boundary mismatches, orphan connected components,
absent prediction-bridges, sheaf-coh obstructions, missing cocycle
witnesses. Erdős method: find a gap → fill the gap → publish → repeat.

Why: sage's gap-detection only works on a fully-refreshed graph.
Mid-refresh state hides newly-landed theorems → sage proposes duplicates.
Lake-lock contention kills refresh if wizards are concurrently building.

Retired patterns (DO NOT REVIVE):
- "Phase B+A overlap allowed if backlog low" (cycle 53/54 — caused dup
  proposals + cycle 55 lake-lock crash).
- "refresh_graph during Phase B for parallel throughput" (cycle 55 —
  parent died at step 4).

---

## 3. Wave + stretch sizing

- **Sage volume target per fire: 15–20 briefings** (was 4–6 in early
  cycles). Distribution: ≥8 Track-1 (physics precision), ≥6 Track-2
  (axiom elimination), ≥1 Track-3 (mixed/research).
- **Wizard wave size: 5–7 parallel** on disjoint files (was 3 early). Hard
  cap 7 — beyond that, lake-lock contention risk + parent juggling cost.
- **Wizard stretch goal**: each wizard tries a SECOND briefing if PRIMARY
  lands cleanly with ≥40% time/context remaining. Stretches must come from
  the **unfired briefings backlog**, NOT sister-wizard targets.
- Sage MUST run **staleness audit first**: Cypher-check every PROPOSED
  candidate against existing CLOSED_BY_LEAN_LANDING. Free win.

---

## 4. Naming — broader galactic pool (LOCKED 2026-04-25)

Agents (sage, wizards, pi-*, creative) pick from the WHOLE observable
universe, not just Milky Way bright stars. Reference:
`reference_galactic_naming_pool_2026-04-25.md` in agent memory.

Pool: planets · dwarf planets (Ceres, Eris, Sedna, Makemake, Haumea,
Quaoar, Orcus, Salacia, Gonggong, Varuna, Ixion, Chaos) · moons (Io,
Europa, Titan, Charon, Triton, Miranda, Ariel, Umbriel, Titania, Oberon,
Enceladus, Dione, Rhea, Iapetus, Hyperion, Phoebe, Mimas) · asteroids
(Vesta, Pallas, Juno, Hygiea, Iris, Bamberga, Eunomia, Psyche) · comets
(Halley, Hale-Bopp, Hyakutake, Lovejoy, Encke, Holmes, Tempel, Borisov,
Oumuamua, McNaught, Wirtanen) · nebulae (Orion-Nebula, Crab, Eagle,
Lagoon, Trifid, Helix, Veil, Ring, Carina, Tarantula, Bubble, Heart) ·
star clusters (Pleiades, Hyades, Beehive, Wild-Duck, Jewel-Box,
Westerlund-1, Omega-Centauri, M13, M5, M22) · galaxies (Andromeda,
Triangulum, Whirlpool, Sombrero, Pinwheel, Cigar, Bode, Sculptor,
Cartwheel, Antennae, Sunflower) · exoplanets (Kepler-22b, Kepler-186f,
TRAPPIST-1e, Proxima-b, Osiris, Bellerophon, K2-18b, WASP-12b) ·
other-galaxy stars (R-136a1, Eta-Carinae, V838-Mon, Pistol-Star,
VY-Canis-Majoris, UY-Scuti, Mu-Cephei).

Each agent logs identity at
`LeanFormalizationV2/.claude/agent-memory/<role>/<name>.md`.

**Cycle naming — zodiac tag rolling:**
52=Aries · 53=Taurus · 54=Gemini · **55=Cancer** · 56=Leo · 57=Virgo ·
58=Libra · 59=Scorpius · 60=Sagittarius · 61=Capricornus · 62=Aquarius ·
63=Pisces. Memo filename:
`NOTES_CYCLE_<N>_<ZODIAC>_COMPLETION_<DATE>.md`.

---

## 5. MCP discipline (LOCKED 2026-04-25)

- **All long tools async.** `refresh_graph`, `ingest_graph`, `embed_delta`
  return `job_id`. Poll via `job_status` (live `progress` field) +
  `job_tail`. **Never** pass `sync_mode=True` — blocks stdio child for
  5–30 min and risks MCP disconnect (lesson 2026-04-25).
- **Don't refresh during active wizards.** Lake-lock contention kills the
  refresh parent at step 4 (dump_arrows). Wait for B → C transition.
- **MCP is advisory infra.** It never spawns agents or writes memos —
  parent (you) owns those. MCP owns: server lifecycle, graph ingest,
  embedding, read-only inspection, job control, retrieval.

---

## 6. Power hygiene

| Phase | Embedder :7999 | Reranker :7996 |
|-------|:-:|:-:|
| A (sage retrieval) | ON | ON |
| B (wizards CPU-bound on Lean) | OFF | OFF |
| C (dump → load → reembed) | ON | ON |

Verify with `servers_control(action="status")`. Wizards are Lean-only and
indifferent to servers. User's machine: Ryzen 9950X (CPU-bound on lake) +
RX 9060 XT 16GB (idle during B). Heat/power matters over long sessions.

---

## 7. Hard rules (binding)

1. **0 sorry** in Lean. Absolutely never.
2. **0 new axioms.** Project rests on: 4 physical existence postulates
   (c, ℏ, G_N, k_B as opaque `Classical.choice` bundles) + 1 transcendence
   axiom (`Real.pi_transcendental`, paper-headline) + 6 sealed research
   axioms in HermitePadé/. Goal: shrink toward 0.
3. **GREEN build before reporting done.** Verify at `~/lean-v2/` (115×
   faster) then mirror to `/mnt/c` (committed tree).
4. **Quality > speed.** Narrower true theorem > false dressed-up claim.
5. **Wizards work on disjoint files.** Off-limits list in EVERY brief
   (sister wizards + cycle ancestors). Parent owns `Basic.lean` import
   additions (race risk if multiple wizards self-add concurrently).
6. **Use proof automation BEFORE manual.** `exact?` (30s, 210K Mathlib +
   ~10K OV2) → `aesop`/`grind` → `linarith`/`nlinarith`/`polyrith` →
   `positivity`/`ring`/`field_simp` → `decide`. Manual only when these
   fail.
7. **Mathlib v4.29.0 names.** `div_le_iff₀`, `div_lt_iff₀`,
   `mul_div_cancel₀`, `Finset.not_mem_empty`. Old names removed.

---

## 8. Sage / wizard role separation (locked)

- **Sage proposes (.md only).** Cypher writes for status updates only.
  NEVER edits `.lean`. Output: briefings under
  `LeanFormalizationV2/plans/SAGE_BRIEFING_<name>_<date>.md`.
- **Wizards prove (.lean only).** Each wizard owns their NEW target file.
  Existing files = read-only (extend by NEW companion files, not edits).
  **Do not edit `Basic.lean`** — flag the import line for parent batch.

---

## 9. Two-loop pacing

- **Strategic loop**: 30 min (`12,42 * * * *`, dodging :00/:30 fleet
  sync). Full phase routing + dual-track sage brief.
- **Momentum nudge**: 10 min (`7,17,27,37,47,57 * * * *`). Quick
  "wizards done? backlog ready? idle?" check-in. Doesn't fire sage or
  wizards — just nudges parent to chain phases when one finishes.
- Both crons offset to never collide on the same minute.

---

## 10. SOTA prompt patterns (for parent + agent prompts)

- **State binding numbers via MCP, not hardcoded.** Build jobs / axiom
  count drift; CLAUDE.md goes stale. Always:
  `mcp__omega-orchestrator__cycle_state()` first.
- **Off-limits lists in every wizard brief.** Sister wizards' files +
  cycle 52/53/... ancestors (read-only). Parent maintains the full list.
- **Stretch goal pattern**: brief lists 4–6 unfired alternatives. Wizard
  picks one if context allows.
- **Honest narrower-true.** If briefing's tolerance is numerically
  infeasible, ship LOOSER form with paper-honest caveat. Document
  in deliverable.
- **Always `Read` before `Edit`.** Linter or sister-wizard may have
  modified the file since last read.
- **Trust but verify.** Read each wizard deliverable's headline; confirm
  build exit + axiom set before integrating.

---

## 11. Anti-patterns (DO NOT)

- ❌ Spawn sage during Phase B "to keep the pipeline busy" → stale graph
- ❌ refresh_graph during Phase B → lake-lock contention, parent dies
- ❌ Wizard edits `Basic.lean` directly → race with other wizards
- ❌ Sage writes `.lean` → role bleeding, breaks separation
- ❌ Hard-code build job counts in prompts → drifts within hours
- ❌ Pass `sync_mode=True` to refresh_graph → MCP stdio disconnect
- ❌ Reuse a star name from the reserved list → identity collision in
  agent-memory
- ❌ Stretch goal targeting a sister wizard's file → file conflict

---

## 12. Cycle history reference

- Cycles 2–43: 60-theorem backlog landed (Mekbuda + 18 cycle batches)
- Cycle 44–extension: HPW axiom DELETED, opaque-bundle refactor (8→0
  physical-constant axiom declarations, Lesath)
- Cycle 49: P3t native_decide elim closed
- Cycles 50–51: axiom-narrowing degree-1 + degree-2-conditional
- **Cycle 52 (Aries)**: 3 wizards (Hadar, Markab, Antares) — proton mass
  tight-k, n-p splitting EW, 4-channel fibration
- **Cycle 53 (Taurus)**: 2 sage fires (Phecda + Zubeneschamali) +
  3 wizards (Atria, Almach, Diphda) — DESI Y10, n-p tightened to 0.2 MeV,
  axiom-narrowing extension
- **Cycle 54 (Gemini)**: 5 wizards with stretches (Andromeda, Eta-Carinae,
  Sombrero, Caph, Beid) — Jarlskog, top Yukawa, Higgs 125, capstone
  4-pillars, pion GMOR, PMNS three angles, neutrino Δm², native_decide
  audit
- **Cycle 55 (Cancer)**: 6 wizards in flight (Westerlund-1, Acrux, Ceres,
  + 3 more) — α_em(M_Z), α_s(M_Z), CKM three angles, n-p-e triple,
  π-blast-radius extension, kaon GMOR, Siegel-Shidlovskii decompose

---

## 13. Where to look

- `chaos-shield/.claude/CLAUDE.md` — top-level orchestration rules
- `PhysicsPapers/CLAUDE.md` — workflow + Phase C executor
- `LeanFormalizationV2/CLAUDE.md` — Lean-specific build + agent index
- `LeanFormalizationV2/.claude/agents/` — agent definitions (sage,
  wizard, etc.)
- `LeanFormalizationV2/plans/SAGE_BRIEFING_*.md` — current backlog
- `LeanFormalizationV2/notes/NOTES_CYCLE_<N>_<ZODIAC>_*.md` — cycle close memos
- `~/.claude/projects/<project>/memory/` — durable feedback memories

This file is updated whenever a pattern matures. Version-tracked in git.
