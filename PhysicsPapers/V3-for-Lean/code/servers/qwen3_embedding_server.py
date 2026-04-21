"""OpenAI-compatible REST server for Qwen3-Embedding-8B (BF16, GPU-resident).

Replaces the LeanDojo ByT5 retriever on port 7999. Dim = 4096, pooling = last-token
(Qwen3-Embedding convention), L2-normalized for cosine similarity.

BF16 chosen over FP16: Qwen3 family trained in BF16 mixed precision; same 16 bytes
per param but FP32 numerical range (8-bit exponent) -> safer for Unicode math tokens
that can produce exotic activation distributions. Verified BF16 works on RX 9060 XT
(gfx1200) under ROCm 7.2.1 + PyTorch 2.9.1.

Endpoints:
  POST /v1/embeddings  -- OpenAI-compatible
  GET  /healthz        -- liveness + VRAM stats

Env vars:
  QWEN3_MODEL_PATH (default ~/models/Qwen3-Embedding-8B)
  QWEN3_PORT       (default 7999)
  QWEN3_BATCH      (default 2)
  QWEN3_MAX_LENGTH (default 2048)

Author: Nashira (agent), 2026-04-19
"""
import os
import time
import torch
from flask import Flask, request, jsonify
from transformers import AutoModel, AutoTokenizer

os.environ.setdefault("PYTORCH_CUDA_ALLOC_CONF", "expandable_segments:True")

MODEL_PATH = os.environ.get(
    "QWEN3_MODEL_PATH", os.path.expanduser("~/models/Qwen3-Embedding-8B")
)
PORT = int(os.environ.get("QWEN3_PORT", "7999"))
BATCH_MAX = int(os.environ.get("QWEN3_BATCH", "2"))
MAX_LENGTH = int(os.environ.get("QWEN3_MAX_LENGTH", "2048"))
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
DTYPE = torch.bfloat16 if DEVICE == "cuda" else torch.float32

app = Flask(__name__)
_tokenizer = None
_model = None


def load_singleton():
    global _tokenizer, _model
    if _model is None:
        print(
            f"[qwen3-emb] Loading {MODEL_PATH}  device={DEVICE}  dtype={DTYPE}",
            flush=True,
        )
        t0 = time.time()
        _tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH, padding_side="left")
        _model = AutoModel.from_pretrained(
            MODEL_PATH,
            torch_dtype=DTYPE,
            trust_remote_code=True,
        )
        _model.to(DEVICE).eval()
        if DEVICE == "cuda":
            alloc = torch.cuda.memory_allocated() / 1e9
            total = torch.cuda.get_device_properties(0).total_memory / 1e9
            print(
                f"[qwen3-emb] Loaded in {time.time()-t0:.1f}s"
                f"  VRAM: {alloc:.2f}/{total:.2f} GB",
                flush=True,
            )
    return _tokenizer, _model


def last_token_pool(last_hidden_states: torch.Tensor, attention_mask: torch.Tensor) -> torch.Tensor:
    """Qwen3-Embedding uses last-token pooling.

    For left-padded inputs, last token is simply -1. For right-padded, it is the last
    non-pad position per-row. We use left padding (padding_side='left') so take [-1].
    """
    left_padding = (attention_mask[:, -1].sum() == attention_mask.shape[0])
    if left_padding:
        return last_hidden_states[:, -1]
    seq_lengths = attention_mask.sum(dim=1) - 1
    batch_size = last_hidden_states.shape[0]
    return last_hidden_states[
        torch.arange(batch_size, device=last_hidden_states.device), seq_lengths
    ]


@torch.inference_mode()
def encode(texts):
    tok, mdl = load_singleton()
    outs = []
    for i in range(0, len(texts), BATCH_MAX):
        batch = texts[i:i + BATCH_MAX]
        enc = tok(
            batch,
            return_tensors="pt",
            padding=True,
            truncation=True,
            max_length=MAX_LENGTH,
        ).to(DEVICE)
        out = mdl(**enc)
        pooled = last_token_pool(out.last_hidden_state, enc["attention_mask"])
        pooled = torch.nn.functional.normalize(pooled, p=2, dim=1)
        outs.append(pooled.detach().float().cpu())
        del enc, out, pooled
        if DEVICE == "cuda":
            torch.cuda.empty_cache()
    return torch.cat(outs, dim=0).tolist()


@app.route("/healthz", methods=["GET"])
def healthz():
    info = {
        "ok": True,
        "model_path": MODEL_PATH,
        "device": DEVICE,
        "dtype": str(DTYPE),
        "max_length": MAX_LENGTH,
        "batch_max": BATCH_MAX,
    }
    if DEVICE == "cuda" and torch.cuda.is_available():
        info["vram_allocated_gb"] = round(torch.cuda.memory_allocated() / 1e9, 2)
        info["vram_total_gb"] = round(
            torch.cuda.get_device_properties(0).total_memory / 1e9, 2
        )
    return jsonify(info)


@app.route("/v1/embeddings", methods=["POST"])
def embeddings():
    data = request.get_json(force=True)
    inp = data.get("input")
    if inp is None:
        return jsonify({"error": "missing 'input'"}), 400
    if isinstance(inp, str):
        inp = [inp]
    if not isinstance(inp, list) or not all(isinstance(x, str) for x in inp):
        return jsonify({"error": "'input' must be str or list[str]"}), 400
    t0 = time.time()
    vecs = encode(inp)
    dt = time.time() - t0
    return jsonify({
        "object": "list",
        "data": [
            {"object": "embedding", "index": i, "embedding": v}
            for i, v in enumerate(vecs)
        ],
        "model": data.get("model", "qwen3-embedding-8b"),
        "usage": {
            "prompt_tokens": sum(len(t) for t in inp),
            "total_tokens": sum(len(t) for t in inp),
            "encode_seconds": round(dt, 3),
        },
    })


if __name__ == "__main__":
    load_singleton()
    print(f"[qwen3-emb] Listening on 0.0.0.0:{PORT}", flush=True)
    app.run(host="0.0.0.0", port=PORT, threaded=False)
