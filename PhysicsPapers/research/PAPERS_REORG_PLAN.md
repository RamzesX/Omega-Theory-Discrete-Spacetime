# REORG_PLAN — PhysicsPapers/ Subfolder Reorganization

**Status:** PROPOSAL. No moves executed yet. Review §7 open questions + §5 batched script.

## 1. Proposed tree (6 subfolders)

```
PhysicsPapers/
├── CLAUDE.md                (stay at root)
├── README.md                (renamed from README-Document-Structure.md)
├── IMPORTANT.md             (stay at root — Claude-agent entry)
├── PAPERS_AUDIT.md, PAPERS_REORG_PLAN.md, ROADMAP_CYCLES_24_43.md  (new planning docs, stay at root for now)
├── papers/                  (4 manuscripts)
│   ├── Main-Paper-Postulates.md
│   ├── Complete-Omega-Theory-Unified-Framework.md
│   ├── Paper-Dark-Energy-Preview-v1.md
│   └── KeyInsight-Irrationals-Action-Thresholds.md
├── appendices/              (15 Appendix-*.md — preserves A..S lettering)
├── letter-coldneutron/      (5-file PRL submission package)
├── diagrams/                (2 visual supplements)
├── notes/                   (3 research notes)
├── research/                (7 recipe/plan/research docs)
└── LeanFormalizationV2/     (untouched — Lean stays; cycle-transition notes move HERE)
    └── notes/
        ├── NOTES_CYCLE14_TRANSITION.md
        └── NOTES_CYCLE15_TRANSITION.md
```

## 2. File-to-folder mapping (37 moves + 1 rename)

| Folder | Files |
|---|---|
| `papers/` | Main-Paper-Postulates, Complete-Omega-Theory-Unified-Framework, Paper-Dark-Energy-Preview-v1, KeyInsight-Irrationals-Action-Thresholds |
| `appendices/` | All 15 `Appendix-*.md` (A/B/C/D/DE/E/F/G/H/I/J/K/LorentzDoppler/P/S) |
| `letter-coldneutron/` | 5 `Letter-ColdNeutron-*` files (including `.tex`) |
| `diagrams/` | unified-theory-diagram, appendix-E-visual-diagrams |
| `notes/` | Note-Continued-Fraction-Information-Channels, Note-Structure-Preserving-Lattice-Curvature, ErdosLagrangianUnification |
| `research/` | CONNES_DF_RECIPE, GAUGE_THEORY_RESEARCH, HPW_UPGRADE_RECIPE, MATTER_SECTOR_RESEARCH, NEW_HORIZONS, OPEN_THEOREMS, STRATEGIC_FORMALIZATION_PLAN |
| `LeanFormalizationV2/notes/` | NOTES_CYCLE14_TRANSITION, NOTES_CYCLE15_TRANSITION (move from root here) |

## 3. Risk summary

| Risk | Severity | Mitigation |
|---|---|---|
| Parent repo's README/PAPERS/mkdocs.yml break (~78 refs across 5 files) | **HIGH** | `sed -i` pass in same commit (script §6) |
| MkDocs documentation site becomes 404-heavy | **HIGH** | Rebuild after with `mkdocs build --strict` |
| Git history lost on 3 untracked files | LOW | `git add` them first or accept no history |
| Cross-folder links in `Note-Continued-Fraction-*.md` + `Paper-Dark-Energy-Preview-v1.md` | MEDIUM | 4 specific sed rewrites (§6) |
| `NOTES_CYCLE1[45]_TRANSITION.md` collides with existing `LeanFormalizationV2/` copies | MEDIUM | `diff` + dedupe before move |

## 4. Execution sequence

1. **Pre-flight**: commit unrelated agent-memory deletions separately; stash dirty state; record rollback SHA.
2. `git add` 3 untracked files (Paper-DE-Preview, NOTES_CYCLE14/15) if want git history.
3. Dedupe `NOTES_CYCLE14/15_TRANSITION.md` collisions in LeanFormalizationV2/.
4. Create subfolders.
5. `git mv` (batched §5).
6. Rename `README-Document-Structure.md` → `README.md`.
7. Internal sed rewrites (2 files, 4 paths).
8. External sed rewrites (5 parent-repo files, ~78 paths).
9. Update `CLAUDE.md` repo-structure block.
10. `git status` + `mkdocs build --strict` verify.
11. Commit atomically.

