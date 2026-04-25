# Sage Briefing — W15 (T3-dump-arrows-perf, USER-MANDATED): dump_arrows perf optimization

**Cycle:** 59 (Scorpius) · **Sage:** Antares · **Date:** 2026-04-25
**Track:** T3 (research/infra) · **Risk:** L (DUAL-FILE WIZARD) · **Wave:** 1
**Target files:**
- `OmegaTheory/Meta/DumpArrows.lean` (Sheratan-owned — extending it; coordinated edit)
- `omega_orchestrator/pipeline.py` (orchestrator MCP — coordinated edit)

## Candidate name

`dump_arrows_perf_optimization_mathlib_cache_plus_task_spawn`

## Priority + complexity

HIGH (USER-MANDATED) · L (≈200-300 lines across 2 files)

## Mission

dump_arrows takes 16 minutes (76% of refresh time). Two compounding fixes:

**Fix 1 — Mathlib-arrow caching (10× target):** Mathlib v4.29 is fixed; the
arrow extraction over Mathlib's ~175K theorems re-runs every refresh wasting
~13 min of the 16. Add a CLI flag `--ov2-only` to `OmegaTheory/Meta/DumpArrows.lean`
that skips the Mathlib walk and emits arrows ONLY for OV2 declarations. The
loader (`omega_orchestrator/pipeline.py refresh_graph`) concatenates the
freshly-emitted OV2-only output with a cached
`arrows_from_env_jobgraph_mathlib.jsonl` (built ONCE on Mathlib version bump).
Cache invalidation: hash of `lean-toolchain` + `lakefile.toml` Mathlib pin —
when changes detected, full rebuild; else use cache.

**Fix 2 — Lean Task.spawn parallelization (3-5× target atop Fix 1):** Dump
loop is currently sequential. Wrap per-decl arrow extraction in
`Task.spawn` chunks of 100 decls; collect with `Task.get`. On the 9950X
(16P+16E), 32-way parallelism is achievable. Combined target: 16 min → ~1
min refresh time.

**Fix 3 — Skip multi-process sharding** (per user mandate). Don't add
multi-process worker pool; stay within single-process Lean dump.

## `statement_lean` skeleton (Fix 1 part)

For `OmegaTheory/Meta/DumpArrows.lean`, add CLI flag:

```lean
def dumpArrows (args : List String) : IO Unit := do
  let ov2_only := args.contains "--ov2-only"
  let env ← Lean.Elab.Frontend.elaborateTopLevelCommands
  let decls := env.constants.toList
  let filtered_decls :=
    if ov2_only then
      decls.filter (fun (n, _) => n.toString.startsWith "OmegaTheory.")
    else
      decls
  -- Existing Sheratan extraction logic continues, but with filtered_decls
  -- AND with Task.spawn batching (Fix 2):
  let chunks := filtered_decls.chunks 100
  let tasks := chunks.map (fun chunk => Task.spawn (fun () => extractArrows chunk env))
  let results := tasks.map Task.get
  let merged := results.flatten
  IO.println s!"Wrote {merged.length} arrows (ov2_only={ov2_only})"
```

## `pipeline.py` skeleton (Fix 1 + Fix 2 integration)

```python
# omega_orchestrator/pipeline.py — refresh_graph chain step 4 (dump_arrows)

def _dump_arrows_step(repo_root: Path, ov2_only: bool, mathlib_cache_path: Path) -> tuple[int, Path]:
    """Run dump_arrows with --ov2-only flag, concat with cached Mathlib JSONL."""
    cmd = [str(LAKE_BIN), 'env', 'lean', '--run',
           'OmegaTheory/Meta/DumpArrows.lean', '--ov2-only']
    ov2_output = run_lean_dump(cmd, repo_root)  # ~1 min instead of 16 min
    
    # Concat with Mathlib cache
    if not mathlib_cache_path.exists():
        # First-time cache build: dump full Mathlib without --ov2-only
        cmd_full = [str(LAKE_BIN), 'env', 'lean', '--run',
                    'OmegaTheory/Meta/DumpArrows.lean']  # no --ov2-only
        full_output = run_lean_dump(cmd_full, repo_root)
        mathlib_jsonl = filter_mathlib(full_output)
        mathlib_cache_path.write_bytes(mathlib_jsonl)
    
    cached_mathlib = mathlib_cache_path.read_bytes()
    merged_output = ov2_output + cached_mathlib
    
    final_path = repo_root / 'arrows_from_env_jobgraph.jsonl'
    final_path.write_bytes(merged_output)
    return len(merged_output.splitlines()), final_path
```

## Premise candidates (top-5)

1. `OmegaTheory/Meta/DumpArrows.lean` (Sheratan's existing dumper — extend, don't rewrite)
2. Lean 4 `Task.spawn` / `Task.get` API (`Init.System.Task`)
3. `omega_orchestrator/pipeline.py refresh_graph` chain (current sync version)
4. `lean-toolchain` + `lakefile.toml` for cache-invalidation hash
5. `arrows_from_env_jobgraph.jsonl` output schema (existing)

## Proof sketch (engineering)

- Add `ov2_only : Bool := false` parameter to `dumpArrows`
- Filter Mathlib decls when `ov2_only` is true via name-prefix check
- Wrap existing extraction loop in `Task.spawn` batches of 100
- Add `mathlib_cache_path` arg to `_dump_arrows_step` in pipeline.py
- Implement cache-invalidation: store SHA-256 of `lakefile.toml` + `lean-toolchain` in cache header
- Test with `~/lean-v2` native ext4: `time lake env lean --run OmegaTheory/Meta/DumpArrows.lean --ov2-only` → expect <1 min
- Test full refresh chain: `~$ time mcp__omega-orchestrator__refresh_graph(dry_run=False)` → expect <5 min total

## Off-limits

- `OmegaTheory/Meta/DumpDeclarations.lean` (Schedar's dumper — DO NOT touch)
- `OmegaTheory/Meta/DumpArrows.lean` is **OWNED BY THIS WIZARD ONLY** for cycle 59 — coordinate via SendMessage to parent if other wizards need related changes
- All cycle 52-58 wizard-owned files
- `OmegaTheory/Basic.lean`

## Build expectation

- `~/.elan/bin/lake build OmegaTheory.Meta.DumpArrows --log-level=error` GREEN
- `pytest omega_orchestrator/` 108/108 tests still GREEN
- Refresh test: `mcp__omega-orchestrator__refresh_graph(dry_run=True)` succeeds
- Production refresh test: `refresh_graph(dry_run=False)` <5 min end-to-end (vs current 21 min)

## Verification rubric

| Stage | Pre-W15 | Post-W15 (target) |
|---|---:|---:|
| dump_arrows duration | 954 s (~16 min) | <60 s (~1 min) |
| total refresh duration | 21 min | <5 min |
| Mathlib edges/refresh | re-extracted | cached JSONL |
| Lean parallel workers | 1 | 16-32 |

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'dump_arrows_perf_optimization_mathlib_cache_plus_task_spawn'})
ON CREATE SET tc.batch_id='scorpius_antares_cycle59_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T3',
              tc.target_file='OmegaTheory/Meta/DumpArrows.lean + omega_orchestrator/pipeline.py',
              tc.user_mandated=true,
              tc.created_at='2026-04-25', tc.created_by='Antares'
RETURN tc.name
```
