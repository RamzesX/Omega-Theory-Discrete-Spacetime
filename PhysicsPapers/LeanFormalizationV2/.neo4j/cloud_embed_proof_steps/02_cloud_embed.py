#!/usr/bin/env python3
"""
Step 2 (CLOUD GPU): batch-embed JSONL via local Qwen3-Embedding-8B server.

Run on the rented GPU pod (RunPod / Vast / Lambda). Assumes vLLM or llama.cpp
serving Qwen3-Embedding-8B at http://localhost:8000 (or :7999 if matching our
local convention).

Reads goals.jsonl, batches 64 at a time, writes embeddings.jsonl with
{id, name, step_idx, vec[4096]} per line.

Pre-flight on cloud pod:
  pip install httpx tqdm
  # Start vLLM:
  python -m vllm.entrypoints.openai.api_server \\
      --model Qwen/Qwen3-Embedding-8B \\
      --task embed --dtype bfloat16 --port 8000 \\
      --max-model-len 4096 --gpu-memory-utilization 0.85

Usage on cloud:
  python3 02_cloud_embed.py \\
    --in goals.jsonl --out embeddings.jsonl \\
    --url http://localhost:8000/v1/embeddings \\
    --model Qwen3-Embedding-8B
"""
import argparse
import json
import sys
import time

import httpx


GOAL_TASK_INSTRUCTION = (
    "Given a Lean 4 theorem signature treated as a proof goal, encode the "
    "goal-state context so that goals closable by analogous tactic prefixes "
    "produce nearby vectors."
)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="input_file", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--url", default="http://localhost:8000/v1/embeddings")
    ap.add_argument("--model", default="Qwen3-Embedding-8B")
    ap.add_argument("--batch-size", type=int, default=64)
    ap.add_argument("--max-chars", type=int, default=1800)
    ap.add_argument("--start-at", type=int, default=0, help="Resume offset")
    args = ap.parse_args()

    rows = []
    with open(args.input_file) as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    if args.start_at:
        rows = rows[args.start_at:]
    print(f"[cloud_embed] {len(rows)} rows to embed (batch={args.batch_size})")

    client = httpx.Client(timeout=120.0)
    written = 0
    failed = 0
    t0 = time.time()
    mode = "a" if args.start_at else "w"

    with open(args.out, mode) as out_f:
        for i in range(0, len(rows), args.batch_size):
            batch = rows[i:i + args.batch_size]
            texts = [
                f"Instruct: {GOAL_TASK_INSTRUCTION}\nQuery: {r['text'][:args.max_chars]}"
                for r in batch
            ]
            try:
                r = client.post(args.url, json={"input": texts, "model": args.model})
                r.raise_for_status()
                data = r.json()["data"]
                vecs = [row["embedding"] for row in sorted(data, key=lambda d: d["index"])]
                for rec, vec in zip(batch, vecs):
                    out_f.write(json.dumps({
                        "id": rec["id"],
                        "name": rec["name"],
                        "step_idx": rec["step_idx"],
                        "vec": vec,
                    }) + "\n")
                written += len(batch)
            except Exception as e:
                print(f"  BATCH ERROR at offset {i}: {e}", file=sys.stderr)
                failed += len(batch)
            if written % 1000 == 0 and written > 0:
                elapsed = time.time() - t0
                rate = written / elapsed
                eta = (len(rows) - written) / rate if rate > 0 else 0
                print(f"  [{written}/{len(rows)}] rate={rate:.0f}/s eta={eta:.0f}s")
                out_f.flush()

    elapsed = time.time() - t0
    print(f"[cloud_embed] DONE: written={written} failed={failed} in {elapsed:.0f}s "
          f"({written/elapsed:.0f}/s)")


if __name__ == "__main__":
    main()
