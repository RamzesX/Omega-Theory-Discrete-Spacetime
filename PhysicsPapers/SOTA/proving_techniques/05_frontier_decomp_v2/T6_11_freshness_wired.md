# T6.11 — LEGO-Prover library-freshness boost WIRED into omega_hammer

**Status**: LIVE 2026-04-30 / 2026-05-01
**Priority**: Tier-99 quick win
**Lines**: ~10 across 3 files

## What changed

`compose_score` in `omega_orchestrator.retrieval` now adds a freshness term:

```python
if cfg.w_freshness > 0:
    s += cfg.w_freshness * row.freshness
```

`RetrievalRow.freshness ∈ [0, 1]` is fetched from `Theorem.freshness` (set by
`set_difficulty_and_freshness.cypher` as `exp(-(now - env_dumped_at)/7d)`).

`RetrievalConfig.w_freshness` defaults to **0.0** — no behavior change in
default profile. Enable per-profile (e.g., tier2 / lean) to bias toward
recently-landed theorems, mitigating the canonical "old proofs dominate
retrieval" failure mode.

## Files touched

| File | Δ |
|---|---|
| `omega_orchestrator/profile.py` | +1 line `w_freshness` to RetrievalConfig + parser |
| `omega_orchestrator/retrieval.py` | +1 line `freshness` to RetrievalRow |
|  | +1 line freshness fetch in `attach_graph_signals` Cypher |
|  | +2 lines freshness term in `compose_score` |

## Smoke test (passed 2026-05-01)

```
default w_fresh=0: score=0.7000
with w_fresh=0.2:  score=0.8000
delta:             0.1000 (expected 0.2*0.5=0.10)
PASS
```

## Tuning recommendation

| Profile | w_freshness | Rationale |
|---|---|---|
| default | 0.0 | Stability — stable retrieval rankings for old proofs |
| lean | 0.15 | Mild bias toward recent landings; not enough to displace strong cosine matches |
| tier2 | 0.30 | Aggressive freshness — for active research where prior week's commits matter |

Freshness decay constant is 7 days (set in `set_difficulty_and_freshness.cypher`).
That means a theorem committed 1 week ago has freshness ~0.37, 2 weeks → ~0.14.

## Authority

- LEGO-Prover paper (arXiv:2310.00656) — library growing for theorem proving
- `~/.claude/plans/binary-painting-dijkstra.md` T6.11
- T1.1 difficulty proxy commit 75402f0 (sets the `freshness` column on each Theorem)
