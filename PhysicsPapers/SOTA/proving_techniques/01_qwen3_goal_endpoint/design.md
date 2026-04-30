# Qwen3-Embedding-8B Goal-Endpoint Design

## Architecture (existing server, NEW endpoint)

```
┌──────────────────────────────────────────────────────────────────────┐
│  ~/lean-v2/V3-for-Lean/code/servers/qwen3_embedding_server.py        │
│  (FastAPI, port :7999, bf16, single GPU)                             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  GET  /                          → health check                      │
│  POST /v1/embeddings             → corpus embedding (existing)       │
│        prefix: [theorem]/[axiom]/[definition]/[instance]/...         │
│  POST /v1/goal_embeddings  ← NEW ─────────────────────────────────┐  │
│        prefix: [goal]                                             │  │
│        optional: instruction-aware (Qwen3 native capability)      │  │
└───────────────────────────────────────────────────────────────────┼──┘
                                                                    │
                  shared GPU model state (no re-load, no contention)
                                                                    │
            ┌──────────────────────────────────┴──────────────────┐
            │                                                     │
   Qwen3-Embedding-8B (:7999)              Qwen3-Reranker-8B (:7996)
   (THIS SERVER, embedder)                 (separate process, reranker)
   |   |   |                               |   |   |
   bf16  GPU  4096-d                       bf16  GPU  cross-encoder
            
   ↑ both concurrent on same GPU per user hardware setup ↑
```

## Input format (mirrors §4.2 of V3-for-Lean paper)

The corpus uses 6-token kind prefixes:
```
[axiom] || name || signature || docstring || proof_body
[definition] || ...
[instance] || ...
[namespace] || ...
[structure] || ...
[theorem] || ...
```

We extend with a 7th:
```
[goal] || goal_string
```

**Why a separate prefix**: the Qwen3 model is robust to instruction-formatted inputs; the prefix helps the model partition embedding space so goals cluster with semantically-similar theorem statements (not with arbitrary axiom names). Empirically (§6 of V3-for-Lean), the prefix scheme improves recall@20 by ~2-3 points.

## Code skeleton

```python
# Inside qwen3_embedding_server.py — add after existing /v1/embeddings handler

class GoalEmbeddingRequest(BaseModel):
    goals: List[str]
    instruction: Optional[str] = None
    batch_size: Optional[int] = 32

class GoalEmbeddingResponse(BaseModel):
    embeddings: List[List[float]]
    model: str
    prefix_token: str = "[goal]"
    throughput_qps: float

@app.post("/v1/goal_embeddings")
async def embed_goals(req: GoalEmbeddingRequest) -> GoalEmbeddingResponse:
    # Construct input strings with [goal] prefix + optional instruction
    if req.instruction:
        inputs = [f"Instruction: {req.instruction}\n[goal] {g}" for g in req.goals]
    else:
        inputs = [f"[goal] {g}" for g in req.goals]
    
    # Batch through existing model
    t0 = time.time()
    embeddings = []
    for i in range(0, len(inputs), req.batch_size):
        batch = inputs[i:i + req.batch_size]
        # Reuse existing tokenizer + model state
        with torch.inference_mode():
            tokens = tokenizer(batch, padding=True, truncation=True, 
                              max_length=32768, return_tensors="pt").to(device)
            out = model(**tokens)
            # Same pooling strategy as corpus embedding (mean over last layer)
            emb = mean_pool_last_hidden(out, tokens["attention_mask"])
            emb = F.normalize(emb, p=2, dim=1)
            embeddings.extend(emb.float().cpu().numpy().tolist())
    elapsed = time.time() - t0
    
    return GoalEmbeddingResponse(
        embeddings=embeddings,
        model="Qwen/Qwen3-Embedding-8B",
        prefix_token="[goal]",
        throughput_qps=len(req.goals) / max(elapsed, 0.001),
    )
```

## Instruction-aware mode

Qwen3-Embedding-8B's instruction-aware feature: prepend a natural-language instruction to condition the embedding on a specific task.

For our case:
- **Default goal embedding**: just `[goal] <stmt>` — for general semantic similarity
- **Premise-retrieval mode**: `Instruction: rate relevance of premises to this proof goal\n[goal] <stmt>` — biases embedding toward matching theorem statements that would be useful as proof premises
- **Tactic-suggestion mode**: `Instruction: find proofs that close goals like this one\n[goal] <stmt>` — biases toward matching :ProofStep nodes (after T1.3)

This unlocks **task-specific retrieval** without retraining the model — a key 2026 SOTA pattern (Qwen3 instruction-aware deployment).

## Verification

```bash
# Smoke test
curl -X POST http://localhost:7999/v1/goal_embeddings \
  -d '{"goals": ["⊢ ∀ x, x = x"]}' | jq '.embeddings[0] | length'
# Expected: 4096

# Throughput test (10 goals)
time curl -X POST http://localhost:7999/v1/goal_embeddings \
  -d '{"goals": ["G"+"1234567890"+"_"+i] for i in range(10)}' | jq '.throughput_qps'
# Expected: ~29 qps single batch
```

## Cross-namespace embedding test

```python
# Embed an OV2 goal, kNN against full Theorem corpus including Mathlib
from neo4j import GraphDatabase
import requests

resp = requests.post("http://localhost:7999/v1/goal_embeddings", json={
    "goals": ["⊢ rothIndex P q R ≤ t - Real.sqrt (↑m * ε)"]
})
goal_vec = resp.json()["embeddings"][0]

driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "..."))
with driver.session() as s:
    result = s.run("""
        CALL db.index.vector.queryNodes(
            'lean_retriever_embedding_theorem', 20, $vec
        ) YIELD node, score
        RETURN node.name, node.namespace, score
        ORDER BY score DESC
    """, vec=goal_vec)
    for r in result:
        print(r["node.namespace"], r["node.name"], r["score"])
```

Expected: top-20 mix of OV2 (rothIndex/Roth-related) + Mathlib (Polynomial.taylor, Real.sqrt_le_sqrt, etc.) — proves goal-embedding can retrieve premises across both namespaces.

## Throughput budget

- 17.5K OV2 + 175K Mathlib = ~193K theorems in corpus
- Vector index kNN over 4096-d cosine: ~5-15 ms per query
- Goal embedding via Qwen3: ~35 ms per goal (single)
- End-to-end latency for `goal_to_premises(goal, k=20)`: ~50ms

Acceptable for interactive prove-wizard use.
