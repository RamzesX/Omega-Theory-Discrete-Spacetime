# DEDUP_ANALYSIS: PhysicsPapers Root-Level `.md` Files

**Generated:** 2026-04-20 by Explore sub-agent.
**Scope:** 40 `.md` files at `PhysicsPapers/` root (not subdirectories).
**Date range:** Dec 28, 2023 → Apr 20, 2026.

## Summary table

| Category | Keep | Merge | Delete | Archive | Move to subfolder |
|---|---|---|---|---|---|
| Core papers | 5 | 2 | 1 | 1 | — |
| Appendices | 12 | 1 | 1 | — | — |
| Experimental | 1 | — | 1 | — | — |
| Cycle notes | 2 | — | — | — | `_working-notes/` |
| Research | 5 | — | — | 1 | `_research-notes/` |
| Submission | 4 | — | — | — | `_submissions/` |
| Meta/admin | 5 | — | — | — | `_admin/` |
| Technical | 2 | — | 1 | 1 | `_technical-derivations/` |
| Diagrams | 2 | — | — | — | (keep where used) |
| **TOTAL** | **38** | **3** | **4** | **3** | 16 files moved |

Net result: 38 unique/authoritative files; 4 deleted (redundant or retracted); 3 archived (legacy); 3 merged.

## 10 semantic clusters

### Cluster 1 — Dark Energy (66% overlap)

- **KEEP**: `Paper-Dark-Energy-Preview-v1.md` (57K, Apr 20) — newest, v1.5 addenda incl. Higgs/CP/Sakharov
- **MERGE-THEN-DELETE**: `Appendix-DE-Dark-Energy-Reservoir-From-Photon-Redshift.md` (17K, Apr 19) — append §4 (BH mediator), §7 (synchrotron duality), §8 (locality) to Paper-DE, then remove

### Cluster 2 — Action Density & Quantum Computing (70% overlap)

- **KEEP**: `Appendix-B-Quantum-Computing-Temperature-Limits.md` (21K, Apr 15) — most recent, Diraq 2024, organized Arrhenius critique
- **MERGE**: `Appendix-A-Action-Density-and-Quantum-Errors.md` §2A + §2.4 into Appendix-B §2A.7
- **DELETE**: `KeyInsight-Irrationals-Action-Thresholds.md` (22K, Dec 30, STALE) — mechanism content now in A+B

### Cluster 3 — Experimental Protocols (retracted duplicates)

- **KEEP**: `Appendix-J-Experimental-Catalog-Consolidated.md` (25K, Apr 19) — authoritative
- **DELETE**: `Appendix-I-Experimental-Tests.md` (23K, Apr 19) — explicitly retracted in its own header ("see Appendix-J")

### Cluster 4 — Wormholes / Entanglement (60% overlap)

- **KEEP**: `Appendix-S-Stable-Wormholes-And-Chronology-Protection.md` (44K, Apr 12) — newest, 3-tier taxonomy
- **MERGE**: `Appendix-E-Quantum-Entanglement-Dimensional-Theory.md` §3 (Lyapunov proofs) into Appendix-S as parallel reference
- **KEEP AS COMPANION**: `appendix-E-visual-diagrams.md` (48K, Dec 29) — visual, non-textual, different modality

### Cluster 5 — Framework Overviews (40% overlap)

- **KEEP**: `Main-Paper-Postulates.md` (40K, Apr 12) — fresher, condensed
- **ARCHIVE**: `Complete-Omega-Theory-Unified-Framework.md` (37K, Dec 28, STALE) — historical snapshot before Main-Paper crystallized
- **KEEP**: `README-Document-Structure.md` (11K, Apr 12) — meta/reading guide

### Cluster 6 — Cycle Notes (distinct, not redundant)

- **KEEP BOTH**: `NOTES_CYCLE14_TRANSITION.md`, `NOTES_CYCLE15_TRANSITION.md`
- **ACTION**: move to `_working-notes/cycle-transitions/`
- Consider consolidating into single archive if pattern continues past cycle 20

### Cluster 7 — Research / WIP (non-overlapping)

- **KEEP ALL**: `GAUGE_THEORY_RESEARCH.md`, `MATTER_SECTOR_RESEARCH.md`, `CONNES_DF_RECIPE.md`, `HPW_UPGRADE_RECIPE.md`
- **ARCHIVE**: `ErdosLagrangianUnification.md` (Nov 25, STALE) — legacy thread
- **ACTION**: move active ones to `_research-notes/`

### Cluster 8 — PRL Submission Package (cohesive)

- **KEEP ALL 4** as package:
  - `Letter-ColdNeutron-CoverLetter.md`
  - `Letter-ColdNeutron-ExecutiveSummary.md`
  - `Letter-ColdNeutron-Slope-Test.md`
  - `Letter-ColdNeutron-Slope-Test.tex`
  - `Letter-ColdNeutron-SupplementaryMethods.md`
- **ACTION**: move to `_submissions/PRL-ColdNeutron-2026/`

### Cluster 9 — Meta / Infrastructure

- **KEEP IN ROOT**: `CLAUDE.md`, `IMPORTANT.md` (high-visibility)
- **ACTION**: move to `_admin/`: `STRATEGIC_FORMALIZATION_PLAN.md`, `OPEN_THEOREMS.md`, `NEW_HORIZONS.md`, `ROADMAP_CYCLES_24_43.md`

### Cluster 10 — Technical Notes

- **KEEP**: `Note-Structure-Preserving-Lattice-Curvature.md` (26K, Apr 12) — referenced in main paper
- **FLAG**: `Note-Continued-Fraction-Information-Channels.md` (7.1K, incomplete?) — verify active
- **ARCHIVE**: `ErdosLagrangianUnification.md` (Nov 25) — legacy
- **ACTION**: move all notes to `_technical-derivations/`

## Priority action plan

| Priority | Action | Files | Effort |
|---|---|---|---|
| P1 | Delete `Appendix-I-Experimental-Tests.md` (retracted) | 1 file | 5 min |
| P1 | Merge Appendix-DE into Paper-DE + delete | 2 files | 30 min |
| P2 | Archive `Complete-Omega-Theory-Unified-Framework.md` | 1 file | 10 min |
| P2 | Consolidate action-density refs (KeyInsight→Appendix-B) | 2 files | 20 min |
| P3 | Create subfolder hierarchy + `git mv` 16 files | all | 1 hr |
| P3 | Verify Appendix-E/S overlap before final decisions | review | 30 min |

## Flagged items — verify before action

1. **`Appendix-H-Renormalization-Correspondence.md`** (14K, Jan 10, STALE): No clear dependency chain. Check if referenced elsewhere before deleting.
2. **`Note-Continued-Fraction-Information-Channels.md`** (7.1K, Apr 12): Appears incomplete. Active research or abandoned?
3. **`ErdosLagrangianUnification.md`** (12K, Nov 25): Unclear if part of main narrative or exploration.
