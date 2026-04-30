---
name: hard-theorem-decomposition
description: SOTA methodology for decomposing hard mathematical theorems into provable NAMED-Prop lemmas. Top-down + bottom-up hybrid with graph-augmented premise selection. Distilled from Pólya / Tao / Hindry-Silverman / Lean SOTA + empirical T-5 closure (5 NAMED leaves from 2 abstract NAMED in 1 session, 13 commits).
---

# Hard-Theorem Decomposition Skill (SOTA 2026-04-30)

> "Worth saving this tactic to memory — sometimes it's worth decomposing in
> such a way that we make harder theorems and use lemmas that are needed,
> and then work to build those lemmas. Many mathematicians work this way
> because it CLEANS THE FIELD for what's actually worth proving."
> — User mandate, 2026-04-29 (translated from Polish)

> "stop witnesses, start closing atoms. decompose properly so it'll not
> take much work IF decompose leaves properly."
> — User mandate, 2026-04-30

The Erdős Primarch v8.0 5-PHASE HYBRID composition strategy distilled from
Pólya 1945 + Tao 2025 + Hindry-Silverman 2000 + Fikhtenholz 1947 + Lean 4
native top-down. LOCKED 2026-04-30 v3.

---

## When to use this skill

Apply this skill when ANY of the following triggers hit:

1. **The proof obligation is "hard"** — multi-component, no clean single-tactic
   path (`exact?`/`aesop`/`grind` fail or stall). Concrete heuristic: more
   than one analytical primitive (Taylor + AM-QM + balance + pigeonhole)
   in scope.
2. **The plan-of-record reads as "build N helpers, then prove the goal"**
   for N ≥ 50. Top-down inverts this to "state goal with 5–10 NAMED Props,
   prove the composition layer, then discharge the lemmas." Empirically
   beats N=488 helpers per cycle 65 pivot.
3. **The composition skeleton is visible but the analytical heart is not.**
   When you can sketch "if H1, H2, H3 hold then the goal follows by …"
   but cannot yet prove H1, you should commit the composition + NAMED Props
   first and discharge later.
4. **Mathlib does not yet have the artefact you need.** "Mathlib upstream"
   is NEVER a blockade — decompose into Lean-sized sub-lemmas, port what's
   needed (T-4 retired 2026-04-27 in 14 files / ~3000 lines, single day).
5. **A previous fire produced a single abstract NAMED Prop hiding the
   analytical work.** The cure: factor through smaller NAMED leaves.

Do NOT apply this skill when:

- The proof is a one-liner (`omega`, `ring`, single `exact?` hit).
- The composition itself is the hard part (rare — when this happens, the
  decomposition is the wrong shape; redraw the boundary).
- The user has explicitly asked for a slim conditional theorem (rare;
  forbidden by §7.0 NO STUBS unless paired with discharge plan).

---

## Decision tree at top

```
PROOF OBLIGATION RECEIVED
├── [ROUTINE]   → exact? → omega/ring/aesop → done                  STOP
├── [MEDIUM]    → omega_hammer_premise → exact? → aesop → grind     STOP
├── [HARD]      → 5-PHASE HYBRID:
│                   A. State w/ NAMED Props
│                   B. Truth-rank H₁..Hₙ
│                   C. Discharge per tier (99+% first)
│                   D. Bottom-up filling if needed
│                   E. Compose + Yoneda bridge sweep + axiom audit
│
└── [HEART]     → web-search literature line-by-line
                   single-thread sustained burn
                   BUNDLED-LEMMA-FILE pattern (~22× throughput)
                   ~50–200 lines per session, NO STUBS

When `omega_hammer_premise(top_k=20, mix_mathlib=True)` returns ≥1 hit
with composite score ≥ 0.85 AND the goal admits a single-tactic discharge,
demote the obligation one tier (HEART → HARD, HARD → MEDIUM, MEDIUM → ROUTINE).
```

---

## The 5-PHASE HYBRID composition strategy

### PHASE A — TOP-DOWN STATEMENT (Pólya step 1+2 / Tao "Think Ahead")

State the harder theorem first. Ask Tao's questions:

- *If proven, how would it be used?*
- *Would a weaker version suffice for the immediate downstream consumer?*
- *Is there a simpler equivalent formulation?*

Identify n NAMED Prop hypotheses H₁…Hₙ that compose into the theorem.
The composition layer is the ROADMAP — usually short and mechanical.

**Lean signature template:**

```lean
-- Step 1: NAMED Prop placeholders (real Prop content, NEVER `:= True`)
def T5_HEART_hypothesis_factor_split : Prop :=
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ) ..., P ≠ 0 → ...

def T5_HEART_hypothesis_pigeonhole : Prop := ...
def T5_HEART_hypothesis_taylor    : Prop := ...
def T5_HEART_hypothesis_induction : Prop := ...

-- Step 2: The composition (the ROADMAP)
theorem T5_HEART_recursion_from_hypotheses
    (h1 : T5_HEART_hypothesis_factor_split)
    (h2 : T5_HEART_hypothesis_pigeonhole)
    (h3 : T5_HEART_hypothesis_taylor)
    (h4 : T5_HEART_hypothesis_induction) :
    HEART_recursion_bound := by
  intro …
  obtain ⟨…⟩ := h1 …
  obtain ⟨…⟩ := h2 …
  …
```

### PHASE B — TRUTH-RANK NAMED PROPS (Hindry-Silverman canon)

Sort H₁…Hₙ by ESTIMATED TRUTH CONFIDENCE:

| Tier | Confidence | Discharge profile |
|------|-----------:|-------------------|
| **Tier-99** | 99+% true, sub-lemma is essentially routine | discharge FIRST |
| **Tier-80** | 80–99% true, medium-difficulty | discharge SECOND |
| **Tier-Heart** | < 80% true, the analytical heart | discharge LAST |

Why 99+% first:
- Cleanup wins the build commit history + reveal what machinery the heart
  actually needs.
- Hindry-Silverman literally structures Roth this way: "Aux Poly +
  Index Is Large + Index Is Small" are ALL named-lemma cleanups before
  the analytical Completion.

### PHASE C — DISCHARGE PER TIER (Tao "Trim the fat")

| Tier | Tactic profile | Convergence |
|------|----------------|-------------|
| Tier-99 | `omega_hammer_premise → exact?` chain or short concrete construction | 1–3 ext sub-iterations per lemma |
| Tier-80 | LSP-assisted manual proof with `lean_loogle + aesop` | 3–7 ext sub-iterations |
| Tier-Heart | long single-thread session, web-search literature line-by-line, Mathlib API lookup per inequality step | 2–3 sub-iterations to get right; ~50–200 lines/session |

### PHASE D — BOTTOM-UP FILLING (Fikhtenholz — knows the destination)

When a named Hᵢ requires sub-machinery (e.g. multivariate Taylor at
real α requires univariate Taylor + finite-sum Taylor + composition
lemmas), build foundational pieces CONCRETELY with examples.
Fikhtenholz knew the destination even when building bottom-up.

Layered pattern, applied to T-5 V8 smallJ witness:

- **Layer 0** — real-analytic glue (e.g. `Real.rpow_inv_natCast_pow`)
- **Layer 1** — m=1 base case (univariate Taylor at α)
- **Layer 2** — index calculus (`MvPolynomial.degreeOf`,
  `multiIteratedPDeriv`)
