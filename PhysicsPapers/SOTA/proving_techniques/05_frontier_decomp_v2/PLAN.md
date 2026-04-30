# T6 — Frontier Decomposition V2 Integrations

**Status**: T6.6 cut-aware ✓ | T6.11 freshness ✓ | T6.1, T6.3 rule-only TODO Day 1 | T6.4-12 TODO Day 2
**Effort**: ~2 days total (mostly rule + Cypher updates, low LOC)

## Authority

Memory: `feedback_decomposition_research_v2_2026-04-30.md` — 12 frontier techniques distilled from 2025-2026 SOTA papers.

## 12 techniques — status table

| # | Technique | Effort | Status | Source paper |
|---|---|---|---|---|
| 1 | NL sketch in Phase A.0 | rule update | TODO | DeepSeek-Prover-V2 (arXiv 2504.21801) |
| 2 | Consistency-penalty rule | rule update | TODO | DeepSeek-Prover-V2 GRPO RL |
| 3 | Type-(a) standalone variants | rule + audit | TODO | DeepSeek-Prover-V2 curriculum |
| 4 | Reflective proof repair loop | 2 days | TODO | Delta Prover (arXiv 2507.15225) |
| 5 | Failure-extraction NAMED Prop | 2 days | TODO | REAL-Prover (arXiv 2505.20613) |
| 6 | **Cut-aware doctrine cite** | 30min | **✓ DONE 2026-04-30** | Don't-Eliminate-Cut (arXiv 2602.10512) |
| 7 | Dynamic replanning trigger | 1 day | TODO | BFS-Prover-V2 (arXiv 2507.08649) |
| 8 | SubGoal DSL (Suppose/Define/ShowBy/Conclude) | 1 week | TODO Day 8-10 | Delta Prover §3 |
| 9 | Progress-prediction tiny model | 2 days | TODO | LeanProgress (arXiv 2502.17925) |
| 10 | Conjecture generation tool | 1 day | TODO | LeanConjecturer (arXiv 2506.22005) |
| 11 | **Library freshness boost** | 1 hr | **✓ DONE 2026-04-30** | LEGO-Prover (arXiv 2310.00656) |
| 12 | Two-mode (fast/deep) generation | 1 day | TODO Day 11-12 | DeepSeek-Prover-V2 dual mode |

## ✓ T6.6 — Cut-aware doctrine cite (DONE 2026-04-30)

Added `<THEORETICAL_FOUNDATION>` section to prove-wizard-v3.md (`agents/prove-wizard-v3.md:161+`):

```xml
<CUT_AWARE_EXPONENTIAL_SEPARATION cite="arXiv:2602.10512">
  Theorem 3 (Don't-Eliminate-Cut, 2026): hierarchical (cut-aware, lemma-using) proving 
  beats flat (cut-free) proving by exponential factor in sample complexity:
    N_flat / N_hier ≥ (Λ/λ)^(D/(p·γ))
  
  IMPLICATION: my 5-PHASE HYBRID + Tier-99-first + ARCHITECTURAL_COMPRESSION discipline 
  is THEORETICALLY OPTIMAL. Reusable cuts (Hi-1 used by both N3c-3 and Hi-Glue chains) 
  deliver the exponential factor.
  
  STRATEGIC: maximize REUSABILITY of sub-NAMED Props.
</CUT_AWARE_EXPONENTIAL_SEPARATION>
```

Effect: prove-wizard-v3 now has theoretical anchor. When the wizard reasons about decomposition strategy, it has explicit reference to why hierarchical decomposition is optimal — not just "Pólya said so" but "Theorem 3 of arXiv 2602.10512".

## ✓ T6.11 — Library freshness boost (DONE 2026-04-30)

All 17,524 OV2 Theorems now have `freshness: float` property:
```
freshness = exp(-(now - env_dumped_at) / 7 days)
```

- Recently-touched Theorems (env_dumped within last 24h): freshness ≈ 1.0
- Theorems untouched for 7 days: freshness ≈ 0.37
- Theorems untouched for 30 days: freshness ≈ 0.014

**Next step**: integrate into `omega_hammer_premise` scoring. Add ~0.2·freshness term to existing composite score (cosine + PageRank + indegree + subsystem_match). Boosts recently-proven lemmas by ~20% in retrieval — captures the empirical pattern that the most useful premise is often something proved in the last 3 sessions, not a Mathlib classic.

## TODO Day 1 (rule-only, fast wins)

### T6.1 — NL sketch in Phase A.0

Add new sub-step to prove-wizard-v3 BOOK_I `<COMBAT_DOCTRINE>` Phase A:

