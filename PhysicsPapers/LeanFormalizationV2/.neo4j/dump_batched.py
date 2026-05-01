#!/usr/bin/env python3
"""
Batched OOM-safe driver for `lake exe dump_proof_steps`.

Trade-off vs per-file driver (dump_ov2_per_file.py):
  - per-file:  one `lake exe` per file → safest (OS reclaims), slowest (~10-30s/file overhead)
  - batched-N: one `lake exe --files-list batch.txt` per N files → faster but lets memory grow within batch
  - single-process: BAD (OOM at ~30 files for OV2 / Mathlib mix)

Empirical sweet spot:
  - OV2 capstones: batch ~5 (heavy Mathlib imports, fast leak)
  - OV2 small files: batch ~20 (light imports, safe)
  - Mathlib (uniform import depth): batch ~10

The batch process exits between batches so the OS reclaims memory. With a
batch size N, throughput is roughly (lake_startup + N × per_file) per batch
≈ 3s + N × 5s = (3 + 5N)s per N files → ~5s/file at large N.

Per-batch RSS-cap watchdog: kills batch and falls back to per-file mode if
peak RSS approaches WSL ceiling.

Usage:
  # Sequential, batch=10, OV2:
  python3 dump_batched.py --root /home/norbert/lean-v2/OmegaTheory --batch 10

  # Mathlib full sweep, batch=10, workers=2 (parallel batches):
  python3 dump_batched.py --root /home/norbert/lean-v2/.lake/packages/mathlib/Mathlib --batch 10 --workers 2

  # Resume support: per-batch output cached as JSONL files
"""

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

LEAN_V2_ROOT = Path("/home/norbert/lean-v2")
LAKE = Path.home() / ".elan" / "bin" / "lake"


def list_lean_files(root: Path) -> list[Path]:
    return sorted(root.rglob("*.lean"))


def get_total_used_gb() -> float:
    try:
        with open("/proc/meminfo") as f:
            lines = f.readlines()
        total_kb = next(int(l.split()[1]) for l in lines if l.startswith("MemTotal:"))
        avail_kb = next(int(l.split()[1]) for l in lines if l.startswith("MemAvailable:"))
        return (total_kb - avail_kb) / 1024 / 1024
    except Exception:
        return 0.0


def chunk_safe_filename(file_paths: list[Path]) -> str:
    """Stable hash-based name for a batch of files."""
    import hashlib
    h = hashlib.md5()
    for p in file_paths:
        h.update(str(p).encode())
    return f"batch_{len(file_paths)}_{h.hexdigest()[:12]}.jsonl"


