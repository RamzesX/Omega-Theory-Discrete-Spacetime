#!/usr/bin/env python3
"""SOTA T6.9 — Progress predictor tiny MLP.

Trains a 2-layer MLP on (goal_embedding, tactics_count) to predict the
total number of tactics needed to close a goal. Source: LeanProgress
(arXiv 2502.17925).

Architecture (deliberately tiny):
    Input:   4096-d Qwen3 embedding
    Hidden:  256-d ReLU
    Output:  1 scalar (regression to log1p(tactics_count) for skew handling)
    Total params: ~1.05M

Training: Huber loss on log-space; AdamW; 50 epochs; batch 64; 80/20 split.

USAGE:
    python3 progress_predictor_model.py train [--data PATH] [--epochs N] [--out MODEL.pt]
    python3 progress_predictor_model.py eval  [--model MODEL.pt] [--data PATH]
    python3 progress_predictor_model.py infer [--model MODEL.pt] --emb-json '[4096 floats]'

REQUIRES: torch (pip install torch — CPU-only is fine, model is tiny).
"""
from __future__ import annotations

import argparse
import json
import math
import os
import sys
from pathlib import Path

import numpy as np


def import_torch():
    try:
        import torch
        import torch.nn as nn
        return torch, nn
    except ImportError:
        print("ERROR: torch not installed. Run: pip install torch", file=sys.stderr)
        sys.exit(2)


def build_model():
    torch, nn = import_torch()

    class TinyMLP(nn.Module):
        def __init__(self, in_dim=4096, hidden=256, out_dim=1, dropout=0.1):
            super().__init__()
            self.net = nn.Sequential(
                nn.Linear(in_dim, hidden),
                nn.ReLU(),
                nn.Dropout(dropout),
                nn.Linear(hidden, hidden),
                nn.ReLU(),
                nn.Dropout(dropout),
                nn.Linear(hidden, out_dim),
            )

        def forward(self, x):
            return self.net(x).squeeze(-1)

    return TinyMLP


def train_cmd(args):
    torch, nn = import_torch()
    TinyMLP = build_model()

    data_path = Path(args.data)
    npz = np.load(data_path, allow_pickle=True)
    X, y = npz["X"], npz["y"]
    print(f"Loaded {X.shape} samples. tactics: min={y.min()} max={y.max()} mean={y.mean():.2f}")

    # Log-space target (handles skew)
    y_log = np.log1p(y).astype(np.float32)

    # 80/20 split (deterministic)
    np.random.seed(42)
    perm = np.random.permutation(len(y))
    split = int(0.8 * len(y))
    train_idx, val_idx = perm[:split], perm[split:]

    Xt = torch.from_numpy(X[train_idx]).float()
    yt = torch.from_numpy(y_log[train_idx]).float()
    Xv = torch.from_numpy(X[val_idx]).float()
    yv = torch.from_numpy(y_log[val_idx]).float()

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"device={device}, train={Xt.shape[0]}, val={Xv.shape[0]}")

    model = TinyMLP().to(device)
    opt = torch.optim.AdamW(model.parameters(), lr=1e-3, weight_decay=1e-4)
    loss_fn = nn.HuberLoss(delta=0.5)

    bs = args.batch
    best_val = float("inf")

    for epoch in range(args.epochs):
        model.train()
        perm = torch.randperm(Xt.shape[0])
        train_loss = 0.0
        for i in range(0, Xt.shape[0], bs):
            idx = perm[i:i+bs]
            xb = Xt[idx].to(device)
            yb = yt[idx].to(device)
            pred = model(xb)
            loss = loss_fn(pred, yb)
            opt.zero_grad()
            loss.backward()
            opt.step()
            train_loss += loss.item() * len(idx)
        train_loss /= Xt.shape[0]

        model.eval()
        with torch.no_grad():
            val_pred = model(Xv.to(device))
            val_loss = loss_fn(val_pred, yv.to(device)).item()
            # Convert back to count-space MAE
            val_pred_count = torch.expm1(val_pred).cpu().numpy()
            val_true_count = np.expm1(yv.numpy())
            val_mae = np.mean(np.abs(val_pred_count - val_true_count))

        if val_loss < best_val:
            best_val = val_loss
            torch.save(model.state_dict(), args.out)

        if (epoch + 1) % 5 == 0 or epoch == args.epochs - 1:
            print(f"  epoch {epoch+1:3d}/{args.epochs}  train={train_loss:.4f}  "
                  f"val_huber={val_loss:.4f}  val_mae_count={val_mae:.2f}")

    print(f"\nSaved best model → {args.out} (val_huber={best_val:.4f})")


def eval_cmd(args):
    torch, nn = import_torch()
    TinyMLP = build_model()
    npz = np.load(args.data, allow_pickle=True)
    X, y = npz["X"], npz["y"]
    y_log = np.log1p(y).astype(np.float32)

    np.random.seed(42)
    perm = np.random.permutation(len(y))
    val_idx = perm[int(0.8 * len(y)):]
    Xv = torch.from_numpy(X[val_idx]).float()
    yv = torch.from_numpy(y_log[val_idx]).float()
    yv_count = np.expm1(yv.numpy())

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = TinyMLP().to(device)
    model.load_state_dict(torch.load(args.model, map_location=device))
    model.eval()

    with torch.no_grad():
        pred_log = model(Xv.to(device))
        pred_count = torch.expm1(pred_log).cpu().numpy()

    mae = np.mean(np.abs(pred_count - yv_count))
    rmse = math.sqrt(np.mean((pred_count - yv_count) ** 2))
    rho = np.corrcoef(pred_count, yv_count)[0, 1]
    print(f"Val N={len(yv)}  MAE={mae:.2f}  RMSE={rmse:.2f}  ρ={rho:.3f}")
    print(f"Sample predictions (first 10):")
    for i in range(min(10, len(yv))):
        print(f"  pred={pred_count[i]:5.1f}  true={yv_count[i]:5.1f}")


def infer_cmd(args):
    torch, _ = import_torch()
    TinyMLP = build_model()
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = TinyMLP().to(device)
    model.load_state_dict(torch.load(args.model, map_location=device))
    model.eval()

    emb = json.loads(args.emb_json) if args.emb_json else None
    if not emb or len(emb) != 4096:
        print("ERROR: --emb-json must be a 4096-element float list", file=sys.stderr)
        sys.exit(2)

    x = torch.tensor([emb], dtype=torch.float32).to(device)
    with torch.no_grad():
        pred_log = model(x)
        pred_count = float(torch.expm1(pred_log).item())
    print(f"predicted_tactics_remaining = {pred_count:.2f}")


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)

    t = sub.add_parser("train")
    t.add_argument("--data", default=str(Path(__file__).parent / "progress_predictor_dataset.npz"))
    t.add_argument("--epochs", type=int, default=50)
    t.add_argument("--batch", type=int, default=64)
    t.add_argument("--out", default=str(Path(__file__).parent / "progress_predictor.pt"))

    e = sub.add_parser("eval")
    e.add_argument("--data", default=str(Path(__file__).parent / "progress_predictor_dataset.npz"))
    e.add_argument("--model", default=str(Path(__file__).parent / "progress_predictor.pt"))

    i = sub.add_parser("infer")
    i.add_argument("--model", default=str(Path(__file__).parent / "progress_predictor.pt"))
    i.add_argument("--emb-json", required=True)

    args = ap.parse_args()
    {"train": train_cmd, "eval": eval_cmd, "infer": infer_cmd}[args.cmd](args)


if __name__ == "__main__":
    main()