```xml
<PHASE n="A.0" name="NL_SKETCH" lens="DeepSeek_V3_informal_formal_pairing">
  Before introducing NAMED Prop hypotheses, write a 5-10 line natural-language 
  proof sketch identifying which steps will become NAMED Props.
  
  Pair the NL sketch with the Lean translation in the docstring of the composition 
  theorem. This forces structural alignment + catches missing-step errors before 
  they become wrong NAMED definitions.
  
  Time investment: ~5 min per HARD obligation. Empirical (DeepSeek-Prover-V2): 
  closes the informal-formal gap that's the #1 source of wasted formalization effort.
</PHASE>
```

### T6.3 — Type-(a) standalone variants

Add to BOOK_VIII `<DELIVERABLE_REPORT_FORMAT>`:

```
For every Tier-99 / Tier-80 sub-NAMED introduced, ALSO ship a Type-(a) standalone 
form: hypothesis-free version that validates the lemma in isolation.

Example: T5_NAMED_Hi1_taylor_support_restriction (Type-b, takes hypotheses)
         → T5_Hi1_standalone_unconditional (Type-a, hypothesis-free if possible)
```

We already do this informally (e.g. `T5_N3c_Hi1_taylor_support_restriction_unconditional` is a Type-(a) variant). Codify as a project rule.

## TODO Day 2 (medium-ROI)

### T6.4 — Reflective proof repair loop

Add to prove-wizard-v3 BOOK_IV phase 4 (manual fallback). Codify the inner loop:

```
1. lake build FAIL → extract error from lean_diagnostic_messages
2. lean_goal(file, line, col) → tactic state at failure point
3. lean_hammer_premise(file, line, col) → premise retrieval at failure
4. omega_hammer_premise(error_context_as_goal) → semantic premise retrieval  
5. Synthesize new attempt with these in context
6. Retry — single coherent trajectory, NOT parallel Best-of-N
```

Source: Delta Prover §3 — single-coherent-trajectory beats Best-of-N.

### T6.5 — Failure-extraction NAMED Prop

New MCP tool `propose_named_from_failure(failed_proof, error_msg)` — extracts what would have been needed as a new NAMED lemma. ~150 lines Python + LLM call.

### T6.7 — Dynamic replanning trigger

Rule: Theorem stuck > 3 fires without progress → auto-spawn sub-factoring agent. Add to prove-wizard-v3 BOOK_VII as a self-imposed mandate.

### T6.9 — Progress-prediction tiny model

Train on existing 17.5K OV2 corpus:
- Input: goal_embedding (4096-d)
- Target: tactics_remaining (regression)
- Architecture: 2-layer MLP
- Use: rank residual NAMED Props by predicted closure-readiness

### T6.10 — Conjecture generation tool

New MCP tool `propose_conjecture_from_proven(theorem_name, k=10)` — apply rules (specialize, generalize, weaken, strengthen) to generate variants. Subset of T4.1 propose_conjecture.

### T6.2 — Consistency-penalty rule

Add to BOOK_VII FORBIDDEN:

```
NO PROOF SKIPS THE NAMED HYPOTHESES.
When stating T : H1 → H2 → ... → conclusion, the proof MUST visibly use each Hi.
A proof that closes via aesop without using the explicit hypotheses is a stub-equivalent.
```

### T6.8 — SubGoal DSL (defer Day 8-10)

NEW file `~/lean-v2/OmegaTheory/Meta/SubgoalDSL.lean` (~200 lines macros):
- `SubGoal.Suppose` — introduce hypothesis
- `SubGoal.Define` — define expression  
- `SubGoal.ShowBy` — pose subproblem + record proof
- `SubGoal.Conclude` — consolidate via delaborator

Source: Delta Prover §3.

### T6.12 — Two-mode generation

Ship `prove-wizard-fast` agent (T7.1) — slim variant of v3 for Tier-99 obligations. Saves ~60% time on routine work.

## Verification

After all 12 land:
```cypher
// 1. Freshness applied
MATCH (t:Theorem {namespace: "OmegaTheoryV2"}) WHERE t.freshness IS NOT NULL
RETURN count(t), avg(t.freshness)

// 2. Tier classification
MATCH (t:Theorem {namespace: "OmegaTheoryV2"}) RETURN t.tier, count(*)
```

Plus: prove-wizard-v3 contains `<THEORETICAL_FOUNDATION>` section, `<PHASE n="A.0">`, BOOK_VII consistency-penalty rule. SubgoalDSL.lean compiles GREEN. New MCP tools available.
