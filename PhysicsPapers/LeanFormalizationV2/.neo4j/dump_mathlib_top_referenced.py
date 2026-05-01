#!/usr/bin/env python3
"""
Dump Mathlib proof steps for the top-N most-referenced files (by OV2 APPLIES).

Strategy: instead of dumping ALL of Mathlib (~3000 files, ~8-25h), dump only
the Mathlib files that OV2 theorems actually depend on. With 1731 distinct
referenced files, top-200 covers >80% of OV2's actual Mathlib usage.

Each invocation of `dump_proof_steps --file PATH` pays its own ~2-5 min import
overhead but the OLEAN cache persists, so file 2..N are faster than file 1.

Usage:
  OMEGA_NEO4J_PASSWORD=... python3 dump_mathlib_top_referenced.py --top 200 --out-dir /tmp/mathlib_proof_steps/
"""

import argparse
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

from neo4j import GraphDatabase

LEAN_V2_ROOT = Path("/home/norbert/lean-v2")
MATHLIB_ROOT = LEAN_V2_ROOT / ".lake" / "packages" / "mathlib"
LAKE = Path.home() / ".elan" / "bin" / "lake"


def get_top_referenced_mathlib_files(driver, top_n: int) -> list[tuple[str, int]]:
    """Return list of (file_path, n_theorems_used) ranked by OV2 APPLIES."""
    cy = """
    MATCH (mt:Theorem {namespace: 'Mathlib'})
    WHERE EXISTS { MATCH (ovt:Theorem {namespace: 'OmegaTheoryV2'})-[:APPLIES]->(mt) }
      AND mt.file IS NOT NULL
    WITH mt.file AS file, count(DISTINCT mt) AS n
    ORDER BY n DESC LIMIT $top
    RETURN file, n
    """
    with driver.session() as sess:
        return [(r["file"], r["n"]) for r in sess.run(cy, top=top_n)]


def resolve_module_to_path(module_name: str) -> Path | None:
    """Module name like `Mathlib.Algebra.Group.Defs` → filesystem path."""
    rel = module_name.replace(".", "/") + ".lean"
    candidate = MATHLIB_ROOT / rel
    if candidate.exists():
        return candidate
    return None


def dump_one_file(file_path: Path, out_path: Path) -> tuple[bool, int]:
    """Run `lake exe dump_proof_steps --file <PATH> --out <OUT>`. Returns (ok, steps)."""
    cmd = [
        str(LAKE), "exe", "dump_proof_steps",
        "--file", str(file_path),
        "--out", str(out_path),
    ]
    res = subprocess.run(cmd, cwd=LEAN_V2_ROOT, capture_output=True, text=True, timeout=600)
    if res.returncode != 0:
        return False, 0
    # Parse stderr for step count.
    steps = 0
    for line in res.stderr.splitlines():
        if "captured" in line and "tactic steps" in line:
            try:
                steps = int(line.split("captured")[1].split("tactic")[0].strip())
            except (IndexError, ValueError):
                pass
            break
    return True, steps


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--top", type=int, default=200, help="Top-N most-referenced Mathlib files")
    ap.add_argument("--out-dir", default="/tmp/mathlib_proof_steps", help="Per-file JSONL output dir")
    ap.add_argument("--combined-out", default=None, help="If set, concatenate all output to this single JSONL")
    ap.add_argument("--neo4j-uri", default="bolt://localhost:7687")
    ap.add_argument("--neo4j-user", default="neo4j")
    ap.add_argument("--start-at", type=int, default=0, help="Skip first N files (resume)")
    args = ap.parse_args()

    pwd = os.environ.get("OMEGA_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD")
    if not pwd:
        print("ERROR: OMEGA_NEO4J_PASSWORD env var required", file=sys.stderr)
        sys.exit(1)

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    driver = GraphDatabase.driver(args.neo4j_uri, auth=(args.neo4j_user, pwd))
    print(f"[dump_mathlib_top] querying top-{args.top} referenced Mathlib files...")
    top_files = get_top_referenced_mathlib_files(driver, args.top)
    driver.close()
    print(f"[dump_mathlib_top] got {len(top_files)} files")

    t0 = time.time()
    total_steps = 0
    n_ok = 0
    n_fail = 0
    n_skipped = 0
    n_resolved = 0
    combined_handle = None
    if args.combined_out:
        combined_handle = open(args.combined_out, "w")

    for idx, (module_name, n_used) in enumerate(top_files):
        if idx < args.start_at:
            continue
        path = resolve_module_to_path(module_name)
        if path is None:
            print(f"  [{idx+1}/{len(top_files)}] SKIP (not found): {module_name}")
            n_skipped += 1
            continue
        n_resolved += 1
        out_path = out_dir / f"mathlib_{idx:04d}_{module_name.replace('.', '_')}.jsonl"
        if out_path.exists():
            print(f"  [{idx+1}/{len(top_files)}] CACHED: {module_name}")
            if combined_handle:
                with out_path.open() as src:
                    shutil.copyfileobj(src, combined_handle)
            n_ok += 1
            continue
        print(f"  [{idx+1}/{len(top_files)}] dump ({n_used} OV2-cited): {module_name}")
        try:
            ok, steps = dump_one_file(path, out_path)
            if ok:
                n_ok += 1
                total_steps += steps
                if combined_handle and out_path.exists():
                    with out_path.open() as src:
                        shutil.copyfileobj(src, combined_handle)
                elapsed = time.time() - t0
                rate = total_steps / elapsed if elapsed > 0 else 0
                print(f"    +{steps} steps (total: {total_steps}, rate: {rate:.0f}/s)")
            else:
                n_fail += 1
                print(f"    FAILED")
        except subprocess.TimeoutExpired:
            n_fail += 1
            print(f"    TIMEOUT (>600s)")

    if combined_handle:
        combined_handle.close()

    elapsed = time.time() - t0
    print(f"\n[dump_mathlib_top] done in {elapsed:.0f}s")
    print(f"  ok={n_ok}  fail={n_fail}  skipped={n_skipped}  total_steps={total_steps}")
    print(f"  per-file dir: {out_dir}")
    if args.combined_out:
        print(f"  combined:     {args.combined_out}")


if __name__ == "__main__":
    main()
