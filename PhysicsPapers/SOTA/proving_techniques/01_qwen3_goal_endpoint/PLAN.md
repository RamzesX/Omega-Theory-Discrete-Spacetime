# T2 — Qwen3-Embedding-8B Goal-Embedding Endpoint

**Status**: TODO Day 2-3
**Effort**: ~120 lines Python on existing :7999 server
**Depends on**: nothing (independent track)

## Goal

Add a NEW endpoint to the existing Qwen3-Embedding-8B server (already running at port :7999, bf16, ~29 declarations/sec) that accepts **proof-goal strings** (current Lean cursor state) and returns 4096-d embeddings.

This is the foundation for **LIVE goal → premise retrieval** — the LeanDojo-tier capability missing from our current pipeline.

## Why this unlocks SOTA

Currently:
- Qwen3 embeds **theorem corpus** (`[kind] || name || signature || docstring || proof_body`)
- `find_similar` works theorem-name → similar-theorem
- We have NO way to ask "given my CURRENT goal-state, what theorems are similar to it?"

After T2:
- Qwen3 embeds **proof goals** with prefix `[goal]`
- `goal_to_premises` MCP (T4.2) takes a goal string → returns top-K most-similar Theorems from the entire corpus (OV2 + Mathlib, 184K+ theorems)
- Provides **active-proof-time retrieval** during `lake build` failures

Hardware advantage (per user reminder): GPU runs Qwen3-Embedding-8B (:7999) AND Qwen3-Reranker-8B (:7996) **CONCURRENTLY**. Goal embedding adds zero contention since the embedder process already exists.

## Endpoint specification

```
POST http://localhost:7999/v1/goal_embeddings
Content-Type: application/json

{
  "goals": [
    "⊢ ∀ q : Fin m → ℚ, rothIndex P q R ≤ t - √(m·ε)",
    "⊢ ∃ J : Fin m → ℕ, aeval q (multiIteratedPDeriv J P) ≠ 0",
    ...
  ],
  "instruction": "rate relevance of premises to this proof goal"  // optional, for instruction-aware
}

→ 200 OK
{
  "embeddings": [[float×4096], [float×4096], ...],
  "model": "Qwen/Qwen3-Embedding-8B",
  "prefix_token": "[goal]",
  "throughput_qps": 29.4
}
```

## Implementation

Edit `~/lean-v2/V3-for-Lean/code/servers/qwen3_embedding_server.py` (find via `find /home/norbert/lean-v2 -name "qwen3*server*.py"`).

Add ~120 lines:

1. **New endpoint handler** `/v1/goal_embeddings`
2. **Input transformation**: prepend `[goal] ` token to each input string (mirrors the `[theorem]/[axiom]/...` 6-token prefix scheme in §4.2 of V3-for-Lean paper)
3. **Reuse existing model state** — same bf16 model, same tokenizer, same GPU memory
4. **Optional instruction-aware mode**: if `instruction` field present, prepend the instruction string before the goal (matches Qwen3-Embedding-8B's instruction-aware capability)
5. **Throughput**: identical to corpus embedding (~29 goals/sec single batch, ~600/sec with batching)

## Verification

```bash
curl -X POST http://localhost:7999/v1/goal_embeddings \
  -H "Content-Type: application/json" \
  -d '{"goals":["⊢ ∀ x, x = x", "⊢ Real.sqrt 2 ∉ ℚ"]}'
```

Expected: 200 OK with two 4096-d float arrays. Validate dimensions + L2 norm ≈ 1 (model is normalized output).

## Files modified

- `~/lean-v2/V3-for-Lean/code/servers/qwen3_embedding_server.py` (~120 lines added)

## Files created

None — endpoint added to existing server.

## Co-existence checks

- Reranker port 7996 untouched (independent process; user confirmed both run concurrently)
- Existing `/v1/embeddings` endpoint untouched (corpus reembedding still works)
- No GPU-memory increase (same model loaded once)

## Sources

- V3-for-Lean §4.2 — input prefix scheme `[axiom] [definition] [instance] [namespace] [structure] [theorem]`; we extend with `[goal]`
- Qwen3-Embedding-8B docs — instruction-aware mode supports task-specific prompts
- LeanDojo (arXiv 2306.15626) — reference architecture for goal-state retrieval
