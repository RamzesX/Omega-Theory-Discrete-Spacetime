# Dependencies for SOTA T6.9 progress predictor

## Required packages

| Package | Version | Purpose |
|---|---|---|
| `numpy` | ≥1.24 | dataset arrays, training tensors |
| `neo4j` | ≥5.20 | dataset extraction from live graph |
| `requests` | ≥2.30 | embedding server HTTP client |
| `torch` | ≥2.9 (with ROCm/CUDA) | MLP training + inference |

## Installation

**Recommended**: use the existing `genai_env` virtualenv (already has torch + ROCm 7.2.1):

```bash
/home/norbert/genai_env/bin/python3 progress_predictor_dataset.py --limit 10000
/home/norbert/genai_env/bin/python3 progress_predictor_model.py train --epochs 50
/home/norbert/genai_env/bin/python3 progress_predictor_model.py eval
```

**Alternative** (system pip blocked by PEP 668):
```bash
# Override system protection (NOT recommended in WSL2)
pip3 install --user --break-system-packages torch numpy neo4j requests

# Or create a fresh venv
python3 -m venv ~/sota-env
~/sota-env/bin/pip install torch numpy neo4j requests
```

## Why genai_env is preferred

- Already used by orchestrator MCP pytest suite (`/home/norbert/genai_env/bin/pytest`)
- Has GPU-enabled torch with ROCm 7.2.1 for AMD RX 9060 XT 16GB
- Avoids PEP 668 conflicts on the system Python 3.12

## Smoke run (current results, 2000 samples)

```
Loaded (2000, 4096) samples. tactics: min=1 max=10 mean=2.19
device=cuda, train=1600, val=400
  epoch  30/30  train=0.0113  val_huber=0.0852  val_mae_count=1.16
Saved best model → progress_predictor.pt (val_huber=0.0789)
```

Slight overfit (train 0.011 vs val 0.079); expected for 2K samples + 1M-param MLP.

**Next-fire**: re-train on full 10K-17K OV2 sample after `embedding_goal` backfill
completes — goal-only embeddings should give cleaner signal than the
proof-cluttered `embedding_lean` we currently use.
