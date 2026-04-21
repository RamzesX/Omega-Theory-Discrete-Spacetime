---
name: LeanFormalizationV2/STATUS.md
type: single-source-of-truth for build + corpus + graph numbers
updated: 2026-04-21
authority: measured live from `lake build` + Neo4j `math` container
---

# OmegaTheory V2 — Canonical Status

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md) · [LeanFormalizationV2](README.md)

> **This file is the single source of truth for corpus numbers.** Other docs
> should link here with a short quote summary (e.g., "3,835 jobs GREEN / 8,996
> own + 175,137 Mathlib / 8 physical axioms — see [STATUS.md](STATUS.md)").
>
> To update: re-measure each section from the cited source, update inline, bump
> the `updated:` frontmatter date. Typically one edit per cycle close.

## Build health — from `~/.elan/bin/lake build --log-level=error`

| Metric | Value | Source |
|--------|------:|--------|
| **Build jobs** | **3,835 GREEN** | `lake build` exit 0, post cycle 43 |
| **Sorry count** | **0** | `grep -r '\bsorry\b' OmegaTheory/ \| wc -l` |
| **Physical axioms** | **8** | c · ℏ · G_N · k_B + 4 positivity lemmas |
| **Research-conjecture axioms** | 16 | 15 HermitePadé conjectures + 1 `Real.pi_transcendental` (awaiting Mathlib Lindemann–Weierstrass port) |
| **Total declared axioms** | 24 | paper story reports 8; research-side tracks all 24 |

## Corpus scale — from live Neo4j `math` container (2026-04-21)

| Metric | Value | Source |
|--------|------:|--------|
| **OmegaTheoryV2 Theorems (own)** | **8,996** | `MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) RETURN count(t)` |
| **OmegaTheoryV2 Definitions** | **4,465** | `MATCH (d:Definition {namespace:'OmegaTheoryV2'}) RETURN count(d)` |
| **OmegaTheoryV2 Axioms** | **24** | `MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN count(a)` |
| **OmegaTheoryV2 LeanFile nodes** | 399 | `MATCH (f:LeanFile {namespace:'OmegaTheoryV2'}) RETURN count(f)` (includes dump artefacts; on-disk `.lean` is 294 committed / 428 in `~/lean-v2` workdir) |
| **Mathlib Theorems (integrated)** | **175,137** | `MATCH (t:Theorem {namespace:'Mathlib'}) RETURN count(t)` |
| **Grand total (Lean corpus compiling GREEN together)** | **184,133** | own + Mathlib |

## Graph state — OmegaTheoryV2 namespace (live 2026-04-21)

| Metric | Value |
|--------|------:|
| `:GraphFinding` nodes (total) | **88** |
| `:GraphFinding` paper_worthy | **44** |
| `:TheoremCandidate` nodes (total) | **166** |
| `:TheoremCandidate` closed | 52 |
| `:TheoremCandidate` open | 113 |
| `:TheoremCandidate` blocked | 1 |
| `:SubsystemNavigator` nodes | **677** |

## Cycle state

| Metric | Value |
|--------|-------|
| Cycles shipped | **2 – 43** (42 numbered cycles, Jan – Apr 2026) |
| Mekbuda's 60-theorem backlog (cycles 24–43) | **CLOSED** |
| Grand Capstone V2 | **LOCKED** — `omega_theory_v2_final_meta_capstone` (Polaris, cycle 43) at `OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean` |
| Next cycle frontier | cycles 44+ — absolute particle masses / CP-violation phase / Proton mass / Kempf bridges / Seeley-DeWitt / IrrationalityClasses (see [`notes/README.md`](notes/README.md) + `plans/`) |

## Axiom roster (definitive)

### Physical axioms (8) — paper story
Constants: `c`, `ℏ`, `G_N`, `k_B`. Each has a positivity lemma — 4 additional constants-as-axioms. Total **8**.

### Research-conjecture axioms (16)
- `Real.pi_transcendental` — awaiting Mathlib Lindemann–Weierstrass port (upstream task).
- 15 HermitePadé conjectures in `Irrationality/HermitePade/` — progressively eliminated by the `pi-formalizer` agent.

### Deleted
- **HPW axiom** — deleted 2026-04-17. All 7 regime witnesses (flat, linearised, Schwarzschild, FRW, Bianchi I, de Sitter, Kerr) now derive via the `HpwEliminableRegime` typeclass.

## Where this file is read

- [`CLAUDE.md`](CLAUDE.md) — quotes a 2-line summary + link
- [`README.md`](README.md) — quotes a 2-line summary + link
- [`PROJECT.md`](PROJECT.md) — quotes a 2-line summary + link
- [`../CLAUDE.md`](../CLAUDE.md) (PhysicsPapers/CLAUDE.md) — quotes 2-line summary + link
- The root `/README.md` and `/PAPERS.md` and `/Physics-Papers-Summary.md` carry
  the compact 🔷/🔶/🔹 corpus-scale banner (different format, same numbers).

## Amendments

- **2026-04-21** — File created as part of the navigation overhaul (plan: `elegant-sauteeing-simon.md`). Centralises numbers previously duplicated across 4+ files with drift risk. Live numbers re-measured from Neo4j `math` container.
- **2026-04-17** — HPW axiom deleted; all 7 regime witnesses re-derived.

---

*Return to: [LeanFormalizationV2](README.md) · [PhysicsPapers](../README.md) · [chaos-shield root](../../README.md)*