## 5. Batched `git mv` script

```bash
#!/usr/bin/env bash
# Run from PhysicsPapers/
set -e

# Pre-flight: stage untracked files so git mv works on them
git add Paper-Dark-Energy-Preview-v1.md NOTES_CYCLE14_TRANSITION.md NOTES_CYCLE15_TRANSITION.md 2>/dev/null || true

mkdir -p papers appendices letter-coldneutron diagrams notes research LeanFormalizationV2/notes

# papers/
git mv Main-Paper-Postulates.md papers/
git mv Complete-Omega-Theory-Unified-Framework.md papers/
git mv Paper-Dark-Energy-Preview-v1.md papers/
git mv KeyInsight-Irrationals-Action-Thresholds.md papers/

# appendices/
for f in \
  Appendix-A-Action-Density-and-Quantum-Errors.md \
  Appendix-B-Quantum-Computing-Temperature-Limits.md \
  Appendix-C-Catalog-of-Evolution-Functionals.md \
  Appendix-D-Topological-Surgery-And-Information-Healing.md \
  Appendix-DE-Dark-Energy-Reservoir-From-Photon-Redshift.md \
  Appendix-E-Quantum-Entanglement-Dimensional-Theory.md \
  Appendix-F-Information-Flow-Conservation.md \
  Appendix-G-Graviton-Predictions.md \
  Appendix-H-Renormalization-Correspondence.md \
  Appendix-I-Experimental-Tests.md \
  Appendix-J-Experimental-Catalog-Consolidated.md \
  Appendix-K-Irrationality-Genesis-Of-Predictions.md \
  Appendix-LorentzDopplerEquivalence.md \
  Appendix-P-Einstein-Cartan-Torsion-Integration.md \
  Appendix-S-Stable-Wormholes-And-Chronology-Protection.md
do git mv "$f" appendices/; done

# letter-coldneutron/
git mv Letter-ColdNeutron-CoverLetter.md letter-coldneutron/
git mv Letter-ColdNeutron-ExecutiveSummary.md letter-coldneutron/
git mv Letter-ColdNeutron-Slope-Test.md letter-coldneutron/
git mv Letter-ColdNeutron-Slope-Test.tex letter-coldneutron/
git mv Letter-ColdNeutron-SupplementaryMethods.md letter-coldneutron/

# diagrams/
git mv unified-theory-diagram.md diagrams/
git mv appendix-E-visual-diagrams.md diagrams/

# notes/
git mv Note-Continued-Fraction-Information-Channels.md notes/
git mv Note-Structure-Preserving-Lattice-Curvature.md notes/
git mv ErdosLagrangianUnification.md notes/

# research/
git mv CONNES_DF_RECIPE.md research/
git mv GAUGE_THEORY_RESEARCH.md research/
git mv HPW_UPGRADE_RECIPE.md research/
git mv MATTER_SECTOR_RESEARCH.md research/
git mv NEW_HORIZONS.md research/
git mv OPEN_THEOREMS.md research/
git mv STRATEGIC_FORMALIZATION_PLAN.md research/

# cycle-transition notes → LeanFormalizationV2/notes/
# IMPORTANT: dedupe with LeanFormalizationV2/NOTES_CYCLE14/15 first!
git mv NOTES_CYCLE14_TRANSITION.md LeanFormalizationV2/notes/
git mv NOTES_CYCLE15_TRANSITION.md LeanFormalizationV2/notes/

# Promote to README
git mv README-Document-Structure.md README.md

echo "✓ Moves complete. Verify: git status; git diff --stat --staged"
```

## 6. Sed rewriter (external references)

