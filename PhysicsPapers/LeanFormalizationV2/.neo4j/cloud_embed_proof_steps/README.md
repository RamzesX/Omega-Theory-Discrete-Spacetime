# Cloud GPU embedding pipeline for :ProofStep.goal_before

Local AMD RX 9060 XT 16GB rate: ~14/s → 5h+ for 259K rows.

| Path | GPU | Wall | Cost | Setup |
|---|---|---|---|---|
| **Modal H100 (recommended)** ✓ already authenticated | H100 80GB | ~5-8 min | **~$0.30** | zero — `modal run modal_embed.py::embed_jsonl` |
| RunPod RTX 4090 spot | RTX 4090 | ~17 min | ~$0.12 | SSH+vLLM install (~15 min first time) |
| RunPod H100 spot | H100 | ~5 min | ~$0.40 | same SSH path |

User has `~/.modal.toml` configured (workspace `ramzesx`) → Modal is the
fastest path to results today. $30 budget = **100× margin**.

## Quick path — Modal (zero SSH)

### Modal pipeline (5-8 min total, ~$0.30)

```bash
cd /home/norbert/lean-v2/.neo4j/cloud_embed_proof_steps

# Step 1 (local, ~1 min) — export :ProofStep.goal_before to JSONL
OMEGA_NEO4J_PASSWORD=omegatheory2026 python3 01_export_goals.py \
  --namespace Mathlib --full-only --out goals_mathlib.jsonl

# Step 2 (Modal H100, ~5-8 min) — batch embed via vLLM
/home/norbert/genai_env/bin/modal run modal_embed.py::embed_jsonl \
  --in-path goals_mathlib.jsonl \
  --out-path embeddings_mathlib.jsonl

# Step 3 (local, ~1 min) — push to Neo4j + create vector index
OMEGA_NEO4J_PASSWORD=omegatheory2026 python3 03_load_embeddings.py \
  --in embeddings_mathlib.jsonl
```

That's it. After step 3, `proof_step_embedding_goal` vector index (4096-d
cosine) is ONLINE — unlocks tasks #36 (auto-tactic-suggest) and #39
(goal_to_proof_step Mode-3 kNN).

---

## Alternative paths (if Modal is unavailable)

### Step 1 — Export (LOCAL, ~1 min)

```bash
cd /home/norbert/lean-v2/.neo4j/cloud_embed_proof_steps
OMEGA_NEO4J_PASSWORD=omegatheory2026 python3 01_export_goals.py \
  --namespace Mathlib --full-only --out goals_mathlib.jsonl
# → ~250-300MB JSONL with ~259K records
```

### Step 2 — Upload to RunPod GPU pod

Recommended provider: **RunPod** (https://runpod.io) — easiest one-click
RTX 4090 with vLLM image. Alternative: Vast.ai (cheaper, less reliable).

Steps:
1. Spin up: RTX 4090 / A100 / H100 with vLLM template OR plain Ubuntu+CUDA
2. SSH in:
   ```bash
   # Install
   pip install vllm httpx
   # Start Qwen3-Embedding-8B server (downloads model ~16GB on first run, ~2 min)
   nohup python -m vllm.entrypoints.openai.api_server \
     --model Qwen/Qwen3-Embedding-8B \
     --task embed --dtype bfloat16 \
     --port 8000 --max-model-len 4096 \
     --gpu-memory-utilization 0.85 > vllm.log 2>&1 &
   # Wait ~2 min for model load, verify:
   curl http://localhost:8000/v1/models
   ```
3. Upload goals.jsonl + 02_cloud_embed.py to pod (scp / rsync / web upload)

## Step 3 — Run embedder on cloud (~17 min on RTX 4090)

```bash
# On cloud pod:
python3 02_cloud_embed.py \
  --in goals_mathlib.jsonl \
  --out embeddings_mathlib.jsonl \
  --url http://localhost:8000/v1/embeddings \
  --model Qwen3-Embedding-8B \
  --batch-size 64
# → embeddings_mathlib.jsonl ~4GB
```

## Step 4 — Download + load (LOCAL, ~5 min)

```bash
# Download (use scp / rsync / cloud provider's UI)
scp pod:embeddings_mathlib.jsonl ./

# Push to Neo4j + create vector index
OMEGA_NEO4J_PASSWORD=omegatheory2026 python3 03_load_embeddings.py \
  --in embeddings_mathlib.jsonl
# → ~3-5K writes/s = ~1-2 min for 259K
# → vector index `proof_step_embedding_goal` (4096-d cosine) ONLINE
```

## Verification

```bash
# Coverage check
OMEGA_NEO4J_PASSWORD=omegatheory2026 python3 -c "
from neo4j import GraphDatabase
d = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j','omegatheory2026'))
with d.session() as s:
    r = s.run('MATCH (ps:ProofStep) RETURN count(ps.embedding_goal) AS done, count(ps) AS total').single()
    print(f'embedding_goal: {r[\"done\"]:,}/{r[\"total\"]:,}')
    r = s.run('SHOW VECTOR INDEXES YIELD name, state WHERE name = \"proof_step_embedding_goal\"').single()
    print(f'index state: {r[\"state\"]}')
"
```

## Cost summary

| Step | Time | Cost |
|---|---|---|
| 1. Export local | 1 min | $0 |
| 2. Pod boot + vLLM init | 5 min | ~$0.04 |
| 3. Embed 259K rows | 17 min | ~$0.12 |
| 4. Download + load | 5 min | ~$0.04 |
| **Total** | **~30 min** | **~$0.20** |

$30 budget = **150× buffer**. You can repeat this for source-segmented OV2
(84K) and any future expansion at trivial cost.

## Unblocks

After the proof_step_embedding_goal index is ONLINE:
- Task #36: Auto-tactic-suggest MCP tool (kNN over goal-state corpus → top-3 tactics)
- Task #39: goal_to_proof_step Mode-3 (real semantic kNN replaces substring fallback)
