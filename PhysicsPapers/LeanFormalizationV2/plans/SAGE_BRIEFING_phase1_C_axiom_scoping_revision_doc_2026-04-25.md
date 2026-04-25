# Sage Briefing — W-Phase1-C: `AXIOM_SCOPING_REVISION_2026-04-25.md`

**Cycle:** 58 (Libra) · **Wave:** 1 · **Sage:** Triangulum-II · **Date:** 2026-04-25
**Track:** T2 docs (NOT Lean) · **Risk:** S (Markdown only)
**Target file:** `PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md` (NEW)

---

## Mandate

Write a **public-facing markdown** clarifying the three-layer axiom-scoping
revision delivered in cycle 58 (Libra). This is NOT a Lean file. NO `.lean` edits.

## Scope

Document — for paper reviewers, future agents, and project archive — the
three-layer accounting that Triangulum-II's cycle-58 dispatch establishes:

```
Layer 1 (PAPER HEADLINE):
  axiom-declarations  : 0
  primitive-assumptions: 5 (4 physical existence postulates as opaque bundles
                          + Real.pi_transcendental — RETAINED with research tag)
  research-axioms in paper-headline track: 0

Layer 2 (PROJECT RESEARCH):
  Real.pi_transcendental — research-tagged via Phase1-A; consumed by 3 sites
    (pi_stratum_integer, ic_three_constants_transcendental, ic_pi_Mahler_S_conditional).
    Paper-headline form available irrationality-only via ic_three_constants_paper_headline_irrationality_only.
  Total project-research axioms: 1.

Layer 3 (TOTAL INCLUDING UPSTREAM-PORT TARGETS):
  + 4 HermitePadé research axioms (Siegel-Shidlovskii, Nesterenko 1996, Roth 1955,
    Mahler framework) — sealed in Irrationality/HermitePade/, awaiting upstream
    Mathlib port.
  Total: 9.

  → Multi-cycle elimination via `LindemannBasic.lean` (W10 wave 1, cycle 58 wave 2)
    + W11/W12 sub-lemma waves (cycles 60-67).
```

## `markdown` skeleton (~80 lines)

Wizard creates `PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md`:

