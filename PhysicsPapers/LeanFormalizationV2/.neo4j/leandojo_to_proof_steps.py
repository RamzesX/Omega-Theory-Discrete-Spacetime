#!/usr/bin/env python3
"""
Transform LeanDojo benchmark JSON → load_proof_steps.py-compatible JSONL.

Replaces the FULL T1.3 (DumpProofSteps.lean) re-elaboration approach which
keeps OOM-killing WSL. Source: LeanDojo upstream-published benchmark
(https://zenodo.org/records/12740403, commit 29dcec074d... v17 of Mathlib4).

Per LeanDojo record:
  {
    "url":          "https://github.com/leanprover-community/mathlib4",
    "commit":       "29dcec074d...",
    "file_path":    "Mathlib/RingTheory/IntegralRestrict.lean",
    "full_name":    "Algebra.intTrace_eq_trace",
    "start":        [216, 1],
    "end":          [223, 81],
    "traced_tactics": [
      { "tactic": "ext x", "state_before": "...⊢ ...", "state_after": "..." },
      ...
    ]
  }

Output JSONL (one per tactic step) compatible with load_proof_steps.py:
  {
    "parent_thm":     <full_name>,
    "step_idx":       <0..N-1>,
    "tactic":         <tactic>,
    "tactic_kind":    "leandojo",  // marker
    "goal_before":    <state_before>,
    "goal_after":     <state_after>,
    "n_goals_before": <count from state_before>,
    "n_goals_after":  <count from state_after>,
    "file":           <file_path>,
    "line":           <start[0]>,
    "col":            <start[1]>
  }

Usage:
  python3 leandojo_to_proof_steps.py \
    --in-dir /home/norbert/datasets/leandojo/leandojo_benchmark_4/random/ \
    --out /home/norbert/lean-v2/.neo4j/data/proof_steps_leandojo.jsonl
"""

import argparse
import json
import sys
from pathlib import Path


def count_goals(state_str: str) -> int:
    """Count `⊢` occurrences as a proxy for active goals."""
    if not state_str or state_str.strip().lower() == "no goals":
        return 0
    return state_str.count("⊢")


def transform_record(rec: dict, out_handle) -> int:
    """Emit one JSONL line per traced tactic. Returns step count."""
    full_name = rec.get("full_name", "")
    file_path = rec.get("file_path", "")
    start = rec.get("start", [0, 0])
    line, col = (start + [0, 0])[:2]
    traced = rec.get("traced_tactics", [])
    n = 0
    for idx, tac in enumerate(traced):
        out = {
            "parent_thm": full_name,
            "step_idx": idx,
            "tactic": tac.get("tactic", ""),
            "tactic_kind": "leandojo",
            "goal_before": tac.get("state_before", ""),
            "goal_after": tac.get("state_after", ""),
            "n_goals_before": count_goals(tac.get("state_before", "")),
            "n_goals_after": count_goals(tac.get("state_after", "")),
            "file": file_path,
            "line": line,
            "col": col,
        }
        out_handle.write(json.dumps(out, ensure_ascii=False) + "\n")
        n += 1
    return n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in-dir", required=True, help="Directory with train/val/test.json")
    ap.add_argument("--out", required=True, help="Output JSONL path")
    ap.add_argument("--splits", default="train,val,test", help="Comma-separated splits to process")
    ap.add_argument("--limit", type=int, default=None, help="Cap total records (smoke test)")
    args = ap.parse_args()

    in_dir = Path(args.in_dir)
    splits = [s.strip() for s in args.splits.split(",") if s.strip()]

    total_thms = 0
    total_steps = 0
    skipped = 0

    with open(args.out, "w") as out_handle:
        for split in splits:
            in_path = in_dir / f"{split}.json"
            if not in_path.exists():
                print(f"  SKIP missing: {in_path}", file=sys.stderr)
                continue
            print(f"[leandojo→proof_steps] processing {split}: {in_path}")
            with in_path.open() as f:
                records = json.load(f)
            print(f"  {len(records)} theorems")
            for i, rec in enumerate(records):
                if args.limit and total_thms >= args.limit:
                    break
                if not rec.get("traced_tactics"):
                    skipped += 1
                    continue
                steps = transform_record(rec, out_handle)
                total_thms += 1
                total_steps += steps
                if total_thms % 5000 == 0:
                    print(f"  ... {total_thms} thms / {total_steps} steps")
            if args.limit and total_thms >= args.limit:
                break

    print(f"\n[leandojo→proof_steps] DONE")
    print(f"  Theorems: {total_thms}")
    print(f"  Steps:    {total_steps}")
    print(f"  Skipped:  {skipped} (no traced_tactics)")
    print(f"  Avg:      {total_steps/max(total_thms,1):.1f} steps/thm")
    print(f"  Out:      {args.out}")


if __name__ == "__main__":
    main()
