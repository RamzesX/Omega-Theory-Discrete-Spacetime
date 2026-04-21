---
name: PhysicsPapers/research
date: 2026-04-21
status: 9 active files covering formalization plans, gauge theory research, matter sector, and the paper ↔ Lean bridge
author: Norbert Marchewka
scope: Research memos, strategic plans, recipes, audits, and the de-facto Paper↔Lean verification table
---

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md)

# OmegaTheory — Research Tree

> **Corpus scale** (live 2026-04-21): 🔷 **8,996** OmegaTheoryV2 own theorems · 🔶 **175,137** Mathlib integrated · 🔹 **184,133** total. Build: **3,835 jobs GREEN**, 0 sorry, **8 physical axioms** (+ 15 HermitePadé + 1 π-transcendental = 24 total, tracked separately).

Strategic plans, research recipes, audits, and — most importantly — the
**paper ↔ Lean verification bridge** that maps every published claim back to a
machine-checked theorem.

## Files

| # | File | Category | Purpose |
|---|------|----------|---------|
| 1 | [`LEAN_VERIFIED_CLAIMS.md`](LEAN_VERIFIED_CLAIMS.md) | **Bridge (authoritative)** | 87-row table `§ paper section → .lean file #Lnnn → theorem_name → proof-style → score`. Every verifiable claim in every paper traces here. **Start here if you want to verify anything independently.** |
| 2 | [`STRATEGIC_FORMALIZATION_PLAN.md`](STRATEGIC_FORMALIZATION_PLAN.md) | Plan | Overarching formalization strategy across cycles |
| 3 | [`GAUGE_THEORY_RESEARCH.md`](GAUGE_THEORY_RESEARCH.md) | Research | SU(2)/SU(3)/U(1) gauge emergence — Connes + Wilson + similarity-algebra approach |
| 4 | [`MATTER_SECTOR_RESEARCH.md`](MATTER_SECTOR_RESEARCH.md) | Research | Fermion masses, generations, mixing — π/e/√2/Catalan-G 4-channel programme |
| 5 | [`CONNES_DF_RECIPE.md`](CONNES_DF_RECIPE.md) | Recipe | Connes spectral action D_F eigenvalue → Yukawa bridge |
| 6 | [`NEW_HORIZONS.md`](NEW_HORIZONS.md) | Horizon-scan | Frontier directions beyond the cycle-43 grand capstone |
| 7 | [`OPEN_THEOREMS.md`](OPEN_THEOREMS.md) | Tracker | Unshipped theorems on the cycle-44+ backlog |
| 8 | [`PAPERS_AUDIT.md`](PAPERS_AUDIT.md) | Audit | File-by-file audit of the PhysicsPapers/ tree (pre-reorg snapshot) |
| 9 | [`PAPERS_REORG_PLAN.md`](PAPERS_REORG_PLAN.md) | Historic plan | The 2026-04 reorg plan (executed; retained for provenance) |

## Tombstoned

- `HPW_UPGRADE_RECIPE.md` — **was never written.** It was scoped as an upgrade
  path for the HPW axiom; the axiom was instead **deleted outright on 2026-04-17**
  via the `HpwEliminableRegime` typeclass (7 regimes eliminated: flat, linearised,
  Schwarzschild, FRW, Bianchi I, de Sitter, Kerr). Any reference to this recipe
  in older docs points to a ghost; grep still turns up historic references in
  `PAPERS_REORG_PLAN.md`.

## Paper ↔ Lean bridge — usage

`LEAN_VERIFIED_CLAIMS.md` is the single authoritative cross-reference table.
Every row is:

```
§ paper section  |  Lean file  |  Line  |  Theorem name  |  Proof style  |  Verification score
```

Usage patterns:
- **Reading a paper** → grep for the section number (e.g. `§4.2`) → follow the
  `#Lnnn` link → verify the theorem compiles.
- **Checking a theorem** → grep for the theorem name → locate its paper citation.
- **Extending OmegaTheory** → check which sections already have Lean backing
  before rewriting.

The table is **hand-curated**. Automation (`Meta/DumpPaperBridge.lean` with a
`@[paper_section "..."]` attribute) was scoped but deferred in the cycle-43
retrospective — the attribute-based approach requires edits to ~150 Lean files
and would drift whenever the paper LaTeX renumbers sections.

## Related trees

- [`../papers/`](../papers/) — the 3 public-facing paper drafts that cite this table.
- [`../appendices/`](../appendices/) — 15 appendices cross-referenced from `LEAN_VERIFIED_CLAIMS.md`.
- [`../LeanFormalizationV2/plans/`](../LeanFormalizationV2/plans/) — formalization backlog + Grothendieck followup reports.
- [`../LeanFormalizationV2/notes/`](../LeanFormalizationV2/notes/) — cycle closure memos + open-work design memos (Kempf β/γ/δ, Seeley-DeWitt, Proton-Mass, Gap-Hunter).

## Amendments

- **2026-04-21** — Directory README added (repo-wide navigation overhaul, plan: `elegant-sauteeing-simon.md`). `HPW_UPGRADE_RECIPE.md` tombstoned; ghost references in other docs cleaned up in the same session.
- **2026-04-17** — HPW axiom deleted outright; `HPW_UPGRADE_RECIPE.md` scope collapsed.
- **Apr 2026** — `LEAN_VERIFIED_CLAIMS.md` extended from ~40 to 87 rows post cycle-24–43 landings.

---

*Return to: [PhysicsPapers index](../README.md) · [chaos-shield root](../../README.md)*
