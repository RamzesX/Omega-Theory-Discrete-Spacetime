"""CPU-hosted BGE-reranker-v2-m3 REST server on port 7998.

Freed from GPU (which now hosts Qwen3-Embedding-8B all-in-one). Ryzen 9950X + 192 GB
RAM is plenty for a 568M-param reranker on CPU.

Endpoints:
  POST /v1/rerank   -- input {"query": str, "documents": [str], "top_n": int?}
                       output {"results": [{"index": i, "relevance_score": f}, ...]}
  GET  /healthz

Env vars:
  BGE_RERANKER_PATH (default ~/models/bge-reranker-v2-m3)
  BGE_RERANKER_PORT (default 7998)

Author: Nashira (agent), 2026-04-19
"""
import os
import time
import torch
from flask import Flask, request, jsonify
from transformers import AutoModelForSequenceClassification, AutoTokenizer

MODEL_PATH = os.environ.get(
    "BGE_RERANKER_PATH", os.path.expanduser("~/models/bge-reranker-v2-m3")
)
PORT = int(os.environ.get("BGE_RERANKER_PORT", "7998"))
MAX_LENGTH = int(os.environ.get("BGE_RERANKER_MAX_LENGTH", "1024"))
BATCH_MAX = int(os.environ.get("BGE_RERANKER_BATCH", "16"))
DEVICE = "cpu"  # explicitly CPU-only
# BF16 matches Qwen3-8B GPU precision (native Qwen3 training precision, FP32 range)
# Ryzen 9950X Zen 5 supports AVX-512 BF16 instructions natively — efficient on CPU
DTYPE = torch.bfloat16

app = Flask(__name__)
_tokenizer = None
_model = None


def load_singleton():
    global _tokenizer, _model
    if _model is None:
        print(
            f"[bge-rerank] Loading {MODEL_PATH} on {DEVICE}",
            flush=True,
        )
        t0 = time.time()
        _tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH)
        _model = AutoModelForSequenceClassification.from_pretrained(
            MODEL_PATH, torch_dtype=DTYPE
        )
        _model.to(DEVICE).eval()
        print(f"[bge-rerank] Loaded in {time.time()-t0:.1f}s, dtype={DTYPE}", flush=True)
    return _tokenizer, _model


@torch.inference_mode()
def score_pairs(pairs):
    tok, mdl = load_singleton()
    scores = []
    for i in range(0, len(pairs), BATCH_MAX):
        batch = pairs[i:i + BATCH_MAX]
        enc = tok(
            batch,
            return_tensors="pt",
            padding=True,
            truncation=True,
            max_length=MAX_LENGTH,
        ).to(DEVICE)
        logits = mdl(**enc).logits.view(-1).float().cpu().tolist()
        scores.extend(logits)
    return scores


@app.route("/healthz", methods=["GET"])
def healthz():
    return jsonify({
        "ok": True,
        "model_path": MODEL_PATH,
        "device": DEVICE,
        "max_length": MAX_LENGTH,
        "batch_max": BATCH_MAX,
    })


@app.route("/v1/rerank", methods=["POST"])
def rerank():
    data = request.get_json(force=True)
    query = data.get("query")
    documents = data.get("documents")
    top_n = data.get("top_n")
    if not isinstance(query, str) or not isinstance(documents, list):
        return jsonify({"error": "expected {query: str, documents: [str]}"}), 400
    t0 = time.time()
    pairs = [[query, doc] for doc in documents]
    scores = score_pairs(pairs)
    ranked = sorted(
        enumerate(scores), key=lambda x: x[1], reverse=True
    )
    if isinstance(top_n, int) and top_n > 0:
        ranked = ranked[:top_n]
    return jsonify({
        "results": [{"index": i, "relevance_score": s} for i, s in ranked],
        "model": "bge-reranker-v2-m3",
        "usage": {
            "num_pairs": len(pairs),
            "rerank_seconds": round(time.time() - t0, 3),
        },
    })


if __name__ == "__main__":
    load_singleton()
    print(f"[bge-rerank] Listening on 0.0.0.0:{PORT}", flush=True)
    app.run(host="0.0.0.0", port=PORT, threaded=True)