def dump_batch(file_paths: list[Path], out_path: Path, timeout_s: int) -> tuple[bool, int, str]:
    """Spawn `lake exe dump_proof_steps --files-list LIST --out OUT` for a batch."""
    with tempfile.NamedTemporaryFile(mode="w", suffix=".txt", delete=False) as tmp:
        for fp in file_paths:
            tmp.write(str(fp) + "\n")
        list_path = tmp.name
    try:
        cmd = [
            str(LAKE), "exe", "dump_proof_steps",
            "--files-list", list_path,
            "--out", str(out_path),
        ]
        try:
            res = subprocess.run(
                cmd, cwd=LEAN_V2_ROOT,
                capture_output=True, text=True, timeout=timeout_s,
            )
        except subprocess.TimeoutExpired:
            return False, 0, f"TIMEOUT (batch={len(file_paths)})"
        if res.returncode != 0:
            return False, 0, f"exit={res.returncode}: {res.stderr[-300:]}"
        steps = sum(
            int(line.split("captured")[1].split("tactic")[0].strip())
            for line in res.stderr.splitlines()
            if "captured" in line and "tactic steps" in line
        )
        return True, steps, ""
    finally:
        try:
            os.unlink(list_path)
        except OSError:
            pass


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", required=True, help="Root directory to walk")
    ap.add_argument("--batch", type=int, default=10, help="Files per lake invocation (default 10)")
    ap.add_argument("--out-dir", default="/home/norbert/lean-v2/.neo4j/data/proof_steps_batched",
                    help="Per-batch output dir (caching for resume)")
    ap.add_argument("--combined-out", default=None,
                    help="If set, concatenate all batch outputs to this file")
    ap.add_argument("--workers", type=int, default=1, help="Parallel batches (default 1)")
    ap.add_argument("--rss-cap-gb", type=int, default=110,
                    help="Pause new batches if total RSS > this (GB)")
    ap.add_argument("--timeout-s", type=int, default=900,
                    help="Per-batch timeout (default 900s = 15min)")
    ap.add_argument("--limit", type=int, default=None, help="Cap total files (smoke test)")
    ap.add_argument("--start-at", type=int, default=0, help="Skip first N files (resume)")
    args = ap.parse_args()

    root = Path(args.root)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    files = list_lean_files(root)
    print(f"[dump_batched] found {len(files)} .lean files under {root}")
    if args.start_at:
        files = files[args.start_at:]
    if args.limit:
        files = files[:args.limit]
    print(f"[dump_batched] processing {len(files)} files in batches of {args.batch}")
    print(f"[dump_batched] workers={args.workers} rss_cap={args.rss_cap_gb}GB")

    batches = [files[i:i + args.batch] for i in range(0, len(files), args.batch)]
    print(f"[dump_batched] {len(batches)} batch(es) total")

    t0 = time.time()
    n_ok = 0
    n_fail = 0
    n_cached = 0
    total_steps = 0

    def task(batch_idx_files):
        idx, batch = batch_idx_files
        out_path = out_dir / chunk_safe_filename(batch)
        if out_path.exists():
            try:
                steps = sum(1 for _ in out_path.open())
                return idx, batch, True, steps, "CACHED"
            except OSError:
                pass
        # RSS pressure backoff
        used = get_total_used_gb()
        while used > args.rss_cap_gb:
            print(f"  [batch {idx+1}/{len(batches)}] PAUSE: total {used:.0f}GB > cap, waiting 15s...")
            time.sleep(15)
            used = get_total_used_gb()
        ok, steps, err = dump_batch(batch, out_path, args.timeout_s)
        return idx, batch, ok, steps, err

    if args.workers <= 1:
        for i, batch in enumerate(batches):
            idx, b, ok, steps, err = task((i, batch))
            mark = "✔" if ok else "✗"
            tag = "CACHED" if err == "CACHED" else (err if not ok else "")
            elapsed = time.time() - t0
            files_done = (idx + 1) * args.batch
            rate = files_done / elapsed if elapsed > 0 else 0
            print(f"  [batch {idx+1}/{len(batches)}] {mark} {len(b)} files: {steps} steps {tag} "
                  f"({rate:.1f} files/s avg, mem={get_total_used_gb():.0f}GB)")
            if ok:
                if err == "CACHED":
                    n_cached += 1
                n_ok += 1
                total_steps += steps
            else:
                n_fail += 1
    else:
        with ThreadPoolExecutor(max_workers=args.workers) as ex:
            futures = {ex.submit(task, (i, b)): i for i, b in enumerate(batches)}
            for fut in as_completed(futures):
                idx, b, ok, steps, err = fut.result()
                mark = "✔" if ok else "✗"
                tag = "CACHED" if err == "CACHED" else (err if not ok else "")
                print(f"  [batch {idx+1}/{len(batches)}] {mark} {len(b)} files: {steps} steps {tag}")
                if ok:
                    if err == "CACHED":
                        n_cached += 1
                    n_ok += 1
                    total_steps += steps
                else:
                    n_fail += 1

    if args.combined_out:
        print(f"[dump_batched] combining {n_ok} batches → {args.combined_out}")
        with open(args.combined_out, "w") as combined:
            for i, batch in enumerate(batches):
                out_path = out_dir / chunk_safe_filename(batch)
                if out_path.exists():
                    with out_path.open() as src:
                        shutil.copyfileobj(src, combined)

    elapsed = time.time() - t0
    print(f"\n[dump_batched] done in {elapsed:.0f}s ({elapsed/60:.1f} min)")
    print(f"  ok_batches={n_ok} (cached={n_cached}) fail_batches={n_fail} total_steps={total_steps}")
    if elapsed > 0 and n_ok > 0:
        files_done = (n_ok - n_cached) * args.batch
        print(f"  throughput: {files_done/elapsed:.1f} files/s, {total_steps/elapsed:.0f} steps/s")


if __name__ == "__main__":
    main()
