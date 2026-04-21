# Build + Graph Workflow — cheat sheet

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md) · [LeanFormalizationV2](README.md)

Canonical Bash recipes for compiling Lean and syncing the Neo4j graph to a
green build. Native ext4 workdir: `~/lean-v2/`. Windows-mount fallback:
`/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/`
(slow — prefer `~/lean-v2/`).

## 1 · Compile Lean (WSL-native, no `wsl.exe` wrapper)

```bash
# Fast iteration — native ext4
cd ~/lean-v2
~/.elan/bin/lake build --log-level=error                    # full project
~/.elan/bin/lake build OmegaTheory.Module --log-level=error # single module
~/.elan/bin/lake exe cache get                              # Mathlib cache (rarely needed)
~/.elan/bin/lake clean                                      # nuclear option
```

**Gate**: `lake build --log-level=error` exit code 0 = **3,835 jobs GREEN / 0 sorry / 8 physical axioms**. Any red = revert the last edit.

**Individual-file sanity**: `~/.elan/bin/lake build OmegaTheory.Emergence.FOO --log-level=error`.

## 2 · Dump Lean environment → JSONL

```bash
cd ~/lean-v2
~/.elan/bin/lake exe dump_decls  --out .neo4j/declarations_from_env_v2.jsonl
~/.elan/bin/lake exe dump_arrows --out .neo4j/arrows_from_env_cycleN.jsonl --include-mathlib
```

**Outputs** (post-cycle 43):
- `declarations_from_env_cycle43.jsonl` ≈ 51 MB — 8,996 theorems + 4,465 defs + 24 axioms
- `arrows_from_env_cycle43.jsonl` ≈ 16 MB — 23,171 records (imports + 12 typed arrows)

**Rule**: never regex-parse `.lean` files for graph work — per `Mirfak` measurement, the regex extractor drops 46 % of fresh theorems. The env-dump is ground truth.

## 3 · Load into Neo4j (Python driver, 27 k edges/s)

```bash
cd ~/lean-v2/.neo4j
python3 load_declarations_env_v2.py              # Naos: MERGE Theorem / Definition / Axiom
python3 load_arrows_parallel.py \
        arrows_from_env_cycleN.jsonl \
        --workers 16 --batch 1000                # SOTA 27 k edges/s, zero deadlocks
python3 reembed_qwen3_delta.py                   # Qwen3-Embedding-8B BF16 GPU on :7999
```

Endpoints:
- `http://localhost:7999/v1/embeddings` — Qwen3-8B GPU, dim 4096
- `http://localhost:7997/rerank` — Qwen3-Reranker-8B CPU

## 4 · Verify graph state live

```bash
# Via Neo4j MCP read-only query in-session
# (paste into any tool-call):
```

```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'}) WITH count(t) AS T
MATCH (a:Axiom {namespace: 'OmegaTheoryV2'}) WITH T, count(a) AS A
MATCH (c:TheoremCandidate {namespace: 'OmegaTheoryV2'}) WITH T, A, count(c) AS C
MATCH (g:GraphFinding {namespace: 'OmegaTheoryV2'}) WITH T, A, C, count(g) AS G
MATCH (s:SubsystemNavigator {namespace: 'OmegaTheoryV2'}) WITH T, A, C, G, count(s) AS S
RETURN T AS theorems, A AS axioms, C AS candidates, G AS findings, S AS subsystems
```

Expected **2026-04-21**:
```
theorems: 8996  axioms: 24  candidates: 221  findings: 92  subsystems: 677
```

## 5 · Close-cycle recipe

```bash
# 1. Build green
cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error

# 2. Dump + load delta
~/.elan/bin/lake exe dump_decls  --out .neo4j/declarations_from_env_v2.jsonl
~/.elan/bin/lake exe dump_arrows --out .neo4j/arrows_from_env_cycle$N.jsonl --include-mathlib
cd .neo4j
python3 load_declarations_env_v2.py
python3 load_arrows_parallel.py arrows_from_env_cycle$N.jsonl --workers 16 --batch 1000
python3 reembed_qwen3_delta.py

# 3. Sync committed tree (from ~/lean-v2 ext4 back to /mnt/c)
rsync -a --delete \
  --exclude='.lake' --exclude='.neo4j' \
  ~/lean-v2/ /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/

# 4. Link-check (from /mnt/c repo)
cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield && make check-links

# 5. Commit
git add . && git commit -m "cycle $N close: …"
```

## 6 · Pre-PR diagnostics

```bash
cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield
make check-links                 # no broken links in canonical docs
grep -rc '\bsorry\b' PhysicsPapers/LeanFormalizationV2/OmegaTheory/  # 0
git log --oneline -1
```

## 7 · Gate rules (must pass before claim "done")

1. `lake build --log-level=error` → exit 0, **3,835+ jobs GREEN**
2. `grep -r '\bsorry\b' OmegaTheory/ | wc -l` → **0**
3. Axiom count (grep `^axiom`) stays at **24** (8 physical + 15 HermitePadé + 1 π-transcendental)
4. Neo4j health: `ReservedName` + `NavigationMaster` nodes reachable
5. No dead links in canonical docs (`make check-links` reports only deprecated `docs/` / `PAPERS_REORG_PLAN.md` residue)

---

*Related: [`STATUS.md`](STATUS.md) (single source of truth for live numbers) · [`.neo4j/CLAUDE.md`](.neo4j/CLAUDE.md) (pipeline deep-dive) · [`CLAUDE.md`](CLAUDE.md) (V2 agent onboarding).*