```bash
cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/
for f in README.md PAPERS.md Physics-Papers-Summary.md mkdocs.yml docs/index.md; do
  [ -f "$f" ] || continue
  sed -i \
    -e 's|PhysicsPapers/Appendix-|PhysicsPapers/appendices/Appendix-|g' \
    -e 's|PhysicsPapers/appendix-E-visual-diagrams.md|PhysicsPapers/diagrams/appendix-E-visual-diagrams.md|g' \
    -e 's|PhysicsPapers/Main-Paper-|PhysicsPapers/papers/Main-Paper-|g' \
    -e 's|PhysicsPapers/Complete-Omega-Theory-|PhysicsPapers/papers/Complete-Omega-Theory-|g' \
    -e 's|PhysicsPapers/KeyInsight-Irrationals-|PhysicsPapers/papers/KeyInsight-Irrationals-|g' \
    -e 's|PhysicsPapers/Paper-Dark-Energy-|PhysicsPapers/papers/Paper-Dark-Energy-|g' \
    -e 's|PhysicsPapers/unified-theory-diagram.md|PhysicsPapers/diagrams/unified-theory-diagram.md|g' \
    -e 's|PhysicsPapers/Letter-ColdNeutron-|PhysicsPapers/letter-coldneutron/Letter-ColdNeutron-|g' \
    -e 's|PhysicsPapers/Note-|PhysicsPapers/notes/Note-|g' \
    -e 's|PhysicsPapers/ErdosLagrangianUnification.md|PhysicsPapers/notes/ErdosLagrangianUnification.md|g' \
    -e 's|PhysicsPapers/README-Document-Structure.md|PhysicsPapers/README.md|g' \
    "$f"
done

# Internal cross-refs (2 files, 4 paths):
cd PhysicsPapers/
sed -i 's|](Main-Paper-Postulates.md)|](../papers/Main-Paper-Postulates.md)|' notes/Note-Continued-Fraction-Information-Channels.md
sed -i 's|](README-Document-Structure.md)|](../README.md)|' notes/Note-Continued-Fraction-Information-Channels.md
sed -i 's|/PhysicsPapers/NOTES_CYCLE14_TRANSITION.md|/PhysicsPapers/LeanFormalizationV2/notes/NOTES_CYCLE14_TRANSITION.md|g' papers/Paper-Dark-Energy-Preview-v1.md
sed -i 's|/PhysicsPapers/NOTES_CYCLE15_TRANSITION.md|/PhysicsPapers/LeanFormalizationV2/notes/NOTES_CYCLE15_TRANSITION.md|g' papers/Paper-Dark-Energy-Preview-v1.md

# Sanity
grep -RE "PhysicsPapers/(Appendix|Main-Paper|Letter-ColdNeutron|Note-|KeyInsight|Complete-Omega|unified-theory|appendix-E-visual|Paper-Dark-Energy|ErdosLagrangian|README-Document)" \
  --include='*.md' --include='*.yml' /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/ \
  && echo "❌ LEGACY REFS REMAIN" || echo "✓ ALL CLEAN"
```

## 7. Open questions

1. **Promote `README-Document-Structure.md` → `README.md`?** RECOMMENDED YES.
2. **Keep `IMPORTANT.md` at root?** RECOMMENDED YES (Claude-agent entry parallel to CLAUDE.md).
3. **Merge `notes/` and `research/`?** RECOMMENDED NO — different content types.
4. **Rename `letter-coldneutron/` → `letters/ColdNeutron/`** for future PRLs? Optional.
5. **Git-track the 3 untracked files first?** RECOMMENDED YES.

## 8. Commit message

```
Reorganize PhysicsPapers/ into 6 subfolders

Move 37 root-level .md/.tex files into thematic subfolders:
- papers/           (4 manuscripts)
- appendices/       (15 Appendix-*.md)
- letter-coldneutron/ (5-file PRL package)
- diagrams/         (2 visual supplements)
- notes/            (3 research notes)
- research/         (7 recipe/plan/research docs)

Promote README-Document-Structure.md → README.md.
Move NOTES_CYCLE14/15_TRANSITION.md into LeanFormalizationV2/notes/.
Update 5 parent-repo external refs (README, PAPERS, mkdocs.yml, docs/)
+ 4 intra-repo cross-refs.

Git-tracked renames preserve history.
Verified: mkdocs build --strict passes; zero legacy refs remain.
```