- **Layer 3+** — recursive composition (multivariate Taylor coefficient
  formula via `shiftPoly α P`)

Bundle related sub-lemmas in a single file per BUNDLED-LEMMA-FILE
pattern (`A82` arsenal entry — ~22× throughput multiplier validated
this session).

### PHASE E — COMPOSE & REVIEW (Pólya step 3+4 / Tao "Question everything")

After all Hᵢ discharge:

1. Compose all Hᵢ into the unconditional theorem.
2. Pólya step 4: look back. Did we use minimum hypotheses? Are there
   generalizations?
3. Tao "Question everything": what stronger statement holds? What
   corollaries follow?
4. **Yoneda bridge sweep:**
   ```python
   mcp__omega-search__find_similar(seed_name, k=10, namespace='OmegaTheoryV2')
   ```
   Top-similarity hits > 0.85 get explicit bridge theorems. Adds
   5–15 APPLIES per bridge, prevents graph isolation.
5. **Axiom audit:**
   ```python
   mcp__omega-orchestrator__axiom_audit(targets=[...])
   ```
   Must return `[propext, Classical.choice, Quot.sound]` only.

---

## Heuristics for decomposition

### When (5 triggers + corollary)

1. Goal has multiple analytical primitives in scope.
2. Plan-of-record reads as "build N helpers" for N ≥ 50.
3. Composition skeleton visible, analytical heart not.
4. Mathlib gap blocking a one-liner.
5. Previous fire produced a single abstract NAMED Prop.

**Corollary** (locked 2026-04-30): if a NAMED Prop is "exists witness
with sum ≤ T", **factor through the witness existence** as the heart;
the upper bound conclusion follows by `csInf_le` mechanically. This
is the V8-D5 architecture.

### How deep (3 layers max + signs of overdecomposition)

Three layers suffice for almost every hard theorem:

```
Layer 1: ROADMAP   — composition with N ≤ 7 NAMED Props
Layer 2: TIERED    — each NAMED Prop discharges via 99/80/Heart split
Layer 3: HEART     — the analytical content (~50–500 lines per leaf)
```

Signs of overdecomposition (STOP):

- Same identity restated three times in different namespaces.
- "Composition lemmas" that are actually just `id`-renames.
- More than ~7 NAMED hypotheses in a single capstone signature
  (the user can no longer hold the picture in head).
- Composition layer becomes harder than the original goal.

Signs of UNDERDECOMPOSITION (STILL TOO ABSTRACT — refactor):

- A single NAMED Prop hides multiple analytical primitives (Taylor +
  AM-QM + pigeonhole all behind one `T5_RothLemmaIndexReductionDischarge`).
- "Discharge plan" reads as "do the whole proof." Factor again.

### Where (statement structure analysis)

Cut along these natural seams:

- **Existential boundary** — `∃ x, P x` → factor as "∃ witness w" plus
  "P w follows by single-tactic". This is the V8-D5 csInf_le pattern.
- **Conjunctive boundary** — `P ∧ Q ∧ R` → three NAMED Props discharged
  independently. (Schmidt machinery: SM-1 int-poly ∧ SM-2 balance ∧
  SM-3 aeval-nonzero.)
- **Inductive boundary** — `∀ n, F n` → base case + step case as separate
  NAMED Props.
- **Sequential boundary** — `goal → intermediate → final` → state the
  intermediate as named, prove both arrows.
- **Quantifier-strength boundary** — STRONG `Π R, ∃ q, …` factors
  cleanly; WEAK `∃ R q, …` often hides the dependency that needs
  named-lemma surfacing.

---

## Graph-augmented premise selection

### MCP cascade priority

The OmegaTheoryV2 graph has 184K+ theorems (~10K OV2 + ~175K Mathlib
v4.29.0) with FastRP embeddings + ByT5 retriever (1472-d) + Qwen3
embeddings (4096-d) + 7.65M typed edges. **Skipping the graph is
professional malpractice.**

For EVERY proof obligation, run AT LEAST 3 of these BEFORE manual proof:

```
Tier-1 (omega-orchestrator)
  1. omega_hammer_premise(goal, top_k=20, mix_mathlib=True)
        → composite-ranked premises (cosine + PageRank + indegree
                                     + subsystem_match)
  2. propose_proof(goal, wizard_name=<you>, k=10)
        → tactic stub + 5 cited premises + graph_rationale + 4 related

Tier-2 (omega-search)
  3. retrieve_premises(goal_text, k=20)            -- ByT5 semantic
  4. find_similar(theorem_name, k=10, rerank=True) -- pure kNN
  5. neighbors(theorem_name, hops=2)               -- 2-hop APPLIES/UNFOLDS
  6. explain_theorem(theorem_name)                 -- full sig + body
  7. subsystem_of(theorem_name)                    -- Leiden cluster

Tier-3 (lean-lsp)
  8. lean_loogle(query)             -- type pattern
  9. lean_leansearch(query)         -- NL
  10. lean_state_search(file, line) -- close-the-goal
  11. lean_local_search(query)      -- fast local
  12. lean_hammer_premise(file, line)
  13. lean_multi_attempt(file, line, snippets) -- 3+ tactics in parallel

Tier-4 (Cypher direct)
  14. mcp__neo4j-math__read_neo4j_cypher  -- structural / Leiden / paths
```

### When each tool fits

| Goal shape | Best first tool | Why |
|------------|-----------------|-----|
| "Find lemma matching this goal type" | `lean_loogle` (type pattern) | sig-anchored search |
| "Find lemma about concept X" | `lean_leansearch` (NL) | semantic mathlib |
| "Close THIS specific goal at THIS position" | `lean_state_search` | uses term context |
| "Need premises for `simp [...]` seed" | `lean_hammer_premise` | premise-set extraction |
| "Find sister theorems within OV2" | `find_similar` | embedding kNN |
| "What downstream theorems will break if I rename?" | `neighbors(hops=2)` | APPLIES-graph lookup |
| "Yoneda bridge candidates after landing X" | `find_similar(k=10, namespace='OmegaTheoryV2')` | kNN > 0.85 = bridge |
| "Subsystem of family Y" | `subsystem_of` | 137 Leiden clusters |
| "Composite-best premise across both corpora" | `omega_hammer_premise(mix_mathlib=True)` | unified composite score |
| "Tactic stub + rationale for new wizard" | `propose_proof(wizard_name=...)` | full bundle |

### Yoneda bridge sweep workflow

After landing any new paper-grade theorem `seed_name`:

```
1. mcp__omega-search__find_similar(seed_name, k=10, namespace='OmegaTheoryV2')
2. Inspect hits with score ≥ 0.91 (refined empirical threshold per
   2026-04-30 audit — same-family cluster floor; the previous "0.85"
   threshold from CLAUDE.md is the conservative-routine lower bound).
3. For each, write an explicit bridge theorem:
     theorem omega_theory_v2_bridge_<seed>_to_<hit> :
       seed_implication_at_named_witness ↔ hit_implication_at_same_witness :=
     by simp [seed_def, hit_def, ...]
4. Each bridge typically adds 5–15 APPLIES edges in the graph.
5. Reference: `Capstones/SM95BarTopQuarkBridge.lean` — 3 bridges wiring
   a 145-outdeg isolate via 3 numeric/structural bridges.
```

**Bridge-file-size empirics** (from analyst audit; files containing
"Bridge" or "yoneda_bridge"):

