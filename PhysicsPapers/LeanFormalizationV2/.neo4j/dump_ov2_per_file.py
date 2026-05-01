#!/usr/bin/env python3
"""
Per-file driver for `lake exe dump_proof_steps` over OV2 — OOM-safe.

Background: 2026-05-01 single-process whole-tree mode OOM-killed at 127GB RSS
(WSL ceiling 160GB, 0 swap). Each `processFile` call accumulates env mass
(loaded oleans + InfoTree pinning) without releasing across files. Per-file
process isolation lets the OS reclaim memory between files (~10-30s startup
penalty per file but bounded RSS).

Sequential by default (max RAM usage = single-file budget ~3-8GB). Optional
--workers N for parallel dispatch but watch total RSS; safe value on this
machine is N=2.

Resume support: skips files whose per-file output already exists.
Combined output appended atomically (each file complete-or-absent).

Usage:
  OMEGA_NEO4J_PASSWORD=... python3 dump_ov2_per_file.py
  OMEGA_NEO4J_PASSWORD=... python3 dump_ov2_per_file.py --root /custom/path
  OMEGA_NEO4J_PASSWORD=... python3 dump_ov2_per_file.py --workers 2 --rss-cap-gb 60
  OMEGA_NEO4J_PASSWORD=... python3 dump_ov2_per_file.py --resume
"""

import argparse
import os
import shutil
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

LEAN_V2_ROOT = Path("/home/norbert/lean-v2")
LAKE = Path.home() / ".elan" / "bin" / "lake"


def list_lean_files(root: Path) -> list[Path]:
    """Recursively enumerate .lean files under root."""
    return sorted(root.rglob("*.lean"))


def get_total_rss_gb() -> float:
    """Read total RSS of all current processes (rough memory pressure indicator)."""
    try:
        with open("/proc/meminfo") as f:
            for line in f:
                if line.startswith("MemAvailable:"):
                    avail_kb = int(line.split()[1])
                    total_kb = 0
                    f.seek(0)
                    for line2 in f:
                        if line2.startswith("MemTotal:"):
                            total_kb = int(line2.split()[1])
                            break
                    return (total_kb - avail_kb) / 1024 / 1024
    except Exception:
        return 0.0
    return 0.0


def dump_one(file_path: Path, out_path: Path, timeout_s: int = 600) -> tuple[bool, int, str]:
    """Spawn `lake exe dump_proof_steps --file PATH --out OUT`. Returns (ok, steps, error_msg)."""
    cmd = [
        str(LAKE), "exe", "dump_proof_steps",
        "--file", str(file_path),
        "--out", str(out_path),
    ]
    try:
        res = subprocess.run(cmd, cwd=LEAN_V2_ROOT, capture_output=True, text=True, timeout=timeout_s)
    except subprocess.TimeoutExpired:
        return False, 0, "TIMEOUT"
    if res.returncode != 0:
        return False, 0, f"exit={res.returncode}: {res.stderr[-200:]}"
    steps = 0
    for line in res.stderr.splitlines():
        if "captured" in line and "tactic steps" in line:
            try:
                steps = int(line.split("captured")[1].split("tactic")[0].strip())
            except (IndexError, ValueError):
                pass
            break
    return True, steps, ""


