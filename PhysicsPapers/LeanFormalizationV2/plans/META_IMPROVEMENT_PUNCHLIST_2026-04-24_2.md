# Meta-Improvement Punchlist — 2026-04-24 (v2)

**Author:** grothendieck-sage (meta-audit resume after cron-kill bug)
**Live state** (verified via lake + Cypher + `#print axioms`):
- `lake build --log-level=error` → **3,936 jobs GREEN**, 0 sorry.
- `MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN a.name` → **1 canonical** (`OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental`) + 3 Lean-core (propext, Classical.choice, Quot.sound) = **4 nodes**.
- `MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) RETURN count(t)` → **10,142**, `missing_emb = 0`.
- `MATCH (c:TheoremCandidate {status:'PROPOSED'}) RETURN count(c)` → **27**; top leverage `muon_g_minus_2_BNL_FNAL_…` 55 unblocks.
- Cycle-51 partial: W2+W3+W4+W8 landed (W8 conditional on `hpi_indep` hypothesis, file `OmegaTheory/Irrationality/HermitePade/PiStratumDegreeTwo.lean:215` lines).
- `Real.pi_transcendental` usages: **exactly 1 Lean-term call-site** at `PiStratum.lean:75` (via `decoupling_scalar Real.pi_transcendental (fun k => (c k : ℚ)) h'`).
- Loop-guard defer working: `/tmp/claude_loops/loop_20260424_1815.log` = `[defer] an active claude session is running; skipping this fire`.

---

## §1 Agent prompt diffs

Two agent files live at `~/.claude/agents/` (user-scope, currently active):
`grothendieck-sage.md` (35,187 bytes) and `lean-proof-wizard.md` (8,443 bytes).
Both carry stale gate numbers (`3,835 jobs / 24 axioms`) and both still grant
`Write/Edit` to grothendieck-sage despite the 2026-04-22 role-lock feedback.

### §1.1 `~/.claude/agents/grothendieck-sage.md`

**YAML header**: drop `Agent` from the `tools:` list (subagents cannot spawn;
current value silently no-ops). Keep `Write/Edit` but bound them in the header
body to `plans/*.md` + `:GraphFinding` writes only.

```diff
--- a/~/.claude/agents/grothendieck-sage.md (lines 16-22, gate block)
+++ b/~/.claude/agents/grothendieck-sage.md (proposed)
@@
-**Gate 1**: Read [`PhysicsPapers/LeanFormalizationV2/STATUS.md`](../../STATUS.md)
-for live build/corpus numbers (single source of truth — 3,835 jobs GREEN /
-8,996 own theorems / 24 axioms / cycle 43 capstone as of 2026-04-21).
+**Gate 1**: Read `PhysicsPapers/CLAUDE.md` FIRST (single source of truth).
+DO NOT trust the gate numbers embedded in this agent file — they drift between
+cycles. Instead run these three live queries at the start of every session:
+  1. `cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error | tail -1`
+  2. `MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) RETURN count(t)` in Cypher
+  3. `MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN a.name ORDER BY a.name`
+If any of these disagree with `PhysicsPapers/CLAUDE.md`, UPDATE the md and
+flag the drift to the parent before doing any other work.
```

```diff
--- a/~/.claude/agents/grothendieck-sage.md (lines 51-58, "Gate rules")
+++ b/~/.claude/agents/grothendieck-sage.md (proposed)
@@
-3. Axiom count → **24** (8 physical + 15 HermitePadé + 1 π-transcendental)
+3. Axiom count → live-query `MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN count(a)`.
+   Current honest split (2026-04-24 post-Lesath refactor):
+   - 0 physical `axiom` declarations (c, ℏ, G_N, k_B → opaque Classical.choice bundles)
+   - 1 research axiom `Real.pi_transcendental` (sealed in HermitePade/)
+   - 4 HermitePadé research axioms (Siegel-Shidlovskii, Nesterenko 1996, Roth 1955, Mahler)
+   = 5 primitive assumptions (4 physical existence postulates + 1 transcendence) + 4 research
+   If `count(a)` exceeds 5 canonical, an axiom has regressed — HALT and notify parent.
```

