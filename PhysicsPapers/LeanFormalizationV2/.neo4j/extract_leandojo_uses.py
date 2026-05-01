#!/usr/bin/env python3
"""
Extract :USES edges from LeanDojo annotated_tactic premise lists.

Each tactic in LeanDojo's traced_tactics has an `annotated_tactic[1]` list of
premise dicts: [{full_name, def_path, def_pos, def_end_pos}, ...]. These are
the LEMMAS / DEFINITIONS / CLASSES that the tactic invokes.

This extractor produces JSONL records of the form:
  {"parent_thm": <theorem>, "step_idx": <i>, "premise": <full_name>, "premise_file": <path>}

Then the loader creates :USES edges from :ProofStep → :Theorem|:Definition,
matching by exact name OR bare-suffix (same fallback as load_proof_steps.py).

Output: ~500K-1M edges (avg 2-4 premises per tactic step × 259K steps).

Usage:
  python3 extract_leandojo_uses.py \
    --in-dir /home/norbert/datasets/leandojo/leandojo_benchmark_4/random/ \
    --out /home/norbert/lean-v2/.neo4j/data/leandojo_uses.jsonl
"""

import argparse
import json
import sys
from pathlib import Path


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in-dir", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--splits", default="train,val,test")
    args = ap.parse_args()

    in_dir = Path(args.in_dir)
    splits = [s.strip() for s in args.splits.split(",") if s.strip()]

    total_thms = 0
    total_steps = 0
    total_edges = 0

    with open(args.out, "w") as out_f:
        for split in splits:
            in_path = in_dir / f"{split}.json"
            if not in_path.exists():
                print(f"  SKIP missing: {in_path}", file=sys.stderr)
                continue
            print(f"[uses] processing {split}: {in_path}")
            with in_path.open() as f:
                records = json.load(f)
            print(f"  {len(records)} theorems")
            for rec in records:
                full_name = rec.get("full_name", "")
                traced = rec.get("traced_tactics", [])
                if not traced:
                    continue
                total_thms += 1
                for step_idx, tac in enumerate(traced):
                    total_steps += 1
                    anno = tac.get("annotated_tactic", [])
                    if not (isinstance(anno, list) and len(anno) >= 2 and isinstance(anno[1], list)):
                        continue
                    for premise in anno[1]:
                        if not isinstance(premise, dict):
                            continue
                        pname = premise.get("full_name", "")
                        if not pname:
                            continue
                        out_f.write(json.dumps({
                            "parent_thm": full_name,
                            "step_idx": step_idx,
                            "premise": pname,
                            "premise_file": premise.get("def_path", ""),
                        }) + "\n")
                        total_edges += 1
                if total_thms % 10000 == 0:
                    print(f"  ... {total_thms} thms / {total_steps} steps / {total_edges} premise refs")

    print(f"\n[uses] DONE")
    print(f"  Theorems: {total_thms}")
    print(f"  Steps:    {total_steps}")
    print(f"  Premise refs: {total_edges}")
    print(f"  Avg refs/step: {total_edges/max(total_steps,1):.1f}")
    print(f"  Out: {args.out}")


if __name__ == "__main__":
    main()
