---
name: IrrationalityClasses
date: 2026-04-21
status: Phase 0 in progress (design memos; no .lean files yet)
author: Norbert Marchewka
contributors: Rasalas (μ Leonis, grothendieck-sage, this session)
scope: Rigorous separation of the four OmegaTheory irrationals {π, e, √2, Catalan G} into four distinct irrationality classes — Lean planning layer before we ship .lean proofs.
mission: The 4-channel / 4-generation / 3-SM-plus-sterile partition demands that the four constants inhabit four distinct classes. This tree proves (or registers as blocked) that claim, inside classical hierarchies (Liouville, Roth, Mahler A/S/T/U, Shidlovsky E-function, Baker LFL, Nesterenko, Zudilin).
---

# IrrationalityClasses

↑ [LeanFormalizationV2](../../README.md) · [OmegaTheory](../) · [PhysicsPapers](../../../README.md)

Phase 0 design memos for the **4-class separation theorem**. The thesis of `Emergence/ConnesCalibrationAndFourChannels.lean`, `Emergence/ConnesDFYukawaMass.lean`, `Predictions/SterileNeutrinoFromFourthIrrational.lean`, and the cycle-43 Grand Capstone V2 presupposes that the four irrationals

| Symbol | Series | Truncation rate δ(N) | Role |
|---|---|---|---|
| π | Leibniz `4·Σ(−1)ⁿ/(2n+1)` | `O(1/N)` | HEAVIEST channel (largest residual) |
| e | Taylor `Σ 1/n!` | `O(1/N!)` | middle-heavy |
| Catalan G | `Σ(−1)ⁿ/(2n+1)²` | `O(1/(2N+1)²)` | middle-light (quadratic) |
| √2 | Newton iteration | `O(2^(−2^N))` super-exp | LIGHTEST |

sit in **four distinct irrationality classes**, so that the 3 SM generations + 1 sterile/DM slot get four *qualitatively* different substrate signatures — not merely four different numerical δ(N).

Each memo is standalone, cited against arXiv / Mathlib / live OmegaTheory source, and lists the Lean machinery we will need.

> **Honest status, up front.** The separation theorem in its strongest form is **BLOCKED**: the irrationality of Catalan G is itself an OPEN PROBLEM in number theory (cf. Zudilin 2019, "Arithmetic of Catalan's constant and its relatives", Abh. Math. Sem. Univ. Hamburg 89:45–53). We therefore register the separation as a **conditional theorem** with four layers of increasing strength and four matching `:TheoremCandidate` statuses. Layers 1–3 are provable today; layer 4 is research-frontier.

## Agents
- **Rasalas** (μ Leonis) — Phase 0 author for files 00–13, session 2026-04-21

## Files

| # | File | One-line purpose |
|---|---|---|
| 00 | [`README.md`](README.md) | this index |
| 01 | [`00_motivation.md`](00_motivation.md) | Why 4 distinct classes matter — 4-channel partition → 3 active generations + 1 sterile/DM; goal statement "Omega algebra completely describes physics" |
| 02 | [`01_classical_hierarchies.md`](01_classical_hierarchies.md) | Liouville / Roth / Mahler A-S-T-U / Shidlovsky / Baker / Nesterenko / Zudilin tabulated, with citations |
| 03 | [`02_pi_class.md`](02_pi_class.md) | π: Lindemann 1882 transcendental; Mahler S-number (conjectured); μ(π) ≤ 7.103 (Zeilberger–Zudilin 2020); Mathlib status |
| 04 | [`03_e_class.md`](03_e_class.md) | e: Hermite 1873 transcendental; E-function (Shidlovsky class); Mahler S-number with μ(e)=2; cleanest of the four |
| 05 | [`04_sqrt2_class.md`](04_sqrt2_class.md) | √2: algebraic degree 2 — Mahler A-class (trivial case), Roth exponent exactly 2 |
| 06 | [`05_catalan_G_class.md`](05_catalan_G_class.md) | Catalan G: **OPEN PROBLEM** — irrationality not proven; Rivoal–Zudilin partial results (∞-many β(2n) irrational); conjectured Mahler S-number μ=2 |
| 07 | [`06_separation_theorem.md`](06_separation_theorem.md) | **Headline**: the 4 constants occupy 4 distinct classes — conditional theorem statement, 4 layers |
| 08 | [`07_proof_sketches.md`](07_proof_sketches.md) | Lean-level proof sketches for §§02–06 |
| 09 | [`08_required_machinery.md`](08_required_machinery.md) | Mathlib / OmegaTheory infra: Hermite-Padé, Baker, Shidlovsky, Nesterenko, Zudilin — what exists / needs port / needs original work |
| 10 | [`09_session_budget.md`](09_session_budget.md) | Per-theorem session estimates (easy 1–3 / medium 3–10 / hard 10–30 / blocked-on-Mathlib) |
| 11 | [`10_proof_count.md`](10_proof_count.md) | **Headline integer**: proofs committed to — N total across (proved / statement-formalised / unwritten) |
| 12 | [`11_master_plan_skeleton.md`](11_master_plan_skeleton.md) | **Puzzle-pieces view** of all Omega-Theory mathematics we still need to ship |
| 13 | [`12_graph_register.md`](12_graph_register.md) | The `:TheoremCandidate` nodes registered in Neo4j for this scope — live register |
| 14 | [`13_novel_mathematics.md`](13_novel_mathematics.md) | Novel math we built on top of Mathlib (Task 13 from coordinator) |

## Headline numbers (live as of this session)

| Question | Answer |
|---|---:|
| % of physics formalised | **~72 %** (see §10) |
| Proofs committed to in this scope | **31** new `:TheoremCandidate` registered |
| Mathlib blockers | **5 critical** (Lindemann-Weierstrass, E-function transcendence, Mahler classification, Nesterenko 1996, Catalan G irrationality) |
| Open vs conjectural vs provable-today | **7 provable** / **19 blocked-on-Mathlib** / **5 conjectural** (incl. Catalan G) |

## Amendments
- **2026-04-21** (Rasalas): first pass — 14 memos, 31 :TheoremCandidate, 4 :GraphFinding. No .lean files written. All claims cited against arXiv / Mathlib / existing OmegaTheory files.

## Reading order
For a first pass: `00_motivation → 01_classical_hierarchies → 06_separation_theorem → 11_master_plan_skeleton → 10_proof_count`.
For implementation: `07_proof_sketches → 08_required_machinery → 09_session_budget → 12_graph_register`.
For scope discussion with the coordinator: `10_proof_count → 11_master_plan_skeleton → 13_novel_mathematics`.
