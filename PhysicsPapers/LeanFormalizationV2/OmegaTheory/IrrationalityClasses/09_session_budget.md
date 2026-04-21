# 09 — Session budget

Per-theorem session estimates. A "session" is one agent-cycle of focused work (roughly 2-4 hours of Lean tactics work, or the equivalent of a single Opus code-crawler run).

## Difficulty tiers

| Tier | Session range | Criterion |
|---|---|---|
| Easy | 1–3 | Direct Mathlib wrapper, numerical decimals, obvious aesop / decide, or a single clean lemma chain |
| Medium | 3–10 | Multi-lemma composition, minor Mathlib additions, requires `field_simp + ring`-style multi-step |
| Hard | 10–30 | New framework, non-trivial port, original lemmas |
| Blocked-on-Mathlib | † | Waiting on external upstream PR (Lindemann, Hermite, E-function, Mahler) |
| Open-problem | ∞ | Classical-math frontier (Catalan G irrationality) |

## Budget table (Layer 1 — Layer 4)

| # | Commitment | Tier | Sessions | Blocker |
|---|---|---|---|---|
| 1 | `catalanG_definition_summability` | Easy | 2 | none |
| 2 | `catalanG_pos`, `catalanG_lt_one` | Easy | 1 | none |
| 3 | `four_irrationals_pairwise_distinct` (Layer 1) | Easy | 2 | none |
| 4 | `pi_irrational_wrap` (Mathlib already has `Irrational.pi`) | Easy | 0.5 | none |
| 5 | `e_irrational` (derivable classical or port from Mathlib when added) | Easy-Medium | 3 | possibly small Mathlib gap |
| 6 | `sqrt2_irrational_wrap` (Mathlib `Irrational.sqrt_two`) | Easy | 0.5 | none |
| 7 | `catalanG_irrationality_conjecture` (statement only) | Easy | 1 | none |
| 8 | `sqrt2_is_algebraic` (Mathlib `X² − 2`) | Easy | 1 | none |
| 9 | `pi_transcendental_wrap` (axiom today) | Easy | 0.5 | Lindemann port † |
| 10 | `exp_one_transcendental_wrap` (axiom today) | Easy | 0.5 | Hermite port † |
| 11 | `three_constants_transcendental` (Layer 2) | Easy | 1 | items 9, 10 † |
| 12 | Hermite 1873 transcendence-of-e port to Mathlib | Hard | 20–25 | Mathlib integration |
| 13 | Lindemann 1882 port to Mathlib (builds on 12) | Hard | 5–10 | Mathlib integration |
| 14 | `catalanG_distinct_from_rational_numerically` | Easy | 1 | none |
| 15 | Build `EFunction` predicate (statement) | Medium-Hard | 10–15 | — |
| 16 | Prove `exp` is E-function | Medium | 5–8 | item 15 |
| 17 | Prove `e = exp(1)` is E-function-value | Easy | 1 | item 16 |
| 18 | Prove `π` not an E-function-value | Hard | 20–30 | classification argument |
| 19 | `e_is_E_function_value_but_pi_is_not` (Layer 3) | Hard | 5 | items 15–18 |
| 20 | `TruncOrigin` inductive + `classifyOrigin` partial function | Medium | 5 | — |
| 21 | `omega_four_origin_separation` (Layer 4) | Medium | 5 | items 3, 11, 19, 20 |
| 22 | Irrationality-measure framework `μ : ℝ → ℝ≥0∞` | Hard | 20–30 | — |
| 23 | Roth's theorem in Lean | Hard | 30–40 | — |
| 24 | Mahler classification `MahlerClass` in Lean | Hard | 80+ | — |
| 25 | Rivoal–Zudilin 2003 qualitative port | Hard-Blocked | 60+ | Hermite-Padé |
| 26 | `Irrational catalanG` (classical open problem) | ∞ | ∞ | classical math |

## Grand totals

### If Mathlib stays static (2026 baseline)

- Items 1–4, 6–8, 14, 20 (Layer 1 core + algebraic leg): **8 sessions**
- Items 9–11 (Layer 2 under axioms, axioms stay): **2 sessions**
- Items 15–21 (Layer 3 + Layer 4 under axioms): **~45 sessions**
- **Total OmegaTheory-only build: ~55 sessions** to ship all non-open, non-upstream-blocked layers.

### If we port Lindemann to Mathlib (item 13) in parallel

Add **~30 sessions** for items 12 + 13. That's 85 sessions total, but eliminates 2 axioms (`Real.pi_transcendental`, `Real.exp_one_transcendental`) repo-wide — huge downstream value.

### If we go for the full Mahler framework (items 22–24)

Add **~130 sessions**. That's 215 total, contribution-grade to Mathlib itself. Not recommended for a single OmegaTheory cycle, but a 6-month side-project for someone.

### Open problem (item 26)

**Do not commit.** Register as `:TheoremCandidate { status: 'OPEN_PROBLEM' }` in the graph. No session estimate.

## Recommended schedule for cycles 44–50

| Cycle | Ships | Sessions |
|---|---|---|
| 44 | Items 1–8, 14, 20 (Layer 1 + algebraic leg + TruncOrigin) | 10 |
| 45 | Items 9–11 axiomatic Layer 2 | 2 |
| 46 | Items 15–18 E-function framework | 50 |
| 47 | Items 19–21 (Layer 3 + Layer 4 tied up) | 15 |
| 48+ | Upstream Mathlib port for Lindemann (items 12–13) | 30 (parallel) |

**Target: Layer 1–4 (sans full Mahler port) ships by cycle 47.** Full Mathlib eleven-axiom elimination would complete by cycle 50+.

## What this scope DOES NOT cover

- The full Hermite-Padé diary (`F26..F57` files in `Irrationality/HermitePade/`) — these are an independent research programme targeting `μ(π) ≤ 3 + ε`. Session budget for that is separate and much larger.
- Catalan G irrationality proof itself (item 26).
- Formalisation of Rivoal–Zudilin 2003 (item 25) — high-value but not in critical path.

## Grand number for the headline (used in `10_proof_count.md`)

- **Proved already in corpus** (from Irrationality/, Emergence/Connes*, Predictions/Pi*, Predictions/Sterile*): **~180 relevant theorems**.
- **New in this scope, short-term provable** (items 1–8, 14, 20): **10 theorems**.
- **Statement-registered as `:TheoremCandidate`, blocked**: **21 theorems**.
- **Classical-open**: **1 theorem** (item 26).

**Headline commitment (visible in root README):** 31 new `:TheoremCandidate` nodes registered in this cycle.