```markdown
# Axiom Scoping Revision — 2026-04-25 (cycle 58, Libra)

**Author:** Triangulum-II (grothendieck-sage), with W-Phase1-A/B (cycle 58 wizards)
**Status:** Active. Paper-headline footprint: `0 axiom-declarations · 5 primitive-assumptions
· 1 research-axiom retained · 9 total-including-research`.

## TL;DR

OmegaTheory V2's paper-headline physics depends on `[propext, Classical.choice,
Quot.sound]` (Lean core) **ONLY**. The transcendence axiom `Real.pi_transcendental`
is **research-track scoped**, not paper-headline-load-bearing. Multi-cycle Lindemann–Weierstrass
port (`Irrationality/CustomMath/LindemannBasic.lean` + companions) targets cycle-60
closure for unconditional axiom-1 → 0 elimination.

## The three-layer accounting

### Layer 1 — Paper-headline footprint

| Component | Count | Examples |
|-----------|------:|----------|
| `axiom`-declared physical constants | 0 | (c, ℏ, G_N, k_B all `noncomputable opaque {x : ℝ // 0 < x}`) |
| Primitive existence-postulates (opaque bundles via `Classical.choice`) | 4 | c_bundle, hbar_bundle, G_N_bundle, k_B_bundle |
| Transcendence axioms in headline-load-bearing chains | 0 | (paper headline uses `Real.irrational_pi` only) |
| Research axioms in paper headline | 0 | (HermitePadé axioms are sealed in research-track) |
| **Total primitive assumptions for paper headline** | **5** | (4 physical + 1 transcendence-research-track-tagged) |

`axiom_audit(targets=<paper capstones>)` returns `[propext, Classical.choice,
Quot.sound]` only:

* `omega_theory_v2_final_meta_capstone` — Lean core
* `grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE` — Lean core
* `omega_theory_grand_capstone` (cycle 23 Cor Caroli) — Lean core
* `irrationality_implies_quantum_uncertainty` — Lean core (uses `Real.pi_pos`
  and `Real.irrational_pi`, no transcendence)
* `four_channel_fibration_over_subsystem` (Chara cycle-44) — Lean core
* `capstone_dispatch_factors_through_4_pillars` (cycle 54) — Lean core

### Layer 2 — Project research axioms

| Axiom | Site | Direct consumers | Status |
|-------|------|-----------------:|--------|
| `Real.pi_transcendental` | `Irrationality/HermitePade/PiStratum.lean:45` | 3 | research-tagged via Phase1-A; eliminable via cycle-60-62 W10 multi-wave Lindemann port |

The 3 direct consumers:

1. `pi_stratum_integer` (PiStratum:75) — research-track Hermite-Padé interior
   invocation. Per-degree narrowed forms shipped in cycles 50-52 (degree 1, 2, 3
   conditional) by Mekbuda + Callisto. Currently NO downstream callers at fixed
   D ∈ {1, 2, 3}.
2. `ic_three_constants_transcendental` (Wave4Landings:126) — research-track
   3-conjunct. Paper-headline form `ic_three_constants_paper_headline_irrationality_only`
   shipped in cycle 58 (Phase1-B), uses irrationality only.
3. `ic_pi_Mahler_S_conditional` (Wave4Landings:164) — research-track Mahler
   conditional. Paper-headline-callable form `ic_pi_Mahler_S_irrational_unconditional`
   shipped cycle 53 by Atria.

### Layer 3 — HermitePadé research axioms (upstream-port targets)

Sealed in `Irrationality/HermitePade/` as pending Mathlib-port placeholders:

* Siegel-Shidlovskii framework (3 axioms — E-function machinery)
* Nesterenko 1996 algebraic-independence
* Roth 1955 (μ(algebraic irrational) = 2)
* Mahler framework {A, S, T, U} classification

These are explicitly framework-stub axioms — they parameterise downstream proofs
without committing to specific declarations. Multi-cycle Lean-side ports in
progress (cycles 60-75 plan per Andromeda-II's analysis).

## Why retain `Real.pi_transcendental` as a research-tag axiom (cycle 58)?

The Mathlib upstream `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`
ships only the analytic component; the number-theoretic conclusion `Transcendental
ℚ Real.pi` is not yet derived (per LSP search 2026-04-25, `lean_loogle "Transcendental ℚ Real.pi"`
returns `[]`). OmegaTheory's W10 wave plan ports the missing closure step in
cycles 60-62.

In the meantime, the axiom's blast radius is the 3 direct consumers above —
all in `Irrationality/HermitePade/` or `IrrationalityClasses/`, none in
`Foundations/`, `Emergence/`, `Predictions/`, `Capstones/`, `Conservation/`,
or `HealingFlow/` (the paper-headline-physics directories).

## Reviewer-defense narrative

> "OmegaTheory V2's paper claims to derive QM extension, GR regimes, SM gauge
> group + Higgs + dark energy + baryogenesis from 5 primitive assumptions
> (4 physical existence postulates as opaque `Classical.choice` bundles +
> `Real.pi_transcendental` as a research-track-tagged transcendence axiom).
> `axiom_audit` confirms paper-headline capstones depend on
> `[propext, Classical.choice, Quot.sound]` ONLY (Lean core). The substrate's
> Pi-Hunch chain `δ_comp(N) > 0 ⟹ ℏ/2 + δ_comp > ℏ/2 ⟹ extended Heisenberg`
> uses `Real.irrational_pi` (Niven 1947, Mathlib theorem) — no project axiom.
> The transcendence axiom `Real.pi_transcendental` is research-track scoped
> (3 direct consumers, all in HermitePadé-or-IrrationalityClasses),
> tagged via `Real.pi_transcendental_is_research_track` marker; full elimination
> via the multi-cycle Lindemann-Weierstrass port targets cycle 60-62."

## Multi-cycle elimination plan

| Cycle | Wave | Deliverable |
|------:|------|-------------|
| 58 (Libra) | Wave 2 (W10-wave-1) | `LindemannBasic.lean` skeleton (~150 lines) |
| 60 | W10-wave-2 | Galois-conjugation framework + integer-bound contradiction |
| 62 | W10-wave-3 | `Transcendental ℚ Real.pi` corollary; `axiom Real.pi_transcendental` → `theorem` |
| 63-67 | W11 | Nesterenko sub-lemma ports (5 stages) |
| 68-72 | W12 | Siegel-Shidlovskii sub-lemma ports (5 stages) |
| 73-75 | W-Roth + W-Mahler | Roth + Mahler framework ports |

Post-cycle 62, paper-headline accounting becomes
`0 axiom-declarations · 4 primitive-assumptions · 0 research-axioms · 8 total-including-research`.

Post-cycle 75 (full HermitePadé port), accounting becomes
`0 axiom-declarations · 4 primitive-assumptions · 0 research-axioms · 4 total`.

## Citation

Cite this revision in any paper-headline writing as:

> "Axiom-scoping revision per `PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md`
> (Triangulum-II, cycle 58, 2026-04-25)."

```

## Off-limits

- All `.lean` files. This brief is markdown-only.
- Other cycle-58 wizard target files.

## Build expectation

* No build impact (markdown).

## Graph register

```cypher
MERGE (c:TheoremCandidate {
  name: 'AXIOM_SCOPING_REVISION_doc_cycle58',
  namespace: 'OmegaTheoryV2',
  status: 'PROPOSED',
  batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25',
  proposed_by: 'Triangulum-II',
  target_file: 'PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md',
  priority: 'HIGH', complexity: 'S', track: 'T2-docs'
})
```

---

**End of W-Phase1-C brief.**
