# OmegaTheory V2 — Master TODO (Apr 15 2026)

Status snapshot **2026-04-15**. Team: `v2-apr15-lean` (4 teammates + team-lead).
Memories: `~/.claude/projects/-mnt-c-Users-Norbert-IdeaProjects-chaos-shield/memory/project_v2_state_apr15.md`.

Actual repo stats: **125 .lean files, 1584 declarations (1334 theorems+lemmas), 0 `sorry`, 31 axiom declarations** (9 substantive: 8 physical constants + 1 HPW; rest are transcendence citations in HermitePade + Hpw supporting).

**Build status at start of wave**: RED — `Decoherence.lean:185` unsolved goal. **Priority #0 fix** assigned to Capella (build-fixer).

---

## ✅ DONE (this wave)

| # | Task | Agent | File |
|---|---|---|---|
| — | **Master refresh of `project_v2_state_apr15.md` memory** | team-lead | `~/.claude/projects/.../memory/project_v2_state_apr15.md` |
| — | **Feedback memory**: "Nie portuj axiomów z V1 do V2" | team-lead | `feedback_no_v1_port.md` |
| — | **Dangling link fix** `feedback_matrix_iteratedfderiv_whnf` | team-lead | `MEMORY.md` |
| — | **Stale memory cleanup** (apr12, apr13_vega deleted) | team-lead | memory dir |
| #6 | **LaSalle ↔ equilibrium equivalence** (this task) | team-lead | `HealingFlow/LaSalle.lean` (NEW, ~160L, built clean in 83s) |
| #20 | Redshift as information-propagation cost | capella | `Emergence/Redshift.lean` (NEW) — reported complete |

---

## 🏃 IN PROGRESS

| # | Task | Agent |
|---|---|---|
| #19 | **[CRITICAL]** Fix `Decoherence.lean:185` unsolved goal | Capella (build-fixer) |
| #10 | `HilbertEmergence.lean` — 5 theorems + capstone 8th conjunct | Procyon (hilbert-builder) |
| #7 | Ingredient A — `central_diff_second_order_accurate` (Taylor bound) | Arcturus (hpw-chain) |
| #21 | Mass as lattice brake — all particles want c | capella (physics-new) |

---

## 📋 PENDING — upcoming waves

### 🟢 Easy quick wins (1 session each)
| # | Task | Blocker |
|---|---|---|
| #5 | Promote `informationDensityKL_nonneg_of_wellDefined` (TODO in CoarseGrainingMap:231) | none (build-fixer will take) |
| #16 | Replace `Real.pi_transcendental` axiom if Mathlib v4.29 derives Lindemann | Mathlib upstream |

### 🟡 HPW Laplacian elimination chain
| # | Task | Who/Blocker |
|---|---|---|
| #7 | Ingredient A — scalar 1D Taylor bound (routine) | Arcturus in progress |
| #8 | Ingredient C — partial_secondderiv 4D lift (routine) | after #7 |
| #9 | Ingredient I — total_truncation_bound glue | after A+C |
| #13 | Ingredient E/F — smooth C⁴ interpolant existence + bound (2 tyg., Whitney extension) | research-grade |
| #14 | Ingredient G — continuum Ricci-box identity (Mathlib gap: no Ricci tensor) | 4–8 tyg. research |
| #15 | Ingredient H — general-curved HpwHypothesis witness | after A..I close |

### 🟣 Hilbert / QM emergence
| # | Task | Who/Blocker |
|---|---|---|
| #10 | `HilbertEmergence.lean` — 5-theorem bundle + 8th conjunct | Procyon in progress |
| #17 | CHSH inequality closure for Bell states (Phase 6C) | research-grade, after #10 |
| #18 | Relativistic Klein-Gordon bridge: derive E²=(pc)²+(mc²)² from lattice | research-grade future |

### 🔵 New physics (Norbert proposals 2026-04-15)
| # | Task | Who/Blocker |
|---|---|---|
| #20 | Redshift as information-propagation cost | ✅ DONE (capella) |
| #21 | Mass as "lattice brake" — all particles want c | in progress (capella) |
| — | **Graviton energy calculator** (bridge Lean symbolic + paper numeric) — proposed, see `Emergence/Gravitons.lean` + `Appendix-G-Graviton-Predictions.md` | PROPOSED — ask user |

---

## 🗺️ GROUPS — thematic organisation

**Group 0 — Broken build** (must-fix before next lake build top-level)
- #19

**Group 1 — Quick wins**
- #5, #16

**Group 2 — Axiom reduction (HPW chain, routine ingredients)**
- #7, #8, #9

**Group 3 — New features (Hilbert-level emergence)**
- #10

**Group 4 — Dynamics closure**
- #6 ✅ DONE

**Group 5 — Research-grade** (4+ weeks each)
- #13, #14, #15, #17, #18

**Group 6 — New physics**
- #20 ✅ DONE, #21, [proposed graviton numeric]

---

## 📂 File territories (non-overlapping editing zones)

| Agent | Allowed edits |
|---|---|
| Capella (build-fixer) | Decoherence.lean, InformationKL.lean, PiStratum.lean, CoarseGrainingMap.lean:231 |
| Procyon (hilbert-builder) | NEW HilbertEmergence.lean, QuantumMechanicsCapstone.lean (add 8th conjunct) |
| Arcturus (hpw-chain) | TaylorBound.lean, HpwHypothesis.lean, optional NEW HpwTotalTruncation.lean |
| capella (physics-new) | NEW Redshift.lean, NEW MassAsDelay.lean (or extend SpecialRelativity.lean) |
| team-lead | HealingFlow/*, master orchestration, meta-documentation |

---

## 🎯 Hard constraints (project-wide, invariant)

- **No `sorry`**
- **No new axioms** (beyond the 9 substantive + existing transcendence citations)
- **No shortcuts** — narrower true theorem > dressed-up false one
- **Incremental build** — per-module `lake build OmegaTheory.Path --log-level=error` between every change
- **WSL-native** — use `~/.elan/bin/lake` directly, NO `wsl.exe` wrapper

---

## 📖 Reference docs (read-for-context)

- `PROJECT.md` — current project overview
- `README.md` — public-facing + agent roster
- `NOTES_HPW_ELIMINATION.md` — HPW axiom elimination programme full status
- `NOTES_QM_AS_DISCRETE_GRAVITY.md` — QM-as-coarse-grained-substrate thesis
- `PLAN_HILBERT_EMERGENCE.md` — #10 spec
- `PLAN_QM_BRIDGE.md` — Phase 1–4 of QM derivation (all done)
- `PLAN_QM_LEGENDARY.md` — Phase 6 (all done, capstone in place)
- `PAPER_DRAFT.md` — publishable narrative (Alnilam arc)

---

## 🏷️ Star-name roster

**Taken**: Waves 1–14, Cortana, Meridian (×2), Lyra, Vega (×3), Orion, Rigel, Saiph, Alnilam, Polaris, Altair, Feynman-E, **Capella** (build-fixer Apr 15), **Procyon** (hilbert-builder Apr 15), **Arcturus** (hpw-chain Apr 15), (capella — physics-new, name collision under review)

**Free pool**: Deneb, Aldebaran, Spica, Antares, Regulus, Betelgeuse, Sirius, Vega⁴, Altair², etc.