def safe_filename(file_path: Path, root: Path) -> str:
    """Convert /home/.../OmegaTheory/Foo/Bar.lean → Foo_Bar.jsonl."""
    rel = file_path.relative_to(root)
    return str(rel).replace("/", "_").replace(".lean", ".jsonl")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(LEAN_V2_ROOT / "OmegaTheory"),
                    help="Root directory to walk (default OmegaTheory/)")
    ap.add_argument("--out-dir", default="/home/norbert/lean-v2/.neo4j/data/proof_steps_per_file",
                    help="Per-file output dir")
    ap.add_argument("--combined-out", default="/home/norbert/lean-v2/.neo4j/data/proof_steps_ov2_perfile.jsonl",
                    help="Combined JSONL (concatenation of per-file outputs)")
    ap.add_argument("--workers", type=int, default=1,
                    help="Parallel workers (default 1; safe max ~2 on this 160GB WSL)")
    ap.add_argument("--rss-cap-gb", type=int, default=120,
                    help="Pause new dispatches if total system RSS exceeds this (GB)")
    ap.add_argument("--timeout-s", type=int, default=600,
                    help="Per-file timeout in seconds")
    ap.add_argument("--limit", type=int, default=None,
                    help="Cap total files processed (smoke test)")
    ap.add_argument("--start-at", type=int, default=0,
                    help="Skip first N files (resume by index)")
    ap.add_argument("--no-combined", action="store_true",
                    help="Skip writing combined JSONL")
    args = ap.parse_args()

    root = Path(args.root)
    if not root.exists():
        print(f"ERROR: root not found: {root}", file=sys.stderr)
        sys.exit(1)

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    files = list_lean_files(root)
    print(f"[dump_ov2_per_file] found {len(files)} .lean files under {root}")
    if args.start_at:
        files = files[args.start_at:]
        print(f"[dump_ov2_per_file] resume: skipping first {args.start_at}")
    if args.limit:
        files = files[:args.limit]
        print(f"[dump_ov2_per_file] limit: capping at {args.limit}")

    print(f"[dump_ov2_per_file] workers={args.workers} rss_cap={args.rss_cap_gb}GB timeout={args.timeout_s}s")
    print(f"[dump_ov2_per_file] out_dir={out_dir}")
    print(f"[dump_ov2_per_file] combined={args.combined_out if not args.no_combined else '(disabled)'}")

    t0 = time.time()
    total_steps = 0
    n_ok = 0
    n_fail = 0
    n_cached = 0

    def task(idx_file):
        idx, file_path = idx_file
        out_path = out_dir / safe_filename(file_path, root)
        if out_path.exists():
            try:
                return idx, file_path, True, sum(1 for _ in out_path.open()), "CACHED"
            except Exception:
                pass
        # RSS-pressure backoff: pause if memory tight.
        used = get_total_rss_gb()
        while used > args.rss_cap_gb:
            print(f"  [{idx+1}/{len(files)}] PAUSE: total RSS {used:.0f}GB > cap {args.rss_cap_gb}GB, waiting 10s...")
            time.sleep(10)
            used = get_total_rss_gb()
        ok, steps, err = dump_one(file_path, out_path, args.timeout_s)
        return idx, file_path, ok, steps, err

    if args.workers <= 1:
        for idx, file_path in enumerate(files):
            idx_file = (idx, file_path)
            i, fp, ok, steps, err = task(idx_file)
            mark = "✔" if ok else "✗"
            tag = "CACHED" if err == "CACHED" else (err if not ok else "")
            elapsed = time.time() - t0
            rate = (n_ok + 1) / elapsed if elapsed > 0 else 0
            print(f"  [{i+1}/{len(files)}] {mark} {fp.name}: {steps} steps {tag} ({rate:.2f} files/s, mem={get_total_rss_gb():.0f}GB)")
            if ok:
                if err == "CACHED":
                    n_cached += 1
                n_ok += 1
                total_steps += steps
            else:
                n_fail += 1
    else:
        with ThreadPoolExecutor(max_workers=args.workers) as ex:
            futures = {ex.submit(task, (i, fp)): (i, fp) for i, fp in enumerate(files)}
            for fut in as_completed(futures):
                i, fp, ok, steps, err = fut.result()
                mark = "✔" if ok else "✗"
                tag = "CACHED" if err == "CACHED" else (err if not ok else "")
                print(f"  [{i+1}/{len(files)}] {mark} {fp.name}: {steps} steps {tag}")
                if ok:
                    if err == "CACHED":
                        n_cached += 1
                    n_ok += 1
                    total_steps += steps
                else:
                    n_fail += 1

    # Combine if requested.
    if not args.no_combined:
        print(f"[dump_ov2_per_file] combining {n_ok} per-file outputs → {args.combined_out}")
        with open(args.combined_out, "w") as combined:
            for file_path in files:
                out_path = out_dir / safe_filename(file_path, root)
                if out_path.exists():
                    with out_path.open() as src:
                        shutil.copyfileobj(src, combined)

    elapsed = time.time() - t0
    print(f"\n[dump_ov2_per_file] done in {elapsed:.0f}s ({elapsed/60:.1f} min)")
    print(f"  ok={n_ok} (cached={n_cached}) fail={n_fail} total_steps={total_steps}")


if __name__ == "__main__":
    main()