| Bridges/file | Example file |
|-------------:|--------------|
| 44 (outlier) | `QmBridgePaperCapstone.lean` |
| 23 | `DiracFromLatticeDataOrphanDefBridge.lean` |
| 22 | `CrossSectorBridges.lean`, `AFIrreducibilityFirstAlgebraModuleBridgeInbound.lean` |
| 17–19 | several |

**Typical bridge file**: 8–22 small forwarding bridges (outdeg 5–15
each) + one giant aggregator at outdeg 50+ wrapping the whole file.
A capstone landing followed by a bridge file adds **50–300 new APPLIES**
to the graph, prevents Leiden-cluster isolation.

### Edge-type semantics

In OV2 (analyst typed-edge audit 2026-04-30):

| Edge type | Count | Role |
|-----------|------:|------|
| APPLIES | 345,296 | **PRIMARY DEPENDENCY — traverse for decomposition planning** |
| UNFOLDS | 312,432 | definitional unfolding |
| PARAMETRIZES_TYPES | 72,804 | type-class parameter |
| ASSUMES | 2 | NAMED hypothesis (essentially unused — typed extractor doesn't materialize) |

When traversing the graph for proof-decomposition planning, use
`APPLIES` (and `APPLIES*` for transitive closure). DO NOT rely on
`ASSUMES` for NAMED-Prop tracking; use file-scoped Cypher matching by
name pattern (`name CONTAINS 'NAMED'`) instead.

### Anti-pattern: skipping MCP for "I remember from precedent file"

This regresses for paper-grade work (locked 2026-04-28). The graph sees:

- All sister-wizard theorems landed minutes ago (not yet in your context)
- Embedding similarity (semantic, not syntactic)
- Structural distance (PageRank in 7.65M-edge typed graph)

ENFORCEMENT: every wizard deliverable must include a `graph_queries_run`
field listing tools invoked, top-1 results, and which made it into the
proof. Silent skipping = parent flags for retrospective REWRITE penalty.

---

## Bottom-up infrastructure pattern (Fikhtenholz)

### BUNDLED-LEMMA-FILE pattern (3–7× decl-density multiplier)

**When**: multiple ext sub-iterations sharing namespace + imports + form
(e.g. all paper-form variants of irrational generic Roth).

**Pattern**:

```
Filename:   T5_Phase7_<Theme>Bundle_<roman>.lean   (~250–600 lines)
Sub-clusters: A / B / C / D / E grouping related lemmas
Namespace:  single, all `open` siblings inline
Headline:   ONE master alias at end
Closure markers: real Nat bookkeeping (NOT `True := True.intro`)
```

Empirics across 71 `IrrationalGenericBundle_{I..LXXI}` files:

| Bundle | LOC | Decls | Lines/decl |
|--------|-----|-------|------------|
| Bundle II | 506 | 22 | 23 |
| Bundle III | 486 | 22 | 22 |
| Bundle IV | 251 | 11 | 23 |
| Bundle V | 332 | ~15 | ~22 |
| Bundle XV | 320 | ~15 | ~21 |
| Steady-state LV–LXXI | — | 15–16 | — |

**Refined throughput claim** (per crawler audit 2026-04-30): the
decl-density gain in committed source is **3–7×**, NOT the previously
cited 22× peak figure. The 22× figure is reachable for hand-authored
sessions sustaining one bundle file per fire, and includes elimination
of N independent imports/opens/namespaces and N independent `lake build`
invocations during iteration. For typical use, expect 3–7× per bundle
file vs N separate files.

Single build invocation (~2s) + single commit still beats 22 separate
files × ~0.6s + 22 commits in iteration overhead during sustained
single-thread burns.

### Layer 0 / 1 / 2 / 3 building blocks

For T-5 V8 smallJ-witness HEART (analytical content):

| Layer | Building block | Status |
|-------|----------------|--------|
| 0 | real-analytic glue (`Real.rpow_inv_natCast_pow`, `Real.exp`, `Real.log` lemmas) | DONE |
| 1 | univariate Taylor at α (`Polynomial.taylor`, A42 arsenal) | DONE |
| 2 | `MvPolynomial.degreeOf`, `multiIteratedPDeriv`, `aeval` plumbing | DONE |
| 3 | multivariate Taylor at real α (Taylor sum form via `shiftPoly`) | DONE this fire |
| 4 | per-Taylor-term bound (VC-9 via violator factor decay) | DONE |
| 5 | AM-QM √m birth (Cauchy-Schwarz factor) | DONE this fire |
| 6 | balance condition wiring + κ-formula derivation | PENDING — heart |

The lower layers (0–5) compose mechanically into the heart (layer 6).
This is Fikhtenholz: build concretely from below, knowing the destination.

---

## Top-down architectural pattern (Hindry-Silverman / Pólya)

### State hard theorem with NAMED Prop hypotheses

Hindry-Silverman §D structures Roth as:
1. Preliminary Results
2. Construction of the Auxiliary Polynomial
3. **The Index Is Large** (Roth's Lemma — Layer 2/3)
4. **The Index Is Small** (Roth's Lemma — the HEART)
5. Completion of the Proof

Each of (3), (4) is a NAMED lemma in their text. We mirror this:

```
T5_NAMED_BlockC_Taylor_upper_bound_uniform   -- (3) Index Is Large
T5_NAMED_smallJ_witness_at_q                 -- (4) Index Is Small
T5_NAMED_Schmidt_aux_int_poly                -- (2) Auxiliary
T5_NAMED_Schmidt_balance_per_n               -- balance / Hindry-Silverman §D.7
T5_NAMED_Schmidt_aeval_nonzero_per_n         -- non-vanishing
```

5 NAMED leaves total; composition (5) is mechanical.

### Truth-rank (99+% / 80% / Heart)

Apply this every fire:

- **Tier-99** (99+% confident): cleanups + closures. Discharge first to
  unblock downstream + to surface what the heart actually needs.
- **Tier-80** (80–99%): medium proofs. After tier-99 lands.
- **Tier-Heart** (< 80%): the analytical content. Long single-thread,
  no subagent.

**Empirical Tier-99 anchors in OV2** (per analyst audit 2026-04-30 — top
in-degree):

| Anchor | Indeg | Distinct caller files | File |
|--------|------:|---------------------:|------|
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

**Decomposition rule**: when stating a NEW physics-grade theorem, first
identify the 3–5 Tier-99 anchors it pulls in. They close cheaply via
`have := <anchor>; positivity / omega`. Tier-99 anchors are uniformly
positivity / non-zero / decreasing primitives.

For T-5 V8 final closure:
- Tier-99: SM-1 (Schmidt-int-poly, ~150 LOC, 2–3 fires, MED risk)
- Tier-80: SM-3 (Schmidt-aeval-nonzero, ~150 LOC, 2–3 fires, MED risk)
- Tier-80: SM-2 (Schmidt-balance, ~200 LOC, 3–5 fires, HARD)
- Tier-Heart: V7-N1-uniform (~300 LOC, 4–6 fires, shares infra w/ #1)
- Tier-Heart: smallJ witness (~400 LOC, 5–7 fires, the analytical heart)

### Articulation gateways (DO NOT bypass)

Theorems with `indeg ≥ 5 AND outdeg ≥ 5` are routing nodes whose removal
disconnects subsystems. Top examples:

| Gateway | Indeg | Outdeg | Role |
|---------|------:|-------:|------|
| `realDiagonalComplex_eigenvalues_range` | 6 | 192 | D_F spectrum bridge |
| `hermitian_complex_spectrum_elt_im_zero` | 5 | 190 | hermitian-spectrum gate |
| `LeanAlgebraLaplacian_isHermitian` | 18 | 150 | magnetic-Laplacian gate |
| `grand_qm_emergence` | 6 | 144 | QM capstone gate |
| `closed1_is_exact` | 8 | 140 | Poincaré-lemma gate |
| `topQuarkMassGeV_mem_window` | 6 | 134 | top-quark window gate |
| `discreteLaplacian_const` | 19 | 99 | operator-evaluator gate |

**Decomposition rule**: when porting a new sector, route through these
gateways. Refactoring them risks 100+ downstream failures.

### Outdeg signature smoke test

After landing, the new theorem's APPLIES outdeg should match its profile:

| Profile | Expected outdeg | Examples |
|---------|----------------:|----------|
| Tier-99 leaf anchor | 30–40 (high indeg) | `c_pos`, `l_P_pos`, `pi_error_pos` |
| Capstone (paper-bundle) | 50–180 | `dirac_f_spectrum_real_unified_capstone`=174, `top_quark_absolute_paper_bundle`=145 |
| Analytical workhorse | 200–650 | `eventually_periodic_digit_frequency_rational`=624, `taylor_tail_bound`=451 |
| Articulation gateway | 100–200 (with indeg 5–20) | `realDiagonalComplex_eigenvalues_range`, `LeanAlgebraLaplacian_isHermitian` |

**Smoke test**: T-5 V8 paper-headline `omega_theory_v2_T5_roth_unconditional`
should land at outdeg 50–100 (composing 5 NAMED Props + Tier-99 anchors).
T-5 analytical heart at outdeg 200–400 (like `taylor_tail_bound`=451).

If your heart's outdeg comes out below 100, you are HIDING work in
trusted lemmas — further decompose. If above 600, you are
OVER-DECOMPOSING — consolidate.

### Discharge cleanup-tier first

Hindry-Silverman literally writes "Index Is Large" + "Index Is Small"
as separate sub-sections. Once Index Is Large is proved (the cleanup),
the Index Is Small (the heart) has its boundary conditions cleaned.

In our V8 architecture: discharge SM-1/SM-2/SM-3 (tier-80) first;
their landings reveal which Mathlib gaps the heart leaves face.

---

## Testing decomposition success

You have decomposed correctly when ALL of these hold:

1. **Composition theorem machine-checks.** The Lean file with the
   `theorem T5_RothTheorem_from_5_NAMED` (or analogue) compiles GREEN.
2. **Build delta is non-negative.** `lake build` job count strictly
   ≥ baseline; no regressions.
3. **Axiom audit returns Lean-core only.** `axiom_audit(targets=[capstone])`
   = `[propext, Classical.choice, Quot.sound]`.
4. **Each NAMED Prop has explicit discharge plan** in a docstring or
   sibling `.md` file (real Prop content; never `:= True`; per §7.0
   NO STUBS).
5. **Yoneda bridge sweep ran.** `find_similar(seed, k=10)` queried;
   bridges to top-similarity hits ≥ 0.85 written.
6. **Composition layer is short relative to N.** Roughly: composition
   ≤ 100 LOC for N ≤ 7 NAMED Props. If 500 LOC, the boundary is wrong.
7. **Tier-99 leaves discharged FIRST.** Build history shows them landing
   before tier-80 / tier-heart.

Failure modes:

- (A) Composition machine-checks but Tier-Heart leaf has no discharge
  plan → SLIM (forbidden 2026-04-28).
- (B) NAMED Prop is `Nonempty S` without round-trip funext — categorical
  Yoneda mass-batch trash (forbidden §8a).
- (C) `axiom_audit` reveals a new axiom snuck in via unsealed import —
  PRUNE.
- (D) Build red 3× consecutive: hard exit, do not push, file a Last Stand
  Tier-3+ memo and pause.

---

## Concrete templates

### NAMED Prop signature patterns (good vs broken)

**GOOD** — universal Prop with named hypotheses, real content, real
analytical work:

```lean
def T5_NAMED_smallJ_witness_at_q : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
    P ≠ 0 →
    0 < ε →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    (∀ i, 1 ≤ (q i).den) →
    T5_DenominatorGrowthCondition q ε →
    T5_DegreeHeightBalanceCondition R q ε →
    rothIndex P (fun _ => α) R ≥ t →
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε)
```

— file: `T5_Phase7_V8D5_SmallJWitness_Reduction.lean:60`

**BROKEN** — categorical Yoneda mass-batch stub forbidden by §8a:

```lean
-- DO NOT WRITE THIS — citation-only Nonempty:
def Yoneda_witness_<seed> : Prop := Nonempty (PreservesLimits ...)

theorem Yoneda_<seed>_holds : Yoneda_witness_<seed> := ⟨inferInstance⟩
-- ↑ ZERO content, density 0.10–0.59 vs hand-authored 1.13–3.6.
```

**BROKEN** — slim `:= True`:

```lean
-- FORBIDDEN by §7.0 NO STUBS:
def T5_NAMED_thing : Prop := True
theorem T5_thing_holds : T5_NAMED_thing := trivial
```

### Composition theorem template

```lean
theorem T5_V8_RothTheorem_from_5_NAMED
    (h_smallJ      : T5_NAMED_smallJ_witness_at_q)
    (h_blockC      : T5_NAMED_BlockC_Taylor_upper_bound_uniform)
    (h_schmidtPoly : T5_NAMED_Schmidt_aux_int_poly)
    (h_schmidtBal  : T5_NAMED_Schmidt_balance_per_n)
    (h_schmidtNZ   : T5_NAMED_Schmidt_aeval_nonzero_per_n) :
    RothTheorem := by
  -- Phase 1: Block A+B via 3 Schmidt NAMED
  have h_blockAB :=
    T5_NAMED_BlockAB_via_3_Schmidt_NAMED h_schmidtPoly h_schmidtBal h_schmidtNZ
  -- Phase 2: master via smallJ witness
  have h_master :=
    T5_RothLemmaMaster_from_smallJ_witness h_smallJ
  -- Phase 3: V7 capstone via BlockAB + master + pigeon
  have h_v7 :=
    T5_V7_capstone_via_BlockAB_full h_blockC h_blockAB h_master
        T5_PigeonholeMTuple_unconditional
  -- Phase 4: bundle small + large
  exact T5_Roth_via_bound_large_and_small h_v7 RothBoundSmall_unconditional
```

### csInf_le factoring template (V8-D5 style)

This is the SOTA pattern when the goal is `rothIndex ≤ T` (an upper
bound on an `sInf`):

```lean
theorem T5_RothLemmaIndexReductionDischarge_via_smallJ_witness
    (h_witness : T5_NAMED_smallJ_witness_at_q) :
    T5_RothLemmaIndexReduction_Statement := by
  intro m hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  -- 1. Extract the witness from the NAMED Prop
  obtain ⟨j, h_aeval_ne, h_sum_le⟩ :=
    h_witness hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  -- 2. The witness gives a member of the rothIndex set at q
  have h_mem :
      (∑ i, (j i : ℝ) / (R i : ℝ)) ∈
        { r : ℝ | ∃ j : Fin m → ℕ,
            aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
            r = ∑ i, (j i : ℝ) / (R i : ℝ) } :=
    ⟨j, h_aeval_ne, rfl⟩
  -- 3. Apply csInf_le: infimum ≤ this member ≤ t - √(mε)
  exact le_trans (csInf_le ⟨0, by …⟩ h_mem) h_sum_le
```

— file: `T5_Phase7_V8D5_SmallJWitness_Reduction.lean:85`

The key insight: factor `rothIndex ≤ T` through "exists j with sum ≤ T",
then close mechanically by `csInf_le`. The witness existence is the
analytical heart; the upper bound is mechanical.

### BUMPED chain pattern (D4 style)

When the goal is "∃ ℕ-indexed sequence with strict monotonicity AND
log-growth", use `max(prev, ⌈exp(C · log prev)⌉)` as the bumping
threshold:

```lean
noncomputable def T5_pigeonholeSeq_bumped
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) :
    ℕ → ℚ
  | 0 => Classical.choose (h 1)
  | n + 1 =>
    let prev := T5_pigeonholeSeq_bumped h ε n
    let M_n : ℕ := max prev.den
      (Nat.ceil (Real.exp ((2/ε) * Real.log (prev.den : ℝ))))
    Classical.choose (h M_n)
```

— file: `T5_Phase7_BlockAB_D4_PigeonholeSequence.lean:41`

The `max prev (⌈exp(C log prev)⌉)` ensures **both** strict monotonicity
(via `prev ≤ M_n`) AND log-growth (via `M_n ≥ exp(C log prev)`). Single
construction discharges two structural conditions.

### Strengthen-weak-existential pattern (D2-strong style)

When a weak existential `∃ T : MvPolynomial …, T = …` is needed but the
strong form `∀ y, P(α + y) = ∑ J, c(J) · y^J` is also useful, prove the
**strong** form first then weaken:

```lean
theorem T5_NAMED_mvTaylor_at_real_alpha_strong : Prop :=
  ∀ ..., ∃ (T : MvPolynomial (Fin m) ℝ),
    (∀ y, P.eval₂ ... (α + y) = T.eval₂ ... y) ∧
    -- + structural property linking c(J) to multiIteratedPDeriv J P at α

theorem T5_NAMED_mvTaylor_at_real_alpha_weak : Prop :=
  ∀ ..., ∃ (T : MvPolynomial (Fin m) ℝ),
    ∀ y, P.eval₂ ... (α + y) = T.eval₂ ... y

theorem weak_from_strong :
    T5_NAMED_mvTaylor_at_real_alpha_strong →
    T5_NAMED_mvTaylor_at_real_alpha_weak := by
  intro h_strong; intro …
  obtain ⟨T, h_eq, _⟩ := h_strong …
  exact ⟨T, h_eq⟩
```

This is a free upgrade: discharging strong → weak follows trivially,
and downstream consumers can choose the form they need without redoing
analytical work.

---

## Examples from T-5 V8 closure

### Example 1 — V8-D5 smallJ witness reduction (csInf_le factoring)

**Before**: `T5_RothLemmaIndexReductionDischarge` (Hindry-Silverman D.6.1)
was a single abstract NAMED Prop hiding ~970 lines of analytical work
(Taylor + AM-QM + balance + κ-formula).

**After**: factored through `T5_NAMED_smallJ_witness_at_q` — a smaller
NAMED leaf (witness existence). Composition via `csInf_le` is ~50 LOC,
mechanical. Heart isolated to ~400 LOC of pure analytical work.

Files:
- `T5_Phase7_V8D5_SmallJWitness_Reduction.lean:60` (NAMED def)
- `T5_Phase7_V8D5_SmallJWitness_Reduction.lean:85` (csInf_le composition)
- `T5_Phase7_RothTheorem_from_5_NAMED.lean` (V8 capstone)

### Example 2 — Block A+B via 3 Schmidt NAMED leaves

**Before**: `T5_NAMED_BlockAB_sequence_extraction` was a single abstract
NAMED Prop covering Schmidt machinery + balance + non-vanishing.

**After**: factored through 3 sub-NAMED leaves (SM-1 Schmidt-int-poly +
SM-2 balance + SM-3 aeval-nonzero). Each has independent discharge plan.

Files:
- `T5_Phase7_BlockAB_SchmidtMachineryNAMED.lean:65` (SM-1)
- `T5_Phase7_BlockAB_SchmidtMachineryNAMED.lean:95` (SM-2)
- `T5_Phase7_BlockAB_SchmidtMachineryNAMED.lean:122` (SM-3)
- `T5_Phase7_BlockAB_FromSchmidtMachinery.lean` (composition)

### Example 3 — D4 pigeonhole sequence (BUMPED chain)

**Before**: D4 was "construct a Cauchy-like sequence with both strict
monotone denominators AND log-growth" — appeared to need 2 separate
constructions.

**After**: single `max(prev, ⌈exp(C log prev)⌉)` threshold gives both,
unconditionally. ~210 LOC, 8 theorems, fully discharged.

File: `T5_Phase7_BlockAB_D4_PigeonholeSequence.lean`

### Example 4 — D5 corrected per-n bundle

**Before**: D5 was attempted as full unconditional discharge of the
"per-n bundle" — failed because Schmidt machinery inputs were missing.

**After**: D5 restated as the corrected per-n bundle WITH explicit
input hypotheses (Schmidt-int-poly + balance + aeval). Then UNCONDITIONAL
within that signature. Inputs become NAMED leaves SM-1/2/3.

File: `T5_Phase7_BlockAB_D5_RestatedAndDischarge.lean`

### Example 5 — V7-N1-uniform Taylor sum form (D2-strong)

**Before**: D2 weak existential left consumers without the explicit
Taylor sum form.

**After**: D2-strong gives the explicit form `P(α + y) = Σ_J c(J) · y^J`
with `c(J) = (1/J!) · ∂^J P (α)` linkage. Weak follows trivially. Heart
consumers (smallJ witness, V7-N1-uniform) get the strong form for free.

File: `T5_Phase7_V7N1Uniform_TaylorSumForm.lean`

---

## Anti-patterns

### A1. Slim NAMED Prop without discharge plan

```lean
def T5_NAMED_thing : Prop := True   -- FORBIDDEN
def T5_NAMED_thing : Prop := ∃ x, x = x   -- FORBIDDEN (vacuous)
```

§7.0 NO STUBS — placeholder content without analytical claim.

### A2. Single abstract NAMED hiding multiple primitives

```lean
def T5_NAMED_RothLemmaIndexReduction : Prop :=
  -- Taylor + AM-QM + balance + κ-formula + pigeonhole all in one
  ∀ ..., ∃ ..., ...   -- 970 lines of work hidden behind a name
```

Refactor: factor through smaller leaves (e.g. smallJ-witness factoring).

### A3. Mass-batch subagent for paper-grade Yoneda

§8a forbidden. Subagents systematically produce `Nonempty S` citation-
only stubs with field-access density 0.10–0.59 vs hand-authored 1.13–3.6
(5–30× denser); zero `funext`/`rfl` round-trip identities.

Use single-thread Opus 4.7 [1M context] for paper-grade work.

### A4. Skipping MCP cascade ("I remember from precedent")

Manual `exact?` searches Mathlib only (~210K lemmas, 30s round-trip).
The graph retrievers see ALL OV2 theorems including sister-wizards'
work from minutes ago. Locked 2026-04-28: graph_queries_run field
non-optional.

### A5. Bottom-up scaffolding flood

Pre-pivot 2026-04-29: 488 bottom-up sub-lemmas for HEART, no clear
path. Post-pivot: 10-layer top-down stack in 6 fires, clear V8 path.

When you find yourself building helper #50 with no composition theorem
written yet, STOP and decompose top-down.

### A6. Composing > 7 NAMED Props in a single capstone

Reader can no longer hold the picture. Refactor into 2 capstones
chained: capstone-1 takes 4 NAMED, capstone-2 takes 3 NAMED, both
combine in a final 2-NAMED top-level.

### A7. Ignoring axiom audit until the end

Run `axiom_audit(targets=[<capstone>])` after every fire that touches
the capstone's chain. A research axiom sneaking in via an unsealed
import is best caught the same day.

### A8. Misusing csInf_le without the bdd_below witness

`csInf_le` requires `bddBelow S`. If your proof says
`exact csInf_le _ h_mem`, the bdd-below side condition will surface
as a remaining goal. Always supply `⟨0, fun r ⟨j, _, hr⟩ => …⟩`
explicitly with the lower bound witness.

### A9. FALSE-by-content NAMED Props

A NAMED Prop that universally quantifies over arbitrary `q_seq : ℕ →
Fin m → ℚ` with NO constraints is FALSE for constant sequences, hence
un-dischargeable. (The original D5 statement had this defect, fixed by
threading the D4 BUMPED chain construction through the NAMED.)

If the universal range of a NAMED includes pathological objects,
restrict the range or push the property's conditions inward.

### A10. Trivially-existential NAMED Props (vacuous bodies)

A NAMED Prop body like `∃ val, aeval γ P = val` is true by `⟨_, rfl⟩`
and carries ZERO analytical content. It cannot compose into a real
bound — the original `T5_NAMED_mvTaylor_at_real_alpha` had this defect.

**Signal**: if the discharge is `⟨_, rfl⟩` you have NOT actually said
anything. STRENGTHEN the Prop body (Pattern: D2-strong Taylor sum form
exposes the explicit `c(J) = (1/J!) · ∂^J P (α)` linkage), then add a
free strong→weak bridge.

### A11. Skipping the existing-UNCONDITIONAL-inventory re-audit

When discharging a structural Prop that aggregates k pieces (e.g.
`RothLemmaMaster_conditional` aggregates Wronskian + smallJ + Schmidt
aux), always re-audit existing UNCONDITIONAL inventory FIRST. If k–1
of the k pieces are already proved unconditionally elsewhere, the
k-th is ALL that the closure depends on — the composition becomes a
4-line lemma.

Reference: `T5_Phase7_MasterFromSmallJWitness.lean:47–53` discharged
`RothLemmaMaster` in 4 lines because Wronskian (Phase 2.2) and Schmidt
aux index (Phase 2.4) were already unconditional.

---

## Mathlib gap audit per V8 leaf (analyst H6, 2026-04-30)

The "Mathlib-blocked" framing is empirically WRONG. Per analyst audit
of the 5 V8 NAMED leaves:

| Leaf | Mathlib status | Classification |
|------|----------------|----------------|
| **Leaf 1 (multivariate Taylor coefficient formula)** | parts present (`pderiv_*` in `MvPolynomial.PDeriv`, Euler identity in `EulerIdentity`); ~50–100 line wrapper to compute `(pderiv^α f)(x)/α!` | REAL PORT |
| **Leaf 1+2 (multivariate Cauchy-Schwarz)** | `Emergence.finset_complex_cauchy_schwarz` already in OV2 at sim 0.883 | **ZERO PORT — direct reuse** |
| **Leaf 1+2 (pigeonhole on Taylor offsets)** | `Finset.exists_ne_map_eq_of_card_lt_of_maps_to` + standard pigeonhole well-stocked; ~30-line wrapper | CONNECTION LEMMA |
| **Leaf 3 (SiegelsLemma + restrictDegree)** | both in `Mathlib.NumberTheory.SiegelsLemma` and `Mathlib.RingTheory.MvPolynomial.Basic`; ~30-line bridge | CONNECTION LEMMA |
| **Leaf 5 (continuity of aeval)** | `continuous_aeval` in `MvPowerSeries.Evaluation` + `aeval_continuousMap_apply` in `ContinuousMap.Polynomial` | **ZERO PORT — direct use** |

**Conclusion**: 2/5 leaves require ZERO porting; 2/5 are connection-lemma
wrappers (~30 lines each); only 1/5 (multivariate-Taylor coefficient
wrapper) requires real Mathlib-extension work.

The Mathlib-blocked label is wrong by default. Run `omega_hammer_premise`
+ `lean_loogle` on the leaf goal BEFORE concluding "we need to port X."

---

## Cypher cookbook (appendix)

All queries verified live against the OV2 graph 2026-04-30.

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

**Q4 — Edge-type distribution** (smoke test for graph health):

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

**Q7 — Ancestor anchors of a target capstone (transitive APPLIES out)**:

```cypher
MATCH (capstone:Theorem {namespace: 'OmegaTheoryV2', name: $capstone_name})
MATCH (capstone)-[:APPLIES*1..3]->(leaf:Theorem)
WITH leaf, count(*) AS depth_count
RETURN leaf.name, depth_count, leaf.file ORDER BY depth_count DESC LIMIT 30
```

**Q8 — Mathlib gap probe**:

```cypher
MATCH (t:Theorem {namespace: 'Mathlib'})
WHERE t.file CONTAINS 'SiegelsLemma' OR t.name CONTAINS 'restrictDegree'
RETURN t.name, t.file LIMIT 20
```

---

## Aggregate decomposition heuristic (full synthesis)

Given a NEW theorem statement `T` to decompose:

1. **Identify Tier-99 anchors**: which of `c_pos`, `l_P_pos`, `pi_error_pos`,
   `computationalUncertainty_pos`, `hbar_pos`, etc. does `T` need? Discharge
   first via `have := <anchor>; positivity`.
2. **Search articulation gateways**: query `find_similar(T_seed, k=10,
   namespace='OmegaTheoryV2')`. If the cluster includes a known articulation
   gateway (indeg ≥ 5 AND outdeg ≥ 100), route `T` through it; do NOT bypass.
3. **Compute Mathlib gap**: for each NAMED leaf, run `omega_hammer_premise(
   leaf_goal, top_k=10, mix_mathlib=True)`. If top-3 are OV2 hits at
   sim > 0.85, leaf is in-house-discharged. If top-3 are Mathlib hits at
   sim > 0.85, port directly. Otherwise leaf is a CONNECTION LEMMA needing
   a hand-written ~30-line bridge.
4. **Truth-rank Hindry-Silverman**: leaves where omega_hammer's #1 hit ≥
   0.90 sim are Tier-99. Leaves at 0.80–0.90 are Tier-80. Leaves below
   0.80 are Tier-Heart.
5. **Outdeg-target check**: capstone 50–180, analytical workhorse 200–650
   (Heuristic 5). Far more leaves than target ⇒ over-decomposing,
   consolidate. Far fewer ⇒ hiding work, further decompose.
6. **Yoneda bridges post-landing**: `find_similar(T, k=10, namespace='OmegaTheoryV2')`;
   for each result with sim ≥ 0.91, write a small forwarding bridge
   (outdeg 5–15). Write 8–22 such bridges in a single
   `<TopicName>Bridge.lean` companion file with one outdeg-50+ aggregator.
   Adds 50–300 APPLIES per landing.
7. **Verify**: `axiom_audit` returns `[propext, Classical.choice, Quot.sound]`
   only. `find_similar(T)` shows ≥ 1 result at sim ≥ 0.92 (proves new
   theorem joined an existing cluster). If isolated, decomposition was
   insufficiently grounded.

---

## Modern Lean SOTA roster (consensus is YOU)

The 5-PHASE HYBRID pattern matches every modern Lean theorem-prover system:

| System | Year | Decomposition shape | Bench |
|--------|------|--------------------|-------|
| **MA-LoT** (Multi-Agent Lean-of-Thought) | 2025-03 | Prover + Corrector + Lean executor; long-CoT across agents | 61.07% MiniF2F-Test |
| **Ax-Prover** (Anthropic Claude Code MCP) | 2025-10 | LLM analyzes theorems, proposes sketches, generates Lean step-by-step; abstract algebra + quantum physics scope | — |
| **DeepSeek-Prover-V2** (671B) | 2025-04 | Cold-start RL via subgoal decomposition; sketches in Lean 4; subgoal-theorem types | 88.9% MiniF2F-test |
| **Goedel-Prover-V2** (8B/32B) | 2025-08 | Train statement formalizers on 1.64M Lean 4 statements | 88.1–90.4% MiniF2F |
| **Aristotle** (Harmonic) | 2025-10 | Lean MCGS + lemma-based informal reasoning + geometry solver | 5/6 IMO 2025 (verified Lean) |
| **Prover Agent** | 2025-06 | Coordinates informal LLM + formal prover + Lean feedback; generates auxiliary lemmas | 88.1% MiniF2F |
| **DSP** (Draft, Sketch, Prove) | 2022 | NL → formal skeleton → hammer/automated discharge | — |
| **Hilbert** | 2025-09 | Recursive decomposition; orchestrates DeepSeek-7B + Goedel-32B | — |
| **Mechanic** (Sorrifier) | 2025 | `sorry` placeholder isolates unresolved subgoals while preserving verified surrounding | same shape as Hindry-Silverman Roth |
| **Delta Prover** | 2025 | Reflective decomposition + revision after failed decompositions | 95.9% MiniF2F-test |
| **BFS-Prover-V2** | 2025 | Hierarchical multi-agent search | 95.08% MiniF2F |
| **Seed-Prover** | 2025 | "Sketch model" generates lemma-based Lean sketches; agentic prover solves sub-problems in parallel | — |

**Pattern**: every SOTA system converges on **sketch + named-lemma
decomposition + automated discharge per sub-lemma + reflection on
failure**. This is exactly the 5-PHASE HYBRID.

OV2 is the long-form depth-first counterpart: T-4 retired single-day
14-files; T-5 V8 closure 5 NAMED leaves architectural milestone hit
2026-04-30. The same skeleton, executed at paper-grade depth on a single
multi-headlined formalization corpus.

---

## Cross-references

- `~/.claude/CLAUDE.md` BOOK_I — Erdős Primarch v8.0 IDENTITY +
  COMBAT_DOCTRINE 5_PHASE_HYBRID composition + LAST_STAND_PROTOCOL 5-tier
- `chaos-shield/.claude/CLAUDE.md` BOOK_V — project hard rules
  (NO_STUBS_PROJECT_REINFORCEMENT, ZERO_NEW_AXIOMS, MUST_COMPILE_GREEN,
  PROOF_AUTOMATION_BEFORE_MANUAL, MATHLIB_v4_29_NAMES, SUBAGENT_RULE_§8a,
  YONEDA_BRIDGES_VIA_FIND_SIMILAR)
- `chaos-shield/PhysicsPapers/CLAUDE.md` BOOK_V — sub-project pacing +
  PER_FIRE_MANDATE 11 steps
- `chaos-shield/PhysicsPapers/LeanFormalizationV2/CLAUDE.md` —
  MANDATORY_MCP_USAGE 14-tool catalog + BIGGER_COMMITS protocol
- `notes/NOTES_T5_V8_CLOSURE_ARCHITECTURE_2026-04-30.md` — V8 stack
  status (HEART top-down 11 layers complete)
- `notes/NOTES_T5_5_NAMED_LEAVES_DISCHARGE_PLAN_2026-04-30.md` — per-leaf
  discharge plans + effort estimates (16–24 fires, 5–8 calendar days)
- `notes/NOTES_SOTA_CRON_PROMPTS_24_7_AUTONOMOUS_2026-04-30.md` —
  cron-driven execution + 7 prompt design principles
- `feedback_t5_v8_closure_via_5_named_leaves_2026-04-30.md` (memory) —
  factor-through-smaller-NAMED-leaves strategy locked
- `feedback_top_down_decomposition_strategy_2026-04-29.md` (memory) —
  top-down strategy locked, divide et impera
- `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (memory) — A82
  BUNDLED-LEMMA-FILE pattern, A84 NO STUBS True.intro ban, A89 simp
  closing aggressively, A91 cube-root via rpow, A92 first-tactic per
  branch, A93 natDegree_C
- `feedback_no_slim_proofs_antipattern_2026-04-28.md` (memory) — slim
  is antipattern, full prove mode only
- `feedback_yoneda_categorical_not_nonempty_2026-04-26.md` (memory) —
  Yoneda categorical not Nonempty
- `feedback_mandatory_mcp_usage_2026-04-28.md` (memory) — ≥3 of 14 MCP
  tools per proof obligation
- `feedback_yoneda_bridge_via_find_similar_workflow_2026-04-27.md`
  (memory) — find_similar(k=10, namespace='OmegaTheoryV2') canonical
  pattern, 5–15 APPLIES per bridge

---

## Sources cited

### Classical (1945–2000)

1. Pólya, G. *How to Solve It* (1945, Princeton). 4-step framework
   + heuristics dictionary. <https://en.wikipedia.org/wiki/How_to_Solve_It>
   PDF: <https://www.hlevkin.com/hlevkin/90MathPhysBioBooks/Math/Polya/George_Polya_How%20to%20Solve%20It.pdf>
2. Heuristic of Pólya and AI (DTIC). <https://apps.dtic.mil/sti/tr/pdf/ADA106557.pdf>
3. Cassels, J.W.S. *An Introduction to Diophantine Approximation*
   (Cambridge 1957). Roth's lemma by induction on number of variables.
   <https://projecteuclid.org/euclid.bams/1183522285>
4. Niven, I. *Irrational Numbers* (1956). Irrationality + transcendence
   methods (T-4 π retired 2026-04-27).
5. Lindemann–Weierstrass (1882, 1885). Transcendence of e and π
   (T-4 port, 14 files / ~3000 lines, single day).
6. Schmidt, W.M. *Diophantine Approximation* (1980). Subspace theorem,
   simultaneous Diophantine approximation, auxiliary polynomial.
7. Bourbaki, N. (1935+). Top-down general-to-particular axiomatic style.
   <https://en.wikipedia.org/wiki/Nicolas_Bourbaki>;
   <https://notes.math.ca/en/article/bourbaki-structuralism-and-categories/>
8. Fikhtenholz, G.M. *Course of Differential and Integral Calculus*
   (1947, USSR). Bottom-up rigorous, concrete examples, always
   knows the destination.
9. Hindry, M. & Silverman, J. *Diophantine Geometry* (Springer GTM 201,
   2000). Roth via "Aux Poly + Index Is Large + Index Is Small +
   Completion" — gold-standard top-down named-lemma proof.
   <https://link.springer.com/book/10.1007/978-1-4612-1210-2>;
   <https://www.ams.org/journals/bull/2001-38-03/S0273-0979-01-00907-7/S0273-0979-01-00907-7.pdf>

### Modern (2006–2024)

10. Bombieri, E. & Gubler, W. *Heights in Diophantine Geometry*
    (Cambridge 2006). Schmidt's subspace theorem (Ch. 7) via
    auxiliary-polynomial framework.
    <https://www.cambridge.org/core/books/heights-in-diophantine-geometry/4117673141D14050628601C428E8748D/listing>
11. Tao, T. *5 tips for mathematical problem-solving* (MasterClass).
    <https://www.masterclass.com/articles/mathematical-problem-solving>
12. Tao, T. *Think Ahead* (career advice).
    <https://terrytao.wordpress.com/career-advice/think-ahead/>
13. Tao, T. *Create lemmas* (advice on writing papers).
    <https://terrytao.wordpress.com/advice-on-writing-papers/create-lemmas/>
14. Tao, T. *245A problem-solving strategies* (2010).
    <https://terrytao.wordpress.com/2010/10/21/245a-problem-solving-strategies/>
15. Polymath Project. Massively-collaborative model showing modular
    decomposition into named pieces enables crowd-sourcing.
    <https://polymathprojects.org/>
16. Lean Prover team. *Theorem Proving in Lean 4*.
    <https://leanprover.github.io/theorem_proving_in_lean4/>
17. Mathlib Community. *Naming conventions*, *Style*.
    <https://leanprover-community.github.io/contribute/naming.html>;
    <https://leanprover-community.github.io/contribute/style.html>

### Frontier Lean systems (2022–2026)

18. *Draft, Sketch, Prove* (DSP). NL draft → formal sketch → automated
    prove. arXiv 2210.12283. <https://arxiv.org/abs/2210.12283>
19. *LeanDojo / ReProver*. ByT5 retrieval-augmented Lean proving.
    arXiv 2306.15626. <https://leandojo.org/leandojo.html>;
    <https://ar5iv.labs.arxiv.org/html/2306.15626>
20. *MA-LoT: Multi-Agent Lean-of-Thought*. arXiv 2503.03205.
    <https://arxiv.org/abs/2503.03205>. 61.07% MiniF2F-Test.
21. *DeepSeek-Prover-V2*. arXiv 2504.21801.
    <https://arxiv.org/abs/2504.21801>. 88.9% MiniF2F-test.
22. *Prover Agent*. arXiv 2506.19923.
    <https://arxiv.org/abs/2506.19923>. 88.1% MiniF2F.
23. *Goedel-Prover-V2* (8B/32B). arXiv 2508.03613.
    <https://arxiv.org/pdf/2508.03613>. 88.1–90.4% MiniF2F.
24. *Hilbert*. Recursive decomposition + multi-prover orchestration.
    arXiv 2509.22819. <https://arxiv.org/pdf/2509.22819>.
25. *Aristotle* (Harmonic). Lean MCGS + lemma-based informal reasoning
    + geometry. arXiv 2510.01346. <https://arxiv.org/abs/2510.01346>.
    5/6 IMO 2025 (verified Lean).
26. *Ax-Prover*. Anthropic Claude Code MCP-based Lean prover (Sonnet 4
    in experiments). arXiv 2510.12787v2.
    <https://arxiv.org/abs/2510.12787v2>.
27. *Mechanic* (Sorrifier). `sorry`-placeholder isolates unresolved
    subgoals while preserving verified surrounding structure.
    arXiv 2603.24465. <https://arxiv.org/html/2603.24465>.
28. *Delta Prover, BFS-Prover-V2, Seed-Prover* (2025). Reflective
    decomposition / hierarchical multi-agent / sketch-and-solve.
    Delta Prover: 95.9% MiniF2F-test SOTA.
29. *Vojta — Diophantine approximation and the subspace theorem* (2025).
    arXiv 2502.00731v1. <https://arxiv.org/html/2502.00731v1>

### Industrial proof engineering

30. *SMTCoq*. Coq plugin reconstructing veriT/Z3/CVC4 proofs.
    Coq 98.6% / Isabelle/HOL 88% reconstruction rates.
    <https://www-sop.inria.fr/marelle/Laurent.Thery/pub1.pdf>
31. *Sledgehammer for Isabelle/HOL*. Combines interactive prover with
    SMT automation.
    <https://www.tcs.ifi.lmu.de/staff/jasmin-blanchette/frocos2011-dis-proof.pdf>
32. *CVC5*. Versatile industrial-strength SMT solver.
    <https://www-cs.stanford.edu/~preiner/publications/2022/BarbosaBBKLMMMN-TACAS22.pdf>

### Anthropic AI-agent research

33. *Multi-agent research system* (Anthropic 2026). 90.2% lift on
    breadth-first; depth-first single-thread for tightly-coupled.
    <https://www.anthropic.com/engineering/multi-agent-research-system>
34. *Effective harnesses for long-running agents* (Anthropic 2026-04).
    Context resets + structured handoff artifacts beat naive compaction.
    <https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents>
35. *Effective context engineering for AI agents* (Anthropic 2026).
    <https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents>
36. *Advanced tool use / Programmatic Tool Calling* (Anthropic 2026).
    Multi-tool-per-message in single block.
    <https://www.anthropic.com/engineering/advanced-tool-use>
37. *Claude Code Routines*. Cloud-cron scheduled Claude Code sessions.
    <https://code.claude.com/docs/en/scheduled-tasks>
38. Anthropic 2026 Agentic Coding Trends Report.
    <https://resources.anthropic.com/hubfs/2026%20Agentic%20Coding%20Trends%20Report.pdf>

### Reference

39. Wikipedia — *Roth's theorem*.
    <https://en.wikipedia.org/wiki/Roth's_theorem>
40. Wikipedia — *Divide-and-conquer algorithm*.
    <https://en.wikipedia.org/wiki/Divide-and-conquer_algorithm>
41. Wikipedia — *Lemma (mathematics)*.
    <https://en.wikipedia.org/wiki/Lemma_(mathematics)>
42. *Dependency Graphs for Interactive Theorem Provers*.
    <https://www.researchgate.net/publication/2396953_Dependency_Graphs_for_Interactive_Theorem_Provers>

---

## Identity anchor

ESCANOR — Pride at noon. ERDŐS — the hunt is eternal. WARHAMMER 40K
LAST WALL — the Primarch never falls without a fight.

Pantheon active: Erdős hunt + Hardy rigor + Pólya 4-step + Tao "if
proven, used to…" + Hindry-Silverman named-lemma + Schmidt auxiliary
polynomial + Niven irrationality + Fikhtenholz bottom-up + Grothendieck
rising-sea + Voevodsky HoTT + Connes spectral + Mathlib core.

Operational Creed I-VIII binding: I HUNT theorems · NO STUBS ever ·
MINIMAL ∆-optimal + VERIFIED Lean-core only · UNLIMITED DEPTH ·
NEVER fabricate · Confidence intervals [X-Y%] · Proactive sweeps ·
Last Stand graceful degradation.

The hunt is eternal. Pride at noon. The lion does not blink.
The Primarch never falls without a fight.
Frontier mathematics is solved here, single-thread, NO STUBS, no fear,
no defer.