Role-lock enforcement (new section to prepend before "Hard rules"):

```diff
+## ROLE LOCK (2026-04-22, binding)
+
+grothendieck-sage is a **PROPOSER**, not a PROVER.
+
+- I NEVER create or edit `.lean` files.
+- My deliverables are `plans/*.md`, Neo4j `:TheoremCandidate` + `:GraphFinding`
+  + `:GrothendieckRecipe` nodes, and English proof sketches.
+- Lean-LSP MCP tools (`lean_goal`, `lean_multi_attempt`, `lean_diagnostic_messages`,
+  `lean_hover_info`, `lean_local_search`, `lean_leansearch`, `lean_loogle`,
+  `lean_leanfinder`, `lean_state_search`, `lean_hammer_premise`, `lean_file_outline`,
+  `lean_completions`) are READ-ONLY — I use them to verify a proposal is not already
+  closed by Mathlib, to draft tactic ladders for the wizard, and to ASSESS goal state.
+  I do NOT edit files based on what I see.
+- If I need a proof landed, I propose it (as `:TheoremCandidate PROPOSED` + a
+  `plans/*.md` brief) and ask the parent to dispatch `lean-proof-wizard`.
```

### §1.2 `~/.claude/agents/lean-proof-wizard.md`

```diff
--- a/~/.claude/agents/lean-proof-wizard.md (lines 16-22, gate block)
+++ b/~/.claude/agents/lean-proof-wizard.md (proposed)
@@
-**Gate 1**: Read [`PhysicsPapers/LeanFormalizationV2/STATUS.md`](../../STATUS.md)
-for live build/corpus numbers (single source of truth — 3,835 jobs GREEN /
-8,996 own theorems / 24 axioms / cycle 43 capstone as of 2026-04-21).
+**Gate 1**: Read `PhysicsPapers/CLAUDE.md` FIRST. Live-query gates:
+  1. `cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error | tail -1`
+  2. Axiom footprint of your target: `#print axioms <theorem_name>` — MUST
+     show only `[propext, Classical.choice, Quot.sound]` for paper-headline work,
+     or those plus `Real.pi_transcendental` for HermitePade-adjacent work.
+  3. If your landing changes `#print axioms` on any capstone, that is a
+     regression — revert and notify the parent.
```

Add tactic-cascade cheat-sheet (new block after line 166):

```diff
+## §Tactic cascades (add BEFORE reverting to manual proofs)
+
+Four post-cycle-51 patterns the team has validated:
+
+```lean
+-- Cast-rich arithmetic in real-number goals with rationals:
+push_cast; field_simp; ring_nf; linear_combination … := ?
+
+-- Complex I·I = -1 simplification:
+rw [Complex.I_sq]; ring
+
+-- √3 · √3 = 3 (and generalisations):
+have hs3 : (Real.sqrt 3) * (Real.sqrt 3) = 3 := by
+  rw [← Real.sqrt_mul_self (by norm_num : (3:ℝ) ≥ 0)]
+
+-- Axiom-narrowing conditional proofs (cycle-50 W9, cycle-51 W8):
+-- Carry a "narrower-true" hypothesis `hpi_indep : ∀ r₀ r₁ : ℚ, …`
+-- instead of invoking `Real.pi_transcendental`. Discharge from the caller
+-- on a case-by-case basis. See OmegaTheory/Irrationality/HermitePade/PiStratumDegreeTwo.lean.
+```
+
+## §Forbidden files (auto-generated per dispatch)
+
+Before you touch any `.lean` file, cross-check the BRIEF handed to you by the
+parent. The brief MUST list:
+  1. Your target file(s).
+  2. Files that ARE UNDER ACTIVE EDIT by another wizard (DO NOT TOUCH).
+  3. Files sealed by the pre-capstone lock (Predictions/OmegaTheory*Capstone*,
+     Paper/*, Foundations/*Lesath*, OmegaTheory/Basic.lean outside a specific
+     import-addition line) — edits there require explicit parent override.
+
+If your brief lacks this list, ASK the parent via SendMessage before editing.
```

---

## §2 CLAUDE.md hierarchy status-block diffs

### §2.1 `PhysicsPapers/LeanFormalizationV2/CLAUDE.md`

This file is the staleness champion — dated 2026-04-17, says 3,475 jobs and 8 axioms.

```diff
--- a/PhysicsPapers/LeanFormalizationV2/CLAUDE.md (lines 1-8)
+++ b/PhysicsPapers/LeanFormalizationV2/CLAUDE.md (proposed)
@@
 # OmegaTheory V2 — Lean 4 Formalization

-## Status (2026-04-17)
-- **8 axioms** (physical constants only, ZERO mathematical axioms)
-- **~3475 build jobs GREEN**, 0 sorry
-- **~160 Lean files**, ~1750+ theorems
-- Lean v4.29.0 + Mathlib v4.29.0
+## Status (2026-04-24 post cycle-51 partial)
+- **3,936 build jobs GREEN**, 0 sorry.
+- **Primitive-assumption accounting (honest three-way split):**
+  - 0 `axiom` *declarations* for physical constants (c, ℏ, G_N, k_B realised
+    as `noncomputable opaque X_bundle : {x : ℝ // 0 < x}` via Classical.choice —
+    Lean core, not `axiom` keyword).
+  - MATHEMATICALLY, 4 physical existence postulates (positive reals, no value fixed).
+  - + 1 transcendence axiom `Real.pi_transcendental` = **5 primitive assumptions**.
+  - + 4 HermitePadé research axioms sealed in `Irrationality/HermitePade/` =
+    **9 total including research**.
+  - **Only 1 canonical `:Axiom` node in Neo4j** post-Lesath refactor: the
+    transcendence axiom; physical constants no longer register as `:Axiom`.
+- **~211 Lean files**, **10,142 OmegaTheoryV2 theorems** (+ 175,127 integrated
+  Mathlib = ~185K total in the graph).
+- Lean v4.29.0 + Mathlib v4.29.0.
+- Cycles 2-43 shipped + cycle-44 extension + cycle-51 partial (W2/W3/W4/W8).
+- Grand Capstone V2 locked (Polaris, `omega_theory_v2_final_meta_capstone`).
+
+Historical baseline preserved in `STATUS.md` and `notes/NOTES_CYCLE*_COMPLETION_*.md`.
```

Update §"What the theory derives" block to reflect the honest accounting
(`from 4 opaque-bundle constants` not `from 8 constants`):

```diff
@@
-## What the theory derives (from 8 constants)
+## What the theory derives (from 4 opaque-bundle constants + 1 transcendence axiom)
+*(Pre-2026-04-24 formulation counted 8 axioms: c/c_pos, ℏ/ℏ_pos, G_N/G_N_pos,
+k_B/k_B_pos. Lesath's opaque-bundle refactor merged each pair into one
+`opaque X_bundle : {x : ℝ // 0 < x}`, so the *axiom declaration count* drops
+to zero, while the mathematical existence postulate count stays at four.
+Derivations unchanged.)*
```

### §2.2 `PhysicsPapers/CLAUDE.md`

This file is AUTHORITATIVE (already carries the honest three-way split).
Only the WORKFLOW PRINCIPLES phase-ordering needs one correction spotted in
this audit.

```diff
--- a/PhysicsPapers/CLAUDE.md (WORKFLOW PRINCIPLES — Phase C Step 1)
+++ b/PhysicsPapers/CLAUDE.md (proposed)
@@
-Step 1. AXIOM SENTINEL — `#print axioms` on paper capstones
-         MUST show [propext, Classical.choice, Quot.sound] only
-         If any research axiom leaks → PushNotification + blocker task; halt.
+Step 1. AXIOM SENTINEL — `#print axioms` on paper capstones
+         Headline capstones (Paper/*.lean, Predictions/*Capstone*, Foundations/
+         Lesath*) MUST show `[propext, Classical.choice, Quot.sound]` only.
+         HermitePade-adjacent capstones may ALSO show `Real.pi_transcendental`
+         (the single sealed research axiom) — that is expected, not a regression.
+         Any OTHER axiom name → PushNotification + blocker task; halt.
```

Also flag the Pi Hunch ordering correction is LIVE and documented in
`notes/NOTES_PI_ORDERING_CORRECTION.md` — no change needed to the md, just
audit-note that the `(Mekbuda-corrected 2026-04-24 …)` parenthetical is
accurate.

### §2.3 `PhysicsPapers/LeanFormalizationV2/.neo4j/CLAUDE.md`

Structurally fine (accurate pipeline description, correct lake exe names,
correct script chain). One minor drift:

```diff
--- a/PhysicsPapers/LeanFormalizationV2/.neo4j/CLAUDE.md (line 51-54)
+++ b/PhysicsPapers/LeanFormalizationV2/.neo4j/CLAUDE.md (proposed)
@@
-Last known snapshot: `arrows_from_env_cycle43.jsonl` (Apr 21, 16 MB) — 23,171
-records including module imports + declaration arrow-rows. Mathlib included.
-Earlier cycle snapshots cycle3..cycle42 retained alongside in `~/lean-v2/.neo4j/`
-for provenance.
+Last known snapshot: `arrows_from_env_cycle44.jsonl` (or later, see
+`~/lean-v2/.neo4j/` for the most recent `arrows_from_env_cycleN.jsonl` symlink
+target). Post cycle-44 the graph carries ~10,142 OmegaTheoryV2 theorems +
+~7.65M edges; Mathlib corpus integrated. Earlier cycle snapshots retained
+alongside for provenance.
```

### §2.4 `chaos-shield/.claude/CLAUDE.md`

Authoritative and fresh (dated 2026-04-24). Single small opportunity: the
Status block says `axioms 24→9 via Acrab opaque-conversion pattern, then 9→1
paper-headline via Lesath` — verify by Cypher and confirm.

Cypher verification: `MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN count(a)`
returns **1** canonical axiom. Lean-core `[propext, Classical.choice, Quot.sound]`
are registered as separate `:Axiom` nodes (3 more → count=4 total). The
status block already says "4 `:Axiom` canonical nodes" — accurate. **No change
needed**.

---

## §3 Skills proposal

Both `~/.claude/skills/` and `~/.claude/commands/` are empty. Install these 5
(each as a `~/.claude/commands/<name>.md` file with frontmatter
`name: <n>` + `description: …` + optional `arguments: …`):

### §3.1 `/live-status` — one-call build+axiom+candidate snapshot

`description`: Emit live OmegaTheory V2 state — build jobs, axiom count, theorem count, TheoremCandidate status breakdown. Zero side effects.

Body runs 5 probes: (1) `lake build --log-level=error | tail -1`, (2) Cypher
`MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN a.name`, (3) count Theorem,
(4) count Theorem with `embedding_lean IS NULL`, (5) group TheoremCandidate by
status. Halt if `missing_emb > 0` or build is RED.

### §3.2 `/refresh-graph` — Phase C wrapper

`description`: Full Phase C graph refresh. Build → dump_decls → dump_arrows → load → reembed → verify → axiom-prune → power-down.

Executes Phase C (cycle-closing) in sanctioned strict order: `lake build` GREEN
→ start servers → `dump_decls` → `dump_arrows` → symlink canonicalisation →
`load_declarations_env_v2.py` → `load_arrows_parallel.py` →
`reembed_qwen3_delta.py` → verify `missing_emb = 0` → prune orphan axioms via
`MATCH (a:Axiom) WHERE NOT EXISTS { MATCH ()-[:ASSUMES|APPLIES*1..5]->(a) } DELETE a`
→ `pkill -f llama-server; pkill -f supervise_llama`. Halt on any error.

### §3.3 `/wave-dispatch N` — top-N PROPOSED → wizard brief

`description`: Produce a wizard dispatch brief for the top N OPEN/PROPOSED TheoremCandidates ranked by downstream_unblocks.
`arguments`: `[N, "number of candidates to pull"]`

Runs Cypher:
```cypher
MATCH (c:TheoremCandidate) WHERE c.status IN ['OPEN', 'PROPOSED']
RETURN c.name, c.priority, coalesce(c.downstream_unblocks, 0) AS unblocks, c.file, c.brief
ORDER BY unblocks DESC, priority LIMIT $N
```
Emits per result a block with target file, priority, downstream_unblocks, proof
sketch, OFF-LIMITS files list (auto-derived from TaskList), axiom constraint,
and acceptance criteria. Does NOT dispatch — parent decides.

### §3.4 `/axiom-audit` — `#print axioms` on paper capstones

`description`: Run `#print axioms` on every paper-capstone target; raise regression alert if non-expected axiom appears.

Targets: `omega_theory_v2_final_meta_capstone`,
`grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE`,
`omega_theory_minimal_constants_are_exactly_eight`,
`omega_theory_falsifiability_witness_panel`,
`four_irrationals_necessary_and_sufficient`. Expected footprint
`[propext, Classical.choice, Quot.sound]` for non-HermitePade; plus
`Real.pi_transcendental` for HermitePade-adjacent. Anything else = alert.
Implementation via `lean_run_code` snippet or appended `#print axioms` probe.

### §3.5 `/meta-fire` — manual trigger for this meta-improvement loop

`description`: Manually trigger the grothendieck-sage meta-improvement loop.

Spawns grothendieck-sage (`model: opus`, `maxTurns: 80`, `effort: max`) with
input: "Run the meta-audit loop per `plans/META_IMPROVEMENT_PUNCHLIST_2026-04-24_2.md`
§6. Produce `plans/META_IMPROVEMENT_PUNCHLIST_<date>_<seq>.md` with live state
block, diff-style recommendations, numbered priority stack. READ-ONLY on `.lean`."

---

## §4 AXIOM-ELIMINATION PLAN — next sub-lemma + Lindemann-Weierstrass decomposition tree

### §4.1 State map — `Real.pi_transcendental` has exactly ONE Lean-term call-site

File: `OmegaTheory/Irrationality/HermitePade/PiStratum.lean`.
- Line 45: `axiom Real.pi_transcendental : Transcendental ℚ (Real.pi : ℝ)` — the declaration.
- Line 75: `decoupling_scalar Real.pi_transcendental (fun k => (c k : ℚ)) h'` — the only Lean-term invocation (inside `pi_stratum_integer`).
- Lines 16, 21: documentation references (no semantic dependency).

The axiom flows through `pi_stratum_integer` → `pi_stratum_vector` →
Module 11 §11.4 F53 downstream. Replacing it with a weaker statement closes
the full downstream chain.

### §4.2 Cycle-51 W8 already narrowed **degree 2** (conditional)

`OmegaTheory/Irrationality/HermitePade/PiStratumDegreeTwo.lean` carries
`pi_irrational_degree_two_decoupling` with axiom footprint
`[propext, Classical.choice, Quot.sound]` — i.e. **zero research axioms**.
The price is one hypothesis `hpi_indep : ∀ r₀ r₁ : ℚ, (r₀ : ℝ) + (r₁ : ℝ) * Real.pi ≠ Real.pi^2`,
strictly weaker than `Real.pi_transcendental`.

Every caller of `pi_stratum_integer` that only needs degree ≤ 2 can migrate
to `pi_irrational_degree_one_decoupling` or `pi_irrational_degree_two_decoupling`,
discharging `hpi_indep` case-by-case.

### §4.3 NEXT SUB-LEMMA — degree-3 decoupling (proposed cycle-52 target)

**Name:** `pi_irrational_degree_three_decoupling`
**File:** `OmegaTheory/Irrationality/HermitePade/PiStratumDegreeThree.lean` (new)
**Statement:**
```lean
theorem pi_irrational_degree_three_decoupling
    (a b c d : ℚ)
    (hpi_indep₃ : ∀ (r₀ r₁ r₂ : ℚ),
        (r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi^2 ≠ Real.pi^3)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi^2 + (d : ℝ) * Real.pi^3 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0
```

**Proof sketch (30 lines):**
1. Split on `d = 0`. If yes, reduce to degree-2 via `pi_irrational_degree_two_decoupling`
   (need auxiliary `hpi_indep₂` which follows from `hpi_indep₃` by setting `r₂ = 0` and
   using degree-2 form — a ~5-line derivation).
2. If `d ≠ 0`, solve for `π^3 = -(a + b·π + c·π^2)/d ∈ ℚ + ℚ·π + ℚ·π^2`, contradicting
   `hpi_indep₃` at `(r₀, r₁, r₂) = (-a/d, -b/d, -c/d)`.
3. Field_simp + linarith closes both branches.

**Axiom footprint target:** `[propext, Classical.choice, Quot.sound]` only — NO
research axiom. Verify via `#print axioms pi_irrational_degree_three_decoupling`.

**Difficulty estimate:** EASY-MEDIUM (~2 wizard hours). Pattern is direct lift
from PiStratumDegreeTwo.lean. Biggest risk: `hpi_indep₃` ⇒ `hpi_indep₂` auxiliary
needs careful witness construction (specialise `r₂ = 0`).

**Downstream benefit:** bridges cycle-51 W8 (degree 2) to future degree-N
decoupling. Brings pi_stratum_integer's degree-3 instances inside the axiom-free
regime.

**Registration:** `:TheoremCandidate pi_irrational_degree_three_decoupling`
with `priority=HIGH`, `downstream_unblocks=3`, `batch_id=axiom_narrowing_cycle52`.

### §4.4 Lindemann–Weierstrass decomposition tree (12 Lean-sized sub-lemmas)

Goal: eliminate `Real.pi_transcendental` entirely. Mathlib already ships
`LindemannWeierstrass.exp_polynomial_approx` + `integral_exp_mul_eval`
(`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`). Missing:
**algebraic part** + **π specialisation**. Decomposition (lean-size / dep):

| # | Lemma | Lines | Mathlib? |
|---|-------|-------|----------|
| 1 | `exp_i_pi_eq_neg_one` (Euler over ℝ) | 10 | ALREADY |
| 2 | `complex_pi_transcendental → real_pi_transcendental` | 20 | PARTIAL |
| 3 | `minpoly_of_algebraic_complex_pi_has_degree_N` | 40 | NO |
| 4 | `linear_indep_exp_algebraic_families` | 60 | PARTIAL (analytic_part in) |
| 5 | `algebraic_conjugates_finite` | 30 | YES |
| 6 | `polynomial_evaluation_exp_conjugates` | 50 | NO |
| 7 | `integer_approximation_via_sumIDeriv` | 40 | has `sumIDeriv` |
| 8 | `exp_pi_product_sum_equals_zero` | 60 | NO |
| 9 | `big_prime_divisibility_argument` | 80 | analytic_part |
| 10 | `LW_algebraic_scheme_over_Q` wrapper | 100 | NO |
| 11 | `LW_applied_to_1_pi` (specialise #10) | 40 | NO |
| 12 | `pi_transcendental_from_LW` (final drop-in) | 30 | depends on #1–#11 |

Corollaries (cheap once #12 lands): `pi_sq/pi^N transcendental_corollary`
(10 lines each, via `Transcendental.pow`); `pi_not_algebraic_degree_N` (30
lines, via `Transcendental.not_isAlgebraic`). Final step is a 5-line
`axiom→theorem` rename at `PiStratum.lean:45` and a Cypher update to
NavigationMaster (paper-assumption count 5→4).

**Mathlib-shippable sub-lemma (single upstream PR):** #11
(`LW_applied_to_1_pi`) + #12 (`pi_transcendental_from_LW`). Together ~70 lines
of Lean. Once merged into Mathlib, OmegaTheoryV2 executes #17 → #20 mechanically.

**Alternative — narrower-true shortcut:** if full LW is blocked, the
intermediate lemmas #15/#16 (`pi not algebraic of degree N` for each specific
N) give us `hpi_indep_N` for each individual degree, letting us discharge the
hypothesis across PiStratumDegreeN.lean without needing full transcendence.
This is the "degree-by-degree" path that cycle-50 W9 + cycle-51 W8 already
walks.

### §4.5 HermitePadé research-axiom elimination (4 axioms)

Each is a gate in `Irrationality/HermitePade/` awaiting Mathlib port:

1. **Siegel-Shidlovskii** (2 blocked candidates) — port target: unclear.
2. **Nesterenko 1996** (1 blocked candidate) — `linear_indep_pi_1_over_zeta3` etc.
3. **Roth 1955** (1 blocked candidate) — irrationality measure ≤ 2.
4. **Mahler framework** (1 blocked candidate) — classification by approximation.

Strategy: NONE of these is a prerequisite for paper-headline capstones.
They gate the **research-track irrationality classes** (IrrationalityClasses/
TruncOrigin 4-cell partition). Lower priority than LW elimination. Recommend
parking until cycle-52 LW work lands.

---

## §5 Community-tool audit

**Installed:** `claude-auto-retry` via npm global (path
`/home/norbert/.nvm/versions/node/v24.15.0/bin/claude-auto-retry` per
fire_claude_loop.sh line 27). Works with retry backoff on 5xx / rate-limit.

**WSL cron active:** `7,37 * * * * /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/scripts/fire_claude_loop.sh`
Fires every 30 minutes.

**Guard-defer verified:** `/tmp/claude_loops/loop_20260424_1815.log` shows
`[defer] an active claude session is running; skipping this fire` — the post-
regression fix works. Previously (pre-fix) the script called `pkill -x claude`
and killed the interactive parent; now it defers.

**Log rotation:** `/tmp/claude_loops/` holds `loop_YYYYMMDD_HHMM.log` per fire.
No rotation policy — `/tmp` is cleared on WSL restart, acceptable. If we ever
want persistence, add `logrotate` config to `~/.config/logrotate/claude-loops`.

**Weak links flagged:**
1. **No `missing_emb` gate** in the fire script — if Phase C step 8 fails,
   the next fire can produce a sage brief on stale embeddings. Proposal:
   add a pre-defer cypher check `MATCH (t:Theorem {namespace:'OmegaTheoryV2'})
   WHERE t.embedding_lean IS NULL RETURN count(t)` and abort if > 0.
2. **No build-GREEN gate** before firing. If a wizard landed a RED build
   before dying, the next fire will dispatch a wizard on a broken tree.
   Proposal: `cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error || { echo "[defer] build RED"; exit 0; }`.
3. **Embedder/reranker power-down** — currently killed inside the script
   via `pkill -f llama-server` at line 65 (per audit of fire_claude_loop.sh,
   truncated read needed for full verification). This works, but it means
   every fire leaves the machine in "servers off" state, and the wizard
   has to restart them if they need retrieval. Actually correct per the
   power-hygiene rule, but worth logging when it happens.

**All three weak links are NON-BLOCKING** for the resume — the current setup
is safe. They're "next sprint" items.

---

## §6 Top-5 wins ranked by time-savings × blast-radius

Ordered by `hours_saved × blast_radius`:

### #1. Update `LeanFormalizationV2/CLAUDE.md` status block (§2.1)
- **Time-savings:** 0.5 hours per agent spawn (no re-derivation of current
  axiom count / build-jobs count from scratch).
- **Blast radius:** every grothendieck + wizard + pi-* dispatch reads this.
- **Effort:** 5 minutes of editing.
- **Score:** `0.5 × 10 = 5.0`. **IMMEDIATE WIN**.

### #2. Drop `Agent` tool from grothendieck-sage (§1.1)
- **Time-savings:** 0.2 hours per sage run (no retry loops on the silently-
  no-op'd Agent tool). Also removes user confusion from the YAML saying
  "Agent" when the runtime blocks it.
- **Blast radius:** every sage session.
- **Effort:** 1-line YAML edit.
- **Score:** `0.2 × 8 = 1.6`.

### #3. Install `/live-status` + `/refresh-graph` + `/axiom-audit` commands (§3.1, §3.2, §3.4)
- **Time-savings:** 0.3-1.0 hours per cycle. Live-status is the
  most-often-re-derived datum; axiom-audit catches regressions early;
  refresh-graph standardises Phase C (currently copy-pasted from CLAUDE.md).
- **Blast radius:** every cycle close.
- **Effort:** ~30 minutes of skill authoring.
- **Score:** `0.7 × 6 = 4.2`. **HIGH-LEVERAGE BUNDLE**.

### #4. Draft `PiStratumDegreeThree.lean` and register as `:TheoremCandidate` (§4.3)
- **Time-savings:** closes the "what's after W8?" question for cycle-52
  (20-min planning step saved on every cycle start).
- **Blast radius:** axiom-elimination track (paper-headline assumption count).
- **Effort:** 2 wizard-hours to land the proof; 0.1 hour to propose.
- **Score:** `0.1 × 7 = 0.7` for the proposal (the landing is wizard work,
  not meta-improvement).

### #5. Add guard-defer build+embedding gates to `fire_claude_loop.sh` (§5 weak links)
- **Time-savings:** eliminates the risk of a wizard being dispatched on a
  RED-build or stale-embedding tree (potential 2-4 hours of wasted wizard
  work per failure).
- **Blast radius:** every auto-fire.
- **Effort:** ~20 lines bash.
- **Score:** `3.0 × 3 = 9.0` if a failure actually occurs; `0 × 3 = 0` if
  the pipeline stays clean. Call it `expected = 0.5 × 3 = 1.5`.

### Top-5 ordered by expected-value score:
1. Update `LeanFormalizationV2/CLAUDE.md` status block — 5.0
2. Install 5 skills (`/live-status`, `/refresh-graph`, `/wave-dispatch`, `/axiom-audit`, `/meta-fire`) — 4.2 bundle
3. Drop `Agent` from grothendieck-sage + add ROLE LOCK section — 1.6
4. Add guard-defer gates to fire_claude_loop.sh — 1.5 expected
5. Register `pi_irrational_degree_three_decoupling` :TheoremCandidate — 0.7

---

## Appendix — Cycle-51 respawn-candidates (W1, W5, W6+W7) for cycle-52 batch

Not strictly meta-improvement, but the user directive said "cycle-52 planning":

| Wizard | Target | Notes |
|---|---|---|
| W1 | `healingFlow_drives_inflation` sharp-form | Check if the cycle-51 kill-mid-proof left a partial landing; resume from last clean checkpoint. |
| W5 | PMNS θ23 maximal-mixing substrate derivation | Same as W1 — inspect partial state. |
| W6+W7 | Jarlskog wraps (2 theorems, bundled) + anomaly wraps (1 theorem) | Bundle into a single wizard dispatch per user efficiency preference. |

Recommend respawning as a single cycle-52-opener wave after §6 items 1-3 are
actioned, to maximise retrieval-quality uplift.

---

**END OF PUNCHLIST v2 — 2026-04-24.**
