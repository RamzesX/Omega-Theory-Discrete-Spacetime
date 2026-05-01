"""Modal H100/A100 batch-embed for :ProofStep.goal_before strings.

Uses your existing Modal account (workspace 'ramzesx', already authenticated
at ~/.modal.toml). Faster + zero SSH vs RunPod.

Pipeline:
    1. modal run modal_embed.py::embed_jsonl --in-path goals_mathlib.jsonl
    2. Modal spins H100 (~30s cold start)
    3. Loads Qwen3-Embedding-8B (~30s with cache, ~3min first-time)
    4. Streams batched embeddings back to local
    5. Writes embeddings_mathlib.jsonl locally

Wall: ~5-8 min for 259K rows on H100. Cost: ~$0.30 ($2/hr × ~10min).

Setup (already done if ~/.modal.toml exists):
    pip install modal
    modal setup

Run:
    cd /home/norbert/lean-v2/.neo4j/cloud_embed_proof_steps
    /home/norbert/genai_env/bin/modal run modal_embed.py::embed_jsonl \\
        --in-path goals_mathlib.jsonl \\
        --out-path embeddings_mathlib.jsonl
"""
from __future__ import annotations

import json
import os
import sys
import time
from pathlib import Path

import modal

# ── Image: vLLM + Qwen3-Embedding-8B ────────────────────────────────────────
IMAGE = (
    modal.Image.debian_slim(python_version="3.11")
    .pip_install(
        "vllm==0.6.3",
        "transformers>=4.45",
        "torch==2.4.0",
        "huggingface_hub>=0.24",
        "httpx",
    )
    # Pre-download model at image build to avoid runtime download cost.
    .run_commands(
        "python -c \"from huggingface_hub import snapshot_download; "
        "snapshot_download('Qwen/Qwen3-Embedding-8B', "
        "cache_dir='/root/.cache/huggingface/hub')\"",
        gpu=None,  # CPU-only download is fine
    )
)

app = modal.App("omegatheory-proof-step-embed", image=IMAGE)

# ── Volume for caching model weights across runs ────────────────────────────
HF_CACHE_VOL = modal.Volume.from_name(
    "omegatheory-hf-cache", create_if_missing=True,
)

# ── Embedding task instruction (matches our Qwen3 [goal] task) ─────────────
GOAL_INSTRUCTION = (
    "Given a Lean 4 theorem signature treated as a proof goal, encode the "
    "goal-state context so that goals closable by analogous tactic prefixes "
    "produce nearby vectors."
)


@app.function(
    gpu="H100",
    image=IMAGE,
    volumes={"/root/.cache/huggingface": HF_CACHE_VOL},
    timeout=3600,  # 1 hour cap
    memory=32 * 1024,  # 32 GB host RAM
)
def embed_batch(rows: list[dict], batch_size: int = 64, max_chars: int = 1800) -> list[dict]:
    """Run vLLM embed on a chunk of rows. Returns rows with vec attached."""
    from vllm import LLM
    print(f"[embed_batch] received {len(rows)} rows, loading vLLM...", flush=True)
    t0 = time.time()
    llm = LLM(
        model="Qwen/Qwen3-Embedding-8B",
        task="embed",
        dtype="bfloat16",
        max_model_len=4096,
        gpu_memory_utilization=0.85,
        download_dir="/root/.cache/huggingface/hub",
    )
    load_time = time.time() - t0
    print(f"[embed_batch] vLLM loaded in {load_time:.0f}s; embedding...", flush=True)

    out = []
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i + batch_size]
        prompts = [
            f"Instruct: {GOAL_INSTRUCTION}\nQuery: {r['text'][:max_chars]}"
            for r in batch
        ]
        results = llm.embed(prompts)
        for rec, res in zip(batch, results):
            out.append({
                "id": rec["id"],
                "name": rec["name"],
                "step_idx": rec["step_idx"],
                "vec": res.outputs.embedding,
            })
        if (i // batch_size) % 20 == 0:
            elapsed = time.time() - t0
            done = i + len(batch)
            rate = done / max(elapsed - load_time, 1)
            print(f"  [{done}/{len(rows)}] rate={rate:.0f}/s", flush=True)
    elapsed = time.time() - t0
    print(f"[embed_batch] DONE: {len(out)} embeds in {elapsed:.0f}s "
          f"({len(out)/elapsed:.0f}/s incl load)", flush=True)
    return out


@app.local_entrypoint()
def embed_jsonl(
    in_path: str,
    out_path: str,
    chunk_size: int = 5000,
    batch_size: int = 64,
):
    """Run embedding pipeline: read JSONL → batch upload → save embeddings."""
    print(f"[local] reading {in_path}...")
    with open(in_path) as f:
        rows = [json.loads(line) for line in f if line.strip()]
    print(f"[local] {len(rows)} rows; chunking by {chunk_size} for Modal calls")

    t0 = time.time()
    written = 0
    chunks = [rows[i:i + chunk_size] for i in range(0, len(rows), chunk_size)]
    print(f"[local] {len(chunks)} chunks → spawning Modal H100...")

    with open(out_path, "w") as out_f:
        for ci, chunk in enumerate(chunks):
            print(f"[local] sending chunk {ci+1}/{len(chunks)} "
                  f"({len(chunk)} rows)...")
            embeds = embed_batch.remote(chunk, batch_size=batch_size)
            for e in embeds:
                out_f.write(json.dumps(e) + "\n")
                written += 1
            out_f.flush()
            elapsed = time.time() - t0
            print(f"  written {written}/{len(rows)} in {elapsed:.0f}s "
                  f"({written/elapsed:.0f}/s avg)")

    elapsed = time.time() - t0
    print(f"\n[local] DONE: {written} embeddings → {out_path} in {elapsed:.0f}s "
          f"(${elapsed/3600 * 2.50:.2f} cost @ $2.50/hr H100)")
